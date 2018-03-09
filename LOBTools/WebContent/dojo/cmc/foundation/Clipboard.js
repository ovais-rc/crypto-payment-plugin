//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"dojo/dom-construct",
	"cmc/RootComponent"
], function(declare, domConstruct, RootComponent) {
	return new declare(null, {
		copy: function(clipboardString) {
			if (window.clipboardData && window.clipboardData.setData) {
				window.clipboardData.setData("Text", clipboardString);
			}
			else {
				try {
					var clipboardNode = this.getClipboardNode();
					if (clipboardNode != null) {
						clipboardNode.innerHTML = clipboardString;
						window.getSelection().removeAllRanges();
						var range = document.createRange();
						range.selectNodeContents(clipboardNode);
						window.getSelection().addRange(range);
						document.execCommand("copy");
					}
				}
				catch (e) {
					console.log("unable to access clipboard "+e);
					console.log(e);
				}
			}
		},
		getClipboardNode: function() {
			var clipboardNode = null;
			if (RootComponent.Singleton != null && RootComponent.Singleton.widget != null && RootComponent.Singleton.widget.domNode != null) {
				clipboardNode = RootComponent.Singleton.widget.clipboardNode;
				if (clipboardNode == null) {
					clipboardNode = domConstruct.toDom("<div style=\"position:absolute;\" class=\"selectEnabled\"></div>");
					RootComponent.Singleton.widget.clipboardNode = clipboardNode;
					RootComponent.Singleton.widget.domNode.insertBefore(clipboardNode, RootComponent.Singleton.widget.domNode.firstChild);
				}
			}
			return clipboardNode;
		}
	})();
});
