//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos
wcRenderContext.declare("searchBasedNavigation_context", ["searchBasedNavigation_content_widget"], { "contentBeginIndex": "0", "productBeginIndex": "0", "beginIndex": "0", "orderBy": "", "facetId": "", "pageView": "", "resultType": "both", "orderByContent": "", "searchTerm": "", "facet": "", "facetLimit": "", "minPrice": "", "maxPrice": "", "pageSize": "" });

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Products).
var searchBasedNavigation_controller_initProperties = {

    renderContextChangedHandler: function(refreshAreaDiv) {
        var rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context");
        var resultType = rcProperties["resultType"];
        rcProperties["pgl_widgetId"] = refreshAreaDiv.attr("pglwidgetid");
        if (["products", "both"].indexOf(resultType) > -1) {
            rcProperties["beginIndex"] = rcProperties["productBeginIndex"];
            refreshAreaDiv.refreshWidget("refresh", rcProperties);
        }

    },
    postRefreshHandler: function(widget) {
        // Handle the new facet counts, and update the values in the left navigation.  First parse the script, and then call the update function.        
        var rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context"),
            objectId = widget.attr("objectid"),
            facetCounts = byId("#facetCounts" + objectId);

        if (facetCounts != null) {
            var scripts = facetCounts.getElementsByTagName("script");
            var j = scripts.length;
            for (var i = 0; i < j; i++) {
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
        for (var k = 0; k < pairs.length; k++) {
            var pair = pairs[k].split(":");
            if (pair[0] == "facet") {
                var ids = pair[1].split(",");
                for (var i = 0; i < ids.length; i++) {
                    var e = byId(ids[i]);
                    if (e) {
                        e.checked = true;
                        if (e.title != "MORE") {
                            SearchBasedNavigationDisplayJS.appendFilterFacet(ids[i]);
                        }
                    }
                }
            }
        }


        var resultType = rcProperties["resultType"];
        if (["products", "both"].indexOf(resultType) > -1) {
            var currentIdValue = currentId;
            cursor_clear();
            SearchBasedNavigationDisplayJS.initControlsOnPage(objectId, rcProperties);
            shoppingActionsJS.updateSwatchListView();
            shoppingActionsJS.checkForCompare();
            var gridViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_grid_categoryResults";
            var listViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_list_categoryResults";
            var selectedFacet = $("#filter_" + currentIdValue + " > a")[0];
            var deSelectedFacet = $("li[id^='facet_" + currentIdValue + "']" + " .facetbutton")[0];

            if (selectedFacet != null && selectedFacet != 'undefined') {
                selectedFacet.focus();
            } else if (deSelectedFacet != null && deSelectedFacet != 'undefined') {
                deSelectedFacet.focus();
            } else if (currentIdValue == "orderBy") {
                $("#orderBy" + objectId).focus();
            } else {
                if ((currentIdValue == gridViewLinkId || currentIdValue != listViewLinkId) && byId(listViewLinkId)) {
                    byId(listViewLinkId).focus();
                }
                if ((currentIdValue == listViewLinkId || currentIdValue != gridViewLinkId) && byId(gridViewLinkId)) {
                    byId(gridViewLinkId).focus();
                }
            }
        }
        var pagesList = document.getElementById("pages_list_id");
        if (pagesList != null && !isAndroid() && !isIOS()) {
            $(pagesList).addClass("desktop");
        }
	
	/* APPLEPAY BEGIN */
	if (typeof(showApplePayButtons) == "function") {
		showApplePayButtons();
	}
	/* APPLEPAY END */
        wcTopic.publish("CMPageRefreshEvent");
    }
};

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Articles and videos).
var declareSearchBasedNavigationContentController = function() {
    var widgetObj = $("#searchBasedNavigation_content_widget"),
        rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context");

    widgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            var resultType = rcProperties["resultType"];
            if (["content", "both"].indexOf(resultType) > -1) {
                rcProperties["beginIndex"] = rcProperties["contentBeginIndex"];
                widgetObj.refreshWidget("refresh", rcProperties);
            }
        },
        postRefreshHandler: function() {
            var resultType = rcProperties["resultType"];
            if (["content", "both"].indexOf(resultType) > -1) {
                var currentIdValue = currentId;
                cursor_clear();
                SearchBasedNavigationDisplayJS.initControlsOnPage(widgetObj.objectId, rcProperties);
                //shoppingActionsJS.initCompare();
                if (currentIdValue == "orderByContent") {
                    byId("orderByContent").focus();
                }
            }
            wcTopic.publish("CMPageRefreshEvent");
        }
    });

};

if (typeof(SearchBasedNavigationDisplayJS) == "undefined" || SearchBasedNavigationDisplayJS == null || !SearchBasedNavigationDisplayJS) {

    SearchBasedNavigationDisplayJS = {

        /**
         * This variable is an array to contain all of the facet ID's generated from the initial search query.  This array will be the master list when applying facet filters.
         */
        contextValueSeparator: "&",
        contextKeySeparator: ":",
        widgetId: "",
        facetIdsArray: [],
        facetIdsParentArray: [],
        uniqueParentArray: [],
        selectedFacetLimitsArray: [],
        facetFromRest: [],

        init: function(widgetSuffix, searchResultUrl, widgetProperties) {
            $('#searchBasedNavigation_widget' + widgetSuffix).refreshWidget("updateUrl", matchUrlProtocol(searchResultUrl));
            var widgetInitProperties = {};
            $.extend(widgetInitProperties, WCParamJS, widgetProperties);
            this.initControlsOnPage(widgetSuffix, widgetInitProperties);
            this.updateContextProperties("searchBasedNavigation_context", widgetInitProperties);

            //			var currentContextProperties = wcRenderContext.getRenderContextProperties('searchBasedNavigation_context').properties;
        },

        initConstants: function(removeCaption, moreMsg, lessMsg, currencySymbol) {
            this.removeCaption = removeCaption;
            this.moreMsg = moreMsg;
            this.lessMsg = lessMsg;
            this.currencySymbol = currencySymbol;
        },

        initControlsOnPage: function(widgetSuffix, properties) {
            //Set state of sort by select box..
            $("#orderBy" + widgetSuffix).val(properties['orderBy']);

            $("#orderByContent").val(properties['orderByContent']);
        },

        initContentUrl: function(contentUrl) {
            $("#searchBasedNavigation_content_widget").refreshWidget("updateUrl", contentUrl);
        },

        findContainer: function(el) {
            //console.debug(el);
            while (el.parentNode) {
                el = el.parentNode;
                if (el.className == 'optionContainer') {
                    return el;
                }
            }
            return null;
        },

        resetFacetCounts: function() {
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);
                var facetAcceValue = byId(this.facetIdsArray[i] + "_ACCE_Label_Count");
                if (facetValue != null) {
                    facetValue.innerHTML = 0;
                }
                if (facetAcceValue != null) {
                    facetAcceValue.innerHTML = 0;
                }
            }
        },

        removeEmptyFacet: function() {
            var widget = this.widgetId;
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetId = "facet_" + this.facetIdsArray[i];
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);

                if (facetValue.innerHTML == '0') {
                    $("#" + facetId + widget).css("display", 'none');
                } else if (facetValue.innerHTML != '0') {
                    $("#" + facetId + widget).css("display", 'block');
                }
            }
        },

        removeZeroFacetValues: function() {
            var uniqueId = this.uniqueParentArray;
            var widget = this.widgetId;
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetId = "facet_" + this.facetIdsArray[i];
                var parentId = this.facetIdsParentArray[i];
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);

                if (facetValue.innerHTML == '0') {
                    $("#" + facetId + widget).css("display", 'none');
                } else if (facetValue.innerHTML != '0') {
                    $("#" + facetId + widget).css("display", 'block');
                    uniqueId[parentId] = uniqueId[parentId] + 1;
                }
            }
            for (var key in uniqueId) {
                if (uniqueId[key] == 0) {
                    document.getElementById(key).style.display = 'none';
                    uniqueId[key] = 0; //reset the count
                } else if (uniqueId[key] != 0) {
                    document.getElementById(key).style.display = 'block';
                    uniqueId[key] = 0; //reset the count
                }
            }

        },
        updateFacetCount: function(id, count, value, label, image, contextPath, group, multiFacet) {
            var facetValue = byId("facet_count" + id);
            var widget = this.widgetId;
            if (facetValue != null) {
                var checkbox = byId(id);
                var facetAcceValue = byId(id + "_ACCE_Label_Count");
                if (count > 0) {
                    // Reenable the facet link
                    checkbox.disabled = false;
                    if (facetValue != null) {
                        facetValue.innerHTML = count;
                    }
                    if (facetAcceValue != null) {
                        facetAcceValue.innerHTML = count;
                    }
                }
            } else if (count > 0) {
                // there is no limit to the number of facets shown, and the user has exposed the show all link
                if (byId("facet_" + id) == null) {
                    // this facet does not exist in the list.  Insert it.
                    var divContainer = $("[id^='section_list_" + group + "']")[0];
                    var grouping = $(" > ul.facetSelect", divContainer)[0];
                    if (grouping) {
                        this.facetIdsArray.push(id);
                        var newFacet = document.createElement("li");
                        newFacet.setAttribute("onclick", "SearchBasedNavigationDisplayJS.triggerCheckBox(this)");
                        var newCheckBox = document.createElement("div");
                        var newCheckMark = document.createElement("div");
                        var facetClass = "";
                        var section = "";
                        if (!multiFacet) {
                            if (image !== "") {
                                facetClass = "singleFacet";
                            }
                            // specify which facet group to collapse when multifacets are not enabled.
                            section = group;
                        }
                        if (image !== "") {
                            facetClass = "singleFacet left";
                        }
                        if (image === "") {
                            $(newCheckBox).attr("class", "checkBox");
                            $(newCheckMark).attr("class", "checkmarkMulti");
                        }
                        $(newFacet).attr("id", "facet_" + id + widget);
                        $(newFacet).attr("class", facetClass);
                        newFacet.setAttribute("data-additionalvalues", "More")
                        var facetLabel = "<label for='" + id + "'>";
                        if (image !== "") {
                            facetLabel = facetLabel + "<span class='swatch'><span class='outline'><span id='facetLabel_" + id + "'><img src='" + image + "' title='" + label + "' alt='" + label + "'/></span> <div class='facetCountContainer'>(<span id='facet_count" + id + "'>" + count + "</span>)</div>";
                        } else {
                            facetLabel = facetLabel + "<span class='outline'><span id='facetLabel_" + id + "'>" + label + "</span> (<span id='facet_count" + id + "'>" + count + "</span>)</span>";
                        }
                        facetLabel = facetLabel + "<span class='spanacce' id='" + id + "_ACCE_Label'>" + label + " (" + count + ")</span></label>";
                        newFacet.innerHTML = "<input type='checkbox' aria-labelledby='" + id + "_ACCE_Label' id='" + id + "' value='" + value + "' onclick='javascript: SearchBasedNavigationDisplayJS.setEnabledShowMoreLinks(this, \"morelink_" + group + "\");SearchBasedNavigationDisplayJS.toggleSearchFilter(this, \"" + id + "\");'/>" + facetLabel;

                        var clearFloat = $(" > div.clear_float", grouping)[0];
                        if (clearFloat != undefined) {
                            grouping.removeChild(clearFloat);
                        }
                        grouping.appendChild(newFacet);
                        if (image === "") {
                            newFacet.appendChild(newCheckBox);
                            newCheckBox.appendChild(newCheckMark);
                        }
                    }
                }
            }
        },

        triggerCheckBox: function(elem) {
            var inputBox = elem.children[0];
            inputBox.click();
        },

        cleanUpAddedFacets: function() {
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var removeFacet = true;
                for (var j = 0; j < this.facetFromRest.length; j++) {
                    if (this.facetIdsArray[i] == this.facetFromRest[j]) {
                        removeFacet = false;
                        break;
                    }
                }
                if (removeFacet) {
                    var elem = byId("facet_" + this.facetIdsArray[i]);
                    if (elem != null) {
                        elem.parentNode.removeChild(elem);
                    }
                }
            }
        },

        setEnabledShowMoreLinks: function(element, section_id) {
            if (element.checked) {
                this.selectedFacetLimitsArray.push(section_id + "|" + element.id + "|" + element.value);
                this.removeShowMoreFromFacetLimitArray(section_id);
            } else {
                var index = this.selectedFacetLimitsArray.indexOf(section_id + "|" + element.id + "|" + element.value);
                if (index > -1) {
                    this.selectedFacetLimitsArray.splice(index, 1);
                }
            }
        },



        isValidNumber: function(n) {
            var valueToParse = n;
            valueToParse = valueToParse.replace(/^\s+|\s+$/g, "");
            valueToParse = valueToParse.replace(/\xa0/g, '');
            var valueToParse = valueToParse;

            if (Utils.getLocale() === 'ar_EG') {
                valueToParse = valueToParse.replace(',', '');
                var parsedAmountValue = Utils.round(valueToParse, 2);
            } else {
                var parsedAmountValue = Utils.round(valueToParse, 2);
            }
            return !isNaN(parsedAmountValue);
        },
        convertToInternalValue: function(val) {
            var valueToParse = val;
            valueToParse = valueToParse.replace(/^\s+|\s+$/g, "");
            valueToParse = valueToParse.replace(/\xa0/g, '');
            var valueToParse = valueToParse;

            if (Utils.getLocale() === 'ar_EG') {
                valueToParse = valueToParse.replace(',', '');
                var parsedAmountValue = Utils.round(valueToParse, 2);
            } else {
                var parsedAmountValue = Utils.round(valueToParse, 2);
            }
            return parsedAmountValue;
        },

        onGoButtonPress: function() {
            var low = $("#low_price_input").val(),
                high = $("#high_price_input").val();
            window.location.href = Utils.updateQueryStringParameter(window.location.href, {
                minPrice: low,
                maxPrice: high
            });
        },

        onPriceInput: function(event) {
            var enterPressed = (event.keyCode === KeyCodes.RETURN),
                inputValid = this.validatePriceInput(enterPressed);
            if (inputValid && enterPressed) {
                this.onGoButtonPress();
            } else {
                this.toggleGoButton(inputValid);
            }
        },

        toggleGoButton: function(enable) {
            var go = $("#price_range_go");
            if (go.length) {
                if (enable) {
                    go.attr("class", "go_button");
                    go.prop("disabled", false);
                } else {
                    go.attr("class", "go_button_disabled");
                    go.prop("disabled", true);
                }
            }
        },

        validatePriceInput: function(showErrorMsg) {
            if ($("#low_price_input").length && $("#high_price_input").length) {
                var low = $("#low_price_input").val();
                var high = $("#high_price_input").val();
                if (!this.isValidNumber(low)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("low_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else if (!this.isValidNumber(high)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("high_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else if (parseFloat(high) < parseFloat(low)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("high_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else {
                    return true;
                }
            }
            return false;
        },

        toggleShowMore: function(index, show) {
            var list = byId('more_' + index);
            var morelink = byId('morelink_' + index);
            if (list != null) {
                if (show) {
                    morelink.style.display = "none";
                    list.style.display = "inline-block";
                } else {
                    morelink.style.display = "inline-block";
                    list.style.display = "none";
                }
            }
        },

        toggleSearchFilterOnKeyDown: function(event, element, id) {
            if (event.keyCode === KeyCodes.RETURN) {
                //element.checked = !element.checked;
                this.toggleSearchFilter(element, id);
            }
        },

        toggleSearchFilter: function(element, id) {
            if (element.checked) {
                this.appendFilterFacet(id);
            } else {
                this.removeFilterFacet(id);
            }

            /*

            			if(section !== "") {
            				byId('section_' + section).style.display = "none";
            			}
            */
            this.doSearchFilter();
        },

        appendFilterPriceRange: function(currencySymbol) {

            var el = byId("price_range_input");
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "none";
            }
            /*
			byId("clear_all_filter").style.display = "block";
            
			var facetFilterList = byId("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				$(facetFilterList).attr("id", "facetFilterList");
				$(facetFilterList).attr("class", "facetSelectedCont");
				var facetFilterListWrapper = byId("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}

			var filter = byId("pricefilter");
			if(filter == null) {
				filter = document.createElement("li");
				$(filter).attr("id", "pricefilter");
				$(filter).attr("class", "facetSelected");
				facetFilterList.appendChild(filter);
			}
			var label = currencySymbol + byId("low_price_input").value + " - " + currencySymbol + $("#high_price_input").val();
			filter.innerHTML = "<a role='button' href='#' onclick='wcTopic.publish(\"Facet_Remove\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span><div class='clear_float'></div></div></a>";

			byId("clear_all_filter").style.display = "block";
            */
            if (this.validatePriceInput()) {
                // Promote the values from the input boxes to the internal inputs for use in the request.
                byId("low_price_value").value = this.convertToInternalValue(byId("low_price_input").value);
                byId("high_price_value").value = this.convertToInternalValue(byId("high_price_input").value);
            }

        },

        removeFilterPriceRange: function() {
            console.error("should not be calling this");
            /*
			if($("#low_price_value").length && $("#high_price_value").length) {
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

			this.doSearchFilter(); */
        },

        appendFilterFacet: function(id) {
            var facetFilterList = byId("facetFilterList");
            // create facet filter list if it's not exist
            if (facetFilterList == null) {
                facetFilterList = document.createElement("ul");
                $(facetFilterList).attr("id", "facetFilterList");
                $(facetFilterList).attr("class", "facetSelectedCont");
                var facetFilterListWrapper = byId("facetFilterListWrapper");
                facetFilterListWrapper.appendChild(facetFilterList);
            }

            var filter = byId("filter_" + id);
            // do not add it again if the user clicks repeatedly
            if (filter == null) {
                filter = document.createElement("li");
                $(filter).attr("id", "filter_" + id);
                $(filter).attr("class", "facetSelected");
                var label = byId("facetLabel_" + id).innerHTML;
                var acceRemoveLabel = "<span class='spanacce' id='ACCE_Label_Remove'>" + MessageHelper.messages['REMOVE'] + "</span>";

                filter.innerHTML = "<a role='button' href='#' onclick='javascript:setCurrentId(\"" + id + "\");wcTopic.publish(\"Facet_Remove\", \"" + id + "\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span>" + acceRemoveLabel + "<div class='clear_float'></div></div></a>";

                facetFilterList.appendChild(filter);
            }

            $("#facetLabel_" + id).parent().attr("class", "outline facetSelectedHighlight");

            var el = byId(id);
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "none";
            }
            byId("clear_all_filter").style.display = "block";

        },

        removeFilterFacet: function(id) {
            var facetFilterList = byId("facetFilterList");
            var filter = byId("filter_" + id);
            if (filter != null) {
                var value = byId(id).value;
                var section_id = value.split("%3A%22")[0];
                var index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);

                if (index == -1) {
                    value = value.replace(/%3A/g, ":");
                    value = value.replace(/%22/g, '"');
                    index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);
                }

                if (index > -1) {
                    this.selectedFacetLimitsArray.splice(index, 1);
                }
                facetFilterList.removeChild(filter);
                //byId(id).checked = false;
            }

            if (facetFilterList != null && facetFilterList.childNodes.length == 0) {
                byId("clear_all_filter").style.display = "none";
                byId("facetFilterListWrapper").innerHTML = "";
            }

            $("#facetLabel_" + id).parent().attr("class", "outline");

            var el = byId(id);
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "block";
            }
            this.doSearchFilter();
        },

        getEnabledProductFacets: function() {
            var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
            var elementArray = facetForm.elements;

            var facetArray = [];
            var facetIds = [];
            if (_searchBasedNavigationFacetContext != 'undefined') {
                for (var i = 0; i < _searchBasedNavigationFacetContext.length; i++) {
                    facetArray.push(_searchBasedNavigationFacetContext[i]);
                    //facetIds.push();
                }
            }
            var facetLimits = [];
            for (var i = 0; i < elementArray.length; i++) {
                var element = elementArray[i];
                if (element.type != null && element.type.toUpperCase() == "CHECKBOX") {
                    if (element.title == "MORE") {
                        // scan for "See More" facet enablement.
                        if (element.checked) {
                            facetLimits.push(element.value);
                        }
                    } else {
                        // disable the checkbox while the search is being performed to prevent double clicks
                        //element.disabled = true;
                        if (element.checked) {
                            facetArray.push(element.value);
                            facetIds.push(element.id);
                        }
                    }
                }
            }
            // disable the price range button also
            if ($("#price_range_go").length) {
                byId("price_range_go").disabled = true;
            }

            var results = [];
            results.push(facetArray);
            results.push(facetLimits);
            results.push(facetIds);
            return results;
        },

        /**
         * @param clickedFacet the facet that was clicked
         */
        onFacetClick: function(clickedFacet) {
            console.error("deprecated: should not call this function");
            /*
			var minPrice = "",
                maxPrice = "";

			if(Utils.idExists("low_price_value", "high_price_value")) {
				minPrice = $("#low_price_value").val();
				maxPrice = $("#high_price_value").val();
			}
			if(minPrice === '' && maxPrice === '')
			{
				minPrice = window.initialMinPrice;
				maxPrice = window.initialMaxPrice;
			}
			
            var facetArray = this.getEnabledProductFacets(),
                $clickedFacet = $(clickedFacet),
                url = $clickedFacet.attr('href')
            url = Utils.updateQueryStringParameter(url, {
                "productBeginIndex": "0", 
                "facet": [$("input[type='checkbox']", $clickedFacet.parent()).val()], 
                "facetLimit": [], 
                "facetId": [$clickedFacet.data("for")], 
                "resultType":"products", 
                "minPrice": minPrice, 
                "maxPrice": maxPrice
            });
            $clickedFacet.attr('href', url)
            console.log(url);*/
            /*
			wcRenderContext.updateRenderContext('searchBasedNavigation_context', );
			*/

        },

        addShowMoreToFacetLimitArray: function(id) {
            // only add if no child facet is selected (i.e. no child is found in selectedFacetLimitsArray
            var childExist = false;
            for (var i = 0; i < this.selectedFacetLimitsArray; i++) {
                if (this.selectedFacetLimitsArray[i].indexOf(id) !== -1) {
                    childExist = true;
                    break;
                }
            }
            if (!childExist) {
                var index = id.indexOf(":");
                if (index != -1) {
                    id = id.substr(0, index);
                }
                this.selectedFacetLimitsArray.push("morelink_" + id);
            }
        },

        removeShowMoreFromFacetLimitArray: function(id) {
            var cIndex = id.indexOf(":");
            if (cIndex != -1) {
                id = id.substr(0, cIndex);
            }
            if (id.indexOf("morelink_") === -1) {
                id = "morelink_" + id;
            }
            var index = this.selectedFacetLimitsArray.indexOf(id);
            if (index != -1) {
                this.selectedFacetLimitsArray.splice(index, 1);
            }
        },

        toggleShowMore: function(element, id) {
            var label = byId("showMoreLabel_" + id);
            var divContainer = $("[id^='section_list_" + id + "']")[0];
            var grouping = $(" > ul.facetSelect > li[data-additionalvalues]", divContainer);
            if (element.checked) {
                this.addShowMoreToFacetLimitArray(element.value);
                label.innerHTML = this.lessMsg;
                var group = $(" > ul.facetSelect", divContainer)[0];
                var clearFloat = $(" > div.clear_float", group)[0];
                if (clearFloat != undefined) {
                    group.removeChild(clearFloat);
                }
                grouping.css("display", "");
            } else {
                this.removeShowMoreFromFacetLimitArray(element.value);
                grouping.css("display", "none");
                label.innerHTML = this.moreMsg;
            }
            this.doSearchFilter();
        },


        clearAllFacets: function(execute) {
            console.error("deprecated: do not call this function");
            /*
			byId("clear_all_filter").style.display = "none";
			byId("facetFilterListWrapper").innerHTML = "";
			if($("#low_price_value").length && $("#high_price_value").length) {
				byId("low_price_value").value = "";
				byId("high_price_value").value = "";
			}

			var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					//element.checked = false;
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
						$(element).parent().attr("class", "outline");
					}
				}
			}

			if(execute) {
				this.doSearchFilter();
				this.selectedFacetLimitsArray = [];
			}*/
        },

        updateContextProperties: function(contextId, properties) {
            //Set the properties in context object..
            for (key in properties) {
                wcRenderContext.getRenderContextProperties(contextId)[key] = properties[key];
            }
        },

        toggleView: function(data) {

            console.error("deprecated: do not call this function");
            /*
			var pageView = data["pageView"];
			setCurrentId(data["linkId"]);
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("pageView = "+pageView+" controller = +searchBasedNavigation_controller");
			wcRenderContext.updateRenderContext('searchBasedNavigation_context', {"pageView": pageView,"resultType":"products", "enableSKUListView":data.enableSKUListView});
			MessageHelper.hideAndClearMessage();*/
        },

        toggleExpand: function(id) {
            var icon = byId("icon_" + id);
            var section_list = byId("section_list_" + id);
            if (icon.className == "arrow") {
                icon.className = "arrow arrow_collapsed";
                $(section_list).attr("aria-expanded", "false");
                section_list.style.display = "none";
            } else {
                icon.className = "arrow";
                $(section_list).attr("aria-expanded", "true");
                section_list.style.display = "block";
            }
        },

        sortResults: function(orderBy) {
            console.error("should not be calling this");
        },

        swatchImageClicked: function(id) {
            // This is a workaround for IE's bug for non-clickable label images.
            var e = byId(id);
            if (!e.checked) {
                e.click();
            }
        },

        clone: function(masterObj) {
            console.error("should not be calling this");
        }
    };
}
