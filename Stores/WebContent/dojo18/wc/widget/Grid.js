//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"dojo/_base/lang",
	"dojo/dom-style",
	"dojo/on",
	"dojo/query",
	"dijit/_WidgetBase",
	"dojo/NodeList-traverse"
], function(declare, lang, domStyle, on, query, _WidgetBase) {
	return declare([_WidgetBase], {
		_setColumnCountAttr: function(columnCount) {
			var items = query(this.domNode).children("li");
			items.style("width", 100 / columnCount + "%");
			this._set("columnCount", columnCount);
		},
		
		postCreate: function() {
			this.inherited(arguments);
			this.own(on(window, "resize", lang.hitch(this, "resize")));
			this.resize();
		},
		
		resize: function() {
			this.inherited(arguments);
			var columnCount = (this.columnCount ? this.columnCount : 1);
			if (this.columnCountByWidth) {
				for (var width in this.columnCountByWidth) {
					if (this.domNode.clientWidth >= width) {
						columnCount = this.columnCountByWidth[width];
					}
				}
			}
			if (columnCount != this.columnCount) {
				this.set("columnCount", columnCount);
			}
		}
	});
});
