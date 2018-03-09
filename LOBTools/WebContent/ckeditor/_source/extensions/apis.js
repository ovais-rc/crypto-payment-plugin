/* Copyright IBM Corp. 2010-2014  All Rights Reserved.                    */

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
