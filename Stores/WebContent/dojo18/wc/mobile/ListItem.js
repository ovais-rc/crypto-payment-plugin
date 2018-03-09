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

dojo.provide("wc.mobile.ListItem");

dojo.require("dojox.mobile.ListItem");
dojo.require("wc.mobile._ItemBase");

dojo.declare("wc.mobile.ListItem", [ dojox.mobile.ListItem, wc.mobile._ItemBase ], {
	
	startup: function() {
		if(this._started) {
			return;
		}
		this.inheritParams();
		if(this.moveTo || this.href || this.url || this.clickable) {
			this.connect(this.domNode, "startTransition", "startTransition");
		}
		this.inherited(arguments);
	},
	
});
