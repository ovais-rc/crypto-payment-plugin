<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
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
	com.ibm.commerce.fulfillment.beans.CalculationCodeDataBean,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeDataBean,
	com.ibm.commerce.tools.campaigns.CampaignSimpleListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.epromotion.databeans.RLPromotionBean,
	com.ibm.commerce.tools.epromotion.databeans.RLPromotionListBean,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.utils.TimestampHelper,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	// initialize variables in this page
	String loginLanguageId = campaignCommandContext.getLanguageId().toString();
	java.sql.Timestamp currentTime = new java.sql.Timestamp(new java.util.Date().getTime());

	// get parameters from request object
	String fromPanel = request.getParameter("fromPanel");
	String campaignName = request.getParameter("campaignName");
	String emsName = request.getParameter("emsName");

	// initialize campaign data bean to populate the campaign drop-down
	CampaignSimpleListDataBean campaignList = new CampaignSimpleListDataBean();
	campaignList.setLocalSearch(true); // set flag to search for local entries only
	DataBeanManager.activate(campaignList, request);
	String [] campaignIdList = campaignList.getCampaignIdList();
	String [] campaignNameList = campaignList.getCampaignNameList();
	int numberOfCampaigns = campaignIdList.length;

	// get the proper URL array from the constants class
	String[] whatTypeArray;
	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("Coupon")) {
		whatTypeArray = CampaignConstants.whatTypeArrayWithCoupon;
	}
	else {
		whatTypeArray = CampaignConstants.whatTypeArray;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<style type="text/css">
.selectWidth {
	width: 350px;
}
.sloshBucketWidth {
	width: 250px;
}
.disabledBox {
	background: #c0c0c0;
}
.enabledBox {
	background: #ffffff;
}
</style>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_PANEL_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Initiative.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/SwapList.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
//
// set variables that are used throughout this panel
//
var isPromotionLoaded = false;
var isCouponLoaded = false;
var isCollateralLoaded = false;

//
// retrieve the model persisted in the previous action
//
if (top.getData("initiativeModel", null) != null) {
	parent.model = top.getData("initiativeModel");
	top.saveData(null, "initiativeModel");
}

//
// retrieve the initiative data bean
//
var initiativeDataBean = null;
if (parent.get) {
	initiativeDataBean = parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
}

//
// override data in initiative data bean using the data object from the marketing
// experimentation tool, if any
//
var experimentSelectedElement = top.getData("experimentSelectedElement", 1);
if (initiativeDataBean != null && experimentSelectedElement != null) {
	var isPromotionCollateralProcessed = false;
	var isProductProcessed = false;
	var isCategoryProcessed = false;
	var isCollateralProcessed = false;
	var isSegmentProcessed = false;
	for (var i=0; i<experimentSelectedElement.length; i++) {
		if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>";
			initiativeDataBean.selectedDiscountUsage = experimentSelectedElement[i].objectIdentifier;
			initiativeDataBean.selectedDiscountCode = experimentSelectedElement[i].objectName;
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION_COLLATERAL %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>";

			// if promotion collateral data is processed for the first time, clear the selected
			// promotion collateral list first
			if (!isPromotionCollateralProcessed) {
				initiativeDataBean.selectedDiscountCollateral = new Array();
				isPromotionCollateralProcessed = true;
			}

			// append the promotion collateral into the selected promotion collateral list
			var newPromotionCollateralObject = new Object();
			newPromotionCollateralObject.collateralID = experimentSelectedElement[i].objectId;
			newPromotionCollateralObject.name = experimentSelectedElement[i].objectName;
			newPromotionCollateralObject.storeID = experimentSelectedElement[i].objectStoreId;
			initiativeDataBean.selectedDiscountCollateral[initiativeDataBean.selectedDiscountCollateral.length] = newPromotionCollateralObject;

/*
			// if promotion collateral data is processed for the first time, clear the selected
			// promotion collateral list first
			if (!isPromotionCollateralProcessed) {
				for (var j=0; j<initiativeDataBean.selectedDiscountCollateral.length; j++) {
					initiativeDataBean.availableDiscountCollateral[initiativeDataBean.availableDiscountCollateral.length] = initiativeDataBean.selectedDiscountCollateral[j];
				}
				initiativeDataBean.selectedDiscountCollateral = new Array();
				isPromotionCollateralProcessed = true;
			}

			// remove the current promotion collateral in the available promotion collateral list
			// if it is found, otherwise append it to the selected promotion collateral list
			var newAvailableDiscountCollateral = new Array();
			var currentIndex = 0;
			for (var j=0; j<initiativeDataBean.availableDiscountCollateral.length; j++) {
				if (experimentSelectedElement[i].objectId != initiativeDataBean.availableDiscountCollateral[j].collateralID) {
					newAvailableDiscountCollateral[currentIndex] = initiativeDataBean.availableDiscountCollateral[j];
					currentIndex++;
				}
				else {
					initiativeDataBean.selectedDiscountCollateral[initiativeDataBean.selectedDiscountCollateral.length] = initiativeDataBean.availableDiscountCollateral[j];
				}
			}
			initiativeDataBean.availableDiscountCollateral = newAvailableDiscountCollateral;
*/
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>";

			// if product data is processed for the first time, clear the selected product list first
			if (!isProductProcessed) {
				initiativeDataBean.productSkus = new Array();
				initiativeDataBean.productNames = new Array();
				isProductProcessed = true;
			}

			// append the product into the selected product list
			initiativeDataBean.productSkus[initiativeDataBean.productSkus.length] = experimentSelectedElement[i].objectIdentifier;
			initiativeDataBean.productNames[initiativeDataBean.productNames.length] = experimentSelectedElement[i].objectName + " (" + experimentSelectedElement[i].objectIdentifier + ")";
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>";

			// if category data is processed for the first time, clear the selected category list first
			if (!isCategoryProcessed) {
				initiativeDataBean.selectedCategories = new Array();
				initiativeDataBean.selectedCategoriesNames = new Array();
				isCategoryProcessed = true;
			}

			// append the category into the selected category list
			initiativeDataBean.selectedCategories[initiativeDataBean.selectedCategories.length] = experimentSelectedElement[i].objectIdentifier;
			initiativeDataBean.selectedCategoriesNames[initiativeDataBean.selectedCategoriesNames.length] = experimentSelectedElement[i].objectName;
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>";

			// if collateral data is processed for the first time, clear the selected collateral list first
			if (!isCollateralProcessed) {
				initiativeDataBean.selectedCollateral = new Array();
				isCollateralProcessed = true;
			}

			// append the collateral into the selected collateral list
			var newCollateralObject = new Object();
			newCollateralObject.collateralID = experimentSelectedElement[i].objectId;
			newCollateralObject.name = experimentSelectedElement[i].objectName;
			newCollateralObject.storeID = experimentSelectedElement[i].objectStoreId;
			initiativeDataBean.selectedCollateral[initiativeDataBean.selectedCollateral.length] = newCollateralObject;

/*
			// if collateral data is processed for the first time, clear the selected collateral list first
			if (!isCollateralProcessed) {
				for (var j=0; j<initiativeDataBean.selectedCollateral.length; j++) {
					initiativeDataBean.availableCollateral[initiativeDataBean.availableCollateral.length] = initiativeDataBean.selectedCollateral[j];
				}
				initiativeDataBean.selectedCollateral = new Array();
				isCollateralProcessed = true;
			}

			// remove the current collateral in the available collateral list if it is found, otherwise
			// append it to the selected collateral list
			var newAvailableCollateral = new Array();
			var currentIndex = 0;
			for (var j=0; j<initiativeDataBean.availableCollateral.length; j++) {
				if (experimentSelectedElement[i].objectId != initiativeDataBean.availableCollateral[j].collateralID) {
					newAvailableCollateral[currentIndex] = initiativeDataBean.availableCollateral[j];
					currentIndex++;
				}
				else {
					initiativeDataBean.selectedCollateral[initiativeDataBean.selectedCollateral.length] = initiativeDataBean.availableCollateral[j];
				}
			}
			initiativeDataBean.availableCollateral = newAvailableCollateral;
*/
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>";
			initiativeDataBean.sellContentType = experimentSelectedElement[i].objectId;
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL %>") {
			initiativeDataBean.whatType = "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>";
			initiativeDataBean.sellContentType = experimentSelectedElement[i].objectId;
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SEGMENT %>") {
			// if segment data is processed for the first time, clear the selected segment list first
			if (!isSegmentProcessed) {
				for (var j=0; j<initiativeDataBean.selectedSegmentIds.length; j++) {
					initiativeDataBean.availableSegmentIds[initiativeDataBean.availableSegmentIds.length] = initiativeDataBean.selectedSegmentIds[j];
					initiativeDataBean.availableSegments[initiativeDataBean.availableSegments.length] = initiativeDataBean.selectedSegments[j];
				}
				initiativeDataBean.selectedSegmentIds = new Array();
				initiativeDataBean.selectedSegments = new Array();
				isSegmentProcessed = true;
			}

			// append the current segment into the selected segment list
			initiativeDataBean.targetAllShoppers = false;
			initiativeDataBean.selectedSegmentIds[initiativeDataBean.selectedSegmentIds.length] = experimentSelectedElement[i].objectId;
			initiativeDataBean.selectedSegments[initiativeDataBean.selectedSegments.length] = experimentSelectedElement[i].objectName;

			// remove the current segment in the available segment list if it is found
			var newAvailableSegmentIds = new Array();
			var newAvailableSegments = new Array();
			var currentIndex = 0;
			for (var j=0; j<initiativeDataBean.availableSegmentIds.length; j++) {
				if (experimentSelectedElement[i].objectId != initiativeDataBean.availableSegmentIds[j]) {
					newAvailableSegmentIds[currentIndex] = initiativeDataBean.availableSegmentIds[j];
					newAvailableSegments[currentIndex] = initiativeDataBean.availableSegments[j];
					currentIndex++;
				}
			}
			initiativeDataBean.availableSegmentIds = newAvailableSegmentIds;
			initiativeDataBean.availableSegments = newAvailableSegments;
		}
		else if (experimentSelectedElement[i].objectType == "<%= com.ibm.commerce.tools.experimentation.ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>") {
			// remove existing schedules on the selected e-marketing spot
			var scheduleListData = initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %>;
			for (var j=0; j<scheduleListData.length; j++) {
				if (scheduleListData[j].emsId == experimentSelectedElement[i].objectId) {
					if (scheduleListData[j].storeId == "" || scheduleListData[j].storeId == "<%= campaignCommandContext.getStoreId() %>") {
						if (scheduleListData[j].actionFlag == "<%= CampaignConstants.ACTION_FLAG_CREATE %>") {
							scheduleListData[j].actionFlag = "<%= CampaignConstants.ACTION_FLAG_DESTROY %>";
						}
						else {
							scheduleListData[j].actionFlag = "<%= CampaignConstants.ACTION_FLAG_DELETE %>";
						}
					}
				}
			}
			initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %> = scheduleListData;

			// add new schedule to the e-marketing spot search result list
			if (experimentSelectedElement[i].objectActionType == null || experimentSelectedElement[i].objectActionType != "remove") {
				var emsResult = new Array();
				emsResult[0] = new Object();
				emsResult[0].emsId = experimentSelectedElement[i].objectId;
				emsResult[0].emsName = experimentSelectedElement[i].objectName;
				emsResult[0].emsStoreId = experimentSelectedElement[i].objectStoreId;
				top.saveData(emsResult, "emsResult");
			}
		}
	}
	top.sendBackData(null, "experimentSelectedElement", 1);
}

//
// start: populate promotion data into list box
//
var promotionDataContainer = new Array();
var promotionDataIndex = 0;
<%
	// initialize promotion data bean to populate the promotion list box
	int numberOfDiscount = 0;
	RLPromotionListBean rlDiscountListBean = new RLPromotionListBean();

	rlDiscountListBean.setParm("groupName", "allList");
	DataBeanManager.activate(rlDiscountListBean, request);
	if (rlDiscountListBean != null) {
		numberOfDiscount = rlDiscountListBean.getListSize();
	}

	// loop through each promotion for details
	for (int i=0; i<numberOfDiscount; i++) {
		String discountId = "";
		String discountName = "";
		String discountUsage = "";
		String discountStoreId = null;
		Vector dtcg = new Vector();

		// get calculation code usage from the calcode data bean by server team
		CalculationCodeDataBean ccdb = new CalculationCodeDataBean();

		// use different beans between rule based or schema based discount
		try {
			// populate the calculation code data bean
			ccdb.setInitKey_calculationCodeId(rlDiscountListBean.getCalcode_Id(i));
			DataBeanManager.activate(ccdb, request);

			// get member group from rule based discount bean
			RLPromotionBean rlpb = new RLPromotionBean();
			rlpb.setCalCodeId(rlDiscountListBean.getCalcode_Id(i));
			DataBeanManager.activate(rlpb, request);

			// set each field for this discount entry
			discountId = rlDiscountListBean.getCalcode_Id(i);
			discountName = rlDiscountListBean.getCode(i);
			discountUsage = ccdb.getCalculationUsageId();
			discountStoreId = ccdb.getStoreEntityId();
			dtcg = rlpb.getMemberGroupName();
		}
		catch (Exception e) {
			// error occurred while retrieving promotion details, skip this one
			continue;
		}
%>
promotionDataContainer[promotionDataIndex] = new Object();
promotionDataContainer[promotionDataIndex].discountId = "<%= discountId %>";
promotionDataContainer[promotionDataIndex].discountName = "<%= UIUtil.toJavaScript(discountName) %>";
promotionDataContainer[promotionDataIndex].discountUsage = "<%= discountUsage %>";
promotionDataContainer[promotionDataIndex].discountStoreId = "<%= discountStoreId %>";
promotionDataContainer[promotionDataIndex].discountTargetGroup = new Array();
<%
		for (int j=0; j<dtcg.size(); j++) {
%>
promotionDataContainer[promotionDataIndex].discountTargetGroup[<%= j %>] = "<%= UIUtil.toJavaScript((String)dtcg.elementAt(j)) %>";
<%		} %>
promotionDataIndex++;
<%	} %>
//
// end: populate promotion data into list box
//

var initiativePanelReady = false;
var schedulePanelReady = false;
var whichListPanelReady = false;

function setReadyFlag (panelIndicator) {
	if (panelIndicator == "initiativePanel") {
		initiativePanelReady = true;
	}
	if (panelIndicator == "schedulePanel") {
		schedulePanelReady = true;
	}
	if (panelIndicator == "whichListPanel") {
		whichListPanelReady = true;
	}
<%	if (fromPanel.equals("ems") || fromPanel.equals("experiment")) { %>
	if (initiativePanelReady && whichListPanelReady) {
<%	} else { %>
	if (initiativePanelReady && schedulePanelReady && whichListPanelReady) {
<%	} %>
		// scroll page to previous offset
		if (top.getData("pagePosition", null) == "initiativeAction") {
			window.scrollBy(0, document.all.actionPosition.offsetTop);
			top.saveData(null, "pagePosition");
		}
		else if (top.getData("pagePosition", null) == "initiativeCondition") {
			window.scrollBy(0, document.all.conditionPosition.offsetTop);
			top.saveData(null, "pagePosition");
		}

		// finish loading base frame
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
	}
	else {
		if (document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.readOnly) {
			document.initiativeForm.<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
		}
		else {
			document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.focus();
		}
	}
}

function loadPanelData () {
	with (document.initiativeForm) {
		if (initiativeDataBean != null) {
			//
			// load general definition
			//
			loadValue(<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>);
			loadValue(<%= CampaignConstants.ELEMENT_DESCRIPTION %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_DESCRIPTION %>);

			//
			// load campaign selection
			//
			loadSelectValue(<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>);

			//
			// load WHEN selection
			//
			if (!initiativeDataBean.<%= CampaignConstants.ELEMENT_EVERYDAY %> || initiativeDataBean.<%= CampaignConstants.ELEMENT_EVERYDAY %> == "false") {
				<%= CampaignConstants.ELEMENT_EVERYDAY %>.options[1].selected = true;
			}
			loadCheckBoxValues(<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>);

			//
			// load WHAT selection
			//
			if ((initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> == "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") ||
				(initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> == "<%= CampaignConstants.WHAT_TYPE_COLLABORATIVE_FILTERING %>") ||
				(initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> == "<%= CampaignConstants.WHAT_TYPE_PRODUCT_ATTRIBUTES %>")) {
				loadSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>, "<%= CampaignConstants.WHAT_TYPE_PRODUCT %>");
				loadSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);
			}
			else {
				loadSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);
			}

			//
			// load WHAT selection - promotion
			//
			var thisSelectedPromotion;
			for (var i=0; i<promotionDataContainer.length; i++) {
				selectedPromotion.options[i] = new Option(promotionDataContainer[i].discountName, promotionDataContainer[i].discountId, false, false);
				if ((promotionDataContainer[i].discountName == initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_CODE %>) &&
					(promotionDataContainer[i].discountUsage == initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_USAGE %>)) {
					if ((promotionDataContainer[i].discountStoreId == initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_STORE_ID %>) ||
						(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_STORE_ID %> == "")) {
						thisSelectedPromotion = promotionDataContainer[i].discountId;
					}
				}
			}
			loadSelectValue(selectedPromotion, thisSelectedPromotion);

			//
			// load WHAT selection - promotion ad copy
			//
			var thisSelectedPromotionCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>;
			var thisAvailablePromotionCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>;
			for (var i=0; i<thisSelectedPromotionCollateral.length; i++) {
				selectedPromotionCollateral.options[i] = new Option(thisSelectedPromotionCollateral[i].name, thisSelectedPromotionCollateral[i].collateralID, false, false);
			}
			for (var i=0; i<thisAvailablePromotionCollateral.length; i++) {
				availablePromotionCollateral.options[i] = new Option(thisAvailablePromotionCollateral[i].name, thisAvailablePromotionCollateral[i].collateralID, false, false);
			}

			//
			// load WHAT selection - coupon ad copy
			//
			var thisSelectedCouponCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>;
			var thisAvailableCouponCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>;
			for (var i=0; i<thisSelectedCouponCollateral.length; i++) {
				selectedCouponCollateral.options[i] = new Option(thisSelectedCouponCollateral[i].name, thisSelectedCouponCollateral[i].collateralID, false, false);
			}
			for (var i=0; i<thisAvailableCouponCollateral.length; i++) {
				availableCouponCollateral.options[i] = new Option(thisAvailableCouponCollateral[i].name, thisAvailableCouponCollateral[i].collateralID, false, false);
			}

			//
			// load WHAT selection - product recommendation
			//
			var SKUsSelected = initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_SKUS %>;
			var SKUsSelectedName = initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_NAMES %>;
			for (var i=0; i<SKUsSelected.length; i++) {
				selectedSKUs.options[i] = new Option(SKUsSelectedName[i], SKUsSelected[i], false, false);
			}

			//
			// load WHAT selection - product filter
			//
			var productAttributes = initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_ATTRIBUTES %>;

			for (var i=0; i<productAttributes.length; i++) {
				if (productAttributes[i].type == "<%= CampaignConstants.CATEGORY %>") {
					productFilterCategoryIdentifier.value = productAttributes[i].value1;
					productFilterCategoryName.value = initiativeDataBean.productAttributesCGName;
					categoryLanguageId.value = productAttributes[i].value2;
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.PRODUCT_DESCRIPTION %>") {
					productDescriptionKeyword.value = productAttributes[i].value1;
					productDescriptionLanguageId.value = productAttributes[i].value2;
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.SKU %>") {
					skuBeginWith.value = productAttributes[i].value1;
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.LOW_INVENTORY %>") {
					loadSelectValue(inventoryLowSymbol, productAttributes[i].value1);
					var lowValue = parent.numberToStr(productAttributes[i].value2, "<%= loginLanguageId %>", 0);
					if (lowValue.toString() == "NaN") {
						inventoryLowValue.value = productAttributes[i].value2;
					}
					else {
						inventoryLowValue.value = lowValue;
					}
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.HIGH_INVENTORY %>") {
					loadSelectValue(inventoryHighSymbol, productAttributes[i].value1);
					var highValue = parent.numberToStr(productAttributes[i].value2, "<%= loginLanguageId %>", 0);
					if (highValue.toString() == "NaN") {
						inventoryHighValue.value = productAttributes[i].value2;
					}
					else {
						inventoryHighValue.value = highValue;
					}
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.LOW_PRICE %>") {
					loadSelectValue(offerPriceLowSymbol, productAttributes[i].value1);
					var lowValue = parent.numberToCurrency(productAttributes[i].value2, defaultCurrency, "<%= loginLanguageId %>");
					if (lowValue.toString() == "NaN") {
						offerPriceLowValue.value = productAttributes[i].value2;
					}
					else {
						offerPriceLowValue.value = lowValue;
					}
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.HIGH_PRICE %>") {
					loadSelectValue(offerPriceHighSymbol, productAttributes[i].value1);
					var highValue = parent.numberToCurrency(productAttributes[i].value2, defaultCurrency, "<%= loginLanguageId %>");
					if (highValue.toString() == "NaN") {
						offerPriceHighValue.value = productAttributes[i].value2;
					}
					else {
						offerPriceHighValue.value = highValue;
					}
				}
				else if (productAttributes[i].type == "<%= CampaignConstants.AVAILABLE_AFTER %>") {
					if (!isEmpty(productAttributes[i].value1)) {
						availableAfterYear.value = productAttributes[i].value1.substring(0, 4);
						var lastDashIndex = productAttributes[i].value1.indexOf("-", 5);
						availableAfterMonth.value = productAttributes[i].value1.substring(5, lastDashIndex);
						availableAfterDay.value = productAttributes[i].value1.substring(lastDashIndex + 1);
					}
				}
			}

			// enable/disable the pull downs for the price/inv fields
			togglePriceFields();
			toggleInventoryFields();

			// handle the disabling based on language
			// check if we are logged in a different language
			if (initiativeDataBean.languageId != categoryLanguageId.value) {
				document.all.languageDiv.style.display = "block";
				productFilterListCategoryButton.disabled = true;
				productFilterListCategoryButton.className = "disabled";
				productFilterListCategoryButton.id = "disabled";
			}
			else {
				productFilterListCategoryButton.disabled = false;
				productFilterListCategoryButton.className = "enabled";
				productFilterListCategoryButton.id = "enabled";
			}
			if (initiativeDataBean.languageId != productDescriptionLanguageId.value) {
				document.all.languageDiv.style.display = "block";
				productDescriptionKeyword.disabled = true;
			}

			//
			// load WHAT selection - category recommendation
			//
			var categoriesSelected = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_CATEGORIES %>;
			var categoriesSelectedName = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_CATEGORIES_NAMES %>;
			for (var i=0; i<categoriesSelected.length; i++) {
				selectedCategory.options[i] = new Option(categoriesSelectedName[i], categoriesSelected[i], false, false);
			}

			//
			// load WHAT selection - advertisement
			//
			var thisSelectedCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>;
			var thisAvailableCollateral = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>;
			for (var i=0; i<thisSelectedCollateral.length; i++) {
				selectedCollateral.options[i] = new Option(thisSelectedCollateral[i].name, thisSelectedCollateral[i].collateralID, false, false);
			}
			for (var i=0; i<thisAvailableCollateral.length; i++) {
				availableCollateral.options[i] = new Option(thisAvailableCollateral[i].name, thisAvailableCollateral[i].collateralID, false, false);
			}

			//
			// load WHAT selection - up-sell and cross-sell product
			//
			loadSelectValue(upSellContentType, initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %>);
			loadSelectValue(crossSellContentType, initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %>);

			//
			// load WHO condition
			//
			var selectValue = (initiativeDataBean.<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>) ? "true" : "false";
			loadSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>, selectValue);
			loadSelectValues(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, initiativeDataBean.selectedSegmentIds);
			loadSelectValues(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, initiativeDataBean.availableSegmentIds);

			//
			// load WHICH condition
			//
			if (top.getData("currentWhichActionType", null) != null) {
				loadSelectValue(whichActionType, top.getData("currentWhichActionType"));
				top.saveData(null, "currentWhichActionType");
			}

			initiative<%= CampaignConstants.ELEMENT_DISABLED %>.value = initiativeDataBean.<%= CampaignConstants.ELEMENT_DISABLED %>;

			setupFinderResultSets();

			initializeNewButton();
			initializeSearchButton();
			initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
			initializeSloshBuckets(selectedCouponCollateral, removeFromCouponCollateralSloshBucketButton, availableCouponCollateral, addToCouponCollateralSloshBucketButton);
			initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
			initializeSloshBuckets(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, removeFromSegmentSloshBucketButton, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, addToSegmentSloshBucketButton);
			initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
			initializeSummaryButton(selectedCouponCollateral, availableCouponCollateral, summaryCouponCollateralButton);
			initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
			initializeSummaryButton(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, summarySegmentButton);
			setButtonContext(document.initiativeForm.selectedPromotion, document.initiativeForm.summaryPromotionButton);
			setButtonContext(document.initiativeForm.selectedSKUs, document.initiativeForm.whatRemoveProductButton);
			setButtonContext(document.initiativeForm.selectedCategory, document.initiativeForm.whatRemoveCategoryButton);

			// check that if this initiative already exists
			if (parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE_EXISTS %>", false)) {
				parent.remove("<%= CampaignConstants.ELEMENT_INITIATIVE_EXISTS %>");
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_EXISTS)) %>");
				<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.select();
			}

			// check that if this initiative has been changed or not
			if (parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE_CHANGED %>", false)) {
				parent.remove("<%= CampaignConstants.ELEMENT_INITIATIVE_CHANGED %>");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_CHANGED)) %>")) {
					parent.put("<%= CampaignConstants.ELEMENT_FORCE_SAVE %>", true);
					parent.finish();
					parent.remove("<%= CampaignConstants.ELEMENT_FORCE_SAVE %>");
				}
			}
		}

		showWhenDivisions();
		showWhatDivisions();
		showWhatProductDivisions();
		showWhoDivisions();
		showWhichDivisions();
	}

	setReadyFlag("initiativePanel");
}

function validatePanelData () {
	with (document.initiativeForm) {
		// validate initiative name field
		if (!<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_NAME_REQUIRED)) %>");
			<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.focus();
			return false;
		}
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_INITIATIVE_NAME %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeNameTooLong")) %>");
			<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.select();
			<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.focus();
			return false;
		}
		if (!isContainInvalidCharacter(<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.value)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_AN_ALPHANUMERIC_NAME)) %>");
			<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.select();
			<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.focus();
			return false;
		}

		// validate initiative name field
		if (!isValidUTF8length(<%= CampaignConstants.ELEMENT_DESCRIPTION %>.value, <%= CampaignConstants.DB_COLUMN_LENGTH_INITIATIVE_DESCRIPTION %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeDescriptionTooLong")) %>");
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.select();
			<%= CampaignConstants.ELEMENT_DESCRIPTION %>.focus();
			return false;
		}

		// validate initiative WHEN condition
		if (<%= CampaignConstants.ELEMENT_EVERYDAY %>.options[1].selected) {
			var checkResult = false;
			for (var i=0; i < <%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>.length; i++) {
				if (<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>[i].checked) {
					checkResult = true;
					break;
				}
			}
			if (!checkResult) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_ONE_DAY)) %>");
				return false;
			}
		}

		// validate e-Marketing Spot schedules
<%	if (!fromPanel.equals("ems") && !fromPanel.equals("experiment")) { %>
		var scheduleListData = initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %>;

		for (var i=0; i<scheduleListData.length; i++) {
			if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
				var thisSchedule = scheduleListData[i];

				if (!validDate(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_DATE)) %>");
					getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).select();
					getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).focus();
					return false;
				}
				if (!validTime(thisSchedule.startTime)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_TIME)) %>");
					getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + i).select();
					getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + i).focus();
					return false;
				}
				if ((thisSchedule.endYear != "") || (thisSchedule.endMonth != "") || (thisSchedule.endDay != "") || (thisSchedule.endTime != "")) {
					if (!validDate(thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_DATE)) %>");
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
						return false;
					}
					if (!validTime(thisSchedule.endTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_TIME)) %>");
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + i).select();
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + i).focus();
						return false;
					}
					// if start and end dates are specified, validate range
					if (!validateStartEndDateTime(thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay, thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay, thisSchedule.startTime, thisSchedule.endTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_END_AFTER_START_DATETIME)) %>");
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
						return false;
					}
					// check if the end date has already passed
					if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
						"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
						"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
						thisSchedule.endYear, thisSchedule.endMonth, thisSchedule.endDay,
						"<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>",
						thisSchedule.endTime)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_END_IN_PAST)) %>");
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).select();
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + i).focus();
						return false;
					}
				}
			}
		}

		// if the schedule starts in the past, confirms with the user
		for (var i=0; i<scheduleListData.length; i++) {
			if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
				var thisSchedule = scheduleListData[i];
				if (!validateStartEndDateTime("<%= TimestampHelper.getYearFromTimestamp(currentTime) %>",
					"<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>",
					"<%= TimestampHelper.getDayFromTimestamp(currentTime) %>",
					thisSchedule.startYear, thisSchedule.startMonth, thisSchedule.startDay,
					"<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>",
					thisSchedule.startTime)) {
					if (!confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_START_IN_PAST)) %>")) {
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).select();
						getIFrameById("scheduleEmsList").basefrm.document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + i).focus();
						return false;
					}
					break;
				}
			}
		}
<%	} %>

		//
		// validate initiative WHAT selection
		//

		// initiative WHAT selection - promotion
		if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>) == "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>") {
			// validate promotion selection
			if (countSelected(selectedPromotion) == 0) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NO_DISCOUNT_SELECTED)) %>");
				return false;
			}
			// validate promotion collateral selection
			if (isListBoxEmpty(selectedPromotionCollateral)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NO_COLLATERAL_SELECTED)) %>");
				return false;
			}
		}
		// initiative WHAT selection - coupon
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>) == "<%= CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL %>") {
			if (isListBoxEmpty(selectedCouponCollateral)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NO_COLLATERAL_SELECTED)) %>");
				return false;
			}
		}
		// initiative WHAT selection - product
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>) == "<%= CampaignConstants.WHAT_TYPE_PRODUCT %>") {
			// initiative WHAT selection - product recommendation
			if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>) == "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") {
				if (isListBoxEmpty(selectedSKUs)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_SKU)) %>");
					return false;
				}
			}
			// initiative WHAT selection - product filter
			else if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>) == "<%= CampaignConstants.WHAT_TYPE_PRODUCT_ATTRIBUTES %>") {
				var selectedIndex;
				// product filters cannot be empty
				if (isEmpty(productFilterCategoryIdentifier.value) &&
					isEmpty(productDescriptionKeyword.value) &&
					isEmpty(skuBeginWith.value) &&
					isEmpty(inventoryLowValue.value) &&
					isEmpty(inventoryHighValue.value) &&
					isEmpty(offerPriceLowValue.value) &&
					isEmpty(offerPriceHighValue.value) &&
					isEmpty(availableAfterYear.value) &&
					isEmpty(availableAfterMonth.value) &&
					isEmpty(availableAfterDay.value)) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_ONE_FILTER)) %>");
					return false;
				}
				// validate available date
				if ((isEmpty(availableAfterYear.value) && isEmpty(availableAfterMonth.value) && isEmpty(availableAfterDay.value)) == false) {
					if (isEmpty(availableAfterYear.value) ||
						isEmpty(availableAfterMonth.value) ||
						isEmpty(availableAfterDay.value) ||
						!validDate(availableAfterYear.value,
						availableAfterMonth.value,
						availableAfterDay.value)) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_DATE)) %>");
						availableAfterYear.focus();
						availableAfterYear.select();
						return false;
					}
				}
				// validate the inventory values
				selectedIndex = inventoryLowSymbol.options.selectedIndex;
				if (selectedIndex > 0 && (isEmpty(inventoryLowValue.value) || !parent.isValidInteger(inventoryLowValue.value, "<%= loginLanguageId %>"))) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_QUANTITY)) %>");
					inventoryLowValue.focus();
					inventoryLowValue.select();
					return false;
				}
				selectedIndex = inventoryHighSymbol.options.selectedIndex;
				if (selectedIndex > 0 && (isEmpty(inventoryHighValue.value) || !parent.isValidInteger(inventoryHighValue.value, "<%= loginLanguageId %>"))) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_QUANTITY)) %>");
					inventoryHighValue.focus();
					inventoryHighValue.select();
					return false;
				}
				// validate the list price values
				selectedIndex = offerPriceLowSymbol.options.selectedIndex;
				if (selectedIndex > 0 && (isEmpty(offerPriceLowValue.value) || !parent.isValidCurrency(offerPriceLowValue.value, defaultCurrency, "<%= loginLanguageId %>"))) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_VALID_AMOUNT)) %>");
					offerPriceLowValue.focus();
					offerPriceLowValue.select();
					return false;
				}
				selectedIndex = offerPriceHighSymbol.options.selectedIndex;
				if (selectedIndex > 0 && (isEmpty(offerPriceHighValue.value) || !parent.isValidCurrency(offerPriceHighValue.value, defaultCurrency, "<%= loginLanguageId %>"))) {
					alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_VALID_AMOUNT)) %>");
					offerPriceHighValue.focus();
					offerPriceHighValue.select();
					return false;
				}
				// ensure that the low inventory range is greater than 0 if the symbol is "less than"
				selectedIndex = inventoryLowSymbol.options.selectedIndex;
				if (inventoryLowSymbol.options[selectedIndex].value == "<%= CampaignConstants.LESS_THAN %>") {
					var lowerBound = parent.strToNumber(inventoryLowValue.value, "<%= loginLanguageId %>");
					if (lowerBound <= 0) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_QUANTITY)) %>");
						inventoryLowValue.focus();
						inventoryLowValue.select();
						return false;
					}
				}
				// ensure that the low inventory range is greater than or equal to 0 if the symbol is "greater than"
				selectedIndex = inventoryLowSymbol.options.selectedIndex;
				if (inventoryLowSymbol.options[selectedIndex].value == "<%= CampaignConstants.GREATER_THAN %>") {
					var lowerBound = parent.strToNumber(inventoryLowValue.value, "<%= loginLanguageId %>");
					if (lowerBound < 0) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_QUANTITY)) %>");
						inventoryLowValue.focus();
						inventoryLowValue.select();
						return false;
					}
				}
				// ensure that the high inventory range is greater than 0 if the symbol is "less than"
				selectedIndex = inventoryHighSymbol.options.selectedIndex;
				if (inventoryHighSymbol.options[selectedIndex].value == "<%= CampaignConstants.LESS_THAN %>") {
					var lowerBound = parent.strToNumber(inventoryHighValue.value, "<%= loginLanguageId %>");
					if (lowerBound <= 0) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_QUANTITY)) %>");
						inventoryHighValue.focus();
						inventoryHighValue.select();
						return false;
					}
				}
				// ensure that the inventory range is valid
				if (!isEmpty(inventoryLowValue.value) && !isEmpty(inventoryHighValue.value)) {
					var lowerBound = parent.strToNumber(inventoryLowValue.value, "<%= loginLanguageId %>");
					var upperBound = parent.strToNumber(inventoryHighValue.value, "<%= loginLanguageId %>");
					if (upperBound <= lowerBound) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_INVENTORY_RANGE)) %>");
						inventoryHighValue.focus();
						inventoryHighValue.select();
						return false;
					}
				}
				// ensure that the list price range is valid
				if (!isEmpty(offerPriceLowValue.value) && !isEmpty(offerPriceHighValue.value)) {
					var lowerBound = parent.currencyToNumber(offerPriceLowValue.value, defaultCurrency, "<%= loginLanguageId %>");
					var upperBound = parent.currencyToNumber(offerPriceHighValue.value, defaultCurrency, "<%= loginLanguageId %>");
					var difference = upperBound - lowerBound;
					if (difference <= 0) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_VALID_PRICE_RANGE)) %>");
						offerPriceHighValue.focus();
						offerPriceHighValue.select();
						return false;
					}
				}
				// ensure that the low price range is greater than 0 if the symbol is "less than"
				selectedIndex = offerPriceLowSymbol.options.selectedIndex;
				if (offerPriceLowSymbol.options[selectedIndex].value == "<%= CampaignConstants.LESS_THAN %>") {
					var lowerBound = parent.currencyToNumber(offerPriceLowValue.value, defaultCurrency, "<%= loginLanguageId %>");
					if (lowerBound <= 0) {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_VALID_AMOUNT)) %>");
						offerPriceLowValue.focus();
						offerPriceLowValue.select();
						return false;
					}
				}
			}
		}
		// initiative WHAT selection - category recommendation
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>) == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
			if (isListBoxEmpty(selectedCategory)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_CATEGORY)) %>");
				return false;
			}
		}
		// initiative WHAT selection - advertisement
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>) == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
			if (isListBoxEmpty(selectedCollateral)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NO_COLLATERAL_SELECTED)) %>");
				return false;
			}
		}

		// validate initiative WHO condition
		if (getSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>) === "false") {
			if (isListBoxEmpty(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_ATLEAST_ONE_PROFILE)) %>");
				return false;
			}
		}
	}

	return true;
}

function savePanelData () {
	with (document.initiativeForm) {
		if (initiativeDataBean != null) {
			//
			// save general definition
			//
			initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %> = <%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.value;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_DESCRIPTION %> = <%= CampaignConstants.ELEMENT_DESCRIPTION %>.value;

			//
			// save campaign selection
			//
			initiativeDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %> = getSelectValue(<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>);

			//
			// save WHEN selection
			//
			initiativeDataBean.<%= CampaignConstants.ELEMENT_EVERYDAY %> = getSelectValue(<%= CampaignConstants.ELEMENT_EVERYDAY %>);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %> = getCheckBoxValues(<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>);

			//
			// save WHAT selection
			//
			var thisWhatType = getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);
			if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_DISCOUNT %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_COUPON %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_PRODUCT %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_GENERAL %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = getSelectValue(<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>);
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_GENERAL %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_GENERAL %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_UPSELL %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_TYPE %> = "<%= CampaignConstants.SELL_TYPE_CROSS_SELL %>";
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHAT_TYPE %> = thisWhatType;
			}

			//
			// save WHAT selection - promotion
			//
			var thisSelectedPromotion;
			for (var i=0; i<selectedPromotion.options.length; i++) {
				if (selectedPromotion.options[i].selected) {
					thisSelectedPromotion = selectedPromotion.options[i].value;
					break;
				}
			}
			for (var i=0; i<promotionDataContainer.length; i++) {
				if (promotionDataContainer[i].discountId == thisSelectedPromotion) {
					initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_CODE %> = promotionDataContainer[i].discountName;
					initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_USAGE %> = promotionDataContainer[i].discountUsage;
					initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_STORE_ID %> = promotionDataContainer[i].discountStoreId;
					break;
				}
			}

			//
			// save WHAT selection - promotion ad copy
			//
			var promotionCollateralSelectedArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>, selectedPromotionCollateral.options);
			var promotionCollateralAvailableArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>, availablePromotionCollateral.options);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %> = promotionCollateralSelectedArray;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %> = promotionCollateralAvailableArray;

			//
			// save WHAT selection - coupon ad copy
			//
			var couponCollateralSelectedArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>, selectedCouponCollateral.options);
			var couponCollateralAvailableArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>, availableCouponCollateral.options);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %> = couponCollateralSelectedArray;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %> = couponCollateralAvailableArray;

			//
			// save WHAT selection - product recommendation
			//
			var SKUsSelected = new Array();
			var SKUsSelectedName = new Array();
			for (var i=0; i<selectedSKUs.options.length; i++) {
				SKUsSelected[i] = selectedSKUs.options[i].value;
				SKUsSelectedName[i] = selectedSKUs.options[i].text;
			}
			initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_SKUS %> = SKUsSelected;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_NAMES %> = SKUsSelectedName;

			//
			// save WHAT selection - product filter
			//
			initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_ATTRIBUTES %> = new Array();
			var productAttributes = initiativeDataBean.<%= CampaignConstants.ELEMENT_PRODUCT_ATTRIBUTES %>;

			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.CATEGORY %>", productFilterCategoryIdentifier.value, categoryLanguageId.value);
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.PRODUCT_DESCRIPTION %>", productDescriptionKeyword.value, productDescriptionLanguageId.value);
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.SKU %>", skuBeginWith.value, "");

			var lowInvValue = parent.strToNumber(inventoryLowValue.value, "<%= loginLanguageId %>");
			var lowInvSaveValue = "";
			if (lowInvValue.toString() == "NaN") {
				lowInvSaveValue = inventoryLowValue.value;
			}
			else {
				lowInvSaveValue = lowInvValue;
			}
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.LOW_INVENTORY %>", inventoryLowSymbol.options[inventoryLowSymbol.options.selectedIndex].value, lowInvSaveValue);

			var highInvValue = parent.strToNumber(inventoryHighValue.value, "<%= loginLanguageId %>");
			var highInvSaveValue = "";
			if (highInvValue.toString() == "NaN") {
				highInvSaveValue = inventoryHighValue.value;
			}
			else {
				highInvSaveValue = highInvValue;
			}
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.HIGH_INVENTORY %>", inventoryHighSymbol.options[inventoryHighSymbol.options.selectedIndex].value, highInvSaveValue);

			var lowValue = parent.currencyToNumber(offerPriceLowValue.value, defaultCurrency, "<%= loginLanguageId %>");
			var lowSaveValue = "";
			if (lowValue.toString() == "NaN") {
				lowSaveValue = offerPriceLowValue.value;
			}
			else {
				lowSaveValue = lowValue;
			}
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.LOW_PRICE %>", offerPriceLowSymbol.options[offerPriceLowSymbol.options.selectedIndex].value, lowSaveValue);

			var highValue = parent.currencyToNumber(offerPriceHighValue.value, defaultCurrency, "<%= loginLanguageId %>");
			var highSaveValue = "";
			if (highValue.toString() == "NaN") {
				highSaveValue = offerPriceHighValue.value;
			}
			else {
				highSaveValue = highValue;
			}
			saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.HIGH_PRICE %>", offerPriceHighSymbol.options[offerPriceHighSymbol.options.selectedIndex].value, highSaveValue);

			if ((isEmpty(availableAfterYear.value) && isEmpty(availableAfterMonth.value) && isEmpty(availableAfterDay.value)) == false) {
				saveProductAttributes(productAttributes, "What", "<%= CampaignConstants.AVAILABLE_AFTER %>", availableAfterYear.value + "-" + availableAfterMonth.value + "-" + availableAfterDay.value, "");
			}

			//
			// save WHAT selection - category recommendation
			//
			var categoriesSelected = new Array();
			var categoriesSelectedName = new Array();
			for (var i=0; i<selectedCategory.options.length; i++) {
				categoriesSelected[i] = selectedCategory.options[i].value;
				categoriesSelectedName[i] = selectedCategory.options[i].text;
			}
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_CATEGORIES %> = categoriesSelected;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_CATEGORIES_NAMES %> = categoriesSelectedName;

			//
			// save WHAT selection - advertisement
			//
			var collateralSelectedArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>, selectedCollateral.options);
			var collateralAvailableArray = recreateCollateralArray(initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>, initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>, availableCollateral.options);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %> = collateralSelectedArray;
			initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %> = collateralAvailableArray;

			//
			// save WHAT selection - up-sell and cross-sell product
			//
			if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %> = getSelectValue(upSellContentType);
			}
			else if (thisWhatType == "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %> = getSelectValue(crossSellContentType);
			}

			//
			// save WHO condition
			//
			var selectValue = getSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %> = (selectValue === "true") ? true : false;
			initiativeDataBean.selectedSegmentIds = getSelectValues(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %> = getSelectTexts(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>);
			initiativeDataBean.availableSegmentIds = getSelectValues(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>);
			initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %> = getSelectTexts(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>);

			//
			// save WHICH condition
			//
			top.saveData(getSelectValue(whichActionType), "currentWhichActionType");

			//
			// save all conflicting schedule priorities
			//
			var allConflictsResult = top.getData("allConflictsResult", null);
			if ((allConflictsResult != null) && (allConflictsResult.length > 0)) {
				var conflictScheduleId = new Array();
				var conflictScheduleEmsId = new Array();
				var conflictSchedulePriority = new Array();
				for (var i=0; i<allConflictsResult.length; i++) {
					conflictScheduleId[i] = allConflictsResult[i].scheduleId;
					conflictScheduleEmsId[i] = allConflictsResult[i].scheduleEmsId;
					conflictSchedulePriority[i] = allConflictsResult[i].schedulePriority;
				}
				initiativeDataBean.<%= CampaignConstants.ELEMENT_CONFLICT_SCHEDULE_ID %> = conflictScheduleId;
				initiativeDataBean.<%= CampaignConstants.ELEMENT_CONFLICT_SCHEDULE_EMS_ID %> = conflictScheduleEmsId;
				initiativeDataBean.<%= CampaignConstants.ELEMENT_CONFLICT_SCHEDULE_PRIORITY %> = conflictSchedulePriority;
			}
			top.saveData(null, "allConflictsResult");

			initiativeDataBean.<%= CampaignConstants.ELEMENT_DISABLED %> = initiative<%= CampaignConstants.ELEMENT_DISABLED %>.value;
		}
	}
}

function saveProductAttributes (productAttributes, action, type, value1, value2) {
	var index = productAttributes.length;
	productAttributes[index] = new Object();
	productAttributes[index].action = action;
	productAttributes[index].type = type;
	productAttributes[index].value1 = value1;
	productAttributes[index].value2 = value2;
}

function togglePriceFields () {
	var selectedIndex = document.initiativeForm.offerPriceLowSymbol.options.selectedIndex;
	// check to see if "N/A" is selected on the low symbol
	if (selectedIndex > 0) {
		document.initiativeForm.offerPriceLowValue.disabled = false;
		document.initiativeForm.offerPriceLowValue.className = "enabledBox";
	}
	else {
		document.initiativeForm.offerPriceLowValue.value = "";
		document.initiativeForm.offerPriceLowValue.disabled = true;
		document.initiativeForm.offerPriceLowValue.className = "disabledBox";
	}

	// if symbol is ">" then enable the "high" symbol pulldown
	if (document.initiativeForm.offerPriceLowSymbol.options[selectedIndex].value == "<%= CampaignConstants.GREATER_THAN %>") {
		document.initiativeForm.offerPriceHighSymbol.disabled = false;
		document.initiativeForm.offerPriceHighSymbol.className = "enabledBox";
	}
	else {
		document.initiativeForm.offerPriceHighSymbol.options[0].selected = true;
		document.initiativeForm.offerPriceHighValue.value = "";
		document.initiativeForm.offerPriceHighSymbol.disabled = true;
		document.initiativeForm.offerPriceHighValue.disabled = true;
		document.initiativeForm.offerPriceHighSymbol.className = "disabledBox";
		document.initiativeForm.offerPriceHighValue.className = "disabledBox";
	}

	// check to see if "N/A" is selected on the high symbol
	var selectedIndex = document.initiativeForm.offerPriceHighSymbol.options.selectedIndex;
	if (selectedIndex > 0) {
		document.initiativeForm.offerPriceHighValue.disabled = false;
		document.initiativeForm.offerPriceHighValue.className = "enabledBox";
	}
	else {
		document.initiativeForm.offerPriceHighValue.value = "";
		document.initiativeForm.offerPriceHighValue.disabled = true;
		document.initiativeForm.offerPriceHighValue.className = "disabledBox";
	}
}

function toggleInventoryFields () {
	var selectedIndex = document.initiativeForm.inventoryLowSymbol.options.selectedIndex;
	// check to see if "N/A" is selected on the low symbol
	if (selectedIndex > 0) {
		document.initiativeForm.inventoryLowValue.disabled = false;
		document.initiativeForm.inventoryLowValue.className = "enabledBox";
	}
	else {
		document.initiativeForm.inventoryLowValue.value = "";
		document.initiativeForm.inventoryLowValue.disabled = true;
		document.initiativeForm.inventoryLowValue.className = "disabledBox";
	}

	if (document.initiativeForm.inventoryLowSymbol.options[selectedIndex].value == "<%= CampaignConstants.GREATER_THAN %>") {
		document.initiativeForm.inventoryHighSymbol.disabled = false;
		document.initiativeForm.inventoryHighSymbol.className = "enabledBox";
	}
	else {
		document.initiativeForm.inventoryHighSymbol.options[0].selected = true;
		document.initiativeForm.inventoryHighValue.value = "";
		document.initiativeForm.inventoryHighSymbol.disabled = true;
		document.initiativeForm.inventoryHighValue.disabled = true;
		document.initiativeForm.inventoryHighValue.className = "disabledBox";
		document.initiativeForm.inventoryHighSymbol.className = "disabledBox";
	}

	// check to see if "N/A" is selected on the high symbol
	var selectedIndex = document.initiativeForm.inventoryHighSymbol.options.selectedIndex;
	if (selectedIndex > 0) {
		document.initiativeForm.inventoryHighValue.disabled = false;
		document.initiativeForm.inventoryHighValue.className = "enabledBox";
	}
	else {
		document.initiativeForm.inventoryHighValue.value = "";
		document.initiativeForm.inventoryHighValue.disabled = true;
		document.initiativeForm.inventoryHighValue.className = "disabledBox";
	}
}

function recreateCollateralArray (selectedCollateralObj, availableCollateralObj, optionBox) {
	var collateralArray = new Array();

	for (var i=0; i<optionBox.length; i++) {
		collateralArray[i] = new Object();

		// get the value of the option which holds the ID of the collateral
		// the ID will be used to determine how to copy the entire collateral object from one array to another
		var collateralId = optionBox[i].value;
		var collateralIndex = findCollateralById(selectedCollateralObj, collateralId);

		if (collateralIndex >= 0) {
			// duplicate the original collateral object into the array
			collateralArray[i] = selectedCollateralObj[collateralIndex];
		}
		else {
			collateralIndex = findCollateralById(availableCollateralObj, collateralId);
			if (collateralIndex >= 0) {
				// duplicate the original collateral object into the array
				collateralArray[i] = availableCollateralObj[collateralIndex];
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
				return;
			}
		}
	}

	return collateralArray;
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("initiativePanel");
	top.saveModel(parent.model);
}

function showWhatDivisions () {
	var whatTypeValue = getSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);
	if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>") {
		if (!isPromotionLoaded) {
			top.showProgressIndicator(true);
			document.contentSelectionSearchForm.searchType.value = "promotionCollateral";
			document.contentSelectionSearchForm.initialLoad.value = "Y";
			document.contentSelectionSearchForm.submit();
			isPromotionLoaded = true;
		}
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentPromotionDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL %>") {
		if (!isCouponLoaded) {
			top.showProgressIndicator(true);
			document.contentSelectionSearchForm.searchType.value = "couponCollateral";
			document.contentSelectionSearchForm.initialLoad.value = "Y";
			document.contentSelectionSearchForm.submit();
			isCouponLoaded = true;
		}
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_PRODUCT %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
		if (!isCollateralLoaded) {
			top.showProgressIndicator(true);
			document.contentSelectionSearchForm.searchType.value = "collateral";
			document.contentSelectionSearchForm.initialLoad.value = "Y";
			document.contentSelectionSearchForm.submit();
			isCollateralLoaded = true;
		}
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "block";
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCouponDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "block";
	}
}

function showWhatProductDivisions () {
	var whatTypeProductValue = getSelectValue(document.initiativeForm.<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>);
	if (whatTypeProductValue == "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") {
		document.all.contentProductMultiOptionFilterDiv.style.display = "none";
		document.all.contentProductSpecificDiv.style.display = "block";
	}
	else if (whatTypeProductValue == "<%= CampaignConstants.WHAT_TYPE_COLLABORATIVE_FILTERING %>") {
		document.all.contentProductSpecificDiv.style.display = "none";
		document.all.contentProductMultiOptionFilterDiv.style.display = "none";
<%	if (!com.ibm.commerce.server.WcsApp.componentManager.getComponentStatus("WCSLikeMindsListener")) { %>
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("productLikemindsEngineDisabled")) %>");
<%	} %>
	}
	else if (whatTypeProductValue == "<%= CampaignConstants.WHAT_TYPE_PRODUCT_ATTRIBUTES %>") {
		document.all.contentProductSpecificDiv.style.display = "none";
		document.all.contentProductMultiOptionFilterDiv.style.display = "block";
	}
}

function showWhenDivisions () {
	with (document.initiativeForm) {
		var selectValue = getSelectValue(<%= CampaignConstants.ELEMENT_EVERYDAY %>) == "true";
		if (selectValue) {
			document.all.daysDiv.style.display = "none";
		}
		else {
			document.all.daysDiv.style.display = "block";
		}
	}
}

function showWhoDivisions () {
	with (document.initiativeForm) {
		var selectValue = getSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>);
		showDivision(segmentsDiv, selectValue === "false");
		if (selectValue === "false") {
			if (isListBoxEmpty(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>) && isListBoxEmpty(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>)) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_CREATE_CUSTOMER_PROFILE_FIRST)) %>");
				<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>.options[0].selected = true;
				showDivision(segmentsDiv, false);
			}
		}
	}
}

function showWhichDivisions () {
	with (document.initiativeForm) {
		var selectValue = getSelectValue(whichActionType);
		var selectedType;
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
		if (selectValue == "<%= CampaignConstants.whenArray[i] %>") {
			selectedType = "<%= CampaignConstants.whenTypeArray[i] %>";
		}
<%	} %>
		if (selectedType == "<%= CampaignConstants.SKU %>" || selectedType == "<%= CampaignConstants.PRODUCT %>") {
			document.all.whichCategoryDiv.style.display = "none";
			document.all.whichPriceDiv.style.display = "none";
			document.all.whichSkuDiv.style.display = "block";
		}
		else if (selectedType == "<%= CampaignConstants.CATEGORY %>") {
			document.all.whichSkuDiv.style.display = "none";
			document.all.whichPriceDiv.style.display = "none";
			document.all.whichCategoryDiv.style.display = "block";
		}
		else if (selectedType == "<%= CampaignConstants.PRICE %>") {
			document.all.whichSkuDiv.style.display = "none";
			document.all.whichCategoryDiv.style.display = "none";
			document.all.whichPriceDiv.style.display = "block";
		}
	}
}

function addWhatProduct () {
	if (isEmpty(document.initiativeForm.productSKU.value)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("skuCannotBeEmpty")) %>");
		return;
	}
	document.catalogValidatorForm.searchType.value = "product";
	document.catalogValidatorForm.locationType.value = "whatAction";
	document.catalogValidatorForm.productSku.value = trim(document.initiativeForm.productSKU.value);
	document.catalogValidatorForm.submit();
	document.initiativeForm.whatAddProductButton.disabled = true;
	document.initiativeForm.whatAddProductButton.className = "disabled";
	document.initiativeForm.whatAddProductButton.id = "disabled";
}

function addWhatCategory () {
	if (isEmpty(document.initiativeForm.categoryIdentifier.value)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("categoryCannotBeEmpty")) %>");
		return;
	}

	document.catalogValidatorForm.searchType.value = "category";
	document.catalogValidatorForm.locationType.value = "whatAction";
	document.catalogValidatorForm.categoryIdentifier.value = trim(document.initiativeForm.categoryIdentifier.value);
	document.catalogValidatorForm.submit();
	document.initiativeForm.whatAddCategoryButton.disabled = true;
	document.initiativeForm.whatAddCategoryButton.className = "disabled";
	document.initiativeForm.whatAddCategoryButton.id = "disabled";
}

function addWhichProduct () {
	if (isEmpty(document.initiativeForm.whichSkuValue.value)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("skuCannotBeEmpty")) %>");
		return;
	}

	document.catalogValidatorForm.searchType.value = "product";
	document.catalogValidatorForm.locationType.value = "whichCondition";
	document.catalogValidatorForm.productSku.value = trim(document.initiativeForm.whichSkuValue.value);
	document.catalogValidatorForm.submit();
	document.initiativeForm.whichAddSkuButton.disabled = true;
	document.initiativeForm.whichAddSkuButton.className = "disabled";
	document.initiativeForm.whichAddSkuButton.id = "disabled";
}

function addWhichCategory () {
	if (isEmpty(document.initiativeForm.whichCategoryValue.value)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("categoryCannotBeEmpty")) %>");
		return;
	}

	document.catalogValidatorForm.searchType.value = "category";
	document.catalogValidatorForm.locationType.value = "whichCondition";
	document.catalogValidatorForm.categoryIdentifier.value = trim(document.initiativeForm.whichCategoryValue.value);
	document.catalogValidatorForm.submit();
	document.initiativeForm.whichAddCategoryButton.disabled = true;
	document.initiativeForm.whichAddCategoryButton.className = "disabled";
	document.initiativeForm.whichAddCategoryButton.id = "disabled";
}

// validate the sku when add to the list
function validateAddSKU (s) {
	if (isEmpty(s)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_SKU_CANNOT_BE_EMPTY)) %>");
		return false;
	}
	// make sure the sku will not be duplicate
	var inputSKU = trim(s);
	for (var i=0; i<document.initiativeForm.selectedSKUs.options.length; i++) {
		var SKUName = document.initiativeForm.selectedSKUs.options[i];
		if (inputSKU == SKUName.value) {
			return false;
		}
	}
	return true;
}

// validate the category when add to the list
function validateAddCategory (s) {
	if (isEmpty(s)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("categoryCannotBeEmpty")) %>");
		return false;
	}
	// make sure the category will not be duplicate
	var inputCategory = trim(s);
	for (var i=0; i<document.initiativeForm.selectedCategory.options.length; i++) {
		var currentCategoryOption = document.initiativeForm.selectedCategory.options[i];
		if (inputCategory == currentCategoryOption.value) {
			return false;
		}
	}
	return true;
}

function addSKU (_sku, _name) {
	var inputSKU = trim(_sku);
	var inputName = trim(_name);
	if (validateAddSKU(inputSKU)) {
		var nextOptionIndex = document.initiativeForm.selectedSKUs.options.length;
		document.initiativeForm.selectedSKUs.options[nextOptionIndex] = new Option(inputName, inputSKU, false, false);
	}
}

function addCategoryOption (_categoryIdentifier, _categoryName) {
	var inputCategoryIdentifier = trim(_categoryIdentifier);
	var inputCategoryName = trim(_categoryName);
	if (validateAddCategory(inputCategoryIdentifier)) {
		var nextOptionIndex = document.initiativeForm.selectedCategory.options.length;
		document.initiativeForm.selectedCategory.options[nextOptionIndex] = new Option(inputCategoryName, inputCategoryIdentifier, false, false);
	}
}

function removeSKU (selectedMultiSelect) {
	var noSKUselected = true;
	for (var i=selectedMultiSelect.options.length-1; i>=0; i--) {
		if (selectedMultiSelect.options[i].selected && selectedMultiSelect.options[i].value != "") {
			selectedMultiSelect.options[i] = null; // remove the selection from the list
			noSKUselected = false;
		}
	}
	if (noSKUselected) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_SELECT_SKU_TO_REMOVE)) %>");
	}

	// update the remove button
	setButtonContext(document.initiativeForm.selectedSKUs, document.initiativeForm.whatRemoveProductButton);
}

function removeCategory (selectedMultiSelect) {
	var noCategorySelected = true;
	for (var i=selectedMultiSelect.options.length-1; i>=0; i--) {
		if (selectedMultiSelect.options[i].selected && selectedMultiSelect.options[i].value != "") {
			selectedMultiSelect.options[i] = null; // remove the selection from the list
			noCategorySelected = false;
		}
	}
	if (noCategorySelected) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("selectCategoryToRemove")) %>");
	}

	// update the remove button
	setButtonContext(document.initiativeForm.selectedCategory, document.initiativeForm.whatRemoveCategoryButton);
}

function productFilterClearCategory () {
	document.initiativeForm.productFilterCategoryIdentifier.value = "";
	document.initiativeForm.productFilterCategoryName.value = "";
}

function addToSelectedPromotionCollateral () {
	with (document.initiativeForm) {
		move(availablePromotionCollateral, selectedPromotionCollateral);
		updateSloshBuckets(availablePromotionCollateral, addToPromotionCollateralSloshBucketButton, selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton);
		initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	}
}

function removeFromSelectedPromotionCollateral () {
	with (document.initiativeForm) {
		move(selectedPromotionCollateral, availablePromotionCollateral);
		updateSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
		initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	}
}

function addToSelectedCouponCollateral () {
	with (document.initiativeForm) {
		move(availableCouponCollateral, selectedCouponCollateral);
		updateSloshBuckets(availableCouponCollateral, addToCouponCollateralSloshBucketButton, selectedCouponCollateral, removeFromCouponCollateralSloshBucketButton);
		initializeSummaryButton(selectedCouponCollateral, availableCouponCollateral, summaryCouponCollateralButton);
	}
}

function removeFromSelectedCouponCollateral () {
	with (document.initiativeForm) {
		move(selectedCouponCollateral, availableCouponCollateral);
		updateSloshBuckets(selectedCouponCollateral, removeFromCouponCollateralSloshBucketButton, availableCouponCollateral, addToCouponCollateralSloshBucketButton);
		initializeSummaryButton(selectedCouponCollateral, availableCouponCollateral, summaryCouponCollateralButton);
	}
}

function addToSelectedCollateral () {
	with (document.initiativeForm) {
		move(availableCollateral, selectedCollateral);
		updateSloshBuckets(availableCollateral, addToCollateralSloshBucketButton, selectedCollateral, removeFromCollateralSloshBucketButton);
		initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	}
}

function removeFromSelectedCollateral () {
	with (document.initiativeForm) {
		move(selectedCollateral, availableCollateral);
		updateSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
		initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	}
}

function addToSelectedSegments () {
	with (document.initiativeForm) {
		move(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, <%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>);
		updateSloshBuckets(<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, addToSegmentSloshBucketButton, <%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, removeFromSegmentSloshBucketButton);
		initializeSummaryButton(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, summarySegmentButton);
	}
}

function removeFromSelectedSegments () {
	with (document.initiativeForm) {
		move(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>);
		updateSloshBuckets(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, removeFromSegmentSloshBucketButton, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, addToSegmentSloshBucketButton);
		initializeSummaryButton(<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, summarySegmentButton);
	}
}

function initializeNewButton () {
<%	if (CampaignUtil.isPromotionAccessible(campaignCommandContext.getStore().getStoreType())) { %>
	document.initiativeForm.newPromotionButton.disabled = false;
	document.initiativeForm.newPromotionButton.className = "enabled";
	document.initiativeForm.newPromotionButton.id = "enabled";
<%	} else { %>
	document.initiativeForm.newPromotionButton.disabled = true;
	document.initiativeForm.newPromotionButton.className = "disabled";
	document.initiativeForm.newPromotionButton.id = "disabled";
<%	} %>
	document.initiativeForm.newPromotionCollateralButton.disabled = false;
	document.initiativeForm.newPromotionCollateralButton.className = "enabled";
	document.initiativeForm.newPromotionCollateralButton.id = "enabled";
	document.initiativeForm.newCouponCollateralButton.disabled = false;
	document.initiativeForm.newCouponCollateralButton.className = "enabled";
	document.initiativeForm.newCouponCollateralButton.id = "enabled";
	document.initiativeForm.newCollateralButton.disabled = false;
	document.initiativeForm.newCollateralButton.className = "enabled";
	document.initiativeForm.newCollateralButton.id = "enabled";
}

function initializeSummaryButton (aComponent1, aComponent2, aButton) {
	var selectedCount = countSelected(aComponent1) + countSelected(aComponent2);

	// if exactly one item is selected... enable the button.
	if (selectedCount == 1) {
		aButton.disabled = false;
		aButton.className = "enabled";
		aButton.id = "enabled";
	}
	else {
		aButton.disabled = true;
		aButton.className = "disabled";
		aButton.id = "disabled";
	}
}

function setupDate () {
	window.yearField = document.initiativeForm.availableAfterYear;
	window.monthField = document.initiativeForm.availableAfterMonth;
	window.dayField = document.initiativeForm.availableAfterDay;
}

function getWhichText (whichAction) {
	if (whichAction == "<%= CampaignConstants.SHOPPING_CART_CONTAINS_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_CONTAINS_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_DOESNOT_CONTAIN_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_DOES_NOT_CONTAIN_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_CONTAINS_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_CONTAINS_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_DOESNOT_CONTAIN_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_DOES_NOT_CONTAIN_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_CONTAINS_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_CONTAINS_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_DOESNOT_CONTAIN_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_DOES_NOT_CONTAIN_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_CONTAINS_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_CONTAINS_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_DOESNOT_CONTAIN_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_DOES_NOT_CONTAIN_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_GREATERTHAN %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_GREATER_THAN)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_LESSTHAN %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_LESS_THAN)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_EQUALTO %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_EQUAL_TO)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.BROWSING_PRODUCT %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_BROWSING_PRODUCT)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.BROWSING_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_BROWSING_CATEGORY)) %>";
	}
}

function addWhichChoice () {
	var selectedActionTypeIndex = document.initiativeForm.whichActionType.selectedIndex;
	var selectedActionValue = "";
	var selectedTypeValue = "";
	var value1 = "";
	var value2 = "";
	var isValid = true;

<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
	if (document.initiativeForm.whichActionType.options[selectedActionTypeIndex].value == "<%= CampaignConstants.whenArray[i] %>") {
		selectedActionValue = "<%= CampaignConstants.whenActionArray[i] %>";
		selectedTypeValue = "<%= CampaignConstants.whenTypeArray[i] %>";
	}
<%	} %>

	if ((selectedActionTypeIndex == 0) || (selectedActionTypeIndex == 1) || (selectedActionTypeIndex == 4) || (selectedActionTypeIndex == 5) || (selectedActionTypeIndex == 11)) {
		value1 = document.initiativeForm.whichSkuValue.value;
		value2 = document.initiativeForm.whichSkuNameValue.value;
	}
	else if ((selectedActionTypeIndex == 2) || (selectedActionTypeIndex == 3) || (selectedActionTypeIndex == 6) || (selectedActionTypeIndex == 7) || (selectedActionTypeIndex == 12)) {
		value1 = document.initiativeForm.whichCategoryNameValue.value;
		value2 = document.initiativeForm.whichCategoryValue.value;
	}
	else if ((selectedActionTypeIndex == 8) || (selectedActionTypeIndex == 9) || (selectedActionTypeIndex == 10)) {
		if (isEmpty(document.initiativeForm.whichPriceValue.value) || !parent.parent.parent.isValidCurrency(document.initiativeForm.whichPriceValue.value, defaultCurrency, "<%= campaignCommandContext.getLanguageId().toString() %>")) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_VALID_AMOUNT)) %>");
			document.initiativeForm.whichPriceValue.focus();
			document.initiativeForm.whichPriceValue.select();
			isValid = false;
		}

		// ensure that the low shopcart total is greater than 0 if the symbol is "less than"
		if (selectedActionTypeIndex == 5) {
			var lowerBound = parent.parent.parent.currencyToNumber(document.initiativeForm.whichPriceValue.value, defaultCurrency, "<%= campaignCommandContext.getLanguageId().toString() %>");
			if (lowerBound <= 0) {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_ENTER_VALID_AMOUNT)) %>");
				document.initiativeForm.whichPriceValue.focus();
				document.initiativeForm.whichPriceValue.select();
				isValid = false;
			}
		}

		value1 = parent.parent.parent.currencyToNumber(document.initiativeForm.whichPriceValue.value, defaultCurrency, "<%= campaignCommandContext.getLanguageId().toString() %>");
		value2 = defaultCurrency;
	}
	else {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_BAD_CUSTOMER_BEHAVIOR_ID)) %>");
		isValid = false;
	}

	if (selectedActionValue == "" || selectedTypeValue == "") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_BAD_SELECTED_ACTION)) %>");
		isValid = false;
	}

	if (isValid) {
		var whichChoice = new Object();
		whichChoice.action = selectedActionValue;
		whichChoice.type = selectedTypeValue;
		whichChoice.value1 = value1;
		whichChoice.value2 = value2;
		document.initiativeForm.whichSkuValue.value = "";
		document.initiativeForm.whichSkuNameValue.value = "";
		document.initiativeForm.whichCategoryValue.value = "";
		document.initiativeForm.whichCategoryNameValue.value = "";
		document.initiativeForm.whichPriceValue.value = "";
		initiativeDataBean.<%= CampaignConstants.ELEMENT_WHEN_CHOICES %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_WHEN_CHOICES %>.length] = whichChoice;
		getIFrameById("whichList").location.reload();
	}
}

function newPromotion () {
	// save the panel settings
	persistPanelData();
	top.saveData(parent.model, "initiativeModel");
	top.saveData("initiativeAction", "pagePosition");

	// save the current content type
	top.saveData("promotion", "contentType");

	// launch the promotion notebook panel
<%	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled(com.ibm.commerce.discount.rules.DiscountConst.COMPONENT_RULE_BASED_DISCOUNT)) { %>
	var url = "<%= UIUtil.getWebappPath(request) %>WizardView?XMLFile=RLPromotion.RLPromotionWizard";
<%	} else { %>
	var url = "<%= UIUtil.getWebappPath(request) %>WizardView?XMLFile=discount.discountWizard";
<%	} %>
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("createPromotion")) %>", url, true);
}

function newCollateral () {
	// save the panel settings
	persistPanelData();
	top.saveData(parent.model, "initiativeModel");
	top.saveData("initiativeAction", "pagePosition");

	// save the current content type
	top.saveData("collateral", "contentType");

	// launch the ad copy dialog panel
	var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_COLLATERAL)) %>", url, true);
}

function gotoSearchProductDialog (searchLocation) {
	// save the panel settings
	persistPanelData();

	// save the current content type
	top.saveData(searchLocation, "contentType");

	// set the search type
	if (searchLocation == "whatActionProduct") {
		top.saveData("productMultiple", "searchType");
		top.saveData("initiativeAction", "pagePosition");
	}
	else if (searchLocation == "whichConditionProduct") {
		var selectedTypeValue = "<%= CampaignConstants.SKU %>";
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
		if (document.initiativeForm.whichActionType.options[document.initiativeForm.whichActionType.selectedIndex].value == "<%= CampaignConstants.whenArray[i] %>") {
			selectedTypeValue = "<%= CampaignConstants.whenTypeArray[i] %>";
		}
<%	} %>
		if (selectedTypeValue == "<%= CampaignConstants.PRODUCT %>") {
			top.saveData("productSingle", "searchType");
			top.saveData("initiativeCondition", "pagePosition");
		}
		else {
			top.saveData("itemSingle", "searchType");
			top.saveData("initiativeCondition", "pagePosition");
		}
	}

	// launch the search panel
	var url = "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("productFindPanelTitle")) %>", url, true);
}

function gotoBrowseProductDialog (searchLocation) {
	// save the panel settings
	persistPanelData();

	// save the current content type
	top.saveData(searchLocation, "contentType");

	// set browsing tree parameters
	var bp = new Object();
	bp.selectionType = "CE";
	bp.catalogId = "";
	bp.categoryId = "";

	// set the browse type
	if (searchLocation == "whatActionProduct") {
		bp.locationType = "allType";
		top.saveData(true, "allowMultiple");
		top.saveData("initiativeAction", "pagePosition");
	}
	else if (searchLocation == "whichConditionProduct") {
		var selectedTypeValue = "<%= CampaignConstants.SKU %>";
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
		if (document.initiativeForm.whichActionType.options[document.initiativeForm.whichActionType.selectedIndex].value == "<%= CampaignConstants.whenArray[i] %>") {
			selectedTypeValue = "<%= CampaignConstants.whenTypeArray[i] %>";
		}
<%	} %>
		if (selectedTypeValue == "<%= CampaignConstants.PRODUCT %>") {
			bp.locationType = "allType";
			top.saveData(false, "allowMultiple");
			top.saveData("initiativeCondition", "pagePosition");
		}
		else {
			bp.locationType = "itemType";
			top.saveData(false, "allowMultiple");
			top.saveData("initiativeCondition", "pagePosition");
		}
	}

	// save the browsing tree parameters
	top.saveData(bp, "browseParameters");

	// launch the browse panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ProductBrowseDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("ProductBrowsePanelTitle")) %>", url, true);
}

function gotoListCategoryDialog (searchLocation) {
	// save the panel settings
	persistPanelData();

	// save the current content type
	top.saveData(searchLocation, "contentType");

	// set the search type
	if (searchLocation == "whatProductFilterCategory") {
		top.saveData("categorySingle", "searchType");
		top.saveData("initiativeAction", "pagePosition");
	}
	else if (searchLocation == "whatActionCategory") {
		top.saveData("categoryMultiple", "searchType");
		top.saveData("initiativeAction", "pagePosition");
	}
	else if (searchLocation == "whichConditionCategory") {
		top.saveData("categorySingle", "searchType");
		top.saveData("initiativeCondition", "pagePosition");
	}

	// launch the list panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CategoryDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("CategoryListDialogTitle")) %>", url, true);
}

function gotoSummaryPromotionDialog () {
	// first find out which item is selected in either option box
	var selectedPromotion = whichItemIsSelected(document.initiativeForm.selectedPromotion);
	if (selectedPromotion == "") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
		return;
	}

	// save the panel settings
	persistPanelData();
	top.saveData("initiativeAction", "pagePosition");

	// launch the summary panel
<%	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled(com.ibm.commerce.discount.rules.DiscountConst.COMPONENT_RULE_BASED_DISCOUNT)) { %>
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=RLPromotion.RLDiscountDetails&calcodeId=" + selectedPromotion;
<%	} else { %>
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=discount.discountDetails&calcodeId=" + selectedPromotion;
<%	} %>
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("promotionSummaryDialogTitle")) %>", url, true);
}

function gotoSummaryPromotionCollateralDialog () {
	// first find out which item is selected in either option box
	var selectedCollateralId = whichItemIsSelected(document.initiativeForm.availablePromotionCollateral);
	if (selectedCollateralId == "") {
		selectedCollateralId = whichItemIsSelected(document.initiativeForm.selectedPromotionCollateral);
		if (selectedCollateralId == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
			return;
		}
	}

	// find the store ID of the selected collateral
	var selectedCollateralStoreId = "";
	for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>.length; i++) {
		if (initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>[i].collateralID == selectedCollateralId) {
			selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>[i].storeID;
			break;
		}
	}
	if (selectedCollateralStoreId == "") {
		for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>.length; i++) {
			if (initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>[i].collateralID == selectedCollateralId) {
				selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>[i].storeID;
				break;
			}
		}
	}

	// save the panel settings
	persistPanelData();
	top.saveData("initiativeAction", "pagePosition");

	// launch the summary panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + selectedCollateralId + "&collateralStoreId=" + selectedCollateralStoreId;
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewDialogTitle")) %>", url, true);
}

function gotoSummaryCouponCollateralDialog () {
	// first find out which item is selected in either option box
	var selectedCollateralId = whichItemIsSelected(document.initiativeForm.availableCouponCollateral);
	if (selectedCollateralId == "") {
		selectedCollateralId = whichItemIsSelected(document.initiativeForm.selectedCouponCollateral);
		if (selectedCollateralId == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
			return;
		}
	}

	// find the store ID of the selected collateral
	var selectedCollateralStoreId = "";
	for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>.length; i++) {
		if (initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>[i].collateralID == selectedCollateralId) {
			selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>[i].storeID;
			break;
		}
	}
	if (selectedCollateralStoreId == "") {
		for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>.length; i++) {
			if (initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>[i].collateralID == selectedCollateralId) {
				selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>[i].storeID;
				break;
			}
		}
	}

	// save the panel settings
	persistPanelData();
	top.saveData("initiativeAction", "pagePosition");

	// launch the summary panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + selectedCollateralId + "&collateralStoreId=" + selectedCollateralStoreId;
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewDialogTitle")) %>", url, true);
}

function gotoSummaryCollateralDialog () {
	// first find out which item is selected in either option box
	var selectedCollateralId = whichItemIsSelected(document.initiativeForm.availableCollateral);
	if (selectedCollateralId == "") {
		selectedCollateralId = whichItemIsSelected(document.initiativeForm.selectedCollateral);
		if (selectedCollateralId == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
			return;
		}
	}

	// find the store ID of the selected collateral
	var selectedCollateralStoreId = "";
	for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>.length; i++) {
		if (initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>[i].collateralID == selectedCollateralId) {
			selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>[i].storeID;
			break;
		}
	}
	if (selectedCollateralStoreId == "") {
		for (var i=0; i<initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>.length; i++) {
			if (initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>[i].collateralID == selectedCollateralId) {
				selectedCollateralStoreId = initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>[i].storeID;
				break;
			}
		}
	}

	// save the panel settings
	persistPanelData();
	top.saveData("initiativeAction", "pagePosition");

	// launch the summary panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + selectedCollateralId + "&collateralStoreId=" + selectedCollateralStoreId;
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewDialogTitle")) %>", url, true);
}

function gotoSummarySegmentDialog () {
	// first find out which item is selected in either option box
	var selectedSegment = whichItemIsSelected(document.initiativeForm.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>);
	if (selectedSegment == "") {
		selectedSegment = whichItemIsSelected(document.initiativeForm.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>);
		if (selectedSegment == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_FATAL_ERROR_NO_COLLATERAL_ID)) %>");
			return;
		}
	}

	// save the panel settings
	persistPanelData();
	top.saveData("initiativeCondition", "pagePosition");

	// launch the summary panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=segmentation.SegmentDetailsDialog&segmentId=" + selectedSegment;
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("segmentSummaryDialogTitle")) %>", url, true);
}

function setupFinderResultSets () {
	// get the current content type
	var currentContentType = top.getData("contentType", null);

	if (currentContentType == "promotion") {
		// check to see if there is any promotion in the result set from promotion notebook
		var promotionResult = top.getData("promotionResult", null);
		if (promotionResult != null) {
			// select the newly created promotion in the promotion list box
			for (var i=0; i<document.initiativeForm.selectedPromotion.options.length; i++) {
				if (document.initiativeForm.selectedPromotion.options[i].value == promotionResult.promotionId) {
					document.initiativeForm.selectedPromotion.options[i].selected = true;
					updateTargetSegmentSelection();
					break;
				}
			}

			// clear the promotion result object
			top.saveData(null, "promotionResult");
		}
	}
	else if (currentContentType == "collateral") {
		// check to see if there is any collateral in the result set from ad copy dialog
		var collateralResult = top.getData("collateralResult", null);
		if (collateralResult != null) {
			// populate collateral objects from model
			var newResultObject = new Object();
			newResultObject.collateralID = collateralResult.collateralId;
			newResultObject.name = collateralResult.collateralName;
			newResultObject.storeID = collateralResult.collateralStoreId;

			// populate collateral to the object of its type based on the ad copy command type
			if ((collateralResult.collateralCommandType == "<%= CampaignConstants.URL_PROMOTION_DISPLAY %>") ||
				(collateralResult.collateralCommandType == "<%= CampaignConstants.URL_PROMOTION_ADD %>") ||
				(collateralResult.collateralCommandType == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")) {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>.length] = newResultObject;
				document.initiativeForm.availablePromotionCollateral.options[document.initiativeForm.availablePromotionCollateral.options.length] = new Option(collateralResult.collateralName, collateralResult.collateralId, false, false);
			}
			else if (collateralResult.collateralCommandType == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>.length] = newResultObject;
				document.initiativeForm.availableCouponCollateral.options[document.initiativeForm.availableCouponCollateral.options.length] = new Option(collateralResult.collateralName, collateralResult.collateralId, false, false);
			}
			else {
				initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>.length] = newResultObject;
				initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>.length] = newResultObject;
				document.initiativeForm.availablePromotionCollateral.options[document.initiativeForm.availablePromotionCollateral.options.length] = new Option(collateralResult.collateralName, collateralResult.collateralId, false, false);
				document.initiativeForm.availableCollateral.options[document.initiativeForm.availableCollateral.options.length] = new Option(collateralResult.collateralName, collateralResult.collateralId, false, false);
			}

			// clear collateral result
			top.saveData(null, "collateralResult");
		}
	}
	else if (currentContentType == "whatActionProduct") {
		// check to see if there is any sku in the result set from finder
		var foundSku = top.getData("productSearchSkuArray", null);
		if (foundSku != null) {
			for (var i=0; i<foundSku.length; i++) {
				// add all the sku in the array and put it in the select box
				addSKU(foundSku[i].productSku, foundSku[i].displayText);
			}
			top.saveData(null, "productSearchSkuArray");
		}

		// check to see if there is any sku in the result set from browser
		var browseResult = top.getData("browserSelection", null);
		if (browseResult != null) {
			for (var i=0; i<browseResult.length; i++) {
				// add all the sku in the array and put it in the select box
				addSKU(browseResult[i].refnum, browseResult[i].displayText);
			}
			top.saveData(null, "browserSelection");
		}
	}
	else if (currentContentType == "whichConditionProduct") {
		// check to see if there is any sku in the result set from finder
		var foundSku = top.getData("productSearchSkuArray", null);
		if (foundSku != null) {
			document.initiativeForm.whichSkuValue.value = foundSku[0].productSku;
			document.initiativeForm.whichSkuNameValue.value = foundSku[0].productName;
			top.saveData(null, "productSearchSkuArray");
			addWhichChoice();
		}

		// check to see if there is any sku in the result set from browser
		var browseResult = top.getData("browserSelection", null);
		if (browseResult != null) {
			document.initiativeForm.whichSkuValue.value = browseResult[0].refnum;
			document.initiativeForm.whichSkuNameValue.value = browseResult[0].refName;
			top.saveData(null, "browserSelection");
			addWhichChoice();
		}
	}
	else if (currentContentType == "whatProductFilterCategory") {
		// check to see if there is any category in the result set from category list
		var categoryResult = top.getData("categoryResult", null);
		if (categoryResult != null) {
			document.initiativeForm.productFilterCategoryIdentifier.value = categoryResult[0].categoryIdentifier;
			document.initiativeForm.productFilterCategoryName.value = categoryResult[0].categoryName;
			top.saveData(null, "categoryResult");
		}
	}
	else if (currentContentType == "whatActionCategory") {
		// check to see if there is any category in the result set from category list
		var categoryResult = top.getData("categoryResult", null);
		if (categoryResult != null) {
			for (var i=0; i<categoryResult.length; i++) {
				// add all the categories in the array and put it in the select box
				addCategoryOption(categoryResult[i].categoryIdentifier, categoryResult[i].categoryName);
			}
			top.saveData(null, "categoryResult");
		}
	}
	else if (currentContentType == "whichConditionCategory") {
		// check to see if there is any category in the result set from category list
		var categoryResult = top.getData("categoryResult", null);
		if (categoryResult != null) {
			document.initiativeForm.whichCategoryValue.value = categoryResult[0].categoryIdentifier;
			document.initiativeForm.whichCategoryNameValue.value = categoryResult[0].categoryName;
			top.saveData(null, "categoryResult");
			addWhichChoice();
		}
	}

	// clear the stored content type
	top.saveData(null, "contentType");
}

function findCollateralById (collateralList, collateralId) {
	// try to find the index of the collateral in the original databean...
	for (var j=0; j<collateralList.length; j++) {
		if (collateralList[j].collateralID == collateralId) {
			return j;
		}
	}
	return -1;
}

function resetTargetSegment () {
	with (document.initiativeForm) {
		for (var i=0; i < <%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>.options.length; i++) {
			<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>.options[i].selected = true;
		}
		removeFromSelectedSegments();
		for (var i=0; i < <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>.options.length; i++) {
			<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>.options[i].selected = false;
		}
	}
}

function updateTargetSegmentSelection () {
	with (document.initiativeForm) {
		// find the selected promotion in the promotion data list
		for (var i=0; i<promotionDataContainer.length; i++) {
			if (promotionDataContainer[i].discountId == selectedPromotion.options[selectedPromotion.options.selectedIndex].value) {
				// if the selected promotion is associated with one or more target segment, then
				// update the target segment slosh bucket
				if (promotionDataContainer[i].discountTargetGroup.length > 0) {
					// clear the current selection
					loadSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>, "false");
					showWhoDivisions();
					resetTargetSegment();
					// select the ones that are associated with the selected promotion
					for (var j=0; j<promotionDataContainer[i].discountTargetGroup.length; j++) {
						for (var k=0; k < <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>.options.length; k++) {
							if (promotionDataContainer[i].discountTargetGroup[j] == <%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>.options[k].innerText) {
								<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>.options[k].selected = true;
							}
						}
					}
					addToSelectedSegments();
				}
				else {
					// clear the current selection
					loadSelectValue(<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>, "true");
					showWhoDivisions();
					resetTargetSegment();
				}
				break;
			}
		}
	}
}

function initializeSearchButton () {
	document.initiativeForm.searchPromotionCollateralButton.disabled = false;
	document.initiativeForm.searchPromotionCollateralButton.className = "enabled";
	document.initiativeForm.searchPromotionCollateralButton.id = "enabled";
	document.initiativeForm.searchCouponCollateralButton.disabled = false;
	document.initiativeForm.searchCouponCollateralButton.className = "enabled";
	document.initiativeForm.searchCouponCollateralButton.id = "enabled";
	document.initiativeForm.searchCollateralButton.disabled = false;
	document.initiativeForm.searchCollateralButton.className = "enabled";
	document.initiativeForm.searchCollateralButton.id = "enabled";
}

function changePageElementStateOnSearch (buttonObject) {
	buttonObject.disabled = true;
	buttonObject.className = "disabled";
	buttonObject.id = "disabled";
	top.showProgressIndicator(true);
}

function changePageElementStateOffSearch (buttonObject) {
	buttonObject.disabled = false;
	buttonObject.className = "enabled";
	buttonObject.id = "enabled";
	top.showProgressIndicator(false);
}

function searchPromotionCollateral () {
	document.contentSelectionSearchForm.searchType.value = "promotionCollateral";
	document.contentSelectionSearchForm.searchActionType.value = getSelectValue(document.initiativeForm.promotionCollateralSearchType);
	document.contentSelectionSearchForm.searchString.value = trim(document.initiativeForm.promotionCollateralSearch.value);
	document.contentSelectionSearchForm.initialLoad.value = "N";
	document.contentSelectionSearchForm.submit();
	changePageElementStateOnSearch(document.initiativeForm.searchPromotionCollateralButton);
}

function searchCouponCollateral () {
	document.contentSelectionSearchForm.searchType.value = "couponCollateral";
	document.contentSelectionSearchForm.searchActionType.value = getSelectValue(document.initiativeForm.couponCollateralSearchType);
	document.contentSelectionSearchForm.searchString.value = trim(document.initiativeForm.couponCollateralSearch.value);
	document.contentSelectionSearchForm.initialLoad.value = "N";
	document.contentSelectionSearchForm.submit();
	changePageElementStateOnSearch(document.initiativeForm.searchCouponCollateralButton);
}

function searchCollateral () {
	document.contentSelectionSearchForm.searchType.value = "collateral";
	document.contentSelectionSearchForm.searchActionType.value = getSelectValue(document.initiativeForm.collateralSearchType);
	document.contentSelectionSearchForm.searchString.value = trim(document.initiativeForm.collateralSearch.value);
	document.contentSelectionSearchForm.initialLoad.value = "N";
	document.contentSelectionSearchForm.submit();
	changePageElementStateOnSearch(document.initiativeForm.searchCollateralButton);
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<form name="initiativeForm" onsubmit="return false;" id="initiativeForm">

<h1><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_GENERAL_PANEL_PROMPT) %></h1>

<!-- ======================================== -->
<!-- General definition section               -->
<!-- ======================================== -->

<p/><label for="<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_NAME_PROMPT) %></label><br/>
<script language="JavaScript">
<!-- hide script from old browsers
var newInitiative = true;
if (initiativeDataBean != null && initiativeDataBean.<%= CampaignConstants.ELEMENT_ID %> != "" && "<%=UIUtil.toJavaScript( request.getParameter("newInitiative") )%>" != "true") {
	newInitiative = false;
}
if (newInitiative) {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>" tabindex="1" type="text" size="50" maxlength="64" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>_In_initiativeForm_1"/>');
}
else {
	document.writeln('<input name="<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>" tabindex="1" type="text" size="50" maxlength="64" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>_In_initiativeForm_1" style="border-style:none" readonly="readonly" />');
}
//-->
</script>

<p/><label for="<%= CampaignConstants.ELEMENT_DESCRIPTION %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_DESCRIPTION_PROMPT) %></label><br/>
<textarea name="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" id="<%= CampaignConstants.ELEMENT_DESCRIPTION %>" tabindex="2" rows="4" cols="50" wrap="physical" onkeydown="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>, 254);" onkeyup="limitTextArea(this.form.<%= CampaignConstants.ELEMENT_DESCRIPTION %>, 254);">
</textarea>

<!-- ======================================== -->
<!-- Campaign selection section               -->
<!-- ======================================== -->

<p/><label for="<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_CAMPAIGN_PROMPT) %></label><br/>
<%	if (fromPanel.equals("campaign")) { %>
<i><%=UIUtil.toHTML( campaignName )%></i>
<div id="campaignDiv" style="display: none">
<%	} %>
<select name="<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>" id="<%= CampaignConstants.ELEMENT_CAMPAIGN_ID %>" tabindex="3">
	<option value=""><%= campaignsRB.get(CampaignConstants.MSG_NO_CAMPAIGN) %></option>
<%		for (int i=0; i<numberOfCampaigns; i++) { %>
	<option value="<%= campaignIdList[i] %>"><%= UIUtil.toHTML(campaignNameList[i]) %></option>
<%		} %>
</select>
<%	if (fromPanel.equals("campaign")) { %>
</div>
<%	} %>

<!-- ======================================== -->
<!-- WHEN selection section                   -->
<!-- ======================================== -->

<p/><label for="<%= CampaignConstants.ELEMENT_EVERYDAY %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHEN_DAY_PROMPT) %></label><br/>
<select name="<%= CampaignConstants.ELEMENT_EVERYDAY %>" id="<%= CampaignConstants.ELEMENT_EVERYDAY %>" tabindex="4" onchange="showWhenDivisions()">
	<option value="true"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_EVERYDAY) %></option>
	<option value="false"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_NOT_EVERYDAY) %></option>
</select>
<br/><br/>

<div id="daysDiv" style="display: none; margin-left: 20">

<input type="checkbox" tabindex="5" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.MONDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_1" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_1"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_MONDAY) %></label>

<input type="checkbox" tabindex="6" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.TUESDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_2" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_2"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_TUESDAY) %></label>

<input type="checkbox" tabindex="7" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.WEDNESDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_3" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_3"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_WEDNESDAY) %></label>

<input type="checkbox" tabindex="8" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.THURSDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_4" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_4"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_THURSDAY) %></label>

<input type="checkbox" tabindex="9" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.FRIDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_5" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_5"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_FRIDAY) %></label>

<input type="checkbox" tabindex="10" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.SATURDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_6" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_6"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_SATURDAY) %></label>

<input type="checkbox" tabindex="11" name="<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>" value="<%= CampaignConstants.SUNDAY %>" id="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_7" />
<label for="WC_InitiativePanel_FormInput_<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>_In_initiativeForm_7"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_SUNDAY) %></label>

</div>

<!-- ======================================== -->
<!-- e-Marketing spot and schedule section    -->
<!-- ======================================== -->

<p/><%= campaignsRB.get("initiativeScheduleEmsListPrompt") %><br/>
<%	if (fromPanel.equals("ems")) { %>
<i><%=UIUtil.toHTML( emsName )%>&nbsp;<%= campaignsRB.get("initiativeScheduleReadOnlyNotice") %></i>
<%	} else if (fromPanel.equals("experiment")) { %>
<i><%= campaignsRB.get("initiativeScheduleExperimentStoreElementNotice") %></i>
<%	} else { %>
<iframe id="scheduleEmsList" name="scheduleEmsList" title="<%= UIUtil.toHTML((String)campaignsRB.get("initiativeScheduleEmsListPrompt")) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.InitiativeScheduleEmsList&amp;cmd=CampaignInitiativeScheduleEmsPanelView" width="100%" height="30%">
</iframe>
<%	} %>

<!-- ======================================== -->
<!-- WHAT selection section                   -->
<!-- ======================================== -->

<div id="actionPosition" />

<h1><%= campaignsRB.get("initiativeContentPanelPrompt") %></h1>

<p/><label for="<%= CampaignConstants.ELEMENT_WHAT_TYPE %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_PANEL_PROMPT) %></label><br/>
<select name="<%= CampaignConstants.ELEMENT_WHAT_TYPE %>" id="<%= CampaignConstants.ELEMENT_WHAT_TYPE %>" tabindex="13" onchange="showWhatDivisions()">
<%	for (int i=0; i<whatTypeArray.length; i++) { %>
	<option value="<%= whatTypeArray[i] %>"><%= (String)campaignsRB.get(whatTypeArray[i]) %></option>
<%	} %>
</select>
<br/><br/>

<!-- ======================================== -->
<!-- WHAT selection - Promotion               -->
<!-- ======================================== -->
<div id="contentPromotionDiv" style="display: none; margin-left: 20">
<input type="hidden" name="discountUsage" id="discountUsage"/>
<table id="WC_InitiativePanel_PromotionTable_1">
	<tr>
		<td id="WC_InitiativePanel_PromotionCell_2" valign="top">
			<label for="selectedPromotion"><%= campaignsRB.get("initiativeWhatPromotionPrompt") %></label><br/>
			<select id="selectedPromotion" name="selectedPromotion" tabindex="14" class="selectWidth" size="5" onchange="javascript:setButtonContext(this, document.initiativeForm.summaryPromotionButton);updateTargetSegmentSelection();">
			</select>
		</td>
		<td id="WC_InitiativePanel_PromotionCell_3" valign="top">
			&nbsp;<br/>
			<input type="button" tabindex="15" id="newPromotionButton" name="newPromotionButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_NEW) %>" onclick="newPromotion();" style="width: 150px" /><br/>
			<input type="button" tabindex="16" id="summaryPromotionButton" name="summaryPromotionButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_SUMMARY) %>" onclick="gotoSummaryPromotionDialog();" style="width: 150px" />
		</td>
	</tr>
</table>
<table id="WC_InitiativePanel_PromotionCollateralTable_1">
	<tr>
		<td id="WC_InitiativePanel_PromotionCollateralCell_1" colspan="4">
			<%= campaignsRB.get("initiativeContentSelectionNumberOfContent") %>&nbsp;<span id="promotionCollateralCount" name="promotionCollateralCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_InitiativePanel_PromotionCollateralCell_2">
			<label for="selectedPromotionCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_SELECTED) %></label><br/>
			<select id="selectedPromotionCollateral" name="selectedPromotionCollateral" tabindex="17" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.removeFromPromotionCollateralSloshBucketButton, document.initiativeForm.availablePromotionCollateral, document.initiativeForm.addToPromotionCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedPromotionCollateral, document.initiativeForm.availablePromotionCollateral, document.initiativeForm.summaryPromotionCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_PromotionCollateralCell_3" width="180px" align="center">
			<table id="WC_InitiativePanel_PromotionCollateralTable_2" cellpadding="2" cellspacing="2">
				<tr><td id="WC_InitiativePanel_PromotionCollateralCell_4">
					<input type="button" tabindex="20" id="addToPromotionCollateralSloshBucketButton" name="addToPromotionCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedPromotionCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_PromotionCollateralCell_5">
					<input type="button" tabindex="18" id="removeFromPromotionCollateralSloshBucketButton" name="removeFromPromotionCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedPromotionCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_PromotionCollateralCell_6">
					<input type="button" tabindex="21" id="newPromotionCollateralButton" name="newPromotionCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_NEW) %>  " style="width: 150px" onclick="newCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_PromotionCollateralCell_7">
					<input type="button" tabindex="22" id="summaryPromotionCollateralButton" name="summaryPromotionCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_SUMMARY) %>   " style="width: 150px" onclick="gotoSummaryPromotionCollateralDialog()" />
				</td></tr>
			</table>
		</td>
		<td id="WC_InitiativePanel_PromotionCollateralCell_8">
			<label for="availablePromotionCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_AVAILABLE) %></label><br/>
			<select id="availablePromotionCollateral" name="availablePromotionCollateral" tabindex="19" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.addToPromotionCollateralSloshBucketButton, document.initiativeForm.selectedPromotionCollateral, document.initiativeForm.removeFromPromotionCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedPromotionCollateral, document.initiativeForm.availablePromotionCollateral, document.initiativeForm.summaryPromotionCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_PromotionCollateralCell_9" width="15px"></td>
		<td id="WC_InitiativePanel_PromotionCollateralCell_10" valign="top">
			<table id="WC_InitiativePanel_PromotionCollateralTable_3" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_InitiativePanel_PromotionCollateralCell_11">
						<label for="promotionCollateralSearch"><%= campaignsRB.get("initiativeContentSelectionContentSearchPrompt") %></label><br/>
						<input type="text" id="promotionCollateralSearch" name="promotionCollateralSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_PromotionCollateralCell_12" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_PromotionCollateralCell_13">
						<label for="promotionCollateralSearchType">
						<select id="promotionCollateralSearchType" name="promotionCollateralSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= campaignsRB.get("initiativeSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_PromotionCollateralCell_14" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_PromotionCollateralCell_15" align="right">
						<input type="button" id="searchPromotionCollateralButton" name="searchPromotionCollateralButton" value="  <%= campaignsRB.get("findContent") %>  " style="width: 150px" onclick="searchPromotionCollateral();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Coupon                  -->
<!-- ======================================== -->
<div id="contentCouponDiv" style="display: none; margin-left: 20">
<table id="WC_InitiativePanel_CouponCollateralTable_1">
	<tr>
		<td id="WC_InitiativePanel_CouponCollateralCell_1" colspan="4">
			<%= campaignsRB.get("initiativeContentSelectionNumberOfContent") %>&nbsp;<span id="couponCollateralCount" name="couponCollateralCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_InitiativePanel_CouponCollateralCell_2">
			<label for="selectedCouponCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_SELECTED) %></label><br/>
			<select id="selectedCouponCollateral" name="selectedCouponCollateral" tabindex="17" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.removeFromCouponCollateralSloshBucketButton, document.initiativeForm.availableCouponCollateral, document.initiativeForm.addToCouponCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedCouponCollateral, document.initiativeForm.availableCouponCollateral, document.initiativeForm.summaryCouponCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_CouponCollateralCell_3" width="180px" align="center">
			<table id="WC_InitiativePanel_CouponCollateralTable_2" cellpadding="2" cellspacing="2">
				<tr><td id="WC_InitiativePanel_CouponCollateralCell_4">
					<input type="button" tabindex="20" id="addToCouponCollateralSloshBucketButton" name="addToCouponCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedCouponCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CouponCollateralCell_5">
					<input type="button" tabindex="18" id="removeFromCouponCollateralSloshBucketButton" name="removeFromCouponCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedCouponCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CouponCollateralCell_6">
					<input type="button" tabindex="21" id="newCouponCollateralButton" name="newCouponCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_NEW) %>  " style="width: 150px" onclick="newCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CouponCollateralCell_7">
					<input type="button" tabindex="22" id="summaryCouponCollateralButton" name="summaryCouponCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_SUMMARY) %>   " style="width: 150px" onclick="gotoSummaryCouponCollateralDialog()" />
				</td></tr>
			</table>
		</td>
		<td id="WC_InitiativePanel_CouponCollateralCell_8">
			<label for="availableCouponCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_AVAILABLE) %></label><br/>
			<select id="availableCouponCollateral" name="availableCouponCollateral" tabindex="19" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.addToCouponCollateralSloshBucketButton, document.initiativeForm.selectedCouponCollateral, document.initiativeForm.removeFromCouponCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedCouponCollateral, document.initiativeForm.availableCouponCollateral, document.initiativeForm.summaryCouponCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_CouponCollateralCell_9" width="15px"></td>
		<td id="WC_InitiativePanel_CouponCollateralCell_10" valign="top">
			<table id="WC_InitiativePanel_CouponCollateralTable_3" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_InitiativePanel_CouponCollateralCell_11">
						<label for="couponCollateralSearch"><%= campaignsRB.get("initiativeContentSelectionContentSearchPrompt") %></label><br/>
						<input type="text" id="couponCollateralSearch" name="couponCollateralSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CouponCollateralCell_12" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CouponCollateralCell_13">
						<label for="couponCollateralSearchType">
						<select id="couponCollateralSearchType" name="couponCollateralSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= campaignsRB.get("initiativeSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CouponCollateralCell_14" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CouponCollateralCell_15" align="right">
						<input type="button" id="searchCouponCollateralButton" name="searchCouponCollateralButton" value="  <%= campaignsRB.get("findContent") %>  " style="width: 150px" onclick="searchCouponCollateral();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Product Recommendation  -->
<!-- ======================================== -->
<div id="contentProductDiv" style="display: none; margin-left: 20">
<label for="<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>"><%= campaignsRB.get("initiativeWhatProductMethodPrompt") %></label><br/>
<select name="<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>" id="<%= CampaignConstants.ELEMENT_WHAT_TYPE_PRODUCT %>" tabindex="29" onchange="showWhatProductDivisions()">
<%	for (int i=0; i<CampaignConstants.whatTypeProductArray.length; i++) { %>
	<option value="<%= CampaignConstants.whatTypeProductArray[i] %>"><%= (String)campaignsRB.get(CampaignConstants.whatTypeProductArray[i]) %></option>
<%	} %>
</select>
<br/><br/>

<div id="contentProductSpecificDiv" style="display: none; margin-left: 20">
<table id="WC_InitiativePanel_Table_4">
	<tr>
		<td valign="top" colspan="2" id="WC_InitiativePanel_TableCell_10"><label for="productSKU"><%= campaignsRB.get("initiativeWhatProductSpecificPrompt") %></label></td>
	</tr>
	<tr>
		<td valign="top" id="WC_InitiativePanel_TableCell_11">
			<input type="text" tabindex="30" name="productSKU" size="43" maxlength="64" id="productSKU" />
		</td>
		<td valign="top" id="WC_InitiativePanel_TableCell_12">
			<input type="button" tabindex="31" name="whatAddProductButton" value="<%= campaignsRB.get("addnoellipsis") %>" onclick="addWhatProduct();" class="enabled" id="whatAddProductButton" /><br/>
		</td>
	</tr>
</table>
<table id="WC_InitiativePanel_Table_5">
	<tr>
		<td colspan="2" id="WC_InitiativePanel_TableCell_13"><label for="selectedSKUs"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_SELECTED_PRODUCTS) %></label></td>
	</tr>
	<tr>
		<td id="WC_InitiativePanel_TableCell_14">
			<select name="selectedSKUs" id="selectedSKUs" tabindex="34" class="selectWidth" multiple="multiple" size="5" onchange="javascript:setButtonContext(this, document.initiativeForm.whatRemoveProductButton);">
			</select>
		</td>
		<td valign="top" id="WC_InitiativePanel_TableCell_15">
			<input type="button" tabindex="32" name="whatSearchProductButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_FIND_ELLIPSIS) %>" onclick="gotoSearchProductDialog('whatActionProduct');" class="enabled" id="whatSearchProductButton" /><br/>
			<input type="button" tabindex="33" name="whatBrowseProductButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_BROWSE_ELLIPSIS) %>" onclick="gotoBrowseProductDialog('whatActionProduct');" class="enabled" id="whatBrowseProductButton" /><br/>
			<input type="button" tabindex="35" name="whatRemoveProductButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_REMOVE) %>" onclick="removeSKU(this.form.selectedSKUs);" class="enabled" id="whatRemoveProductButton" />
		</td>
	</tr>
</table>
</div>

<div id="contentProductMultiOptionFilterDiv" style="display: none; margin-left: 20">
<table id="WC_InitiativePanel_Table_6" cellpadding="3" cellspacing="3">
	<tr valign="middle">
		<td valign="middle" id="WC_InitiativePanel_TableCell_16">
			<label for="productFilterCategoryName"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_CATEGORY) %></label>
			<br/>&nbsp;&nbsp;&nbsp;&nbsp;
<script language="JavaScript">
<!-- hide script from old browsers
// display the category language
var databean = parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
document.writeln('(' + databean.categoryLanguageDescription + ')');
//-->
</script>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_17">
			<input type="hidden" name="productFilterCategoryIdentifier" id="productFilterCategoryIdentifier" />
			<input type="text" tabindex="36" name="productFilterCategoryName" size="34" maxlength="64" readonly="readonly" id="productFilterCategoryName" />
			&nbsp;
			<input type="button" tabindex="37" name="productFilterListCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_LIST_ELLIPSIS) %>" onclick="gotoListCategoryDialog('whatProductFilterCategory');" class="enabled" id="productFilterListCategoryButton" />
			&nbsp;
			<input type="button" tabindex="38" name="productFilterClearCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_CLEAR) %>" onclick="productFilterClearCategory();" class="enabled" id="productFilterClearCategoryButton" />
		</td>
	</tr>
	<tr>
		<td valign="middle" id="WC_InitiativePanel_TableCell_18">
			<label for="productDescriptionKeyword"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_PRODUCT_DESCRIPTION) %></label>
			<br/>&nbsp;&nbsp;&nbsp;&nbsp;
<script language="JavaScript">
<!-- hide script from old browsers
// display the product language
var databean = parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
document.writeln('(' + databean.productLanguageDescription + ')');
//-->
</script>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_19">
			<input type="text" tabindex="39" name="productDescriptionKeyword" size="34" maxlength="64" id="productDescriptionKeyword" />
		</td>
	</tr>
	<tr>
		<td valign="middle" id="WC_InitiativePanel_TableCell_20">
			<label for="skuBeginWith"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_SKU_BEGIN_WITH) %></label>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_21">
			<input type="text" tabindex="40" name="skuBeginWith" size="34" maxlength="64" id="skuBeginWith" />
		</td>
	</tr>
	<tr>
		<td valign="middle" id="WC_InitiativePanel_TableCell_22">
			<label for="inventoryLowSymbol"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_INVENTORY_LEVEL) %></label>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_23">
			<select name="inventoryLowSymbol" id="inventoryLowSymbol" tabindex="41" size="1" onchange="toggleInventoryFields()">
				<option selected="selected" value=""><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_NA) %></option>
<%
	for (int i=0; i<CampaignConstants.operatorArray.length; i++) {
		if (CampaignConstants.operatorArray[i].equals(CampaignConstants.EQUAL_TO)) continue;  // skip the equals sign on inventory (meaningless)
%>
				<option value="<%= CampaignConstants.operatorArray[i] %>"><%= campaignsRB.get("initiativeWhat" + CampaignConstants.operatorArray[i]) %></option>
<%	} %>
			</select>
			<label for="inventoryLowValue"></label><input type="text" tabindex="42" name="inventoryLowValue" size="16" maxlength="14" value="" disabled="disabled" class="disabledBox" id="inventoryLowValue" />&nbsp;<label for="inventoryHighSymbol"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_AND) %></label>
			<select name="inventoryHighSymbol" id="inventoryHighSymbol" tabindex="43" size="1" onchange="toggleInventoryFields()" disabled="disabled" class="disabledBox">
				<option value="" selected="selected"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_NA) %></option>
				<option value="<%= CampaignConstants.LESS_THAN %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_LESS_THAN) %></option>
			</select>
			<label for="inventoryHighValue"></label><input type="text" tabindex="44" name="inventoryHighValue" size="16" maxlength="14" value="" disabled="disabled" class="disabledBox" id="inventoryHighValue" />
		</td>
	</tr>
	<tr>
		<td valign="middle" id="WC_InitiativePanel_TableCell_24">
			<label for="offerPriceLowSymbol"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_OFFER_PRICE) %></label>
<script language="JavaScript">
<!-- hide script from old browsers
// display the default merchant currency
var databean = parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
document.writeln('(' + databean.currency + ')');
//-->
</script>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_25">
			<select name="offerPriceLowSymbol" id="offerPriceLowSymbol" tabindex="45" size="1" onchange="togglePriceFields()">
				<option selected="selected" value=""><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_NA) %></option>
<%	for (int i=0; i<CampaignConstants.operatorArray.length; i++) { %>
				<option value="<%= CampaignConstants.operatorArray[i] %>"><%= campaignsRB.get("initiativeWhat"+CampaignConstants.operatorArray[i]) %></option>
<%	} %>
			</select>
			<label for="offerPriceLowValue"></label><input type="text" tabindex="46" name="offerPriceLowValue" size="16" maxlength="14" disabled="disabled" class="disabledBox" id="offerPriceLowValue" />&nbsp;<label for="offerPriceHighSymbol"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_AND) %></label>
			<select name="offerPriceHighSymbol" id="offerPriceHighSymbol" tabindex="47" size="1" onchange="togglePriceFields()" disabled="disabled" class="disabledBox">
				<option selected="selected" value=""><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_NA) %></option>
				<option value="<%= CampaignConstants.LESS_THAN %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_LESS_THAN) %></option>
			</select>
			<label for="offerPriceHighValue"></label><input type="text" tabindex="48" name="offerPriceHighValue" size="16" maxlength="14" disabled="disabled" class="disabledBox" id="offerPriceHighValue" />
		</td>
	</tr>
	<tr>
		<td valign="middle" id="WC_InitiativePanel_TableCell_26">
			<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_AVAILABLE_AFTER) %>
		</td>
		<td valign="middle" id="WC_InitiativePanel_TableCell_27">
			<table id="WC_InitiativePanel_Table_7" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_InitiativePanel_TableCell_28"><label for="availableAfterYear"><%= campaignsRB.get(CampaignConstants.MSG_YEAR_PROMPT) %></label></td>
					<td id="WC_InitiativePanel_TableCell_29">&nbsp;</td>
					<td id="WC_InitiativePanel_TableCell_30"><label for="availableAfterMonth"><%= campaignsRB.get(CampaignConstants.MSG_MONTH_PROMPT) %></label></td>
					<td id="WC_InitiativePanel_TableCell_31">&nbsp;</td>
					<td id="WC_InitiativePanel_TableCell_32"><label for="availableAfterDay"><%= campaignsRB.get(CampaignConstants.MSG_DAY_PROMPT) %></label></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_TableCell_33"><input type="text" tabindex="50" name="availableAfterYear" size="4" maxlength="4" id="availableAfterYear" /></td>
					<td id="WC_InitiativePanel_TableCell_34"></td>
					<td id="WC_InitiativePanel_TableCell_35"><input type="text" tabindex="51" name="availableAfterMonth" size="2" maxlength="2" id="availableAfterMonth" /></td>
					<td id="WC_InitiativePanel_TableCell_36"></td>
					<td id="WC_InitiativePanel_TableCell_37"><input type="text" tabindex="52" name="availableAfterDay" size="2" maxlength="2" id="availableAfterDay" /></td>
					<td id="WC_InitiativePanel_TableCell_38">&nbsp;</td>
					<td id="WC_InitiativePanel_TableCell_39">
						<a href="javascript:setupDate();showCalendar(document.initiativeForm.calImg)" id="WC_InitiativePanel_Link_1">
						<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImg" alt='<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>'/></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div id="languageDiv" style="display: none; margin-left: 50">
<p><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_MIXED_LANGUAGE) %></p>
</div>
</div>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Category Recommendation -->
<!-- ======================================== -->
<div id="contentCategoryDiv" style="display: none; margin-left: 20">
<table id="WC_InitiativePanel_Table_8">
	<tr>
		<td valign="top" colspan="2" id="WC_InitiativePanel_TableCell_40"><label for="categoryIdentifier"><%= campaignsRB.get("initiativeWhatCategoryIdentifier") %></label></td>
	</tr>
	<tr>
		<td valign="top" id="WC_InitiativePanel_TableCell_41">
			<input type="text" tabindex="53" name="categoryIdentifier" size="43" maxlength="64" id="categoryIdentifier" />
		</td>
		<td valign="top" id="WC_InitiativePanel_TableCell_42">
			<input type="button" tabindex="54" name="whatAddCategoryButton" value="<%= campaignsRB.get("addnoellipsis") %>" onclick="addWhatCategory();" class="enabled" id="whatAddCategoryButton" /><br/>
		</td>
	</tr>
</table>
<table id="WC_InitiativePanel_Table_9">
	<tr>
		<td colspan="2" id="WC_InitiativePanel_TableCell_43"><label for="selectedCategory"><%= campaignsRB.get("initiativeWhatSelectedCategory") %></label></td>
	</tr>
	<tr>
		<td id="WC_InitiativePanel_TableCell_44">
			<select name="selectedCategory" id="selectedCategory" tabindex="56" class="selectWidth" multiple="multiple" size="5" onchange="javascript:setButtonContext(this, document.initiativeForm.whatRemoveCategoryButton);">
			</select>
		</td>
		<td valign="top" id="WC_InitiativePanel_TableCell_45">
			<input type="button" tabindex="55" name="whatListCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_LIST_ELLIPSIS) %>" onclick="gotoListCategoryDialog('whatActionCategory');" class="enabled" id="whatListCategoryButton" /><br/>
			<input type="button" tabindex="57" name="whatRemoveCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_REMOVE) %>" onclick="removeCategory(this.form.selectedCategory);" class="enabled" id="whatRemoveCategoryButton" />
		</td>
	</tr>
</table>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Advertisement           -->
<!-- ======================================== -->
<div id="contentAdDiv" style="display: none; margin-left: 20">
<table id="WC_InitiativePanel_CollateralTable_1">
	<tr>
		<td id="WC_InitiativePanel_CollateralCell_1" colspan="4">
			<%= campaignsRB.get("initiativeContentSelectionNumberOfContent") %>&nbsp;<span id="collateralCount" name="collateralCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_InitiativePanel_CollateralCell_2">
			<label for="selectedCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_SELECTED) %></label><br/>
			<select id="selectedCollateral" name="selectedCollateral" tabindex="58" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.removeFromCollateralSloshBucketButton, document.initiativeForm.availableCollateral, document.initiativeForm.addToCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedCollateral, document.initiativeForm.availableCollateral, document.initiativeForm.summaryCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_CollateralCell_3" width="180px" align="center">
			<table id="WC_InitiativePanel_CollateralTable_2" cellpadding="2" cellspacing="2">
				<tr><td id="WC_InitiativePanel_CollateralCell_4">
					<input type="button" tabindex="61" id="addToCollateralSloshBucketButton" name="addToCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CollateralCell_5">
					<input type="button" tabindex="59" id="removeFromCollateralSloshBucketButton" name="removeFromCollateralSloshBucketButton" value="  <%= campaignsRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CollateralCell_6">
					<input type="button" tabindex="62" id="newCollateralButton" name="newCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_NEW) %>  " style="width: 150px" onclick="newCollateral();" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_CollateralCell_7">
					<input type="button" tabindex="63" id="summaryCollateralButton" name="summaryCollateralButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_SUMMARY) %>   " style="width: 150px" onclick="gotoSummaryCollateralDialog()" />
				</td></tr>
			</table>
		</td>
		<td id="WC_InitiativePanel_CollateralCell_8">
			<label for="availableCollateral"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHAT_COLLATERAL_AVAILABLE) %></label><br/>
			<select id="availableCollateral" name="availableCollateral" tabindex="60" class="sloshBucketWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.addToCollateralSloshBucketButton, document.initiativeForm.selectedCollateral, document.initiativeForm.removeFromCollateralSloshBucketButton);initializeSummaryButton(document.initiativeForm.selectedCollateral, document.initiativeForm.availableCollateral, document.initiativeForm.summaryCollateralButton);">
			</select>
		</td>
		<td id="WC_InitiativePanel_CollateralCell_9" width="15px"></td>
		<td id="WC_InitiativePanel_CollateralCell_10" valign="top">
			<table id="WC_InitiativePanel_CollateralTable_3" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_InitiativePanel_CollateralCell_11">
						<label for="collateralSearch"><%= campaignsRB.get("initiativeContentSelectionContentSearchPrompt") %></label><br/>
						<input type="text" id="collateralSearch" name="collateralSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CollateralCell_12" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CollateralCell_13">
						<label for="collateralSearchType">
						<select id="collateralSearchType" name="collateralSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= campaignsRB.get("initiativeSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("initiativeSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= campaignsRB.get("initiativeSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CollateralCell_14" height="4"></td>
				</tr>
				<tr>
					<td id="WC_InitiativePanel_CollateralCell_15" align="right">
						<input type="button" id="searchCollateralButton" name="searchCollateralButton" value="  <%= campaignsRB.get("findContent") %>  " style="width: 150px" onclick="searchCollateral();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Up-sell product         -->
<!-- ======================================== -->
<div id="contentUpSellProductDiv" style="display: none; margin-left: 20">
<label for="upSellContentType"><%= campaignsRB.get("initiativeWhatProductMethodPrompt") %></label><br/>
<select name="upSellContentType" id="upSellContentType" tabindex="64">
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_CONTENT_OF_CURRENT_PAGE %>"><%= campaignsRB.get("initiativeWhatUpSellContentOfCurrentPage") %></option>
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_SHOPPING_CART_CONTAINS %>"><%= campaignsRB.get("initiativeWhatUpSellShoppingCartContains") %></option>
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_PURCHASE_HISTORY_CONTAINS %>"><%= campaignsRB.get("initiativeWhatUpSellPreviousPurchaseContains") %></option>
</select>
</div>

<!-- ======================================== -->
<!-- WHAT selection - Cross-sell product      -->
<!-- ======================================== -->
<div id="contentCrossSellProductDiv" style="display: none; margin-left: 20">
<label for="crossSellContentType"><%= campaignsRB.get("initiativeWhatProductMethodPrompt") %></label><br/>
<select name="crossSellContentType" id="crossSellContentType" tabindex="65">
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_CONTENT_OF_CURRENT_PAGE %>"><%= campaignsRB.get("initiativeWhatCrossSellContentOfCurrentPage") %></option>
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_SHOPPING_CART_CONTAINS %>"><%= campaignsRB.get("initiativeWhatCrossSellShoppingCartContains") %></option>
	<option value="<%= CampaignConstants.SELL_CONTENT_TYPE_PURCHASE_HISTORY_CONTAINS %>"><%= campaignsRB.get("initiativeWhatCrossSellPreviousPurchaseContains") %></option>
</select>
</div>

<!-- ======================================== -->
<!-- WHO condition section                    -->
<!-- ======================================== -->

<div id="conditionPosition" />

<p/><label for="<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_PANEL_PROMPT) %></label><br/>
<select name="<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>" id="<%= CampaignConstants.ELEMENT_TARGET_ALL_SHOPPERS %>" tabindex="66" onchange="showWhoDivisions()">
	<option value="true"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_ALL_SHOPPERS) %></option>
	<option value="false"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_TARGET_SEGMENTS) %></option>
</select>
<br/><br/>

<div id="segmentsDiv" style="display: none; margin-left: 20">

<table id="WC_InitiativePanel_Table_11">
	<tr>
		<td id="WC_InitiativePanel_TableCell_49">
			<label for="<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_SEGMENTS_SELECTED_PROMPT) %></label><br/>
			<select name="<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>" id="<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>" tabindex="67" class="selectWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.removeFromSegmentSloshBucketButton, document.initiativeForm.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, document.initiativeForm.addToSegmentSloshBucketButton);initializeSummaryButton(document.initiativeForm.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, document.initiativeForm.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, document.initiativeForm.summarySegmentButton);">
			</select>
		</td>
		<td width="180px" align="center" id="WC_InitiativePanel_TableCell_50">
			<table id="WC_InitiativePanel_Table_15" cellpadding="2" cellspacing="2">
				<tr><td id="WC_InitiativePanel_TableCell_64">
					<input type="button" tabindex="70" name="addToSegmentSloshBucketButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_ADD_BUTTON) %>  " style="width: 150px" onclick="addToSelectedSegments()" id="addToSegmentSloshBucketButton" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_TableCell_65">
					<input type="button" tabindex="68" name="removeFromSegmentSloshBucketButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_REMOVE_BUTTON) %>  " style="width: 150px" onclick="removeFromSelectedSegments()" id="removeFromSegmentSloshBucketButton" />
				</td></tr>
				<tr><td id="WC_InitiativePanel_TableCell_66">
					<input type="button" tabindex="71" name="summarySegmentButton" value="  <%= campaignsRB.get(CampaignConstants.MSG_BUTTON_SUMMARY) %>  " style="width: 150px" onclick="gotoSummarySegmentDialog()" id="summarySegmentButton" />
				</td></tr>
			</table>
		</td>
		<td id="WC_InitiativePanel_TableCell_51">
			<label for="<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_WHO_SEGMENTS_AVAILABLE_PROMPT) %></label><br/>
			<select name="<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>" id="<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>" tabindex="69" class="selectWidth" size="10" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.initiativeForm.addToSegmentSloshBucketButton, document.initiativeForm.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, document.initiativeForm.removeFromSegmentSloshBucketButton);initializeSummaryButton(document.initiativeForm.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>, document.initiativeForm.<%= CampaignConstants.ELEMENT_AVAILABLE_SEGMENTS %>, document.initiativeForm.summarySegmentButton);">
			</select>
		</td>
	</tr>
</table>

</div>

<!-- ======================================== -->
<!-- WHICH condition section                  -->
<!-- ======================================== -->

<p/><label for="whichActionType"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_PROMPT) %></label><br/>
<select name="whichActionType" id="whichActionType" tabindex="72" onchange="showWhichDivisions()">
<script language="JavaScript">
<!-- hide script from old browsers
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
document.writeln('<option value="<%= CampaignConstants.whenArray[i] %>">' + getWhichText("<%= CampaignConstants.whenArray[i] %>") + '</option>');
<%	} %>
//-->
</script>
</select>
<br/><br/>

<div id="whichSkuDiv" style="display: none; margin-left: 25">
	<label for="whichSkuValue"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_TYPE_SKU) %></label><br/>
	<input type="hidden" name="whichSkuNameValue" id="whichSkuNameValue" />
	<input type="text" tabindex="75" name="whichSkuValue" size="50" maxlength="64" id="whichSkuValue" />
	&nbsp;
	<input type="button" tabindex="76" name="whichAddSkuButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_ADD_NO_ELLIPSIS) %>" onclick="addWhichProduct();" class="enabled" id="whichAddSkuButton" />
	&nbsp;
	<input type="button" tabindex="73" name="whichSearchProductButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_FIND_ELLIPSIS) %>" onclick="gotoSearchProductDialog('whichConditionProduct');" class="enabled" id="whichSearchProductButton" />
	&nbsp;
	<input type="button" tabindex="74" name="whichBrowseProductButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_BROWSE_ELLIPSIS) %>" onclick="gotoBrowseProductDialog('whichConditionProduct');" class="enabled" id="whichBrowseProductButton" />
</div>
<div id="whichCategoryDiv" style="display: none; margin-left: 25">
	<label for="whichCategoryValue"><%= campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_TYPE_CATEGORY) %></label><br/>
	<input type="hidden" name="whichCategoryNameValue" id="whichCategoryNameValue" />
	<input type="text" tabindex="78" name="whichCategoryValue" size="50" maxlength="64" id="whichCategoryValue" />
	&nbsp;
	<input type="button" tabindex="79" name="whichAddCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_ADD_NO_ELLIPSIS) %>" onclick="addWhichCategory();" class="enabled" id="whichAddCategoryButton" />
	&nbsp;
	<input type="button" tabindex="77" name="whichListCategoryButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_LIST_ELLIPSIS) %>" onclick="gotoListCategoryDialog('whichConditionCategory');" class="enabled" id="whichListCategoryButton" />
</div>
<div id="whichPriceDiv" style="display: none; margin-left: 25">
	<%= campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_TYPE_PRICE) %><br/>
<script language="JavaScript">
<!-- hide script from old browsers
var defaultCurrency = initiativeDataBean.currency;
var defaultLanguageId = initiativeDataBean.languageId;
document.writeln('<input type="text" tabindex="80" name="whichPriceValue" id="whichPriceValue" size="20" maxlength="14"> ' + defaultCurrency);
//-->
</script>
	&nbsp;
	<input type="button" tabindex="81" name="whichAddPriceButton" value="<%= campaignsRB.get(CampaignConstants.MSG_BUTTON_ADD_NO_ELLIPSIS) %>" onclick="addWhichChoice();" class="enabled" id="whichAddPriceButton" />
</div>
<br/>
<iframe id="whichList" name="whichList" title="<%= UIUtil.toHTML((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_PROMPT)) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.InitiativeWhichList&amp;cmd=CampaignInitiativeWhichPanelView" width="100%" height="30%">
</iframe>

<input type="hidden" name="categoryLanguageId" value="<%= loginLanguageId %>" id="categoryLanguageId" />
<input type="hidden" name="productDescriptionLanguageId" value="<%= loginLanguageId %>" id="productDescriptionLanguageId" />
<input type="hidden" name="initiative<%= CampaignConstants.ELEMENT_DISABLED %>" id="initiative<%= CampaignConstants.ELEMENT_DISABLED %>" />

<script language="JavaScript" for="document" event="onclick()">
<!-- hide script from old browsers
document.all.CalFrame.style.display = "none";
//-->
</script>

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<iframe id="CalFrame" title="' + top.calendarTitle + '" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" src="Calendar" style="display: none; position: absolute; width: 198; height: 230"></iframe>');
//-->
</script>

</form>

<form id="catalogValidatorForm" name="catalogValidatorForm" action="CampaignInitiativeCatalogValidatorView" target="catalogValidator" method="post">
<input type="hidden" name="searchType" id="searchType"/>
<input type="hidden" name="locationType" id="locationType"/>
<input type="hidden" name="categoryIdentifier" id="categoryIdentifier"/>
<input type="hidden" name="productSku" id="productSku"/>
</form>

<iframe id="catalogValidator" name="catalogValidator" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

<form id="contentSelectionSearchForm" name="contentSelectionSearchForm" action="CampaignInitiativeContentSelectionSearchView" target="contentSelectionSearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>

<iframe id="contentSelectionSearchFrame" name="contentSelectionSearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

</body>

</html>
