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

<%@ page import="com.ibm.commerce.tools.shipping.ShippingConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="ShippingCommon.jsp" %>

<%
		
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_GENERAL_PANEL_TITLE) %></title>

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
			var o1 = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
			var o2 = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_DESCR_BEAN %>", null);
			if (o1 != null) {
				loadValue(<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>, o1.<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>);
				loadValue(<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>, o2.<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>);
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_NAME_REQUIRED %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCCODE_NAME_REQUIRED %>");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_NAME_REQUIRED)) %>");
				<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
				return;
			}

			if (parent.get("calcCodeNameTooLong", false)) {
				parent.remove("calcCodeNameTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeNameTooLong")) %>");
				<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.select();
				<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
				return;
			}

			if (parent.get("calcCodeDescriptionTooLong", false)) {
				parent.remove("calcCodeDescriptionTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeDescriptionTooLong")) %>");
				<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.select();
				<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.focus();
				return;
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_EXISTS %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCCODE_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_EXISTS)) %>");
				<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.select();
				<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
				return;
			}

			if (parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_CHANGED %>", false)) {
				parent.remove("<%= ShippingConstants.ELEMENT_CALCCODE_CHANGED %>");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_CHANGED)) %>")) {
					parent.put("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>", true);
					parent.finish();
					parent.remove("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>");
				}
			}
		}
		<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
	}
}

function validatePanelData () {
	with (document.generalForm) {
		if (!<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_NAME_REQUIRED)) %>");
			<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCCODE_CODE %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeNameTooLong")) %>");
			<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.select();
			<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.value, <%= ShippingConstants.DB_COLUMN_LENGTH_CALCCODE_DESCRIPTION %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("calcCodeDescriptionTooLong")) %>");
			<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.select();
			<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.focus();
			return false;
		}
	}
	return true;
}

function savePanelData () {
	with (document.generalForm) {
		if (parent.get) {
			var o1 = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
			if (o1 != null) {
				o1.<%= ShippingConstants.ELEMENT_CALCCODE_NAME %> = <%= ShippingConstants.ELEMENT_CALCCODE_NAME %>.value;
			}
			var o2 = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_DESCR_BEAN %>", null);
			if (o2 != null) {
				o2.<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %> = <%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>.value;
			}
		}
	}
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_GENERAL_PANEL_PROMPT) %></h1>

<form name="generalForm">

<p><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_NAME_PROMPT) %><br>
<LABEL><input name="<%= ShippingConstants.ELEMENT_CALCCODE_NAME %>" type="TEXT" size="30" maxlength="64"></LABEL>

</p><p><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_DESCRIPTION_PROMPT) %><br>
<LABEL for="<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>"><textarea name="<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>" id="<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>,254);" onkeyup="limitTextArea(this.form.<%= ShippingConstants.ELEMENT_CALCCODE_DESCRIPTION %>,254);"></LABEL>
</textarea>



</p></form>

</body>

</html>