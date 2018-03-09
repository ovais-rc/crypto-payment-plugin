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

function AddToRequisitionListsJS(storeId, catalogId, langId, dropDownMenuId, selectListMenuId, createListMenuId, listTypeMenuId, listNameFieldId, listTypeFieldId, addResultMenuId, buttonStyle, jsObjectName) {

    this.storeId = storeId;
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
    this.addResultMenuId = "";
    this.addSingleSKU = false;
    this.addBundle = false;
    this.addPDK = false;
    var product_id = 0;

    var quantity = 1; // One item to add to list by default
    var catEntryId = 0;

    var catEntryResolved = false;
	
	this.addDK = false;
	var configurationXML = "";
	

    /**
     * Re-initializes variables when product is successfully added to a list
     */
    this._initialize = function () {
        this.someRadioButtonChecked = false;
        this.createListDetailsMenuOpen = false;
        this.listTypeMenuOpen = false;
        this.dropDownOpen = false;
        this.addSingleSKU = false;
        this.addBundle = false;
        this.params.status = 'Y'; // Default to private list
    };

    /**
     * Setter for topic.subscribe callback
     */
    this.setQuantity = function (newQuantity) {
        if (newQuantity != '') {
            quantity = newQuantity;
        }
    };
    /**
     * Getter for topic.subscribe callback
     */
    this.getQuantity = function () {
        return quantity;
    };
    /**
     * Setter for topic.subscribe callback
     */
    this.setCatEntryId = function (newCatEntryId, newProductId) {
        if (newCatEntryId != null) {
            catEntryResolved = true;
            catEntryId = newCatEntryId;
            product_id = newProductId;
        } else {
            catEntryResolved = false;
        }

    };
    /**
     * Getter for topic.subscribe callback
     */
    this.getCatEntryId = function () {
        return catEntryId;
    };

    /**
     * Sets product ID to be added to cart
     */
    this.setProductId = function (newProductId) {
        product_id = newProductId;
    };

    /**
     * sets whether a PDK is being added to the list
     */
    this.setAddPDK = function (addpdk) {
        this.addPDK = addpdk;
    };

	/**
	 * sets whether a DK is being added to the requisition list
	 */
	this.setAddDK = function(adddk) {
		this.addDK = adddk;
	};

	/**
	 * sets the configuration xml of the DK
	 */
	this.setConfigurationXML = function(configXML) {
		this.configurationXML = configXML;
	};
	
	/**
	 * Converts xml accepted form to < >
	 * @param {String} str, String to be converted
	 * @return {String} converted string
	 */
	this.unEscapeXml =  function(str){
		return str.replace(/&lt;/gm, "<").replace(/&gt;/gm, ">").replace(/&#034;/gm,"\"");
	};
	
	
    /**
     * Hides the dropdown
     * @param dropDownId - dropdown node
     */
    this._hideDropDownMenu = function (dropDownId) {
        Utils.ifSelectorExists("#" + dropDownId, function (dropDown) {
            dropDown.css("display", "none");
            $('#grayOut').css("display", "none");
            $('#grayOutPopup').css("display", "none");

            this.dropDownVisible = false;
            this.dropDownInFocus = false;
            this.dropDownOpen = false;
        }, this);

        if (document.removeEventListener) {
            document.removeEventListener("keydown", this.trapTabKey, true);
        }
    };

    /**
     * Shows the dropdown
     * @param dropDownId - dropdown node id
     * @param resolveCatentry - if true, then catentry must be resolved before showing drop down menu
     */
    this._showDropDownMenu = function (dropDownId, resolveCatentry) {
        if (resolveCatentry && !catEntryResolved) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_RESOLVED_SKU'));
            return;
        }

        Utils.ifSelectorExists("#" + dropDownId, function (dropDown) {
            dropDown.css("display", "block");
            var radioButtons = $('.radioButton', dropDown);
            if (radioButtons.length) {
                radioButtons[0].focus();
            }
            $('#grayOut').css("display", "block");
            $('#grayOutPopup').css("display", "block");

            this.dropDownVisible = true;
            this.dropDownInFocus = true;
            this.dropDownOpen = true;
            MessageHelper.hideAndClearMessage();
        }, this);

        if (document.addEventListener) {
            document.addEventListener("keydown", this.trapTabKey, true);
        }
    };

    /**
     * Hides the list of requisition lists
     */
    this._hideSelectList = function () {
        $("#" + this.selectListMenuId).css("display", "none");
    };

    /**
     * Shows the list of requisition lists
     */
    this._showSelectList = function () {
        $("#" + this.selectListMenuId).css("display", "block");
    };

    /**
     * Traps the tab key when in the popup
     * @event the key event
     */
    this.trapTabKey = function (event) {
        if (event.keyCode === KeyCodes.TAB) {
            var popup = $('.requisitionListContent.popup').toArray().find(function (a_popup) {
                return a_popup.offsetHeight !== 0;
            });

            if (popup) {
                var visibleFocusableItems = $('[tabindex$=\"0\"]', popup).toArray().filter(function (a_item) {
                    return a_item.offsetHeight !== 0; // visible
                });
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
    this.toggleDropDownMenu = function (showSelectList, resolveCatentry, multipleSKUs, singleSkuId, addBundle) {
        if (resolveCatentry == null) {
            resolveCatentry = true;
        }

        // Check to make sure quantity fields are populated when adding bundle
        if (addBundle) {
            for (var productId in shoppingActionsJS.productList) {
                var productDetails = shoppingActionsJS.productList[productId];
                var quantity = parseInt(productDetails.quantity);
                if (quantity == 0) {
                    continue;
                }
                if (productDetails.id == 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                    return;
                }
                if (isNaN(quantity) || quantity < 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
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
                    if (!isPositiveInteger(quantity)) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                        return;
                    }
                    length++;
                }
                if (length == 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                    return;
                }
            } else {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                return;
            }
        }

        // Check to make sure quantity field is populated when adding single SKU from SKU List widget
        if (singleSkuId) {
            var quantity = $("#" + singleSkuId + "_Mobile_Quantity_Input").val();
            if (!isPositiveInteger(quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }

            this.setQuantity(quantity);
            this.addSingleSKU = true;
        }

        if (this.dropDownOpen == false) {
            this._showDropDownMenu(dropDownMenuId, resolveCatentry);
        } else {
            this._hideDropDownMenu(dropDownMenuId);
        }
        if (showSelectList == false) {
            this._hideSelectList();
        } else {
            this._showSelectList();
        }
    };

    /**
     * Check a radio button
     * @param nodeToCheck - the radio button to check
     * @param listId - list's ID
     * @param radiovalue - list's name
     */
    this.checkRadioButton = function (nodeToCheck, listId, radioValue) {
        if (nodeToCheck) {
            $(".checked", "#" + dropDownMenuId).css("display", "none");
            $(".checked", nodeToCheck).css("display", "block");
            $(".radioButton", "#" + dropDownMenuId).attr("aria-checked", "false");
            $(nodeToCheck).attr("aria-checked", "true");
            if (radioValue !== undefined) {
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
    this.toggleCreateListDetailsMenu = function (state) {
        // Only toggle the menu when the requested state is different from the current state
        if (this.createListDetailsMenuOpen == true && state == false) {
            $("#" + createListMenuId).css("display", "none");
            this.createListDetailsMenuOpen = false;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        } else if (this.createListDetailsMenuOpen == false && state == true) {
            $("#" + createListMenuId).css("display", "block");
            this.createListDetailsMenuOpen = true;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };

    /**
     * Handles a keyboard event on the list type menu
     */
    this.handleKeyEventListTypeMenu = function (event) {
        switch (event.keyCode) {
            case KeyCodes.UP_ARROW:
                event.preventDefault();
                if (this.params.status == 'Z') {
                    this.setListType('Y');
                }
                break;
            case KeyCodes.DOWN_ARROW:
                event.preventDefault();
                if (this.params.status == 'Y') {
                    this.setListType('Z');
                }
                break;
        }
    };

    /**
     * Toggle showing the list type menu when creating a new list
     */
    this.toggleListTypeMenu = function () {
        if (this.listTypeMenuOpen == true) {
            $("#" + listTypeMenuId).css("display", "none");
            this.listTypeMenuOpen = false;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        } else {
            $("#" + listTypeMenuId).css("display", "block");
            this.listTypeMenuOpen = true;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };

    /**
     * Set the type of list for the newly created list
     * @param listTypeToSet - 'Y' for private, 'Z' for shared/public
     */
    this.setListType = function (listTypeToSet) {
        if (this.params.status != listTypeToSet) {
            $("#" + listTypeFieldId + this.params.status).css("display", "none");
            this.params.status = listTypeToSet;
            $("#" + listTypeFieldId + this.params.status).css("display", "block");
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };


    /**
     * addSkus2RequisitionListAjax This function is used to add one or more SKUs to a requisition list using an AJAX call.
     **/
    this.addSkus2RequisitionListAjax = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                productId: product_id,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                addBundle: this.addBundle,
                addMultipleSKUs: 'true'
            };

            if (this.addSingleSKU) {
                var quantity = $("#" + catEntryId + "_Mobile_Quantity_Input").val();
                if (!isPositiveInteger(quantity)) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                    return;
                }

                params["catEntryId_1"] = catEntryId;
                params["quantity_1"] = quantity;
            } else if (this.addBundle) {
                var i = 1;
                for (var prodId in shoppingActionsJS.productList) {
                    var productDetails = shoppingActionsJS.productList[prodId];
                    var quantity = parseInt(productDetails.quantity);
                    if (quantity == 0) {
                        continue;
                    }
                    if (productDetails.id == 0) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                        return;
                    }
                    if (isNaN(quantity) || quantity < 0) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
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
                        if (!isPositiveInteger(quantity)) {
                            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                            return;
                        }
                        params["catEntryId_" + i] = skuId;
                        params["quantity_" + i++] = quantity;
                    }
                }
            }


            if (params.catEntryId_1 == null || params.quantity_1 == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                return;
            }

            //For Handling multiple clicks
            if (!submitRequest()) {
                return;
            }
            cursor_wait();

            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            wcService.invoke('addCatalogEntriesToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * addOrderToRequisitionList This function is used to add an order to a requisition list.
     * @param {String} orderId the order Id being added to cart 	
     **/
    this.addOrderToRequisitionList = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                productId: product_id,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                addSavedOrder: 'true'
            };

            //Get all of the catEntryIds and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1, catEntryId_2, quantity_2)
            if (OrderListJS.quantityList != {}) {
                var i = 1;
                for (var orderId in OrderListJS.quantityList) {
                    for (var catEntryId in OrderListJS.quantityList[orderId]) {
                        var quantity = OrderListJS.quantityList[orderId][catEntryId];

                        params["catEntryId_" + i] = catEntryId;
                        params["quantity_" + i] = quantity;
                        i++;
                    }
                }
            }

            if (params.catEntryId_1 == null || params.quantity_1 == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL'));
                return;
            }

            //For Handling multiple clicks
            if (!submitRequest()) {
                return;
            }
            cursor_wait();

            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            wcService.invoke('addOrderToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Add the product to a specific or new list
     */
    this.addToList = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                catEntryId: catEntryId,
                productId: product_id,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                quantity: quantity
            };
            if (quantity < 1) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            if (this.addPDK) {
                wcService.getServiceById("addToCreateRequisitionList").setUrl(getAbsoluteURL() + "AjaxRESTRequisitionListConfigurationAdd");
            }
            wcService.invoke('addToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Add the product to a specific or new list
     */
    this.moveToList = function (requisitionOrderItemId) {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                catEntryId: catEntryId,
                productId: product_id,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                requisitionOrderItemId: requisitionOrderItemId,
                quantity: quantity
            };
            if (quantity < 1) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
			if (this.addPDK || this.addDK) {
				if (this.addDK){
					params.configurationXML = this.unEscapeXml( this.configurationXML);
				}
				wcService.getServiceById("addToCreateRequisitionListAndDeleteFromCart").setUrl(getAbsoluteURL() + "AjaxRESTRequisitionListConfigurationAdd");
			}
            wcService.invoke('addToCreateRequisitionListAndDeleteFromCart', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Hide and reset widget after successfully adding an item to a list
     */
    this.continueShopping = function () {
        Utils.ifSelectorExists("#" + addResultMenuId, function ($addResultMenu) {
            $addResultMenu.css("display", "none");
            this.toggleDropDownMenu(true);
            this._initialize();

            if (document.removeEventListener) {
                document.removeEventListener("keydown", this.trapTabKey, true);
            }

            $("#" + this.pageName + "addToShoppingListBtn").focus();
        }, this);
    };

    /**
     * Service declaration to add a catalog entry to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addToCreateRequisitionList",
        actionId: "addToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = "";
            // Get the product or SKU name
            if ($("#ProductInfoName_" + serviceResponse.productId).length) {
                productName = $("#" + "ProductInfoName_" + serviceResponse.productId).val();
            } else if ($("#ProductInfoName_" + catEntryId).length) {
                productName = $("#" + "ProductInfoName_" + catEntryId).val();
            }

            var productThumbnail = "";
            // Get the product's image or SKU image
            if ($("#ProductInfoImage_" + serviceResponse.productId).length) {
                productThumbnail = $("#" + "ProductInfoImage_" + serviceResponse.productId).val();
            } else if ($("#ProductInfoImage_" + catEntryId).length) {
                productThumbnail = $("#" + "ProductInfoImage_" + catEntryId).val();
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productId": serviceResponse.productId
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight !== 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, 100);
        },

        failureHandler: function (serviceResponse) {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            } else {
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
    wcService.declare({
        id: "addToCreateRequisitionListAndDeleteFromCart",
        actionId: "addToCreateRequisitionListAndDeleteFromCart",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = "";
            // Get the product or SKU name
            if ($("#catalogEntry_name_" + serviceResponse.requisitionOrderItemId).length) {
                productName = $("#" + "catalogEntry_name_" + serviceResponse.requisitionOrderItemId).html();
            }

            var productThumbnail = "";
            // Get the product's image or SKU image
            if ($("#catalogEntry_img_" + serviceResponse.requisitionOrderItemId).length) {
                productThumbnail = document.getElementById("catalogEntry_img_" + serviceResponse.requisitionOrderItemId).childNodes[1].src;
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName
            });

            CheckoutHelperJS.deleteFromCart(serviceResponse.requisitionOrderItemId);

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight != 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                });
            }, 100);

            // Remove the grayOut.  User does not have chance to cancel gray out themselves when catentry is deleted from the cart 
            $("#grayOut").css("display", "none");
            $("#grayOutPopup").css("display", "none");
        },

        failureHandler: function (serviceResponse) {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            } else if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
            cursor_clear();
        }
    });

    /**
     * Service declaration to add multiple catalog entries to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addCatalogEntriesToCreateRequisitionList",
        actionId: "addCatalogEntriesToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = [];
            var productThumbnail = [];
            var productSKU = [];

            // Get the SKU name and thumbnail urls
            for (var i = 1;
                ("catEntryId_" + i) in serviceResponse; i++) {
                var catEntryId = serviceResponse["catEntryId_" + i];
                var productId = serviceResponse["productId_" + i]; //Used when adding bundle

                var catEntryName = Utils.selectExistingElement(["#item_name_" + catEntryId, "#ProductInfoName_" + productId]);
                if (catEntryName) {
                    productName.push(catEntryName.val());
                    Utils.ifSelectorExists("#item_sku_" + catEntryId, function (catEntrySKU) {
                        productSKU.push("(" + catEntrySKU.val() + ")");
                    });
                }

                var catEntryThumbnail = Utils.selectExistingElement(["#item_thumbnail_" + catEntryId, "#ProductInfoImage_" + catEntryId]);
                if (catEntryThumbnail) {
                    productThumbnail.push(catEntryThumbnail.val());
                } else { //Get the thumbnail image from the JSON in the HTML in the bundle case
                    Utils.ifSelectorExists("#entitledItem_" + productId, function (element) {
                        var entitledItemJSON = JSON.parse(element.html());
                        for (var j in entitledItemJSON) {
                            var entitledItem = entitledItemJSON[j];
                            if (entitledItem.catentry_id == catEntryId) {
                                if (entitledItem.ItemThumbnailImage != null) {
                                    productThumbnail.push(entitledItem.ItemThumbnailImage);
                                    break;
                                }
                            }
                        }
                    });
                }
            }

            var type = "";
            if (serviceResponse.addBundle) {
                type = 'bundle';
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "productSKU": productSKU,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productId": serviceResponse.productId,
                "addMultipleSKUs": serviceResponse.addMultipleSKUs,
                "numberOfSKUs": i - 1,
                "type": type
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight !== 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, 100);

            wcTopic.publish('SKUsAddedToReqList');
        },

        failureHandler: function (serviceResponse) {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            } else {
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
    wcService.declare({
        id: "addOrderToCreateRequisitionList",
        actionId: "addOrderToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productID": serviceResponse.productId,
                "addSavedOrder": serviceResponse.addSavedOrder,
                "orderId": serviceResponse.orderId
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval($.proxy(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight != 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, this), 100);
        },

        failureHandler: function (serviceResponse) {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            } else {
                if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                }
            }
            cursor_clear();
        }
    });

    if (jsObjectName != 'AddToRequisitionListJS') {
        this.pageName = jsObjectName.replace('AddToRequisitionListsJS', '');
    };
    this._initialize();
}

/**
* Declares a new refresh controller
for Add To Requisition List display.*/
var declareRequsitionListsContentController = function (widgetPrefix) {
    if (!wcRenderContext.checkIdDefined("requisitionLists_content_context")) {
        wcRenderContext.declare("requisitionLists_content_context", [], {
            "showSuccess": "false"
        });
    }
    var myWidgetObj = $("#" + widgetPrefix + "requisitionlists_content_widget");
    wcRenderContext.addRefreshAreaId("requisitionLists_content_context", widgetPrefix + "requisitionlists_content_widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("requisitionLists_content_context");


    /**
     * Declares a new render context for the Requisition List display.
     */
    var renderContextChangedHandler = function () {
            var widgetId = myRCProperties["parentPage"] + "requisitionlists_content_widget";
            if (widgetId === myWidgetObj.attr("id")) {
                // Only refresh the widget associated with parentPage
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            };

        },



        postRefreshHandler = function () {
            MessageHelper.hideAndClearMessage();
            cursor_clear();
        }
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: renderContextChangedHandler,
        postRefreshHandler: postRefreshHandler
    });
};
