<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>


<%@include file="../common/common.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", jLocale);	

CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
String localeUsed = cmdContext.getLocale().toString();
TypedProperty requestProperty = (TypedProperty) request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);

JSPHelper JSPHelp = new JSPHelper(request);
String customerId = JSPHelp.getParameter("customerId");
String firstOrderId = JSPHelp.getParameter("1stOrderId");
String secondOrderId = JSPHelp.getParameter("2ndOrderId");
String firstBillingAddressId = JSPHelp.getParameter("1stBillingAddressId");
String secondBillingAddressId = JSPHelp.getParameter("2ndBillingAddressId");
String firstPaymentTCId = JSPHelp.getParameter("1stPaymentTCId");
String secondPaymentTCId = JSPHelp.getParameter("2ndPaymentTCId");

// Determine which order adjustment to display
// If nothing is set, default is to display the adjustment of the first order
String PARAM_NAME_DISPLAY_BILLINGADDRESS_FOR_ORDER = "displayBillingAddressForOrder";
String FIRST_ORDER = "firstOrder";
String SECOND_ORDER = "secondOrder";
String displayBillingAddressFor;

try {
	displayBillingAddressFor = JSPHelp.getParameter(PARAM_NAME_DISPLAY_BILLINGADDRESS_FOR_ORDER);
} catch (Exception ex) {
	displayBillingAddressFor = FIRST_ORDER;
}

if (null == displayBillingAddressFor)
	displayBillingAddressFor = SECOND_ORDER;


%>




<html>
  <head>
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

    <title><%= UIUtil.toHTML(orderMgmtNLS.get("wizardConfirmTitle").toString()) %></title>   
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>


    <script>
    
      // get the xml data from the parent window
      function initializeState() 
      {
        parent.orderBillingAddressPage.location.replace(get1stOrderURL());
      }
      
      function get1stOrderURL() {
      	return "/webapp/wcs/tools/servlet/OrderBillingAddressPageInit?customerId=<%=customerId%>&1stOrderId=<%=firstOrderId%>&1stBillingAddressId=<%=firstBillingAddressId%>&1stPaymentTCId=<%=firstPaymentTCId%>&<%= PARAM_NAME_DISPLAY_BILLINGADDRESS_FOR_ORDER  %>=firstOrder";
      }
      
      function get2ndOrderURL() {
      	return "/webapp/wcs/tools/servlet/OrderBillingAddressPageInit?customerId=<%=customerId%>&2ndOrderId=<%=secondOrderId%>&2ndBillingAddressId=<%=secondBillingAddressId%>&2ndPaymentTCId=<%=secondPaymentTCId%>&<%= PARAM_NAME_DISPLAY_BILLINGADDRESS_FOR_ORDER  %>=secondOrder";
      }
      
      function displayBillingAddressFor(value)
      {
      	if (defined(parent.orderBillingAddressPage.basefrm)) {
      		parent.orderBillingAddressPage.basefrm.savePanelData();
      	}
      	var url;
	if (value == "<%=FIRST_ORDER%>") {
		url = get1stOrderURL();
	} else {
	     	url = get2ndOrderURL();
	}
	parent.orderBillingAddressPage.location.replace(url);
	
      }
    //[[>-->
    </script>
  </head>
  <body  class="content" onload="initializeState();" >        
    <form name="itemSummary" method="post" action="">
	
	
	<table>
 		<tr>
			<td align="left">
				<p><b><label for="showBilling"><%= UIUtil.toHTML(orderMgmtNLS.get("showBillingAddressForTheFollowing").toString()) %></label></b></p>
			</td>
		</tr>
		<tr>
			<td align="left">
				<select id="showBilling" name="showBillingAddress" onchange="displayBillingAddressFor(value);"> 
					<option id="firstOrder" value="<%= FIRST_ORDER %>" selected ="selected"><%= UIUtil.toHTML(orderMgmtNLS.get("showBillingAddressForCurrentOrder1").toString()) %> <%= firstOrderId %><%= UIUtil.toHTML(orderMgmtNLS.get("showBillingAddressForCurrentOrder2").toString()) %> </option> 
					<option id="secondOrder" value="<%= SECOND_ORDER %>"> <%= UIUtil.toHTML(orderMgmtNLS.get("showBillingAddressForOtherOrder1").toString()) %> <%= secondOrderId %><%= UIUtil.toHTML(orderMgmtNLS.get("showBillingAddressForOtherOrder2").toString()) %> </option> 
				</select>
			</td>
		</tr>
	</table>
	<br />
		
    </form>

<form name="callActionForm" action="" method="post">
<input type="hidden" name="XML" value="" />
<input type="hidden" name="URL" value="" />
</form>
  </body>
</html>



