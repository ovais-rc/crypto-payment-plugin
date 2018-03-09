<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2005
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
	com.ibm.commerce.tools.campaigns.search.beans.CollateralSearchListBeanConsts,
	com.ibm.commerce.tools.campaigns.search.beans.CollateralSearchListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignCollateralListDataBean collateralList;
	CollateralSearchListDataBean collateralSearchList;
	CampaignCollateralDataBean collateral[] = null;

	// perform content search if necessary, otherwise fetch the entire list of content
	if ((request.getParameter("isContentSearch") != null) && (request.getParameter("isContentSearch").equals("Y"))) {
		collateralSearchList = new CollateralSearchListDataBean();
		String nameSearchString = request.getParameter("nameSearchString");
		if ((nameSearchString != null) && (!nameSearchString.equals(""))) {
			collateralSearchList.setName(nameSearchString);
			collateralSearchList.setNameOperator(request.getParameter("nameSearchType"));
		}
		String marketingTextSearchString = request.getParameter("marketingTextSearchString");
		if ((marketingTextSearchString != null) && (!marketingTextSearchString.equals(""))) {
			collateralSearchList.setMktTxt(marketingTextSearchString);
			collateralSearchList.setMktTxtOperator(request.getParameter("marketingTextSearchType"));
		}
		String fileNameSearchString = request.getParameter("fileNameSearchString");
		if ((fileNameSearchString != null) && (!fileNameSearchString.equals(""))) {
			collateralSearchList.setFileName(fileNameSearchString);
			collateralSearchList.setFileNameOperator(request.getParameter("fileNameSearchType"));
		}
		String clickActionValue = request.getParameter("clickActionValue");
		if ((clickActionValue != null) && (!clickActionValue.equals(""))) {
			collateralSearchList.setURL(clickActionValue);
			collateralSearchList.setURLOperator(CollateralSearchListBeanConsts.OPERATOR_LIKE);
		}
		collateralSearchList.setMaxResult(request.getParameter("numberOfResultValue"));
		collateralSearchList.setOrderBy(orderByParm);
		DataBeanManager.activate(collateralSearchList, campaignCommandContext);
		collateral = collateralSearchList.getCpgnCollDataBeans();
	}
	else {
		collateralList = new CampaignCollateralListDataBean();
		DataBeanManager.activate(collateralList, request);
		collateral = collateralList.getCollateralList();
	}

	int numberOfCollateral = 0;
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
function newCollateral () {
	var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_COLLATERAL)) %>", url, true);
}

function collateralProperties () {
	var collateralId = -1;
	if (arguments.length > 0) {
		collateralId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (getListEditableFlag(checked[0]) == "Y") {
				collateralId = getListCollateralId(checked[0]);
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
		}
	}
	if (collateralId != -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog&collateralId=" + collateralId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_UPDATE_COLLATERAL)) %>", url, true);
	}
}

function summaryCollateral () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var collateralId = getListCollateralId(checked[0]);
		var collateralStoreId = getListStoreId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + collateralId + "&collateralStoreId=" + collateralStoreId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewDialogTitle")) %>", url, true);
	}
}

function deleteCollateral () {
	var checked = parent.getChecked();
	var isDeleting = false;
	if (checked.length > 0) {
		var collateralId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignCollateralDelete?collateralIds=";
		for (var i=0; i<checked.length; i++) {
			collateralId = getListCollateralId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += collateralId + ",";
				isDeleting = true;
			}
		}
		if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_COLLATERAL_LIST_DELETE_CONFIRMATION)) %>")) {
				parent.location.replace(url.substring(0, url.length-1));
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function findCollateral () {
<%	if ((request.getParameter("isContentSearch") != null) && (request.getParameter("isContentSearch").equals("Y"))) { %>
	top.goBack();
<%	} else { %>
	var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralFindDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralFindPanelTitle")) %>", url, true);
<%	} %>
}

function getResultsSize () {
	return <%= numberOfCollateral %>;
}

function getListCollateralId (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListStoreId (checkValue) {
	var sep1Index = checkValue.indexOf("|");
	var sep2Index = checkValue.substring(sep1Index+1, checkValue.length).indexOf("|") + sep1Index + 1;
	return checkValue.substring(sep1Index + 1, sep2Index);
}

function getListEditableFlag (checkValue) {
	var sep1Index = checkValue.indexOf("|");
	var sep2Index = checkValue.substring(sep1Index+1, checkValue.length).indexOf("|") + sep1Index + 1;
	return checkValue.substring(sep2Index + 1, checkValue.length);
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
<%= comm.addControlPanel("campaigns.CampaignCollateralList", totalpage, totalsize, jLocale) %>
<form name="collateralForm" id="collateralForm">
<%= comm.startDlistTable((String)campaignsRB.get("collateralListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
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
<%		if (collateralDb.getStoreId().equals(campaignCommandContext.getStoreId())) { %>
<%= comm.addDlistCheck(collateralDb.getId().toString() + "|" + collateralDb.getStoreId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(collateralDb.getCollateralName()), "javascript:collateralProperties(" + collateralDb.getId() + ")") %>
<%
		}
		else {
%>
<%= comm.addDlistCheck(collateralDb.getId().toString() + "|" + collateralDb.getStoreId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(collateralDb.getCollateralName()), "none") %>
<%
		}
		if (collateralDb.getCollateralType().intValue() == 2) {
%>
<%= comm.addDlistColumn((String)campaignsRB.get("collateralType2"), "none") %>
<%
		}
		else {
%>
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
<%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_LIST_EMPTY) %>
<%	} %>
</form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>