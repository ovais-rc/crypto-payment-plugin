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
function showAge () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_AGE_OP %>);
		showDivision(document.all.ageDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadAge () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_AGE_OP %>, o.<%= SegmentConstants.ELEMENT_AGE_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_AGE_GROUPS %>, o.<%= SegmentConstants.ELEMENT_AGE_GROUPS %>);
			}
		}
		showAge();
	}
}

function saveAge () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_AGE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_AGE_OP %>);
				o.<%= SegmentConstants.ELEMENT_AGE_GROUPS %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_AGE_GROUPS %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_AGE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_AGE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_AGE_OP %>" id="<%= SegmentConstants.ELEMENT_AGE_OP %>" onChange="showAge()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_AGE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_AGE_ONE_OF) %></option>
</select>

<div id="ageDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBoxes(segmentsRB, userRegistration, SegmentConstants.ELEMENT_AGE_GROUPS, SegmentConstants.USER_REGISTRATION_AGE_OPTIONS) %>
</div>
