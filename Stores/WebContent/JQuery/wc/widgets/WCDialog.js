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

/*global jQuery, $, window, setTimeout, clearTimeout, Utils */

/*
 * WCDialog (extends $.ui.dialog)
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.ui.dialog):
     *
     * OPTIONAL:
     * show_title: {boolean}
     *             true if the title should be shown, false otherwise
     * close_button_selector: {string} {default: "a.closeButton"}
     *                        jQuery selector for the close button,
     *                        can have falsy value if there is no
     *                        close button.
     * primary_button_selector: {string}
     *                     jQuery selector for the ok button, can have falsy
     *                     value if there is no ok button.
     * close_on_primary_click: {boolean} {default: true}
     *                     true if the dialog should be closed when the primary 
     *                     button is clicked, false otherwise.
     * secondary_button_selector: {string}
     *                     jQuery selector for the cancel button,
     *                     can have falsy value if there is no
     *                     cancel button.
     * related_source: {string}
     *                 jQuery selector of an element to position the dropdown relative to
     * title: {string}
     *        title to display
     * in_iframe: {boolean}
     *            truthy value if this dialog is in an iframe, false otherwise
     *
     * REQUIRED:
     * (None)
     */
    $.widget("wc.WCDialog", $.ui.dialog, {
        options: {
            show_title: false,

            autoOpen: false,

            /*
             * Closes the dialog after the given timeout seconds
             */
            timeout: null,
            /*
             * Auto close the dialog when the mouse leaves the
             * dialog or the relatedSource (if it is specified)
             */
            autoClose: false,

            close_button_selector: "a.closeButton",

            /**
            * Close the dialog when the primary button is clicked
            */
            close_on_primary_click: true,
            
            /**
            * The selector of an element to position the dropdown relative to
            */
            relatedSource: null,

            modal: true,

            /*
            * Required otherwise a default width of 300px will be assigned
            */
            width: "auto"
            
            
        },

        _create: function () {
            this._super(this);

            if (!this.options.show_title) {
                this.element.siblings("div.ui-dialog-titlebar").hide();
            }

            // Add the data-widget-type attribute in case the element doesn't
            // already have it. Useful for finding all WCDialog widgets
            this.element.attr("data-widget-type", "wc.WCDialog");

            $(window).resize($.proxy(function () {
                // Reposition the dialog after window resize, otherwise
                // the dialog will stay in the same position
                this.reposition();
            }, this));

            this._add_event_handlers();
        },
        
        _add_event_handlers: function () {
            // Add click handler for all close buttons within the dialog
            if (this.options.close_button_selector) {
                this.close_button = $(this.options.close_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        this.close();
                    }, this));
            }

            // Add click handler for all OK buttons within the dialog
            if (this.options.primary_button_selector) {
                this.primary_button = $(this.options.primary_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        if (this.options.close_on_primary_click) {
                            this.close();
                        }                        
                    }, this));
            }

            // Add click handler for all cancel buttons within the dialog
            if (this.options.secondary_button_selector) {
                this.secondary_button = $(this.options.secondary_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        this.close();
                    }, this));
            }

//            var obj = this.options.position;
//            obj.collision = "none";
//            this.option("position", obj);

//            this.element.on("wcdialogopen", $.proxy(function(){
//                 $('html, body').scrollTo(this.options.position.of);
//            }, this));

            if (this.options.timeout || this.options.autoClose) {
                var self = this,
                    timeoutObj,
                    clearAndDeleteTimer = function () {
                        if (timeoutObj) {
                            clearTimeout(timeoutObj);
                            timeoutObj = null;
                        }
                    },
                    startTimer = function () {
                        if (timeoutObj) {
                            // Resets the previous one if it exists
                            clearAndDeleteTimer();
                        }
                        timeoutObj = setTimeout(function () {
                            self.close();
                        }, self.options.timeout);
                    };

                if (this.option.timeout) {
                    this.element.on("wcdialogopen", startTimer);

                    this.element.on("wcdialogclose", clearAndDeleteTimer);

                    // Delete the timer when the mouse overs over the
                    // dialog, only reset it once the mouse leaves
                    this.element.on("mouseover", function (event) {
                        // Resets the timer count down if the mouse
                        // moves over the dialog
                        clearAndDeleteTimer();

                        // Start the timer again once the mouse leaves
                        self.element.on("mouseleave", startTimer);
                    });
                }

                if (this.options.autoClose) {
                    self.element.add($(self.options.relatedSource)).on("mouseleave", function (event) {
                        if (!$.contains(self.element.get(0), event.toElement) && !$.contains($(self.options.relatedSource).get(0), event.toElement)) {
                            self.close();
                        }
                    });
                }

            }

        },

        reposition: function () {
            // Find the dialog wrapper
            var wrapper = this.element.parent("div.ui-widget-content:first[role='dialog']");
            // For some reason in Store Preview mode, jQuery returns 0 when getting the
            // height of the dialog wrapper even though this.element.height() returns the correct
            // value. So we set the dialog wrapper's height manually so jQuery can retrieve it 
            // correctly.
            if (wrapper.height() === 0) {
                wrapper.height(this.element.height());
            }
            if (wrapper.width() === 0) {
                wrapper.width(this.element.width());
            }
            
            var pos = this.option("position");
            this.option("position", pos);
        },

        /** 
        * Bring this WCDialog on top of all other WCDialogs.
        *
        * @param elements <optional> a jQuery Object, HTML Node collection, or jQuery selector 
        *        representing the elements on the page that this WCDialog should be on top of.
        *        If not defined ".ui-dialog" will be used instead which will bring this WCDialog
        *        on top of all other WCDialogs.
        */
        bringToFront: function(elements) {
            // Find max z-index
            var maxZIndex = 0;
            elements = $(elements || ".ui-dialog");
            elements.each(function(i, e) {
                var zIndex = $(e).css("z-index");
                if ($.isNumeric(zIndex)) {
                    zIndex = parseInt(zIndex);
                    if (zIndex > maxZIndex) {
                        maxZIndex = zIndex;
                    }
                }
            });
            // This could overflow eventually, but very unlikely
            this.element.parent(".ui-dialog").css("z-index", parseInt(maxZIndex) + 1);
        },
        
        /*
         * Updates the content of the WCDialog with the content from
         * the given selector (note the selector will be detached
         * from it's current DOM location).
         *
         * Parameters:
         * selector - selector for the new content
         */
        update_content: function (selector) {
            var content = $(selector).detach();
            this.element.html(content.html());
            // Reset the position element after updating content
            this.reposition();
            this._add_event_handlers();
        }

    });

}());