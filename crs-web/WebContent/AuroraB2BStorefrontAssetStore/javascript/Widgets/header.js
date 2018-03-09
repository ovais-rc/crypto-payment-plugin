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
/* global Utils, $, document, window, wc, setTimeout, cX, processAndSubmitForm, updateFormWithWcCommonRequestParameters, cursor_wait, cursor_clear */

// Declare functions/variables needed by the declareDeptDropdownRefreshArea function here
var updateDepartmentsMenu,
    activate,
    ajaxRefresh = "",

// We need this function to be global for Header_UI.jspf to call it
    setAjaxRefresh = function (refresh) {
        ajaxRefresh = refresh;
    };

$(document).ready(function () {
    var mouseDownRegistered = false,
        activeMenuNode = null,
        toggleControlNode = null,
        active = {},
        departmentMenuId = "departmentMenu_",
        registerMouseDown = function () {
            if (!mouseDownRegistered) {
                $(document.documentElement).on("mousedown.wc.header", handleMouseDown);
                mouseDownRegistered = true;
            }
        },
        unregisterMouseDown = function () {
            if (mouseDownRegistered) {
                $(document.documentElement).off("mousedown.wc.header");
                mouseDownRegistered = false;
            }
        },
        handleMouseDown = function (evt) {
            var node = evt.target;
            if (activeMenuNode !== null && node != document.documentElement) {
                var close = true;
                var parent = activeMenuNode.getAttribute("data-parent");
                while (node && node != document.documentElement) {
                    if (node == activeMenuNode || node == toggleControlNode || $(node).hasClass("dijitPopup") || parent == node.getAttribute("data-parent")) {
                        close = false;
                        break;
                    }
                    node = node.parentNode;
                }
                if (node === null) {
                    var children = $("div", activeMenuNode);
                    for (var i = 0; i < children.length; i++) {
                        var position = Utils.position(children[i]);
                        if (evt.clientX >= position.x && evt.clientX < position.x + position.w &&
                            evt.clientY >= position.y && evt.clientY < position.y + position.h) {
                            close = false;
                            break;
                        }
                    }
                }
                if (close) {
                    deactivate(activeMenuNode);
                }
            }
        },
        deactivate = function (target) {
            if (active[target.id]) {
                deactivate(active[target.id]);
            }
            $(target).removeClass("active");
            $("a[data-activate='" + target.id + "']").removeClass("selected");
            $("a[data-toggle='" + target.id + "']").removeClass("selected");
            var parent = target.getAttribute("data-parent");
            delete active[parent];
            if (target == activeMenuNode) {
                activeMenuNode = null;
                toggleControlNode = null;
                unregisterMouseDown();
            }
        },
        toggle = function (target) {
            if ($(target).hasClass("active")) {
                deactivate(target);
            } else {
                activate(target);
            }
        },
        setUpEventActions = function () {
            $(document).on("click", "a[data-activate]", function (e) {
                var target = this.getAttribute("data-activate");
                activate(document.getElementById(target));
                Utils.stopEvent(e);
            });
            $(document).on("click", "a[data-deactivate]", function (e) {
                var target = this.getAttribute("data-deactivate");
                deactivate(document.getElementById(target));
                Utils.stopEvent(e);
            });
            $(document).on("click", "a[data-toggle]", function (e) {
                var target = this.getAttribute("data-toggle");
                toggle(document.getElementById(target));
                Utils.stopEvent(e);
            });
            $(document).on("keydown", "a[data-toggle]", function (e) {
                var target;
                if (e.keyCode === 27) {
                    target = this.getAttribute("data-toggle");
                    deactivate(document.getElementById(target));
                    Utils.stopEvent(e);
                } else if (e.keyCode === 40) {
                    target = this.getAttribute("data-toggle");
                    var targetElem = document.getElementById(target);
                    activate(targetElem);
                    $('[class*="menuLink"]', targetElem)[0].focus();
                    Utils.stopEvent(e);
                }
            });

            var ie_version = Utils.get_IE_version();
            if (ie_version && ie_version < 10) {
                $("input[placeholder]").each(function (i, input) {
                    var placeholder = input.getAttribute("placeholder");
                    if (placeholder) {
                        var label = document.createElement("label");
                        label.className = "placeholder";
                        label.innerHTML = placeholder;
                        input.parentNode.insertBefore(label, input);
                        var updatePlaceholder = function () {
                            label.style.display = (input.value ? "none" : "block");
                        };
                        window.setTimeout(updatePlaceholder, 200);
                        $(input).on("blur focus keyup", updatePlaceholder);
                        $(label).click(function (e) {
                            input.focus();
                        });
                    }
                });
            }
        };

    activate = function (target) {
        var startsWith = (target.id.slice(0, departmentMenuId.length) == departmentMenuId);
        if (ajaxRefresh == "true" && startsWith) {
            setAjaxRefresh(""); // No more refresh till shopper leaves this page
            // Update the Context, so that widget gets refreshed..
            wcRenderContext.updateRenderContext("departmentSubMenuContext", {
                "targetId": target.id
            });
            if (typeof cX === 'function') {
                // For Coremetrics tagging to generate linkclick tags when clicking on navigation buttons
                setTimeout(function () {
                    cX("");
                }, 1000);
            }
            return;
        }

        var parent = target.getAttribute("data-parent");
        if (parent && active[parent]) {
            deactivate(active[parent]);
        }
        if (parent) {
            activate(document.getElementById(parent));
        }
        $(target).addClass("active");
        $("a[data-activate='" + target.id + "']").addClass("selected");
        var toggleControl = $("a[data-toggle='" + target.id + "']");
        toggleControl.addClass("selected");
        if (parent) {
            active[parent] = target;
            if (activeMenuNode === null) {
                activeMenuNode = target;
                toggleControlNode = toggleControl.length > 0 ? toggleControl[0] : null;
                registerMouseDown();
            }
        }
    };

    setUpEventActions();

    window.setTimeout(function () {
        var quickLinksBar = document.getElementById("quickLinksBar");
        var quickLinksButton = document.getElementById("quickLinksButton");
        var quickLinksMenu = document.getElementById("quickLinksMenu");
        var quickLinksMenuItems = $("> ul > li > a", quickLinksMenu);
        var signInOutQuickLink = document.getElementById("signInOutQuickLink");
        $("#quickLinksMenu > ul > li").each(function (i, li) {
            if (li.id != "facebookQuickLinkItem" && li.id != "globalLoginWidget") {
                li = li.cloneNode(true);
                $("[id]", li).each(function (j, node) {
                    node.id += "_alt";
                });
                quickLinksBar.insertBefore(li, quickLinksBar.firstChild);
            }
        });
        $("#quickLinksBar > li > a, #quickLinksBar > li > span").each(function (i, node) {
            if (node.id != "miniCartButton" && node.id != "barcodeScanButton" && node.id.indexOf("signOutQuickLink") === -1 && node.id != "contactQuickLink_alt") {
                var s = $.trim(node.innerHTML);
                var it = node.childNodes;
                //find the first non-blank text node (type=3)
                for (i = 0; i < it.length; i++) {
                    if (it[i].nodeType === 3 && $.trim(it[i].nodeValue) !== "") {
                        s = $.trim(it[i].nodeValue);
                        break;
                    }
                }
                var n = s.lastIndexOf(",");
                if (n === -1) {
                    n = s.lastIndexOf(" ");
                }
                if (n != -1) {
                    var sBr = s.substring(0, n + 1) + "<br/>" + s.substring(n + 1, s.length);
                    node.innerHTML = node.innerHTML.replace(s, sBr);
                }
            }
        });
        $(quickLinksButton).click(function (e) {
            var target = this.getAttribute("data-toggle");
            toggle(document.getElementById(target));
            Utils.stopEvent(e);
        });
        $(quickLinksButton).keydown(function (e) {
            var target;
            if (e.keyCode === 40) {
                target = this.getAttribute("data-toggle");
                activate(document.getElementById(target));
                quickLinksMenuItems[0].focus();
                Utils.stopEvent(e);
            } else if (e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                deactivate(quickLinksMenu);
            } else if (e.keyCode === 27) {
                target = this.getAttribute("data-toggle");
                deactivate(document.getElementById(target));
                Utils.stopEvent(e);
            }
        });
        $(quickLinksMenu).keydown(function (e) {
            if (e.keyCode === 27 || e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                deactivate(quickLinksMenu);
            } else if (e.keyCode === 27) {
                var target = this.getAttribute("data-toggle");
                deactivate(document.getElementById(target));
                Utils.stopEvent(e);
            }
        });
        quickLinksMenuItems.each(function (i, quickLinksMenuItem) {
            quickLinksMenuItem.setAttribute("role", "menuitem");
            quickLinksMenuItem.setAttribute("tabindex", "-1");
            $(quickLinksMenuItem).keydown(function (e) {
                switch (e.keyCode) {
                case 38:
                    quickLinksMenuItems[i === 0 ? quickLinksMenuItems.length - 1 : i - 1].focus();
                    Utils.stopEvent(e);
                    break;
                case 40:
                    quickLinksMenuItems[(i + 1) % quickLinksMenuItems.length].focus();
                    Utils.stopEvent(e);
                    break;
                }
            });
        });
        var searchFilterButton = document.getElementById("searchFilterButton");
        if (searchFilterButton) {
            $(searchFilterButton).keydown(function (e) {
                if (e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                    deactivate(document.getElementById(searchFilterButton.getAttribute("data-toggle")));
                }
            });
        }
        var searchForm = document.getElementById("SimpleSearchForm_SearchTerm");
        if (searchForm) {
            $(searchForm).click(function (e) {
                $('.selected:not(a[data-toggle="searchBar"])', document.getElementById("header")).each(function (i, selectedDataToggle) {
                    deactivate(document.getElementById(selectedDataToggle.getAttribute("data-toggle")));
                });
            });
        }
        var searchFilterMenu = document.getElementById("searchFilterMenu");
        if (searchFilterMenu) {
            $('[class*="menuLink"]', searchFilterMenu).each(function (i, searchFilterMenuItems) {
                $(searchFilterMenuItems).keydown(function (e) {
                    if (e.keyCode === 27) {
                        deactivate(searchFilterMenu);
                        Utils.stopEvent(e);
                    } else if (e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                        deactivate(searchFilterMenu);
                    } else if (e.keyCode === 38) {
                        searchFilterMenuItems[i === 0 ? searchFilterMenuItems.length - 1 : i - 1].focus();
                        Utils.stopEvent(e);
                    } else if (e.keyCode === 40) {
                        searchFilterMenuItems[(i + 1) % searchFilterMenuItems.length].focus();
                        Utils.stopEvent(e);
                    }
                });
            });
        }
    }, 100);

    var header = document.getElementById("header"),
        direction = Utils.getTextDirection(header),
        updateQuickLinksBar = function () {
            var logo = document.getElementById("logo");
            var quickLinksBar = document.getElementById("quickLinksBar");
            var availableWidth = (direction === "rtl" ? logo.offsetLeft - quickLinksBar.offsetLeft : (quickLinksBar.offsetLeft + quickLinksBar.offsetWidth) - (logo.offsetLeft + logo.offsetWidth));
            // BEGIN Facebook quick link workaround
            var facebookQuickLinkItem = document.getElementById("facebookQuickLinkItem");
            if (facebookQuickLinkItem && facebookQuickLinkItem.parentNode != quickLinksBar && availableWidth > 1024) {
                quickLinksBar.insertBefore(facebookQuickLinkItem, quickLinksBar.firstChild);
            } else if (facebookQuickLinkItem && facebookQuickLinkItem.parentNode == quickLinksBar && availableWidth <= 1024) {
                var quickLinksMenuList = $("#quickLinksMenu > ul")[0];
                quickLinksMenuList.append(facebookQuickLinkItem);
            }
            // END Facebook quick link workaround
            var quickLinksBarItems = $("#quickLinksBar > li");
            var quickLinksItem = quickLinksBarItems[quickLinksBarItems.length - 2];
            var miniCartItem = quickLinksBarItems[quickLinksBarItems.length - 1];
            availableWidth -= quickLinksItem.offsetWidth + miniCartItem.offsetWidth;
            for (var i = quickLinksBarItems.length - 3; i >= 0; i--) {
                availableWidth -= quickLinksBarItems[i].offsetWidth;
                $(quickLinksBarItems[i]).toggleClass("border-right", (availableWidth >= 0));
                $(quickLinksBarItems[i]).toggleClass("hidden", (availableWidth < 0));
            }

        };
    window.setTimeout(updateQuickLinksBar, 200);
    $(window).resize(updateQuickLinksBar);

    updateDepartmentsMenu = function () {
        var departmentsMenu = document.getElementById("departmentsMenu");
        var searchBar = document.getElementById("searchBar");
        var departmentButtons = $(".departmentButton");
        var departmentMenus = $(".departmentMenu");
        var departmentsMenuItems = $("#departmentsMenu > li");
        var allDepartmentsItem = departmentsMenuItems[departmentsMenuItems.length - 1];
        var availableWidth = null;
        if (searchBar) {
            availableWidth = (direction === "rtl" ? (departmentsMenu.offsetLeft + departmentsMenu.offsetWidth) - (searchBar.offsetLeft + searchBar.offsetWidth) : searchBar.offsetLeft - departmentsMenu.offsetLeft) - allDepartmentsItem.offsetWidth;
        } else {
            availableWidth = departmentsMenu.offsetWidth - allDepartmentsItem.offsetWidth;
        }
        for (var i = 0; i < departmentsMenuItems.length - 1; i++) {
            availableWidth -= departmentsMenuItems[i].offsetWidth;
            $(departmentsMenuItems[i]).toggleClass("hidden", (availableWidth < 0));
        }
        departmentButtons.each(function (i, departmentButton) {
            $(departmentButton).keydown(function (e) {
                if (e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                    deactivate(document.getElementById(departmentButton.getAttribute("data-toggle")));
                }
            });
        });
        departmentMenus.each(function (i, departmentMenu) {
            $(departmentMenu).click(function (e) {
                var target = this.getAttribute("data-toggle");
                if (target !== null) {
                    toggle(document.getElementById(target));
                    Utils.stopEvent(e);
                }
            });
            var departmentMenuItems = $('[class*="menuLink"]', departmentMenu);
            departmentMenuItems.each(function (j, departmentMenuItem) {
                $(departmentMenuItem).keydown(function (e) {
                    if (e.keyCode === 27) {
                        deactivate(document.getElementById(departmentMenu.getAttribute("id")));
                        Utils.stopEvent(e);
                    } else if (e.keyCode === 9 || (e.keyCode === 9 && e.shiftKey)) {
                        deactivate(document.getElementById(departmentMenu.getAttribute("id")));
                    } else if (e.keyCode === 38) {
                        departmentMenuItems[j === 0 ? departmentMenuItems.length - 1 : j - 1].focus();
                        Utils.stopEvent(e);
                    } else if (e.keyCode === 40) {
                        departmentMenuItems[(j + 1) % departmentMenuItems.length].focus();
                        Utils.stopEvent(e);
                    }
                });
            });
        });
    };
    window.setTimeout(updateDepartmentsMenu, 200);
    var ie_version = Utils.get_IE_version();
    if (!ie_version || ie_version > 8) {
        // Disabled in IE8 due to an IE8 bug causing the page to go partially black
        $(window).resize(updateDepartmentsMenu);
    }

    $("#searchFilterMenu > ul > li > a").click(function (e) {
        document.getElementById("searchFilterButton").innerHTML = this.innerHTML;
        document.getElementById("categoryId").value = this.getAttribute("data-value");
        deactivate(document.getElementById("searchFilterMenu"));
    });
    $("#searchBox > .submitButton").click(function (e) {
        var searchTerm = document.getElementById("SimpleSearchForm_SearchTerm");
        searchTerm.value = $.trim(searchTerm.value);
        var unquote = $.trim(searchTerm.value.replace(/'|"/g, ""));
        if (searchTerm.value && unquote !== "") {
            processAndSubmitForm(document.getElementById("searchBox"));
        }
    });
    var searchBox = document.getElementById("searchBox");
    if (searchBox) {
        $(searchBox).submit(function (e) {
            updateFormWithWcCommonRequestParameters(e.target);
            var searchTerm = document.getElementById("SimpleSearchForm_SearchTerm");
            var origTerm = searchTerm.value;
            var unquote = $.trim(searchTerm.value.replace(/'|"/g, ""));
            searchTerm.value = unquote;

            if (!searchTerm.value) {
                Utils.stopEvent(e);
                return false;
            }
            searchTerm.value = $.trim(origTerm);
        });
    }

});

function declareDeptDropdownRefreshArea(divId) {
    // ============================================
    // div: drop_down_${department.uniqueID} refresh area
    // Context and Controller to refresh department drop-down

    // common render context
    wcRenderContext.declare("departmentSubMenuContext", [divId], { targetId: "" });

    // render content changed handler
    var renderContextChangedHandler = function() {
        $("#"+divId).refreshWidget("refresh", wcRenderContext.getRenderContextProperties("departmentSubMenuContext"));
    };

    // post refresh handler
    var postRefreshHandler = function() {
        updateDepartmentsMenu(); // Browser may be re-sized. From server we return entire department list.. updateHeader to fit to the list within available size
        activate(document.getElementById(wcRenderContext.getRenderContextProperties("departmentSubMenuContext").targetId)); // We have all the data.. Activate the menu...
        cursor_clear();
    };

    // initialize widget
    $("#"+divId).refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});

}