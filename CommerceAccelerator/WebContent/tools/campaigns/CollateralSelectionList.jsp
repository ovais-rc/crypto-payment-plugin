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
	com.ibm.commerce.tools.campaigns.CampaignCollateralDataBean,
	com.ibm.commerce.tools.campaigns.CampaignCollateralListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignCollateralListDataBean collateralList;
	CampaignCollateralDataBean collateral[] = null;
	int numberOfCollateral = 0;
	collateralList = new CampaignCollateralListDataBean();
	DataBeanManager.activate(collateralList, request);
	collateral = collateralList.getCollateralList();
	if (collateral != null) {
		numberOfCollateral = collateral.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performFinish () {
	// put the selected e-marketing spots into an array in the model
	var collateralResult = new Array();

	// at least one e-marketing spot must be selected before this add action can be completed
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_COLLATERAL)) %>");
		return;
	}

	collateralResult = currentArray;
	top.sendBackData(collateralResult, "collateralResult");
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
	top.goBack();
}

function getResultsSize () {
	return <%= numberOfCollateral %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad();" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfCollateral;
	int totalpage = totalsize/listSize;
%>

<script language="JavaScript">
<!-- hide script from old browsers
<%	for (int i=0; i<collateral.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].collateralId = "<%= collateral[i].getId() %>";
resultContainer[resultIndex].collateralName = "<%= UIUtil.toJavaScript(collateral[i].getCollateralName()) %>";
resultContainer[resultIndex].collateralStoreId = "<%= collateral[i].getStoreId() %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.CollateralSelectionList", totalpage, totalsize, jLocale) %>
<form name="collateralSelectionForm" id="collateralSelectionForm">
<%= comm.startDlistTable((String)campaignsRB.get("collateralListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_COLLATERAL_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_COLLATERAL_LIST_TYPE_COLUMN), CampaignConstants.ORDER_BY_TYPE, CampaignConstants.ORDER_BY_TYPE.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfCollateral) {
		endIndex = numberOfCollateral;
	}

	CampaignCollateralDataBean collateralDb;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		collateralDb = collateral[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(collateralDb.getId().toString(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(collateralDb.getCollateralName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(collateralDb.getCollateralName()), "none") %>
<%		if (collateralDb.getCollateralType().intValue() == 2) { %>
<%= comm.addDlistColumn((String)campaignsRB.get("collateralType2"), "none") %>
<%		} else { %>
<%= comm.addDlistColumn((String)campaignsRB.get("collateralType1"), "none") %>
<%		} %>
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

<%	if (numberOfCollateral == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_SELECTION_LIST_EMPTY) %>
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