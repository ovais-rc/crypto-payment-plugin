<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.tools.contract.beans.PolicyDataBean,
      com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
      com.ibm.commerce.tools.contract.beans.MemberDataBean,
      com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeDataBean" %>

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
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_SHIPPING);
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
 <style type='text/css'>
 .selectWidth { width: 300px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractShippingChargePanelTitle") %></title>
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



  function loadPanelData() {
    with (document.chargeForm) {
      if (parent.setContentFrameLoaded) {
        parent.setContentFrameLoaded(true);
      }

      if (parent.get) {
        var hereBefore = parent.get("ContractShippingChargeModelLoaded", null);
        if (hereBefore != null) {
          // have been to this page before - load from the model
          //alert('charge type - back to same page - load from model');
          var o = parent.get("ContractShippingChargeModel", null);
          if (o != null) {
             loadTextValueSelectValues(SelectedCharges, o.selectedCharges);
             loadTextValueSelectValues(AvailableCharges, o.availableCharges);
          }
       } else {
         <%
           // load the policies from the database
           PolicyListDataBean policyList = new PolicyListDataBean();
           String policyType = policyList.TYPE_SHIPPING_CHARGE;
           PolicyDataBean policy[] = null;
           int selectSize = 0;
           String selectRefNum[] = null;
           Long id = null;
           Long selectId[] = null;
           try {
            policyList.setPolicyType(policyType);
            DataBeanManager.activate(policyList, request);
            policy = policyList.getPolicyList();
         %>
            var chargePolicyList = new Array();
         <%
            for (int i = 0; i < policy.length; i++) {
                     MemberDataBean mdb = new MemberDataBean();
                     mdb.setId(policy[i].getStoreMemberId());
                     DataBeanManager.activate(mdb, request);
         %>
               chargePolicyList[chargePolicyList.length] =
                                                                    new PolicyObject('<%=UIUtil.toJavaScript(policy[i].getShortDescription())%>',
                                                                                 '<%= UIUtil.toJavaScript(policy[i].getPolicyName()) %>',
                                                                                 '<%= policy[i].getId() %>',
                                                                                 '<%= UIUtil.toJavaScript(policy[i].getStoreIdentity()) %>',
                                                                                 new Member('<%= mdb.getMemberType() %>',
                                                                                            '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                                                            '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                                                            '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                                                            '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>')
                           );
         <%
            }
            // check whether it's an update or a new contract
            if (foundContractId || (editingAccount && foundAccountId) ) {
               String tradingId = null;
               if (foundContractId) {
                  tradingId = contractId;
               } else {
                  tradingId = accountId;
               }
               ShippingTCShippingChargeDataBean tcData = new ShippingTCShippingChargeDataBean(new Long(tradingId), new Integer(fLanguageId));
               DataBeanManager.activate(tcData, request);

               selectSize = tcData.getShippingCharge().size();
               selectRefNum = new String[selectSize];
               selectId = new Long[selectSize];
               for (int i=0; i<selectSize; i++) {
                  Vector tcElement = tcData.getShippingCharge(i);
                  selectRefNum[i] = (String)tcElement.elementAt(0);
                  selectId[i] = new Long((String)tcElement.elementAt(1));
               }

         %>
         var a = 0;
         var s = 0;
       
         <%
         for(int  x=0; x< selectSize; x++){
           %>
           
            var flag = false;
            var index = 0;
            for(var y=0; y< chargePolicyList.length; y++){
          
             if (chargePolicyList[y].policyId == "<%= selectId[x] %>") {
                  flag = true;
                  index = y;
               }
            }
           
          if (flag == true) {
        
             SelectedCharges.options[s++] = new Option(chargePolicyList[index].displayText,
             chargePolicyList[index].policyName, false, false);
            
            }
         <%
         }
         %>
         
        
         for (var k=0; k<chargePolicyList.length; k++) {
         
            var flag = false;
   <%
            for (int j=0; j < selectSize; j++) {
   %>
               if (chargePolicyList[k].policyId == "<%= selectId[j] %>") {
                  flag = true;
               }
   <%
            }
   %>
            if (flag == false) {
             AvailableCharges.options[a++] = new Option(chargePolicyList[k].displayText,
                              chargePolicyList[k].policyName, false, false);
            } 
         }
   <%
            } else {
   %>
               for (var k=0; k<chargePolicyList.length; k++) {
                     AvailableCharges.options[k] = new Option(chargePolicyList[k].displayText,
                           chargePolicyList[k].policyName, false, false);
               }
   <%
            }
       } catch (Exception e) {
       }
       %>
         // this is the first time on this page - create the model
         var csm = new ContractShippingChargeModel();
         csm.policyType = "<%=policyType%>";
         csm.storeId = "<%=fStoreId%>";
         csm.policyList = chargePolicyList;
         csm.initialCharges = getTextValueSelectValues(SelectedCharges);
     <%  if (selectRefNum != null) {
            for (int h=0; h<selectSize; h++) { %>
               csm.initialRefNum[<%=h%>] = "<%=selectRefNum[h]%>";
        <%  }
         } %>
         parent.put("ContractShippingChargeModel", csm);
         parent.put("ContractShippingChargeModelLoaded", true);
      } // end hereBefore

      initializeSloshBuckets(SelectedCharges,
                               removeFromSloshBucketButton,
                               AvailableCharges,
                               addToSloshBucketButton);

      // save panel data in case of user refresh the panel
      savePanelData();

      } // end parent.get
    } // end with


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
   myFormNames[0]  = "chargeForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("ShippingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Shipping")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      2);


  }

  function savePanelData() {
    //alert ('Shipping Charge savePanelData');
    with (document.chargeForm) {
      if (parent.get) {
        var o = parent.get("ContractShippingChargeModel", null);
        if (o != null) {
           o.selectedCharges = getTextValueSelectValues(SelectedCharges);
           o.availableCharges = getTextValueSelectValues(AvailableCharges);
        }
      }
    }
  }

  function addToSelectedCharges() {
    with (document.chargeForm) {
      move(AvailableCharges, SelectedCharges);
      updateSloshBuckets(AvailableCharges,
                         addToSloshBucketButton,
                         SelectedCharges,
                         removeFromSloshBucketButton);
    }
  }

  function removeFromSelectedCharges() {
    with (document.chargeForm) {
      move(SelectedCharges, AvailableCharges);
      updateSloshBuckets(SelectedCharges,
                         removeFromSloshBucketButton,
                         AvailableCharges,
                         addToSloshBucketButton);
    }
  }

</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractShippingChargePanelPrompt") %></h1>

<form NAME="chargeForm" id="chargeForm">

<table border=0 id="ContractShippingChargePanel_Table_1">
 <tr>
  <td width=160 id="ContractShippingChargePanel_TableCell_1"></td>
  <td width=70 id="ContractShippingChargePanel_TableCell_2"></td>
  <td width=10 id="ContractShippingChargePanel_TableCell_3"></td>
  <td width=160 id="ContractShippingChargePanel_TableCell_4"></td>
 </tr>

 <tr>
  <td valign='top' id="ContractShippingChargePanel_TableCell_5">
    <label for="ContractShippingChargePanel_FormInput_SelectedCharges_In_chargeForm_1"><%= contractsRB.get("contractShippingChargesSelected") %></label><br>
    <select id="ContractShippingChargePanel_FormInput_SelectedCharges_In_chargeForm_1" NAME="SelectedCharges" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.chargeForm.removeFromSloshBucketButton, document.chargeForm.AvailableCharges, document.chargeForm.addToSloshBucketButton);">
    </select>
  </td>
  <td width=100px id="ContractShippingChargePanel_TableCell_6">
   <table cellpadding="2" cellspacing="2">
   <tr><td>
    <input TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedCharges()"
           id="ContractShippingChargePanel_FormInput_1">
   </td></tr>
   <tr><td>
    <input TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedCharges()"
           id="ContractShippingChargePanel_FormInput_2">
   </td></tr>
   </table>
  </td>
  <td width=10 id="ContractShippingChargePanel_TableCell_7"></td>
  <td valign='top' id="ContractShippingChargePanel_TableCell_8">
    <label for="ContractShippingChargePanel_FormInput_AvailableCharges_In_chargeForm_1"><%= contractsRB.get("contractShippingChargesAvailable") %></label><br>
    <select id="ContractShippingChargePanel_FormInput_AvailableCharges_In_chargeForm_1" NAME="AvailableCharges" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.chargeForm.addToSloshBucketButton, document.chargeForm.SelectedCharges, document.chargeForm.removeFromSloshBucketButton);">
    </select>
  </td>
 </tr>
</table>

</form>
</body>
</html>
