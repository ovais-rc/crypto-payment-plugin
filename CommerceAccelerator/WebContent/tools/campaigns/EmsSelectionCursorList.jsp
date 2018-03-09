<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2008
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
	com.ibm.commerce.tools.campaigns.CampaignEmsListCursorDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignEmsListCursorDataBean emsList = new CampaignEmsListCursorDataBean();
	emsList.setEmsUsageType(CampaignConstants.EMS_USAGE_TYPE_MARKETING);
	
	//get the start and list sizes from the xml file
  int startIndex = Integer.parseInt(request.getParameter("startindex"));
  int listSize = Integer.parseInt(request.getParameter("listsize"));
  int endIndex = startIndex + listSize;

  //initialize the start and end indicies
  emsList.setIndexEnd("" + endIndex);
  emsList.setIndexBegin("" + startIndex);
   
	DataBeanManager.activate(emsList, request);
	CampaignEmsDataBean [] ems = emsList.getEmsList();
	
	int numberOfEms = 0;
	int totalNumberOfEms = 0;
	
	if (ems != null) {
		numberOfEms = ems.length;
	  totalNumberOfEms = emsList.getResultSetSize();
	}
	
	//set up paging
	int rowselect = 1;
	int totalpage = 0;
	if (listSize != 0) {
		totalpage = totalNumberOfEms/listSize;
	}

	String resultLimit = "multiple";
	if (request.getParameter("resultLimit") != null && !request.getParameter("resultLimit").equals("")) {
		resultLimit = request.getParameter("resultLimit");
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
var resultLimit = "<%= UIUtil.toJavaScript(resultLimit) %>";
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performFinish () {
	// put the selected e-marketing spots into an array in the model
	var emsResult = new Array();

	// check if no checkboxes has been selected, or checked boxes exceeds allowed result limit
	if ((resultLimit == "single") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneEms")) %>");
		return;
	}
	if ((resultLimit == "single") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneEms")) %>");
		return;
	}
	if ((resultLimit == "multiple") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtLeastOneEms")) %>");
		return;
	}

	emsResult = currentArray;
	top.sendBackData(emsResult, "emsResult");
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
	top.goBack();
}

function getResultsSize () {
	return <%= totalNumberOfEms %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad();" class="content_list">

<script language="JavaScript">
<!-- hide script from old browsers
<%	for (int i=0; i<ems.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].emsId = "<%= ems[i].getId() %>";
resultContainer[resultIndex].emsName = "<%= UIUtil.toJavaScript(ems[i].getEmsName()) %>";
resultContainer[resultIndex].emsStoreId = "<%= ems[i].getStoreId() %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.EmsSelectionList", listSize, totalNumberOfEms, jLocale) %>
<form name="emsSelectionForm" id="emsSelectionForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SCHEDULE_NUMBER_COLUMN), null, false) %>
<%= comm.endDlistRow() %>
  <%
	//make sure the endIndex is greater than the number of spots
	if (endIndex > totalNumberOfEms) {
		endIndex = totalNumberOfEms;
	}
	int indexFrom = startIndex;
	for (int i = 0; i < numberOfEms; i++) {
	    CampaignEmsDataBean emsDb = ems[i];
  %>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(emsDb.getId().toString(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(emsDb.getEmsName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getEmsName()), "none") %>
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
<%= campaignsRB.get(CampaignConstants.MSG_EMS_SELECTION_LIST_EMPTY) %>
<%	} %>
</form>

<script>
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
