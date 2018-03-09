<!-- ========================================================================
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
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="ShippingCommon.jsp" %>

<jsp:useBean
	id="calcRule_ffcListBean" scope="request"
	class="com.ibm.commerce.fulfillment.beans.FulfillmentCenterByLanguageAndStoreListDataBean">
</jsp:useBean>

<jsp:useBean
	id="calcRule_ffcBean" scope="request"
	class="com.ibm.commerce.fulfillment.beans.FulfillmentCenterByLanguageAndStoreDataBean">
</jsp:useBean>

<jsp:useBean
	id="calcRule_shipModeListBean" scope="request"
	class="com.ibm.commerce.tools.shipping.ShippingModeListDataBean"> </jsp:useBean>

<jsp:useBean
	id="calcRule_shipModeBean" scope="request"
	class="com.ibm.commerce.fulfillment.beans.ShippingModeDataBean"> </jsp:useBean>

<jsp:useBean
	id="calcRule_zoneListBean" scope="request"
	class="com.ibm.commerce.tools.shipping.JurisdictionGroupListDataBean">
</jsp:useBean>

<jsp:useBean
	id="calcRule_zoneBean" scope="request"
	class="com.ibm.commerce.fulfillment.beans.JurisdictionGroupDataBean"> </jsp:useBean>

<%
		
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {
	background: #c0c0c0;
}

.enabledBox {
	background: #ffffff;
}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_ZONE_PANEL_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript"
	src="/wcs/javascript/tools/shipping/CalcRuleZone.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData () {
	with (document.generalForm) {
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE %>", null);
			if (o != null) {
				loadValue(<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>, o.<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>);
				loadValue(<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>, o.<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>);
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_NAME_REQUIRED %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCRULE_NAME_REQUIRED %>");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_NAME_REQUIRED)) %>");
				<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
				return;
			}

			if (parent.get("calcCodeNameTooLong", false)) {
				parent.remove("calcCodeNameTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeNameTooLong")) %>");
				<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.select();
				<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
				return;
			}

			if (parent.get("calcCodeDescriptionTooLong", false)) {
				parent.remove("calcCodeDescriptionTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeDescriptionTooLong")) %>");
				<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.select();
				<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.focus();
				return;
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_EXISTS %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCRULE_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_EXISTS)) %>");
				<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.select();
				<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
				return;
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_CHANGED %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCRULE_CHANGED %>");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_CHANGED)) %>")) {
					parent.put("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>", true);
					parent.finish();
					parent.remove("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>");
				}
			}
		}
		<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
	}
}

function validatePanelData () {
	with (document.generalForm) {
		if (!<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_NAME_REQUIRED)) %>");
			<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCRULE_NAME %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeNameTooLong")) %>");
			<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.select();
			<%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCRULE_DESCRIPTION %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeDescriptionTooLong")) %>");
			<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.select();
			<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.focus();
			return false;
		}
	}
	return true;
}

function savePanelData () {
	with (document.generalForm) {
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE %>", null);
			if (o != null) {
				o.<%= ShippingConstants.ELEMENT_CALCRULE_NAME %> = <%= ShippingConstants.ELEMENT_CALCRULE_NAME %>.value;
				o.<%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %> = <%= ShippingConstants.ELEMENT_CALCRULE_DESCRIPTION %>.value;
			}
		}
	}
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_ZONE_PANEL_PROMPT) %></h1>

<form name="zoneForm">

</form>

</body>

</html>
