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
 * Carousel (extends $.Widget)
 * Wraps around a third party plugin - Owl Carousel. Owl Carousel is just a jQuery plugin
 * so it's not written as a jQuery UI Widget, otherwise we would extend the Owl Carousel Widget.
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.Widget):
     *
     * OPTIONAL:
     * prevButton: {string}
     *             jQuery selector for the previous button, can have falsy
     *             value if there is no previous button.
     * nextButton: {string}
     *             jQuery selector for the next button, can have falsy value
     *             if there is no previous button.
     * paginationButtons: {string}
     *             jQuery selector for the previous button, can have falsy
     *             value if there are no pagination buttons.
     * overflowVisible: {boolean}
     *             true if content that overflows the container should be shown,
     *             false otherwise.
     * REQUIRED:
     * (None)
     */
    $.widget("wc.Carousel", $.Widget, {
        options: {
            prevButton: null,
            nextButton: null,
            paginationButtons: null,
            contentContainer: "div.content",
            overflowVisible: false,
            owlCarouselOptions: {
                autoHeight: false,
                autoWidth: true,
                pagination: false, // We're generating our own pagination control
                slideSpeed: 2000,
                //touchDrag: false, // Need to disable touch drag if we want this to work
                // with gridster
                //mouseDrag: false,
                afterMove: function (elem) {
                    if (this.options.paginationButtons) {
                        this.paginationButtons.removeClass("selected")
                        // Highlight the selected element after pagination move
                        .eq(this.owlCarousel.currentItem).attr("class", "selected");
                    }
                },
                afterUpdate: function() {
                    // Only hide/show next/prev buttons after update has finished
                    this._togglePrevNextButtons();
                }
            }
        },

        /**
        * Attach "this" to a function passed to the owlCarousel option
        */
        _proxyFunction: function(optionName) {
            if ($.isFunction(this.options.owlCarouselOptions[optionName])) {
                this.options.owlCarouselOptions[optionName] = $.proxy(this.options.owlCarouselOptions[optionName], this);
            }
        },

        _create: function () {
            this._super(this);

            // Stores a handle to the underlying Owl Carousel
            this.content = $(this.options.contentContainer, this.element);
            this._proxyFunction("afterMove");
            this._proxyFunction("afterUpdate");

            if (this.options.columnCountByWidth) {
                var columnCountByWidth = this.options.columnCountByWidth;
                if (Utils.isObject(columnCountByWidth)) {
                    var windowWidth = $(window).width(),
                        // Grab all the screen sizes and sort them
                        screenSizes = Object.keys(columnCountByWidth)
                                            .map(function(str) {
                                                return parseInt(str, 10);
                                            });
                    screenSizes.sort(function(a, b) { return a - b });
                    screenSizes = screenSizes.map(function(size) {
                        return [size, columnCountByWidth[size.toString()]];
                    });
                    this.options.owlCarouselOptions.itemsCustom = screenSizes;
                } else {
                    console.error("columnCountByWidth is not an object: " + this.options.columnCountByWidth);
                }
            }

            this.owlCarousel = this.content.owlCarousel(this.options.owlCarouselOptions).data('owlCarousel');
		    //RTC DEFECT#153115 the carousel disableTextSelect event handling result in invocation of event.stopPropagation()
			if ((this.owlCarousel.options.mouseDrag !== false || this.owlCarourel.options.touchDrag !== false)
				&& this.owlCarousel.disabledEvents && typeof this.owlCarousel.disabledEvents === "function")
			{
				this.owlCarousel.$elem.off("mousedown.disableTextSelect");
				this.owlCarousel.$elem.on("mousedown.disableTextSelect", function (e) {
					if (!$(e.target).is('input, textarea, select, option')){
						e.preventDefault();
					};
				});
			}

            if (this.options.overflowVisible) {
                $(".owl-wrapper-outer", this.element).addClass("overflow-visible");
            }

            $(window).resize($.proxy(function() {
                this.owlCarousel.reload();
                this._togglePrevNextButtons();
            }, this));



//            $(window).resize($.proxy(function () {
//                // Reposition the dialog after window resize, otherwise
//                // the dialog will stay in the same position
//                this.reposition();
//            }, this));

            this._add_event_handlers();
            this._togglePrevNextButtons();
        },

        /**
        * Show/hide custom pagination buttons depending on the number of items
        * being shown
        */
        _togglePrevNextButtons: function() {
            // Require pagination if the total number of items is greater than
            // the number of items being shown
            var requirePagination = (this.owlCarousel.itemsAmount > this.owlCarousel.options.items);

            if (requirePagination) {
                if (this.options.nextButton) {
                    this.$nextButton.show();
                }
                if (this.options.prevButton) {
                    this.$prevButton.show();
                }
            } else {
                if (this.options.nextButton) {
                    this.$nextButton.hide();
                }
                if (this.options.prevButton) {
                    this.$prevButton.hide();
                }
            }
        },

        _add_event_handlers: function () {
            var carousel = this.owlCarousel;

            this.element.on("resized.owl.carousel", function() {
                console.log("resized");
            });
            // Pagination Controls
            // Previous button
            if (this.options.prevButton) {
                this.$prevButton = $(this.options.prevButton, this.element);
                this.$prevButton.click(function (e) {
                    carousel.prev();
                    e.preventDefault();
                });
            }

            // Next button
            if (this.options.nextButton) {
                this.$nextButton = $(this.options.nextButton, this.element);
                this.$nextButton.click(function (e) {
                    carousel.next();
                    e.preventDefault();
                });
            }

            // Pagination buttons (either dots or numbers)
            // Highlight the first element on startup
            if (this.options.paginationButtons) {
                this.paginationButtons = $(this.options.paginationButtons, this.element);
                this.paginationButtons.first().attr("class", "selected");
                this.paginationButtons.each(function(i, button) {
                    $(button).click(function(e) {
                        carousel.goTo(i);
                        e.preventDefault();
                    });
                });
            }
        },

        _destroy: function () {
            this.owlCarousel.destroy();

            // remove the event handlers
            //this.element.off("mouseenter.wcToolTip");
            //this.element.off("mouseleave.wcToolTip");
        }

    });

}());