//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


widgetCommonJS = {
    toggleDisplay: function(divId){
        if ($("#"+divId).css("display") === "none") {
            $("#"+divId).css("display", "block");
        } else {
            $("#"+divId).css("display", "none");
        }
    },

    toggleCustomCheckBox: function(cssClassForQuery,cssClassToToggle,node){
        $('.'+cssClassForQuery, node).toggleClass(cssClassToToggle);
        if(node.getAttribute("aria-checked") == 'true'){
            node.setAttribute("aria-checked","false");
        } else {
            node.setAttribute("aria-checked","true");
        }
    },

    toggleCustomCheckBoxKeyPress: function(cssClassForQuery,cssClassToToggle,node,event){
        var charOrCode = event.charCode || event.keyCode;
        console.debug(charOrCode);
        if (charOrCode == KeyCodes.SPACE) { 
            widgetCommonJS.toggleCustomCheckBox(cssClassForQuery,cssClassToToggle,node);
        }
    },

    toggleReadEditSection:function(editSectionId,showSection){
        var overlay = $("#overlay");
        var editSectionMain = $("#"+editSectionId+"Main");

        if(showSection == 'edit'){
            $('#'+editSectionId).css('display', 'block');
            $("#"+editSectionId+'Icon').css('display', 'none');
            $("#"+editSectionId+'Read').css('display','none');

            if (overlay){
                $(overlay).removeClass("nodisplay");
            }
            $(editSectionMain).addClass("editView lightedSection");
        } else if(showSection == 'read'){
            $('#'+editSectionId).css('display', 'none');
            $('#'+editSectionId+'Icon').css('display', 'inline-block');
            $("#"+editSectionId+'Read').css('display','block');

            if (overlay){
                $(overlay).addClass("nodisplay");
            }
            $(editSectionMain).removeClass("lightedSection editView");
        }
    },
    focusDiv: function(divId){
        $("#"+divId).addClass("dottedBorder");
    },

    blurDiv: function(divId){
        $("#"+divId).removeClass("dottedBorder");
    },
    
    toggleEditSection: function(target){
        $(target).toggleClass("readOnly editView");
        
        var editField = $(target).find(".editField");
        var readField = $(target).find(".readField");
        var overlay = $("#overlay");
        if ($(target).hasClass("readOnly")){
            $(editField).attr("aria-hidden", "true");
            $(readField).removeAttr("aria-hidden");
            $(target).removeClass("lightedSection")
            if (overlay){
                overlay.addClass("nodisplay");
            }
        }else {
            $(readField).attr("aria-hidden", "true");
            $(editField).removeAttr("aria-hidden");
            $(target).addClass("lightedSection")
            if (overlay){
                overlay.removeClass("nodisplay");
            }
        }
    },
    
    //can be invoked by postRefreshHandler upon update
    removeSectionOverlay: function(){
        var overlay = $("#overlay");
        if (overlay){
            $(overlay).addClass("nodisplay");
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
    	Utils.onOnce($(".pageSection .pageSectionTitle .editIcon[data-section-toggle]"), "click", "EditSection", function(e){
            var target = this.getAttribute("data-section-toggle");
            widgetCommonJS.toggleEditSection(document.getElementById(target));
            Utils.stopEvent(e);
        });
        //cancle button
    	Utils.onOnce($(".pageSection .editField .button_footer_line a[data-section-toggle]"), "click", "EditSection", function(e){
            var target = this.getAttribute("data-section-toggle");
            widgetCommonJS.toggleEditSection(document.getElementById(target));
            var data = {"target": target};
            wcTopic.publish("sectionToggleCancelPressed", data);
            Utils.stopEvent(e);
        });
    }
};
	
