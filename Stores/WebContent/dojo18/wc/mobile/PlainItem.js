//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.mobile.PlainItem");

dojo.require("dojox.mobile._ItemBase");
dojo.require("wc.mobile._ItemBase");

dojo.declare("wc.mobile.PlainItem", [ dojox.mobile._ItemBase, wc.mobile._ItemBase ], {

	startup: function() {
		if(this._started) {
			return;
		}
		this.inheritParams();
		if(this.moveTo || this.href || this.url || this.clickable) {
			this.connect(this.domNode, "onclick", "onClick");
			this.connect(this.domNode, "startTransition", "startTransition");
		}
		this.inherited(arguments);
	},

	onClick: function(e) {
		e.preventDefault();
		this.defaultClickAction(e);
	}

});
