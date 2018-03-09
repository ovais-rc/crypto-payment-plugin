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
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.segmentation.SegmentDataBean,
	com.ibm.commerce.tools.segmentation.SegmentListDataBean,
	com.ibm.commerce.user.objects.MemberGroupAccessBean,
	java.text.DateFormat,
	java.util.Date" %>

<%@ include file="SegmentCommon.jsp" %>
<%@ include file="../bi/BINLS.jsp" %>

<%
	Locale locale = segmentCommandContext.getLocale();
	SegmentListDataBean segmentList = new SegmentListDataBean();
	DataBeanManager.activate(segmentList, request);
	SegmentDataBean [] segments = segmentList.getSegmentList();
	int numberOfSegments = 0;
	if (segments != null) {
		numberOfSegments = segments.length;
	}
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, locale);
	String storeType = segmentCommandContext.getStore().getStoreType();
	String segmentNotebookURL = SegmentConstants.URL_SEGMENT_NOTEBOOK_VIEW;
	String segmentNotebookChangeXML = "segmentation.SegmentNotebookChange";
	if ("B2B".equals(storeType) || "BMH".equals(storeType) || "BRH".equals(storeType)) {
		segmentNotebookURL = SegmentConstants.URL_SEGMENT_NOTEBOOK_B2B_VIEW;
		segmentNotebookChangeXML="segmentation.SegmentNotebookB2BChange";
	}
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function newSegment () {
	var url = "<%= segmentNotebookURL + "&" + SegmentConstants.PARAMETER_NEW_SEGMENT + "=true" %>";
	top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_NEW_SEGMENT)) %>", url, true);
}

function changeSegment () {
	var segmentValue = "";
	if (arguments.length > 0) {
		segmentValue = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			segmentValue = checked[0];
		}
	}

	if (segmentValue != "") {
		if (getListEditableFlag(segmentValue) == "Y") {
			var segmentId = getListSegmentId(segmentValue);
			var url = "<%= UIUtil.getWebappPath(request) %>SegmentNotebookView?XMLFile=<%= segmentNotebookChangeXML %>&<%= SegmentConstants.PARAMETER_SEGMENT_ID %>=" + segmentId;
			top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CHANGE_SEGMENT)) %>", url, true);
		}

		else if (getListEditableFlag(segmentValue) == "C") {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntryHasBeenMigratedToCMC")) %>");
		}

		else {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntryCannotBeModified")) %>");
		}
	}
}

function segmentDetails () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var segmentId = getListSegmentId(checked[0]);
		var url = "<%= SegmentConstants.URL_SEGMENT_DETAILS_DIALOG_VIEW %>" + segmentId;
		top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_DETAILS_DIALOG_TITLE)) %>", url, true);
	}
}

function copySegment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {

		if (getListEditableFlag(checked[0]) == "C") {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntryHasBeenMigratedToCMC")) %>");
		}
		else {
			var segmentId = getListSegmentId(checked[0]);
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=segmentation.SegmentDuplicateDialog&amp;" + "<%= SegmentConstants.PARAMETER_SEGMENT_ID + "=" %>" + segmentId;
			top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_COPY_SEGMENT)) %>", url, true);
		}
	}
}

function listCustomers () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var segmentId = getListSegmentId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=segmentation.CustomerListDialog&amp;segmentId=" + segmentId;
		top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMERS)) %>", url, true);
	}
}

function deleteSegment () {
	var checked = parent.getChecked();
	var isDeleting = false;
	var countMigratedSegmentSelected = 0;
	if (checked.length > 0) {
		var segmentId, editableFlag;
		var url = "<%= SegmentConstants.URL_SEGMENT_DELETE %>";
		for (var i=0; i<checked.length; i++) {
			segmentId = getListSegmentId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);

			if (editableFlag  == "C") {
				++countMigratedSegmentSelected;
			}

			if (editableFlag == "Y") {
				url += segmentId + ",";
				isDeleting = true;
			}
		}

		if (countMigratedSegmentSelected > 0) {
			if (checked.length == 1) {	
				alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntryHasBeenMigratedToCMC")) %>");
			} 
			else {
				alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntriesContainSegmentsMigratedToCMC")) %>");
			}
		}
		else if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_DELETE_CONFIRMATION)) %>")) {
				top.setContent("", url.substring(0, url.length-1), true);
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function biReport () {
	var url = "<%= UIUtil.getWebappPath(request) %>ShowContextList?ActionXMLFile=bi.biRptCustomerSegmentActivityContextList&context=CustomerSegmentActivity&contextConfigXML=bi.biContext";
	top.setContent("<%= UIUtil.toJavaScript((String)biNLS.get("contextList")) %>", url, true);
}

function getResultsSize () {
	return <%= numberOfSegments %>;
}

function getListSegmentId (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListEditableFlag (checkValue) {
	return checkValue.substring(checkValue.indexOf("|") + 1, checkValue.length);
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onLoad="onLoad()" class="content_list">

<%
	String orderByParm = request.getParameter("orderby");
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfSegments;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("segmentation.SegmentList", totalpage, totalsize, locale) %>
<form name="segmentForm">
<%= comm.startDlistTable(UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_SUMMARY))) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_NAME_COLUMN), SegmentConstants.ORDER_BY_NAME, SegmentConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_DESCRIPTION_COLUMN), SegmentConstants.ORDER_BY_DESCRIPTION, SegmentConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_LAST_UPDATE_COLUMN), SegmentConstants.ORDER_BY_LAST_UPDATE, SegmentConstants.ORDER_BY_LAST_UPDATE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_MODIFIED_BY_COLUMN), SegmentConstants.ORDER_BY_LAST_UPDATED_BY, SegmentConstants.ORDER_BY_LAST_UPDATED_BY.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfSegments) {
		endIndex = numberOfSegments;
	}

	SegmentDataBean segment;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		segment = segments[i];

		// Check the segment's CMC migration status. If the segment
		// has been migrated to CMC, the OID value should return a
		// string value of 'CMC'.
		MemberGroupAccessBean mbrgrp = segment.getMemberGroupAccessBean();
		String cmcFlag = (mbrgrp != null) ? mbrgrp.getOID() : "";
		boolean migratedToCMC = "CMC".equals(cmcFlag);
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (segment.getStoreId().equals(segmentCommandContext.getStoreId()) && !migratedToCMC) { %>
<%= comm.addDlistCheck(segment.getId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getSegmentName()), "javascript:changeSegment('" + segment.getId() + "|Y')") %>
<%		} else if (migratedToCMC) { %>
<%= comm.addDlistCheck(segment.getId().toString() + "|C", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getSegmentName()), "none") %>
<%		} else { %>
<%= comm.addDlistCheck(segment.getId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getSegmentName()), "none") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getDescription()), "none") %>
<%= comm.addDlistColumn(dateFormat.format(new Date(segment.getLastUpdateDate().longValue())), "none") %>
<%= comm.addDlistColumn(segment.getLastUpdatedBy(), "none") %>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>

<%	if (numberOfSegments == 0) { %>
<p><p>
<%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_LIST_NO_SEGMENTS) %>
<%	} %>

</form>

<script>
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>