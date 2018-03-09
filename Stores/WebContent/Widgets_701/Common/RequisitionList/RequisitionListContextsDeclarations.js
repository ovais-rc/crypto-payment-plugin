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
 * @fileOverview This javascript defines all the render contexts needed for the Requisition List pages.
 * @version 1.2
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * Declares a new render context for requisition list item table
 */
wc.render.declareContext("RequisitionListItemTable_Context",{"beginIndex":"0","requisitionListId":""},"")