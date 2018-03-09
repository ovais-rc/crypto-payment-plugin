/**
 * 
 */
CKEDITOR.plugins.add( 'ibmpastemedialink', {
	icons: 'ibmpastemedialink',
    requires: 'embed',
    init: function( editor ) {
        // TODO plugin logic
    	
    	var allowed_domains = editor.config.ibmPasteMediaLink.allowed_domains;
    	var _WIDGET_REGEXP = /data-oembed-url/gi;
    	var regexStrForLinksAsYouType = "(^|\\s|>|&nbsp;*)" // the URL must be at the start of the string, or be preceded with a whitespace, or after a html tag.
			+ "(" // capture to $2
			+ "((https?|ftps?|news|mailto|notes):|www\\.|w3\\.)" // protocol, www or w3
			+ "([\\w/\\#~:.?+=%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]|(?:&|&amp;))+?" // one or more valid chars take little as possible
			+ ")"
			+ "(?=" // lookahead for the end of the url
			+ "[.:?\\),;!\\]'\"]*" // punct
			+ "(?:[^\\w/\\#~:.?+=&%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]"// invalid character
			+ "|&nbsp;" // non-breaking space entity
			+ "|$)" // or end of string
			+ ")";

    	var linkRegexp = new RegExp(regexStrForLinksAsYouType, 'gi');
    	
    	function isUrl(text) { 
   			if(CKEDITOR.env.webkit)
		 		text = text.replace(/\u200B/g, '');		//remove unicode space character added by webkit
			if(CKEDITOR.env.ie) {
				text = text.replace(/\u00A0/g, '');		//remove unicode space character added by IE
			}	
			
			linkRegexp.lastIndex = 0;
			return linkRegexp.exec(text);
   		}
    	
    	function _getWidgetNode(){
    		var widgetNode = editor.getSelection().getRanges()[0].getPreviousNode();
			while(widgetNode != null && ((widgetNode.getAttribute("class") && widgetNode.getAttribute("class").indexOf("cke_widget_wrapper cke_widget_block") == -1) || widgetNode.getAttribute("class") == null)){
				if(widgetNode.getPrevious() == null){
					widgetNode = widgetNode.getParent();
				}else{
					widgetNode = widgetNode.getPrevious();
				}	    								
			}
			return widgetNode;
    	}
    	
    	function _getLinkNode(widgetNode){
    		var linkNode = null;
			if(widgetNode != null){
				linkNode = widgetNode.getNext();
				while(linkNode != null && linkNode.getName() != 'a'){
					if(linkNode.getName() == 'p'){
						linkNode = linkNode.getChildren().getItem(0);
						while(linkNode.getNext() != null){
							//if the type is not a text element and it's a link
							if(linkNode.type != CKEDITOR.NODE_TEXT && linkNode.getName() == 'a')
								break;
							linkNode = linkNode.getNext();
						}
						if(linkNode.getName() == 'a'){
							break;
						}else{
							linkNode = linkNode.getParent().getNext();
						}
					}else{    
						linkNode = linkNode.getNext();
					}
				}
			}
			return linkNode;
    	}
    	
    	function pasteMediaLink(evt){
    		if(isUrl(evt.data.dataValue)){
    	//		var count = (evt.data.dataValue.match(/http/g) || []).length;
    	//		if(count == 2){
	    			var domain = evt.data.dataValue.replace('http://','').replace('https://','').replace('www.','').split(/[/?#]/)[0].split('"')[1];
	    			if(allowed_domains.indexOf(domain) != -1){
	    				var url = evt.data.dataValue.split('href="')[1].split('">')[0];
	    				var element = editor.document.createElement( 'div' );
	    				editor.insertElement( element );
	    				var widget = editor.widgets.initOn( element, 'embed' );
	    				widget.loadContent( url, {			 			
	    					noNotifications : true,
	    					callback : function() {
		    					//removing just the link that has been turned into a widget 
	    						//and only if the widget is actually present and loaded
	    						if(_WIDGET_REGEXP.test(editor.getData())){
	    							setTimeout(function(){
		    							var widgetNode = _getWidgetNode();
		    							var linkNode = _getLinkNode(widgetNode);	    							
		    							linkNode.remove();
	    							});
	    						}	    							
		    				}
				 		} );	    				  				
	    			}
    			//}
    		}
    	}
    	
		editor.on('paste', function(evt) {
			pasteMediaLink(evt);
		});
    }
});