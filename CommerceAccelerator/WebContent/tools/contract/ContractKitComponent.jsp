<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<%--
//
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*,
      com.ibm.commerce.beans.*,
      com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
      com.ibm.commerce.tools.contract.beans.PolicyDataBean,
      com.ibm.commerce.tools.contract.beans.MemberDataBean,
      com.ibm.commerce.tools.contract.beans.ContractDataBean,
      com.ibm.commerce.tools.contract.beans.PriceTCMasterCatalogWithFilteringDataBean,
      com.ibm.commerce.tools.contract.beans.CatalogFilterDataBean,
      com.ibm.commerce.tools.contract.beans.CustomPricingTCDataBean,
      com.ibm.commerce.order.objects.TradingPositionContainerAccessBean,
      com.ibm.commerce.catalog.objects.CatalogEntryAccessBean,
      com.ibm.commerce.contract.helper.ECContractConstants,
      com.ibm.commerce.command.CommandContext,
      com.ibm.commerce.tools.catalog.beans.*,
      com.ibm.commerce.common.beans.*,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.utils.TimestampHelper,
      com.ibm.commerce.tools.catalog.util.*,
      com.ibm.commerce.catalog.objects.*,
      com.ibm.commerce.price.commands.*,
      com.ibm.commerce.price.utils.*,
      com.ibm.commerce.contract.util.*,
      com.ibm.commerce.contract.helper.ContractUtil,
      com.ibm.commerce.common.objects.StoreAccessBean,
      com.ibm.commerce.tools.util.*"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>
<head>

<meta http-equiv="Content-Style-Type" content="text/css">

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CatalogFilter.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>


<%
   StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
   // get the default currenty for a store
   CurrencyManager cm = CurrencyManager.getInstance();
   String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());
%>


<script LANGUAGE="JavaScript">


// This variable holds the total count of checked components to be deleted
var componentCheckCount=0;


// This variable holds a temporary list of component entires (KCPEntry)
var myKCPEntriesList = new Array();



//-----------------------------------------------------------------------------
// Function Name: KCPEntry()
//
// Define KCPEntry data model to encapsulate attribute for a component kit
// pricing entry.
//-----------------------------------------------------------------------------
function KCPEntry(compName, compRefNum, sku, adjValue, adjType, adjCurrency, toBeDeleted)
{
   // KCPEntry Attributes
   this.componentName           = compName;
   this.componentReferenceNum   = compRefNum;
   this.sku                     = sku;
   this.adjustmentValue         = adjValue;
   this.adjustmentType          = adjType; // 1-markdown, 2-markup, 3-price
   this.adjustmentCurrency      = adjCurrency;
   this.checkedForDelete        = toBeDeleted;
}



//-----------------------------------------------------------------------------
// Function Name: createKitFinderFrame()
//
// This function creates the component kit finder iframe.
//-----------------------------------------------------------------------------
function createKitFinderFrame()
{
   // Create the component kit finder iframe
   var kitFinderIFrame = document.createElement("IFRAME");
   kitFinderIFrame.id="kitComponentFinderIframe";
   kitFinderIFrame.src="/webapp/wcs/tools/servlet/ContractKitComponentFinderView";
   kitFinderIFrame.style.position = "absolute";
   kitFinderIFrame.style.visibility = "hidden";
   kitFinderIFrame.style.height="250";
   kitFinderIFrame.style.width="700";
   kitFinderIFrame.frameborder="1";
   kitFinderIFrame.MARGINHEIGHT="0";
   kitFinderIFrame.MARGINWIDTH="0";
   document.body.appendChild(kitFinderIFrame);
}


//-----------------------------------------------------------------------------
// Function Name: startKCPListTable()
//
// Build the visual part of the kit pricing list table header
//-----------------------------------------------------------------------------
function startKCPListTable()
{
   document.writeln('<table id="kcp" name="kcp" cellpadding="1" cellspacing="0" border="0" width="100%" bgcolor="#6D6D7C">');
   document.writeln('<tr id="kcp_tr1"><td>');
   document.writeln('<table id="kitComponentListTable" name="kitComponentListTable" class="list" border="0" cellpadding="0" cellspacing="0" width="100%"> ');
   document.writeln('<tr>');

   // Add the check box
   document.write('<td class="list_check_all">');
   var check=false;
   if (check == true)
   {
      document.write('<input name="select_deselect" type="checkbox" value="Select Deselect All" onclick="');
      document.write('parent.selectDeselectAll()');
      document.write(';">');
   }
   document.writeln('</td>');
}


//-----------------------------------------------------------------------------
// Function Name: endKCPListTable()
//
// End the visual part of the kit pricing list table header
//-----------------------------------------------------------------------------
function endKCPListTable()
{
   document.writeln('</table>');
   document.writeln('</td></tr>');
   document.writeln('</table>');
}


//-----------------------------------------------------------------------------
// Function Name: addKCPListColumnHeading()
//
// Build the visual part of the kit pricing list table columns
//-----------------------------------------------------------------------------
var numOfTableColumn=0; // counter for th-id# increments purpose
function addKCPListColumnHeading(hvalue,wrap,width)
{
   numOfTableColumn++;
   heading_id = 'kcp_heading_' + numOfTableColumn;
   document.write('<th id="' + heading_id + '" ');
   document.write('class="list_header" ');

   if (width != null)
   {
      document.write('width="' + width + '" ');
   }

   if (wrap != null && !wrap)
   {
      document.write('nowrap="nowrap" ');
   }

   document.write('>');
   document.writeln(hvalue);
   document.writeln('</th>');
}



//-----------------------------------------------------------------------------
// Function Name: setKCPEntryChecked()
//
// Toggle the delete flag in the data model entry when user clicks on the checkbox
//-----------------------------------------------------------------------------
function setKCPEntryChecked(rowID)
{
   var myRow = myKCPEntriesList[rowID];
   if (myRow==null) { return; }

   if (myRow.checkedForDelete==true)
   {
      myRow.checkedForDelete = false;
      componentCheckCount--;
   }
   else
   {
      myRow.checkedForDelete = true;
      componentCheckCount++;
   }

   if (componentCheckCount > 0)
   {
      document.getElementById('removeKitButton').disabled = false;
   }
   else
   {
      document.getElementById('removeKitButton').disabled = true;
   }
}


//-----------------------------------------------------------------------------
// Function Name: addNewRowToKCPList()
//
// Add a new kit component entry into both visual and data models
//-----------------------------------------------------------------------------
function addNewRowToKCPList(compName, compRefNum, sku, adjustmentValue, adjustmentType, adjustmentCurrency)
{
   var col0, col1, col2, col3;

   var myNewRow_ID = "kitrow_" + compRefNum;;
   if (myKCPEntriesList[myNewRow_ID]!=null)
   {
      // Skip for adding duplicated entry
      return;
   }

   var useCurrency = "<%= defaultCurrency %>";
   if ( (adjustmentCurrency!=null) && (adjustmentCurrency!="") )
   {
      // Use the specified currency instead of the default one
      useCurrency = adjustmentCurrency;
   }

   // Ready the new row
   var myNewRow  = document.all.kitComponentListTable.insertRow();
   var myNewRow_ID = "kitrow_" + compRefNum;;
   myNewRow.id = myNewRow_ID;

   // Ready the checkbox column
   var myNewCol0 = myNewRow.insertCell();
   var myNewCol0_ID = "kitcell1CheckBox_" + compRefNum;
   myNewCol0.id = myNewCol0_ID;
   col0 = '<input type="checkbox" onclick="setKCPEntryChecked(\'' + myNewRow_ID + '\');"/>';

   // Ready the first column: Component Name
   var myNewCol1 = myNewRow.insertCell();
   var myNewCol1_ID = "kitcell1_" + compRefNum;
   myNewCol1.id = myNewCol1_ID;
   col1 = compName;

   // Ready the first column: SKU
   var myNewCol2 = myNewRow.insertCell();
   var myNewCol2_ID = "kitcell2_" + compRefNum;
   myNewCol2.id = myNewCol2_ID;
   col2 = sku;

   // Ready the third column: Price Adjustment
   var myNewCol3 = myNewRow.insertCell();
   var myNewCol3_ID = "kitcell3_" + compRefNum;
   myNewCol3.id = myNewCol3_ID;

   var is_1_Selected='';
   var is_2_Selected='';
   var is_3_Selected='';
   var displayAdjValue='';

   if (adjustmentValue!='')
   {
      displayAdjValue = parent.parent.numberToStr(Math.abs(adjustmentValue),
                                                   "<%=fLanguageId%>");
   }

   if (adjustmentType==1)
   {
      is_1_Selected='selected';
   }
   else if (adjustmentType==2)
   {
      is_2_Selected='selected';
   }
   else if (adjustmentType==3)
   {
      is_3_Selected='selected';
      displayAdjValue = parent.parent.numberToCurrency(adjustmentValue,
                                                       useCurrency,
                                                       "<%=fLanguageId%>");
   }
   else
      { is_1_Selected='selected'; }

   col3 = '<input id=col3_adjvalue_"' + compRefNum + '" name="col3_adjvalue_' + compRefNum + '" size="10" type="text" value="' + displayAdjValue + '">';
   col3 +='<select id=col3_adjtype_"' + compRefNum + '" name="col3_adjtype_' + compRefNum + '">';
   col3 +='<option value="1" ' + is_1_Selected + '><%= UIUtil.toJavaScript((String)contractsRB.get("KCP_LabelMarkDown")) %></option>';
   col3 +='<option value="2" ' + is_2_Selected + '><%= UIUtil.toJavaScript((String)contractsRB.get("KCP_LabelMarkUp")) %></option>';
   col3 +='<option value="3" ' + is_3_Selected + '><%= UIUtil.toJavaScript((String)contractsRB.get("KCP_LabelPrice")) %>(' + useCurrency + ')</option>';
   col3 +='</select>';


   //myNewRow.className  = "list_row1";
   myNewCol0.className = "list_check";
   myNewCol1.className = "list_info1";
   myNewCol2.className = "list_info1";
   myNewCol3.className = "list_info1";

   myNewCol0.innerHTML = col0;
   myNewCol1.innerHTML = col1;
   myNewCol2.innerHTML = col2;
   myNewCol3.innerHTML = col3;


   // Create a data model entry to hold the data and add it to the entries list
   var aNewDataEntry = new KCPEntry(compName,
                                    compRefNum,
                                    sku,
                                    adjustmentValue,
                                    adjustmentType,
                                    useCurrency,
                                    false);

   myKCPEntriesList[myNewRow_ID] = aNewDataEntry;
}


//-----------------------------------------------------------------------------
// Function Name: deleteRowFromKCPList()
//
// Delete user selected kit component entries in both visual and data models
//-----------------------------------------------------------------------------
function deleteRowFromKCPList()
{
   var rowList = document.getElementById('kitComponentListTable').rows;
   if (rowList==null) { return; }

   // Temp. index i starting from 1 because the [0] is the header row
   for (var i=1; i < rowList.length; i++)
   {
      var rowID = rowList[i].id;
      var rowNode = myKCPEntriesList[rowID];

      if (rowNode!=null)
      {
         if (rowNode.checkedForDelete == true)
         {
            document.all.kitComponentListTable.deleteRow(i);
            myKCPEntriesList[rowID] = null;

            // The row index will shift once a row is deleted,
            // so we need to rewind the temp index i
            i--;
         }
      }

   }//end-for

   // Disable the remove button after deleting all selected entries
   document.getElementById('removeKitButton').disabled = true;
   componentCheckCount = 0;

   /*95161*/ resetRowsBgColor();
}



//-----------------------------------------------------------------------------
// Function Name: callbackFromFinder()
//
// This is a callback function invoked from the kit component finder once the
// user selects the catentry and clicks OK button.
//-----------------------------------------------------------------------------
function callbackFromFinder(ids, names, skus)
{
   var markSetting = 1;
   if (parent.getJROM().defaultMarkType == "markup") {
      markSetting = 2;
   }
   for (var i=0; i < ids.length; i++)
   {
      addNewRowToKCPList(names[i], ids[i], skus[i], "", markSetting, null);
   }

   /*95161*/ resetRowsBgColor();
}



//-----------------------------------------------------------------------------
// Function Name: addButton()
//
// Display the kit component finder to user to search components
// and add the user selected catentries to the list
//-----------------------------------------------------------------------------
function addButton()
{
   var myIFrame = document.getElementById("kitComponentFinderIframe");

   if (myIFrame==null)
   {
      createKitFinderFrame();
   }

   var objAdd = document.getElementById("addKitButton");
   document.getElementById("kitComponentFinderIframe").style.top = getObjPageY(objAdd);
   document.getElementById("kitComponentFinderIframe").style.left = getObjPageX(objAdd);
   document.getElementById("kitComponentFinderIframe").style.visibility = "visible";
}



//-----------------------------------------------------------------------------
// Function Name: getKitComponentPricingList()
//
// This is a callback function involved by caller (i.e. CatalogFilterTree.js).
// It returns the current list of kit component pricing information in an array
// format, and the array contains a list of KCPEntry objects.
//-----------------------------------------------------------------------------
function getKitComponentPricingList()
{
   var rowList = document.getElementById('kitComponentListTable').rows;
   if (rowList==null) { return null; }

   var appliedKCPEntriesList = new Array();
   var validRowCounter=0;

   // Temp. index i starting from 1 because the [0] is the header row
   for (var i=1; i < rowList.length; i++)
   {
      var rowID = rowList[i].id;
      var rowNode = myKCPEntriesList[rowID];

      if (rowNode!=null)
      {
         var adjustValue_id = "col3_adjvalue_" + rowNode.componentReferenceNum;
         var adjustType_id  = "col3_adjtype_"  + rowNode.componentReferenceNum;
         var adjValueAtRow  = eval("document.ContractKitComponentForm." + adjustValue_id + ".value");
         var adjTypeAtRow   = eval("document.ContractKitComponentForm." + adjustType_id  + ".value");
         rowNode.adjustmentValue     = adjValueAtRow;
         rowNode.adjustmentType      = adjTypeAtRow;
         rowNode.adjustmentCurrency  = "<%= defaultCurrency %>";

         //adjValueAtRow = Math.abs(adjValueAtRow); // trim out all tailing zeros

         if (adjTypeAtRow=="3")
         {
            adjValueAtRow = parent.parent.currencyToNumber(adjValueAtRow,
                                                           rowNode.adjustmentCurrency,
                                                           "<%=fLanguageId%>");
         }
         else
         {
            adjValueAtRow = parent.parent.strToNumber(adjValueAtRow,
                                                       "<%=fLanguageId%>");
         }

         var kitComponentNode = new KCPEntry(rowNode.componentName,
                                             rowNode.componentReferenceNum,
                                             rowNode.sku,
                                             adjValueAtRow,
                                             adjTypeAtRow,
                                             "<%= defaultCurrency %>",
                                             false);

         appliedKCPEntriesList[validRowCounter++] = kitComponentNode;
      }

   }//end-for

   return appliedKCPEntriesList;
}



//-----------------------------------------------------------------------------
// Function Name: loadKitPricing()
//
// This function loads the kit components to the visual model using the
// the prefetched data in JKIT model.
//-----------------------------------------------------------------------------
function loadKitPricing()
{
   // ensure the save button is enabled
   parent.enableDialogButtons();

   var nodeSelected = parent.gLastClickedTreeNode;
   if (nodeSelected==null)
   {
      // Skip if no previous node has been selected
      top.showProgressIndicator(false);
      return;
   }

   var JKIT = parent.getJKIT();
   var kitConfig = JKIT.configurationList[nodeSelected.value];
   if (kitConfig==null)
   {
   //alert('cc kit config null');
      // check for base contract
      kitConfig = JKIT.parentConfigurationList[nodeSelected.value];
      if (kitConfig==null)
      {
      //alert('base kit config null');
      	// Skip if no previous kit configuration has been found
     	top.showProgressIndicator(false);
      	return;
      } else {
       //alert('base kit config not null');
      }
   }

   var blockList = kitConfig.buildBlockList;

   for (bbID in blockList)
   {
      var adjustmentValue = "";

      if (blockList[bbID].adjustmentType=="3")
      {
         // Fixed price adjustment type
         defCurrency = "<%= defaultCurrency %>";
         if (kitConfig.buildBlockList[bbID].priceOffers[defCurrency]==null)
         {
            // No fixed price adjustment has been defined for the store default currency
            adjustmentValue = "";
         }
         else
         {
            adjustmentValue = kitConfig.buildBlockList[bbID].priceOffers[defCurrency].priceAdjustmentValue;
         }
      }
      else
      {
         // Percentage adjustment type
         adjustmentValue = blockList[bbID].percentageOfferAdjustmentValue;
      }

      //adjustmentValue = Math.abs(adjustmentValue); // trim out all tailing zeros

      addNewRowToKCPList(blockList[bbID].name,
                         blockList[bbID].catalogEntryRef,
                         blockList[bbID].sku,
                         adjustmentValue,
                         blockList[bbID].adjustmentType,
                         null);

   }//end-for-bbID

   /*95161*/ resetRowsBgColor();

   top.showProgressIndicator(false);
}

//-----------------------------------------------------------------------------
// Function Name: validatePanelData()
//
// This function returns false if any component pricing adjustment values in
// the panel is invalid; otherwise, it returns true.
//-----------------------------------------------------------------------------
function validatePanelData()
{
   var rowList = document.getElementById('kitComponentListTable').rows;
   if (rowList==null)
   {
      parent.getJKIT().isValidated=true;
      return true;
   }

   var appliedKCPEntriesList = new Array();
   var validRowCounter=0;

   // Temp. index i starting from 1 because the [0] is the header row
   for (var i=1; i < rowList.length; i++)
   {
      var rowID = rowList[i].id;
      var rowNode = myKCPEntriesList[rowID];

      if (rowNode!=null)
      {
         var adjustValue_id = "col3_adjvalue_" + rowNode.componentReferenceNum;
         var adjustType_id  = "col3_adjtype_"  + rowNode.componentReferenceNum;

         var adjValueAtRow  = eval("document.ContractKitComponentForm." + adjustValue_id + ".value");
         var adjTypeAtRow   = eval("document.ContractKitComponentForm." + adjustType_id  + ".value");
         var adjCurrency    = "<%= defaultCurrency %>";
         var langId         = <%= fLanguageId %>;
         var compName       = rowNode.componentName;
         var compSKU        = rowNode.sku;

         if (adjTypeAtRow=="3")
         {
            if (parent.parent.isValidCurrency(adjValueAtRow, adjCurrency, langId)==false)
            {
               alertDialog("<%=UIUtil.toJavaScript( (String) contractsRB.get("contractPricingCustomInvalidPrice"))%>");
               parent.getJKIT().isValidated=false;
               return false;
            }
         }
         else
         {
            if (parent.parent.isValidNumber(adjValueAtRow, langId, false) == false)
            {
               alertDialog("<%=UIUtil.toJavaScript( (String) contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
               parent.getJKIT().isValidated=false;
               return false;
            }

            // Make sure the mark down value cann't be over 100%
            if ((adjTypeAtRow == "1") && (adjValueAtRow > 100))
            {
               alertDialog("<%=UIUtil.toJavaScript( (String) contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
               parent.getJKIT().isValidated=false;
               return false;
            }

         }

      }//end-if-rowNode

   }//end-for

   parent.getJKIT().isValidated=true;
   return true;
}



// Initialization
function init()
{
}


// For debug purpose
function showKCPEntryNode(node)
{
   if (node==null) { return; }
   var msg2 = "KCPEntry: compName=" + node.componentName
            + ",ref=" + node.componentReferenceNum
            + ",sku=" + node.sku
            + ",adjValue=" + node.adjustmentValue
            + ",adjType=" + node.adjustmentType;
            + ",adjCurency=" + node.adjustmentCurrency;
   alert(msg2);
}


/*95161*/
function resetRowsBgColor()
{
   for (var j=0; j < document.all.kitComponentListTable.rows.length; j++)
   {
      var myRow = document.all.kitComponentListTable.rows[j];

      if (myRow!=null)
      {
         if ( (j % 2) != 0 )
         {
            myRow.className  = "list_row1";
         }
         else
         {
            myRow.className  = "list_row2";
         }
      }

   }//end-for
}


</script>




</head>

<body onload="init();" class="content" >

<form NAME="ContractKitComponentForm" id="ContractKitComponentForm">


<h1>
<%= ((String)contractsRB.get("KCP_Title"))%>
<script>document.write(': ' + parent.catalogFilterMainFrame.getAttribute("kcpNodeName"));</script>
</h1>
<%= ((String)contractsRB.get("KCP_LabelAdd"))%><br>


<br>
<button id="addKitButton" type="button" value="addKitButton"
        onClick="addButton()"
        class="general"><%=UIUtil.toJavaScript((String)contractsRB.get("KCP_ButtonAdd"))%></button>
&nbsp;
<button id="removeKitButton" type="button" value="removeKitButton" onclick="deleteRowFromKCPList()"
        class="general" disabled><%=UIUtil.toJavaScript((String)contractsRB.get("KCP_ButtonRemove"))%></button>
&nbsp;
<br>
<br>

<script>startKCPListTable();</script>
<script>addKCPListColumnHeading('<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_ColumnComponentName")) %>', true, 'null');</script>
<script>addKCPListColumnHeading('<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_ColumnSKU")) %>', true, 'null');</script>
<script>addKCPListColumnHeading('<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_ColumnPriceAdjustment")) %>', true, 'null');</script>
<script>endKCPListTable();</script>
<script>loadKitPricing();</script>

</form>

</body>
</html>




