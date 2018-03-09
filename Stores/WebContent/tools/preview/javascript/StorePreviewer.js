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
    var skin = document.getElementById("skin");
    var wrapper = $("#previewFrameWrapper");
    var frame = document.getElementById("previewFrame");
    wrapper.resizable({
        helper: 'ui-resizable-helper',
        animate: true,
        minWidth: 320,
        minHeight: 320,
        resize: function (event, ui) {
            var width = parseInt(ui.size.width);
            var height = parseInt(ui.size.height);


            var headerDocument = window.frames["headerFrame"].document;
            var sizeDropdown = headerDocument.getElementById("sizeDropdown");
            var customOption = headerDocument.getElementById("customOption");
            if (!customOption) {
                customOption = headerDocument.createElement("option");
                customOption.id = "customOption";
                customOption.value = "custom";
                sizeDropdown.add(customOption, null);
            }

            customOption.text = width + "x" + height;
            customOption.selected = true;
            skin.className = (width > height ? "landscape" : "portrait");
        }
    });


});
