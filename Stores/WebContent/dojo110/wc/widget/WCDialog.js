//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript is used to display the mini shopping cart on the header.
 * @version 1.0
 */
dojo.provide("wc.widget.WCDialog");

/* Import dojo classes */
dojo.require("dijit.Dialog");

/**
 * The functions defined in this class enables initialisation of event listeners for WCDialog. Another set of functions act as callback when a key press or mouse click event occurs.
 * @class The WCDialog widget is an extension of dijit.Dialog. The difference between WCDialog and dijit.Dialog Dialog is that, WCDialog disappears after a specified timeout period,
 * also it positions itself around a specific node whereas dijit.Dialog displays in the middle of the page.
 */

dojo.declare(
    "wc.widget.WCDialog",
    [dijit.Dialog], {

        /* Flag which indicates whether the dialog is to be closed after 'timeOut' milliseconds. The default value is true. */
        closeOnTimeOut:true,
        /* The amount of time, in milliseconds, the dialog remains open. The default value is 4500. */
        timeOut:4500,
        /* The element the dialog can be attached to. The default value is the mini shopping cart element. */
        relatedSource:"",
        /* The x axis page coordinate where the dialog is displayed. */
        x:"",
        /* The y axis page coordinate where the dialog is displayed. */
        y:"",
        /* The current display status of the dialog. */
        displayStatus:false,

        /* Should this dialog closes automatically if mouse is clicked outside the dialog widget area.*/
        autoClose:true,

        /**
         *  This function is used to display the dialog.This makes the dialog listen to onClick event and allow _onMouseClick function to handle it.
         *  This hides the title bar, also starts the timer to close this dialog after timeOut milliseconds if closeOnTimeOut is set to true.
         *  If closeOnTimeOut is set to false, we have to explicitly call hide function to close the dialog.
         */

        show:function(event) {
            if (this.displayStatus)return;
            if (this._showTimer) {
                clearTimeout(this._showTimer);
                delete this._showTimer;
            }
            this.refocus = true;
            this.inherited("show", arguments);

            /* Parent dojo dialog handles only _onKey event. We will be handling onmousedown event also. */

            this._modalconnects.push(dojo.connect(document.documentElement, "onmousedown", this, "_onMouseClick"));
            this._modalconnects.push(dojo.connect(document.documentElement, "onmouseover", this, "_onMouseOver"));

            dojo.style(this.titleNode, "display", "none");
            dojo.style(this.titleNode, "visibility", "hidden");

            dojo.style(this.closeButtonNode, "display", "none");
            dojo.style(this.closeButtonNode, "visibility", "hidden");

            dojo.style(this.closeText, "display", "none");
            dojo.style(this.closeText, "visibility", "hidden");

            /* If closeOnTimeOut is true, then start a timer to close this dialog after timeOut milli seconds. */
            if (this.closeOnTimeOut) {
                this._showTimer = setTimeout(dojo.hitch(this, "hide"), this.timeOut);
            }

            /**
             * If we dont stop this event from propogating further up, then dialog doesnt work properly.
             * If the dialog is opened on click of button, then this onclick event will propogate and it will
             * call _onMouseClick function which closes the dialog immediately.
             */
            if (event != null)dojo.stopEvent(event);
            this.displayStatus = true;
        },

        /**
         *  This function positions this dialog widget at the give x and y coordinates if passed in. This function positions this
         *  dialog widget relative to the relatedSource element passed in. It can also display the dialog just below this relatedSource
         *  element and left margin will be same for both. If not passed, then this will delegate it to parent dojo dialog to position it
         *  at the center of the window.
         */

        _position: function() {

            if (this.x != "" && this.y != "") {
                var style = this.domNode.style;
                style.left = this.x + "px";
                style.top = this.y + "px";
            }
            else if (this.relatedSource != null && this.relatedSource != "") {
                /* This code always positions the dialog around the relatedSource node. */
                var aroundNode = dojo.byId(this.relatedSource);
                var align = this.isLeftToRight() ? {'BR': 'BL', 'BL': 'BR'} : {'BL': 'BR', 'BR': 'BL'};
                var pos = dijit.placeOnScreenAroundElement(this.domNode, aroundNode, align);
            }
            else {
                this.inherited("_position", arguments);
            }
        },

        /**
         *  This function is used to retposition and reset the timer. This function is called when
         *  the dialog is already created and associated with some other source.
         */
        rePosition:function(source) {

            this.relatedSource = source;
            this._position();
            if (this.closeOnTimeOut) {
                if (this._showTimer) {
                    clearTimeout(this._showTimer);
                    delete this._showTimer;
                }
                this._showTimer = setTimeout(dojo.hitch(this, "hide"), this.timeOut);
            }
        },

        /**
         *    This function is used to cancel the timer. If same dialog is associated with two or more buttons or divs and if its showing somewhere
         *  else, then then timer would be set and hence cancel that timer.
         */
        hide:function() {

            if (this._showTimer) {
                clearTimeout(this._showTimer);
                delete this._showTimer;
            }
            if (this.domNode) {
                this.inherited("hide", arguments);
                this.displayStatus = false;
            }
        },

        /* This function is used to get the current display status of the dialog. */
        getDisplayStatus:function() {
            return this.displayStatus;
        },

        /* This function is used to set the display status of the dialog. */
        setDisplayStatus:function(status) {
            this.displayStatus = status;
        },

        /**
         *  This function cancels the timer function which was setup to close this dialog after timeOut milliseconds.
         *  This is called from mousePress and onKey event handlers when the event takes places inside the dialog, so that we wont abruptly
         *  close the dialog when user is doing something inside the dialog widget.
         */
        cancelCloseOnTimeOut:function() {

            if (this._showTimer) {
                clearTimeout(this._showTimer);
                delete this._showTimer;
            }
        },

        /**
         *  This is a callback event when a key is pressed. It checks whether the key press event is inside the dialog,
         *  if so user is using dialog and hence cancel the closeOnTimeOut event. Do not close the dialog unless user explicitly
         *  comes out of it by clicking ESC key or by clicking the mouse outside dialog area.
         */
        _onKey:function(event) {
            /**
             * We have to handle it first and then delegate it to DOJO Dialog, because dojo will stop propogating this event and we may
             * not get chance to handle this if dojo handles it first.
             */
            var node = event.target;
            while (node) {
                if (node == this.domNode) {
                    this.cancelCloseOnTimeOut();
                }
                node = node.parentNode;
            }
            this.inherited("_onKey", arguments);

        },

        /**
         *  This function handles the mouse click events. If the mouse is clicked inside dialog widget area, then cancel the closeOnTimeOut feature,
         *  so that dialog doesnt close on time out. If mouse is clicked outside dialog widget area then close the dialog immediately.
         *  @param {string} evt The mouse click event.
         */
        _onMouseClick: function(evt) {

            var node = evt.target;
            var close = this.autoClose;
            while (node) {
                if (node == this.domNode) {
                    close = false;
                    this.autoClose = false;
                }
                node = node.parentNode;
            }
            if (close) {
            	this.refocus = false;
                this.hide();
            }
            else {
                this.cancelCloseOnTimeOut();
            }
        },

        /**
         *  This function handles the mouse over events. If the mouse is outside the dialog widget area, then close the dialog immediately.
         *  @param {string} evt The mouseover event.
         */
        _onMouseOver: function(evt) {

            var node = evt.target;
            var close = true;
            while (node) {
                if (node == this.domNode || node.id == this.relatedSource) {
                    close = false;
                }
                node = node.parentNode;
            }
            if (close) {
                if (this.autoClose) {
                    this.hide();
                }
            }
        }
    }
);
