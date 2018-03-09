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

function ShoppingListJS(storeParams, catEntryParams, shoppingListNames, jsObjectName) {

	this.storeParams = storeParams;

	this.catEntryParams = catEntryParams;

	this.catEntryParams.quantity = 1;

	this.shoppingListNames = shoppingListNames;

	this.addItemAfterCreate = false;

	this.jsObjectName = jsObjectName;

	this.dropDownVisible = false;

	this.dropDownInFocus = false;

	this.dropDownOpen = false;

	this.exceptionFlag = false;

	this.mouseOnArrow = false;

	this.pageName = "";

	this.itemId = -1;

	var eventName = "";

	/**
	 * Keep track of the wish list name that is to be deleted. This is needed only for the my account personal wish
	 * list management UI.
	 **/
	this.nameToDelete = "";

	/**
	 * Keep track of the orderItemId that is to be deleted from the shopping cart after successfully adding an item to the
	 * wish list. This is needed only for the shopping cart and checkout related UI that uses this button code.
	 **/
	this.orderItemId = "";

	/**
	 * Keep track of the current action being performed by this button widget. This action is needed when there are several
	 * same button widgets in the same page such as the shopping cart page UI. We need to know which button is actually doing
	 * actions so that we know when to display success dialogs. Otherwise, all buttons display success dialogs.
	 **/
	this.actionBeingPerformed = "";

	if(jsObjectName != 'shoppingListJS'){
		this.pageName = jsObjectName.replace('shoppingListJS', '');
		eventName = this.pageName + "_";
	}

	/**
	 * Setter for catEntryQuantity
	 *
	 * @param {Integer} catEntryQuantity
	 */
	this.setCatEntryQuantity = function(catEntryQuantity){
        	var catEntryQuantity = $.parseJSON(catEntryQuantity);
		// If the quantity is an object
        	if ($.isPlainObject(catEntryQuantity)) {
			var component = this.catEntryParams.components[catEntryQuantity.baseItemId];
			// component is a product and a new sku is available
			if(component.id != catEntryQuantity.baseItemId && catEntryQuantity.id !=0){
				component.id = catEntryQuantity.id;
			}
			component.quantity = catEntryQuantity.quantity;
		// If the quantity is a single value
		} else {
			this.catEntryParams.quantity = catEntryQuantity;
		}
	};

	/**
	 * Setter for catEntryAttributes
	 *
	 * @param {Integer} catEntryAttributes
	 */
	this.setCatEntryAttributes = function(catEntryAttributes){
        	this.catEntryParams.attributes = $.parseJSON(catEntryAttributes);
	};

	/**
	 * Setter for itemId
	 *
	 * @param {Integer} catEntryId
	 */
	this.setItemId = function(catEntryId){
		this.itemId = catEntryId;
	};

	/**
	 * Hides the dropdown with shopping list names if it exists
	 */
	this.hideDropDown = function() {
        	var dropDown = $('#' + this.pageName + 'shoppingListDropDown');
		if (dropDown) {
	            	$(dropDown).css('display', 'none');
	            	$("#" + this.pageName + "addToShoppingListBtn .drop").first().focus();
			this.dropDownVisible = false;
			this.dropDownInFocus = false;
			this.dropDownOpen = false;

            		var contentRightBorder = $(".widget_quick_info_popup .content_right_border").first();
			if (contentRightBorder != undefined) {
                		$(contentRightBorder).css('height', 'auto');
			}
		}
	};

	/**
	 * Shows the dropdown with shopping list names & a create a new shopping list link - if authenticated
	 * If not authenticated, redirects user to login page
	 */
	this.showDropDown = function() {
		if(this.dropDownOpen == false){
            var contentRightBorder = $(".widget_quick_info_popup .content_right_border").first();
            var ocontentRightBorderH = $(contentRightBorder).height();
            var dropDown = ('#' + this.pageName + 'shoppingListDropDown');
            $(dropDown).css('display', '');
			this.dropDownVisible = true;

            $("#" + this.pageName + "shoppingListDropDown.dropdown_list div").removeClass("focused");

            if ($("#quickInfoRefreshArea") && $("#QuickInfoshoppingListDropDown")) { // check if dropdown is shown in a QuickInfo popup
                var quickInfoRefreshAreaH = $("#quickInfoRefreshArea").height();
                var shoppingListDropDownH = $("QuickInfoshoppingListDropDown").height();
                var contentRightBorderH = $(contentRightBorder).height();
			}
			this.dropDownOpen = true;
		}
		else{
			this.hideDropDown();
		}
	};

	/**
	 * Show appropriate popups to create, update or delete Shopping List
	 *
	 * @param {String}
	 *            action type of popup to be shown (create, update or delete)
	 */
	this.showPopup = function(action){
		this.hideDropDown();
		this.clearPopupText();
		var popup = $("#" + this.pageName + action + "ShoppingListPopup").data("wc-WCDialog");
		var newListName = $("#" + this.pageName + "newListName");
		popup.option("close_on_primary_click", false);
		this.hideErrorMessage();
		this.hideEditErrorMessage();
		if (popup) {            
			closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this.
			popup.close();//close all popups
			// Add a delay to showing the popup to give closeAllDialogs() a bit of time to do it's job
			setTimeout(function() {
				popup.open();
				if (action === 'create') {
					$(newListName).focus();
				} else if (action === 'edit') {
					$("#editListName").focus();
				}
			}, 250);
		}else {
			console.debug(action+"ShoppingListPopup"+" does not exist");
		}
	};

	/**
	 * Method to display message dialog on successful creation of shopping list.
	 *
	 */
	 this.showSuccessDialog = function(){
		var popup = $("#" + this.pageName + "shoppingListCreateSuccessPopup").data("wc-WCDialog");
		if (popup && this.actionBeingPerformed !== "") {
			$("#" + this.pageName + "successMessageAreaText").html(Utils.getLocalizationMessage('LIST_CREATED'));
			popup.open();
			this.actionBeingPerformed = "";
		}
	 };

	/**
	 * Method to display message dialog on successful creation of shopping list.
	 *
	 */
	 this.showMessageDialog = function(message){
		var popup = $("#" + this.pageName + "shoppingListCreateSuccessPopup").data("wc-WCDialog");

		if (popup) {
			$("#" + this.pageName + "successMessageAreaText").html(message);
			popup.open();
		}
	 };
	 
	/**
	 * Method to close/hide message dialog on successful creation of shopping list.
	 *
	 */
	this.hideMessageDialog = function(){
		var popup = $("#" + this.pageName + "shoppingListCreateSuccessPopup").data("wc-WCDialog");

		if (popup) {
			popup.close();
		}
	};

	/**
	 * Method to display error message pertaining to shopping list
	 * @param (string) msg The error/information message to be displayed
	 *
	 */
	this.showErrorMessage = function(msg){
		if(document.getElementById(this.pageName + "shoppingListErrorMessageArea") && document.getElementById(this.pageName + "shoppingListErrorMessageText")){
			document.getElementById(this.pageName + "shoppingListErrorMessageText").innerHTML = msg;
			document.getElementById(this.pageName + "shoppingListErrorMessageArea").style.display = "block";
		}
	};

	/**
	 * Method to hide error message display area
	 *
	 */
	this.hideErrorMessage = function(){
		if(document.getElementById(this.pageName + "shoppingListErrorMessageArea") && document.getElementById(this.pageName + "shoppingListErrorMessageText")){
			document.getElementById(this.pageName + "shoppingListErrorMessageText").innerHTML = "";
			document.getElementById(this.pageName + "shoppingListErrorMessageArea").style.display = "none";
		}
	};

	/**
	 * Method to display error message pertaining to change shopping list name
	 * @param (string) msg The error/information message to be displayed
	 *
	 */
	this.showEditErrorMessage = function(msg){
		if(document.getElementById("editShoppingListErrorMessageArea") && document.getElementById("editShoppingListErrorMessageText")){
			document.getElementById("editShoppingListErrorMessageText").innerHTML = msg;
			document.getElementById("editShoppingListErrorMessageArea").style.display = "block";
		}
	};

	/**
	 * Method to hide error message display area from the change shopping list name dialog
	 *
	 */
	this.hideEditErrorMessage = function(){
		if(document.getElementById("editShoppingListErrorMessageArea") && document.getElementById("editShoppingListErrorMessageText")){
			document.getElementById("editShoppingListErrorMessageText").innerHTML = "";
			document.getElementById("editShoppingListErrorMessageArea").style.display = "none";
		}
	};

	/**
	 * Method to create a new shopping list
	 *
	 */
	this.create = function(){
		// picks the new shopping list name and trims it
        var name = trim($("#" + this.pageName + "newListName").val());
        var maxlength = $("#" + this.pageName + "newListName").maxLength;
		var defaultName = Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME');

		if (this.empty(name)) {
			// display error message saying list name is empty.
			this.showErrorMessage(Utils.getLocalizationMessage('ERR_NAME_EMPTY'));
		} else if(!MessageHelper.isValidUTF8length(name, maxlength)){
			// check for max length
			this.showErrorMessage(Utils.getLocalizationMessage('ERR_NAME_TOOLONG'));
		} else if(name == defaultName) {
			// show error message saying that DEFAULT cannot be used
			this.showErrorMessage(Utils.getLocalizationMessage('ERR_NAME_SHOPPING_LIST'));
		} else if(this.isDuplicate(name)){
			// show error message saying that a wish list with the same name already exists
			this.showErrorMessage(Utils.getLocalizationMessage('ERR_NAME_DUPLICATE'));
		} else if(!this.validateWishName(name)){
			// show error message saying that wish list name is invalid
			this.showErrorMessage(Utils.getLocalizationMessage('INVALID_NAME_SHOPPING_LIST'));
		} else {
			var params = this.setCommonParams();
			params.name = name;

			// For Handling multiple clicks.
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			// calling the service to save the new list name
			wcService.invoke('ShoppingListServiceCreate',params);
			this.actionBeingPerformed = "create";
		}
	};

	/**
	 * Creates the default shopping list with name 'Wish List' and adds the displayed item to this list.
	 * If the default shopping list is already created, just adds the item to the existing list.
	 * Also, redirects the user to login page if not authenticated.
	 *
	 * @param {Integer} listId - id of the default shopping list if present, else -1 is passed
	 */
	this.createDefaultListAndAddItem = function(listId, orderItemId, focusElement){
		if (orderItemId && orderItemId != "") {
			this.orderItemId = orderItemId;
		}

		if("-1" == listId){
			var params = this.setCommonParams();
			params.name = Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME');

			// For Handling multiple clicks.
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			this.addItemAfterCreate = true;
			// calling the service to save the new list name
			wcService.invoke('ShoppingListServiceCreate',params);
		} else {
			if (orderItemId && orderItemId != "") {
				this.addToListAndDelete(listId, orderItemId, focusElement);
			} else {
				this.addToList(listId, focusElement);
			}
		}
	};

	/**
	 * add an item/product/bundle/package to a wish list
	 *
	 * @param {string}
	 *            listId id of the item/product/bundle/package be
	 *            added
	 */
	this.addToList = function(listId, focusElement){
		this.hideDropDown();

		var params = this.setCommonParams();
		params.giftListId = listId;

		var catEntryId = this.catEntryParams.id;
		//Add the parent product to the cart.
		if(this.catEntryParams.type.toLowerCase() == 'itembean'
			|| this.catEntryParams.type.toLowerCase() == 'packagebean'
			|| this.catEntryParams.type.toLowerCase() == 'preddynakitbean'
			|| this.catEntryParams.type.toLowerCase() == 'dynamickitbean'){
			updateParamObject(params,"catEntryId",this.catEntryParams.id,false,-1);
			updateParamObject(params,"quantity",this.catEntryParams.quantity,false,-1);
		} else if (this.catEntryParams.type.toLowerCase() == 'bundlebean') {
			// Add items in the bundle
			var resolved = true;
			for (baseItemId in this.catEntryParams.components) {
				if (this.catEntryParams.components[baseItemId].skus && this.catEntryParams.components[baseItemId].skus.length > 1) {
					// If component has multiple SKUs, meaning defining attributes
					var resolvedValue = this.catEntryParams.components[baseItemId].resolved;
					if (resolvedValue == null || resolvedValue == "undefined" || resolvedValue == false) {
						// If any component is unresolved (ie. attributes not selected), do not allow adding to the list
						resolved = false;
						break;
					}
				}
			}
			if (!resolved) {
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
				return;
			}
			else {
				for(baseItemId in this.catEntryParams.components){				
					updateParamObject(params,"catEntryId",this.catEntryParams.components[baseItemId].id,false,-1);
					updateParamObject(params,"quantity",this.catEntryParams.components[baseItemId].quantity,false,-1);
				}
			}
		} else {
			// Resolve ProductBean to an ItemBean based on the attributes in the main page
			var sku = this.itemId;
			if (sku == -1){
				sku = this.resolveSKU();
			}
			if(-1 == sku){
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
				return;
			} else {
				catEntryId = sku;
				updateParamObject(params,"catEntryId",sku,false,-1);
				updateParamObject(params,"quantity",this.catEntryParams.quantity,false,-1);
			}
		}
		if(this.jsObjectName != 'shoppingListJS'){
			QuickInfoJS.close();
		}

		// For Handling multiple clicks.
		if(!submitRequest()){
			return;
		}

		cursor_wait();
		ShoppingListDialogJS.setDialogParams(this.storeParams, {catEntryId:catEntryId, thumbnail: 'imgPath', focusElement: focusElement});
		wcService.invoke('ShoppingListServiceAddItem',params);

	};

	/**
	 * Checks if shopping list name already exists
	 *
	 * @param {String} listName, name of the shopping list to be created
	 * @return {Boolean} true, if a duplicate is present
	 * 					 false, if no duplicates present
	 */
	this.isDuplicate = function(listName) {
		var listName = this.escapeXml(listName, true);
		return (this.shoppingListNames[listName.toUpperCase()] == 1);
	};

	/**
	 * Updates the dom object representing the default shopping list with onclick function and also updates the shopping list
	 *
	 * @param {Integer} listId, default shopping list id
	 */
    	this.updateDefaultListId = function(listId){
		this.shoppingListNames[Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME')] = 1;
    		if ($('#'+this.pageName+'addToShoppingList')) {
    			$('#'+this.pageName+'addToShoppingList').attr('href' ,'"javascript:" + this.jsObjectName + ".createDefaultListAndAddItem(" + listId + ");"');
		}
    	};

	/**
	 * Adds an entry in shopping list dropdown. Also updates the shopping list names with the new name.
	 *
	 * @param {Integer} listId, id of the new shopping list that got created
	 * @param {String} listName, name of the new shopping list that got created
	 */
	this.updateShoppingList = function(listId, listName, action){
		var listNameEsc = this.escapeXml(listName, false);
		this.shoppingListNames[listNameEsc.toUpperCase()] = 1;

		if (action && (action == 'edit' || action == 'delete')) {
			this.shoppingListNames[this.nameToDelete.toUpperCase()] = -1;
		}

        var dropdownWidgetNode = $('#' + this.pageName + 'ShoppingListDivider');
        if (dropdownWidgetNode) {
            var eventHandlerString = "javascript: this.className = 'created_list';";

            if (this.pageName.indexOf("OI") == -1) {
                $('#' + this.pageName + 'ShoppingListDivider').before('<div role="menuitem" id="' + this.pageName + 'ShoppingList_' + listId + '" class="created_list" onfocus="javascript:' + jsObjectName + '.focusList(\'' + listId +
                    '\'); "  onblur="' + eventHandlerString + '" onclick="javascript:' + jsObjectName + '.addToList(\'' + listId +
                    '\');"><a role="menuitem" id="' + this.pageName + 'ShoppingListLink_' + listId + '" href="javascript:' + jsObjectName + '.addToList(\'' + listId +
                    '\');" onfocus="javascript:' + jsObjectName + '.focusListLink(\'' + listId + '\');">' + listName + '</a></div>');
            } else {
                var oiId = this.pageName.replace("OI", "");
                $('#' + this.pageName + 'ShoppingListDivider').before('<div role="menuitem" id="' + this.pageName + 'ShoppingList_' + listId + '" class="created_list" onfocus="javascript:' + jsObjectName + '.focusList(\'' + listId +
                    '\'); "  onblur="' + eventHandlerString + '" onclick="javascript:' + jsObjectName + '.addToListAndDelete(\'' + listId +
                    '\',\'' + oiId + '\');"><a role="menuitem" id="' + this.pageName + 'ShoppingListLink_' + listId + '" href="javascript:' + jsObjectName + '.addToListAndDelete(\'' + listId +
                    '\',\'' + oiId + '\');" onfocus="javascript:' + jsObjectName + '.focusListLink(\'' + listId + '\');">' + listName + '</a></div>');
            }
        }
    };

	/**
	 * Clears the textbox in the popup
	 */
	this.clearPopupText = function(){
        $("#" + this.pageName + "newListName").val("");
	};

	/**
	 * Converts & < > " ' to xml accepted form
	 *
	 * @param {String} str, String to be converted
	 * @param {Boolean} fullConversion, if true converts & < > " ' chars
	 * 									if false converts only " ' chars
	 *
	 * @return {String} converted string
	 */
	this.escapeXml = function(str, fullConversion){
		if(fullConversion){
			str = str.replace(/&/gm, "&amp;").replace(/</gm, "&lt;").replace(/>/gm, "&gt;");
		}
		str = str.replace(/"/gm, "&#034;").replace(/'/gm, "&#039;");
		return str;
	};

	 /**
	  * Based on the selected attributes, resolve the SKU of the product.
	  *
	  * @return {Integer} uniqueId of the SKU
	  */
	 this.resolveSKU = function() {
		// if there is only one sku, no need to resolve.
		if(this.catEntryParams.skus.length == 1){
			return this.catEntryParams.skus[0].id;
		}
		for (idx = 0; idx < this.catEntryParams.skus.length; idx++) {
			var matches = 0;
			var attributeCount = 0;
			// iterate through each attribute
			for (attribute in this.catEntryParams.skus[idx].attributes) {
				attributeCount++;
				// check for matches
				if (this.catEntryParams.attributes
						&& this.catEntryParams.skus[idx].attributes[attribute] == this.catEntryParams.attributes[attribute]) {
					matches++;
				} else {
					break;
				}
			}
			// if all the attributes match, pick that SKU
			if (0 != matches && matches == attributeCount) {
				return this.catEntryParams.skus[idx].id;
			}
		}
		// no match found
		return -1;
	};

	/**
	 * Sets the store specific values such as storeId, catalogId and langId in a Object and returns it.
	 *
	 * @return {Object} params with store specific values
	 */
	this.setCommonParams = function(){
		var params = {};
		params.storeId		= this.storeParams.storeId;
		params.catalogId	= this.storeParams.catalogId;
		params.langId		= this.storeParams.langId;
		return params;
	};

	/**
	 * Checks if the string is null, undefined or empty
	 *
	 * @param {String} str, value to be checked
	 * @return {Boolean} true, if empty
	 * 					 false, if not empty
	 */
	this.empty = function(str) {
		return (str == null || str == undefined || str == "");
	};

	/**
	 * redirect users to the sign on page
	 */
	this.redirectToSignOn = function() {
		// 3 scenario's are possible
		/* 
		*	Scenario 1 - Current Page Loaded with HTTP
		*				 In this case, the page will be reloaded with HTTPS and globalLogIn panel is opened up.
		*				 GlobalLoginJS.updateGlobalLoginSignInContent does this work and uses WC_RedirectToPage_xxx cookie to
		*				 identify the page to display after logIn.
		*   Scenario 2 - Current page is loaded with HTTPS and signIn panel is already loaded.
		*				 In this case, before displayiong signIn panel, update the URL field value of the signIn panel form.
		*	Scenario 3 - Current page is laoded with HTTPS, but signIn panel is NOT yet loaded.
		*				 Ajax call is made to load the panel. Send reload URL as part of the ajax call, based on WC_RedirectToPage_xxx cookie value.
		*/
		var currentURL = document.location.href;
		var widgetId = 'Header_GlobalLogin'; // This widgetId is defined in Header_UI.jspf / GlobalLoginActions.js / UserTimeoutView.jsp
		setCookie("WC_RedirectToPage_"+WCParamJS.storeId, currentURL , {path:'/', domain:cookieDomain});			
		GlobalLoginJS.InitHTTPSecure(widgetId);
	};


	/**
	 * changes the style class to show which shopping list is currently focused
	 */
	this.focusList = function(listId){
		this.focusListByElementId(this.pageName + "ShoppingList_" +listId);
	};

	/**
	 * changes the style class to show which shopping list is currently focused
	 */
	this.focusListByElementId = function(elementId){
        if ($("#" + elementId).hasClass("focused")) {
			return;
		}
        $("#" + elementId.replace("ShoppingList", "ShoppingListLink")).focus();

	};

	/**
	 * changes the style class to show which shopping list is currently focused
	 */
	this.focusListLink = function(listId){
        $("#" + this.pageName + "shoppingListDropDown.dropdown_list div").removeClass("focused");
        $("#" + this.pageName + "ShoppingList_" + listId).addClass("focused");
	};

	this.updateShoppingListAndAddItem = function(serviceResponse){
		if(serviceResponse.listName == Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME')){
			this.updateDefaultListId(serviceResponse.listId);
		} else {
			this.updateShoppingList(serviceResponse.listId, serviceResponse.listName, serviceResponse.action);
		}

		if(this.addItemAfterCreate){
			this.addItemAfterCreate = false;
			if (this.orderItemId != "") {
				this.addToListAndDelete(serviceResponse.listId, this.orderItemId);
			} else {
				this.addToList(serviceResponse.listId);
			}
		} else {
			if (serviceResponse.action == 'add') {
				this.showSuccessDialog();
			}
		}
	};

	this.navigateDropDown = function(event){
		var shoppingListObj = this;
		if (event.keyCode === KeyCodes.UP_ARROW) {
			Utils.stopEvent(event);

			var focusChanged = false;
			var dropdownList = $( "#" + shoppingListObj.pageName + "shoppingListDropDown.dropdown_list div.created_list" );
			dropdownList.each(function (index, element) {                				
				if (!focusChanged && ($(element).hasClass("focused"))) {
					if(0 == index){
						shoppingListObj.focusListByElementId($(dropdownList).get(dropdownList.length-1).id);
					} else {
						shoppingListObj.focusListByElementId($(dropdownList).get(index-1).id);
					}
					focusChanged = true;
				}
			});
		} else if (event.keyCode === KeyCodes.DOWN_ARROW) {
			Utils.stopEvent(event);

			var focusChanged = false;
			var dropdownList = $("#" + shoppingListObj.pageName + "shoppingListDropDown.dropdown_list div.created_list");
			dropdownList.each(function (index, element) {
				if (!focusChanged && ($(element).hasClass("focused"))) {
					if(dropdownList.length-1 == index){
						shoppingListObj.focusListByElementId($(dropdownList).get(0).id);
					} else {
						shoppingListObj.focusListByElementId($(dropdownList).get(index+1).id);
					}
					focusChanged = true;
				}
			});
		} else if (event.keyCode === KeyCodes.ESCAPE || event.keyCode === KeyCodes.TAB) {
			Utils.stopEvent(event);
			this.hideDropDown();
		}
	};

	this.hideIfNoFocus = function(){
		if(this.dropDownVisible && !this.dropDownInFocus && !this.mouseOnArrow){
			this.hideDropDown();
		}
	};

	this.hasFocus = function(event){
		$(document).on("contextmenu", function (event) {
			if (event.which == 1) {
				this.dropDownInFocus = true;
			} else {
				this.dropDownInFocus = false;
			}
		});
	};


	/**
	 * Method to update the name of an existing shopping list
	 *
	 */
	this.edit = function(){
		// picks the new shopping list name and trims it
                    var name = trim($("#editListName").val());
		var maxlength = name.maxLength;
		var defaultName = Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME');

		if (this.empty(name)) {
			// display error message saying list name is empty.
			this.showEditErrorMessage(Utils.getLocalizationMessage('ERR_NAME_EMPTY'));
		} else if(!MessageHelper.isValidUTF8length(name, maxlength)){
			// check for max length
			this.showEditErrorMessage(Utils.getLocalizationMessage('ERR_NAME_TOOLONG'));
		} else if(name == defaultName) {
			// show error message saying that DEFAULT cannot be used
			this.showEditErrorMessage(Utils.getLocalizationMessage('ERR_NAME_SHOPPING_LIST'));
		} else if(this.isDuplicate(name)){
			// show error message saying that DEFAULT cannot be used
			this.showEditErrorMessage(Utils.getLocalizationMessage('ERR_NAME_DUPLICATE'));
		} else if(!this.validateWishName(name)){
			// show error message saying that
			this.showErrorMessage(Utils.getLocalizationMessage('INVALID_NAME_SHOPPING_LIST'));
		} else {
			var params = this.setCommonParams();
			params.name = name;

                        var dropdown = $('#multipleWishlistController_select');
			if((dropdown != null && dropdown != 'undefined') && dropdown.value != 0){
				// get wish list ID
                            params["giftListId"] = $("#multipleWishlistController_select").val();
                            this.nameToDelete = $('#multipleWishlistController_select options:dropdown.selectedIndex').text();
			}
                        $("#editShoppingListPopup").data("wc-WCDialog").close();
                        
                        // For Handling multiple clicks.
                        if (!submitRequest()) {
                            return;
                        }
                        cursor_wait();
                        // calling the service to save the new list name
                        wcService.invoke('ShoppingListServiceUpdate', params);
                    }
                };

	/**
	 * Method to delete an existing shopping list
	 *
	 */
	this.deleteList = function(){
		var params = this.setCommonParams();
                    var dropdown = $('#multipleWishlistController_select');
		if((dropdown != null && dropdown != 'undefined') && dropdown.value != 0){
			// get wish list ID
                        params["giftListId"] = $("#multipleWishlistController_select").val();
                        this.nameToDelete = $('#multipleWishlistController_select options:dropdown.selectedIndex').text();
		}
                    $("#deleteShoppingListPopup").data("wc-WCDialog").close();
                    
                    // For Handling multiple clicks.
                    if (!submitRequest()) {
                        return;
                    }
                    cursor_wait();
                    // calling the service to save the new list name
                    wcService.invoke('ShoppingListServiceDelete', params);
                };

	/**
	 * Method that knows how to hide or un-hide the links to delete and rename a wish list in the my account
	 * wish list select controller area.
	 *
	 */
	this.refreshLinkState = function() {
        var dropdown =$('#multipleWishlistController_select')[0];
		if (dropdown != null) {
			var wName = $('#multipleWishlistController_select')[0].options[dropdown.selectedIndex].text;
			var defaultName = Utils.getLocalizationMessage('DEFAULT_WISH_LIST_NAME');
			if (wName == defaultName) {
				//hide the delete and rename links, default wish list cannot be changed nor deleted
                        	$('#editDivider').css('display','none');
                        	$('#edit_popup_link').css('display','none');
                        	$('#deleteDivider').css('display','none');
                        	$('#delete_popup_link').css('display','none');
                        } else {
                        	$('#editDivider').css('display','block');
                        	$('#edit_popup_link').css('display','block');
                        	$('#deleteDivider').css('display','block');
                        	$('#delete_popup_link').css('display','block');
                        }
                    }
                };

	/**
	  * move an order item to the default wish list
	  * @param {string} listId id of the shopping list to add the item to
	  * @param {string} orderItemId the order item id of the item to be removed from shopping cart
	  */
	this.addToListAndDelete = function(listId, inOrderItemId, focusElement) {
		this.orderItemId = inOrderItemId;

                    wcTopic.publish("modelChanged/AnalyticsConversionEvent");

		this.hideDropDown();

		var params = this.setCommonParams();
		params.giftListId = listId;
		params["catEntryId_1"] = this.catEntryParams.id;
		params["quantity_1"] = 1;

		// For Handling multiple clicks.
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		ShoppingListDialogJS.setDialogParams(this.storeParams, {catEntryId:this.catEntryParams.id, name:this.catEntryParams.name, image:this.catEntryParams.image, thumbnail: 'imgPath', focusElement: focusElement});
		wcService.invoke('ShoppingListServiceAddItemAndRemoveFromCart',params);
	};

	/**
	 * delete an order item from the shopping cart
	*/
	this.deleteItemFromCart = function() {
		if (this.orderItemId != "") {
			var test = this.orderItemId;
			this.orderItemId = "";
			if(test != ""){
				CheckoutHelperJS.deleteFromCart(test, true);
			}
		}
	};
	/**
	 * validate the wish name
	 */
	this.validateWishName = function(wishName) {
		var invalidChars = "~!@#$%^&*()+=[]{};:,<>?/|`"; // invalid chars
		invalidChars += "\t\'\"\\\/"; // escape sequences

		// look for presence of invalid characters.  if one is
		// found return false.  otherwise return true
		for (var i=0; i<wishName.length; i++) {
		  if (invalidChars.indexOf(wishName.substring(i, i+1)) >= 0) {
			return false;
		  }
		}
		return true;
	};
	/**
	 * Indicate a catEntry component has been resolved or unresolved (attributes selected or not selected)
	 */
	this.setResolved = function(baseItemId, value) {
		this.catEntryParams.components[baseItemId].resolved = value;
	};
	
                $(document.documentElement).on("mousedown", $.proxy("hideIfNoFocus", this));
	for (baseItemId in this.catEntryParams.components) {
		// For each catEntry component, subscribe to SKU resolution
                    wcTopic.subscribe('DefiningAttributes_Resolved_' + baseItemId, function (catEntryId, productId) {
			eval(jsObjectName + ".setResolved('" + productId + "', true)");
		});
                    wcTopic.subscribe('DefiningAttributes_Changed_' + baseItemId, function (catEntryId, productId) {
			if (catEntryId == 0) {
				// Some attribute has not been selected after SKU resolution
				eval(jsObjectName + ".setResolved('" + productId + "', false)");
			}
		});
	};
}

if(typeof(ShoppingListDialogJS) == "undefined" || ShoppingListDialogJS == null || !ShoppingListDialogJS) {

	ShoppingListDialogJS = {
		storeParams: null,
		dialogParams: null,

		setDialogParams: function(storeParams, dialogParams){
			this.storeParams = storeParams;
			this.dialogParams = dialogParams;
			if(this.dialogParams.image == null || this.dialogParams.image == ''){
				// when item image is not available, we need to fetch separately
				this.fetchAddedItem();
			} else {
				// when item is moved - the ones available in cart pages
				this.displayItemAddedWithoutFetching();
			}
		},

		fetchAddedItem: function(){
			var params = this.setCommonParams();
			params.productId = this.dialogParams.catEntryId;
			params.catalogEntryId = this.dialogParams.catEntryId;

			$.ajax({
				url: getAbsoluteURL() + "GetCatalogEntryDetailsByIDView",
				method:"post",
                		dataType: "json",
                		data: params,
				success: ShoppingListDialogJS.displayItemAddedDialog,
				error: function(jqXHR, textStatus, err) {
					console.debug("QuickInfoJS.selectItem: Unexpected error occurred during an xhrPost request.");
				}
			});
		},

		displayItemAddedDialog: function(serviceResponse) {
			var itemAddedPopup = $("#shoppingListItemAddedPopup");
			if(itemAddedPopup != null){
                var data = serviceResponse.catalogEntry.description[0];
                $("#shoppingListItemAddedImg").attr("src", data.thumbnail)
                                            .attr("alt", data.name);
				$("#shoppingListItemAddedName").html(data.name);
                $("#shoppingListItemAddedPopup").data("wc-WCDialog").open();
			} else {
				console.debug("shoppingListItemAddedPopup does not exist");
			}
		},

		/**
		 * This method can be used to display "Added to Wish List" popup in cart pages
		 * because cart has only items and no products, so no need to make another call to pick item image & name
		 */
		displayItemAddedWithoutFetching: function() {
                            if ($("#shoppingListItemAddedPopup").length) {
                                $("#shoppingListItemAddedImg").attr("src", this.dialogParams.image);
                                $("#shoppingListItemAddedImg").attr("alt", this.dialogParams.name);
                                $("#shoppingListItemAddedName").html(this.dialogParams.name);
                            } else {
                                console.debug("shoppingListItemAddedPopup does not exist");
                            }
                        },

		/**
		 * show popup
		 */
		showDialog: function(){
			var itemAddedPopup = $("#shoppingListItemAddedPopup");
			if(itemAddedPopup != null){
				itemAddedPopup.data("wc-WCDialog").open();
			} else {
				console.debug("shoppingListItemAddedPopup does not exist");
			}
		},

		setCommonParams: function(){
			var params = new Object();
			params.storeId		= this.storeParams.storeId;
			params.catalogId	= this.storeParams.catalogId;
			params.langId		= this.storeParams.langId;
			return params;
		},

		close: function(){
			$("#shoppingListItemAddedPopup").hide();
			if (this.dialogParams.focusElement && this.dialogParams.focusElement != "") {
				$("#" + this.dialogParams.focusElement).focus();
			}
		}
	}
	/*
	 * itemAddedReadyForDelete applies to items in cart - since cart has only items and no products,
	 * so no need to make another call to pick item image & name
	 */
	wcTopic.subscribe("ShoppingListItem_Added", ShoppingListDialogJS.showDialog);

}
