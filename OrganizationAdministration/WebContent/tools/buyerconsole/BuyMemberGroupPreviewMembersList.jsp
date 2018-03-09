<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
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
-->

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentCustomerListDataBean" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentDataBean" %>
<%@ page import="com.ibm.commerce.tools.xml.XMLUtil" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>

<%
   CommandContext cmdContext 	= getCommandContext();
   Locale locale = cmdContext.getLocale();

   // obtain the resource bundle for display
   Hashtable memberGroupListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", getLocale());
   Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
   Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale.toString());
   if (format == null) {
	format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
   }
   String nameOrder = (String)XMLUtil.get(format, "name.order");
   
   SegmentCustomerListDataBean customerList = new SegmentCustomerListDataBean();
   customerList.setView("all");
   customerList.setCheckStore("false");
   DataBeanManager.activate(customerList, request);
   SegmentCustomerListDataBean.Customer[] customers = customerList.getCustomerList();
   int numberOfCustomers = 0;
   if (customers != null) {
	numberOfCustomers = customers.length;
   }

   String memberGroupId = request.getParameter("segmentId");

   SegmentDataBean segmentDataBean = new SegmentDataBean();
   segmentDataBean.setId(memberGroupId);
   segmentDataBean.populate();
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(locale)%>" type="text/css">

<title><%= UIUtil.toHTML( (String)memberGroupListNLS.get("memberGroupPreviewMembersTitle") ) %></title>

<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" language="JavaScript">
<!-- hide script from old browsers
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

<% if (segmentDataBean.getSegmentName() != null) { %>
function getUserNLSTitle () {
	return finderChangeSpecialText("<%= UIUtil.toJavaScript((String)memberGroupListNLS.get("memberGroupPreviewMembersPromptWithSegmentName")) %>", "<%= UIUtil.toJavaScript(UIUtil.toHTML((String)segmentDataBean.getSegmentName())) %>");
}
<% } %>

//-->
</script>
</head>

<body onload="onLoad()" class="content_list">
<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfCustomers;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("buyerconsole.BuyMemberGroupPreviewMembersList", totalpage, totalsize, locale) %>
<form name="MemberGroupPreviewMembersForm" id="MemberGroupPreviewMembersForm" action="">
<%=addHiddenVars()%>
<%= comm.startDlistTable(UIUtil.toJavaScript((String)memberGroupListNLS.get("memberGroupPreviewMembersSummary"))) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupPreviewMembersLogonIdColumn"), null, false) %>
<%	if (nameOrder.indexOf("first") < nameOrder.indexOf("last")) { %>
	<%= comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupPreviewMembersFirstNameColumn"), null, false) %>
	<%= comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupPreviewMembersLastNameColumn"), null, false) %>
<%	} else { %>
	<%= comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupPreviewMembersLastNameColumn"), null, false) %>
	<%= comm.addDlistColumnHeading((String)memberGroupListNLS.get("memberGroupPreviewMembersFirstNameColumn"), null, false) %>
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

<% if (numberOfCustomers == 0) { %>
<p></p><p>
<%=UIUtil.toHTML((String)memberGroupListNLS.get("memberGroupPreviewMembersNoCustomers"))%>
<% } %>
</p></form>

<script type="text/javascript" language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
