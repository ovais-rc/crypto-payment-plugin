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

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentDetailsDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentDetailsDataBean segmentDetails = new SegmentDetailsDataBean();
	DataBeanManager.activate(segmentDetails, request);

	String segmentName = segmentDetails.getSegmentName();
	String segmentDesc = segmentDetails.getDescription();
	if (segmentDesc == null) {
		segmentDesc = "";
	}
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_GENERAL_PANEL_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/segmentation/SegmentNotebook.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function loadPanelData () {
	document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value = "<%= segmentName %>";
	document.generalForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.value = "<%= segmentDesc %>";
	document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
	parent.setContentFrameLoaded(true);
}

function savePanelData () {
	parent.put("<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>" , document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value);
	parent.put("<%= SegmentConstants.ELEMENT_DESCRIPTION %>", document.generalForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.value);
}

function validatePanelData () {
	if (!(document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value)) {
		alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_NAME_REQUIRED)) %>");
		document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
		return false;
	}

	if (!parent.isValidUTF8length(document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value, 254)) {
		alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
		document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.select();
		document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.focus();
		return false;
	}

	if (!parent.isValidUTF8length(document.generalForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.value, 512)) {
		alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
		document.generalForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.select();
		document.generalForm.<%= SegmentConstants.ELEMENT_DESCRIPTION %>.focus();
		return false;
	}

	if (document.generalForm.<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>.value == "<%= UIUtil.toJavaScript(segmentName) %>") {
		alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentNewNameRequired")) %>");
		document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.select();
		document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.focus();
		return false;
	}

	return true;
}
//-->
</script>
</head>

<body onLoad="loadPanelData()" class="content">

<h1><%= segmentsRB.get("SegmentDuplicateTitle") %></h1>

<form name="generalForm" action="javascript:">

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<p><%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_NAME_PROMPT)) %><br>');
document.writeln('<input name="<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>" id="<%= SegmentConstants.ELEMENT_SEGMENT_NAME %>" type="text" maxlength="254">');
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_DESCRIPTION %>"><%= segmentsRB.get(SegmentConstants.MSG_DESCRIPTION_PROMPT) %></label><br>
<textarea name="<%= SegmentConstants.ELEMENT_DESCRIPTION %>" id="<%= SegmentConstants.ELEMENT_DESCRIPTION %>" rows="6" cols="50" wrap>
</textarea>

</form>

</body>

</html>