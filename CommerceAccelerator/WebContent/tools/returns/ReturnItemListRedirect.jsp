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
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="../common/common.jsp" %>

<%
   // get request parameters
   JSPHelper jspHelper = new JSPHelper(request);
   String returnId = jspHelper.getParameter("returnId");
   if ( returnId == null )
      returnId = "";
%>

<HTML>
<HEAD>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT>

function initialize() {    
	parent.parent.setContentFrameLoaded(true);
	
	// set the return id in the wizard model
        var returnWizardModel = top.getModel(1);
        returnWizardModel.returnId = "<%=returnId%>";
        
        //set the customer id in the wizard model
        var customerId = parent.parent.get("customerId");
        returnWizardModel.customerId = customerId;
        
	top.goBack();
}

</SCRIPT>
</HEAD>

<BODY class="content" onload="initialize();">
</BODY>

</HTML>
