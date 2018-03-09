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
	com.ibm.commerce.tools.segmentation.SegmentCurrenciesDataBean" %>

<%@ include file="SegmentCommon.jsp" %>
<%@ include file="ValueCheckBox.jspf" %>

<%
	SegmentCurrenciesDataBean segmentCurrencies = new SegmentCurrenciesDataBean();
	DataBeanManager.activate(segmentCurrencies, request);
	String[] currencies = segmentCurrencies.getCurrencies();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showCurrency () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_CURRENCY_OP %>);
		showDivision(document.all.currencyDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadCurrency () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_CURRENCY_OP %>, o.<%= SegmentConstants.ELEMENT_CURRENCY_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_CURRENCIES %>, o.<%= SegmentConstants.ELEMENT_CURRENCIES %>);
			}
		}
		showCurrency();
	}
}

function saveCurrency () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_CURRENCY_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_CURRENCY_OP %>);
				o.<%= SegmentConstants.ELEMENT_CURRENCIES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_CURRENCIES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_CURRENCY_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_CURRENCY_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_CURRENCY_OP %>" id="<%= SegmentConstants.ELEMENT_CURRENCY_OP %>" onChange="showCurrency()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_CURRENCY) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_CURRENCY_ONE_OF) %></option>
</select>

<div id="currencyDiv" style="display: none; margin-left: 20">
<br/>
<%
	if (currencies != null) {
		for (int i=0; i<currencies.length; i++) {
%>
<%= generateValueCheckBox(segmentsRB, SegmentConstants.ELEMENT_CURRENCIES, SegmentConstants.MSG_CURRENCY, currencies[i]) %>
<%
		}
	}
%>
</div>
