
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%> 
<%@ page language="java"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@include file="../common/common.jsp" %>

<!-- Get the resource bundle with all the NLS strings -->
<%
  CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContextLocale.getLocale();
  Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
  
  String  orderId = request.getParameter("orderId");
  String  orderBlockId = request.getParameter("orderBlockId");
  
  OrderBlockDataBean orderBlockDB = new OrderBlockDataBean();
  orderBlockDB.setOrderBlockId(orderBlockId);
  com.ibm.commerce.beans.DataBeanManager.activate(orderBlockDB, request);
  String resolved = orderBlockDB.getResolved().toString();
  String blockCodeId = orderBlockDB.getBlkRsnCodeId().toString();
  String description = orderBlockDB.getBlockReasonCodeDB().getDescription();
  String strResolved = null;
  if (resolved.equals("1")){
     strResolved = (String)orderLabels.get("orderResolved");
  }else {
     strResolved = (String)orderLabels.get("orderNotResolved");
  }
%>


<html>
<head>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"/>
<script language="JavaScript">
<!-- <![CDATA[
  var orderId=<%=(orderId == null ? null : UIUtil.toJavaScript(orderId))%>;
  
  function onLoad(){
    parent.setContentFrameLoaded(true);
  }
  
  function saveComments(){
    var urlParams = new Object();
    var url = "/webapp/wcs/tools/servlet/BlockNotify";
    if (<%=resolved%>=="1"){
       urlParams.notifyBlock = 'false';
    } else {
       urlParams.notifyBlock = 'true';
    }
    urlParams.orderId = orderId;
    urlParams.reasonCodeId = <%=blockCodeId%>;
    urlParams.blockOrUnblockComments = document.orderBlock.commentsField.value;
    urlParams.URL = '/webapp/wcs/tools/servlet/OrderBlockRedirect';
    top.setContent('',url,false,urlParams);
  }
              
// -->
//[[>-->
</script>
</head>

<body class=content onload="onLoad();">

<h1><%= UIUtil.toHTML((String)orderLabels.get("addCommentTitle")) %> </h1>

<table>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlockOrderNumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %>
			    <i><%= UIUtil.toHTML(orderId) %></i>
			</td>
		</tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlcokDescription")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %>
			    <i><%= UIUtil.toHTML(blockCodeId) %>  <%= UIUtil.toHTML(description) %></i>
			</td>
		</tr>
		<tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlodkResolved")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %>
			    <i><%= UIUtil.toHTML(strResolved) %></i>
			</td>
		</tr>
</table>

<form name="orderComments" id="orderBlock">
  <label for="commentsField"><%= orderLabels.get("orderBlockComments") %></label><br /><br />
  <textarea name="commentsField" rows="7" cols="60" id="commentsField"><%=orderBlockDB.getBlkComment()%></textarea>
</form>
</body>
</html>

