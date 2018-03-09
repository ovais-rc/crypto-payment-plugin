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
function showGender () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_GENDER_OP %>);
		showDivision(document.all.genderDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadGender () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_GENDER_OP %>, o.<%= SegmentConstants.ELEMENT_GENDER_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_GENDER_VALUES %>, o.<%= SegmentConstants.ELEMENT_GENDER_VALUES %>);
			}
		}
		showGender();
		<%= SegmentConstants.ELEMENT_GENDER_OP %>.focus();
	}
}

function saveGender () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_GENDER_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_GENDER_OP %>);
				o.<%= SegmentConstants.ELEMENT_GENDER_VALUES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_GENDER_VALUES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_GENDER_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_GENDER_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_GENDER_OP %>" id="<%= SegmentConstants.ELEMENT_GENDER_OP %>" onChange="showGender()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_GENDER) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_GENDER_ONE_OF) %></option>
</select>

<div id="genderDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBoxes(segmentsRB, userRegistration, SegmentConstants.ELEMENT_GENDER_VALUES, SegmentConstants.USER_REGISTRATION_GENDER_OPTIONS) %>
</div>
