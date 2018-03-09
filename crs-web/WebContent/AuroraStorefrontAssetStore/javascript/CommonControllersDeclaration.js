//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This file provides the common controller variables and functions,
 * and links these controllers to listen to the defined render contexts in CommonContextsDeclarations.js.
 */

/**
 * @class The CommonControllersDeclarationJS class defines all the common variables and functions
 * for the controllers of the defined render contexts across all store pages.
 */
CommonControllersDeclarationJS = {
	
	/**
        * This variable stores the ID of the language that the store is currently using.
        * @private
        */
       langId: "-1",

       /**
        * This variable stores the ID of the current store.
        * @private
        */
       storeId: "",

       /**
        * This variable stores the ID of the catalog that is used in the store.
        * @private
        */
       catalogId: "",

       /**
        * Sets the common ids used in the store - language id, store id, and catalog id.
        *
        * @param {string} langId The id of the store language.
        * @param {string} storeId The id of the store.
        * @param {string} langId The id of the catalog used in the store.
        */
       setCommonParameters:function(langId,storeId,catalogId){
              this.langId = langId;
              this.storeId = storeId;
              this.catalogId = catalogId;
       },

       /**
        * Sets the URL of the specified refresh area.
        *
        * @param {string} refreshAreaId The id of the target refresh area.
        * @param {string} url The link to specify for the refresh area.
        */
       setRefreshURL:function(refreshAreaId,url){
              $("#" + refreshAreaId).attr("refreshurl", url);
       },

        declareAccountCouponRefreshArea:function() {
            // ============================================
            // div: CouponDisplay_Widget refresh area
            // Declares a new refresh controller for Coupon Wallet display.
            var myWidgetObj = $("#CouponDisplay_Widget");

            // model change
            wcTopic.subscribe(["AjaxCouponsAddRemove","AjaxWalletItemProcessServiceDelete"], function() {
                myWidgetObj.refreshWidget("refresh");
            });

            // initialize widget
            myWidgetObj.refreshWidget();
        },

        declareShopCartDisplayRefreshArea: function() {
            // ============================================
            // div: ShopCartDisplay refresh area
            // Declares a new refresh controller for the Shopping Cart display.
            var myWidgetObj = $("#ShopCartDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("ShopCartPaginationDisplay_Context");
            
            /**
             * Refreshs the shopping cart area when an update to the order is made,
             * such as add/remove items or update quantity/promotions etc.
             * This function is called when a modelChanged event is detected.
             */
            wcTopic.subscribe(order_updated, function() {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
                submitRequest(); //Till shop cart is refreshed, do not allow any other requests..
                cursor_wait();
            });
            
            /**
             * Displays the discounts and promotions area upon a successful refresh.
             *
             * @param {object} widget The registered refresh area
             */
            var postRefreshHandler = function () {
                resetRequest(); //Shop cart is refreshed, give the control to shopper...
                if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
                    savedOrdersJS.isCurrentOrderPage(true);
                }
                // Order level discount tooltip section - if the tooltip is defined, show the section after area is refreshed
                $("#discountDetailsSection").css("display", "block");
                // Promotion code tooltip section - if the tooltip is defined, show the section after area is refreshed
                $("#appliedPromotionCodes").css("display", "block");
                
                // select the proper shipmode that is saved in the cookie
                var orderId = myRCProperties["orderId"];
                if ($("#currentOrderId").length) {
                    orderId = document.getElementById("currentOrderId").value;
                }
                ShipmodeSelectionExtJS.displaySavedShipmentTypeForOrder(orderId);
                if ($("#OrderFirstItemId").length) {
                    ShipmodeSelectionExtJS.orderItemId = document.getElementById("OrderFirstItemId").value;
                }
                
                // evaluate scripts in shopping list
				/* TODO - Fix globalEval issue later.
                $('div[id^="shoppingListScript_"]').each(function(i, e) {
                   $.globalEval($(e).html()); 
                });
                
                $('input[id^="orderItem_"]').each(function(i, e) {
                    if ($('addToRequisitionListScript_' + $(e).val()) != null) {
                        $.globalEval($('addToRequisitionListScript_' + $(e).val()).html());
                    }
                    if ($('addReqListsJS_' + $(e).val()) != null) {
                        $.globalEval('addReqListsJS' + $(e).val() + '.setCatEntryId("' + $('catalogId_' + $(e).attr("id").substring($(e).attr("id").indexOf('_')+1)).val() + '");');
                    }
                });*/
                
                cursor_clear();
		/* APPLEPAY BEGIN */
		if (typeof(showApplePayButtons) == "function") {
			showApplePayButtons();
		}
		/* APPLEPAY END */
		
            };
            
            // initialize widget
            myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
        },
        
		declareShopCartPagingDisplayRefreshArea: function() {
            // ============================================
            // div: ShopCartPagingDisplay refresh area
            // Declares a new refresh controller for the Shopping Cart pagination display.
            var myWidgetObj = $("#ShopCartPagingDisplay");
			wcRenderContext.addRefreshAreaId("ShopCartPaginationDisplay_Context", "ShopCartPagingDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("ShopCartPaginationDisplay_Context");
		   /**
			* Displays the previous/next page of order items in the shopping cart.
			* This function is called when a render context changed event is detected.
			*
			* @param {string} message The render context changed event message
			* @param {object} widget The registered refresh area
			*/
			var renderContextChangedHandler = function() {
				if(wcRenderContext.testForChangedRC("ShopCartPaginationDisplay_Context", ["beginIndex"])){
                     myWidgetObj.refreshWidget("refresh", myRCProperties);
				}
            };
            
		   /**
			* Hide the progress bar upon a successful refresh.
			*
			* @param {object} widget The registered refresh area
			*/
            var postRefreshHandler = function () {
              cursor_clear();

              //select the proper shipmode that is saved in the cookie
              var orderId = myRCProperties["orderId"];
              if(document.getElementById("currentOrderId")) {
                orderId = document.getElementById("currentOrderId").value;
              }
              ShipmodeSelectionExtJS.displaySavedShipmentTypeForOrder(orderId);
              // evaluate scripts in shopping list
              $('div[id^="shoppingListScript_"]').each(function(i, e){
                 $.globalEval($(e).html());
              });
              $('input[id^="orderItem_"]').each(function(i,orderItem) {
                if($('addToRequisitionListScript_' + orderItem.value) != null){
                      $.globalEval($('addToRequisitionListScript_' + orderItem.value).innerHTML);
                }
                if($('addReqListsJS_' + orderItem.value).length != 0){
                  $.globalEval('addReqListsJS' + orderItem.value + '.setCatEntryId("' + $('catalogId_' + (orderItem.id.substring(orderItem.id.indexOf('_') + 1))).value + '");');
                }
              });
			};
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
		
		declarePromotionFreeGiftsDisplayRefreshArea: function() {
            // ============================================
            // div: PromotionFreeGiftsDisplay refresh area
            // Declares a new refresh controller for the Promotion Free Gifts display.
            var myWidgetObj = $("#PromotionFreeGiftsDisplay");
            wcRenderContext.addRefreshAreaId("PromotionFreeGifts_Context", "PromotionFreeGiftsDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("PromotionFreeGifts_Context");
            
            
			var renderContextChangedHandler = function() {
				myWidgetObj.refreshWidget("refresh", myRCProperties);
            };

            var postRefreshHandler = function () {
			    PromotionChoiceOfFreeGiftsJS.showFreeGiftsDialog();
			};
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
		
        declareRecentRecurringOrderDisplayRefreshArea: function() {
            // ============================================
            // div: RecentRecurringOrderDisplay refresh area
            // Declares a new refresh controller for Recent Recurring Orders in My Account landing page.
            var myWidgetObj = $("#RecentRecurringOrderDisplay");
            wcRenderContext.addRefreshAreaId("RecentRecurringOrderDisplay_Context", "RecentRecurringOrderDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("RecentRecurringOrderDisplay_Context");
            
            /**
             * Displays the previous/next page of recurring orders.
             * This function is called when a render context changed event is detected.
             */
            wcTopic.subscribe("AjaxCancelSubscription", function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });
            
            /**
            * Hide the progress bar upon a successful refresh.
            */
            var postRefreshHandler = function() {
                cursor_clear();
            };
            
            // initialize widget
            myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
        },
        
        declareRecentSubscriptionDisplayRefreshArea: function() {
            // ============================================
            // div: RecentSubscriptionDisplay refresh area
            // Declares a new refresh controller for recent Subscription display in My Account landing page.
            var myWidgetObj = $("#RecentSubscriptionDisplay");
            wcRenderContext.addRefreshAreaId("RecentSubscriptionDisplay_Context", "RecentSubscriptionDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("RecentSubscriptionDisplay_Context");
            
            /**
             * Displays the previous/next page of subscriptions.
             * This function is called when a render context changed event is detected.
             */
            wcTopic.subscribe("AjaxCancelSubscription", function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });
             
            /**
            * Hide the progress bar upon a successful refresh.
            */
            var postRefreshHandler = function() {
                cursor_clear();
            };
            
            // initialize widget
            myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
        },
        
        declareOrderItemPaginationDisplayRefreshArea: function(widgetId) {
            // ============================================
            // old controller: OrderItemPaginationDisplayController
            // div: OrderConfirmPagingDisplay refresh area
            // Declares a new refresh controller for Single Shipment Order Item display with pagination
            // on the Order Summary and Confirmation pages.
        	if(typeof widgetId == "object" || typeof widgetId == "array") {
        		widgetId = widgetId[0];
        	}
        	
            var myWidgetObj = $("#" + widgetId);
            wcRenderContext.addRefreshAreaId("OrderItemPaginationDisplay_Context", widgetId);
            var myRCProperties = wcRenderContext.getRenderContextProperties("OrderItemPaginationDisplay_Context");
            
            /**
             * Displays the previous/next page of order items for Single Shipment Order Summary/Confirmation display.
             * This function is called when a render context changed event is detected.
             */
            var renderContextChangedHandler = function() {
                if (wcRenderContext.testForChangedRC("OrderItemPaginationDisplay_Context", ["beginIndex"])){
                	myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            }
           
            /**
             * Hide the progress bar upon a successful refresh.
             */
            var postRefreshHandler = function() {
                cursor_clear();
                if (myRCProperties["analytics"] == 'true') {
                    wcTopic.publish("order_contents_ProductRec", $("#orderPartNumbers").val());
                }
            }          
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
        
        declareRecurOrderDisplayRefreshArea: function() {
            // ============================================
            // div: RecurringOrderDisplay refresh area
            // Declares a new refresh controller for Recurring Order display with pagination
            // in My Recurring Order page.
            var myWidgetObj = $("#RecurringOrderDisplay");
            wcRenderContext.addRefreshAreaId("RecurringOrderDisplay_Context", "RecurringOrderDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("RecurringOrderDisplay_Context");
            
            /**
             * Displays the previous/next page of recurring orders.
             * This function is called when a render context changed event is detected.
             */
             
            wcTopic.subscribe("AjaxCancelSubscription", function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });
            
            
            var renderContextChangedHandler = function() {
                if(wcRenderContext.testForChangedRC("RecurringOrderDisplay_Context", ["beginIndex"])){
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            }
           
            /**
             * Hide the progress bar upon a successful refresh.
             */
            var postRefreshHandler = function() {
                cursor_clear();
            }          
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },

        declareRecurOrderChildOrdersRefreshArea: function() {
            // ============================================
            // div: RecurringOrderChildOrdersDisplay refresh area
            // Declares a new refresh controller for Recurring Order child orders display with pagination
            // in Recurring Order Details History page.
            var myWidgetObj = $("#RecurringOrderChildOrdersDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("RecurringOrderChildOrdersDisplay_Context");
            
            /**
             * Displays the previous/next page of recurring orders.
             * This function is called when a render context changed event is detected.
             */
            var renderContextChangedHandler = function() {
                if(wcRenderContext.testForChangedRC("RecurringOrderChildOrdersDisplay_Context", ["beginIndex"])){
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            };
           
            /**
             * Hide the progress bar upon a successful refresh.
             */
            var postRefreshHandler = function() {
                cursor_clear();
            }          
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
        
        declareSubscriptionDisplayRefreshArea: function() {
            // ============================================
            // div: SubscriptionDisplay refresh area
            // Declares a new refresh controller for Subscription display with pagination
            // in My Subscription page.
            var myWidgetObj = $("#SubscriptionDisplay");
            wcRenderContext.addRefreshAreaId("SubscriptionDisplay_Context", "SubscriptionDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("SubscriptionDisplay_Context");
            
            /**
             * Displays the previous/next page of subscriptions.
             * This function is called when a render context changed event is detected.
             */
            wcTopic.subscribe("AjaxCancelSubscription", function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });
            
            
            var renderContextChangedHandler = function() {
                if(wcRenderContext.testForChangedRC("SubscriptionDisplay_Context", ["beginIndex"])){
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            }
           
            /**
             * Hide the progress bar upon a successful refresh.
             */
            var postRefreshHandler = function() {
                cursor_clear();
            }          
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
        
        declareSubscriptionChildOrdersRefreshArea: function() {
            // ============================================
            // div: SubscriptionChildOrdersDisplay refresh area
            // Declares a new refresh controller for Subscription child orders display with pagination
            // in Subscription Details History page.
            var myWidgetObj = $("#SubscriptionChildOrdersDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("SubscriptionChildOrdersDisplay_Context");
            
            /**
             * Displays the previous/next page of subscriptions.
             * This function is called when a render context changed event is detected.
             */
            var renderContextChangedHandler = function() {
                if(wcRenderContext.testForChangedRC("SubscriptionChildOrdersDisplay_Context", ["beginIndex"])){
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            };
           
            /**
             * Hide the progress bar upon a successful refresh.
             */
            var postRefreshHandler = function() {
                cursor_clear();
            }          
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
    
        declareQuickInfoDetails: function() {
            var widgetObj = $("#quickInfoRefreshArea"),
                rcProperties = wcRenderContext.getRenderContextProperties("QuickInfoContext");
            
            widgetObj.refreshWidget({
                formId: "",
                /**
                 * Refreshs the wishlist drop down in the quick info popup.
                 */
                renderContextChangedHandler: function() {
                    widgetObj.refreshWidget("refresh", rcProperties);
                },
                
                /**
                 * Hide the progress bar upon a successful refresh.
                 */
                postRefreshHandler: function() {
                	if ($("#catEntryParamsForJS").length){
                        var catEntryParams = $.parseJSON($("#catEntryParamsForJS").val());
                    }
                	
                    if ($("#QuickInfostoreParams").length){
                        var storeParams = $("#QuickInfostoreParams").val();
                        var shoppingListNames = $("#QuickInfoshoppingListNames").val();

                        shoppingListJSQuickInfo = new ShoppingListJS($.parseJSON(storeParams), catEntryParams, $.parseJSON(shoppingListNames),"shoppingListJSQuickInfo");


                        if (!this.quickInfoEvenSubscribed){
                            this.quickInfoEvenSubscribed = true;
                            wcTopic.subscribe("DefiningAttributes_Resolved", function(catEntryId, productId) {
                                shoppingListJSQuickInfo.setItemId(catEntryId, productId);
                            });
                            wcTopic.subscribe("QuickInfo_attributesChanged", function(catEntryAttributes) {
                                shoppingListJSQuickInfo.setCatEntryAttributes(catEntryAttributes);
                            });
                            wcTopic.subscribe("Quantity_Changed", function(catEntryQuantityObject) {
                                shoppingListJSQuickInfo.setCatEntryQuantity(catEntryQuantityObject);
                            });
                            wcTopic.subscribe("ShoppingList_Changed", function(serviceResponse) {
                                shoppingListJSQuickInfo.updateShoppingListAndAddItem(serviceResponse);
                            });
                            wcTopic.subscribe("ShoppingListItem_Added", function() {
                                shoppingListJSQuickInfo.deleteItemFromCart();
                            });
                            $("#QuickInfoaddToShoppingListDropdown").on("mouseover", function(){
                                shoppingListJSQuickInfo.mouseOnArrow = true;
                            });
                            $("#QuickInfoShoppingList_0").on("mouseover", function(){
                                shoppingListJSQuickInfo.exceptionFlag = true; $("#QuickInfoShoppingListLink_0").focus();
                            });
                        }

                        var catEntryId = catEntryParams.id;
                        if(null != catEntryId && '' != catEntryId){
                            wcRenderContext.updateRenderContext('QuickInfoDiscountDetailsContext', {productId: catEntryParams.id});
                        }
                    }
                    if ($("#catEntryParamsForJS").length){
                        QuickInfoJS.catEntryParams = $.parseJSON($("#catEntryParamsForJS").val());
                    }
                    //the quick info dialog is hidden by default. We have to display it after the area is refreshed.
                    var quickInfoPopup = $("#quickInfoPopup").data("wc-WCDialog");
                    if (quickInfoPopup) {
                        closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this.
                        // if itemId is present, then quickInfo popup is from change attribute link in shopping cart page, which will explicitly set the quantity
                        if(QuickInfoJS.itemId == ''){
                            QuickInfoJS.setCatEntryQuantity(1);
                            QuickInfoJS.selectDefaultSwatch();
                        } else {
                            QuickInfoJS.selectCurrentAttributes();
                        }
                        quickInfoPopup.open();
                        // disable dialog re-position for ios and android right after the dialog is opened, this is to avoid virtual keyboard conflict
                        //if (ios || android) {
                        // quickInfoPopup._relativePosition = new Object();
                        //}
                        if(typeof TealeafWCJS !== 'undefined'){
                            TealeafWCJS.rebind("quickInfoPopup");
                        }
                    }else {
                        console.debug("quickInfoPopup does not exist");
                    }
                    cursor_clear();
                }
            });
        },
        
        /**
         * Refresh controller for fetching discount details for quick info.
         */
        declareQuickInfoDiscountDetailsController: function() {
            var widgetObj = $("#quickInfoDiscountDetailsRefreshArea");
            wcRenderContext.addRefreshAreaId("QuickInfoDiscountDetailsContext", "quickInfoDiscountDetailsRefreshArea");
            var renderContextProperties = wcRenderContext.getRenderContextProperties("QuickInfoDiscountDetailsContext");
            
            widgetObj.refreshWidget({
                formId: "", 
                /**
                 * Refreshes the discount section.
                 */
                renderContextChangedHandler: function() {
                    widgetObj.refreshWidget("refresh", renderContextProperties);
                },
                /**
                 * Hide the progress bar upon a successful refresh.
                 */
                postRefreshHandler: function() {
                    cursor_clear();
                }
            });
            
        },
		
		declareMSOrderItemPagingDisplayRefreshArea:function(widgetName) {

			var contextName = "MSOrderItemPaginationDisplay_Context";
			if(typeof widgetName == "object") {
				widgetName = widgetName[0];
			}
			var myWidgetObj = $("#"+widgetName);

			if (!wcRenderContext.checkIdDefined(contextName)) {
				wcRenderContext.declare(contextName, [],null);
			}
			var myRCProperties = wcRenderContext.getRenderContextProperties(contextName);
			wcRenderContext.addRefreshAreaId(contextName, widgetName);
			
		   /** 
			* Displays the previous/next page of order items for Multiple Shipment Order Summary/Confirmation display.
			* This function is called when a render context changed event is detected. 
			* 
			*/
		   renderContextChangedHandler = function() {
			    if(wcRenderContext.testForChangedRC(contextName,["beginIndex"])){
					myWidgetObj.refreshWidget("refresh", myRCProperties);
				}
		   };

		   /** 
			* Hide the progress bar upon a successful refresh.
			* 
			* @param {object} widget The registered refresh area
			*/
		   postRefreshHandler = function() {
				  cursor_clear();
				  if (myRCProperties["analytics"] == 'true') {
					  wcTopic.publish("order_contents_ProductRec", $("#orderPartNumbers").value);
				  }
		   };

			// initialize widget
			myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
		},

        /** 
         * Declares a new refresh controller for Single Shipment Order Item display with pagination
         * on the Order Summary pages when inegrating with Sterling. 
         */
        declareSSFSOrderItemPaginationDisplayController: function() {
            var myWidgetObj = $("#OrderConfirmPagingDisplay");
            wcRenderContext.addRefreshAreaId("OrderItemPaginationDisplay_Context", "OrderConfirmPagingDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("OrderItemPaginationDisplay_Context");

            // initialize widget
            myWidgetObj.refreshWidget({
                /** 
                 * Displays the previous/next page of order items for Single Shipment Order Summary/Confirmation display.
                 * This function is called when a render context changed event is detected.
                 */
                renderContextChangedHandler: function() {
                    if(wcRenderContext.testForChangedRC("OrderItemPaginationDisplay_Context", ["beginIndex"])){
                        myWidgetObj.refreshWidget("refresh", myRCProperties);
                    }
                },

                /** 
                 * Hide the progress bar upon a successful refresh.
                 */
                postRefreshHandler: function() {
                    var orderStr = document.getElementById("jsonOrderStr").innerHTML;
                    var beginIndex = myRCProperties['beginIndex'];
                    var pageSize = myRCProperties['pageSize'];
                    sterlingIntegrationJS.populateOrderLineInfoForSingleShipment(orderStr, beginIndex, pageSize);
                    cursor_clear();
                }
            });
        },

        /** 
         * Declares a new refresh controller for Multiple Shipment Order Item display with pagination
         * on the Order Summary when integrating with Sterling.
         */
        declareSSFSMSOrderItemPaginationDisplayController: function() {
            var myWidgetObj = $("#MSOrderDetailPagingDisplay");
            wcRenderContext.addRefreshAreaId("MSOrderItemPaginationDisplay_Context", "MSOrderDetailPagingDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("MSOrderItemPaginationDisplay_Context");

            // initialize widget
            myWidgetObj.refreshWidget({
                /** 
                 * Displays the previous/next page of order items for Multiple Shipment Order Summary/Confirmation display.
                 * This function is called when a render context changed event is detected. 
                 */
                renderContextChangedHandler: function() {
                    if(wcRenderContext.testForChangedRC("MSOrderItemPaginationDisplay_Context", ["beginIndex"])){
                        myWidgetObj.refreshWidget("refresh", myRCProperties);
                    }
                },

                /** 
                 * Hide the progress bar upon a successful refresh.
                 */
                postRefreshHandler: function() {
                    var orderStr = document.getElementById("jsonOrderStr").innerHTML;
                    var beginIndex = myRCProperties['beginIndex'];
                    var pageSize = myRCProperties['pageSize'];
                    sterlingIntegrationJS.populateOrderLineInfoForMultipleShipment(orderStr, beginIndex, pageSize);
                    cursor_clear();
                }
            });
        }
}

// convert in future - move from CommonControllersDeclaration.js: 
        // id: "ShopCartPaginationDisplayController",
        // id: "PendingOrderPaginationDisplayController",
        // id: "ListOrdersDisplay_Controller",
        // id: "PendingOrderDisplayController",
        // id: "BrowsingHistoryController",
        // id: "BrowsingHistoryDisplay_Controller",
        // id: "CategorySubscriptionController",
        // id: "RecentSubscriptionDisplayController",
        // id: "DiscountDetailsController",
        // id: "DoubleContentAreaESpot_Controller",
        // id: "ScrollableESpot_Controller",
        // id: "TopCategoriesESpot_Controller",
        // id: "CategoryFeaturedProductsESpot_Controller",
        // id: "HomeHeroESpot_Controller",
        // id: "HomeLeftESpot_Controller",
        // id: "HomeRightTopESpot_Controller",
        // id: "HomeRightBottomESpot_Controller",
        // id: "TallDoubleContentAreaESpot_Controller",
        // id: "TopCategoryHeroESpot_Controller",
        // id: "TopCategoryTallDoubleESpot_Controller",
        // id: "AttachmentPagination_Controller",

