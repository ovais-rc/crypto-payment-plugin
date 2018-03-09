//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos
wc.render.declareContext("searchBasedNavigation_context", {"contentBeginIndex":"0", "productBeginIndex":"0", "beginIndex":"0", "orderBy":"", "facetId":"", "pageView":"", "resultType":"both", "orderByContent":"", "searchTerm":"", "facet":"", "facetLimit":"", "minPrice":"", "maxPrice":"", "pageSize":""}, "");

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Products).
var searchBasedNavigation_controller_initProperties = {
	id: "searchBasedNavigation_controller",
	renderContext: wc.render.getContextById("searchBasedNavigation_context"),
	url: "",
	formId: ""

,renderContextChangedHandler: function(message, widget) {
	var controller = this;
	var renderContext = this.renderContext;
	var resultType = renderContext.properties["resultType"];
	renderContext.properties["pgl_widgetId"] = widget.pglwidgetid;
	if(resultType == "products" || resultType == "both"){
		renderContext.properties["beginIndex"] = renderContext.properties["productBeginIndex"];
		widget.refresh(renderContext.properties);
	}

}

,postRefreshHandler: function(widget) {
	// Handle the new facet counts, and update the values in the left navigation.  First parse the script, and then call the update function.
	var facetCounts = byId("facetCounts" + widget.objectId);

	if(facetCounts != null) {
		var scripts = facetCounts.getElementsByTagName("script");
		var j = scripts.length;
		for (var i = 0; i < j; i++){
			var newScript = document.createElement('script');
			newScript.type = "text/javascript";
			newScript.text = scripts[i].text;
			facetCounts.appendChild(newScript);
		}
		SearchBasedNavigationDisplayJS.resetFacetCounts();
		
		//uncomment this if you want tohide zero facet values and the facet itself
		//SearchBasedNavigationDisplayJS.removeZeroFacetValues();
		SearchBasedNavigationDisplayJS.validatePriceInput();
	}
	updateFacetCounts();
	SearchBasedNavigationDisplayJS.cleanUpAddedFacets();
	
	SearchBasedNavigationDisplayJS.removeEmptyFacet();
	var pairs = location.hash.substring(1).split(SearchBasedNavigationDisplayJS.contextValueSeparator);
	for(var k = 0; k < pairs.length; k++) {
		var pair = pairs[k].split(":");
		if(pair[0] == "facet") {
			var ids = pair[1].split(",");
			for(var i = 0; i < ids.length; i++) {
				var e = byId(ids[i]);
				if (e) {
					e.checked = true;
					if(e.title != "MORE") {
							SearchBasedNavigationDisplayJS.appendFilterFacet(ids[i]);										
					}							
				}
			}
		}
	}
	

	var resultType = widget.controller.renderContext.properties["resultType"];
	if(resultType == "products" || resultType == "both"){
		var currentIdValue = currentId;
		cursor_clear();
		SearchBasedNavigationDisplayJS.initControlsOnPage(widget.objectId, widget.controller.renderContext.properties);
		shoppingActionsJS.updateSwatchListView();
		shoppingActionsJS.checkForCompare();
		var gridViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_grid_categoryResults";
		var listViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_list_categoryResults";
		var selectedFacet = dojo.query("#filter_" + currentIdValue +" > a")[0];
		var deSelectedFacet = dojo.query("li[id^='facet_" + currentIdValue + "']" + " .facetbutton")[0];
		
		if (selectedFacet != null && selectedFacet != 'undefined'){
			selectedFacet.focus();
		}else if(deSelectedFacet != null && deSelectedFacet != 'undefined'){ 
			deSelectedFacet.focus();
		}else if(currentIdValue == "orderBy"){
			byId("orderBy"+widget.objectId).focus();
		}
		else{
			if((currentIdValue == gridViewLinkId || currentIdValue != listViewLinkId) && byId(listViewLinkId)){
				byId(listViewLinkId).focus();
			}
			if((currentIdValue == listViewLinkId || currentIdValue != gridViewLinkId) && byId(gridViewLinkId)){
				byId(gridViewLinkId).focus();
			}
		}
	}
	var pagesList = document.getElementById("pages_list_id");
	if (pagesList != null && !isAndroid() && !isIOS()) {
		dojo.addClass(pagesList, "desktop");
	}
	dojo.publish("CMPageRefreshEvent");
	dojo.publish("CIRefreshProductOverlay");
}
};

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Articles and videos).
wc.render.declareRefreshController({
	id: "searchBasedNavigation_content_controller",
	renderContext: wc.render.getContextById("searchBasedNavigation_context"),
	url: "",
	formId: ""

,renderContextChangedHandler: function(message, widget) {
	var controller = this;
	var renderContext = this.renderContext;
	var resultType = renderContext.properties["resultType"];
	if(resultType == "content" || resultType == "both"){
		renderContext.properties["beginIndex"] = renderContext.properties["contentBeginIndex"];
		widget.refresh(renderContext.properties);
	}
}

,postRefreshHandler: function(widget) {
	var resultType = widget.controller.renderContext.properties["resultType"];
	if(resultType == "content" || resultType == "both"){
			var currentIdValue = currentId;
			cursor_clear();
			SearchBasedNavigationDisplayJS.initControlsOnPage(widget.objectId, widget.controller.renderContext.properties);
			//shoppingActionsJS.initCompare();
			if(currentIdValue == "orderByContent"){
				byId("orderByContent").focus();
			}
		}
		dojo.publish("CMPageRefreshEvent");
	}
});



if(typeof(SearchBasedNavigationDisplayJS) == "undefined" || SearchBasedNavigationDisplayJS == null || !SearchBasedNavigationDisplayJS){

	SearchBasedNavigationDisplayJS = {

		/**
		 * This variable is an array to contain all of the facet ID's generated from the initial search query.  This array will be the master list when applying facet filters.
		 */
		contextValueSeparator: "&",
		contextKeySeparator: ":",
		widgetId: "",
		facetIdsArray: new Array,
		facetIdsParentArray: new Array,
		uniqueParentArray: new Array,
		selectedFacetLimitsArray: new Array,		
		facetFromRest: new Array,

		init:function(widgetSuffix,searchResultUrl, widgetProperties){
			wc.render.getRefreshControllerById('searchBasedNavigation_controller'+widgetSuffix).url = matchUrlProtocol(searchResultUrl);
			var lang = require("dojo/_base/lang");
			var widgetInitProperties = {};
			lang.mixin(widgetInitProperties, WCParamJS, widgetProperties);
			this.initControlsOnPage(widgetSuffix, widgetInitProperties);
			this.updateContextProperties("searchBasedNavigation_context", widgetInitProperties);
			
//			var currentContextProperties = wc.render.getContextById('searchBasedNavigation_context').properties;
		},

		initConstants:function(removeCaption, moreMsg, lessMsg, currencySymbol) {
			this.removeCaption = removeCaption;
			this.moreMsg = moreMsg;
			this.lessMsg = lessMsg;
			this.currencySymbol = currencySymbol;
		},

		initControlsOnPage:function(widgetSuffix,properties){
			//Set state of sort by select box..
			var selectBox = dojo.byId("orderBy"+widgetSuffix);
			if(selectBox != null && selectBox != 'undefined'){
				dojo.byId("orderBy"+widgetSuffix).value = properties['orderBy'];
			}

			selectBox = dojo.byId("orderByContent");
			if(selectBox != null && selectBox != 'undefined'){
				dojo.byId("orderByContent").value = properties['orderByContent'];
			}
		},

		initContentUrl:function(contentUrl){
			wc.render.getRefreshControllerById('searchBasedNavigation_content_controller').url = contentUrl;
		},

		findContainer:function(el) {
		//console.debug(el);
			while (el.parentNode) {
				el = el.parentNode;
				if (el.className == 'optionContainer') {
					return el;
				}
			}
			return null;
		},

		resetFacetCounts:function() {
			for(var i = 0; i < this.facetIdsArray.length; i++) {
				var facetValue = byId("facet_count" + this.facetIdsArray[i]);
				var facetAcceValue = byId(this.facetIdsArray[i] + "_ACCE_Label_Count");
				if(facetValue != null) {
					facetValue.innerHTML = 0;
				}
				if(facetAcceValue != null) {
					facetAcceValue.innerHTML = 0;
				}
			}
		},
		
		removeEmptyFacet:function(){			
			var widget = this.widgetId;
			for(var i = 0; i < this.facetIdsArray.length; i++) {				
				var facetId = "facet_" + this.facetIdsArray[i];			
				var facetValue = byId("facet_count" + this.facetIdsArray[i]);
		
				if(facetValue.innerHTML == '0') {
					document.getElementById(facetId + widget).style.display = 'none';
				}
				else if(facetValue.innerHTML != '0') {					
					document.getElementById(facetId + widget).style.display = 'block';													
				}
			}			
		},
		
		removeZeroFacetValues:function() {
			var uniqueId = this.uniqueParentArray;
			var widget = this.widgetId;
			for(var i = 0; i < this.facetIdsArray.length; i++) {
				var facetId = "facet_" + this.facetIdsArray[i];
				var parentId = this.facetIdsParentArray[i];
				var facetValue = byId("facet_count" + this.facetIdsArray[i]);

				if(facetValue.innerHTML == '0') {
					document.getElementById(facetId + widget).style.display = 'none';
				}
				else if(facetValue.innerHTML != '0') {
					document.getElementById(facetId + widget).style.display = 'block';
					uniqueId[parentId] = uniqueId[parentId] + 1;
				}
			}
			for(var key in uniqueId){
				if(uniqueId[key] == 0){
					document.getElementById(key).style.display = 'none';
					uniqueId[key] = 0;//reset the count
				}
				else if(uniqueId[key] != 0){
					document.getElementById(key).style.display = 'block';
					uniqueId[key] = 0;//reset the count
				}
			}

		},
		updateFacetCount:function(id, count, value, label, image, contextPath, group, multiFacet) {
			var facetValue = byId("facet_count" + id);
			var widget = this.widgetId;
			if(facetValue != null) {
				var checkbox = byId(id);
				var facetAcceValue = byId(id + "_ACCE_Label_Count");
				if(count > 0) {
					// Reenable the facet link
					checkbox.disabled = false;
					if(facetValue != null) {
						facetValue.innerHTML = count;
					}
					if(facetAcceValue != null) {
						facetAcceValue.innerHTML = count;
					}		
				}
			}
			else if(count > 0) {
				// there is no limit to the number of facets shown, and the user has exposed the show all link
				if(byId("facet_" + id) == null) {
					// this facet does not exist in the list.  Insert it.
					var divContainer = dojo.query("[id^='section_list_" + group + "']")[0];
					var grouping = dojo.query(" > ul.facetSelect", divContainer)[0];
					if(grouping) {
						this.facetIdsArray.push(id);
						var newFacet = document.createElement("li");
						newFacet.setAttribute("onclick","SearchBasedNavigationDisplayJS.triggerCheckBox(this)");
						var newCheckBox = document.createElement("div");
						var newCheckMark = document.createElement("div");
						var facetClass = "";
						var section = "";
						if(!multiFacet) {
							if(image != ""){
							facetClass = "singleFacet";
							}
							// specify which facet group to collapse when multifacets are not enabled.
							section = group;
						}
						if(image != "") {
							facetClass = "singleFacet left";
						}
						if(image == ""){
						newCheckBox.setAttribute("class", "checkBox");
						newCheckMark.setAttribute("class", "checkmarkMulti");
						}
						newFacet.setAttribute("id", "facet_" + id + widget);
						newFacet.setAttribute("class", facetClass);
						newFacet.setAttribute("data-additionalvalues", "More")
						var facetLabel = "<label for='" + id + "'>";
						if(image != "") {
							facetLabel = facetLabel + "<span class='swatch'><span class='outline'><span id='facetLabel_" + id + "'><img src='" + image + "' title='" + label + "' alt='" + label + "'/></span> <div class='facetCountContainer'>(<span id='facet_count" + id + "'>"+ count + "</span>)</div>";
						}
						else {														
							facetLabel = facetLabel + "<span class='outline'><span id='facetLabel_" + id + "'>" + label + "</span> (<span id='facet_count" + id +"'>" + count + "</span>)</span>";
						}
						facetLabel = facetLabel + "<span class='spanacce' id='" + id + "_ACCE_Label'>" + label + " (" + count + ")</span></label>";
						newFacet.innerHTML = "<input type='checkbox' aria-labelledby='" + id + "_ACCE_Label' id='" + id + "' value='" + value + "' onclick='javascript: SearchBasedNavigationDisplayJS.setEnabledShowMoreLinks(this, \"morelink_" + group + "\");SearchBasedNavigationDisplayJS.toggleSearchFilter(this, \"" + id + "\");'/>" + facetLabel;
						
						var clearFloat = dojo.query(" > div.clear_float", grouping)[0];
						if(clearFloat != undefined) {
							grouping.removeChild(clearFloat);
						}
						grouping.appendChild(newFacet);
						if(image == ""){
						newFacet.appendChild(newCheckBox);
						newCheckBox.appendChild(newCheckMark);
						}
					}
				}
			}
		},
		
		triggerCheckBox:function(elem){
			var inputBox = elem.children[0];
			inputBox.click();
		},
		
		cleanUpAddedFacets:function() {
			for(var i = 0; i < this.facetIdsArray.length; i++) {
				var removeFacet = true;
				for(var j = 0; j < this.facetFromRest.length; j++) {
					if (this.facetIdsArray[i] == this.facetFromRest[j]) {
						removeFacet = false;
						break;
					}
				}    
				if (removeFacet) {
					var elem = byId("facet_" + this.facetIdsArray[i]);
					if(elem != null) {
						elem.parentNode.removeChild(elem);
					}
				}
			}                
		},
		
		setEnabledShowMoreLinks:function(element, section_id){
			if(element.checked) {				
				this.selectedFacetLimitsArray.push(section_id + "|" + element.id + "|" + element.value);
				this.removeShowMoreFromFacetLimitArray(section_id);
			}
			else {
				var index = this.selectedFacetLimitsArray.indexOf(section_id + "|" + element.id + "|" + element.value);
				if (index > -1){
					this.selectedFacetLimitsArray.splice(index, 1);
				}
			}			
		},
		
		
		
		isValidNumber:function(n) {
			var valueToParse = n;
			valueToParse = valueToParse.replace(/^\s+|\s+$/g,"");
			valueToParse = valueToParse.replace(/\xa0/g,'');
			var valueToParse = valueToParse;

			if(dojo.locale == 'ar-eg')
			{
				valueToParse = valueToParse.replace(',','');
				var parsedAmountValue = dojo.number.round(valueToParse,2);
			}
			else
			{
				var parsedAmountValue = dojo.number.parse(valueToParse, {place:2});
			}
			if(!isNaN(parsedAmountValue)){
				return true;
			}
			else{
				return false;
			}	
		},
		convertToInternalValue:function(val) {
			var valueToParse = val;
			valueToParse = valueToParse.replace(/^\s+|\s+$/g,"");
			valueToParse = valueToParse.replace(/\xa0/g,'');
			var valueToParse = valueToParse;

			if(dojo.locale == 'ar-eg')
			{
				valueToParse = valueToParse.replace(',','');
				var parsedAmountValue = dojo.number.round(valueToParse,2);
			}
			else
			{
				var parsedAmountValue = dojo.number.parse(valueToParse, {place:2});
			}
			return parsedAmountValue;
		},

		checkPriceInput:function(event) {
			if(this.validatePriceInput() && event.keyCode == 13) {
				this.appendFilterPriceRange(this.currencySymbol);
				this.doSearchFilter();
			}else if(byId("low_price_input") != null && byId("high_price_input") != null){
				var lowPrice = byId("low_price_input").value;
				var highPrice = byId("high_price_input").value;
				if((!this.isValidNumber(lowPrice) || !this.isValidNumber(highPrice)) && event.keyCode == 13) {
					MessageHelper.formErrorHandleClient("high_price_input", storeNLS['ERROR_FACET_PRICE_INVALID']);
				}
			}
			return false;
		},

		validatePriceInput:function() {
			if(byId("low_price_input") != null && byId("high_price_input") != null && byId("price_range_go") != null) {
				var low = byId("low_price_input").value;
				var high = byId("high_price_input").value;
				var go = byId("price_range_go");
				if(this.isValidNumber(low) && this.isValidNumber(high) && parseFloat(high) > parseFloat(low)) {
					go.className = "go_button";
					go.disabled = false;
				}
				else {
					go.className = "go_button_disabled";
					go.disabled = true;
				}
				return !go.disabled;
			}
			return false;
		},

		toggleShowMore:function(index, show) {
			var list = byId('more_' + index);
			var morelink = byId('morelink_' + index);
			if(list != null) {
				if(show) {
					morelink.style.display = "none";
					list.style.display = "inline-block";
				}
				else {
					morelink.style.display = "inline-block";
					list.style.display = "none";
				}
			}
		},

		toggleSearchFilterOnKeyDown:function(event, element, id) {
			if (event.keyCode == dojo.keys.ENTER) {
				element.checked = !element.checked;
				this.toggleSearchFilter(element, id);
			}
		},

		toggleSearchFilter:function(element, id) {
			if(element.checked) {
				this.appendFilterFacet(id);
			}
			else {
				this.removeFilterFacet(id);
			}

/*

			if(section != "") {
				byId('section_' + section).style.display = "none";
			}
*/
			this.doSearchFilter();
		},

		appendFilterPriceRange:function(currencySymbol) {

			var el = byId("price_range_input");
			var section = this.findContainer(el);
			if(section) {
				byId(section.id).style.display = "none";
			}
			byId("clear_all_filter").style.display = "block";


			var facetFilterList = byId("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				facetFilterList.setAttribute("id", "facetFilterList");
				facetFilterList.setAttribute("class", "facetSelectedCont");
				var facetFilterListWrapper = byId("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}

			var filter = byId("pricefilter");
			if(filter == null) {
				filter = document.createElement("li");
				filter.setAttribute("id", "pricefilter");
				filter.setAttribute("class", "facetSelected");
				facetFilterList.appendChild(filter);
			}
			var label = currencySymbol + byId("low_price_input").value + " - " + currencySymbol + byId("high_price_input").value;
			filter.innerHTML = "<a role='button' href='#' onclick='dojo.topic.publish(\"Facet_Remove\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span><div class='clear_float'></div></div></a>";

			byId("clear_all_filter").style.display = "block";

			if(this.validatePriceInput()) {
				// Promote the values from the input boxes to the internal inputs for use in the request.
				byId("low_price_value").value = this.convertToInternalValue(byId("low_price_input").value);
				byId("high_price_value").value = this.convertToInternalValue(byId("high_price_input").value);
			}

		},

		removeFilterPriceRange:function() {
			if(byId("low_price_value") != null && byId("high_price_value") != null) {
				byId("low_price_value").value = "";
				byId("high_price_value").value = "";
			}
			var facetFilterList = byId("facetFilterList");
			var filter = byId("pricefilter");
			if(filter != null) {
				facetFilterList.removeChild(filter);
			}

			if(facetFilterList.childNodes.length == 0) {
				byId("clear_all_filter").style.display = "none";
				byId("facetFilterListWrapper").innerHTML = "";
			}

			var el = byId("price_range_input");
			var section = this.findContainer(el);
			if(section) {
				byId(section.id).style.display = "block";
			}

			this.doSearchFilter();
		},

		appendFilterFacet:function(id) {
			var facetFilterList = byId("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				facetFilterList.setAttribute("id", "facetFilterList");
				facetFilterList.setAttribute("class", "facetSelectedCont");
				var facetFilterListWrapper = byId("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}

			var filter = byId("filter_" + id);
			// do not add it again if the user clicks repeatedly
			if(filter == null) {
				filter = document.createElement("li");
				filter.setAttribute("id", "filter_" + id);
				filter.setAttribute("class", "facetSelected");
				var label = byId("facetLabel_" + id).innerHTML;					
				var acceRemoveLabel = "<span class='spanacce' id='ACCE_Label_Remove'>"+ MessageHelper.messages['REMOVE']+ "</span>";
				
				filter.innerHTML = "<a role='button' href='#' onclick='javascript:setCurrentId(\"" + id + "\");dojo.topic.publish(\"Facet_Remove\", \"" + id + "\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span>" + acceRemoveLabel + "<div class='clear_float'></div></div></a>";
				
				facetFilterList.appendChild(filter);
			}

			byId("facetLabel_" + id).parentElement.setAttribute("class","outline facetSelectedHighlight");

			var el = byId(id);
			var section = this.findContainer(el);
			if(section) {
				byId(section.id).style.display = "none";
			}
			byId("clear_all_filter").style.display = "block";

		},

		removeFilterFacet:function(id) {
			var facetFilterList = byId("facetFilterList");
			var filter = byId("filter_" + id);
			if(filter != null) {
				var value = byId(id).value;
				var section_id = value.split("%3A%22")[0];
				var index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);
				
				if (index == -1) {
					value=value.replace(/%3A/g,":");
					value=value.replace(/%22/g,'"');
					index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);
				}

				if (index > -1){
					this.selectedFacetLimitsArray.splice(index, 1);
				}
				facetFilterList.removeChild(filter);
				byId(id).checked = false;
			}

			if(facetFilterList.childNodes.length == 0) {
				byId("clear_all_filter").style.display = "none";
				byId("facetFilterListWrapper").innerHTML = "";
			}

			byId("facetLabel_" + id).parentElement.setAttribute("class","outline");

			var el = byId(id);
			var section = this.findContainer(el);
			if(section) {
				byId(section.id).style.display = "block";
			}
			this.doSearchFilter();
		},

		getEnabledProductFacets:function() {
			var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
			var elementArray = facetForm.elements;

			var facetArray = new Array();
			var facetIds = new Array();
			if(_searchBasedNavigationFacetContext != 'undefined') {
				for(var i=0; i< _searchBasedNavigationFacetContext.length; i++) {
					facetArray.push(_searchBasedNavigationFacetContext[i]);
					//facetIds.push();
				}
			}
			var facetLimits = new Array();
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX") {
					if(element.title == "MORE") {
						// scan for "See More" facet enablement.
						if(element.checked) {
							facetLimits.push(element.value);
						}
					}
					else {
						// disable the checkbox while the search is being performed to prevent double clicks
						element.disabled = true;
						if(element.checked) {
							facetArray.push(element.value);
							facetIds.push(element.id);
						}
					}
				}
			}
			// disable the price range button also
			if(byId("price_range_go") != null) {
				byId("price_range_go").disabled = true;
			}

			var results = new Array();
			results.push(facetArray);
			results.push(facetLimits);
			results.push(facetIds);
			return results;
		},

		doSearchFilter:function() {
			if(!submitRequest()){
				return;
			}
			cursor_wait();

			var minPrice = "";
			var maxPrice = "";

			if(byId("low_price_value") != null && byId("high_price_value") != null) {
				minPrice = byId("low_price_value").value;
				maxPrice = byId("high_price_value").value;
			}
			if(minPrice == '' && maxPrice == '')
			{
				minPrice = window.initialMinPrice;
				maxPrice = window.initialMaxPrice;
			}
			var facetArray = this.getEnabledProductFacets();

			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0", "facet": facetArray[0], "facetLimit": facetArray[1], "facetId": facetArray[2], "resultType":"products", "minPrice": minPrice, "maxPrice": maxPrice});
			this.updateHistory();

			MessageHelper.hideAndClearMessage();
		},
		
		addShowMoreToFacetLimitArray:function(id) {
			// only add if no child facet is selected (i.e. no child is found in selectedFacetLimitsArray
			var childExist = false;
			for (var i=0; i<this.selectedFacetLimitsArray; i++) {
				if (this.selectedFacetLimitsArray[i].indexOf(id) != -1) {
					childExist = true;
					break;
				}
			}
			if (!childExist) {
				var index = id.indexOf(":");
				if (index != -1) {
					id = id.substr(0,index);
				}
				this.selectedFacetLimitsArray.push("morelink_" + id);
			}
		},
		
		removeShowMoreFromFacetLimitArray:function(id) {
			var cIndex = id.indexOf(":");
			if (cIndex != -1) {
				id = id.substr(0,cIndex);
			}
			if (id.indexOf("morelink_") == -1) {
				id = "morelink_" + id;
			}
			var index = this.selectedFacetLimitsArray.indexOf(id);
			if (index != -1) {
				this.selectedFacetLimitsArray.splice(index,1);
			}
		},

		toggleShowMore:function(element, id) {
			var label = byId("showMoreLabel_" + id);
			var divContainer = dojo.query("[id^='section_list_" + id + "']")[0];
			var grouping = dojo.query(" > ul.facetSelect > li[data-additionalvalues]", divContainer);
			if(element.checked) {
				this.addShowMoreToFacetLimitArray(element.value);
				label.innerHTML = this.lessMsg;
				var group = dojo.query(" > ul.facetSelect", divContainer)[0];
				var clearFloat = dojo.query(" > div.clear_float", group)[0];
				if(clearFloat != undefined) {
					group.removeChild(clearFloat);
				}
				if(grouping) {
					for(var i = 0;i < grouping.length; i++) {
						grouping[i].style.display="";
					}
				}
			}
			else {
				this.removeShowMoreFromFacetLimitArray(element.value);
				if(grouping) {
					for(var i = 0;i < grouping.length; i++) {
						grouping[i].style.display="none";
					}
				}
				label.innerHTML = this.moreMsg;

			}
			this.doSearchFilter();
		},


		clearAllFacets:function(execute) {
			byId("clear_all_filter").style.display = "none";
			byId("facetFilterListWrapper").innerHTML = "";
			if(byId("low_price_value") != null && byId("high_price_value") != null) {
				byId("low_price_value").value = "";
				byId("high_price_value").value = "";
			}

			var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					element.checked = false;
				}
			}

			var elems = document.getElementsByTagName("*");
			for (var i=0; i < elems.length; i++) {
				// Reset all hidden facet sections (single selection facets are hidden after one facet is selected from that facet grouping)
				// and clear all selected facet highlights.
				var element = elems[i];
				if (element.id != null) {
					if (element.id.indexOf("section_") == 0 && !(element.id.indexOf("section_list") == 0)) {
						element.style.display = "block";
					}
					if (element.id.indexOf("facetLabel_") == 0) {
						element.parentElement.setAttribute("class","outline");
					}
				}
			}

			if(execute) {
				this.doSearchFilter();
				this.selectedFacetLimitsArray = [];
			}
		},

		toggleSearchContentFilter:function() {
			if(!submitRequest()){
				return;
			}
			cursor_wait();

			var facetList = "";
			var facetForm = document.forms['contentsFacets'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					facetList += element.value + ";";
				}
			}

			wc.render.updateContext('searchBasedNavigation_context', {"facet": facetList, "resultType":"content"});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},


		updateContextProperties:function(contextId, properties){
			//Set the properties in context object..
			for(key in properties){
				wc.render.getContextById(contextId).properties[key] = properties[key];
				//console.debug(" key = "+key +" and value ="+wc.render.getContextById(contextId).properties[key]);
			}
		},

		showResultsPageForContent:function(data){

			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = dojo.number.parse(pageNumber);
			pageSize = dojo.number.parse(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();
			wc.render.updateContext('searchBasedNavigation_context', {"contentBeginIndex": beginIndex,"resultType":"content"});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		showResultsPage:function(data){

			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = dojo.number.parse(pageNumber);
			pageSize = dojo.number.parse(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			//console.debug(wc.render.getContextById('searchBasedNavigation_context').properties);
			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();


			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": beginIndex,"resultType":"products"});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		toggleView:function(data){
			var pageView = data["pageView"];
			setCurrentId(data["linkId"]);
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("pageView = "+pageView+" controller = +searchBasedNavigation_controller");
			wc.render.updateContext('searchBasedNavigation_context', {"pageView": pageView,"resultType":"products", "enableSKUListView":data.enableSKUListView});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		toggleExpand:function(id) {
			var icon = byId("icon_" + id);
			var section_list = byId("section_list_" + id);
			if(icon.className == "arrow") {
				icon.className = "arrow arrow_collapsed";
				section_list.setAttribute("aria-expanded", "false");
				section_list.style.display = "none";
			}
			else {
				icon.className = "arrow";
				section_list.setAttribute("aria-expanded", "true");
				section_list.style.display = "block";
			}
		},

		setPageSize:function(newPageSize){
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("resultsPerPage = "+newPageSize+" controller = +searchBasedNavigation_controller");

			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0","resultType":"products","pageSize":newPageSize});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		sortResults:function(orderBy){
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("orderBy = "+orderBy+" controller = +searchBasedNavigation_controller");
			//Reset beginIndex = 1

			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0","orderBy":orderBy,"resultType":"products"});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		sortResults_content:function(orderBy){
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("orderBy = "+orderBy+" controller = +searchBasedNavigation_controller");
			//Reset beginIndex = 1
			wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": "0","orderByContent":orderBy,"resultType":"content"});
			this.updateHistory();
			MessageHelper.hideAndClearMessage();
		},

		swatchImageClicked:function(id) {
			// This is a workaround for IE's bug for non-clickable label images.
			var e = byId(id);
			if(!e.checked) {
				e.click();
			}
		},

		clone:function(masterObj) {
			if (null == masterObj || "object" != typeof masterObj) return masterObj;
			var clone = masterObj.constructor();
			for (var attr in masterObj) {
				if (masterObj.hasOwnProperty(attr)) clone[attr] = masterObj[attr];
			}
			return clone;
		},

		getContextPropertiesAsString:function(){
			
			var currentContextProperties = wc.render.getContextById('searchBasedNavigation_context').properties;
			var mergedFacetLimits = this.selectedFacetLimitsArray;			
			var contextValues = "facet:" + currentContextProperties["facetId"] + this.contextValueSeparator;						
			contextValues+= "productBeginIndex:" + currentContextProperties["beginIndex"] + this.contextValueSeparator;
			contextValues+= "facetLimit:" + mergedFacetLimits + this.contextValueSeparator;
			contextValues+= "orderBy:" + currentContextProperties["orderBy"] + this.contextValueSeparator;
			contextValues+= "pageView:" + currentContextProperties["pageView"] + this.contextValueSeparator;
			contextValues+= "minPrice:" + currentContextProperties["minPrice"] + this.contextValueSeparator;
			contextValues+= "maxPrice:" + currentContextProperties["maxPrice"] + this.contextValueSeparator;
			contextValues+= "pageSize:" + currentContextProperties["pageSize"] + this.contextValueSeparator;
			return contextValues;

		},

		updateHistory:function() {
/*
			var contextValues = "";
			for(var i = 0; i < facetArray[2].length; i++) {
				console.debug(facetArray[2][i]);
				contextValues= contextValues + facetArray[2][i] + "|";
			}
			*/

			var contextValues = this.getContextPropertiesAsString();
			var yScroll=document.body.scrollTop;
			if(history.pushState) {
				if (location.hash == "") {
					history.replaceState(null, null, "#" + contextValues);
				} else {
					history.pushState(null, null, "#" + contextValues);
				}
			}
			else {
				window.location.hash = contextValues;
			}
			document.body.scrollTop=yScroll;
		},

		restoreHistoryContext:function(currencySymbol) {
			if(location.hash != null && location.hash != "" && location.hash != "#") {

				var contextValues = this.getContextPropertiesAsString();
				if( location.hash == "#"+contextValues){
					// Page is loaded and contextValues is same as the hash value in URL
					// No need to make another Ajax call to update same content.
					return;
				} 

				this.clearAllFacets(false);

				var productBeginIndex = "";
				var orderBy = "";
				var pageView = "";
				var minPrice = "";
				var maxPrice = "";
				var pageSize = "";
				var moreFacetsIdList = [];
				var moreFacetsList = [];				

				var pairs = location.hash.substring(1).split(this.contextValueSeparator);
				for(var k = 0; k < pairs.length; k++) {
					var index = pairs[k].indexOf(":");
					var pair = [];
					pair.push(pairs[k].substring(0,index));
					pair.push(pairs[k].substring(index+1));

					if(pair[0] == "facet") {
						var ids = pair[1].split(",");
						for(var i = 0; i < ids.length; i++) {
							var e = byId(ids[i]);
							if (e) {
								e.checked = true;
								this.appendFilterFacet(ids[i]);
							}
						}
					}
					else if(pair[0] == "facetLimit") {
						var showMoreLinksIds = pair[1].split(",");
						for(var i = 0; i < showMoreLinksIds.length; i++) {
							var e = byId(showMoreLinksIds[i].split("|")[0]);
							if (e && e.title == "MORE") {								
								e.checked = true;
								// update the label
								var checkBoxLabel = showMoreLinksIds[i].substr(9);
								checkBoxLabel = "showMoreLabel_" + checkBoxLabel;
								var label = byId(checkBoxLabel);
								label.innerHTML = this.lessMsg;
								
								if (showMoreLinksIds[i].split("|")[1]) {
									moreFacetsIdList.push(showMoreLinksIds[i].split("|")[1]);
								}
								if (showMoreLinksIds[i].split("|")[2]) {
									moreFacetsList.push(showMoreLinksIds[i].split("|")[2]);
								}
								this.selectedFacetLimitsArray.push(showMoreLinksIds[i]);	
							}
						}
					}
					else if(pair[0] == "productBeginIndex") {
						productBeginIndex = pair[1];
					}
					else if(pair[0] == "orderBy") {
						orderBy = pair[1];
					}
					else if(pair[0] == "pageView") {
						pageView = pair[1];
					}
					else if(pair[0] == "minPrice") {
						byId("low_price_input").value = pair[1];
						minPrice = pair[1];
					}
					else if(pair[0] == "maxPrice") {
						byId("high_price_input").value = pair[1];
						maxPrice = pair[1];
					}
					else if(pair[0] == "pageSize") {
						pageSize = pair[1];
					}
				}
				if(!submitRequest()){
					return;
				}
				cursor_wait();

				if(minPrice != "" && maxPrice != "") {
					this.appendFilterPriceRange(currencySymbol);
				}

				var facetArray = this.getEnabledProductFacets();

				var moreFacetsIdArray = facetArray[2].concat(moreFacetsIdList);
				var moreFacetsArray = facetArray[0].concat(moreFacetsList);
				wc.render.updateContext('searchBasedNavigation_context', {"productBeginIndex": productBeginIndex, "orderBy": orderBy, "pageView": pageView, "facet": moreFacetsArray, "facetLimit": facetArray[1], "facetId": moreFacetsIdArray, "minPrice": minPrice, "maxPrice": maxPrice, "pageSize": pageSize});
			}
			else {
				this.updateHistory();
			}
		}
	};
}
