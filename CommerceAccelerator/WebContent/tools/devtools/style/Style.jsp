<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.exception.ECException" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ConfigProperties" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@include file="../../common/common.jsp" %>

<%@ taglib uri="flow.tld" prefix="flow" %>
<flow:fileRef id="bannerCustom" fileId="vfile.banner"/>
<flow:fileRef id="vfileSelectBanner" fileId="vfile.selectedBanner"/>


<%
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties wizardRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreStyleRB", locale);

	Integer StoreId= cmdContext.getStoreId();       
	String StoreDir = cmdContext.getStore(StoreId).getDirectory();
        
        // get the stores webapp path
       // String StoresWebPath = ConfigProperties.singleton().getValue("WebServer/StoresWebPath");
	String StoresWebPath = "";
	WebModuleConfig webApp = (WebModuleConfig) com.ibm.commerce.server.WebApp.retrieveObject("Stores");
	if (webApp != null) {
		StoresWebPath = webApp.getContextPath()+"/servlet";
	}
	String SSLPort = ConfigProperties.singleton().getValue("WebServer/SSLPort");
try {
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
	var selections = new Object();	// selections[optionGroupId] = optionId that is selected for the optionGroupId
	var optionGroups = new Object();

	/* initializeData() is called to read FlexFlow style data and store it in the parent hashtable for easier access
	 */
	function initializeData()
	{

		<jsp:useBean id="flowBean" scope="request" class="com.ibm.commerce.tools.devtools.flexflow.ui.databeans.FlexflowDataBean">
		<%
			flowBean.setCommandContext(cmdContext);
			flowBean.setUIPath(com.ibm.commerce.tools.devtools.flexflow.util.FlexflowConfig.getStyleUIPath());
			flowBean.populate();
			out.println(flowBean.toJS());
		%>
		</jsp:useBean>

		parent.put("jspStoreDir", "<%= UIUtil.toJavaScript(flowBean.getUIStoreDir()) %>");

		parent.put("flexflowInfo", flexflowInfo);

		// Make it more convenient to access options.
		optionGroups["StylePanelOptions"] = flexflowInfo["panels"]["StylePanel"]["optionGroups"]["StylePanelOptions"];
		optionGroups["ColorPanelOptions"] = flexflowInfo["panels"]["ColorPanel"]["optionGroups"]["ColorPanelOptions"];
		optionGroups["BannerPanelOptions"] = flexflowInfo["panels"]["BannerPanel"]["optionGroups"]["BannerPanelOptions"];
		optionGroups["CustomBannerPanelOptions"] = flexflowInfo["panels"]["BannerPanel"]["optionGroups"]["CustomBannerPanelOptions"];
		parent.put("optionGroups", optionGroups);
		
		// Initialize Banner page data
		<flow:ifEnabled feature="CustomBanner">
			<%-- Want to store that the current banner is a custom banner --%>
			parent.put("currentBannerCustom","true");
			parent.put("currentCustomBannerName", "<%=UIUtil.toJavaScript(bannerCustom)%>");
			parent.put("uploadedBannerName", "<%=UIUtil.toJavaScript(bannerCustom)%>");
			parent.put("uploadedBanner", "true");
		</flow:ifEnabled>
		<flow:ifDisabled feature="CustomBanner">
			<%-- Want to store that the current banner is a provided/selected banner --%>
			parent.put("currentSelectedBannerName", "<%=UIUtil.toJavaScript(vfileSelectBanner)%>");
		</flow:ifDisabled>
	}


	/* showStyles() draws all the supported styles on the screen.
	 */
	function showStyles()
	{
		if (parent.get("flexflowInfo") == null) {
			initializeData();
		}

		selections = parent.get("flexflowInfo")["selections"];
		optionGroups = parent.get("optionGroups");

		var COLUMNS = 3;
		var i = 0;
		var templateLabel = '<%=UIUtil.toJavaScript(wizardRB.get("style.label"))%>';
		var label = '';
		for (var styleId in optionGroups.StylePanelOptions.options)
		{
			style = optionGroups.StylePanelOptions.options[styleId]; 
						
			var row = i % COLUMNS;
			if (row == 0) {
				document.write('<tr>');
			}
			
			document.write('<td valign="top">');
			document.write('<input type="radio" value="' + style.id + '" name="styleRadio" id="style' + style.id + '" onClick="SaveToTopFrame(' + i + ');">');
			document.write('</td>');

			document.write('<td>');
			
			label = templateLabel.replace('{0}', i+1);
			document.write('<label for="style' + style.id + '"><img src="' + self.location.protocol + '//' + self.location.hostname + <% if(SSLPort != null){%> ":<%=SSLPort%>" + <%}%>'<%=StoresWebPath%>/' + style.src.replace("$storeDir$", parent.get("jspStoreDir")) + '" border="0" onClick="SaveToTopFrame(' + i + ');" alt="' + label + '"></label>');

			document.write('<br><br></td>');
			
			if (row == (COLUMNS - 1)) {
				document.write('</tr>');
			}
			i++;
		}
	}

	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		parent.setContentFrameLoaded(true);

		// Put dynamic store data into parent frame so StyleEditor.js can use it
                parent.put("StoreId", "<%=StoreId%>");
                parent.put("StoreDir", "<%=StoreDir%>");
	        parent.put("StoresWebPath", "<%=StoresWebPath%>");
			parent.put("SSLPort", "<%=SSLPort%>");
	        parent.put("AlertWarning", "<%=UIUtil.toJavaScript(wizardRB.get("warning.apply"))%>");
	        
		
		var elements = document.styleForm.elements;
		for (var i = 0; i < elements.length; i++)
		{
			if (elements[i].type == 'radio' && elements[i].value == selections["StylePanelOptions"]) {
				elements[i].checked = true;
			}
		}
	}


	/* When a new style is selected, we have to save this selection and 
	 * reset all the selections for the store color and banner.
	 */
	function SaveToTopFrame(styleNumber)
	{
		document.styleForm.styleRadio[styleNumber].checked = true;
		
		// Save style information
		selections["StylePanelOptions"] = document.styleForm.styleRadio[styleNumber].value;
		
		// Save color information
		var style = optionGroups.StylePanelOptions.options[selections["StylePanelOptions"]];
		selections["ColorPanelOptions"] = style.enablesOptions[0];
		
		// Save banner selection information
		var colors = optionGroups.ColorPanelOptions.options[selections["ColorPanelOptions"]];
		selections["BannerPanelOptions"] = colors.enablesOptions[0];	
	}
	
	/* submitApplyHandler() is Called when the Apply button is pressed.
	 */
	function submitApplyHandler(finishMessage)
	{
		location.reload();	// Refresh the screen
	}
	
</script>
</head>

<body class="content" onload="initializeState()">

<H1><%=wizardRB.get("style.title")%></H1>
<%=wizardRB.get("style.blurb")%>
<br>
<br>

<form name="styleForm" action="post">
	<table>

		<script>
			showStyles();
		</script>

	</table>
</form>
</body>
</html>

<%
}catch(ECException e)
{
	out.println(e);
}
%>
