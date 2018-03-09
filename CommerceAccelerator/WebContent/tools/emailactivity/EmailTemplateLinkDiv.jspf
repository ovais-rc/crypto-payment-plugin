<!-- 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//----------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
=========================================================================== -->

<script>

function loadValue (entryField, value) {
	if (value != top.undefined) {
		entryField.value = value;
	}
}

function getSearchResult()
{
		var foundResult = null;
		var searchType = top.getData("searchType", null);
		var newUrl = "";
		var linkType = top.getData("linkType",null);
		if (searchType == "productSingle") {
			foundResult = top.getData("productSearchSkuArray", null);
			if (foundResult != null) {
				loadValue(document.emailTemplateForm.productName, foundResult[0].productName);
				productResult = new Object();
				productResult.catentryId = foundResult[0].productSku;
				top.saveData(productResult, "productResult");
			}
			else {
				foundResult = top.getData("browserSelection", null);
				if (foundResult != null) {
					loadValue(document.emailTemplateForm.productName, foundResult[0].refName);
					productResult = new Object();
					productResult.catentryId = foundResult[0].refnum;
					top.saveData(productResult, "productResult");
				}
			}
		}
		else if (searchType == "itemSingle") {
			foundResult = top.getData("productSearchSkuArray", null);
			if (foundResult != null) {
				if(linkType == "Add to shopping cart")
				{
					loadValue(document.emailTemplateForm.selectItem, foundResult[0].productName);
				}
				else
				{
					loadValue(document.emailTemplateForm.selectInterestItem, foundResult[0].productName);
				}
				itemResult = new Object();
				itemResult.catentryId = foundResult[0].productSku;
				top.saveData(itemResult, "itemResult");
			}
			else {
				foundResult = top.getData("browserSelection", null);
				if (foundResult != null) {
					if(linkType == "Add to shopping cart")
					{
						loadValue(document.emailTemplateForm.selectItem, foundResult[0].refName);
					}
					else
					{
						loadValue(document.emailTemplateForm.selectInterestItem, foundResult[0].refName);
					}
					itemResult = new Object();
					itemResult.catentryId = foundResult[0].refnum;
					top.saveData(itemResult, "itemResult");
				}
			}
		}
		else if (searchType == "categorySingle") {
			foundResult = top.getData("categoryResult", null);
			if (foundResult != null) {
				loadValue(document.emailTemplateForm.selectCategory, foundResult[0].categoryName);
				categoryResult = new Object();
				categoryResult.categoryId = foundResult[0].categoryId;
				categoryResult.categoryName = foundResult[0].categoryName;
				categoryResult.isTopCategory = foundResult[0].isTopCategory;
				top.saveData(categoryResult, "categoryResult");
			}

		}
		else if (searchType == "emsSingle") {
			foundResult = top.getData("emsResult", null);
			if (foundResult != null) {
				loadValue(document.emailTemplateForm.eMarketingSpot, foundResult[0].emsName);
			}
		}
		else if (searchType == "adCopySingle") {
			foundResult = top.getData("adCopyResult", null);
			if (foundResult != null) {
				loadValue(document.emailTemplateForm.content, foundResult[0].collateralName);
			}
		}

}

function gotoCommandParameterDialog (paramValue)
{
	var url;
	var urlTitle;

	// save the panel data
	saveFormData();
	saveLinkFields();
	top.saveData("searchPage","comingFrom");
	top.saveData(null, "productSearchSkuArray");
	top.saveData(null,"browserSelection");

	// set flag to record that we are going on a product finder, category list or coupon list
	if (paramValue == "searchProduct") {
		top.saveData("productSingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog";
		urlTitle = "<%= emailActivityRB.get("searchProduct")%>"; 

	}
	else if (paramValue == "searchSku") {
		top.saveData("itemSingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>CampaignProductFindDialogView?XMLFile=campaigns.ProductFindDialog";
		urlTitle = "<%= emailActivityRB.get("searchItem")%>"; 
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
		urlTitle = "<%= emailActivityRB.get("browseProduct")%>"; 

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
		urlTitle = "<%= emailActivityRB.get("browseItem")%>"; 

		// save the panel settings
		top.saveData(param, "browseParameters");
		top.saveData(false, "allowMultiple");
	}
	else if (paramValue == "listCategory") {
		top.saveData("categorySingle", "searchType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CategoryDialog";
		urlTitle = "<%= emailActivityRB.get("listCategory")%>"; 
	}
	else if(paramValue == "listEmarketingSpot") {
		top.saveData("emsSingle","searchType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EMarketingSpotDialog";
		urlTitle = "<%= emailActivityRB.get("listEMSpots")%>"; 
	}
	else if(paramValue == "listAdCopy")
	{
		top.saveData("adCopySingle","searchType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.ContentSpotDialog";
		urlTitle = "<%= emailActivityRB.get("listContentSpots")%>"; 
	}
	top.setContent(urlTitle, url, true);
}
//-->
</script>


<!-- Div for Link -->
<Div id="linkSelect" style="display:none;margin-left: 22">
<br/>
<label for="clickActionLabel"><%= emailActivityRB.get("clickAction") 
%><br/></label>
<select name="clickActionList" id="clickActionLabel" single="SINGLE"
onchange = javascript:showHideLinkDivs()>
<option value = "predefined click"><%= emailActivityRB.get("predefinedClickAction")%></option>
<option value = "URL click"><%= emailActivityRB.get("urlClickAction")%></option>
</select> <br/><br/>

<!--div for URL as Click Action menu -->
<Div id="urlLinkSelect" style="display:none;">
<label for="url"><%= emailActivityRB.get("url")%><br/></label>
<input name="url" id="url" type="text" size="50" maxlength="254" /> 
<br/><br/>
<label for="text"><%= emailActivityRB.get("textLabel")%><br/></label>
<input name="textURL" id="text" type="text" size="50" maxlength="254" /><br/><br/>
<input name="recordClicksForURL" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label><br /> 
<!-- End of URL as click action menu -->
</Div>

<!-- div for predefined click action menu -->
<Div id="predefinedLinkSelect" style="display:none;">
<label for="predefinedClickActionLabel"><%= emailActivityRB.get("predefinedClickAction")%><br/></label>
<select name="predefinedClickActionsList" id="predefinedClickActionLabel" single="SINGLE"
onchange = javascript:showHidePredefinedClickDivs()>
<option value = "Display product"><%=emailActivityRB.get("displayProduct")%></option>
<option value = "Display category"><%=emailActivityRB.get("displayCategory")%></option>
<option value = "Add to shopping cart"><%=emailActivityRB.get("addToShoppingCart")%></option>
<option value = "Add to interest list"><%=emailActivityRB.get("addToInterestList")%></option>
<option value = "Unsubscribe"><%=emailActivityRB.get("unsubscribe")%></option>
</select> <br/><br/>

<!-- for display product div.. -->
<Div id="displayProductSelect" style="display:none;">
<label for="productName"><%= emailActivityRB.get("productNameLabel")%><br/></label>
<input name="productName" id="productName" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("productFind")%>' name="productFind" onclick="gotoCommandParameterDialog('searchProduct');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("productFind")%></button>&nbsp;
<button value='<%=emailActivityRB.get("productBrowse")%>' name="productBrowse" onclick="gotoCommandParameterDialog('browseProduct');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("productBrowse")%></button><br/><br/>
<input name="recordClicksForProduct" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label>
<br /> 
<!-- end of display product div.. -->
</Div>

<!-- for display category div.. -->
<Div id="displayCategorySelect" style="display:none;">
<label for="selectCategory"><%= emailActivityRB.get("selectCategory")%><br/></label>
<input name="selectCategory" id="selectCategory" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("categoryList")%>' name="categoryList" onclick="gotoCommandParameterDialog('listCategory');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("categoryList")%></button><br/><br/>
<input name="recordClicksForCategory" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label>
<br /> 
<!-- end of display category div.. -->
</Div>

<!-- for Add to Shopping Cart div.. -->
<Div id="shoppingCartSelect" style="display:none;">
<label for="selectItem"><%= emailActivityRB.get("selectItem")%><br/></label>
<input name="selectItem" id="selectItem" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("itemFind")%>' name="itemFind" onclick="gotoCommandParameterDialog('searchSku');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("itemFind")%></button>&nbsp;
<button value='<%=emailActivityRB.get("itemBrowse")%>' name="itemBrowse" onclick="gotoCommandParameterDialog('browseSku');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("itemBrowse")%></button><br/><br/>
<input name="recordClicksForSC" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label>
<br /> 
<!-- end of Add to shopping cart div.. -->
</Div>

<!-- for Add to interest List div.. -->
<Div id="interestListSelect" style="display:none;">
<label for="selectInterestItem"><%= emailActivityRB.get("selectInterestItem")%><br/></label>
<input name="selectInterestItem" id="selectInterestItem" type="text" size="50" maxlength="254" readOnly = 'true' />&nbsp;
<button value='<%=emailActivityRB.get("interestItemFind")%>' name="interestItemFind" onclick="gotoCommandParameterDialog('searchSku');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("interestItemFind")%></button>&nbsp;
<button value='<%=emailActivityRB.get("interestItemBrowse")%>' name="interestItemBrowse" onclick="gotoCommandParameterDialog('browseSku');" class="general" style="text-align: center; padding-left: 5px;">&nbsp;<%=emailActivityRB.get("interestItemBrowse")%></button><br/><br/>
<input name="recordClicksForIL" type="checkbox" id="recordClicks" /> <label for="recordClicks"><%=emailActivityRB.get("recordClicks")%></label>
<br /> 
<!-- end of Add to Interest List div.. -->
</Div>

<!--div for URL as Click Action menu -->
<Div id="unsubscribeSelect" style="display:none;">
<label for="unsubscribeUrlLabel"><%= emailActivityRB.get("unsubscribeUrl")%><br/></label>
<input name="unsubscribeUrl" id="unsubscribeUrlLabel" type="text" size="50" maxlength="254" /> 
<br/><br/>
<label for="unsubscribetext"><%= emailActivityRB.get("unsubscribeTextLabel")%><br/></label>
<input name="unsubscribeText" id="unsubscribetext" type="text" size="50" maxlength="254" /><br/><br/>
<!-- End of URL as click action menu -->
</Div>

<!-- End of predefined click action menu -->
</Div>
<!-- End of Div for Link -->
</Div>