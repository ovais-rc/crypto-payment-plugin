//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * @fileOverview This JavaScript file is used in store pages that need to display a tooltip without the standard connector arrow and the bubble around the message.
 */

/* Import dojo classes */
dojo.provide("wc.widget.XTooltip");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.Tooltip");

/**
 * The functions defined in this class set the tooltip to use a customized template style.
 * @class wc.widget._MasterTooltip is an extension of the dijit._MasterTooltip.
 * It is used to set the tooltip to use a customized template without the standard tooltip connector arrow and tooltip bubble.
 */
dojo.declare(
    "wc.widget._MasterXTooltip",
    dijit._MasterTooltip,
    {

    }
);
wc.widget.showXTooltip = function(innerHTML, aroundNode, position) {
    if (!wc.widget._masterXTT) {
        wc.widget._masterXTT = new wc.widget._MasterXTooltip();
    }
    return wc.widget._masterXTT.show(innerHTML, aroundNode, position);
};

/**
 * This function is used to hide the tooltip.
 * @param {string} aroundNode The DomNode around which tooltip is currently displayed.
 */
wc.widget.hideXTooltip = function(aroundNode) {
    if (!wc.widget._masterXTT) {
        wc.widget._masterXTT = new wc.widget._MasterXTooltip();
    }
    return wc.widget._masterXTT.hide(aroundNode);
};
/**
 * The functions defined in this class are used to open and close a tooltip that has the template style defined in wc.widget._MasterTooltip.
 * @class The Tooltip widget is an extension of dijit.Tooltip and is used to display tooltips that have the template style defined in wc.widget._MasterTooltip.
 *  It inherits the rest of the functionality from dijit.Tooltip.
 */
dojo.declare(
    "wc.widget.XTooltip",
    dijit.Tooltip,
    {
        connectId: [],
        /**
         * This constant integer is the number of milliseconds to wait after hovering over/focusing on the object, before the tooltip is displayed.
         * @private
         * @constant
         */
        showDelay: 100,

        _keyDown: false,
        /**
         * This function is used to display the tooltip.
         * @param {string} target The DomNode around which tooltip is to be displayed.
         */
        open: function(/*DomNode*/ target) {
            target = target || this._connectNode;
            if (!target) {
                return;
            }
            if (this._showTimer) {
                clearTimeout(this._showTimer);
                delete this._showTimer;
            }
            wc.widget.showXTooltip(this.label || this.domNode.innerHTML, target, this.position);
            dojo.connect(wc.widget._masterXTT.domNode, "onmouseout", this, "_onTargetMouseLeave");
            dojo.connect(target, "onkeydown", this, "_onTargetKeyDown");
            var tooltip = this;
            var links = dojo.query("a", wc.widget._masterXTT.domNode);
            (function() {
                var currentTooltip = tooltip;
                dojo.connect(links[links.length - 1], 'onkeydown', null, function(e) {
                    if (e.keyCode == dojo.keys.ESCAPE || e.keyCode == dojo.keys.TAB) {
                        currentTooltip.close();
                        links.forEach(function(node, index, array) {
                            node.tabIndex = -1;
                        });
                        dojo.query(".shopping_list_delete a", currentTooltip.domNode.parentNode)[0].focus();
                        dojo.stopEvent(e);
                    }
                })

            })();
            this._connectNode = target;

        },
        close: function() {
            if (this._connectNode) {
                wc.widget.hideXTooltip(this._connectNode);
                delete this._connectNode;
            }
            if (this._showTimer) {
                clearTimeout(this._showTimer);
                delete this._showTimer;
            }
        },
        _onTargetMouseLeave: function(/*Event*/ e) {
            var relTg = e.relatedTarget ? e.relatedTarget : e.toElement;
            if (typeof relTg.className == 'undefined')relTg.className = '';
            if (relTg.className == 'dijitTooltipConnector' || relTg.className == 'dijitTooltipContainer'
                || dojo.isDescendant(relTg, e.currentTarget)
                || e.target.className == "dijitTooltipConnector"
                || (wc.widget._masterXTT != null && dojo.isDescendant(relTg, wc.widget._masterXTT.domNode))
                || dojo.isDescendant(e.orignalTarget, e.currentTarget)) {
                return;
            }
            this._onUnHover(e);
        },
        _onTargetBlur: function(/*Event*/ e) {
            // Skip keydown event for keyboard operation
            this._focus = false;
            if (this._keyDown) {
                this._keyDown = false;
                return;
            }
            this.inherited(arguments);
        },
        _onTargetKeyDown: function(/*Event*/ e) {
            //Move focus to the tooltip above the connector by pressing "TAB"
            if (e.keyCode == dojo.keys.TAB) {
                this._keyDown = true;
                dojo.byId(dojo.query("a", wc.widget._masterXTT.domNode)[0]).focus();
                dojo.stopEvent(e);
            }
        }
    }
);