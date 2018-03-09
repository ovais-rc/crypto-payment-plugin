//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the wish list pages to handle CRUD operations.
 * @version 1.0
 */


/**
/**
         * Declares a new render context for the Wishlist display,
         * and initializes it with the post URL to load. 
         */
        wcRenderContext.declare("WishlistDisplay_Context", ["WishlistDisplay_Widget"], {
            url: ""
        });
/**	
 * Declares a new render context for the Shared Wishlist display,
 * and initializes it with the post URL to load. 
 */
wcRenderContext.declare("SharedWishlistDisplay_Context", ["SharedWishlistDisplay_Widget"], {
            url: ""
        });
	
	
		
ShoppingListControllersJS = {

    
    declareWishlistDisplayWidgetRefreshController: function () {
        // ============================================
        // div: WishlistDisplay_Widget refresh area
        // Declares a new refresh controller for the Wishlist display
        var myWidgetObj = $("#WishlistDisplay_Widget");
       
        
        var myRCProperties = wcRenderContext.getRenderContextProperties("WishlistDisplay_Context");

        /** 
         * Displays the previous/next page of items on the Wishlist display page.
         * This function is called when a render context changed event is detected. 
         */
        var renderContextChangedHandler = function () {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };

        /** 
         * Refreshs the wishlist display when an item is added to or deleted from the wishlist.
         * This function is called when a modelChanged event is detected. 
         */
        wcTopic.subscribe(["ShoppingListServiceCreate", "ShoppingListServiceUpdate", "ShoppingListServiceDelete", "ShoppingListServiceRemoveItem", "ShoppingListServiceAddItem"], function () {
            myWidgetObj.refreshWidget("refresh");
        });

        /** 
         * This function handles paging and browser back/forward functionalities upon a successful refresh.
         */
        var postRefreshHandler = function () {
            if (($("#multipleWishlistController_select") != null && $("#multipleWishlistController_select") != 'undefined')) {
                $("#multipleWishlistController_select").disabled = false;
            }
            cursor_clear();
        }

        // initialize widget with properties
        myWidgetObj.refreshWidget({
            renderContextChangedHandler: renderContextChangedHandler,
            postRefreshHandler: postRefreshHandler
        });
    },

    declareSharedWishlistDisplayRefreshController: function () {
        // ============================================
        // div: SharedWishlistDisplay_Widget refresh area
        // Declares a new refresh controller for the shared Wishlist display
        var myWidgetObj = $("#SharedWishlistDisplay_Widget");

        
        var myRCProperties = wcRenderContext.getRenderContextProperties("SharedWishlistDisplay_Context");

        /** 
         * Displays the previous/next page of items on the Shared Wishlist display page.
         * This function is called when a render context changed event is detected. 
         */
        var renderContextChangedHandler = function () {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };

        /** 
         * This function handles paging and browser back/forward functionalities upon a successful refresh.
         */
        var postRefreshHandler = function () {
            cursor_clear();
        }

        // initialize widget with properties
        myWidgetObj.refreshWidget({
            renderContextChangedHandler: renderContextChangedHandler,
            postRefreshHandler: postRefreshHandler
        });
    },
    declareWishlistSelectWidgetRefreshController: function () {
        // ============================================
        // div: WishlistSelect_Widget refresh area
        // Declares a new refresh controller for the Wishlist select display
	
	/**
 * Declares a new render context for the multiple Wishlist select display
 */
 wcRenderContext.declare("WishlistSelect_Context", ["WishlistSelect_Widget"], "");
        var myWidgetObj = $("#WishlistSelect_Widget");

        /**
         * Declares a new render context for the multiple Wishlist select display
         */
       
        var myRCProperties = wcRenderContext.getRenderContextProperties("WishlistSelect_Context");


        /** 
         * Displays the previous/next page of items on the Wishlist display page.
         * This function is called when a render context changed event is detected. 
         */
        var renderContextChangedHandler = function () {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };

        /** 
         * Refreshs the wishlist select drop down display when a new wish list is added or when a wish list is deleted.
         * This function is called when a modelChanged event is detected. 
         */
        wcTopic.subscribe(["ShoppingListServiceCreate", "ShoppingListServiceUpdate", "ShoppingListServiceDelete", "ShoppingListServiceAddItem"], function () {
            myWidgetObj.refreshWidget("refresh");
        });

        /** 
         * Hide the progress bar upon a successful refresh.
         */
        var postRefreshHandler = function () {
            cursor_clear();
            //ensure default wish list name is used if all lists are deleted.
            var dropdown = $('#multipleWishlistController_select');
            if (dropdown == null) {
                //if the drop down does not exist, that means there is no wish list
                MultipleWishLists.defaultListId = null;
                MultipleWishLists.addItemAfterCreate = null;
            } else if (dropdown.length > 0) {
                //ensure the name of the wish list is the same as the one selected in the drop down
                MultipleWishLists.defaultListId = $('#multipleWishlistController_select').val();
		
                shoppingListJS.refreshLinkState();
            }
        }

        // initialize widget with properties
        myWidgetObj.refreshWidget({
            renderContextChangedHandler: renderContextChangedHandler,
            postRefreshHandler: postRefreshHandler
        });

    }


};
