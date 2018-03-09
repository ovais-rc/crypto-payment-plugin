

<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.tools.shipping.ShippingConstants" %> 
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="java.util.Hashtable" %>

<%@ include file="ShippingCommon.jsp" %>

<%
	String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
    boolean editable = (readOnly == null || readOnly.equals("")||readOnly.equalsIgnoreCase("false"));
	String disabledString = " disabled";
	if(editable){
		disabledString = "";
	}
	String calcCodeModeId = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID);
	boolean newCalcCode = (calcCodeModeId == null || calcCodeModeId.equals(""));
	String title;
	String panelPrompt;
	if(newCalcCode){
		title = (String)shippingRB.get(ShippingConstants.MSG_CALCCODE_WIZARD_TITLE);
		panelPrompt = (String)shippingRB.get(ShippingConstants.MSG_CALCCODE_GENERAL_PANEL_PROMPT);
	}
	else{
		title = (String)shippingRB.get(ShippingConstants.MSG_CALCCODE_NOTEBOOK_TITLE);
		panelPrompt = (String)shippingRB.get(ShippingConstants.MSG_CALCCODE_GENERAL_PANEL_PROMPT);
	}	
	
	Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", fLocale);
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= title %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/CalcCode.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData () {
	with (document.generalForm) {
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		if (parent.get) {
	
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
			if (o != null) {
				<% if (newCalcCode) { %>
					loadValue(codeInput, o.<%= ShippingConstants.ELEMENT_CODE %>);
				<% } %>
				loadValue(descriptionText, o.<%= ShippingConstants.ELEMENT_DESCRIPTION %>);
			}
			<% if (newCalcCode) { %>
			if (parent.get("codeRequired", false)) {
				parent.remove("codeRequired");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_CODE_REQUIRED)) %>");
				codeInput.focus();
				return;
			}
			
			if (parent.get("codeTooLong", false)) {
				parent.remove("codeTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CODE_TOO_LONG)) %>");
				codeInput.select();
				codeInput.focus();
				return;
			}

			if (parent.get("calcCodeDescriptionTooLong", false)) {
				parent.remove("calcCodeDescriptionTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DESCRIPTION_TOO_LONG)) %>");
				codeInput.select();
				codeInput.focus();
				return;
			}

			if (parent.get("<%= ShippingConstants.MSG_CALCCODE_EXISTS %>", false)) {
				parent.remove("<%= ShippingConstants.MSG_CALCCODE_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_EXISTS)) %>");
				codeInput.select();
				codeInput.focus();
				return;
			}
			<% } %>
			if (parent.get("<%= ShippingConstants.MSG_CALCCODE_CHANGED %>", false)) {
				parent.remove("<%= ShippingConstants.MSG_CALCCODE_CHANGED %>");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_CHANGED)) %>")) {
					parent.put("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>", true);
					parent.finish();
					parent.remove("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>");
				}
			}
		}
		<% if (newCalcCode) { %>
			codeInput.focus();
		<% } %>
	}
}

function validatePanelData () {
	with (document.generalForm) {
	<% if (newCalcCode) { %>
		if (!codeInput.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_CODE_REQUIRED)) %>");
			codeInput.focus();
			return false;
		}
		if (!isValidUTF8length(codeInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCCODE_CODE %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)userWizardNLS.get("inputFieldMax")) %>");
			codeInput.select();
			codeInput.focus();
			return false;
		}
	<% } %>
		if (!isValidUTF8length(descriptionText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCCODE_DESCRIPTION %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)userWizardNLS.get("inputFieldMax")) %>");
			descriptionText.select();
			descriptionText.focus();
			return false;
		}
	}
	return true;
}

function savePanelData () {
	with (document.generalForm) {
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
			if (o != null) {
				<% if (newCalcCode) { %>
				o.<%= ShippingConstants.ELEMENT_CODE %> = codeInput.value;
				<% } %>
				o.<%= ShippingConstants.ELEMENT_DESCRIPTION %> = descriptionText.value;
				o.catGrpIds = o.strCatGrpIds;
			}
		}
	}
	
	parent.addURLParameter("authToken", "${authToken}");	
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_GENERAL_PANEL_PROMPT) %></h1>

<LINE3><%= shippingRB.get("calcCodeDesc") %></LINE3>

<form name="generalForm">

<p><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_NAME_PROMPT) %><br>
<% 
	if (!newCalcCode) { 
%>
<SCRIPT language="JavaScript"> 
	var o = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
	document.writeln("<i>" + o.<%= ShippingConstants.ELEMENT_CODE %> + "</i></TD></TR>");
</SCRIPT>
<%
	}
	else{
%>	
	<LABEL><input name="codeInput" type="TEXT" size="30" maxlength="128"></LABEL>
<%
	}
%>	

</p><p><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_DESCRIPTION_PROMPT) %><br>
<LABEL for="descriptionText"><textarea name="descriptionText" id="descriptionText" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(document.generalForm.descriptionText,254);" onkeyup="limitTextArea(document.generalForm.descriptionText,254);" <%=disabledString%>></textarea></LABEL>
</p></form>

</body>

</html>