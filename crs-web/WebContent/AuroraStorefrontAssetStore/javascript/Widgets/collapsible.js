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

var toggleCollapsible = function(collapsible) {
	var content = collapsible.querySelector(".content");
	var expanded = $(collapsible).attr("aria-expanded");
	var mainESpotHome = document.getElementById("mainESpotHome");
	(content.id.match(/homeESpotDetails/)) ? ((mainESpotHome.className == "closed") ? mainESpotHome.className = "expand" : mainESpotHome.className = "closed") : 0;
	if (expanded == "true") {
		window.setTimeout(function() {
			$(collapsible).attr("aria-expanded", "false");
			$(content).css("transition", "max-height .2s");
		}, 0);
		window.setTimeout(function() {
			$(content).css("transition", null);
		}, 200);
		window.setTimeout(function() {
			$(content).css("display", "none");
		}, 300);
	} else if (expanded == "false") {
		$(collapsible).attr("aria-expanded", "true");
		$(content).css("transition", "max-height .2s");
		window.setTimeout(function() {
			$(content).css("transition", null);
		}, 200);
		window.setTimeout(function() {
			$(content).css("display", "block");
		}, 300);
	}
};

var updateGrid = function(i, grid) {
	var width = grid.clientWidth;
	var minColWidth = $(grid).attr("data-min-col-width");
	var minColCount = $(grid).attr("data-min-col-count");
	var colCount = Math.floor(width/minColWidth);
	if (colCount < minColCount) {
		colCount = minColCount;
	}
	var colWidth = Math.floor(100/colCount) + "%";
    $(".col", grid).css("width", colWidth);
};

var toggleExpandNav = function(id) {
	var icon = byId("icon_" + id);
	var section_list = byId("section_list_" + id);
	if(icon.className == "arrow") {
		icon.className = "arrow arrow_collapsed";
		$(section_list).attr("aria-expanded", "false");
		$(section_list).css("display", "none");
	} else {
		icon.className = "arrow";
		$(section_list).attr("aria-expanded", "true");
		$(section_list).css("display", "block");
	}
};

$(document).ready(function() {
    var updateCollapsibles = function(mediaQuery) {
        var expanded = mediaQuery ? !mediaQuery.matches : document.documentElement.clientWidth > 583;
        if (expanded == false){
            $(".collapsible").attr("aria-expanded", expanded.toString());
        }else {
            $(".collapsible:not(.collapsedOnInit)").attr("aria-expanded", expanded.toString());
        }
    };
    if (window.matchMedia) {
        var mediaQuery = window.matchMedia("(max-width: 600px)");
        updateCollapsibles(mediaQuery);
        mediaQuery.addListener(updateCollapsibles);
    }
    else {
        updateCollapsibles();

        $(window).on("resize", function(event) {
            updateCollapsibles();
        });
    }

    Utils.onOnce($(document), "click", "collapsible", ".collapsible .toggle", function(event) {
        toggleCollapsible($(event.target).parents(".collapsible")[0]);
        event.preventDefault();
    });
    Utils.onOnce($(document), "keydown", "collapsible", ".collapsible .toggle", function(event) {
        if (event.keyCode === KeyCodes.RETURN || event.keyCode === KeyCodes.SPACE) {
            toggleCollapsible($(event.target).parents(".collapsible")[0]);
            event.preventDefault();
        }
    });

    $(".grid").each(updateGrid);

    $(window).on("resize", function(event) {
        $(".grid").each(updateGrid);
    });
});


