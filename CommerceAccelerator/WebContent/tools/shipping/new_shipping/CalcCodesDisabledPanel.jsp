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
<%@ page import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.shipping.*,
	com.ibm.commerce.tools.campaigns.*,
	com.ibm.commerce.tools.util.ResourceDirectory,
	java.util.Hashtable,
	java.util.Vector" %>

<%@ include file="ShippingCommon.jsp" %>

<%
	Vector calcCodesDisabled = new Vector();
	Vector calcCodesNotDisabled = new Vector();
	boolean calcCodeIdInvalid = false;

	String calcCodesDisabledParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_DISABLED);
	if (calcCodesDisabledParameter != null) {
		StringTokenizer st = new StringTokenizer(calcCodesDisabledParameter, ",");
		while (st.hasMoreTokens()) {
			calcCodesDisabled.addElement(st.nextToken());
		}
	}

	String calcCodesNotDisabledParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_NOT_DISABLED);
	if (calcCodesNotDisabledParameter != null) {
		StringTokenizer st = new StringTokenizer(calcCodesNotDisabledParameter, ",");
		while (st.hasMoreTokens()) {
			calcCodesNotDisabled.addElement(st.nextToken());
		}
	}

	String calcCodeIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID_INVALID);
	if (calcCodeIdInvalidParameter != null) {
		calcCodeIdInvalid = CampaignUtil.toBoolean(calcCodeIdInvalidParameter);
	}
%>

<HTML>

<HEAD>
<%= fHeader %>
<TITLE><%= shippingRB.get(ShippingConstants.MSG_CALCCODES_DISABLED_DIALOG_TITLE) %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function calcCodeList () {
	parent.location.replace("<%= ShippingConstants.URL_CAMPAIGN_CALCCODES_VIEW %>");
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="loadPanelData()" class="content">

<BR>

<%
	boolean noCalcCodesDisabled = true;
	if (calcCodesDisabled != null && calcCodesDisabled.size() > 0) {
		noCalcCodesDisabled = false;
%>
<P><%= shippingRB.get(ShippingConstants.MSG_CALCCODES_DISABLED) %>
<UL>
<%		for (int i=0; i<calcCodesDisabled.size(); i++) { %>
<LI><%= calcCodesDisabled.elementAt(i) %></LI>
<%		} %>
</UL>
<%	} %>

<%
	if (calcCodesNotDisabled != null && calcCodesNotDisabled.size() > 0) {
		noCalcCodesDisabled = false;
%>
<P><%= shippingRB.get(ShippingConstants.MSG_CALCCODES_NOT_DISABLED) %>
<UL>
<%		for (int i=0; i<calcCodesNotDisabled.size(); i++) { %>
<LI><%= calcCodesNotDisabled.elementAt(i) %></LI>
<%		} %>
</UL>
<%	} %>

<%
	if (calcCodeIdInvalid) {
		noCalcCodesDisabled = false;
%>
<P><%= shippingRB.get(ShippingConstants.MSG_DISABLE_CALCCODE_ID_INVALID) %>
<%	} %>

<%	if (noCalcCodesDisabled) { %>
<P><%= shippingRB.get(ShippingConstants.MSG_NO_CALCCODES_DISABLED) %>
<%	} %>

</BODY>

</HTML>