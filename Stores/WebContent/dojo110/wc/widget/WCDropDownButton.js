//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2008, 2013
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/**
 * @fileOverview This javascript is used by CachedHeaderDisplay.jsp to display a top-level category which has subcategories associated with it.
 * @version 1.0
 */
dojo.provide("wc.widget.WCDropDownButton");
/* Import dojo classes */
dojo.require("dijit.form.Button");
dojo.require("dijit.form.DropDownButton");

/**
 *  The functions defined in this class enables initialisation of event listeners for WCDropDownButton. Another set of functions act as callback when a key press or mouse click event occurs.
 *  @class This class extends the dijit.form.DropDownButton to add the following functionality:
 *  -When hovering over the button, the drop down menu is displayed.
 *  -When clicking on the button, the page is replaced and the page corresponding to the URL specified in the 'url' property is loaded.
 */

dojo.declare("wc.widget.WCDropDownButton", dijit.form.DropDownButton, {
        /* The fully resolved URL to be loaded when the menu button is clicked. */
        url: '',
        /* This is the template string for the widget. */
        templateString:"<div class=\"dijit dijitLeft dijitInline\"\n\tdojoAttachEvent=\"onmouseenter:onMouseEnter,onmouseleave:onMouseLeave,onmousedown:onMouseDown,onclick:_onDropDownClick,onkeydown:_onKey,onblur:_onBlur,onkeypress:_onKey\"\n\t><div class='dijitRight'>\n\t<div class=\"dijitStretch dijitButtonNode dijitButtonContents\" type=\"${type}\"\n\t\tdojoAttachPoint=\"focusNode,titleNode\" waiRole=\"button\" waiState=\"haspopup-true,labelledby-${id}_label\"\n\t\t><div class=\"dijitInline ${iconClass}\" dojoAttachPoint=\"iconNode\"></div\n\t\t><span class=\"dijitButtonText\" \tdojoAttachPoint=\"containerNode,popupStateNode\"\n\t\tid=\"${id}_label\">${label}</span\n\t\t><span class='dijitA11yDownArrow'>&#9660;</span>\n\t</div>\n</div></div>\n",

        /**
         * This function initialises the event listeners and style classes for WCDropDownButton.
         */
        postCreate: function() {
            this.titleNode.title = this.title;
            this.inherited("postCreate", arguments);
            dojo.connect(this.domNode, "onmouseenter", this, "toggleDropDown");
            dojo.connect(this.domNode, "onfocus", this, "_onKey");
        },
        /**
         *  This is a callback function when the user presses a key on menu popup node.
         *  @param {string} e The key press event.
         */
        _onKey: function(e) {
            this.inherited("_onKey", arguments);
            if (!e.shiftKey) {
                if (e.keyCode == dojo.keys.ENTER) {
                    if (this.url) {
                        dojo.stopEvent(e);
                        document.location.href = this.url;
                    }
                }
            }

            if (e.shiftKey) {
                if (e.keyCode == dojo.keys.ENTER) {
                    if (!this.dropDown || this.dropDown.domNode.style.display == "none") {
                        dojo.stopEvent(e);
                        return this._toggleDropDown();
                    }
                }
            }
        },
        /**
         *  This is a callback function when the user mouse clicks on menu popup node.
         *  @param {string} e The mouse click event.
         */
        _onDropDownClick: function(e) {
            this.inherited("_onDropDownClick", arguments);
            if (this.url) {
                dojo.stopEvent(e);
                document.location.href = this.url;
            }

        },


        /**
         * return the URL of this widget.
         */
        getURL: function() {
            return this.url;
        }

    }
);