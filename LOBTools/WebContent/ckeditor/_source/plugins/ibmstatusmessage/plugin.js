/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
/**
 * @class ibmstatusmessage displays messages in the bottom of the editor. Editor instance events are used to
 * display and remove the messages.
 */
CKEDITOR.plugins.add('ibmstatusmessage', {
	lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
	init : function(editor)	{
	
		// Check if the language file has the object that contains the status messages.
		if (!editor.lang.ibmstatusmessage) {
			return;
		}
		
		// Check if the plugins configuration object has been set.
		var messages = CKEDITOR.config.status_messages;
		if (!messages || messages.length === 0) {
			return;
		}

		var statusDiv,
			statusId = 'cke_status_' + editor.name;
			
		// Gets a reference to the div that contains the message text.
		var	getStatusDiv = function() {
		
				if (!statusDiv) {
					statusDiv = CKEDITOR.document.getById(statusId);					
				}
				return statusDiv;
			};
		
		// An event listener that displays the message. Can be used with any CKEditor event.
		var displayMessage = function(event) {
				
				var msgData = event.listenerData;
				if (msgData && !(msgData.display && !msgData.display(event.data))) {
					var msgDiv = getStatusDiv();
					if (msgDiv) 	//the div will not be present if there is no bottom uispace present e.g. inline mode
						msgDiv.setHtml(msgData.html);
				}
			};
			
		// An event listener that clears the message. Can be used with any CKEditor event.
		var clearMessage = function(event) {
				var div = getStatusDiv();
				if (div && div.getHtml() === event.listenerData.html) {
					div.setHtml('');
				}
			};
		
		/**
		 * Registers the displayMessage listener function with the supplied events.
		 * displayEvents the array or object containing the names of event when the message is to be displayed.
		 * langStr the ibm.status language string to be displayed.
		 */
		var registerDisplayMessage = function(displayEvents, langStr) {
				var html = editor.lang.ibmstatusmessage[langStr];
					
				// Array of event names
				if (CKEDITOR.tools.isArray(displayEvents)) {
				
					/* Register the displayMessage listener function on the event and pass in the 
					   message html as custom event data. */
					for (var i = displayEvents.length; i--; ) {
						editor.on(displayEvents[i], displayMessage, null, { html : html });
					}
					
				/* Object containing properties named after events which reference a function used
					to determine if the message is displayed. */
				} else {
					var data;
					for (var eventName in displayEvents) {
						data = { html : html };
						if (typeof displayEvents[eventName] === 'function') {
							data.display =  displayEvents[eventName];
						}
						editor.on(eventName, displayMessage, null, data);
					}					
				}
			};
			
		var registerClearMessage = function(hideEvents, langStr) {
				var html = editor.lang.ibmstatusmessage[langStr];
				for (var i = hideEvents.length; i--; ) {
					editor.on(msg.hide[i], clearMessage, null, { html : html });
				}				
			}
			
		/* Register the above display/clearMessage event listener functions with the
		   events specified to display and hide the message. */
		for (var i = messages.length; i--; ) {
			var msg = messages[i];
			var html = editor.lang.ibmstatusmessage[msg.langStr];
			
			if (msg.display) {
				registerDisplayMessage(msg.display, msg.langStr)
			}
			
			if (msg.hide) {
				registerClearMessage(msg.hide, msg.langStr);
			}
		}
		
		// Add the message text container to the bottom part of the editor.
		editor.on('uiSpace', function(event) {
			var data = event.data;
			var messageDiv = '<div id="' + statusId + '" class="cke_status_message"></div>';
			
			if (data.space === 'top' && editor.elementMode == CKEDITOR.ELEMENT_MODE_INLINE) {	//inline edit mode
				//clear: both property needs to be added to cke_status_container class in order to properly display status message when editor is in inline mode for IE and Opera
				var divClass = CKEDITOR.env.ie || CKEDITOR.env.opera ? 'cke_status_container_inline' : 'cke_status_container';
				data.html +='<br/>'+'<br/>'+'<div class="cke_reset_all '+divClass+'">' + messageDiv + '</div>';
			} else if (data.space === 'bottom') {

				/* The resize handle must remain in the corner. If it is present move it into the
				   status container so its position can be managed. */
				data.html = data.html.replace(/(.*)(<div class="cke_resizer".*?<\/div>)?(?=.*)/,
											 '$1<div class="cke_status_container">' + messageDiv + '$2</div>');
			}
		}, editor, null, 150 );
	}
} );

// The array of status message object that are displayed in the bottom of the editor.
CKEDITOR.config.status_messages = [
	{
		langStr: 'keystrokeForHelp',			// The editor.lang.ibm.status.X language string that is displayed. 
		display: ['instanceReady', 'focus'],	// The events on which to display the message.		
		hide: ['blur']							// The events on which to hide the message
	} /* Example of using functions to determine if message is display based on the event data.,
	{
		langStr: 'keystrokeForToolbarEsc',
		display:								// The events and boolean functions use to determine if the message should be shown
		{			
			afterCommandExec: function(eventData)
				{
					return (eventData.name === 'toolbarFocus');
				}
		},
		hide: ['focus']
	} */
]; 