//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------

/**
 * @fileOverview This javascript is used in store pages which have a section of a page which needs to be dynamically updated with new content.
 * @version 1.0
 */

/* Import dojo classes */
dojo.provide("wc.widget.RefreshArea");

dojo.require("dijit._Widget");
dojo.require("dijit.layout.ContentPane");
dojo.require("wc.render.RefreshController");
dojo.require("dojo.parser");

/**
 * The functions defined in this class helps in initialising, updating and destroying a RefreshArea.
 * @class The RefreshArea widget is used to wrap a Document Object Model (DOM) node that is refreshed by replacing the innerHTML property with new content loaded from the server.
 * That is, a refresh area is a section of a page which is dynamically updated with new content. A refresh area widget is associated with a registered refresh controller
 * of type wc.render.RefreshController, that handles listening for events that require this widget to be refreshed.
 */
dojo.declare(

    "wc.widget.RefreshArea",

    [dijit._Widget, dijit.layout.ContentPane],

    {

        /* The unique identifier of the refresh controller associated with the refresh area widget.*/
        controllerId: "",
        /* The unique identifier of the refresh area widget used to distinguish this refresh area from
         * other refresh areas being controlled by the same refresh controller
         */
        objectId: "",

        /** The refresh controller instance that is controlling this refresh area. This value is initialized
         * by locating the refresh controller with the controller ID specified by "controllerId".
         */
        controller: null,

        /**
         * This identifier stores the message that will be read to the user using screen reader
         */
        ariaMessage: "",

        /**
         * This identifier stores the id of the message span using aria-live region
         */
        ariaLiveId: "",

        /**
         * This function initialises the refresh area widget.The refresh area widget is registered to the refresh controller that
         * matches the "controllerId" attribute. This function is called by the dojo widget framework.
         */
        startup: function() {

            this.controller = wc.render.getRefreshControllerById(this.controllerId);

            if (!this.controller) {

                throw new Error('Could not locate RefreshController "' + this.controllerId + '".');
            }

            console.debug("Adding.. " + this.id + " to ...." + this.controllerId);
            this.controller.addWidget(this);
            this.containerNode = this.domNode;
            return this.inherited("startup", arguments);
        },

        /**
         *  This function is used to destroy the refresh area widget.
         *  The refresh area widget is deregistered from the refresh controller that is controlling this refresh area.
         *  This function is called by the dojo widget framework.
         */

        destroy: function() {

            this.controller.removeWidget(this);
            return this.inherited("destroy", arguments);
        },

        /**
         *  This function is used to refresh the content of the refresh area widget.
         *  The refresh controller calls the refresh method of the RefreshArea when it recieves an event that the area needs to be refreshed.
         *  This method then delegates back to the refresh function of the refresh controller after adding objectId to the parameters array.
         *  @param {array} parameters This contains parameters to be used during refresh.
         */
        refresh: function(parameters) {

            if (!parameters) {
                parameters = {};
            }
            parameters.objectId = this.objectId;
            this.controller.refresh(this, parameters);

        },

        /**
         *  This function is used to update the inner HTML of the refresh area with the new content loaded from the server .
         *  This function is normally called by the refresh controller to update the content of the Refresh area.
         *  It also ensures that any Dojo child widgets are properly destroyed and reinitialized.
         *  @param {string} html The new content loaded from the server.
         */
        setInnerHTML: function (html) {

            this.destroyDescendants();
            // Check whether there are already widgets with the same id. If it's the case, destroy first
            // it's possible that widget dom is not the child of the refresh area any more, so 'destroyDescendants'
            // will not unregister the widget
            var nHtml = dojo.create('div', {innerHTML:html});
            var arrD = dojo.query('[dojoType][id]', nHtml);
            dojo.forEach(arrD, function(entr, i) {
                var wId = dojo.attr(entr, 'id');
                var w = dijit.byId(wId);
                if (w) {
                    w.destroyRecursive();
                    console.debug('Destroy widget :' + w);
                }
            });
            // end check
            this.containerNode.innerHTML = html;
            dojo.parser.parse(this.containerNode);

        },

        /**
         *  This function checks if ariaMessage and ariaLiveId is set, if it is, it will set the ariaMessage locate the span
         *  with ariaLiveId and using that, set the message so that it will be read to user using screen reader.
         *  This function is normally called by the refresh controller after the content is updated to notify the user
         *  certain section of the screen has been udpated.  Additionally, the function will also unhide the ACCE_Label for
         *  the node with areaLiveId as well.
         */
        updateLiveRegion: function () {
            if (document.getElementById(this.ariaLiveId + "_ACCE_Label")) {
                document.getElementById(this.ariaLiveId + "_ACCE_Label").style.display = "block"
            }
            if (this.ariaMessage != "" && this.ariaLiveId != "") {
                var messageNode = document.createTextNode(this.ariaMessage);
                var liveRegionNode = document.getElementById(this.ariaLiveId);
                if (liveRegionNode) {
                    while (liveRegionNode.firstChild) {
                        liveRegionNode.removeChild(liveRegionNode.firstChild);
                    }
                    liveRegionNode.appendChild(messageNode);
                }
            }
        }

    }
);