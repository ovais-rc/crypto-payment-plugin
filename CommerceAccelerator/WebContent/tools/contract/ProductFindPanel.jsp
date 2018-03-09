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
   import="com.ibm.commerce.tools.contract.beans.ProductSearchListDataBean,
   com.ibm.commerce.tools.util.ResourceDirectory,
   com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.datatype.TypedProperty,
   java.util.Hashtable" %>

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
   }

   if (srCategoryNameType.equals("")) srCategoryNameType = ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE;
   if (srCategoryShortType.equals("")) srCategoryShortType = ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE;
   if (srItemSkuType.equals("")) srItemSkuType = ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE;
   if (srItemNameType.equals("")) srItemNameType = ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE;
   if (srItemShortType.equals("")) srItemShortType = ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE;
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractProductFindPanelTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var contractId = "<%= _contractId %>";
var catalogId = "<%= catalogId %>";
var categoryId = "<%= categoryId %>";
var categoryDisplayText = "<%= UIUtil.toJavaScript((String)categoryDisplayText) %>";
var searchActionType = "<%= searchActionType %>";
var searchSelectionType = "<%= searchSelectionType %>";
var targetView = "<%= targetView %>";
var targetXML = "<%= targetXML %>";

function finderChangeSpecialText (rawDisplayText, textOne, textTwo, textThree, textFour) {
   var displayText = rawDisplayText.replace(/%1/, textOne);
   if (textTwo != null)
      displayText = displayText.replace(/%2/, textTwo);
   if (textThree != null)
      displayText = displayText.replace(/%3/, textThree);
   if (textFour != null)
      displayText = displayText.replace(/%4/, textFour);
   return displayText;
}

function loadSelectValue (obj, field) {
   for (var i=0; i<obj.length; i++) {
      if (obj.options[i].value == field) {
         obj.options[i].selected = true;
         break;
      }
   }
   return true;
}

function loadPanelData () {

   // prefill the find input box if the user entered
   // something on the previous screen.
   with (document.productSearchForm) {
      srCategoryName.value = "<%= UIUtil.toJavaScript(srCategoryName) %>";
      srCategoryShort.value = "<%= UIUtil.toJavaScript(srCategoryShort) %>";
      loadSelectValue(srCategoryNameType, "<%= srCategoryNameType %>");
      loadSelectValue(srCategoryShortType, "<%= srCategoryShortType %>");
      srItemSku.value = "<%= UIUtil.toJavaScript(srItemSku) %>";
      srItemName.value = "<%= UIUtil.toJavaScript(srItemName) %>";
      srItemShort.value = "<%= UIUtil.toJavaScript(srItemShort) %>";
      loadSelectValue(srItemSkuType, "<%= srItemSkuType %>");
      loadSelectValue(srItemNameType, "<%= srItemNameType %>");
      loadSelectValue(srItemShortType, "<%= srItemShortType %>");
   }

   findSelectionLoad();
   showDivision();

   // show the right help page
   if (searchActionType == "CE") {
           parent.pageArray["productFindPanel"].helpKey="MC.contract.ProductFindOnlyDialog.Help";
   }

   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}

function hasInvalidChars (inputString) {
   var i = 0;
   for (i=0; i<inputString.length; i++) {
      var c = inputString.charAt(i);
      switch (c) {
         case "#":
            return c;
      }
   }
   return null;
}

function findProducts () {
   var findValidationMsg = "";
   var searchSelectionTypeValue = "";
   var urltitle = "";

   with (document.productSearchForm) {
      if (searchSelectionType[0].checked) {
         searchSelectionTypeValue = searchSelectionType[0].value;
         urltitle = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchCategoryTitle")) %>";
      }
      else if (searchSelectionType[1].checked) {
         searchSelectionTypeValue = searchSelectionType[1].value;
         urltitle = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchItemTitle")) %>";
      }
      else {
         findValidationMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindSearchNotSpecified")) %>";
      }

      // check if illegal character exists in the search criteria
      var invalidChar = "", s1 = "", s2 = "", s3 = "";
      if (searchSelectionType[0].checked) {
         s1 = srCategoryName.value;
         s2 = srCategoryShort.value;
      }
      else if (searchSelectionType[1].checked) {
         s1 = srItemSku.value;
         s2 = srItemName.value;
         s3 = srItemShort.value;
      }
      invalidChar = hasInvalidChars(s1);
      if (invalidChar != null) {
         findValidationMsg = finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidCharacter")) %>", invalidChar);
      }
      invalidChar = hasInvalidChars(s2);
      if (invalidChar != null) {
         findValidationMsg = finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidCharacter")) %>", invalidChar);
      }
      invalidChar = hasInvalidChars(s3);
      if (invalidChar != null) {
         findValidationMsg = finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidCharacter")) %>", invalidChar);
      }

      // use different xml file to display different titles, depends on the selection type
      var ActionXMLFile, cmd;
      if ((targetXML == "contract.PriceListProductSearchResultsDialog") || (targetXML == "contract.PriceListProductSearchResultsCategoryDialog") || (targetXML == "contract.PriceListProductSearchResultsProductDialog")) {
         if (searchSelectionTypeValue == "CG") {
            ActionXMLFile = "contract.PriceListProductSearchResultsCategoryTable";
            cmd = "PriceListProductSearchResultsTableView";
            targetXML = "contract.PriceListProductSearchResultsCategoryDialog";
         }
         else if (searchSelectionTypeValue == "CE") {
            ActionXMLFile = "contract.PriceListProductSearchResultsProductTable";
            cmd = "PriceListProductSearchResultsTableView";
            targetXML = "contract.PriceListProductSearchResultsProductDialog";
         }
      }
      else {
         ActionXMLFile = "contract.ContractPricingCustomResultsTable";
         cmd = "ContractPricingCustomResultsTableView";
      }

      // create the base url
      if (findValidationMsg == "") {
         var url = "/webapp/wcs/tools/servlet/" + targetView;
         var urlparm = new Object();
         urlparm.ActionXMLFile = ActionXMLFile;
         urlparm.cmd = cmd;
         urlparm.XMLFile = targetXML;
         urlparm.contractId = contractId;
         urlparm.catalogId = catalogId;
         urlparm.categoryId = categoryId;
         urlparm.categoryDisplayText = categoryDisplayText;
         urlparm.searchActionType = searchActionType;
         urlparm.searchSelectionType = searchSelectionTypeValue;
         urlparm.targetView = targetView;
         urlparm.targetXML = targetXML;
         urlparm.srCategoryName = srCategoryName.value;
         urlparm.srCategoryShort = srCategoryShort.value;
         urlparm.srCategoryNameType = srCategoryNameType.options[srCategoryNameType.selectedIndex].value;
         urlparm.srCategoryShortType = srCategoryShortType.options[srCategoryShortType.selectedIndex].value;
         urlparm.srItemSku = srItemSku.value;
         urlparm.srItemName = srItemName.value;
         urlparm.srItemShort = srItemShort.value;
         urlparm.srItemSkuType = srItemSkuType.options[srItemSkuType.selectedIndex].value;
         urlparm.srItemNameType = srItemNameType.options[srItemNameType.selectedIndex].value;
         urlparm.srItemShortType = srItemShortType.options[srItemShortType.selectedIndex].value;
         top.setContent(urltitle, url, false, urlparm);
      }
      else {
         alertDialog(findValidationMsg);
      }
   }
}

function goBackToRefererURL () {
   // take the user back to the previous entry in the model...
   top.goBack();
}

function findSelectionLoad () {
   for (var i=0; i<document.productSearchForm.searchSelectionType.length; i++) {
      if (document.productSearchForm.searchSelectionType[i].value == searchSelectionType) {
         document.productSearchForm.searchSelectionType[i].checked = true;
      }
      else {
         document.productSearchForm.searchSelectionType[i].checked = false;
      }
   }
}

function showDivision () {
   if (searchActionType == "CG") {
      categoryFieldDiv.style.display = "";
   }
   else if (searchActionType == "CE") {
      itemFieldDiv.style.display = "";
   }
   else {
      categorySelectionDiv.style.display = "";
      itemSelectionDiv.style.display = "";
      findSelectionChange();
   }
}

function findSelectionChange () {
   if (document.productSearchForm.searchSelectionType[0].checked) {
      itemFieldDiv.style.display = "none";
      categoryFieldDiv.style.display = "";
   }
   else if (document.productSearchForm.searchSelectionType[1].checked) {
      categoryFieldDiv.style.display = "none";
      itemFieldDiv.style.display = "";
   }
}


//-->

</script>
</head>

<body onLoad="loadPanelData();" class="content">

<form name="productSearchForm" id="productSearchForm">

<script language="JavaScript">
<!---- hide script from old browsers
if (searchActionType == "CG") {
   document.writeln('<H1><%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindCategoryPrompt")) %></H1>');
}
else if (searchActionType == "CE") {
   document.writeln('<H1><%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindItemPrompt")) %></H1>');
}
else {
   document.writeln('<H1><%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindPanelTitle")) %></H1>');
}
//-->

</script>

<p><%= contractsRB.get("contractProductFindDescription") %>

<div id="categorySelectionDiv" style="display:none;">
<p>
<input type="radio" name="searchSelectionType" value="CG" onClick="findSelectionChange();" id="ProductFindPanel_FormInput_searchSelectionType_In_productSearchForm_1">
<label for="ProductFindPanel_FormInput_searchSelectionType_In_productSearchForm_1"><%= (String)contractsRB.get("contractProductFindCategoryRadioLabel") %></label>

</script>
</div>

<div id="categoryFieldDiv" style="display:none;">
<table border=0 cellpadding=0 cellspacing=0 id="ProductFindPanel_Table_1">
   <tr>
      <td width="50" align="left" nowrap id="ProductFindPanel_TableCell_1">&nbsp;</td>
      <td width="210" align="left" id="ProductFindPanel_TableCell_2">&nbsp;</td>
   </tr>
   <tr valign="bottom">
      <td id="ProductFindPanel_TableCell_3"></td>
      <td width="210" align="left" nowrap id="ProductFindPanel_TableCell_4">
         <label for="ProductFindPanel_FormInput_srCategoryName_In_productSearchForm_1"><label for="ProductFindPanel_FormInput_srCategoryNameType_In_productSearchForm_1"><%= contractsRB.get("contractProductFindName") %></label></label><br>
         <input type=text name=srCategoryName size=20 maxlength=64 id="ProductFindPanel_FormInput_srCategoryName_In_productSearchForm_1">
      </td>
      <td id="ProductFindPanel_TableCell_5">
         <select id="ProductFindPanel_FormInput_srCategoryNameType_In_productSearchForm_1" NAME="srCategoryNameType">
            <option VALUE="<%= ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindMatchesContaining") %></option>
            <option VALUE="<%= ProductSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindExactPhrase") %></option>
         </select>
      </td>
   </tr>
   <tr>
      <td colspan=3 id="ProductFindPanel_TableCell_6">&nbsp;</td>
   </tr>
   <tr valign="bottom">
      <td id="ProductFindPanel_TableCell_7"></td>
      <td width="210" align="left" nowrap id="ProductFindPanel_TableCell_8">
         <label for="ProductFindPanel_FormInput_srCategoryShort_In_productSearchForm_1"><label for="ProductFindPanel_FormInput_srCategoryShortType_In_productSearchForm_1"><%= contractsRB.get("contractProductFindShortDesc") %></label></label><br>
         <input type=text name=srCategoryShort size=20 maxlength=64 id="ProductFindPanel_FormInput_srCategoryShort_In_productSearchForm_1">
      </td>
      <td id="ProductFindPanel_TableCell_9">
         <select id="ProductFindPanel_FormInput_srCategoryShortType_In_productSearchForm_1" NAME="srCategoryShortType">
            <option VALUE="<%= ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindMatchesContaining") %></option>
            <option VALUE="<%= ProductSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindExactPhrase") %></option>
         </select>
      </td>
   </tr>
</table>
</div>

<div id="itemSelectionDiv" style="display:none;">
<p>
<input type="radio" name="searchSelectionType" value="CE" onClick="findSelectionChange();" id="ProductFindPanel_FormInput_searchSelectionType_In_productSearchForm_2">
<label for="ProductFindPanel_FormInput_searchSelectionType_In_productSearchForm_2"><%= (String)contractsRB.get("contractProductFindItemRadioLabel") %></label>

</script>
</div>

<div id="itemFieldDiv" style="display:none;">
<table border=0 cellpadding=0 cellspacing=0 id="ProductFindPanel_Table_2">
   <tr>
      <td width="50" align="left" nowrap id="ProductFindPanel_TableCell_10">&nbsp;</td>
      <td width="210" align="left" id="ProductFindPanel_TableCell_11">&nbsp;</td>
   </tr>
   <tr valign="bottom">
      <td id="ProductFindPanel_TableCell_12"></td>
      <td width="210" align="left" nowrap id="ProductFindPanel_TableCell_13">
         <label for="ProductFindPanel_FormInput_srItemSku_In_productSearchForm_1"><label for="ProductFindPanel_FormInput_srItemSkuType_In_productSearchForm_1"><%= contractsRB.get("contractProductFindSkuSearchString") %></label></label><br>
         <input type=text name=srItemSku size=20 maxlength=64 id="ProductFindPanel_FormInput_srItemSku_In_productSearchForm_1">
      </td>
      <td id="ProductFindPanel_TableCell_14">
         <select id="ProductFindPanel_FormInput_srItemSkuType_In_productSearchForm_1" NAME="srItemSkuType">
            <option VALUE="<%= ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindMatchesContaining") %></option>
            <option VALUE="<%= ProductSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindExactPhrase") %></option>
         </select>
      </td>
   </tr>
   <tr>
      <td colspan=3 id="ProductFindPanel_TableCell_15">&nbsp;</td>
   </tr>
   <tr valign="bottom">
      <td id="ProductFindPanel_TableCell_16"></td>
      <td width="210" align="left" nowrap id="ProductFindPanel_TableCell_17">
         <label for="ProductFindPanel_FormInput_srItemName_In_productSearchForm_1"><label for="ProductFindPanel_FormInput_srItemNameType_In_productSearchForm_1"><%= contractsRB.get("contractProductFindName") %></label></label><br>
         <input type=text name=srItemName size=20 maxlength=64 id="ProductFindPanel_FormInput_srItemName_In_productSearchForm_1">
      </td>
      <td id="ProductFindPanel_TableCell_18">
         <select id="ProductFindPanel_FormInput_srItemNameType_In_productSearchForm_1" NAME="srItemNameType">
            <option VALUE="<%= ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindMatchesContaining") %></option>
            <option VALUE="<%= ProductSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindExactPhrase") %></option>
         </select>
      </td>
   </tr>
   <tr>
      <td colspan=3 id="ProductFindPanel_TableCell_19">&nbsp;</td>
   </tr>
   <tr valign="bottom">
      <td id="ProductFindPanel_TableCell_20"></td>
      <td width="210" align="left" nowrap id="ProductFindPanel_TableCell_21">
         <label for="ProductFindPanel_FormInput_srItemShort_In_productSearchForm_1"><label for="ProductFindPanel_FormInput_srItemShortType_In_productSearchForm_1"><%= contractsRB.get("contractProductFindShortDesc") %></label></label><br>
         <input type=text name=srItemShort size=20 maxlength=64 id="ProductFindPanel_FormInput_srItemShort_In_productSearchForm_1">
      </td>
      <td id="ProductFindPanel_TableCell_22">
         <select id="ProductFindPanel_FormInput_srItemShortType_In_productSearchForm_1" NAME="srItemShortType">
            <option VALUE="<%= ProductSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindMatchesContaining") %></option>
            <option VALUE="<%= ProductSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= contractsRB.get("contractProductFindExactPhrase") %></option>
         </select>
      </td>
   </tr>
</table>
</div>

</form>

</body>

</html>
