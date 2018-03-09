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
/* global Utils, document, jQuery */

var WCWidgetParser;
(function ($) {
    WCWidgetParser = WCWidgetParser || {
        widgetDefinitions: {
            // jQuery UI Widgets
            dialog: {
                fcnName: "Dialog"
            },
            autocomplete: {
                fcnName: "autocomplete"
            },
            tabs: {
                fcnName: "tabs"
            },
            datepicker: {
                fcnName: "datepicker",
                defaultOptions: {
                    showOtherMonths: true,
                    changeYear: true,
                    dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                    altFormat: "yy-mm-dd",
                    dateFormat: "mm/dd/yy"
                }
            },
            // Custom widgets
            "wc.WCDialog": {
                fcnName: "WCDialog"
            }, 
            "wc.Carousel": {
                fcnName: "Carousel"
            },
            "wc.Grid": {
                fcnName: "Grid"
            },
            "wc.tooltip": {
                fcnName: "wcToolTip"
            },
            "wc.Select": {
                fcnName: "Select"
            },
            "wc.ValidationTextbox": {
                fcnName: "ValidationTextbox"
            }
        },

        /*
        */
        _parse_widget: function ($element, widgetName, htmlOptions) {
            var entry = this.widgetDefinitions[widgetName];
            if (!entry) {
                console.error("Widget type: " + widgetName + " not registered");
                return;
            }
            
            var fcn_name = entry.fcnName,
                default_options = entry.default_options || {};
            htmlOptions = htmlOptions || {};
            
            if (Utils.isObject(htmlOptions) || $.isArray(htmlOptions)) {
                /*
                Grab options declared in the html (if any). Merge it with the passed in 
                default_options (if any). The options declared in the html takes higher precedence
                than the given default_options. I.e.
                If these options where declared in the html:
                {
                    abc: 123,
                    efg: 456
                }
                These were the default options:
                {
                    abc: 789,
                    hij: 567
                }
                Then this would be passed to widget constructor:
                {
                    abc: 123, // from options declared in the html, which overwrites the default options
                    efg: 456, // from options declared in the html
                    hij: 567 // from the default options
                }
                */
                var options = $.extend({}, default_options, htmlOptions);
                if ($element[fcn_name]) {
                    $element[fcn_name](options);
                } else {
                    console.error("Function: " + fcn_name + " does not exist");
                }
                
                
            } else {
                $element[fcn_name](default_options);
                console.error("The given html option is neither an Object nor an array (the default options will be used instead): " + htmlOptions);
            }
        },

        /*
         * Declare widget in html like so:
         * <div data-widget-type="declare_name" />
         *
         * @param context the DOM Node to parse under, can be undefined in which case the entire page is
         *                parsed
         */
        parse: function (context) {
            // An array of Objects, each Object has the following fields:
            // element: the jQuery element to parse
            // widgetName: the name of the widget (specified by the "widget-type" data field)
            // widgetOptions: the options passed to the widget, if any (specified by the "widget-options"
            //                data field)
            var widgetsToParse = [];
            $("[data-widget-type]", context).each($.proxy(function (i, element) {
                var $element = $(element),
                    widgetName = $element.data("widget-type"),
                    widgetOptions = $element.data("widget-options");

                if ($.isArray(widgetName)) { // Multiple widgets defined
                    if (Utils.varExists(widgetOptions) && !$.isArray(widgetOptions)) {
                        console.error("widgetName is an array but widgetOptions is not: " + widgetOptions);

                    } else if (widgetName.length !== widgetOptions.length) {
                        console.error("widgetName and widgetOptions have different lengths");

                    } else {
                        widgetName.forEach(function (name, i) {
                            widgetsToParse.push({
                                element: $element,
                                widgetName: name,
                                widgetOptions: widgetOptions[i]
                            });                          
                        });
                    }

                } else {
                    widgetsToParse.push({
                        element: $element,
                        widgetName: widgetName,
                        widgetOptions: widgetOptions
                    });                    
                }
            }, this));
            
            var sortByParseOrder = function(w1, w2) {
                if (w1.widgetOptions && w1.widgetOptions.parseOrder) {
                    if (w2.widgetOptions && w2.widgetOptions.parseOrder) {
                        return w1.widgetOptions.parseOrder - w2.widgetOptions.parseOrder;
                    } else {
                        // Only w1 has parseOrder specified
                        return -1; 
                    }
                } else if (w2.widgetOptions && w2.widgetOptions.parseOrder) {
                    // Only w2 has parseOrder specified
                    return 1;
                } else {                    
                    // Neither has parseOrder defined, stable sort will leave the elements
                    // in the order they appear in the original array
                    return 0; 
                }
            },
                sortByVisibility = function(w1, w2) {
                    if (w1.element.is(":visible")) {
                        if (w2.element.is(":visible")) {
                            // Both visible
                            return 0;
                        } else {
                            // Only w1 visible
                            return -1;
                        }
                    } else if (w2.element.is(":visible")) {
                        // Only w2 is visible
                        return 1;
                    } else {
                        // Both not visible
                        return 0;
                    }
                };
            
            
            // Sorts widgets by their parseOrder, the widget with the lower parseOrder will be
            // parsed first. If the parseOrder is unspecified, then just parse in the order in
            // which they appeared in the array (i.e. stable sort).
            widgetsToParse = arrayUtils.stableSort(widgetsToParse, function(w1, w2) {
                var result = sortByParseOrder(w1, w2);
                if (result === 0) {
                    result = sortByVisibility(w1, w2);
                }
                return result;
            });
            $.each(widgetsToParse, $.proxy(function(i, widgetToParse) {
                this._parse_widget(widgetToParse.element, widgetToParse.widgetName, widgetToParse.widgetOptions);
            }, this));
        },
        
        /** 
        * @param context the DOM Node to parse under, can be undefined in which case the entire page is
         *                parsed
         */
        parseRefreshArea: function(context) {
            $("[wcType='RefreshArea']", context).each(function (i, e) {
                var declareFunc = $(e).attr("declareFunction");
                
                // find out namepace, function name and params to the function call
                var nameSpace, functionName, argArray = null;
                
                if (declareFunc) {
                    var indexDot = declareFunc.indexOf(".");
                    if (indexDot > 0) {
                        nameSpace = declareFunc.substr(0, indexDot);
                    }
                    var indexFunc = declareFunc.indexOf("(");
                    if (indexFunc > 0) {
                        functionName = declareFunc.substr(indexDot+1, indexFunc-indexDot-1);
                        var argString = declareFunc.slice(indexFunc+1, declareFunc.length-1);
                        // trim single quote, double quote and spaces
                        argString = argString.replace(/"/g, "").replace(/'/g, "").replace(/ /g, "");
                        argArray = argString.split(",");
                    } else {
                        functionName = declareFunc.substr(indexDot+1);
                    }
                }
               
                if (functionName) {
                    if (nameSpace) {
                        if (Utils.isUndefined(window[nameSpace])) {
                            console.error("Namespace " + nameSpace + " is not defined");
                        } else if (Utils.isUndefined(window[nameSpace][functionName])) {
                            console.error("Function " + functionName + " is not defined under namespace " + nameSpace);
                        } else {
                            window[nameSpace][functionName](argArray);
                        }
                        
                    } else {
                        if (Utils.isUndefined(window[functionName])) {
                            console.error(functionName + " is not defined!");
                        } else if (!$.isFunction(window[functionName])) {
                            console.error(window[functionName] + " is not a function!");
                        } else {
                            window[functionName](argArray);                            
                        }                        
                    }
                }
            });
        }
    };

    $(document).ready(function () {
        WCWidgetParser.parse();
        WCWidgetParser.parseRefreshArea();
    });
}(jQuery));