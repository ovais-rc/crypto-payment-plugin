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

dojo.provide("wc.mobile.PlainHeading");

dojo.require("dojox.mobile.Heading");
dojo.require("dojox.mobile.ToolBarButton");

dojo.declare("wc.mobile.PlainHeading", [ dojox.mobile.Heading, dojox.mobile.ToolBarButton ], {

	transition: "slide",
	
	buildRendering: function() {
		this.domNode = this.containerNode = this.srcNodeRef;
		this.back = "Back";
	},
	
	_setBackAttr: function(/*String*/back){
		this.inherited(arguments);
		document.getElementById(this.backButton.id).style.display = "none";
	}

});
