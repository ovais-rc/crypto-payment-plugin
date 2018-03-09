//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"dojo/_base/event",
	"dojo/_base/lang",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojo/on",
	"dojo/query",
	"dijit/_WidgetBase",
	"dojo/NodeList-traverse"
], function(declare, event, lang, domClass, domConstruct, domStyle, on, query, _WidgetBase) {
	return declare([_WidgetBase], {
		auto: 0,
		pageIndex: 0,
		speed: 500,
		wrap: true,
		preventSwipe: false,
		
		_setAutoAttr: function(auto) {
			if (this.autoInterval) {
				window.clearInterval(this.autoInterval);
				this.set("autoInterval", null);
			}
			if (auto) {
				var autoInterval = window.setInterval(lang.hitch(this, "nextPage", true), auto);
				this.set("autoInterval", autoInterval);
			}
			this._set("auto", auto);
		},
		
		_setColumnCountAttr: function(columnCount) {
			var items = query(this.ul).children("li");
			items.style("width", 100 / Math.min(columnCount, items.length) + "%");
			this._set("columnCount", columnCount);
		},
		
		_setPageCountAttr: function(pageCount) {
			if (this.prevPageButton) {
				domClass.toggle(this.prevPageButton, "hidden", pageCount <= 1);
			}
			if (this.nextPageButton) {
				domClass.toggle(this.nextPageButton, "hidden", pageCount <= 1);
			}
			if (this.pageControlButton) {
				domClass.toggle(this.pageControlButton, "hidden", pageCount <= 1);
			}
			if (this.pageControlMenu) {
				deactivate(this.pageControlMenu);
			}
			if (this.pageControl) {
				domClass.toggle(this.pageControl, "hidden", pageCount <= 1);
				while (this.pageControl.firstChild) {
					this.pageControl.removeChild(this.pageControl.firstChild);
				}
				for (var i = 0; i < pageCount; i++) {
					this.pageControl.appendChild(this.pageButtonList[i]);
				}
			}
			this._set("pageCount", pageCount);
			this.set("pageIndex", 0);
		},
		
		_setPageIndexAttr: function(pageIndex) {
			this.startScroll();
			this.endScroll(this.speed);
			
			if (this.dir === "rtl") {
				this.ul.style.right = -pageIndex * 100 + "%";
			}
			else {
				this.ul.style.left = -pageIndex * 100 + "%";
			}
			this.ul.style.transition
				= this.ul.style.mozTransition
				= this.ul.style.webkitTransition
				= this.speed + "ms";
			
			var background = this.backgroundList[this.pageIndex];
			if (background) {
				background.style.opacity = "0";
				background.style.transition
					= background.style.mozTransition
					= background.style.webkitTransition
					= this.speed + "ms";
			}
			background = this.backgroundList[pageIndex];
			if (background) {
				background.style.opacity = null;
				background.style.transition
					= background.style.mozTransition
					= background.style.webkitTransition
					= this.speed + "ms";
			}
			
			if (this.pageControl) {
				var pageButtons = query(this.pageControl).children("a");
				pageButtons.forEach(function(pageButton, i) {
					domClass.toggle(pageButton, "selected", i === pageIndex);
				});
				
				if (domClass.contains(this.pageControl, "number")) {
					if (this.pageControlMenu) {
						deactivate(this.pageControlMenu);
					}
					if (this.pageControlButton) {
						this.pageControlButton.innerHTML = pageButtons[pageIndex].innerHTML;
					}
					query(this.pageControl).children(".ellipsis").forEach(function(ellipsis) {
			            ellipsis.parentNode.removeChild(ellipsis);
			        });
					var n = pageButtons.length;
					var ellipsis = null;
					pageButtons.forEach(function(pageButton, i) {
						var visible = (n <= 5 || i === 0 || i === n - 1
								|| pageIndex < 3 && i < 3
								|| pageIndex > n - 3 && i >= n - 3
								|| i >= pageIndex - 1 && i <= pageIndex + 1);
						domClass.toggle(pageButton, "hidden", !visible);
						if (visible) {
							ellipsis = null;
						}
						else if (!ellipsis) {
							ellipsis = document.createElement("span");
							ellipsis.className = "ellipsis";
							pageButton.parentNode.insertBefore(ellipsis, pageButton);
						}
					});
				}
			}
			
			this._set("pageIndex", pageIndex);
		},
		
		_ontouchstart: function(e) {
			this.startScroll();
			if (this.auto) {
				this.set("auto", 0);
			}
			if (e.touches.length !== 1) {
				this.set("swipeData", null);
				this.endScroll();
				return;
			}
			this.set("swipeData", {
				x1: e.touches[0].pageX,
				y1: e.touches[0].pageY,
				t1: new Date().getTime(),
				dx: 0
			});
			this.ul.style.transition
				= this.ul.style.mozTransition
				= this.ul.style.webkitTransition
				= "none";
		},
		
		_ontouchmove: function(e) {
			if (!this.swipeData) {
				return;
			}
			else if (e.touches.length > 1) {
				this.set("swipeData", null);
				this.set("pageIndex", this.pageIndex);
				return;
			}
			this.swipeData.dx = e.touches[0].pageX - this.swipeData.x1;
			if (this.swipeData.y1) {
				var adx = Math.abs(this.swipeData.dx);
				var ady = Math.abs(e.touches[0].pageY - this.swipeData.y1);
				
				if (adx < 10 && ady < 10) {
					event.stop(e);
					return;
				}
                else if(dojo.hasClass(e.currentTarget.childNodes[1], 'ci_overlay_wide_rect_small') && e.touches[0].target.nodeName !== 'IMG'){
                    //prevent swiping the background image if the user is swiping the overlay on top                    
					this.preventSwipe = true;
					event.stop(e);
					return;
                }
				else if (adx < ady) {
					this.set("swipeData", null);
					this.set("pageIndex", this.pageIndex);
					return;
				}
				else {
					this.swipeData.y1 = null;
				}
			}
			if (this.dir === "rtl") {
				this.ul.style.right = (-this.pageIndex - this.swipeData.dx / this.content.clientWidth) * 100 + "%";
			}
			else {
				this.ul.style.left = (-this.pageIndex + this.swipeData.dx / this.content.clientWidth) * 100 + "%";
			}
			event.stop(e);
		},
		
		_ontouchend: function(e) {
			if(this.preventSwipe === true){
				this.preventSwipe = false;
				event.stop(e);
			}
			else{
				if (!this.swipeData) {
					return;
				}
				var adx = Math.abs(this.swipeData.dx);
				var dt = new Date().getTime() - this.swipeData.t1;
				if (adx < 50 || adx < this.content.clientWidth / 2 && dt >= 500) {
					this.set("swipeData", null);
					this.set("pageIndex", this.pageIndex);
					return;
				}
				if (this.swipeData.dx < 0 && this.dir === "rtl" || this.swipeData.dx > 0 && this.dir !== "rtl") {
					this.prevPage();
				}
				else {
					this.nextPage();
				}
				this.set("swipeData", null);
				event.stop(e);	
			}
	
		},
		
		postCreate: function() {
			this.inherited(arguments);
			
			// _AttachMixin stand-in since it's not available in dojo18
			query("[data-dojo-attach-point]", this.domNode).forEach(lang.hitch(this, function(element) {
				var attachPoint = element.getAttribute("data-dojo-attach-point");
				if (attachPoint) {
					this.set(attachPoint, element);
				}
			}));
			
			this.set("dir", domStyle.getComputedStyle(this.domNode).direction);
			
			this.set("backgroundList", new Array());
			query(this.ul).children("li").forEach(lang.hitch(this, function(li, i) {
				var background = li.querySelector("[data-carousel-background]");
				if (background) {
					this.domNode.insertBefore(background, this.content);
					background.style.opacity = (i === 0 ? "1" : "0");
				}
				this.backgroundList.push(background);
			}));
			
			this.own(on(this.content, "touchstart", lang.hitch(this, "_ontouchstart")));
			this.own(on(this.content, "touchmove", lang.hitch(this, "_ontouchmove")));
			this.own(on(this.content, "touchend", lang.hitch(this, "_ontouchend")));
			
			if (this.prevPageButton) {
				this.own(on(this.prevPageButton, "click", lang.hitch(this, function(e) {
					if (this.auto) {
						this.set("auto", 0);
					}
					this.prevPage(this.wrap);
					event.stop(e);
				})));
			}
			if (this.nextPageButton) {
				this.own(on(this.nextPageButton, "click", lang.hitch(this, function(e) {
					if (this.auto) {
						this.set("auto", 0);
					}
					this.nextPage(this.wrap);
					event.stop(e);
				})));
			}
			
			if (this.pageControl) {
				var pageButtonTemplate = this.pageControl.innerHTML;
				if (pageButtonTemplate) {
					pageButtonTemplate = lang.trim(pageButtonTemplate);
				}
				this.set("pageButtonTemplate", pageButtonTemplate);
				this.set("pageButtonList", new Array());
				query(this.ul).children("li").forEach(lang.hitch(this, function(item, i) {
					var pageButton = item.querySelector("[data-carousel-pageButton]");
					if (pageButton) {
						pageButton.parentNode.removeChild(pageButton);
					}
					if (this.pageButtonTemplate) {
						pageButton = domConstruct.toDom(lang.replace(this.pageButtonTemplate, [ i + 1 ]));
					}
					else if (!pageButton) {
						var img = item.querySelector("img");
						pageButton = domConstruct.create("a", { href: "#", title: (img && img.alt ? img.alt : "") });
						if (img) {
							img = domConstruct.create("img", { src: img.src, alt: (img.alt ? img.alt : "") }, pageButton);
							// IE8 fix
							img.removeAttribute("width");
							img.removeAttribute("height");
						}
					}
					this.own(on(pageButton, "click", lang.hitch(this, function(e) {
						if (this.auto) {
							this.set("auto", 0);
						}
						var pageIndex = query(this.pageControl).children("a").indexOf(e.currentTarget);
						if (pageIndex !== this.pageIndex) {
							this.set("pageIndex", pageIndex);
						}
						event.stop(e);
					})));
					this.pageButtonList.push(pageButton);
				}));
			}
			
			this.own(on(window, "resize", lang.hitch(this, "resize")));
			this.resize();
		},
		
		resize: function() {
			this.inherited(arguments);
			
			var columnCount = (this.columnCount ? this.columnCount : 1);
			if (this.columnCountByWidth) {
				for (var width in this.columnCountByWidth) {
					if (this.content.clientWidth >= width) {
						columnCount = this.columnCountByWidth[width];
					}
				}
			}
			if (columnCount != this.columnCount) {
				this.set("columnCount", columnCount);
			}
			
			var pageCount = Math.ceil(query(this.ul).children("li").length / columnCount);
			if (pageCount !== this.pageCount) {
				this.set("pageCount", pageCount);
			}
		},
		
		prevPage: function(wrap) {
			this.set("pageIndex", (wrap ? (this.pageIndex === 0 ? this.pageCount - 1 : this.pageIndex - 1) : Math.max(this.pageIndex - 1, 0)));
		},
		
		nextPage: function(wrap) {
			this.set("pageIndex", (wrap ? (this.pageIndex + 1) % this.pageCount : Math.min(this.pageIndex + 1, this.pageCount - 1)));
		},
		
		startScroll: function() {
			if (this.endScrollTimeout) {
				window.clearTimeout(this.endScrollTimeout);
			}
			query(this.ul).children("li").forEach(function(item) {
				domClass.remove(item, "hidden");
			});
		},
		
		endScroll: function(delay) {
			if (this.endScrollTimeout) {
				window.clearTimeout(this.endScrollTimeout);
			}
			if (delay) {
				this.set("endScrollTimeout", window.setTimeout(lang.hitch(this, "endScroll"), delay));
			}
			else {
				query(this.ul).children("li").forEach(lang.hitch(this, function(item, i) {
					domClass.toggle(item, "hidden", (i < this.pageIndex * this.columnCount || i >= (this.pageIndex + 1) * this.columnCount));
				}));
			}
		}
	});
});
