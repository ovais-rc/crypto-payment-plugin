<!-- ========================================================================
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
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.server.ConfigProperties,
	com.ibm.commerce.server.ServerConfiguration,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignDataBean,
	com.ibm.commerce.tools.campaigns.CampaignListCursorDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	java.text.DateFormat,
	org.w3c.dom.Node" %>

<%@ include file="common.jsp" %>
<%@ include file="../bi/BINLS.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignListCursorDataBean campaignList = new CampaignListCursorDataBean();
	// Get the Start & End Index from the XML file
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	// Initialize the Start & End Indices
	campaignList.setIndexEnd(""+endIndex);
	campaignList.setIndexBegin(""+startIndex);
	
	DataBeanManager.activate(campaignList, request);
	CampaignDataBean campaigns[] = campaignList.getCampaignList();
	int numberOfCampaigns = 0;
	int totalNumberOfCampaigns = 0;
	
	if (campaigns != null) {
		numberOfCampaigns = campaigns.length;
		totalNumberOfCampaigns = campaignList.getResultSetSize();
	}
	// set up paging
	int rowselect = 1;
	int totalpage = 0;
	if(listSize != 0){
		totalpage = totalNumberOfCampaigns / listSize;
	}
	
	ConfigProperties theConfigProperties = ConfigProperties.singleton();
	String hostname = theConfigProperties.getValue("WebServer/HostName");
	Node node = ServerConfiguration.singleton().getConfigCache("CommerceAccelerator");
	Hashtable configNode = (Hashtable) XMLUtil.processNode(node);
	String statisticsSource = (String) ((Hashtable)configNode.get("BusinessIntelligence")).get("StatisticsSource");
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, jLocale);
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function newCampaign () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_CAMPAIGN)) %>", url, true);
}

function campaignProperties () {
	var campaignId = -1;
	if (arguments.length > 0) {
		campaignId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (getListEditableFlag(checked[0]) == "Y") {
				campaignId = getListCampaignId(checked[0]);
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
		}
	}
	if (campaignId != -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignDialog&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_UPDATE_CAMPAIGN)) %>", url, true);
	}
}

function summaryCampaign () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var campaignId = getListCampaignId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignSummaryDialog&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_SUMMARY_DIALOG_TITLE)) %>", url, true);
	}
}

function deleteCampaign () {
	var checked = parent.getChecked();
	var isDeleting = false;
	if (checked.length > 0) {
		var campaignId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignDelete?campaignIds=";
		for (var i=0; i<checked.length; i++) {
			campaignId = getListCampaignId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += campaignId + ",";
				isDeleting = true;
			}
		}
		if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_DELETE_CONFIRMATION)) %>")) {
				parent.location.replace(url.substring(0, url.length-1));
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function reportCampaigns () {
	var url = "<%= UIUtil.getWebappPath(request) %>ShowContextList?context=campaign&contextConfigXML=bi.biContext&ActionXMLFile=bi.biRptCampaignContextList";
	top.setContent("<%= UIUtil.toJavaScript((String)biNLS.get("contextList")) %>", url, true);
}

function getResultsSize () {
	return <%= totalNumberOfCampaigns %>;
}

function getListCampaignId (checkValue) {
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
<%= comm.addControlPanel("campaigns.CampaignList", listSize, totalNumberOfCampaigns, jLocale) %>
<form name="campaignForm" id="campaignForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_INITIATIVE_NUMBER_COLUMN), CampaignConstants.ORDER_BY_INITIATIVE_NUMBER, CampaignConstants.ORDER_BY_INITIATIVE_NUMBER.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	for (int i=0; i<numberOfCampaigns; i++) {
		CampaignDataBean campaign = campaigns[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (campaign.getStoreId().equals(campaignCommandContext.getStoreId())) { %>
<%= comm.addDlistCheck(campaign.getId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaign.getCampaignName()), "javascript:campaignProperties(" + campaign.getId() + ")") %>
<%		} else { %>
<%= comm.addDlistCheck(campaign.getId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaign.getCampaignName()), "none") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaign.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaign.getNumberOfInitiative().toString()), "none") %>
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
<%	if (numberOfCampaigns == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_EMPTY) %>
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