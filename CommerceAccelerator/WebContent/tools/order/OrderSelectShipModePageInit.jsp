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

<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>

<%
	JSPHelper jspHelp = new JSPHelper(request);
	String orderItemId = jspHelp.getParameter("orderItemId");
%>
<html>
  <body class="content">

    <form name="shipModeForm" target="_self" action="/webapp/wcs/tools/servlet/NewDynamicListView" method="get">

    <input type="hidden" name="XMLFile" value="order.orderSelectShipModeDialog" />
    <input type="hidden" name="ActionXMLFile" value="order.orderSelectShipModeList" />
    <input type="hidden" name="cmd" value="OrderSelectShipModePage" />
    <input type="hidden" name="listsize" value="10" />
    <input type="hidden" name="startindex" value="0" />
    <input type="hidden" name="orderItemId" value="<%=orderItemId%>" />
    </form>

    <script language="javascript" type="text/javascript">
	<!-- <![CDATA[
      document.shipModeForm.submit();
    //[[>-->
    </script>
  </body>
</html>