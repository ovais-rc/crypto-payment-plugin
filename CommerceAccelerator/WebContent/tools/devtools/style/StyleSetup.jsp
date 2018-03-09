<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.exception.ECException" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ConfigProperties" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.registry.StoreRegistry" %>
<%@page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>

<%
	/* When FlexflowDataBean is populated it first checks that this store is configured to
	 * access change style from Accelerator, if it is then it checks for all appropriate store Style xml files.  
	 * If a needed file is missing, it throws an exception.  Else we redirect to the Style wizard.
	 */

	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties wizardRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreStyleRB", locale);	
	
	// Find out if "MC" is on store.storelevel
	Integer storeEntityId = cmdContext.getStoreId();
	String STORE_LEVEL = "MC";	
	String strStoreLevel = null;	
	StoreAccessBean storeAB = StoreRegistry.singleton().find(storeEntityId);
	if (storeAB != null) {	
		strStoreLevel = storeAB.getStoreLevel();
		if (strStoreLevel == null) {
			Integer[] storePathIds = StoreUtil.getStorePath(storeAB.getStoreEntityIdInEntityType(), ECConstants.EC_STRELTYP_VIEW);
			StoreAccessBean relatedStoreAccessBean = null;
			boolean storeLevelFound = false;	
			for (int i=1; i<storePathIds.length; i++) {
				if (!storeLevelFound) {
					relatedStoreAccessBean = StoreRegistry.singleton().find(storePathIds[i]);
					strStoreLevel = relatedStoreAccessBean.getStoreLevel();
					if (strStoreLevel != null) {
						storeLevelFound = true;
					}
				}
			}
		}
	}
	if (strStoreLevel != null && strStoreLevel.toUpperCase().contains(STORE_LEVEL.toUpperCase())) {
		%>
		<html>
			<head>
				<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
				<script src="/wcs/javascript/tools/common/Util.js"></script>
				
				<script>
					top.showProgressIndicator(false);
					alertDialog('<%=UIUtil.toJavaScript(wizardRB.get("error.managementCenter"))%>');
					top.setHome();
				</script>
			</head>
			<body class="content" >
		<br>
		</body>
		<%
	} else {
		try {%>
			<jsp:useBean id="flowBean" scope="request" class="com.ibm.commerce.tools.devtools.flexflow.ui.databeans.FlexflowDataBean">
			<%
				flowBean.setCommandContext(cmdContext);
				flowBean.setUIPath(com.ibm.commerce.tools.devtools.flexflow.util.FlexflowConfig.getStyleUIPath());
				flowBean.populate();
			%>
			</jsp:useBean>
			<html>
			<head>
				<meta http-equiv="refresh" content="0; URL=/webapp/wcs/tools/servlet/WizardView?XMLFile=devtools.StoreStyleWizard">
				<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
			</head>
			<body class="content">
			</body>
		<%}catch(ECException e){%>
			<html>
			<head>
				<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
				<script src="/wcs/javascript/tools/common/Util.js"></script>
				
				<script>
					top.showProgressIndicator(false);
					alertDialog('<%=UIUtil.toJavaScript(wizardRB.get("error.notConfigurable"))%>');
					top.setHome();
				</script>
			</head>
			<body class="content" >
			<br>
			</body>
			<%
		}
	}
%>
</html>
