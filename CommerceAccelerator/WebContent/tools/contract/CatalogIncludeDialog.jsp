<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
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


///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////

function init(){
   var w = getPageWidth();
   var h = getPageHeight();
   var iframe = parent.document.getElementById("catalogIncludeIframe");
   iframe.style.width = w + 10;
   iframe.style.height = h + 10;
   isLoaded = true;
}


function load(type){

      nodeType = type;

   var lastNodeSelected = parent.getHighlightedNode();

   if(lastNodeSelected.adjustment &&  lastNodeSelected.adjustment != null){
      document.includeForm.adjustment.value = parent.parent.parent.numberToStr(Math.abs(lastNodeSelected.adjustment), "<%= fLanguageId %>");
         parent.loadSignedAdjustment(lastNodeSelected.adjustment,document.includeForm.adjustmentSign);
   }else{
      document.includeForm.adjustment.value = 0;
      var JROM = parent.parent.getJROM();      
      if (JROM.defaultMarkType == "markup") {
        // this is a markup
        document.includeForm.adjustmentSign.options[1].selected = true;
      } else {
        // this is a markdown
        document.includeForm.adjustmentSign.options[0].selected = true;
      }      
   }

      document.includeForm.adjustment.select();

      //changing the title of the iframe
      var title = document.getElementById("title");
      if(lastNodeSelected.mode){
         title.innerText = "<%=UIUtil.toJavaScript((String)contractsRB.get("adjustCatalogTitle"))%>";
      }else{
         title.innerText = "<%=UIUtil.toJavaScript((String)contractsRB.get("iframeDialogTitle"))%>";
      }

}


function savePanelData(){

    if(validatePanelData()){

      parent.document.getElementById("catalogIncludeIframe").style.visibility = "hidden";

      var JROM = parent.parent.getJROM();
      var adjustmentValue = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
      var lastNodeSelected = parent.getHighlightedNode();

   // start the indicator that the subtree is updating
      parent.startIndicator(lastNodeSelected.id + "-anchor", parent.parent.getIndicatorMessage());

   var synch = "true";
         var precedence = parent.getLastNodePrecedence();

         // saving the filters
      parent.parent.saveJLOMRow(lastNodeSelected.value, precedence, nodeType, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], synch, adjustmentValue);

   // change the node's filters as well as the children'.
   parent.setNodeFilters(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustmentValue, true, synch);
   parent.setChildrenNodesSettings(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustmentValue, synch);

   parent.stopIndicator();
    }

}


function validatePanelData() {

   var adjustmentValue = document.includeForm.adjustment.value;

        if (parent.parent.parent.isValidNumber(adjustmentValue, lang_id, false) == false) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
            if (parent.document.getElementById("catalogIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.select();
            }
            return false;
        }

      var signedAdj = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
        if (parent.doesNodeReduceBaseContractAdjustment(parent.getHighlightedNode(), signedAdj)) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorCannotOverrideBase"))%>");
            if (parent.document.getElementById("catalogIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.focus();
            }
            return false;
        }

        if (parent.getSignedAdjustment(adjustmentValue, document.includeForm.adjustmentSign) < -100) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
            if (parent.document.getElementById("catalogIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.focus();
            }
            return false;
        }
      return true;
}


function cancelButton(){
   parent.document.getElementById("catalogIncludeIframe").style.visibility = "hidden";
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



</script>
</head>

<body onload="init();" class="content" onkeypress="KeyListener(event);">
<form NAME="includeForm" onsubmit="return false;" id="includeForm">

<table BORDER="0" id="CatalogIncludeDialog_Table_1">
<tr>
   <td colspan=3 id="CatalogIncludeDialog_TableCell_1">
      <b id="title"><%= contractsRB.get("iframeDialogTitle") %></b>
   </td>
</tr>

<tr>
   <td id="CatalogIncludeDialog_TableCell_2">
      <input size="4" maxlength="4" type="text" name="adjustment" id="CatalogIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CatalogIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CatalogIncludeDialog_FormInput_adjustmentSign_In_includeForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %></label></label> &nbsp;&nbsp;
   </td>
   <td id="CatalogIncludeDialog_TableCell_3">
      <select name="adjustmentSign" id="CatalogIncludeDialog_FormInput_adjustmentSign_In_includeForm_1">
         <option value="markdown" selected> <%= contractsRB.get("contractPricingAdjustmentMarkdownLabel") %> </option>
         <option value="markup"> <%= contractsRB.get("contractPricingAdjustmentMarkupLabel") %> </option>
      </select>
   </td>
</tr>

<tr>
   <td COLSPAN=3 ALIGN=RIGHT id="CatalogIncludeDialog_TableCell_4">
      <table id="CatalogIncludeDialog_Table_2">
         <tr>
            <td id="CatalogIncludeDialog_TableCell_5">
               <button type="button" value="okButton" onclick="savePanelData()" class="general"> <%=UIUtil.toHTML((String)contractsRB.get("ok"))%></button>
            </td>
            <td id="CatalogIncludeDialog_TableCell_6">
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
