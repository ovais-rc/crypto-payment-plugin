//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.require("wc.service.common");
dojo.require("wc.render.common");

function AddToRequisitionListsJS(storeId, catalogId, langId, dropDownMenuId, selectListMenuId, createListMenuId, listTypeMenuId, listNameFieldId, listTypeFieldId, addResultMenuId, buttonStyle, jsObjectName) {

	this.storeId = storeId
	this.catalogId = catalogId;
	this.langId = langId;
	this.dropDownMenuId = dropDownMenuId;
	this.selectListMenuId = selectListMenuId;
	this.createListMenuId = createListMenuId;
	this.listTypeMenuId = listTypeMenuId;
	this.listNameFieldId = listNameFieldId;
	this.listTypeFieldId = listTypeFieldId;
	this.addResultMenuId = addResultMenuId;
	this.buttonStyle = buttonStyle;
	
	this.jsObjectName = jsObjectName;
	
	this.dropDownVisible = false;

	this.dropDownInFocus = false;
	
	this.pageName = "";
	this.params = {};
	
	var eventName = "";
	
	this.dropDownMenuId = "";
	this.createListMenuId = "";
	this.addResultMenuId="";
	this.addSingleSKU = false;
	this.addBundle = false;
	this.addPDK = false;
	var product_id = 0;

	var quantity = 1; // One item to add to list by default
	var catEntryId = 0;
	
	var catEntryResolved = false;
	
	/**
	 * Re-initializes variables when product is successfully added to a list
	 */
	this._initialize = function() {
		this.someRadioButtonChecked = false;
		this.createListDetailsMenuOpen = false;
		this.listTypeMenuOpen = false;
		this.dropDownOpen = false;
		this.addSingleSKU = false;
		this.addBundle = false;
		this.params.status = 'Y'; // Default to private list
	};
	
	/**
	 * Setter for dojo.topic.subscribe callback
	 */
	this.setQuantity = function(newQuantity) {
		if(newQuantity != ''){
			quantity = newQuantity;
		}
	};
	/**
	 * Getter for dojo.topic.subscribe callback
	 */
	this.getQuantity = function() {
		return quantity;
	}
	/**
	 * Setter for dojo.topic.subscribe callback
	 */
	this.setCatEntryId = function(newCatEntryId, newProductId) {
		if (newCatEntryId != null) {
			catEntryResolved = true;
			catEntryId = newCatEntryId;
			product_id = newProductId;
		}
		else {
			catEntryResolved = false;
		}
		
	};
	/**
	 * Getter for dojo.topic.subscribe callback
	 */
	this.getCatEntryId = function() {
		return catEntryId;
	};
	
	/**
	 * Sets product ID to be added to cart
	 */
	this.setProductId = function(newProductId) {
		product_id = newProductId;
	};
	
	/**
	 * sets whether a PDK is being added to the list
	 */
	this.setAddPDK = function(addpdk) {
		this.addPDK = addpdk;
	};
	
	/**
	 * Hides the dropdown
	 * @param dropDown - dropdown node
	 */
	this._hideDropDownMenu = function(dropDown) {
		if (dropDown) {
			dropDown.style.display = "none";
			if (dojo.byId('grayOut')) {
				dojo.byId('grayOut').style.display = "none";
			}
			if (dojo.byId('grayOutPopup')) {
				dojo.byId('grayOutPopup').style.display = "none";
			}
			this.dropDownVisible = false;
			this.dropDownInFocus = false;
			this.dropDownOpen = false;
		}
		
		if (document.removeEventListener) {
			document.removeEventListener("keydown", this.trapTabKey, true);
		}
	};
	
	/**
	 * Shows the dropdown
	 * @param dropDown - dropdown node
	 * @param resolveCatentry - if true, then catentry must be resolved before showing drop down menu
	 */
	this._showDropDownMenu = function(dropDown, resolveCatentry) {
		if (resolveCatentry && !catEntryResolved) {
			MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_RESOLVED_SKU']);
			return;
		}

		if (dropDown) {
			dropDown.style.display = "block";
			var radioButtons = dojo.query('.radioButton', dropDown);
			if (radioButtons.length > 0) {
				radioButtons[0].focus();
			}
			if (dojo.byId('grayOut')) {
				dojo.byId('grayOut').style.display = "block";
			}
			if (dojo.byId('grayOutPopup')) {
				dojo.byId('grayOutPopup').style.display = "block";
			}
			this.dropDownVisible = true;
			this.dropDownInFocus = true;
			this.dropDownOpen = true;
			MessageHelper.hideAndClearMessage();
		}
		
		if (document.addEventListener) {
			document.addEventListener("keydown", this.trapTabKey, true);
		}
	};

	/**
	 * Hides the list of requisition lists
	 */
	this._hideSelectList = function() {
		if (dojo.byId(this.selectListMenuId)) {
			dojo.byId(this.selectListMenuId).style.display = "none";
		}
	};
	
	/**
	 * Shows the list of requisition lists
	 */
	this._showSelectList = function() {
		if (dojo.byId(this.selectListMenuId)) {
			dojo.byId(this.selectListMenuId).style.display = "block";
		}
	};

	/**
	 * Traps the tab key when in the popup
	 * @event the key event
	 */
	this.trapTabKey = function(event) {
		if (event.keyCode == 9) {
			var popups = dojo.query('.requisitionListContent.popup');
			var popup = null;
			for (var i=0; i < popups.length; i++) {
				if (popups[i].offsetHeight != 0) { // visible
					popup = popups[i];
				} 
			}
			
			if (popup != null) {
				var focusableItems = dojo.query('[tabindex$=\"0\"]', popup);
				var visibleFocusableItems = [];
				for (var i=0; i < focusableItems.length; i++) {
					if (focusableItems[i].offsetHeight != 0) { // visible
						visibleFocusableItems.push(focusableItems[i]);
					} 
				}
				var focusedItem = document.activeElement;
				var numberOfFocusableItems = visibleFocusableItems.length;
		        var focusedItemIndex = visibleFocusableItems.indexOf(focusedItem);

		        if (event.shiftKey) {
		            //back tab - if focused on first item and user presses back-tab, go to the last focusable item
		            if (focusedItemIndex == 0) {
		            	event.preventDefault();
		            	visibleFocusableItems[numberOfFocusableItems - 1].focus();
		            }
		        } else {
		            //forward tab - if focused on the last item and user presses tab, go to the first focusable item
		            if (focusedItemIndex == numberOfFocusableItems - 1) {
		            	event.preventDefault();
		            	visibleFocusableItems[0].focus();
		            }
		        }
			}
	    }
	};
	
	/**
	 * Toggle showing the requisition list drop down
	 * @param showSelectList - optionally choose whether the list of requisition lists should be affected by the toggle
	 * @param resolveCatentry - optionally choose whether or not catentry needs to be resolved (defaults to true)
	 * @param multipleSKUs - optionally choose whether or not we are adding multiple SKUs (e.g. from SKU list widget)
	 * @param singleSkuId - optional single skuId being passed in from SKU list widget
 	 * @param addBundle - optionally choose whether or not we are adding a bundle
	 */
	this.toggleDropDownMenu = function(showSelectList, resolveCatentry, multipleSKUs, singleSkuId, addBundle) {
		if (resolveCatentry == null) {
			resolveCatentry = true;
		}

		// Check to make sure quantity fields are populated when adding bundle
		if (addBundle) {
			for (var productId in shoppingActionsJS.productList){
				var productDetails = shoppingActionsJS.productList[productId];
				var quantity = dojo.number.parse(productDetails.quantity);
				if (quantity == 0) {
					continue;
				}
				if(productDetails.id == 0){
					MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
					return;
				}
				if(isNaN(quantity) || quantity < 0){
					MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
					return;
				}
			}
			this.addBundle = true;
		}
		
		// Check to make sure quantity fields are populated if adding multiple SKUs
		if (multipleSKUs) {
			if (product_id in SKUListJS.quantityList) {
				var length = 0;
				for (var skuId in SKUListJS.quantityList[product_id]) {
					var quantity = SKUListJS.quantityList[product_id][skuId];
					if (!isPositiveInteger(quantity)){
						MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUTS_ERROR']);
						return;
					}
					length++;
				}
				if (length == 0) {
					MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUTS_ERROR']);
					return;
				}
			} else {
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUTS_ERROR']);
				return;
			}
		}
		
		// Check to make sure quantity field is populated when adding single SKU from SKU List widget
		if (singleSkuId) {
			var quantity = dojo.byId(singleSkuId + "_Mobile_Quantity_Input").value;
			if (!isPositiveInteger(quantity)){
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
				return;
			}
			
			this.setQuantity(quantity);
			this.addSingleSKU = true;
		}

		if (this.dropDownOpen == false) {
			this._showDropDownMenu(dojo.byId(dropDownMenuId), resolveCatentry);
		}
		else {
			this._hideDropDownMenu(dojo.byId(dropDownMenuId));
		}
		if (showSelectList == false) {
			this._hideSelectList();
		}
		else {
			this._showSelectList();
		}
	};

	/**
	 * Check a radio button
	 * @param nodeToCheck - div node ID of the radio button to check
	 * @param listId - list's ID
	 * @param radiovalue - list's name
	 */
	this.checkRadioButton = function(nodeToCheck, listId, radioValue) {
		if (nodeToCheck) {
			dojo.query(".checked", dropDownMenuId).style("display", "none");
			dojo.query(".checked", nodeToCheck).style("display", "block");
			dojo.query(".radioButton", dropDownMenuId).forEach(function(node) {
				dojo.setAttr(node, "aria-checked", "false");
			});
			dojo.setAttr(nodeToCheck, "aria-checked", "true");
			if (radioValue != undefined) {
				this.params.name = radioValue.replace(/&#039;/gm, "'");
			}
			this.params.requisitionListId = listId;
			this.someRadioButtonChecked = true;
		}
	};
	
	/**
	 * Toggle showing the create list menu
	 * @param state - state of the menu.  True = shown, false = hidden
	 */
	this.toggleCreateListDetailsMenu = function(state) {
		// Only toggle the menu when the requested state is different from the current state
		if (this.createListDetailsMenuOpen == true && state == false) {
			dojo.byId(createListMenuId).style.display = "none";
			this.createListDetailsMenuOpen = false;
			dojo.byId(this.pageName + "scrollContainer").scrollTop = dojo.byId(this.pageName + "scrollContainer").scrollHeight;
		}
		else if (this.createListDetailsMenuOpen == false && state == true) {
			dojo.byId(createListMenuId).style.display = "block";
			this.createListDetailsMenuOpen = true;
			dojo.byId(this.pageName + "scrollContainer").scrollTop = dojo.byId(this.pageName + "scrollContainer").scrollHeight;
		}
	};
	
	/**
	 * Handles a keyboard event on the list type menu
	 */
	this.handleKeyEventListTypeMenu = function(event) {
		switch (event.keyCode) {
			case 38: // up arrow
				event.preventDefault();
				if (this.params.status == 'Z') {
					this.setListType('Y');
				}
				break;
			case 40: // down arrow
				event.preventDefault();
				if (this.params.status == 'Y') {
					this.setListType('Z');
				}
				break;
		}
	}
	
	/**
	 * Toggle showing the list type menu when creating a new list
	 */
	this.toggleListTypeMenu = function() {
		if (this.listTypeMenuOpen == true) {
			dojo.byId(listTypeMenuId).style.display = "none";
			this.listTypeMenuOpen = false;
			dojo.byId(this.pageName + "scrollContainer").scrollTop = dojo.byId(this.pageName + "scrollContainer").scrollHeight;
		}
		else {
			dojo.byId(listTypeMenuId).style.display = "block";
			this.listTypeMenuOpen = true;
			dojo.byId(this.pageName + "scrollContainer").scrollTop = dojo.byId(this.pageName + "scrollContainer").scrollHeight;
		}
	};
	
	/**
	 * Set the type of list for the newly created list
	 * @param listTypeToSet - 'Y' for private, 'Z' for shared/public
	 */
	this.setListType = function(listTypeToSet) {
		if (this.params.status != listTypeToSet) {
			dojo.byId(listTypeFieldId + this.params.status).style.display="none";
			this.params.status = listTypeToSet;
			dojo.byId(listTypeFieldId + this.params.status).style.display="block";
			dojo.byId(this.pageName + "scrollContainer").scrollTop = dojo.byId(this.pageName + "scrollContainer").scrollHeight;
		}
	};
	
	
	/**
	* addSkus2RequisitionListAjax This function is used to add one or more SKUs to a requisition list using an AJAX call.
	**/
	this.addSkus2RequisitionListAjax = function() {
		if (this.someRadioButtonChecked == true) {			
			params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.pageName = this.pageName;
			params.buttonStyle = this.buttonStyle;
			params.productId = product_id;
			params.name = this.params.name;
			params.status = this.params.status;
			params.requisitionListId = this.params.requisitionListId;
			params.addBundle = this.addBundle;
			params.addMultipleSKUs = 'true';
			
			if (this.addSingleSKU) {
				var quantity = dojo.byId(catEntryId + "_Mobile_Quantity_Input").value;
				if (!isPositiveInteger(quantity)){
					MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
					return;
				}
				
				params["catEntryId_1"] = catEntryId;
				params["quantity_1"] = quantity;
			} else if (this.addBundle) {
				var i = 1;
				for (var prodId in shoppingActionsJS.productList){
					var productDetails = shoppingActionsJS.productList[prodId];
					var quantity = dojo.number.parse(productDetails.quantity);
					if (quantity == 0) {
						continue;
					}
					if(productDetails.id == 0){
						MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
						return;
					}
					if(isNaN(quantity) || quantity < 0){
						MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
						return;
					}

					params["catEntryId_" + i] = productDetails.id;
					params["quantity_" + i] = quantity;
					params["productId_" + i++] = prodId;
				}
			} else {
				//Get all of the SKUs and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1, catEntryId_2, quantity_2)
				if (product_id in SKUListJS.quantityList) {
					var i = 1;
					for (var skuId in SKUListJS.quantityList[product_id]) {
						var quantity = SKUListJS.quantityList[product_id][skuId];
						if(!isPositiveInteger(quantity)){
							MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUTS_ERROR']);
							return;
						}
						params["catEntryId_" + i] = skuId;
						params["quantity_" + i++] = quantity;
					}
				}				
			}
			
			
			if (params.catEntryId_1 == null || params.quantity_1 == null) {
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUTS_ERROR']);
				return;
			}
	
			//For Handling multiple clicks
			if (!submitRequest()) {
				return;
			}   
			cursor_wait();	
			
			if (this.createListDetailsMenuOpen) {
				params.name = dojo.byId(this.listNameFieldId).value.replace(/^\s+|\s+$/g, '');
				if (params.name == "") {
					MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_EMPTY_SL_NAME']);
					return;
				}
			}
			wc.service.invoke('addCatalogEntriesToCreateRequisitionList', params);
		}
		else {
			MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_LIST_NOT_CHOSEN']);
			return;
		}
	};

	/**
	* addOrderToRequisitionList This function is used to add an order to a requisition list.
	* @param {String} orderId the order Id being added to cart 	
	**/
	this.addOrderToRequisitionList = function() {
		if (this.someRadioButtonChecked == true) {			
			params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.pageName = this.pageName;
			params.buttonStyle = this.buttonStyle;
			params.productId = product_id;
			params.name = this.params.name;
			params.status = this.params.status;
			params.requisitionListId = this.params.requisitionListId;
			params.addSavedOrder = 'true';
			
			//Get all of the catEntryIds and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1, catEntryId_2, quantity_2)
			if (SavedOrderListJS.quantityList != {}) {
				var i = 1;
				for (var orderId in SavedOrderListJS.quantityList) {
					for (var catEntryId in SavedOrderListJS.quantityList[orderId]) { 
						var quantity = SavedOrderListJS.quantityList[orderId][catEntryId];
					
						params["catEntryId_" + i] = catEntryId;
						params["quantity_" + i]	= quantity;
						i++;
					}
				}
			}
			
			if (params.catEntryId_1 == null || params.quantity_1 == null) {
				MessageHelper.displayErrorMessage(storeNLS['MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL']);
				return;
			}
	
			//For Handling multiple clicks
			if (!submitRequest()) {
				return;
			}   
			cursor_wait();	
			
			if (this.createListDetailsMenuOpen) {
				params.name = dojo.byId(this.listNameFieldId).value.replace(/^\s+|\s+$/g, '');
				if (params.name == "") {
					MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_EMPTY_SL_NAME']);
					return;
				}
			}
			wc.service.invoke('addOrderToCreateRequisitionList', params);
		}
		else {
			MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_LIST_NOT_CHOSEN']);
			return;
		}
	};

	/**
	 * Add the product to a specific or new list
	 */
	this.addToList = function() {
		if (this.someRadioButtonChecked == true) {			
			params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.catEntryId = catEntryId;
			params.productId = product_id;
			params.pageName = this.pageName;
			params.buttonStyle = this.buttonStyle;
			params.name = this.params.name;
			params.status = this.params.status;
			params.requisitionListId = this.params.requisitionListId;
						
			params.quantity = quantity;
			if (quantity < 1) {
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
				return;
			}
			if (!submitRequest()) {
				return;
			}
			cursor_wait();
			if (this.createListDetailsMenuOpen) {
				params.name = dojo.byId(this.listNameFieldId).value.replace(/^\s+|\s+$/g, '');
				if (params.name == "") {
					MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_EMPTY_SL_NAME']);
					return;
				}
			}
			if (this.addPDK) {
				wc.service.getServiceById("addToCreateRequisitionList").url = getAbsoluteURL() + "AjaxRESTRequisitionListConfigurationAdd";
			}
			wc.service.invoke('addToCreateRequisitionList', params);
		}
		else {
			MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_LIST_NOT_CHOSEN']);
			return;
		}
	};
	
	/**
	 * Add the product to a specific or new list
	 */
	this.moveToList = function(requisitionOrderItemId) {
		if (this.someRadioButtonChecked == true) {	
			params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.catEntryId = catEntryId;
			params.productId = product_id;
			params.pageName = this.pageName;
			params.buttonStyle = this.buttonStyle;
			params.name = this.params.name;
			params.status = this.params.status;
			params.requisitionListId = this.params.requisitionListId;
			params.requisitionOrderItemId = requisitionOrderItemId;			
			params.quantity = quantity;
			if (quantity < 1) {
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
				return;
			}
			if (!submitRequest()) {
				return;
			}
			cursor_wait();
			if (this.createListDetailsMenuOpen) {
				params.name = dojo.byId(this.listNameFieldId).value.replace(/^\s+|\s+$/g, '');
				if (params.name == "") {
					MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_EMPTY_SL_NAME']);
					return;
				}
			}
			wc.service.invoke('addToCreateRequisitionListAndDeleteFromCart', params);
		}
		else {
			MessageHelper.displayErrorMessage(storeNLS['ERROR_SL_LIST_NOT_CHOSEN']);
			return;
		}
	};
	
	/**
	 * Hide and reset widget after successfully adding an item to a list
	 */
	this.continueShopping = function() {
		if (dojo.byId(addResultMenuId)) {
			dojo.byId(addResultMenuId).style.display = "none";
			this.toggleDropDownMenu(true);
			this._initialize();
			
			if (document.removeEventListener) {
				document.removeEventListener("keydown", this.trapTabKey, true);
			}
			
			var addToReqListButton = dojo.byId(this.pageName + "addToShoppingListBtn");
			if (addToReqListButton != null) {
				addToReqListButton.focus();
			}
		}
	};
	
	/**
	 * Service declaration to add a catalog entry to a requisition list.  List is created if it does not exist.
	 */
	wc.service.declare({
		id: "addToCreateRequisitionList",
		actionId: "addToCreateRequisitionList",
		url: getAbsoluteURL() + "AjaxRequisitionListUpdateItem",
		formId: "",
		
		successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			
			var productName = "";
			// Get the product or SKU name
			if(document.getElementById("ProductInfoName_" + serviceResponse.productId) != null){
				productName = document.getElementById("ProductInfoName_" + serviceResponse.productId).value;
			} else if(document.getElementById("ProductInfoName_" + catEntryId) != null){
				productName = document.getElementById("ProductInfoName_" + catEntryId).value;
			}
			
			var productThumbnail = "";
			// Get the product's image or SKU image
			if(document.getElementById("ProductInfoImage_" + serviceResponse.productId) != null){
				productThumbnail = document.getElementById("ProductInfoImage_" + serviceResponse.productId).value;
			} else if(document.getElementById("ProductInfoImage_" + catEntryId) != null){
				productThumbnail = document.getElementById("ProductInfoImage_" + catEntryId).value;
			}

			// Refresh the widget's refresh area and show item was added to a list
			wc.render.updateContext("requisitionLists_content_context", {"showSuccess":"true", "listName": serviceResponse.name, "productName":productName, "productThumbnail":productThumbnail, "storeId":serviceResponse.storeId, "buttonStyle":serviceResponse.buttonStyle, "parentPage":serviceResponse.pageName, "productId":serviceResponse.productId});
			
			// Keep polling until the continue shopping button is visible after AJAX update, then focus on it
			var poll = window.setInterval(function() {
				var contShopButton = dojo.byId(serviceResponse.pageName + "requisitionListsContShopButton");
				if (contShopButton != null) {
					if (contShopButton.offsetHeight != 0) {
						window.clearInterval(poll);
						contShopButton.focus();
						if (document.addEventListener) {
							document.addEventListener("keydown", this.trapTabKey, true);
						}
					}
				}
			}, 100);
		},
		
		failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}
	});
	
	/**
	 * Service declaration to add a catalog entry to a requisition list.  List is created if it does not exist.
	 */
	wc.service.declare({
		id: "addToCreateRequisitionListAndDeleteFromCart",
		actionId: "addToCreateRequisitionListAndDeleteFromCart",
		url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
		formId: "",
		
		successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			
			var productName = "";
			// Get the product or SKU name
			if(document.getElementById("catalogEntry_name_" + serviceResponse.requisitionOrderItemId) != null){
				productName = document.getElementById("catalogEntry_name_" + serviceResponse.requisitionOrderItemId).innerHTML;
			} 
			
			var productThumbnail = "";
			// Get the product's image or SKU image
			if(document.getElementById("catalogEntry_img_" + serviceResponse.requisitionOrderItemId) != null){
				productThumbnail = document.getElementById("catalogEntry_img_" + serviceResponse.requisitionOrderItemId).childNodes[1].src;
			}
			
			// Refresh the widget's refresh area and show item was added to a list
			wc.render.updateContext("requisitionLists_content_context", {"showSuccess":"true", "listName": serviceResponse.name, "productName":productName, "productThumbnail":productThumbnail, "storeId":serviceResponse.storeId, "buttonStyle":serviceResponse.buttonStyle, "parentPage":serviceResponse.pageName});

			CheckoutHelperJS.deleteFromCart(serviceResponse.requisitionOrderItemId);
			
			// Keep polling until the continue shopping button is visible after AJAX update, then focus on it
			var poll = window.setInterval(function() {
				var contShopButton = dojo.byId(serviceResponse.pageName + "requisitionListsContShopButton");
				if (contShopButton != null) {
					if (contShopButton.offsetHeight != 0) {
						window.clearInterval(poll);
						contShopButton.focus();
						if (document.addEventListener) {
							document.addEventListener("keydown", this.trapTabKey, true);
						}
					}
				}
			}, 100);
			
			// Remove the grayOut.  User does not have chance to cancel gray out themselves when catentry is deleted from the cart 
			if (dojo.byId('grayOut')) {
				dojo.byId('grayOut').style.display = "none";
			}
			if (dojo.byId('grayOutPopup')) {
				dojo.byId('grayOutPopup').style.display = "none";
			}

		},
		
		failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}
	});
	
	/**
	 * Service declaration to add multiple catalog entries to a requisition list.  List is created if it does not exist.
	 */
	wc.service.declare({
		id: "addCatalogEntriesToCreateRequisitionList",
		actionId: "addCatalogEntriesToCreateRequisitionList",
		url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
		formId: "",
		
		successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();

			var productName = [];
			var productThumbnail = [];
			var productSKU = [];
			
			// Get the SKU name and thumbnail urls
			for (var i = 1; ("catEntryId_" + i) in serviceResponse; i++) {
				var catEntryId = serviceResponse["catEntryId_" + i];
				var productId = serviceResponse["productId_" + i];  //Used when adding bundle
				
				var catEntryName = dojo.byId("item_name_" + catEntryId) || dojo.byId("ProductInfoName_" + productId);
				if (catEntryName != null) {
					productName.push(catEntryName.value);
					var catEntrySKU = dojo.byId("item_sku_" + catEntryId);
					if (catEntrySKU != null) {
						productSKU.push("(" + catEntrySKU.value + ")");						
					}
				}
				
				var catEntryThumbnail = dojo.byId("item_thumbnail_" + catEntryId) || dojo.byId("ProductInfoImage_" + catEntryId);
				if (catEntryThumbnail != null){
					productThumbnail.push(catEntryThumbnail.value);
				} else if (dojo.byId("entitledItem_" + productId) != null) { //Get the thumbnail image from the JSON in the HTML in the bundle case
					var entitledItemJSON = dojo.fromJson(dojo.byId("entitledItem_"+ productId).innerHTML);
					for (var j in entitledItemJSON) {
						var entitledItem = entitledItemJSON[j];
						if (entitledItem.catentry_id == catEntryId) {
							if (entitledItem.ItemThumbnailImage != null) {
								productThumbnail.push(entitledItem.ItemThumbnailImage);
								break;
							}
						}
					}
				}
			}
			
			var type = "";
			if (serviceResponse.addBundle) {
				type = 'bundle';
			}
			
			// Refresh the widget's refresh area and show item was added to a list
			wc.render.updateContext("requisitionLists_content_context", {"showSuccess":"true", "listName": serviceResponse.name, "productName":productName, "productThumbnail":productThumbnail, "productSKU":productSKU, "storeId":serviceResponse.storeId, "buttonStyle":serviceResponse.buttonStyle, "parentPage":serviceResponse.pageName, "productId":serviceResponse.productId, "addMultipleSKUs":serviceResponse.addMultipleSKUs, "numberOfSKUs":i-1, "type":type});
			
			// Keep polling until the continue shopping button is visible after AJAX update, then focus on it
			var poll = window.setInterval(function() {
				var contShopButton = dojo.byId(serviceResponse.pageName + "requisitionListsContShopButton");
				if (contShopButton != null) {
					if (contShopButton.offsetHeight != 0) {
						window.clearInterval(poll);
						contShopButton.focus();
						if (document.addEventListener) {
							document.addEventListener("keydown", this.trapTabKey, true);
						}
					}
				}
			}, 100);
			
			dojo.publish('SKUsAddedToReqList');
		},
		
		failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}
	});
	
	/**
	 * Service declaration to add saved order to a requisition list.  List is created if it does not exist.
	 */
	wc.service.declare({
		id: "addOrderToCreateRequisitionList",
		actionId: "addOrderToCreateRequisitionList",
		url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
		formId: "",
		
		successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			
			// Refresh the widget's refresh area and show item was added to a list
			wc.render.updateContext("requisitionLists_content_context", {"showSuccess":"true", "listName": serviceResponse.name, "storeId":serviceResponse.storeId, "buttonStyle":serviceResponse.buttonStyle, "parentPage":serviceResponse.pageName, "productID":serviceResponse.productId, "addSavedOrder":serviceResponse.addSavedOrder, "orderId":serviceResponse.orderId});
			
			// Keep polling until the continue shopping button is visible after AJAX update, then focus on it
			var poll = window.setInterval(function() {
				var contShopButton = dojo.byId(serviceResponse.pageName + "requisitionListsContShopButton");
				if (contShopButton != null) {
					if (contShopButton.offsetHeight != 0) {
						window.clearInterval(poll);
						contShopButton.focus();
						if (document.addEventListener) {
							document.addEventListener("keydown", this.trapTabKey, true);
						}
					}
				}
			}, 100);
		},
		
		failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}
	});

	if(jsObjectName != 'AddToRequisitionListJS'){
		this.pageName = jsObjectName.replace('AddToRequisitionListsJS', '');
	};
	this._initialize();
}

/**
 * Declares a new render context for the Requisition List display.
 */
wc.render.declareContext("requisitionLists_content_context",{"showSuccess":"false"});

/** 
 * Declares a new refresh controller for Add To Requisition List display.
 */
wc.render.declareRefreshController({
       id: "requisitionLists_content_controller",
       renderContext: wc.render.getContextById("requisitionLists_content_context"),
       url: getAbsoluteURL()+"AddToRequisitionListsView",
       formId: ""

       /** 
        * Refresh widget if new list was created through the widget
        * 
        * @param {string} message The render context changed event message
        * @param {object} widget The registered refresh area
        */
       ,renderContextChangedHandler: function(message, widget) {
			var controller = this;
			var renderContext = this.renderContext;
			var widgetId = renderContext.properties["parentPage"] + "requisitionlists_content_widget";
			if (widgetId === widget.id) {
				// Only refresh the widget associated with parentPage
				widget.refresh(renderContext.properties);
			};
       }  

		/** 
		 * Refresh widget if new list was created through the widget
		 * 
		 * @param {string} message The model changed event message
		 * @param {object} widget The registered refresh area
		 */
		,modelChangedHandler: function(message, widget) {
			
		}
		 
		/** 
		 * Clears the progress bar
		 * 
		 * @param {object} widget The registered refresh area
		 */
		,postRefreshHandler: function(widget) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}		 
});
