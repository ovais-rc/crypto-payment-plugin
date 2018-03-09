<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentCustomerListDataBean" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentDataBean" %>
<%@ page import="com.ibm.commerce.tools.xml.XMLUtil" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	Locale locale = segmentCommandContext.getLocale();
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale.toString());
	if (format == null) {
		format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	}
	String nameOrder = (String)XMLUtil.get(format, "name.order");
	SegmentCustomerListDataBean customerList = new SegmentCustomerListDataBean();
	DataBeanManager.activate(customerList, request);
	SegmentCustomerListDataBean.Customer[] customers = customerList.getCustomerList();
	int numberOfCustomers = 0;
	if (customers != null) {
		numberOfCustomers = customers.length;
	}

	String segmentId = request.getParameter(SegmentConstants.PARAMETER_SEGMENT_ID);
	String view = request.getParameter(SegmentConstants.PARAMETER_VIEW);
	int viewNum = 0;
	if (SegmentConstants.VIEW_EXPLICITLY_INCLUDED.equals(view)) {
		viewNum = 1;
	}
	else if (SegmentConstants.VIEW_EXPLICITLY_EXCLUDED.equals(view)) {
		viewNum = 2;
	}

	SegmentDataBean segmentDataBean = new SegmentDataBean();
	if (segmentId != null) {
		segmentDataBean.setId(segmentId);
		segmentDataBean.setStoreId(segmentCommandContext.getStoreId());
		segmentDataBean.populate();
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_TITLE) %></title>

<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" language="JavaScript">
<!-- hide script from old browsers
function loadView (view) {
	var parameters = new Object();
	if (view == "<%= SegmentConstants.VIEW_EXPLICITLY_EXCLUDED %>") {
		parameters.<%= SegmentConstants.PARAMETER_ACTION_XML_FILE %> = "<%= SegmentConstants.ACTION_XML_FILE_EXPLICITLY_EXCLUDED_CUSTOMER_LIST %>";
	}
	else {
		parameters.<%= SegmentConstants.PARAMETER_ACTION_XML_FILE %> = "<%= SegmentConstants.ACTION_XML_FILE_CUSTOMER_LIST %>";
	}
	parameters.<%= SegmentConstants.PARAMETER_ORDER_BY %> = "<%= SegmentConstants.ORDER_BY_LOGON_ID %>";
	parameters.<%= SegmentConstants.PARAMETER_CMD %> = "<%= SegmentConstants.URL_SEGMENT_CUSTOMER_LIST_VIEW %>";
	parameters.<%= SegmentConstants.PARAMETER_VIEW %> = view;
	parameters.<%= SegmentConstants.PARAMETER_SEGMENT_ID %> = "<%=UIUtil.toJavaScript( segmentId )%>";
	top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMERS)) %>", "<%= SegmentConstants.URL_SEGMENT_CUSTOMERS_VIEW %>", false, parameters);
}

function getResultsSize () {
	return <%= numberOfCustomers %>;
}

function onLoad () {
	parent.loadFrames();
}

function finderChangeSpecialText (rawDisplayText, textOne, textTwo) {
	var displayText = rawDisplayText.replace(/%1/, textOne);
	if (textTwo != null) {
		displayText = displayText.replace(/%2/, textTwo);
	}
	return displayText;
}

<%	if (segmentDataBean.getSegmentName() != null) { %>
function getUserNLSTitle () {
	return finderChangeSpecialText("<%= UIUtil.toJavaScript((String)segmentsRB.get("customerListPromptWithSegmentName")) %>", "<%= UIUtil.toJavaScript(UIUtil.toHTML((String)segmentDataBean.getSegmentName())) %>");
}
<%	} %>
//-->
</script>
</head>

<body onload="onLoad()" class="content_list">

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
<form name="segmentForm" id="segmentForm" action="">
<%= comm.startDlistTable(UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_SUMMARY))) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LOGON_ID_COLUMN), null, false) %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
	<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), null, false) %>
	<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), null, false) %>
<%	} else { %>
	<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), null, false) %>
	<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), null, false) %>
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
<%= comm.addDlistColumn(customer.getLogonId(), "none") %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
	<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
	<%= comm.addDlistColumn(customer.getLastName(), "none") %>
<%	} else { %>
	<%= comm.addDlistColumn(customer.getLastName(), "none") %>
	<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
<%	} %>
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
<%
	if (numberOfCustomers == 0) {
		if (viewNum == 0 || viewNum == 1) {
%>
<p></p><p>
<%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_NO_CUSTOMERS) %>
<%		} else { %>
</p><p></p><p>
<%= segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMER_LIST_NO_CUSTOMERS) %>
<%
		}
	}
%>
</p></form>

<script type="text/javascript" language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
parent.setoption(<%= viewNum %>);
//-->
</script>

</body>

</html>
