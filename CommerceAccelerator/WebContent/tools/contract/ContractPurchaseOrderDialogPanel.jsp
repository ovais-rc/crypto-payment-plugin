<!--==========================================================================
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
<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
         com.ibm.commerce.beans.DataBeanManager" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>
<%@page import="com.ibm.commerce.common.objects.*,
   com.ibm.commerce.price.utils.*" %>

<%
   // Create an instance of the databean to use if we are doing an update
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(contractCommandContext.getLocale()) %>" type="text/css">
<title><%= contractsRB.get("contractPurchaseOrderTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<!--SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Payment.js"></SCRIPT-->

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
   var storeCurrs = new Array();
<%
   StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
   // get the supported currencies for a store
   CurrencyManager cm = CurrencyManager.getInstance();
   String[] supportedCurrencies = cm.getSupportedCurrencies(storeAB);
   String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());

   // supported and default currencies for store
   for (int i=0; i<supportedCurrencies.length; i++) {
%>
   storeCurrs[<%= i %>] = "<%= supportedCurrencies[i] %>";
<%
   }
%>

function loadPanelData ()
{
   with (document.pOForm)
   {
      if (parent.setContentFrameLoaded)
      {
         parent.setContentFrameLoaded(true);
      }

      if (parent.get)
    {
         loadDiscCurr();
    }

    var changeRow=top.getData("changeRow",1);
    if (changeRow!=null)
    {
      //reset values to form
      PONumber.value = changeRow.po;

      var limit=changeRow.limit;
      if (limit != "-1")
      {
        //limited PO
        hasSpendLimit.checked = true;
        //Amount.value=parent.numberToCurrency(limit,changeRow.currency,"<%=fLanguageId%>");
        Amount.value=limit;
        for (var i=0; i < Currency.options.length; i++)
        {
          if (Currency.options[i].value==changeRow.currency)
          {
            Currency.options[i].selected=true;
            break;
          }
        }

        //if change a limited PO, disable currency selection
        //if change a PO, user cannot switch over from one PO TC type to another one
        if (defined(changeRow.referenceNumber))
        {
          Currency.disabled=true;
          hasSpendLimit.disabled=true;
        }
      }
      else
      {
        //blanket PO
        hasSpendLimit.checked = false;
        if (defined(changeRow.referenceNumber))
        {
          hasSpendLimit.disabled=true;
        }

      }
      showDivisions();
    }
   }
}

function showDivisions()
{
  with (document.pOForm)
  {
    var ifhasSpendLimit = hasSpendLimit.checked;
    if (ifhasSpendLimit == true)
    {
      AmountDiv.style.display = "block";
    }
    else
    {
      AmountDiv.style.display = "none";
    }
  }
}


function loadDiscCurr()
{
  if (storeCurrs !=null)
  {
    for(var i=0; i<storeCurrs.length; i++)
    {
       document.pOForm.Currency.options[i] = new Option(storeCurrs[i], storeCurrs[i], false, false);
    }
  }
}


function savePanelData () {
   with (document.pOForm) {
      if (parent.get) {
         var o = parent.get("ContractPurchaseOrderModel", null);
         if (o != null)
         {

         }
      }
   }
}


function validatePanelData()
{
  var displayName = document.pOForm.PONumber.value;

  //validate PONumber

  if (displayName=="" || displayName == null)
  {
    alertDialog("<%=  UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogFormInvalidPONumber"))%>");
    document.pOForm.PONumber.focus();
    return false;
  }

  if (!isValidUTF8length(displayName, 254))
  {
    alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogFormDisplayNameTooLong"))%>");
    selectionBody.document.paymentForm.PaymentName.focus();
    return false;
  }


  if (checkUniqueness(displayName))
  {
    alertDialog("<%=  UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogFormDuplicatePONumber"))%>");
    document.pOForm.PONumber.focus();
    return false;
  }

  //Validate Currency
  var amount = document.pOForm.Amount.value;
  var hasLimit = document.pOForm.hasSpendLimit.checked;
  //if ((hasLimit) && (amount != ""))
  if (hasLimit)
  {
    if ( !parent.isValidCurrency(document.pOForm.Amount.value, document.pOForm.Currency.options[document.pOForm.Currency.selectedIndex].value, "<%=fLanguageId%>"))
    {
      alertDialog("<%=  UIUtil.toJavaScript((String)contractsRB.get("contractOrderApprovalSpecifyCurrencyValue"))%>");
      document.pOForm.Amount.focus();
      return false;
    }
    var realAmount=parent.currencyToNumber(amount, document.pOForm.Currency.options[document.pOForm.Currency.selectedIndex].value, "<%=fLanguageId%>");
    if (realAmount==0)
    {
      alertDialog("<%=  UIUtil.toJavaScript((String)contractsRB.get("contractOrderApprovalSpecifyCurrencyValue"))%>");
      document.pOForm.Amount.focus();
      return false;
    }
  }


  return true;
}


function checkUniqueness(name)
{
  var changeRow=top.getData("changeRow",1);

  //it a update
  if (changeRow!=null)
  {
    // display name has not been changed.
    if (name == changeRow.po)
    {
      return false;
    }
  }

  // otherwise it is a new entry or display name has changed, so check uniqueness

  var cpm=top.getModel(1);

  //alertDialog(convertToXML(cpm.ContractPurchaseOrderModel));
  if (cpm==null)
  {
    alertDialog ("model is null");
  }

  var purchaseOrderList = cpm.ContractPurchaseOrderModel.purchaseOrder;


  for (var i=0; i<purchaseOrderList.length; i++)
  {
    if (name==purchaseOrderList[i].po && purchaseOrderList[i].action!="delete")
    {
      return true;
    }
  }

  return false;
}


function savePurchaseOrderForm () {
   // save data to notebook javascript model

   // go back to contract payment panel
   //sendBackData
   if (validatePanelData())
   {
     newPurchaseOrderTC = new Object();
    newPurchaseOrderTC.po = document.pOForm.PONumber.value

    newPurchaseOrderTC.action="new";

    var changeRow=top.getData("changeRow",1);

    //it is an update
    if ((changeRow!=null) && ((changeRow.action=="noaction") || (changeRow.action=="update")))
    {
      newPurchaseOrderTC.action="update";
      if (changeRow.referenceNumber!=null && changeRow.referenceNumber!="")
      {
        newPurchaseOrderTC.referenceNumber=changeRow.referenceNumber;
      }
    }

    var amount = document.pOForm.Amount.value;
    var hasLimit = document.pOForm.hasSpendLimit.checked;
    if ((hasLimit) && (amount != ""))
    {
      // POTCLimited
      var newAmount=parent.currencyToNumber(amount, document.pOForm.Currency.options[document.pOForm.Currency.selectedIndex].value, "<%=fLanguageId%>");
      amount = parent.numberToCurrency(newAmount, document.pOForm.Currency.options[document.pOForm.Currency.selectedIndex].value, "<%=fLanguageId%>");
      newPurchaseOrderTC.limit=amount;
      newPurchaseOrderTC.currency=document.pOForm.Currency.options[document.pOForm.Currency.selectedIndex].value;
    }
    else
    {
      //POTCBlanket
      newPurchaseOrderTC.limit="-1";
    }
    //alertDialog(convertToXML(newPurchaseOrderTC));
     top.sendBackData(newPurchaseOrderTC, "newPurchaseOrderTC");
     top.goBack();
   }
}

function cancelPurchaseOrderForm () {
   // go back to contract payment panel

   top.goBack();
}
//-->

</script>
</head>

<body ONLOAD="loadPanelData()" class="content">
<h1>
<script LANGUAGE="JavaScript">
var cR=top.getData("changeRow",1);
if (cR!=null)
  document.write('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogChangeTitle")) %>');
else
  document.write('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPurchaseOrderDialogAddTitle")) %>');

</script>
</h1>

<form NAME="pOForm" id="pOForm">

<table BORDER=0 id="ContractPurchaseOrderDialogPanel_Table_1">

   <tr>
      <td id="ContractPurchaseOrderDialogPanel_TableCell_1"><label for="ContractPurchaseOrderDialogPanel_FormInput_PONumber_In_pOForm_1"><%= contractsRB.get("contractPurchaseOrderNumberPrompt") %></label></td>
   </tr>
   <tr>
      <td id="ContractPurchaseOrderDialogPanel_TableCell_2">
         <input NAME="PONumber" TYPE="TEXT" SIZE=20 maxlength=254 id="ContractPurchaseOrderDialogPanel_FormInput_PONumber_In_pOForm_1">
      </td>
   </tr>
</table>
<table id="ContractPurchaseOrderDialogPanel_Table_2">
   <tr>
      <td id="ContractPurchaseOrderDialogPanel_TableCell_3">
         <table BORDER=0 id="ContractPurchaseOrderDialogPanel_Table_3">
            <tr>
               <td WIDTH=20 id="ContractPurchaseOrderDialogPanel_TableCell_4"><input NAME="hasSpendLimit" TYPE="CHECKBOX" value="true" ONCLICK="showDivisions()" id="ContractPurchaseOrderDialogPanel_FormInput_hasSpendLimit_In_pOForm_1"></td>
               <td id="ContractPurchaseOrderDialogPanel_TableCell_5"><label for="ContractPurchaseOrderDialogPanel_FormInput_hasSpendLimit_In_pOForm_1"><%= contractsRB.get("contractPurchaseOrderHasSpendLimitPrompt") %></label></td>
            </tr>
            <tr>
               <td WIDTH=20 id="ContractPurchaseOrderDialogPanel_TableCell_6">&nbsp;</td>
               <td id="ContractPurchaseOrderDialogPanel_TableCell_7">
                  <div id="AmountDiv" style="display: none">
                    <label for="ContractPurchaseOrderDialogPanel_FormInput_Amount_In_pOForm_1"><label for="ContractPurchaseOrderDialogPanel_FormInput_Currency_In_pOForm_1"><%= contractsRB.get("contractPurchaseOrderDialogFormAmountTitle") %></label></label><br>
                     <input NAME="Amount" TYPE="TEXT" size=15 maxlength=30 id="ContractPurchaseOrderDialogPanel_FormInput_Amount_In_pOForm_1">&nbsp;&nbsp;<select id="ContractPurchaseOrderDialogPanel_FormInput_Currency_In_pOForm_1" NAME="Currency"></select>
                  </div>
               </td>
            </tr>
         </table>
      </td>
   </tr>

</table>

</form>

<script LANGUAGE="JavaScript">
  document.pOForm.PONumber.focus();

</script>

</body>
</html>
