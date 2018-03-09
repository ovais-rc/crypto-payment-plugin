//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define("wc/widget/Select", [
	"dojo/_base/declare",
	"dojo/_base/event",
	"dojo/_base/lang", //lang.trim
	"dojo/dom-class",
	"dojo/on",
	"dojo/aspect", //aspect.after
	"dojo/_base/array", //array.indexOf
	"dijit/form/Select"
], function(declare, event, lang, domClass, on, aspect, array, FormSelect) {
	return declare("wc.widget.Select", [FormSelect], {
		
		//the class to add to DropDown popup menu for css styling
		wcMenuClass: "wcSelectMenu",
		
		_setWcMenuClassAttr : function (wcMenuClass){
			if (wcMenuClass !== undefined && wcMenuClass !== null && wcMenuClass !== '' && wcMenuClass != this.wcMenuClass){
				if (this.dropDown){
					domClass.remove(this.dropDown.domNode, this.wcMenuClass);
					domClass.add(this.dropDown.domNode, wcMenuClass);
				}
				this._set("wcMenuClass", wcMenuClass);
			}
		},
		
		postCreate: function(){
		// overridden to add custom dropdown class and "kepress" event handler
			this.inherited(arguments);
			domClass.add(this.dropDown.domNode, this.wcMenuClass);
			this.own(
				aspect.after(this.dropDown, "focusChild", function(child){
					var menuItems = this.getChildren();
					this._lastIndex = array.indexOf(menuItems, child);
				},true),
				on(this.dropDown, "keypress", function(e){
					var temp = String.fromCharCode(e.charCode);
					var keycodeString = lang.trim(temp).toUpperCase();
					if (keycodeString.length > 0) {
						var found = false;
						var menuItems = this.getChildren();
						for (var i = this._lastIndex + 1; i < menuItems.length && !found; i++)
						{
							if (lang.trim(menuItems[i].get("label")).toUpperCase().indexOf(keycodeString) == 0){
									this.focusChild(menuItems[i]);
									found = true;
							}
						}
						if (!found) {
							for (var i = 0; i < this._lastIndex + 1 && !found; i++)
							{
								if (lang.trim(menuItems[i].get("label")).toUpperCase().indexOf(keycodeString) == 0){
									this.focusChild(menuItems[i]);
									found = true;
								}
							}
						}
					}
					event.stop(e);
				}),
				aspect.around(this.dropDown, "onItemClick", function(orgOnItemClick){
                    return function(){
                       if (!this._touchMoved){
                    	   orgOnItemClick.apply(this, arguments);
                       }
                    }
	            }),
	            on(this.dropDown.domNode, "touchstart", lang.hitch(this.dropDown, function(){
	                this._touchMoved = false;
	            })),
	            on(this.dropDown.domNode, "touchmove", lang.hitch(this.dropDown, function(){
	                this._touchMoved = true;
	            }))
			);
		}
	});
});
