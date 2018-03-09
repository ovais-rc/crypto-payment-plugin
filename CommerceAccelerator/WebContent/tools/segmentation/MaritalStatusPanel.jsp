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
function showMaritalStatus () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>);
		showDivision(document.all.maritalStatusDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadMaritalStatus () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>, o.<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_MARITAL_STATUS_VALUES %>, o.<%= SegmentConstants.ELEMENT_MARITAL_STATUS_VALUES %>);
			}
		}
		showMaritalStatus();
	}
}

function saveMaritalStatus () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>);
				o.<%= SegmentConstants.ELEMENT_MARITAL_STATUS_VALUES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_MARITAL_STATUS_VALUES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_MARITAL_STATUS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>" id="<%= SegmentConstants.ELEMENT_MARITAL_STATUS_OP %>" onChange="showMaritalStatus()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_MARITAL_STATUS) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_MARITAL_STATUS_ONE_OF) %></option>
</select>

<div id="maritalStatusDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBoxes(segmentsRB, userRegistration, SegmentConstants.ELEMENT_MARITAL_STATUS_VALUES, SegmentConstants.USER_REGISTRATION_MARITAL_STATUS_OPTIONS) %>
</div>
