<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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
//*-------------------------------------------------------------------
-->

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
    	try{
    		String titleStr = UIUtil.toHTML((String)resourceBundle.get("storeCreationWizardBCTTitle"));   
    		String[] store_types = null;

		Cookie[] cookies = request.getCookies();
		Vector values = new Vector();
		String storetypeSize = null;
		String store_id = null;
		String storeViewName = null;
		boolean isCallingURL = false;
		boolean fromAccelerator = false;

		for (int i = 0; i < cookies.length; i++){
			if (cookies[i].getName().equalsIgnoreCase("storetypeSize")) {
				storetypeSize = cookies[i].getValue();
			}
			if (cookies[i].getName().equalsIgnoreCase("storeIdCookie")) {
				store_id = cookies[i].getValue();
			}
			if (cookies[i].getName().equalsIgnoreCase("callingURLCookie")) {
				isCallingURL = true;
			}
			if (cookies[i].getName().equalsIgnoreCase("fromAcceleratorCookie")) {
				fromAccelerator = true;
			}
			if (cookies[i].getName().equalsIgnoreCase("storeViewNameCookie")) {
				storeViewName = cookies[i].getValue();
			}				
		}

		if(storetypeSize != null){
			int storetypeLength = (new Integer(storetypeSize)).intValue();
			for(int k = 0; k < storetypeLength; k++){
				for (int j = 0; j < cookies.length; j++){
					if (cookies[j].getName().equalsIgnoreCase("storetype" + k)) {
						values.addElement(cookies[j].getValue());					
						break;
					}
				}
			}
		}

		if(values.size() > 0){
			store_types = new String[values.size()];
			values.copyInto(store_types);
		}	  
%>

<html>
<head>
<title><%=titleStr%></title>
</head>
<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script language="JavaScript">
var url = new URLParser(top.document.URL);
var origLangId = url.getParameterValue("originalLangId");
var launchSeparateWindow = url.getParameterValue("launchSeparateWindow");
var redirectURL = '/webapp/wcs/tools/servlet/SCWLogonView';
var isOneParameterPresent = false;

<%
if(store_types != null){
	for(int i = 0; i < store_types.length; i++){
		if(i == 0){
%>
			redirectURL = redirectURL + '?storetype=<%=  UIUtil.toJavaScript(store_types[i]) %>';
			isOneParameterPresent = true;
<%
		}else{
%>
			redirectURL = redirectURL + '&storetype=<%=  UIUtil.toJavaScript(store_types[i]) %>';
<%
		}
	}
}
%>

if('<%= UIUtil.toJavaScript(store_id) %>' != 'null'){
	if(isOneParameterPresent){
		redirectURL = redirectURL + '&storeId=<%= UIUtil.toJavaScript(store_id) %>';
	}else{
		redirectURL = redirectURL + '?storeId=<%= UIUtil.toJavaScript(store_id) %>';
		isOneParameterPresent = true;
	}
	top.put("storeId", "<%= UIUtil.toJavaScript(store_id) %>");
}

if(<%= isCallingURL %>){
	if(isOneParameterPresent){
		redirectURL = redirectURL + '&callingURLPresent=true';
	}else{
		redirectURL = redirectURL + '?callingURLPresent=true';
		isOneParameterPresent = true;
	}
}

if(<%= fromAccelerator %>){
	top.put("fromAccelerator", "true");
}

if(origLangId != null){
	if(isOneParameterPresent){
		redirectURL = redirectURL + '&originalLangId=' + origLangId;
	}else{
		redirectURL = redirectURL + '?originalLangId=' + origLangId;
		isOneParameterPresent = true;
	}
}

if('<%= UIUtil.toJavaScript(storeViewName) %>' != 'null'){
	top.put("storeViewName", "<%= UIUtil.toJavaScript(storeViewName) %>");
}

top.put("closingWindowMessage", "<%=UIUtil.toJavaScript((String)resourceBundle.get("closeWindow"))%>");
top.put("closingRedirectURL", redirectURL); 
if(launchSeparateWindow != null && launchSeparateWindow == "false"){
	top.put("launchSeparateWindow", launchSeparateWindow);
}
top.mccbanner.trail[1].model = new Object();
top.setContent("<%=UIUtil.toJavaScript(titleStr)%>", "/webapp/wcs/tools/servlet/WizardView?XMLFile=contract.StoreCreationWizard", false);

</script>

<body class="content">
</body>
</html>
<%
    }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
    <% }
%>

