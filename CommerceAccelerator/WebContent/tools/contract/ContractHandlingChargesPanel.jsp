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
<%@ page language="java"
  import="com.ibm.commerce.tools.util.UIUtil,
  com.ibm.commerce.beans.DataBeanManager,
  com.ibm.commerce.tools.contract.beans.HandlingChargeTCDataBean" %>
 
<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractHandlingChargesPanelPrompt") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Handling.js">
</script>

<script language="JavaScript">

function loadPanelData()
{
  with (document.handlingChargesForm) {
    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
    }
    
    if (parent.get) {
      var hereBefore = parent.get("ContractHandlingChargesModelLoaded", null);
      if (hereBefore != null) {
        // have been to this page before - load from the model
        //alert('back to same page - load from model');
        var o = parent.get("ContractHandlingChargesModel", null);
        if (o != null) {
          ContractHandlingCharges_HandlingChargesEnabled.checked = o.handlingChargesEnabled;
          ContractHandlingCharges_HandlingCharge.value = parent.formatNumber(o.handlingAmount, "<%= fLanguageId %>", 2);
          ContractHandlingCharges_FirstReleaseFree.checked = o.firstReleaseFree;
          ContractHandlingCharges_FixedAmount.value = parent.formatNumber(o.handlingChargeFixedAmount, "<%= fLanguageId %>", 2);
          ContractHandlingCharges_Percentage.value = parent.formatNumber(o.handlingChargePercentage, "<%= fLanguageId %>", 2);
          ContractHandlingCharges_PercentageAmount.value = parent.formatNumber(o.handlingChargePercentageAmount, "<%= fLanguageId %>", 2);
          ContractHandlingCharges_ChargeType[0].checked = o.handlingChargeTypeFixed;
          ContractHandlingCharges_ChargeType[1].checked = !o.handlingChargeTypeFixed;
        }
      } else {
        // this is the first time on this page

        <%
	  boolean firstReleaseFree = false;
	  String orderCurrency = "";
          java.math.BigDecimal handlingAmount = new java.math.BigDecimal(0);
          java.math.BigDecimal maximumHandlingAmount = new java.math.BigDecimal(0);
          Double maximumPercentage = new Double(0);
          String referenceNumber = "";

          // check whether it's an update or a new contract
          if (foundContractId || (editingAccount && foundAccountId) ) {
            String tradingId = (foundContractId) ? contractId : accountId;
            HandlingChargeTCDataBean tcData = new HandlingChargeTCDataBean(new Long(tradingId), new Integer(fLanguageId));
            DataBeanManager.activate(tcData, request);

            firstReleaseFree = tcData.getFirstReleaseFree();
            orderCurrency = tcData.getOrderCurrency();
            if (tcData.getHandlingAmount() != null) {
            	handlingAmount = tcData.getHandlingAmount();
            }
            if (tcData.getMaximumHandlingAmount() != null) {
            	maximumHandlingAmount = tcData.getMaximumHandlingAmount();
            }
            if (tcData.getMaximumPercentage() != null) {
            	maximumPercentage = tcData.getMaximumPercentage();
            }
            referenceNumber = tcData.getReferenceNumber();
          }
        %>

        // first time on this page - create the model
        var chcm = new ContractHandlingChargesModel();

        chcm.handlingAmount = "<%= handlingAmount %>";
        chcm.firstReleaseFree = "<%= firstReleaseFree %>";
        chcm.handlingChargePercentage = "<%= maximumPercentage %>";

        // Set order currency to be store defaul currency if empty
        <% if (orderCurrency != null && !orderCurrency.equals("")) { %>
          chcm.orderCurrency = "<%= orderCurrency %>";
        <% } else { %>
          chcm.orderCurrency = storeDefaultCurrency();
        <% } %>
        
        // Set maximum amount according to charge type
        if (chcm.handlingChargePercentage <= 0) {
          ContractHandlingCharges_ChargeType[0].checked = true;
          chcm.handlingChargeFixedAmount = "<%= maximumHandlingAmount %>";
          chcm.handlingChargePercentageAmount = "";
        } else {
          ContractHandlingCharges_ChargeType[1].checked = true;
          chcm.handlingChargeFixedAmount = "";
          chcm.handlingChargePercentageAmount = "<%= maximumHandlingAmount %>";
        }
        
        <% if (referenceNumber != null && !referenceNumber.equals("")) { %>
          chcm.handlingChargesEnabled = true;
          chcm.referenceNumber = <%= referenceNumber %>;
        <% } else { %>
          chcm.handlingChargesEnabled = false;
        <% } %>

        parent.put("ContractHandlingChargesModel", chcm);
        parent.put("ContractHandlingChargesModelLoaded", true);

        ContractHandlingCharges_HandlingChargesEnabled.checked = chcm.handlingChargesEnabled;
        ContractHandlingCharges_HandlingCharge.value = chcm.handlingAmount;
        ContractHandlingCharges_FirstReleaseFree.checked = chcm.firstReleaseFree;
        ContractHandlingCharges_FixedAmount.value = chcm.handlingChargeFixedAmount;
        ContractHandlingCharges_Percentage.value = chcm.handlingChargePercentage;
        ContractHandlingCharges_PercentageAmount.value = chcm.handlingChargePercentageAmount;
      }
    }

    // handle error messages back from the validate page
    if (parent.get("contractHandlingChargesInvalidHandlingAmount", false)) {
      parent.remove("contractHandlingChargesInvalidHandlingAmount");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractHandlingChargesInvalidHandlingAmount"))%>");
    }
    else if (parent.get("contractHandlingChargesInvalidFixedMaxHandlingAmount", false)) {
      parent.remove("contractHandlingChargesInvalidFixedMaxHandlingAmount");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractHandlingChargesInvalidFixedMaxHandlingAmount"))%>");
    }
    else if (parent.get("contractHandlingChargesInvalidPercentageMaxHandlingAmount", false)) {
      parent.remove("contractHandlingChargesInvalidPercentageMaxHandlingAmount");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractHandlingChargesInvalidPercentageMaxHandlingAmount"))%>");
    }
    else if (parent.get("contractHandlingChargesInvalidPercentage", false)) {
      parent.remove("contractHandlingChargesInvalidPercentage");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractHandlingChargesInvalidPercentage"))%>");
     }

    toggleHandlingCharges();
    if (ContractHandlingCharges_ChargeType[0].checked) {
      toggleChargeType(0);
    } else {
      toggleChargeType(1);
    }
  }
}

function storeDefaultCurrency() {
  var ccdm = parent.get("ContractCommonDataModel");
  return ccdm.storeDefaultCurr;
}

function toggleHandlingCharges() {
  if (document.handlingChargesForm.ContractHandlingCharges_HandlingChargesEnabled.checked) {
    document.all["HandlingCharges"].style.display = "block";  
  } else {
    document.all["HandlingCharges"].style.display = "none";  
  }
}

function toggleChargeType(type) {
  with (document.handlingChargesForm) {
    if(type == 0) {
      ContractHandlingCharges_ChargeType[0].checked = true;
      ContractHandlingCharges_ChargeType[1].checked = false;
      ContractHandlingCharges_PercentageAmount.value = "0";
      ContractHandlingCharges_Percentage.value = "0";
    } else {
      ContractHandlingCharges_ChargeType[0].checked = false;
      ContractHandlingCharges_ChargeType[1].checked = true;
      ContractHandlingCharges_FixedAmount.value = "0";
    }
  }
}

function savePanelData()
{
  with (document.handlingChargesForm) {
    if (parent.get) {
      var o = parent.get("ContractHandlingChargesModel", null);
      if (o != null) {
        o.handlingChargesEnabled = ContractHandlingCharges_HandlingChargesEnabled.checked;
        o.handlingAmount = ContractHandlingCharges_HandlingCharge.value;
        o.orderCurrency = storeDefaultCurrency();
        o.firstReleaseFree = ContractHandlingCharges_FirstReleaseFree.checked;
        o.handlingChargeFixedAmount = ContractHandlingCharges_FixedAmount.value;
        o.handlingChargePercentage = ContractHandlingCharges_Percentage.value;
        o.handlingChargePercentageAmount = ContractHandlingCharges_PercentageAmount.value;
        o.handlingChargeTypeFixed = ContractHandlingCharges_ChargeType[0].checked;
      }
    }
  }
}

</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractHandlingChargesPanelPrompt") %></h1>

<form name="handlingChargesForm" id="handlingChargesForm">

<table border=0 id="ContractHandlingCharges_Table_1">
  <tr>
    <td width=20 id="ContractHandlingCharges_TableCell_1"><input name="ContractHandlingCharges_HandlingChargesEnabled" type="checkbox" onClick="toggleHandlingCharges()" id="ContractHandlingCharges_HandlingChargesEnabled"></td>
    <td id="ContractHandlingCharges_TableCell_2"><label for="ContractHandlingCharges_HandlingChargesEnabled"><%= contractsRB.get("contractHandlingCharges") %></label></td>
  </tr>
  <tr>
    <td width=20 id="ContractHandlingCharges_TableCell_3">&nbsp;</td>
    <td id="ContractHandlingCharges_TableCell_4">
    <div id="HandlingCharges" style="display: none">
      <p>
      <%= contractsRB.get("contractHandlingCharge") %>
      <br>
      <label for="ContractHandlingCharges_HandlingCharge"><%= contractsRB.get("contractFixedAmount") %></label>:
      <input name="ContractHandlingCharges_HandlingCharge" id="ContractHandlingCharges_HandlingCharge" type="text" size="5" maxlength="8">
      <script>document.write(storeDefaultCurrency())</script>
      </p>
      <p>
        <input name="ContractHandlingCharges_FirstReleaseFree" type="checkbox" id="ContractHandlingCharges_FirstReleaseFree">
        <label for="ContractHandlingCharges_FirstReleaseFree"><%= contractsRB.get("contractFirstReleaseFree") %></label>
      </p>
      <p>
        <%= contractsRB.get("contractMaximumHandlingCharges") %>
        <br>
        <table BORDER=0 id="ContractHandlingCharges_Table_2">
          <tr>
            <td width=20 id="ContractHandlingCharges_TableCell_4"><input name="ContractHandlingCharges_ChargeType" type="radio" id="ContractHandlingCharges_ChargeType_Fixed" onClick="toggleChargeType(0)"></td>
            <td id="ContractHandlingCharges_TableCell_5"><label for="ContractHandlingCharges_ChargeType_Fixed"><%= contractsRB.get("contractTotalHandlingChargesFixed") %></label></td>
          </tr>
          <tr>
            <td width=20 id="ContractHandlingCharges_TableCell_6">&nbsp;</td>
            <td id="ContractHandlingCharges_TableCell_7">
              <label for="ContractHandlingCharges_FixedAmount"><%= contractsRB.get("contractFixedAmount") %></label>:
                  <input name="ContractHandlingCharges_FixedAmount" id="ContractHandlingCharges_FixedAmount" type="text" size="5" maxlength="8" onClick="toggleChargeType(0)">
                  <script>document.write(storeDefaultCurrency())</script>
                </td>
              </tr>
          <tr>
            <td width=20 id="ContractHandlingCharges_TableCell_8"><input name="ContractHandlingCharges_ChargeType" type="radio" id="ContractHandlingCharges_ChargeType_Percentage" onClick="toggleChargeType(1)"></td>
            <td id="ContractHandlingCharges_TableCell_9"><label for="ContractHandlingCharges_ChargeType_Percentage"><%= contractsRB.get("contractTotalHandlingChargesPercentage") %></label></td>
          </tr>
          <tr>
            <td width=20 id="ContractHandlingCharges_TableCell_10">&nbsp;</td>
            <td id="ContractHandlingCharges_TableCell_11">
                  <label for="ContractHandlingCharges_Percentage"><%= contractsRB.get("contractPercentage") %></label>:
                  <input name="ContractHandlingCharges_Percentage" id="ContractHandlingCharges_Percentage" type="text" size="5" maxlength="8" onClick="toggleChargeType(1)">
                  %
              <br>
                  <label for="ContractHandlingCharges_PercentageAmount"><%= contractsRB.get("contractFixedAmount") %></label>:
                  <input name="ContractHandlingCharges_PercentageAmount" id="ContractHandlingCharges_PercentageAmount" type="text" size="5" maxlength="8" onClick="toggleChargeType(1)">
                  <script>document.write(storeDefaultCurrency())</script>
                </td>
              </tr>

            </table>
          </p>
    </div>
    </td>
  </tr>
</table>

</form>

</body>

</html>
