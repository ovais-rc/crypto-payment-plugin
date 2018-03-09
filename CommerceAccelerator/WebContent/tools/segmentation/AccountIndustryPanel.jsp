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
function showAccountIndustry () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>);
		showDivision(document.all.accountIndustryDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadAccountIndustry () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES %>);
			}
		}
		showAccountIndustry();
	}
}

function saveAccountIndustry () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>);
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_INDUSTRY_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_INDUSTRY_OP %>" onChange="showAccountIndustry()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_INDUSTRY) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_INDUSTRY_ONE_OF) %></option>
</select>

<div id="accountIndustryDiv" style="display: none; margin-left: 20">
<br/>
<%	if (orgEntityResources == null || orgEntityResources.size() == 0) { %>
<%= generateValueCheckBoxes(segmentsRB, segmentsRB, SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES, SegmentConstants.MSG_ACCOUNT_INDUSTRY_OPTIONS) %>
<%	} else { %>
<%= generateValueCheckBoxes(segmentsRB, orgEntityResources, SegmentConstants.ELEMENT_ACCOUNT_INDUSTRIES, SegmentConstants.ORG_ENTITY_INDUSTRY_TYPE_OPTIONS) %>
<%	} %>
</div>
