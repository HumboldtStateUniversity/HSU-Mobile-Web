var containerScroller = null;
var navScroller = null;

function onDOMChange() {
  if (containerScroller) {
    setContainerWrapperHeight();
    containerScroller.refresh();
  }
}

// Update the nav slide indicators
function updateNavSlider() {
  var current = Math.abs(navScroller.x);
  var max = Math.abs(navScroller.maxScrollX);

  var canScrollLeft = (current > 0);
  var canScrollRight = (current < max-1);
  
  document.getElementById('slideleft').style.display  = canScrollLeft  ? 'block' : 'none';
  document.getElementById('slideright').style.display = canScrollRight ? 'block' : 'none';
}

// Change wrapper height based on device orientation.
function setContainerWrapperHeight() {
  document.getElementById('container').style.height = 'auto';

	var navbarHeight = document.getElementById('navbar').offsetHeight;
  var footerNavHeight = document.getElementById('footernav').offsetHeight;
	var wrapperHeight = window.innerHeight - navbarHeight - footerNavHeight;
	var containerHeight = document.getElementById('container').offsetHeight;
	
	document.getElementById('wrapper').style.height = wrapperHeight + 'px';
	
	if (containerHeight < wrapperHeight) {
	  document.getElementById('container').style.height = wrapperHeight + 'px';
	}
	
	// when this exists, make it fill the screen
	var fillscreen = document.getElementById('fillscreen');
	if (fillscreen) {
	  fillscreen.style.height = wrapperHeight + 'px';
	}
}

function handleWindowResize(e) {
    if (!('orientation' in window)) {
        rotateScreen();
    }
    setContainerWrapperHeight();
  
  setTimeout(updateNavSlider, 0);
  
  if (typeof moduleHandleWindowResize != 'undefined') {
    moduleHandleWindowResize(e);
  }
} 

function tabletInit() {
    if(!document.getElementById('navbar')) {
        // page has no footer so do not attempt
        // to use fancy tablet container
        return;
    }

  setContainerWrapperHeight();
  
  // Adjust wrapper height on orientation change or resize
  var resizeEvent = 'onorientationchange' in window ? 'orientationchange' : 'resize';
  window.addEventListener(resizeEvent, handleWindowResize, false);

  document.addEventListener('touchmove', function(e) { e.preventDefault(); });
  
  containerScroller = new iScroll('wrapper', { 
    checkDOMChanges: false, 
    hScrollbar: false,
    desktopCompatibility: true,
    bounce: false,
    bounceLock: true
  });


  navScroller = new iScroll('navsliderwrapper', { 
    checkDOMChanges: false, 
    hScrollbar: false,
    vScrollbar: false,
    desktopCompatibility: true,
    bounce: false,
    bounceLock: true,
    onScrollStart: updateNavSlider,
    onScrollEnd: updateNavSlider
  });

    handleWindowResize();
    updateNavSlider();

  //run module init if present
  if (typeof moduleInit != 'undefined') {
    moduleInit();
  }
}

function scrollToTop() {
  if (containerScroller) {
  	containerScroller.scrollTo(0,0,0); 
  }
}

(function(window) {

    function splitView (options) {
      // set caller options
        if (typeof options == 'object') {
            for (var i in options) {
                this.options[i] = options[i];
            }
        }
      
        if (window.addEventListener) {
          window.addEventListener(RESIZE_EVENT, this, false);
        } else if (window.attachEvent) {
          window.attachEvent(RESIZE_EVENT, this);
        }
        
        if (!document.getElementById(this.options.list) || !document.getElementById(this.options.detail)) {
            return;
        }

        this.list = document.getElementById(this.options.list);
        this.listScroller = new iScroll(this.options.list);
        this.detail = document.getElementById(this.options.detail);
        this.detailScroller = new iScroll(this.options.detail, {checkDOMChange: true});
        
        if ('content' in this.options) {
            this.content = document.getElementById(this.options.content);
        } else {
            this.options.content = this.options.detail;
            this.content = this.detail;
        }
        
        var self = this;
        
        var links = this.list.getElementsByTagName('a');
            var first = true;
            for (var i=0;i<links.length;i++) {
                if (!links[i].parentNode.className.match(/pagerlink/)) {
                    links[i].onclick = function(e) {
                        var selected = self.list.getElementsByTagName('a');
                        for (var j=0;j<selected.length;j++) {
                            removeClass(selected[j],'listSelected');
                        }                    
                        addClass(this,'listSelected');
                        self.detailScroller.scrollTo(0,0);
                        var httpRequest = new XMLHttpRequest();
                        httpRequest.open("GET", this.href+'&ajax=1', true);
                        httpRequest.onreadystatechange = function() {
                            if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                                self.content.innerHTML = httpRequest.responseText;
                                self.detailScroller.refresh();
                                moduleHandleWindowResize();
                            }
                        }
                        showLoadingMsg(self.options.content);
                        httpRequest.send(null);
                        if (e) {
                            e.preventDefault();
                        }
                    }
                    if (first) {
                        links[i].onclick();
                        first = false;
                    }
                }
            }
    }

    splitView.prototype = {
        options: {},
        listScroller: null,
        detailScroller: null,
        handleEvent: function (e) {
            switch (e.type) {
                case 'orientationchange':
                case 'resize':
                    break;
            }
        }
    }

    var RESIZE_EVENT = window.addEventListener ? 
    ('onorientationchange' in window ? 
    'orientationchange' :  // touch device
    'resize')              // desktop browser
    : ('onresize');          // IE
    
    window.splitView = splitView;

})(window)
