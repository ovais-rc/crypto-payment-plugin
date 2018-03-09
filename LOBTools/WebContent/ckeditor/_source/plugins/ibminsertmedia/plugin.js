/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
( function() {
	
	
	CKEDITOR.plugins.add('ibminsertmedia',
	{
		init : function(editor) {
			
			editor.widgets.on( 'instanceCreated', function( evt ) {
			    var widget = evt.data;

			    /**
			     * Override original sendRequest event
			     */
			    widget.on( 'sendRequest', function( evt ) {
					var request = evt.data;
					
					Ajax.sendRequest(
							this.providerUrl,
							{
								url: encodeURIComponent( request.url )
							},
							request.callback,
							function( err, response ) {
								if ( err ) {
									request.errorCallback( err );
								} else {
									request.callback( response );
								}
							}
						);
						evt.stop();
				});
			    
			    /**
			     * Override original handleResponse event
			     */
			    widget.on( 'handleResponse', function( evt ) {
					if(evt.data.html){
						evt.stop();						
						return;
					}
					var retHtml = getEmbeddableHTML( evt.data.url, evt.data.response );
					if ( retHtml !== null ) {
						evt.data.html = retHtml;
						evt.stop();
					}
					else{
						evt.data.errorMessage = 'unsupportedUrl';
						evt.cancel();
					}
				});
			    
			} );
			
		}
	});
	
	function getEmbeddableHTML(url, response) {
		if ( response.type == 'photo' || response.type == 'image' ) {
			return '<img src="' + CKEDITOR.tools.htmlEncodeAttr( response.url ) + '" ' +
				'alt="' + CKEDITOR.tools.htmlEncodeAttr( response.title || '' ) + '" style="max-width:100%;height:auto" />';
		} else if ( response.type == 'video' || response.type == 'rich' || response.type == 'link') {
			return response.html;
		}

		return null;
	}
	
	var Ajax = {
			/**
			 * Sends request using AJAX.
			 *
			 * @param {CKEDITOR.template} urlTemplate Template of the URL to be requested. All properties
			 * passed in `urlParams` can be used
			 * @param {Object} urlParams Params to be passed to the `urlTemplate`.
			 * @param {Function} errorCallback
			 */
			sendRequest: function( urlTemplate, urlParams, callback, errors) {
				urlParams = urlParams || {};
				var json = {};
				
				var urlToSend = urlTemplate.output( urlParams );
				
				var xhr = createCORSRequest('GET', urlToSend);
				if (!xhr) {
					return;
				}
				
				// Response handlers.
				xhr.onload = function() {
					try{
						json = JSON.parse(xhr.response);
						if (!json) {
							return;
						}
						if(!json.html){
							json = convertToHTML(json);
						}
						callback(json);
					}
					catch (e) {
						console.log('error:',e);//TODO: Set error msg for the callback function
					}
				};
				
				xhr.onerror = function() {
					console.log('error');//TODO: Set error msg for the callback function
				};
				xhr.send();
				
				function convertToHTML(response) {
					var divStyle = {style : 'left: 0px; width: 100%; height: 0px; position: relative; padding-bottom: 56.2493%;'};//TODO: GET width/height/alignment from the dialog
					var htmlDiv = new CKEDITOR.htmlParser.element( 'div' , divStyle);
					
					switch (response.type) {
						case 'video':
							if(response.video[0]['video:url'] && typeof response.video[0]['video:url'] != "undefined")
								attribute = response.video[0]['video:url'];
							else
								attribute = response.thumbnails[0];
							break;
						case 'link':
							if(response.raw['twitter:player'] && typeof response.raw['twitter:player'] != "undefined")
								attribute = response.raw['twitter:player'];
							else
								attribute = response.thumbnails[0];
							break;
						default:
							attribute = response.thumbnails[0];
							break;
					} 

					if(attribute && typeof attribute != "undefined"){
						var iframeAttributes = {
								src:attribute,
								style : 'width: 100%; height: 100%; position: absolute;'
						};
						var iframe = new CKEDITOR.htmlParser.element( 'iframe' , iframeAttributes);
						htmlDiv.add(iframe);
						var html = htmlDiv.getOuterHtml();
						response.html = html;
					}
					else 
						response.html = null;
					return response;
				}
				
				function createCORSRequest(method, url) {
					var xhr = new XMLHttpRequest();
					if ("withCredentials" in xhr) {// XHR for Chrome/Firefox/Opera/Safari.
						xhr.open(method, url, true);
					} 
					else if (typeof XDomainRequest != "undefined") {// XDomainRequest for IE.
						xhr = new XDomainRequest();
						xhr.open(method, url);
					} 
					else {
						xhr = null;// CORS not supported
					}
					return xhr;
				}
			}
		};
	
})()
