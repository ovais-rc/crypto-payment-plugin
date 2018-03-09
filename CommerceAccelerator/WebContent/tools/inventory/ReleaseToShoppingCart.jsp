<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 020723	    KNG		Initial Create
//
// 020813	    KNG		Make changes from code review and
//				UCD design exploration sessions
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.inventory.commands.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Long userId = cmdContextLocale.getUserId();

Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderIds = URLParameters.getParameter("orderIds");
String orderItemIds = URLParameters.getParameter("orderItemIds");
String ffmcIds = URLParameters.getParameter("ffmcIds");
String FFMStores = URLParameters.getParameter("FFMStores");

String[] FFMStoresTokens = Util.tokenize(FFMStores, ",");
%>

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 

<TITLE><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartTitle")) %></TITLE>

<SCRIPT src="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT>
var orderItemIds = "<%= orderItemIds %>";
var ffmcIds = "<%= ffmcIds %>";
var orderIds = "<%= orderIds %>";

var orderItemId = orderItemIds.split(",");
var ffmcId = ffmcIds.split(",");
var orderId = orderIds.split(",");

function initialize() {
	parent.setContentFrameLoaded(true);
}

function release() {
	// create parameters for the command
	var URLParam = new Object();
	URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_ALLOCATE %>"] = "1";
	URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_RELEASE %>"] = "1";
	URLParam.orderItemIds = "<%= orderItemIds %>";
	URLParam.ffmcIds = "<%= ffmcIds %>";
	URLParam.FFMStores = "<%= FFMStores %>";
	URLParam.orderIds = "<%= orderIds %>";	
	
	for (var i=0; i<orderItemId.length; i++) {
		URLParam["<%= OrderConstants.EC_ORDERITEM_ID %>" + "_" + (i+1)] = orderItemId[i];
		URLParam["ffmcenterId" + "_" + (i+1)] = ffmcId[i];
	}

	var checkedOption;
	
	for (i=0; i<document.releaseToShoppingCartForm.releaseOption.length; i++) {
		if (document.releaseToShoppingCartForm.releaseOption[i].checked) {
			checkedOption = i;
		}
	}
	
	var releaseOption = document.releaseToShoppingCartForm.releaseOption[checkedOption].value;
	
	if (releaseOption == "1") {
		// shopCartNumber is mandatory
		if (document.releaseToShoppingCartForm.shopCartNumber.options[document.releaseToShoppingCartForm.shopCartNumber.selectedIndex].value == "none") {
			alertDialog("<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartNothingSelected")) %>");
			return false;
		} else {
			URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_FULFILLMENT_ORDER_ID %>"] = document.releaseToShoppingCartForm.shopCartNumber.options[document.releaseToShoppingCartForm.shopCartNumber.selectedIndex].value;
		}		
	} else if (releaseOption == "2") {
		// shopCartName is mandatory
		if (document.releaseToShoppingCartForm.shopCartName.value == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartNoName")) %>");
			return false;
		} else {
			URLParam["<%= AssignToSpecifiedFulfillmentCenterCmd.STR_FULFILLMENT_ORDER_NAME %>"] = document.releaseToShoppingCartForm.shopCartName.value;
		}
	}

	var returnURL = "ReleaseToShoppingCartRedirect";
	URLParam.URL = returnURL;
	URLParam["<%= ECConstants.EC_ERROR_VIEWNAME %>"] = "ReleaseToShoppingCartErrorView";

	var url = "/webapp/wcs/tools/servlet/AssignToSpecifiedFulfillmentCenter?";
	for(k=0; k<orderId.length; k++) {
		if (k==0) {
			url = url + "<%= OrderConstants.EC_ORDER_ID %>=" + orderId[k];
		} else {
			url = url + "&<%= OrderConstants.EC_ORDER_ID %>=" + orderId[k];
		}
	}	
	
	parent.setContentFrameLoaded(false);
	top.mccmain.submitForm(url,URLParam);
      	//top.refreshBCT();
}
</SCRIPT>
</HEAD>

<BODY onload="initialize();" class="content">

<script language="javascript"><!--alert("ReleaseToShoppingCart.jsp");--></script> 


  <H1><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartTitle")) %></H1>
  <P><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartDescription")) %>  

  <form name="releaseToShoppingCartForm">

  <table border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td valign="bottom" align="left">
    <input type="radio" name="releaseOption" id="releaseOption" value="1" checked ><label for="releaseOption"><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartExisting")) %></label>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  
  <tr>
    <td valign="bottom" align="left">
    &nbsp;&nbsp;&nbsp;
    <LABEL for="shopCartNumber1"><select name="shopCartNumber" id="shopCartNumber1" ></LABEL>
        <option  value="none"><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartSelectOne")) %></option>
<%
// read the reseller shopping cart numbers
// @kng - assumption of 1 FFMStore only
OrderAccessBean orderAB = new OrderAccessBean();
String anOrderId = "";
String description = "";
Enumeration pendingOrders = orderAB.findPendingOrders(userId, new Long(FFMStoresTokens[0]));
Enumeration currentPendingOrders = orderAB.findCurrentPendingOrdersByMemberAndStore(userId, new Integer(FFMStoresTokens[0]));

Vector cpOrderIds = new Vector();
while (currentPendingOrders.hasMoreElements()) {
	cpOrderIds.addElement( ((OrderAccessBean)currentPendingOrders.nextElement()).getOrderId() );
}

while (pendingOrders.hasMoreElements()) {
	orderAB = (OrderAccessBean)pendingOrders.nextElement();
	anOrderId = orderAB.getOrderId();
	// 1. is it a current pending order then get description from properties file
	// 2. the description is empty then put order id
	if (orderAB.getDescription() == null || orderAB.getDescription().equals("")) {
		boolean isCurrentPendingOrder = false;
		String aCPOrderId = "";
		for (int i=0; i<cpOrderIds.size(); i++) {
			aCPOrderId = (String)cpOrderIds.elementAt(i);
			if (aCPOrderId.equals(anOrderId)) {
				isCurrentPendingOrder = true;
			}
		}
		
		if (isCurrentPendingOrder) {
			description = (String)releaseOrderItemsNLS.get("ReleaseToShoppingCartCurrentShopcart");
		} else {
			description = anOrderId;
		}
	} else {
		description = orderAB.getDescription();
	}
%>
	<option  value="<%= anOrderId %>"><%= description %></option>
<%
}
%></select>
    </td>
  </tr>

  <P>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="bottom" align="left">
    <input type="radio" name="releaseOption" id="releaseOption" value="2" ><label for="releaseOption"><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartNew")) %></label>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="bottom" align="left">
    &nbsp;&nbsp;&nbsp;
    <label for="shopCartName"><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartNewName")) %></label>
    &nbsp;
    <input type="text" name="shopCartName" id="shopCartName" value="" size=64 maxlength=254 >
    </td>
  </tr>
  
  <P>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="bottom" align="left">
    <input type="radio" name="releaseOption" id="releaseOption" value="3" ><label for="releaseOption"><%= UIUtil.toHTML((String)releaseOrderItemsNLS.get("ReleaseToShoppingCartOnePerOrder")) %></label>
    </td>
  </tr>
  </table>
  </form>
</BODY>
</HTML>
