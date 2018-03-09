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
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>


<%@ taglib uri="flow.tld" prefix="flow" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Hashtable orderMgmtNLS = (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

JSPHelper URLParameters = new JSPHelper(request);
String displayPaymentFor = URLParameters.getParameter("displayPaymentFor");
%>

<html>
  <head>
    <title><%= UIUtil.toHTML( (String)orderMgmtNLS.get("paymentPONumberTitle")) %></title>
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
  </head>
  <body class="content"> 

<flow:ifEnabled feature="PurchaseOrderOnlyDisplay PurchaseOrderDisplay">

  <form name="f1">
  <table>
    <tr><td><label for="ponum"><%= UIUtil.toHTML( (String)orderMgmtNLS.get("paymentPONumber")) %></label></td></tr><tr>
    
    </tr><tr>
    <td>
        <input id="ponum" type="text" size="30" maxlength="256" name="PONumber" value="" />
    </td>
    </tr>
    
  </table>
  </form>
  
  <script type="text/javascript">
	<!-- <![CDATA[
     
     // pre-fill the PONumber field if it was saved before
     // 1. assumption is that this form has only one input field (which is PONumber)
     var order = parent.parent.get("order");
     var orderToChange = order["<%= displayPaymentFor %>"];
     var payment = orderToChange["payment"];
     
     if ( defined(payment) && defined(payment[this.document.f1.elements[0].name]) ) {
        if ( payment[this.document.f1.elements[0].name] != "" ) {
           this.document.f1.elements[0].value = payment[this.document.f1.elements[0].name];          
        }
     }
  //[[>-->
  </script>
  
</flow:ifEnabled>

  </body>
</html>
