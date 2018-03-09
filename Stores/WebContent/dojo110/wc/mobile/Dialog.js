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

dojo.provide("wc.mobile.Dialog");

dojo.require("dojox.mobile.Tooltip");
dojo.require("dojo.window");

dojo.declare("wc.mobile.Dialog", [ dojox.mobile.Tooltip ], {

	greyBackground: true,

	onShow: function(/*DomNode*/node){},
	onHide: function(/*DomNode*/node, /*Anything*/v){},

	resizeDialog: function() {
		
		var vs = dojo.window.getBox();
		var dialogWidth = dojo.style(this.domNode, "width");
		var dialogHeight = dojo.style(this.domNode, "height");
		var windowsWidth = vs.w;
		var windowsHeight = vs.h;
		
		var top = (windowsHeight - dialogHeight) / 3 / windowsHeight * 100;
		var left = (windowsWidth - dialogWidth) / 2 / windowsWidth * 100;

		dojo.style(this.domNode, "top", top + "%");
		dojo.style(this.domNode, "left", left + "%");
		dojo.style(this.domNode, "visibility", "visible");
		dojo.style(this.domNode, "position", "absolute");
	},
		
	buildRendering: function(){
		this.inherited(arguments);

		// remove arrow from dialog
		if(this.anchor){
			this.anchor.removeChild(this.innerArrow);
			this.anchor.removeChild(this.arrow);
			this.domNode.removeChild(this.anchor);
			this.anchor = this.arrow = this.innerArrow = undefined;
		}
		
		this.connect(null, "onresize", this.resizeDialog);
		this.connect(null, "onorientationchange", this.resizeDialog);
	},
	
	show: function(modal) {
		
		this.modal = modal;
		if (!this.modal) {
			this.modal = false;
		}

		if(!this.underLay){
			if (this.greyBackground) {
				this.underLay = dojo.create('div', {style: {position:'absolute', top:'0px', left:'0px', width:'100%', height:'100%', opacity: 0.5, backgroundColor:'black'}}, this.domNode, 'before');
			} else {
				this.underLay = dojo.create('div', {style: {position:'absolute', top:'0px', left:'0px', width:'100%', height:'100%', opacity: 0, backgroundColor:'black'}}, this.domNode, 'before');
			}
			this.connect(this.underLay, "onclick", "_onBlur");
		}
		
		dojo.style(this.underLay, "visibility", "visible");
		this.resizeDialog();
		dojo.replaceClass(this.domNode, "mblTooltipVisible", "mblTooltipHidden");
		
		return true;
	},

	hide: function(/*Anything*/ val) {
		
		dojo.style(this.underLay, "visibility", "hidden");
		this.inherited(arguments);
		this.onHide(this.node, val);
	},

	_onBlur: function(e) {
		if (this.onBlur(e) !== false && !this.modal) { // only exactly false prevents hide()
			this.hide(e);
		}
	},

	destroy: function() {
		this.inherited(arguments);
		dojo.destroy(this.underLay);
	}

});
