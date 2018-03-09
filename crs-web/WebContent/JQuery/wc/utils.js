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

/* global $, window */

var Utils = Utils || {
    /*
     * Returns a function that can only be executed once. 
     */
    once: function(fn, context) {
        var result;

        return function() {
            if (fn) {
                result = fn.apply(context || this, arguments);
                fn = null;
            }

            return result;
        };
    },

    /*
     * Stops an event (same as Dojo's event.stop(e)).
     */
    stopEvent: function(event) {
        event.preventDefault();
        event.stopPropagation();
    },

    /**
     * Returns the text direction (one of rtl or ltr) of the given element.
     */
    getTextDirection: function(element) {
        var result = null;
        if (window.getComputedStyle) {
            result = window.getComputedStyle(element, null).direction;
        } else if (element.currentStyle) {
            result = element.currentStyle.direction;
        }

        return result;
    },

    /**
     * Returns true if the browser is Opera, false otherwise.
     */
    isOpera: function() {
        return (navigator.userAgent.match(/Opera|OPR\//) ? true : false);
    },
    /**
     * Detect ios devices
     * return true if ios devies
     */
    has_ios: function() {
        return navigator.userAgent.match(/(iPod|iPhone|iPad)/)

    },

    /**
     * Returns true if the browser is Chrome, false otherwise.
     */
    isChrome: function() {
        return /chrom(e|ium)/.test(navigator.userAgent.toLowerCase());
    },

    /**
     * Detect touch devices
     * return true for touch devies
     */
    hasTouch: function() {
        return (('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0));
    },
    /**
     * Detect IE
     * returns the version of IE or undefined, if browser is not Internet Explorer
     */
    get_IE_version: function() {
        var ua = window.navigator.userAgent,
            msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
        }

        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 => return version number
            var rv = ua.indexOf('rv:');
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
        }

        var edge = ua.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
        }

        // other browser
        return undefined;
    },

    /**
     * Returns the keys of a JavaScript object as an array. 
     */
    keys: function(obj) {
        var keys = [],
            k;
        for (k in obj) {
            if (obj.hasOwnProperty(k)) {
                keys.push(k);
            }
        }
        return keys;
    },

    /**
     * Iterate over the key-value pairs of the given object
     * in the order returned by the given comparator function.
     * 
     * Parameters:
     * obj - an object to iterate over
     * cmp - the comparator function. Accepts two objects (a, b) 
     *       and returns an integer greater than 0 if a > b, returns
     *       an integer less than 0 if a < b, returns 0 if a equals b.
     * fcn - the callback to execute for each key-value pair in the
     *       object. Shouldaccepts two arguments, a key and a
     *       value. Return true to break out of the loop early.
     */
    iterate_obj_in_order: function(obj, cmp, fcn) {
        var keys = this.keys(obj),
            len = keys.length,
            i, k;

        keys.sort(cmp);

        for (i = 0; i < len; i++) {
            k = keys[i];
            if (fcn(k, obj[k])) {
                break;
            }
        }
    },

    /*
     * Returns true if the given value is NOT null or undefined
     */
    varExists: function(val) {
        return val !== null && (typeof val !== 'undefined');
    },

    /**
     * Returns true if the given value is not null, undefined or empty (i.e. length === 0).
     * Only works on values that have a length property. 
     */
    existsAndNotEmpty: function(val) {
        return this.varExists(val) && val.length;
    },

    /*
     * Returns true if the given value is null or undefined
     TODO: remove this, since it's not following our JavaScript convention, use isNullOrUndefined instead
     */
    is_null_or_undefined: function(val) {
        return val === null || (typeof val === 'undefined');
    },

    /*
     * Returns true if the given value is null or undefined
     */
    isNullOrUndefined: function(val) {
        return val === null || (typeof val === 'undefined');
    },

    /*
     * Returns true if the given value is undefined.
     */
    isUndefined: function(val) {
        return typeof val === 'undefined';
    },

    /*
     * Returns true if the given value is undefined or empty (i.e. length === 0),
     * assumes the given value will have a length property if it's not undefined.
     */
    isUndefinedOrEmpty: function(val) {
        return (typeof val === 'undefined') || (val.length === 0);
    },

    /**
     * Returns true if the given value is an Object
     */
    isObject: function(val) {
        return (val !== null) && (typeof val === "object");
    },

    isString: function(val) {
        return typeof val === 'string';
    },

    /**
     * Converts a URI query into a JavaScript Object
     */
    queryToObject: function(query) {
        var json = '{"' + query.split("&").map(function(str) {
            // important, only replace the first occurrence, don't use a regex
            // to replace all occurence, because the value might have an '=' sign
            // (e.g. if it's a url)
            return str.replace("=", '":"');
        }).join('","') + '"}';

        return query ? JSON.parse(json,
            function(key, value) {
                return key === "" ? value : decodeURIComponent(value);
            }) : {};
    },

    /**
     * Updates the given URL with the given query parameter(s). Modifies the query parameter if it
     * already exists in the URL, otherwise adds the query parameters. 
     * 
     * @param uri the URL to modify
     * @param keys {string, Object} the name of the parameter (must also specify the val parameter) or
     * an Object where the property names are the parameter names and the property values are the 
     * parameter values.
     * @param val {string} the value of the parameter, if keys is an Object, val will be ignored.
     */
    updateQueryStringParameter: function(uri, keys, val) {
        var parameters = {};

        // Parameter checks
        if (this.isString(keys)) {
            parameters[keys] = val;
        } else if (this.isObject(keys)) {
            if (!this.isUndefined(val)) {
                console.warn("Value parameter passed, but will not be used: " + val);
            } else if ($.isEmptyObject(keys)) {
                console.warn("The given parameters are empty");
                return uri;
            }
            parameters = keys;
        } else {
            throw "Invalid key parameter, expected a String or an Object, got: " + keys;
        }

        $.each(parameters, function(key, value) {
            var re = new RegExp("([?|&])" + key + "=.*?(&|#|$)", "i");
            if (uri.match(re)) {
                uri = uri.replace(re, '$1' + key + "=" + value + '$2');
            } else {
                var hash = '';
                if (uri.indexOf('#') !== -1) {
                    hash = uri.replace(/.*#/, '#');
                    uri = uri.replace(/#.*/, '');
                }
                var separator = uri.indexOf('?') !== -1 ? "&" : "?";
                uri = uri + separator + key + "=" + value + hash;
            }
        });
        return uri;
    },

    /**
     * Returns a new Date object with the same date as the given date plus the given number of days.
     *
     * @param date {Date} a JavaScript Date object
     * @param days {integer} the number of days to add (if negative will subtract the given 
     * number of days)
     * @returns {Date} a new Date object
     */
    addDays: function(date, days) {
        var result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
    },

    /**
     * Returns a new Date object with the same date as the given date plus the given number of milliseconds.
     *
     * @param date {Date} a JavaScript Date object
     * @param milliseconds {integer} the milliseconds to add (if negative will subtract the given 
     * number of milliseconds)
     * @returns {Date} a new Date object
     */
    addMilliseconds: function(date, milliseconds) {
        return new Date(date.getTime() + milliseconds);
    },

    /* ----- USES JQUERY ----- */
    /*
     * Set the option of the given widget with data from the DOM if the option is currently
     * null or undefined. If the data from the DOM could not be found, then assign the 
     * given default value.
     * 
     * Parameters: 
     * widget - a jQuery widget
     * option_name - name of the option
     * data_name - name of the data in the DOM
     * default_val - the default value to assign if the data could not be found
     *               in the DOM.
     */
    set_option: function(widget, option_name, data_name, default_val) {
        if (this.is_null_or_undefined(widget.options[option_name])) {
            var data_val = $(widget.element).data(data_name);
            if (this.is_null_or_undefined(data_val)) {
                widget.option(option_name, default_val);
            } else {
                widget.option(option_name, data_val);
            }

        }
    },

    /**
     * Toggle the given hyperlink
     *
     * @param enable true if the hyperlink should be enabled (i.e. the browser will following the link
     * when the user clicks on it), false otherwise (i.e. browser will NOT follow the link when the user
     * clicks on it).
     */
    toggleHyperlink: function($link, enable) {
        if ($link.is("a")) {
            if (enable) {
                // Remove the click handler we added that prevents the default behaviour
                // from occurring
                $link.off("click.utils");
                // Restore the original onclick attribute
                var data = $link.data("utils.toggleHyperlink");
                $link.attr("onclick", data.onclick);
            } else {
                // Stop default href behaviour (note this does not stop other click
                // handlers attached to this link
                $link.on("click.utils", function(evt) {
                    evt.preventDefault();
                });
                // Remove the onclick attribute (evt.preventDefault does not appear to stop
                // browser from following the link). Store it in a data field so when we want
                // to re-enable it we add add the onclick attribute back
                $link.data("utils.toggleHyperlink", {
                    onclick: $link.attr("onclick")
                });
                $link.removeAttr("onclick");
            }

        } else {
            console.err("not a hyperlink: " + $link);
        }
    },

    /**
     * Returns the absolute position of the given element as well as it's 
     * width and height (same as Dojo's domGeometry.position)
     * 
     * @param element {string || jQuery Object || node}
     * Returns:
     * {
     *   x: x coordinate of the element in the document
     *   y: y coordinate of the element in the document
     *   width: width of the element
     *   height: height of the element
     * }
     */
    position: function(element) {
        var $e = $(element),
            offset = $e.offset();
        return {
            x: offset.left,
            y: offset.top,
            w: $e.width(),
            h: $e.height()
        };
    },

    /**
     * Returns true if the given String is empty or whitespace
     */
    isEmptyOrWhiteSpace: function(str) {
        return $.trim(str) === '';
    },

    /**
     * Returns true if the given value is a boolean
     */
    isBoolean: function(value) {
        return $.type(value) === "boolean";
    },

    /*
     * Given an array of jQuery selectors, returns a jQuery object
     * selecting all elements that match the given selectors. 
     */
    selectAll: function(selectors) {
        if (selectors.length > 0) {
            var elements = $(selectors[0]),
                i;
            for (i = 1; i < selectors.length; i++) {
                elements = elements.add(selectors[i]);
            }
            return elements;
        }
        // Return an empty jQuery object if we're given
        // an empty selector
        return $();
    },

    /* ----- JQUERY HELPERS ----- */
    /**
     * Returns true if the given element exists, false otherwise.
     *
     * @param selector {string} the jQuery selector of the element
     */
    elementExists: function(selector) {
        return $(selector).length > 0;
    },

    /**
     * Executes the given function on the jQuery object matched by the given
     * selector if the jQuery object exists. Does nothing otherwise. The return value
     * of this function will be the same as the given function (or undefined if the
     * function is not executed or does not return anything).
     *
     * @param selector {string} jQuery selector 
     * @param fcn {function($obj)} function that accepts a jQuery object as parameter
     * @param context {object} {optional} an optional context object to proxy onto the given
     * function
     */
    ifSelectorExists: function(selector, fcn, context) {
        var $obj = $(selector);
        if ($obj.length) {
            if (context) {
                return $.proxy(fcn, context)($obj);
            } else {
                return fcn($obj);
            }
        }
    },

    /**
     * Given an array of selectors, return the first jQuery object that exists (i.e. length > 0).
     */
    selectExistingElement: function(selectors) {
        return selectors.map(function(s) {
            return $(s);
        }).find(function($e) {
            return $e.length;
        });
    },

    /**
     * Replaces the given attribute
     *
     * @param $obj {jQuery object} the jQuery object to modify the attributes on
     * @param attrName {string} the name of the attribute 
     * @param transform {function} a function that takes the old attribute as argument
     * and returns the new attribute
     */
    replaceAttr: function($obj, attrName, transform) {
        $obj.attr(attrName, transform($obj.attr(attrName)));
    },

    /**
     * Scroll the dom element into view if it's not
     */
    scrollIntoView: function(node) {
        var nodeTop = $(node).offset().top;
        var docViewTop = $(window).scrollTop();
        if (nodeTop < docViewTop) {
            $(node)[0].scrollIntoView(true);
        } else if (nodeTop + $(node).height() > docViewTop + $(window).height()) {
            $(node)[0].scrollIntoView(false);
        }
    },

    /**
     * Binds the given event only once (unbinds all previous instances of this event).
     * 
     * @param $node {jQuery object} the jQuery object to bind the event to 
     * @param eventName {string} the name of the event (e.g. "click" or "keydown")
     * @param namespace {string} namespace for this event, must be unique, otherwise other 
     *                           events with the same namespace will be removed as well
     * @param childSelector {string} {optional} the child selector for this event
     * @param handler {function} the handler for this event
     */
    onOnce: function($node, eventName, namespace, childSelector, handler) {
        var fullEventName = eventName + "." + namespace;
        if (this.isString(childSelector)) {
            $node.off(fullEventName).on(fullEventName, childSelector, handler);
        } else {
            handler = childSelector;
            $node.off(fullEventName).on(fullEventName, handler);
        }

    },

    /**
     * Replaces {obj.attr} param in a string with string specified in an object
     * @param origString {string} original string with param to be replaced
     * @param targObject {object} contains required attributes for the string substitution
     * 
     * Example usage: substituteStringWithObj("<p>{address.city}, {address.postalCode}</p>", {"address": {"city": "toronto", "postalCode": "12345"}}) will return
     * "<p>toronto, 12345</p>"
     */
    substituteStringWithObj: function(origString, targObject) {
        return origString.replace(/{(\w+(\.*\w*)*)}/g, function(match, key) {
            if (typeof targObject !== 'undefined') {
                var subArgs = targObject;
                var subObject = key.substr(0, key.indexOf("."));
                key = key.substr(key.indexOf(".") + 1, key.length);
                while (subObject !== "") {
                    subArgs = subArgs[subObject];
                    subObject = key.substr(0, key.indexOf("."));
                    key = key.substr(key.indexOf(".") + 1, key.length);
                }
                if (key !== "") {
                    subArgs = subArgs[key];
                }

                return typeof subArgs !== 'undefined' ? subArgs : match;
            } else {
                return match;
            }
        });
    },

    /**
     * Replaces {i} param in a string with string specified in substituteMap
     * @param origString the original string that contains {i} to be substitute
     * @param substituteMap a map containing strings to substitute into original string
     * 
     * Example usage: substituteStringWithMap("hi {0}, this is {1}!", {0: "Aurora", 1: "jQuery"}) will return
     * "hi Aurora, this is jQuery!"
     */
    substituteStringWithMap: function(origString, substituteMap) {
        origString = origString.replace(/\{([0-9])\}/g, function(match, key) {
            return substituteMap[key];
        });
        return origString;
    },

    /**
     * Get Localization Messages from nls
     * example: Utils.getLocalizationMessage(message, {0: arg1, 1: arg2})
     */
    getLocalizationMessage: function(message, /* optional*/ params) {
        if (GlobalizeLoaded) {
            return Globalize.formatMessage(message, params);
        }
    },

    /**
     * Get localized currency display
     * example: Utils.formatCurrency("123.4", {
     *                  minimumFractionDigits: 2,
     *                  maximumFractionDigits: 2,
     *                  currency: "USD"
     *          })
     * 
     * @param amount {string}
     * @param options {object} may include currency, minimumFractionDigits, maximumFractionDigits, etc.
     */
    formatCurrency: function(amount, options) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (options) {
            var currency = options["currency"];
            var locale = options["locale"];
        }
        if (!currency) {
            currency = WCParamJS.commandContextCurrency;
        }
        if (GlobalizeLoaded) {
            if (locale) {
                amount = Globalize(locale).parseNumber(amount);
                return Globalize(locale).formatCurrency(amount, currency, options);
            } else {
                amount = Globalize.parseNumber(amount);
                return Globalize.formatCurrency(amount, currency, options);
            }
        }
    },

    /**
     * Parse numbers according to localized information
     * example: Utils.parseNumber("123.4")
     * 
     * @param amount {string}
     */
    parseNumber: function(amount) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (GlobalizeLoaded) {
            return Globalize.parseNumber(amount);
        }
    },

    /**
     * Format numbers according to localized information
     * example: Utils.formatNumber("123.4", {maximumFractionDigits: 2, minimumFractionDigits: 2})
     * 
     * @param amount {string}
     * @param options {object} may include minimumFractionDigits, maximumFractionDigits, etc.
     */
    formatNumber: function(amount, options) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (GlobalizeLoaded) {
            amount = Globalize.parseNumber(amount);
            return Globalize.formatNumber(amount, options);
        }
    },

    /**
     * Returns the locale.
     */
    getLocale: function() {
        return navigator.languages ? navigator.languages[0] : (navigator.language || navigator.userLanguage);
    },

    /**
     * Round the given value to the given number of decimals.
     */
    round: function(value, decimals) {
        return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
    },

    /**
     * Converts any value to true/false depending on it's truthy value (e.g. undefined, 0, null 
     * returns false, 1, objects return true). 
     */
    toBoolean: function(value) {
        // First ! converts it to a boolean, second ! reverts the value back (i.e. false to true and
        // vice-versa)
        return !!value;
    },

    /**
     * Returns true if the given array contains the given value, false otherwise.
     */
    arrContains: function(arr, value) {
        return $.inArray(value, arr) !== -1;
    },

    /**
     * Returns true if the given string is not null or white space.
     */
    notNullOrWhiteSpace: function(str) {
        return str !== null && $.trim(str).length !== 0;
    },

    /**
     * Returns the name of the first property in the object that satisfies the given predicate.
     *
     * @param obj a JavaScript Object
     * @param predicate a function that takes two arguments: the property name and property value
     */
    findInObj: function(obj, predicate) {
        var target;
        $(obj).each(function(key, val) {
            if (predicate(key, val)) {
                target = key;
                return false; // breaks out of the each
            }
        });
        return target;
    },

    /**
     * Returns true if the two given elements belong to the same parent. 
     *
     * @param $e1 a jQuery Object representing zero or more elements
     * @param $e2 a jQuery Object representing zero or more elements
     */
    areSiblings: function($e1, $e2) {
        var isSibling = function(e1, e2) {
            return $(e1).siblings().is($(e2));
        };
        if (!arrayUtils.verifyTransitiveProperty($e1, isSibling) || !arrayUtils.verifyTransitiveProperty($e2, isSibling)) {
            return false;
        } else if (arrayUtils.isEmpty($e1) || arrayUtils.isEmpty($e2)) {
            return true;
        } else {
            return isSibling(arrayUtils.last($e1), $e2[0]);
        }
    },

    /**
     * Returns true if the given elements are the same parent element.
     *
     * @param jqObj a jQuery object representing elements
     */
    sameParent: function(jqObj) {},

    /**
     * Return a property from a dot-separated string, such as "A.B.C"
     *
     * @param name: {string} path to an property, in the form "A.B.C"
     */
    getObject: function(name) {
        if (name === "") return;

        var nameArray = name.split(".");
        var result = window[nameArray[0]];

        for (i = 1; i < nameArray.length; i++) {
            if (!result) break;
            result = result[nameArray[i]];
        }

        return result;
    },

    /**
     * Return a property from a dot-separated string, such as "A.B.C"
     *
     * @param name: {string} path to an property, in the form "A.B.C"
     */
    idExists: function() {
        if (arguments.length === 0) {
            console.warn("No arguments passed to idExists");
            return true;
        }
        for (var i = 0; i < arguments.length; i++) {
            if (!$(arguments[i].length)) {
                return false;
            }
        }
        return true;
    },

    /**
     * Call a function after the original function returns
     *
     * @param srcObj: {string} source object of the original function
     * @param oldFunc: {string} original function name
     * @param callback: {function} the function will be called afterwards
     */
    aop_after: function(srcObj, oldFunc, callback) {
        var old = $.proxy(srcObj[oldFunc], srcObj);
        srcObj[oldFunc] = function() {
            old.apply(this, arguments);
            return callback(arguments);
        }
    },

    /**
     * Replaces ${i} param in a string with string specified in substituteMap
     * param origString the original string that contains ${i} to be substitute
     * param substituteMap a map containing strings to substitute into original string
     * example usage: substituteString("hi ${0}, this is ${1}!", {0: "Aurora", 1: "jQuery"}) will return
     * "hi Aurora, this is jQuery!"
     */
    substituteString: function(origString, substituteMap) {
        origString = origString.replace(/\$\{([0-9])\}/g, function(match, key) {
            return subsMap[key];
        });
        return origString;
    }
};