<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004, 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<%@ page import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<%
	String[] urlArray;
	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("Coupon")) {
		urlArray = CampaignConstants.collateralUrlArrayWithCoupon;
	}
	else {
		urlArray = CampaignConstants.collateralUrlArray;
	}
%>

<script language="JavaScript">
<!-- hide script from old browsers
function gotoCommandParameterDialog (paramValue) {
	var url;
	var urlTitle;

	// save the panel data
	isSavingCollateral = false;
	_saveFormData();

	// set flag to record that we are going on a product finder, category list or coupon list
	if (paramValue == "searchProduct") {
		top.saveData("productSingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog";
		urlTitle = "<%= campaignsRB.get("productFindPanelTitle") %>";
	}
	else if (paramValue == "searchSku") {
		top.saveData("itemSingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog";
		urlTitle = "<%= campaignsRB.get("productFindPanelTitle") %>";
	}
	else if (paramValue == "browseProduct") {
		// save parameter to be used in dynamic tree
		var param = new Object();
		param.catalogId = "";
		param.categoryId = "";

		// set flag to record that we are going on a product browser
		param.selectionType = "CE";
		param.locationType = "allType";
		top.saveData("productSingle", "searchType");

		// set url properties
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ProductBrowseDialog";
		urlTitle = "<%= campaignsRB.get("ProductBrowsePanelTitle") %>";

		// save the panel settings
		top.saveData(param, "browseParameters");
		top.saveData(false, "allowMultiple");
	}
	else if (paramValue == "browseSku") {
		// save parameter to be used in dynamic tree
		var param = new Object();
		param.catalogId = "";
		param.categoryId = "";

		// set flag to record that we are going on a product browser
		param.selectionType = "CE";
		param.locationType = "itemType";
		top.saveData("itemSingle", "searchType");

		// set url properties
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ProductBrowseDialog";
		urlTitle = "<%= campaignsRB.get("ProductBrowsePanelTitle") %>";

		// save the panel settings
		top.saveData(param, "browseParameters");
		top.saveData(false, "allowMultiple");
	}
	else if (paramValue == "listCategory") {
		top.saveData("categorySingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CategoryDialog";
		urlTitle = "<%= campaignsRB.get("CategoryListDialogTitle") %>";
	}
	else if (paramValue == "listCoupon") {
		top.saveData("coupon", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeCouponDialog";
		urlTitle = "<%= campaignsRB.get("initiativeCouponPanelTitle") %>";
	}

	top.setContent(urlTitle, url, true);
}
//-->
</script>

<%	if (request.getParameter(CampaignConstants.PARAMETER_COLLATERAL_ID) != null) { %>
<input name="<%= CampaignConstants.ELEMENT_ID %>" type="hidden" value="<%=UIUtil.toHTML( request.getParameter(CampaignConstants.PARAMETER_COLLATERAL_ID) )%>" id="WC_CollateralURLSegment_FormInput_<%= CampaignConstants.ELEMENT_ID %>_1"/>
<%	} %>
<input name="<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>" type="hidden" id="WC_CollateralURLSegment_FormInput_<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>_1"/>
<input name="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>" type="hidden" id="WC_CollateralURLSegment_FormInput_<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>_1"/>

<p/><label for="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>"><%= campaignsRB.get("collateralClickActionPrompt") %></label><br/>
<select name="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>" id="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>" onchange="showDivisions()">
	<option value="none"><%= campaignsRB.get("collateralClickActionNoActionRequired") %></option>
	<option value="command"><%= campaignsRB.get("collateralClickActionCommand") %></option>
	<option value="custom"><%= campaignsRB.get("collateralClickActionCustom") %></option>
</select>

<!-- start url command section -->
<div id="commandUrlDiv" style="display: none; margin-left: 20">
<br/>
<table border="0" cellspacing="3" cellpadding="3" id="WC_CollateralURLSegment_Table_1">
	<tbody><tr><td id="WC_CollateralURLSegment_TableCell_1">
		<label for="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>"><%= campaignsRB.get("collateralUrlCommandPrompt") %></label>
		<br/>
		<select name="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>" id="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>" onchange="javascript:updateCollateralUrl();">
<%	for (int i=0; i<urlArray.length; i++) { %>
			<option value="<%= urlArray[i] %>"><%= campaignsRB.get("collateralUrl" + urlArray[i]) %></option>
<%	} %>
		</select>
	</td></tr>
	<tr><td id="WC_CollateralURLSegment_TableCell_2">
		<!-- start product command section -->
		<div id="commandProductDiv" style="display: none">
			<label for="urlCommandProduct"><%= campaignsRB.get("collateralUrlProductPrompt") %></label>
			<br/>
			<table border="0" cellpadding="0" cellspacing="0" id="WC_CollateralURLSegment_Table_2">
				<tbody><tr>
					<td valign="top" id="WC_CollateralURLSegment_TableCell_3">
						<input name="urlCommandProduct" type="text" size="50" maxlength="254" readonly="readonly" id="urlCommandProduct" />
						&nbsp;
						<button type="button" name="searchButton" value="searchProduct" class="enabled" onclick="gotoCommandParameterDialog('searchProduct');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_FIND_ELLIPSIS) %></button>
						&nbsp;
						<button type="button" name="browseButton" value="browseProduct" class="enabled" onclick="gotoCommandParameterDialog('browseProduct');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_BROWSE_ELLIPSIS) %></button>
					</td>
				</tr></tbody>
			</table>
		</div>
		<!-- end product command section -->
		<!-- start item command section -->
		<div id="commandItemDiv" style="display: none">
			<label for="urlCommandItem"><%= campaignsRB.get("collateralUrlItemPrompt") %></label>
			<br/>
			<table border="0" cellpadding="0" cellspacing="0" id="WC_CollateralURLSegment_Table_3">
				<tbody><tr>
					<td valign="top" id="WC_CollateralURLSegment_TableCell_4">
						<input name="urlCommandItem" type="text" size="50" maxlength="254" readonly="readonly" id="urlCommandItem" />
						&nbsp;
						<button type="button" name="searchButton" value="searchSKU" class="enabled" onclick="gotoCommandParameterDialog('searchSku');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_FIND_ELLIPSIS) %></button>
						&nbsp;
						<button type="button" name="browseButton" value="browseSKU" class="enabled" onclick="gotoCommandParameterDialog('browseSku');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_BROWSE_ELLIPSIS) %></button>
					</td>
				</tr></tbody>
			</table>
		</div>
		<!-- end item command section -->
		<!-- start category command section -->
		<div id="commandCategoryDiv" style="display: none">
			<label for="urlCommandCategory"><%= campaignsRB.get("collateralUrlCategoryPrompt") %></label>
			<br/>
			<table border="0" cellpadding="0" cellspacing="0" id="WC_CollateralURLSegment_Table_4">
				<tbody><tr>
					<td valign="top" id="WC_CollateralURLSegment_TableCell_5">
						<input name="urlCommandCategory" type="text" size="50" maxlength="254" readonly="readonly" id="urlCommandCategory" />
						&nbsp;
						<button type="button" name="listCategoryButton" value="listCategory" class="enabled" onclick="gotoCommandParameterDialog('listCategory');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_LIST_ELLIPSIS) %></button>
					</td>
				</tr></tbody>
			</table>
		</div>
		<!-- end category command section -->
		<!-- start coupon command section -->
		<div id="commandCouponDiv" style="display: none">
			<label for="urlCommandCoupon"><%= campaignsRB.get("collateralUrlCouponPrompt") %></label>
			<br/>
			<table border="0" cellpadding="0" cellspacing="0" id="WC_CollateralURLSegment_Table_5">
				<tbody><tr>
					<td valign="top" id="WC_CollateralURLSegment_TableCell_6">
						<input name="urlCommandCoupon" type="text" size="50" maxlength="254" readonly="readonly" id="urlCommandCoupon" />
						&nbsp;
						<button type="button" name="listCouponButton" value="listCoupon" class="enabled" onclick="gotoCommandParameterDialog('listCoupon');"><%= campaignsRB.get(CampaignConstants.MSG_BUTTON_LIST_ELLIPSIS) %></button>
					</td>
				</tr></tbody>
			</table>
		</div>
		<!-- end coupon command section -->
	</td></tr></tbody>
</table>
</div>
<!-- end url command section -->

<!-- start custom url section -->
<div id="customUrlDiv" style="display: none; margin-left: 20">
<br/>
<table border="0" cellspacing="3" cellpadding="3" id="WC_CollateralURLSegment_Table_6">
	<tbody><tr><td id="WC_CollateralURLSegment_TableCell_11">
		<label for="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>"><%= campaignsRB.get("collateralUrlPrompt") %></label>
		<br/>
		<input name="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>" type="text" size="50" maxlength="254" id="<%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>" />
	</td></tr></tbody>
</table>
</div>
<!-- end custom url section -->
