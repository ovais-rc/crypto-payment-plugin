<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
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
	ResourceBundleDataBean usrResourceBundle= new ResourceBundleDataBean();
	usrResourceBundle.setPropertyFileName(SegmentConstants.SEGMENTATION_USER_REGISTRATION);
	DataBeanManager.activate(usrResourceBundle, request);
	Hashtable userRegistration = (Hashtable) usrResourceBundle.getPropertyHashtable();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showIncome () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_INCOME_OP %>);
		showDivision(document.all.incomeDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadIncome () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_INCOME_OP %>, o.<%= SegmentConstants.ELEMENT_INCOME_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_INCOME_GROUPS %>, o.<%= SegmentConstants.ELEMENT_INCOME_GROUPS %>);
			}
		}
		showIncome();
	}
}

function saveIncome () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_INCOME_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_INCOME_OP %>);
				o.<%= SegmentConstants.ELEMENT_INCOME_GROUPS %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_INCOME_GROUPS %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_INCOME_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_INCOME_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_INCOME_OP %>" id="<%= SegmentConstants.ELEMENT_INCOME_OP %>" onChange="showIncome()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_INCOME) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_INCOME_ONE_OF) %></option>
</select>

<div id="incomeDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBoxes(segmentsRB, userRegistration, SegmentConstants.ELEMENT_INCOME_GROUPS, SegmentConstants.USER_REGISTRATION_INCOME_OPTIONS) %>
</div>
