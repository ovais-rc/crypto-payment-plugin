//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

	
/** 
 * @fileOverview This JavaScript file is used in store pages that need to display a tooltip without the standard connector arrow and the bubble around the message.
 */
	
 /* Import dojo classes */
dojo.provide("wc.widget.Tooltip");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.Tooltip");

/**
 * The functions defined in this class set the tooltip to use a customized template style. 
 * @class wc.widget._MasterTooltip is an extension of the dijit._MasterTooltip.
 * It is used to set the tooltip to use a customized template without the standard tooltip connector arrow and tooltip bubble.
 */ 
dojo.declare(
	"wc.widget._MasterTooltip",
	dijit._MasterTooltip,
	{
		/**
		 * This constant specifies the file path to the template to use for an instance of wc.widget.Tooltip.
		 * @private
		 * @constant
		 */
		templateString:"<div class='dijitTooltip dijitTooltipLeft' id='dojoTooltip'><div id='tooltipBox' class='dijitTooltipContainer dijitTooltipContents' data-dojo-attach-point='containerNode' role='alert'></div><div class='dijitTooltipConnector' data-dojo-attach-point='connectorNode'></div></div>"
	}
);

/** 
 * This function displays the tooltip with specified contents.
 * @param {string} innerHTML The content to be displayed in the tooltip.
 * @param {string} aroundNode The DomNode around which tooltip is to be displayed.
 */
wc.widget.showTooltip = function(innerHTML,aroundNode){
	if(!wc.widget._masterTT){ wc.widget._masterTT = new wc.widget._MasterTooltip(); }
	var isRtl = dojo.some(['ar','he','iw'],function(item){return item === dojo.attr(dojo.body().parentNode,"lang")});
	return wc.widget._masterTT.show(innerHTML, aroundNode, [], isRtl);
};

/**
 * This function is used to hide the tooltip.
 * @param {string} aroundNode The DomNode around which tooltip is currently displayed.
 */
wc.widget.hideTooltip = function(aroundNode){
	if(!wc.widget._masterTT){ wc.widget._masterTT = new wc.widget._MasterTooltip(); }
	return wc.widget._masterTT.hide(aroundNode);
};


/**
 * The functions defined in this class are used to open and close a tooltip that has the template style defined in wc.widget._MasterTooltip.
 * @class The Tooltip widget is an extension of dijit.Tooltip and is used to display tooltips that have the template style defined in wc.widget._MasterTooltip. 
 *  It inherits the rest of the functionality from dijit.Tooltip.
 */
dojo.declare(
	"wc.widget.Tooltip",
	dijit.Tooltip,
	{
		/**
		 * This constant integer is the number of milliseconds to wait after hovering over/focusing on the object, before the tooltip is displayed.
		 * @private
		 * @constant
		 */
		showDelay: 200,
		
		/**
		 * This function is used to display the tooltip.
		 * @param {string} target The DomNode around which tooltip is to be displayed.
		 */
		open: function(/*DomNode*/ target){
			target = target || this._connectNodes[0];
			if(!target){ return; }

			if(this._showTimer){
				clearTimeout(this._showTimer);
				delete this._showTimer;
			}
			wc.widget.showTooltip(this.label || this.domNode.innerHTML, target);
			
			this._connectNode = target;
		},
		
		/**
		 * This function is used to hide the tooltip.
		 */
		close: function(){
			if(this._connectNode){
				wc.widget.hideTooltip(this._connectNode);
				delete this._connectNode;
			}
			if(this._showTimer){
				clearTimeout(this._showTimer);
				delete this._showTimer;
			}
		}
	}
);