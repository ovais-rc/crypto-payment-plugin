//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

$(document).ready(function () {
    var parentDocument = parent.document;
    var skin = parentDocument.getElementById("skin");
    var wrapper = parentDocument.getElementById("previewFrameWrapper");
    var sizeDropdown = $("#sizeDropdown");
    var rotateButton = $("#rotateButton");

    $(sizeDropdown).on("change", function (e) {
        var option = this.options[this.selectedIndex];
        var value = option.value;
        if (value == "custom") {
            value = option.text;
        }
        if (value == "fit") {
            wrapper.style.width = "100%";
            wrapper.style.height = "100%";
            skin.className = "fit";
        } else {
            value = value.split("x");
            wrapper.style.width = value[0] + "px";
            wrapper.style.height = value[1] + "px";
            skin.className = (Number(value[0]) > Number(value[1]) ? "landscape" : "portrait");
        }
    });

    $(rotateButton).on("click", function (e) {
        if (skin.className != "fit") {
            var width = wrapper.clientHeight;
            var height = wrapper.clientWidth;
            wrapper.style.width = width + "px";
            wrapper.style.height = height + "px";
            skin.className = (width > height ? "landscape" : "portrait");
        }
    });
});
