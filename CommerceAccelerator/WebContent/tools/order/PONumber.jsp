<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.order.beans.OrderDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%@include file="../common/common.jsp" %>
<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Hashtable orderMgmtNLS=(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);

OrderDataBean orderBean = new OrderDataBean ();
String poNumber = null;

if ((orderId != null) && !(orderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(orderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
    poNumber = orderBean.getPurchaseOrderNumber();
}
if(poNumber == null) {poNumber = "";}

%>

<HTML>
<HEAD>
  <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
  <TITLE><%= UIUtil.toJavaScript(orderMgmtNLS.get("PONumberTitle")) %></TITLE>
  <script src="/wcs/javascript/tools/common/Util.js"></script>
  <script src="/wcs/javascript/tools/common/Vector.js"></script>
  <script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>

<SCRIPT>

  var order = parent.get("order");
  var poNumber = order["poNumber"];
  // remove preCommand in XML when this page loaded
  var preCommand = parent.get("preCommand");
 
  
  if (!defined(poNumber)) {
     poNumber = "<%=poNumber%>";
     addEntry(order, "poNumber", poNumber);
  }
  function initializeState() {
     document.PONumber.poNumberField.value = poNumber;
     parent.setContentFrameLoaded(true);
  }
    
  // used to save the data in the panel to the model in both Notebook and Wizard
  function savePanelData()
  {
     poNumber = document.PONumber.poNumberField.value;
     updateEntry(order, "poNumber", poNumber);
     
     var authToken = parent.get("authToken");
     if (defined(authToken)) {
	  parent.addURLParameter("authToken", authToken);
     }
  }

  
  
  // used to validate panel in the Wizard
  function validatePanelData() {
    return true;  
  }
</SCRIPT>

</HEAD>

<body  onLoad="initializeState();" class="content">
<TITLE><%= UIUtil.toHTML((String) orderMgmtNLS.get("PONumberTitle")) %></TITLE>
<form NAME='PONumber' METHOD='POST'>
<h1><%= UIUtil.toHTML((String) orderMgmtNLS.get("PONumberTab")) %></h1>
<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("changePONumberInstruction")) %>
<TABLE BORDER='0'>
    <TR>
      <TD COLSPAN=4>
        <P><BR><label for="poNumberFd"><%= UIUtil.toHTML((String) orderMgmtNLS.get("PleaseEnterPONumber")) %></label><BR>
      </TD>
    </TR>
    <TR>
      <TD COLSPAN=4>
        <input id="poNumberFd" NAME='poNumberField' value='' size=40></input>
      </TD>
    </TR>
</table>
</form>


</body>

</HTML>



