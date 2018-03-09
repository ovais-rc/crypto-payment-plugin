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
 * @fileOverview This javascript is used by CategoriesNavDisplay.jsp to display the popup style category of the Madisons starter store.
 * @version 1.0
 */

/* Import dojo classes. */
dojo.provide("wc.widget.WCPopupMenu");

dojo.require("wc.widget.WCMenu");
dojo.require("dijit.Menu");
dojo.require("dijit._Widget");
dojo.require("dijit._Container");
dojo.require("dijit._Templated");

dojo.declare("wc.widget.WCPopupMenu", wc.widget.WCMenu, {
	
	/**
	 *  Direction value controls the menu pop up direction. The default value is 'down'.
	 */
	suffix: '',
	
	/* The HTML that is generated when this widget is parsed. */
	templateString:
			'<div class="dropdown_${suffix}" dojoAttachPoint="mainNode" waiRole="menu">'+
				'<table dojoAttachPoint="mainTable" cellpadding="0" cellspacing="0">'+
					'<tr class="wcmenu_menuItemsPosition">'+
						'<td>'+
							'<div class="wcmenu_columnPosition wcmenu_columnBorder wcmenu_columnPadding" dojoAttachPoint="containerNodeDiv">'+
								'<table dojoAttachPoint="containerNodeTable" cellpadding="0" cellspacing="0" dojoAttachEvent="onkeypress:_onKeyPress">'+
									'<tbody dojoAttachPoint="containerNode"></tbody>'+
								'</table>'+
							'</div>'+
						'</td>'+
						'<td >'+
							'<div dojoAttachPoint="containerNode2Div" class="wcmenu_columnPosition wcmenu_columnBorder wcmenu_columnPadding">'+
								'<table  dojoAttachPoint="containerNode2Table" cellpadding="0" cellspacing="0" dojoAttachEvent="onkeypress:_onKeyPress">'+
									'<tbody dojoAttachPoint="containerNode2"></tbody>'+
								'</table>'+
							'</div>'+
						'</td>'+
						'<td>'+
							'<div dojoAttachPoint="containerNode3Div" class="wcmenu_columnPosition wcmenu_lastColumnBorder wcmenu_columnPadding">'+
								'<table  dojoAttachPoint="containerNode3Table" cellpadding="0" cellspacing="0" dojoAttachEvent="onkeypress:_onKeyPress">'+
									'<tbody dojoAttachPoint="containerNode3"></tbody>'+
								'</table>'+
							'</div>'+
						'</td>'+
					'</tr>'+
					'<tr>'+
						'<td colspan="3">'+
							'<div dojoAttachPoint="showAllMainNode" class="wcmenu_showAllBorder wcmenu_showAllPadding">'+
								'<table cellpadding="0" cellspacing="0" class="wcmenu_showAllSize" dojoAttachEvent="onkeypress:_onKeyPress">'+
									'<tbody dojoAttachPoint="showAllContainer">'+
										'<div dojoType="dijit.MenuItem" dojoAttachPoint="showAllNode" dojoAttachEvent="onClick:showAll">'+
											'<span>'+
												'<a href="" dojoAttachPoint="menuItemLabel"></a>'+
											'</span >'+
										'</div>'+
									'</tbody>'+
								'</table>'+
							'</div>'+
						'</td>'+
					'</tr>'+
				'</table>'+
			'</div>'
	
});

dojo.declare("wc.widget.WCPopupMenuItem", dijit.PopupMenuItem, {

    closeTimer: null,

    changeDelay: 0,

    addHoverClass: function() {
        dojo.addClass(this.containerNode, 'dijitMenuItemLabelHover');
    },

    removeHoverClass: function() {
        dojo.removeClass(this.containerNode, 'dijitMenuItemLabelHover');
    },

    closePopup: function() {
        this.removeHoverClass();
        dijit.popup.close(this.popup);
    },

    _onHover: function() {
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
            this.closeTimer = null;
        }
        this.inherited("_onHover", arguments);
        setTimeout(dojo.hitch(this, "addHoverClass"), this.changeDelay);
        this.getParent().onItemClick(this, null);
    },

    _onUnhover: function() {
        this.inherited("_onUnhover", arguments);
        this.popup.parentMenuItem = this;
        this.closeTimer = setTimeout(dojo.hitch(this, "closePopup"), this.changeDelay);
        this.popup.closeTimer = this.closeTimer;
    }

});

dojo.declare("wc.widget.WCPopupSubMenu", dijit.Menu, {

    /**
     *  Direction value controls the menu pop up direction. The default value is 'down'.
     */
    suffix: '',

    parentMenuItem: null,

    closeTimer: null,

    changeDelay: 0,

    /* The HTML that is generated when this widget is parsed. */
	templateString:
			'<table class="dijit dijitMenu dijitReset dijitMenuTable dropdown_${suffix}" waiRole="menu" dojoAttachEvent="onmouseover:_onHover,onmouseleave:_onUnhover,onkeypress:_onKeyPress">' +
				'<tbody class="dijitReset" dojoAttachPoint="containerNode"></tbody>'+
			'</table>',

    _onHover: function(e) {
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
            this.closeTimer = null;
        }
    },

    _onUnhover: function(e) {
        this.closeTimer = setTimeout(dojo.hitch(this.parentMenuItem, "closePopup"), this.changeDelay);
        this.parentMenuItem.closeTimer = this.closeTimer;
    }

});