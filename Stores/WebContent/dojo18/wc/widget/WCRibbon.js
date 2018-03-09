//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide('wc.widget.WCRibbon');
dojo.provide('wc.widget.WCRibbonSlide');
dojo.provide('wc.widget.WCRibbonItem');
dojo.provide('wc.widget.WCRibbonItemAbstract');
dojo.provide('wc.widget.WCRibbonLeadspace');

dojo.declare('wc.widget.WCRibbon', [dijit._Widget, dijit._Templated], {

    // number of columns (used for adding items)
    columns: 3,

    // automatic scrolling on or off
    autoscroll: false,
    freeScroll: false,

    // scroll interval
    interval: 9000,
    leadNoHomeInterval: 10000,
    // interval function
    _interval: null,
    _intervalHandlers: {
        resize: null,
        onmouseleave: null,
        onmouseenter: null
    },

    // how many times should do the whole ribbon automatically rotate until it stops
    // 0 = infinite, will rotate for ever..
    rotationCount: 1,
    // internal temporary variable related to rotationCount
    _rotationCount: 0,

    // default duration of slide
    defaultDuration: 500,

    // if this ribbon is currently being animated
    _isBeingAnimated: false,

    _isBegingAutoscroll: false,
    _isLeadSpace: false,
    _isLeadNoHome: false,

    // Show or hide side scrolling arrows
    arrows: false,
    // choose slide image type
    imageType: 'thumbnail',

    // Thumbnail height and width.  Change this to desired thumbnail size
    tWidth: '39px',
    tHeight: '29px',
    // Store slide image URLs so they can be used and shrunk for thumbnails
    imageMap: null,

    /*
     * Following member variables created automatically based on dojoAttachPoint
     * this.scrollableNode - node that contains scrollable slides
     * this.scrollLeftButton - scroll left button
     * this.scrollRightButton - scroll right button
     * this.navNode - node that contains navigation dots
     */

    // template for the ribbon
	templateString : "<div class='ibm-container-body' dojoAttachPoint='ribbonContainer'>" +
        "<a class='ibm-ribbon-prev' dojoAttachPoint='scrollLeftButton' role='button' href='#' alt=''><div class='ibm-ribbon-prev-arrow-value'>&lt;</div></a>" +
        "<div class='ibm-ribbon-pane' dojoAttachPoint='scrollContainer'>" +
        "<div class='ibm-ribbon-section' dojoAttachPoint='scrollableNode'></div>" +
        "</div>" +
        "<a class='ibm-ribbon-next' dojoAttachPoint='scrollRightButton' role='button' href='#' alt=''><div class='ibm-ribbon-next-arrow-value'>&gt;</div></a>" +
        "<div class='ibm-ribbon-nav' dojoAttachPoint='navNode'></div>" +
        "</div>",
	
    /*
     * Constructor. Keeps the copy of original node if exist
     */
    constructor: function(param) {
        // these variables must be created here to make sure that these variables are not shared with objects

        // slides in the ribbon 
        this.slides = [];

        // current entry in slider
        this.currentSlideIndex = 0;

        // keeps a reference to original node if passed in constructor
        this.originalNode = null;

        // set slide duration to default
        this.duration = this.defaultDuration;

        // duration copy needed to reset slides 
        this._durationCopy = this.duration;

        // if the srcNodeRef is specified keep the reference to it as original node
        !!param && param.srcNodeRef && (this.originalNode = param.srcNodeRef);

        !!param && param.imageMap && (this.imageMap = param.imageMap);
	// flag to enable arrows scroll buttons
	this.arrows = param.arrows;
	// parm to set slide image type
	this.imageType = param.imageType;
    },

    /*
     * If the original node exist, create respective slides and items in ribbon
     */
    postCreate: function() {
        var self = this;
        // if the original node exist, based on that create slides and items
        // loop through the ibm-columns and for each column create a slide and add items to it
        if (self.originalNode) {

            dojo.query('.ibm-columns', this.originalNode).forEach(function(column, index) {
                // if this column does have an id, it would be great to store it and re-set later
                // otherwise it gets disappeared and we end up with something like id="wc.widget_ribbonSlide_0" etc..
                var preservedId = null;
                if (column.id) {
                    preservedId = column.id;
                }

                // loop over all childs
                dojo.query('> *', column).forEach(function(item, j) {
                    self.addItem(new wc.widget.WCRibbonItemAbstract({srcNodeRef:item}), index, preservedId);
                });

            });

            // preserve ID
            if (self.originalNode.id) {
                self.domNode.id = self.originalNode.id;
            }
        }

        if (this._isLeadSpace && !this.checkHome()) {
            this._isLeadNoHome = true;
            this.autoscroll = true;
            this.interval = this.leadNoHomeInterval;
        }
    },

    /*
     * Function called to start the parsing & initializing
     */
    startup: function() {

        /* Ribbon disable height calculation if class "ibm-ribbon-fixed" is present
         * desc: in case you have dynamic content - flash, or dynamic fonts inside ribbon slide, that is rendered after ribbon startup function, then height is calculated incorrectly.
         */
        if (!dojo.hasClass(this.ribbonContainer.parentNode, 'ibm-ribbon-fixed')) {
            // issue is that unless .swf is loaded, firefox will say this elements height and width is 0px
            var temp = dojo.coords(this.scrollableNode).h;
            // look for <object> inside this scrollableNode
            var ob = dojo.query('object', this.id);
            if (ob.length > 0) {
                var max = 0;

                // loop through them and determine which one's height="" attribute has highest number
                ob.forEach(function(i) {
                    if (i.height) {
                        if (i.height > max) {
                            max = i.height;
                        }
                    }
                });

                // apply this highest number if it's higher than the one calculated by browser
                if (max > temp) {
                    temp = max;
                }
            }

            // To set height of ribbon scrollable content on startup
            dojo.style(this.scrollContainer, 'height', temp + 'px');
        }
        // -50 px to make 2 scroll buttons at same height
        dojo.style(this.scrollLeftButton, { marginTop : (dojo.coords(this.scrollContainer).h / 2) -50 + 48 + 'px' });
        dojo.style(this.scrollRightButton, { marginTop : '-' + ((dojo.coords(this.scrollContainer).h) / 2 ) -50 - 48 + 'px' });


        // disable left scroll button
        dojo.addClass(this.scrollLeftButton, "ibm-disabled");
        if (!this.arrows) {
            dojo.addClass(this.scrollRightButton, "ibm-disabled");
        }

        if (this.slideCount() <= 1) {
            dojo.addClass(this.scrollRightButton, "ibm-disabled");
            dojo.query(this.navNode).orphan();
        } else {
            // make first navigation dot active
            if (this.imageType == 'dot')
                dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']")[0].className ='ibm-ribbon-dot ibm-ribbon-dot-active';
            else if(this.imageType == 'number')
                dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-numberButton']")[0].className ='ibm-ribbon-number ibm-ribbon-number-active';
            dojo.query(':first-child', this.navNode).addClass("ibm-active");

            // bind event handlers
            dojo.connect(this.scrollLeftButton, "onclick", dojo.hitch(this, this.slideLeft));
            dojo.connect(this.scrollRightButton, "onclick", dojo.hitch(this, this.slideRight));
        }

        if (this.autoscroll) {
            // this ribbon should automatically scroll after certain *interval*
            // part of autoscroll is additional animation option for sliding from last slide, to first one.
            // lets say there are 3 slides. If we are on third slide and we manually click to go to first one, it will just go back left.
            // but during autoscroll, we want to go smoothly to right, creating impression of 1st sliding being somehow 4th..
            // to do that, we have to do many things, but first is to clone 1st slide and place after 4th..
            if (!this._isLeadNoHome) {
                var firstLead = this.slides[0].domNode,
                    clonedFirstLead = dojo.clone(firstLead);

                // adjust classes
                dojo.addClass(clonedFirstLead, 'ibm-cloned');

                //remove duplicate id's from the cloned slide and will restored later
                dojo.removeAttr(clonedFirstLead, "id");
                //var clonedWidgetId=dojo.query("div",clonedFirstLead).attr("id");
                dojo.query("div", clonedFirstLead).removeAttr("id");


                // and place it into content
                dojo.place(clonedFirstLead, this.scrollableNode);
            }

            // reference to 'this' object
            var self = this;

            // let's create variable for holding interval object - this will be later clearedOut once mouse moves over this widget
            // and then again re-enabled when moved out..
            this._interval = setInterval(function() {
                self.next();
            }, this.interval);

            if (!this.freeScroll) {
                // if user moves mouse over ribbon area, we should disable interval - it should not circle on its own, give control to user
                this._intervalHandlers.onmouseenter = dojo.connect(this.domNode, 'onmouseenter', dojo.hitch(this, function() {
                    clearInterval(this._interval);
                }));

                // when user moves out of ribbon area, we should enable interval again
                this._intervalHandlers.onmouseleave = dojo.connect(this.domNode, 'onmouseleave', dojo.hitch(this, function() {
                    clearInterval(this._interval);
                    this._interval = setInterval(function() {
                        self.next();
                    }, this.interval);
                }));

                // also, make sure we do not autoscroll while resizing window, it looks very ugly
                this._intervalHandlers.resize = dojo.connect(window, 'resize', dojo.hitch(this, function() {
                    clearInterval(this._interval);
                }));
            }
        }

        // add support for iPad swipe
        /*
         note: when testing on iOS Simulator / Ipad directly, please note that console.log('string: ', var);
         doesn't work in Developer console.
         You have to use it the same way as alert() function, so console.log('string: ' + var );
         */
        // iPad support (actually: iDevice support, as it also works for iPhone and iPod)
        this.iDevice = /iPad|iPhone|iPod/i.test(navigator.userAgent);
        this.android = navigator.userAgent.toLowerCase().indexOf("android") > -1;

        if (this.iDevice || this.android) {
            var swipeStart = 0;

            // when user touches the screen, we need to store position of his finger
            this.domNode.ontouchstart = function(e) {
                // we have to use preventDefault, otherwise screen would move with us, not just ribbon
                swipeStart = e.touches[0].clientX;
            }

            // when he moves the finger on the screen, we have to decide - is he making a gesture, or just trying to click on a link?
            this.domNode.ontouchmove = function(e) {
                e.preventDefault();
            }

            this.domNode.ontouchend = dojo.hitch(this, function(e) {
                swipeEnd = e.changedTouches[0].clientX;
                var diff = swipeEnd - swipeStart;

                // if diff is less then 0 it means we are going right. Otherwise slide left
                if (diff < 0) {
                    this.slideRight();
                } else if (diff > 0) {
                    this.slideLeft();
                }
            });
        }

        // call startup on all child elements
        dojo.forEach(this.slides, function(w) {
            if (w && !w._started && w.startup) {
                w.startup();
            }
        });

        this.inherited(arguments);
    },

    /*
     * Adds slide to the ribbon
     */
    addSlide: function(slide) {
        // add reference of slide in slides array
        this.slides.push(slide);

        // place the slide in dom node
        dojo.place(slide.domNode, this.scrollableNode);
        if (!this.scrollableNode.id) {
            this.scrollableNode.id = this.ribbonContainer.id + '_scrollable';
        }
        var carouselAnk = dojo.create("a", {
            href:"#",
            innerHTML: '',
            'role': 'button',
            'aria-labelledby': 'thumbNailButton-' + this.slides.length,
            'IbmCarouselIndex': this.slides.length - 1,
            'dojoAttachPoint': 'ibm-ribbon-carouselAnk'
        }, this.navNode);
	// resize the clicking spot based on image type
	if (typeof RotatingContentJS == "undefined"){
		this.imageType = "thumbnail";
		this.tWidth = "94px";
		this.tHeight = "39px";
	}
        if (this.imageType == "thumbnail") {
            dojo.attr(carouselAnk, {style:{width: this.tWidth, height: this.tHeight}});
        } else if (this.imageType == "number") {
            dojo.attr(carouselAnk, {style:{width: '40px', height: '29px', border: '0px'}});
        } else if (this.imageType == "dot") {
            dojo.attr(carouselAnk, {style:{width: '25px', height: '25px', border: '0px'}});
	}
        
        // add navigation dot to access this slide and add event handler
        dojo.connect(carouselAnk, "onclick", dojo.hitch(this, function(event) {
            // get current carousel index
            if (dojo.hasClass(event.target, 'ibm-ribbon-view')) {
                slideToIdx = dojo.attr(event.target.parentNode, "IbmCarouselIndex") * 1;
            }
            else {
                slideToIdx = dojo.attr(event.target, 'IbmCarouselIndex') * 1;
            }
            this.slideTo(slideToIdx, event);
            this.stopSlideShow();
        }));
        // insert different element to clicking spot base on image type
        var thumbnailLink;
        if (this.imageType == "thumbnail") {
            thumbnailLink = dojo.create("img", {src: this.imageMap[this.slides.length], 'IbmCarouselIndex': this.slides.length - 1, 'alt':""}, carouselAnk);
            dojo.attr(thumbnailLink, {style:{width: this.tWidth, height: this.tHeight}});
        } else if (this.imageType == "number") {
            thumbnailLink = dojo.create("div", {innerHTML: this.slides.length, 'dojoAttachPoint': 'ibm-ribbon-numberButton', 'IbmCarouselIndex': this.slides.length - 1, 'alt':""}, carouselAnk);
            thumbnailLink.style.fontSize='14px';
	    thumbnailLink.style.padding = '0px 8px 0 0';
        } else if (this.imageType == "dot") {
            thumbnailLink = dojo.create("div", {'dojoAttachPoint': 'ibm-ribbon-dotImageButton', 'IbmCarouselIndex': this.slides.length - 1, 'alt':""}, carouselAnk);
        }

	if (thumbnailLink != undefined ) {
        dojo.connect(thumbnailLink, "onclick", dojo.hitch(this, function(event) {
            // get current carousel index
            if (dojo.hasClass(event.target, 'ibm-ribbon-view')) {
                slideToIdx = dojo.attr(event.target.parentNode, "IbmCarouselIndex") * 1;
            } else {
                slideToIdx = dojo.attr(event.target, 'IbmCarouselIndex') * 1;
            }
            this.slideTo(slideToIdx, event);
            this.stopSlideShow();
        }));
	}



        dojo.connect(carouselAnk, "keypress", dojo.hitch(this, function(event) {
            // Stop scrolling
            if (event.keyCode == dojo.keys.TAB && !event.shiftKey) {
                if (!!event.target.nextSibling) {
                    dojo.stopEvent(event);
                    event.target.nextSibling.focus();
                }
            }
            if (event.keyCode == dojo.keys.TAB && event.shiftKey) {
                if (!!event.target.previousSibling) {
                    dojo.stopEvent(event);
                    event.target.previousSibling.focus();
                } else {
                    dojo.stopEvent(event);
                    if (dojo.attr(event.target, 'IbmCarouselIndex') * 1 == 0) {
                        dojo.byId('slideLink-' + (this.currentSlideIndex + 1)).focus();
                    }
                }
            }
            if (event.keyCode == dojo.keys.ENTER || event.keyCode == dojo.keys.SPACE || event.keyCode == 0) {
                // get current carousel index
                slideToIdx = dojo.attr(event.target, 'IbmCarouselIndex') * 1;
                this.slideTo(slideToIdx, event);
                this.stopSlideShow();
            }

        }));

        // return the slide
        return slide;
    },

    /*
     * focus() div with aria-role='document' to read text inside with JAWS
     */
    _focusSlideContent: function(slideToIdx, sIdxDiff) {
        // note:
        var timer = setTimeout(dojo.hitch(this, function() {
            clearTimeout(timer);
        }), (!dojo.isIE || dojo.isIE < 8) ? this._durationCopy * sIdxDiff : this._durationCopy * sIdxDiff * 2); // sIdxDiff - leadspace/Homepage ribbon animation fix
    },

    /*
     * Adds a new item to the given slide. If the given slide does not exist, new slide will be created
     * if and only if the slide number given is equal to total slides + 1
     */
    addItem: function(item, slideIndex, preservedId) {

        // if index is not a valid index, add a new slide
        if (slideIndex == undefined || slideIndex < 0 || slideIndex >= this.slides.length) {
            // user requested a special slide?
            if (slideIndex && slideIndex >= this.slides.length) {
                this.addSlide(new wc.widget.WCRibbonSlide({ pid: preservedId }));
            }
            // fill the slides up automatically based on ibmweb.columns
            if (!slideIndex && (this.slides.length == 0 || this.slides[this.slides.length - 1].getChildren().length == this.columns)) {
                this.addSlide(new wc.widget.WCRibbonSlide({ pid: preservedId }));
            }
            slideIndex = this.slides.length - 1;
        }
        // add item to the slide
        this.slides[slideIndex].addChild(item);

        // return the item
        return item;
    },

    /* to check if the ribbon is in leadspace section */
    checkHome: function() {
        if (dojo.attr(this.ribbonContainer.parentNode, 'id') == 'ibm-leadspace-head' && dojo.query('.ibm-home-page').length > 0) {
            return 1;
        }
        return 0;
    },

    /*
     * Slide to given entry, which is smoothly scrolled to
     * and then displayed.
     */
    slideTo: function(slideToIndex, event, isCloned) {
        // if event object is passed stop the propagation of event. 
        event && dojo.stopEvent(event);

        slideToIndex = parseInt(slideToIndex, 10);

        // if slideTo is less than zero or greater than total slides or equal to current slide do nothing
        if (slideToIndex < 0 || slideToIndex >= this.slides.length || slideToIndex == this.currentSlideIndex) {
            if (event && !this.autoscroll) {
                this._focusSlideContent(slideToIndex, sIndexDiff);
            }
            return;
        }

        // calculate scroll width. Nothing but a width of first item
        var scrollWidth = dojo.coords(dojo.query('> *', this.scrollableNode)[0]).w;
        // if is cloned and ribbon not in homepage
        if (isCloned && !this.checkHome() && !this._isLeadNoHome) {
            //slide index is reset to first
            slideToIndex = 0;

            // cloned slide is animated only once just to keep the slide right animation happen infinitely
            dojo.animateProperty({
                node: this.scrollableNode,
                duration: this._durationCopy,
                properties: { left: scrollWidth * (this.slideCount() - 1) * -1 }
            }).play();
        }

        /*
         allow developers to user their own animation script
         */
        if (this.customSeekAnimation) {
            if (this._isBeingAnimated) {
                return;
            }

            this._isBeingAnimated = true;
            this.customSeekAnimation(scrollWidth, slideToIndex, isCloned);
            // fake slideToIndex, we need ribbon to think we have just slided to 1st slide, instead of imaginary cloned element..
            if (isCloned) {
                slideToIndex = 0;
            }
            /*
             if no custom animation is defined, then use default .. ->
             */
        } else {
            if (!dojo._isBodyLtr()) {
                // IMPORTANT: dojo.animateProperty has bug which completely ignores `right` property
                // so we can't use animation in this case
                dojo.style(this.scrollableNode, { right: (scrollWidth * slideToIndex * -1) + 'px'});
            } else {
                dojo.animateProperty({
                    node: this.scrollableNode,
                    duration: this.duration,
                    properties: { left: scrollWidth * slideToIndex * -1 }
                }).play();
            }
        }


        // show / hide the next/prev arrows
        if (slideToIndex == 0 || !this.arrows) {
            dojo.addClass(this.scrollLeftButton, "ibm-disabled");
        }
        else {
            dojo.removeClass(this.scrollLeftButton, "ibm-disabled");
        }

        if (slideToIndex == this.slides.length - 1 || !this.arrows) {
            dojo.addClass(this.scrollRightButton, "ibm-disabled");
        }
        else {
            dojo.removeClass(this.scrollRightButton, "ibm-disabled");
        }

        if (this._isBegingAutoscroll && this._isLeadNoHome) {
            var _l = wc.widget.WCRibbonLeadspace._widget.scrollLeftButton,
                _r = wc.widget.WCRibbonLeadspace._widget.scrollRightButton;

            if (dojo.isIE < 7) {
                _l.style.display = 'none';
                _r.style.display = 'none';
            } else {
                dojo.forEach([_l, _r], function(item) {
                    dojo.anim(item, { opacity: 0 }, 250, null, function() {
                        item.style.display = 'none';
                    });
                });
            }
        }

        // to slide animation fix - to get total time to slideTo position and focus 'document'
        var sIndexDiff = Math.abs(this.currentSlideIndex - slideToIndex) + 1;

        // set current slide to new value
        this.currentSlideIndex = slideToIndex;

        // update navigation dots to show current item, highlight the first spot
        if (this.imageType == 'dot') {
            dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']").forEach(function(i) {
                dojo.removeClass(i,"ibm-ribbon-dot-active");
            });
        } else if (this.imageType == 'number') {
            dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-numberButton']").forEach(function(i) {
                dojo.removeClass(i,"ibm-ribbon-number-active");
            });
        }
        var active = dojo.query('a.ibm-active', this.navNode)
        if (active.length > 0) {
            active.removeClass("ibm-active");
        }

        
       if (this.imageType == 'dot') {
           dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']")[slideToIndex].className ='ibm-ribbon-dot ibm-ribbon-dot-active';
       } else if (this.imageType == 'number') {
           dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-numberButton']")[slideToIndex].className ='ibm-ribbon-number ibm-ribbon-number-active';
       }
       dojo.query('a:nth-child(' + (slideToIndex + 1) + ')', this.navNode).addClass("ibm-active");

        // Defect 277457 : Ribbon with autoscroll takes focus
        if (event && !this.autoscroll) {
            this._focusSlideContent(slideToIndex, sIndexDiff);
        }

        for (i = 0; i < (this.slides.length); i++) {
            if (!!dojo.byId('slideLink-' + (i + 1))) {
                dojo.byId('slideLink-' + (i + 1)).tabIndex = 0;
            }
        }
        for (i = 0; i < (this.currentSlideIndex); i++) {
            dojo.byId('slideLink-' + (i + 1)).tabIndex = -1;
        }
    },

    /*
     * Slides one frame to the left
     */
    slideLeft: function(event) {
        this.slideTo(this.currentSlideIndex - 1, event);
    },

    /*
     * Slides one frame to the right
     */
    slideRight: function(event) {
        this.slideTo(this.currentSlideIndex + 1, event);
    },

    /*
     * Slides to the first frame
     */
    slideFirst: function() {
        this.slideTo(0);
    },

    /*
     * Slides to the last frame
     */
    slideLast: function() {
        this.slideTo(this.slides.length - 1);
    },

    /*
     * Slides to next frame. If there are no more frames to go to, then slide to first one.
     * Basically this function can go in circle, while all other defined above stops at some point
     */
    next: function() {

        // adding removed id attribute when it is in autoscroll mode (to avoid RPT duplicate id issue)
        if (this.checkHome()) {
            dojo.query('.ibm-cloned').attr("id", "ibm-lead-1");
            var copyWidgetId = dojo.query('.ibm-cloned div').attr("widgetId");
            dojo.query('.ibm-cloned div').attr("id", copyWidgetId);
        }


        // did we already reach the end of rotation count? for example if we should only do 2 cycles, then stop..
        if (this.rotationCount > 0 && this.rotationCount == this._rotationCount) {
            this.autoscroll = false;
            this._isBegingAutoscroll = false;
            return false;
        }

        this._isBegingAutoscroll = true;

        // check if we have already reached the end
        if ((this.currentSlideIndex + 1) == this.slideCount()) {
            if (!this.checkHome()) {
                this.duration = 1;// to bring back to the first slide
            } 
            this._rotationCount += 1;
            //this.slideFirst();
            // ok, now we have to slide to cloned node, placed in .startup() after last slide in original dom.
            // to do that, let's temporary hack number of slides
            this.slides.length += 1;
            // now we can execute slideTo()

            this.slideTo(this.slides.length - 1, null, true);
            // reset slide length to original value
            this.slides.length -= 1;
            // hmm.. what next..

            if (!this.checkHome()) {
                this.currentSlideIndex = -1;
            }

        } else {
            // no, we can just go to right, as usual
            this.slideRight();
            if (!this.checkHome()) {
                this.duration = this._durationCopy; // duration is reset to default duration
            }

        }
    },

    /*
     * place the dom node in given node
     */
    placeAt: function(placeAt) {
        dojo.place(this.domNode, placeAt);
    },

    /*
     * Returns the number of slides
     */
    slideCount: function() {
        return this.slides.length;
    },

    /*
     * Sets the duration of slide movement
     */
    setDuration: function(duration) {
        this.duration = duration;
        this._durationCopy = duration;
    },

    stopSlideShow: function() {
        if (this.autoscroll) {
            this.autoscroll = false;
            this._isBegingAutoscroll = false;
            clearInterval(this._interval);
            dojo.disconnect(this._intervalHandlers.onmouseenter);
            dojo.disconnect(this._intervalHandlers.onmouseleave);
        }
    },

    /*
     * Sets the duration of slide movement
     */
    hideNavigationDots: function() {
        dojo.query(this.navNode).style('display', 'none');
        dojo.query(this.navNode).orphan();
    },

    addRibbonCloseBtn: function() {
        if (dojo.byId('ibm-com').className.indexOf('dijit_a11y') != -1) {
            dojo.create('div', {
                className:'ibm-mm-close',
                innerHTML: "<span tabindex='0' aria-label='Close' role='button' title='Close'>&#9650;</span>"
            }, this.ribbonContainer, 'last');
        }
        else {
            dojo.create('div', {
                className:'ibm-mm-close',
                innerHTML: "<span tabindex='0' aria-label='Close' role='button' title='Close'></span>"
            }, this.ribbonContainer, 'last');
        }
    }
});

/*
 * Ribbon-Item which can be added dynamically
 * 
 */
dojo.declare('wc.widget.WCRibbonSlide', [dijit._Widget, dijit._Templated, dijit._Container], {
    // if pid is defined, it means we want to preserve the original ID used in html
    pid: null,
    templateString: "<div class='ibm-columns' dojoAttachPoint='containerNode'></div>",

    postCreate: function() {
        // check if we should preserve original ID
        if (this.pid && this.pid !== '') {
            this.containerNode.id = this.pid;
        }
    }
});

/*
 * Ribbon-Item base is abstract class for items
 * 
 */
dojo.declare('wc.widget.WCRibbonItemAbstract', [dijit._Widget], {
    /*
     * Creates item based on dom node
     */
    constructor: function(param) {
        // do nothing if dom node is not passed
        if (!param.srcNodeRef) return;

        // clone the node and pass it to srcNodeRef, so widget is pointed to this node directly
        this.srcNodeRef = dojo.clone(param.srcNodeRef);
    }
});

/*
 * Ribbon-Item which can be added dynamically
 * 
 */
dojo.declare('wc.widget.WCRibbonItem', [dijit._Widget, dijit._Templated, dijit._Container], {

    columns: 3,

    templateString: "<div dojoAttachPoint='containerNode'></div>",

    attributeMap: {
        type: { node: "containerNode", type: "class" },
        content: { node: "containerNode", type: "innerHTML" }
    },

    postCreate: function() {
        // set the classname
        switch (parseInt(this.columns)) {
            case 1:
                this.attr('class', 'ibm-col-1-1');
                break;
            case 3:
                this.attr('class', 'ibm-col-6-2');
                break;
            case 5:
                this.attr('class', 'ibm-col-5-1');
                break;
            case 6:
                this.attr('class', 'ibm-col-6-1');
                break;
            default:
                this.attr('class', 'ibm-col-6-2');
                break;
        }
    }
});


/*
 namespace for enabling cute ribbons in leadspace area
 */
wc.widget.WCRibbonLeadspace = {

    /*
     on every page resize + on page load we will need to adjust some CSS
     */
	bgImageMap:null ,
	bidi: null,
	containerWidth:null,
	containerHeight:null,	
        onWindowResize: function(param) {
		if (param != null && param.bgImageMap != null){
			this.bgImageMap = param.bgImageMap;			
			this.bidi = param.bidi;				
			this.containerWidth = dojo.query("#ibm-leadspace-body")[0].offsetWidth;
			this.containerHeight = dojo.query("#ibm-leadspace-body")[0].offsetHeight;			
		}
        // get reference to leadspace widget
        var temp = dojo.byId('ibm-leadspace-body');
        var widget = null;
        if (temp) {
            var id = dojo.hasAttr(temp, 'widgetid') ? dojo.attr(temp, 'widgetid') : null;
            if (id) {
                widget = dijit.byId(id);
            } else {
                // stop right here, we couldn't find the widget !!
                return false;
            }

        }

        // we need to calculate window width
        var dimensions = dojo.window.getBox();

        // change css
        var iWidth = null
        var iHeight = null        
        var bidi = this.bidi;
        var mainContentWidth = dojo.query(".main_content")[0].offsetWidth;		
		var maxWidth = 935;
		var minWidth = 320;
		var maxHeight = 352;
		iHeight = maxHeight;	
		
	  if (dojo.isIE <= 8) {
            // In IE7/8, these values become NaN, so hardcode them for now.  Change this to match image dimensions.
		 maxWidth = 935;
                 maxHeight = 352;
          }

				
		if (dimensions.w <= mainContentWidth)
		{
			iWidth = this.containerWidth * (dimensions.w / mainContentWidth);
		}else{
			iWidth = this.containerWidth;
		}
		
		
		
		if (iWidth > maxWidth){iWidth = maxWidth};
		
		if (iWidth <= minWidth){iWidth = minWidth};	
								
		var newImageURL = "";
	 	var hash = new Object(); // or just {}
	 	
	 	for (var i in this.bgImageMap)	 	
	 	{	 				
	 		var originalImagePath = this.bgImageMap[i]; 
	 		var originalImagePathArray = originalImagePath.split("/");
	 		var originalImageFile = originalImagePathArray[originalImagePathArray.length - 1];	 		

	 		if (iWidth <= 560){				
	 			var newImageFile = "BP003_" + originalImageFile;	 				 			
				iHeight = (0.56 * maxHeight) + 40 * (iWidth / 600);	
			} else if (iWidth <= 800){				
				var newImageFile = "BP004_" + originalImageFile;										
			} else {				
				var newImageFile = originalImageFile;					
			}			 	
	 		newImageURL = originalImagePath.replace(originalImageFile, newImageFile);	 		
	 		hash[i] = newImageURL;
	 	}
	 	if ( typeof RotatingContentJS == "undefined")
		{
			iWidth = 935;
			iHeight = 394;  
		}
		else
		{
			RotatingContentJS.updateImage(iWidth, hash);
			RotatingContentJS.updateProperties(iWidth, maxHeight, iHeight, dimensions.w, minWidth);
		}				
      
        dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-pane')[0].style.width = iWidth + 'px';
        dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-pane')[0].style.height = iHeight + 'px';
        dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-pane > div.ibm-ribbon-section > div').forEach(function(i) {
            i.style.width = iWidth + 'px';
            i.style.height = iHeight + 'px';
        });

        // to avoid the css overriding from the parent objects, I have to reset the css based on image type
        if (dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']").length > 0) {
            dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav').style('margin', '-50px 20px -20px ' + ((iWidth / 2) - 307) + 'px');
            dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']").forEach(function(i) {
                dojo.removeClass(i,"ibm-active");
                dojo.addClass(i,"ibm-ribbon-dot");

            i.style.borderRadius  = '16px';
            i.style.marginRight = '0';
            });
            dojo.query("#ibm-leadspace-head > div.ibm-container-body >  div.ibm-ribbon-nav > a[dojoAttachpoint='ibm-ribbon-carouselAnk']").forEach(function(i) {
                i.style.boxShadow  = '0 0 0 rgba(0, 0, 0, 0)';
                i.style.margin = '0px 0px 0px 20px';
            });
        }
        if (dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-numberButton']").length > 0) {	    
            dojo.query("#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-numberButton']").forEach(function(i) {
                dojo.removeClass(i,"ibm-active");
                dojo.addClass(i,"ibm-ribbon-number");

                i.style.borderRadius  = '2px';
                i.style.margin = '0';
            });
            dojo.query("#ibm-leadspace-head > div.ibm-container-body >  div.ibm-ribbon-nav > a[dojoAttachpoint='ibm-ribbon-carouselAnk']").forEach(function(i) {
                i.style.boxShadow  = '0 0 0 rgba(0, 0, 0, 0)';
                i.style.margin = '0px 5px 0px 0px';
            });
        }
        
	dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav').style('margin', '-70px 0px 0px ' + (iWidth - 375) + 'px');
	
	if ( typeof RotatingContentJS != "undefined")
	{
	        if (dojo.query("#ibm-leadspace-head > div.ibm-container-body >  div.ibm-ribbon-nav > a[dojoAttachpoint='ibm-ribbon-carouselAnk']").length > 0)
	        {
	        	dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav').style('margin', '-50px 0px 0px ' + (iWidth - 395) + 'px');
	        }
        
	        if (dojo.query("#ibm-leadspace-head > div.ibm-container-body >  div.ibm-ribbon-nav > a > div[dojoAttachpoint='ibm-ribbon-dotImageButton']").length > 0)
	        {
	        	dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-nav').style('margin', '-50px 0px 0px ' + (160 - (this.containerWidth - iWidth) * 0.5) + 'px');
	        }
	}
        
        
        dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-pane > div.ibm-ribbon-section > div > div').forEach(function(i) {
            var paddingLR = ( iWidth + 30 - dojo.coords(i).w ) / 2;
            i.style.width = (bidi ? '0px' : iWidth + 'px');
        });

        var ribbonSection = dojo.query('#ibm-leadspace-head > div.ibm-container-body > div.ibm-ribbon-pane > div.ibm-ribbon-section')[0];
        // on first lead we don't need to change anything
        if (!ribbonSection.style.left || ribbonSection.style.left == '0px') {
            // first lead..
        } else {
            // we need to adjust it a little
            ribbonSection.style.left = '-' + (widget.currentSlideIndex * iWidth) + 'px';
        }

        // place arrows to the right spot
        if (wc.widget.WCRibbonLeadspace._widget) {
            var pos = 20;
            wc.widget.WCRibbonLeadspace._widget.scrollLeftButton.style.left = ( pos < 1 ? 1 : pos ) + 'px';
            var ribbonWidth = dojo.query(".ibm-ribbon-pane")[0].offsetWidth; 
            // here goes a small problem
            // we are using dojo.window.getBox() to calculate width of window.
            // what needs to be taken care of separately is Internet Explorer 7 and lower
            // in IE7, once below 1050px of width ( approximately the size of one slide ) we have to set right: 5px; ( static ) ,
            // no need to calculate it any further - if we would use the same value as in other browsers, it would jump by that amount of px to the content area
            if (dojo.isIE < 8) {
                wc.widget.WCRibbonLeadspace._widget.scrollRightButton.style.right = ( pos < 1 ? 5 : pos ) + 'px';
            } else {
                wc.widget.WCRibbonLeadspace._widget.scrollRightButton.style.right = ( pos < 1 ? (-1) * (dimensions.w - 988) : pos ) + 'px';
	    }
	    
            if ( typeof RotatingContentJS != "undefined")
	    {
		RotatingContentJS.updateScrollButton(iWidth, this.containerWidth, ribbonWidth );
	    }
        }
    },

    /*
     just a helpful function for fading in and out the arrows around leadspace
     */
    arrowsToggle: {
        generic: function(x) {
            // make a shortcut to arrows, to clear the code a little bit
            var _l = wc.widget.WCRibbonLeadspace._widget.scrollLeftButton;
            var _r = wc.widget.WCRibbonLeadspace._widget.scrollRightButton;

            switch (x) {
                case 'show':

                    // for IE6 we will skip the animation
                    if (dojo.isIE < 7) {
                        _l.style.display = 'block';
                        _r.style.display = 'block';
                    } else {
                        // for modern browsers we have to do animation - changing opacity from 0 to 1
                        // first, we have to set opacity to 0 and display the element - but of course user won't see it due to lower opacity
                        // and then fire animation to set opacity to 1, making the fade in effect
                        dojo.forEach([_l, _r], function(item) {
                            dojo.style(item, { opacity: '0', display: 'block' });
                            dojo.anim(item, { opacity: 1 }, 300, null, function() {
                                // sometimes user will move his mouse way too fast and will enter the leadspace, move out immediately and then move back
                                // in such case, the code we had till now wouldn't be able to handle it ( because one animation will be still in progress,
                                // hence the other won't start and you end up with no arrows, yet you will be hovering over leadspace.
                                // to prevent this, we can introduce sort of 'queue' - onEnd animation - check if current status has changed - if so, animate
                                // again to accommodate to this new status
                                // this will create a loop that will always end with correct arrows style
                                if (wc.widget.WCRibbonLeadspace.arrowsToggle._stat != 'show') {
                                    wc.widget.WCRibbonLeadspace.arrowsToggle.generic('hide');
                                }
                            });
                        });
                    }

                    break;
                case 'hide':
                    /*
                     for every step, see documentation for function written above - 'show' fn()
                     */
                    if (dojo.isIE < 7) {
                        _l.style.display = 'none';
                        _r.style.display = 'none';
                    } else {
                        dojo.forEach([_l, _r], function(item) {
                            dojo.anim(item, { opacity: 0 }, 250, null, function() {
                                item.style.display = 'none';
                                if (wc.widget.WCRibbonLeadspace.arrowsToggle._stat != 'hide') {
                                    wc.widget.WCRibbonLeadspace.arrowsToggle.generic('show');
                                }
                            });
                        });
                    }

                    break;
            }
        },

        show: function() {
            this.WCRibbonLeadspace.arrowsToggle._stat = 'show';
            this.WCRibbonLeadspace.arrowsToggle.generic('show');
        },

        hide: function() {
            this.WCRibbonLeadspace.arrowsToggle._stat = 'hide';
            this.WCRibbonLeadspace.arrowsToggle.generic('hide');
        }
    },

    init: function(param) {

        // initialize leadspace ribbon - it's very specific, so we can't leave it to controller.js
        var _temp = new wc.widget.WCRibbon({
            srcNodeRef: dojo.query('#ibm-leadspace-head.ibm-ribbon > div#ibm-leadspace-body.ibm-container-body')[0],
            _isLeadSpace: true,
            arrows: param.arrows,
            imageType: param.imageType,
            imageMap: param.imageMap,
            customSeekAnimation: function(scrollWidth, slideToIndex, isCloned) {
                if (isCloned && this._isLeadNoHome) {
                    slideToIndex = 0;
                    this.currentSlideIndex = -1;
                }

                switch (this.currentSlideIndex) {
                    case 1:
                        var headlineNode = dojo.query('#ibm-lead-2 div.ibm-col-1-1')[0];
                        break;
                    case 2:
                        var headlineNode = dojo.query('#ibm-lead-3 div.ibm-col-1-1')[0];
                        break;
                    default:
                        var headlineNode = dojo.query('#ibm-lead-1 div.ibm-col-1-1')[0];
                }

                /* animation description ->>>
                 - there has got to be 2 animations
                 1.) moving headline to left
                 2.) moving the whole leadspace to left

                 both has to start at the same time, but headline is twice as fast
                 */

                /* (1) */
                // ilhe special case
                var _prop1 = {
                    left: {
                        start: 0,
                        end: -2000,
                        unit: "px"
                    }
                },
                    _prop2 = {
                        left: {
                            start: -1000,
                            end: 0,
                            unit: "px"
                        }
                    };

                var headAnim = dojo.fx.chain([
                    dojo.animateProperty({
                        node: headlineNode,
                        properties: _prop1,
                        duration: 950,
                        easing: function(n) { /* circIn */
                            return -1 * (Math.sqrt(1 - Math.pow(n, 2)) - 1);
                        }
                    }), dojo.animateProperty({
                        node: headlineNode,
                        properties: _prop2,
                        duration: 200
                    })
                ]),

                    _prop3 = {
                        left: {
//		                	start: (wc.widget.meta.cpi == 'ilhe' ? 
//		                			(this.scrollableNode.style.right || 0) : 
//		                			(this.scrollableNode.style.left || 0)),
                            start: (this.scrollableNode.style.left || 0),
                            end: scrollWidth * slideToIndex * -1,
                            nit: "px"
                        }
                    };

//	            if(wc.widget.meta.cpi == 'ilhe') {
//					_prop3.right = _prop3.left;
//					_prop3.left = undefined;
//				}

                var bodyAnim = dojo.animateProperty({
                    node: this.scrollableNode,
                    properties: _prop3,
                    duration: 2100,
                    easing: function(/* Decimal? */n) { /* expoInOut */
                        if (n == 0) {
                            return 0;
                        }

                        if (n == 1) {
                            return 1;
                        }

                        n = n * 2;
                        if (n < 1) {
                            return Math.pow(2, 10 * (n - 1)) / 2;
                        }

                        --n;
                        return (-1 * Math.pow(2, -10 * n) + 2) / 2;
                    }
                }),
                    /* (combine into 1 animation) */
                    combinedAnim = dojo.fx.combine([headAnim, bodyAnim]);

                // !IMPORTANT
                // dojo.animateProperty has bug which does basically nothing with property 'right' in some browsers
                // for some reasons, this leadspace ribbon only breaks in IE6 RtL
                // for this one case, instead of animation, just switch to that leadspace
                combinedAnim.play();

                // check if this is the last, cloned slides.
                dojo.connect(combinedAnim, 'onEnd', dojo.hitch(this, function() {
                    this._isBeingAnimated = false;
                    this._isBegingAutoscroll = false;

                    if (isCloned && this._isLeadNoHome) {
                        this.currentSlideIndex = 0;
                    }
                }));
            }
        });
     //   this.width = param.width;
     //   this.height = param.height;
        this.bidi = (param.bidi ? param.bidi : false);
        this._widget = _temp;
        /*
         IE6 and IE7 fix
         in these 2 browsers, right arrow would push the whole content / or at least ribbon-nav down when visible
         Due to this bug and absolutely no CSS solution I decided to move right arrow to a different place in HTML content
         */
        if (dojo.isIE < 8) {
            dojo.place(
                wc.widget.WCRibbonLeadspace._widget.scrollRightButton,
                wc.widget.WCRibbonLeadspace._widget.scrollLeftButton,
                'after'
            );

            dojo.style(wc.widget.WCRibbonLeadspace._widget.scrollRightButton, {
                marginTop: '140px',
                zIndex: '1'

            });
        }

        // on mouse over, arrows should be visible, otherwise hidden
        dojo.connect(_temp, 'onMouseEnter', wc.widget, wc.widget.WCRibbonLeadspace.arrowsToggle.show);
        dojo.connect(_temp, 'onMouseLeave', wc.widget, wc.widget.WCRibbonLeadspace.arrowsToggle.hide);

        // call startup function
        // update - there will be leadspaces with just 1 tab. - do not initialize ribbon for them.
        if (_temp.slides.length > 1) {
            _temp.startup();
        }

        // show 2nd and 3rd leadspace which by default has display: none for non-js version support
        dojo.query('#ibm-lead-2, #ibm-lead-3').forEach(function(item) {
            item.style.display = 'block';
        });

        /*
         lets generate those small overlays inside .ibm-ribbon-nav that shows when you move mouse over
         */
        if (_temp.slides.length > 1) {

            dojo.query('#ibm-leadspace-head .ibm-ribbon-nav a').forEach(function(item, i) {
                // 'i' starts from 0, but in most cases we will want to search for IDs starting from 1
                // so instead of doing constant ..' + (i+1) + ' .. let's create temporary variable right here
                var j = i + 1;
                // and let's use this 'j' in all next code..

                // look for thumbnail
                var temp = dojo.query('#ibm-lead-' + j + ' div.ibm-ribbon-view');
                // if found..
                if (temp.length == 1) {
                    // .. then move it into ribbon-nav
                    dojo.place(temp[0], item);
                }
            });
        } else {
            dojo.query(_temp.navNode).orphan();
        }

        // IE7 css fix - we have tried setting this directly in CSS but it just didn't take! :-(
        

        // we need to adjust leadspace ribbon on every page resize
        dojo.connect(window, 'onresize',wc.widget.WCRibbonLeadspace ,wc.widget.WCRibbonLeadspace.onWindowResize);
        wc.widget.WCRibbonLeadspace.onWindowResize({ arrows:param.arrows, imageType:param.imageType, bgImageMap:param.imageMap, bidi:param.bidi });

        // accessibility support
        var anchors = dojo.query('#ibm-leadspace-head div.ibm-ribbon-nav a');

        // first we have to make sure that if you TAB into leadspace it won't break the whole design
        // so we listen for TAB key and if hit, we stopEvent - that will do it.
        // But at the same time we need to set focus to element that is next in row, otherwise the whole navigation would get stuck here
        dojo.connect(dojo.query('#ibm-leadspace-head div.ibm-ribbon-pane')[0], 'onkeypress', dojo.hitch(this, function(evt) {
            if (evt.keyCode == dojo.keys.TAB && !evt.shiftKey) {
                if (anchors.length > 0) {
                    // if there are multiple leadspaces, let's set focus to ribbon navigation
                    dojo.query('#ibm-leadspace-head div.ibm-ribbon-nav a:first-child')[0].focus();
                }
                dojo.stopEvent(evt);
            }
        }));

    }
}