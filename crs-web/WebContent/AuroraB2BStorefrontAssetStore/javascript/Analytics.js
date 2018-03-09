//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * @fileOverview This file triggers various Coremetrics events upon user actions. The following five events are supported:
 * 1. pageview: This event is triggered when a new page is loaded, part of a page is refreshed, or the mini shopping cart is accessed
 * 2. productview: This event is triggered when a catalog entry is viewed using Quick Info button
 * 3. cartview: This event is triggered when a user's cart is updated in any way, such as item being added, item being
 *    deleted, quantity being updated, shipping being updated, and payment being updated.
 * 4. element: This event is triggered when filtering criteria or sorting criteria in a fast finder is updated.
 * 5. registration: This event is triggered when the user updates his account information
 *
 * @version 1.0
 *
 **/

/**
* @class analyticsJS This class defines all the variables and functions used by the Analytics.js
* One and only one global analyticsJS should be created. Therefore, we create this object only when it is not present in
* in the global namespace.
*
**/

if(typeof(analyticsJS) === "undefined" || !analyticsJS || !analyticsJS.topicNamespace){
    analyticsJS = {
        /** The storeId this object is used for.**/
        storeId: 0,

        /** The catalogId the user uses **/
        catalogId: 0,

        /** The URL prefix used for invoking JSON views **/
        urlPath: null,

        /** The Mini Shopping cart title will be used in publishStoreAccordionPageView **/
        miniShopCartTitle: "MiniShoppingCart",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics page view **/
        jsonPageView: "AnalyticsPageView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics product view **/
        jsonProductView: "AnalyticsProductView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics element view **/
        jsonElementView: "AnalyticsElementView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics cart view **/
        jsonShopcartView: "AnalyticsShopcartView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics add cart **/
        jsonAddCart: "AnalyticsShopcartView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics registration view **/
        jsonRegistrationView: "AnalyticsRegistrationView",

        /** The name of the view that will be used to retrieve JSON data for Coremetrics conversion event **/
        jsonConversionEventView: "AnalyticsConversionEventView",

        /** The namespace of any Commerce implementation of Coremetrics event. For example, if an element event
         *  will be of form "/wc/analytics/element". To generalize, each Coremetric topic/event follows this
         *   grammar: <topicNamespace><event name>
         */
        topicNamespace: "/wc/analytics/",

        /** The name of the page view event **/
        pageView: "pageview",

        /** The name of the product view event **/
        productView: "productview",

        /** The name of the cart view event **/
        cartView: "cartview",

        /** The name of the add cart event **/
        addCart: "addcart",

        /** The name of the element view **/
        element: "element",

        /** The name of the registration view **/
        registration: "registration",

        /** The name of the conversion event view **/
        conversionEvent: "conversionevent",

        /** A boolean flag to control the page views triggered through minishop cart views **/
        pageViewControl: false,

        incTaxInUnitPriceForCart: "F",

        /**
         * The list of service requests that should result in a cart view event. Each item in the list
         * is an legitimate action ID used in a service. Refer to the wcService.* for details.
         * Assumption: Each service topic will be of form "modelChanged/<actionID>".
         */
        cartViewActionIdList: [
            "AjaxDeleteOrderItem",
            "AjaxUpdateOrderItem"
        ],

        /**
         * The list of service requests that should result in a add cart event. Each item in the list
         * is an legitimate action ID used in a service. Refer to the wcService.* for details.
         * Assumption: Each service topic will be of form "modelChanged/<actionID>".
         */
        addCartActionIdList: [
            "AddOrderItem",
            "AjaxAddOrderItemWithShipingInfo",
        ],

        /** The list of service requests that should result in ajax wishlist update page view event.**/
        wishlistPageIdList: [
            "AjaxInterestItemAdd",
            "InterestItemDelete",
            "AjaxRestWishListAddItem",
            "AjaxRestWishListRemoveItem",
            "ShoppingListServiceAddItem"

        ],
        /** The list of service requests that should result in ajax multiple wishlist add conversionevent.**/
        conversionEventList : [
            "AjaxInterestItemAdd",
            "AjaxRestWishListAddItem",
            "AjaxInterestItemAddAndDeleteFromCart",
            "ShoppingListServiceAddItem",
            "AnalyticsConversionEvent"

        ],

        /**
        * This function retrieves all the required data for cart view event, and then publishes a  view event with the retrieved data
        *
        * @param {String} jsonViewName name of the view that will be called to get Coremetrics event data
        * @param {String} urlParams  The URL parameters passed to the jsonViewName when it is be called.For example: {storeId: 0, shopperStoreId: 10001}
        * @param {object} publisher  A function that takes a single parameter. The parameter will be the
        *                            retrieved data. It is up to this function to decide if a Coremetrics view
        *                            will be published. This function will be invoked under the context of this object. For example: function(data){this.publishTopic("/wc/analytics/cartview", data);}
        **/
        publishAnalyticsView: function(jsonViewName, urlParams, publisher){
            var scope = this;
            var kw = {
                url:        getAbsoluteURL() + jsonViewName,
                method:     'GET',
                dataType:   'json',
                data:       $.extend({storeId:scope.storeId, catalogId:scope.catalogId}, urlParams),
                error:      function(type, textStatus){
                                // Hidden tags should not interrupt user interactions. Therefore, no error will be reported to user.
                                wcTopic.publish("ajaxRequestCompleted");
                            },
                success:    function(data, textStatus){
                                publisher.call(scope, data);
                                wcTopic.publish("ajaxRequestCompleted");
                            }
            };
            wcTopic.publish("ajaxRequestInitiated");
            $.ajax(kw);
        },

       /**
        * This function publishes a topic with the given topic data
        * @param {String} topicName Topic name
        * @param {Object} topicData Topic data
        *
        */
        publishTopic: function(/*String*/topicName, /*Object*/topicData){
            var topic = this.makeTopic(topicName);
            wcTopic.publish(topic, topicData);
        },
        /**
         * This function publishes a page view event with page view data
         * @param {Object} pageViewData name-value pairs that contain all the page view event data
         *
         */
        publishPageView: function(/*Object*/pageViewData){
            var scope = this;
            this.publishAnalyticsView(
                scope.jsonPageView,
                pageViewData,
                function(data){
                    scope.publishTopic(scope.pageView, data);
                }
            );
        },

        /**
         * Publishes a non eCommerce conversion event with the event data.
         * @param {Object} conEventData name-value pairs that contain the conversion event data
         */
        publishConversionEventView: function(/*Object*/conEventData){
            var scope = this;
            this.publishAnalyticsView(
                scope.jsonConversionEventView,
                conEventData,
                function(data){
                    scope.publishTopic(scope.conversionEvent, data);
                }
            );
        },

        /**
         * This function publishes a cart view event with cart view data
         *
         */
        publishCartView: function(){
            var scope = this;
            this.publishAnalyticsView(
                scope.jsonShopcartView,
                {storeId:scope.storeId, incTaxInPrice: scope.incTaxInUnitPriceForCart },
                function(data){
                    scope.publishTopic(scope.cartView, data);
                }
            );
        },

        /**
         * This function publishes an add cart event with add cart data
         *
         */
        publishAddCart: function(){
            var scope = this;
            this.publishAnalyticsView(
                scope.jsonAddCart,
                {storeId:scope.storeId, incTaxInPrice: scope.incTaxInUnitPriceForCart },
                function(data){
                    scope.publishTopic(scope.addCart, data);
                }
            );
        },

        /**
         * This function publishes a registration view event with registration view data
         *
         */
        publishRegistrationView: function() {
            var scope = this;
            this.publishAnalyticsView(
                scope.jsonRegistrationView,
                {storeId:scope.storeId},
                function(data){
                    scope.publishTopic(scope.registration, data);
                }
            );
        },
        /**
         * This function assembles full topic  with the given topic name.
         * @param {String} topicName Topic name      *
         * @return {String} topicName A string of the form <topicNamespace><topicName>
         */
        makeTopic: function(/*String*/topicName){

            return [this.topicNamespace, topicName].join("")
        },
        /**
         * This function  is used to get the category of  mini shopping cart page view
         * @return {String} MiniShoppingCart  the page category of mini shopping cart page view
         */

        getMiniShopCartPageCategory: function(){
            return "MiniShoppingCart"
        },

        /**
         * This function is used to get the mini shopping cart page name.
         * @returns {String} MiniShoppingCart the mini shopping cart page name
         *
         */
        getMiniShopCartPageName: function(){
            return ["MiniShoppingCart: ", document.title].join("");
        },

        /**
         * This function is called to get the mini shopping cart view data
         * @param {String} miniShopCartTitle MiniShopCart Title
         * @returns {String} pagename: pageName, category: pageCategory the mini shopping cart page view data
         */
        getMiniShopCartPageViewData: function(miniShopCartTitle){
            var pageName = this.getMiniShopCartPageName();
            var pageCategory = this.getMiniShopCartPageCategory();

            return {pagename: pageName, category: pageCategory};
        },
        /**
         * This function publishes the mini shop cart page view
         * @param {String} miniShopCartTitle  MiniShopCart Title
         */
        publishMiniShopCartPageView: function(miniShopCartTitle) {
            var scope = this;
            if (!scope.pageViewControl) {
                scope.lockPageView();
                var pageViewData = this.getMiniShopCartPageViewData(miniShopCartTitle);
                this.publishPageView(pageViewData);
            }

        },

        /**
         * This function sets the pageview control flag in locked state for 3 seconds so that no extra page views are thrown
         * at the same time
         */
        lockPageView: function() {
            this.pageViewControl = true;
            setTimeout('analyticsJS.pageViewControl = false;', 3000);
        },




       /**
        * This function registers the mini shopping cart cart view whenever the user adds a item to the mini shopping cart
        */
        registerMiniShopCartCartView: function(){
            var scope = this;
            $(this.cartViewActionIdList).each( function(i, actionId){
                wcTopic.subscribe("modelChanged/"+actionId, function(){
                    scope.publishCartView();
                });
            });

           $(this.addCartActionIdList).each( function(i, actionId){
        	   wcTopic.subscribe("modelChanged/"+actionId, function(){
                    scope.publishAddCart();
                });
            });
        },

        /**
         * This function registers the shopping cart page view and cart view events
         * @param{boolean} incTaxInUP The boolean flag to indicate whether to include the sales tax in the unit price amount
         */
        loadShopCartHandler: function(/* boolean */ incTaxInUP){
            var scope = this;
            if (incTaxInUP === true) {
                scope.incTaxInUnitPriceForCart = "T";
            }
            scope.registerMiniShopCartCartView();

            scope.registerShopCartPaginationPageView();
            scope.registerShippingBillingAddressEditPageView();
        },


        /**
         * This function registers the shop cart page's pagination handler
         */
        loadShopCartPaginationHandler: function() {
            var scope = this;
            scope.registerShopCartPaginationPageView();
        },

        /**
         * Registers the shopping cart pagination event to trigger a page view tag
         */
        registerShopCartPaginationPageView: function() {
            var scope = this;
            wcTopic.subscribe("ShopCartPaginationDisplay_Context/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title};
                scope.publishPageView(pageViewData);
            });
            wcTopic.subscribe("OrderItemPaginationDisplay_Context/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title};
                scope.publishPageView(pageViewData);
            });
            wcTopic.subscribe("traditionalShipmentDetailsContext/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title};
                scope.publishPageView(pageViewData);
            });
            wcTopic.subscribe("MSOrderItemPaginationDisplay_Context/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title};
                scope.publishPageView(pageViewData);
            });
        },

        /**
         * Registers the shipping and billing address add/update event to trigger a page view tag
         */
        registerShippingBillingAddressEditPageView: function() {
            var scope = this;
            wcTopic.subscribe("editShippingAddressContext/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title, category:"Shipping and biling address"};
                scope.publishPageView(pageViewData);
            });
        },


        /**
         * Registers the store locator event page views
         */
        registerStoreLocatorPageViews: function() {
            var scope = this;
            wcTopic.subscribe("selectedStoreListContext/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title, category:"Store locator"};
                scope.publishPageView(pageViewData);
            });
            wcTopic.subscribe("storeLocatorResultsContext/RenderContextChanged", function(){
                var pageViewData = {pagename: document.title, category:"Store locator"};
                scope.publishPageView(pageViewData);
            });
        },

        /**
         * Loads the event handlers to generate coremetrics page view tags when the user interact with the
         * store locator page
         */
        loadStoreLocatorPageViews: function(){
            var scope = this;
            $(document).ready(function(){
                scope.registerStoreLocatorPageViews();
            });
        },

        /**
         * This function registers page view events when the shopper adds/removes items
         * from his personal wishlist
         */
        registerWishlistHandler: function() {
            var scope = this;
            var pageCategory = "MyAccountPage";
            var pageName = "Personal Wishlist:" + document.title;
            var pageViewData = {pagename: pageName, category: pageCategory};
            var cevData = {eventId: 'AddToWishlist'};


            $(this.conversionEventList).each( function(i, actionId){
                wcTopic.subscribe("modelChanged/"+actionId, function(){
                scope.publishConversionEventView(cevData);
               });
           });




        },

        /**
         * This function loads the event handlers for the Wishlist based events.
         *
         */
        loadWishlistHandler: function() {
            var scope = this;
            $(document).ready(function(){
                scope.registerWishlistHandler();
            });
        },

        /**
         * This function publishes the registration and cart tag when a guest shopper
         * tries to login from the checkout page
         */
        publishShopCartLoginTags: function() {
            var scope = this;
            $(document).ready(function(){
                scope.publishRegistrationView();
                scope.publishCartView();
            });
        },

        /**
         * This function registers the product view when the user clicks on the Quick info button
         */
        registerProductQuickInfoView: function() {

            var scope = this;
            if(typeof(QuickInfoJS) !== "undefined") {
            	Utils.aop_after(QuickInfoJS, "showDetails", function(args){
                    //console.debug("productId ", productId)
                    var catEntryId = args[0];
                    scope.publishAnalyticsView(
                        scope.jsonProductView,
                        {
                            productId: catEntryId,
                            storeId: scope.storeId
                        },
                        function(data){
                            scope.publishTopic(scope.productView, data);
                        }
                    );
                });
            }
        },
        /**
         * This function loads the Quick info event handlers
         */
        loadProductQuickInfoHandler: function () {

            var scope = this;
            $(document).ready(function(){
                scope.registerProductQuickInfoView();
            });
        },
        /**
         * This function loads the paging handler
         *
         */
        loadPagingHandler: function(){

            var scope = this;

            $(document).ready(function(){
                var movement = {forward: "page forward", backward: "page backward"};
                var monitoredEvents = [
                    ["Common", "goBack", movement.backward],
                    ["Common", "goForard", movement.forward],
                    ["Common.HistoryTracker.prototype", "back", movement.backward],
                    ["Common.HistoryTracker.prototype", "forward", movement.forward]
                ];

                $(monitoredEvents).each( function(i, target){
                    var srcObj = Utils.getObject(target[0]);
                    var srcFunc = target[1];
                    var movement = target[2];
                    $(srcObj).on( srcFunc, function(){
                        scope.publishPageView(
                            {pagename: document.title,
                             category: movement
                            }
                        );
                    });
                });
            });

        },
        /**
         * This function assumes that the related page view data is inside a DIV with ID = resultInfoDivId
         *  @param{String} resultInfoDivId  The ID of the DIV that contains information about search result.
         *  @param{Boolean} registerPageViewNow  A boolean flag to indicate whether to throw a page view when the handler is being loaded.
         *  @param{String} advSearchFormDivId  A DIV Id of the advanced search form display.
         *
         */

        registerSearchResultPageView: function(resultInfoDivId, registerPageViewNow, advSearchFormDivId){

            var realSearch = true;
            var scope = this;

            if (registerPageViewNow) {
                if ($("#" + resultInfoDivId).length) {
                    var resultInfo = eval('('+$("#" + resultInfoDivId).html()+')').searchResult;
                    var pageViewData = {pagename: document.title};

                    if (resultInfo.searchTerms !== "") {
                        if (resultInfo.totalResultCount !== '0') {
                            pageViewData = {pagename: "Search Successful:" + resultInfo.currentPageNumber};
                        } else {
                            pageViewData = {pagename: "Search Unsuccessful"};
                        }
                        if (resultInfo.searchTerms.length > 0) {
                            pageViewData.searchTerms = resultInfo.searchTerms;
                            pageViewData.searchCount = resultInfo.totalResultCount;
                        }
                        pageViewData.category = "Search Results";
                    }

                    pageViewData.attributes = resultInfo.attributes;
                    scope.publishPageView(pageViewData);
                }
            }
        },

        /**
         *  This function handles the Coremetrics event for searching.
         *  @param{String} resultInfoDivId  The ID of the DIV that contains information about search result.
         *  @param{Boolean} registerPageViewNow  A boolean flag to indicate whether to throw a page view when the handler is being loaded.
         *  @param{String} advSearchFormDivId  A DIV Id of the advanced search form display.
         */
        loadSearchResultHandler: function(/*String*/resultInfoDivId, registerPageViewNow, /*String*/ advSearchFormDivId){
            var scope = this;
            wcTopic.subscribe("CMPageRefreshEvent", function(){
                scope.registerSearchResultPageView(resultInfoDivId,registerPageViewNow, advSearchFormDivId);
            });
        },

        /**
         * This function will publish page view events when number of payment methods  changes. The category of page view event will be "payment method".
         * @param paymentController The paymentController object
         */
        registerPaymentPageView: function(/*Object*/paymentController){
            var scope = this;
            Utils.aop_after(paymentController, "setNumberOfPaymentMethods", function(args){
            	var selection = args[1];
            	scope.publishPageView({pagename:selection.value, category:"payment method"});
            	selection = null;
            });
        },

        /**
         * Loads the function that handles all the Coremetrics events for changing payments.
         * @param paymentController The paymentController object
         */
        loadPaymentPageView: function(/*Object*/paymentController){
            var scope = this;
            $(document).ready(function(){
                scope.registerPaymentPageView(paymentController);
            });
        }
    }
}
