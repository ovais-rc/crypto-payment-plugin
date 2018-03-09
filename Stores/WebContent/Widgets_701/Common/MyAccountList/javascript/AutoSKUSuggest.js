//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


if(typeof(AutoSKUSuggestJS) == "undefined" || AutoSKUSuggestJS == null || !AutoSKUSuggestJS){

	AutoSKUSuggestJS = {

		/**
		 * This variable controls the timer handler before triggering the autoSuggest.  If the user types fast, intermittent requests will be cancelled.
		 * The value is initialized to -1.
		 */
		autoSuggestSKUTimer: -1,

		/**
		 * This variable controls the delay of the timer in milliseconds between the keystrokes before firing the search request.
		 * The value is initialized to 400.
		 */
		autoSuggestSKUKeystrokeDelay : 400,

		/**
		 * This variable indicates whether or not the user is hovering over the autoSuggest results popup display.
		 * The value is initialized to false.
		 */
		skuAutoSuggestHover : false,

		/**
		 * This variable stores the old search term used in the auto suggest search box
		 * The value is initialized to empty string.
		 */
		skuAutoSuggestPreviousTerm : "",	

		/**
		 * This variable stores the index of the selected auto suggestion item when using up/down arrow keys.
		 * The value is initialized to -1.
		 */
		autoSelectOption : -1,

		/**
		 * This variable stores the index offset of the first previous history term
		 * The value is initialized to -1.
		 */
		historyIndex : -1,

		/**
		 * This variable controls when to trigger the auto suggest box.  The number of characters greater than this threshold will trigger the auto suggest functionality.
		 * The static/cached auto suggest will be performed if this threshold is exceeded.
		 * The value is initialized to 0.
		 */
		AUTOSUGGEST_THRESHOLD : 0,

		/**
		 * This variable controls when to trigger the dynamic auto suggest.  The number of characters greater than this threshold will trigger the request for keyword search.
		 * The static/cached auto suggest will be be displayed if the characters exceed the above config parameter, but exceeding this threshold will additionally perform the dynamic search to add to the results in the static/cached results.
		 * This value should be greater or equal than the AUTOSUGGEST_THRESHOLD, as the dynamic autosuggest is secondary to the static/cached auto suggest.
		 * The value is initialized to 0.
		 */
		DYNAMIC_AUTOSUGGEST_THRESHOLD : 0,

		/**
		 * URL to retrieve auto suggest keywords
		*/
		SearchAutoSuggestServletURL:"",

		/**
		 * Timeout variable for suggestions dropdown list
		*/
		searchSuggestionHoverTimeout:"",
		
		/**
		 * Suffix for the SKU type ahead id
		*/
		suffix:"",
		
		/**
		 * SKU type ahead input field id
		*/
		inputField: "",
		
		/**
		 * SKU type ahead add button
		 */
		addButton: "",
		
		/**
		 * SKU type ahead add button text
		 */
		addButtonText: "",
		
		/**
		 * SKU type ahead add button CSS
		 */
		addButtonDisableCss: "",
		
		/**
		 * SKU type ahead add button text CSS
		 */
		addButtonTextDisableCss: "",
		
		init:function(inputField){		
			dojo.connect(document.getElementById(inputField), "onfocus", AutoSKUSuggestJS, AutoSKUSuggestJS._onFocus);
			dojo.connect(document.getElementById(inputField), "onblur", AutoSKUSuggestJS, AutoSKUSuggestJS._onBlur);
			dojo.connect(document.getElementById(inputField), "onkeyup", AutoSKUSuggestJS, AutoSKUSuggestJS._onKeyUp);			
		},
		
		setAddButton:function(addButton, addButtonText, addButtonDisableCss, addButtonTextDisableCss){
			this.addButton = addButton;
			this.addButtonText = addButtonText;
			this.addButtonDisableCss = addButtonDisableCss;
			this.addButtonTextDisableCss = addButtonTextDisableCss;
		},

		showSKUSearchComponent:function(){
			var srcElement = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
			if(srcElement != null) {
				srcElement.style.display= 'block';
			}
		  },

		setAutoSuggestURL:function(url){
			this.SearchAutoSuggestServletURL = getAbsoluteURL() + url;
		},

		_onFocus:function(evt){
			var target = evt.target || evt.srcElement;
			this.inputField = target.id;	
			this.suffix = "_" + target.id;
			var inputFieldElement = document.getElementById(this.inputField);
			if (inputFieldElement != null && !this.isEmpty(inputFieldElement.value)){
				this.showSKUSearchComponent();			
			}
		},

		_onBlur:function(evt){
			var target = evt.target || evt.srcElement;
			this.inputField = target.id;	
			this.suffix = "_" + target.id;
			clearTimeout(this.searchSuggestionHoverTimeout);
			this.searchSuggestionHoverTimeout = setTimeout("AutoSKUSuggestJS.showSKUAutoSuggest(false)",200);
		},

		_onKeyUp:function(evt){
			var target = evt.target || evt.srcElement;
			this.inputField = target.id;	
			this.suffix = "_" + target.id;
			var srcElement = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
			srcElement.style.display='block';
			this.doSKUAutoSuggest(evt, this.SearchAutoSuggestServletURL, document.getElementById(this.inputField).value);
		},

		doDynamicSKUAutoSuggest:function(url, searchTerm) {
			// if pending autosuggest triggered, cancel it.
			if(this.skuAutoSuggestSKUTimer != -1) {
				clearTimeout(this.skuAutoSuggestSKUTimer);
				this.skuAutoSuggestSKUTimer = -1;
			};

			// call the auto suggest
			this.skuAutoSuggestSKUTimer = setTimeout(function() {				
				wc.render.getRefreshControllerById("autoSuggestBySKU_Controller" + AutoSKUSuggestJS.suffix).url = url + "&term=" + encodeURIComponent(searchTerm) + "&suffix=" + encodeURIComponent(AutoSKUSuggestJS.suffix);
				console.debug("update autosuggest "+url);
				wc.render.updateContext("AutoSuggestSKU_Context", {});
				this.skuAutoSuggestSKUTimer = -1;
			}, this.skuAutoSuggestSKUKeystrokeDelay);
		},

		showSKUAutoSuggest:function(display) {
			var autoSuggest_Result_div = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
			if(autoSuggest_Result_div != null && autoSuggest_Result_div != 'undefined') {
				if(display) {
					autoSuggest_Result_div.style.display = "block";
				}
				else {
					autoSuggest_Result_div.style.display = "none";
				}
			}
		},

		showSKUAutoSuggestIfResults:function() {
			// if no results, hide the autosuggest box
			var scrElement = document.getElementById("skuAddSearch" + this.suffix);
			var domClass = require("dojo/dom-class");
			if(scrElement == null)
			{				
				if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null 
					&& !domClass.contains(document.getElementById(this.addButton), "formButtonDisabled") && !domClass.contains(document.getElementById(this.addButtonText), "formButtonGreyOut")){					
					domClass.add(document.getElementById(this.addButton), "formButtonDisabled");
					domClass.add(document.getElementById(this.addButtonText), "formButtonGreyOut");
				}
			}else{
				if (document.getElementById("enableAddButton" + this.suffix) != null && document.getElementById("enableAddButton" + this.suffix).value == "false"){					
					if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null 
						&& !domClass.contains(document.getElementById(this.addButton), "formButtonDisabled") && !domClass.contains(document.getElementById(this.addButtonText), "formButtonGreyOut")){					
						domClass.add(document.getElementById(this.addButton), "formButtonDisabled");
						domClass.add(document.getElementById(this.addButtonText), "formButtonGreyOut");
					}
				} else if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null 
					&& domClass.contains(document.getElementById(this.addButton), "formButtonDisabled") && domClass.contains(document.getElementById(this.addButtonText), "formButtonGreyOut")){					
					domClass.remove(document.getElementById(this.addButton), "formButtonDisabled");
					domClass.remove(document.getElementById(this.addButtonText), "formButtonGreyOut");
				}
			}
			if(scrElement != null && scrElement.style.display == 'block')
			{
				if(document.getElementById(this.inputField).value.length <= this.AUTOSUGGEST_THRESHOLD)
				{
					this.showSKUAutoSuggest(false);
				}
				else
				{
					this.showSKUAutoSuggest(true);
				}				
			}
		},

		selectAutoSuggest:function(term) {
			var scrElement = document.getElementById("skuAddSearch" + this.suffix);
			if (scrElement != null && scrElement.style.display == 'block'){
				var searchBox = document.getElementById(this.inputField);
			}
			searchBox.value = term;
			searchBox.focus();
			this.skuAutoSuggestPreviousTerm = term;
			var domClass = require("dojo/dom-class");
			if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null 
				&& domClass.contains(document.getElementById(this.addButton), "formButtonDisabled") && domClass.contains(document.getElementById(this.addButtonText), "formButtonGreyOut")){					
				domClass.remove(document.getElementById(this.addButton), "formButtonDisabled");
				domClass.remove(document.getElementById(this.addButtonText), "formButtonGreyOut");
			}	
			this.showSKUAutoSuggest(false);	
		},

		highLightSelection:function(state, index) {
			var selection = document.getElementById("skuAutoSelectOption_" + index + this.suffix);
			if(selection != null && selection != 'undefined') {
				if(state) {
					selection.className = "autoSuggestSelected";
					var scrElement = document.getElementById("skuAddSearch" + this.suffix);
					if (scrElement != null && scrElement.style.display == 'block'){
						var searchBox = document.getElementById(this.inputField);
					}
					searchBox.setAttribute("aria-activedescendant", "suggestionSKU_" + index);
					var totalDynamicResults = document.getElementById("dynamicAutoSuggestSKUTotalResults" + this.suffix);
					if((totalDynamicResults != null && totalDynamicResults != 'undefined' && index < totalDynamicResults.value) || (index >= this.historyIndex)) {
						searchBox.value = selection.title;
						this.skuAutoSuggestPreviousTerm = selection.title;						
					}					
				}
				else {
					selection.className = "skuSearchItem";
				}
				return true;
			}
			else {
				return false;
			}
		},

		resetSKUAutoSuggestKeyword:function() {
			var originalKeyedSearchTerm = document.getElementById("autoSuggestSKUOriginalTerm" + this.suffix);
			if(originalKeyedSearchTerm != null && originalKeyedSearchTerm != 'undefined') {
				var scrElement = document.getElementById("skuAddSearch" + this.suffix);
				if (scrElement != null && scrElement.style.display == 'block')
				{
					var searchBox = document.getElementById(this.inputField);
				}
				searchBox.value = originalKeyedSearchTerm.value;
				this.skuAutoSuggestPreviousTerm = originalKeyedSearchTerm.value;
			}
		},


		clearSKUAutoSuggestResults:function() {
			this.showSKUAutoSuggest(false);
		},

		doSKUAutoSuggest:function(event, url, searchTerm) {
			if(searchTerm.length <= this.AUTOSUGGEST_THRESHOLD ) {
				this.showSKUAutoSuggest(false);
			}

			if(event.keyCode == dojo.keys.TAB) {				
				this.showSKUAutoSuggest(false);
				return;
			}

			if(event.keyCode == dojo.keys.ESCAPE) {
				this.showSKUAutoSuggest(false);
				return;
			}
			
			if(event.keyCode == dojo.keys.ENTER) {			
				var searchBox = document.getElementById(this.inputField);
				if (searchBox != null){	
					AutoSKUSuggestJS.selectAutoSuggest(searchBox.value);
				}
				return;
			}

			if(event.keyCode == dojo.keys.UP_ARROW) {
				if (this.highLightSelection(true, this.autoSelectOption-1)) {
					this.highLightSelection(false, this.autoSelectOption);
					if(this.autoSelectOption == this.historyIndex) {
						this.resetSKUAutoSuggestKeyword();
					}
					this.autoSelectOption--;
				}
				return;
			}

			if(event.keyCode == dojo.keys.DOWN_ARROW) {
				if(this.highLightSelection(true, this.autoSelectOption+1)) {
					this.highLightSelection(false, this.autoSelectOption);
					this.autoSelectOption++;
				}
				return;
			}

			if(searchTerm.length > this.AUTOSUGGEST_THRESHOLD && searchTerm == this.skuAutoSuggestPreviousTerm) {
				return;
			}
			else {
				this.skuAutoSuggestPreviousTerm = searchTerm;
			}

			if(searchTerm.length <= this.AUTOSUGGEST_THRESHOLD) {
				return;
			};

			// cancel the dynamic search if one is pending
			if(this.skuAutoSuggestSKUTimer != -1) {
				clearTimeout(this.skuAutoSuggestSKUTimer);
				this.skuAutoSuggestSKUTimer = -1;
			}

			if(searchTerm != "") {
				this.autoSelectOption = -1;				
				if(searchTerm.length > this.DYNAMIC_AUTOSUGGEST_THRESHOLD) {					
					this.doDynamicSKUAutoSuggest(url, searchTerm);
				}
				else {
					// clear the dynamic results
					document.getElementById("autoSuggestBySKU_Result_div" + this.suffix).innerHTML = "";
				}
			}
			else {
				this.clearSKUAutoSuggestResults();
			}
		},
		
		/**
		 * Checks if a string is null or empty.
		 * @param (string) str The string to check.
		 * @return (boolean) Indicates whether the string is empty.
		 */
		isEmpty:function (str) {
			var reWhiteSpace = new RegExp(/^\s+$/);
			if (str == null || str =='' || reWhiteSpace.test(str) ) {
				return true;
			}
			return false;
		}

	};
}
/**
 * Declares a new render context for the AutoSuggest display.
 */
wc.render.declareContext("AutoSuggestSKU_Context",null,"");
	
var autoSKUSuggest_controller_initProperties = {
   id: "autoSuggestBySKU_Controller",
   renderContext: wc.render.getContextById("AutoSuggestSKU_Context"),
   url: "",
   formId: ""

   /**
	* Displays the keyword suggestions from the search index
	* This function is called when a render context changed event is detected.
	*
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
   ,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		if (controller.id == ("autoSuggestBySKU_Controller" + AutoSKUSuggestJS.suffix)){
			widget.refresh(renderContext.properties);
		}
   }

   /**
	* Display the results.
	*
	* @param {object} widget The registered refresh area
	*/
   ,postRefreshHandler: function(widget) {				
		AutoSKUSuggestJS.showSKUAutoSuggestIfResults();	
   }
};
