<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
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
		"N".equals(request.getParameter("contentSpotEditableFlag"))) {
		readonlyFlag = " style=\"border-style:none\" readonly=\"readonly\" ";
		disableFlag = " disabled=\"disabled\" ";
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("contentSpotPanelTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Ems.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var contentSpotPanelReady = false;
var schedulePanelReady = false;

var contentSpotDataBean = parent.get("ems", null);
if (contentSpotDataBean == null) {
	contentSpotDataBean = top.getData("contentSpotDataBean", null);
}

function setReadyFlag (panelIndicator) {
	if (panelIndicator == "contentSpotPanel") {
		contentSpotPanelReady = true;
	}
	if (panelIndicator == "schedulePanel") {
		schedulePanelReady = true;
	}
	if (contentSpotPanelReady && schedulePanelReady) {
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
	with (document.contentSpotForm) {
		if (contentSpotDataBean != null) {
			loadValue(emsName, contentSpotDataBean.emsName);
			loadValue(description, contentSpotDataBean.description);
		}

		// if this e-Marketing Spot already exists
		if (parent.get("emsExists", false)) {
			parent.remove("emsExists");
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotExists")) %>");
			emsName.select();
		}

		if (emsName.readOnly) {
			description.focus();
		}
		else {
			emsName.focus();
		}
	}

	setReadyFlag("contentSpotPanel");
}

function validatePanelData () {
	with (document.contentSpotForm) {
		if (!emsName.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotNameRequired")) %>");
			emsName.focus();
			return false;
		}
		if (!isValidName(emsName.value)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterAnAlphaNumericName")) %>");
			emsName.select();
			emsName.focus();
			return false;
		}
		if (!isValidUTF8length(emsName.value, 64)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsNameTooLong")) %>");
			emsName.select();
			emsName.focus();
			return false;
		}
		if (!isValidUTF8length(description.value, 254)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsDescriptionTooLong")) %>");
			description.select();
			description.focus();
			return false;
		}
	}

	// validate start date and end date in schedule panel
	if (contentSpotDataBean != null) {
		var scheduleListData = contentSpotDataBean.initiativeSchedule;

		for (var i=0; i<scheduleListData.length; i++) {
			if ((scheduleListData[i].actionFlag != "deleteAction") && (scheduleListData[i].actionFlag != "destroyAction")) {
				var thisSchedule = scheduleListData[i];

				if (!validDate(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("invalidDate")) %>");
					getIFrameById("scheduleList").basefrm.document.all("startYear_" + i).select();
					getIFrameById("scheduleList").basefrm.document.all("startYear_" + i).focus();
					return false;
				}
				if (!validTime(thisSchedule.startTime)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("invalidTime")) %>");
					getIFrameById("scheduleList").basefrm.document.all("startTime_" + i).select();
					getIFrameById("scheduleList").basefrm.document.all("startTime_" + i).focus();
					return false;
				}
				if ((thisSchedule.endYear != "") || (thisSchedule.endMonth != "") || (thisSchedule.endDay != "") || (thisSchedule.endTime != "")) {
					if (!validDate(thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("invalidDate")) %>");
						getIFrameById("scheduleList").basefrm.document.all("endYear_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("endYear_" + i).focus();
						return false;
					}
					if (!validTime(thisSchedule.endTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("invalidTime")) %>");
						getIFrameById("scheduleList").basefrm.document.all("endTime_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("endTime_" + i).focus();
						return false;
					}
					// if start and end dates are specified, validate range
					if (!validateStartEndDateTime(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay, thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay, thisSchedule.startTime, thisSchedule.endTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterEndAfterStartDateTime")) %>");
						getIFrameById("scheduleList").basefrm.document.all("endYear_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("endYear_" + i).focus();
						return false;
					}
				}
			}
		}

		for (var i=0; i<scheduleListData.length; i++) {
			if ((scheduleListData[i].actionFlag != "deleteAction") && (scheduleListData[i].actionFlag != "destroyAction")) {
				var thisSchedule = scheduleListData[i];

				// if the schedule starts in the past, confirms with the user
				if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
					"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
					"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
					thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay,
					"<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>",
					thisSchedule.startTime)) {
					if (!confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleStartInPast")) %>")) {
						getIFrameById("scheduleList").basefrm.document.all("startYear_" + i).select();
						getIFrameById("scheduleList").basefrm.document.all("startYear_" + i).focus();
						return false;
					}
					break;
				}
			}
		}
	}

	return true;
}

function savePanelData () {
	with (document.contentSpotForm) {
		if (contentSpotDataBean != null) {
			contentSpotDataBean.emsName = emsName.value;
			contentSpotDataBean.description = description.value;
			contentSpotDataBean.supportedTypes = supportedTypes.value;
			contentSpotDataBean.usageType = usageType.value;
			parent.put("ems", contentSpotDataBean);
		}
	}
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("contentSpotPanel");
	top.saveData(contentSpotDataBean, "contentSpotDataBean");
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

<form name="contentSpotForm" onsubmit="return false;" id="contentSpotForm">

<h1><%= campaignsRB.get("contentSpotPanelPrompt") %></h1>

<p/><label for="emsName"><%= campaignsRB.get("contentSpotNamePrompt") %></label><br/>
<script language="JavaScript">
<!-- hide script from old browsers
if (contentSpotDataBean != null && contentSpotDataBean.<%= CampaignConstants.ELEMENT_ID %> != "") {
	document.writeln('<input name="emsName" type="text" size="50" maxlength="64" id="emsName" style="border-style:none" readonly="readonly" />');
}
else {
	document.writeln('<input name="emsName" type="text" size="50" maxlength="64" id="emsName" <%= readonlyFlag %> />');
}
//-->
</script>

<p/><label for="description"><%= campaignsRB.get("contentSpotDescriptionPrompt") %></label><br/>
<textarea name="description" id="description" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.description, 254);" onkeyup="limitTextArea(this.form.description, 254);" <%= readonlyFlag %>>
</textarea>

<h1><%= campaignsRB.get("contentScheduleListPrompt") %></h1>

<iframe id="scheduleList" title="<%= UIUtil.toHTML((String)campaignsRB.get("contentScheduleListPrompt")) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.ContentSpotScheduleList&amp;cmd=ContentSpotSchedulePanelView&amp;orderby=name" width="100%" height="400"></iframe>

<input name="supportedTypes" type="hidden" value="<%= com.ibm.commerce.tools.campaigns.CampaignConstants.EMS_SUPPORTED_TYPE_GENERAL_CONTENT %>" id="WC_ContentSpotPanel_FormInput_supportedTypes_In_contentSpotForm_1" />
<input name="usageType" type="hidden" value="<%= com.ibm.commerce.tools.campaigns.CampaignConstants.EMS_USAGE_TYPE_CONTENT %>" id="WC_ContentSpotPanel_FormInput_usageType_In_contentSpotForm_1" />

</form>

</body>

</html>