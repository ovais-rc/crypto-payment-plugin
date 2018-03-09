//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript is used by CategoriesNavDisplay.jsp to display the collapse style category of the Madisons starter store.
 * @version 1.0
 */

/* Import dojo classes. */
dojo.provide("wc.widget.WCTitlePane");

dojo.require("dijit.TitlePane");
dojo.require("dijit._Widget");
dojo.require("dijit._Container");
dojo.require("dijit._Templated");

dojo.declare("wc.widget.WCTitlePane", dijit.TitlePane, {

    url: "#",

    alt: "",

    startup: function() {
        this.inherited("startup", arguments);
        this.attr('title', "<span><a href=\"" + this.url + "\" title=\"" + this.alt + "\">" + this.title + "</a></span>");
    },

    setTitle: function(/*String*/ title) {
        title = "<span><a href=\"" + this.url + "\" title=\"" + this.alt + "\">" + title + "</a></span>";
        this.titleNode.innerHTML = title;
    }

});