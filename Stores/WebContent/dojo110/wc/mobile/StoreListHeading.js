//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.mobile.StoreListHeading");

dojo.require("dojox.mobile.Heading");

dojo.declare("wc.mobile.StoreListHeading", [ dojox.mobile.Heading ], {
	
	onClick: function(e) {
	
		var mainView = dijit.byId("StoresPopupView-GeoNode-");
		var storeListView = dijit.byId("StoresPopupView-PhysicalStore-myStoreList");
		var storeListItem = dijit.byId("StorePopupView_MyStoreList_ListItem");

		storeListView.destroy();
		storeListView = null;
		
		dojo.xhrGet({
			url: storeListItem.url,
			load: dojo.hitch(this, this.dataLoaded)
		})
	},

	dataLoaded: function(data) {
			
		var storeListItem = dijit.byId("StorePopupView_MyStoreList_ListItem");
		
		var progressIndicator = dojox.mobile.ProgressIndicator.getInstance();
		progressIndicator.stop();
		
		storeListItem.moveTo = storeListItem._parse(data);
		if(!dojox.mobile._viewMap) {
			dojox.mobile._viewMap = {};
		}
		dojox.mobile._viewMap[storeListItem.url] = storeListItem.moveTo;
		
		if(storeListItem.moveTo) {
			var currentView = storeListItem.findCurrentView();
			if(currentView) {
				currentView.performTransition(storeListItem.moveTo, -1, storeListItem.transition);
			}
		}
	}

});
