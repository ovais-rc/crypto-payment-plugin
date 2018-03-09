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

/*global jQuery, Utils, window, document */

/* 
 * WCGrid (extends $.ui.dialog) 
 *
 */
(function ($) {

    /*
     * New options (in addition to ones inherited from $.Widget):
     * columnCount: the number of columns (can be empty if rowCount is specified)
     * rowCount: the number of rows (can be empty if columnCount is specified)
     * elementSelector: the elements in the grid
     * useColumnWrapper: true if column wrappers should be used, false otherwise
     * columnWrapperClass: the CSS class to add to the column wrapper divs
     */
    $.widget("wc.Grid", $.Widget, {
        
        options: {            
            columnCount: 1,
            rowCount: null,
            elementSelector: "div.grid-element",
            useColumnWrapper: false,
            columnWrapperClass: "grid-column-wrapper"
        },
        
        /**
        * Handlers to be called when options are changed. Key corresponds to the option name, 
        * value corresponds to the handler.
        */
        optionChangedHandlers: {
            columnCount: function() {
                this._columnCountUpdated();
            },
            columnCountByWidth: function() {
                this.resize();                
            },
            elementSelector: function() {
                this.$elements = undefined;
            }
        },
        
        /**
        * The CSS class to add to the column container depending on the number of
        * columns.
        * Example: a grid with 3 columns will receive have the class "ui-grid-b" added.
        */
        columnContainerClass: {
            "1": "ui-grid-solo",
            "2": "ui-grid-a",
            "3": "ui-grid-b",
            "4": "ui-grid-c",
            "5": "ui-grid-d",
            "6": "ui-grid-e",
            "7": "ui-grid-f",
            "8": "ui-grid-g",
            "9": "ui-grid-h"
        },
        
        /** The current column container class */
        currentColumnContainerClass: null,
        
        /**
        * The CSS class to add to a column depending on it's column index. 
        * Example: the 4th column will have the class "ui-class-d" added.
        */
        columnClass: {
            "1": "ui-block-a",
            "2": "ui-block-b",
            "3": "ui-block-c",
            "4": "ui-block-d",
            "5": "ui-block-e",
            "6": "ui-block-f",
            "7": "ui-block-g",
            "8": "ui-block-h",
            "9": "ui-block-i"
        },
        
        _setOption: function (key, value) {
            this._super(key, value);
            
            if (this.optionChangedHandlers[key]) {
                this.optionChangedHandlers[key].call(this);
            }
        },

        _getColumnContainerClass: function(columnCount) {
            var val = this.columnContainerClass[String(columnCount)];
            if (val) {
                return val;
            }
            throw "Unsupported, too many columns: " + columnCount;
        },
        
        _columnCountUpdated: function() {
            this.$elements = this.$elements || $(this.options.elementSelector, this.element)
            var $elements = this.$elements,
                $parent = $elements.parent(),
                columnCount = this.options.columnCount,
                rowCount = this.options.rowCount;
            
            if (columnCount) {
                if (columnCount === 0) {
                    throw "Column count must be greater than 0!"
                    
                } else if (rowCount) {
                    // Make sure the number of elements in this grid can fit into a grid 
                    // defined by columnCount and rowCount
                     if (rowCount === 0) {
                        throw "rowCount must be greater than 0!";
                     } else if ($elements.length > columnCount * rowCount) {
                        throw "The number of elements (" + $elements.length + ") cannot fit into a " + columnCount + " by " + rowCount + " grid";
                     } 
                } else {
                    // Only column count defined, calculate row count
                    rowCount = Math.ceil($elements.length / columnCount);
                }
            } else if (rowCount) {
                if (rowCount === 0) {
                    throw "rowCount must be greater than 0!";
                    
                } else {
                    // Only row count defined, calculate column count
                    columnCount = Math.ceil($elements.length / rowCount);
                }
            } else {
                // Should not get here since default value provided for at least
                // one of columnCount or rowCount, but might reach here if user
                // accidentially sets both columnCount and rowCount to a falsy value
                throw "Row count and column count not defined!";
            }

            if (this.options.useColumnWrapper && $parent.hasClass(this.options.columnWrapperClass)) {
                // Unwrap previous column wrappers if any
                $elements.unwrap();
                $parent = $elements.parent();                
            }
            if (this.currentColumnContainerClass) {
                $parent.removeClass(this.currentColumnContainerClass);
            }
            this.currentColumnContainerClass = this._getColumnContainerClass(columnCount);
            $parent.addClass(this.currentColumnContainerClass);
        
            var rows = arrayUtils.arrTo2D($.makeArray($elements), columnCount),
                c;
            for (c = 0; c < columnCount; c++) {
                var $cols = $(rows.filter(function(a_row) {
                                return a_row.length > c;
                            }).map(function(a_row) {
                                return a_row[c];
                            }));
                if (this.options.useColumnWrapper) {
                    $cols = $cols.detach();              
                    $wrapper = $("<div class=\"" + this.options.columnWrapperClass + " " + this.columnClass[c + 1] + "\"></div>");
                    $parent.append($wrapper);
                    $wrapper.append($cols);
                } else {
                    $cols.removeClass(this.allColumnClass)
                         .addClass(this.columnClass[c + 1]);
                }                
            }
        },
        
        _validateElements: function() {
            if (!Utils.areSiblings($(this.options.elementSelector, this.element), $([]))) {
                throw "Grid elements must all be under the same parent";
            }
        },
        
        _create: function () {
            this._super(this);
            
            /**
             * Grab all the CSS class as a space separated string. Passed to $.removeClass to help remove all
             * column class from an element. 
             */
            this.allColumnClass = $.map(this.columnClass, function(val, key) {return val;}).join(" ");

            this._validateElements();
            this.option("columnCount", this._calculateColumnBasedOnClientWidth());
                                    
            $(window).resize($.proxy(function () {
                this.resize();
            }, this));
        },

        /**
         * Calculates the number of columns based on the columnCountByWidth option and client width
         * (if no such option is provided, returns 1). E.g. if client width is: 1000 px and columnCountByWidth
         * is: {"300": 2, "500": 3: "800": 4} then this will return 4 since the screen width is
         * greater than 800.  
         */
        _calculateColumnBasedOnClientWidth: function() {
            var columnCount = 1,
                clientWidth = this.element.get(0).clientWidth;
            
            if (this.options.columnCountByWidth) {
                Utils.iterate_obj_in_order(this.options.columnCountByWidth, function(a, b) {
                    return parseInt(b) - parseInt(a);
                },
                function(width, colWidth) {
                    if (clientWidth >= parseInt(width)) {
						columnCount = colWidth;
                        return true; // breaks out of the loop
					}
                });
            }
            return columnCount;
        },
        
        /**
         * Recalculates the column width on window resize and rearrange the elements 
         * accordingly.
         */
        resize: function () {
            var columnCount = this._calculateColumnBasedOnClientWidth();
            if (columnCount !== this.options.columnCount) {
                this.option("columnCount", columnCount);
            }
        }

    });

}(jQuery));