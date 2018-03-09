<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>	
<%@include file="common.jsp" %>

<jsp:useBean id="list" scope="request" class="com.ibm.commerce.tools.common.ui.NewDynamicListBean"></jsp:useBean>

<%
    list.setRequest(request);  
    list.setParameters(request); 

    CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cc.getLocale();
%>

  <%= list.getUserJSfnc() %>
<SCRIPT SRC="/wcs/javascript/tools/common/newlist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/newbutton.js"></SCRIPT>

<script>
  var button_frame_loaded = false;
  var scroll_frame_loaded = false;

  <%= list.getJSvars() %>
  <%= list.getButtons() %>
  <%= list.getControlPanel() %>
</script>

<html>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" />
<title>List Title</title>
</head>

<%=
    list.getGeneralForm()
%>
<%=
    list.getFrameset()
%>
<%=
    list.setJSvars()
%>

</html>
