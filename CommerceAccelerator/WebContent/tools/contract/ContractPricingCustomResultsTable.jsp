<!-- ==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
   import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.ProductSearchListDataBean,
   com.ibm.commerce.price.utils.*,
   com.ibm.commerce.tools.common.ui.taglibs.*,
   com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   String _contractId = "";
   String catalogId = "";
   String categoryId = "";
   String categoryDisplayText = "";
   String searchActionType = "";
   String searchSelectionType = "";
   String targetView = "";
   String targetXML = "";
   String srCategoryName = "";
   String srCategoryShort = "";
   String srCategoryNameType = "";
   String srCategoryShortType = "";
   String srItemSku = "";
   String srItemName = "";
   String srItemShort = "";
   String srItemSkuType = "";
   String srItemNameType = "";
   String srItemShortType = "";
   String orderByParm = "";

   try {
      TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
      if (requestProperties != null) {
         _contractId = (String)requestProperties.getString("contractId");
         catalogId = (String)requestProperties.getString("catalogId");
         categoryId = (String)requestProperties.getString("categoryId");
         categoryDisplayText = (String)requestProperties.getString("categoryDisplayText");
         searchActionType = (String)requestProperties.getString("searchActionType");
         searchSelectionType = (String)requestProperties.getString("searchSelectionType");
         targetView = (String)requestProperties.getString("targetView");
         targetXML = (String)requestProperties.getString("targetXML");
         srCategoryName = (String)requestProperties.getString("srCategoryName");
         srCategoryShort = (String)requestProperties.getString("srCategoryShort");
         srCategoryNameType = (String)requestProperties.getString("srCategoryNameType");
         srCategoryShortType = (String)requestProperties.getString("srCategoryShortType");
         srItemSku = (String)requestProperties.getString("srItemSku");
         srItemName = (String)requestProperties.getString("srItemName");
         srItemShort = (String)requestProperties.getString("srItemShort");
         srItemSkuType = (String)requestProperties.getString("srItemSkuType");
         srItemNameType = (String)requestProperties.getString("srItemNameType");
         srItemShortType = (String)requestProperties.getString("srItemShortType");
              orderByParm = request.getParameter("orderby");
      }
      if (orderByParm.length() == 0)
         orderByParm = ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME;

      ProductSearchListDataBean cList = new ProductSearchListDataBean();
      cList.setSearchType(request.getParameter("searchActionType"));
      cList.setStoreID(fStoreId.toString());
      cList.setLanguageID(fLanguageId);
      cList.setCatalogID(catalogId);
      cList.setContractID(_contractId);
      cList.setOrderBy(orderByParm);
      cList.setPartNumber(srItemSku);
      cList.setPartNumberLike(srItemSkuType);
      cList.setName(srItemName);
      cList.setNameLike(srItemNameType);
      cList.setShortDescription(srItemShort);
      cList.setShortDescriptionLike(srItemShortType);
      //cList.setCategoryName(strCategoryName);
      //cList.setCategoryNameCaseSensitive(request.getParameter("categoryNameCaseSensitive"));

      int startIndex = Integer.parseInt(request.getParameter("startindex"));
      int listSize = Integer.parseInt(request.getParameter("listsize"));
      int endIndex = startIndex + listSize;
      cList.setIndexBegin(""+startIndex);
      cList.setIndexEnd(""+endIndex);

      int numberOfResults = 0;

      DataBeanManager.activate(cList, request);
      int totalsize = cList.getResultSetSize();
      int totalpage = (totalsize+listSize-1)/listSize;

      numberOfResults = totalsize;

      if (endIndex > totalsize) {
         endIndex = totalsize;
      }
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractProductSearchResultsTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CustomPricing.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
// create a new global price TC pointer to the "scratchCustomPriceTC" creating by the
// dynamic list prior to launching this dialog.
// SCPTC will have default values as per ContractCustomPricingModel() constructor.
// all the data is this dialog is stored in the object and passed back to the
// dynamic list on save.
///////////////////////////////////////

///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
var ccdm = top.getData("ccdm", 1);
var tempModel;
var scptc;
var runSavePanelData = true;

function loadPanelData () {
   var insertCounter = 0;

   // check to see if the model has already been loaded ...
   scptc = top.getData("scratchCustomPriceTC", 0);

   if (scptc == null) {
      scptc = new Array();
      top.saveData(scptc, "scratchCustomPriceTC");
   }

   tempModel = new Array();
<% for (int i = 0; i < cList.getListSize(); i++) { %>
   tempModel[insertCounter] = new Object();
   tempModel[insertCounter].productId = "<%= cList.getCatalogListData(i).getID().toString() %>";
<%
      MemberDataBean mdb = new MemberDataBean();
      mdb.setId(cList.getCatalogListData(i).getMemberID().toString());
      DataBeanManager.activate(mdb, request);
%>
   tempModel[insertCounter].productMember = new Member("<%= mdb.getMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>");
   tempModel[insertCounter].productIdentifier = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getIdentifier()) %>";
   tempModel[insertCounter].productName = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getName()) %>";
   tempModel[insertCounter].productShortDescription = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getShortDescription()) %>";
<%    if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_PRODUCT)) { %>
   tempModel[insertCounter].productType = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductTypeProduct")) %>";
<%    } else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_ITEM)) { %>
   tempModel[insertCounter].productType = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductTypeItem")) %>";
<%    } else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_PACKAGE)) { %>
   tempModel[insertCounter].productType = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductTypePackage")) %>";
<%    } else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_BUNDLE)) { %>
   tempModel[insertCounter].productType = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductTypeBundle")) %>";
<%    } else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_DYNAMIC_KIT)) { %>
   tempModel[insertCounter].productType = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductTypeDynamicKit")) %>";
<%    } %>
   tempModel[insertCounter].productChildSku = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getNumOfSKUs().toString()) %>";
   tempModel[insertCounter].productPublished = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getPublished()) %>";
   tempModel[insertCounter].productQuantityUnit = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getQuantityUnit()) %>";
   tempModel[insertCounter].checkValue = false;
   tempModel[insertCounter].productPrice = "";
   insertCounter++;
<% } %>
}

function loadPriceValue () {
   for (var i=0; i<tempModel.length; i++) {
      for (var j=0; j<scptc.length; j++) {
         if (tempModel[i].productId == scptc[j].productId) {
            document.all("check" + tempModel[i].productId).checked = scptc[j].checkValue;
            document.all("price" + tempModel[i].productId).value = scptc[j].productPrice;
            break;
         }
      }
   }
   parent.setChecked();
}

function performAdd () {
   // save data in this page
   savePanelData();
   runSavePanelData = false;

   // helper variables
   var duplicateCheck = false;
   var invalidCheck = false;
   var insertCounter = 0;
   var tempString = "";//stores a string of the duplicate products selected
   var dupCounter = 0;//keeps track of how many duplicates are found

   if (scptc.length > 0) {
      // loop through each record in the model to see if it has been selected in the list or not
      var newCustomPriceTC = new ContractCustomPricingModel();
      var currentCustomPriceTC = top.getData("currentCustomPriceTC", 1);
      // error checking to see if the model exists or not
      if (currentCustomPriceTC != null) {
         for (var i=0; i<scptc.length; i++) {
            // check if duplicate record exists by compare current tc model with page model
            for (var j=0; j<currentCustomPriceTC.customPriceTC.length; j++) {
               if ((scptc[i].productIdentifier == currentCustomPriceTC.customPriceTC[j].productIdentifier) && (!currentCustomPriceTC.customPriceTC[j].markedForDelete)) {
                  duplicateCheck = true;
                  break;
               }
            }

            // check if the textbox value is valid, and not empty
            if ((!scptc[i].checkValue)) {
               invalidCheck = true;
            } else {
               if (trim(scptc[i].productPrice) == "") {
                  alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchPriceMustBeDefined")) %>");
                  runSavePanelData = true;
                  return;
               }
               //Alert is shown if a product is selected to be added but has already been added
               if(duplicateCheck){
                  if(scptc[i].productName == null || scptc[i].productName==""){
                     tempString = tempString + "<BR> &nbsp;&nbsp;&nbsp;  " + scptc[i].productIdentifier ;
                     dupCounter++;
                  }
                  else{
                     tempString = tempString + "<BR> &nbsp;&nbsp;&nbsp;  " + scptc[i].productName + " (" + scptc[i].productIdentifier + ")";
                     dupCounter++;
                  }
               }
            }

            // add entry to the model to be sent back only if duplicate doesn't exist
            if (duplicateCheck || invalidCheck) {
               duplicateCheck = false;
               invalidCheck = false;
            }
            else {
               newCustomPriceTC.customPriceTC[insertCounter] = new CustomPriceTC();
               newCustomPriceTC.customPriceTC[insertCounter].markedForDelete = false;
               newCustomPriceTC.customPriceTC[insertCounter].productId = scptc[i].productId;
               newCustomPriceTC.customPriceTC[insertCounter].productMember = scptc[i].productMember;
               newCustomPriceTC.customPriceTC[insertCounter].productIdentifier = scptc[i].productIdentifier;
               newCustomPriceTC.customPriceTC[insertCounter].productName = scptc[i].productName;
               newCustomPriceTC.customPriceTC[insertCounter].productShortDescription = scptc[i].productShortDescription;
               newCustomPriceTC.customPriceTC[insertCounter].productPublished = scptc[i].productPublished;
               newCustomPriceTC.customPriceTC[insertCounter].productQuantityUnit = scptc[i].productQuantityUnit;
               newCustomPriceTC.customPriceTC[insertCounter].productPriceInfo = new Array();
               newCustomPriceTC.customPriceTC[insertCounter].productPriceInfo[0] = new CustomProductPrice(parent.parent.currencyToNumber(scptc[i].productPrice, ccdm.storeDefaultCurr, "<%= fLanguageId %>"), ccdm.storeDefaultCurr, true);
               insertCounter++;
            }
         }
         //Display a message if a product has been selected which has already been added previously
         tempString = tempString + "<BR>";
         if(dupCounter == 1){
            //if there has only been one duplicate
            alertDialog(finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductDuplicateSingle")) %>", tempString));
         }
         else if(dupCounter > 1){
            //if there has been more than one duplicate
            alertDialog(finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchResultsProductDuplicatePlural")) %>", tempString));
         }


      }

      // save the model containing new entries back to the custom price list
      top.saveData(null, "scratchCustomPriceTC");
      top.sendBackData(newCustomPriceTC, "ContractCustomPricingNewPriceTC");
      top.goBack();
   }
   else {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchAtLeastOneItem")) %>");
   }
}

// called when cancel button is clicked
function performCancel () {
   // clear data in this page
   runSavePanelData = false;
   top.saveData(null, "scratchCustomPriceTC");

   var urlparm = new Object();
   urlparm.XMLFile = "contract.PriceListProductFindDialog";
   urlparm.contractId = "<%= _contractId %>";
   urlparm.catalogId = "<%= catalogId %>";
   urlparm.categoryId = "<%= categoryId %>";
   urlparm.categoryDisplayText = "<%= UIUtil.toJavaScript(categoryDisplayText) %>";
   urlparm.searchActionType = "<%= searchActionType %>";
   urlparm.searchSelectionType = "<%= searchSelectionType %>";
   urlparm.targetView = "<%= targetView %>";
   urlparm.targetXML = "<%= targetXML %>";
   urlparm.srCategoryName = "<%= UIUtil.toJavaScript(srCategoryName) %>";
   urlparm.srCategoryShort = "<%= UIUtil.toJavaScript(srCategoryShort) %>";
   urlparm.srCategoryNameType = "<%= srCategoryNameType %>";
   urlparm.srCategoryShortType = "<%= srCategoryShortType %>";
   urlparm.srItemSku = "<%= UIUtil.toJavaScript(srItemSku) %>";
   urlparm.srItemName = "<%= UIUtil.toJavaScript(srItemName) %>";
   urlparm.srItemShort = "<%= UIUtil.toJavaScript(srItemShort) %>";
   urlparm.srItemSkuType = "<%= srItemSkuType %>";
   urlparm.srItemNameType = "<%= srItemNameType %>";
   urlparm.srItemShortType = "<%= srItemShortType %>";
   top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindItemPrompt")) %>", "/webapp/wcs/tools/servlet/PriceListProductFindDialogView", false, urlparm);
}

function savePanelData () {
   if (runSavePanelData) {
      var recordFound = false;
      var recordIndex = 0;
      // loop through each textboxes to check for validation
      for (var i=0; i<tempModel.length; i++) {
         checkObj = document.all("check" + tempModel[i].productId);
         textObj = document.all("price" + tempModel[i].productId);
         if ((checkObj != null) && (textObj != null)) {
            for (var j=0; j<scptc.length; j++) {
               if (tempModel[i].productId == scptc[j].productId) {
                  scptc[j].checkValue = checkObj.checked;
                  scptc[j].productPrice = textObj.value;
                  recordFound = true;
                  break;
               }
            }
            if (!recordFound) {
               recordIndex = scptc.length;
               scptc[recordIndex] = new Object();
               scptc[recordIndex].productId = tempModel[i].productId;
               scptc[recordIndex].productMember = tempModel[i].productMember;
               scptc[recordIndex].productIdentifier = tempModel[i].productIdentifier;
               scptc[recordIndex].productName = tempModel[i].productName;
               scptc[recordIndex].productShortDescription = tempModel[i].productShortDescription;
               scptc[recordIndex].productType = tempModel[i].productType;
               scptc[recordIndex].productChildSku = tempModel[i].productChildSku;
               scptc[recordIndex].productPublished = tempModel[i].productPublished;
               scptc[recordIndex].productQuantityUnit = tempModel[i].productQuantityUnit;
               scptc[recordIndex].checkValue = checkObj.checked;
               scptc[recordIndex].productPrice = textObj.value;
            }
            else {
               recordFound = false;
            }
         }
      }
      top.saveData(scptc, "scratchCustomPriceTC");
   }
}

function priceOnChange (checkIndex) {
   // automatically turn on/off checkbox depends on the price
   var obj = document.all("price" + checkIndex);
   if (obj != null) {
      if (trim(obj.value) != "") {
         // check if the price is in correct format
         if (parent.parent.isValidCurrency(obj.value, ccdm.storeDefaultCurr, "<%= fLanguageId %>")) {
            document.all("check" + checkIndex).checked = true;
         }
         else {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingCustomInvalidPrice")) %>");
            obj.value = "";
            document.all("check" + checkIndex).checked = false;
         }
      }
      else {
         document.all("check" + checkIndex).checked = false;
      }
      parent.setChecked();
   }
}

function getRowsCount () {
   return <%= numberOfResults %>;
}

function onLoad () {
   //alert('total <%= numberOfResults %> start <%= startIndex %> end <%= endIndex %> listsize <%= listSize %> page <%= totalpage %>');
   parent.loadFrames();

   // load textbox values for price
   loadPriceValue();
}
//this function will insert the chosen strings into the text to be displayed
function finderChangeSpecialText (rawDisplayText, textOne, textTwo) {
   var displayText = rawDisplayText.replace(/%1/, textOne);
   if (textTwo != null)
      displayText = displayText.replace(/%2/, textTwo);
   return displayText;
}
//-->

</script>
</head>

<body onLoad="onLoad();" onUnload="savePanelData();" class="content_list">

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
loadPanelData();
//-->

</script>

<%= comm.addControlPanel("contract.ContractPricingCustomResultsTable", totalpage, totalsize, fLocale) %>

<form name="productSearchForm" id="productSearchForm">

<%= comm.startDlistTable((String)contractsRB.get("contractProductSearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>

<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductSKUHeading"), ProductSearchListDataBean.ORDER_BY_PRODUCT_CODE, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_PRODUCT_CODE)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductNameHeading"), ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductShortHeading"), ProductSearchListDataBean.ORDER_BY_SHORTDESCRIPTION, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_SHORTDESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductSearchResultsProductType"), null, false) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductSearchResultsSKUs"), null, false) %>

<%
   String defaultCurrency = "";
   try {
      CurrencyManager cm = CurrencyManager.getInstance();
      defaultCurrency = cm.getDefaultCurrency(contractCommandContext.getStore(), contractCommandContext.getLanguageId());
   }
   catch (Exception e) {
   }
%>

<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductPriceHeading") + " (" + defaultCurrency + ")", null, false) %>

<%= comm.endDlistRow() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var j = 0;
for (var i=0; i<tempModel.length; i++) {
   if (j == 0) {
      document.writeln('<tr CLASS="list_row1">');
      j = 1;
   }
   else {
      document.writeln('<tr CLASS="list_row2">');
      j = 0;
   }

   var myName = "check" + tempModel[i].productId;
   addDlistCheck(myName);
   addDlistColumn(tempModel[i].productIdentifier, "none");
   addDlistColumn(tempModel[i].productName, "none");
   addDlistColumn(tempModel[i].productShortDescription, "none");
   addDlistColumn(tempModel[i].productType, "none");
   if (tempModel[i].productChildSku == '0')
      addDlistColumn("", "none");
   else
      addDlistColumn(tempModel[i].productChildSku, "none");

   document.writeln('<td id="ContractPricingCustomersResultsTable_TableCell_'
                  + i
                  + '" CLASS="list_info1"><input id="ContractPricingCustomersResultsTable_FormInput_price'
                  + tempModel[i].productId
                  + '_In_productSearchForm" type="text" name="price'
                  + tempModel[i].productId
                  + '" size="10" maxlength="15" onChange="priceOnChange('
                  + tempModel[i].productId
                  + ');"></td>');
   document.writeln('</tr>');
}
//-->

</script>

<%= comm.endDlistTable() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
if (getRowsCount() == 0) {
   document.writeln('<br>');
   document.writeln('<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchEmpty")) %>');
}
//-->

</script>

</form>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getRowsCount());
//-->

</script>

<%
   }
   catch (Exception e) {
      // exception caught, do nothing
   }
%>

</body>

</html>
