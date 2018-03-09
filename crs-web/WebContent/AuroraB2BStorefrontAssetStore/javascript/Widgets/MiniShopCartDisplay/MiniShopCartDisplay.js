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


/**
 * @fileOverview This file provides the common functions which are specific to the Mini Shopping cart
 */

/**
 * map order_updated to all the services that result in changes to an order
 * @static
 */

var order_updated = {
    'AjaxAddOrderItem': 'AjaxAddOrderItem',
    'AddOrderItem': 'AddOrderItem',
    'AjaxAddOrderItemWithShipingInfo': 'AjaxAddOrderItemWithShipingInfo',
    'AjaxDeleteOrderItem': 'AjaxDeleteOrderItem',
    'AjaxUpdateOrderItem': 'AjaxUpdateOrderItem',
    'AjaxUpdateOrderShippingInfo': 'AjaxUpdateOrderShippingInfo',
    'AjaxOrderCalculate': 'AjaxOrderCalculate',
    'AjaxLogoff': 'AjaxLogoff',
    'AjaxSetPendingOrder': 'AjaxSetPendingOrder',
    'AjaxUpdatePendingOrder': 'AjaxUpdatePendingOrder',
    'AjaxSingleOrderCancel': 'AjaxSingleOrderCancel',
    'AjaxUpdateRewardOption': 'AjaxUpdateRewardOption'
};

/** This variable indicates whether the mini cart drop down is updated or not. */
var dialogWidget,
    update_content = false,
    dropdownUpdated = false,
    /** This is variable indicates whether the mini cart drop down is being initialized. */
    dropdownInit = false,
    productAddedList = {};

function declareMiniShoppingCartRefreshArea() {

    // ============================================
    // initialize refresh area widgets
    // ============================================

    // ============================================
    // div: MiniShoppingCart refresh area
    // Declares a new refresh controller for the Mini Shopping Cart.

    // declare render context
    wcRenderContext.declare("MiniShoppingCartContext", ["MiniShoppingCart"], { status: "init" });

    /*
    /* Refreshes the mini shopping cart.
     * This function is called when a render context changed event is detected.
     */
    var renderContextChangedHandler = function() {
        if (wcRenderContext.testForChangedRC("MiniShoppingCartContext", ["status"])) {
            wcRenderContext.getRenderContextProperties("MiniShoppingCartContext").deleteCartCookie = true;
            $("#MiniShoppingCart").refreshWidget("refresh", wcRenderContext.getRenderContextProperties("MiniShoppingCartContext"));
        }
    };

    // model change
    /*
     * Refreshes the mini shopping cart.
     * If a new order item is added via an Ajax service call, set the mini shopping cart to display the new order item in the dropdown.
     * Otherwise, only refresh the contents of mini shopping cart to the updated order information.
     * This function is called when a modelChanged event is detected.
     *
     * @param {string} event The model changed event
     * @param {object} returnData The data returned from the event
     */
    var events = $.extend({}, order_updated, { "AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage" });
    wcTopic.subscribe(events, function(returnData) {
        var param = [];
        if (returnData.actionId == 'AddOrderItem') {
            if (returnData.data.orderItem != null && returnData.data.orderItem[0].orderItemId != null) {
                var addedOrderItemIdString = "";
                for (var i = 0; i < returnData.data.orderItem.length; i++) {
                    if (addedOrderItemIdString !== "") {
                        addedOrderItemIdString += ",";
                    }
                    addedOrderItemIdString += returnData.data.orderItem[i].orderItemId;
                }
                param.addedOrderItemId = addedOrderItemIdString;
            } else {
                param.addedOrderItemId = returnData.data.orderItemId + "";
            }
            showDropdown = true;
        }
        param.deleteCartCookie = true;
        if (returnData.data.addedFromSKUList != null && returnData.data.addedFromSKUList[0] != null) {
            param.addedFromSKUList = returnData.data.addedFromSKUList[0];
        }
        $("#MiniShoppingCart").refreshWidget("refresh", param);
    });

    var postRefreshHandler = function() {
        //The dialog contents has changed..so destroy the old dialog with stale data..
        destroyDialog("MiniShopCartProductAdded");

        if (showDropdown) {
            update_content = true;
            //We have added item to cart..So display the drop down with item added message..
            positionMiniShopCartDropDown("widget_minishopcart", 'MiniShopCartProductAdded', 'orderItemAdded');
            showDropdown = false;
        }

        if (!multiSessionEnabled) {
            updateCartCookie();
        }

        populateProductAddedDropdown();

        if (!multiSessionEnabled) {
            resetDeleteCartCookie();
        }
    };

    // initialize widget
    $("#MiniShoppingCart").refreshWidget({ renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler });
}

function declareMiniShopCartContentsRefreshArea() {
    // ============================================
    // div: MiniShopCartContents refresh area
    // Declares a new refresh controller for the Mini Shopping Cart contents

    // Declares a new render context for the Mini Shopping Cart contents.
    wcRenderContext.declare("MiniShopCartContentsContext", ["MiniShopCartContents"], { status: "init", relativeId: "", contentId: "", contentType: "" });

    /*
     * Refreshes the mini shopping cart contents since it is out of date.
     * This function is called when a render context changed event is detected.
     */
    var renderContextChangedHandler = function(event, data) {
        if (!dropdownUpdated) {
            wcRenderContext.getRenderContextProperties("MiniShopCartContentsContext").fetchCartContents = true;
            dropdownUpdated = true;
            $("#MiniShopCartContents").refreshWidget("refresh", wcRenderContext.getRenderContextProperties("MiniShopCartContentsContext"));
        }
    };

    /*
     * Indicate that the mini cart contents are out of date upon an order change action.
     * This function is called when a modelChanged event is detected.
     */
    var events = $.extend({}, order_updated, { "AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage", "AjaxRESTOrderLockUnlockOnBehalf": "AjaxRESTOrderLockUnlockOnBehalf" });
    wcTopic.subscribe(events, function() {
        dropdownUpdated = false;
    });

    /*
     * Displays and positions the mini shop cart contents.
     * This function is called after a successful refresh.
     */
    var postRefreshHandler = function() {
        var renderContextProperties = wcRenderContext.getRenderContextProperties("MiniShopCartContentsContext");
        positionMiniShopCartDropDown(renderContextProperties.relativeId, renderContextProperties.contentId, renderContextProperties.contentType);
        //
        // This is needed for CSR solution. When CSR and shopper are browsing the store in simultaenously in
        // different browsers and if CSR locks/unlocks the shoppers cart, the miniCart in shopper's browser will
        // NOT reflect the change unless shopper takes some order related actions (add/delete from cart).
        // So to update the miniCart status loadMiniCart() function is called here.
        // It doesn't make another server call. The data returned from the MiniCartContentsUI is used
        // to refresh the miniCart summary.
        //
        updateCartCookie();
        loadMiniCart(WCParamJS.commandContextCurrency, WCParamJS.langId);
    };

    // initialize widget
    $("#MiniShopCartContents").refreshWidget({ renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler });

}

/*
 * Displays the dropdown content of the mini shopping cart when the user hovers over the
 * mini shopping cart if the contents are up-to-date or retrieve the latest contents from server.
 *
 * @param {string} relativeId The id of a placeholder element to position the dropdown relatively
 * @param {string} contentId The id of the content pane containing the mini shopping cart dropdown contents
 * @param {string} contentType The content that will be shown in the expanded mini shopping cart dropdown.
 */
function showMiniShopCartDropDown(relativeId, contentId, contentType) {
    //isOnPasswordUpdateForm flag is set at UpdatePasswordForm.jsp, in other cases the variable type will always be undefined or value equals false.
    // Need this line otherwise it'll throw a isOnPasswordUpdateForm is undefined error
    var isOnPasswordUpdateForm = isOnPasswordUpdateForm;
    if (!dropdownInit && (Utils.isUndefined(isOnPasswordUpdateForm) || isOnPasswordUpdateForm == false)) {
        dropdownInit = true;
        if (!dropdownUpdated) {
            update_content = true;
            var params = {
                status: "load",
                relativeId: relativeId,
                contentId: contentId,
                contentType: contentType,
                page_view: "dropdown"
            };
            wcRenderContext.updateRenderContext("MiniShopCartContentsContext", params);
        } else {
            positionMiniShopCartDropDown(relativeId, contentId, contentType);
        }
    }
}

function toggleMiniShopCartDropDown(relativeId, contentId, contentType) {
    if (dialogWidget && dialogWidget._isOpen) {
        dialogWidget.close();
    } else {
        showMiniShopCartDropDown(relativeId, contentId, contentType);
    }
}

/*
 * Displays the dropdown content of the mini shopping cart.
 *
 * @param {string} relativeId The id of a placeholder element to position the dropdown relatively
 * @param {string} contentId The id of the content pane containing the mini shopping cart dropdown contents
 * @param {string} contentType The content that will be shown in the expanded mini shopping cart dropdown.
 */
function positionMiniShopCartDropDown(relativeId, contentId, contentType) {
    var add_event_handlers = function(contentElement) {
        contentElement.on("wcdialogopen", function(event) {
            //deactivate(document.getElementById("header"));
            $("#" + relativeId).addClass("selected");
        });

        contentElement.on("wcdialogclose", function(event) {
            $("#" + relativeId).removeClass("selected");
        });
    };

    // Dialog is not yet created..Create one
    if (!dialogWidget) {
        var content = $("#" + contentId);
        if (contentId === "MiniShopCartProductAdded") {
            // The content may have been hidden so show it
            $("#MiniShopCartProductAddedWrapper").removeAttr("style");
        }
        dialogWidget = content.WCDialog({
            position: {
                my: "right top",
                at: "right bottom",
                of: "#widget_minishopcart"
            },
            autoOpen: false,
            open: function() {
                // Make the element show up on top of the header elements
                dialogWidget.element.parent().css("z-index", 1);


                if (contentType == 'orderItemAdded') {
                    $("#MiniShopCartProductAddedWrapper").css("display", "block");
                }
            },
            appendTo: "#headerRow1",
            title: $("#" + contentId + "_ACCE_Label").html(),
            show_title: false,
            width: "360px",
            //dialogClass: "no-close",
            modal: false


        }).data("wc-WCDialog");
        add_event_handlers(content);
        update_content = false;
		
		/* APPLEPAY BEGIN */
		if (typeof(showApplePayButtons) == "function") {
			showApplePayButtons();
		}
		/* APPLEPAY END */

    } else {
        dialogWidget.close();
        if (update_content) {
            if (contentType == 'orderItemAdded') {
                $("#MiniShopCartProductAddedWrapper").css("display", "block");
            }
            var newContent = $("#" + contentId);
            dialogWidget.update_content("#" + contentId);
            add_event_handlers(newContent);
            update_content = false;
        }

    }

    if (Utils.get_IE_version() < 7) {
        dialogWidget.css("display", "block");
    }

    $("html, body").animate({
        scrollTop: 0
    }, {
        duration: 200,
        complete: function() {
            dialogWidget.open();
            dialogWidget.reposition();
        }
    });

    dropdownInit = false;
}

/*
 * Store the current mini cart information in the mini cart cookie.
 */
function updateCartCookie() {
    //Save current order information into cookie
    if ($("#currentOrderQuantity").length && $("#currentOrderAmount").length && $("#currentOrderCurrency").length && $("#currentOrderId").length && $("#currentOrderLanguage").length) {
        var cartQuantity = $("#currentOrderQuantity").val();
        var cartAmount = $("#currentOrderAmount").val();
        var cartCurrency = $("#currentOrderCurrency").val();
        var cartLanguage = $("#currentOrderLanguage").val();
        var cartOrderId = $("#currentOrderId").val();
        var currentOrderLocked = $("#currentOrderLocked").val();

        //Clear out previous cookies
        var orderIdCookie = getCookie("WC_CartOrderId_" + WCParamJS.storeId);
        if (orderIdCookie != null) {
            setCookie("WC_CartOrderId_" + WCParamJS.storeId, null, {
                expires: -1,
                path: '/',
                domain: cookieDomain
            });
            var cartTotalCookie = getCookie("WC_CartTotal_" + orderIdCookie);
            if (cartTotalCookie != null) {
                setCookie("WC_CartTotal_" + orderIdCookie, null, {
                    expires: -1,
                    path: '/',
                    domain: cookieDomain
                });
            }
        }
        setCookie("WC_CartOrderId_" + WCParamJS.storeId, cartOrderId, {
            path: '/',
            domain: cookieDomain
        });
        if (cartOrderId !== "") {
            setCookie("WC_CartTotal_" + cartOrderId, cartQuantity + ";" + cartAmount + ";" + cartCurrency + ";" + cartLanguage + ";" + currentOrderLocked, {
                path: '/',
                domain: cookieDomain
            });
        }
    } else {
        setCookie("WC_CartOrderId_" + WCParamJS.storeId, "", { path: '/', domain: cookieDomain });
    }
}

function setProductAddedList(newProductAddedList) {
    productAddedList = newProductAddedList;
}

/*
 * Populates the Product Added dropdown upon an add to cart action.
 */
function populateProductAddedDropdown() {

    var search = '"';

    var replaceStr = "'";
    for (productId in productAddedList) {
        var productDetails = productAddedList[productId];

        if ($("#MiniShopCartAddedProdName_" + productId).length && productDetails[0] != null && productDetails[0].length != 0) {
            $("#MiniShopCartAddedProdName_" + productId).html(productDetails[0]);
        }
        if ($("#MiniShopCartAddedProdImgSrc_" + productId).length && productDetails[1] != null && productDetails[1].length != 0) {
            $("#MiniShopCartAddedProdImgSrc_" + productId).attr("src", productDetails[1]);
            document.getElementById('MiniShopCartAddedProdImgSrc_' + productId).alt = productDetails[0];
        }
        if ($("#MiniShopCartAddedProdPrice_" + productId).length && productDetails[2] != null && productDetails[2].length != 0) {
            $("#MiniShopCartAddedProdPrice_" + productId).html(productDetails[2]);
        }
        if ($("#MiniShopCartAddedProdQty_" + productId).length && productDetails[3] != null && productDetails[3].length != 0) {
            $("#MiniShopCartAddedProdQty_" + productId).html(productDetails[3]);
        }

        if ($("#MiniShopCartAddedProdAttr_" + productId).length && productDetails[4] != null && productDetails[4].length != 0) {
            $("#MiniShopCartAddedProdAttr_" + productId).html("");

            for (attrName in productDetails[4]) {
                attrValue = productDetails[4][attrName];
                if (attrValue != null && attrValue != 'undefined') {
                    attrValue = attrValue.replace(/&amp;/g, "&").replace(/&#039;/g, "'").replace(/&#034;/g, '"').replace(replaceStr, search);
                }
                document.getElementById('MiniShopCartAddedProdAttr_' + productId).innerHTML += '<div>' + attrName + ': ' + attrValue + '</div>';
            }
        }
    }
    wcTopic.publish("ProductInfo_Reset");
}

/*
 * Loads mini shop cart info upon page load.
 * @param {String} contextCurrency Current currency selected.
 * @param {String} langId Current language selected.
 */
function loadMiniCart(contextCurrency, langId) {
    var updateCart = false;

    var orderIdCookie = getCookie("WC_CartOrderId_" + WCParamJS.storeId);

    if (checkDeleteCartCookie()) {
        updateCart = true;
    } else if (orderIdCookie != undefined && orderIdCookie === "") {
        var subtotal = document.getElementById("minishopcart_subtotal");
        var formattedSubtotal = null;
        if ($("#currentOrderAmount").length) {
            formattedSubtotal = Utils.formatCurrency($("#currentOrderAmount").val(), {
                currency: contextCurrency
            });
        }
        if (formattedSubtotal == null && $("#currentOrderAmount").length) {
            formattedSubtotal = $("#currentOrderAmount").val();
        }

        if (subtotal != null) {
            subtotal.innerHTML = "\n " + formattedSubtotal + "\n ";
        }
        var items = document.getElementById("minishopcart_total");
        if (items != null) {
            var itemsMsg = null;
            if ($("#currentOrderQuantity").length) {
                itemMsg = $("#currentOrderQuantity").val();
            }
            if (itemsMsg == null) {
                itemsMsg = "0";
            }
            items.innerHTML = "\n " + itemsMsg + "\n ";
        }
    } else if (orderIdCookie != undefined && orderIdCookie !== "") {
        var cartCookie = getCookie("WC_CartTotal_" + orderIdCookie);

        if (cartCookie != undefined && cartCookie != null && cartCookie !== "") {
            var orderInfo = cartCookie.split(";");

            if (orderInfo != null && orderInfo.length > 3) {
                if (orderInfo[2] == contextCurrency && orderInfo[3] == langId) {
                    var subtotal = document.getElementById("minishopcart_subtotal");
                    if (subtotal != null) {
                        var formattedSubtotal = null;
                        formattedSubtotal = Utils.formatCurrency(orderInfo[1].toString(), {
                            currency: contextCurrency
                        });
                        if (formattedSubtotal == null) {
                            formattedSubtotal = orderInfo[1].toString();
                        }
                        subtotal.innerHTML = "\n " + formattedSubtotal + "\n ";
                    }
                    var currentOrderLocked = false;
                    if (orderInfo[4] != null && orderInfo[4] == 'true') {
                        var currentOrderLocked = true;
                    }
                    var items = document.getElementById("minishopcart_total");
                    var lock = document.getElementById("minishopcart_lock");
                    if (items != null) {
                        var itemsMsg = orderInfo[0].toString();
                        items.innerHTML = "\n " + itemsMsg + "\n ";
                        if (currentOrderLocked) {
                            $(items).addClass("nodisplay");
                            $(lock).removeClass("nodisplay");
                        } else {
                            $(items).removeClass("nodisplay");
                            $(lock).addClass("nodisplay");
                        }
                    }
                } else {
                    updateCart = true;
                }
            } else {
                updateCart = true;
            }
        } else {
            updateCart = true;
        }
    } else {
        updateCart = true;
    }
    //isOnPasswordUpdateForm flag is set at UpdatePasswordForm.jsp, in other cases the variable type will always be undefined or value equals false.
    // Need this line otherwise it'll throw a isOnPasswordUpdateForm is undefined error
    var isOnPasswordUpdateForm = isOnPasswordUpdateForm;
    if (updateCart == true && (Utils.isUndefined(isOnPasswordUpdateForm) || isOnPasswordUpdateForm == false)) {
        wcRenderContext.updateRenderContext('MiniShoppingCartContext', {
            'status': 'load'
        });
    }
}

/*
 * Turn on the flag to indicate that the mini cart cookies should be refreshed.
 */
function setDeleteCartCookie() {
    setCookie("WC_DeleteCartCookie_" + WCParamJS.storeId, true, {
        path: '/',
        domain: cookieDomain
    });
}

/*
 * Check whether the mini cart cookies need to be updated or not.
 */
function checkDeleteCartCookie() {
    var deleteCartCookieVal = getCookie("WC_DeleteCartCookie_" + WCParamJS.storeId);

    if (deleteCartCookieVal != undefined && deleteCartCookieVal !== "") {
        if (deleteCartCookieVal == 'true') {
            return true;
        }
    }
    return false;
}

/*
 * Delete the flag that indicates the mini cart cookie should be refreshed.
 */
function resetDeleteCartCookie() {
    var deleteCartCookieVal = getCookie("WC_DeleteCartCookie_" + WCParamJS.storeId);

    if (deleteCartCookieVal != null) {
        setCookie("WC_DeleteCartCookie_" + WCParamJS.storeId, null, {
            expires: -1,
            path: '/',
            domain: cookieDomain
        });
    }
}
wcTopic.subscribe("ProductInfo_Added", setProductAddedList);