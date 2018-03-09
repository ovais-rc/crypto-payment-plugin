<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.ExperimentRuleConstants" %>

<%@ include file="common.jsp" %>

<%
	// define size for search buttons based on the length of their labels
	int searchPromotionButtonLength = 0;
	if (experimentRB.get("findPromotion") != null) {
		searchPromotionButtonLength = (((String)experimentRB.get("findPromotion")).length() * 7) + 20;
	}
	int searchProductButtonLength = 0;
	if (experimentRB.get("findProduct") != null) {
		searchProductButtonLength = (((String)experimentRB.get("findProduct")).length() * 7) + 20;
	}
	int searchCategoryButtonLength = 0;
	if (experimentRB.get("findCategory") != null) {
		searchCategoryButtonLength = (((String)experimentRB.get("findCategory")).length() * 7) + 20;
	}
	int searchCollateralButtonLength = 0;
	if (experimentRB.get("findContent") != null) {
		searchCollateralButtonLength = (((String)experimentRB.get("findContent")).length() * 7) + 20;
	}

	// keep the minimum size of search buttons to 150
	if (searchPromotionButtonLength < 150) {
		searchPromotionButtonLength = 150;
	}
	if (searchProductButtonLength < 150) {
		searchProductButtonLength = 150;
	}
	if (searchCategoryButtonLength < 150) {
		searchCategoryButtonLength = 150;
	}
	if (searchCollateralButtonLength < 150) {
		searchCollateralButtonLength = 150;
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
<title><%= experimentRB.get("experimentContentSelectionDialogTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/SwapList.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/experimentation/Experiment.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var isPromotionLoaded = false;
var isProductLoaded = false;
var isCategoryLoaded = false;
var isCollateralLoaded = false;

function loadPanelData () {
	with (document.experimentContentSelectionForm) {
		// initialize all slosh buckets
		initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
		initializeSloshBuckets(selectedProduct, removeFromProductSloshBucketButton, availableProduct, addToProductSloshBucketButton);
		initializeSloshBuckets(selectedCategory, removeFromCategorySloshBucketButton, availableCategory, addToCategorySloshBucketButton);
		initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);

		// initialize the state of buttons in the page
		initializeButton();
		initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
		initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
		setButtonContext(selectedPromotion, summaryPromotionButton);

		// pre-populate content type selection
		var contentTypeSelection = top.getData("contentTypeSelection");
		if (contentTypeSelection != null) {
			loadSelectValue(contentType, contentTypeSelection);
			top.saveData(null, "contentTypeSelection");
		}

		// pre-populate promotion selection
		var promotionSelection = top.getData("promotionSelection");
		if (promotionSelection != null) {
			for (var i=0; i<promotionSelection.length; i++) {
				selectedPromotion.options[i] = new Option(promotionSelection[i].name, promotionSelection[i].id, false, false);
				if (promotionSelection[i].selected) {
					selectedPromotion.options[i].selected = true;
				}
			}
			top.saveData(null, "promotionSelection");
		}

		// pre-populate promotion collateral selection
		var promotionCollateralSelection = top.getData("promotionCollateralSelection");
		if (promotionCollateralSelection != null) {
			for (var i=0; i<promotionCollateralSelection.length; i++) {
				selectedPromotionCollateral.options[i] = new Option(promotionCollateralSelection[i].name, promotionCollateralSelection[i].id, false, false);
			}
			top.saveData(null, "promotionCollateralSelection");
		}

		// pre-populate product selection
		var productSelection = top.getData("productSelection");
		if (productSelection != null) {
			for (var i=0; i<productSelection.length; i++) {
				selectedProduct.options[i] = new Option(productSelection[i].name, productSelection[i].id, false, false);
			}
			top.saveData(null, "productSelection");
		}

		// pre-populate category selection
		var categorySelection = top.getData("categorySelection");
		if (categorySelection != null) {
			for (var i=0; i<categorySelection.length; i++) {
				selectedCategory.options[i] = new Option(categorySelection[i].name, categorySelection[i].id, false, false);
			}
			top.saveData(null, "categorySelection");
		}

		// pre-populate collateral selection
		var collateralSelection = top.getData("collateralSelection");
		if (collateralSelection != null) {
			for (var i=0; i<collateralSelection.length; i++) {
				selectedCollateral.options[i] = new Option(collateralSelection[i].name, collateralSelection[i].id, false, false);
			}
			top.saveData(null, "collateralSelection");
		}

		// pre-populate up-sell selection
		var upSellSelection = top.getData("upSellSelection");
		if (upSellSelection != null) {
			loadSelectValue(upSellContentType, upSellSelection);
			top.saveData(null, "upSellSelection");
		}

		// pre-populate cross-sell selection
		var crossSellSelection = top.getData("crossSellSelection");
		if (crossSellSelection != null) {
			loadSelectValue(crossSellContentType, crossSellSelection);
			top.saveData(null, "crossSellSelection");
		}
	}

	// select the proper division to show and hide others
	showContentDivisions();

	// complete loading of this page
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

function validatePanelData () {
	with (document.experimentContentSelectionForm) {
		var contentTypeValue = getSelectValue(contentType);
		if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
			// validate promotion selection
			if (countSelected(selectedPromotion) == 0) {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseSelectOnePromotion")) %>");
				return false;
			}
			// validate promotion collateral selection
			if (isListBoxEmpty(selectedPromotionCollateral)) {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseSelectAtLeastOnePromotionContent")) %>");
				return false;
			}
		}
		else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION %>") {
			// validate product selection
			if (isListBoxEmpty(selectedProduct)) {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseSelectAtLeastOneProduct")) %>");
				return false;
			}
		}
		else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION %>") {
			// validate category selection
			if (isListBoxEmpty(selectedCategory)) {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseSelectAtLeastOneCategory")) %>");
				return false;
			}
		}
		else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>") {
			// validate collateral selection
			if (isListBoxEmpty(selectedCollateral)) {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseSelectAtLeastOneContent")) %>");
				return false;
			}
		}
	}
	return true;
}

function savePanelData () {
	with (document.experimentContentSelectionForm) {
		// save selected content type to top model
		top.saveData(getSelectValue(contentType), "contentTypeSelection");

		// save promotion selection to top model
		var promotionSelection = new Array();
		for (var i=0; i<selectedPromotion.options.length; i++) {
			promotionSelection[i] = new Object();
			promotionSelection[i].id = selectedPromotion.options[i].value;
			promotionSelection[i].name = selectedPromotion.options[i].innerText;
			promotionSelection[i].selected = selectedPromotion.options[i].selected;
		}
		top.saveData(promotionSelection, "promotionSelection");

		// save promotion collateral selection to top model
		var promotionCollateralSelection = new Array();
		for (var i=0; i<selectedPromotionCollateral.options.length; i++) {
			promotionCollateralSelection[i] = new Object();
			promotionCollateralSelection[i].id = selectedPromotionCollateral.options[i].value;
			promotionCollateralSelection[i].name = selectedPromotionCollateral.options[i].innerText;
		}
		top.saveData(promotionCollateralSelection, "promotionCollateralSelection");

		// save product selection to top model
		var productSelection = new Array();
		for (var i=0; i<selectedProduct.options.length; i++) {
			productSelection[i] = new Object();
			productSelection[i].id = selectedProduct.options[i].value;
			productSelection[i].name = selectedProduct.options[i].innerText;
		}
		top.saveData(productSelection, "productSelection");

		// save category selection to top model
		var categorySelection = new Array();
		for (var i=0; i<selectedCategory.options.length; i++) {
			categorySelection[i] = new Object();
			categorySelection[i].id = selectedCategory.options[i].value;
			categorySelection[i].name = selectedCategory.options[i].innerText;
		}
		top.saveData(categorySelection, "categorySelection");

		// save collateral selection to top model
		var collateralSelection = new Array();
		for (var i=0; i<selectedCollateral.options.length; i++) {
			collateralSelection[i] = new Object();
			collateralSelection[i].id = selectedCollateral.options[i].value;
			collateralSelection[i].name = selectedCollateral.options[i].innerText;
		}
		top.saveData(collateralSelection, "collateralSelection");

		// save up-sell selection to top model
		top.saveData(getSelectValue(upSellContentType), "upSellSelection");

		// save cross-sell selection to top model
		top.saveData(getSelectValue(crossSellContentType), "crossSellSelection");
	}
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("experimentContentSelectionPanel");
}

function initializeButton () {
	with (document.experimentContentSelectionForm) {
		searchPromotionButton.disabled = false;
		searchPromotionButton.className = "enabled";
		searchPromotionButton.id = "enabled";
		searchProductButton.disabled = false;
		searchProductButton.className = "enabled";
		searchProductButton.id = "enabled";
		searchCategoryButton.disabled = false;
		searchCategoryButton.className = "enabled";
		searchCategoryButton.id = "enabled";
		searchPromotionCollateralButton.disabled = false;
		searchPromotionCollateralButton.className = "enabled";
		searchPromotionCollateralButton.id = "enabled";
		searchCollateralButton.disabled = false;
		searchCollateralButton.className = "enabled";
		searchCollateralButton.id = "enabled";
<%	if (CampaignUtil.isPromotionAccessible(experimentCommandContext.getStore().getStoreType())) { %>
		newPromotionButton.disabled = false;
		newPromotionButton.className = "enabled";
		newPromotionButton.id = "enabled";
<%	} else { %>
		newPromotionButton.disabled = true;
		newPromotionButton.className = "disabled";
		newPromotionButton.id = "disabled";
<%	} %>
		newPromotionCollateralButton.disabled = false;
		newPromotionCollateralButton.className = "enabled";
		newPromotionCollateralButton.id = "enabled";
		newCollateralButton.disabled = false;
		newCollateralButton.className = "enabled";
		newCollateralButton.id = "enabled";
	}
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

function showContentDivisions () {
	var contentTypeValue = getSelectValue(document.experimentContentSelectionForm.contentType);
	if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
		if (!isPromotionLoaded) {
			top.showProgressIndicator(true);
			document.promotionSearchForm.searchType.value = "promotion";
			document.promotionSearchForm.initialLoad.value = "Y";
			document.promotionSearchForm.submit();
			document.promotionCollateralSearchForm.searchType.value = "promotionCollateral";
			document.promotionCollateralSearchForm.initialLoad.value = "Y";
			document.promotionCollateralSearchForm.submit();
			isPromotionLoaded = true;
		}
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentPromotionDiv.style.display = "block";
	}
	else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION %>") {
		if (!isProductLoaded) {
			top.showProgressIndicator(true);
			document.productSearchForm.searchType.value = "product";
			document.productSearchForm.initialLoad.value = "Y";
			document.productSearchForm.submit();
			isProductLoaded = true;
		}
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "block";
	}
	else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION %>") {
		if (!isCategoryLoaded) {
			top.showProgressIndicator(true);
			document.categorySearchForm.searchType.value = "category";
			document.categorySearchForm.initialLoad.value = "Y";
			document.categorySearchForm.submit();
			isCategoryLoaded = true;
		}
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "block";
	}
	else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>") {
		if (!isCollateralLoaded) {
			top.showProgressIndicator(true);
			document.collateralSearchForm.searchType.value = "collateral";
			document.collateralSearchForm.initialLoad.value = "Y";
			document.collateralSearchForm.submit();
			isCollateralLoaded = true;
		}
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "block";
	}
	else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "block";
	}
	else if (contentTypeValue == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL %>") {
		document.all.contentPromotionDiv.style.display = "none";
		document.all.contentProductDiv.style.display = "none";
		document.all.contentCategoryDiv.style.display = "none";
		document.all.contentAdDiv.style.display = "none";
		document.all.contentUpSellProductDiv.style.display = "none";
		document.all.contentCrossSellProductDiv.style.display = "block";
	}
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

function newCollateral () {
	// save the panel settings
	persistPanelData();

	// launch the marketing content dialog panel
	var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createCollateral")) %>", url, true);
}

function launchCollateralSummaryDialog (collateralId) {
	// save the panel settings
	persistPanelData();

	// launch the marketing content summary panel
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + collateralId;
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryCollateral")) %>", url, true);
}

function newPromotion () {
	// save the panel settings
	persistPanelData();

	// launch the promotion notebook panel
<%	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled(com.ibm.commerce.discount.rules.DiscountConst.COMPONENT_RULE_BASED_DISCOUNT)) { %>
	var url = "<%= UIUtil.getWebappPath(request) %>WizardView?XMLFile=RLPromotion.RLPromotionWizard";
<%	} else { %>
	var url = "<%= UIUtil.getWebappPath(request) %>WizardView?XMLFile=discount.discountWizard";
<%	} %>
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createPromotion")) %>", url, true);
}

function gotoSummaryPromotionDialog () {
	// first find out which item is selected in the list box
	var selectedPromotion = whichItemIsSelected(document.experimentContentSelectionForm.selectedPromotion);
	if (selectedPromotion == "") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("fatalErrorNoCollateralID")) %>");
		return;
	}

	// save the panel settings
	persistPanelData();

	// launch the summary panel
<%	if (com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled(com.ibm.commerce.discount.rules.DiscountConst.COMPONENT_RULE_BASED_DISCOUNT)) { %>
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=RLPromotion.RLDiscountDetails&calcodeId=" + selectedPromotion;
<%	} else { %>
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=discount.discountDetails&calcodeId=" + selectedPromotion;
<%	} %>
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryPromotion")) %>", url, true);
}

function searchPromotion () {
	document.promotionSearchForm.searchType.value = "promotion";
	document.promotionSearchForm.searchActionType.value = getSelectValue(document.experimentContentSelectionForm.promotionSearchType);
	document.promotionSearchForm.searchString.value = trim(document.experimentContentSelectionForm.promotionSearch.value);
	document.promotionSearchForm.initialLoad.value = "N";
	document.promotionSearchForm.submit();
	changePageElementStateOnSearch(document.experimentContentSelectionForm.searchPromotionButton);
}

function addToSelectedPromotionCollateral () {
	with (document.experimentContentSelectionForm) {
		move(availablePromotionCollateral, selectedPromotionCollateral);
		updateSloshBuckets(availablePromotionCollateral, addToPromotionCollateralSloshBucketButton, selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton);
		initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	}
}

function removeFromSelectedPromotionCollateral () {
	with (document.experimentContentSelectionForm) {
		move(selectedPromotionCollateral, availablePromotionCollateral);
		updateSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
		initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	}
}

function gotoSummaryPromotionCollateralDialog () {
	var collateralId = "";

	// first find out which item is selected in either option box
	var collateralId = whichItemIsSelected(document.experimentContentSelectionForm.availablePromotionCollateral);
	if (collateralId == "") {
		collateralId = whichItemIsSelected(document.experimentContentSelectionForm.selectedPromotionCollateral);
		if (collateralId == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("fatalErrorNoCollateralID")) %>");
			return;
		}
	}

	// launch the marketing content summary panel
	launchCollateralSummaryDialog(collateralId);
}

function searchPromotionCollateral () {
	document.promotionCollateralSearchForm.searchType.value = "promotionCollateral";
	document.promotionCollateralSearchForm.searchActionType.value = getSelectValue(document.experimentContentSelectionForm.promotionCollateralSearchType);
	document.promotionCollateralSearchForm.searchString.value = trim(document.experimentContentSelectionForm.promotionCollateralSearch.value);
	document.promotionCollateralSearchForm.initialLoad.value = "N";
	document.promotionCollateralSearchForm.submit();
	changePageElementStateOnSearch(document.experimentContentSelectionForm.searchPromotionCollateralButton);
}

function addToSelectedProduct () {
	with (document.experimentContentSelectionForm) {
		move(availableProduct, selectedProduct);
		updateSloshBuckets(availableProduct, addToProductSloshBucketButton, selectedProduct, removeFromProductSloshBucketButton);
	}
}

function removeFromSelectedProduct () {
	with (document.experimentContentSelectionForm) {
		move(selectedProduct, availableProduct);
		updateSloshBuckets(selectedProduct, removeFromProductSloshBucketButton, availableProduct, addToProductSloshBucketButton);
	}
}

function searchProduct () {
	document.productSearchForm.searchType.value = "product";
	document.productSearchForm.searchActionType.value = getSelectValue(document.experimentContentSelectionForm.productSearchType);
	document.productSearchForm.searchString.value = trim(document.experimentContentSelectionForm.productSearch.value);
	document.productSearchForm.searchStringType.value = getSelectValue(document.experimentContentSelectionForm.productSearchStringType);
	document.productSearchForm.initialLoad.value = "N";
	document.productSearchForm.submit();
	changePageElementStateOnSearch(document.experimentContentSelectionForm.searchProductButton);
}

function addToSelectedCategory () {
	with (document.experimentContentSelectionForm) {
		move(availableCategory, selectedCategory);
		updateSloshBuckets(availableCategory, addToCategorySloshBucketButton, selectedCategory, removeFromCategorySloshBucketButton);
	}
}

function removeFromSelectedCategory () {
	with (document.experimentContentSelectionForm) {
		move(selectedCategory, availableCategory);
		updateSloshBuckets(selectedCategory, removeFromCategorySloshBucketButton, availableCategory, addToCategorySloshBucketButton);
	}
}

function searchCategory () {
	document.categorySearchForm.searchType.value = "category";
	document.categorySearchForm.searchActionType.value = getSelectValue(document.experimentContentSelectionForm.categorySearchType);
	document.categorySearchForm.searchString.value = trim(document.experimentContentSelectionForm.categorySearch.value);
	document.categorySearchForm.searchStringType.value = getSelectValue(document.experimentContentSelectionForm.categorySearchStringType);
	document.categorySearchForm.initialLoad.value = "N";
	document.categorySearchForm.submit();
	changePageElementStateOnSearch(document.experimentContentSelectionForm.searchCategoryButton);
}

function addToSelectedCollateral () {
	with (document.experimentContentSelectionForm) {
		move(availableCollateral, selectedCollateral);
		updateSloshBuckets(availableCollateral, addToCollateralSloshBucketButton, selectedCollateral, removeFromCollateralSloshBucketButton);
		initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	}
}

function removeFromSelectedCollateral () {
	with (document.experimentContentSelectionForm) {
		move(selectedCollateral, availableCollateral);
		updateSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
		initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	}
}

function gotoSummaryCollateralDialog () {
	var collateralId = "";

	// first find out which item is selected in either option box
	var collateralId = whichItemIsSelected(document.experimentContentSelectionForm.availableCollateral);
	if (collateralId == "") {
		collateralId = whichItemIsSelected(document.experimentContentSelectionForm.selectedCollateral);
		if (collateralId == "") {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("fatalErrorNoCollateralID")) %>");
			return;
		}
	}

	// launch the marketing content summary panel
	launchCollateralSummaryDialog(collateralId);
}

function searchCollateral () {
	document.collateralSearchForm.searchType.value = "collateral";
	document.collateralSearchForm.searchActionType.value = getSelectValue(document.experimentContentSelectionForm.collateralSearchType);
	document.collateralSearchForm.searchString.value = trim(document.experimentContentSelectionForm.collateralSearch.value);
	document.collateralSearchForm.initialLoad.value = "N";
	document.collateralSearchForm.submit();
	changePageElementStateOnSearch(document.experimentContentSelectionForm.searchCollateralButton);
}

function performFinish () {
	with (document.experimentContentSelectionForm) {
		if (validatePanelData()) {
			var contentResult = new Array();
			var contentResultType = getSelectValue(contentType);

			if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
				for (var i=0; i<selectedPromotion.options.length; i++) {
					if (selectedPromotion.options[i].selected) {
						var currentIndex = contentResult.length;
						contentResult[currentIndex] = new Object();
						contentResult[currentIndex].type = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>";
						contentResult[currentIndex].id = selectedPromotion.options[i].value;
						contentResult[currentIndex].name = selectedPromotion.options[i].innerText;
					}
				}
				for (var i=0; i<selectedPromotionCollateral.options.length; i++) {
					var currentIndex = contentResult.length;
					contentResult[currentIndex] = new Object();
					contentResult[currentIndex].type = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION_COLLATERAL %>";
					contentResult[currentIndex].id = selectedPromotionCollateral.options[i].value;
					contentResult[currentIndex].name = selectedPromotionCollateral.options[i].innerText;
				}
			}
			else if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION %>") {
				for (var i=0; i<selectedProduct.options.length; i++) {
					var currentIndex = contentResult.length;
					contentResult[currentIndex] = new Object();
					contentResult[currentIndex].id = selectedProduct.options[i].value;
					contentResult[currentIndex].name = selectedProduct.options[i].innerText;
				}
			}
			else if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION %>") {
				for (var i=0; i<selectedCategory.options.length; i++) {
					var currentIndex = contentResult.length;
					contentResult[currentIndex] = new Object();
					contentResult[currentIndex].id = selectedCategory.options[i].value;
					contentResult[currentIndex].name = selectedCategory.options[i].innerText;
				}
			}
			else if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>") {
				for (var i=0; i<selectedCollateral.options.length; i++) {
					var currentIndex = contentResult.length;
					contentResult[currentIndex] = new Object();
					contentResult[currentIndex].id = selectedCollateral.options[i].value;
					contentResult[currentIndex].name = selectedCollateral.options[i].innerText;
				}
			}
			else if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL %>") {
				var selectedType = getSelectValue(upSellContentType);
				contentResult[0] = new Object();
				contentResult[0].id = selectedType;
				if (selectedType == "currentPageContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("currentPageContentCatalogAssociationType")) %>";
				}
				else if (selectedType == "shoppingCartContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("shoppingCartContentCatalogAssociationType")) %>";
				}
				else if (selectedType == "purchaseHistoryContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("purchaseHistoryContentCatalogAssociationType")) %>";
				}
			}
			else if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL %>") {
				var selectedType = getSelectValue(crossSellContentType);
				contentResult[0] = new Object();
				contentResult[0].id = selectedType;
				if (selectedType == "currentPageContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("currentPageContentCatalogAssociationType")) %>";
				}
				else if (selectedType == "shoppingCartContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("shoppingCartContentCatalogAssociationType")) %>";
				}
				else if (selectedType == "purchaseHistoryContent") {
					contentResult[0].name = "<%= UIUtil.toJavaScript((String)experimentRB.get("purchaseHistoryContentCatalogAssociationType")) %>";
				}
			}

			top.sendBackData(contentResult, "contentResult");
			top.sendBackData(contentResultType, "contentResultType");
			top.goBack();
		}
	}
}

function performCancel () {
	top.goBack();
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<form id="experimentContentSelectionForm" name="experimentContentSelectionForm">

<h1><%= experimentRB.get("experimentContentSelectionDialogTitle") %></h1>

<p/><label for="contentType"><%= experimentRB.get("experimentContentSelectionContentType") %></label><br/>
<select name="contentType" id="contentType" onchange="showContentDivisions()">
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>" selected><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION + "ContentType") %></option>
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION %>"><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION + "ContentType") %></option>
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION %>"><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION + "ContentType") %></option>
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>"><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL + "ContentType") %></option>
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL %>"><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL + "ContentType") %></option>
	<option value="<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL %>"><%= (String) experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL + "ContentType") %></option>
</select>
<br/><br/>

<!-- =========================================== -->
<!-- Content Selection - Promotion               -->
<!-- =========================================== -->
<div id="contentPromotionDiv" style="display: none; margin-left: 20">
<table id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable">
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable_TableCell_1" colspan="3">
			<%= experimentRB.get("experimentContentSelectionNumberOfPromotion") %>&nbsp;<span id="promotionCount" name="promotionCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable_TableCell_2">
			<label for="selectedPromotion"><%= experimentRB.get("experimentContentSelectionSelectedPromotion") %></label><br/>
			<select id="selectedPromotion" name="selectedPromotion" class="selectWidth" size="8" onchange="javascript:setButtonContext(this, document.experimentContentSelectionForm.summaryPromotionButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable_TableCell_3" valign="top">
			&nbsp;<br/>
			<input type="button" id="newPromotionButton" name="newPromotionButton" value="<%= experimentRB.get("new") %>" onclick="newPromotion();" style="width: 150px" /><br/>
			<input type="button" id="summaryPromotionButton" name="summaryPromotionButton" value="<%= experimentRB.get("summary") %>" onclick="gotoSummaryPromotionDialog();" style="width: 150px" />
		</td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable_TableCell_4" width="15px" rowspan="2"></td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionSelectionTable_TableCell_5" valign="top">
			<table id="WC_ExperimentContentSelectionPanel_PromotionSearchTable" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionSearchTable_TableCell_1">
						<label for="promotionSearch"><%= experimentRB.get("experimentContentSelectionPromotionSearchPrompt") %></label><br/>
						<input type="text" id="promotionSearch" name="promotionSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionSearchTable_TableCell_2" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionSearchTable_TableCell_3">
						<label for="promotionSearchType">
						<select id="promotionSearchType" name="promotionSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= experimentRB.get("experimentSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= experimentRB.get("experimentSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= experimentRB.get("experimentSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionSearchTable_TableCell_4" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionSearchTable_TableCell_5" align="right">
						<input type="button" id="searchPromotionButton" name="searchPromotionButton" value="<%= experimentRB.get("findPromotion") %>" style="width: <%= searchPromotionButtonLength %>px" onclick="searchPromotion();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<p/>
<table id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable">
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_1" colspan="4">
			<%= experimentRB.get("experimentContentSelectionNumberOfContent") %>&nbsp;<span id="promotionCollateralCount" name="promotionCollateralCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_2">
			<label for="selectedPromotionCollateral"><%= experimentRB.get("experimentContentSelectionSelectedContent") %></label><br/>
			<select id="selectedPromotionCollateral" name="selectedPromotionCollateral" class="sloshBucketWidth" size="8" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.removeFromPromotionCollateralSloshBucketButton, document.experimentContentSelectionForm.availablePromotionCollateral, document.experimentContentSelectionForm.addToPromotionCollateralSloshBucketButton);initializeSummaryButton(document.experimentContentSelectionForm.selectedPromotionCollateral, document.experimentContentSelectionForm.availablePromotionCollateral, document.experimentContentSelectionForm.summaryPromotionCollateralButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_3" width="180px" align="center">
			&nbsp;<br/>
			<table id="WC_ExperimentContentSelectionPanel_PromotionCollateralButtonTable" cellpadding="0" cellspacing="0">
				<tr><td id="WC_ExperimentContentSelectionPanel_PromotionCollateralButtonTable_TableCell_1">
					<input type="button" id="addToPromotionCollateralSloshBucketButton" name="addToPromotionCollateralSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedPromotionCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_PromotionCollateralButtonTable_TableCell_2">
					<input type="button" id="removeFromPromotionCollateralSloshBucketButton" name="removeFromPromotionCollateralSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedPromotionCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_PromotionCollateralButtonTable_TableCell_3">
					<input type="button" id="newPromotionCollateralButton" name="newPromotionCollateralButton" value="  <%= experimentRB.get("new") %>  " style="width: 150px" onclick="newCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_PromotionCollateralButtonTable_TableCell_4">
					<input type="button" id="summaryPromotionCollateralButton" name="summaryPromotionCollateralButton" value="  <%= experimentRB.get("summary") %>   " style="width: 150px" onclick="gotoSummaryPromotionCollateralDialog();" />
				</td></tr>
			</table>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_4">
			<label for="availablePromotionCollateral"><%= experimentRB.get("experimentContentSelectionAvailableContent") %></label><br/>
			<select id="availablePromotionCollateral" name="availablePromotionCollateral" class="sloshBucketWidth" size="8" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.addToPromotionCollateralSloshBucketButton, document.experimentContentSelectionForm.selectedPromotionCollateral, document.experimentContentSelectionForm.removeFromPromotionCollateralSloshBucketButton);initializeSummaryButton(document.experimentContentSelectionForm.selectedPromotionCollateral, document.experimentContentSelectionForm.availablePromotionCollateral, document.experimentContentSelectionForm.summaryPromotionCollateralButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_5" width="15px"></td>
		<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSelectionTable_TableCell_6" valign="top">
			<table id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable_TableCell_1">
						<label for="promotionCollateralSearch"><%= experimentRB.get("experimentContentSelectionContentSearchPrompt") %></label><br/>
						<input type="text" id="promotionCollateralSearch" name="promotionCollateralSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable_TableCell_2" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable_TableCell_3">
						<label for="promotionCollateralSearchType">
						<select id="promotionCollateralSearchType" name="promotionCollateralSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= experimentRB.get("experimentSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= experimentRB.get("experimentSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= experimentRB.get("experimentSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable_TableCell_4" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_PromotionCollateralSearchTable_TableCell_5" align="right">
						<input type="button" id="searchPromotionCollateralButton" name="searchPromotionCollateralButton" value="  <%= experimentRB.get("findContent") %>  " style="width: <%= searchCollateralButtonLength %>px" onclick="searchPromotionCollateral();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- =========================================== -->
<!-- Content Selection - Product Recommendation  -->
<!-- =========================================== -->
<div id="contentProductDiv" style="display: none; margin-left: 20">
<table id="WC_ExperimentContentSelectionPanel_ProductSelectionTable">
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_1" colspan="4">
			<%= experimentRB.get("experimentContentSelectionNumberOfProduct") %>&nbsp;<span id="productCount" name="productCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_2">
			<label for="selectedProduct"><%= experimentRB.get("experimentContentSelectionSelectedProduct") %></label><br/>
			<select id="selectedProduct" name="selectedProduct" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.removeFromProductSloshBucketButton, document.experimentContentSelectionForm.availableProduct, document.experimentContentSelectionForm.addToProductSloshBucketButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_3" width="180px" align="center">
			&nbsp;<br/>
			<table id="WC_ExperimentContentSelectionPanel_ProductButtonTable" cellpadding="0" cellspacing="0">
				<tr><td id="WC_ExperimentContentSelectionPanel_ProductButtonTable_TableCell_1">
					<input type="button" id="addToProductSloshBucketButton" name="addToProductSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedProduct();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_ProductButtonTable_TableCell_2">
					<input type="button" id="removeFromProductSloshBucketButton" name="removeFromProductSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedProduct();" />
				</td></tr>
			</table>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_4">
			<label for="availableProduct"><%= experimentRB.get("experimentContentSelectionAvailableProduct") %></label><br/>
			<select id="availableProduct" name="availableProduct" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.addToProductSloshBucketButton, document.experimentContentSelectionForm.selectedProduct, document.experimentContentSelectionForm.removeFromProductSloshBucketButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_5" width="15px"></td>
		<td id="WC_ExperimentContentSelectionPanel_ProductSelectionTable_TableCell_6" valign="top">
			<table id="WC_ExperimentContentSelectionPanel_ProductSearchTable" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_1">
						<label for="productSearch"><%= experimentRB.get("experimentContentSelectionProductSearchPrompt") %></label><br/>
						<input type="text" id="productSearch" name="productSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_2" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_3">
						<label for="productSearchStringType">
						<select id="productSearchStringType" name="productSearchStringType">
							<option value="name" selected><%= experimentRB.get("experimentSearchProductByName") %></option>
							<option value="partnumber"><%= experimentRB.get("experimentSearchProductBySKU") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_4" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_5">
						<label for="productSearchType">
						<select id="productSearchType" name="productSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= experimentRB.get("experimentSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= experimentRB.get("experimentSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= experimentRB.get("experimentSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_6" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_ProductSearchTable_TableCell_7" align="right">
						<input type="button" id="searchProductButton" name="searchProductButton" value="  <%= experimentRB.get("findProduct") %>  " style="width: <%= searchProductButtonLength %>px" onclick="searchProduct();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- =========================================== -->
<!-- Content Selection - Category Recommendation -->
<!-- =========================================== -->
<div id="contentCategoryDiv" style="display: none; margin-left: 20">
<table id="WC_ExperimentContentSelectionPanel_CategorySelectionTable">
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_1" colspan="4">
			<%= experimentRB.get("experimentContentSelectionNumberOfCategory") %>&nbsp;<span id="categoryCount" name="categoryCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_2">
			<label for="selectedCategory"><%= experimentRB.get("experimentContentSelectionSelectedCategory") %></label><br/>
			<select id="selectedCategory" name="selectedCategory" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.removeFromCategorySloshBucketButton, document.experimentContentSelectionForm.availableCategory, document.experimentContentSelectionForm.addToCategorySloshBucketButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_3" width="180px" align="center">
			&nbsp;<br/>
			<table id="WC_ExperimentContentSelectionPanel_CategoryButtonTable" cellpadding="0" cellspacing="0">
				<tr><td id="WC_ExperimentContentSelectionPanel_CategoryButtonTable_TableCell_1">
					<input type="button" id="addToCategorySloshBucketButton" name="addToCategorySloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedCategory();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_CategoryButtonTable_TableCell_2">
					<input type="button" id="removeFromCategorySloshBucketButton" name="removeFromCategorySloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedCategory();" />
				</td></tr>
			</table>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_4">
			<label for="availableCategory"><%= experimentRB.get("experimentContentSelectionAvailableCategory") %></label><br/>
			<select id="availableCategory" name="availableCategory" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.addToCategorySloshBucketButton, document.experimentContentSelectionForm.selectedCategory, document.experimentContentSelectionForm.removeFromCategorySloshBucketButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_5" width="15px"></td>
		<td id="WC_ExperimentContentSelectionPanel_CategorySelectionTable_TableCell_6" valign="top">
			<table id="WC_ExperimentContentSelectionPanel_CategorySearchTable" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_1">
						<label for="categorySearch"><%= experimentRB.get("experimentContentSelectionCategorySearchPrompt") %></label><br/>
						<input type="text" id="categorySearch" name="categorySearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_2" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_3">
						<label for="categorySearchStringType">
						<select id="categorySearchStringType" name="categorySearchStringType">
							<option value="name" selected><%= experimentRB.get("experimentSearchCategoryByName") %></option>
							<option value="identifier"><%= experimentRB.get("experimentSearchCategoryByIdentifier") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_4" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_5">
						<label for="categorySearchType">
						<select id="categorySearchType" name="categorySearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= experimentRB.get("experimentSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= experimentRB.get("experimentSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= experimentRB.get("experimentSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_6" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CategorySearchTable_TableCell_7" align="right">
						<input type="button" id="searchCategoryButton" name="searchCategoryButton" value="  <%= experimentRB.get("findCategory") %>  " style="width: <%= searchCategoryButtonLength %>px" onclick="searchCategory();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- =========================================== -->
<!-- Content Selection - Advertisement           -->
<!-- =========================================== -->
<div id="contentAdDiv" style="display: none; margin-left: 20">
<table id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable">
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_1" colspan="4">
			<%= experimentRB.get("experimentContentSelectionNumberOfContent") %>&nbsp;<span id="collateralCount" name="collateralCount">0</span>
		</td>
	</tr>
	<tr>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_2">
			<label for="selectedCollateral"><%= experimentRB.get("experimentContentSelectionSelectedContent") %></label><br/>
			<select id="selectedCollateral" name="selectedCollateral" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.removeFromCollateralSloshBucketButton, document.experimentContentSelectionForm.availableCollateral, document.experimentContentSelectionForm.addToCollateralSloshBucketButton);initializeSummaryButton(document.experimentContentSelectionForm.selectedCollateral, document.experimentContentSelectionForm.availableCollateral, document.experimentContentSelectionForm.summaryCollateralButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_3" width="180px" align="center">
			&nbsp;<br/>
			<table id="WC_ExperimentContentSelectionPanel_CollateralButtonTable" cellpadding="0" cellspacing="0">
				<tr><td id="WC_ExperimentContentSelectionPanel_CollateralButtonTable_TableCell_1">
					<input type="button" id="addToCollateralSloshBucketButton" name="addToCollateralSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketAdd") %>  " style="width: 150px" onclick="addToSelectedCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_CollateralButtonTable_TableCell_2">
					<input type="button" id="removeFromCollateralSloshBucketButton" name="removeFromCollateralSloshBucketButton" value="  <%= experimentRB.get("GeneralSloshBucketRemove") %>  " style="width: 150px" onclick="removeFromSelectedCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_CollateralButtonTable_TableCell_3">
					<input type="button" id="newCollateralButton" name="newCollateralButton" value="  <%= experimentRB.get("new") %>  " style="width: 150px" onclick="newCollateral();" />
				</td></tr>
				<tr height="4"><td>
				</td></tr>
				<tr><td id="WC_ExperimentContentSelectionPanel_CollateralButtonTable_TableCell_4">
					<input type="button" id="summaryCollateralButton" name="summaryCollateralButton" value="  <%= experimentRB.get("summary") %>   " style="width: 150px" onclick="gotoSummaryCollateralDialog();" />
				</td></tr>
			</table>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_4">
			<label for="availableCollateral"><%= experimentRB.get("experimentContentSelectionAvailableContent") %></label><br/>
			<select id="availableCollateral" name="availableCollateral" class="sloshBucketWidth" size="20" multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.experimentContentSelectionForm.addToCollateralSloshBucketButton, document.experimentContentSelectionForm.selectedCollateral, document.experimentContentSelectionForm.removeFromCollateralSloshBucketButton);initializeSummaryButton(document.experimentContentSelectionForm.selectedCollateral, document.experimentContentSelectionForm.availableCollateral, document.experimentContentSelectionForm.summaryCollateralButton);">
			</select>
		</td>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_5" width="15px"></td>
		<td id="WC_ExperimentContentSelectionPanel_CollateralSelectionTable_TableCell_6" valign="top">
			<table id="WC_ExperimentContentSelectionPanel_CollateralSearchTable" cellpadding="0" cellspacing="0">
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CollateralSearchTable_TableCell_1">
						<label for="collateralSearch"><%= experimentRB.get("experimentContentSelectionContentSearchPrompt") %></label><br/>
						<input type="text" id="collateralSearch" name="collateralSearch" value="" size="27" maxlength="128" />
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CollateralSearchTable_TableCell_2" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CollateralSearchTable_TableCell_3">
						<label for="collateralSearchType">
						<select id="collateralSearchType" name="collateralSearchType">
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_IGNORE_CASE %>" selected><%= experimentRB.get("experimentSearchTypeIgnoreCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_MATCH_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseBegin") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_EXACT_MATCH %>"><%= experimentRB.get("experimentSearchTypeExactMatch") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE %>"><%= experimentRB.get("experimentSearchTypeIgnoreCaseContain") %></option>
							<option value="<%= ExperimentConstants.SEARCH_TYPE_LIKE_CASE_SENSITIVE %>"><%= experimentRB.get("experimentSearchTypeMatchCaseContain") %></option>
						</select>
						</label>
					</td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CollateralSearchTable_TableCell_4" height="4"></td>
				</tr>
				<tr>
					<td id="WC_ExperimentContentSelectionPanel_CollateralSearchTable_TableCell_5" align="right">
						<input type="button" id="searchCollateralButton" name="searchCollateralButton" value="  <%= experimentRB.get("findContent") %>  " style="width: <%= searchCollateralButtonLength %>px" onclick="searchCollateral();" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>

<!-- =========================================== -->
<!-- Content Selection - Up-sell product         -->
<!-- =========================================== -->
<div id="contentUpSellProductDiv" style="display: none; margin-left: 20">
<label for="upSellContentType"><%= experimentRB.get("experimentContentSelectionMethodPrompt") %></label><br/>
<select name="upSellContentType" id="upSellContentType">
	<option value="currentPageContent" selected><%= experimentRB.get("experimentContentSelectionUpSellContentOfCurrentPage") %></option>
	<option value="shoppingCartContent"><%= experimentRB.get("experimentContentSelectionUpSellShoppingCartContains") %></option>
	<option value="purchaseHistoryContent"><%= experimentRB.get("experimentContentSelectionUpSellPreviousPurchaseContains") %></option>
</select>
</div>

<!-- =========================================== -->
<!-- Content Selection - Cross-sell product      -->
<!-- =========================================== -->
<div id="contentCrossSellProductDiv" style="display: none; margin-left: 20">
<label for="crossSellContentType"><%= experimentRB.get("experimentContentSelectionMethodPrompt") %></label><br/>
<select name="crossSellContentType" id="crossSellContentType">
	<option value="currentPageContent" selected><%= experimentRB.get("experimentContentSelectionCrossSellContentOfCurrentPage") %></option>
	<option value="shoppingCartContent"><%= experimentRB.get("experimentContentSelectionCrossSellShoppingCartContains") %></option>
	<option value="purchaseHistoryContent"><%= experimentRB.get("experimentContentSelectionCrossSellPreviousPurchaseContains") %></option>
</select>
</div>

</form>

<form id="promotionSearchForm" name="promotionSearchForm" action="ExperimentContentSelectionSearchView" target="promotionSearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>
<iframe id="promotionSearchFrame" name="promotionSearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

<form id="productSearchForm" name="productSearchForm" action="ExperimentContentSelectionSearchView" target="productSearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="searchStringType" name="searchStringType" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>
<iframe id="productSearchFrame" name="productSearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

<form id="categorySearchForm" name="categorySearchForm" action="ExperimentContentSelectionSearchView" target="categorySearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="searchStringType" name="searchStringType" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>
<iframe id="categorySearchFrame" name="categorySearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

<form id="promotionCollateralSearchForm" name="promotionCollateralSearchForm" action="ExperimentContentSelectionSearchView" target="promotionCollateralSearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>
<iframe id="promotionCollateralSearchFrame" name="promotionCollateralSearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

<form id="collateralSearchForm" name="collateralSearchForm" action="ExperimentContentSelectionSearchView" target="collateralSearchFrame" method="post">
<input type="hidden" id="searchType" name="searchType" />
<input type="hidden" id="searchActionType" name="searchActionType" />
<input type="hidden" id="searchString" name="searchString" />
<input type="hidden" id="initialLoad" name="initialLoad" />
</form>
<iframe id="collateralSearchFrame" name="collateralSearchFrame" title="" frameborder="0" scrolling="no" src="/wcs/tools/common/blank.html" width="0" height="0">
</iframe>

</body>

</html>