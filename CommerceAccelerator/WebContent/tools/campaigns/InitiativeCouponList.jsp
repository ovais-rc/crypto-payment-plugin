<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
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
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.ecoupon.ECouponPromotionListBean" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();

	ECouponPromotionListBean couponListBean = new ECouponPromotionListBean();
	int numberOfCoupon = 0;
	DataBeanManager.activate(couponListBean, request);
	if (couponListBean != null) {
		numberOfCoupon = couponListBean.getLength();
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function chooseCoupon () {
	var couponResult = new Object();

	// find the coupon id
	var checked = parent.getChecked();
	if (checked.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_LIST_EMPTY)) %>");
		return;
	}
	else if (checked.length == 1) {
		// add coupon id parameter
		couponResult.couponName = trim(checked[0]);
		top.sendBackData(couponResult, "couponResult");
	}
	else {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_LIST_TOO_MANY)) %>");
		return;
	}

	// go back to the previous panel
	top.goBack();
}

function cancelCoupon () {
	top.goBack();
}

function getResultsSize () {
	return <%= numberOfCoupon %>;
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

<body onload="onLoad();" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfCoupon;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("campaigns.InitiativeCouponList", totalpage, totalsize, jLocale) %>
<form name="initiativeCouponForm" id="initiativeCouponForm">
<%= comm.startDlistTable((String)campaignsRB.get("initiativeCouponListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_LIST_CODE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_LIST_DESCRIPTION_COLUMN), null, false) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfCoupon) {
		endIndex = numberOfCoupon;
	}

	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(couponListBean.getName(i), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(couponListBean.getName(i)), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(couponListBean.getDescription(i)), "none") %>
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

<%	if (numberOfCoupon == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_COUPON_EMPTY) %>
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