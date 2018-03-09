<!-- ========================================================================
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
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.utils.TimestampHelper" %>

<%@ include file="common.jsp" %>

<%
	java.sql.Timestamp currentTime = new java.sql.Timestamp(new java.util.Date().getTime());

	// if the current e-marketing spot cannot be edited, then disable all the fields except schedules
	String readonlyFlag = "";
	String disableFlag = "";
	if (!CampaignUtil.isEmsEditable(campaignCommandContext.getStore().getStoreType()) ||
		"N".equals(request.getParameter("emsEditableFlag"))) {
		readonlyFlag = " style=\"border-style:none\" readonly=\"readonly\" ";
		disableFlag = " disabled=\"disabled\" ";
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_EMS_PANEL_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Ems.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var emsPanelReady = false;
var schedulePanelReady = false;

function setReadyFlag (panelIndicator) {
	if (panelIndicator == "emsPanel") {
		emsPanelReady = true;
	}
	if (panelIndicator == "schedulePanel") {
		schedulePanelReady = true;
	}
	if (emsPanelReady && schedulePanelReady) {
		// finish loading base frame
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	}
}

function loadCheckValue (checkBox, checkValue) {
	// loop through the checkbox and set the correct box to check ...
	for (var i=0; i<checkBox.length; i++) {
		if (checkValue.indexOf(checkBox[i].value) >= 0) {
			checkBox[i].checked = true;
		}
	}
}

function saveCheckValue (checkBox) {
	var returnValue = "";
	for (var i=0; i<checkBox.length; i++) {
		if (checkBox[i].checked) {
			returnValue += checkBox[i].value;
		}
	}
	return returnValue;
}

function loadPanelData () {
	with (document.emsForm) {
		if (parent.get) {
			var o = parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);
			if (o != null) {
				loadValue(<%= CampaignConstants.ELEMENT_EMS_NAME %>, o.<%= CampaignConstants.ELEMENT_EMS_NAME %>);
				loadValue(<%= CampaignConstants.ELEMENT_DESCRIPTION %>, o.<%= CampaignConstants.ELEMENT_DESCRIPTION %>);
				loadCheckValue(<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>, o.<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>);
			}

			// if this e-Marketing Spot already exists
			if (parent.get("<%= CampaignConstants.ELEMENT_EMS_EXISTS %>", false)) {
				parent.remove("<%= CampaignConstants.ELEMENT_EMS_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_EMS_EXISTS)) %>");
				<%= CampaignConstants.ELEMENT_EMS_NAME %>.select();
			}
		}
		if (<%= CampaignConstants.ELEMENT_EMS_NAME %>.readOnly) {
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
		}
		else {
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.focus();
		}
	}

	setReadyFlag("emsPanel");
}

function validatePanelData () {
	with (document.emsForm) {
		if (!<%= CampaignConstants.ELEMENT_EMS_NAME %>.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_EMS_NAME_REQUIRED)) %>");
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.focus();
			return false;
		}
		if (!isContainInvalidCharacter(<%= CampaignConstants.ELEMENT_EMS_NAME %>.value)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_AN_ALPHANUMERIC_NAME)) %>");
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.select();
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_EMS_NAME %>.value, 64)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_NAME_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.select();
			<%= CampaignConstants.ELEMENT_EMS_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_DESCRIPTION %>.value, 254)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_DESCRIPTION_TOO_LONG)) %>");
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.select();
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
			return false;
		}
	}

	// validate start date and end date in schedule panel
	if (parent.get) {
		var o = parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);
		if (o != null) {
			var scheduleListData = o.<%= CampaignConstants.ELEMENT_EMS_INITIATIVE_SCHEDULE %>;

			for (var i=0; i<scheduleListData.length; i++) {
				if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
					var thisSchedule = scheduleListData[i];

					if (!validDate(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_DATE)) %>");
						getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).focus();
						return false;
					}
					if (!validTime(thisSchedule.startTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_TIME)) %>");
						getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + i).focus();
						return false;
					}
					if ((thisSchedule.endYear != "") || (thisSchedule.endMonth != "") || (thisSchedule.endDay != "") || (thisSchedule.endTime != "")) {
						if (!validDate(thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay)) {
							alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_DATE)) %>");
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
							return false;
						}
						if (!validTime(thisSchedule.endTime)) {
							alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_TIME)) %>");
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + i).select();
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + i).focus();
							return false;
						}
						// if start and end dates are specified, validate range
						if (!validateStartEndDateTime(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay, thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay, thisSchedule.startTime, thisSchedule.endTime)) {
							alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_END_AFTER_START_DATETIME)) %>");
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
							return false;
						}
						// check if the end date has already passed
						if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
							"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
							"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
							thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay,
							"<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>",
							thisSchedule.endTime)) {
							alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_END_IN_PAST)) %>");
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
							return false;
						}
					}
				}
			}

			// if the schedule starts in the past, confirms with the user
			for (var i=0; i<scheduleListData.length; i++) {
				if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
					var thisSchedule = scheduleListData[i];
					if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
						"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
						"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
						thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay,
						"<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>",
						thisSchedule.startTime)) {
						if (!confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_START_IN_PAST)) %>")) {
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).select();
							getIFrameById("scheduleList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).focus();
							return false;
						}
						break;
					}
				}
			}
		}
	}

	return true;
}

function savePanelData () {
	with (document.emsForm) {
		if (parent.get) {
			var o = parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);
			if (o != null) {
				o.<%= CampaignConstants.ELEMENT_EMS_NAME %> = <%= CampaignConstants.ELEMENT_EMS_NAME %>.value;
				o.<%= CampaignConstants.ELEMENT_DESCRIPTION %> = <%= CampaignConstants.ELEMENT_DESCRIPTION %>.value;
				o.<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %> = saveCheckValue(<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>);
				o.<%= CampaignConstants.ELEMENT_EMS_USAGE_TYPE %> = <%= CampaignConstants.ELEMENT_EMS_USAGE_TYPE %>.value;
			}
		}
	}
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("emsPanel");
	top.saveModel(parent.model);
}

function visibleList (s) {
	if (defined(getIFrameById("scheduleList").basefrm) == false || getIFrameById("scheduleList").basefrm.document.readyState != "complete") {
		return;
	}
	if (defined(getIFrameById("scheduleList").basefrm.visibleList)) {
		getIFrameById("scheduleList").basefrm.visibleList(s);
		return;
	}
	if (defined(getIFrameById("scheduleList").basefrm.document.forms[0])) {
		for (var i = 0; i < getIFrameById("scheduleList").basefrm.document.forms[0].elements.length; i++) {
			if (getIFrameById("scheduleList").basefrm.document.forms[0].elements[i].type.substring(0,6) == "select") {
				getIFrameById("scheduleList").basefrm.document.forms[0].elements[i].style.visibility = s;
			}
		}
	}
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<form name="emsForm" onsubmit="return false;" id="emsForm">

<h1><%= campaignsRB.get(CampaignConstants.MSG_EMS_PANEL_PROMPT) %></h1>

<p/><label for="<%= CampaignConstants.ELEMENT_EMS_NAME %>"><%= campaignsRB.get(CampaignConstants.MSG_EMS_NAME_PROMPT) %></label><br/>
<script language="JavaScript">
<!-- hide script from old browsers
var newESpot = true;
if (parent.get) {
	var o = parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);
	if (o != null && o.<%= CampaignConstants.ELEMENT_ID %> != "") {
		newESpot = false;
	}
}
if (newESpot) {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_EMS_NAME %>" type="text" size="50" maxlength="64" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_NAME %>_In_emsForm_1" <%= readonlyFlag %> />');
}
else {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_EMS_NAME %>" type="text" size="50" maxlength="64" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_NAME %>_In_emsForm_1" style="border-style:none" readonly="readonly" />');
}
//-->
</script>

<p/><label for="<%= CampaignConstants.ELEMENT_DESCRIPTION %>"><%= campaignsRB.get(CampaignConstants.MSG_EMS_DESCRIPTION_PROMPT) %></label><br/>
<textarea name="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" id="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>, 254);" onkeyup="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>, 254);" <%= readonlyFlag %>>
</textarea>

<p/><%= campaignsRB.get(CampaignConstants.MSG_EMS_SUPPORTED_TYPES_PROMPT) %><br/>
<input type="checkbox" name="<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>" value="<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT %>" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_1" <%= disableFlag %> />
<label for="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_1"><%= (String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 1) %></label>&nbsp;&nbsp;&nbsp;
<input type="checkbox" name="<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>" value="<%= CampaignConstants.EMS_SUPPORTED_TYPE_ADVERTISEMENT %>" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_2" <%= disableFlag %> />
<label for="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_2"><%= (String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 2) %></label>&nbsp;&nbsp;&nbsp;
<input type="checkbox" name="<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>" value="<%= CampaignConstants.EMS_SUPPORTED_TYPE_CATEGORY %>" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_3" <%= disableFlag %> />
<label for="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_3"><%= (String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 3) %></label>&nbsp;&nbsp;&nbsp;
<input type="checkbox" name="<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>" value="<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT_ASSOCIATION %>" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_4" <%= disableFlag %> />
<label for="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>_In_emsForm_4"><%= (String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 4) %></label>

<h1><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_PROMPT) %></h1>

<iframe id="scheduleList" title="<%= UIUtil.toHTML((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_PROMPT)) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.CampaignEmsScheduleList&amp;cmd=CampaignEmsSchedulePanelView&amp;orderby=name" width="100%" height="50%"></iframe>

<input name="<%= CampaignConstants.ELEMENT_EMS_USAGE_TYPE %>" type="hidden" value="<%= CampaignConstants.EMS_USAGE_TYPE_MARKETING %>" id="WC_EmsPanel_FormInput_<%= CampaignConstants.ELEMENT_EMS_USAGE_TYPE %>_In_emsForm_1" />

</form>

</body>

</html>