//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2007
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/**
 * @fileOverview This javascript is used in CachedTopCategoriesDisplay.jsp to display a scrolling thumbnail picker in the home page of Madisons starter store.
 * @version 1.0
 */

/* Import dojo classes */
dojo.provide("wc.widget.ScrollablePane");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dojo.parser");

/**
 *  The functions defined in this class enables initialisation of event listeners for ScrollablePane. Another set of functions act as callback when a key press or mouse click event occurs.
 *  @class The ScrollablePane widget displays a scrolling thumbnail picker that displays product images and details. It provides a scrolling effect for the items or images contained within the content of the widget.
 *  Each item within the scrollable pane should be in contained in a ContentPane widget. The scrollable pane supports both automatic and manual scrolling of the items displayed in the widget.
 */
dojo.declare("wc.widget.ScrollablePane",
    [dijit._Widget, dijit._Templated],
    {


        /* Identifier of the widget */
        identifier:null,
        /*Indicates the width, in pixels, of each scrollable item.*/
        itemSize: 135,

        /**
         * This flag indicates whether the scrollable pane scrolls automatically or manually.
         * When the value is true, the scrollable pane scrolls automatically. The default value is false.
         */
        autoScroll: false,

        /*Indicates the total number of items to show at one time. */
        totalDisplayNodes: 4,

        /*Indicates the button size, in pixels. */
        buttonSize: 45,
        /**
         * Indicates whether to display the thumbnails horizontally or vertically. When the value is true, the thumbnails are displayed horizontally.
         * When the value is false, the thumbnails are displayed vertically. The default value is true.
         */
        isHorizontal: true,

        /**
         * This indicates whether the scrollable pane is vertical or horizontal scrollable. Possible values are 'width' and 'height'.
         * If the value is 'width', then it is horizontal scrollable, else if the value is set to 'height', it is vertical scrollable.
         */
        sizeProperty: 'width',

        /* This is the total number of items in the queue. */
        totalItems: 0,

        /* This the current right item index after an animation. */
        last: 0,

        /* This the current left item index after an animation. */
        first:0,

        /* This is the left most item in the queue. */
        firstEnd:0,

        /* This is the right most item in the queue. */
        lastEnd:0,

        /* This is the locking variable which locks the animation. */
        lock:false,
        /**
         *  Indicates the direction of the scrolling animation. The acceptable values are -1 and 1. The default value is 1, where the animation scrolls to the left,
         *  and new products appear from the right when displayed horizontally. The animation scrolls up, and new products appear from the bottom when displayed vertically.
         */
        direction:-1,
        /*Indicates the delay time, in milliseconds, of the animation.*/
        delay:2000,

        /* This indicates the state of animation. */
        state: null,
        /* Indicates the scrolling direction. The acceptable values are -1 and 1. The default value is 1. */
        autoScrollDir: 1,

        /*The alternative (alt) text for the left button control. */
        altPrev: 'Scroll Left',

        /*The alternative (alt) text for the right button control. */
        altNext: 'Scroll Right',


        /* This is the template string for the widget. */
        templateString:"<div dojoAttachPoint=\"outerNode\" class=\"thumbOuter\">\r\n\t<div dojoAttachPoint=\"navPrev\" role=\"button\" tabindex=\"0\" class=\"navPrev\">\r\n\t\t<img src=\"${tempImgPath}\" dojoAttachPoint=\"navPrevImg\" alt=\"${altPrev}\"/>\r\n\t</div>\r\n\t<div dojoAttachPoint=\"thumbScroller\" class=\"thumbScroller\" valign=\"middle\">\r\n\t\t<div dojoAttachPoint=\"thumbsNode\" class=\"thumbsNode\"></div>\r\n\t</div>\r\n\t<div dojoAttachPoint=\"navNext\" tabindex=\"0\" role=\"button\" class=\"navNext\">\r\n\t\t<img src=\"${tempImgPath}\" dojoAttachPoint=\"navNextImg\" alt=\"${altNext}\"/>\r\n\t</div>\r\n</div>\r\n",


        /* This is the image path for the widget images. */
        tempImgPath: "/wcsstore/dojo110/wc/widget/images/trasparent.gif",

        /**
         * This flag indicates whether the arrows in the scrollable pane should be hidden automatically when scrolling is disabled
         * (ie: When all items can fit into the scrollable pane without overflow)
         * When the value is true, the arrows will hide automatically when they are not enabled. The default value is false.
         */
        hideArrows: false,

        /**
         * This flag indicates whether the scrollable pane size should be adjusted when there are less than the totalDisplayNodes item to list.
         * When the value is true, the scrollable pane will shorten to avoid showing a lot of white space.
         */
        adjustPaneSize: false,

        /**
         * This flag indicates whether to ignore the Internet Explorer specific layout adjustments.
         * When the value is true, the layout adjustments for Internet Explorer will be ignored.
         */
        skipIECorrection: false,

        /**
         * Indicates if the list should be scrolled page by page instead of item by item.
         * The default value is set to false.
         */
        scrollByPage: false,

        /**
         * Indicates if the list should loop to the beginning immediately in the same view when scrolling reaches the end of the list.
         * The default value is set to false. If true, the last scroll view will only contain the last set of items, the next scroll view
         * will start from the beginning of the list.
         */
        loopItems: true,

        /**
         *  This method enables horizontal scrolling of the Scrollable pane widget
         *  @param {array} args The array containing the node to scroll horizontally.
         *
         *  @return {object} returns animation of type dojo._Animation.
         */
        scrollHorizontal: function(args) {

            var node = (args.node = dojo.byId(args.node));

            var left = null;

            var init = (function(n) {
                return function() {
                    var cs = dojo.getComputedStyle(n);
                    var pos = cs.position;
                    left = (pos == 'absolute' ? n.offsetLeft : parseInt(cs.left) || 0);
                    if (pos != 'absolute' && pos != 'relative') {
                        var ret = dojo.coords(n, true);

                        left = ret.x;
                        n.style.position = "absolute";

                    }
                };
            })(node);
            init();

            var anim = dojo.animateProperty(dojo.mixin({
                properties: {
                    left: { end: args.left || 0 }
                }
            }, args));
            dojo.connect(anim, "beforeBegin", anim, init);

		return anim; /* dojo._Animation */
	},
	
	/**
	 *  This method enables vertical scrolling of the Scrollable pane widget.
	 *  @param {array} args The array containing the node to scroll vertically.
	 *  
	 *  @return {object} returns animation of type dojo._Animation.
	 */
	scrollVertical: function(args){
		
		var node = (args.node = dojo.byId(args.node));
		
		var top = null;
		var left = 0;
		
		var init = (function(n){
			return function(){
				var cs = dojo.getComputedStyle(n);
				var pos = cs.position;
				top = (pos == 'absolute' ? n.offsetTop : parseInt(cs.top) || 0);
				
				if(pos != 'absolute' && pos != 'relative'){
					var ret = dojo.coords(n, true);
					top = ret.y;
					
					n.style.position="absolute";
					
					n.style.left=left+"px";
				}
			};
		})(node);
		init();

            var anim = dojo.animateProperty(dojo.mixin({
                properties: {
                    top: { end: args.top || 0 }

                }
            }, args));
            dojo.connect(anim, "beforeBegin", anim, init);

		return anim; /* dojo._Animation */
	},

        /**
         * Reference implementation of dijit.layout.ContentPane.
         * Overrides Widget.buildRendering().
         * Declare container node to annouce that this is a container widget
         * to make getDescendants() work.
         */
        buildRendering: function() {
            this.inherited(arguments);
            if (!this.containerNode) {
                this.containerNode = this.domNode;
            }
        },

        /**
         *  This functions initialises styles and listeners.
         */
        postCreate: function() {

            this.widgetid = this.id;
            this.inherited("postCreate", arguments);
            var ieCurrection = 0;
            if (dojo.isIE <= 6 && !this.skipIECorrection) ieCurrection = 15;


            var outerNodeSize = (this.itemSize * this.totalDisplayNodes) + this.buttonSize;

            console.log("postCreate: itemSize = " + this.itemSize);

            this.scrollerSize = this.itemSize * this.totalDisplayNodes;

            this.sizeProperty = this.isHorizontal ? "width" : "height";

            dojo.style(this.outerNode, "textAlign", "center");

            this.init();

            //below code is used to adjust the location of scroll elements under different condition
            if(this.isHorizontal) {
            	dojo.style(this.outerNode, "width", outerNodeSize + "px");
            	dojo.style(this.thumbScroller, "width", this.scrollerSize - ieCurrection + "px");
            } else {
            	dojo.style(this.outerNode, "width", this.thumbScroller.clientWidth + this.navPrev.clientWidth + 30 + "px");
				// scroll pane for productRecommendation need to adjust separately
				if(dojo.query("div[id^='prod_']",this.thumbScroller).length>0)
					dojo.style(this.thumbScroller, "width", this.scrollerSize - ieCurrection + "px");
            }
            //below code is used to adjust the location of scroll elements under different condition
            if (!this.hideArrows) {
				dojo.style(this.navNext, "position", "relative");

				// scroll pane for productRecommendation need to adjust separately
				if(dojo.query("div[id^='prod_']",this.thumbScroller).length>0) {
					dojo.style(this.thumbScroller, "float", "left");
					dojo.style(this.navPrev, "marginTop", (this.thumbScroller.clientHeight/2 - this.navPrev.clientHeight) + "px");
					//dojo.style(this.navNext, "marginTop", 0-(this.thumbScroller.clientHeight + this.navNext.clientHeight)/2 + "px");				

				} else{
					dojo.style(this.navPrev, "marginTop", (this.thumbScroller.clientHeight - this.navPrev.clientHeight)/2 + "px");
					dojo.style(this.navNext, "marginTop", 0-(this.thumbScroller.clientHeight + this.navNext.clientHeight)/2 + "px");				
					dojo.style(this.navNext, "marginRight", (0-10-this.navNext.clientWidth) + "px");
					dojo.style(this.thumbScroller, "padding", "0");
				}
            } else{
				// scroll pane for productRecommendation need to adjust separately
				if(dojo.query("div[id^='prod_']",this.thumbScroller).length>0) {
				//dojo.style(this.thumbScroller, "float", "left");
				//dojo.style(this.navPrev, "marginTop", (this.thumbScroller.clientHeight/2 - this.navPrev.clientHeight) + "px");
				dojo.style(this.navNext, "marginTop", 0-(this.thumbScroller.clientHeight/2 + this.navNext.clientHeight) + "px");
				dojo.style(this.navNext, "marginRight", (0-10-this.navNext.clientWidth) + "px");

            }            	
            }
        },

        /**
         *  This function creates DOM nodes for thumbnail images and initializes their listeners.
         */
        init: function() {

            dojo.connect(this.navNext, "onclick", this, "prev");
            dojo.connect(this.navPrev, "onclick", this, "next");

            dojo.connect(this.navNext, "onkeypress", this, function(event) {
                if (event.type == "keypress") {
                    if (event.keyCode == 13) {
                        this.prev();
                    }
                }
            });
            dojo.connect(this.navPrev, "onkeypress", this, function(event) {
                if (event.type == "keypress") {
                    if (event.keyCode == 13) {
                        this.next();
                    }
                }
            });

            dojo.connect(this.thumbScroller, "onmouseover", this, "pause");
            dojo.connect(this.thumbScroller, "onmouseout", this, "play");

            var items = this.setDataStore("dijit.layout.ContentPane");
            this.items = items;
            this.totalItems = items.length;
            this.appendItems(this.items);
            if(this.isHorizontal) {
            	dojo.style(this.thumbsNode, this.sizeProperty, this.itemSize * (this.totalItems) + "px");
            } else {
	    	// scroll pane for productRecommendation need to adjust separately
            	if(dojo.query("div[id^='prod_']",this.thumbsNode).length>0) {
            		dojo.style(this.thumbsNode, "width", this.itemSize * (this.totalItems) + "px");
            	}
            }

            this.first = 0;
            this.last = this.totalDisplayNodes - 1;
            if (this.totalItems < this.totalDisplayNodes) this.last = this.totalItems - 1;

            this.firstEnd = 0;
            this.lastEnd = this.totalItems - 1;

            console.debug("ScrollablePane: init: items.length = " + items.length);
            if (this.autoScroll)
                this.autoScroller();

            //below code is used to adjust the location of scroll elements under different condition
            if (this.hideArrows || this.totalItems <= this.totalDisplayNodes) {
                dojo.style(this.navPrev, "display", "none");
                dojo.style(this.navNext, "display", "none");

				if(dojo.query("div[id^='contrec']",this.outerNode).length>0)
					dojo.style(this.outerNode, "marginLeft", "0px");

            }

            if (this.adjustPaneSize && this.totalItems <= this.totalDisplayNodes && !this.isHorizontal) {
                var ieCorrection = 0;
                if (dojo.isIE <= 6) {
                    ieCorrection = 5;
                }

                if (this.hideArrows) {
                    var outerNodeSize = this.itemSize * this.totalItems;
                    this.scrollerSize = this.itemSize * this.totalItems;
                } else {
                    var outerNodeSize = this.itemSize * this.totalItems + this.buttonSize;
                    this.scrollerSize = this.itemSize * this.totalItems;
                }
                dojo.style(this.outerNode, this.sizeProperty, (outerNodeSize + ieCorrection) + "px");
                dojo.style(this.thumbScroller, this.sizeProperty, (this.scrollerSize + ieCorrection) + "px");
            }

            if (this.totalItems > this.totalDisplayNodes && !this.loopItems) {
                var extraItems = this.totalItems % this.totalDisplayNodes;

                if (extraItems != 0) {
                    var difference = this.totalDisplayNodes - extraItems;

                    for (var i = 0; i < difference; i++) {
                        var emptyDiv = document.createElement('div');
                        emptyDiv.id = "empty_div_" + i;
                        emptyDiv.className = "imgContainer";
                        emptyDiv.innerHTML = "";

                        (this.items).push(emptyDiv);
                        this.loadImage(this.removeTabIndex(emptyDiv), 1);
                    }
                    this.totalItems = this.items.length;
                    this.lastEnd = this.totalItems - 1;
                }
            }

            return true;
        },

        /**
         *  This function will take the nodetype as parameter and returns all the nodes in the scroll area with that node type.
         *  @param {string} nodeType The type of the node to be retrieved.
         *
         *  @return {array} All the nodes of the specified node type.
         */
        setDataStore: function(nodeType) {
            var nodes = dojo.query("[dojoType=" + nodeType + "]", this.srcNodeRef);
            return nodes;
        },

        /**
         * This function removes HTML attribute tabindex for an item in the scrollable area.
         * The tabIndex is removed for items which are hidden. These items should not be accessible via the keyboard.
         * It will remove tabindex for all the children in that item and returns the item.
         *
         * @param {string} item The item for which tabindex should be removed.
         *
         * @return {string} The item after removing the tabindex.
         */
        removeTabIndex: function(item) {
            var a = item.getElementsByTagName('a');
            var p = item.getElementsByTagName('p');
            for (var x = 0; x + 1 <= a.length; x++) {
                a[x].setAttribute('tabIndex', -1);
            }
            for (var x = 0; x + 1 <= p.length; x++) {
                p[x].setAttribute('tabIndex', -1);
            }
            return item;
        },

        /**
         * This function adds HTML attribute tabindex for an item in the scrollable area.
         * The tabIndex is added for items which are displayed. These items should be accessible via the keyboard.
         * It will add tabindex for all the children in that item and returns the item.
         *
         * @param {string} item The item for which tabindex should be added.
         *
         * @return {string} The item after adding the tabindex.
         */

        addTabIndex: function(item) {
            var a = item.getElementsByTagName('a');
            var p = item.getElementsByTagName('p');
            for (var x = 0; x + 1 <= a.length; x++) {
                a[x].setAttribute('tabIndex', 0);
            }
            for (var x = 0; x + 1 <= p.length; x++) {
                p[x].setAttribute('tabIndex', 0);
            }
            return item;
        },

        /**
         *  This method is used to append the items to the scrollable node on the initial load of the scrollable area.
         */
        appendItems: function(items) {

            for (var i = 0; i < items.length; i++) {
                if (i >= this.totalDisplayNodes) {
                    this.loadImage(this.removeTabIndex(items[i]), 1);
                }
                else {
                    this.loadImage(this.addTabIndex(items[i]), 1);
                }
            }
        },

        /**
         * This function modifies the DOM structure of the node by appending or inserting the given DOM element.
         * If the input flag is 1, then the DOM element is appended at the end of the node.
         * If the input flag is -1, then the element is inserted at the beginning of the node.
         * @param {Object} data The DOM element to modify.
         * @param {Integer} flag A flag that indicates if the element should be appended or inserted.
         */
        loadImage: function(data, flag) {
            console.log("ScrollablePane: loadImage: position = " + flag);
            if (flag == 1)
                this.thumbsNode.appendChild(data);
            else this.thumbsNode.insertBefore(data, this.thumbsNode.firstChild);
        },

        /**
         *  This function is used internally to start or restart the animation after direction changes.
         */
        play: function() {

            this.autoScroll = this.state;
            if (this.autoScroll)
                this.autoScroller();

        },

        /**
         *  This method is used internally to pause the animation while switching the directions.
         */
        pause: function() {

            this.state = this.autoScroll;
            this.autoScroll = false;
        },

        /**
         *  This method gives the auto scroll effect. This method will call prev or next methods based
         *  on the direction and will keep auto scrolling.
         */
        autoScroller: function() {

            if (this.autoScrollDir == 1)this.next();
            else this.prev();

        },

        /**
         *  This method will set the direction of the scroll and then calls showThumbs method to scroll the right side items.
         */
        next: function() {

            this.autoScrollDir = 1;
            if (!this.lock) {
                this.lock = true;

                /* summary: Displays the next page of images */
                this.showThumbs(1);
            }
        },

        /**
         *  This method will set the direction of the scroll and then calls showThumbs method to scroll the left side items.
         */
        prev: function() {

            this.autoScrollDir = -1;
            if (!this.lock) {
                this.lock = true;

                /*Displays the next page of images. */
                this.showThumbs(-1);
            }
        },

        /**
         *  This method will adjust the left nodes after an animation. This method will remove the hidden nodes from the right and adds them to leftmost position.
         */
        adjustPrevScroll: function() {

            var i = this.firstEnd;
            while (i != this.first) {
                this.thumbsNode.removeChild(this.thumbsNode.firstChild);
                this.loadImage(this.items[i], 1);
                this.lastEnd = i;
                i = i + 1;
                if (i >= this.totalItems) i = 0;
            }
            this.direction = -1;
            this.firstEnd = this.first;
            if (this.isHorizontal) this.thumbsNode.style.left = 0 + 'px';
            else this.thumbsNode.style.top = 0 + 'px';
        },

        /**
         *  This method will adjust the right nodes after an animation. This method will remove the hidden nodes from the left and adds them to rightmost position.
         */

        adjustNextScroll: function() {

            var adjust = (((this.totalItems) - this.totalDisplayNodes) * (this.itemSize) * -1);

            var i = this.lastEnd;
            while (i != this.last) {
                this.thumbsNode.removeChild(this.thumbsNode.lastChild);
                this.loadImage(this.items[i], -1);
                this.firstEnd = i;
                i = i - 1;
                if (i < 0) i = this.totalItems - 1;
            }
            this.direction = 1;
            this.lastEnd = this.last;
            if (this.isHorizontal) this.thumbsNode.style.left = adjust + 'px';
            else this.thumbsNode.style.top = adjust + 'px';
        },

        /**
         * This method will animate the items with given delay and will scale the items in the given direction.
         * @param {boolean} idx Flag to determine the scrolling direction.
         */
        showThumbs: function(idx) {

            if (this.totalItems > this.totalDisplayNodes) {
                if (idx == 1) {
                    if (this.direction != 1) this.adjustNextScroll();
                    var adjust = (((this.totalItems) - this.totalDisplayNodes) * (this.itemSize) * -1);
                    var slideSize = adjust + this.itemSize;
                    if (this.scrollByPage) {
                        slideSize = adjust + (this.itemSize * this.totalDisplayNodes);
                    }

                    if (this.isHorizontal) slideNext = this.scrollHorizontal({node: this.thumbsNode ,duration: this.delay, left: slideSize });
                    else slideNext = this.scrollVertical({node: this.thumbsNode ,duration: this.delay, top: slideSize });

                    slideNext.play();
                    dojo.connect(slideNext, "onEnd", this, this.nextConnect);
                }
                else {
                    if (this.direction != -1) this.adjustPrevScroll();
                    var slideSize = - this.itemSize;
                    if (this.scrollByPage) {
                        slideSize = - (this.itemSize * this.totalDisplayNodes);
                    }
                    if (this.isHorizontal) slidePrev = this.scrollHorizontal({node: this.thumbsNode ,duration: this.delay, left: slideSize });
                    else slidePrev = this.scrollVertical({node: this.thumbsNode ,duration: this.delay, top: slideSize });

                    slidePrev.play();
                    dojo.connect(slidePrev, "onEnd", this, this.prevConnect);
                }
            }

        },
        /**
         * This method performs the post operations for this.next() function.
         * It is invoked at the "onEnd" event.
         */
        nextConnect: function() {
            if (this.scrollByPage) {
                var i = this.totalDisplayNodes;
                while (i != 0) {
                    this.nextItemDisplayProcessor();
                    i = i - 1;
                }
            } else {
                this.nextItemDisplayProcessor();
            }

            this.lock = false;
            if (this.autoScroll) this.autoScroller();
        },

        /**
         * Processes the next item to display by removing the current last item from the node and inserting it at the beginning of the node.
         * Updates the tab indices of the items in the display area.
         * Updates the indices that are used to keep track of item positions.
         */
        nextItemDisplayProcessor: function() {
            this.thumbsNode.removeChild(this.thumbsNode.lastChild);

            var adjust = ((this.totalItems - this.totalDisplayNodes) * (this.itemSize) * -1);

            if (this.isHorizontal) this.thumbsNode.style.left = adjust + 'px';
            else this.thumbsNode.style.top = adjust + 'px';

            this.loadImage(this.removeTabIndex(this.items[this.last]), -1);
            this.addTabIndex(this.thumbsNode.childNodes[this.totalItems - this.totalDisplayNodes]);
            this.first = this.first - 1;
            if (this.first < 0) this.first = this.totalItems - 1;
            this.firstEnd = this.last;
            this.last = this.last - 1;
            if (this.last < 0) this.last = this.totalItems - 1;
            this.lastEnd = this.last;
        },

        /**
         * This method will perform the post operations for this.prev() function.
         * It is invoked at the "onEnd" event.
         */
        prevConnect: function() {
            if (this.scrollByPage) {
                var i = this.totalDisplayNodes;
                while (i != 0) {
                    this.prevItemDisplayProcessor();
                    i = i - 1;
                }
            } else {
                this.prevItemDisplayProcessor();
            }

            this.lock = false;
            if (this.autoScroll) this.autoScroller();
        },

        /**
         * Processes the previous item to display by removing the current first item from the node and appending it at the end of the node.
         * Updates the tab indices of the items in the display area.
         * Updates the indices that are used to keep track of item positions.
         */
        prevItemDisplayProcessor:function() {
            this.thumbsNode.removeChild(this.thumbsNode.childNodes[0]);

            if (this.isHorizontal) this.thumbsNode.style.left = 0 + 'px';
            else this.thumbsNode.style.top = 0 + 'px';

            this.loadImage(this.removeTabIndex(this.items[this.first]), 1);
            this.addTabIndex(this.thumbsNode.childNodes[this.totalDisplayNodes - 1]);
            this.lastEnd = this.first;
            this.first = this.first + 1;
            if (this.first >= this.totalItems) this.first = 0;
            this.firstEnd = this.first;
            this.last = this.last + 1;
            if (this.last >= this.totalItems) this.last = 0;
        }
    });