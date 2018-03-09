//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

require([
         	 "dojo/dom-attr",
			 "dojo/html",
			 "dojo/on", 
			 "dojo/query", 
			 "dojo/topic", 
			 "dojo/dom",
			 "dojo/dom-style",
			 "dojo/dom-class",
			 "dojo/_base/event",
			 "dojo/_base/array",
			 "dojo/NodeList-manipulate",
			 "dojo/domReady!"], function(domAttr,html,on, query, topic, dom, domStyle, domClass, event, array,nodelist) {

FindOrders = function(){
				
	this.searchListData = {
							"progressBarId":"FindOrdersList_form_botton_1", "formId":"FindOrders_searchForm", 
							"searchButtonId":"FindOrdersList_form_botton_1", "clearButtonId":"FindOrdersList_form_botton_2",
							 "searchOptionLabel" : "searchOptionLabel"
						  },
	

	 /**
		Setup events for Search and Clear Results button in Find Orders Page
	*/
	this.setUpEvents = function(){
		
		var scope = this;
		var target = dojo.byId(this.searchListData.searchButtonId);
		if(target != null) {
			on(target, "click", function(event){
				scope.doSearch();
			});
		}

		target = dojo.byId(this.searchListData.clearButtonId);
		if(target != null) {
			on(target, "click", function(event){
				scope.clearFilter();
			});
		}

	};


	
	this.clearFilter = function(){
		
		this.clearSearchResults();

		// Remove search criteria..
		dojo.query('#FindOrders_searchForm input[id ^= "findOrders_"]').forEach(function(inputElement){
			inputElement.value = null;
			var dijitObject = dijit.byId(inputElement.id);
			if(dijitObject != null){
				dijitObject.setValue('-1');
			}
		});

		dojo.query('#FindOrders_searchForm table[id ^= "findOrders_"]').forEach(function(inputElement){
			var dijitObject = dijit.byId(inputElement.id);
			if(dijitObject != null){
				dijitObject.setValue('-1');
			}
		});
		
		
		
	};

	this.doSearch = function(){
		this.clearSearchResults();

		//Do we have any search criteria to search ?
		var doSearch = false;
		dojo.query('#'+this.searchListData.formId+' input[id ^= "findOrders_"]').forEach(function(inputElement){
				 var value = inputElement.value;
				 if(value != null && value != ''){
					 doSearch = true;
				 }
			 });


		if(!doSearch){
			dojo.query('#'+this.searchListData.formId+' table[id ^= "findOrders_"]').forEach(function(inputElement){
					var dijitObject = dijit.byId(inputElement.id);
					var value = dijitObject.value;
					if(value != '' ){
						doSearch = true;
					}
				 });
		}


		if(!doSearch) {
			MessageHelper.formErrorHandleClient(this.searchListData.searchButtonId, storeNLS["CSR_NO_SEARCH_CRITERIA"]);
			return false;
		}


		var renderContext = wc.render.getContextById('findOrdersSearchResultsContext');		
		renderContext.properties["searchInitialized"] = "true";
		
		setCurrentId(this.searchListData.progressBarId);
		if(!submitRequest()){
			return;
		}

		cursor_wait();
		var params = {};
		// code level formatting can be taken care or in js. Based on server REST need, include formatting here.
		//this.formatDate();
		wc.render.getRefreshControllerById("findOrdersController").formId = this.searchListData.formId;
		wc.render.updateContext("findOrdersSearchResultsContext", params);	
		
		
	};

	
	
	this.toggleOrderSummarySection = function(orderId){
		findbyCSRJS.showHide('orderDetailsExpandedContent_'+orderId, 'collapsed', 'expanded');
		findbyCSRJS.changeDropDownArrow('dropDownArrow_'+orderId,'expanded');
		return true;
	};

	this.handleActionDropDown = function(event,memberId){
		findbyCSRJS.cancelEvent(event);
		findbyCSRJS.toggleSelection('actionDropdown','actionDropdown_'+memberId, 'findOrdersSearchResults', 'active');
		findbyCSRJS.toggleCSSClass('actionButton','actionButton7_'+memberId,'findOrdersSearchResults','actionDropdownAnchorHide','actionDropdownAnchorDisplay');
		return false;
	}

	this.clearSearchResults = function(){
		// Remove search results
		if(dojo.byId("findOrdesResultList_table") != null){
			dojo.style("findOrdesResultList_table","display","none");
		}
	};

	

	

	
	this.accessOrderDetails = function(userId, selectedUser, landingURL)
	{
		
		
		var renderContext = wc.render.getContextById('findOrdersSearchResultsContext');		
		// First need to set user in sesison before accessing orderDetails page...
		
		// in case of order details display, landing URL will be different. So set that here before calling setUserInSession command.
		// in case of guest orders, landingURL will be coming null and it will pass null as well..
		if(landingURL != '' && landingURL != null){
			renderContext.properties["landingURL"] = landingURL;
		}
		// currently landingUrl is registered customers account link...if it is guest user, landing url will be differnt..
		findbyCSRJS.setUserInSession(userId,selectedUser,landingURL);
		
	};

	
	this.lockUnlockOrder = function(orderId, isLocked, takeOverLock){
		
		//Save it in context
		var context = wc.render.getContextById("OrderLockUnlockContext");
		context.properties["orderId"] = orderId;
		var takeOverLockStatus = context.properties[orderId+"_takeOverLock"];
		if(takeOverLockStatus != null){
			//if context has already  saved data then pick up from conetxt
			takeOverLock = takeOverLockStatus;
		}
		
		if(takeOverLock == 'true')
		{
			//take over lock first and then call unlock order
			wc.service.invoke("AjaxRESTTakeOverlock", {'orderId' : orderId, 'filterOption' : "All", 'takeOverLock' : 'Y',  'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});	
		
		}
		else
		{
			// this is required to set value in context back when CSR decides to unlock again..
			var lockStatus = context.properties[orderId+"_isLocked"];
			if(lockStatus != null){
				//if context has already  saved data then pick up from conetxt
					isLocked = lockStatus;
			}
			// Invoke service : if order is already locked, call unlock cart to unlock the same else lock it
			if(isLocked=='true')
			{
				//unlock order
				wc.service.invoke("AjaxRESTOrderUnlock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});
		
			}else
			{
				//lock order...
				wc.service.invoke("AjaxRESTOrderLock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});	
		
			}
		}
		
		
	};
	
	

	this.onlockUnlockOrder = function(serviceResponse){
		
		var message = storeNLS["SUCCESS_ORDER_LOCK"];
		var lockStatusText = storeNLS['UNLOCK_CUSTOMER_ORDER_CSR'];
		if(serviceResponse.isLocked[0] == 'true'){
			message = storeNLS["SUCCESS_ORDER_UNLOCK"];
			lockStatusText = storeNLS['LOCK_CUSTOMER_ORDER_CSR'];
		}
		MessageHelper.displayStatusMessage(message);
		
		var renderContext = wc.render.getContextById("OrderLockUnlockContext"); //this should be orderlock related context
		var orderId = renderContext.properties["orderId"];  // orderid
		var lockStatus = renderContext.properties[orderId+"_isLocked"];
		
		// Update widget text...
		dojo.byId("orderLocked_"+orderId).innerHTML = lockStatusText;
		
		if(dojo.byId("minishopcart_lock_"+orderId) != null){
			var node = dojo.byId("minishopcart_lock_"+orderId);
			if(renderContext.properties[orderId+"_isLocked"] == "true")
			{
				 domAttr.set(node, "class", "");
			}
			else
			{
				 domAttr.set(node, "class", "nodisplay");
			}
		}
	};

	this.displayCSROrderSummaryPage = function(orderId){
		document.location.href = "CSROrderSummaryView"+"?"+getCommonParametersQueryString()+"&orderId="+orderId;
	};
	
};
	
});


dojo.addOnLoad(function(){
	findOrdersJS = new FindOrders();
	findOrdersJS.setUpEvents();
	
});


/**
 * Declares a new render context for find orders  result list - To display orders based on search criteria.
 */
wc.render.declareContext("findOrdersSearchResultsContext",{'searchInitialized':'false', 'isPaginatedResults':'false'},"");

/** 
 * Declares a new refresh controller for the Find Orders List
 */
wc.render.declareRefreshController({
	   id: "findOrdersController",
	   renderContext: wc.render.getContextById("findOrdersSearchResultsContext"),
	   url: "",
	   baseURL:getAbsoluteURL()+'FindOrdersResultListView',
	   formId: ""
	   
	   ,modelChangedHandler: function(message, widget) {
			 console.debug("modelChangedHandler of findOrdersController",widget);
	   }

	   ,renderContextChangedHandler: function(message, widget) {
			var controller = this;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
			var renderContext = this.renderContext;
			widget.setInnerHTML("");
			console.debug(renderContext.properties);
			widget.refresh(renderContext.properties);
	   }       	   

	   ,postRefreshHandler: function(widget) {
		   findbyCSRJS.handleErrorScenario();
			console.debug("Post refresh handler of findOrdersController",widget);
			cursor_clear();
	   }
});


//Declare context and service for updating the status of user.
wc.render.declareContext("OrderLockUnlockContext",{},"");
wc.service.declare({
		id: "AjaxRESTOrderLock",
		actionId: "AjaxRESTOrderLock",
		url:  getAbsoluteURL()+'AjaxRESTOrderLock',
		formId: ""
		
		
	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		// set context of lock for this orderid as true... as it has been locked..

		var renderContext = wc.render.getContextById("OrderLockUnlockContext"); //this should be orderlock related context
		var orderId = renderContext.properties["orderId"];  // orderid
		renderContext.properties[orderId+"_isLocked"] = "true";
		
		//renderContext.properties[orderId+"_isLocked"] = lockStatus; // Save it in context for future use.
	
		findOrdersJS.onlockUnlockOrder(serviceResponse);
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} else {
			if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			}
		}
	}

});
wc.service.declare({

	id: "AjaxRESTOrderUnlock",
	actionId: "AjaxRESTOrderUnlock",
	url:  getAbsoluteURL()+'AjaxRESTOrderUnlock',
	formId: ""
	
	
 /**
  *  This method refreshes the panel 
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
	//var lockStatus = context.properties[orderId+"_isLocked"];
	// set context of lock for this orderid as false... as it has been unlocked..
	var renderContext = wc.render.getContextById("OrderLockUnlockContext"); //this should be orderlock related context
	var orderId = renderContext.properties["orderId"];  // orderid
	renderContext.properties[orderId+"_isLocked"] = "false";

	findOrdersJS.onlockUnlockOrder(serviceResponse);
	cursor_clear();
}

/**
* display an error message.
* @param (object) serviceResponse The service response object, which is the
* JSON object returned by the service invocation.
*/
,failureHandler: function(serviceResponse) {
	if (serviceResponse.errorMessage) {
		MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
	} else {
		if (serviceResponse.errorMessageKey) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
		}
	}
}

});

wc.service.declare({

	id: "AjaxRESTTakeOverlock",
	actionId: "AjaxRESTTakeOverlock",
	url:  getAbsoluteURL()+'/AjaxRESTTakeOverlock',
	formId: ""
	
	
 /**
  *  This method refreshes the panel 
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
	//findOrdersJS.onlockUnlockOrder(serviceResponse);
	//after successfully taking over lock, it should call unlock 
	var context = wc.render.getContextById("OrderLockUnlockContext");
	var orderId = context.properties["orderId"];
	context.properties[orderId+"_takeOverLock"] = "false";
	findOrdersJS.lockUnlockOrder(orderId, 'true', 'false');
	cursor_clear();
}

/**
* display an error message.
* @param (object) serviceResponse The service response object, which is the
* JSON object returned by the service invocation.
*/
,failureHandler: function(serviceResponse) {
	if (serviceResponse.errorMessage) {
		MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
	} else {
		if (serviceResponse.errorMessageKey) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
		}
	}
}

});
