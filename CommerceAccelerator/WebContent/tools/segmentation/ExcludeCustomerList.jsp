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
var initialLoad = top.getData("initialLoadOnExcludeList");
if (initialLoad == null) {
	top.saveData("false", "initialLoadOnExcludeList");
}

var ExcludeCustomerList = top.getData("ExcludeCustomerList");
if (ExcludeCustomerList == null && initialLoad == null) {
<%
	if (segmentId != null && !segmentId.equals("")) {
		SegmentCustomerListDataBean customerList = new SegmentCustomerListDataBean();
		DataBeanManager.activate(customerList, request);
		SegmentCustomerListDataBean.Customer[] customers = customerList.getCustomerList();
		if (customers != null && customers.length > 0) {
%>
	ExcludeCustomerList = new Array();
<%			for (int i=0; i<customers.length; i++) { %>
	ExcludeCustomerList[<%= i %>] = new Object();
	ExcludeCustomerList[<%= i %>].memberId = "<%= customers[i].getId() %>";
	ExcludeCustomerList[<%= i %>].logonID = "<%= customers[i].getLogonId() %>";
	ExcludeCustomerList[<%= i %>].firstName = "<%= UIUtil.toJavaScript(customers[i].getFirstName()) %>";
	ExcludeCustomerList[<%= i %>].lastName = "<%= UIUtil.toJavaScript(customers[i].getLastName()) %>";
<%
			}
		}
	}
%>
}
top.saveData(ExcludeCustomerList, "ExcludeCustomerList");
parent.parent.parent.put("ExcludeCustomerList", ExcludeCustomerList);

function addCustomers () {
	var url = "<%= SegmentConstants.URL_SEGMENT_CUSTOMER_SEARCH_DIALOG_VIEW + UIUtil.toJavaScript(segmentId)%>";
	parent.parent.saveFormData();
	top.saveModel(parent.parent.parent.model);
	top.setReturningPanel("segmentNotebookGeneralPanel");
	top.saveData("exclusionList", "fromPanel");
	top.saveData(ExcludeCustomerList, "ExcludeCustomerList");
	top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH)) %>", url, true);
}

function removeCustomers () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var listVector = new Vector();
		if (ExcludeCustomerList != null) {
			for (var i=0; i<ExcludeCustomerList.length; i++) {
				listVector.addElement(ExcludeCustomerList[i]);
			}
		}
		for (var i=0; i<checked.length; i++) {
            //This code is added for defect 177567
			var correctIndex = 	checked[i] - i ;
			listVector.removeElementAt(correctIndex);

		}
		if (listVector.size() == 0) {
			top.saveData(null, "ExcludeCustomerList");
		}
		else {
			top.saveData(listVector.container, "ExcludeCustomerList");
		}
	}
	parent.location.href = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=segmentation.ExplicitlyExcludedCustomerList&cmd=SegmentNotebookCustomersExclusionPanelView&segmentId=<%=UIUtil.toJavaScript( segmentId )%>";
}

function removeAllCustomers () {
	top.saveData(null, "ExcludeCustomerList");
	parent.location.href = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=segmentation.ExplicitlyExcludedCustomerList&cmd=SegmentNotebookCustomersExclusionPanelView&segmentId=<%=UIUtil.toJavaScript( segmentId )%>";
}

function onLoad () {
	parent.loadFrames();
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

if (ExcludeCustomerList != null) {
	var rowColor = 1;
	for (var i=0; i<ExcludeCustomerList.length; i++) {
		startDlistRow(rowColor);
		addDlistCheck(i);
		addDlistColumn(ExcludeCustomerList[i].logonID, "none");
		if ("<%= nameOrder %>".indexOf("first") < "<%= nameOrder %>".indexOf("last")) {
			addDlistColumn(ExcludeCustomerList[i].firstName, "none");
			addDlistColumn(ExcludeCustomerList[i].lastName, "none");
		}
		else {
			addDlistColumn(ExcludeCustomerList[i].lastName, "none");
			addDlistColumn(ExcludeCustomerList[i].firstName, "none");
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
//-->
</script>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
if (ExcludeCustomerList == null) {
	document.write('<p><%= UIUtil.toJavaScript((String)segmentsRB.get("addCustomerListNoCustomers")) %></p>');
}
parent.afterLoads();
//-->
</script>

</body>

</html>
