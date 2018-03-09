//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

var recentProductMetrics = null;
var recentCategoryMetrics = null;
var recentESpotMetrics = null;
var eventSource = null;
var eventOrigin = null;
var nlsText = null;
var ciInventoryView = false;
var lastSubOverlayId = null;
var productHooks = [];
var categoryHooks = [];
var espotHooks = [];
var ESPOT_THRESHOLD = 130;
var CAT_THRESHOLD = 50;
var categoryTimeoutInit = false;
var productTimeoutInit = false;
var espotTimeoutInit = false;
var hideReOrderLink = false;

function removeSpaceFromId(id) {
	return id.split(" ").join("--_-");
}

function addSpaceToId(id) {
	return id.split("--_-").join(" ");
}

function encodeId(id) {
	return id;
}

function decodeId(id) {
	return id;
}

function openWatch(partNumber) {
	if (eventSource && eventOrigin) {
		eventSource.postMessage(JSON.stringify({cmd:'open_watch', partNumber:partNumber}), eventOrigin);
	}
}

function editProduct(partNumber) {
	if (eventSource && eventOrigin) {
		eventSource.postMessage(JSON.stringify({cmd:'edit_product', partNumber:partNumber}), eventOrigin);
	}
}

function editCategory(categoryIdentifier) {
	if (eventSource && eventOrigin) {
		eventSource.postMessage(JSON.stringify({cmd:'edit_category', categoryIdentifier:categoryIdentifier}), eventOrigin);
	}
}

function reOrder(categoryIdentifier) {
	if (eventSource && eventOrigin) {
		//change order of products in a category
		eventSource.postMessage(JSON.stringify({cmd:'re_order', categoryIdentifier:categoryIdentifier}), eventOrigin);
	}
}

function changeStoreViewLanguage(languageId) {
	if (eventSource && eventOrigin) {
		eventSource.postMessage(JSON.stringify({cmd:'change_language', languageId:languageId}), eventOrigin);
	}
}

function showInfo(emsName) {
	require(["dojo/dom"], function(dom){
		var idDiv = dom.byId('ci_widgetSuffix_espot_' + emsName);
		var ids = undefined;
		var layoutId = undefined;
		var widgetId = undefined;
		if (idDiv){
			var patt = /^(-\d|\d)\d*$/;
			ids = idDiv.innerHTML.split("_");
			if (patt.test(ids[4])&& patt.test(ids[3])){
				layoutId = ids[4];
				widgetId = ids[3];
			}
		}
		var previewReport = undefined;
		var previewReportDiv = dom.byId('ci_previewreport_espot_' + emsName);
		if (previewReportDiv){
			previewReport = JSON.parse(previewReportDiv.innerHTML);
		}
		eventSource.postMessage(JSON.stringify({cmd:'show_info', previewReport:previewReport, layoutId: layoutId, widgetId: widgetId}), eventOrigin);
	});
	
}

function getOverlayType(overlayId) {
	return overlayId.split("_")[1];
}

function processTap(e) {
	if ((e.currentTarget.id).indexOf("ci_") === 0) {
		if (e.target.tagName.toLowerCase() === 'a') {
			if (e.target.id.indexOf('next') === 0) {
				overlayNext(e.currentTarget.id);
			}
			else if (e.target.id.indexOf('prev') === 0) {
				overlayPrev(e.currentTarget.id);
			}
		}
		else if (e.target.parentElement.tagName.toLowerCase() === 'a') {
			var parent = e.target.parentElement;
			
			if (parent.href.indexOf('editCategory') !== -1) {
				editCategory(addSpaceToId(e.currentTarget.id.split("_").splice(2).join("_")));
			}
			else if (parent.href.indexOf('editProduct') !== -1) {
				editProduct(e.currentTarget.id.split("_").splice(2).join("_"));
			}
			else if (parent.href.indexOf('reOrder') !== -1) {
				reOrder(addSpaceToId(e.currentTarget.id.split("_").splice(2).join("_")));
			}
			else if (parent.href.indexOf('showInfo') !== -1) {
				showInfo(e.currentTarget.id.split("_").splice(2).join("_"));
			}
			else if (parent.href.indexOf('openWatch') !== -1) {
				openWatch(e.currentTarget.id.split("_").splice(2).join("_"));
			}
		}
		else {
			toggleSubOverlay(e.currentTarget.id);
			dojo.stopEvent(e);
		}
	}
}

function processSwipe(dx, id) {
	if (dx < -50) {
		if (!dojo.hasClass('next_' + id, 'ci_not_visible')) {
			overlayNext(id);
		}
	}
	else if (dx > 50) {
		if (!dojo.hasClass('prev_' + id, 'ci_not_visible')) {
			overlayPrev(id);
		}
	}
}

/**
 * Calculate the maximum number of metrics that should be displayed in the given overlay
 * @param overlayId
 * @returns {Number}
 */
function calculatePagingSize(overlayId) {
	var w = dojo.position(dojo.query(".ci_data", overlayId).parent()[0]).w;
	var h = dojo.position(dojo.query(".ci_data", overlayId).parent()[0]).h;
	var li = dojo.query(".ci_data > ul > li", overlayId);
	var overlayType = getOverlayType(overlayId);
	
	var width = 0;
	if (overlayType && overlayType === "product") {
		// Always one column
		width = 1;
	}
	else {
		if (overlayType && overlayType === "espot") {
			if (h > ESPOT_THRESHOLD) {
				// Optimal overlay widths plus a buffer
				var espotOverlayWidth = [325, 490, 630, 775, 925, 1050, 1210, 1375, 1510, 1660, 1825, 2000, 2200, 2400, 2600, 2800];
				do {
					// Determine number of espot metrics to display horizontally
				} while (width < espotOverlayWidth.length && w > espotOverlayWidth[width++] + Math.floor(200/width));
			}
		}
		else if (overlayType && overlayType === "category") {
			if (h > CAT_THRESHOLD) {
				// Always one column for bigger category overlays
				width = 1;
			}
			else {
				// Optimal overlay widths plus a buffer
				var catOverlayWidth;
				if (isAndroid() || isIOS()) {
					catOverlayWidth = [400,650, 840, 1140, 1367, 1600, 1855];
				}
				else {
					catOverlayWidth = [650, 840, 1140, 1367, 1600, 1855, 2065, 2270, 2475, 2660, 2840, 3010, 3200];
				}
				
				do {
					// Determine the number of metrics to display horizontally based on size of overlay
				} while (width < catOverlayWidth.length && w > catOverlayWidth[width++] + Math.floor(100/width));
			}
		}
		
		if (width === 0) {
			// Width not previously determined
			var overlayWidth = [400, 550, 800, 950, 1100, 1325, 1600, 1825, 1950, 2150];
			do {
				// Determine the number of metrics to display horizontally based on size of overlay
			} while (width < overlayWidth.length && w > overlayWidth[width++] + 25);
		}
	}
	
	var height = 0;
	if (overlayType && overlayType === "espot") {
		height = 1;
	}
	else {
		dojo.some(li, function(node, i) {
			if (dojo.hasClass(node, "ci_hidden")) {
				// Temporarily un-hide node so height can be measured
				dojo.removeClass(node, "ci_hidden");
				if (dojo.position(node).h <= h && h > 0) {
					// remove height of node from overlay height
					h -= dojo.position(node).h;
					height++;
					dojo.addClass(node, "ci_hidden");
				}
				else {
					dojo.addClass(node, "ci_hidden");
					return true;
				}
			}
			else {
				if (dojo.position(node).h <= h && h > 0) {
					//remove height of node from overlay height
					h -= dojo.position(node).h;
					height++;
				}
				else {
					return true;
				}
			}
			if (overlayType && (overlayType === "product" || overlayType === "category") && height > 1) {
				// height padding buffer
				h -= 10;
			}
		});
	}

	return width * height;
}
function overlayNext(overlayId) {
	var pageSize = calculatePagingSize(overlayId);
	var overlayType = getOverlayType(overlayId);
	//var widthStyle = (overlayType && overlayType === "espot") ? Math.floor(60/pageSize) + "%" : null;
	
	var li = dojo.query(".ci_data > ul > li", overlayId);
	dojo.some(li, function(node, i) {
		if (dojo.hasClass(node, "ci_show")) {
			if ((i + pageSize) >= (li.length - pageSize)) {
				dojo.addClass("next_" + overlayId, "ci_not_visible");
			}
			if (i <= li.length - pageSize) {
				var j = 0;
				do {
					dojo.toggleClass(li[i + j], "ci_show");
					dojo.toggleClass(li[i + j], "ci_hidden");
					j++;
				} while (li[i + j] && dojo.hasClass(li[i + j], "ci_show") && j < pageSize);
				
				var groupSize = 0;
				for (k = 0; k < pageSize; k++) {
					if (li[i + j + k]) {
						var metricId = dojo.attr(li[i + j + k], "metricId");
						if (metricId === "itemsSold" || metricId === "itemSales") {
							groupSize = 1;
							if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_p']", overlayId).length > 0) {
								groupSize++;
							}
							if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_apv']", overlayId).length > 0) {
								groupSize++;
							}							
						}
						if (groupSize != 0 && pageSize >= groupSize) {
							if (groupSize <= pageSize - k) {
								dojo.toggleClass(li[i + j + k], "ci_show");
								dojo.toggleClass(li[i + j + k], "ci_hidden");
								groupSize--;
							}
						}
						else {
							dojo.toggleClass(li[i + j + k], "ci_show");
							dojo.toggleClass(li[i + j + k], "ci_hidden");
						}
//						if (widthStyle) {
//							dojo.setStyle(li[i + j + k], "width", widthStyle);
//						}
					}
						
				}
				if (dojo.hasClass("prev_" + overlayId, "ci_not_visible")) {
					dojo.removeClass("prev_" + overlayId, "ci_not_visible");
				}
			}
			return true;
		}
	});
}

function overlayPrev(overlayId) {
	var pageSize = calculatePagingSize(overlayId);
	var li = dojo.query(".ci_data > ul > li", overlayId);
	dojo.some(li, function(node, i) {
		if (dojo.hasClass(node, "ci_show")) {
			if ((i - pageSize) <= 0) {
				dojo.addClass("prev_" + overlayId, "ci_not_visible");
			}
			if (i - pageSize >= 0 - pageSize) {
				var j = 0;
				do {
					dojo.toggleClass(li[i + j], "ci_show");
					dojo.toggleClass(li[i + j], "ci_hidden");
					j++;
				} while (li[i + j] && dojo.hasClass(li[i + j], "ci_show") && j < pageSize);
				
				var groupSize = 0;
				for (k = 1; k <= pageSize; k++) {
					if (li[i - k]) {
						var metricId = dojo.attr(li[i - k], "metricId");
						
						if (metricId.lastIndexOf("_p") != -1 || metricId.lastIndexOf("_apv") != -1) {
							groupSize++;
							if (groupSize === pageSize) {
								for (l = 0; l < groupSize; l++) {
									dojo.toggleClass(li[i - k + l], "ci_show");
									dojo.toggleClass(li[i - k + l], "ci_hidden");
								}
							}
						}
						else if (metricId === "itemsSold" || metricId === "itemSales") {
							groupSize++;
							if (groupSize <= pageSize) {
								for (l = 0; l < groupSize; l++) {
									dojo.toggleClass(li[i - k + l], "ci_show");
									dojo.toggleClass(li[i - k + l], "ci_hidden");
								}
							}
							groupSize = 0;
						}
						else {
							dojo.toggleClass(li[i - k], "ci_show");
							dojo.toggleClass(li[i - k], "ci_hidden");
						}
					}
				}
				if (dojo.hasClass("next_" + overlayId, "ci_not_visible")) {
					dojo.removeClass("next_" + overlayId, "ci_not_visible");
				}
			}
			return true;
		}
	});	
}

function getCIClassSize(overlayId) {
	var overlaySize = dojo.position(overlayId).w;
	if (overlaySize < 320) {
		return "ci_xxs";		
	}
	else if (overlaySize < 768) {
		return "ci_xs";
	}
	else if (overlaySize < 992) {
		return "ci_sm";
	}
	else if (overlaySize < 1200) {
		return "ci_md";
	}
	else {
		return "ci_lg";
	}
}
function toggleSubOverlay(subOverlayId) {
	var div = dojo.query('div[id^="' + encodeId(subOverlayId) + '"]  div[class*="ci_sub_overlay_"]')[0];
	if (div) {
		if (lastSubOverlayId != null && (lastSubOverlayId != subOverlayId)) {
			// Hide the last overlay that was opened, if any
			var lastOverlay = dojo.query('div[id^="' + encodeId(lastSubOverlayId) + '"]  div[class*="ci_sub_overlay_"]')[0];
			dojo.addClass(lastOverlay, "ci_not_visible");
		}
		dojo.toggleClass(div, "ci_not_visible");
		lastSubOverlayId = dojo.hasClass(div, "ci_not_visible") ? null : subOverlayId;
	}
}

function toggleCIInventoryView(){
	var productDivs = dojo.query('div[id^="ci_product_"]');
	var inventoryClass = "ci_inventory";
	if (ciInventoryView){
		productDivs.forEach(function(node){
			var position = dojo.position(node);
			dojo.addClass(node, inventoryClass);
			if (position.h > 0 && position.w > 0){
				var inventoryDiv = dojo.query('.ci_overlay.ci_inventory_overlay', node)[0];
				if (inventoryDiv){
					drawCIInventory(inventoryDiv);
				}
			}
		});
	}
	else {
		productDivs.forEach(function(node){
			dojo.removeClass(node, inventoryClass);
		});
	}
}

function drawCIInventory(e){
	
	var position = dojo.position(e);
	var h = position.h;
	var w = position.w;
	
	//position inventory info div
	dojo.query('.ci_inventory_info', e).style({
		width: w+'px',
		height: h+'px',
		padding: '0'
	});
	
	//position child div, centering text
	var inventoryTextDiv = dojo.query('.ci_child_inventory_info', e)[0];
	var inventoryTextSize = dojo.position(inventoryTextDiv);
	var top = (h/2 - inventoryTextSize.h/2) * 1.1;
	var left = (w/2 - inventoryTextSize.w/2);
	dojo.style(inventoryTextDiv, {
		top: top+'px',
		left: left+'px',
		visibility: 'visible'
	});
	
	var percentageAttr = e.getAttribute("data-percentage");
	if (percentageAttr){
		var canvas = dojo.query('canvas', e)[0];
		var percentage = Number(percentageAttr);
		var lineWidth = 6;
		var r = (Math.min(w*0.8, h*0.8) - lineWidth)/2;
		var ctx = canvas.getContext("2d");
		canvas.setAttribute('width', w);
		canvas.setAttribute('height', h);
		ctx.clearRect(0,0,w,h);
		
		ctx.beginPath();
		ctx.lineWidth = lineWidth;
		ctx.strokeStyle="white";
		ctx.arc(w/2,h/2,r,1.5*Math.PI,(1.5 + 2*percentage)*Math.PI);
		ctx.stroke();
		ctx.beginPath();
		ctx.lineWidth = lineWidth
		ctx.strokeStyle="grey";
		ctx.arc(w/2,h/2,r,(1.5 + 2*percentage)*Math.PI, 1.5*Math.PI);
		ctx.stroke();
	}
}

function showProductOverlay(metrics) {
	var delay = 250;
	
	if (!productTimeoutInit) {
		dojo.subscribe("CIRefreshProductOverlay", function() {
			setTimeout(function() {
				showProductOverlay(_addEmptyMetrics(recentProductMetrics, "product"));
				toggleCIInventoryView();
			}, delay);
		});
		require(["dojo/on", "dojo/topic"], function(on, topic){
			if (!isAndroid() && !isIOS()) {
				// Listen to resize only on desktop
				window.addEventListener("resize", function(e) {
					var timeout;
					clearTimeout(timeout);
					timeout = setTimeout(function(){
						if (!ciInventoryView) {
							// Don't redraw product metrics if showing inventory
							showProductOverlay(_addEmptyMetrics(recentProductMetrics, "product"));							
						}
						toggleCIInventoryView();
					}, 500);
				},false);
		}
			topic.subscribe("CIRefreshProductOverlay", function(){
				setTimeout(function() {
					showProductOverlay(_addEmptyMetrics(recentProductMetrics, "product"));
					toggleCIInventoryView();
				}, delay);
			});			
		});		
		productTimeoutInit = true;
	}
	
	recentProductMetrics = metrics;
	for (var m in metrics) {
		var div = dojo.byId("ci_product_" + encodeId(metrics[m].partNumber));
		if (div) {
			dojo.style(div.parentNode, "position", "relative");
			dojo.query('> .ci_overlay_root', div).forEach(dojo.destroy);	
			var overlay = "<div class='ci_overlay_root'>";
			if (dojo.position(div).h > 320) {
				overlay += "<div class='ci_overlay products ci_sub_overlay_top_large ci_not_visible " + getCIClassSize(div.id) + "'>";
			}
			else if (dojo.position(div).h > 290){
				overlay += "<div class='ci_overlay products ci_sub_overlay_top_medium ci_not_visible " + getCIClassSize(div.id) + "'>";
			}
			else{
				overlay += "<div class='ci_overlay products ci_sub_overlay_top_small ci_not_visible " + getCIClassSize(div.id) + "'>";
			}
			overlay += "<div class='ci_actions'>";
			//overlay += "<div class='ci_overlay_close' onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'></div>";
			overlay += "<ul>";
			overlay += "<li><span title='"+ metrics[m].partNumber.split("_").slice(1).join("_") + "'>" + metrics[m].partNumber.split("_").slice(1).join("_") + "</span></li>";
			overlay += "<li><a role='button' href='javascript:openWatch(\"" + encodeId(metrics[m].partNumber) + "\");'>" +
						"<div class='watch_icon action_icons'></div><span title='"+nlsText.watch+"'>" + nlsText.watch + "</span></a></li>";
			overlay += "<li><a role='button' href='javascript:editProduct(\"" + encodeId(metrics[m].partNumber) + "\");'>" +
						"<div class='edit_icon action_icons'></div><span title='"+ nlsText.edit +"'>" + nlsText.edit + "</span></a></li>";
			overlay += "</ul>";
			overlay += "</div>";
			overlay += "</div>";
			var additionalOverlayClass = "ci_overlay_tall_rect_small";
			if (dojo.position(div).h > 320) {
				additionalOverlayClass = "ci_overlay_tall_rect_large";
			}
			else if (dojo.position(div).h > 290) {
				additionalOverlayClass = "ci_overlay_tall_rect_medium";
			}
			overlay += "<div class='ci_overlay products " + additionalOverlayClass + " " + getCIClassSize(div.id) + "'>";
			overlay += "<div class='ci_data'>";			
			
			overlay += "<a id='prev_" + div.id + "' class='ci_left_arrow ci_not_visible' href='javascript:overlayPrev(\"" + div.id + "\");'><span></span></a>";
			overlay += "<a id='next_" + div.id + "' class='ci_right_arrow' href='javascript:overlayNext(\"" + div.id + "\");'><span></span></a>";			
			overlay += "<ul onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
			
			var appendNoDataText = true;
			for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
				for (var i in metrics[m]) {
					switch (i) {
						default: {
							if (metrics[m][i].order === c) {
								appendNoDataText = false;
								if (i === "itemSales" || i === "itemsSold") {
									if (metrics[m][i].a) {
										overlay += "<li metricId='" + i + "' class='ci_hidden'>";
										overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + "</span>";
										overlay += "<span title='" + metrics[m][i].a + "'>" + metrics[m][i].a + "</span>";
										overlay += "</li>";
									}
									if (metrics[m][i].p) {
										overlay += "<li metricId='" + i + "_p' class='ci_hidden'>";
										overlay += "<span title='" + nlsText.plan + "'>" + nlsText.plan + "</span>";
										overlay += "<span title='" + metrics[m][i].p + "'>" + metrics[m][i].p + "</span>";
										overlay += "</li>";
									}
									
									if (metrics[m][i].apv) {
										overlay += "<li metricId='" + i + "_apv' class='ci_hidden'>";
										overlay += "<span title='" + nlsText.variance + "'>" + nlsText.variance + "</span>";
										overlay += "<span title='" +  metrics[m][i].apv + "'>" + metrics[m][i].apv + "</span>";
										overlay += "</li>";
									}							
								}								
								else {
									overlay += "<li metricId='" + i + "' class='ci_hidden'>";
									overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + "</span>";
									if (metrics[m][i].a) {
										overlay += "<span title='" + metrics[m][i].a + "'>" + metrics[m][i].a + "</span>";
									}
									else {
										overlay += "<span title='" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
									}
									overlay += "</li>";
								}
							}
						}
						case "partNumber": // metric data that should not be displayed
						case "parentCategoryIdentifier":
						case "rank":
						case "totalInventory": // inventory related metrics should only exist for products
						case "displayInventoryOnhandPercentage":
						case "inventoryOnHand":
						case "inventoryOnOrder":
						case "inventoryOnHandPercentage":
							break;
						case "data": {
							if (metrics[m][i] === "none" && c === 0) {
								// Only want one entry added
								appendNoDataText = false;
								overlay += "<li metricId='no_data' class='ci_hidden'>" + nlsText.nodata + "</li>";							
							}
							break;
						}
					}
				}
			}
			
			if (appendNoDataText) {				
				overlay += "<li metricId='no_data' class='ci_hidden'>" + nlsText.nodata + "</li>";							
			}
			
			overlay += "</ul>";
			overlay += "</div>";
			overlay += "</div>";
			
			// inventory view
			if (metrics[m].data && metrics[m].data === "none"){
				overlay += "<div class='ci_overlay ci_inventory_overlay " + additionalOverlayClass +"' id='inventory_" + div.id + "'";
				overlay += " onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
				overlay += "<div class='ci_inventory_info'>";
				overlay += "<div class='ci_child_inventory_info' style='visibility: hidden;'>";
				overlay += "<span title='" + nlsText.nodata + "'>" + nlsText.nodata +"</span>";
				overlay += "</div>";
				overlay += "</div>";
				overlay += "</div>";
			}
			else {
				// inventory view
				var totalInventory = metrics[m].totalInventory || nlsText.undefinedValue;
				var percentage = metrics[m].inventoryOnHandPercentage;
				var displayPercentage = metrics[m].displayInventoryOnhandPercentage || nlsText.undefinedValue;
				
				overlay += "<div class='ci_overlay ci_inventory_overlay " + additionalOverlayClass +"' id='inventory_" + div.id + "'";
				overlay += "' data-percentage='" + percentage+ "'";
				overlay += " onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
				overlay += "<canvas id='inventory_canvas_"+ div.id + "'></canvas>";
				overlay += "<div class='ci_inventory_info'>";
				overlay += "<div class='ci_child_inventory_info' style='visibility: hidden;'>";
				overlay += "<span title='"+ displayPercentage + "' class='percentage'>" + displayPercentage + "</span>";
				overlay += "<span title='" + nlsText.ofSKUsInStock + "'>" + nlsText.ofSKUsInStock +"</span>";
				overlay += "<span title='" + totalInventory + "' class='inventory'>" + totalInventory + "</span>";
				overlay += "<span title='" + nlsText.units + "'>" + nlsText.units + "</span>";
				overlay += "</div>";
				overlay += "</div>";
				overlay += "</div>";
				
				if (isAndroid() || isIOS()) {
					require(["dojo/on", "dojox/gesture/swipe", "dojox/gesture/tap", "dojo/_base/event"], function(on, swipe, tap, event) {
						on(div, tap, function(e) {
							processTap(e);
						});
						
						on(div, swipe.end, function(e) {
							processSwipe(e.dx, e.currentTarget.id);					
						});
					});
				}
			}
			overlay += "</div>";
			if (dojo.query(div).closest(".productListingWidget").length > 0) {
				if (metrics[m].rank) {
					// Only add ranking if part of the catalog entry list widget and ranking exists
					dojo.query('> .ci_overlay_triangle', div).forEach(dojo.destroy);
					var style = metrics[m].color ? metrics[m].color : '';
					overlay += "<div class='ci_overlay_triangle " + style + "'>";
					overlay += "<span title='" + metrics[m].rank + "'>" + metrics[m].rank + "</span>";
					overlay += "</div>";
				}
				else {
					// Destroy any existing ranking
					dojo.query('> .ci_overlay_triangle', div).forEach(dojo.destroy);
				}
			}
			
			dojo.place(overlay, div, "first");
			var pageSize = calculatePagingSize(div.id);
			if (dojo.query(".ci_data > ul > li", div).length <= pageSize) {
				dojo.toggleClass(dojo.byId('next_' + div.id), "ci_not_visible");
			}
			dojo.some(dojo.query(".ci_data > ul > li", div), function(node, i) {
				var metricId = dojo.attr(node, "metricId");
				if (metricId === "itemsSold" || metricId === "itemSales") {
					var groupSize = 1;
					if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_p']", div).length > 0) {
						groupSize++;
					}
					if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_apv']", div).length > 0) {
						groupSize++;
					}
					if (groupSize > pageSize) {
						return true;
					}
				}
				if (pageSize-- === 0) {
					return true;
				}
				else {
					dojo.toggleClass(node, "ci_show");
					dojo.toggleClass(node, "ci_hidden");
				}
			});
		}
	}	
}

function showCategoryOverlay(metrics, event) {
	var delay = 250;
	
	if (!categoryTimeoutInit) {
		dojo.subscribe("CIRefreshProductOverlay", function() {
			setTimeout(function() {
				showProductOverlay(_addEmptyMetrics(recentProductMetrics, "product"));
				toggleCIInventoryView();
			}, delay);
		});
		require(["dojo/on", "dojo/topic"], function(on, topic){
			if (!isAndroid() && !isIOS()) {
				// Listen to resize only on desktop
				window.addEventListener("resize", function(e) {
					var timeout;
					clearTimeout(timeout);
					timeout = setTimeout(function(){
						showCategoryOverlay(_addEmptyMetrics(recentCategoryMetrics, "category"));
						toggleCIInventoryView();
					}, 500);
				},false);
			}
			topic.subscribe("CIRefreshProductOverlay", function(){
				setTimeout(function() {
					showProductOverlay(_addEmptyMetrics(recentProductMetrics, "product"));
					toggleCIInventoryView();
				}, delay);
			});			
		});
		categoryTimeoutInit = true;
	}
	recentCategoryMetrics = metrics;
	for (var m in metrics) {
		var div = dojo.query('div[id^="ci_category_' + removeSpaceFromId(metrics[m].categoryIdentifier) + '"]')[0];	
		if (div) {
			dojo.style(div.parentNode, "position", "relative");
			dojo.query('> .ci_overlay', div).forEach(dojo.destroy);
			var overlay = "";
			if (dojo.position(div).h < 100) {
				overlay += "<div class='ci_overlay category ci_sub_overlay_stack ci_not_visible " + getCIClassSize(div.id) + "'>";
			}
			else {
				overlay += "<div class='ci_overlay products ci_sub_overlay_top_small ci_not_visible " + getCIClassSize(div.id) + "'>";				
			}
			//overlay += "<div class='ci_overlay_close' onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'></div>";
			var reorder = hideReOrderLink ? "" : "<a class='ci_reorder_link' href='javascript:reOrder(\""+ metrics[m].categoryIdentifier +"\");'>" + 
					"<div class='reorder_icon action_icons'></div><span title='" + nlsText.reorder + "'>" + nlsText.reorder + "</span></a>";
			overlay += "<div class='ci_actions'>" +
						"<a href='javascript:editCategory(\""+ metrics[m].categoryIdentifier +"\");'>" +  
						"<div class='edit_icon action_icons'></div><span title='" + nlsText.edit + "'>" + nlsText.edit + "</span></a>" +
						reorder + 
						"</div>";
			overlay += "</div>";
			
			if (dojo.position(div).h < 100) {
				overlay += "<div class='ci_overlay category ci_overlay_full_wide " + getCIClassSize(div.id) + "'>";
			}
			else {
				overlay += "<div class='ci_overlay products ci_overlay_tall_rect_small " + getCIClassSize(div.id) + "'>";
			}
			overlay += "<div class='ci_data'>";
			overlay += "<a id='prev_" + div.id + "' class='ci_left_arrow ci_not_visible' href='javascript:overlayPrev(\"" + div.id + "\");'><span></span></a>";
			overlay += "<a id='next_" + div.id + "' class='ci_right_arrow' href='javascript:overlayNext(\"" + div.id + "\");'><span></span></a>";
			overlay += "<ul onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
			
			var appendNoDataText = true;
			for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
				for (var i in metrics[m]) {
					switch (i) {
						default: {
							if (metrics[m][i].order === c) {
								appendNoDataText = false;
								if (i === "itemSales" || i === "itemsSold") {
									if (metrics[m][i].a) {
										overlay += "<li metricId='" + i + "' class='ci_hidden'>";
										overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
										overlay += "<span title='" + metrics[m][i].a + "'>" + metrics[m][i].a + "</span>";
										overlay += "</li>";
									}
									
									if (metrics[m][i].p) {
										overlay += "<li metricId='" + i + "_p' class='ci_hidden'>";
										overlay += "<span title='" + nlsText.plan + "'>" + nlsText.plan + ":</span>";
										overlay += "<span title='" + metrics[m][i].p + "'>" + metrics[m][i].p + "</span>";
										overlay += "</li>";
									}						
									if (metrics[m][i].apv) {
										overlay += "<li metricId='" + i + "_apv' class='ci_hidden'>";
										overlay += "<span title='" + nlsText.variance + "'>" + nlsText.variance + ":</span>";
										overlay += "<span title='" + metrics[m][i].apv + "'>" + metrics[m][i].apv + "</span>";
										overlay += "</li>";
									}							
								}
								else {
									overlay += "<li metricId='" + i + "' class='ci_hidden'>";
									overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
									if (metrics[m][i].a) {
										overlay += "<span title='" + metrics[m][i].a + "'>" + metrics[m][i].a + "</span>";
									}
									else {
										overlay += "<span title='" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
									}
									overlay += "</li>";
								}
							}
						}
						case "categoryIdentifier":
							break;
					}
				}
			}
			
			if (appendNoDataText) {				
				overlay += "<li metricId='no_data' class='ci_hidden'>" + nlsText.nodata + "</li>";							
			}
			
			overlay += "</ul>";
			
			overlay += "</div>";		
			overlay += "</div>";
			dojo.place(overlay, div, "first");
			var pageSize = calculatePagingSize(div.id);
			if (dojo.query(".ci_data > ul > li", div).length <= pageSize) {
				dojo.toggleClass(dojo.byId('next_' + div.id), "ci_not_visible");
			}
			dojo.some(dojo.query(".ci_data > ul > li", div), function(node, i) {
				var metricId = dojo.attr(node, "metricId");
				if (metricId === "itemsSold" || metricId === "itemSales") {
					var groupSize = 1;
					if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_p']", div).length > 0) {
						groupSize++;
					}
					if (dojo.query(".ci_data > ul > li[metricId$='" + metricId + "_apv']", div).length > 0) {
						groupSize++;
					}
					if (groupSize > pageSize) {
						return true;
					}
				}
				if (pageSize-- === 0) {
					return true;
				}
				else {
					dojo.toggleClass(node, "ci_show");
					dojo.toggleClass(node, "ci_hidden");
				}
			});
			
			if (isAndroid() || isIOS()) {
				require(["dojo/on", "dojox/gesture/swipe", "dojox/gesture/tap", "dojo/_base/event"], function(on, swipe, tap, event) {
					on(div, tap, function(e) {
						processTap(e);
					});
					on(div, swipe.end, function(e) {
						processSwipe(e.dx, e.currentTarget.id);		
					});
				});
			}
		}
	}
}

function showESpotOverlay(metrics) {
	var delay = 250;
	
	if (!espotTimeoutInit) {
		dojo.subscribe("CIRefreshProductOverlay", function() {
			setTimeout(function() {
				showESpotOverlay(_addEmptyMetrics(recentESpotMetrics, "espot"));
				toggleCIInventoryView();
			}, delay);
		});
		
		require(["dojo/on", "dojo/topic"], function(on, topic){
			if (!isAndroid() && !isIOS()) {
				// Listen to resize only on desktop
				window.addEventListener("resize", function(e) {
					var timeout;
					clearTimeout(timeout);
					timeout = setTimeout(function(){
						showESpotOverlay(_addEmptyMetrics(recentESpotMetrics, "espot"));
						toggleCIInventoryView();
					}, 500);
				},false);
			}
			topic.subscribe("CIRefreshProductOverlay", function(){
				setTimeout(function() {
					showESpotOverlay(_addEmptyMetrics(recentESpotMetrics, "espot"));
					toggleCIInventoryView();
				}, delay);
			});
		});
		espotTimeoutInit = true;
	}
	
	recentESpotMetrics = metrics
	var processedMetrics = [];
	for (var m in metrics) {
		var div = dojo.query('div[id^="ci_espot_' + encodeId(metrics[m].espotName) + '"]')[0];
		if (div) {
			var overlay = "";
			if (processedMetrics.indexOf(metrics[m].espotName) === -1) {
				dojo.style(div.parentNode, "position", "relative");
				dojo.query('> .ci_overlay', div).forEach(dojo.destroy);	
				if (dojo.position(div).h > ESPOT_THRESHOLD) {
					overlay += "<div class='ci_overlay activities ci_sub_overlay_top_wide ci_not_visible " + getCIClassSize(div.id) + "'>";
					//overlay += "<div class='ci_overlay_close' onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'></div>";
					overlay += "<div class='ci_actions'>" +
								"<a role='button' href='javascript:showInfo(\"" + metrics[m].espotName + "\");'>" + 
								"<div class='info_icon action_icons'></div><span title='" + nlsText.information + "'>" + nlsText.information + "</span></a>" +
								"</div>";
					overlay += "</div>";
					overlay += "<div class='ci_overlay activities ci_overlay_wide_rect_small " + getCIClassSize(div.id) + "'>";
				}
				else {
					overlay += "<div class='ci_overlay activities ci_sub_overlay_stack ci_not_visible " + getCIClassSize(div.id) + "'>";
					//overlay += "<div class='ci_overlay_close' onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'></div>";
					overlay += "<div class='ci_actions'>" +
					"<a href='javascript:showInfo(\"" + metrics[m].espotName + "\");'>" + 
								"<div class='info_icon action_icons'></div><span title='" + nlsText.information + "'>" + nlsText.information + "</span></a>" +
	
								"</div>";
					overlay += "</div>";
					overlay += "<div class='ci_overlay category ci_overlay_full_wide " + getCIClassSize(div.id) + "'>";
				}
				overlay += "<div class='ci_data'>";
				overlay += "<a id='prev_" + div.id + "' class='ci_left_arrow ci_not_visible' href='javascript:overlayPrev(\"" + div.id + "\");'><span></span></a>";
				overlay += "<a id='next_" + div.id + "' class='ci_right_arrow' href='javascript:overlayNext(\"" + div.id + "\");'><span></span></a>";
				
				if (dojo.position(div).h > ESPOT_THRESHOLD) {
					overlay += "<ul onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
					
					if (metrics[m].data && metrics[m].data === "none") {
						overlay += "<li metricId='no_data' class='activity-slide ci_hidden'>";
						overlay += "<span class='heading' title='" + nlsText.nodata + "'>" + nlsText.nodata + "</span>";					
					}
					else {
						overlay += "<li metricId='espot' class='activity-slide ci_hidden'>";
						overlay += "<span class='heading' title='" + metrics[m].activityName + "'>" + metrics[m].activityName + "</span>";
						overlay += "<ul>";
						for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
							for (var i in metrics[m]) {
								switch (i) {
									default: {
										if (metrics[m][i].order === c) {
											overlay += "<li>";
											overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
											if (metrics[m][i].value) {
												overlay += "<span title='" + metrics[m][i].value + "'>" + metrics[m][i].value + "</span>";
											}
											else {
												overlay += "<span title'" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
											}
											overlay += "</li>";
										}									
									}
									case "reportId":
									case "espotName":
									case "activityName":
										break;
								}
							}
						}
						overlay += "</ul>";

						if (isAndroid() || isIOS()) {
							require(["dojo/on", "dojox/gesture/swipe", "dojox/gesture/tap", "dojo/_base/event"], function(on, swipe, tap, event) {
								on(div, tap, function(e) {
									processTap(e);
								});

							});
						}
					}
					overlay += "</li>";
					overlay += "</ul>";
				}
				else {
					overlay += "<ul onclick='javascript:toggleSubOverlay(\"" + div.id + "\");'>";
					if (metrics[m].data && metrics[m].data === "none") {
						overlay += "<li metricId='no_data' class='ci_hidden'>" + nlsText.nodata + "</li>";							
					}
					else {
						overlay += "<li metricId='activityName' class='ci_hidden'><span class='heading' title='" + metrics[m].activityName + "'>" + metrics[m].activityName + "</span></li>";
						for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
							for (var i in metrics[m]) {
								switch (i) {
									default: {
										if (metrics[m][i].order === c) {
											overlay += "<li metricId='" + i + "' class='ci_hidden'>";
											overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
											if (metrics[m][i].value) {
												overlay += "<span title='" + metrics[m][i].value + "'>" + metrics[m][i].value + "</span>";
											}
											else {
												overlay += "<span title='" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
											}
											overlay += "</li>";
										}									
									}
									case "reportId":
									case "espotName":
									case "activityName":
										break;
								}
							}
						}
						if (isAndroid() || isIOS()) {
							require(["dojo/on", "dojox/gesture/swipe", "dojox/gesture/tap", "dojo/_base/event"], function(on, swipe, tap, event) {
								on(div, tap, function(e) {
									processTap(e);
								});
								
								on(div, swipe.end, function(e) {                                    
									processSwipe(e.dx, e.currentTarget.id);                                    
								});
							});
						}
					}
					overlay += "</li>";
					overlay += "</ul>";
				}
				
				overlay += "</div>";
				overlay += "</div>";

				dojo.place(overlay, div, "first");
                
                var overlayDiv = dojo.query('div[id^="ci_espot_' + encodeId(metrics[m].espotName) + '"] .ci_overlay_wide_rect_small')[0];                
                if ((isAndroid() || isIOS()) && overlayDiv !== undefined) {
                    require(["dojo/on", "dojox/gesture/swipe", "dojox/gesture/tap", "dojo/_base/event"], function(on, swipe, tap, event) {

                        on(overlayDiv, swipe.end, function(e) {
                            processSwipe(e.dx, e.currentTarget.parentNode.id);
                        });

                    });
                }
                
                
				processedMetrics.push(metrics[m].espotName);
			}
			else {
				var espotOverlayDiv = dojo.query('> .ci_overlay > .ci_data > ul', div)[0];
				if (dojo.position(div).h > ESPOT_THRESHOLD) {
					// Should be no need to handle no metrics case since this is the 2nd+ activity					
					overlay += "<li metricId='espot' class='activity-slide ci_hidden'>";
					overlay += "<span class='heading' title='" + metrics[m].activityName + "'>" + metrics[m].activityName + "</span>";
					overlay += "<ul>";
					for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
						for (var i in metrics[m]) {
							switch (i) {
								default: {
									if (metrics[m][i].order === c) {
										overlay += "<li>";
										overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
										if (metrics[m][i].value) {
											overlay += "<span title='" + metrics[m][i].value + "'>" + metrics[m][i].value + "</span>";
										}
										else {
											overlay += "<span title='" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
										}
										overlay += "</li>";
									}
								}
								case "reportId":
								case "espotName":
								case "activityName":
									break;
							}
						}
					}
					overlay += "</ul>";
					overlay += "</li>";
				}
				else {
					overlay += "<li metricId='activityName' class='ci_hidden'><span class='heading' title='" + metrics[m].activityName + "'>" + metrics[m].activityName + "</span></li>";
					for (var c = 0; c < Object.keys(metrics[m]).length; c++) {
						for (var i in metrics[m]) {
							switch (i) {
								default: {
									if (metrics[m][i].order === c) {
										overlay += "<li metricId='" + i + "' class='ci_hidden'>";
										overlay += "<span title='" + metrics[m][i].name + "'>" + metrics[m][i].name + ":</span>";
										if (metrics[m][i].value) {
											overlay += "<span title='" + metrics[m][i].value + "'>" + metrics[m][i].value + "</span>";
										}
										else {
											overlay += "<span title='" + metrics[m][i] + "'>" + metrics[m][i] + "</span>";
										}
										overlay += "</li>";
									}
								}
								case "reportId":
								case "espotName":
								case "activityName":
									break;
							}
						}
					}
					overlay += "</li>";
				}				
				dojo.place(overlay, espotOverlayDiv, "last");			
			}
			var pageSize = calculatePagingSize(div.id);
			//var widthStyle = pageSize === 1 ? "75%" : Math.floor(60/pageSize) + "%";
			if (dojo.query(".ci_data > ul > li", div).length <= pageSize) {
				dojo.addClass(dojo.byId('next_' + div.id), "ci_not_visible");
			}
			else {
				dojo.removeClass(dojo.byId('next_' + div.id), "ci_not_visible");
			}
			var activityCheck = false;
			dojo.some(dojo.query(".ci_data > ul > li", div), function(node, i) {
				if (pageSize-- === 0) {
					return true;
				}
				else {					
					if (dojo.attr(node, "metricId") === "activityName") {
						if (activityCheck) {
							dojo.removeClass(dojo.byId('next_' + div.id), "ci_not_visible");
							return true;
						}
						else {
							activityCheck = true;
						}
					}
					dojo.addClass(node, "ci_show");
					if (dojo.hasClass(node, "ci_hidden")) {
						dojo.toggleClass(node, "ci_hidden");
					}
					//dojo.setStyle(node, "width", widthStyle);
				}
			});
		}
	}
}

function _addEmptyMetrics(metrics, metricType) {
	if (metrics) {
		dojo.query('div[id^="ci_' + metricType + '"]').forEach(function(node, index, arr) {
			var tokens = node.getAttribute("id").split("_");
			
			switch (metricType) {
				case "product": {
					var id = tokens.slice(2).join('_');
					
					var found = dojo.some(metrics, function(n) {
							if (n.partNumber === id) {
								return true;
							}
							else if (id.indexOf("_" + n.partNumber, id.length - (n.partNumber.length + 1)) !== -1) {
								// partNumber and ID not the same, check if ID ends with _partNumber.  
								// Likely scenario is if metrics are cached and page contents have changed with AJAX (e.g. pagination), thus
								// hooks did not include the new products.
								n.partNumber = id;
								return true;
							}
						});
					if (!found) {
						metrics.push({partNumber : id, data : "none"});
					}

					break;
				}
				case "category": {
					var id = addSpaceToId(tokens.slice(2).join('_'));
					
					var found = dojo.some(metrics, function(n) {
							if (n.categoryIdentifier === id) {
								return true;
							}
						});
					if (!found) {
						metrics.push({categoryIdentifier : id, data : "none"});
					}
					
					break;
				}
				case "espot": {
					var id = tokens.slice(2).join('_');
					
					var found = dojo.some(metrics, function(n) {
							if (n.espotName === id) {
								return true;
							}
						});
					if (!found) {
						metrics.push({espotName : id, data : "none"});
					}

					break;
				}
			}
		});
	}
	return metrics;
}

function retrieveCIHooks() {
	productHooks = [];
	categoryHooks = [];
	espotHooks = [];
	
	dojo.query('div[id^="ci_"]').forEach(function(node, index, arr) {
		var tokens = node.getAttribute("id").split("_");
		// Some validation on the ID for CI purposes
		
		if (tokens.length >= 4 && (tokens[1] === 'product' || tokens[1] === 'category' || tokens[1] === 'espot')) {
			switch (tokens[1]) {
				case "product": {
					productHooks.push(tokens.slice(2).join('_'));
					break;
				}
				case "category": {
					categoryHooks.push(tokens.slice(2,3) + "_" + addSpaceToId(tokens.slice(3).join('_')));
					break;
				}
				case "espot": {
					espotHooks.push(tokens.slice(2).join('_'));
					break;
				}
			}
		}	
	});
	return [productHooks, categoryHooks, espotHooks, getPrimaryProduct()];
	
}

function getPrimaryProduct() {
	dojo.query('meta[name="pageGroup"]').forEach(function(node, index, arr) {
		if (node.getAttribute("content") !== "Product") {
			return null;
		};
	});
	
	var primaryProduct;
	dojo.query('meta[name="pageIdentifier"]').forEach(function(node, index, arr) {
		primaryProduct = node.getAttribute("content");
	});
	return primaryProduct;
}

function receive(event) {
	var data;
	try {
		data = JSON.parse(event.data);
	}
	catch (e) {
		// Likely invalid CI message.  Ignore or handle other messages here.
	}
	
	if (data) {
		switch (data.cmd) {
			case "ack":
				initializeCIinventoryRedrawEvent();
				nlsText = data.nlsText;
				event.source.postMessage(JSON.stringify({cmd:'request_metrics', hooks: JSON.stringify(retrieveCIHooks())}), event.origin);
				eventSource = event.source;
				eventOrigin = event.origin;
				break;
			case "response_metrics_product":
				ciInventoryView = data.inventoryView;
				
				showProductOverlay(_addEmptyMetrics(JSON.parse(data.metrics), "product"));
				if (ciInventoryView){
					toggleCIInventoryView();
				}
				break;
			case "response_metrics_category":
				showCategoryOverlay(_addEmptyMetrics(JSON.parse(data.metrics), "category"), event);
				break;
			case "response_metrics_espot":
				showESpotOverlay(_addEmptyMetrics(JSON.parse(data.metrics), "espot"));
				break;
			case "update_prefs":
				nlsText = data.nlsText;
				break;
			case "toggle_inventory_view":
				if (ciInventoryView != data.inventoryView){
					ciInventoryView = data.inventoryView;
					toggleCIInventoryView();
				}
				break;
			case "hide_reorder_link":
				hideReOrderLink = true;
				break;
		}
	}
}

function initializeCIinventoryRedrawEvent(){
	
	require(["dojo/on", "dojo/topic"], function(on, topic){
		on(window, "resize", function(e){
			setTimeout(function(){
				var productDivs = dojo.query('div[id^="ci_product_"]');
				if (ciInventoryView){
					productDivs.forEach(function(node){
						var position = dojo.position(node);
						if (position.h > 0 && position.w > 0 ){
							var inventoryDiv = dojo.query('.ci_overlay.ci_inventory_overlay', node)[0];
							if (inventoryDiv){
								drawCIInventory(inventoryDiv);
							}
						}
					});
				}
			}, 300);
		});
		topic.subscribe("CIRefreshProductInventoryOverlay", function(){
			setTimeout(function(){
				var productDivs = dojo.query('div[id^="ci_product_"]');
				if (ciInventoryView){
					productDivs.forEach(function(node){
						var position = dojo.position(node);
						if (position.h > 0 && position.w > 0 ){
							var inventoryDiv = dojo.query('.ci_overlay.ci_inventory_overlay', node)[0];
							if (inventoryDiv){
								drawCIInventory(inventoryDiv);
							}
						}
					});
				}
			}, 200);
		});
	});
}