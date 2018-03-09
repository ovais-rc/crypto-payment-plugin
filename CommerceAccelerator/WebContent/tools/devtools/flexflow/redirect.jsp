<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.registry.StoreRegistry" %>
<%@page import="com.ibm.commerce.common.helpers.StoreUtil" %>

<%@ include file="../../../tools/common/common.jsp" %>

<%
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties myResource = (ResourceBundleProperties)ResourceDirectory.lookup("devtools.StoreFlowRB", locale);
%>

<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
	<script src="/wcs/javascript/tools/common/Util.js"></script>
</head>
<body class="content">
<p><p>
	<script>
		<% 
		// Find out if "MC" is on store.storelevel
		Integer storeEntityId = commandContext.getStoreId();
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
			top.showProgressIndicator(false);
			alertDialog("<%= myResource.getJSProperty("Flow.managementCenter") %>");
			top.setHome();
			<%
		}else if (request.getAttribute("Error") != null) { %>
			var msg = '<%=UIUtil.toJavaScript(request.getAttribute("Error")) %>';
			if (msg == 'generic') {
				top.showProgressIndicator(false);
				alertDialog("<%= myResource.getJSProperty("Flow.notConfigurable") %>");
				top.setHome();
			} else {
				alertDialog(msg);
				top.setHome();
			}
		<% } else { %>
			var param = encodeURIComponent("<%= request.getAttribute("XMLFile") %>");
			location.href="/webapp/wcs/tools/servlet/NotebookView?id=<%=request.getAttribute("id") %>&XMLFile=" + param;
		<% } %>
	</script>
</body>