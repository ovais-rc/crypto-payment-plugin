<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000,2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.order.calculation.CalculationConstants" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.taxation.beans.*" %>
<%@page import="java.util.*" %>

<%@include file="ShippingCommon.jsp" %>

<%
    String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
	
    boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
    String disabledString = " disabled";
    if(editable){
          disabledString = "";
    }

 	String type = request.getParameter("configType");
	String configDataName = "";
   	if (type.equals("product")){
   		configDataName = "config";
   	}
   	else if(type.equals("category")){
   		configDataName = "configCategory";
   	}
   	else if (type.equals("all")){
   		configDataName = "configFlagForAll";
   	}

%>

<html>

<head>
<%= fHeader %>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(shippingCommandContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 300px;}
</style>
<title></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript"
	src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">


function validatePanelData () {

}

function loadPanelData () {

var configFlagsArray = null;
configFlagsArray = top.getData("<%=configDataName%>", 1);
var flagValue = null;
if(configFlagsArray !=null){
<%if (type.equals("product") || type.equals("category")){

%>
	var configIndex = top.getData("configIndex",1);
	flagValue = configFlagsArray[configIndex];
<%} else {

%>
	flagValue = configFlagsArray;
<%}%>
	if(document.configForm.configurationOption[flagValue]!=null)
	{
		document.configForm.configurationOption[flagValue].checked= true;
	}
}

parent.setContentFrameLoaded(true);
}


function savePanelData () {
var flags = document.configForm.configurationOption;
for(var i=0;i<flags.length;i++){
    if(flags[i].checked)
    {
    	var configFlags = null;
    	configFlags = top.getData("<%=configDataName%>", 1);
    	<%if (type.equals("product") || type.equals("category")){
		%>
		var configIndex = top.getData("configIndex", 1);
    	configFlags[configIndex] = flags[i].value;
    	<%} else {
    	%>
    	configFlags = flags[i].value;
		<%}%>
//		top.sendBackData(configFlagsArray, "config");    	
		top.sendBackData(configFlags, "<%=configDataName%>");    	
		break;
    }
}
top.saveModel(parent.model);
top.goBack();
}



</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= shippingRB.get(ShippingConstants.MSG_CONFIG_TITLE) %></h1>
<line3><%= shippingRB.get(ShippingConstants.MSG_CONFIG_PROMPT) %></line3>

<form name="configForm">

	<LABEL><INPUT type="radio" name="configurationOption" value="<%=CalculationConstants.CALFLAGS_ATTACHMENT%>"
		checked <%=disabledString%>></LABEL>
	<%= shippingRB.get(ShippingConstants.MSG_CALFLAGS_ATTACHMENT) %>
	<p>

	<LABEL><INPUT type="radio" name="configurationOption" value="<%=CalculationConstants.CALFLAGS_CANCEL_ATTACHMENT_IN_STOREPATH%>" <%=disabledString%>></LABEL>
	<%= shippingRB.get(ShippingConstants.MSG_CALFLAGS_CANCEL_STOREPATH) %>
	
	
</form>

</body>

</html>
