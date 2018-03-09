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
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignEmsDataBean,
	com.ibm.commerce.tools.campaigns.CampaignEmsListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="../campaigns/common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignEmsListDataBean contentSpotList;
	CampaignEmsDataBean contentSpots[] = null;
	int numberOfContentSpot = 0;
	contentSpotList = new CampaignEmsListDataBean();
	contentSpotList.setEmsUsageType(CampaignConstants.EMS_USAGE_TYPE_CONTENT);
	DataBeanManager.activate(contentSpotList, request);
	contentSpots = contentSpotList.getEmsList();
	if (contentSpots != null) {
		numberOfContentSpot = contentSpots.length;
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("contentSpotListTitle") %></title>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
<!-- added from here...-->

var resultContainer = new Array();
var resultIndex = 0;

<%	for (int i=0; i<numberOfContentSpot; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].collateralId = "<%= contentSpots[i].getId().toString() %>";
resultContainer[resultIndex].collateralName = "<%= contentSpots[i].getEmsName()%>";
resultIndex++;
<%	} %>

var currentArray = top.getData("currentArray", null);
if (currentArray == null) {
	currentArray = new Array();
}

var searchType = top.getData("searchType", 1);

function performAdd () {
	// put the category's into an array in the model and set a flag
	var categoryArray = new Array();

	// check if the number of selected categories exceeds allowed result limit -- change the alert message later
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneCategory")) %>");
		return;
	}
	if ((searchType == "adCopySingle") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneCategory")) %>");
		return;
	}

	categoryArray = currentArray;
	top.sendBackData(categoryArray, "adCopyResult");
	top.saveData(null, "currentArray");

	// go back to the finder's caller!
	top.goBack();
}

// called when a checkbox is clicked
function performUpdate (isAll, checkObject) {
	var newIndex;
	var resultFound = false;

	if (isAll) {
		for (var i=0; i<resultContainer.length; i++) {
			for (var j=0; j<currentArray.length; j++) {
				// case 1: if deselect and current entry found, remove current entry
				// case 2: if select and current entry found, do nothing
				if (currentArray[j] != null) {
					if (resultContainer[i].collateralId == currentArray[j].collateralId) {
						resultFound = true;
						if (!checkObject.checked) {
							currentArray[j] = null;
							break;
						}
					}
				}
			}
			// case 3: if select and current entry not found, add current entry
			// case 4: if deselect and current entry not found, do nothing
			if (!resultFound) {
				if (checkObject.checked) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
				}
			}
			else {
				resultFound = false;
			}
		}
	}
	else {
		if (checkObject.checked) {
			for (var i=0; i<resultContainer.length; i++) {
				if (resultContainer[i].collateralId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].collateralId == checkObject.name) {
					currentArray[i] = null;
					break;
				}
			}
		}
	}

	var tempArray = new Array();
	for (var i=0; i<currentArray.length; i++) {
		if (currentArray[i] != null) {
			tempArray[tempArray.length] = currentArray[i];
		}
	}
	currentArray = tempArray;

	top.saveData(currentArray, "currentArray");
}

function performCancel () {
	// let's go back
	top.goBack();
}

<!-- till here -->

function getResultsSize () {
	return <%= numberOfContentSpot %>;
}

function getListContentSpotId (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListEditableFlag (checkValue) {
	return checkValue.substring(checkValue.indexOf("|") + 1, checkValue.length);
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>
<body onload="onLoad()" class="content_list">
<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfContentSpot;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("campaigns.ContentSpotList", totalpage, totalsize, jLocale) %>
<form name="contentSpotForm" id="contentSpotForm">
<%= comm.startDlistTable((String)campaignsRB.get("contentSpotListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListNameColumn"), "name", "name".equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListDescriptionColumn"), "description", "description".equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListScheduleNumberColumn"), "schedulenumber", "schedulenumber".equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfContentSpot) {
		endIndex = numberOfContentSpot;
	}

	CampaignEmsDataBean contentSpotDb;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		contentSpotDb = contentSpots[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(contentSpotDb.getId().toString(),"parent.setChecked();performUpdate(false, this);") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getEmsName()),"none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getNumberOfSchedule().toString()), "none") %>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>
<%	if (numberOfContentSpot == 0) { %>
<p/><p/>
<%= campaignsRB.get("contentSpotListEmpty") %>
<%	} %>
</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>