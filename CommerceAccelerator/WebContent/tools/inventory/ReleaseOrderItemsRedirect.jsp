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
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.inventory.commands.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
TypedProperty requestProp = cmdContextLocale.getRequestProperties();
//System.out.println("RequestProperties = " + requestProp);

Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);

String failedOrderCount = URLParameters.getParameter(AssignToSpecifiedFulfillmentCenterCmd.DEFAULT_OUT_FAILED_ORDER_COUNT_NAME);
int totalOrdersFailed = 0;
if (failedOrderCount != null) {
	totalOrdersFailed = (new Integer(failedOrderCount)).intValue();
}

Hashtable ishFailedOrderIds = null;
//Hashtable ishFailedOrderItemIds = null;
Hashtable ishFailureMessages = null;
String successMsg = "";
StringBuffer partialSuccess = new StringBuffer("");
if ( totalOrdersFailed == 0 ) {
	successMsg = (String)releaseOrderItemsNLS.get("ReleaseOrderItemsSuccess");
} else {
	ishFailedOrderIds = ResolveParameter.resolveValues(AssignToSpecifiedFulfillmentCenterCmd.DEFAULT_OUT_FAILED_ORDER_NAME, requestProp, false);
	//ishFailedOrderItemIds = ResolveParameter.resolveValues(AssignToSpecifiedFulfillmentCenterCmd.DEFAULT_OUT_FAILED_ORDERITEMS_NAME, requestProp, true);
	ishFailureMessages = ResolveParameter.resolveValues(AssignToSpecifiedFulfillmentCenterCmd.DEFAULT_OUT_FAILURE_MESSAGE_NAME, requestProp, false);
	
	partialSuccess.append((String)releaseOrderItemsNLS.get("ReleaseOrderItemsPartialSuccess"));
	partialSuccess.append("<BR>");
	partialSuccess.append("<BR>");
	for (int i=0; i<totalOrdersFailed; i++) {
		if (ishFailedOrderIds != null) {
			partialSuccess.append((String)releaseOrderItemsNLS.get("ReleaseOrderItemsFailedOrder"));
			partialSuccess.append(" ");
			partialSuccess.append(ResolveParameter.getString(new Integer(i+1), ishFailedOrderIds));
			partialSuccess.append("<BR>");
		}
		
		//partialSuccess.append((String)releaseOrderItemsNLS.get("ReleaseOrderItemsFailedOrderItems"));
		//partialSuccess.append(" ");
		//String[] failedOrderItemIds = ResolveParameter.getStringArray(new Integer(i+1), ishFailedOrderItemIds);
		//if (failedOrderItemIds != null) {
		//	for (int j=0; j<failedOrderItemIds.length; j++) {
		//		partialSuccess.append(failedOrderItemIds[j]);
		//		partialSuccess.append(" ");
		//	}
		//}
		//partialSuccess.append("<BR>");
		
		if (ishFailureMessages != null) {
			partialSuccess.append((String)releaseOrderItemsNLS.get("ReleaseOrderItemsFailureReason"));
			partialSuccess.append(" ");
			partialSuccess.append(ResolveParameter.getString(new Integer(i+1), ishFailureMessages));
		}
		partialSuccess.append("<BR>");
		partialSuccess.append("<BR>");
	}
}
%>

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 
<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT>
function initialize() {
	if ("<%= UIUtil.toJavaScript(successMsg) %>" != "") {
		alertDialog("<%=UIUtil.toJavaScript(successMsg)%>");
	} else if ("<%= UIUtil.toJavaScript(partialSuccess.toString()) %>" != "") {
		alertDialog("<%=UIUtil.toJavaScript(partialSuccess.toString())%>");
	}
	
	top.mccmain.submitForm("/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.releaseOrderItems", null);
      	top.refreshBCT();	
}

</SCRIPT>
</HEAD>

<BODY onload="initialize();" class="content">

</BODY>

</HTML>
