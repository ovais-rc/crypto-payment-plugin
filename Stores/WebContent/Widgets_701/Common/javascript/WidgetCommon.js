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


require(["dojo/on", 
         "dojo/query", 
         "dojo/topic", 
         "dojo/dom",
         "dojo/dom-style",
         "dojo/dom-class",
         "dojo/_base/event",
         "dojo/NodeList-dom",
         "dojo/domReady!"], function(on, query, topic, dom, domStyle, domClass, event, NodeListDom) {
	
	widgetCommonJS = {
		toggleDisplay: function(divId){
			var node = dom.byId(divId);
			domStyle.get(node, "display") === "none" ? domStyle.set(node,"display", "block") : domStyle.set(node,"display", "none");
		},

		toggleCustomCheckBox: function(cssClassForQuery,cssClassToToggle,node){
			query('.'+cssClassForQuery, node).toggleClass(cssClassToToggle);
			if(node.getAttribute("aria-checked") == 'true'){
				node.setAttribute("aria-checked","false");
			} else {
				node.setAttribute("aria-checked","true");
			}
		},

		toggleCustomCheckBoxKeyPress: function(cssClassForQuery,cssClassToToggle,node,event){
			var charOrCode = event.charCode || event.keyCode;
			console.debug(charOrCode);
			if (charOrCode == dojo.keys.SPACE) { // Do not use event.keyCode == dojo.keys.SPACE - doesn't work according to dojo documentation.
				widgetCommonJS.toggleCustomCheckBox(cssClassForQuery,cssClassToToggle,node);
			}
		},

		toggleReadEditSection:function(editSectionId,showSection){
			var overlay = dom.byId("overlay");
			var editSectionMain = dom.byId(editSectionId+"Main");

			if(showSection == 'edit'){
				dojo.query('#'+editSectionId).style('display', 'block');
				dojo.style(editSectionId+'Icon','display', 'none');
				dojo.style(editSectionId+'Read','display','none');

				if (overlay){
					domClass.remove(overlay, "nodisplay");
				}
				domClass.add(editSectionMain, "editView")
				domClass.add(editSectionMain, "lightedSection")
			} else if(showSection == 'read'){
				dojo.query('#'+editSectionId).style('display', 'none');
				dojo.query('#'+editSectionId+'Icon').style('display', 'inline-block');
				dojo.style(editSectionId+'Read','display','block');

				if (overlay){
					domClass.add(overlay, "nodisplay");
				}
				domClass.remove(editSectionMain, "lightedSection")
				domClass.remove(editSectionMain, "editView")
			}
		},
		focusDiv: function(divId){
			query("#"+divId).addClass("dottedBorder");
		},

		blurDiv: function(divId){
			query("#"+divId).removeClass("dottedBorder");
		},
		
		toggleEditSection: function(target){
			domClass.toggle(target, "readOnly");
			domClass.toggle(target, "editView");
			var editField = query(".editField", target);
			var readField = query(".readField", target);
			var overlay = dom.byId("overlay");
			if (domClass.contains(target, "readOnly")){
				editField.attr("aria-hidden", "true");
				readField.removeAttr("aria-hidden");
				domClass.remove(target, "lightedSection")
				if (overlay){
					domClass.add(overlay, "nodisplay");
				}
			}else {
				readField.attr("aria-hidden", "true");
				editField.removeAttr("aria-hidden");
				domClass.add(target, "lightedSection")
				if (overlay){
					domClass.remove(overlay, "nodisplay");
				}
			}
		},
		
		//can be invoked by postRefreshHandler upon update
		removeSectionOverlay: function(){
			var overlay = dom.byId("overlay");
			if (overlay){
				domClass.add(overlay, "nodisplay");
			}
		},
		
		redirect:function(url, queryParams){
			if(queryParams != null && queryParams != 'undefined'){
				if(url.indexOf('?') > -1){
					url = url +"&"+queryParams;
				} else {
					url = url +"?"+queryParams;
				}
			}
			document.location.href = url;
		},
		
		initializeEditSectionToggleEvent: function (){
			//toggle edit and readonly sections, see organization user info widget
			on(document, ".pageSection .pageSectionTitle .editIcon[data-section-toggle]:click", function(e){
				var target = this.getAttribute("data-section-toggle");
				widgetCommonJS.toggleEditSection(document.getElementById(target));
				event.stop(e);	
			});
			//cancle button
			on(document, ".pageSection .editField .button_footer_line a[data-section-toggle]:click", function(e){
				var target = this.getAttribute("data-section-toggle");
				widgetCommonJS.toggleEditSection(document.getElementById(target));
				var data = {"target": target};
				topic.publish("sectionToggleCancelPressed", data);
				event.stop(e);	
			});
		}
	};
	
});