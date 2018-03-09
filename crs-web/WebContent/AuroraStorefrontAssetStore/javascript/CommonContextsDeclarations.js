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
 * @fileOverview This file provides the common render context variables and functions, 
 * and defines all the render contexts needed throughout the store.
 */

/** 
 * @class The CommonContextsJS class defines all the common variables and functions 
 * for the render contexts across all store pages.
 */
CommonContextsJS = {
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
	 * Updates the specified context's property and assign it the desired value.
	 * 
	 * @param {string} contextId The id of the render context 
	 * @param {string} property The name of the context's property to update
	 * @param {string} value The value to update the specified property to
	 */
	setContextProperty:function(contextId,property,value){
        wcRenderContext.getRenderContextProperties(contextId)[property] = value;
	}

}

/**
 * Declares a new render context for Multiple Shipment Shipping & Billing display.
 */
wcRenderContext.declare("multipleShipmentDetailsContext", [], {shipmentDetailsArea: "update"}),

/**
 * Declares a new render context for Single Shipment Shipping Charge display.
 */
wcRenderContext.declare("singleShipmentShipChargeContext", [], null),

/**
 * Declares a new render context for Multiple Shipment Shipping Charge display.
 */
wcRenderContext.declare("multipleShipmentShipChargeContext", [], null),

/**
 * Declares a new render context for Single Shipment Shipping & Billing display.
 */
wcRenderContext.declare("traditionalShipmentDetailsContext", [], {shipmentDetailsArea: "update"}),

/**
 * Declares a new render context for the Current Order Totals display.
 */
wcRenderContext.declare("currentOrder_Context", [], null),

/**
 * Declares a new render context for creating/editing the shipping address
 * and initializes it with the shipping address id and address type to the default placeholder values.
 */
wcRenderContext.declare("editShippingAddressContext", [], {shippingAddress: "0",addressType: "ShippingAndBilling"}),

/**
 * Declares a new render context for dealing with states for the shipping addresses in all shipments
 * and initializes it with the shipping address id to the default placeholder values.
 */
wcRenderContext.declare("shippingAddressContext",[],{shippingAddress: "0"});

/**
 * Declares a new render context for the select Billing Address dropdowns,
 * and initializes each Billing Address dropdown with address id and billing url placeholders.
 * Even though BillingURL1, 2, 3 point to same BillingAddressDropDisplay.jsp we cannot use only one URL to submit 3 requests.
 * There are 3 billing dropdown boxes in the Checkout page and all needs to be refreshed on address add/change.
 * But using the same URL and submitting 3 requests separately to refresh 3 dropdown boxes doesn't work, 
 * and invariably one of the request doesn't come back with response. Solution is to use 3 different URLs as a workaround.
 * BillingURL1,2,3 are set to correct <c:url values in .JSP page using setContextPRoperty method..
 */
wcRenderContext.declare("billingAddressDropDownBoxContext", [], {billingAddress1: "0", billingAddress2: "0", billingAddress3: "0", billingURL1: "",billingURL2:"",billingURL3:"",areaNumber:'0',payment1: "", payment2: "", payment3: "", paymentTCId1: "", paymentTCId2: "", paymentTCId3: ""}),

/**
 * Declares a new render context for 3 payment areas
 * and initializes it with the payment method names, current area number, billing modes and current total price to the default placeholder values.
 * When the context changes the corresponding controller will be used and the paymentArea div will be populated with the required JSP file, based on the
 * selection made...ex: if Visa brand is selected in payment1, then paymentArea1 will get populated with contents of Visa.jsp
 */
wcRenderContext.declare("paymentContext", [], {payment1: "empty", payment2: "empty", payment3: "empty", currentAreaNumber: "1", billingMode1: "none", billingMode2: "none", billingMode3: "none",currentTotal:"0"}),

/**
 * Declares a new render context for showing/hiding the address form on the Checkout pages,
 * and initializes the show and hide area to a placeholder value.  
 */
wcRenderContext.declare("contextForMainAndAddressDiv", [], {showArea: "0",hideArea: "0"}),

/**
 * Declares a new render context for the select Shipping Address dropdown.
 */
wcRenderContext.declare("shippingAddressDropDownBoxContext", [], {}),

/**
 * Declares a new render context for the Category display with pagination.
 */
wcRenderContext.declare("CategoryDisplay_Context", [], {pageView:"", beginIndex:""}),

/**
 * Declares a new render context for the Sub-category display with pagination.
 */
wcRenderContext.declare("SubCategoryDisplay_Context", [], null),

/**
 * Declares a new render context for Shopping Cart with pagination,
 * and initializes it with the beginning index value. 
 */
wcRenderContext.declare("ShopCartPaginationDisplay_Context", [], {}),
/**
* Declares a new render context for Pending order details page with pagination,
* and initializes it with the beginning index value. 
*/
wcRenderContext.declare("PendingOrderPaginationDisplay_Context", [], {}),
/**
* Declares a new render context for the pending order details page with pagination,
* and initializes it with the beginning index value. 
*/
wcRenderContext.declare("PendingOrderDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for Single Shipment Order Summmary/Confirmation with pagination,
 * and initializes it with the beginning index value. 
 */
wcRenderContext.declare("OrderItemPaginationDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for the Order Status Details with pagination,
 * and initializes it with the beginning index value. 
 */
wcRenderContext.declare("OrderDetailPaginationDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for Multiple Shipment Order Summary/Confirmation with pagination,
 * and initializes it with the beginning index value.
 */
wcRenderContext.declare("MSOrderItemPaginationDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for the Coupon Wallet display.
 */
wcRenderContext.declare("CouponDisplay_Context", [], null),
/**
 * Declares a new render context for the Promotion Choice of free gifts pop-up display.
 */
wcRenderContext.declare("PromotionFreeGifts_Context", [], {}),

/**
 *  Declares a new render context for the saved orders list.
 */
wcRenderContext.declare("ListOrdersDisplay_Context", [], {startNumber: "0"}),

/**
 * Declares a new render context for the scheduled orders status display.
 */
wcRenderContext.declare("ScheduledOrdersStatusDisplay_Context", [], {beginIndex: "0", selectedTab: "Scheduled"}),

/**
 * Declares a new render context for the processed orders status display.
 */
wcRenderContext.declare("ProcessedOrdersStatusDisplay_Context", [], {beginIndex: "0", selectedTab: "PreviouslyProcessed"}),

/**
 * Declares a new render context for the waiting-for-approval orders status display.
 */
wcRenderContext.declare("WaitingForApprovalOrdersStatusDisplay_Context", [], {beginIndex: "0", selectedTab: "WaitingForApproval"}),

/**
 * Declares a new render context for the Browsing History Espot.
 */
wcRenderContext.declare("BrowsingHistoryContext", [], {status:"init"}),

/**
 * Declares a new render context for the Browsing History Display in My Account.
 */
wcRenderContext.declare("BrowsingHistoryDisplay_Context", [], {currentPage: "0", pageView: ""}),

/**
 * Declares a new render context for the subscription display area on category pages.
 */
wcRenderContext.declare("CategorySubscriptionContext", [], null),

/**
 * Declares a new render context for the recurring order display.
 */
wcRenderContext.declare("RecurringOrderDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for the subscription display.
 */
wcRenderContext.declare("SubscriptionDisplay_Context", [], {beginIndex: "0"}),

/**
 * Declares a new render context for the recent recurring order display.
 */
wcRenderContext.declare("RecentRecurringOrderDisplay_Context", [], {beginIndex: "0",isMyAccountMainPage:"true"}),

/**
 * Declares a new render context for the recent subscription display.
 */
wcRenderContext.declare("RecentSubscriptionDisplay_Context", [], {beginIndex: "0",isMyAccountMainPage:"true"}),

/**
 * Declares a new render context for the recurring order child orders display.
 */
wcRenderContext.declare("RecurringOrderChildOrdersDisplay_Context", [], {beginIndex: "0",orderId: ""}),

/**
 * Declares a new render context for the subscription child orders display.
 */
wcRenderContext.declare("SubscriptionChildOrdersDisplay_Context", [], {beginIndex: "0",orderItemId: "",subscriptionName: ""}),

/**
 * Declares a new render context for the QuickInfo.
 */
wcRenderContext.declare("QuickInfoContext", ["quickInfoRefreshArea"], {}),

/**
 * Declares a new render context for the Discounts.
 */
wcRenderContext.declare("DiscountDetailsContext", [], null),

/**
 * Declares a new render context for the Discounts in quick info.
 */
wcRenderContext.declare("QuickInfoDiscountDetailsContext", [], {}),

/**
 * Declares a new render context for double content area espot.
 */
wcRenderContext.declare("DoubleContentAreaESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for scrollable espot.
 */
wcRenderContext.declare("ScrollableESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for top categories espot.
 */
wcRenderContext.declare("TopCategoriesESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for featured products in category espot.
 */
wcRenderContext.declare("CategoryFeaturedProductsESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for home hero espot.
 */
wcRenderContext.declare("HomeHeroESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for home left espot.
 */
wcRenderContext.declare("HomeLeftESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for home right top espot.
 */
wcRenderContext.declare("HomeRightTopESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for home right bottom espot.
 */
wcRenderContext.declare("HomeRightBottomESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for tall double espot.
 */
wcRenderContext.declare("TallDoubleContentAreaESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for top category hero espot.
 */
wcRenderContext.declare("TopCategoryHeroESpot_Context", [], {emsName: ""}),

/**
 * Declares a new render context for top category tall double espot.
 */
wcRenderContext.declare("TopCategoryTallDoubleESpot_Context", [], {emsName: ""}),


wcRenderContext.declare("AttachmentPagination_Context", [], {beginIndex: "0"})
