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

/* global jQuery, $, console */

// Adds publish/subscribe functionality to jQuery using callbacks
// Source: https://api.jquery.com/jQuery.Callbacks/

/*
// Publisher
wcTopic.publish( "mailArrived", "hello world!" );
wcTopic.publish( "event1", {"key1":"value1", "key2":"value2"});

// Subscribe
wcTopic.subscribe( "mailArrived", fn1 );
wcTopic.subscribe( ["event1", "event2"], function test(returnData) {
    if (returnData) {
        alert("data: " + returnData["key1"]);
    }
});
wcTopic.subscribe({"event1":"event1", "event2":"event2"}, fn1);

*/

wcTopic = {
    _topics: {},

    _getIdArray: function(ids) {
        var idArray = new Array();
        if ($.type(ids) === "array" || $.type(ids) === "object") {
            for (var key in ids) {
                idArray.push(ids[key]);
            }
        } else if ($.type(ids) === "string"){
            idArray.push(ids);
        } else {
            console.error("jQuery.Topic - ids has an unsupported type: " + $.type(ids));
        }
        return idArray;
    },

    _processIds: function(ids) {
        var idArray = this._getIdArray(ids);
        for (var key in idArray) {
            var id = idArray[key];
            if (!this._topics[id]) {
                // declare new topic
                this._topics[id] = $.Topic(id);
            }
        }
        return idArray;
    },

    /**
     * @param ids Event ids (type can be string for single ID, or array of ids in string, or object containing ids in string)
     * @param fcn The function to invoke
     */
    subscribe: function(ids, fcn) {
        var idArray = this._processIds(ids);
        for (var key in idArray) {
            this._topics[idArray[key]].subscribe(fcn);
        }
    },

    /**
     * @param ids Event ids (type can be string for single ID, or array of ids in string, or object containing ids in string)
     * @param obj The data to pass back to the callback list
     */
    publish: function(ids, obj) {
        var idArray = this._processIds(ids),
            args;
        for (var key in idArray) {
            // Grab all but the first argument
            args = Array.prototype.slice.call(arguments, 1);
            this._topics[idArray[key]].publish.apply(null, args);
        }
    },

    subscribeOnce: function(ids, fcn, context) {
        var idArray = this._processIds(ids);
        for (var key in idArray) {
            this._topics[idArray[key]].subscribeOnce(fcn, context);
        }
    }
}

jQuery.Topic = function (id) {
    var callbacks = jQuery.Callbacks("unique");

    var topic = {
        id: id,
        publish: callbacks.fire,
        subscribe: callbacks.add,
        /**
        * Same as subscribe except the given function or array of functions
        * only execute once (and then the function is removed from this callback).
        */
        subscribeOnce: function (fcns, context) {
            if ($.isFunction(fcns)) {
                var newFcn = function () {
                    fcns.apply(context || this, arguments);
                    callbacks.remove(newFcn);
                };
                callbacks.add(newFcn);
            } else {
                fcns.forEach(function (a_fcn) {
                    if ($.isFunction(a_fcn)) {
                        var newFcn = function () {
                            a_fcn.apply(context || this, arguments);
                            callbacks.remove(newFcn);
                        };
                        callbacks.add(newFcn);
                    } else {
                        console.err(a_fcn + " is not a function");
                    }
                });
            }
        },
        unsubscribe: callbacks.remove
    };

    return topic;
};