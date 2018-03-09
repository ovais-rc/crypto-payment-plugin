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
	"cmc/foundation/ImageRegistry"
], function(declare, ImageRegistry) {
	return new declare(null, {
		cursorStyleElement: null,
		cmcClickablePointerRule: null,
		locked: false,
		showPointer: true,
		constructor: function() {
			this.cursorStyleElement = document.createElement("style");
			document.head.appendChild(this.cursorStyleElement);
			this.cursorStyleElement.appendChild(document.createTextNode("\n"));
			this.cursorStyleElement.sheet.insertRule(".cmcModal .cmcClickable { cursor: pointer }", 0);
			this.cmcClickablePointerRule = this.cursorStyleElement.sheet.cssRules[0];
		},
		setCursorGlobal: function(cursor) {
			if (cursor && typeof ImageRegistry[cursor] != "undefined") {
				var imageSet = ImageRegistry[cursor];
				if (imageSet.length > 0) {
					var image = imageSet[0];
					var contextRoot = "/lobtools";
					if (cmcConfig.serviceContextRoot) {
						contextRoot = cmcConfig.serviceContextRoot;
					}
					cursor = "url('" + contextRoot + image.uri + "')";
				}
			}
			this.cursorStyleElement.sheet.deleteRule(0);
			this.cursorStyleElement.sheet.insertRule(".cmcModal .cmcClickable { cursor: " + cursor + " }", 0);
		},
		restoreCursor: function() {
			if (!this.locked) {
				this.setCursorGlobal(this.showPointer ? "pointer" : "default");
			}
		},
		showHandCursor: function(show) {
			this.showPointer = show;
			this.setCursorGlobal(show ? "pointer" : "default");
		},
		lock: function() {
			this.locked = true;
		},
		unlock: function() {
			this.locked = false;
			this.restoreCursor();
		}
	})();
});