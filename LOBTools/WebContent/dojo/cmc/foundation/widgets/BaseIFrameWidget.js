//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/widgets/ComponentWidget",
	"dojo/dom-construct",
	"dojo/dom-attr"
], function(declare, ComponentWidget, domConstruct, domAttr) {
	return declare(ComponentWidget, {
		buildRendering: function() {
			if (!this.domNode) {
				this.domNode = domConstruct.toDom("<div style=\"position:absolute;-moz-user-select:none;outline:none\"></div>");
				this.iframeNode = domConstruct.toDom("<iframe style=\"width: 100%; height: 100%; position:absolute; border:none\"></iframe>");
				this.domNode.appendChild(this.iframeNode);
			}
			this.applySrc();
			this.inherited(arguments);
		},
		applySrc: function(){
			if (this.component.src != domAttr.get(this.iframeNode, "src")){
				domAttr.set(this.iframeNode, "src", this.component.src);
			}
		}
	});
});
