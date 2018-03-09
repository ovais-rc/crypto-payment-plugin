//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript defines all the render contexts needed for the Saved Order pages.
 * @version 1.1
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * Declares a new render context for saved order details page item table.
 */
wc.render.declareContext("SavedOrderItemTable_Context",{"beginIndex": "0"},"");

/**
 * Declares a new render context for saved order details page information area.
 */
wc.render.declareContext("SavedOrderInfo_Context",null,"");
