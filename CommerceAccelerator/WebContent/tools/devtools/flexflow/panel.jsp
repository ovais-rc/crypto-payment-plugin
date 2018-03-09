<!--
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
//*--------------------------------------------------------------------->

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="java.util.Locale" %>

<%@include file="../../common/common.jsp" %>

<%
	CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties myResource = (ResourceBundleProperties)ResourceDirectory.lookup("devtools.StoreFlowRB", locale);
%>

<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
	<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
	<script src="/wcs/javascript/tools/common/Util.js"></script>

	<!jsp:include page="flexflow.jsp" flush="true" />
	<%@include file="flexflow.jsp" %>
	
	<%--
	<%@include file="debug.jsp" %>
	--%>

	<script>
	
		/******************************************************************************
		*
		*	State initializer.
		*
		******************************************************************************/
	
		function initializeState()
		{
			initializeContent();
		}
		
		/******************************************************************************
		*
		*	Button controller & handlers.
		*
		******************************************************************************/
	
		function showCacheWarning()
		{
			var requestProperties = parent.NAVIGATION.getRequestProperties();
			var cacheEnabled = requestProperties["cacheEnabled"];		
			if (cacheEnabled == "true")
				alertDialog('<%=UIUtil.toJavaScript( (String)myResource.get("configureCacheWarning")) %>');
		}
		
		function submitFinishHandler(finishMessage)
		{
			showCacheWarning();
			parent.put("cmd", "finishCmd");
			
			var requestProperties = parent.NAVIGATION.getRequestProperties();
			var cmd = requestProperties["cmd"];
			
			if (cmd == "applyCmd")
				return;
			else
				top.goBack();
		}
	
		function applyButton()
		{
			parent.put("cmd", "applyCmd");
			parent.finish();
		}
		
		function applyPermanentlyButton()
		{
			var confirmMessage = '<%=UIUtil.toJavaScript( (String)myResource.get("Flow.warning")) %>';
			if (confirmDialog(confirmMessage) == true)
			{
				parent.put("cmd", "applyPermanentlyCmd");
				parent.finish();
			}
		}

		function submitErrorHandler(errorMessage)
		{	
			parent.put("cmd", "finishCmd");
			alertDialog(errorMessage);
		}

	</script>

</head>

<jsp:useBean id="panelBean" scope="request" class="com.ibm.commerce.tools.devtools.flexflow.ui.databeans.PanelBean"></jsp:useBean>
 
<body class="content" onload="initializeState();">
<form name="optionsForm">

<%
	panelBean.setRequest(request);
	panelBean.writeBody(out);
%>

</form>
</body>
