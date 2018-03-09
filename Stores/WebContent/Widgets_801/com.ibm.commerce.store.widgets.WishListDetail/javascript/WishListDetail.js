//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/** 
 * @fileOverview This file contains all the global variables and JavaScript functions needed for wish list page in My Account section.
 * This JavaScript file defines all the functions used  by the AccountWishDisplay.jsp file.
 * @version 1.0
 */

/* Declare the namespace if it does not already exist. */
if (WishListDetailJS == null || typeof(WishListDetailJS) != "object") {
	/**
	 * @class This WishListDetailJS class defines all the variables and functions for the wish list page of My account section.
	 * The wish list page displays all the wish list item of an user and provides functions like remove from the wish list, add to cart, etc.
	 *
	 */
	var WishListDetailJS = {	
		/* Global variables used in the CompareProductDisplay page. */
			
		/** The contextChanged is a boolean flag indicating whether the context was changed and if there is a need to refresh the wish list result. */
		contextChanged:false, 

		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = parseInt(data['pageNumber']) - 1,
				pageSize = parseInt(data['pageSize']),
				beginIndex = pageSize * pageNumber;

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			cursor_wait();

			if($("#WishlistDisplay_Widget").length){
				wcRenderContext.updateRenderContext("WishlistDisplay_Context", {startIndex: beginIndex, currentPage: pageNumber});
			}

			if($("#SharedWishlistDisplay_Widget").length) {	
				wcRenderContext.updateRenderContext("SharedWishlistDisplay_Context", {startIndex: beginIndex, currentPage: pageNumber});
			}
			MessageHelper.hideAndClearMessage();
		},

		/**
		 * Updates the ContentURL and does not cause an Ajax refresh. 
		 * 
		 * @param {string} contentURL  the value of the controller URL.
		 */
		updateContentURL: function(contentURL) {
			if($("#WishlistDisplay_Widget").length){
				$("#WishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
			}

			if($("#SharedWishlistDisplay_Widget").length) {
				$("#SharedWishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
			}
		},

		/**
		* Updates the ContentURL and causes an Ajax refresh. 
		* 
		* @param {string} contentURL  the value of the controller URL.
		*/
		loadContentURL:function(contentURL){
			/* Handles multiple clicks */
			if(!submitRequest()){
				return;
			}   	
			cursor_wait();
			if($("#WishlistDisplay_Widget").length){
				$("#WishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
				wcRenderContext.updateRenderContext("WishlistDisplay_Context");
			}

			if($("#SharedWishlistDisplay_Widget").length) {
				$("#SharedWishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);		
				wcRenderContext.updateRenderContext("SharedWishlistDisplay_Context");
			}
		}
	};
}
