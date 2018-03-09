<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2003
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants" %>

<%@include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<HTML>
<HEAD>
 <%= fHeader %>
<TITLE><%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_NAME)%></TITLE>
</HEAD>
<BODY class="content">
<FONT style="font-family: Verdana,Arial,Helvetica; font-size: 16pt; color: #565665; font-weight: normal; word-wrap: break-word;">
<%= guidedSellRB.get(GuidedSellUIConstants.GSA_CONSTRAINT_NAME)%>
</font>
</BODY>
</HTML>
