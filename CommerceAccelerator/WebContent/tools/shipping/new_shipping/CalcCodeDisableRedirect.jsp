<!-- ========================================================================
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
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="com.ibm.commerce.tools.shipping.ShippingConstants,
	com.ibm.commerce.datatype.TypedProperty,
	java.util.Vector" %>

<%@ include file="ShippingCommon.jsp" %>

<%
	Vector calcCodesDisabled = null;
	Vector calcCodesNotDisabled = null;
	Boolean calcCodeIdInvalid = null;
	
	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		calcCodesDisabled = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCCODE_DISABLED, null);
		calcCodesNotDisabled = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCCODE_NOT_DISABLED, null);
		calcCodeIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_CALCCODE_ID_INVALID, Boolean.FALSE);
	}
%>

<HTML>

<HEAD>
<%= fHeader %>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
<%
	String url = null;
	if (calcCodesNotDisabled.size() == 0 && !calcCodeIdInvalid.booleanValue()) {
		url = ShippingConstants.URL_CALCCODE_LIST_VIEW;
	}
	else {
		url = ShippingConstants.URL_CALCCODES_DISABLED_DIALOG_VIEW;
		if (calcCodesDisabled.size() > 0) {
			url += "&" + ShippingConstants.PARAMETER_CALCCODE_DISABLED + "=" + calcCodesDisabled.elementAt(0);
			for (int i=1; i<calcCodesDisabled.size(); i++) {
				url += ",";
				url += calcCodesDisabled.elementAt(i);
			}
		}
		if (calcCodesNotDisabled.size() > 0) {
			url += "&" + ShippingConstants.PARAMETER_CALCCODE_NOT_DISABLED + "=" + calcCodesNotDisabled.elementAt(0);
			for (int i=1; i<calcCodesNotDisabled.size(); i++) {
				url += ",";
				url += calcCodesNotDisabled.elementAt(i);
			}
		}
		url += "&" + ShippingConstants.PARAMETER_CALCCODE_ID_INVALID + "=" + calcCodeIdInvalid;
	}
%>
window.location.replace("<%= url %>");
//-->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<body class="content">

</body>

</HTML>