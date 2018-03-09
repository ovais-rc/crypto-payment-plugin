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

/**
 *@fileOverview This javascript file defines all the javascript functions used by saved order detail widget
 */

	SavedOrderItemsJS = {

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
			 * This variable stores the order ID of the saved order. Its default value is empty.
			 */
			orderId : "",
			
			/**
			 * This variable stores the current order ID. Its default value is empty.
			 */
			currentOrderId : "",
			
			/** The currently selected row. **/
			currentRow : "",
			
			/** The URL of the shopping cart used to forward the page when an order is converted to the current order. **/
			shoppingCartURL : "",
			
			/**
			 * Sets the common parameters for the current page. 
			 * For example, the language ID, store ID, and catalog ID.
			 *
			 * @param {Integer} langId The ID of the language that the store currently uses.
			 * @param {Integer} storeId The ID of the current store.
			 * @param {Integer} catalogId The ID of the catalog.
			 * @param {Integer} orderId The ID of the saved order.
			 */
			setCommonParameters:function(langId,storeId,catalogId,orderId){
				this.langId = langId;
				this.storeId = storeId;
				this.catalogId = catalogId;
				this.orderId = orderId;
			},

			/**
			 * Returns the current row.
			 * @returns {String} The current row number.
			 **/
			getCurrentRow:function() {
				return this.currentRow;
			},
			
			/**
			 * Resets the current row variable.
			 **/
			resetCurrentRow:function() {
				this.currentRow = "";
			},
			
			/**
			 * Sets the URL of the current shopping cart view.
			 *
			 * @param shoppingCartURL The URL of the shopping cart view.
			 */
			setCurrentShoppingCartURL : function(shoppingCartURL)
			{
				this.shoppingCartURL = shoppingCartURL;
			},
			
			/**
			 * Returns the URL of the shopping cart view.
			 * @returns {String} The URL of the shopping cart view.
			 **/
			getCurrentShoppingCartURL:function() {
				return this.shoppingCartURL;
			},
			
			/**
			 * Initialize the URL of Saved Order Items widget controller. 	 
			 *
			 * @param {object} widgetUrl The controller's URL.
			 */
			initSavedOrderItemsUrl:function(widgetUrl){
				wc.render.getRefreshControllerById('SavedOrderItemTable_Controller').url = widgetUrl;
			},

			/**
			 * This function validates the SKU input values and their corresponding quantities 
			 * before sending the request to the server to add the SKUs to the saved order.
			 * An error message would be displayed if the inputs are invalid and the requested will be stopped.
			 * @param (object) formName The form that contains the items to add to the requisition list.
			 */
			addItemToSavedOrder:function(formName){
				MessageHelper.hideAndClearMessage();
				var form = document.forms[formName];
				if (form.skuAdd != null && this.isEmpty(form.skuAdd.value)) {
					MessageHelper.formErrorHandleClient(form.skuAdd.id,MessageHelper.messages["SAVED_ORDER_EMPTY_SKU"]); return;
				}else if (form.quantityAdd != null && this.isEmpty(form.quantityAdd.value)) {
					form.quantityAdd.value = "1";
				}else if (!this.isNumber(form.quantityAdd.value) || form.quantityAdd.value <= 0) {
					MessageHelper.formErrorHandleClient(form.quantityAdd.id,MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]); return;
				}
				
				var params = {};
				params["orderId"] = form.orderId.value;
				params["partNumber"] = form.skuAdd.value;
				params["quantity"] = form.quantityAdd.value;
				params.calculationUsage = form.calculationUsage.value;
				params.calculateOrder="1";
				params.storeId = this.storeId;
				params.catalogId = this.catalogId;
				params.langId = this.langId;			
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}			
				cursor_wait();
				wc.service.invoke('AjaxAddOrderItem',params);
			},

			/**
			 * Adds item to the current order
			 * @param {Integer} partNumber The partNumber of the item to add to the current order.
			 * @param (string) row The row number of the quantity input in the table.
			 * @param (string) catEntryId The catentry ID of the item
			 */
			addItemToCurrentOrder:function(partNumber, row, catEntryId){
				var params = {};
				params.storeId = this.storeId;
				params.catalogId = this.catalogId;
				params.langId = this.langId;
				//params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
				params.calculateOrder="0";
				params.mergeToCurrentPendingOrder = "Y";
				params.URL = "";
				params["partNumber"] = partNumber;
				params["inventoryValidation"] = true;
				params["orderId"] = ".";
				params["quantity"] = document.getElementById("orderItem_input_"+row).value;
				
				// used by mini shopcart
				var selectedAttrList = new Object();
				shoppingActionsJS.saveAddedProductInfo(params["quantity"], catEntryId, catEntryId, selectedAttrList);
				
				MessageHelper.hideAndClearMessage();
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}			
				cursor_wait();
				wc.service.invoke('AddOrderItem',params);
				// close action dropdown
				hideMenu(dojo.byId('actionButton'+row));
				hideMenu(dojo.byId('actionDropdown'+row));
			},

			/**
			 * This function deletes an order item from a saved order.
			 * @param {Integer} orderItemId The ID of the order item to delete.
			 */
			deleteItem:function(orderItemId){ 
				var params = {};
				params["orderItemId"] = orderItemId;
				params.storeId = this.storeId;
				params.catalogId = this.catalogId;
				params.langId = this.langId;
				params.orderId = (this.orderId != null && this.orderId != 'undefined' && this.orderId != "")?this.orderId:".";
				params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
				params.check="*n";
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				} 
				
				cursor_wait();	
				wc.service.invoke("AjaxSavedOrderDeleteItem", params);
				
			},
			
			/**
			 * Updates the quantities of each item in the saved order, if the quantities are changed.
			 * @param (string) qty The quantity value to update to.
			 * @param (string) orderItemId The ID of the saved order to update.
			 * @param (string) row The row number of the quantity input in the table.
			 */
			updateItemQuantity:function (qty, orderItemId, row) {
				//dojo.byId(qtyDiv).value does not work for some reason;
				if(!this.isNumber(qty)){
					dojo.byId("orderItem_input_"+row).value = document.getElementById("oldOrderItem_input_"+row).value;
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]);
					return;
				} else {
					var params={};
					params.orderId = (this.orderId != null && this.orderId != 'undefined' && this.orderId != "")?this.orderId:".";
					params["quantity"] = qty;
					params["orderItemId"] = orderItemId;
					params.storeId = this.storeId;
					params.catalogId = this.catalogId;
					params.langId = this.langId;
					params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
					params.check="*n";
					params.calculateOrder="1";
					this.currentRow = row;
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wc.service.invoke('AjaxSavedOrderUpdateItem',params);
				}
				
			},
			
			/**
			 * Sets the selected saved order as the current order when the <b>Set as Current Order and Checkout</b> button is clicked.
			 * This method updates the current order in the database to match the order in the shopping cart.
			 *
			 * @param orderId The ID of the saved order.
			 * **/
			setCurrentOrderAndCheckout : function(orderId)
			{
				if (this.orderId == null || this.orderId == 'undefined') {
					this.orderId = orderId;
				}
				
				var params = {};
				params.storeId = this.storeId;
				params.catalogId = this.catalogId;
				params.langId = this.langId;
				params.URL = "AjaxOrderItemDisplayView";
				params.orderId = this.orderId;
				params["nextAction"] = true;
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wc.service.invoke("AjaxUpdatePendingOrder", params);
			},
			
			/**
			 * Display saved order items for pagination
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
		
				console.debug(wc.render.getRefreshControllerById('SavedOrderItemTable_Controller').renderContext.properties);
				var beginIndex = pageSize * ( pageNumber - 1 );
				cursor_wait();
				wc.render.updateContext('SavedOrderItemTable_Context', {'beginIndex':beginIndex});
				MessageHelper.hideAndClearMessage();
			},

			/**
			* Shows the "quantity updated" message next to quantity input
			* This function is automatically called by the successHandler of AjaxUpdateOrderItem.
			*/		
			showUpdatedMessage: function() {
				dojo.byId("orderItem_msg_qty_updated_"+this.currentRow).style.display="block";
				dojo.byId("orderItem_input_"+this.currentRow).style.border="1px solid #006ecc";
				setTimeout("SavedOrderItemsJS.hideUpdatedMessage("+this.currentRow+")", 3000);
			},

			/**
			* Hides the "quantity updated" message next to quantity input
			* @param {Integer} row The row number of the quantity input in the table
			*/		
			hideUpdatedMessage: function(row) {
				dojo.byId("orderItem_msg_qty_updated_"+row).style.display="none";
				dojo.byId("orderItem_input_"+row).style.border="1px solid #b7b7b7";
			},
			
			/**
			 * Checks if the string is an integer.
			 * @param (string) str The string to check.
			 * @return (boolean) Indicates whether the string is a number.
			 */
			isNumber:function (str) {
				if ((str*0)==0) return true;
				else return false;
			},	
			
			/**
			 * Checks if a string is null or empty.
			 * @param (string) str The string to check.
			 * @return (boolean) Indicates whether the string is empty.
			 */
			isEmpty: function(str) {
				var reWhiteSpace = new RegExp(/^\s+$/);
				if (str == null || str =='' || reWhiteSpace.test(str) ) {
					return true;
				}
				return false;
			}
	}