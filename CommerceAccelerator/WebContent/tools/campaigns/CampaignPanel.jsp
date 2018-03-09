<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_PANEL_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Campaign.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var campaignPanelReady = false;
var initiativeMappingPanelReady = false;

function setReadyFlag (panelIndicator) {
	if (panelIndicator == "campaignPanel") {
		campaignPanelReady = true;
	}
	if (panelIndicator == "initiativeMappingPanel") {
		initiativeMappingPanelReady = true;
	}
	if (campaignPanelReady && initiativeMappingPanelReady) {
		// finish loading base frame
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	}
}

function loadPanelData () {
	with (document.campaignForm) {
		if (parent.get) {
			var o = parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN %>", null);
			if (o != null) {
				loadValue(<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>, o.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>);
				loadValue(<%= CampaignConstants.ELEMENT_DESCRIPTION %>, o.<%= CampaignConstants.ELEMENT_DESCRIPTION %>);
				loadValue(<%= CampaignConstants.ELEMENT_OWNER %>, o.<%= CampaignConstants.ELEMENT_OWNER %>);
				loadValue(<%= CampaignConstants.ELEMENT_OBJECTIVE %>, o.<%= CampaignConstants.ELEMENT_OBJECTIVE %>);
			}

			if (parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN_EXISTS %>", false)) {
				parent.remove("<%= CampaignConstants.ELEMENT_CAMPAIGN_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_EXISTS)) %>");
				<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.select();
				<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.focus();
				return;
			}

			if (parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN_CHANGED %>", false)) {
				parent.remove("<%= CampaignConstants.ELEMENT_CAMPAIGN_CHANGED %>");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_CHANGED)) %>")) {
					parent.put("<%= CampaignConstants.ELEMENT_FORCE_SAVE %>", true);
					parent.finish();
					parent.remove("<%= CampaignConstants.ELEMENT_FORCE_SAVE %>");
				}
			}
		}
		if (<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.readOnly) {
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
		}
		else {
			<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.focus();
		}
	}

	setReadyFlag("campaignPanel");
}

function validatePanelData () {
	with (document.campaignForm) {
		if (!<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_NAME_REQUIRED)) %>");
			<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_CAMPAIGN_NAME %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_CAMPAIGN_NAME_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.select();
			<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_DESCRIPTION %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_CAMPAIGN_DESCRIPTION %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_CAMPAIGN_DESCRIPTION_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.select();
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_OWNER %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_CAMPAIGN_OWNER %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_CAMPAIGN_OWNER_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_OWNER %>.select();
			<%= CampaignConstants.ELEMENT_OWNER %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_OBJECTIVE %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_CAMPAIGN_OBJECTIVE %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_CAMPAIGN_OBJECTIVES_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_OBJECTIVE %>.select();
			<%= CampaignConstants.ELEMENT_OBJECTIVE %>.focus();
			return false;
		}
	}
	return true;
}

function savePanelData () {
	with (document.campaignForm) {
		if (parent.get) {
			var o = parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN %>", null);
			if (o != null) {
				o.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %> = <%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.value;
				o.<%= CampaignConstants.ELEMENT_DESCRIPTION %> = <%= CampaignConstants.ELEMENT_DESCRIPTION %>.value;
				o.<%= CampaignConstants.ELEMENT_OWNER %> = <%= CampaignConstants.ELEMENT_OWNER %>.value;
				o.<%= CampaignConstants.ELEMENT_OBJECTIVE %> = <%= CampaignConstants.ELEMENT_OBJECTIVE %>.value;
			}
		}
	}
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("campaignPanel");
	top.saveModel(parent.model);
}

function visibleList (s) {
	if (defined(getIFrameById("initiativeList").basefrm) == false || getIFrameById("initiativeList").basefrm.document.readyState != "complete") {
		return;
	}
	if (defined(getIFrameById("initiativeList").basefrm.visibleList)) {
		getIFrameById("initiativeList").basefrm.visibleList(s);
		return;
	}
	if (defined(getIFrameById("initiativeList").basefrm.document.forms[0])) {
		for (var i = 0; i < getIFrameById("initiativeList").basefrm.document.forms[0].elements.length; i++) {
			if (getIFrameById("initiativeList").basefrm.document.forms[0].elements[i].type.substring(0,6) == "select") {
				getIFrameById("initiativeList").basefrm.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<form name="campaignForm" onsubmit="return false;" id="campaignForm">

<h1><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_GENERAL_PANEL_PROMPT) %></h1>

<table border="0" cellpadding="0" cellspacing="0" id="WC_CampaignPanel_Table_1">
	<tr>
		<td id="WC_CampaignPanel_TableCell_1">
			<label for="<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>"><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_NAME_PROMPT) %></label><br/>
<script language="JavaScript">
<!-- hide script from old browsers
var newCampaign = true;
if (parent.get) {
	var o = parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN %>", null);
	if (o != null && o.<%= CampaignConstants.ELEMENT_ID %> != "") {
		newCampaign = false;
	}
}
if (newCampaign) {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>" type="text" size="50" maxlength="64" tabindex="1" id="<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>"/>');
}
else {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>" type="text" size="50" maxlength="64" tabindex="1" id="<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>" style="border-style:none" readonly="readonly" />');
}
//-->
</script>
		</td>
		<td width="20" id="WC_CampaignPanel_TableCell_2">&nbsp;</td>
		<td id="WC_CampaignPanel_TableCell_3">
			<label for="<%= CampaignConstants.ELEMENT_OWNER %>"><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_OWNER_PROMPT) %></label><br/>
			<input name="<%= CampaignConstants.ELEMENT_OWNER %>" type="text" size="50" maxlength="64" tabindex="3" id="<%= CampaignConstants.ELEMENT_OWNER %>"/>
		</td>
	</tr>
	<tr height="20"><td colspan="3" id="WC_CampaignPanel_TableCell_4">&nbsp;</td></tr>
	<tr>
		<td id="WC_CampaignPanel_TableCell_5">
			<label for="<%= CampaignConstants.ELEMENT_DESCRIPTION %>"><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_DESCRIPTION_PROMPT) %></label><br/>
			<textarea name="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" id="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" tabindex="2" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>,254);" onkeyup="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>,254);">
			</textarea>
		</td>
		<td width="5" id="WC_CampaignPanel_TableCell_6">&nbsp;</td>
		<td id="WC_CampaignPanel_TableCell_7">
			<label for="<%= CampaignConstants.ELEMENT_OBJECTIVE %>"><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_OBJECTIVES_PROMPT) %></label><br/>
			<textarea name="<%= CampaignConstants.ELEMENT_OBJECTIVE %>" id="<%= CampaignConstants.ELEMENT_OBJECTIVE %>" tabindex="4" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.<%=CampaignConstants.ELEMENT_OBJECTIVE%>,254);" onkeyup="limitTextArea(this.form.<%=CampaignConstants.ELEMENT_OBJECTIVE%>,254);">
			</textarea>
		</td>
	</tr>
</table>

<h1><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_PROMPT) %></h1>

<iframe id="initiativeList" title="<%= UIUtil.toHTML((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_PROMPT)) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.CampaignInitiativeMappingList&amp;cmd=CampaignInitiativeMappingPanelView&amp;orderby=name" width="100%" height="400">
</iframe>

</form>

</body>

</html>