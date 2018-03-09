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
var lang_id = <%= fLanguageId %>;
var isLoaded = false;
//NOT_REQUIRED var parentNodeText = "";

///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////

function init(){
   var w = getPageWidth();
   var h = getPageHeight();
   var iframe = parent.document.getElementById("categoryIncludeIframe");
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
         title.innerText = "<%=UIUtil.toJavaScript((String)contractsRB.get("adjustCategoryTitle"))%>";
      }else{
         title.innerText = "<%=UIUtil.toJavaScript((String)contractsRB.get("iframeDialogTitle"))%>";
      }
      //NOT_REQUIRED document.includeForm.excludeSiblingsCheck.checked = false;
      //NOT_REQUIRED parentNodeText = parent.parent.getNodeText(lastNodeSelected.parentNode);
   //alert(parent.parent.getNodeText(lastNodeSelected.parentNode));
}



function savePanelData(){

    if(validatePanelData()){

      var lastNodeSelected = parent.getHighlightedNode();

      // hide the iframe
      parent.document.getElementById("categoryIncludeIframe").style.visibility = "hidden";

   // start the indicator that the subtree is updating
      parent.startIndicator(lastNodeSelected.id + "-anchor", parent.parent.getIndicatorMessage());

      var JROM = parent.parent.getJROM();

   // if we do not know if the category inclusions are synched or not, then ask the user
   if(JROM.includedCategoriesAreSynched == false && JROM.includedCategoriesAreUnSynched == false){
      if(confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("includeCategorySynchronizedQuestion"))%>")){
         JROM.includedCategoriesAreSynched = true;
      } else {
         JROM.includedCategoriesAreUnSynched = true;
         var catalogRow = parent.parent.findCatalogInModel();
         if (catalogRow != null) {
         //alert('remove catalog setting');
               parent.removeRootNodeSetting(lastNodeSelected.parentNode);
         }
      }
//alert("Synch " + JROM.includedCategoriesAreSynched + " UnSynch " + JROM.includedCategoriesAreUnSynched);
      parent.parent.refreshCatalogFilterTitleDivision();
   }
//alert('document.includeForm.adjustment.value=' + document.includeForm.adjustment.value);
      var adjustmentValue = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
//alert('adjustmentValue=' + adjustmentValue);      
      var synch = "true";
      if (JROM.includedCategoriesAreUnSynched == true) {
         synch = "false";
      }
         var precedence = parent.getLastNodePrecedence();

//NOT_REQUIRED    var nodeItem = lastNodeSelected.parentNode;
//NOT_REQUIRED    if(document.includeForm.excludeSiblingsCheck.checked && nodeItem.hasChildNodes()){
//NOT_REQUIRED    for(var i=0; i < nodeItem.childNodes.length; i++){
//NOT_REQUIRED       //alert('Node ' + nodeItem.childNodes[i].value + ' explicit ' + nodeItem.childNodes[i].isExplicit + ' hostexcl ' + nodeItem.childNodes[i].isHostingExcluded);
//NOT_REQUIRED       if (!nodeItem.childNodes[i].isExplicit && !nodeItem.childNodes[i].isHostingExcluded
//NOT_REQUIRED          && nodeItem.childNodes[i].value != lastNodeSelected.value) {
//NOT_REQUIRED          //alert('exclude this node');
//NOT_REQUIRED          parent.excludeNode(nodeItem.childNodes[i], JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATEGORY]);
//NOT_REQUIRED       }
//NOT_REQUIRED    }
//NOT_REQUIRED }

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
            if (parent.document.getElementById("categoryIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.select();
            }
            return false;
        }

      var signedAdj = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
        if (parent.doesNodeReduceBaseContractAdjustment(parent.getHighlightedNode(), signedAdj)) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorCannotOverrideBase"))%>");
            if (parent.document.getElementById("categoryIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.focus();
            }
            return false;
        }

        if (parent.getSignedAdjustment(adjustmentValue, document.includeForm.adjustmentSign) < -100) {
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
            if (parent.document.getElementById("categoryIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.focus();
            }
            return false;
        }

        if(parent.isParentAdjustmentSame(parent.getSignedAdjustment(adjustmentValue, document.includeForm.adjustmentSign))){
            alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateExplicitFilterMessage"))%>");
            if (parent.document.getElementById("categoryIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.select();
            }
            return false;
        }

      return true;
}

// This function takes in a text and performs some substitution
function changeSpecialText(rawDisplayText,textOne, textTwo, textThree, textFour) {
    var displayText = rawDisplayText.replace(/%1/, textOne);


    if (textTwo != null)
       displayText = displayText.replace(/%2/, textTwo);
    if (textThree != null)
       displayText = displayText.replace(/%3/, textThree);
    if (textFour != null)
       displayText = displayText.replace(/%4/, textFour);

    return displayText;
}


function cancelButton(){
   parent.document.getElementById("categoryIncludeIframe").style.visibility = "hidden";
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

<table BORDER="0" id="CategoryIncludeDialog_Table_1">
<tr>
   <td colspan=3 id="CategoryIncludeDialog_TableCell_1">
      <b id="title"><%= contractsRB.get("iframeDialogTitle") %></b>
   </td>
</tr>

<tr>
   <td id="CategoryIncludeDialog_TableCell_2">
      <input size="4" maxlength="4" type="text" name="adjustment" id="CategoryIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CategoryIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CategoryIncludeDialog_FormInput_adjustmentSign_In_includeForm"><%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %></label></label> &nbsp;&nbsp;
   </td>
   <td id="CategoryIncludeDialog_TableCell_3">
      <select name="adjustmentSign" id="CategoryIncludeDialog_FormInput_adjustmentSign_In_includeForm">
         <option value="markdown" selected> <%= contractsRB.get("contractPricingAdjustmentMarkdownLabel") %> </option>
         <option value="markup"> <%= contractsRB.get("contractPricingAdjustmentMarkupLabel") %> </option>
      </select>
   </td>
</tr>
<!--<TR>
       <TD colspan=3>
            <INPUT type=checkbox name=excludeSiblingsCheck><%= contractsRB.get("excludeOtherCategories") %>
       </TD>
</TR>
-->
<tr>
   <td COLSPAN=3 ALIGN=RIGHT id="CategoryIncludeDialog_TableCell_4">
      <table id="CategoryIncludeDialog_Table_2">
         <tr>
            <td id="CategoryIncludeDialog_TableCell_5">
               <button type="button" value="okButton" onclick="savePanelData()" class="general"> <%=UIUtil.toHTML((String)contractsRB.get("ok"))%></button>
            </td>
            <td id="CategoryIncludeDialog_TableCell_6">
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
