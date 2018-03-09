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

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.common.beans.ResourceBundleDataBean" %>

<%@ include file="SegmentCommon.jsp" %>
<%@ include file="ValueCheckBoxes.jspf" %>

<%
	ResourceBundleDataBean orgResourceBundle= new ResourceBundleDataBean();
	orgResourceBundle.setPropertyFileName(SegmentConstants.ORG_ENTITY_PROPERTIES_FILE);
	DataBeanManager.activate(orgResourceBundle, request);
	Hashtable orgEntityResources = (Hashtable) orgResourceBundle.getPropertyHashtable();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showAccountSize () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP %>);
		showDivision(document.all.accountSizeDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadAccountSize () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
			if (o != null) {
				loadSelectValue(<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP%>, o.<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP%>);
				loadCheckBoxValues(<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES%>, o.<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES%>);
			}
		}
		showAccountSize();
	}
}

function saveAccountSize () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
			if (o != null) {
				o.<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP%> = getSelectValue(<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP%>);
				o.<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES%> = getCheckBoxValues(<%=SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES%>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_SIZE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_SIZE_OP %>" onChange="showAccountSize()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_SIZE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_SIZE_ONE_OF) %></option>
</select>

<div id="accountSizeDiv" style="display: none; margin-left: 20">
<br/>
<%	if (orgEntityResources == null || orgEntityResources.size() == 0) { %>
<%= generateValueCheckBoxes(segmentsRB, segmentsRB, SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES, SegmentConstants.MSG_ACCOUNT_SIZE_OPTIONS) %>
<%	} else { %>
<%= generateValueCheckBoxes(segmentsRB, orgEntityResources, SegmentConstants.ELEMENT_ACCOUNT_SIZE_VALUES, SegmentConstants.ORG_ENTITY_SIZE_OPTIONS) %>
<%	} %>
</div>
