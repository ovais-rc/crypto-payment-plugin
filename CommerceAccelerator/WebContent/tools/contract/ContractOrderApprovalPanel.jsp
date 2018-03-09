<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2013
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
    com.ibm.commerce.tools.util.*,
    com.ibm.commerce.tools.xml.*,
    com.ibm.commerce.tools.util.UIUtil,
    com.ibm.commerce.beans.DataBeanManager,
    com.ibm.commerce.datatype.TypedProperty,
    com.ibm.commerce.common.objects.StoreAccessBean,
    com.ibm.commerce.tools.contract.beans.OrderApprovalTCDataBean,
    com.ibm.commerce.tools.contract.beans.PolicyDataBean,
    com.ibm.commerce.tools.contract.beans.PolicyListDataBean"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>



<%
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 1 (Specify TC Type ID)
   //
   // After including the ContractCommon.jsp file, please include
   // the following code segment before including the JSP file
   // ContractTCLockCommon.jspf, and change the myContractTCTypeID
   // accordingly.
   //----------------------------------------------------------------
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_ORDER_APPROVAL);
   request.setAttribute("com.ibm.commerce.contract.util.CONTRACT_TCTYPE_ID", myContractTCTypeID);
%>


<%--
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 2 (Manage & Renew Lock)
   //
   // Include the JSP file ContractTCLockCommon.jspf which will
   // perform the checking of the terms and conditions lock for
   // the previously specified contract TC type ID. If necessary,
   // it will renew the lock on the TC for the current logon user.
   // The checking will only be performed in contract change mode.
   //----------------------------------------------------------------
--%>
<%@include file="ContractTCLockCommon.jspf" %>



<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractOrderApprovalHeading") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/OrderApproval.js">
</script>


<script LANGUAGE="JavaScript">
///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
// global contract order approval model...
// there is only one per contract...
var coam;





///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////
function onLoad() {
   if (! parent.get) {
       // alert('No model found!');
       return;
   }

   if (parent.setContentFrameLoaded) {
       parent.setContentFrameLoaded(true);
   }

   // check to see if the model has already been loaded...
   var isModelLoaded = parent.get("ContractOrderApprovalModelLoaded", null);

   if (isModelLoaded) {
       // alert('Contract Order Approval - Reloading Page - Using stored model...');

       // get the model
       coam = parent.get("ContractOrderApprovalModel", null);

       // populate the fields on this page using the model
       if (coam == null) {
          // alert('Fatal Error: No model found!');
          return;
       }
   }
   else {
       // alert('Contract Order Approval - First visit! - Creating a new model...');

       // create a contract price list model which will store an array of price TCs
       coam = new ContractOrderApprovalModel();

       // persist the model
       parent.put("ContractOrderApprovalModel", coam);

       // set the loaded flag to true, as processing is different if this page is reloaded...
       parent.put("ContractOrderApprovalModelLoaded", true);

   // check if this is an update
   if (<%= foundContractId %> == true) {
      //alert('Load from the databean');
      // load the data from the databean
      <%
      // Create an instance of the databean to use if we are doing an update
      if (foundContractId) {
         OrderApprovalTCDataBean tc = new OrderApprovalTCDataBean(new Long(contractId), new Integer(fLanguageId));
         DataBeanManager.activate(tc, request);
         if (tc.getHasOrderApproval()) {
            out.println("coam.contractHasOrderApproval = true;");
            out.println("coam.orderApprovalRequiredSwitch = true;");
            out.println("coam.referenceNumber = '" + tc.getReferenceNumber() + "';");
            out.println("coam.contractMinimumAmountValue = '" + tc.getValue() + "';");
            out.println("coam.orderApprovalMinimumAmountValue = '" + tc.getValue() + "';");
            out.println("coam.contractMinimumAmountCurrency = '" + tc.getCurrency() + "';");
            out.println("coam.orderApprovalMinimumAmountCurrency = '" + tc.getCurrency() + "';");
         }
      }
      %>
   }

   }

   loadPanelData();

   // show the divisions
   showDivisions();

    // handle error messages back from the validate page
    if (parent.get("contractOrderApprovalSpecifyCurrency", false))
     {
      parent.remove("contractOrderApprovalSpecifyCurrency");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractOrderApprovalSpecifyCurrency"))%>");
     }
    else if (parent.get("contractOrderApprovalSpecifyCurrencyValue", false))
     {
      parent.remove("contractOrderApprovalSpecifyCurrencyValue");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractOrderApprovalSpecifyCurrencyValue"))%>");
     }


<%--
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 3 (Handling Lock Status)
   //
   // The handlTCLockStatus function will take care of the locking
   // status for the terms and conditions. According to the status
   // and system configuration, it will display various dialogs
   // to the end user. Before invoking the handleTCLockStatus()
   // function, some parameters are required. Please refer to the
   // ContractTCLockCommon.jspf for details.
   //----------------------------------------------------------------
--%>
   var myFormNames = new Array();
   myFormNames[0]  = "orderApprovalRequiredSwitchForm";
   myFormNames[1]  = "orderApprovalMinimumAmountSwitchForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("OrderApprovalTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OrderApproval")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      5);

   return;
}

function loadPanelData() {
    // set all the checkbox switches
    document.orderApprovalRequiredSwitchForm.orderApprovalRequiredSwitch.checked = coam.orderApprovalRequiredSwitch;

    var minValue = parent.numberToStr(coam.orderApprovalMinimumAmountValue, <%= fLanguageId %>, 0);
    if (minValue.toString() == "NaN") {
   document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountValue.value = coam.orderApprovalMinimumAmountValue;
    } else {
   document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountValue.value = minValue;
    }

    // set all the the pulldowns
    loadSelectValue(document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountCurrency,
                    coam.orderApprovalMinimumAmountCurrency);
}

function savePanelData() {
    coam.orderApprovalRequiredSwitch = document.orderApprovalRequiredSwitchForm.orderApprovalRequiredSwitch.checked;

    coam.orderApprovalMinimumAmountValue = document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountValue.value;

    var selectedActionIndex = document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountCurrency.selectedIndex;
    coam.orderApprovalMinimumAmountCurrency = document.orderApprovalMinimumAmountSwitchForm.orderApprovalMinimumAmountCurrency.options[selectedActionIndex].value;

    // alert('Saved OA TC Model\n'+dumpObject(coam));
}

///////////////////////////////////////
// BUTTON ACTION SCRIPTS
///////////////////////////////////////
function showDivisions() {
   document.all.orderApprovalRequiredSwitchDiv.style.display = "block";

   document.all.orderApprovalMinimumAmountSwitchDiv.style.display =
              getDivisionStatus(document.orderApprovalRequiredSwitchForm.orderApprovalRequiredSwitch.checked);

}


</script>

</head>

<!--
///////////////////////////////////////
// HTML SECTION
///////////////////////////////////////
-->

<body onLoad="onLoad()" class="content">

   <h1>
   <%= contractsRB.get("contractOrderApprovalHeading") %>
   </h1>

    <!-- ################################################################################# -->
    <!-- ORDER APPROVAL DIVISION -->
    <!-- ################################################################################# -->
    <div id="orderApprovalRequiredSwitchDiv" style="display: block; margin-left: 0">

    <form name="orderApprovalRequiredSwitchForm" id="orderApprovalRequiredSwitchForm">
      <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractOrderApprovalPanel_Table_1">
      <tr>
       <td width="20" align="left" id="ContractOrderApprovalPanel_TableCell_1"><input type=checkbox name=orderApprovalRequiredSwitch onClick='showDivisions();' id="ContractOrderApprovalPanel_FormInput_orderApprovalRequiredSwitch_In_orderApprovalRequiredSwitchForm_1"></td>
       <td width="500" align="left" id="ContractOrderApprovalPanel_TableCell_2"><label for="ContractOrderApprovalPanel_FormInput_orderApprovalRequiredSwitch_In_orderApprovalRequiredSwitchForm_1"><%= contractsRB.get("orderApprovalRequiredSwitchLabel") %></label></td>
      </tr>
     </table>
    </form>

    <div id="orderApprovalMinimumAmountSwitchDiv" style="display: block; margin-left: 20">
    <form name="orderApprovalMinimumAmountSwitchForm" id="orderApprovalMinimumAmountSwitchForm">
     <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractOrderApprovalPanel_Table_2">
      <tr valign="top">
       <td width="20" id="ContractOrderApprovalPanel_TableCell_3">&nbsp;&nbsp;</td>
       <td width="500" align="left" id="ContractOrderApprovalPanel_TableCell_4">
       <table id="ContractOrderApprovalPanel_Table_3">
      <tr>
      <td id="ContractOrderApprovalPanel_TableCell_5"><label for="ContractOrderApprovalPanel_FormInput_orderApprovalMinimumAmountValue_In_orderApprovalMinimumAmountSwitchForm_1"><label for="ContractOrderApprovalPanel_FormInput_orderApprovalMinimumAmountCurrency_In_orderApprovalMinimumAmountSwitchForm_1"><%= contractsRB.get("orderApprovalAmountLabel") %></label></label></td>
      </tr>
      <tr>
               <td id="ContractOrderApprovalPanel_TableCell_6"><input type=text name=orderApprovalMinimumAmountValue value="" size=10 maxlength=10 id="ContractOrderApprovalPanel_FormInput_orderApprovalMinimumAmountValue_In_orderApprovalMinimumAmountSwitchForm_1">
      &nbsp;&nbsp;
               <select id="ContractOrderApprovalPanel_FormInput_orderApprovalMinimumAmountCurrency_In_orderApprovalMinimumAmountSwitchForm_1" size=1 name=orderApprovalMinimumAmountCurrency >
      <script>
      var ccdm = parent.get("ContractCommonDataModel");
      for (i = 0; i < ccdm.storeCurrArray.length; i++)
         document.write('<OPTION value="' + ccdm.storeCurrArray[i] + '">' + ccdm.storeCurrArray[i] + '</OPTION>');

</script>
               </select>
         </td>
      </tr>
      </table>
       </td>
      </tr>
     </table>
    </form>
    </div>

    </div><!-- ORDER APPROVAL DIVISION -->


</body>
</html>


