//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2007
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------

dojo.provide("wc.render.Context");

//wd dojo.require("dojo.i18n.common");
dojo.requireLocalization("wc", "common", null, "ROOT,en,en-us");

wc.render.contexts = {
    // summary: Map of all declared render context objects.
    // description: The wc.render.context object stores all of the currently declared
    //		render context objects. The render context ID is the property name.
};

wc.render.getContextById = function (id) {
    // summary: Get the declared render context with the specified ID.
    // description: Get the render context that was declared under the specified
    //		identifier. If the render context was not declared then this function
    //		will return "undefined".
    // returns: The render context with the specified ID.
    return wc.render.contexts[id];
};

wc.render.updateContext = function (id, updates) {
    // summary: Update the specified render context with the specified updates.
    // description: This function retrieves the render context with the specified ID
    //		and applies the updates found in the specified "updates" object.
    // id: String
    //		The render context ID.
    // updates: Object
    //		The render context updates. The properties of the object are added to
    //		the render context. Properties that have an undefined value are removed
    //		from the render context.
    console.debug("wc.render.updateContext: " + id);
    wc.render.getContextById(id).update(updates);
};

wc.render.declareContext = function (id, properties, updateContextURL) {
    // summary: Declare a new render context with the specified ID.
    // description: This function declares a new render context and initializes it
    //		with the specified render context properties. The update context URL
    //		is used to report changes to the render context to the server.
    // returns: The new render context.
    // id: String
    //		The unique ID of the new render context.
    // properties: Object
    //		The initial render context properties.
    // updateContextURL:
    //		The URL that is used to notify the server of render context updates.
    if (this.contexts[id] != null && this.contexts[id] != "") {
        console.debug("Render context with id =  " + id + " already exits.Please use a different id");
        return;
    }
    var context = new wc.render.Context(id, properties, updateContextURL);
    this.contexts[id] = context;
    return context;
};

dojo.declare("wc.render.Context", null, {
    // summary: Render context class.
    // description: This class manages the render context. Changes to the render context
    //		will be communicated to the server using an Ajax style request. Once the render
    //		context is successfully updated, an event will be published so that any listening
    //		widgets can refresh their content to reflect the updated render context.
    // id: String
    //		The ID of the render context.
    // properties: Object
    //		The current render context properties.
    // url: String
    //		The URL that is used to notify the server of changes to the render context.
    // contextChangedEventName: String
    //		The topic name of the event that is published when the render context is successfully
    //		updated. The topic name is the render context ID appended with "/RenderContextChanged".
    constructor: function (id, properties, updateRenderContextURL) {
        // summary: Render context initializer.
        // description: Initializes a new render context object.
        // id: String
        //		The ID of the new render context.
        // properties: Object
        //		The initial render context properties.
        // udateRenderContextURL: String
        //		The URL used to notify the server of render context updates.
        this.id = id;
        this.properties = properties ? properties : {};
        this.url = updateRenderContextURL;
        this.contextChangedEventName = id + "/RenderContextChanged";
    },

    id: undefined,
    properties: undefined,
    url: undefined,
    contextChangedEventName: undefined,

    update: function (updates) {
        // summary: Render context update function.
        // description: This function will update the render context with the specified properties.
        //		Only properties specified in the "updates" object will be updated.
        //		If an update render context URL was declared for this render context, then the server is notified
        //		of the updates through an Ajax style request. When the update is complete, an event is published
        //		to notify listeners of the render context change.
        // updates: Object
        //		Render context updates.
        if (!this.properties) {
            this.properties = {};
        }
        if (this.url) {
            console.debug("wc.render.updateContext - url : " + this.url);
            var content = {};
            for (var name in updates) {
                var value = updates[name];
                if (typeof value == "undefined") {
                    if (typeof content.clear == "undefined") {
                        content.clear = [name];
                    }
                    else {
                        content.clear.push(name);
                    }
                }
                else {
                    content["set_" + name] = value;
                }
            }

            dojo.publish("ajaxRequestInitiated");

            dojo.xhrPost({
                url: this.url,
                mimetype: "text/json",
                handleAs: "json",
                content: content,
                properties: this.properties,
                successEventName: this.contextChangedEventName,
                load: function(data) {
                    if (dojo.isArray(data.renderContextChanges)) {
                        for (var i = 0; i < data.renderContextChanges.length; i++) {
                            var name = data.renderContextChanges[i];
                            console.debug("updating render context: " + request.properties[name] + " = " + data[name]);
                            request.properties[name] = data[name];
                        }
                    }
                    console.debug("publishing " + this.successEventName + " event");
                    dojo.publish(this.successEventName, [data]);
                    dojo.publish("ajaxRequestCompleted");
                },
                error: function(response, ioArgs) {
                    // handle error here - need to post an event to tell event listeners
                    // that the render update didn't happen and the UI needs to resynch
                    // with the local copy of the render context
                    var messages = dojo.i18n.getLocalization("wc", "common");
                    console.debug("Warning: communication error while updating the context values"); // Communication error.
                    dojo.publish("ajaxRequestCompleted");
                }
            });
        }
        else {
            console.debug("wc.render.updateContext - url not specified");

            // local render context
            var data = {
                renderContextChanges: []
            };
            for (var name in updates) {
                var value = updates[name];
                if (value != this.properties[name]) {
                    data.renderContextChanges.push(name);
                    //wd-todo
                    if (typeof value == "undefined") {
                        delete this.properties[name];
                    }
                    else {
                        this.properties[name] = value;
                        data[name] = value;
                        console.debug("updating render context: " + name + " = " + value);
                    }
                }
            }
            console.debug("publishing " + this.contextChangedEventName + " event")
            dojo.publish(this.contextChangedEventName, [data]);
        }
    }
});