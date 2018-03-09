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
 *@fileOverview This javascript file defines all the javascript functions used by requisition list items widget
 */

	ReqListItemsJS = {
			
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
		* This variable stores the ID of the requisition list. Its default value is empty.
		*/
		requisitionListId: "",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 * @param {Integer} requisitionListId The ID of the requisition list.
		 */
		setCommonParameters: function(langId,storeId,catalogId,requisitionListId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			this.requisitionListId = requisitionListId;
		},

		/**
		 * Adds an item to the requisition list.
		 * @param (object) formName The form that contains the items to add to the requisition list.
		 */
		addItemToReqList:function(formName){
			MessageHelper.hideAndClearMessage();
			var form = document.forms[formName];
			if (form.skuAdd!=null && this.isEmpty(form.skuAdd.value.replace(/^\s+|\s+$/g, ''))) {
				MessageHelper.formErrorHandleClient(form.skuAdd.id,MessageHelper.messages["ERROR_REQUISITION_LIST_SKU_EMPTY"]); return;
			}else if (form.quantityAdd!=null && this.isEmpty(form.quantityAdd.value.replace(/^\s+|\s+$/g, ''))) {
				form.quantityAdd.value = "1";
			}else if (!this.isNumber(form.quantityAdd.value.replace(/^\s+|\s+$/g, '')) || form.quantityAdd.value.replace(/^\s+|\s+$/g, '') <= 0) {
				MessageHelper.formErrorHandleClient(form.quantityAdd.id,MessageHelper.messages["ERROR_REQUISITION_LIST_QUANTITY_ONE_OR_MORE"]); return;
			}
			
			var params = {};
			params["requisitionListId"] = form.requisitionListId.value;
			params["partNumber"] = form.skuAdd.value.replace(/^\s+|\s+$/g, '');
			params["quantity"] = form.quantityAdd.value.replace(/^\s+|\s+$/g, '');
			params["operation"] = "addItem";
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;			
			
			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('requisitionListAddItem',params);
		},
	
		/**
		 * Updates the quantities of each item in the requisition list, if the quantities are changed.
		 * This function is automatically called by the sucessHandler of requisitionListUpdate.
		 * @see RequisitionList.updateReqList()
		 * @see MyAccountServiceDeclaration.js requisitionListUpdate declaration
		 * @param (string) requisitionListId The ID of the requisition list to update.
		 */
		updateItemQuantity:function (qtyDiv, orderItemId, row) {
			
			var params={};
			params["requisitionListId"] = this.requisitionListId;
			params["quantity"] = dojo.byId(qtyDiv).value;
			params["orderItemId"] = orderItemId;
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params["operation"] = "updateQty";
			params["row"] = row;
			
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			wc.service.invoke('requisitionListUpdateItem',params);
		},

		/**
		* Shows the "quantity updated" message next to quantity input
		* @param {Integer} row The row number of the quantity input in the table
		*/		
		showUpdatedMessage: function(row) {
			dojo.byId("reqItem_msg_qty_updated_"+row).style.display="block";
			dojo.byId("table_r"+row+"_input2").style.border="1px solid #006ecc";
			setTimeout("ReqListItemsJS.hideUpdatedMessage("+row+")", 5000);
		},

		/**
		* Hides the "quantity updated" message next to quantity input
		* @param {Integer} row The row number of the quantity input in the table
		*/		
		hideUpdatedMessage: function(row) {
			dojo.byId("reqItem_msg_qty_updated_"+row).style.display="none";
			dojo.byId("table_r"+row+"_input2").style.border="1px solid #b7b7b7";
		},
		
		/**
		 * Deletes an item from the requisition list for the Ajax flow.
		 * @param (string) orderItemId The item to delete from the requisition list.
		 */
		deleteItemFromReqList:function (orderItemId) {
			var params = {};
			params["requisitionListId"] = this.requisitionListId;
			params["orderItemId"] = orderItemId;
			params["quantity"] = "0";
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;	
			params["operation"] = "deleteItem";
			
			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('requisitionListDeleteItem',params);
		},

		/**
		 * Adds all of the order items from the current requisition list to the current order.
		 * Checks whether the current requisition list contains items.
		 */
		addListToOrder:function () {
			var form = document.forms["RequisitionListAddToCartForm"];
			var formElements = form.elements;
			var params = {};

			for(var i = 0; i < formElements.length; i++) {
				if (formElements[i].name.indexOf("quantity") == -1 && formElements[i].name.indexOf("ProductInfo") == -1) {
					// ingore all hidden "quantity" and "ProductInfo" inputs - do not add to params
					params[formElements[i].name] = formElements[i].value;
				}
			}
									
			MessageHelper.hideAndClearMessage();
	
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			} 
			
			cursor_wait();
			service = wc.service.getServiceById('requisitionListAjaxPlaceOrder');
			service.formId = form;
			wc.service.invoke('requisitionListAjaxPlaceOrder', params);
		},			

		/**
		 * Adds selected item from the current requisition list to the current order.
		 * @param (String) catEntryId catentry id of the item to be added to the current order
		 * @param (String) partNumber part number of the item to be added to the current order
		 * @param (String) row row number of the item in the requisition list
		 */
		addItemToOrder:function (catEntryId,partNumber,row) {
			var form = document.forms["RequisitionListAddToCartForm"];
			var formElements = form.elements;
			var params = {};
			
			for(var i = 0; i < formElements.length; i++) {
				if (formElements[i].name.indexOf("quantity") != -1) {
					if(formElements[i].name.indexOf("quantity_"+row) != -1) {
						// just add quantity of the specified row to params
						params["quantity"] = formElements[i].value;
					}
				} else if (formElements[i].name.indexOf("ProductInfo") == -1) {
					// ingore all hidden "ProductInfo" inputs - do not add to params
					params[formElements[i].name] = formElements[i].value;
				}
			}
			params["partNumber"] = partNumber;
			params["inventoryValidation"] = true;
			params["orderId"] = ".";
			
			// used by mini shopcart
			var selectedAttrList = new Object();
			shoppingActionsJS.saveAddedProductInfo(params["quantity"], catEntryId, catEntryId, selectedAttrList);
			
			MessageHelper.hideAndClearMessage();
	
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			} 
			
			cursor_wait();
			wc.service.invoke('ReqListAddOrderItem',params);
			
			// close action dropdown
			hideMenu(dojo.byId('RequisitionListItems_actionButton'+row));
			hideMenu(dojo.byId('RequisitionListItems_actionDropdown'+row));
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

			wc.render.updateContext('RequisitionListItemTable_Context', {"beginIndex": beginIndex, "requisitionListId":this.requisitionListId});
			MessageHelper.hideAndClearMessage();
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
		},

	}