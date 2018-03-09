//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
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
				$("#SavedOrderItemTable_Widget").attr("refreshurl", widgetUrl);
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
				}else if (isNaN(form.quantityAdd.value) || form.quantityAdd.value <= 0) {
					MessageHelper.formErrorHandleClient(form.quantityAdd.id,MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]); return;
				}
				
				var params = {
					orderId: form.orderId.value,
					partNumber: form.skuAdd.value,
					quantity: form.quantityAdd.value,
					calculationUsage : form.calculationUsage.value,
					calculateOrder: "1",
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId
				};
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke('AjaxAddSavedOrderItem',params);
			},

			/**
			 * Adds item to the current order
			 * @param {Integer} partNumber The partNumber of the item to add to the current order.
			 * @param (string) row The row number of the quantity input in the table.
			 * @param (string) catEntryId The catentry ID of the item
			 */
			addItemToCurrentOrder:function(partNumber, row, catEntryId){
				var params = {
					storeId: this.storeId,
					catalogId: this.catalogId,
					langId: this.langId,
					calculationUsage: "-1,-2,-3,-4,-5,-6,-7",
					calculateOrder: "0",
					mergeToCurrentPendingOrder: "Y",
					URL: "",
					partNumber: partNumber,
					inventoryValidation: true,
					orderId: ".",
					quantity: $("#orderItem_input_" + row).val()
				};
				
				// used by mini shopcart
				var selectedAttrList = new Object();
				shoppingActionsJS.saveAddedProductInfo(params["quantity"], catEntryId, catEntryId, selectedAttrList);
				
				MessageHelper.hideAndClearMessage();
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke('AddOrderItem',params);
				// close action dropdown
				hideMenu($('#actionButton' + row)[0]);
				hideMenu($('#actionDropdown' + row)[0]);
			},

			/**
			 * This function deletes an order item from a saved order.
			 * @param {Integer} orderItemId The ID of the order item to delete.
			 */
			deleteItem:function(orderItemId){ 
				var params = {
					orderItemId: orderItemId,
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId,
					orderId : Utils.existsAndNotEmpty(this.orderId) ? this.orderId : ".",
					calculationUsage : "-1,-2,-3,-4,-5,-6,-7",
					check: "*n"
				};
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				}
				
				cursor_wait();
				wcService.invoke("AjaxSavedOrderDeleteItem", params);
				
			},
			
			/**
			 * Updates the quantities of each item in the saved order, if the quantities are changed.
			 * @param (string) qty The quantity value to update to.
			 * @param (string) orderItemId The ID of the saved order to update.
			 * @param (string) row The row number of the quantity input in the table.
			 */
			updateItemQuantity:function (qty, orderItemId, row) {
				if(isNaN(qty)){
					$("#orderItem_input_"+row).val($("#oldOrderItem_input_"+row).val());
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]);
					return;
				} else {
					var params = {
						orderId : Utils.existsAndNotEmpty(this.orderId) ? this.orderId : ".",
						quantity: qty,
						orderItemId: orderItemId,
						storeId : this.storeId,
						catalogId : this.catalogId,
						langId : this.langId,
						calculationUsage : "-1,-2,-3,-4,-5,-6,-7",
						check: "*n",
						calculateOrder: "1"
					};
					
					this.currentRow = row;
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wcService.invoke('AjaxSavedOrderUpdateItem',params);
				}
				
			},
			
			/**
			 * Sets the selected saved order as the current order when the <b>Set as Current Order and Checkout</b> button is clicked.
			 * This method updates the current order in the database to match the order in the shopping cart.
			 *
			 * @param orderId The ID of the saved order.
			 * **/
			setCurrentOrderAndCheckout : function(orderId) {
				if (Utils.isNullOrUndefined(this.orderId)) {
					this.orderId = orderId;
				}
				
				var params = {
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId,
					URL : "AjaxOrderItemDisplayView",
					orderId : this.orderId,
					nextAction: true
				};
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke("AjaxUpdatePendingOrder", params);
			},
			
			/**
			 * Display saved order items for pagination
             * TODO: check if this is unused, it appears to be ...
			 */
			showResultsPage:function(data){
				var pageNumber = data['pageNumber'];
				var pageSize = data['pageSize'];
				pageNumber = parseInt(pageNumber);
				pageSize = parseInt(pageSize);
		
				setCurrentId(data["linkId"]);
		
				if(!submitRequest()){
					return;
				}
		
				console.debug(wcRenderContext.getRenderContextProperties("SavedOrderItemTable_Context"));
				var beginIndex = pageSize * ( pageNumber - 1 );
				cursor_wait();
				wcRenderContext.updateRenderContext('SavedOrderItemTable_Context', {'beginIndex':beginIndex});
				MessageHelper.hideAndClearMessage();
			},

			/**
			* Shows the "quantity updated" message next to quantity input
			* This function is automatically called by the successHandler of AjaxUpdateOrderItem.
			*/
			showUpdatedMessage: function() {
				$("#orderItem_msg_qty_updated_"+this.currentRow).css("display", "block");
				$("#orderItem_input_"+this.currentRow).css("border", "1px solid #006ecc");
				setTimeout("SavedOrderItemsJS.hideUpdatedMessage("+this.currentRow+")", 3000);
			},

			/**
			* Hides the "quantity updated" message next to quantity input
			* @param {Integer} row The row number of the quantity input in the table
			*/		
			hideUpdatedMessage: function(row) {
				$("#orderItem_msg_qty_updated_"+row).css("display", "none");
				$("#orderItem_input_"+row).css("border", "1px solid #b7b7b7");
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