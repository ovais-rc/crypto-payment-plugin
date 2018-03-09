<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.attachment.beans.AttachmentDataBean,
	com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.common.beans.StoreDataBean,
	com.ibm.commerce.marketing.beans.CollateralDataBean,
	com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<%
	String collateralId = request.getParameter("collateralId");
	String collateralStoreId = request.getParameter("collateralStoreId");
	String attachmentObjectPath = "";
	String attachmentMimeType = "";
	String attachmentMimePart = "";

	if (collateralId != null && !collateralId.equals("")) {
		CollateralDataBean collateralDataBean = new CollateralDataBean();
		collateralDataBean.setCollateralID(Integer.valueOf(collateralId));
		collateralDataBean.setCommandContext(campaignCommandContext);
		collateralDataBean.populate();

		// get the attachment object file path
		AttachmentDataBean adb = collateralDataBean.getAttachmentDataBean();
		if (adb != null) {
			attachmentObjectPath = adb.getPath();
			attachmentMimeType = adb.getMimeType();
			if (attachmentMimeType != null && !attachmentMimeType.equals("")) {
				attachmentMimePart = attachmentMimeType.substring(0, attachmentMimeType.indexOf("/"));
				attachmentObjectPath = adb.getObjectPath() + attachmentObjectPath;
			}
		}

		// get collateral store ID if it is not being passed through parameter
		if (collateralStoreId == null || collateralStoreId.equals("")) {
			collateralStoreId = collateralDataBean.getStoreId().toString();
		}
	}

	// get the store directory... this will prefix the image location attribute.
	StoreDataBean myStoreDataBean = new StoreDataBean();
	myStoreDataBean.setStoreId(collateralStoreId);
	DataBeanManager.activate(myStoreDataBean, request);
	String collateralPath = "https://" + request.getServerName() + myStoreDataBean.getFilePath();
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("collateralPreviewDialogTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function loadCollateral () {
	collateral = parent.get("<%= CampaignConstants.ELEMENT_COLLATERAL %>");

	displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewName")) %>", collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>);
	if (collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %> == "1") {
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewType")) %>", "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_COLLATERAL_TYPE + "1")) %>");
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewURLlink")) %>", collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewMarketingText")) %>", convertFromTextToHTML(collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>));

		var qualifiedCollateralLocation = "<%= attachmentObjectPath %>";
		var attachmentMimePart = "<%= attachmentMimePart %>";
		var attachmentMimeType = "<%= attachmentMimeType %>";
		if (qualifiedCollateralLocation != "") {
			if (attachmentMimePart == "image" || attachmentMimePart == "images") {
				displayImage("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewImage")) %>", qualifiedCollateralLocation, collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>, "");
			}
			else if (attachmentMimePart == "content" || attachmentMimeType == "application/x-shockwave-flash") {
				displayFlash("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewImage")) %>", qualifiedCollateralLocation, "");
			}
			else {
				displayAttachmentLink("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewAttachmentLink")) %>", qualifiedCollateralLocation);
			}
		}
	}
	else if (collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %> == "2") {
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewType")) %>", "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_COLLATERAL_TYPE + "2")) %>");
		var colURLLink = collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>;
		if (colURLLink != null && colURLLink != "") {
			displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewURLlink")) %>", colURLLink);
		}

		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewStaticText")) %>", convertFromTextToHTML(collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>));
	}
	else if (collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %> == "3") {
		var qualifiedCollateralLocation = "<%= collateralPath %>" + collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATION %>;
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewType")) %>", "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_COLLATERAL_TYPE + "1")) %>");
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewURLlink")) %>", collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewMarketingText")) %>", convertFromTextToHTML(collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>));
		displayImage("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewImage")) %>", qualifiedCollateralLocation, collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>, collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATION %>);
	}
	else if (collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %> == "4") {
		var qualifiedCollateralLocation = "<%= collateralPath %>" + collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATION %>;
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewType")) %>", "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_COLLATERAL_TYPE + "1")) %>");
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewURLlink")) %>", collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewMarketingText")) %>", convertFromTextToHTML(collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>));
		displayFlash("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewImage")) %>", qualifiedCollateralLocation, collateral.<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATION %>);
	}
}

function displayRow (columnName, columnValue) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><i>' + columnValue + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

function displayImage (columnName, columnValue, altText, locationText) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><img border="1" alt="' + altText + '" src="' + columnValue + '"></td>');
	document.writeln('		<td valign="bottom"><i>&nbsp;' + locationText + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

function displayFlash (columnName, columnValue, locationText) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><embed src="' + columnValue + '" type="application/x-shockwave-flash"></embed></td>');
	document.writeln('		<td valign="bottom"><i>&nbsp;' + locationText + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

function displayAttachmentLink (columnName, columnValue) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><a href="' + columnValue + '" target="_blank">' + columnValue + '</a></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body class="content" onload="loadPanelData();">

<h1><%= campaignsRB.get("collateralPreviewDialogTitle") %></h1>

<form name="collateralPreviewForm" id="collateralPreviewForm">

<script language="JavaScript">
<!-- hide script from old browsers
loadCollateral();
//-->
</script>

</form>

</body>

</html>