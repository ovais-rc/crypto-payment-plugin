//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/widgets/ComponentWidget",
	"cmc/RootComponent",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/on",
	"dojo/_base/lang",
	"dojo/dom",
	"dojo/dom-class",
	"dojo/query",
	"dojo/_base/event",
	"dijit/registry",
	"dojo/NodeList-traverse"
], function(declare, ComponentWidget, RootComponent, domConstruct, domStyle, on, lang, dom, domClass, query, event, registry) {
	return declare(ComponentWidget, {
		component: null,
		currentItem: null,
		items: [],
		separatorTemplate: "<li style=\"list-style:none; padding: 0; margin:1px 0px; border-bottom: 1px solid #E5E5E5\"></>",
		menuItemTemplate: "<li data-item-offset=\"{0}\" data-item-index=\"{1}\" class=\"cmcContextMenuItem cmcEnabledContextMenuItem\"><span style=\"display: inline-block; cursor: default; \">{2}</span></>",
		disabledMenuItemTemplate: "<li data-item-offset=\"{0}\" data-item-index=\"{1}\" class=\"cmcContextMenuItem cmcDisabledContextMenuItem\"><span style=\"display: inline-block; cursor: default; \">{2}</span></>",
		menuItemParentTemplate: "<ul class=\"cmcContextMenu\" style=\"list-style:none; margin: 0\"></ul>",
		
		_setItemsAttr: function (items){
			query(this.domNode).children().forEach(function(child){
				child.parentNode.removeChild(child);
			});
			if (items.length > 0){
				this.menuItemParentNode = domConstruct.toDom(this.menuItemParentTemplate);
				this.domNode.appendChild(this.menuItemParentNode);
				if (RootComponent.Singleton.rtlMirroring) {
					this.menuItemParentNode.dir = "rtl";
				}
				else {
					this.menuItemParentNode.dir = "ltr";
				}
			}
			for (var i = 0; i < items.length; i++) {
				var index = i;
				var item = items[i];
				var itemNode = domConstruct.toDom(lang.replace(this.menuItemTemplate, [item.offset, index, item.label]));
				if (item.type == "Disabled"){
					itemNode = domConstruct.toDom(lang.replace(this.disabledMenuItemTemplate, [item.offset, index, item.label]));
				}
				if(item.separatorbefore){
					this.menuItemParentNode.appendChild(domConstruct.toDom(this.separatorTemplate));
				}
				item.node = itemNode;
				this.menuItemParentNode.appendChild(itemNode);
			}
		
			this._set("items", items);			
		},
		
		buildRendering: function() {
			if (!this.domNode) {
				this.domNode = domConstruct.toDom("<div style=\"position:absolute;outline:none;display:none\"></div>");
			}
			this.inherited(arguments);
		},
		
		applyVisible: function() {
			this.inherited(arguments);
			if (this.component.visible){
				var width = 0;
				var spans = query(".cmcContextMenuItem span", this.domNode);
				spans.forEach(function(span){
					width = (width < span.offsetWidth)? span.offsetWidth : width;
				});
				spans.forEach(function(span){	
					domStyle.set(span, "width", width + 'px');
				});
			}
			else {
				this.resetCurrentItem();;
			}
		},
		
		resetCurrentItem: function(){
			this.set("currentItem", null);
		},
		
		applyClickable: function() {
			domStyle.set(this.domNode, "pointerEvents", "auto");
		},
		
		postCreate: function() {

			this.own(
				on(this.domNode, ".cmcContextMenuItem.cmcEnabledContextMenuItem:click", lang.hitch(this, function(e){
					var item = e.target;
					if (item.parentNode !== this.domNode){
						item = item.parentNode;
					}
					var offset = parseInt(item.getAttribute("data-item-offset"));
					this.component.select(offset);
					event.stop(e);
				})),
				on(this.domNode, ".cmcContextMenuItem.cmcEnabledContextMenuItem:contextmenu", lang.hitch(this, function(e){
					event.stop(e);
					var item = e.target;
					if (item.parentNode !== this.domNode){
						item = item.parentNode;
					}
					var offset = parseInt(item.getAttribute("data-item-offset"));
					this.component.select(offset);
				})),
				on(this.domNode, ".cmcContextMenuItem.cmcEnabledContextMenuItem:mouseover", lang.hitch(this, function(e){
					query(".cmcMenuItemHilte", this.domNode).forEach(function(hilited){
						domClass.remove(hilited, "cmcMenuItemHilte");
					});
					var item = e.target;
					if (item.parentNode !== this.domNode){
						item = item.parentNode;
					}
					domClass.add(item, "cmcMenuItemHilte");
					var index = parseInt(item.getAttribute("data-item-index"));
					this.set("currentItem",index);
					event.stop(e);
				})),
				on(this.domNode, "keydown", lang.hitch(this, function(e){
					if (e.keyCode == 27 ) {
						this.component.hide();
						event.stop(e);
					}					
					else if (e.keyCode == 38) {
						//up key
						query(".cmcMenuItemHilte", this.domNode).forEach(function(hilited){
							domClass.remove(hilited, "cmcMenuItemHilte");
						});
						if(this.currentItem != null && this.currentItem > 0){
							this.set("currentItem",this.currentItem - 1);
						}
						else if (this.currentItem == 0){
							this.set("currentItem",this.items.length - 1);
						}
						else {
							this.set("currentItem",0);
						}
						domClass.add(this.items[this.currentItem].node, "cmcMenuItemHilte");
						event.stop(e);
					}
					else if (e.keyCode == 40){
						query(".cmcMenuItemHilte", this.domNode).forEach(function(hilited){
							domClass.remove(hilited, "cmcMenuItemHilte");
						});
						if(this.currentItem != null && this.currentItem < this.items.length - 1){
							this.set("currentItem",this.currentItem + 1);
						}
						else {
							this.set("currentItem",0);
						}
						domClass.add(this.items[this.currentItem].node, "cmcMenuItemHilte");
						event.stop(e);
					}
					else if (e.keyCode == 13){
						var currentItem = this.currentItem;
						var item = this.items[currentItem];
						if (item.type != "Disabled"){
							this.component.select(parseInt(item.node.getAttribute("data-item-offset")));
						}
						event.stop(e);
					}
				})),
				on(this.domNode, "mouseout", lang.hitch(this, function(){
					query(".cmcMenuItemHilte", this.domNode).forEach(function(hilited){
						domClass.remove(hilited, "cmcMenuItemHilte");
					});
					this.resetCurrentItem();
				})),
				on(this.domNode, "blur", lang.hitch(this.component, "checkMouse")),
				//use checkMouse to handle issue encountered with IE
				on(window, "resize", lang.hitch(this.component, "hide"))
			);
			this.inherited(arguments);
		},
		setFocus: function() {
			this.domNode.tabIndex = -1;
			this.domNode.focus();
		}
	});
});
