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

<%@ page import="com.ibm.commerce.tools.campaigns.CampaignCollateralDataBean,
	com.ibm.commerce.tools.campaigns.CampaignConstants" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ page import="com.ibm.commerce.attachment.objects.AttachmentAssetAccessBean" %>
<%@ page import="java.util.Enumeration" %>

<%@ include file="common.jsp" %>

<%
	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	String resultCollateralId = "";
	String resultCollateralName = "";
	String resultCollateralCommandType = "";
	String locTargetId = "";
	if (jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_ID) != null) {
		resultCollateralId = jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_ID);
	}
	if (jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_NAME) != null) {
		resultCollateralName = jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_NAME);
	}

	if (jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE) != null) {
		resultCollateralCommandType = jspHelper.getParameter(CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE);
	}

	request.setAttribute(CampaignConstants.REQ_ATTRIBUTE_COLL_FILE_PATH,((CampaignCollateralDataBean)request.getAttribute("collateral")).getLocations());
	request.setAttribute(CampaignConstants.REQ_ATTRIBUTE_COLL_ATCH_TARGET_ID,((CampaignCollateralDataBean)request.getAttribute("collateral")).getTargetId());

	String targetId = "";
	targetId = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getTargetId();

	String thisCollateralType = "";
	if (((CampaignCollateralDataBean)request.getAttribute("collateral")).getCollateralType() != null) {
		thisCollateralType = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getCollateralType().toString();
	}
	String thisUrl = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrl();
	String thisUrlType = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrlType();
	String thisUrlCommand = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrlCommand();
	String thisUrlCustom = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrlCustom();
	String thisUrlCommandType = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrlCommandType();
	String thisUrlCommandParameter = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getUrlCommandParameter();
	String thisMarketingText = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getMarketingText();
	String thisLocation = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getLocation();
	String thisAttachmentLocations = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getLocations();
	String thisCollateralName = ((CampaignCollateralDataBean)request.getAttribute("collateral")).getCollateralName();

	if (jspHelper.getParameter(ECAttachmentConstants.EC_ATCH_URL_PARAM_TARGET_ID) != null) {
		locTargetId = jspHelper.getParameter(ECAttachmentConstants.EC_ATCH_URL_PARAM_TARGET_ID);
	}

	Enumeration enAttachmentAsset = null;

	if(!(locTargetId.equals(""))){
		StringBuffer attachAsset = null;
		AttachmentAssetAccessBean abAttachmentAsset = new AttachmentAssetAccessBean();
		enAttachmentAsset = abAttachmentAsset.findByTargetId(new Long(locTargetId));
	}
%>

<body oncontextmenu="return false;"/>
<script language="JavaScript">
<!-- hide script from old browsers
var formLoaded = false;
var isSavingCollateral = true;
var productResult = top.getData("productResult", null);
var itemResult = top.getData("itemResult", null);
var categoryResult = top.getData("categoryResult", null);
var couponResult = top.getData("couponResult", null);

function init () {
	with (document.collateralForm) {
<%	if (!resultCollateralId.equals("")) { %>
		// disable name field if changing this collateral
		collateralName.readOnly = true;
		collateralName.style.borderStyle = "none";
<%	} %>

		// retrieve data from request if model is empty
		var thisCollateralType = getData("collateralType", "<%= UIUtil.toJavaScript(thisCollateralType) %>");
		var thisUrl = getData("url", "<%= UIUtil.toJavaScript(thisUrl) %>");
		var thisUrlType = getData("urlType", "<%= UIUtil.toJavaScript(thisUrlType) %>");
		var thisUrlCommand = getData("urlCommand", "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
		var thisUrlCustom = getData("urlCustom", "<%= UIUtil.toJavaScript(thisUrlCustom) %>");
		var thisUrlCommandType = getData("urlCommandType", "<%= UIUtil.toJavaScript(thisUrlCommandType) %>");
		var thisUrlCommandParameter = getData("urlCommandParameter","<%= UIUtil.toJavaScript(thisUrlCommandParameter) %>");
		var thisMarketingText = getData("marketingText", "<%= UIUtil.toJavaScript(thisMarketingText) %>");
		var thisCollateralName = getData("collateralName", "<%= UIUtil.toJavaScript(thisCollateralName) %>");

		////////////////////////////////////////////
		//Initialize file path and remove variables
		////////////////////////////////////////////
		var newAttachmentLocations ="";
		saveData("allRemoveAsset","false");
		saveData("targetId","<%=targetId%>");

		//////////////////////////////////////////////////////////////////////////////////////
		// Re-populate top asset object if URL has targetId
		//////////////////////////////////////////////////////////////////////////////////////
		<%if(enAttachmentAsset!=null){%>
			var selectedFileSet = new Array();
			var fileIndex = 0;
			<%while (enAttachmentAsset.hasMoreElements()) {
				AttachmentAssetAccessBean abInstance = (AttachmentAssetAccessBean) enAttachmentAsset.nextElement();	%>
				fileIndex = selectedFileSet.length;
				selectedFileSet[fileIndex] 			= new Object();
				selectedFileSet[fileIndex].assetPath 	= "<%= abInstance.getAttachmentAssetPath()%>";
				selectedFileSet[fileIndex].atchtgtId 	= "<%= abInstance.getAttachmentTargetId()%>";
				selectedFileSet[fileIndex].mimeType 	= "<%= abInstance.getMimeType()%>";
				selectedFileSet[fileIndex].cmFilePath 	= "<%= abInstance.getDirectoryPath()%>";
			<%}%>
			if(selectedFileSet.length > 0){
				top.saveData(selectedFileSet, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
			}
		<%}%>

		//////////////////////////////////////////////////////////////////////////////////////
		// Remove target id parameter added to url by attachment page
		//////////////////////////////////////////////////////////////////////////////////////

		var trailLocation = top.mccbanner.trail[top.mccbanner.counter].location;
		var targetStr = "&" + "<%=ECAttachmentConstants.EC_ATCH_URL_PARAM_TARGET_ID%>" + "=";
		var targetInd = trailLocation.indexOf(targetStr);
		if(targetInd != -1){
			var newTrailLocation = trailLocation.substring(0,targetInd);
			top.mccbanner.trail[top.mccbanner.counter].location = newTrailLocation;
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// if no new attachment then get the old attachment else get new attachment
		//////////////////////////////////////////////////////////////////////////////////////
		newAttachmentLocations = constructLocationString(top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null));
		allRemoveAsset = getData("allRemoveAsset",null);
		if((newAttachmentLocations=="")  && (allRemoveAsset=="false") && (top.getData("<%=CampaignConstants.ELEMENT_ATCH_REL_DELETED%>", null)!="true")){
			attachmentLocations = "<%= UIUtil.toJavaScript(thisAttachmentLocations)%>";
		} else{
			attachmentLocations = newAttachmentLocations;
			saveData("targetId", getFirstTargetId(top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null)));
		}

		// load data to collateral name
		loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>, thisCollateralName);

		// load data to collateral type selection
		loadSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>, thisCollateralType);

		//load attachments to file location
		loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATIONS %>, attachmentLocations);

		// load data to fields in custom URL section
		loadSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>, thisUrlCommandType);
		loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>, thisUrl);
		loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, thisUrlCommand);
		loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>, thisUrlCustom);

		// load data to marketing text field or static text field based on the collateral type
		if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
			loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>, thisMarketingText);
			loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_STATIC_TEXT %>, "");
		}
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "2") {
			loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>, "");
			loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_STATIC_TEXT %>, thisMarketingText);
		}

		// select the URL type radio based on the URL type value
		loadSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>, thisUrlType);

		// load the URL command parameter
		if ("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>") {
			loadValue(urlCommandProduct, thisUrlCommandParameter);
		}
		else if (("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
			("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") ||
			("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")) {
			loadValue(urlCommandItem, thisUrlCommandParameter);
		}
		else if ("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>") {
			loadValue(urlCommandCategory, thisUrlCommandParameter);
		}
		else if ("<%= UIUtil.toJavaScript(thisUrlCommandType) %>" == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
			loadValue(urlCommandCoupon, thisUrlCommandParameter);
		}

		// populate url string with data selected in finder, category list or coupon list
		var foundResult = null;
		var searchType = top.getData("searchType", null);
		var newUrl = "";
		if (searchType == "productSingle") {
			foundResult = top.getData("productSearchSkuArray", null);
			if (foundResult != null) {
				loadValue(urlCommandProduct, foundResult[0].productName);
				productResult = new Object();
				productResult.productId = foundResult[0].productId;
				productResult.partNumber = foundResult[0].productEncodedSku;
				top.saveData(productResult, "productResult");
			}
			else {
				foundResult = top.getData("browserSelection", null);
				if (foundResult != null) {
					loadValue(urlCommandProduct, foundResult[0].refName);
					productResult = new Object();
					productResult.productId = foundResult[0].objectId;
					productResult.partNumber = foundResult[0].refnumEncoded;
					top.saveData(productResult, "productResult");
				}
			}
		}
		else if (searchType == "itemSingle") {
			foundResult = top.getData("productSearchSkuArray", null);
			if (foundResult != null) {
				loadValue(urlCommandItem, foundResult[0].productName);
				itemResult = new Object();
				itemResult.productId = foundResult[0].productId;
				itemResult.partNumber = foundResult[0].productEncodedSku;
				top.saveData(itemResult, "itemResult");
			}
			else {
				foundResult = top.getData("browserSelection", null);
				if (foundResult != null) {
					loadValue(urlCommandItem, foundResult[0].refName);
					itemResult = new Object();
					itemResult.productId = foundResult[0].objectId;
					itemResult.partNumber = foundResult[0].refnumEncoded;
					top.saveData(itemResult, "itemResult");
				}
			}
		}
		else if (searchType == "categorySingle") {
			foundResult = top.getData("categoryResult", null);
			if (foundResult != null) {
				loadValue(urlCommandCategory, foundResult[0].categoryName);
			}
			categoryResult = foundResult;
			top.saveData(categoryResult, "categoryResult");
		}
		else if (searchType == "coupon") {
			foundResult = top.getData("couponResult", null);
			if (foundResult != null) {
				loadValue(urlCommandCoupon, foundResult.couponName);
			}
			couponResult = foundResult;
			top.saveData(couponResult, "couponResult");
		}

		<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>.focus();
	}

	showDivisions();
	formLoaded = true;
}

function saveFormData () {
	with (document.collateralForm) {
		var currentCommandType = getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>);
		var newUrl = "";

		if (top.getData("newAttachment", null) == "true") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_ATTACHMENT_RELATION %>", top.getData("<%= ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS %>", null));
		}

		if (top.getData("<%= CampaignConstants.ELEMENT_ATCH_REL_DELETED %>", null) == "true") {
			saveData("<%= CampaignConstants.ELEMENT_ATCH_REL_DELETED %>", "true");
		}

		// save data from marketing text field or static text field based on the collateral type
		if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>", <%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>.value);
		}
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "2") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>", <%= CampaignConstants.ELEMENT_COLLATERAL_STATIC_TEXT %>.value);
		}

<%	if (thisLocation != null) { %>
		// keep the original collateral type value (either image or flash) if no attachment has been assigned
		if (!top.getData("<%= ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS %>")) {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>", <%= thisCollateralType %>);
		}
<%	} %>

		// save the URL command parameter, if the URL is command based
		if (isSavingCollateral) {
			if (currentCommandType == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>") {
				if (productResult != null) {
					newUrl = "?productId=" + productResult.productId;
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandProduct.value);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") {
				if (itemResult != null) {
					newUrl = "?partNumber=" + itemResult.partNumber;
					newUrl += "&URL=<%= CampaignConstants.URL_ORDER_CALCULATE %>?URL=<%= CampaignConstants.URL_ORDER_ITEM_DISPLAY %>";
					newUrl += "&calculationUsageId=-1";
					newUrl += "&quantity=1";
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandItem.value);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") {
				if (itemResult != null) {
					newUrl = "?partNumber=" + itemResult.partNumber;
					newUrl += "&URL=<%= CampaignConstants.URL_INTEREST_ITEM_DISPLAY %>";
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandItem.value);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>") {
				if (categoryResult != null) {
					newUrl = "?identifier=" + categoryResult[0].categoryEncodedIdentifier;
					newUrl += "&categoryId=" + categoryResult[0].categoryId;
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					newUrl += "&top=" + categoryResult[0].isTopCategory;
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandCategory.value);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_PROMOTION_DISPLAY %>") {
				newUrl = "?code=#promoName#";
				newUrl += "&catalogId=#catalogId#";
				newUrl += "&storeId=#storeId#";
				newUrl += "&pStoreId=#pStoreId#";
				loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_PROMOTION_ADD %>") {
				newUrl = "?promotionName=#promoName#";
				newUrl += "&catalogId=#catalogId#";
				newUrl += "&storeId=#storeId#";
				newUrl += "&URL=<%= CampaignConstants.URL_ORDER_CALCULATE %>?URL=<%= CampaignConstants.URL_ORDER_ITEM_DISPLAY %>";
				newUrl += "&calculationUsageId=#calUsageId#";
				loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>") {
				if (itemResult != null) {
					newUrl = "?partNumber=" + itemResult.partNumber;
					newUrl += "&promoCode=#promoCode#";
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					newUrl += "&quantity=1";
					newUrl += "&URL=<%= CampaignConstants.URL_ORDER_CALCULATE %>?URL=<%= CampaignConstants.URL_ORDER_ITEM_DISPLAY %>";
					newUrl += "&calculationUsageId=#calUsageId#";
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandItem.value);
			}
			else if (currentCommandType == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
				if (couponResult != null) {
					newUrl = "?promoName=" + couponResult.couponName;
					newUrl += "&catalogId=#catalogId#";
					newUrl += "&storeId=#storeId#";
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, currentCommandType + newUrl);
				}
				else {
					loadValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>, "<%= UIUtil.toJavaScript(thisUrlCommand) %>");
				}
				saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_PARAMETER %>", urlCommandCoupon.value);
			}
		}

		// save data from fields in custom URL section
		saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>", currentCommandType);
		saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>", <%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>.value);
		saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>", <%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>.value);

		// save the actual URL and the URL type
		// if command is the type, then use the URL from hidden variable, else use custom URL textbox
		if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>) == "none") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>", "");
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>", "none");
		}
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>) == "command") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>", <%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND %>.value);
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>", "command");
		}
		else if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>) == "custom") {
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>", <%= CampaignConstants.ELEMENT_COLLATERAL_URL_CUSTOM %>.value);
			saveData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>", "custom");
		}
	}
}

function showDivisions () {
	with (document.collateralForm) {
		// show and hide different URL command sections
		var urlCommandTypeValue = getSelectValue(urlCommandType);
		if (urlCommandTypeValue == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>") {
			document.all.commandItemDiv.style.display = "none";
			document.all.commandCategoryDiv.style.display = "none";
			document.all.commandCouponDiv.style.display = "none";
			document.all.commandProductDiv.style.display = "block";
		}
		else if ((urlCommandTypeValue == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
			(urlCommandTypeValue == "<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") ||
			(urlCommandTypeValue == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")) {
			document.all.commandProductDiv.style.display = "none";
			document.all.commandCategoryDiv.style.display = "none";
			document.all.commandCouponDiv.style.display = "none";
			document.all.commandItemDiv.style.display = "block";
		}
		else if (urlCommandTypeValue == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>") {
			document.all.commandProductDiv.style.display = "none";
			document.all.commandItemDiv.style.display = "none";
			document.all.commandCouponDiv.style.display = "none";
			document.all.commandCategoryDiv.style.display = "block";
		}
		else if ((urlCommandTypeValue == "<%= CampaignConstants.URL_PROMOTION_DISPLAY %>") ||
			(urlCommandTypeValue == "<%= CampaignConstants.URL_PROMOTION_ADD %>")) {
			document.all.commandProductDiv.style.display = "none";
			document.all.commandItemDiv.style.display = "none";
			document.all.commandCategoryDiv.style.display = "none";
			document.all.commandCouponDiv.style.display = "none";
		}
		else if (urlCommandTypeValue == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
			document.all.commandProductDiv.style.display = "none";
			document.all.commandItemDiv.style.display = "none";
			document.all.commandCategoryDiv.style.display = "none";
			document.all.commandCouponDiv.style.display = "block";
		}

		// show and hide different URL type sections
		var urlTypeValue = getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>);
		if (urlTypeValue == "command") {
			document.all.customUrlDiv.style.display = "none";
			document.all.commandUrlDiv.style.display = "block";
		}
		else if (urlTypeValue == "custom") {
			document.all.commandUrlDiv.style.display = "none";
			document.all.customUrlDiv.style.display = "block";
		}
		else {
			document.all.customUrlDiv.style.display = "none";
			document.all.commandUrlDiv.style.display = "none";
		}

		// show and hide image/flash and static text sections
		var typeValue = getSelectValue(collateralType);
		if (typeValue == "1") {
			document.getElementById("textDescriptionSection").style.display = "none";
			document.getElementById("fileLocationSection").style.display = "block";
			document.getElementById("imageDescriptionSection").style.display = "block";
		}
		else if (typeValue == "2") {
			document.getElementById("fileLocationSection").style.display = "none";
			document.getElementById("imageDescriptionSection").style.display = "none";
			document.getElementById("textDescriptionSection").style.display = "block";
		}
	}
}

function updateCollateralUrl () {
	if (!formLoaded) {
		return;
	}

	with (document.collateralForm) {
		var currentCommandType = getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>);
		if (currentCommandType == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>") {
			if (productResult == null) {
				if (currentCommandType == "<%= UIUtil.toJavaScript(thisUrlCommandType) %>") {
					loadValue(urlCommandProduct, "<%= UIUtil.toJavaScript(thisUrlCommandParameter) %>");
				}
				else {
					loadValue(urlCommandProduct, "");
				}
			}
		}
		else if ((currentCommandType == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
			(currentCommandType == "<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") ||
			(currentCommandType == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")) {
			if (itemResult == null) {
				if (currentCommandType == "<%= UIUtil.toJavaScript(thisUrlCommandType) %>") {
					loadValue(urlCommandItem, "<%= UIUtil.toJavaScript(thisUrlCommandParameter) %>");
				}
				else {
					loadValue(urlCommandItem, "");
				}
			}
		}
		else if (currentCommandType == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>") {
			if (categoryResult == null) {
				if (currentCommandType == "<%= UIUtil.toJavaScript(thisUrlCommandType) %>") {
					loadValue(urlCommandCategory, "<%= UIUtil.toJavaScript(thisUrlCommandParameter) %>");
				}
				else {
					loadValue(urlCommandCategory, "");
				}
			}
		}
		else if (currentCommandType == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
			if (couponResult == null) {
				if (currentCommandType == "<%= UIUtil.toJavaScript(thisUrlCommandType) %>") {
					loadValue(urlCommandCoupon, "<%= UIUtil.toJavaScript(thisUrlCommandParameter) %>");
				}
				else {
					loadValue(urlCommandCoupon, "");
				}
			}
		}
	}

	showDivisions();
}

function finishAction () {
	with (document.collateralForm) {
		// parameter must exist for pre-defined URL command
		if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
			if (getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>) == "command") {
				var currentCommandType = getSelectValue(<%= CampaignConstants.ELEMENT_COLLATERAL_URL_COMMAND_TYPE %>);
				if (currentCommandType == "<%= CampaignConstants.URL_PRODUCT_DISPLAY %>") {
					if (urlCommandProduct.value == "") {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralURLProductParameterRequired")) %>");
						return;
					}
				}
				else if ((currentCommandType == "<%= CampaignConstants.URL_ORDER_ITEM_ADD %>") ||
					(currentCommandType == "<%= CampaignConstants.URL_INTEREST_ITEM_ADD %>") ||
					(currentCommandType == "<%= CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION %>")) {
					if (urlCommandItem.value == "") {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralURLItemParameterRequired")) %>");
						return;
					}
				}
				else if (currentCommandType == "<%= CampaignConstants.URL_CATEGORY_DISPLAY %>") {
					if (urlCommandCategory.value == "") {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralURLCategoryParameterRequired")) %>");
						return;
					}
				}
				else if (currentCommandType == "<%= CampaignConstants.URL_ACCEPT_COUPON %>") {
					if (urlCommandCoupon.value == "") {
						alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralURLCouponParameterRequired")) %>");
						return;
					}
				}
			}
		}
	}

	finish();
}

function cancelAction () {
	if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("cancelConfirmation")) %>")) {
		cancelForm();
	}
}

function wc_validateCollateralName () {
	var collateralName = document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>.value;
	var invalidChars = "~!@#$%^&*+=;:<>?/|`"; // invalid chars
	invalidChars += "\t\"\\"; // escape sequences

	// if the string is empty it is not a valid name
	if (isEmpty(collateralName)) {
		return false;
	}

	// look for presence of invalid characters
	// if one is found then return false, otherwise return true
	for (var i=0; i<collateralName.length; i++) {
		if (invalidChars.indexOf(collateralName.substring(i, i+1)) >= 0) {
			return false;
		}
	}

	return true;
}

function wc_validateCollateralURL () {
	if (getSelectValue(document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
		if (getSelectValue(document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_URL_TYPE %>) == "custom") {
			if (!isValidUTF8length(getData("<%= CampaignConstants.ELEMENT_COLLATERAL_URL %>"), 254)) {
				return false;
			}
		}
	}
	return true;
}

function wc_validateCollateralLocation () {
	if (getSelectValue(document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
		if (!isValidUTF8length(getData("<%= CampaignConstants.ELEMENT_COLLATERAL_LOCATION %>"), 254)) {
			return false;
		}
	}
	return true;
}

function wc_validateCollateralMarketingText () {
	if (getSelectValue(document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "1") {
		if (!isValidUTF8length(getData("<%= CampaignConstants.ELEMENT_COLLATERAL_MARKETING_TEXT %>"), 4000)) {
			return false;
		}
	}
	return true;
}

function wc_validateCollateralStaticText () {
	if (getSelectValue(document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_TYPE %>) == "2") {
		if (!isValidUTF8length(getData("<%= CampaignConstants.ELEMENT_COLLATERAL_STATIC_TEXT %>"), 4000)) {
			return false;
		}
	}
	return true;
}

function finishHandler (msg) {
	// initialize panel state
	init();

	// build result object and return it to the previous panel
	var collateralResult = new Object();
	collateralResult.collateralId = "<%= UIUtil.toJavaScript(resultCollateralId) %>";
	collateralResult.collateralName = "<%= UIUtil.toJavaScript(resultCollateralName) %>";
	collateralResult.collateralCommandType = "<%= UIUtil.toJavaScript(resultCollateralCommandType) %>";
	collateralResult.collateralStoreId = "<%= campaignCommandContext.getStoreId() %>";
	top.sendBackData(collateralResult, "collateralResult");
	alertDialog(msg);

	// find out the number of panels to go back
	var numberOfBackPanels = 1;
	if (top.getData("isContentSearch", 2) == "Y") {
		numberOfBackPanels = 3;
	}
	top.goBack(numberOfBackPanels);
}

function errorHandler (msg, errorCode) {
	if (errorCode == "collateralExists") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralExists")) %>");
		document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>.select();
		document.collateralForm.<%= CampaignConstants.ELEMENT_COLLATERAL_NAME %>.focus();
	}
	else {
		alertDialog(msg);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
//Constucts file paths used by this collateral given an array of files
//@param File asset array
//@return File paths
//////////////////////////////////////////////////////////////////////////////////////////
function constructLocationString(assets){
		var strLocation="";
		var j=0;

		if(assets!=null){
			for(var i=0; i<assets.length; i++){
				if(assets[i].remove==true){
					j++;
				} else{
				 	if(assets[i].assetPath != null){
						strLocation= strLocation+assets[i].assetPath+"\n";
					}
				}
			}
			if(j==i){
				saveData("allRemoveAsset", "true");
			} else{
				saveData("allRemoveAsset", "false");
			}
		} else{
			saveData("allRemoveAsset", "false");
		}

		return strLocation;
	}

//////////////////////////////////////////////////////////////////////////////////////////
//Get first target id in the object. Relies on the assumption that all the target Id in
//the object are same.
//@param File asset array
//@return The first asset id
//////////////////////////////////////////////////////////////////////////////////////////
function getFirstTargetId(assets){
		var targetId="";
		if(assets!=null){
			for(var i=0; i<assets.length; i++){
				if(assets[i].remove==true){
					continue;
				} else{
				 	if(assets[i].atchtgtId != null){
						targetId= assets[i].atchtgtId;
						break;
					}
				}
			}
		return targetId;
	}
}





//-->
</script>
