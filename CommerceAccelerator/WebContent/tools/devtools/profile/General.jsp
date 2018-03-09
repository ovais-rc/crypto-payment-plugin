<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.common.objects.StoreEntityDescriptionAccessBean" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Locale" %>

<%@include file="../../common/common.jsp" %>

<%
try {
	
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties storeProfileRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreProfileRB", locale);
%>

<%
	String storeName = null;
	String storeDescription = null;
	
	StoreEntityDescriptionAccessBean storeDescriptionAB = null;
	
	try {
		storeDescriptionAB = cmdContext.getStore().getDescription(cmdContext.getLanguageId());
	} catch(javax.persistence.NoResultException e) {
		storeDescriptionAB = null; // JTest filler
	}
	
	if (storeDescriptionAB != null) {
		storeName = storeDescriptionAB.getDisplayName();
		storeDescription = storeDescriptionAB.getDescription();
	}
	
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
	/******************************************************************************
	*
	*	Store data object.
	*
	******************************************************************************/	
	function StoreData(name, description)
	{
		this.name = name;
		this.description = description;
	}

	function populateForm(storeData)
	{
		document.details.name.value = storeData.name;
		document.details.description.value = storeData.description;
	}

	function processErrors()
	{
		var errorCode = parent.get(parent.ERROR_CODE);

		if (errorCode == null)
			return;

		else if (errorCode == parent.ERR_DETAILS_NAME)
		{
			document.details.name.select();
			alertDialog("<%= (String)storeProfileRB.getJSProperty("AlertMaxLength") %>");
		}
		else if (errorCode == parent.ERR_DETAILS_DESCRIPTION)
		{
			document.details.description.select();
			alertDialog("<%= (String)storeProfileRB.getJSProperty("AlertMaxLength") %>");
		}
		
		parent.remove(parent.ERROR_CODE);
	}		
		
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		var storeData = parent.get(parent.STORE_DATA_ID);
		
		if (storeData == null)
		{
			storeData = new StoreData();
			storeData.name = "<%= UIUtil.toJavaScript(storeName) %>";
			storeData.description = "<%= UIUtil.toJavaScript(storeDescription) %>";
		}
		
		populateForm(storeData);
		processErrors();		
		parent.setContentFrameLoaded(true);	
	}

	function savePanelData()
	{
		var storeData = new StoreData(document.details.name.value, document.details.description.value);
		parent.addURLParameter("authToken", "${authToken}");
		parent.put(parent.STORE_DATA_ID, storeData);
	}
</script>

</head>
<body class="content" onload="initializeState();">

<h1><%= (String)storeProfileRB.getProperty("GeneralPanel.title") %></h1>

<form name="details">
	<label for="name"><%= (String)storeProfileRB.getProperty("GeneralPanel.name") %></label><br>
	<input id="name" size="20" value=" " type="text" name="name" maxlength="80"><br>
	<br>
	<label for="description"><%= (String)storeProfileRB.getProperty("GeneralPanel.description") %></label><br>
	<textarea rows="7" cols="55" id="description" name="description">""</textarea><br>
	<br>
</form>

</body>
<%
}
catch (Exception e) 
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
</html>
