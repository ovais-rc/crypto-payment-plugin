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
 * @fileOverview This javascript defines all the render contexts needed for the approval List pages.
 * @version 1.2
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * Declares a new render context for order approval list table
 */
wc.render.declareContext("OrderApprovalTable_Context",{"beginIndex":"0", "orderId": "", "firstName": "", "lastName":"","startDate":"","endDate":"","approvalStatus":"0"},"")

/**
 * Declares a new render context for buyer approval list table
 */
wc.render.declareContext("BuyerApprovalTable_Context",{"beginIndex":"0", "approvalId": "", "firstName": "", "lastName":"","startDate":"","endDate":"","approvalStatus":"0"},"")

/**
 * Declares a new render context for approval comments widget
 */
wc.render.declareContext("ApprovalComment_Context",{"approvalStatus":"all"},"")