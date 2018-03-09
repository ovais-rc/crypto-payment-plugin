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
 * @fileOverview This file provides all the functions and variables to manage saved orders and the items within.
 * This file is included in all pages with saved order list actions.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");
dojo.require("dojo.store.JsonRest");

/**
 * This class defines the functions and variables that customers can use to create, update, and view their saved orders.
 * @class The SavedOrderListJS class defines the functions and variables that customers can use to manage their saved orders, 
 */
SavedOrderListJS ={
		
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

	/** This variable stores the ID of the newly created saved order. Its default value is empty. **/
	newOrderId : "",

	/** A boolean used to indicate if the current saved order was just deleted. Its default value is false. **/
	currentOrderDeleted : false,

	/** 
	 * This array stores the quantities of each product in the order. Its default value is empty.
	 * @private
	 */
	quantityList: {},
	
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 *
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 */
	setCommonParameters:function(langId,storeId,catalogId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		cursor_clear();
	},	
	
	/**
	 * Initialize the URL of Saved Order List widget controller. 	 
	 *
	 * @param {object} widgetUrl The controller's URL.
	 */
	initSavedOrderListUrl:function(widgetUrl){
		wc.render.getRefreshControllerById('SavedOrderListTable_controller').url = widgetUrl;
	},

	/**
	 * Creates an empty order.
	 */
	createNewList:function() {
		var form_name = document.getElementById("SavedOrderList_NewListForm_Name");
		if (form_name !=null && this.isEmpty(form_name.value)) {
			MessageHelper.formErrorHandleClient(form_name.id,MessageHelper.messages["LIST_TABLE_NAME_EMPTY"]); return false;
		}
		service = wc.service.getServiceById('AjaxOrderCreate');
		
		var params = {};
		params["storeId"] = this.storeId;
		params["catalogId"] = this.catalogId;
		params["langId"] = this.langId;
		params["description"] = dojo.attr(form_name, "value");
			
		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wc.service.invoke('AjaxOrderCreate',params);
	},
	
	/**
	 * Deletes a saved order
	 * This method is invoked by the <b>Delete</b> action.
	 * @param (string) orderId The orderId of the saved order.
	 */
	deleteOrder:function (orderId) {
		var params = {};
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["storeId"] = this.storeId;
		params["catalogId"] = this.catalogId;
		params["langId"] = this.langId;		
		
		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wc.service.invoke("AjaxSingleOrderCancel", params);
	},
	
	/**
	 * Duplicates a saved order.
	 * This method is invoked by the <b>Duplicate order</b> action.
	 * @param (string) orderId The order from which the new saved order is created.
	 * @param (string) orderDesc The name of the saved order.
	 */
	duplicateOrder:function (orderId, orderDesc) {
		MessageHelper.hideAndClearMessage();
						
		var params = {};
		params["storeId"] = this.storeId;
		params["catalogId"] = this.catalogId;
		params["langId"] = this.langId;
		params["fromOrderId_1"] = orderId;	
		params["toOrderId"] = "**";
		params["copyOrderItemId_1"] = "*";
		params["keepOrdItemValidContract"] = "1";
		params["URL"] = "AjaxSavedOrderListViewURL";
		if (orderDesc != null && orderDesc != 'undefined'){
			params["description"] = orderDesc;
		}
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wc.service.invoke('AjaxSingleOrderCopy',params);
	},		
	
	/**
	* Sets the selected saved order as the current order in the saved orders table.
	* This method is invoked by the <b>Set as Current Order</b> action. 
	**/
	setCurrentOrder : function (orderId)
	{		
		if (orderId != null && orderId != 'undefined')
		{
			if(!submitRequest()){
				return;
			}
			var params = [];
			
			params["storeId"] = this.storeId;
			params["catalogId"] = this.catalogId;
			params["langId"] = this.langId;
			params["orderId"] = orderId;
			params["URL"] = "";
			wc.service.invoke("AjaxSetPendingOrder", params);
		}	
	},
	
	/**
	 * Updates the current order in the database to match the order in the shopping cart.
	 * This method is called when the Saved Order list page loads, and when a saved order is added/deleted. 
	 * @param (string) currentOrderId The orderId to set as the current order.
	 */
	updateCurrentOrder : function(currentOrderId)
	{
		if (currentOrderId != null)
		{
			var params = [];
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.URL = "";
			params.orderId = currentOrderId;
			wc.service.invoke("AjaxUpdatePendingOrder", params);
		}
	},
	
	/**
	 * Returns the order ID of the first saved order in the table.
	 * @returns {String} The order ID of the first saved order if not empty, otherwise, returns null.
	 * 
	 **/
	getFirstSavedOrderIdFromList : function()
	{
		var savedOrderLink = document.getElementById("WC_SavedOrderList_Link_2_1");
		
		if (savedOrderLink && savedOrderLink != null && savedOrderLink != 'undefined' && savedOrderLink.innerHTML != null && savedOrderLink.innerHTML != 'undefined') {
			var savedOrderText = savedOrderLink.innerHTML;
			var savedOrderId = savedOrderText.split(" ")[0];
			
			return savedOrderId;
		} else {
			return null;
		}
	},
	
	/**
	 * Returns the current order ID from the currentOrderJSON div.
	 * @returns {String} The order ID of the current order or null if the currentOrderJSON div cannot be found.
	 * 
	 **/
	getCurrentOrderId : function()
	{
		var jsonDIV = null;
		var node = document.getElementById("currentOrderJSON");

		if (node && node != null && node != 'undefined')
		{
			jsonDIV = eval('('+ dojo.byId("currentOrderJSON").innerHTML +')');
		}
		if (jsonDIV != null && jsonDIV != 'undefined' && jsonDIV.currentOrderId != null && jsonDIV.currentOrderId != 'undefined')
		{
			return jsonDIV.currentOrderId;
		}
		else
		{
			return null;
		}
	},
	
	/**
	 * Sets the newOrderId variable. This variable is only used to store the first saved order in the list.
	 * @param newOrdId The order ID of the newly created saved order.
	 */
	setNewOrderId : function(newOrdId)
	{
		this.newOrderId = newOrdId;
	},

	/**
	 * Returns the ID of the new saved order. 
	 * The newOrderId variable is set only when it is the first saved order in the list.
	 * @returns {String} The ID of the newly created saved order.
	 */
	getNewOrderId : function()
	{
		return this.newOrderId;
	},
	
	/**
	 * Returns the currentOrderDeleted flag. 
	 * @returns {boolean} true or false indicating whether the current saved order was deleted.
	 * 
	 */
	isCurrentOrderDeleted : function()
	{
		return this.currentOrderDeleted;
	},
	
	/**
	 * Sets the currentOrderDeleted flag to true or false. 
	 * This flag determines if the current saved order was deleted.
	 * @param currOrderDeleted A boolean (true/false) indicating if the saved order was deleted.
	 */
	setCurrentOrderDeleted : function(currOrderDeleted)
	{
		this.currentOrderDeleted = currOrderDeleted;
	},
	
	/**
	* Opens the saved order details view for the order.
	* This method is invoked by the <b>View Details</b> action.
	* @param (string) reqListURL The URL to the 
	**/
	viewDetails : function (reqListURL)
	{		
		document.location.href = reqListURL;
	},
	
	/**
	 * Checks if a string is null or empty.
	 * @param (string) str The string to check.
	 * @return (boolean) Indicates whether the string is empty.
	 */
	isEmpty:function (str) {
		var reWhiteSpace = new RegExp(/^\s+$/);
		if (str == null || str =='' || reWhiteSpace.test(str) ) {
			return true;
		}
		return false;
	},

	/**
	 * Display saved order list for pagination
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

		console.debug(wc.render.getRefreshControllerById('SavedOrderListTable_controller').renderContext.properties);
		var beginIndex = pageSize * ( pageNumber - 1 );
		cursor_wait();
		wc.render.updateContext('SavedOrderListTable_Context', {'beginIndex':beginIndex});
		MessageHelper.hideAndClearMessage();
	},
	
	/**
	 * Remove the quantity of the SKU (e.g. when row is hidden)
	 * @param (string) restUrl The rest url for getting order items
	 * @param (string) params String with the params to be passed in
	 */
	getOrderItems:function(restUrl, params){
		var store = new dojo.store.JsonRest({
			target: restUrl
		});
	
		store.query(params).then(function(order){
			SavedOrderListJS.quantityList = {};
			if (order.orderItem == null) {
				MessageHelper.displayErrorMessage(storeNLS['MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL']);
				return;
			}
			for (var i = 0; i < order.orderItem.length; i++) {
				var orderId = order.orderId;
				
				if (!(orderId in SavedOrderListJS.quantityList)) {
					SavedOrderListJS.quantityList[orderId] = {};
				}
				SavedOrderListJS.quantityList[orderId][order.orderItem[i].productId] = order.orderItem[i].quantity;
			}
			
			if (typeof addReqListsJS != 'undefined') {
				addReqListsJS.toggleDropDownMenu(true,false);
			}
		});
	},
	
        /**
         *This method locks the order specified when the buyer administrator is browsing in 
         *an on behalf mode.
         */                 
        lockOrderOnBehalf: function(orderId){
                var params = {};
                params["orderId"] = orderId;
                params["filterOption"] = "All";
                params["storeId"] = this.storeId;
                params["catalogId"] = this.catalogId;
                params["langId"] = this.langId;		
                
                /*For Handling multiple clicks. */
                if(!submitRequest()){
                	return;
                }			
                cursor_wait();
		wc.service.invoke("AjaxRESTOrderLockOnBehalf", params);
        },
        
        /**
         *This method take over the lock on the order by other buyer administrator when the buyer administrator is browsing in 
         *an on behalf mode.
         */                 
        takeOverLockOrderOnBehalf: function(orderId, isCurrentOrder){
        		var params = {};
        		if (undefined !== isCurrentOrder && isCurrentOrder =='true'){
        			setDeleteCartCookie();
        			params["isCurrentOrder"] = 'true';
        		} else {
        			params["isCurrentOrder"] = 'false';
        		}
                params["orderId"] = orderId;
                params["filterOption"] = "All";
                params["storeId"] = this.storeId;
                params["catalogId"] = this.catalogId;
                params["langId"] = this.langId;		
                params["takeOverLock"] = "Y"
                /*For Handling multiple clicks. */
                if(!submitRequest()){
                	return;
                }			
                cursor_wait();
                wc.service.invoke("AjaxRESTOrderLockTakeOverOnBehalf", params);
        },
        
        /**
         *This method unlocks the order specified when the buyer administrator is browsing in 
         *an on behalf mode.
         */                 
        unlockOrderOnBehalf: function(orderId){
                var params = {};
                params["orderId"] = orderId;
                params["filterOption"] = "All";
                params["storeId"] = this.storeId;
                params["catalogId"] = this.catalogId;
                params["langId"] = this.langId;		
                
                /*For Handling multiple clicks. */
                if(!submitRequest()){
                	return;
                }			
                cursor_wait();
		wc.service.invoke("AjaxRESTOrderUnlockOnBehalf", params);
        }
}

