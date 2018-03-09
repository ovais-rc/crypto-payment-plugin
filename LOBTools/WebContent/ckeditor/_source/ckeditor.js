/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

// Compressed version of core/ckeditor_base.js. See original for instructions.
/* jshint ignore:start */
/* jscs:disable */
window.CKEDITOR||(window.CKEDITOR=function(){var e=/(^|.*[\\\/])ckeditor\.js(?:\?.*|;.*)?$/i,b={timestamp:"",version:"4.4.8",revision:"20150826-1229",rnd:Math.floor(900*Math.random())+100,_:{pending:[],basePathSrcPattern:e},status:"unloaded",basePath:function(){var a=window.CKEDITOR_BASEPATH||"";if(!a)for(var b=document.getElementsByTagName("script"),c=0;c<b.length;c++){var f=b[c].src.match(e);if(f){a=f[1];break}}-1==a.indexOf(":/")&&"//"!=a.slice(0,2)&&(a=0===a.indexOf("/")?location.href.match(/^.*?:\/\/[^\/]*/)[0]+
a:location.href.match(/^[^\?]*\/(?:)/)[0]+a);if(!a)throw'The CKEditor installation path could not be automatically detected. Please set the global variable "CKEDITOR_BASEPATH" before creating editor instances.';return a}(),getUrl:function(a){-1==a.indexOf(":/")&&0!==a.indexOf("/")&&(a=this.basePath+a);this.timestamp&&"/"!=a.charAt(a.length-1)&&!/[&?]t=/.test(a)&&(a+=(0<=a.indexOf("?")?"&":"?")+"t="+this.timestamp);return a},domReady:function(){function a(){try{document.addEventListener?(document.removeEventListener("DOMContentLoaded",
a,!1),b()):document.attachEvent&&"complete"===document.readyState&&(document.detachEvent("onreadystatechange",a),b())}catch(f){}}function b(){for(var a;a=c.shift();)a()}var c=[];return function(b){c.push(b);"complete"===document.readyState&&setTimeout(a,1);if(1==c.length)if(document.addEventListener)document.addEventListener("DOMContentLoaded",a,!1),window.addEventListener("load",a,!1);else if(document.attachEvent){document.attachEvent("onreadystatechange",a);window.attachEvent("onload",a);b=!1;try{b=
!window.frameElement}catch(e){}if(document.documentElement.doScroll&&b){var d=function(){try{document.documentElement.doScroll("left")}catch(b){setTimeout(d,1);return}a()};d()}}}}()},d=window.CKEDITOR_GETURL;if(d){var g=b.getUrl;b.getUrl=function(a){return d.call(b,a)||g.call(b,a)}}return b}());
/* jscs:enable */
/* jshint ignore:end */

if ( CKEDITOR.loader )
	CKEDITOR.loader.load( 'ckeditor' );
else {
	// Set the script name to be loaded by the loader.
	CKEDITOR._autoLoad = 'ckeditor';

	// Include the loader script.
	if ( document.body && ( !document.readyState || document.readyState == 'complete' ) ) {
		var script = document.createElement( 'script' );
		script.type = 'text/javascript';
		script.src = CKEDITOR.getUrl( 'core/loader.js' );
		document.body.appendChild( script );
	} else {
		document.write( '<script type="text/javascript" src="' + CKEDITOR.getUrl( 'core/loader.js' ) + '"></script>' );
	}

}

/**
 * The skin to load for all created instances, it may be the name of the skin
 * folder inside the editor installation path, or the name and the path separated
 * by a comma.
 *
 * **Note:** This is a global configuration that applies to all instances.
 *
 *		CKEDITOR.skinName = 'moono';
 *
 *		CKEDITOR.skinName = 'myskin,/customstuff/myskin/';
 *
 * @cfg {String} [skinName='moono']
 * @member CKEDITOR
 */
CKEDITOR.skinName = 'moono';



if (CKEDITOR) {
	// Set up CKEDITOR.ibm namespace for all things IBM
	if (CKEDITOR.ibm === undefined) {
		CKEDITOR.ibm = {};
	}
	
	// Add api namespace to CKEDITOR.ibm
	CKEDITOR.ibm.api = {};
	
	// Wrap CKEDITOR.dom.range for cross window invocations in IE
	CKEDITOR.ibm.api.newDomRange = function (document) {
		return new CKEDITOR.dom.range(document);
	};
	
	//Wrap CKEDITOR.dom.element for cross window invocations in IE
	CKEDITOR.ibm.api.newDomElement = function (element) {
		return new CKEDITOR.dom.element(element);
	};
	
	//Wrap CKEDITOR.dom.walker for cross window invocations in IE
	CKEDITOR.ibm.api.newDomWalker = function (range) {
		return new CKEDITOR.dom.walker(range);
	};
	
	//Enabling the svg icons when needed
	//@param {boolean} contextMenu true if we're adding the css for context menu icons
	// false if we're adding the css for the toolbar icons
	function setIconCssFile(contextMenu){
		var ss = new CKEDITOR.dom.element("link");
		ss.setAttribute('type','text/css');
		ss.setAttribute('href',CKEDITOR.getUrl('skins/ibmdesign/icons/svg/icons.css'));
		ss.setAttribute('rel','stylesheet');
		ss.setAttribute('id','svg-icons-css');
		if(!contextMenu){
			CKEDITOR.document.getHead().append(ss);
		}else{
			var elements = CKEDITOR.document.getElementsByTag("iframe");
			if(elements.getItem(elements.count()-1).getFrameDocument().getById('svg-icons-css') == null)
				elements.getItem(elements.count()-1).getFrameDocument().getHead().append(ss);
		}
	}
	(function addSvgListeners(){
		if(CKEDITOR.on){
			CKEDITOR.on('instanceCreated',function (evt){
				evt.editor.on('langLoaded', function(evt){
					if( (CKEDITOR.document.getById('svg-icons-css') == null) && (evt.editor.config.ibmEnableSvgIcons) && !(CKEDITOR.env.ie && CKEDITOR.env.version < 9) && evt.editor.config.skin == "ibmdesign"){
						setIconCssFile(false);	
						for(icon in CKEDITOR.skin.icons){
							CKEDITOR.skin.icons[icon].path = CKEDITOR.getUrl('skins/ibmdesign/icons/svg/sprite.svg');
						}
						var spanElements = CKEDITOR.document.getElementsByTag('span');
						for(var i in spanElements.$){
							var span = spanElements.$[i];
							if(span && span.className && span.className.indexOf("cke_button_icon cke_button__") > -1 ){
								var button_icon_name = span.className.split("cke_button__")[1].split("_icon")[0];
								span.setAttribute('style','background-image:url('+CKEDITOR.getUrl('skins/ibmdesign/icons/svg/sprite.svg')+');background-position:0 0;background-size:auto;');
							}
						}
					}
				});		
			});
			//attaching a listener to the creation of the context menu
			CKEDITOR.on('instanceLoaded',function (evt){
				if ( evt.editor.contextMenu && (evt.editor.config.ibmEnableSvgIcons) && !(CKEDITOR.env.ie && CKEDITOR.env.version < 9) && evt.editor.config.skin == "ibmdesign") {
					evt.editor.contextMenu.addListener( function(start) {
						setTimeout(function(){setIconCssFile(true);},100);
					} );	
					evt.editor.on('menuShow',function(){
						setIconCssFile(true);
					});
				}
			});
		}else{
			setTimeout(addSvgListeners,10);
		}
	})();
}
