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

wcRenderContext={
    contextArray: {},

    getRefreshAreaIds: function(id) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.getRefreshAreaIds: Common render context " + id + " is not defined");
            return;
        }
        return this.contextArray[id]["refreshAreaIds"];
    },

    getRenderContextProperties: function(id) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.getRenderContextProperties: Common render context " + id + " is not defined");
            return;
        }
        return this.contextArray[id]["contextProperties"];
    },

    addRefreshAreaId: function(id, refreshAreaId) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.addRefreshAreaId: Common render context " + id + " is not defined");
            return;
        }
        if (!Utils.arrContains(this.contextArray[id]["refreshAreaIds"], refreshAreaId)) {
            this.contextArray[id]["refreshAreaIds"].push(refreshAreaId);
        }        
    },

    declare: function(id, refreshAreaIds, initialProperties) {
        // create new context obj and add to contextArray
        if (this.checkIdDefined(id)) {
            console.error("Common render context with id =  " + id + " already exits.Please use a different id");
            return;
        } else if (!$.isArray(refreshAreaIds)) {
            console.error("refresh area ids should be an array, got: " + refreshAreaIds);
            return;
        }
        
        // if initial property is empty, create an empty object
        if (initialProperties === "") {
            initialProperties = {};
        }
        
        var context = {
            "id": id,
            "refreshAreaIds": refreshAreaIds,
            "contextProperties": initialProperties,
            // The current render context properties. This object is used to determine what properties have
            // actually changed since the last time a render context changed event was detected.
            "currentRCProperties": {}
        };
        this.contextArray[id] = context;
        this._syncRCProperties(id);
    },

    updateRenderContext: function(id, properties) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.updateRenderContext: Common render context " + id + " is not defined");
            return;
        }

        var curRenderContext = this.getRenderContextProperties(id);
        for (var name in properties) {
            var value = properties[name];
            if (value != curRenderContext[name]) {
                //contextChanged = true;

                if (Utils.isUndefined(value)) {
                    delete curRenderContext[name];
                } else {
                    curRenderContext[name] = value;
                }
            }
        }

        var curRefershAreas = this.getRefreshAreaIds(id);
        $.each(curRefershAreas, function(i, refreshDivId) {
            var refreshAreaDiv = $("#" + refreshDivId);
            refreshAreaDiv.refreshWidget("renderContextChanged", refreshAreaDiv);
        });
        
        wcTopic.publish(id + "/RenderContextChanged", {actionId: id + "/RenderContextChanged"});

        this._syncRCProperties(id);
    },

    testForChangedRC: function(id, propertyNames) {
        var change = false;
        for (var i = 0; i < propertyNames.length; i++) {
            var prop = propertyNames[i];
            if (this.contextArray[id]["currentRCProperties"][prop] != this.contextArray[id]["contextProperties"][prop]) {
                change = true;
                break;
            }
        }
        return change;
    },

    checkIdDefined: function(id) {
        return Utils.toBoolean(this.contextArray[id]);
    },

    _syncRCProperties: function(id) {        
        var rc = this.getRenderContextProperties(id),
            properties = $.extend({}, rc); // shallow copy
        this.contextArray[id]["currentRCProperties"] = properties;
    }
};



