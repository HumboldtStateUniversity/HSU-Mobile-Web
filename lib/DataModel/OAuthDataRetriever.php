<?php

class OAuthDataRetriever extends URLDataRetriever
{
    protected $oauthVersion='1.0';
    protected $token;
    protected $tokenSecret;
    protected $consumerKey;
    protected $consumerSecret;
    protected $signatureMethod = 'HMAC-SHA1';
    protected $requiresToken = false;
    protected $cert;
    
	protected function buildQuery(array $parameters) {

		if(empty($parameters)) return '';

		// encode the keys
		$keys = self::urlencode(array_keys($parameters));

		// encode the values
		$values = self::urlencode(array_values($parameters));

		// combine the key/value array
		$parameters = array_combine($keys, $values);

		// sort parameters as required by oauth
		uksort($parameters, 'strcmp');

		$params = array();
		foreach($parameters as $key => $value) {
			// sort by value
			if (is_array($value)) {
			    $value = natsort($value);
			}
		    $params[] = $key .'='. str_replace('%25', '%', $value);
		}
		
		// return
		return implode('&', $params);
	}

	protected function calculateHeader($url, $parameters) {

		// init var
		$params = array();

		// encode each parameter
		foreach($parameters as $key => $value) {
		    $params[] = self::urlencode($key) .'="'. self::urlencode($value) .'"';
		}

		// build return
		$return = 'OAuth ' . implode(',', $params);

		return $return;
	}

    /* Builds the base string according to 3.4.1 of RFC 5849 */
	protected function calculateBaseString($method, $url, $parameters) {

		$parameters = is_array($parameters) ? $parameters : array();

		// init var
		$pairs = array();
		$params = array();

		// sort parameters by key
		uksort($parameters, 'strcmp');

		foreach($parameters as $key => $value) {
			// sort by value
			if(is_array($value)) { 
			    $value = natsort($value);
            }

			$params[] = self::urlencode($key) .'='. self::urlencode($value);
		}
		
		// builds base
		$parts = array(
		    strtoupper($method),
		    $url,
		    implode('&', $params)
        );
        
        $parts = self::urlencode($parts);
        $base = implode('&', $parts);
        return $base;
	}

    /* Encodes urls. This attempts to conform to 3.6 of RFC 5849 
       If there is a problem with an OAuth provider, likely it's going to be here 
    */
	protected static function urlencode($value) {
		if (is_array($value)) {
		    return array_map(array(__CLASS__, 'urlencode'), $value);
		}

        return str_replace('+',' ', str_replace('%7E', '~', rawurlencode($value)));
	}

    /* sign the request according to 3.1 of RFC 5849 */
	protected function oauthSignature($method, $url, $parameters) {
		// calculate the base string
		$baseString = $this->calculateBaseString($method, $url, $parameters);
		$key = self::urlencode($this->consumerSecret) .'&' . self::urlencode($this->tokenSecret);
		
		switch ($this->signatureMethod)
		{
		    case 'PLAINTEXT':
		        $sig = $key;
		        break;
		    case 'HMAC-SHA1':
        		$sig = base64_encode(hash_hmac('SHA1', $baseString, $key, true));
        		break;
        	case 'RSA-SHA1':

                if (!$privatekeyid = openssl_get_privatekey($this->cert)) {
                    throw new KurogoException("Error getting private key for $this->cert");
                }

                // Sign using the key
                $ok = openssl_sign($this->base_string, $signature, $privatekeyid);

                // Release the key resource
                openssl_free_key($privatekeyid);

                $sig = base64_encode($signature);
        	    break;
        	default:
        	    throw new KurogoException("Signature method $this->signatureMethod not handled");
		}
		
		return $sig;
	}

	protected function parseQueryString($queryString) {
	    $return = array();
	    $vars = explode('&', $queryString);
	    foreach ($vars as $value) {
	        $bits = explode("=", $value);
	        $return[$bits[0]] = urldecode($bits[1]);
	    }
	    return $return;
	}
	
    protected function getAuthorizationHeader() {
		$params = $this->parameters();
		$options = array();

        /* strip out query string and add it to parameters */
        $url = $this->url();
        $urlParts = parse_url($url);
        if (isset($urlParts['query'])) {
            $params = array_merge($params, $this->parseQueryString($urlParts['query']));
        }

        $fragment = isset($urlParts['fragment']) ? '#' . $urlParts['fragment'] : '';
        
        if (!$this->consumerKey) {
            throw new KurogoException("Consumer Key not set");
        }

		// append default parameters
		$oauth['oauth_consumer_key'] = $this->consumerKey;
		$oauth['oauth_nonce'] = md5(microtime() . rand());
		$oauth['oauth_signature_method'] = $this->signatureMethod;
		$oauth['oauth_timestamp'] = time();
		$oauth['oauth_version'] = $this->oauthVersion;
		
		if ($this->token) {
		    $oauth['oauth_token'] = $this->token;
		}

	    foreach ($params as $param=>$value) {
	        if (preg_match("/^oauth_/", $param)) {
	            $oauth[$param] = $value;
	            unset($params[$param]);
	        }
	    }
		
		$method = $this->method();
        switch ($method) {
            case 'POST':
                $params = array_merge($params, $oauth);
                $url = $this->canonicalURL($url);
        		$params['oauth_signature'] = $this->oauthSignature($method, $url, $params);
                $authHeader =  $this->calculateHeader($url, $params);
                break;
                
            case 'GET':
                $data = $oauth;
                $base_url = $url = $this->canonicalURL($url);
                if(count($params)>0) {
                    $data = array_merge($data, $params);
                    $url .= '?'. $this->buildQuery($params);
                }

        		$oauth['oauth_signature'] = $this->oauthSignature($method, $base_url, $data);
                $authHeader = $this->calculateHeader($url, $oauth);
                break;
            default:
                throw new KurogoException("Invalid method $method");
                break;
        }        
        
        return $authHeader;
    }
    
    protected function streamContextOpts($args) {
        $streamContextOpts = parent::streamContextOpts($args);
        $streamContextOpts['http']['follow_location'] = false;
        $streamContextOpts['http']['max_redirects'] = 0;

        return $streamContextOpts;
    }
    
    public function cacheFolder($baseCacheFolder) {
        return $baseCacheFolder . DIRECTORY_SEPARATOR . md5($this->token);
    }
    
    protected function headers() {
        $headers = parent::headers();
        
        //if the first parameter is true then exclude the authorization headers
        $args = func_get_args();
        if (isset($args[0]) && $args[0]) {
            return $headers;
        }
                
        switch ($this->method()) {
            case 'GET':
                break;
            case 'POST':
                $headers['Content-type'] = 'application/x-www-form-urlencoded';
                break;
        }
        
	    $headers['Authorization'] = $this->getAuthorizationHeader();
	    $headers['Expect'] = '';
        return $headers;        
    }
    
    public function retrieveData() {
    
        if ($this->requiresToken && !$this->token) {
            $response = $this->initResponse();
            return $response;
        }

        $headers = $this->headers(true);
        $response = parent::retrieveData();
        
        //if there is a location header we need to re-sign before redirecting
        if ($redirectURL = $response->getHeader("Location")) {
            Kurogo::log(LOG_WARNING, "Found Location Header", 'oauth');
		    $redirectParts = parse_url($redirectURL);
		    //if the redirect does not include the host or scheme, use the scheme/host from the original URL
            if (!isset($redirectParts['scheme']) || !isset($redirectParts['host'])) {
                $urlParts = parse_url($url);
                unset($urlParts['path']);
                unset($urlParts['query']);
                $redirectURL = $this->buildURL($urlParts) . $redirectURL;
            }

		    $this->setBaseURL($this->canonicalURL($redirectURL));
            $parameters = $this->parameters();
            if (isset($redirectParts['query'])) {
		        $parameters = array_merge($parameters, $this->parseQueryString($redirectParts['query']));
		    }
		    $this->setParameters($parameters);

		    //reset headers
		    $this->setHeaders($headers);
            Kurogo::log(LOG_DEBUG, "Redirecting to $this->baseURL", 'oauth');
            $response =  $this->retrieveData();
        }
        
        return $response;
    }
    
    public function setToken($token) {
        $this->token = $token;
    }
    
    public function setTokenSecret($tokenSecret) {
        $this->tokenSecret = $tokenSecret;
    }
    
    protected function setAuthority(AuthenticationAuthority $authority) {
        if ($authority instanceOf OAuthAuthentication) {
            $oauth = $authority->oauth();
            $this->consumerKey = $oauth->getConsumerKey();
            $this->consumerSecret = $oauth->getConsumerSecret();
            $this->token = $oauth->getToken();
            $this->tokenSecret = $oauth->getTokenSecret();
            $this->signatureMethod = $oauth->getSignatureMethod();
            $this->cert = $oauth->getCert();
        } 
        parent::setAuthority($authority); 
    } 
    
    protected function init($args) {
        parent::init($args);
        
        if (isset($args['consumerKey'])) {
            $this->consumerKey = $args['consumerKey'];
        }

        if (isset($args['consumerSecret'])) {
            $this->consumerSecret = $args['consumerSecret'];
        }        

        if (isset($args['token'])) {
            $this->token = $args['token'];
        }        

        if (isset($args['tokenSecret'])) {
            $this->tokenSecret = $args['tokenSecret'];
        }        

        if (isset($args['cert'])) {
            $this->cert = $args['cert'];
        }        

        if (isset($args['signatureMethod'])) {
            $this->signatureMethod = $args['signatureMethod'];
        }        
        
    }
    
}