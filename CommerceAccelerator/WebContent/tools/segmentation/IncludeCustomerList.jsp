<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2006
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.segmentation.SegmentCustomerListDataBean,
	com.ibm.commerce.tools.xml.XMLUtil" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	Locale locale = segmentCommandContext.getLocale();
	Hashtable formats = (Hashtable) ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable) XMLUtil.get(formats, "nlsFormats."+ locale.toString());
	if (format == null) {
		format = (Hashtable) XMLUtil.get(formats, "nlsFormats.default");
	}
	String nameOrder = (String) XMLUtil.get(format, "name.order");
	String segmentId = request.getParameter(SegmentConstants.PARAMETER_SEGMENT_ID);
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get("includeCustomerPanelTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var initialLoad = top.getData("initialLoadOnIncludeList");
if (initialLoad == null) {
	top.saveData("false", "initialLoadOnIncludeList");
}

var IncludeCustomerList = top.getData("IncludeCustomerList");
if (IncludeCustomerList == null && initialLoad == null) {
<%
	if (segmentId != null && !segmentId.equals("")) {
		SegmentCustomerListDataBean customerList = new SegmentCustomerListDataBean();
		DataBeanManager.activate(customerList, request);
		SegmentCustomerListDataBean.Customer[] customers = customerList.getCustomerList();
		if (customers != null && customers.length > 0) {
%>
	IncludeCustomerList = new Array();
<%			for (int i=0; i<customers.length; i++) { %>
	IncludeCustomerList[<%= i %>] = new Object();
	IncludeCustomerList[<%= i %>].memberId = "<%= customers[i].getId() %>";
	IncludeCustomerList[<%= i %>].logonID = "<%= customers[i].getLogonId() %>";
	IncludeCustomerList[<%= i %>].firstName = "<%= UIUtil.toJavaScript(customers[i].getFirstName()) %>";
	IncludeCustomerList[<%= i %>].lastName = "<%= UIUtil.toJavaScript(customers[i].getLastName()) %>";
<%
			}
		}
	}
%>
}
top.saveData(IncludeCustomerList, "IncludeCustomerList");
parent.parent.parent.put("IncludeCustomerList", IncludeCustomerList);

function addCustomers () {
	var url = "<%= SegmentConstants.URL_SEGMENT_CUSTOMER_SEARCH_DIALOG_VIEW + UIUtil.toJavaScript(segmentId)%>";
	parent.parent.saveFormData();
	top.saveModel(parent.parent.parent.model);
	top.setReturningPanel("segmentNotebookGeneralPanel");
	top.saveData("inclusionList", "fromPanel");
	top.saveData(IncludeCustomerList, "IncludeCustomerList");
	top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH)) %>", url, true);
}

function removeCustomers () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var listVector = new Vector();
		if (IncludeCustomerList != null) {
			for (var i=0; i<IncludeCustomerList.length; i++) {
				listVector.addElement(IncludeCustomerList[i]);
			}
		}
		for (var i=0; i<checked.length; i++) {
            //This code is added for defect 177567
			var correctIndex = 	checked[i] - i ;
			listVector.removeElementAt(correctIndex);
		}
		if (listVector.size() == 0) {
			top.saveData(null, "IncludeCustomerList");
		}
		else {
			top.saveData(listVector.container, "IncludeCustomerList");
		}
	}
	parent.location.href = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=segmentation.ExplicitlyIncludedCustomerList&cmd=SegmentNotebookCustomersInclusionPanelView&segmentId=<%=UIUtil.toJavaScript( segmentId )%>";
}

function removeAllCustomers () {
	top.saveData(null, "IncludeCustomerList");
	parent.location.href = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=segmentation.ExplicitlyIncludedCustomerList&cmd=SegmentNotebookCustomersInclusionPanelView&segmentId=<%=UIUtil.toJavaScript( segmentId )%>";
}

function onLoad () {
	parent.loadFrames();
}

function importCustomers () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=segmentation.CustomerIncludeImportDialog";
	parent.parent.saveFormData();
	top.saveModel(parent.parent.parent.model);
	top.setReturningPanel("segmentNotebookGeneralPanel");
	top.saveData("segmentNotebookCustomersInclusionPanel", "ReturningPanel");
	top.setContent("<%= segmentsRB.get("CustomerImportButton") %>", url, true);
}

function saveWCAData () {
	var BIImportModel = top.getData("WCAClosedLoopImportModel");
	var BIImportSegment = top.getData("WCAClosedLoopImportSegment");
	var BIImportScore = top.getData("WCAClosedLoopImportScore");
	var o = parent.parent.parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
	if (o != null) {
		if (BIImportModel != null) {
			o.<%= SegmentConstants.ELEMENT_WCA_MODEL %> = BIImportModel;
			top.saveData(null, "WCAClosedLoopImportModel");
		}

		if (BIImportSegment != null) {
			o.<%= SegmentConstants.ELEMENT_WCA_SEGMENT %> = BIImportSegment;
			top.saveData(null, "WCAClosedLoopImportSegment");
		}

		if (BIImportScore != null) {
			o.<%= SegmentConstants.ELEMENT_WCA_SCORE %> = BIImportScore;
			top.saveData(null, "WCAClosedLoopImportScore");
		}
	}
}
//-->
</script>
</head>

<body class="content_list" style="margin-left: 0px">

<script language="JavaScript">
<!-- hide script from old browsers
//For IE
if (document.all) {
	onLoad();
}
//-->
</script>

<form name="segmentForm">

<script language="JavaScript">
<!-- hide script from old browsers
startDlistTable('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_SUMMARY)) %>');
startDlistRowHeading();
addDlistCheckHeading();
addDlistColumnHeading('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LOGON_ID_COLUMN)) %>', false, "30%");

if ("<%= nameOrder %>".indexOf("first") < "<%= nameOrder %>".indexOf("last")) {
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN)) %>', false, "35%");
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN)) %>', false, "35%");
}
else {
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN)) %>', false, "35%");
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN)) %>', false, "35%");
}
endDlistRow();

if (IncludeCustomerList != null) {
	var rowColor = 1;
	for (var i=0; i<IncludeCustomerList.length; i++) {
		startDlistRow(rowColor);
		addDlistCheck(i);
		addDlistColumn(IncludeCustomerList[i].logonID, "none");
		if ("<%= nameOrder %>".indexOf("first") < "<%= nameOrder %>".indexOf("last")) {
			addDlistColumn(IncludeCustomerList[i].firstName, "none");
			addDlistColumn(IncludeCustomerList[i].lastName, "none");
		}
		else {
			addDlistColumn(IncludeCustomerList[i].lastName, "none");
			addDlistColumn(IncludeCustomerList[i].firstName, "none");
		}
		endDlistRow();

		if (rowColor == 1) {
			rowColor = 2;
		}
		else {
			rowColor = 1;
		}
	}
}

endDlistTable();
saveWCAData();
//-->
</script>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
if (IncludeCustomerList == null) {
	document.write('<p><%= UIUtil.toJavaScript((String)segmentsRB.get("addCustomerListNoCustomers")) %></p>');
}
parent.afterLoads();
//-->
</script>

</body>

</html>
