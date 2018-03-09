//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2010 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.widget.WCLightbox");

dojo.require("dojox.image.Lightbox");
dojo.require("dijit.Dialog");
dojo.require("dojox.fx._base");
dojo.require("dojo.string");

dojo.requireLocalization("wc", "lightbox", null, "en,zh");

dojo.declare("wc.widget.WCLightbox", dojox.image.Lightbox, {
    // summary:
    //		A dojo-based Lightbox implementation for Websphere Commerce. 
    //
    // description:
    //	An Elegant, keyboard accessible, markup and store capable Lightbox widget to show images
    //	in a modal dialog-esque format. Can show individual images as Modal dialog, or can group
    //	images with multiple entry points, all using a single "master" Dialog for visualization
    //
    //	key controls:
    //		ESC - close
    //		Down Arrow / Rt Arrow / N - Next Image
    //		Up Arrow / Lf Arrow / P - Previous Image
    // 
    // example:
    // |	<a href="image1.jpg" thumbnail="image1_thumb.jpg" dojoType="wc.widget.WCLightbox">show lightbox</a>
    //
    // example: 
    // |	<a href="image2.jpg" thumbnail="image2_thumb.jpg" dojoType="wc.widget.WCLightbox" group="one">show group lightbox</a>
    // |	<a href="image3.jpg" thumbnail="image3_thumb.jpg" dojoType="wc.widget.WCLightbox" group="one">show group lightbox</a>
    //
    // example:	 
    // |	not implemented fully yet, though works with basic datastore access. need to manually call
    // |	widget._attachedDialog.addImage(item,"fromStore") for each item in a store result set.
    // |	<div dojoType="wc.widget.WCLightbox" group="fromStore" store="storeName"></div>
    //

    // thumb; String
    //		thumb image to use for this Lightbox node (empty if using a store).
    thumb: "",

    startup: function() {
        dijit._Widget.prototype.startup.apply(this, arguments);

        // setup an attachment to the masterDialog (or create the masterDialog)
        var tmp = dijit.byId('wcLightboxDialog');
        if (tmp) {
            this._attachedDialog = tmp;
        }
        else {
            // this is the first instance to start, so we make the masterDialog
            this._attachedDialog = new wc.widget.WCLightboxDialog({
                id: "wcLightboxDialog"
            });
            this._attachedDialog.startup();
        }
        if (!this.store) {
            this._addSelf();
            this.connect(this.domNode, "onclick", "_handleClick");
        }

    },

    _addSelf: function() {
        // summary: Add this instance to the master LightBoxDialog
        this._attachedDialog.addImage({
            href: this.href,
            title: this.title,
            thumb: this.thumb
        }, this.group || null);
    }

});

dojo.declare("wc.widget.WCLightboxDialog", dojox.image.LightboxDialog, {
    // summary:
    //		The "dialog" shared  between any Lightbox instances on the page, publically available
    //		for programatic manipulation.
    //
    // description:
    //	
    //		A widget that intercepts anchor links (typically around images) 	
    //		and displays a modal Dialog. this is the actual Dialog, which you can
    //		create and populate manually, though should use simple Lightbox's
    //		unless you need the direct access.
    //
    //		There should only be one of these on a page, so all wc.widget.WCLightbox's will us it
    //		(the first instance of a Lightbox to be show()'n will create me If i do not exist)
    //	
    //	example: 
    //	|	// show a single image from a url
    //	|	var url = "http://dojotoolkit.org/logo.png";
    //	|	var url_thumb = "http://dojotoolkit.org/logo_thumb.png";
    //	|	var dialog = new wc.widget.WCLightboxDialog.startup();
    //	|	dialog.show({ href: url, thumbnail: url_thumb, title:"My Remote Image"});
    //	

    // imagePath: Url
    //		Path to the default image path 
    imagePath: dojo.moduleUrl("wc.widget", "resources/images/lightbox/"),

    // blankGif: Url
    // 		Path to the blank image
    blankGif: dijit._Widget.prototype._blankGif,

    // thumbnailGif: Url
    // 		Path to the thumbnail icon image
    thumbnailGif: dojo.moduleUrl("wc.widget", "resources/images/lightbox/thumbnail.gif"),

    // thumbnailGifDisable: Url
    // 		Path to the thumbnail disable icon image   
    thumbnailGifDisable: dojo.moduleUrl("wc.widget", "resources/images/lightbox/thumbnail_disable.gif"),

    // playGif: Url
    // 		Path to the auto play icon image    
    playGif: dojo.moduleUrl("wc.widget", "resources/images/lightbox/play.gif"),

    // playGifDisable: Url
    // 		Path to the auto play disable icon image   
    playGifDisable: dojo.moduleUrl("wc.widget", "resources/images/lightbox/play_disable.gif"),

    // prevGif: Url
    // 		Path to the previous image icon image        
    prevGif: dojo.moduleUrl("wc.widget", "resources/images/lightbox/prev.gif"),

    // prevGifDisable: Url
    // 		Path to the previous image disable icon image   
    prevGifDisable: dojo.moduleUrl("wc.widget", "resources/images/lightbox/prev_disable.gif"),

    // nextGif: Url
    // 		Path to the next image icon image       
    nextGif: dojo.moduleUrl("wc.widget", "resources/images/lightbox/next.gif"),

    // nextGifDisable: Url
    // 		Path to the next image disable icon image 
    nextGifDisable: dojo.moduleUrl("wc.widget", "resources/images/lightbox/next_disable.gif"),

    // stopGif: Url
    // 		Path to the stop auto play icon image        
    stopGif: dojo.moduleUrl("wc.widget", "resources/images/lightbox/stop.gif"),

    // nullThumbnail: Url
    // 		Path to the default thumbnail for the image which has no thumbnail       
    nullThumbnail: dojo.moduleUrl("wc.widget", "resources/images/lightbox/nullThumbnail.gif"),

    // errorImg: Url
    //		Path to the image used when a 404 is encountered
    errorImg: dojo.moduleUrl("wc.widget", "resources/images/lightbox/warning.png"),

    // nlsStrings: Object
    // 		the localization object     
    nlsStrings: null,

    // _thumbHighlightClassName: String
    //		the style class name of thumbnail highlight border
    _thumbHighlightClassName: "imgThumbBorderHighlight",

    // _isAutoPlay: Boolean
    //		is the widget running auto play mode  
    _isAutoPlay: false,

    templateString: '<div class="wcLightbox" dojoAttachPoint="containerNode">' +
						'<div style="position:relative;width:100%;height:100%">' +
							'<div dojoAttachPoint="imageContainer" class="wcLightboxContainer">' +
								'<div class="galleryGroup" dojoAttachPoint="galleryGroup">' +
									'<div class="thumbBox">' +
										'<div class="header">' +
											'<table cellspacing="0" cellpadding="0">' +
												'<tbody>' +
													'<tr>' +
														'<td class="headImg pointer" dojoAttachPoint="thumbImgNode">' +
															'<a href="javascript:;" dojoAttachPoint="thumbnailNode"><img dojoAttachPoint="thumbnailIcon" class="ico" src="${imagePath}thumbnail.gif" /></a>' +
														'</td>' +
														'<td class="spacer">' +
															'<img src="${imagePath}separator.gif"/>' +
														'</td>' +
														'<td class="headImg pointer">' +
															'<a href="javascript:;" dojoAttachPoint="autoPlayNode"><img dojoAttachPoint="autoPlayIcon" class="ico" src="${imagePath}play.gif" /></a>' +
														'</td>' +
														'<td class="spacer" >' +
															'<img src="${imagePath}separator.gif"/>' +
														'</td>' +
														'<td class="headImg pointer" >' +
															'<a href="javascript:;" dojoAttachPoint="prevButtonNode"><img dojoAttachPoint="prevIcon" class="ico" src="${imagePath}prev.gif" /></a>' +
														'</td>' +
														'<td class="headImg pointer">' +
															'<a href="javascript:;" dojoAttachPoint="nextButtonNode"><img dojoAttachPoint="nextIcon" class="ico" src="${imagePath}next.gif" /></a>' +
														'</td>' +
														'<td class="spacer" >' +
															'<img src="${imagePath}separator.gif"/>' +
														'</td>' +
														'<td class="headImg pointer" >' +
															'<a href="javascript:;" dojoAttachPoint="closeButtonNode"><img dojoAttachPoint="closeIcon" class="ico" src="${imagePath}close.gif" /></a>' +
														'</td>' +
													'</tr>' +
												'</tbody>' +
											'</table>' +
										'</div>' +
										'<div class="thumbImgContent" style="display:none;" dojoAttachPoint="thumbnailAreaNode">' +
										'</div>' +
										'<div class="descriptionBox">' +
											'<div class="imgDescContainer" id="imgDescContainer" dojoAttachPoint="titleNode">' +
												'<div class="dojoxLightboxText" dojoAttachPoint="titleTextNode">'+
													'<label dojoAttachPoint="imgDescNodeLabel" for="imgDescNode" class="nodisplay" ></label>' +
													'<a id="imgDescNode" name="imgDescNode" class="likeTextLink" dojoAttachPoint="imgDescNode" href="javascript:;"></a>' +
													'<label dojoAttachPoint="groupCountLabel" for="groupCount" class="nodisplay" ></label>' +
													'<a id="groupCount" name="groupCount" class="likeTextLink" dojoAttachPoint="groupCount" href="javascript:;"></a>' +
												'</div>'+
											'</div>' +
										'</div>' +
									'</div>' +
									'<div class="imageContainer">' +
										'<div id="fullImageContainer" dojoAttachPoint="fullImageContainer">' +
											'<img dojoAttachPoint="imgNode" src="${blankGif}" class="imgFull" alt="${title}" />' +
										'</div>' +
									'</div>' +
								'</div>' +						
							'</div>' +
						'</div>' +
					'</div>',
    
    startup: function(){
        // summary: Add some extra event handlers, and startup our superclass.
        //
        // returns: dijit._Widget
        //		Perhaps the only `dijit._Widget` that returns itself to allow
        //		'chaining' or var referencing with .startup()

        dijit.Dialog.prototype.startup.apply(this, arguments);

        this._animConnects = [];
        this.connect(this.nextButtonNode, "onclick", "_nextNodeClickHandler");
        this.connect(this.prevButtonNode, "onclick", "_prevNodeClickHandler");
        this.connect(this.closeButtonNode, "onclick", "_closeNodeClickHandler");
        this.connect(this.thumbImgNode, "onclick", "_thumbImgNodeClickHandler");
        this.connect(this.autoPlayNode, "onclick", "_autoPlayNodeClickHandler");
        this._makeAnims();
        this._vp = dijit.getViewport();

        // make localization support
        this.nlsStrings = dojo.i18n.getLocalization("wc", "lightbox");
        this.thumbnailIcon.alt = this.nlsStrings.THUMBNAIL_ICON;
        this.nextIcon.alt = this.nlsStrings.NEXT_ICON;
        this.prevIcon.alt = this.nlsStrings.PREV_ICON;
        this.closeIcon.alt = this.nlsStrings.CLOSE_ICON;
        this.autoPlayIcon.alt = this.nlsStrings.AUTOPLAY_ICON;
        this.imgDescNodeLabel.innerHTML = this.nlsStrings.IMG_DESC_LABEL;
        this.groupCountLabel.innerHTML = this.nlsStrings.IMG_COUNT_LABEL;

        return this;
    },

    _nextNodeClickHandler: function() {
        // summary: Handle the nextNode click event
        // if auto play mode, stop it
        this._stopAutoPlay();

        this._nextImage();
    },

    _prevNodeClickHandler: function() {
        // summary: Handle the prevNode click event
        // if auto play mode, stop it
        this._stopAutoPlay();

        this._prevImage();
    },

    _closeNodeClickHandler: function() {
        // summary: Handle the closeNode click event
        // if auto play mode, stop it
        this._stopAutoPlay();

        this.hide();
    },

    _thumbImgNodeClickHandler: function() {
        // summary: Show or hidden the thumbnail area
        var _t = this;

        if ((_t.lastGroup && _t.lastGroup !== "XnoGroupX") || _t.inGroup) {
            var display = _t.thumbnailAreaNode.style.display;
            if (display == 'none') {
                display = 'block';
                dojo.fx.wipeIn({
                    node: _t.thumbnailAreaNode,
                    duration: 400
                }).play();
            }
            else {
                display = 'none';
                dojo.fx.wipeOut({
                    node: _t.thumbnailAreaNode,
                    duration: 400
                }).play();
            }
        }
    },

    _autoPlayNodeClickHandler: function() {
        // summary: Handle the autoPlayNode click event
        var _t = this;

        if (!_t.inGroup) {
            return;
        }

        if ((_t._lastGroup && _t._lastGroup !== "XnoGroupX") || _t.inGroup) {
            _t._isAutoPlay = !_t._isAutoPlay;
            if (_t._isAutoPlay) {
                _t.autoPlayIcon.src = _t.stopGif;
                _t.autoPlayIcon.alt = _t.nlsStrings.STOP_AUTOPLAY_ICON;
                _t._startTimer();
            }
            else {
                _t._stopTimer();
            }
        }
    },

    _stopAutoPlay: function() {
        // summary: Stop autoplay mode
        if (this._isAutoPlay) {
            this._stopTimer();
        }
    },

    _startTimer: function() {
        // summary: Start the time out for show next image
        this._imageSwitcher = setTimeout(dojo.hitch(this, function() {
            this._autoPlayNextImage(true);
        }), 5000);
    },

    _stopTimer: function() {
        // summary: Clear the time out for show next image
        var _t = this;

        _t._isAutoPlay = false;
        _t.autoPlayIcon.src = _t.playGif;
        _t.autoPlayIcon.alt = this.nlsStrings.AUTOPLAY_ICON;
        if (_t._imageSwitcher) {
            clearTimeout(_t._imageSwitcher);
        }
    },

    _autoPlayNextImage: function() {
        // summary: Show next page if in autoplay mode
        if (!this._isAutoPlay) {
            return false;
        }
        this._nextImage();
        return true;
    },

    _thumbnailClickHandler: function(e) {
        // summary: Handle the thumbnail click event
        var _t = this;

        // if auto play mode, stop it
        _t._stopAutoPlay();

        var targ = e.target;
        _t._index = targ.index;
        if (!_t._index) {
            _t._index = 0;
        }

        _t._loadImage();

    },

    _buildThumbnailArea: function(/* Object */groupData) {
        // summary: Build the thumbnail area
        var _t = this;

        var thumbIndex = 0;
        if (_t.thumbnailAreaNode != null) {
            dojo.style(_t.thumbnailAreaNode, "display", "none");

            dojo.forEach(_t._groups[(groupData.group)], function(g) {
                var thumb = (g.thumb ? g.thumb : _t.nullThumbnail);
                var thumbImageHTML = document.createElement("img");
                thumbImageHTML.src = thumb;
                thumbImageHTML.className = "imgThumb pointer";
                thumbImageHTML.index = thumbIndex++;
                _t.thumbnailAreaNode.appendChild(thumbImageHTML);
                _t.connect(thumbImageHTML, "onclick", "_thumbnailClickHandler");
            }, _t);
        }
    },

    show: function(/* Object */groupData) {
        // summary: Show the Master Dialog. Starts the chain of events to show
        //		an image in the dialog, including showing the dialog if it is
        //		not already visible
        //
        // groupData: Object
        //	needs href, thumb and title attributes. the values for this image.
        //
        //
        var _t = this; // size
        // if show different group with last show group, build thumbnail area for new show group
        if ((!this._lastGroup) || (this._lastGroup == "") || (this._lastGroup.group == "") || (groupData.group == "") || (this._lastGroup.group != groupData.group)) {
            this._buildThumbnailArea(groupData);
            this._lastGroup = groupData;
        }

        // we only need to call dijit.Dialog.show() if we're not already open.
        if (!_t.open) {
            dijit.Dialog.prototype.show.apply(this, arguments);
            this._modalconnects.push(dojo.connect(dojo.global, "onscroll", this, "_position"), dojo.connect(dojo.global, "onresize", this, "_position"), dojo.connect(dojo.body(), "onkeypress", this, "_handleKey"));
            if (!groupData.modal) {
                this._modalconnects.push(dojo.connect(dijit._underlay.domNode, "onclick", this, "onCancel"));
            }
        }

        if (this._wasStyled) {
            // ugly fix for IE being stupid:
            dojo.destroy(_t.imgNode);
            _t.imgNode = dojo.create("img", null, _t.fullImageContainer, 'first');
            _t._makeAnims();
            _t._wasStyled = false;
        }

        dojo.style(_t.imgNode, "opacity", "0");
        dojo.style(_t.titleNode, "opacity", "0");

        var src = groupData.href;

        if ((groupData.group && groupData !== "XnoGroupX") || _t.inGroup) {
            if (!_t.inGroup) {
                _t.inGroup = _t._groups[(groupData.group)];
                // determine where we were or are in the show 
                dojo.forEach(_t.inGroup, function(g, i) {
                    if (g.href == groupData.href) {
                        _t._index = i;
                    }
                }, _t);
            }
            if (!_t._index) {
                _t._index = 0;
                src = _t.inGroup[_t._index].href;
            }

            // use string template to show page count
            var pageCountStringTemplate = this.nlsStrings.PAGE_COUNT;
            var pageCountString = dojo.string.substitute(pageCountStringTemplate, {
                currentPage: (_t._index + 1),
                totalPage: (_t.inGroup.length)
            });

            _t.groupCount.innerHTML = "&nbsp;(&nbsp;" + pageCountString + "&nbsp;)";
            _t.thumbnailIcon.src = _t.thumbnailGif;
            _t.prevIcon.src = _t.prevGif;
            _t.nextIcon.src = _t.nextGif;
            if (_t._isAutoPlay) {
                _t.autoPlayIcon.src = _t.stopGif;
                _t.autoPlayIcon.alt = _t.nlsStrings.STOP_AUTOPLAY_ICON;
            }
            else {
                _t.autoPlayIcon.src = _t.playGif;
                _t.autoPlayIcon.alt = _t.nlsStrings.AUTOPLAY_ICON;
            }
        }
        else {
            // single images don't have buttons, or counters:
            _t.groupCount.innerHTML = "";

            _t.thumbnailIcon.src = _t.thumbnailGifDisable;
            _t.prevIcon.src = _t.prevGifDisable;
            _t.nextIcon.src = _t.nextGifDisable;
            _t.autoPlayIcon.src = _t.playGifDisable;

            _t.thumbnailIcon.alt = _t.nlsStrings.THUMBNAIL_ICON_DISABLED;
            _t.prevIcon.alt = _t.nlsStrings.PREV_ICON_DISABLED;
            _t.nextIcon.alt = _t.nlsStrings.NEXT_ICON_DISABLED;
            _t.autoPlayIcon.alt = _t.nlsStrings.AUTOPLAY_ICON_DISABLED;
        }

        // show title
        if (!groupData.leaveTitle) {
            if (!groupData.title) {
                _t._index = 0;
                _t.imgDescNode.innerHTML = _t.inGroup[_t._index].title;
            }
            else {
                _t.imgDescNode.innerHTML = groupData.title;
            }
        }
        _t.imgNode.alt = _t.imgDescNode.innerHTML;

        // make picture related to thumbnail selector change
        var thumbImages = _t._getThumbImages();
        for (var i = 0; i < thumbImages.length; i++) {
            var thumbImage = thumbImages[i]
            if (_t._index == i) {
                dojo.addClass(thumbImage, _t._thumbHighlightClassName);
            }
            else {
                dojo.removeClass(thumbImage, _t._thumbHighlightClassName);
            }
        }

        _t._ready(src);
    },

    _getThumbImages: function() {
        return dojo.query(".imgThumb");
    },

    _ready: function(src) {
        // summary: A function to trigger all 'real' showing of some src
        var _t = this;

        // listen for 404's:
        _t._imgError = dojo.connect(_t.imgNode, "error", _t, function() {
            dojo.disconnect(_t._imgError);
            // trigger the above onload with a new src:
            _t.imgNode.src = _t.errorImg;
            _t.imgDescNode.innerHTML = this.nlsStrings.IMAGE_NOT_FOUND;
        });

        // connect to the onload of the image
        _t._imgConnect = dojo.connect(_t.imgNode, "load", _t, function(e) {
            _t.resizeTo({
                w: _t.imgNode.width,
                h: _t.imgNode.height,
                duration: _t.duration
            });
            // cleanup
            dojo.disconnect(_t._imgConnect);
            if (_t._imgError) {
                dojo.disconnect(_t._imgError);
            }
        });

        _t.imgNode.src = src;
    },

    _prepNodes: function() {
        // summary: A localized hook to accompany _loadImage
        this._imageReady = false;
        this.show({
            href: this.inGroup[this._index].href,
            title: this.inGroup[this._index].title,
            group: this._lastGroup.group
        });
    },

    resizeTo: function(/* Object */size, forceTitle) {
        // summary: Resize our dialog container, and fire _showImage
        var adjustSize = dojo.boxModel == "border-box" ? dojo._getBorderExtents(this.domNode).w : 0, titleSize = forceTitle ||
        {
            h: 30
        };

        this._lastTitleSize = titleSize;

        // size less than min size
        if (this.adjust && (size.w < 300 || size.h < 200 || titleSize.h + 80 > size.h)) {
            this._lastSize = size;
            size = this._enlargeScaleToFit(size);
        }

        // if size larger than viewport
        if (this.adjust &&
            (size.h + adjustSize + 80 > this._vp.h ||
                size.w + adjustSize + 80 > this._vp.w)) {
            this._lastSize = size;
            size = this._narrowScaleToFit(size);
        }

        var _sizeAnim = dojox.fx.sizeTo({
            node: this.containerNode,
            duration: size.duration || this.duration,
            width: size.w + adjustSize,
            height: size.h + adjustSize
        });
        this.connect(_sizeAnim, "onEnd", "_showImage");
        _sizeAnim.play(15);
    },

    _narrowScaleToFit: function(/* Object */size) {
        // summary: resize an image to fit within the bounds of the viewport
        // size: Object
        //		The 'size' object passed around for this image
        var ns = {};

        // one of the dimensions is too big, go with the smaller viewport edge:
        if (this._vp.h > this._vp.w) {
            // don't actually touch the edges:
            ns.w = this._vp.w - 80;
            ns.h = ns.w * (size.h / size.w);
        }
        else {
            ns.h = this._vp.h - 80;
            ns.w = ns.h * (size.w / size.h);
        }

        // we actually have to style this image, it's too big
        this._wasStyled = true;
        this._setImageSize(ns);

        ns.duration = size.duration;
        return ns; // Object
    },

    _enlargeScaleToFit: function(/* Object */size) {
        // summary: resize an image to fit the min size
        // size: Object
        //		The 'size' object passed around for this image
        var ns = {};
        ns.w = size.w;
        ns.h = size.h;

        // one of the dimensions is too big, go with the smaller viewport edge:
        if (ns.w < 300) {
            ns.w = 300;
        }
        if (ns.h < 200) {
            ns.h = 200;
        }
        if (ns.h < this._lastTitleSize.h + 80) {
            ns.h = this._lastTitleSize.h + 80;
        }

        // we don't need to style this image, even if it's too small(we have limited the min size of container with css)
        this._wasStyled = true;

        ns.duration = size.duration;
        return ns; // Object
    },

    _position: function(/* Event */e) {
        // summary: we want to know the viewport size any time it changes
        this._vp = dijit.getViewport();
        dijit.Dialog.prototype._position.apply(this, arguments);

        // determine if we need to scale up or down, if at all.
        if (e && e.type == "resize") {
            if (this._wasStyled) {
                this._setImageSize(this._lastSize);
                this.resizeTo(this._lastSize);
            }
            else {
                if (this.imgNode.height + 80 > this._vp.h || this.imgNode.width + 60 > this._vp.h) {
                    this.resizeTo({
                        w: this.imgNode.width,
                        h: this.imgNode.height
                    });
                }
            }
        }
    },

    _showImage: function() {
        // summary: Fade in the image, and fire showNav
        this._showImageAnim.play(1);
        if (this._isAutoPlay)
            this._startTimer();
    },

    _showNav: function() {
        // summary: Fade in the footer, and setup our connections.
        this._showNavAnim.play(1);
    },

    hide: function() {
        // summary: Hide the Master Lightbox
        dojo.fadeOut({
            node: this.titleNode,
            duration: 200,
            // #5112 - if you _don't_ change the .src, safari will 
            // _never_ fire onload for this image
            onEnd: dojo.hitch(this, function() {
                this.imgNode.src = this._blankGif;
            })
        }).play(5);

        dijit.Dialog.prototype.hide.apply(this, arguments);

        this.inGroup = null;
        this._index = null;
    },

    _handleKey: function(/* Event */e) {
        // summary: Handle keyboard navigation internally
        if (!this.open) {
            return;
        }

        var dk = dojo.keys;
        switch (e.charOrCode) {

            case dk.ESCAPE:
                this.hide();
                break;

            case dk.DOWN_ARROW:
            case dk.RIGHT_ARROW:
            case 78: // key "n"
                this._nextNodeClickHandler();
                break;

            case dk.UP_ARROW:
            case dk.LEFT_ARROW:
            case 80: // key "p" 
                this._prevNodeClickHandler();
                break;
        }
    }
});
