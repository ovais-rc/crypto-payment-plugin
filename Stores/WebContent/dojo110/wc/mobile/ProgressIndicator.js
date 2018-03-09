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

dojo.provide("wc.mobile.ProgressIndicator");

dojo.require("dojox.mobile.ProgressIndicator");

dojo.declare("wc.mobile.ProgressIndicator", [ dojox.mobile.ProgressIndicator ], {

	start: function() {
	
		if (!this.underLay) {
			this.underLay = dojo.create('div', {style: {position:'absolute', top:'0px', left:'0px', width:'100%', height:'100%'}}, this.domNode, 'before');
		}
		
		this.inherited(arguments);
	},

	stop: function(){

		if (this.underLay) {
			dojo.destroy(this.underLay);
		}
		this.inherited(arguments);
	}

});

wc.mobile.ProgressIndicator._instance = null;
wc.mobile.ProgressIndicator.getInstance = function(){
	if(!wc.mobile.ProgressIndicator._instance){
		wc.mobile.ProgressIndicator._instance = new wc.mobile.ProgressIndicator();
	}
	return wc.mobile.ProgressIndicator._instance;
};

