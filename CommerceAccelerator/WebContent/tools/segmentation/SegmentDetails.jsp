<!--
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
-->

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentDetailsDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentDetailsDataBean segmentDetails = new SegmentDetailsDataBean();
	DataBeanManager.activate(segmentDetails, request);
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_DIALOG_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function segmentList () {
	top.goBack();
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body onLoad="loadPanelData()" class="content">

<h1><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_DIALOG_TITLE) %></h1>

<p><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_NAME) %>&nbsp;
<%= UIUtil.toHTML(segmentDetails.getSegmentName()) %>

<p><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_DESCRIPTION) %>&nbsp;
<%	if (segmentDetails.getDescription() != null) { %>
<%= UIUtil.toHTML(segmentDetails.getDescription()) %>
<%	} %>

<%	if (segmentDetails.getNoConstraints()) { %>
<p><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_NO_CONSTRAINTS) %>
<%	} else { %>
<p><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_CONSTRAINTS) %>
<ul>
<%= segmentDetails.getConstraintList() %>
</ul>
<%	} %>

<%
	Vector referringInitiatives = segmentDetails.getReferringInitiatives();
	if (referringInitiatives.size() > 0) {
%>
<p><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_INITIATIVES) %><br>
<ul>
<%		for (int i=0; i<referringInitiatives.size(); i++) { %>
<li><%= referringInitiatives.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

</body>

</html>