<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

<%@ page import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
function init () {
	document.collateralFindForm.collateralName.focus();
}

function findAction () {
	// get the search strings from the fields
	var nameSearchString = document.collateralFindForm.collateralName.value;
	var marketingTextSearchString = document.collateralFindForm.collateralMarketingText.value;
	var fileNameSearchString = document.collateralFindForm.collateralFileName.value;
	var nameSearchType = document.collateralFindForm.collateralNameSearchType.options[document.collateralFindForm.collateralNameSearchType.selectedIndex].value;
	var marketingTextSearchType = document.collateralFindForm.collateralMarketingTextSearchType.options[document.collateralFindForm.collateralMarketingTextSearchType.selectedIndex].value;
	var fileNameSearchType = document.collateralFindForm.collateralFileNameSearchType.options[document.collateralFindForm.collateralFileNameSearchType.selectedIndex].value;
	var clickActionValue = document.collateralFindForm.collateralClickAction.options[document.collateralFindForm.collateralClickAction.selectedIndex].value;
	var numberOfResultValue = document.collateralFindForm.collateralNumberOfResult.options[document.collateralFindForm.collateralNumberOfResult.selectedIndex].value;

	// make sure at least one field has been filled
	if (isEmpty(nameSearchString) && isEmpty(marketingTextSearchString) && isEmpty(fileNameSearchString) && isEmpty(clickActionValue)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtLeastOneSearchCriteria")) %>");
		return;
	}

	// create the base URL
	var url = "NewDynamicListView";
	var urlparm = new Object();
	urlparm.ActionXMLFile = "campaigns.CampaignCollateralList";
	urlparm.cmd = "CampaignCollateralListView";
	urlparm.nameSearchString = nameSearchString;
	urlparm.marketingTextSearchString = marketingTextSearchString;
	urlparm.fileNameSearchString = fileNameSearchString;
	urlparm.nameSearchType = nameSearchType;
	urlparm.marketingTextSearchType = marketingTextSearchType;
	urlparm.fileNameSearchType = fileNameSearchType;
	urlparm.clickActionValue = clickActionValue;
	urlparm.numberOfResultValue = numberOfResultValue;
	urlparm.isContentSearch = "Y";
	top.saveData("Y", "isContentSearch");
	top.setContent("<%= UIUtil.toJavaScript(campaignsRB.get("collateralSearchResultPanelTitle")) %>", url, true, urlparm);
}

function cancelAction () {
	cancelForm();
}
//-->
</script>
