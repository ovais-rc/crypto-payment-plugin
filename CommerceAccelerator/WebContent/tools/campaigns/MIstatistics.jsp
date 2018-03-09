<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.marketingcenter.events.databeans.CampaignStatisticsBean,
	com.ibm.commerce.marketingcenter.events.databeans.CampaignStatisticsListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.util.*" %>

<%@ include file="common.jsp" %>

<jsp:useBean id="campaignStatsList" beanName="com.ibm.commerce.marketingcenter.events.databeans.CampaignStatisticsListDataBean" type="com.ibm.commerce.marketingcenter.events.databeans.CampaignStatisticsListDataBean">
<jsp:setProperty name="campaignStatsList" property="*"/>
<%	DataBeanManager.activate(campaignStatsList, request); %>
</jsp:useBean>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignStatisticsBean campaignsStats[] = null;
	int numberOfStats = 0;
	campaignsStats = campaignStatsList.getStatsDataBeanList();
	if (campaignsStats != null) {
		numberOfStats = campaignsStats.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function getInitiativeId () {
	return <%=(request.getParameter(CampaignConstants.PARAMETER_INTV_ID) == null ? null : UIUtil.toJavaScript(request.getParameter(CampaignConstants.PARAMETER_INTV_ID)))%>;
}

function getCampaignId () {
	return <%=(request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID) == null ? null : UIUtil.toJavaScript(request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID)))%>;
}

function returnToInitiatives () {
	if (top.goBack) {
		top.goBack();
	}
	else {
		parent.location.replace("<%= CampaignConstants.URL_CAMPAIGN_INITIATIVES_VIEW %>" + "<%=UIUtil.toJavaScript( request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID) )%>");
	}
}

function onLoad () {
	parent.loadFrames();

	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
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
	int totalsize = numberOfStats;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("campaigns.MIstatisticsXMLmap", totalpage, totalsize, jLocale) %>
<form name="campaignStatsForm" id="campaignStatsForm">
<input type="hidden" name="<%= CampaignConstants.PARAMETER_INTV_ID %>" value="<%=UIUtil.toHTML( request.getParameter(CampaignConstants.PARAMETER_INTV_ID) )%>" id="WC_MIstatistics_FormInput_<%= CampaignConstants.PARAMETER_INTV_ID %>_In_campaignStatsForm_1"/>
<input type="hidden" name="<%= CampaignConstants.PARAMETER_CAMPAIGN_ID %>" value="<%=UIUtil.toHTML( request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID) )%>" id="WC_MIstatistics_FormInput_<%= CampaignConstants.PARAMETER_CAMPAIGN_ID %>_In_campaignStatsForm_1"/>
<%= comm.startDlistTable((String)campaignsRB.get("MIstatisticsSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_STATISTICS_PAGE_ELEMENT), CampaignConstants.ORDER_BY_PAGE_ELEMENT, CampaignConstants.ORDER_BY_PAGE_ELEMENT.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_STATISTICS_VIEWS), CampaignConstants.ORDER_BY_VIEWS, CampaignConstants.ORDER_BY_VIEWS.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_STATISTICS_CLICKS), CampaignConstants.ORDER_BY_CLICKS, CampaignConstants.ORDER_BY_CLICKS.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_STATISTICS_RATIO), null, false) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfStats) {
		endIndex = numberOfStats;
	}

	CampaignStatisticsBean campaignStat;
	int viewTotal = 0;
	int clickTotal = 0;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		campaignStat = campaignsStats[i];
		viewTotal = campaignStat.getViewCountAsInteger().intValue();
		clickTotal = campaignStat.getClickCountAsInteger().intValue();
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaignStat.getMpeName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaignStat.getViewCount()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(campaignStat.getClickCount()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(String.valueOf(Math.round(clickTotal * 100/viewTotal))), "none") %>
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
<%	if (numberOfStats == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_STATISTICS_NO_STATS_FOUND) %>
<%	} %>
</form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(<%= numberOfStats %>);
//-->
</script>

</body>

</html>
