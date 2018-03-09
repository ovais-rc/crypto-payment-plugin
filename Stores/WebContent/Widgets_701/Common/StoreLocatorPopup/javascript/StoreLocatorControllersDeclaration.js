//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2016
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>

/**
 * @fileOverview This file declares the controllers of the store locator.
 *
 * @version 1.0
 *
 */

/* Import dojo classes */
dojo.require("wc.render.common");
dojo.require("wc.widget.RefreshArea");
dojo.require("dojo.parser");


/**
 * The functions defined in the class are used to initialize the common parameters of the controllers and set the 
 * URL of a specific controller.
 *
 * @class This StoreLocatorContextsJS class defines all the variables and functions for manipuating the controllers
 * of the store locator.
 *
 */
StoreLocatorControllersDeclarationJS = {
	/* common paramater declarations */
	langId: "-1",
	storeId: "",
	catalogId: "",
	orderId: "",
	fromPage: "StoreLocator",

	/**
	 * This function initializes the common parameters. 
	 *
	 * @param {String} langId The language ID. 
	 * @param {String} storeId The store ID.
	 * @param {String} catalogId The catalog ID.
	 * @param {String} orderId The order ID.
	 * @param {String} fromPage The constants indicates what the calling page is.
	 *
	 */
	setCommonParameters:function(langId,storeId,catalogId,orderId,fromPage){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.orderId = orderId;
		this.fromPage = fromPage;
	},
	
	/**
	 * This function sets the URL of a controller. 
	 *
	 * @param {String} controllerId The controller identifier. 
	 * @param {String} url The URL.
	 *
	 */
	setControllerURL:function(controllerId,url){
		wc.render.getRefreshControllerById(controllerId).url = url;
	}

}


/* refresh controller declaration for "provinceSelectionsController" */
wc.render.declareRefreshController({
	id: "provinceSelectionsController",
	renderContext: wc.render.getContextById("provinceSelectionsContext"),
	url: "",
	formId: ""

	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
	}

	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		cursor_wait();
		widget.refresh(renderContext.properties);
	}

	,postRefreshHandler: function(widget) {
		var controller = this;
		var renderContext = this.renderContext;
		storeLocatorJS.refreshCities();
		cursor_clear();
	}

}),

/* refresh controller declaration for "citySelectionsController" */
wc.render.declareRefreshController({
	id: "citySelectionsController",
	renderContext: wc.render.getContextById("citySelectionsContext"),
	url: "",
	formId: ""

	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
	}

	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		cursor_wait();
		widget.refresh(renderContext.properties);
	}

	,postRefreshHandler: function(widget) {
		var controller = this;
		var renderContext = this.renderContext;
		storeLocatorJS.refreshSearchResults(StoreLocatorControllersDeclarationJS.fromPage);
		cursor_clear();
	}

}),

/* refresh controller declaration for "storeLocatorResultsController" */
wc.render.declareRefreshController({
	id: "storeLocatorResultsController",
	renderContext: wc.render.getContextById("storeLocatorResultsContext"),
	url: "",
	formId: ""

	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
	}

	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		cursor_wait();
		widget.refresh(renderContext.properties);
	}

	,postRefreshHandler: function(widget) {
		var controller = this;
		var renderContext = this.renderContext;

		var bopisTable = dojo.byId("bopis_table");
		if (bopisTable != null && bopisTable != "undefined") {
			bopisTable.focus();
		}
		var noStoreMsg = dojo.byId("no_store_message");
		if (noStoreMsg != null && noStoreMsg != "undefined") {
			noStoreMsg.focus();
		}

		cursor_clear();
	}

}),

/* refresh controller declaration for "selectedStoreListController" */
wc.render.declareRefreshController({
	id: "selectedStoreListController",
	renderContext: wc.render.getContextById("selectedStoreListContext"),
	url: "",
	formId: ""

	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
	}

	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		cursor_wait();
		widget.refresh(renderContext.properties);
	}

	,postRefreshHandler: function(widget) {
		var controller = this;
		var renderContext = this.renderContext;

		var bopisTable = dojo.byId("bopis_table");
		if (bopisTable != null && bopisTable != "undefined") {
			bopisTable.focus();
		}

		cursor_clear();
	}

})


