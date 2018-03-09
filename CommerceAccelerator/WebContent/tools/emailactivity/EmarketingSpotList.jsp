<!-- 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//----------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
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
<%@ include file="../bi/BINLS.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignEmsListDataBean emsList;
	CampaignEmsDataBean ems[] = null;
	int numberOfEms = 0;
	emsList = new CampaignEmsListDataBean();
	DataBeanManager.activate(emsList, request);
	ems = emsList.getEmsList();
	if (ems != null) {
		numberOfEms = ems.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_EMS_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers

<!-- added from here...-->

var resultContainer = new Array();
var resultIndex = 0;

<%	for (int i=0; i<ems.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].emsId = "<%= ems[i].getId().toString() %>";
resultContainer[resultIndex].emsName = "<%= ems[i].getEmsName()%>";
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

	// check if the number of selected categories exceeds allowed result limit
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneCategory")) %>");
		return;
	}
	if ((searchType == "emsSingle") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneCategory")) %>");
		return;
	}

	categoryArray = currentArray;
	top.sendBackData(categoryArray, "emsResult");
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
					if (resultContainer[i].emsId == currentArray[j].emsId) {
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
				if (resultContainer[i].emsId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].emsId == checkObject.name) {
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
	return <%= numberOfEms %>;
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
	int totalsize = numberOfEms;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("campaigns.CampaignEmsList", totalpage, totalsize, jLocale) %>
<form name="emsForm" id="emsForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.compareTo(orderByParm) == 0) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.compareTo(orderByParm) == 0) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SCHEDULE_NUMBER_COLUMN), CampaignConstants.ORDER_BY_SCHEDULE_NUMBER, CampaignConstants.ORDER_BY_SCHEDULE_NUMBER.compareTo(orderByParm) == 0) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfEms) {
		endIndex = numberOfEms;
	}

	CampaignEmsDataBean emsDb;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		emsDb = ems[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(emsDb.getId().toString(),"parent.setChecked();performUpdate(false, this);") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getEmsName()),"none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getNumberOfSchedule().toString()), "none") %>
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
<%	if (numberOfEms == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_EMS_LIST_EMPTY) %>
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