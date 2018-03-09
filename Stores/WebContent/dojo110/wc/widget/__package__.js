//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2007
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

dojo.kwCompoundRequire({
    common: ["dojo.xml.Parse",
        "dojo.widget.Widget",
        "dojo.widget.Parse",
        "dojo.widget.Manager"],
    browser: ["dojo.widget.DomWidget",
        "dojo.widget.HtmlWidget"],
    dashboard: ["dojo.widget.DomWidget",
        "dojo.widget.HtmlWidget"],
    svg:      ["dojo.widget.SvgWidget"],
    rhino:      ["dojo.widget.SwtWidget"]
});
dojo.provide("wc.widget.*");
dojo.widget.manager.registerWidgetPackage("wc.widget");