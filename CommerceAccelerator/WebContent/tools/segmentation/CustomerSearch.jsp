<!--
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
-->

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
	String segmentId = request.getParameter(SegmentConstants.PARAMETER_SEGMENT_ID);
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_DIALOG_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function loadPanelData () {
	document.searchForm.<%= SegmentConstants.PARAMETER_LOGON_ID %>.focus();

	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

function validatePanelData () {
	with (document.searchForm) {
		if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_LOGON_ID %>.value, 254)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_LOGON_ID %>.focus();
			<%= SegmentConstants.PARAMETER_LOGON_ID %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_FIRST_NAME %>.value, 128)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_FIRST_NAME %>.focus();
			<%= SegmentConstants.PARAMETER_FIRST_NAME %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%=SegmentConstants.PARAMETER_LAST_NAME%>.value, 128)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_LAST_NAME %>.focus();
			<%= SegmentConstants.PARAMETER_LAST_NAME %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_PHONE %>.value, 32)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_PHONE %>.focus();
			<%= SegmentConstants.PARAMETER_PHONE %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_E_MAIL %>.value, 256)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_E_MAIL %>.focus();
			<%= SegmentConstants.PARAMETER_E_MAIL %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_CITY %>.value, 128)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_CITY %>.focus();
			<%= SegmentConstants.PARAMETER_CITY %>.select();
			return false;
		}
		else if (!isValidUTF8length(<%= SegmentConstants.PARAMETER_ZIP_CODE %>.value, 128)) {
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG)) %>");
			<%= SegmentConstants.PARAMETER_ZIP_CODE %>.focus();
			<%= SegmentConstants.PARAMETER_ZIP_CODE %>.select();
			return false;
		}
		return true;
	}
}

function findCustomers () {
	if (validatePanelData()) {
		with (document.searchForm) {
			var parameters = new Object();
			parameters.ActionXMLFile = "segmentation.AddCustomerList";
			parameters.cmd = "SegmentAddCustomerListView";
			parameters.<%= SegmentConstants.PARAMETER_XML_FILE %> = "<%= SegmentConstants.XML_FILE_ADD_CUSTOMERS_DIALOG %>";
			parameters.<%= SegmentConstants.PARAMETER_VIEW %> = "<%= SegmentConstants.VIEW_ALL %>";
			parameters.<%= SegmentConstants.PARAMETER_LOGON_ID %> = <%= SegmentConstants.PARAMETER_LOGON_ID %>.value;
			parameters.<%= SegmentConstants.PARAMETER_FIRST_NAME %> = <%= SegmentConstants.PARAMETER_FIRST_NAME %>.value;
			parameters.<%= SegmentConstants.PARAMETER_LAST_NAME %> = <%= SegmentConstants.PARAMETER_LAST_NAME %>.value;
			parameters.<%= SegmentConstants.PARAMETER_PHONE %> = <%= SegmentConstants.PARAMETER_PHONE %>.value;
			parameters.<%= SegmentConstants.PARAMETER_E_MAIL %> = <%= SegmentConstants.PARAMETER_E_MAIL %>.value;
			parameters.<%= SegmentConstants.PARAMETER_CITY %> = <%= SegmentConstants.PARAMETER_CITY %>.value;
			parameters.<%= SegmentConstants.PARAMETER_ZIP_CODE %> = <%= SegmentConstants.PARAMETER_ZIP_CODE %>.value;
			parameters.<%= SegmentConstants.PARAMETER_SEGMENT_ID %> = "<%=UIUtil.toJavaScript( segmentId )%>";
			parameters.<%= SegmentConstants.PARAMETER_SEARCH %> = "true";
			top.setContent("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_ADD_CUSTOMERS)) %>", "<%= SegmentConstants.URL_SEGMENT_ADD_CUSTOMERS_DIALOG_VIEW %>", true, parameters);
		}
	}
}

function getNameOrder () {
	return "<%= nameOrder %>";
}

function displayNameSearchField () {
	var tempList = getNameOrder();
	var nameOrderList = tempList.split(",");

	for (var i=0; i<nameOrderList.length; i++) {
		if (nameOrderList[i] == "last") {
			document.writeln("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_LAST_NAME_PROMPT)) %><br/>");
			document.writeln('<input name="<%= SegmentConstants.PARAMETER_LAST_NAME %>" id="<%= SegmentConstants.PARAMETER_LAST_NAME %>" type="text" maxlength="128"><br/>');
		}
		else if (nameOrderList[i] == "first") {
			document.writeln("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_FIRST_NAME_PROMPT)) %><br/>");
			document.writeln('<input name="<%= SegmentConstants.PARAMETER_FIRST_NAME %>" id="<%= SegmentConstants.PARAMETER_FIRST_NAME %>" type="text" maxlength="128"><br/>');
		}
	}
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<h1><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_DIALOG_TITLE) %></h1>

<p/><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_DIALOG_PROMPT) %>

<form id="searchForm" name="searchForm">

<p/><label for="<%= SegmentConstants.PARAMETER_LOGON_ID %>"><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_LOGON_ID_PROMPT) %></label><br/>
<input name="<%= SegmentConstants.PARAMETER_LOGON_ID %>" id="<%= SegmentConstants.PARAMETER_LOGON_ID %>" type="text" maxlength="254"><br/>

<script language="JavaScript">
<!-- hide script from old browsers
displayNameSearchField();
//-->
</script>

<label for="<%= SegmentConstants.PARAMETER_PHONE %>"><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_PHONE_PROMPT) %></label><br/>
<input name="<%= SegmentConstants.PARAMETER_PHONE %>" id="<%= SegmentConstants.PARAMETER_PHONE %>" type="text" maxlength="32"><br/>

<label for="<%= SegmentConstants.PARAMETER_E_MAIL %>"><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_E_MAIL_PROMPT) %></label><br/>
<input name="<%= SegmentConstants.PARAMETER_E_MAIL %>" id="<%= SegmentConstants.PARAMETER_E_MAIL %>" type="text" maxlength="256"><br/>

<label for="<%= SegmentConstants.PARAMETER_CITY %>"><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_CITY_PROMPT) %></label><br/>
<input name="<%= SegmentConstants.PARAMETER_CITY %>" id="<%= SegmentConstants.PARAMETER_CITY %>" type="text" maxlength="128"><br/>

<label for="<%= SegmentConstants.PARAMETER_ZIP_CODE %>"><%= segmentsRB.get(SegmentConstants.MSG_CUSTOMER_SEARCH_ZIP_CODE_PROMPT) %></label><br/>
<input name="<%= SegmentConstants.PARAMETER_ZIP_CODE %>" id="<%= SegmentConstants.PARAMETER_ZIP_CODE %>" type="text" maxlength="40"><br/>

</form>

</body>

</html>
