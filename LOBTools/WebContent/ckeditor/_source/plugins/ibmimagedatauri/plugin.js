/* Copyright IBM Corp. 2010-2014 All Rights Reserved. */

CKEDITOR.plugins.add('ibmimagedatauri', {
	lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
	init : function(editor)	{
	
		var imgRexExp = /<img[^>]*>/i;

		if (editor.config.ibmFilterPastedDataUriImage){
		
			// Add a paste event listener to remove data uri images from pasted content
			editor.on('paste', function(evt) {
				
				var isDataURIImageRegex = /<img.*src=["']data:image\/[^>]*>/gi,
					_html = evt.data.dataValue;

				if (isDataURIImageRegex.test(_html)){
					
					var dataUriImages = _html.match(isDataURIImageRegex);
					
					for (var i=0; i<dataUriImages.length; i++){
						_html = _html.replace(dataUriImages[i], '');
					}
					alert(editor.lang.ibmimagedatauri.error);
					evt.data.dataValue = _html;					
				}
			});
			
			// Add a contentDom event listener to register a drop event each time the document is recreated
			editor.on('contentDom', function(evt) {
				
				// Add a drop event listener to cancel the drop event if the content contains data uri images
				editor.document.on('drop', function (evt) {
				
					if (evt.data.$.dataTransfer.files.length > 0 ){
						alert(editor.lang.ibmimagedatauri.error);
						evt.data.$.preventDefault();
					}
					else{
						var type = CKEDITOR.env.ie ? 'url' : 'text/html';
						var _html = CKEDITOR.env.ie ? "<img src=\""+evt.data.$.dataTransfer.getData(type) +"\">" : evt.data.$.dataTransfer.getData(type);
						if(CKEDITOR.env.mac){
							//image dragged from the web page
							if(/\S/.test(evt.data.$.dataTransfer.getData('url')))
								_html = "<img src=\""+evt.data.$.dataTransfer.getData('url') +"\">";
						}
						
						var isDataURIImageRegex = /<img.*src=["']data:image\/[^>]*>/gi;
						if (isDataURIImageRegex.test(_html)){
							alert(editor.lang.ibmimagedatauri.error);
							evt.data.$.preventDefault();
						}
					}
					
				});
			}); 
		}
	}
});
