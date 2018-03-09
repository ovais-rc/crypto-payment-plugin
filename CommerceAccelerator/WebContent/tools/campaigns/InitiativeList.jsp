<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.server.ConfigProperties,
	com.ibm.commerce.server.ServerConfiguration,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeListCursorDataBean,
	com.ibm.commerce.tools.campaigns.CampaignSimpleListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.context.content.ContentContext,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.xml.XMLUtil,
	java.text.DateFormat,
	java.util.Vector,
	org.w3c.dom.Node" %>

<%@ include file="common.jsp" %>
<%@ include file="../bi/BINLS.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");
	String viewType = request.getParameter("viewType");
	String campaignId = request.getParameter("campaignId");
	// Added for Performance Improvement
	CampaignInitiativeListCursorDataBean initiativeList = new CampaignInitiativeListCursorDataBean();
	// Get the Start & the List Sizes from the XML
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;	
	// Initialized the Start & End Indices
	initiativeList.setIndexEnd(""+endIndex);
	initiativeList.setIndexBegin(""+startIndex);
	
	DataBeanManager.activate(initiativeList, request);
	CampaignInitiativeDataBean initiatives[] = initiativeList.getInitiativeList();
	int numberOfInitiatives = 0;
	int totalNumberOfInitiatives = 0;
	if (initiatives != null) {
		numberOfInitiatives = initiatives.length;
		totalNumberOfInitiatives = initiativeList.getResultSetSize();
	}

	// Set Up Paging
	int rowselect = 1;
	int totalpage = 0;
	if(listSize!=0){
		totalpage = totalNumberOfInitiatives/ listSize;
	}
	// Added for Performance Improvement
	CampaignSimpleListDataBean campaignList = new CampaignSimpleListDataBean();
	campaignList.setLocalSearch(true); // set flag to search for local entries only
	DataBeanManager.activate(campaignList, request);
	String [] campaignIdList = campaignList.getCampaignIdList();
	String [] campaignNameList = campaignList.getCampaignNameList();
	int numberOfCampaigns = campaignIdList.length;

	ConfigProperties theConfigProperties = ConfigProperties.singleton();
	String hostname = theConfigProperties.getValue("WebServer/HostName");
	String hostport = theConfigProperties.getValue("Websphere/ToolsPort");
	Node node = ServerConfiguration.singleton().getConfigCache("CommerceAccelerator");
	Hashtable configNode = (Hashtable) XMLUtil.processNode(node);
	String statisticsSource = (String) ((Hashtable)configNode.get("BusinessIntelligence")).get("StatisticsSource");
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, jLocale);

	String[] availableActivityView = CampaignUtil.getActivityViewByStoreType(campaignCommandContext.getStore().getStoreType());
	if (availableActivityView.length == 2) {
	   // have web and e-mail activities, check if this is under a workspace
	   ContentContext contentContext = (ContentContext)campaignCommandContext.getContext(ContentContext.NAME);
	   if (contentContext != null && contentContext.getWorkspaceData() != null) {
	      // in a workspace, so remove email activities. They are not content managed.
	      availableActivityView = new String[1];
		    availableActivityView[0] = CampaignConstants.INITIATIVE_LIST_WEB_VIEW;
	   }
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers

function showPreview ()
{
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=preview.PreviewDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("preview")) %>", url, true);
}

function newInitiative () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_INITIATIVE)) %>", url, true);
}

function initiativeProperties () {
	var initiativeId = -1;
	if (arguments.length > 0) {
		initiativeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (getListEditableFlag(checked[0]) == "Y") {
				initiativeId = getListInitiativeId(checked[0]);
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
		}
	}
	if (initiativeId != -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + initiativeId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_UPDATE_INITIATIVE)) %>", url, true);
	}
}

function copyInitiative () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var initiativeId = getListInitiativeId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + initiativeId + "&newInitiative=true";
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_INITIATIVE)) %>", url, true);
	}
}

function summaryInitiative () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var initiativeId = getListInitiativeId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSummaryDialog&initiativeId=" + initiativeId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryDialogTitle")) %>", url, true);
	}
}

function deleteInitiative () {
	var checked = parent.getChecked();
	var isDeleting = false;
	var viewType = getSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	var campaignId = getSelectValue(document.initiativeForm.initiativeCampaign);

	if (checked.length > 0) {
		var initiativeId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignInitiativeDelete?viewType=" + viewType + "&campaignId=" + campaignId + "&initiativeIds=";
		for (var i=0; i<checked.length; i++) {
			initiativeId = getListInitiativeId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += initiativeId + ",";
				isDeleting = true;
			}
		}
		if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_DELETE_CONFIRMATION)) %>")) {
				parent.location.replace(url.substring(0, url.length-1));
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function disableInitiative (statusValue) {
	var checked = parent.getChecked();
	var isModifying = false;
	var viewType = getSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	var campaignId = getSelectValue(document.initiativeForm.initiativeCampaign);

	if (checked.length > 0) {
		var initiativeId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignInitiativeDisable?viewType=" + viewType + "&campaignId=" + campaignId + "&initiativeIds=";
		for (var i=0; i<checked.length; i++) {
			initiativeId = getListInitiativeId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += initiativeId + ",";
				isModifying = true;
			}
		}
		if (isModifying) {
			url = url.substring(0, url.length-1);
			url += "&amp;<%= CampaignConstants.PARAMETER_INITIATIVE_STATUS %>=" + statusValue;
			parent.location.replace(url);
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
		}
	}
}

function resumeInitiative () {
	disableInitiative("");
}

function suspendInitiative () {
	disableInitiative("<%= CampaignConstants.INITIATIVE_STATUS_DISABLED %>");
}

function initiativeStatistics () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var initiativeId = getListInitiativeId(checked[0]);
		var hostname = "<%= hostname %>";
		var statisticsSource = "<%= statisticsSource %>";
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignInitiativeStatisticsView?XMLFile=campaigns.MIstatisticsDialog&cmd=MIstatisticsView&ActionXMLFile=campaigns.MIstatisticsXMLmap&intv_id=" + initiativeId;
		if (hostname != statisticsSource) {
			url = "https://" + statisticsSource + ":<%= hostport %><%= UIUtil.getWebappPath(request) %>CampaignInitiativeStatisticsView?XMLFile=campaigns.MIstatisticsRemoteDialog&remoteURL=/webapp/wcs/tools/servlet/CampaignInitiativeStatisticsRemoteView&cmd=MIstatisticsView&ActionXMLFile=campaigns.MIstatisticsXMLmap"+ "&" + "<%= CampaignConstants.PARAMETER_INTV_ID %>" + "=" + initiativeId + "&" +"<%= CampaignConstants.PARAMETER_PRODUCTION_SERVER %>"+ "="+ statisticsSource;
		}
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("MIstatisticsBrowserTitle")) %>", url, true);
	}
}

function initiativeReports () {
	var url = "<%= UIUtil.getWebappPath(request) %>ShowContextList?context=initiative&contextConfigXML=bi.biContext&ActionXMLFile=bi.biRptInitiativeContextList";
	top.setContent("<%= UIUtil.toJavaScript((String)biNLS.get("contextList")) %>", url, true);
}

function getResultsSize () {
	return <%= totalNumberOfInitiatives %>;
}

function getListInitiativeId (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListEditableFlag (checkValue) {
	return checkValue.substring(checkValue.indexOf("|") + 1, checkValue.length);
}

function getSelectValue (select) {
	return select.options[select.selectedIndex].value;
}

function loadSelectValue (select, value) {
	for (var i=0; i<select.length; i++) {
		if (select.options[i].value == value) {
			select.options[i].selected = true;
			return;
		}
	}
}

function changeListView () {
	var viewType = getSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	var campaignId = getSelectValue(document.initiativeForm.initiativeCampaign);
	if (viewType == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignInitiativesView?ActionXMLFile=campaigns.InitiativeList&cmd=CampaignInitiativeListView&orderby=name&viewType=" + viewType + "&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeListTitle")) %>", url, false);
	}
	else if (viewType == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=emailactivity.EmailActivityList&cmd=EmailActivityListView&orderby=name&viewType=" + viewType + "&campaignId=" + campaignId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeListTitle")) %>", url, false);
	}
}

function onLoad () {
	loadSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>, "<%=UIUtil.toJavaScript( viewType )%>");
	loadSelectValue(document.initiativeForm.initiativeCampaign, "<%=UIUtil.toJavaScript( campaignId )%>");

	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad()" class="content_list">
<%= comm.addControlPanel("campaigns.InitiativeList", listSize, totalNumberOfInitiatives, jLocale) %>
<form name="initiativeForm" id="initiativeForm">

<table border="0" cellpadding="0" cellspacing="0" id="WC_InitiativeList_Table_1">
	<tr>
		<td id="WC_InitiativeList_TableCell_1">
			<label for="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>"><%= campaignsRB.get("initiativeListTypeView") %></label><br/>
			<select name="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>" id="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>" onchange="changeListView()">
<%	if (availableActivityView.length > 0) { %>
				<option value="<%= availableActivityView[0] %>" selected><%= campaignsRB.get(availableActivityView[0]) %></option>
<%		for (int i=1; i<availableActivityView.length; i++) { %>
				<option value="<%= availableActivityView[i] %>"><%= campaignsRB.get(availableActivityView[i]) %></option>
<%
		}
	}
%>
			</select>
		</td>
		<td width="20" id="WC_InitiativeList_TableCell_2">&nbsp;</td>
		<td id="WC_InitiativeList_TableCell_3">
			<label for="initiativeCampaign"><%= campaignsRB.get("initiativeListCampaignView") %></label><br/>
			<select name="initiativeCampaign" id="initiativeCampaign" onchange="changeListView()">
				<option value="" selected><%= campaignsRB.get(CampaignConstants.MSG_ALL_CAMPAIGN) %></option>
<%	for (int i=0; i<numberOfCampaigns; i++) { %>
				<option value="<%= campaignIdList[i] %>"><%= UIUtil.toHTML(campaignNameList[i]) %></option>
<%	} %>
			</select>
		</td>
	</tr>
</table>
<br/>

<%= comm.startDlistTable((String)campaignsRB.get("initiativeListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm), "75", false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TYPE_COLUMN), CampaignConstants.ORDER_BY_TYPE, CampaignConstants.ORDER_BY_TYPE.equals(orderByParm), "100", false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_CAMPAIGN_COLUMN), CampaignConstants.ORDER_BY_CAMPAIGN, CampaignConstants.ORDER_BY_CAMPAIGN.equals(orderByParm), "100", false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_STATUS_COLUMN), CampaignConstants.ORDER_BY_STATUS, CampaignConstants.ORDER_BY_STATUS.equals(orderByParm), "75", false) %>
<%= comm.endDlistRow() %>
<%
	for (int i= 0 ; i<numberOfInitiatives; i++) {
		CampaignInitiativeDataBean initiative = initiatives[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (initiative.getStoreId().equals(campaignCommandContext.getStoreId())) { %>
<%= comm.addDlistCheck(initiative.getId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getInitiativeName()), "javascript:initiativeProperties(" + initiative.getId() + ")") %>
<%		} else { %>
<%= comm.addDlistCheck(initiative.getId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getInitiativeName()), "none") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)campaignsRB.get(initiative.getContentType())), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getCampaignName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)campaignsRB.get(initiative.getStatus())), "none") %>
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
<%	if (numberOfInitiatives == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_EMPTY) %>
<%	} %>
</form>

<script>
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
parent.setButtonPos("0px", "54px");
//-->
</script>

</body>

</html>
