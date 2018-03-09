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
	ResourceBundleDataBean usrResourceBundle= new ResourceBundleDataBean();
	usrResourceBundle.setPropertyFileName(SegmentConstants.SEGMENTATION_USER_REGISTRATION);
	DataBeanManager.activate(usrResourceBundle, request);
	Hashtable userRegistration = (Hashtable) usrResourceBundle.getPropertyHashtable();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showJobFunction () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>);
		showDivision(document.all.jobFunctionDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadJobFunction () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>, o.<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_JOB_FUNCTIONS %>, o.<%= SegmentConstants.ELEMENT_JOB_FUNCTIONS %>);
			}
		}
		showJobFunction();
	}
}

function saveJobFunction () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>);
				o.<%= SegmentConstants.ELEMENT_JOB_FUNCTIONS %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_JOB_FUNCTIONS %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_JOB_FUNCTION_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>" id="<%= SegmentConstants.ELEMENT_JOB_FUNCTION_OP %>" onChange="showJobFunction()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_JOB_FUNCTION) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_JOB_FUNCTION_ONE_OF) %></option>
</select>

<div id="jobFunctionDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBoxes(segmentsRB, userRegistration, SegmentConstants.ELEMENT_JOB_FUNCTIONS, SegmentConstants.USER_REGISTRATION_JOB_FUNCTION_OPTIONS) %>
</div>
