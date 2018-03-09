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
function showAccountBusiness () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>);
		showDivision(document.all.accountBusinessDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadAccountBusiness () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES %>);
			}
		}
		showAccountBusiness();
	}
}

function saveAccountBusiness () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>);
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_BUSINESS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_BUSINESS_OP %>" onChange="showAccountBusiness()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_BUSINESS) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_BUSINESS_ONE_OF) %></option>
</select>

<div id="accountBusinessDiv" style="display: none; margin-left: 20">
<br/>
<%	if (orgEntityResources == null || orgEntityResources.size() == 0) { %>
<%= generateValueCheckBoxes(segmentsRB, segmentsRB, SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES, SegmentConstants.MSG_ACCOUNT_BUSINESS_OPTIONS) %>
<%	} else { %>
<%= generateValueCheckBoxes(segmentsRB, orgEntityResources, SegmentConstants.ELEMENT_ACCOUNT_BUSINESSES, SegmentConstants.ORG_ENTITY_BUSINESS_TYPE_OPTIONS) %>
<%	} %>
</div>
