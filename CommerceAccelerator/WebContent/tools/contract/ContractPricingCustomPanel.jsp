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
   import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
   String pricelistId = null;
   TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
   if (requestProperties != null) {
      pricelistId = (String)requestProperties.getString("pricelistId");
   }
   if (pricelistId == null) {
      pricelistId = "-1";
   }
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<style type='text/css'>
.selectWidth {width: 200px;}

</style>

<title><%= contractsRB.get("contractPricingCustomPanelTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CustomPricing.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var scptc = top.getData("scratchCustomPriceTC", 1);

var ccdm = top.getData("ccdm", 1);
var supportedCurrencies, defaultCurrency;
if (ccdm != null) {
   supportedCurrencies = ccdm.storeCurrArray;
   defaultCurrency = ccdm.storeDefaultCurr;
}

function loadPanelData () {
   with (document.ContractCustomPriceListForm) {
      if (parent.setContentFrameLoaded) {
         parent.setContentFrameLoaded(true);
      }

      if (supportedCurrencies != null) {
         for (var i=0; i<supportedCurrencies.length; i++) {
            if (supportedCurrencies[i] == defaultCurrency) {
               customPricingCurrency.options[i] = new Option(supportedCurrencies[i], supportedCurrencies[i], true, true);
            }
            else {
               customPricingCurrency.options[i] = new Option(supportedCurrencies[i], supportedCurrencies[i], false, false);
            }
         }
      }

      if (scptc != null) {
         for (var i=0; i<scptc.productPriceInfo.length; i++) {
            customPricingAllEntry.options[customPricingAllEntry.length] = new Option(parent.numberToCurrency(scptc.productPriceInfo[i].productPrice, scptc.productPriceInfo[i].productPriceCurrency, "<%= fLanguageId %>") + "  " + scptc.productPriceInfo[i].productPriceCurrency, scptc.productPriceInfo[i].productPrice + "#" + scptc.productPriceInfo[i].productPriceCurrency, false, false);
         }
      }
   }
}

function changeAction () {
   var obj = document.ContractCustomPriceListForm.customPricingAllEntry;
   var targetPrice = "", targetCurrency = "";
   var divIndex = -1;

   if (defaultCurrencyCheck()) {
      scptc.productPriceInfo = new Array();

      for (var i=0; i<obj.length; i++) {
         divIndex = obj.options[i].value.indexOf("#");
         targetPrice = obj.options[i].value.substring(0, divIndex);
         targetCurrency = obj.options[i].value.substring(divIndex+1, obj.options[i].value.length);
         if (targetCurrency == defaultCurrency) {
            scptc.productPriceInfo[scptc.productPriceInfo.length] = new CustomProductPrice(targetPrice, targetCurrency, true);
         }
         else {
            scptc.productPriceInfo[scptc.productPriceInfo.length] = new CustomProductPrice(targetPrice, targetCurrency, false);
         }
      }

      top.sendBackData(scptc, "ContractCustomPricingUpdatePriceTC");
      top.sendBackData(getPriceListId(), "ContractCustomPricingUpdatePriceTCindex");
      top.goBack();
   }
   else {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingCustomNoDefaultCurrency")) %>");
   }
}

function cancelAction () {
   // take the user back to the previous entry in the model...
   top.goBack();
}

function selectionAdd () {
   var targetPrice = "", targetCurrency = "";
   var currentCheckValue = "";
   var duplicateCheck = false;

   with (document.ContractCustomPriceListForm) {
      targetPrice = trim(customPricingPrice.value);

      for (var i=0; i<customPricingCurrency.length; i++) {
         if (customPricingCurrency.options[i].selected) {
            targetCurrency = customPricingCurrency.options[i].value;
            break;
         }
      }

      // validate price amount
      if (!parent.isValidCurrency(targetPrice, targetCurrency, "<%= fLanguageId %>")) {
         alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingCustomInvalidPrice")) %>");
         return false;
      }
      else {
         targetPrice = parent.currencyToNumber(targetPrice, targetCurrency, "<%= fLanguageId %>");
         for (var i=0; i<customPricingAllEntry.length; i++) {
            currentCheckValue = customPricingAllEntry.options[i].value.substring(customPricingAllEntry.options[i].value.indexOf("#")+1, customPricingAllEntry.options[i].value.length);
            if (currentCheckValue == targetCurrency) {
               //if (confirmDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingCustomAddItemAlreadyExists")) %>")) {
                  customPricingAllEntry.options[i].value = targetPrice + "#" + targetCurrency;
                  customPricingAllEntry.options[i].text = parent.numberToCurrency(targetPrice, targetCurrency, "<%= fLanguageId %>") + "  " + targetCurrency;
               //}
               duplicateCheck = true;
               break;
            }
         }

         if (!duplicateCheck) {
            customPricingAllEntry.options[customPricingAllEntry.length] = new Option(parent.numberToCurrency(targetPrice, targetCurrency, "<%= fLanguageId %>") + "  " + targetCurrency, targetPrice + "#" + targetCurrency, false, false);
         }
      }
   }
}

function selectionRemove () {
   var obj = document.ContractCustomPriceListForm.customPricingAllEntry;
   var selectNone = true;

   for (var i=obj.length-1; i>=0; i--) {
      if (obj.options[i].selected) {
         obj.options[i] = null;
         selectNone = false;
      }
   }

   if (selectNone) {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingCustomSelectEntryToRemove")) %>");
   }
}

function defaultCurrencyCheck () {
   var obj = document.ContractCustomPriceListForm.customPricingAllEntry;

   for (var i=0; i<obj.length; i++) {
      if (obj.options[i].value.indexOf(defaultCurrency) > -1) {
         return true;
      }
   }

   return false;
}

function getPriceListId () {
   return "<%= pricelistId %>";
}
//-->

</script>
</head>

<body onLoad="loadPanelData();" class="content">

<form name="ContractCustomPriceListForm" id="ContractCustomPriceListForm">

<h1><%= contractsRB.get("contractPricingCustomPanelPrompt") %></h1>

<p><%= contractsRB.get("contractPricingCustomItemPrompt") %>
<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
document.writeln(" <i>" + scptc.productName + "</i>");
//-->

</script>

<p><%= contractsRB.get("contractPricingCustomDefaultCurrencyPrompt") %>
<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
document.writeln(" <i>" + defaultCurrency + "</i>");
//-->

</script>

<p><label for="ContractPricingCustomPanel_FormInput_customPricingPrice_In_ContractCustomPriceListForm_1"><label for="ContractPricingCustomPanel_FormInput_customPricingCurrency_In_ContractCustomPriceListForm_1"><%= contractsRB.get("contractPricingCustomPricePrompt") %></label></label><br>
<input type="text" name="customPricingPrice" size="12" maxlength="12" id="ContractPricingCustomPanel_FormInput_customPricingPrice_In_ContractCustomPriceListForm_1">
<select id="ContractPricingCustomPanel_FormInput_customPricingCurrency_In_ContractCustomPriceListForm_1" name="customPricingCurrency">
</select>
&nbsp;
<button type="button" name="customPricingAddButton" value="customPricingAddButton" style="width:80px" class="enabled" onClick="selectionAdd();"><%= contractsRB.get("addnoelipsis") %></button>

<p>
<table border="0" cellpadding="0" cellspacing="0" id="ContractPricingCustomPanel_Table_1">
   <tr>
      <td id="ContractPricingCustomPanel_TableCell_1">
         <label for="ContractPricingCustomPanel_FormInput_customPricingAllEntry_In_ContractCustomPriceListForm_1"><%= contractsRB.get("contractPricingCustomPriceListText") %></label>
      </td>
   </tr>
   <tr>
      <td id="ContractPricingCustomPanel_TableCell_2">
         <select id="ContractPricingCustomPanel_FormInput_customPricingAllEntry_In_ContractCustomPriceListForm_1" name="customPricingAllEntry" size="10" tabindex="1" class="selectWidth" multiple>
         </select>
      </td>
      <td valign="top" id="ContractPricingCustomPanel_TableCell_3">
         &nbsp;<button type="button" name="customPricingRemoveButton" value="customPricingRemoveButton" style="width:80px" class="enabled" onClick="selectionRemove();"><%= contractsRB.get("remove") %></button>
      </td>
   </tr>
</table>

</form>

</body>

</html>
