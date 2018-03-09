

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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.shipping.ShippingConstants" %>
<%@ page import="com.ibm.commerce.order.calculation.CalculationConstants" %>
<%@ page import="com.ibm.commerce.tools.shipping.ShippingUtil" %>

<%@ include file="ShippingCommon.jsp" %>

<%	String loginLanguageId = shippingCommandContext.getLanguageId().toString(); 

	Hashtable campaignsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("campaigns.campaignsRB", shippingCommandContext.getLocale());
	if (campaignsRB == null) {
		System.out.println("Campaigns resouces bundle is null");
	}
	
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.selectWidth {width: 200px;}
.selectWidenWidth {width: 300px;}
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_PRODUCTS_PANEL_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/CalcCode.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>

<script language="JavaScript">
<!---- hide script from old browsers
// globals
// get the default currency and language in the calcCode bean


///////////////////////////////////////////////////////////////
// This function will add a complete SKU entered
// by the user in the text box to the multi-select box in the
// right hand side
//////////////////////////////////////////////////////////////
function addSKU (_sku, _name,_catentryId) {
	var inputSKU = trim(_sku);
	var inputName = trim(_name);
	var catentryId = trim(_catentryId)
	if (validateAddSKU(catentryId)) {
		var nextOptionIndex = document.whatForm.selectedSKUs.options.length;
		document.whatForm.selectedSKUs.options[nextOptionIndex] = new Option(
			inputName, // name
			inputSKU, // value
			false,    // defaultSelected
			false);   // selected
			
		
		var configFlagsArray = top.getData("config",null);
		if(configFlagsArray!=null){
			configFlagsArray[nextOptionIndex] = <%=CalculationConstants.CALFLAGS_ATTACHMENT%>;
		}
		top.saveData(configFlagsArray, "config");

		var editableFlagsArray = top.getData("editableFlags",null);
		if(editableFlagsArray!=null){
			editableFlagsArray[nextOptionIndex] = <%=ShippingConstants.EDITABLE_FLAG_YES%>;
		}
		top.saveData(editableFlagsArray, "editableFlags");
		
		var catentryIdsArray = top.getData("catentryIds",null);
		
		if(catentryIdsArray!=null){
			catentryIdsArray[nextOptionIndex] = catentryId;
		}
		
		top.saveData(catentryIdsArray, "catentryIds");
	
	}
}

///////////////////////////////////////////////////////////////
// This function will add a complete category entered
// by the user in the text box to the multi-select box in the
// right hand side
//////////////////////////////////////////////////////////////
function addCategory (cat, catName ,catGrpId) {
	var inputCat = trim(cat);
	var inputCatName = trim(catName);
	var inputCatGrpId = trim(catGrpId);
	if (validateAddCategory(inputCatGrpId)) {
		var nextOptionIndex = document.whatForm.selectedCategories.options.length;
		document.whatForm.selectedCategories.options[nextOptionIndex] = new Option(
			inputCatName, // name
			inputCat, // value
			false,    // defaultSelected
			false);   // selected
		var configCategoryFlagsArray = top.getData("configCategory",null);
		if(configCategoryFlagsArray!=null){
			configCategoryFlagsArray[nextOptionIndex] = <%=CalculationConstants.CALFLAGS_ATTACHMENT%>;
		}
		top.saveData(configCategoryFlagsArray, "configCategory");

		var categoryEditableFlagsArray = top.getData("categoryEditableFlags",null);
		if(categoryEditableFlagsArray!=null){
			categoryEditableFlagsArray[nextOptionIndex] = <%=ShippingConstants.EDITABLE_FLAG_YES%>;
		}
		top.saveData(categoryEditableFlagsArray, "categoryEditableFlags");
		
		
		var catGrpIdsArray = top.getData("catGrpIds",null);
		
		if(catGrpIdsArray != null){
			catGrpIdsArray[nextOptionIndex] = inputCatGrpId;
		}
		
		top.saveData(catGrpIdsArray, "catGrpIds");
	

	}
}

///////////////////////////////////////////////////////////////
// This function handles to move one or more items from 1 list
// box to the other. It is called menu-swapper
// input: component name (from);  component name (to)
//////////////////////////////////////////////////////////////
function removeSKU (selectedMultiselect) {
	var noSKUselected = true;
	var configFlagsArray = top.getData("config",null);
	var editableFlagsArray = top.getData("editableFlags",null);
	var catentryIdsArray = top.getData("catentryIds",null);
		
		
		
		
	
	
	for (var i=selectedMultiselect.options.length-1; i>=0; i--) {
		if (selectedMultiselect.options[i].selected && selectedMultiselect.options[i].value != "") {
			selectedMultiselect.options[i] = null; // remove the selection from the list
			if(configFlagsArray!=null){
				configFlagsArray[i] = null;
			}
			if(editableFlagsArray!=null){
				editableFlagsArray[i] = null;
			}
	
			if(catentryIdsArray!=null){
			catentryIdsArray[i] = null;
		}
		
			noSKUselected = false;
		}
	}
	
	
		
	if (noSKUselected) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SELECT_SKU_TO_REMOVE)) %>");
	}

	// update the remove button
	setButtonContext(document.whatForm.selectedSKUs, document.whatForm.removeButton);

	if(!noSKUselected && configFlagsArray!=null){
		var newArray = new Array();
		var j=0;
		//move forward to filter the null value
		for(var index=0;index<configFlagsArray.length;index++)	{
			if(configFlagsArray[index]!=null){
				newArray[j] = configFlagsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "config");
	}
	if(!noSKUselected && editableFlagsArray!=null){
		var newArray = new Array();
		var j=0;
		//move forward to filter the null value
		for(var index=0;index<editableFlagsArray.length;index++)	{
			if(editableFlagsArray[index]!=null){
				newArray[j] = editableFlagsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "editableFlags");
	}

		if(!noSKUselected && catentryIdsArray!=null){
		var newArray = new Array();
		var j=0;
		//move forward to filter the null value
		for(var index=0;index<catentryIdsArray.length;index++)	{
			if(catentryIdsArray[index]!=null){
				newArray[j] = catentryIdsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "catentryIds");
	}

}

function removeCategory (selectedMultiselect) {
	var noCategorySelected = true;
	var configCategoryFlagsArray = top.getData("configCategory",null);
	var editableCategoryFlagsArray = top.getData("categoryEditableFlags",null);
	var catGrpIdsArray = top.getData("catGrpIds",null);
	
	
	
	for (var i=selectedMultiselect.options.length-1; i>=0; i--) {
		if (selectedMultiselect.options[i].selected && selectedMultiselect.options[i].value != "") {
			selectedMultiselect.options[i] = null; // remove the selection from the list
			if(configCategoryFlagsArray!=null){
				configCategoryFlagsArray[i] = null;// need move foward after removing all xl?
			}
			if(editableCategoryFlagsArray!=null){
				editableCategoryFlagsArray[i] = null;// need move foward after removing all xl?
			}
			if(catGrpIdsArray != null){
			catGrpIdsArray[i] = null;
			}
		
			noCategorySelected = false;
		}
	}
	if (noCategorySelected) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_CATEGORY)) %>");			
	}

	// update the remove button
	setButtonContext(document.whatForm.selectedCategories, document.whatForm.removeCategoryButton);

	if(!noCategorySelected && configCategoryFlagsArray!=null){
		var newArray = new Array();
		var j=0;
		for(var index=0;index<configCategoryFlagsArray.length;index++)	{
			if(configCategoryFlagsArray[index]!=null){
				newArray[j] = configCategoryFlagsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "configCategory");
	}
	if(!noCategorySelected && editableCategoryFlagsArray!=null){
		var newArray = new Array();
		var j=0;
		for(var index=0;index<editableCategoryFlagsArray.length;index++)	{
			if(editableCategoryFlagsArray[index]!=null){
				newArray[j] = editableCategoryFlagsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "categoryEditableFlags");
	}

		if(!noCategorySelected && catGrpIdsArray!=null){
		var newArray = new Array();
		var j=0;
		//move forward to filter the null value
		for(var index=0;index<catGrpIdsArray.length;index++)	{
			if(catGrpIdsArray[index]!=null){
				newArray[j] = catGrpIdsArray[index];
				j++;
			}
		}
		top.saveData(newArray, "catGrpIds");
	}


}


function config(type){

	var noSelected = true;
	var isReadOnly = "";
	var selectedSelect=null;
	if (type=="product"){
		selectedSelect = document.whatForm.selectedSKUs;
	}
	else if (type=="category"){
		selectedSelect = document.whatForm.selectedCategories;
	}
	else if (type=="all"){
	}
	if (selectedSelect!=null){
		for (var i=selectedSelect.options.length-1; i>=0; i--) {
			if (selectedSelect.options[i].selected && selectedSelect.options[i].value != "") {
				noSelected = false;
				top.saveData(i, "configIndex");
				if(type == "product"){
					var editableFlags = top.getData("editableFlags");
					if(editableFlags[i]==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
						isReadOnly = "true";
					}				
				}
				else if(type=="category"){
					var editableFlags = top.getData("categoryEditableFlags");
					if(editableFlags[i]==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
						isReadOnly = "true";
					}				
				}
				break;            
			}
		}
		if ( noSelected) {
			if(type == "product"){
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_SKU)) %>");
			}
			else if(type == "category"){
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_CATEGORY)) %>");			
			}
			return;
		}
	}

	// save the panel
	savePanelData();

	// save the panel settings
	top.saveModel(parent.model);
	top.setReturningPanel("calcCodeProductPanel");

	// let's go...
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=shipping.CalcCodeAttachmentConfigureDialog&configType=" + type;
	if (isReadOnly!=""){
		url += "&amp;<%=ShippingConstants.PARAMETER_READONLY%>="+ isReadOnly;
	}
	top.setContent("<%= shippingRB.get(ShippingConstants.MSG_CONFIG_TITLE) %>", url, true);


}

// validate the sku when add to the list
function validateAddSKU (s) {
	if (isEmpty(s)) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SKU_CANNOT_BE_EMPTY)) %>");
		return false;
	}
	// make sure the Id will not be duplicate in the current store
	var inputCatentryId = trim(s);
	var editableFlags = top.getData("editableFlags",null);
	var catentryIdsArray = top.getData("catentryIds",null);
	
	for (var i=0; i<document.whatForm.selectedSKUs.options.length; i++) {
		//var SKUName = document.whatForm.selectedSKUs.options[i];
		var catentryId = catentryIdsArray[i];
		var editableFlag = editableFlags[i];
		if ((inputCatentryId == catentryId)&&(editableFlag==<%=ShippingConstants.EDITABLE_FLAG_YES%>)) {
			return false;
		}
	}
	return true;
}

// validate the sku when add to the list
function validateAddCategory (s) {
	if (isEmpty(s)) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CATEGORY_CANNOT_BE_EMPTY)) %>");
		return false;
	}
	// make sure the category will not be duplicate in the current store
	var inputCatGrpId = trim(s);
	var editableFlags = top.getData("categoryEditableFlags",null);
	var catGrpIdsArray = top.getData("catGrpIds",null);

	for (var i=0; i<document.whatForm.selectedCategories.options.length; i++) {
		//var catName = document.whatForm.selectedCategories.options[i];
		var catGrpId = catGrpIdsArray[i];
		var editableFlag = editableFlags[i];
		if ((inputCatGrpId == catGrpId)&&(editableFlag==<%=ShippingConstants.EDITABLE_FLAG_YES%>)) {
			return false;
		}
	}
	return true;
}

function showDivisions () {

	if (document.whatForm.whatTypeRadio[0].checked) {
		document.all.allProductsDiv.style.display = "block";
		document.all.specificProductFilterDiv.style.display = "none";
		document.all.categoryDiv.style.display = "none";
	}
	else if (document.whatForm.whatTypeRadio[1].checked) {
		document.all.allProductsDiv.style.display = "none";
		document.all.specificProductFilterDiv.style.display = "block";
		document.all.categoryDiv.style.display = "none";
	}
	else if (document.whatForm.whatTypeRadio[2].checked) {
		document.all.allProductsDiv.style.display = "none";
		document.all.specificProductFilterDiv.style.display = "none";
		document.all.categoryDiv.style.display = "block";
	}
}

function onSelect(thisSelect){
	setButtonContext(thisSelect, document.whatForm.removeButton);
	setButtonContext(thisSelect, document.whatForm.removeCategoryButton);
	
	if (isCurrentStore() == false){
		setButtonContext(thisSelect, document.whatForm.configButton);
       	setButtonContext(thisSelect, document.whatForm.configCategoryButton);
		}
    

	
	var flags = top.getData("editableFlags", null);
	if(flags!=null){
		for(var i=0;i<thisSelect.options.length;i++){
			if(thisSelect.options[i].selected)
			{
				if(flags[i]==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
					disableButton(document.whatForm.removeButton);
					break;
				}
			}
		}
	}

	var categoryFlags = top.getData("categoryEditableFlags", null);
	if(categoryFlags!=null){
		for(var i=0;i<thisSelect.options.length;i++){
			if(thisSelect.options[i].selected)
			{
				if(categoryFlags[i]==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
					disableButton(document.whatForm.removeCategoryButton);
					break;
				}
			}
		}
	}
	
}


///////////////////////////////////////////////////////////////
// INITIALIZE THE PANEL
///////////////////////////////////////////////////////////////


function initializeValues () {
	var databean = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
	
	if(databean != null){
	
	// initialize the radio button
	if (databean.whatType == "<%= ShippingConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") {
		document.whatForm.whatTypeRadio[1].checked = true;
	}
	else if (databean.whatType == "<%= ShippingConstants.WHAT_TYPE_CATEGORY %>") {
		document.whatForm.whatTypeRadio[2].checked = true;
	}
	
	// show the correct division based on the radio button selection
	showDivisions();
	

	// setup the selected SKU's
	var SKUsSelected = databean.productSkus;
	var SKUsSelectedName = databean.productNames;
	var catentryIds = databean.catentryIds; 
	var catGrpIds = databean.catGrpIds;
	var editableFlags = databean.catentryCalCodeEditableFlags;
	var calFlags = new Array();
	var j =0;

	for (var i=0; i<SKUsSelected.length; i++) {
		var SKUName = SKUsSelected[i];
		var ProductName = SKUsSelectedName[i];
		//specific products will displayed in the select list
		if(SKUName != "" && ProductName != ""){
			document.whatForm.selectedSKUs.options[i] = new Option(ProductName, SKUName, false, false);
			document.whatForm.selectedSKUs.options[i].selected = false;
		
			var flag = editableFlags[i];
			if(flag==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
				document.whatForm.selectedSKUs.options[i].style.setExpression("backgroundColor","'lightgrey'");
				document.whatForm.selectedSKUs.options[i].style.setExpression("color","'gray'");
			}
			calFlags[j] = databean.catentryCalFlags[i];
			j++;
		}
		else{
			if(top.getData("configFlagForAll", null)==null)
			{
				var configFlagForAll = databean.catentryCalFlags[i];
				if(configFlagForAll == null){
					configFlagForAll = <%=CalculationConstants.CALFLAGS_ATTACHMENT%>;
				}
				top.saveData(configFlagForAll, "configFlagForAll");
			}
		}
	}
	
	if(top.getData("config", null)==null)
	{
		top.saveData(calFlags, "config");
	}

	if(top.getData("editableFlags", null)==null)
	{
		var editableFlagsArray = new Array();
		for(var i=0;i<SKUsSelected.length;i++){
			editableFlagsArray[i]=databean.catentryCalCodeEditableFlags[i];
		}
		top.saveData(editableFlagsArray, "editableFlags");
	}

	if(top.getData("catentryIds", null)==null)
	{
		var catentryIdsArray = new Array();
		for(var i=0;i<SKUsSelected.length;i++){
			catentryIdsArray[i]=databean.catentryIds[i];
		}
		top.saveData(catentryIdsArray, "catentryIds");
	}
	
	
	
	var categories = databean.selectedCategories;
	var catNames = databean.selectedCategoriesNames;
	var catEditableFlags = databean.categoryCalCodeEditableFlags;
	if(categories!=null){
		for (var i=0; i<categories.length; i++) {
			var category = categories[i];
			var categoryName = catNames[i];
			document.whatForm.selectedCategories.options[i] = new Option(categoryName, category, false, false);
			document.whatForm.selectedCategories.options[i].selected = false;
		
			var flag = catEditableFlags[i];
			if(flag==<%=ShippingConstants.EDITABLE_FLAG_NO%>){
				document.whatForm.selectedCategories.options[i].style.setExpression("backgroundColor","'lightgrey'");
				document.whatForm.selectedCategories.options[i].style.setExpression("color","'gray'");
			}
		}
	}

	//only load when first from DB
	if(top.getData("configCategory", null)==null)
	{
		var configCategoryFlagsArray = new Array();
		for(var i=0;i<categories.length;i++){
			configCategoryFlagsArray[i]=databean.categoryCalFlags[i];
		}
		top.saveData(configCategoryFlagsArray, "configCategory");
	}

	if(top.getData("categoryEditableFlags", null)==null)
	{
		var editableFlagsArray = new Array();
		for(var i=0;i<categories.length;i++){
			editableFlagsArray[i]=databean.categoryCalCodeEditableFlags[i];
		}
		top.saveData(editableFlagsArray, "categoryEditableFlags");
	}

	if(top.getData("catGrpIds", null)==null)
	{
		var catGrpIdsArray = new Array();
		for(var i=0;i<categories.length;i++){
			catGrpIdsArray[i]=databean.strCatGrpIds[i];
		}
		top.saveData(catGrpIdsArray, "catGrpIds");
	}
	
	// check to see if we are returning from a product/category finder
	setupFinderResultSets();
	// update the remove button
	
	setButtonContext(document.whatForm.selectedSKUs, document.whatForm.removeButton);
	setButtonContext(document.whatForm.selectedCategories, document.whatForm.removeCategoryButton);
       if (isCurrentStore() == false){
       		setButtonContext(document.whatForm.selectedSKUs, document.whatForm.configButton); 
       		setButtonContext(document.whatForm.selectedCategories, document.whatForm.configCategoryButton);       
		}
	
	// for *NOTEBOOK* validation, check these error flags set in the model
	// to see if anything failed on the validation.

	// check that a product was selected
	if (parent.get("productRequired", false)) {
		parent.remove("productRequired");
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_SKU)) %>");
	}

	// check that a filter was selected
	if (parent.get("filterRequired", false)) {
		parent.remove("filterRequired");
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_ONE_FILTER)) %>");
	}

	
	// ensure that a category is selected
	if (parent.get("categoryRequired", false)) {
		parent.remove("categoryRequired");
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_ENTER_VALID_CATEGORY)) %>");
	}
	}
	

	disableUncheckRadio();
	parent.setContentFrameLoaded(true);
}



///////////////////////////////////////////////////////////////
// SAVE THE PANEL
///////////////////////////////////////////////////////////////
function savePanelData () {
	var databean = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);

	if (databean != null){
			//save for all product
		if(document.whatForm.whatTypeRadio[0].checked) {
		
			//clear "Specific Products"
			databean.productSkus = new Array();
			databean.productNames = new Array();
			databean.catentryCalFlags = new Array();
			databean.catentryCalCodeEditableFlags = new Array();
			databean.catentryIds = new Array(); 
			
			//clear "Categories"
			databean.selectedCategories = "";
			databean.selectedCategoriesNames = "";
			databean.categoryCalFlags = "";
			databean.categoryCalCodeEditableFlags = "";
			databean.catGrpIds = "";
			databean.strCatGrpIds = "";
			
			databean.productSkus[0] = "";
			databean.productNames[0] = "";
			var configFlagForAll = top.getData("configFlagForAll", null);
			if(configFlagForAll == null){
				configFlagForAll = <%=CalculationConstants.CALFLAGS_ATTACHMENT%>;
			}
			databean.catentryCalFlags[0] = configFlagForAll;
		}// save the product SKUs
			else if(document.whatForm.whatTypeRadio[1].checked) {
			
			//clear "Categories"
			//defect 130226: not clear "Categories"
			//databean.selectedCategories = "";
			//databean.selectedCategoriesNames = "";
			//databean.categoryCalFlags = "";
			//databean.categoryCalCodeEditableFlags = "";
			//databean.catGrpIds = "";		
		 
			var SKUsSelected = document.whatForm.selectedSKUs.options;
			var selectedSKUs = new Array();
			var selectedNames = new Array();
			for (var i=0; i<SKUsSelected.length; i++) {
				selectedSKUs[i] = SKUsSelected[i].value;
				selectedNames[i] = SKUsSelected[i].text;
			}
			databean.productSkus = selectedSKUs;
			databean.productNames = selectedNames;
			databean.catentryCalFlags = top.getData("config", null);
			databean.catentryCalCodeEditableFlags = top.getData("editableFlags", null);
			databean.catentryIds = top.getData("catentryIds" , null); 
			
		}
		//save category
		else if(document.whatForm.whatTypeRadio[2].checked) {
		
			//clear "Specific Products"
			//defect 130226: not clear "Specific Products"
			//databean.productSkus = "";
			//databean.productNames = "";
			//databean.catentryCalFlags = "";
			//databean.catentryCalCodeEditableFlags = "";
			//databean.catentryIds = ""; 
			
			var categoriesSelected = document.whatForm.selectedCategories.options;
			var catSelected = new Array();
			var catNamesSelected = new Array();
			for (var i=0;i<categoriesSelected.length;i++){
				catSelected[i] = categoriesSelected[i].value;
				catNamesSelected[i] = categoriesSelected[i].text;
			}
			databean.selectedCategories = catSelected;
			databean.selectedCategoriesNames = catNamesSelected;
			databean.categoryCalFlags = top.getData("configCategory", null);
			databean.categoryCalCodeEditableFlags = top.getData("categoryEditableFlags", null);
			databean.catGrpIds = top.getData("catGrpIds" , null); 
			databean.strCatGrpIds = top.getData("catGrpIds" , null); 
		}


	// save the radio selection (either "specific product" or the "system what filters")
	if(document.whatForm.whatTypeRadio[0].checked) {
		databean.whatType = "";
	}
	else if (document.whatForm.whatTypeRadio[1].checked) {
		databean.whatType = "<%= ShippingConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>";
		
	}
	else if (document.whatForm.whatTypeRadio[2].checked) {
		databean.whatType = "<%= ShippingConstants.WHAT_TYPE_CATEGORY %>";
		
				
	} 
	top.saveModel(parent.model);
	
 	parent.addURLParameter("authToken", "${authToken}");
 
	}
}



function validatePanelData () {

	// ensure at least SKU has been selected!
	if (document.whatForm.whatTypeRadio[1].checked && document.whatForm.selectedSKUs.options.length <= 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_SKU)) %>");
		return false;
	}

	
	// make sure at least a category has been selected.
	if (document.whatForm.whatTypeRadio[2].checked && document.whatForm.selectedCategories.options.length <=0) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PLEASE_ENTER_VALID_CATEGORY)) %>");
		return false;
	}

	return true;
}


function validateNoteBookPanel() {
	return validatePanelData();

}


function getCategoryName () {

   // save the panel
	savePanelData();

	// set flag to record that we are going on a category find
	top.saveData("categoryName", "whenAddFind");

	// save the panel settings
	top.saveModel(parent.model);
	top.setReturningPanel("calcCodeProductPanel");

	// load parent frame
	var url = "<%= ShippingConstants.URL_CALCCODE_CATEGORY_LIST_VIEW %>";
	top.setContent("<%= campaignsRB.get("CategoryListDialogTitle") %>", url, true);
}


function gotoSearchSkuDialog () {

	
	// save the panel
	savePanelData();

	// set flag to record that we are going on a product find
	top.saveData("productMultiple", "whenAddFind");
	//to tell the compain catalog search dialog (ProductFindPanel.jsp) to search products and items.
	top.saveData("productMultiple", "searchType");

	// save the panel settings
	top.saveModel(parent.model);
	top.setReturningPanel("calcCodeProductPanel");

	// let's go...
	var url = "<%= ShippingConstants.URL_CALCCODE_PRODUCT_FIND_DIALOG_VIEW %>";
	top.setContent("<%= campaignsRB.get("productFindPanelTitle") %>", url, true);
}

function gotoBrowseSkuDialog () {


	// save the panel
	savePanelData();
	

	// set flag to record that we are going on a product browser
	top.saveData("product", "whenAddFind");

	// set browsing tree parameters
	var bp = new Object();
	bp.selectionType = "CE";
	bp.locationType = "allType";
	bp.catalogId = "";
	bp.categoryId = "";
	top.saveData(bp, "browseParameters");
	top.saveData(true, "allowMultiple");

	// save the panel settings
	top.saveModel(parent.model);
	top.setReturningPanel("calcCodeProductPanel");

	// let's go...
	var url = "<%= ShippingConstants.URL_CALCCODE_PRODUCT_BROWSE_DIALOG_VIEW %>";
	top.setContent("<%= campaignsRB.get("ProductBrowsePanelTitle") %>", url, true);
}

function setupFinderResultSets () {
	// check to see if we are returning from a product finder
	var finder = top.getData("whenAddFind", null);
	if (finder == "productMultiple") {
		// check to see if we have any sku's in the result set
		var foundSku = top.getData("productSearchSkuArray", null);
		if (foundSku != null) {
			for (var i=0; i<foundSku.length; i++) {
				// add all the sku's in the array and put it in the select box
				addSKU(foundSku[i].productSku, foundSku[i].displayText ,foundSku[i].productId);
			}
			top.saveData(null, "productSearchSkuArray");
		}
	}
	else if (finder == "product") {
		// check to see if we have any sku's in the result set from browser
		var browseResult = top.getData("browserSelection", null);
		if (browseResult != null) {
			for (var i=0; i<browseResult.length; i++) {
				// add all the sku's in the array and put it in the select box
				addSKU(browseResult[i].refnum, browseResult[i].displayText ,browseResult[i].objectId);
			}
			top.saveData(null, "browserSelection");
		}
	}

	else if (finder == "categoryName") {
		// check to see if we have any category in the result set
		var foundCategory = top.getData("categoryResult", null);

		if (foundCategory != null) {
			// get the first sku in the array and put it in the input box
			for(var i=0;i<foundCategory.length;i++){
				addCategory(foundCategory[i].categoryIdentifier, foundCategory[i].categoryName,foundCategory[i].categoryId);
			}
			top.saveData(null, "categoryResult");
		}
	}

	top.saveData(null, "whenAddFind");
}

function isCurrentStore(){
	//check to see if this shipping code owns by this store.
	var databean = parent.get("<%= ShippingConstants.ELEMENT_CALCCODE_BEAN %>", null);
	
	if ( (databean != null) && (databean.storeEntityId == <%= fStoreId%>)){
		return true;
	}
	else{
		return false;
	}
}

function disableUncheckRadio(){
	//if not currentStore,disable other radio buttons which are not checked.
	if (isCurrentStore() == false){
		for(var i=0; i < document.whatForm.whatTypeRadio.length ; i++){
		if (document.whatForm.whatTypeRadio[i].checked != "1"){
			document.whatForm.whatTypeRadio[i].disabled = true;
			}
	
		}
	}
}
	



//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="initializeValues();" class="content">


<h1><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_PRODUCTS_PROMPT) %></h1>

<LINE3><%= shippingRB.get("calcCodeProdDesc") %></LINE3>

<form name="whatForm">

<input type="HIDDEN" name="categoryLanguageId" value="<%= loginLanguageId %>">
<input type="HIDDEN" name="productDescriptionLanguageId" value="<%= loginLanguageId %>">

<!-- Product Search Division -->
<p>
<LABEL for="whatTypeRadio"><input tabindex="1" type="radio" name="whatTypeRadio" id="whatTypeRadio" onclick="showDivisions();" checked ></LABEL><%= shippingRB.get("appliesToAll") %><br>
</p>
<p></p>
<div id="allProductsDiv" style="display: none; margin-left: 50">
<table>
<tbody>
<tr>

<script>
 if (isCurrentStore() == false){
 	document.writeln("<td colspan='2'>");
 	document.writeln("<%= shippingRB.get(ShippingConstants.MSG_CONFIG_PROMPT_ALLPRODUCT) %>");
 	document.writeln("</td><td valign='top'>");
 	document.writeln("<input tabindex='6' type='button' name='configAllButton' value='<%= shippingRB.get(ShippingConstants.MSG_BUTTON_CONFIG) %>' onclick='config(\"all\")' class='enabled' style='width:200px'>");
    document.writeln("</td>");  
	}
</script>
</tr>
</tbody>
</table>
</div>

<p>
<LABEL for="whatTypeRadio"><input tabindex="1" type="radio" name="whatTypeRadio" id="whatTypeRadio" onclick="showDivisions();" ></LABEL><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_SPECIFIC_PRODUCT) %><br>
</p>

<div id="specificProductFilterDiv" style="display: none; margin-left: 50">
<!--<p>-->
<table>
	<tbody><tr>
		<td colspan="2"><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_SELECTED_PRODUCTS) %></td>
	</tr>
	<tr>
		<td>
			<LABEL for="selectedSKUs"><select tabindex="2" name="selectedSKUs" id="selectedSKUs" class="selectWidenWidth" multiple size="6" onchange="javascript:onSelect(this)" >
			</select></LABEL>
			
		</td>
		<td valign="top">
			<input tabindex="3" type="button" name="searchButton" value="<%= shippingRB.get(ShippingConstants.MSG_BUTTON_FIND_ELLIPSIS) %>" onclick="gotoSearchSkuDialog();" class="enabled" style="width:200px" ><br>
			<input tabindex="4" type="button" name="browseButton" value="<%= shippingRB.get(ShippingConstants.MSG_BUTTON_BROWSE_ELLIPSIS) %>" onclick="gotoBrowseSkuDialog();" class="enabled" style="width:200px" ><br>
			<input tabindex="5" type="button" name="removeButton" value="<%= shippingRB.get(ShippingConstants.MSG_CALCCODE_PRODUCTS_REMOVE_SKU) %>" onclick="removeSKU(this.form.selectedSKUs);" class="enabled" style="width:200px" ><br>
			
<script>
 if (isCurrentStore() == false){
 	document.writeln(" <input tabindex='6' type='button' name='configButton' value='<%= shippingRB.get(ShippingConstants.MSG_BUTTON_CONFIG) %>' onclick='config(\"product\");' class='enabled' style='width:200px' >");
 	}
</script>

	</tr>
</tbody></table>
<!--</p>-->
</div>


<p>
<!-- Category Division -->
<LABEL for="whatTypeRadio"><input tabindex="1" type="radio" name="whatTypeRadio" id="whatTypeRadio" onclick="showDivisions();" ></LABEL><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_PRODUCTS_CATEGORY) %><br>
</p>
<!--<p>-->
<div id="categoryDiv" style="display: none; margin-left: 50">
<%= shippingRB.get(ShippingConstants.MSG_CALCCODE_PRODUCTS_CATEGORY_PROMPT) %><br>
<table>
	<tbody>
	<tr>
	<td valign="top">
	<LABEL for="selectedCategories"><select tabindex="2" name="selectedCategories" id="selectedCategories" class="selectWidenWidth" multiple size="4" onchange="javascript:onSelect(this);" >
	</select></LABEL>
	</td>

		<td valign="top">
		<input tabindex="3" type="button" name="findCategoryNameButton" value="<%= shippingRB.get(ShippingConstants.MSG_BUTTON_LIST_ELLIPSIS) %>" style="width:200px" onclick="getCategoryName();" class="enabled" ><br>
		<input tabindex="4" type="button" name="removeCategoryButton" value="<%= shippingRB.get(ShippingConstants.MSG_BUTTON_REMOVE_CATEGORY) %>" style="width:200px" onclick="removeCategory(this.form.selectedCategories)" class="enabled" ><br>
		
<script>
 if (isCurrentStore() == false){
 	document.writeln(" <input tabindex='6' type='button' name='configCategoryButton' value='<%= shippingRB.get(ShippingConstants.MSG_BUTTON_CONFIG) %>' style='width:200px' onclick='config(\"category\");' class='enabled'  >");
 	 
 	}

</script> 
		</td>
	</tr>
</tbody></table>
</div>


<!--</p>-->
</form>

</body>

</html>
