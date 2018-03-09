<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
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
	SegmentCustomerListDataBean customerList = new SegmentCustomerListDataBean();
	DataBeanManager.activate(customerList, request);
	SegmentCustomerListDataBean.Customer[] customers = customerList.getCustomerList();
	int numberOfCustomers = 0;
	if (customers != null) {
		numberOfCustomers = customers.length;
	}
	String segmentId = request.getParameter(SegmentConstants.PARAMETER_SEGMENT_ID);
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function addCustomers () {
	var url = "<%= SegmentConstants.URL_SEGMENT_CUSTOMER_SEARCH_DIALOG_VIEW + UIUtil.toJavaScript(segmentId) %>";
	parent.parent.saveFormData();
	top.saveModel(parent.parent.parent.model);
	top.saveData(parent.parent.parent.pageArray, "pageArray");
	top.setReturningPanel("segmentNotebookGeneralPanel");
	top.saveData("changeInclusionList", "fromPanel");
	top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH)) %>", url, true);
}

function removeCustomers () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_REMOVE_CONFIRMATION)) %>")) {
			var userId = checked[0];
			var url = "<%= SegmentConstants.URL_SEGMENT_REMOVE_USER + UIUtil.toJavaScript(segmentId) + "&" + SegmentConstants.PARAMETER_EXCLUDED_USERS + "=false&" + SegmentConstants.PARAMETER_USER_IDS + "=" %>" + userId;
			for (var i=1; i<checked.length; i++) {
				userId = checked[i];
				url += "," + userId;
			}
			top.saveModel(parent.parent.parent.model);
			top.saveData(parent.parent.parent.pageArray, "pageArray");
			top.setReturningPanel("segmentNotebookGeneralPanel");
			top.setContent("", url, true);
		}
	}
}

function removeAllCustomers () {
	var url = "<%= SegmentConstants.URL_SEGMENT_REMOVE_USER + UIUtil.toJavaScript(segmentId) + "&" + SegmentConstants.PARAMETER_EXCLUDED_USERS + "=false&" + SegmentConstants.PARAMETER_ALL_USERS + "=true" %>";
	if (confirmDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("customerListRemoveAllConfirmation")) %>")) {
		top.saveModel(parent.parent.parent.model);
		top.saveData(parent.parent.parent.pageArray, "pageArray");
		top.setReturningPanel("segmentNotebookGeneralPanel");
		top.setContent("", url, true);
	}
}

function importCustomers () {
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=segmentation.CustomerIncludeImportDialog";
	parent.parent.saveFormData();
	top.saveModel(parent.parent.parent.model);
	top.saveData(parent.parent.parent.pageArray, "pageArray");
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

function getResultsSize () {
	return <%= numberOfCustomers %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onLoad="onLoad()" class="content_list" style="margin-left: 0px">

<%
	String orderByParm = request.getParameter("orderby");
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfCustomers;
	int totalpage = totalsize/listSize;
%>

<%= comm.addControlPanel("segmentation.CustomerList", totalpage, totalsize, locale) %>
<form name="segmentForm">
<%= comm.startDlistTable(UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_SUMMARY))) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LOGON_ID_COLUMN), SegmentConstants.ORDER_BY_LOGON_ID, SegmentConstants.ORDER_BY_LOGON_ID.equals(orderByParm)) %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), SegmentConstants.ORDER_BY_FIRST_NAME, SegmentConstants.ORDER_BY_FIRST_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), SegmentConstants.ORDER_BY_LAST_NAME, SegmentConstants.ORDER_BY_LAST_NAME.equals(orderByParm)) %>
<%	} else { %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), SegmentConstants.ORDER_BY_LAST_NAME, SegmentConstants.ORDER_BY_LAST_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), SegmentConstants.ORDER_BY_FIRST_NAME, SegmentConstants.ORDER_BY_FIRST_NAME.equals(orderByParm)) %>
<%	} %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfCustomers) {
		endIndex = numberOfCustomers;
	}

	SegmentCustomerListDataBean.Customer customer;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		customer = customers[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(customer.getId().toString(), "none") %>
<%= comm.addDlistColumn(customer.getLogonId(), "none") %>
<%		if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
<%= comm.addDlistColumn(customer.getLastName(), "none") %>
<%		} else { %>
<%= comm.addDlistColumn(customer.getLastName(), "none") %>
<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
<%		} %>
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

<%	if (numberOfCustomers == 0) { %>
<p><p>
<%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_NO_CUSTOMERS) %>
<%	} %>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
saveWCAData()
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
