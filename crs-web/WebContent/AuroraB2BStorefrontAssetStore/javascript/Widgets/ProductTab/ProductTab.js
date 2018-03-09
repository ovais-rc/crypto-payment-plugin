//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

if (typeof (ProductTabJS) == "undefined" || ProductTabJS == null || !ProductTabJS) {

    ProductTabJS = {
        lastTabId: null,
        /**
         * To make the tab selected and remove all other tabs from the tab order
         * See http://www.w3.org/TR/wai-aria-practices/#tabpanel for ARIA best practices
         * 
         * @param {String} tabId The ID of the tab to be selected
         */
        selectTab: function (tabId) {
            $("div.tab_container").each(function (i, tab) {
                $(tab).attr("aria-selected", "false")
                      .attr("class", "tab_container inactive_tab")
                      .attr("tabindex", "-1");
            });
            $("div.tab").each(function (i, tabPanel) {
                $(tabPanel).css("display", "none");
            });

            $("#" + tabId).attr("aria-selected", "true")
                          .attr("tabindex", "0")
                          .attr("class", "tab_container active_tab");
            $("#" + tabId + "Widget").css("display", "block");
            $("#" + tabId + "Widget").each(function (i, widget) {
                if (widget.resize) {
                    widget.resize();
                }
            });

            if (this.lastTabId == null || this.lastTabId != tabId) {
                this.lastTabId = tabId;
            }
        },

        /**
         * To select the previous or next tab with the keyboard arrow keys.  If there are no more tabs to the
         * left or right, wrap to the other end of the tab list.  
         * See http://www.w3.org/TR/wai-aria-practices/#tabpanel for ARIA best practices
         * 
         * @param {int} tabIndex The index of the tab to be selected
         * @param {int} tabSetSize The number of total tabs in the tablist
         * @param {event} event
         */
        selectTabWithKeyboard: function (tabIndex, tabSetSize, event) {
            if (event.keyCode == keys.DOWN_ARROW || event.keyCode == keys.RIGHT_ARROW) {
                tabIndex++;
                if ($("#tab" + tabIndex)) {
                    this.selectTab("tab" + tabIndex);
                    this.focusTab("tab" + tabIndex);
                } else {
                    this.selectTab("tab1");
                    this.focusTab("tab1");
                }
                this.cancelEvent(event);
            }

            if (event.keyCode == keys.UP_ARROW || event.keyCode == keys.LEFT_ARROW) {
                if ($("#tab" + (tabIndex - 1))) {
                    this.selectTab("tab" + (tabIndex - 1));
                    this.focusTab("tab" + (tabIndex - 1));
                } else {
                    this.selectTab("tab" + tabSetSize);
                    this.focusTab("tab" + tabSetSize);
                }
                this.cancelEvent(event);
            }
        },

        /**
         * Stop event propagation
         * 
         * @param {event} e
         */
        cancelEvent: function (e) {
            Utils.stopEvent(e);
        },

        /**
         * To bring the focus to the tab
         * 
         * @param {String} tabId The ID of the tab to be selected
         */
        focusTab: function (tabId) {
            if ($("#" + tabId).hasClass("focused_tab")) {
                $("> div", "#" + tabId).css("border", "1px dotted #000000");
                return;
            } else {
                $("#" + tabId).addClass("focused_tab");
                $("> div", $("#" + tabId)).css("border", "1px dotted #000000");
                $("#" + tabId).focus();
            }
        },

        /**
         * To take the focus out from the tab
         * 
         * @param {String} tabId The ID of the tab to be selected
         */
        blurTab: function (tabId) {
            $(tabId).removeClass("focused_tab");
            $("> div", "#" + tabId).css("border", "1px solid transparent");
        }
    };
}
