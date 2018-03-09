/*
 *-----------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2009 All Rights Reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with
 * IBM Corp.
 *-----------------------------------------------------------------
 */

/* Import dojo classes. */
dojo.provide("wc.widget.WCStackContainer");
dojo.provide("wc.widget.WCStackController");

dojo.require("dijit._Widget");
dojo.require("dijit._Container");
dojo.require("dijit._Templated");
dojo.require("dijit.layout._LayoutWidget");
dojo.require("dijit.form.Button");
dojo.require("dijit.layout.StackContainer");


dojo.declare(
    "wc.widget.WCStackContainer", dijit.layout.StackContainer,
    {
        isShowChild: false,

        wipeIn: "",
        wipeOut: "",

        fadeInDuration: 500,
        fadeOutDuration: 500,

        postCreate: function() {
            this.inherited("postCreate", arguments);
            //init the fade animation
            if (this.isShowChild == false) {
                this.isShowChild = true;
                this.hide();
            }
        },

        selectChild: function(/*dijit._Widget*/ page) {
            if (this.isShowChild == false) {
                this.isShowChild = true;

                dojo.style(this.domNode, "display", "block");
                dojo.style(this.domNode, "height", "120px");
                var fadeIn = dojo.fadeIn({node: this.domNode.id  ,duration: this.fadeInDuration});
                fadeIn.play();

                dojo.publish("StackPop", ["120px"]);
            }
            this.inherited("selectChild", arguments);
        },

        hide: function() {
            if (this.isShowChild == true) {
                this.isShowChild = false;

                var fadeOut = dojo.fadeOut({node:  this.domNode.id ,duration: this.fadeOutDuration});
                fadeOut.play();

                dojo.style(this.domNode, "display", "none");
                dojo.style(this.domNode, "height", "1px");
                dojo.publish("StackBack", ["120px"]);
            }
        },

        // TODO: Need accessability function

        _hideChild: function(/*dijit._Widget*/ page) {
            page.selected = false;
            var fadeOut = dojo.fadeOut({node: page.id ,duration: this.fadeOutDuration});
            fadeOut.play();

            page.domNode.style.display = "none";

            if (page.onHide) {
                page.onHide();
            }

        },

        _showChild: function(/*dijit._Widget*/ page) {
            var children = this.getChildren();
            page.isFirstChild = (page == children[0]);
            page.isLastChild = (page == children[children.length - 1]);
            page.selected = true;

            page.domNode.style.display = "";
            var fadeIn = dojo.fadeIn({node: page.id ,duration: this.fadeInDuration});
            fadeIn.play();

            if (page._loadCheck) {
                page._loadCheck(); // trigger load in ContentPane
            }
            if (page.onShow) {
                page.onShow();
            }
        }
    });

dojo.declare(
    "wc.widget.WCStackController", dijit.layout.StackController, {
        // summary:
        // 	Set of tabs (the things with titles and a close button, that you click to show a tab panel).
        // description:
        //	Lets the user select the currently shown pane in a TabContainer or StackContainer.
        //	TabController also monitors the TabContainer, and whenever a pane is
        //	added or deleted updates itself accordingly.

        templateString: "<div wairole='tablist' dojoAttachEvent='onkeypress:onkeypress'></div>",

        // tabPosition: String
        //   Defines where tabs go relative to the content.
        //   "top", "bottom", "left-h", "right-h"
        tabPosition: "top",

        // doLayout: Boolean
        // 	TODOC: deprecate doLayout? not sure.
        doLayout: true,

        // buttonWidget: String
        //	the name of the tab widget to create to correspond to each page
        buttonWidget: "wc.layout._TabButton",

        postMixInProperties: function() {
            this["class"] = "dijitTabLabels-" + this.tabPosition + (this.doLayout ? "" : " dijitTabNoLayout");
            this.inherited("postMixInProperties", arguments);
        },

        postCreated: function() {
            this.inherited("postCreated", arguments);
        }
    });

dojo.declare("wc.layout._TabButton",
    dijit.layout._StackButton,
    {
        // summary:
        //	A tab (the thing you click to select a pane).
        // description:
        //	Contains the title of the pane, and optionally a close-button to destroy the pane.
        //	This is an internal widget and should not be instantiated directly.

        baseClass: "dijitTab",

        templateString:"<div dojoAttachEvent=\"onclick:onClick,onmouseenter:_onMouse,onmouseleave:_onMouse,onmouseenter:_onMouseEnter\"\n\t>" +
            "<div class=\"dijitStretch dijitButtonNode dijitButtonContents\" type=\"${type}\"\n\t\tdojoAttachPoint=\"focusNode,titleNode\" waiRole=\"button\" waiState=\"haspopup-true,labelledby-${id}_label\"\n\t\t>" +
            "<div class=\"dijitInline ${iconClass}\" dojoAttachPoint=\"iconNode\"\n\t>" +
            "<span class=\"dijitButtonText\" \tdojoAttachPoint=\"containerNode,popupStateNode\"\n\t\tid=\"${id}_label\">${label}</span\n\t\t>" +
            "</div>\n" +
            "</div>\n" +
            "</div>\n",

        tabSwitchTimer: null,

        postCreate: function() {
            var indexNumber;
            var indexOfIdentifier = this.id.lastIndexOf("_");
            if (indexOfIdentifier >= 0) {
                indexNumber = this.id.substring(indexOfIdentifier + 1);
            }
            this.baseClass = "dijitTab" + indexNumber;

            this.inherited("postCreate", arguments);
            dojo.setSelectable(this.containerNode, false);
        },

        _onMouseEnter: function(e) {
            //console.info("Event:"+ e);
            this.tabSwitchTimer = setTimeout(this.onClick, 300);
        },

        _onMouse:  function(e) {
            this.inherited("_onMouse", arguments);
            clearTimeout(this.tabSwitchTimer);
        }

    });
