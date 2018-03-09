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
	Hashtable format = (Hashtable) XMLUtil.get(formats, "nlsFormats." + locale.toString());
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
	String logonId = request.getParameter(SegmentConstants.PARAMETER_LOGON_ID);
	String firstName = request.getParameter(SegmentConstants.PARAMETER_FIRST_NAME);
	String lastName = request.getParameter(SegmentConstants.PARAMETER_LAST_NAME);
	String phone = request.getParameter(SegmentConstants.PARAMETER_PHONE);
	String email = request.getParameter(SegmentConstants.PARAMETER_E_MAIL);
	String city = request.getParameter(SegmentConstants.PARAMETER_CITY);
	String zipCode = request.getParameter(SegmentConstants.PARAMETER_ZIP_CODE);
	String search = request.getParameter(SegmentConstants.PARAMETER_SEARCH);
%>

<html>

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMER_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function addCustomers () {
	var checked = parent.getChecked();
	var fromPanel = top.getData("fromPanel", 2);

	if (checked.length > 0) {
		if (fromPanel == "inclusionList") {
			var IncludeList = top.getData("IncludeCustomerList", 2);
			var ExcludeList = top.getData("ExcludeCustomerList", 2);
			for (var i=0; i<checked.length; i++) {
				var customer = new Array();
				customer = checked[i].split("<%= SegmentConstants.STRING_DELIMITER %>");
				var alreadyContain = false;
				if (IncludeList != null) {
					for (var j=0; j<IncludeList.length; j++) {
						if (IncludeList[j].memberId == customer[0]) {
							alreadyContain = true;
							break;
						}
					}
				}
				if (!alreadyContain) {
					var newCustomer = new Object;
					newCustomer.memberId = customer[0];
					newCustomer.logonID = customer[1];
					newCustomer.firstName = customer[2];
					newCustomer.lastName = customer[3];
					if (IncludeList == null) {
						IncludeList = new Array();
						IncludeList[0] = newCustomer;
					}
					else {
						IncludeList[IncludeList.length] = newCustomer;
					}
				}
			}
			var newExcludeList = new Array();
			var isConflict = false;
			if (ExcludeList != null) {
				for (var i=0; i<ExcludeList.length; i++) {
					for (var j=0; j<IncludeList.length; j++) {
						if (ExcludeList[i].memberId == IncludeList[j].memberId) {
							isConflict = true;
							break;
						}
					}
					if (!isConflict) {
						newExcludeList[newExcludeList.length] = ExcludeList[i];
					}
					else {
						isConflict = false;
					}
				}
			}
			if (newExcludeList.length == 0) {
				newExcludeList = null;
			}
			top.sendBackData(IncludeList, "IncludeCustomerList", 2);
			top.sendBackData(newExcludeList, "ExcludeCustomerList", 2);
			top.goBack(2);
		}
		else if (fromPanel == "exclusionList") {
			var IncludeList = top.getData("IncludeCustomerList", 2);
			var ExcludeList = top.getData("ExcludeCustomerList", 2);
			for (var i=0; i<checked.length; i++) {
				var customer = new Array();
				customer = checked[i].split("<%= SegmentConstants.STRING_DELIMITER %>");
				var alreadyContain = false;
				if (ExcludeList != null) {
					for (var j=0; j<ExcludeList.length; j++) {
						if (ExcludeList[j].memberId == customer[0]) {
							alreadyContain = true;
							break;
						}
					}
				}
				if (!alreadyContain) {
					var newCustomer = new Object;
					newCustomer.memberId = customer[0];
					newCustomer.logonID = customer[1];
					newCustomer.firstName = customer[2];
					newCustomer.lastName = customer[3];
					if (ExcludeList == null) {
						ExcludeList = new Array();
						ExcludeList[0] = newCustomer;
					}
					else {
						ExcludeList[ExcludeList.length] = newCustomer;
					}
				}
			}
			var newIncludeList = new Array();
			var isConflict = false;
			if (IncludeList != null) {
				for (var i=0; i<IncludeList.length; i++) {
					for (var j=0; j<ExcludeList.length; j++) {
						if (IncludeList[i].memberId == ExcludeList[j].memberId) {
							isConflict = true;
							break;
						}
					}
					if (!isConflict) {
						newIncludeList[newIncludeList.length] = IncludeList[i];
					}
					else {
						isConflict = false;
					}
				}
			}
			if (newIncludeList.length == 0) {
				newIncludeList = null;
			}
			top.sendBackData(newIncludeList, "IncludeCustomerList", 2);
			top.sendBackData(ExcludeList, "ExcludeCustomerList", 2);
			top.goBack(2);
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

<body onLoad="onLoad()" class="content_list">

<%
	String orderByParm = request.getParameter("orderby");
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfCustomers;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("segmentation.AddCustomerList", totalpage, totalsize, locale) %>

<form name="segmentForm">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_SEGMENT_ID %>" value="<%=UIUtil.toHTML( segmentId )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_LOGON_ID %>" value="<%=UIUtil.toHTML( logonId )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_FIRST_NAME %>" value="<%=UIUtil.toHTML( firstName )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_LAST_NAME %>" value="<%=UIUtil.toHTML( lastName )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_PHONE %>" value="<%=UIUtil.toHTML( phone )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_E_MAIL %>" value="<%=UIUtil.toHTML( email )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_CITY %>" value="<%=UIUtil.toHTML( city )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_ZIP_CODE %>" value="<%=UIUtil.toHTML( zipCode )%>">
<input type="hidden" name="<%=SegmentConstants.PARAMETER_SEARCH %>" value="<%=UIUtil.toHTML( search )%>">

<%= comm.startDlistTable(UIUtil.toJavaScript((String)segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMER_LIST_SUMMARY))) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMER_LIST_LOGON_ID_COLUMN), SegmentConstants.ORDER_BY_LOGON_ID, SegmentConstants.ORDER_BY_LOGON_ID.equals(orderByParm)) %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), SegmentConstants.ORDER_BY_FIRST_NAME, SegmentConstants.ORDER_BY_FIRST_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), SegmentConstants.ORDER_BY_LAST_NAME, SegmentConstants.ORDER_BY_LAST_NAME.equals(orderByParm)) %>
<%	} else { %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_LAST_NAME_COLUMN), SegmentConstants.ORDER_BY_LAST_NAME, SegmentConstants.ORDER_BY_LAST_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_LIST_FIRST_NAME_COLUMN), SegmentConstants.ORDER_BY_FIRST_NAME, SegmentConstants.ORDER_BY_FIRST_NAME.equals(orderByParm)) %>
<%	} %>
<%
	int MAX_NUMBER_OF_COLUMN = 5;
	int columnCount = 3;
	if (!phone.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_PHONE_PROMPT), SegmentConstants.ORDER_BY_PHONE, SegmentConstants.ORDER_BY_PHONE.equals(orderByParm)) %>
<%
		columnCount++;
	}
	if (!email.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_E_MAIL_PROMPT), SegmentConstants.ORDER_BY_EMAIL, SegmentConstants.ORDER_BY_EMAIL.equals(orderByParm)) %>
<%
		columnCount++;
	}
	if (!city.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_CITY_PROMPT), SegmentConstants.ORDER_BY_CITY, SegmentConstants.ORDER_BY_CITY.equals(orderByParm)) %>
<%
		columnCount++;
	}
	if (!zipCode.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumnHeading((String)segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_ZIP_CODE_PROMPT), SegmentConstants.ORDER_BY_ZIP_CODE, SegmentConstants.ORDER_BY_ZIP_CODE.equals(orderByParm)) %>
<%
		columnCount++;
	}
%>
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
<%= comm.addDlistCheck(customer.getId().toString().concat(SegmentConstants.STRING_DELIMITER).concat(customer.getLogonId()).concat(SegmentConstants.STRING_DELIMITER).concat(customer.getFirstName()).concat(SegmentConstants.STRING_DELIMITER).concat(customer.getLastName()), "none") %>
<%= comm.addDlistColumn(customer.getLogonId(), "none") %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
<%= comm.addDlistColumn(customer.getLastName(), "none") %>
<%	} else { %>
<%= comm.addDlistColumn(customer.getLastName(), "none") %>
<%= comm.addDlistColumn(customer.getFirstName(), "none") %>
<%	} %>
<%
	columnCount = 3;
	if (!phone.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumn(customer.getPhone(), "none") %>
<%
		columnCount++;
	}
	if (!email.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumn(customer.getEmail(), "none") %>
<%
		columnCount++;
	}
	if (!city.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumn(customer.getCity(), "none") %>
<%
		columnCount++;
	}
	if (!zipCode.equals("") && columnCount < MAX_NUMBER_OF_COLUMN) {
%>
<%= comm.addDlistColumn(customer.getZipCode(), "none") %>
<%
		columnCount++;
	}
%>
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
<%= segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMER_LIST_NO_CUSTOMERS) %>
<%	} %>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
