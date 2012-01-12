  {if $moduleDebug && count($moduleDebugStrings)}
  {*  <p class="legend nonfocal">
      {foreach $moduleDebugStrings as $string}
        <br/>{$string}
      {/foreach}
    </p>  *}
  {/if} 
  
 {capture name="footerHTML" assign="footerHTML"}
{*     {if $strings.COPYRIGHT_LINK}
      <a href="{$strings.COPYRIGHT_LINK}" class="copyright">
    {/if}
        {$strings.COPYRIGHT_NOTICE}
    {if $strings.COPYRIGHT_LINK}
      </a>
    {/if}
   <br />
   {block name="footerKurogo"}{$footerKurogo}{/block} *}
  {/capture}

  
  {block name="footerNavLinks"}
    {if !$hideFooterLinks}
     {* <div id="footerlinks">
           <a href="#top">{$footerBackToTop}</a> | <a href="{$homeLink}">{$homeLinkText}</a> 
      </div> *}
    {/if}
  {/block}

  {block name="loginHTML"}
   {* {if $showLogin}
	<div class="loginstatus">
		<ul class="nav secondary loginbuttons">
		<li{if $footerLoginClass} class="{$footerLoginClass}"{/if}><a href="{$footerLoginLink}">{$footerLoginText}</a></li>
		</ul>
	</div>
	{/if} *}
  {/block}

  {block name="footer"}
  
  {if $moduleID != 'home'}
  	<div id="persistent-nav">
  		<ul>
  			<li><a href="#">Mobile Home</a></li>
  			<li><a href="/people">Directory</a></li>
   			<li><a href="/calendar">Events</a></li>
  			<li><a href="/news">News</a></li>
				<li><a href="/athletics">Athletics</a></li>
  			<li><a href="/programs">Programs</a></li>
  			<li><a href="/map">Maps</a></li>
  			<li><a href="/emergency">Emergency</a></li>
  		</ul>
  	</div><!-- #persistent-nav -->

  {/if}
  
    <div id="footer">
        {$footerHTML}
    	<p id="f-navblock"><span class="color"><a href="http://humboldt.edu">&laquo; Full Site</a></span> | Facebook | Flickr | Tumblr</p>
    	<p id="f-contact-info"><span class="color large"><a href="http://humboldt.edu">Humboldt State University</a></span><br />1 Harpst Street<br />Arcata, CA 95521<br />707-826-3011</p>
    </div>
  {/block}

  {block name="deviceDetection"}
  {*  {if $moduleID == 'home' && $showDeviceDetection}
      <table class="devicedetection">
        <tr><th>Pagetype:</th><td>{$pagetype}</td></tr>
        <tr><th>Platform:</th><td>{$platform}</td></tr>
        <tr><th>Certificates:</th><td>{if $supportsCerts}yes{else}no{/if}</td></tr>
        <tr><th>User Agent:</th><td>{$smarty.server.HTTP_USER_AGENT}</td></tr>
      </table>
    {/if} *}
  {/block}
  

  {block name="footerJavascript"}
    {foreach $inlineJavascriptFooterBlocks as $script}
      <script type="text/javascript">
        {$script} 
      </script>
    {/foreach}
    
    {if strlen($GOOGLE_ANALYTICS_ID)}
      <script type="text/javascript">
        (function() {ldelim}
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        {rdelim})();
      </script>
    {/if}
    {if strlen($PERCENT_MOBILE_ID)}
        <script>
           <!--
            percent_mobile_track('{$PERCENT_MOBILE_ID}', '{$pageTitle}');
            -->
        </script>
    {/if}
  {/block}
{block name="containerEnd"}
</div>
</div> <!--nonfooternav -->
{/block}

{block name="belowContent"}
{/block}
</body>
</html>