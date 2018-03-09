<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>
<head>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script>

///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////

var nodeType = null;
var lang_id = <%= fLanguageId%>;
var isLoaded = false;

var JROM = parent.parent.getJROM(); 
var shipmodes = parent.parent.getAvailableShipmodes();


///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////

function init(){
   var w = getPageWidth();
   var h = getPageHeight();
   var iframe = parent.document.getElementById("catalogAdjustmentTCIframe");
   iframe.style.width = w + 10;
   iframe.style.height = h + 10;
   isLoaded = true;
}
// return the dynamic generated form element id 
function getCheckboxId(policyId) {
   var id = "checkbox" + policyId;
   return id;
}
// return the dynamic generated form element id 
function getAdjustmentValueId(policyId) {
   var id = "adjustmentValue" + policyId;
   return id;
}
// return the dynamic generated form element id 
function getAdjustmentTypeId(policyId) {
   var id = "adjustmentType"+policyId;
   return id;
}


function load(type){
  nodeType = type;
   
  var lastNodeSelected = parent.getHighlightedNode();
   // give a clean form before load data.
  clearForm();
   // load whatever from JLOM or JROM
  if(lastNodeSelected.adjustmentTCs != null){
    parent.parent.alertDebug("found adjustmentTC!");
     // Load the data to the adjustment TC List:
    for (policyId in lastNodeSelected.adjustmentTCs) {
       // setup the global value shared by all TCs in this node.
      if (lastNodeSelected.adjustmentTCs[policyId].actionType != JROM.ACTION_TYPE_DELETE) {
         // only load the noaction, new, updated TCs
        if (lastNodeSelected.adjustmentTCs[policyId].policyId == JROM.POLICY_ALL_SHIPMODES) {
           // load the data to all shipmode TC
          document.getElementById(getCheckboxId(0)).checked=true;
          if (lastNodeSelected.adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF) {
             // load percentage value             
            if (lastNodeSelected.adjustmentTCs[policyId].adjustmentValue.charAt(0)=="-") {
              document.getElementById(getAdjustmentTypeId(0)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN;
            } else {
              document.getElementById(getAdjustmentTypeId(0)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP;
            }
            document.getElementById(getAdjustmentValueId(0)).value = parent.parent.parent.numberToStr(Math.abs(lastNodeSelected.adjustmentTCs[policyId].adjustmentValue), "<%= fLanguageId %>");
          } else {
            // load fixed cost
            document.getElementById(getAdjustmentTypeId(0)).value = lastNodeSelected.adjustmentTCs[policyId].adjustmentType;
            document.getElementById(getAdjustmentValueId(0)).value = parent.parent.parent.numberToCurrency(lastNodeSelected.adjustmentTCs[policyId].adjustmentValue, JROM.storeDefaultCurrency, "<%=fLanguageId%>");
          }           
        } else {
          document.getElementById(getCheckboxId(policyId)).checked=true;
          if (lastNodeSelected.adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF) {
            // load percentage value             
            if (lastNodeSelected.adjustmentTCs[policyId].adjustmentValue.charAt(0)=="-") {
              document.getElementById(getAdjustmentTypeId(policyId)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN;
            } else {
              document.getElementById(getAdjustmentTypeId(policyId)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP;
            }
            document.getElementById(getAdjustmentValueId(policyId)).value = parent.parent.parent.numberToStr(Math.abs(lastNodeSelected.adjustmentTCs[policyId].adjustmentValue), "<%= fLanguageId %>");
          } else {
            // load fixed cost
            document.getElementById(getAdjustmentTypeId(policyId)).value = lastNodeSelected.adjustmentTCs[policyId].adjustmentType;
            document.getElementById(getAdjustmentValueId(policyId)).value = parent.parent.parent.numberToCurrency(lastNodeSelected.adjustmentTCs[policyId].adjustmentValue, JROM.storeDefaultCurrency, "<%=fLanguageId%>");
          }
        }
      }
    }   
  }
}

function clearForm() {
  parent.parent.alertDebug("clear form");
  document.getElementById(getCheckboxId(0)).checked=false;
  document.getElementById(getAdjustmentValueId(0)).value = "";
  document.getElementById(getAdjustmentTypeId(0)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN;
  if (parent.parent.getShipmodePolicyQty()>0) {
    for (policyId in shipmodes) {
      document.getElementById(getCheckboxId(policyId)).checked=false;
      document.getElementById(getAdjustmentValueId(policyId)).value = "";
      document.getElementById(getAdjustmentTypeId(policyId)).value = JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN;
    }
  } 
}

function savePanelData(){
  var lastNodeSelected = parent.getHighlightedNode();
  parent.parent.alertDebug("In savePanelData()");
  if(validatePanelData()){
    parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility = "hidden";
    if(document.getElementById(getCheckboxId(0)).checked) {
      var adjustType = document.getElementById(getAdjustmentTypeId(0)).value;
      var adjustValue = document.getElementById(getAdjustmentValueId(0)).value;
      if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN) {
        adjustValue = parent.getSignedAdjustment(adjustValue, adjustType);
        adjustType = JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF;
      } else if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP) {
        adjustValue = parent.getSignedAdjustment(adjustValue, adjustType);
        adjustType = JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF;
      } else if (adjustType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
        adjustValue = parent.parent.parent.currencyToNumber(adjustValue, JROM.storeDefaultCurrency, "<%=fLanguageId%>");
      }
      // save the all-shipmode TC
      var newAdjustmentTC = new parent.parent.AdjustmentTC(0,
                                             "<%=UIUtil.toJavaScript((String)contractsRB.get("allShipmodes")) %>", 
                                             lastNodeSelected.refId, 
                                             JROM.FILTER_TYPE_CATALOG, 
                                             adjustType, 
                                             adjustValue, 
                                             lastNodeSelected.ownerDn, 
                                             JROM.storeDefaultCurrency, 
                                             lastNodeSelected.referenceName,
                                             null, 
                                             JROM.ACTION_TYPE_NEW);
      parent.parent.saveAdjustmentTCInJLOM(lastNodeSelected.value, JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG], newAdjustmentTC);      
    } else {
      // mark for delete
      parent.parent.removeAdjustmentTCInJLOM(lastNodeSelected.value, 0);      
    }
    
    if (parent.parent.getShipmodePolicyQty()>0) {
    // check all other policies
      for (policyId in shipmodes) {
        if(document.getElementById(getCheckboxId(policyId)).checked) {
          var adjustType = document.getElementById(getAdjustmentTypeId(policyId)).value;
          var adjustValue = document.getElementById(getAdjustmentValueId(policyId)).value;
          if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN) {
            adjustValue = parent.getSignedAdjustment(adjustValue, adjustType);
            adjustType = JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF;
          } else if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP) {
            adjustValue = parent.getSignedAdjustment(adjustValue, adjustType);
            adjustType = JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF;
          } else if (adjustType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
            adjustValue = parent.parent.parent.currencyToNumber(adjustValue, JROM.storeDefaultCurrency, "<%=fLanguageId%>");
          }
          // save different shipmode TC
          var newAdjustmentTC = new parent.parent.AdjustmentTC(policyId, 
                                       shipmodes[policyId].name, 
                                       lastNodeSelected.refId, 
                                       JROM.FILTER_TYPE_CATALOG,
                                       adjustType, 
                                       adjustValue, 
                                       lastNodeSelected.ownerDn, 
                                       JROM.storeDefaultCurrency, 
                                       lastNodeSelected.referenceName,
                                       null,
                                       JROM.ACTION_TYPE_NEW);
          parent.parent.saveAdjustmentTCInJLOM(lastNodeSelected.value, JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG], newAdjustmentTC);       
        } else {
          // mark for delete
          parent.parent.removeAdjustmentTCInJLOM(lastNodeSelected.value, policyId);
        }
      }
    }
    var JLOMnode = parent.parent.findNodeInJLOM(lastNodeSelected.value);
    if(JLOMnode != null){
      parent.setNodeFilters(lastNodeSelected, JLOMnode.adjustmentTCs);	
      parent.setChildrenNodesSettings(lastNodeSelected);			
    } else {
      var adjustmentTCs = new Array();
      parent.setNodeFilters(lastNodeSelected, adjustmentTCs);
      parent.setChildrenNodesSettings(lastNodeSelected);		
    }
	
    // change the node's filters as well as the children'.   
    parent.stopIndicator();
  }
}

function validatePanelData() {
  if(document.getElementById(getCheckboxId(0)).checked) {
    var adjustType = document.getElementById(getAdjustmentTypeId(0)).value;
    var adjustValue = document.getElementById(getAdjustmentValueId(0)).value;
    if (adjustType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
      if (parent.parent.parent.isValidNumber(adjustValue, lang_id, false) == false) {
        alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyFixedCost"))%>");
        if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
          document.getElementById(getAdjustmentValueId(0)).focus();
        }
        return false;
      }
      if (parent.parent.parent.isValidCurrency(adjustValue, JROM.storeDefaultCurrency, lang_id) == false) {
        alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyCurrencyFormat"))%>");
        if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
          document.getElementById(getAdjustmentValueId(0)).focus();
        }
        return false;
      }
    }
    if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP || adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN) {
      if (parent.parent.parent.isValidNumber(adjustValue, lang_id, false) == false) {
        alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyPercentage"))%>");
        if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
          document.getElementById(getAdjustmentValueId(0)).focus();
        }
        return false;
      }
      if (parent.getSignedAdjustment(adjustValue, adjustType) < -100) {
        alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorMaximumMarkdown"))%>");
        if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
          document.getElementById(getAdjustmentValueId(0)).focus();
        }
        return false;
      }
    }
  }
  if (parent.parent.getShipmodePolicyQty()>0) {
    // check all other policies
    for (policyId in shipmodes) {
      if(document.getElementById(getCheckboxId(policyId)).checked) {
        var adjustType = document.getElementById(getAdjustmentTypeId(policyId)).value;
        var adjustValue = document.getElementById(getAdjustmentValueId(policyId)).value;
        if (adjustType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
          if (parent.parent.parent.isValidNumber(adjustValue, lang_id, false) == false) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyFixedCost"))%>");
            if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
              document.getElementById(getAdjustmentValueId(policyId)).focus();
            }
            return false;
          }
          if (parent.parent.parent.isValidCurrency(adjustValue, JROM.storeDefaultCurrency, lang_id) == false) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyCurrencyFormat"))%>");
            if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
              document.getElementById(getAdjustmentValueId(policyId)).focus();
            }
            return false;
          }
        }
        if (adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP || adjustType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN) {
          if (parent.parent.parent.isValidNumber(adjustValue, lang_id, false) == false) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorSpecifyPercentage"))%>");
            if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
              document.getElementById(getAdjustmentValueId(policyId)).focus();
            }
            return false;
          }
          if (parent.getSignedAdjustment(adjustValue, adjustType) < -100) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractShippingChargeAdjustmentErrorMaximumMarkdown"))%>");
            if (parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility == "visible") {
              document.getElementById(getAdjustmentValueId(policyId)).focus();
            }
            return false;
          }
        }
      }
    }
  }
    
  return true;
}


function cancelButton(){
   parent.document.getElementById("catalogAdjustmentTCIframe").style.visibility = "hidden";
}


function KeyListener(e){
   // 13 is the "Enter" key
   if(e.keyCode == 13){
      savePanelData();
   }

   // 27 is the "Esc" key
   if(e.keyCode == 27){
      cancelButton();
   }
}

function writeTableRows() {
  if (parent.parent.getShipmodePolicyQty()>0) {
    var j =4; // used for cell id
    for (policyId in shipmodes) {
      document.write('<tr>');
      document.write('<td id="CatalogAdjustmentDialog_TableCell_'+j+'1"><input type="checkbox" name="checkbox'+shipmodes[policyId].id+
                     '" id="checkbox' + shipmodes[policyId].id + '" value="false" onclick="validateCheckBox(' + shipmodes[policyId].id + ')"></td>');
      document.write('<td id="CatalogAdjustmentDialog_TableCell_'+j+'2">'+shipmodes[policyId].description + '</td>');
      document.write('<td id="CatalogAdjustmentDialog_TableCell_'+j+'3"><input size="5" maxlength="10" type="text" name="adjustmentValue'+shipmodes[policyId].id+
                     '" id="adjustmentValue'+shipmodes[policyId].id+'">');
      document.write('</td>');
      document.write('<td id="CatalogAdjustmentDialog_TableCell_'+j+'4">' +
                     '<select name="adjustmentType'+shipmodes[policyId].id+'" id="adjustmentType'+shipmodes[policyId].id+'">');
      writeSelectOptions();
      document.write('</select>');
      document.write('</td>');
      document.write('</tr>');
      j++;
    }
  }
}

function writeSelectOptions() {
  document.write('<option value="'+ JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN +'" selected> <%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingAdjustmentPercentageLabel"))%> <%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingAdjustmentMarkdownLabel"))%> </option>');
  if (JROM.delegationGrid == false) {
  	document.write('<option value="'+ JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP +'" > <%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingAdjustmentPercentageLabel"))%> <%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingAdjustmentMarkupLabel"))%> </option>');
  	document.write('<option value="'+ JROM.ADJUSTMENT_TYPE_AMOUNT_OFF +'"><%=UIUtil.toJavaScript((String)contractsRB.get("fixedCostAdjustmentLabel"))%> '+ JROM.storeDefaultCurrency + '</option>');
  }
}

function validateCheckBox(policyId) {
  if (policyId == 0) {
    // if false, do nothing
    // if true, disable other checkbox
    if (document.getElementById(getCheckboxId(policyId)).checked) {
      for (pId in shipmodes) {
        document.getElementById(getCheckboxId(pId)).checked = false;
      }
    }
  } else {
    // if false, do nothing
    // if true, disable the checkbox0
    if (document.getElementById(getCheckboxId(policyId)).checked) {
      document.getElementById(getCheckboxId(0)).checked = false;
    }
  }
}


</script>
</head>

<body onload="init();" class="content" onkeypress="KeyListener(event);">
<form NAME="adjustmentForm" onsubmit="return false;" id="adjustmentForm">

<table BORDER="0" id="CatalogAdjustmentDialog_Table_1">
<tr>
  <td colspan=4 id="CatalogAdjustmentDialog_TableCell_1">
    <b id="title"><%= contractsRB.get("setShippingChargeAdjustment") %></b>
  </td>
</tr>
<tr>
  <td id="CatalogAdjustmentDialog_TableCell_21">&nbsp;</td>
  <td id="CatalogAdjustmentDialog_TableCell_22"><%= contractsRB.get("shippingModeLabel") %></td>
  <td id="CatalogAdjustmentDialog_TableCell_23"><%= contractsRB.get("amountLabel") %></td>
  <td id="CatalogAdjustmentDialog_TableCell_24"><%= contractsRB.get("typeLabel") %></td>
</tr> 
<tr>
  <td id="CatalogAdjustmentDialog_TableCell_31"><input type="checkbox" name="checkbox0" id="checkbox0" value="false" onclick="validateCheckBox(0)"></td>
  <td id="CatalogAdjustmentDialog_TableCell_32"><label for="checkbox0"><%= contractsRB.get("allShipmodes") %></label></td>
  <td id="CatalogAdjustmentDialog_TableCell_33">
    <label class="hidden-label" for="adjustmentValue0"><%= contractsRB.get("amountLabel") %></label>
    <input size="5" maxlength="10" type="text" name="adjustmentValue0" id="adjustmentValue0">
  </td>
  <td id="CatalogAdjustmentDialog_TableCell_34">
      <label class="hidden-label" for="adjustmentType0"><%= contractsRB.get("typeLabel") %></label>
      <select name="adjustmentType0" id="adjustmentType0">
          <script language="JavaScript"> writeSelectOptions();</script>
      </select>
   </td>
</tr>
<script language="JavaScript">
writeTableRows();
</script>
<tr>
   <td COLSPAN=4 ALIGN=RIGHT id="CatalogAdjustmentDialog_TableCell_0">
      <table id="CatalogAdjustmentDialog_Table_2">
         <tr>
            <td id="CatalogAdjustmentDialog_Table_2_Cell_1">
               <button type="button" value="okButton" onclick="savePanelData()" class="general"> <%=UIUtil.toHTML((String)contractsRB.get("ok"))%></button>
            </td>
            <td id="CatalogAdjustmentDialog_Table_2_Cell_2">
               <button type="button" value="cancelButton" onclick="cancelButton()" class="general"> <%=UIUtil.toHTML((String)contractsRB.get("cancel"))%></button>
            </td>
         </tr>
      </table>
   </td>
</tr>
</table>
</form>
</body>
</html>
