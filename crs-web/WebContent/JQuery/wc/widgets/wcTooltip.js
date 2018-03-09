//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

(function ($) {
    $.widget("custom.wcToolTip", {

        options: {
            /* 
            * The key the user can press to open the tooltip if the element the tooltip
            * is anchored on is in focus. Disable this feature by setting the value to null.
            */
            accessibilityKey: null            
        },
        
        _create: function () {
            var self = this;
            this.element.on("mouseenter.wcToolTip", function() {
                self.show_popup();
            });
            this.element.on("mouseleave.wcToolTip", function() {
                self.hide_popup();
            });
            if (this.options.accessibilityKey !== null) {
                this.element.on("keydown.wcToolTip", function(event) {
                    if (event.keyCode === self.options.accessibilityKey) {
                        self.show_popup();    
                    }
                });                    
            }
        },
        show_popup: function () {
            if (this.tooltip) {
                this.tooltip.show();

            } else {
                var header = $(this.element).data("tooltip-header"),
                    content = $(this.element).data("tooltip-content");
                if (content && header) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container'><div class='connector'></div><div class='header'>" + header + "</div><div class='content' >" + content + "</div></div></div>");

                } else if (header) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container' style='padding:8px;' ><div class='connector'></div>" + header + "</div></div>");
                    
                } else if (content) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container'><div class='connector'></div><div class='content' >" + content + "</div></div></div>");
                    
                } else {
                    // both undefined
                    this.tooltip = $("");
                }
                this.element.after(this.tooltip);
            }
            this.tooltip.position({
                my: "center top",
                at: "center bottom",
                of: this.element,
                collision: "none"
            });


        },
        hide_popup: function () {
            if (this.tooltip) {
                this.tooltip.hide();
            }
        },
        _destroy: function () {
            if (this.tooltip) {
                this.tooltip.hide();
                this.tooltip.remove(); // remove from DOM
            }            
            // remove the event handlers
            this.element.off("mouseenter.wcToolTip");  
            this.element.off("mouseleave.wcToolTip");  
        }
    });
}(jQuery));
