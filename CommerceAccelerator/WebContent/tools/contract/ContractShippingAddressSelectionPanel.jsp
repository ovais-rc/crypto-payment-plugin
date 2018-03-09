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
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.user.beans.AddressDataBean,
      com.ibm.commerce.tools.contract.beans.AddressListDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   // Create an instance of the databean to use if we are doing an update
%>

<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 300px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractShippingAddressPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Shipping.js">
</script>

 <script LANGUAGE="JavaScript">

  function addToSelectedAddresses() {
    with (document.addressForm) {
      move(AvailableAddresses, SelectedAddresses);
      updateSloshBuckets(AvailableAddresses,
                         addToSloshBucketButton,
                         SelectedAddresses,
                         removeFromSloshBucketButton);
    }
  }

  function removeFromSelectedAddresses() {
    with (document.addressForm) {
      move(SelectedAddresses, AvailableAddresses);
      updateSloshBuckets(SelectedAddresses,
                         removeFromSloshBucketButton,
                         AvailableAddresses,
                         addToSloshBucketButton);
    }
  }


/*90288*/
//------------------------------------------------------------------------
// Function Name: disableMyFormsElements
//
// This function disables all the elements in the forms, so that user
// will not able to change any current contents to the forms fields.
//------------------------------------------------------------------------
function disableMyFormsElements()
{
   for (var i=0; i<document.addressForm.elements.length; i++)
   {
      document.addressForm.elements[i].disabled = true;
   }
}

function loadPanelData()
{
   parent.loadPanelData();


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
   // ContractTCLockCommon.jsp for details.
   //----------------------------------------------------------------
--%>
   var contractCommonDataModel = parent.parent.get("ContractCommonDataModel", null);

   parent.handleTCLockStatus("ShippingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Shipping")) %>",
                      "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_SHIPPING %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      null,
                      2);


   // Disallow user to change any fields only if the shipping TC lock info
   // is existed and the tcLockInfo object attribute 'shouldTCbeSaved'
   // is set to false.
   if (contractCommonDataModel!=null)
   {
      if (contractCommonDataModel.tcLockInfo["ShippingTC"]!=null)
      {
         if (!contractCommonDataModel.tcLockInfo["ShippingTC"].shouldTCbeSaved) { disableMyFormsElements(); }
      }
   }
}

</script>

</head>

<body ONLOAD="loadPanelData();" class="content">

<h1><%= contractsRB.get("contractShippingAddressPanelPrompt") %></h1>

<form NAME="addressForm" id="addressForm">
<script>
   var base = parent.parent.get("baseContract", null);
   if (base != null && base == "true") {
      document.write ("<%=UIUtil.toJavaScript(contractsRB.get("contractShippingAddressNotForBaseContracts"))%>");
   } else {
     var o = parent.parent.get("AccountCustomerModel");
     if (o != null && o.forBaseContracts) {
   document.write ("<%=UIUtil.toJavaScript(contractsRB.get("contractShippingAddressNotForBaseAccounts"))%>");
     }
   }
</script>

<table border=0 id="ContractShippingAddressSelectionPanel_Table_1">
 <tr>
  <td width=160 id="ContractShippingAddressSelectionPanel_TableCell_1"></td>
  <td width=70 id="ContractShippingAddressSelectionPanel_TableCell_2"></td>
  <td width=10 id="ContractShippingAddressSelectionPanel_TableCell_3"></td>
  <td width=160 id="ContractShippingAddressSelectionPanel_TableCell_4"></td>
 </tr>

 <tr>
  <td valign='top' id="ContractShippingAddressSelectionPanel_TableCell_5">
    <label for="ContractShippingAddressSelectionPanel_FormInput_SelectedAddresses_In_addressForm_1"><%= contractsRB.get("contractShippingAddressSelected") %></label><br>
    <select id="ContractShippingAddressSelectionPanel_FormInput_SelectedAddresses_In_addressForm_1" NAME="SelectedAddresses" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="parent.addressDetailChange('sBucket');javascript:updateSloshBuckets(this, document.addressForm.removeFromSloshBucketButton, document.addressForm.AvailableAddresses, document.addressForm.addToSloshBucketButton);">
    </select>
  </td>
  <td width=100px id="ContractShippingAddressSelectionPanel_TableCell_6">
  <table cellpadding="2" cellspacing="2">
  <tr><td>
    <input TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedAddresses();parent.addressDetailChange('');"
           id="ContractShippingAddressSelectionPanel_FormInput_1" >
   </td></tr>
   <tr><td>
    <input TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedAddresses();parent.addressDetailChange('');"
           id="ContractShippingAddressSelectionPanel_FormInput_2" >
   </td></tr>
   </table>
  </td>
  <td width=10 id="ContractShippingAddressSelectionPanel_TableCell_7"></td>
  <td valign='top' id="ContractShippingAddressSelectionPanel_TableCell_8">
    <label for="ContractShippingAddressSelectionPanel_FormInput_AvailableAddresses_In_addressForm_1"><%= contractsRB.get("contractShippingAddressAvailable") %></label><br>
    <select id="ContractShippingAddressSelectionPanel_FormInput_AvailableAddresses_In_addressForm_1" NAME="AvailableAddresses" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="parent.addressDetailChange('aBucket');javascript:updateSloshBuckets(this, document.addressForm.addToSloshBucketButton, document.addressForm.SelectedAddresses, document.addressForm.removeFromSloshBucketButton);">
    </select>
  </td>
 </tr>
 <tr>
   <td colspan=4>
   <br><label for="ContractShippingAddressSelectionPanel_FormInput_contractShippingAddressBookDescription_In_addressForm_1"><%= contractsRB.get("contractShippingAddressBookDescription") %></label>
   </td>
 </tr>
  <tr>
  <td colspan=4 id="ContractShippingAddressSelectionPanel_TableCell_9">
    <input NAME="usePersonal" TYPE="CHECKBOX" id="ContractShippingAddressSelectionPanel_FormInput_usePersonal_In_infoForm_1"><label for="ContractShippingAddressSelectionPanel_FormInput_usePersonal_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookPersonal") %></label><br>
    <input NAME="useParent"   TYPE="CHECKBOX" id="ContractShippingAddressSelectionPanel_FormInput_useParent_In_infoForm_1"><label for="ContractShippingAddressSelectionPanel_FormInput_useParent_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookParent") %></label><br>
    <input NAME="useAccount"  TYPE="CHECKBOX" id="ContractShippingAddressSelectionPanel_FormInput_useAccount_In_infoForm_1"><label for="ContractShippingAddressSelectionPanel_FormInput_useAccount_In_infoForm_1"><%= contractsRB.get("contractShippingAddressBookAccount") %></label>
  </td>
 </tr>
</table>

</form>
</body>
</html>
