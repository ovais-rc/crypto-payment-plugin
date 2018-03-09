<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2003
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>


<%@include file="../../common/common.jsp" %>

<%
try {
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties wizardRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreStyleRB", locale);
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
	// Global Variables
	var selections = null;
	var optionGroups = null;
	
	/* showColors() writes out all the color options supported for a particular style selected on the previous screen
	 */
	function showColors()
	{
		selections = parent.get("flexflowInfo")["selections"];
		optionGroups = parent.get("optionGroups");

		var enabledOptions = optionGroups.StylePanelOptions.options[selections["StylePanelOptions"]].enablesOptions;
		var COLUMNS = 3;
		var SSLPort = parent.get("SSLPort");
		if(SSLPort != 'null'){
			SSLPort = ":" + SSLPort;
		}
		else{
			SSLPort = '';
		}
		var templateLabel = '<%=UIUtil.toJavaScript(wizardRB.get("colors.label"))%>';
		var label = '';
		for (var i = 0; i < enabledOptions.length; i++)
		{
			option = optionGroups["ColorPanelOptions"].options[enabledOptions[i]];
			
			var row = i % COLUMNS;
			if (row == 0) {
				document.write('<tr>');
			}
	
			document.write('<td valign="top">');
			document.write('<input type="radio" value="' + option.id + '" name="optionRadio" id="color' + option.id + '" onClick="SaveToTopFrame(' + i + ');">');
			document.write('</td>');
			
			document.write('<td>');
			label = templateLabel.replace('{0}', i+1);
			document.write('<label for="color' + option.id + '"><img src="' + self.location.protocol + '//' + self.location.hostname + SSLPort + parent.get("StoresWebPath") + '/' + option.src.replace("$storeDir$", parent.get("jspStoreDir")) + '" border="0" onClick="SaveToTopFrame(' + i + ');" alt="' + label + '"></label>');
			document.write('<br><br></td>');
			
			if (row == (COLUMNS - 1)) {
				document.write('</tr>');
			}
		}
	}
	
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		var elements = document.colorForm.elements;

		for (var i = 0; i < elements.length; i++)
		{
			if (elements[i].type == 'radio' && elements[i].value == selections["ColorPanelOptions"]) {
				elements[i].checked = true;
			}
		}

		parent.setContentFrameLoaded(true);
	}	


	/* When a new color is selected, we have to save this selection and 
	 * reset the store banner selection.
	 */
	function SaveToTopFrame(colorNumber)
	{
		document.colorForm.optionRadio[colorNumber].checked = true;
		
		// Save color information
		selections["ColorPanelOptions"] = document.colorForm.optionRadio[colorNumber].value;

		// Save banner selection information
		var color = optionGroups.ColorPanelOptions.options[selections["ColorPanelOptions"]];
		selections["BannerPanelOptions"] = color.enablesOptions[0];
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
<H1><%=wizardRB.get("colors.title")%></H1>
<%=wizardRB.get("colors.blurb")%>
<br>
<br>

<form name="colorForm" action="post">
	<table>
		<script>
			showColors();
		</script>
	</table>
</form>
</body>
</html>
<%
}catch(Exception e)
{
	out.println(e);
}
%>
