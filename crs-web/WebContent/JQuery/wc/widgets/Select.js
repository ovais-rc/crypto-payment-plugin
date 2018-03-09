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

/*global jQuery, Utils, window, document */

/* 
 * Select (extends $.ui.selectmenu) 
 *
 * Options:
 * useValueAsLink: true if the value of the select menu items should be treated as a link (defaults to false). The onChange element will be ignored. 
 */
(function ($) {
    $.widget("wc.Select", $.ui.selectmenu, {
        options: {
            wcMenuClass: "",
            useValueAsLink: false
        },
        
        _create: function() {
            this._super(this);
            
            if (this.options.useValueAsLink) {
                if (!Utils.isUndefined(this.element.attr("onChange"))) {
                    console.warn("onChange defined for select menu, but it will be ignored since useValueAsLink is set to true");
                }                 
                this.options.change = function() {
                    var url = $(this).val();
                    if(Utils.existsAndNotEmpty(url)) {
                        window.location = url;
                    } else {
                        console.error("the url is not defined");
                    }
                }
            } else if(this.element.attr("onChange") !== undefined) {
                //pick up the onChange parameters
    			var onChange = this.element.attr("onChange").replace(/javascript:/i, '')
	    		this.options.change = function(event, data) {
	    			eval(onChange);
	    		}
    		}
            
            // Get index of the selected element (if any)
            var selectedOption = $(this.element).find("[selected='selected']");
            if (selectedOption.length) {
                $(this.element[0]).prop('selectedIndex', selectedOption.index());
            }            
    	},
    	
    	open: function( event ) {
    		this._super(this);
    		
    		// If this is not the first time the menu is being opened, reset focused and selected item
    		if ( this.menuItems ) {
    			this._removeClass( this.menu.find( ".ui-state-select" ), null, "ui-state-select" );
    			this._addClass( this._getSelectedItem().children(), null, "ui-state-select" );
    			this.menuInstance.focus( null, this._getSelectedItem() );
    		}
    	},
    	
    	close: function( event ) {
    		this._super(this);
			
    		//re-identify the selected items
    		this._removeClass( this.menu.find( ".ui-state-select" ), null, "ui-state-select" );
    		this._addClass( this._getSelectedItem().children(), null, "ui-state-select" );
    	},
    	
    	_drawButton: function() {
    		this._super(this);
    		
    		//pass classes from select element to new select button
    		this.button.addClass(this.element.attr("class"));
    		this.button.addClass(this.element.attr("baseclass"));
    		this.button.attr("style", "");
    	},
    	
    	_drawMenu: function() {
    		var that = this;
    		
    		this._super(this);
    		this.menu.menu({
    			focus: function( event, ui ) {
    				var item = ui.item.data( "ui-selectmenu-item" );
    				if(item) {
    					that.menuItems.eq( item.index ).focus();
    				}
    			}
    		}).css("font-size", this.buttonItem.css("font-size"));
    		
    		//the class to add to DropDown popup menu for css styling
			var wcMenuClass = this.options.wcMenuClass;
			if (wcMenuClass !== undefined && wcMenuClass !== null && wcMenuClass !== ''){
				this.menu.addClass(wcMenuClass);
			}
    	},
    	
    	_position: function() {
    		this._super(this);
    		this.reposition(this.menuWrap, this.button);
    	},
    	
    	//reposition the drop down menu if there's not enough space
    	reposition: function (menuWrap, button) {
    		//synchronize the z index of drop down menu and the button
    		this.menuWrap.css("z-index", 1000);
			
    		//reset menu height to auto
    		this.menu.css("height", "auto");
    		var menuHeight = menuWrap.height();
    		var disToTop = menuWrap.position().top - $(window).scrollTop();
    		var disToBottom = $(window).height() - disToTop;
    		if(disToTop > $(window).height()/2 && menuHeight > disToBottom) {
    			if(disToTop > menuHeight) {
    				//If there's enough space on top, align the menu to select button
    				this.menuWrap.css("top", menuWrap.position().top - menuHeight - button.outerHeight());
    			} else {
    				//Align the menu to window top
    				this.menuWrap.css("top", menuWrap.position().top - disToTop);
    				//adjust menu height accordingly
    				this.menu.css("height", disToTop - button.outerHeight());
    			}
    		} else if(menuHeight > disToBottom) {
    			//adjust menu height accordingly
    			this.menu.css("height", disToBottom);
    		}
        },
        
        _renderItem: function( ul, item ) {
        	this._super(ul, item);
        	
        	//pick up the value and style attributes from options
        	ul.children().last().attr("value", item.value);
        	ul.children().children().last().attr("style", item.element[0].style.cssText);

    		return ul.children().last();
    	},
    	
    	refresh_noResizeButton: function() {
    		this._refreshMenu();
			if($(this.element[0]).prop('selectedIndex') > -1) {
				this._setText( this.buttonItem, this._getSelectedItem().text() );
			}
    	}
        
    });

}(jQuery));