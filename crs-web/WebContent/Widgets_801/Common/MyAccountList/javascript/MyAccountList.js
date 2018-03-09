//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------
/* global document, window, jQuery, KeyCodes, Utils, handleMouseDown, showMenu, hideMenu, 
toggleMenu, toggleExpand, eventActionsInitialization, toggleExpandedContent, toggleMobileView */

(function ($) {
    var activeMenuNode = null;
    var toggleControlNode = null;
    var NAMESPACE = "MyAccountList"; // Namespace to use for all event handlers in this file

    var registerMouseDown = function () {
        Utils.onOnce($(document.documentElement), "mousedown", NAMESPACE, handleMouseDown);
    };

    var unregisterMouseDown = function () {
        $(document.documentElement).off("mousedown." + NAMESPACE);
    };

    showMenu = function (target) {

        //Ensure All menus are closed on list table
        $("div.listTable a[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $("div.listTable div[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $("div.listTable form[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $(target).addClass("active");
	activeMenuNode = target;
        var toggleControl = $("div.listTable a[table-toggle='" + target.id + "']");
        toggleControl.addClass("clicked");
        toggleControlNode = toggleControl[0];
        registerMouseDown();
    };

    hideMenu = function (target) {
        $(target).removeClass("active");
        $("div.listTable a[table-toggle='" + target.id + "']").removeClass("clicked");
        unregisterMouseDown();
        activeMenuNode = null;
        toggleControlNode = null;
    };

    handleMouseDown = function (evt) {
        if (activeMenuNode !== null) {
            var node = evt.target;
            if (node != document.documentElement) {
                var close = true;
                while (node && node != document.documentElement) {
                    if (node == activeMenuNode || node == toggleControlNode || $(node).hasClass("dijitPopup")) {
                        close = false;
                        break;
                    }
                    node = node.parentNode;
                }
                if (node === null) {
                    $("div", activeMenuNode).each(function (i, child) {
                        var position = Utils.position(child);
						if (evt.clientX >= position.left && evt.clientX < position.left + position.width() &&
							evt.clientY >= position.top && evt.clientY < position.top + position.height()) {
                            close = false;
                            return false; // breaks
                        }
                    });
                }
                if (close) {
                    hideMenu(activeMenuNode);
                }
            }
        }
    };

    toggleMenu = function (target) {
        if ($(target).hasClass("active")) {
            hideMenu(target);
        } else {
            showMenu(target);
        }
    };

    toggleExpand = function (target) {
        $("div.listTable div[row-expand]").each(function (i, node) {
            var resetNodeId = $(node).attr("row-expand");
            var resetNodeElement = document.getElementById(resetNodeId);
            if (resetNodeElement != target) {
                Utils.replaceAttr($(resetNodeElement), "src", function (oldSrc) {
                    return oldSrc.replace("sort_arrow_DN.png", "sort_arrow_OFF.png")
                        .replace("sort_arrow_UP.png", "sort_arrow_OFF.png");
                });
                $(resetNodeElement).removeClass("active");
            }
        });
        var $target = $(target);
        if ($target.hasClass("active")) {
            $target.removeClass("active");
            Utils.replaceAttr($target, "src", function (oldSrc) {
                return oldSrc.replace("sort_arrow_OFF.png", "sort_arrow_UP.png")
                    .replace("sort_arrow_DN.png", "sort_arrow_UP.png");
            });
        } else {
            $target.addClass("active");
            Utils.replaceAttr($target, "src", function (oldSrc) {
                return oldSrc.replace("sort_arrow_OFF.png", "sort_arrow_DN.png")
                    .replace("sort_arrow_UP.png", "sort_arrow_DN.png");
            });
        }
    };

    eventActionsInitialization = function () {
        Utils.onOnce($(document), "click", NAMESPACE, "div.listTable div[row-expand]", function (e) {
            var target = $(this).attr("row-expand");
            toggleExpand(document.getElementById(target));
            Utils.stopEvent(e);
        });

        Utils.onOnce($(document), "click", NAMESPACE, "div.listTable a[table-toggle]", function (e) {
            var target = $(this).attr("table-toggle");
            toggleMenu(document.getElementById(target));
            Utils.stopEvent(e);
        });

        Utils.onOnce($(document), "keydown", NAMESPACE, "div.listTable a[table-toggle]", function (e) {
            if (e.keyCode === KeyCodes.TAB || (e.keyCode === KeyCodes.TAB && e.shiftKey)) {
                var target = $(this).attr("table-toggle");
                if (target !== "newListDropdown" && target !== 'uploadListDropdown') {
                    hideMenu(document.getElementById(target));
                }
            } else if (e.keyCode === KeyCodes.RETURN) {
                var target = $(this).attr("table-toggle");
                toggleMenu(document.getElementById(target));
                Utils.stopEvent(e);
            } else if (e.keyCode === KeyCodes.DOWN_ARROW) {
                var target = $(this).attr("table-toggle");
                toggleMenu(document.getElementById(target));
                var targetElem = document.getElementById(target);
                var targetMenuItem = $('[role*="menuitem"]', targetElem)[0];
                if (targetMenuItem !== null) {
                    targetMenuItem.focus();
                }
                Utils.stopEvent(e);
            }
        });
    };

    /**
     * Toggle mobile view or full view depending on size of the table's container (if < 600, show mobile)
     **/
    toggleMobileView = function () {
        var containerWidth;
        $(".listTable").each(function (i, table) {
            if($(table).parent().parent().width() > 0) {
                containerWidth = $(table).parent().parent().width();
            }
        });
        
        if (containerWidth < 600) {
            $(".fullView").css("display", "none");
            $(".listTableMobile").css("display", "block");
        } else {
            $(".fullView").each(function (i, node) {
                var $node = $(node);
                if (!$node.hasClass("nodisplay")) {
                    $node.css("display", "block");
                }
            });

            $(".listTableMobile").css("display", "none");
        }
    };

    /**
     * Toggle expanded content to show or hide (e.g. when button is clicked)
     * @param widgetName the name of the widget
     * @param row The row on which the expanded content is contained
     **/
    toggleExpandedContent = function (widgetName, row) {
        $('#WC_' + widgetName + '_Mobile_ExpandedContent_' + row).toggleClass('nodisplay');
        $('#WC_' + widgetName + '_Mobile_TableContent_ExpandButton_' + row).toggleClass('nodisplay');
        $('#WC_' + widgetName + '_Mobile_TableContent_CollapseButton_' + row).toggleClass('nodisplay');
    };

    eventActionsInitialization();

    window.setTimeout(function () {

        // the code is shared by ItemTable_UI.jspf, the query for cancel button and newListButton
        // could be empty, use forEach to handle this case.
        $("#newListButton").each(function (i, newListButton) {
            $(newListButton).on("keydown", function (e) {
                if (e.keyCode === KeyCodes.RETURN) {
                    var target = $(this).attr("table-toggle");
                    toggleMenu(document.getElementById(target));
                    var targetElem = document.getElementById(target);
                    $('[class*="input_field"]', targetElem).first().focus();
                    Utils.stopEvent(e);
                }
            });
        });

        $("form.toolbarDropdown > .createTableList > .button_secondary").each(function (i, cancelButton) {
            $(cancelButton).on("keydown", function (e) {
                if (e.keyCode === KeyCodes.TAB || (e.keyCode === KeyCodes.TAB && e.shiftKey)) {
                    var targetId = $(this).attr("id");
                    var newTargetId = targetId.replace("_NewListForm_Cancel", "_NewListForm_Name");
                    $("#" + newTargetId).focus();
                    Utils.stopEvent(e);
                } else if (e.keyCode === KeyCodes.RETURN) {
                    var target = $(this).attr("table-toggle");
                    hideMenu(document.getElementById(target));
                    $("#newListButton").focus();
                    Utils.stopEvent(e);
                }
            });
        });

        $(".actionDropdown").each(function (i, actionMenu) {
            var actionMenuItems = $('[role*="menuitem"]', actionMenu);
            actionMenuItems.each(function (j, actionMenuItem) {
                $(actionMenuItem).on("keydown", function (e) {
                    if (e.keyCode === KeyCodes.TAB) {
                        hideMenu(document.getElementById(actionMenu.getAttribute("id")));
                    } else if (e.keyCode === KeyCodes.UP_ARROW) {
                        actionMenuItems[j === 0 ? actionMenuItems.length - 1 : j - 1].focus();
                        Utils.stopEvent(e);
                    } else if (e.keyCode === KeyCodes.DOWN_ARROW) {
                        actionMenuItems[(j + 1) % actionMenuItems.length].focus();
                        Utils.stopEvent(e);
                    }
                });
            });
        });
    }, 100);
})(jQuery);
