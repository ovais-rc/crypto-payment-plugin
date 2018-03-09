/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

define([
	"dijit/_WidgetBase",
	"dojo/_base/declare",
	"dojo/_base/window",
	"dojo/_base/Deferred",
	"dojo/_base/lang",
	"dojo/_base/sniff",
	"dojo/_base/connect",
	"dojo/io/script"
], function(_WidgetBase, declare, dwindow, Deferred, lang, dsniff, connect, script){
	var obj = declare("ckeditor.widget.CKEditor", [_WidgetBase], {
		// summary:
		//		A CKEditor wrapper class for Dojo
		//
		// description:
		//		This widget is a wrapper widget to run CKEditor in Dojo framework.  
		//
		//		To initialise:
		//
		//		<textarea data-dojo-type="ckeditor.widget.CKEditor"
		//			data-dojo-props="ref: {value: ... (mvc binding to set value)} ">
		//		</textarea>
		//
		
		// _beingInitialized: Boolean
		//		True means CKEditor being initialized.
		_beingInitialized: false,
		
		// value: String|Object
		//		The value to be displayed by ckeditor.  If object, an object-to-string formatter has to be set. 
		value: "",
		
		// ckeditorConfig: config parameter for CKEditor
		ckeditorConfig: {},
		
		constructor: function(){
			this.onLoadDeferred = new Deferred();
		},
		
		// onLoadDeferred: [readonly] dojo.Deferred
		//		Deferred which is fired when the editor finishes loading.
		//		Call myEditor.onLoadDeferred.then(callback) it to be informed
		//		when the rich-text area initialization is finalized.
		onLoadDeferred: null,
		
		postCreate: function(){
			// summary:
			//		Loads the widgets content editor.
			// description:
			// 		This function will load the ckeditor into the UI.
			this.inherited(arguments);

			if (!window.CKEditor) {
				var scriptElement;
				var scriptElements = document.getElementsByTagName('script');
				for (var i = 0; i < scriptElements.length; i++) {
					var found = scriptElements[i].src.match( /(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/ );
					if (found) {
						scriptElement = scriptElements[i];
						break;
					}
				}
				if (!scriptElement) {
					var path = window.CKEDITOR_BASEPATH || dwindow.global.CKEDITOR_BASEPATH || '/ckeditor/';
					path += 'ckeditor.js';
					scriptElement = script.attach("ckeditor", path, dwindow.doc);
				}
				var loadEvent = dsniff("ie") ? "onreadystatechange" : "load";
				var readyRegExp = /complete|loaded/;
				var obj = this;
				var handle = connect.connect(scriptElement, loadEvent, function(evt){
					if(evt.type == "load" || readyRegExp.test(scriptElement.readyState)){
						connect.disconnect(handle);
						obj.set("loading", false);
						obj._createEditorElement();
					}
				});
				if ((dwindow.doc.parentWindow || dwindow.doc.defaultView).CKEDITOR) {
					this._createEditorElement();
				}else{
					this.set("loading", true);
				}
			}
			else {
				this._createEditorElement();
			}
		},
		destroy: function(){
			if (this._ckeditor) {
				// By default, CKEditor tries to bring the content back to original <textarea>.
				// Given we are just releasing CKEditor from memory here, such content handling is not necessary - Setting true to the 1st arg skils such content handling.
				// https://nsjazz.raleigh.ibm.com:8010/jazz/resource/itemName/com.ibm.team.workitem.WorkItem/19583
				this._ckeditor.destroy(true);
				delete this._ckeditor;
			}

			this.inherited(arguments);
		},
		addStyleSheet: function(/*dojo._Url*/ uri){
			// summary:
			//		add an external stylesheet for the editing area
			// uri:
			//		A dojo.uri.Uri pointing to the url of the external css file
			if (!window.CKEDITOR) return;
			if (!CKEDITOR.document) return;
			var url = uri.toString();
			if(url.charAt(0) === '.' || (url.charAt(0) !== '/' && !uri.host)){
				url = (new _Url(win.global.location, url)).toString();
			}
			CKEDITOR.document.appendStyleSheet(url);
		},
		focus: function(){
			// summary:
			//		Move focus to this editor
			if (this._ckeditor) {
				if(this._beingInitialized){
					this._ckeditor.config.startupFocus = true;
				}else{
					this._ckeditor.focus();
				}
			}
		},
		onChange: function(){
			// summary:
			//		Fired if and only if the editor loses focus and the content is changed.
		},
		_timeout: function(){
			this._createEditorElement();
		},
		_createEditorElement: function() {
			if (this._beingInitialized || this._beingDestroyed) return;

			if (!this.nRetry) this.nRetry = 0;
			if ((dwindow.doc.parentWindow || dwindow.doc.defaultView).CKEDITOR) {
				CKEDITOR = (dwindow.doc.parentWindow || dwindow.doc.defaultView).CKEDITOR;
			}
			if (CKEDITOR.document && window.CKEDITOR) {
				CKEDITOR.document = new CKEDITOR.dom.document(dwindow.doc);
			}
			if (CKEDITOR.status == 'unloaded' || CKEDITOR.status == 'basic_loaded' || (CKEDITOR.document && !CKEDITOR.document.getById(this.id))) {
				if (this.nRetry < 600) {
					this.nRetry++;
					
					setTimeout(lang.hitch(this, '_timeout'), 100);
					return;
				}
			}
			else {
				if (this._destroyed) return;
				this._ckeditor = CKEDITOR.replace(this.domNode, this.get("ckeditorConfig"));
				this._beingInitialized = true;
				this.set("loading", true);
				this._ckeditor.on('instanceReady', lang.hitch(this, this._onLoad));
				this._ckeditor.on('blur', lang.hitch(this, this._onBlur));
				this.onLoadDeferred.callback(true);
			}
		},
		_getCkeditorConfigAttr: function() {
			// summary:
			//		Returns the cofig value in CKEditor
			return this.ckeditorConfig;
		},
		_onLoad: function(e){
			// summary:
			//		This function is called when the ckeditor finishes loading.  
			// description:
			// 		When the ckeditor finishes loading it will check whether to set the focus of the editor.
			if(this._ckeditor) {
				if (this._ckeditor.config.startupFocus){
					this._ckeditor.focus();
				}

				// workaround for https://dev.ckeditor.com/ticket/8548
				var range = new CKEDITOR.dom.range(this._ckeditor.document);
				range.selectNodeContents(this._ckeditor.document.getBody());
				range.collapse(true);
				var selection = this._ckeditor.getSelection();
				if (selection && selection.getNative() && !!selection.getNative().rangeCount)
					selection.selectRanges([range]);
			}
		},
		_onBlur: function(evt){
			// summary:
			//		Triggers the binding when the blur event occurs on the widget.
			// description:
			// 		If the blur event is triggered, the value binding gets updated.
			this._set("value", this.get("value"));
		},
		_setValueAttr: function(value) {
			// summary:
			//		Sets the value of the widget
			// description:
			// 		If ckeditor is enabled it will set the ckeditor content.
			this._set("value", value); 
			if (this._ckeditor) 
				this._ckeditor.setData(value);
		},
		_getValueAttr: function() {
			// summary:
			//		Returns the value of the widget
			// description:
			// 		If ckeditor is enabled it will return the ckeditor content. 

			var value = "";
			if(this._ckeditor)
				value = this._ckeditor.getData();
			else
				value = this.value;
			return value;
		}
	});
	return obj;
});
