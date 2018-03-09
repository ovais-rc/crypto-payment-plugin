//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.widget.WCMenu");

dojo.require("dijit._Widget");
dojo.require("dijit._KeyNavContainer");
dojo.require("dijit._Templated");
dojo.require("dijit._WidgetsInTemplateMixin");
dojo.require("dijit.Menu");


dojo.declare("wc.widget.WCMenu",
    [dijit.Menu, dijit._WidgetsInTemplateMixin],
    {
        // summary
        //		A context menu you can assign to multiple elements

        // TODO: most of the code in here is just for context menu (right-click menu)
        // support.  In retrospect that should have been a separate class (dijit.ContextMenu).
        // Split them for 2.0

	
	/* The HTML that is generated when this widget is parsed. */
	templateString:
					'<div dojoAttachPoint="mainNode" waiRole="menu">'+
						'<table dojoAttachPoint="mainTable" cellpadding="0" cellspacing="0">'+
							'<tr class="wcmenu_menuItemsPosition">'+
								'<td>'+
									'<div class="wcmenu_columnPosition wcmenu_columnBorder wcmenu_columnPadding" dojoAttachPoint="containerNodeDiv" >'+
										'<table dojoAttachPoint="containerNodeTable" cellpadding="0" cellspacing="0" style="width: 100%" class="dijit dijitMenu dijitMenuPassive dijitReset dijitMenuTable" waiRole="menu" tabIndex="${tabIndex}" dojoAttachEvent="onkeypress:_onKeyPress">'+
											'<tbody class="dijitReset" dojoAttachPoint="containerNode"></tbody>'+
										'</table>'+
									'</div>'+
								'</td>'+
								
								'<td>'+
									'<div class="wcmenu_columnPosition wcmenu_columnBorder wcmenu_columnPadding" dojoAttachPoint="containerNode2Div" >'+
										'<table dojoAttachPoint="containerNode2Table" cellpadding="0" cellspacing="0" style="width: 100%" class="dijit dijitMenu dijitMenuPassive dijitReset dijitMenuTable" waiRole="menu" tabIndex="${tabIndex}" dojoAttachEvent="onkeypress:_onKeyPress">'+
											'<tbody class="dijitReset" dojoAttachPoint="containerNode2"></tbody>'+
										'</table>'+
									'</div>'+
								'</td>'+
							
							
								'<td>'+
									'<div class="wcmenu_columnPosition wcmenu_columnBorder wcmenu_columnPadding" dojoAttachPoint="containerNode3Div" >'+
										'<table dojoAttachPoint="containerNode3Table" cellpadding="0" cellspacing="0" style="width: 100%" class="dijit dijitMenu dijitMenuPassive dijitReset dijitMenuTable" waiRole="menu" tabIndex="${tabIndex}" dojoAttachEvent="onkeypress:_onKeyPress">'+
											'<tbody class="dijitReset" dojoAttachPoint="containerNode3"></tbody>'+
										'</table>'+
									'</div>'+
								'</td>'+
							'<tr>'+
							'<tr>'+
								'<td colspan="3">'+
									'<div dojoAttachPoint="showAllMainNode" class="wcmenu_showAllBorder wcmenu_showAllPadding">'+
										'<table cellpadding="0" cellspacing="0" class="wcmenu_showAllSize" dojoAttachEvent="onkeypress:_onKeyPress">'+
											'<tbody dojoAttachPoint="showAllContainer">'+
												'<div dojoType="dijit.MenuItem" dojoAttachPoint="showAllNode" dojoAttachEvent="onClick:showAll">'+
													'<span>'+
														'<a href="" dojoAttachPoint="menuItemLabel">hello</a>'+
													'</span >'+
												'</div>'+
											'</tbody>'+
										'</table>'+
									'</div>'+
								'</td>'+
							'</tr>'+
						'</table>'+ 
					'</div>',



        /* The text to display on the Show All menu item */
        showAllText: '',


        /* The fully resolved URL to be loaded when the Show All menu item is clicked. */
        showAllURL: '',

        /**
         *  The maximum number of menu items to show in a column. If more items exist than can fit into one column, a second column becomes visible, and then a third.
         *  If all three columns are full, the remaining categories are not displayed. This value must be greater then 0. The default value is 6.
         */
        maxItemsPerColumn: 6,

        /**
         *  The 'Show All' link is displayed when this value is true, even if all the categories fit into the menu. Otherwise, the 'Show All' link is only displayed
         *  when there are too many categories to display in the menu. The default value is false.
         */
        forceDisplayShowAll: false,

        /* Dojo attribute to tell parser to parse internal menu item widget for the show all menu item. */
        widgetsInTemplate : true,


        startup: function() {
            /* Move the children menu items around so that they appear in the correct columns of the new maximum three column menu table */


            var allChildren = this.getChildren();


            this.children = allChildren;

            /*If there are no children then hide the menu */
            if (this.children.length == 0) {
                this.mainNode.style.overflow = "hidden";
                this.mainNode.style.display = "none";
                this.showAllMainNode.style.overflow = "hidden";
                this.showAllMainNode.style.display = "none";
                this.mainNode.style.backgroundColor = "red";
                this.mainNode.style.padding = "0px";
                this.mainNode.style.margin = "0px";
                this.mainNode.style.width = "0px";
                this.mainNode.style.height = "0px";
                this.mainNode.style.border = "0px";
            }
            else {
                var thirdColumnCount = 0;

                if (this.maxItemsPerColumn < 1) {
                    this.maxItemsPerColumn = 1;
                }

                /* Determine if a bidi language is being used */
                var direction = this.getComputedStyle(this.domNode, "direction", " ");

                if (direction != null && direction != 'undefined' && direction == "rtl") {
                    this.bidi = true;
                }

                if (this.children.length + 1 > this.maxItemsPerColumn) {

                    /* Determine how many elements will go into the third column. */
                    if (this.children.length + 1 > 2 * this.maxItemsPerColumn) {
                        thirdColumnCount = this.children.length - (2 * this.maxItemsPerColumn);
                    }

                    /* Add elements to second column if overflowing the first column. */
                    for (var i = this.maxItemsPerColumn; i < this.children.length - thirdColumnCount; i++) {
                        this.containerNode2.appendChild(this.children[i].domNode);
                    }

                    /* Add elements to the third column if overflowing the second column. */
                    for (var i = 2 * this.maxItemsPerColumn; i < this.children.length; i++) {
                        this.containerNode3.appendChild(this.children[i].domNode);
                    }

                    /* Remove elements from the table if overflowing the third column. */
                    for (var i = 3 * this.maxItemsPerColumn; i < this.children.length; i++) {
                        this.containerNode3.removeChild(this.children[i].domNode);
                    }
                }

                var numcolumns = (this.children.length > 2 * this.maxItemsPerColumn) ? 3 : (this.children.length > this.maxItemsPerColumn ? 2 : 1);

                /* If there is only one column then hide the second column and reformat the first column to look appropriate. */
                if (numcolumns == 1) {
                    this.containerNode2Div.style.padding = "0px";
                    this.containerNodeDiv.style.border = "0px";
                    if (dojo.isMozilla) {
                        if (this.bidi) {
                            this.containerNodeDiv.style.padding = "0px 4px 3px 3px";
                        }
                        else {
                            this.containerNodeDiv.style.padding = "0px 3px 3px 4px";
                        }
                    }
                    else {
                        if (this.bidi) {
                            this.containerNodeTable.style.margin = "0px 0px 0px 0px";
                            this.containerNodeDiv.style.padding = "0px 4px 3px 2px";
                        }
                        else {
                            this.containerNodeTable.style.margin = "0px 0px 0px 0px";
                            this.containerNodeDiv.style.padding = "0px 2px 3px 4px";
                        }
                    }
                }

                /* If there is less then three columns then hide the third column. */
                if (numcolumns < 3) {
                    this.containerNode3Div.style.padding = "0px";
                    this.containerNode2Div.style.border = "0px";
                    if (this.bidi) {
                        if (dojo.isMozilla) {
                            this.containerNodeDiv.style.padding = "0px 4px 3px 4px";
                        }
                        else {
                            this.containerNode2Div.style.padding = "0px 4px 3px 3px";
                        }
                    }
                }

                /* If there are three columns then set the padding for the third column */


                /* Remove the border from the last column */
                this.containerNode3Div.style.border = "0px";

                /* Add the Show All node to the correct place in the table. */
                this.showAllContainer.appendChild(this.showAllNode.domNode);

                /* Set the show all text label */
                var newLabel = '<span><a href="' + this.showAllURL + '" dojoAttachPoint="menuItemLabel">' + this.showAllText + '</a></span >';

                this.showAllNode.attr("label", newLabel);


                /* Determine whether or not to show the show all link. */
                if (this.forceDisplayShowAll == false && this.children.length <= 3 * this.maxItemsPerColumn) {
                    this.hideShowAllItem();
                }
            }


        },

        /**
         *  This function is called when a menu item needs to be focused.
         */
        focus: function() {

            /*
             In the event that the text in the header of the menu (or the show all node) is wider then the sum of the
             widths of the columns of the menu then the difference in the widths will be divided
             amongst the columns thereby enlarging their widths to fill the remaining space so that the menu
             is at least as wide as the wider of the header or the show all node.
             */


            this.inherited('focus', arguments);
            //this.clearFocus();

            //this.focusedChild = null;


            if (this["columnsAdjusted"] == undefined || this["columnsAdjusted"] == false) {
                this.columnsAdjusted = true;

                var nodeWidth = dojo.style(this.mainNode, "width");
                var column1Width = dojo.style(this.containerNodeDiv, "width");
                var column2Width = dojo.style(this.containerNode2Div, "width");
                var column3Width = dojo.style(this.containerNode3Div, "width");
                var columnWidthSum = column1Width + column2Width + column3Width;
                var numcolumns = (this.children.length > 2 * this.maxItemsPerColumn) ? 3 : (this.children.length > this.maxItemsPerColumn ? 2 : 1);


                if ((nodeWidth - (9 * numcolumns)) > columnWidthSum) {

                    var column1Padding = dojo.style(this.containerNodeDiv, "paddingRight");
                    var column2Padding = dojo.style(this.containerNode2Div, "paddingRight");
                    var column3Padding = dojo.style(this.containerNode3Div, "paddingRight");

                    var diff = ((nodeWidth - 7) - columnWidthSum) / numcolumns;

                    dojo.style(this.containerNodeDiv, "width", (column1Width + diff) + "px");
                    if (numcolumns > 1) dojo.style(this.containerNode2Div, "width", ((column2Width + diff) - column1Padding - column2Padding - 3) + "px");
                    if (numcolumns > 2) {
                        if (!this.bidi) {
                            this.containerNode3Div.style.padding = "0px 0px 2px 4px";
                        }
                        else {
                            this.containerNode3Div.style.padding = "0px 4px 2px 0px";
                        }

                        if (! dojo.isMozilla) {
                            dojo.style(this.containerNode3Div, "width", ((column3Width + diff) - column1Padding - column2Padding + 2) + "px");
                        }
                        else {
                            dojo.style(this.containerNode3Div, "width", ((column3Width + diff) - column1Padding - column2Padding) + "px");
                        }

                    }

                }
            }


        },



        /**
         *  This function specifies the action to perform when 'Show All' link is clicked.
         */
        showAll: function() {
            loadLink(this.showAllURL);
        },


        /**
         * This function hides the 'Show All' menu item.
         */
        hideShowAllItem: function() {

            this.showAllContainer.removeChild(this.showAllNode.domNode);
            this.showAllMainNode.style.padding = "0px";
            this.showAllMainNode.style.visibility = "hidden";
            this.mainNode.style.padding = "3px 0px 0px 0px";
        },

        /**
         * This function will retrieve the value of a computed style property from a computed style object.
         * @param {object} The object in which to retrieve the style from.
         * @param {string} styleItem The style property to retrieve.
         * @param {string} splitchar A character to be removed from the result such as "px" or "em".
         *
         * @returns: Either 0 or a value representing the style object's desired property.
         */
        getComputedStyle: function(object, styleItem, splitchar) {

            var styleObject = dojo.getComputedStyle(object)[styleItem];

            var styleResult = styleObject.split(splitchar)[0];

            if (styleResult == undefined || styleResult.length == 0) {
                return 0;
            }
            return styleResult;
        },

        /**
         *  This function checks to see if the 'Show All' menu item is hidden or not.
         */
        showAllHidden: function() {
            if (this.showAllMainNode.style.visibility == "hidden") {
                return true;
            }
            else {
                return false;
            }
        },

        /**
         *  This function changes the currently focused menu item.
         *  @param {string} currentNode A pointer to the currently focused child of the menu.
         *  @param {string} newNode A pointer to the new menu item to put into focus.
         *
         *  @return true if the method completed successfully.
         */
        changeFocus: function(newNode, e) {
            dojo.stopEvent(e);
            this.focusedChild._setSelected(false);
            newNode._setSelected(true);
            newNode.focus();
            this.focusedChild = newNode;
        },


        /**
         *  This is a callback function when a key is pressed while a menu item is in focus.
         *  @param {string} e The key press event
         */
        _onKeyPress: function(e) {

            if (this.children.length > 0) {
                var currentFocusIndex = dojo.indexOf(this.children, this.focusedChild);
                var lastIndex = (this.children.length <= (3 * this.maxItemsPerColumn)) ? this.children.length - 1 : (3 * this.maxItemsPerColumn) - 1;

                if (e.keyCode == dojo.keys.DOWN_ARROW) {

                    if ((currentFocusIndex == this.maxItemsPerColumn - 1) || (currentFocusIndex == (2 * this.maxItemsPerColumn) - 1) || (this.focusedChild == this.showAllNode) || (currentFocusIndex == lastIndex)) {

                        //If at the show all link
                        if (this.focusedChild == this.showAllNode) {
                            this.changeFocus(this.children[this.maxItemsPerColumn], e);
                        }

                        //If at the end of the first column
                        if (currentFocusIndex == this.maxItemsPerColumn - 1) {
                            if (!this.showAllHidden()) {
                                this.changeFocus(this.showAllNode, e);
                            }
                            else {
                                this.changeFocus(this.children[currentFocusIndex + 1], e);
                            }

                        }


                        //If at the end of the second column
                        if (currentFocusIndex == (2 * this.maxItemsPerColumn) - 1) {
                            this.changeFocus(this.children[currentFocusIndex + 1], e);
                        }


                        //If at the end of the list
                        if (currentFocusIndex == lastIndex) {
                            this.changeFocus(this.children[0], e);
                        }
                    }

                }

                if (e.keyCode == dojo.keys.UP_ARROW) {
                    if ((currentFocusIndex == this.maxItemsPerColumn) || (currentFocusIndex == (2 * this.maxItemsPerColumn)) || (this.focusedChild == this.showAllNode) || (currentFocusIndex == 0)) {
                        //If at the show all link
                        if (this.focusedChild == this.showAllNode) {
                            this.changeFocus(this.children[this.maxItemsPerColumn - 1], e);
                        }

                        //If at the top of the second column
                        if (currentFocusIndex == this.maxItemsPerColumn) {
                            if (!this.showAllHidden()) {
                                this.changeFocus(this.showAllNode, e);
                            }
                            else {
                                this.changeFocus(this.children[this.maxItemsPerColumn - 1], e);
                            }

                        }

                        //If at the top of the third column
                        if (currentFocusIndex == 2 * this.maxItemsPerColumn) {
                            this.changeFocus(this.children[currentFocusIndex - 1], e);
                        }

                        //If at the top of the third column
                        if (currentFocusIndex == (2 * this.maxItemsPerColumn)) {
                            this.changeFocus(this.children[currentFocusIndex - 1], e);
                        }

                        if (currentFocusIndex == 0) {
                            this.changeFocus(this.children[lastIndex], e);
                        }


                    }

                }

                if (e.keyCode == dojo.keys.RIGHT_ARROW) {

                    if (this.bidi) {
                        this.moveToNextColumn(e);
                    }
                    else {
                        this.moveToPreviousColumn(e);
                    }
                }

                if (e.keyCode == dojo.keys.LEFT_ARROW) {
                    if (this.bidi) {
                        this.moveToPreviousColumn(e);
                    }
                    else {
                        this.moveToNextColumn(e);
                    }
                }

            }
        },

        /**
         *  This function changes the focus to the menu item in the same row but the previous column if available,
         *  or else wraps around to the last available column in the same row.
         *  @param {string} e The key press event.
         */
        moveToPreviousColumn: function(e) {

            var focusIndex = -1;

            if (this.focusedChild != this.showAllNode) {
                /* Find the index of the currently focused node in the array.  */
                for (var i = 0; i < this.children.length; i++) {
                    if (this.focusedChild == this.children[i]) {
                        focusIndex = i;
                        break;
                    }
                }

                var toManyToFit = false;
                if (this.children.length > 3 * this.maxItemsPerColumn) {
                    toManyToFit = true;
                }

                if ((this.children.length - 1 >= focusIndex + this.maxItemsPerColumn) && !toManyToFit || (toManyToFit && (3 * this.maxItemsPerColumn > focusIndex + this.maxItemsPerColumn))) {

                    this.changeFocus(this.children[focusIndex + this.maxItemsPerColumn], e);
                }
                else {

                    this.changeFocus(this.children[focusIndex % this.maxItemsPerColumn], e);
                }
            }
        },

        /**
         *  This function changes the focus to the menu item in the same row but the next column if available,
         *  or else wraps around to the first available column in the same row.
         *  @param {string} e The key press event.
         */
        moveToNextColumn: function(e) {

            var focusIndex = -1;
            if (this.focusedChild != this.showAllNode) {
                /* Find the index of the currently focused node in the array. */
                for (var i = 0; i < this.children.length; i++) {
                    if (this.focusedChild == this.children[i]) {
                        focusIndex = i;
                        break;
                    }
                }

                if (focusIndex - this.maxItemsPerColumn >= 0) {
                    this.changeFocus(this.children[focusIndex - this.maxItemsPerColumn], e);
                }
                else {
                    var row = focusIndex % this.maxItemsPerColumn + 1;

                    var toManyToFit = false;
                    if (this.children.length > 3 * this.maxItemsPerColumn) {
                        toManyToFit = true;
                    }

                    var rem = (!toManyToFit) ? (this.children.length % this.maxItemsPerColumn) : (0);
                    var lastIndex = 0;
                    var newIndex = 0;

                    var toManyToFit = false;
                    if (this.children.length > 3 * this.maxItemsPerColumn) {
                        toManyToFit = true;
                    }

                    if (row <= rem && rem > 0) {
                        newIndex = (!toManyToFit) ? (this.children.length - 1 - (rem - row)) : (3 * this.maxItemsPerColumn - this.maxItemsPerColumn - (rem - row));
                    }
                    else {
                        newIndex = (!toManyToFit) ? this.children.length - 1 - rem - (this.maxItemsPerColumn - row) : ((3 * this.maxItemsPerColumn - (3 * this.maxItemsPerColumn % this.maxItemsPerColumn) - 1 - (this.maxItemsPerColumn - row)));
                    }

                    this.changeFocus(this.children[newIndex], e);
                }
            }
        }
    }
);