<!--********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------
*-->
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.ErrorDataBean" %>

<%@include file="../common/common.jsp" %>
<% response.setContentType("text/html;charset=UTF-8"); %>
<% response.setHeader("Pragma", "No-cache");           %>
<% response.setDateHeader("Expires", 0);               %>
<% response.setHeader("Cache-Control", "no-cache");    %>
<%

  JSPHelper jsphelper = new JSPHelper(request);
  
  ErrorDataBean errorBean = new ErrorDataBean();
  com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);  

%>


<HTML>

<HEAD>
  <TITLE></TITLE>
</HEAD>

<BODY BGCOLOR="#FFFFFF">
<SCRIPT LANGUAGE="JavaScript">
  <!-- // Hide
<%
	if (errorBean.getMessage() != null && ((String)errorBean.getMessage()).length() > 0) {
%>  		
  		window.alert('<%= UIUtil.toJavaScript((String)errorBean.getMessage() ) %>');
  		top.goBack();
<%		
	}  else {
%>
		top.goBack();
<%		
	}  
%>
  // End Hide -->
</SCRIPT>

</BODY>

</HTML>

