//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by OrderDetail_ItemTable widget
 */

	OrderDetailJS = {
			
		/** 
		 * This variable stores the ID of the language that the store currently uses. Its default value is set to -1, which corresponds to United States English.
		 * @private
		 */
		langId: "-1",
		
		/** 
		 * This variable stores the ID of the current store. Its default value is empty.
		 * @private
		 */
		storeId: "",
		
		/** 
		 * This variable stores the ID of the catalog. Its default value is empty.
		 * @private
		 */
		catalogId: "",
		
		/**
		* indicates whether the OrderDetail_ItemTable widget is not loaded, expanded or collapsed
		* possible values: "notLoaded", "expanded" or "collapsed"
		*/
		itemTableShown: "notLoaded",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 * @param {Integer} orderId The ID of the order.
		 */
		setCommonParameters: function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
	
		/**
		* By default the order item detail table isn't shown. This function will refresh the area so the table will
		* show.
		*/
		expandCollapseArea:function(){
			if (this.itemTableShown == "notLoaded") {
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}	
				cursor_wait();
				wc.render.updateContext('OrderDetailItemTable_Context', {"beginIndex": 0});
				this.itemTableShown = "expanded";
			} else if (this.itemTableShown == "expanded") {
				dojo.style("orderSummaryContainer_plusImage","display","inline");
				dojo.byId('orderSummaryContainer_plusImage_link').setAttribute('tabindex', '0');

				dojo.style("orderSummaryContainer_minusImage","display","none");
				dojo.byId('orderSummaryContainer_minusImage_link').setAttribute('tabindex', '-1');
				
				dojo.style("OrderDetail_ItemTable_table","display","none");
				this.itemTableShown = "collapsed";
			} else if (this.itemTableShown == "collapsed") {
				dojo.style("orderSummaryContainer_plusImage","display","none");
				dojo.byId('orderSummaryContainer_plusImage_link').setAttribute('tabindex', '-1');
				
				dojo.style("orderSummaryContainer_minusImage","display","inline");
				dojo.byId('orderSummaryContainer_minusImage_link').setAttribute('tabindex', '0');
				
				dojo.style("OrderDetail_ItemTable_table","display","block");
				this.itemTableShown = "expanded";
			}
		},
		
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = dojo.number.parse(pageNumber);
			pageSize = dojo.number.parse(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wc.render.updateContext('OrderDetailItemTable_Context', {"beginIndex": beginIndex});
			MessageHelper.hideAndClearMessage();
		},
	}