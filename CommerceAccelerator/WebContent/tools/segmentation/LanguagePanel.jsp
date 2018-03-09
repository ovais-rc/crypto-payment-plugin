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
	com.ibm.commerce.tools.segmentation.SegmentLanguagesDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentLanguagesDataBean segmentLanguages = new SegmentLanguagesDataBean();
	DataBeanManager.activate(segmentLanguages, request);
	SegmentLanguagesDataBean.Language[] languages = segmentLanguages.getLanguages();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showLanguage () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>);
		showDivision(document.all.languageDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadLanguage () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>, o.<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_LANGUAGES %>, o.<%= SegmentConstants.ELEMENT_LANGUAGES %>);
			}
		}
		showLanguage();
	}
}

function saveLanguage () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_LANGUAGE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>);
				o.<%= SegmentConstants.ELEMENT_LANGUAGES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_LANGUAGES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_LANGUAGE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>" id="<%= SegmentConstants.ELEMENT_LANGUAGE_OP %>" onChange="showLanguage()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_LANGUAGE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_LANGUAGE_ONE_OF) %></option>
</select>

<div id="languageDiv" style="display: none; margin-left: 20">
<br/>
<%
	if (languages != null) {
		for (int i=0; i<languages.length; i++) {
%>
<nobr><input name="<%= SegmentConstants.ELEMENT_LANGUAGES %>" id="<%= SegmentConstants.ELEMENT_LANGUAGES %>" type="checkbox" value="<%= languages[i].getLocaleName() %>">
<label for="<%= SegmentConstants.ELEMENT_LANGUAGES %>"><%= languages[i].getLanguageDescription() %></label></nobr>
<%
		}
	}
%>
</div>
