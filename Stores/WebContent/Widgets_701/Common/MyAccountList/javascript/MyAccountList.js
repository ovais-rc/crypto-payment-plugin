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

require([
		"dojo/_base/event",		
		"dojo/dom-class",				
		"dojo/on",
		"dojo/query"								
	], function(event, domClass, on, query) {
	var mouseDownConnectHandle = null;
	var activeMenuNode = null;
	var toggleControlNode = null;
	
	var registerMouseDown = function() {
		if (mouseDownConnectHandle == null) {
			mouseDownConnectHandle = on(document.documentElement, "mousedown", handleMouseDown);
		}
	};
	
	var unregisterMouseDown = function() {
		if (mouseDownConnectHandle != null) {
			mouseDownConnectHandle.remove();
			mouseDownConnectHandle = null;
		}
	};
	
	var handleMouseDown = function(evt) {
		if (activeMenuNode != null) {
			var node = evt.target;
			if (node != document.documentElement) {
				var close = true;
				while (node && node != document.documentElement) {
					if (node == activeMenuNode || node == toggleControlNode || domClass.contains(node, "dijitPopup")) {
						close = false;
						break;
					}
					node = node.parentNode;
				}
				if (node == null) {
					var children = query("div", activeMenuNode);
					for (var i = 0; i < children.length; i++) {
						var position = domGeometry.position(children[i]);
						if (evt.clientX >= position.x && evt.clientX < position.x + position.w &&
							evt.clientY >= position.y && evt.clientY < position.y + position.h) {
							close = false;
							break;
						}
					}
				}
				if (close) {
					hideMenu(activeMenuNode);
				}
			}
		}
	};

	showMenu = function(target){
		
		//Ensure All menus are closed on list table
		query("div.listTable a[table-parent='listTable']").forEach(function(node){
			hideMenu(node);
		});
		
		query("div.listTable div[table-parent='listTable']").forEach(function(node){
			hideMenu(node);
		});
		
		query("div.listTable form[table-parent='listTable']").forEach(function(node){
			hideMenu(node);
		});
				
		domClass.add(target, "active");
		activeMenuNode = target;
		var toggleControl = query("div.listTable a[table-toggle='" + target.id + "']");
		toggleControl.addClass("clicked");
		toggleControlNode = toggleControl[0];
		registerMouseDown();
	};
	
	hideMenu = function(target){		
		domClass.remove(target, "active");
		query("div.listTable a[table-toggle='" + target.id + "']").removeClass("clicked");
		unregisterMouseDown();
		activeMenuNode = null;
		toggleControlNode = null;
	};
	toggleMenu = function(target){
		if (domClass.contains(target, "active")){
			hideMenu(target);
		}else{
			showMenu(target);
		}
	};
	
	toggleExpand = function(target){
		query("div.listTable div[row-expand]").forEach(function(node){
			var resetNodeId = node.getAttribute("row-expand");
			var resetNodeElement = document.getElementById(resetNodeId);
			if (resetNodeElement != target){
				resetNodeElement.src = resetNodeElement.src.replace("sort_arrow_DN.png","sort_arrow_OFF.png");
				resetNodeElement.src = resetNodeElement.src.replace("sort_arrow_UP.png","sort_arrow_OFF.png");
				domClass.remove(resetNodeElement, "active");
			}
		});
		if(domClass.contains(target,"active")){
			domClass.remove(target, "active");
			target.src = target.src.replace("sort_arrow_OFF.png","sort_arrow_UP.png");
			target.src = target.src.replace("sort_arrow_DN.png","sort_arrow_UP.png");
		}else{
			domClass.add(target, "active");
			target.src = target.src.replace("sort_arrow_OFF.png","sort_arrow_DN.png");
			target.src = target.src.replace("sort_arrow_UP.png","sort_arrow_DN.png");
		}		
	};
	
	eventActionsInitialization = function(){
		on(document, "div.listTable div[row-expand]:click", function(e){
			var target = this.getAttribute("row-expand");
			toggleExpand(document.getElementById(target));
			event.stop(e);	
		});
		
		on(document, "div.listTable a[table-toggle]:click", function(e){
			var target = this.getAttribute("table-toggle");
			toggleMenu(document.getElementById(target));
			event.stop(e);	
		});
		
		on(document, "div.listTable a[table-toggle]:keydown", function(e){			
			if (e.keyCode == 9 || (e.keyCode ==9 && e.shiftKey)) {		
				var target = this.getAttribute("table-toggle");	
				if ( target != "newListDropdown" && target != 'uploadListDropdown'){
					hideMenu(document.getElementById(target));					
				}
			}
			else if (e.keyCode == 13){	
				var target = this.getAttribute("table-toggle");
				toggleMenu(document.getElementById(target));	
				event.stop(e);		
			}	
			else if (e.keyCode == 40){
				var target = this.getAttribute("table-toggle");
				toggleMenu(document.getElementById(target));
				var targetElem = document.getElementById(target);
				var targetMenuItem = query('[role*="menuitem"]', targetElem)[0];
				if ( targetMenuItem != null){
					targetMenuItem.focus();					
				}		
				event.stop(e);	
			}
		});						
	};			
	
	/**
	* Toggle mobile view or full view depending on size of the table's container (if < 600, show mobile)
	**/
	toggleMobileView = function() {
		var containerWidth = dojo.coords(dojo.query(".listTable")[0].parentElement.parentElement).w;
		if (containerWidth < 600) {
			dojo.query(".fullView").style("display", "none");
			dojo.query(".listTableMobile").style("display", "block");
		} else {
			var fullView = dojo.query(".fullView");
			for (var i = 0; i < fullView.length; i++) {
				if (!dojo.hasClass(fullView[i], "nodisplay")) {
					dojo.style(fullView[i], "display", "block");
				}
			}

			dojo.query(".listTableMobile").style("display", "none");
		}
	};

	/**
	* Toggle expanded content to show or hide (e.g. when button is clicked)
	* @param widgetName the name of the widget
	* @param row The row on which the expanded content is contained
	**/
	toggleExpandedContent = function(widgetName, row) {
		dojo.toggleClass('WC_' + widgetName + '_Mobile_ExpandedContent_' + row, 'nodisplay');
		dojo.toggleClass('WC_' + widgetName + '_Mobile_TableContent_ExpandButton_' + row, 'nodisplay');
		dojo.toggleClass('WC_' + widgetName + '_Mobile_TableContent_CollapseButton_' + row, 'nodisplay');
	};
	
	eventActionsInitialization(); 

	window.setTimeout(function() {
		
		// the code is shared by ItemTable_UI.jspf, the query for cancel button and newListButton could be empty, use
		// forEach to handle this case.
		query("#newListButton").forEach(function(newListButton){
			on(newListButton,"keydown",function(e){
				if (e.keyCode == 13){
					var target = this.getAttribute("table-toggle");
					toggleMenu(document.getElementById(target));				
					var targetElem = document.getElementById(target);				
					query('[class*="input_field"]', targetElem)[0].focus();
					event.stop(e);
				}
			});
		});
		
		query("form.toolbarDropdown > .createTableList > .button_secondary").forEach(function(cancelButton){
			on(cancelButton, "keydown", function(e){
				if (e.keyCode == 9 || (e.keyCode ==9 && e.shiftKey)) {
					var targetId = this.getAttribute("id");				
					var newTargetId = targetId.replace("_NewListForm_Cancel","_NewListForm_Name"); 
					dojo.byId(newTargetId).focus();
					event.stop(e);					
				} else if (e.keyCode == 13){
					var target = this.getAttribute("table-toggle");
					hideMenu(document.getElementById(target));
					newListButton.focus();
					event.stop(e);
				}
			});
		});
		
		query(".actionDropdown").forEach(function(actionMenu,i){						
			var actionMenuItems = query('[role*="menuitem"]',actionMenu);
			actionMenuItems.forEach(function(actionMenuItem,j){
				on(actionMenuItem,"keydown",function(e){
					if (e.keyCode == 9 || (e.keyCode ==9 && e.shiftKey)) {
						hideMenu(document.getElementById(actionMenu.getAttribute("id")));					
					}					
					else if (e.keyCode == 38) {
						actionMenuItems[j == 0 ? actionMenuItems.length - 1 : j - 1].focus();
						event.stop(e);
					}
					else if (e.keyCode == 40){
						actionMenuItems[(j + 1) % actionMenuItems.length].focus();
						event.stop(e);
					}
				});				
			});	
		});		
	},100);	
});
