<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentDataBean,
	com.ibm.commerce.tools.segmentation.SegmentListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	Locale jLocale = segmentCommandContext.getLocale();
	SegmentListDataBean segmentList = new SegmentListDataBean();
	DataBeanManager.activate(segmentList, request);
	SegmentDataBean [] segments = segmentList.getSegmentList();
	int numberOfSegments = 0;
	if (segments != null) {
		numberOfSegments = segments.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= segmentsRB.get("segmentSelectionPanelTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performFinish () {
	// put the selected segments into an array in the model
	var segmentResult = new Array();

	// at least one segment must be selected before this add action can be completed
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)segmentsRB.get("pleaseSelectAtLeastOneSegment")) %>");
		return;
	}

	segmentResult = currentArray;
	top.sendBackData(segmentResult, "segmentResult");
	top.saveData(null, "currentArray");

	// go back to the finder's caller
	top.goBack();
}

// called when a checkbox is clicked
function performUpdate (isAll, checkObject) {
	var newIndex;
	var resultFound = false;

	if (isAll) {
		for (var i=0; i<resultContainer.length; i++) {
			for (var j=0; j<currentArray.length; j++) {
				// case 1: if deselect and current entry found, remove current entry
				// case 2: if select and current entry found, do nothing
				if (currentArray[j] != null) {
					if (resultContainer[i].segmentId == currentArray[j].segmentId) {
						resultFound = true;
						if (!checkObject.checked) {
							currentArray[j] = null;
							break;
						}
					}
				}
			}
			// case 3: if select and current entry not found, add current entry
			// case 4: if deselect and current entry not found, do nothing
			if (!resultFound) {
				if (checkObject.checked) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
				}
			}
			else {
				resultFound = false;
			}
		}
	}
	else {
		if (checkObject.checked) {
			for (var i=0; i<resultContainer.length; i++) {
				if (resultContainer[i].segmentId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].segmentId == checkObject.name) {
					currentArray[i] = null;
					break;
				}
			}
		}
	}

	var tempArray = new Array();
	for (var i=0; i<currentArray.length; i++) {
		if (currentArray[i] != null) {
			tempArray[tempArray.length] = currentArray[i];
		}
	}
	currentArray = tempArray;

	top.saveData(currentArray, "currentArray");
}

function performCancel () {
	top.goBack();
}

function getResultsSize () {
	return <%= numberOfSegments %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad();" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfSegments;
	int totalpage = totalsize/listSize;
%>

<script language="JavaScript">
<!-- hide script from old browsers
<%	for (int i=0; i<segments.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].segmentId = "<%= segments[i].getId() %>";
resultContainer[resultIndex].segmentStoreId = "<%= segments[i].getStoreId() %>";
resultContainer[resultIndex].segmentName = "<%= UIUtil.toJavaScript(segments[i].getSegmentName()) %>";
resultContainer[resultIndex].segmentDescription = "<%= UIUtil.toJavaScript(segments[i].getDescription()) %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("segmentation.SegmentSelectionList", totalpage, totalsize, jLocale) %>
<form name="segmentSelectionForm" id="segmentSelectionForm">
<%= comm.startDlistTable((String)segmentsRB.get("segmentSelectionListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get("segmentListNameColumn"), null, false) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get("segmentListDescriptionColumn"), null, false) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfSegments) {
		endIndex = numberOfSegments;
	}

	SegmentDataBean segment;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		segment = segments[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(segment.getId().toString(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(segment.getSegmentName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getSegmentName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(segment.getDescription()), "none") %>
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
<p/><p/>
<%= segmentsRB.get("segmentSelectionListEmpty") %>
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