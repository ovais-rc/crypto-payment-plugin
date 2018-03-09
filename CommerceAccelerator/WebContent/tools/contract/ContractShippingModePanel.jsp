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
      com.ibm.commerce.tools.contract.beans.ShippingTCShippingModeDataBean" %>

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

 <title><%= contractsRB.get("contractShippingModePanelTitle") %></title>
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
    with (document.modeForm) {
      if (parent.setContentFrameLoaded) {
        parent.setContentFrameLoaded(true);
      }

      if (parent.get) {
        var hereBefore = parent.get("ContractShippingModeModelLoaded", null);
        if (hereBefore != null) {
     // have been to this page before - load from the model
          var o = parent.get("ContractShippingModeModel", null);
     if (o != null) {
             loadTextValueSelectValues(SelectedModes, o.selectedModes);
           loadTextValueSelectValues(AvailableModes, o.availableModes);
     }
        } else {

          <%

          PolicyListDataBean policyList = new PolicyListDataBean();
     PolicyDataBean policy[] = null;
     int selectSize = 0;
     String selectRefNum[] = null;
     String policyType = policyList.TYPE_SHIPPING_MODE;
     Long id = null;
     Long selectId[] = null;

     try {
         policyList.setPolicyType(policyType);
         DataBeanManager.activate(policyList, request);
      policy = policyList.getPolicyList();
   %>
      var providerPolicyList = new Array();
   <%
      for (int i = 0; i < policy.length; i++) {
                  MemberDataBean mdb = new MemberDataBean();
             mdb.setId(policy[i].getStoreMemberId());
             DataBeanManager.activate(mdb, request);
   %>
         providerPolicyList[providerPolicyList.length] =
                                      new PolicyObject('<%= UIUtil.toJavaScript(policy[i].getShortDescription()) %>',
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
         ShippingTCShippingModeDataBean tcData = new ShippingTCShippingModeDataBean(new Long(tradingId), new Integer(fLanguageId));
         DataBeanManager.activate(tcData, request);

         selectSize = tcData.getShippingMode().size();
         selectRefNum = new String[selectSize];
         selectId = new Long[selectSize];
         for (int i=0; i<selectSize; i++) {
            Vector tcElement = tcData.getShippingMode(i);
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
            for(var y=0; y< providerPolicyList.length; y++){
          
             if (providerPolicyList[y].policyId == "<%= selectId[x] %>") {
                  flag = true;
                  index = y;
               }
            }
           
          if (flag == true) {
        
             SelectedModes.options[s++] = new Option(providerPolicyList[index].displayText,
             providerPolicyList[index].policyName, false, false);
            
            }
         <%
         }
         %>
         
        
         for (var k=0; k<providerPolicyList.length; k++) {
         
            var flag = false;
   <%
            for (int j=0; j < selectSize; j++) {
   %>
               if (providerPolicyList[k].policyId == "<%= selectId[j] %>") {
                  flag = true;
               }
   <%
            }
   %>
            if (flag == false) {
             AvailableModes.options[a++] = new Option(providerPolicyList[k].displayText,
                              providerPolicyList[k].policyName, false, false);
            } 
         }
   <%
      } else {
   %>
         for (var k=0; k<providerPolicyList.length; k++) {
            AvailableModes.options[k] = new Option(providerPolicyList[k].displayText,
                           providerPolicyList[k].policyName, false, false);
         }
   <%
      }

     } catch (Exception e) {
     }%>

     // this is the first time on this page - create the model
          var csm = new ContractShippingModeModel();
        csm.policyType = "<%=policyType%>";
     csm.storeId = "<%=fStoreId%>";
     csm.policyList = providerPolicyList;
        csm.initialModes = getTextValueSelectValues(SelectedModes);
     <% if (selectRefNum != null) {
      for (int h=0; h<selectSize; h++) { %>
        csm.initialRefNum[<%=h%>] = "<%=selectRefNum[h]%>";
        <% }
        } %>
          parent.put("ContractShippingModeModel", csm);
     parent.put("ContractShippingModeModelLoaded", true);
      }

      initializeSloshBuckets(SelectedModes,
                               removeFromSloshBucketButton,
                               AvailableModes,
                               addToSloshBucketButton);

   // save panel data in case of user refresh the panel
      savePanelData();

      }
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
   myFormNames[0]  = "modeForm";
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
    //alert ('Shipping Mode savePanelData');
    with (document.modeForm) {
      if (parent.get) {
        var o = parent.get("ContractShippingModeModel", null);
        if (o != null) {
           o.selectedModes = getTextValueSelectValues(SelectedModes);
           o.availableModes = getTextValueSelectValues(AvailableModes);
        }
      }
    }
  }


  function addToSelectedModes() {
    with (document.modeForm) {
      move(AvailableModes, SelectedModes);
      updateSloshBuckets(AvailableModes,
                         addToSloshBucketButton,
                         SelectedModes,
                         removeFromSloshBucketButton);
    }
  }

  function removeFromSelectedModes() {
    with (document.modeForm) {
      move(SelectedModes, AvailableModes);
      updateSloshBuckets(SelectedModes,
                         removeFromSloshBucketButton,
                         AvailableModes,
                         addToSloshBucketButton);
    }
  }


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractShippingModePanelPrompt") %></h1>

<form NAME="modeForm" id="modeForm">

<table border=0 id="ContractShippingModePanel_Table_1">
 <tr>
  <td width=160 id="ContractShippingModePanel_TableCell_1"></td>
  <td width=70 id="ContractShippingModePanel_TableCell_2"></td>
  <td width=10 id="ContractShippingModePanel_TableCell_3"></td>
  <td width=160 id="ContractShippingModePanel_TableCell_4"></td>
 </tr>

 <tr>
  <td valign='top' id="ContractShippingModePanel_TableCell_5">
    <label for="ContractShippingModePanel_FormInput_SelectedModes_In_modeForm_1"><%= contractsRB.get("contractShippingModeSelected") %></label><br>
    <select id="ContractShippingModePanel_FormInput_SelectedModes_In_modeForm_1" NAME="SelectedModes" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.modeForm.removeFromSloshBucketButton, document.modeForm.AvailableModes, document.modeForm.addToSloshBucketButton);">
    </select>
  </td>
  <td width=100px id="ContractShippingModePanel_TableCell_6">
  <table cellpadding="2" cellspacing="2">
  <tr><td>
    <input TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedModes()"
           id="ContractShippingModePanel_FormInput_1">
   </td></tr>
   <tr><td>
    <input TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedModes()"
           id="ContractShippingModePanel_FormInput_2">
   </td></tr>
   </table>
  </td>
  <td width=10 id="ContractShippingModePanel_TableCell_7"></td>
  <td valign='top' id="ContractShippingModePanel_TableCell_8">
    <label for="ContractShippingModePanel_FormInput_AvailableModes_In_modeForm_1"><%= contractsRB.get("contractShippingModeAvailable") %></label><br>
    <select id="ContractShippingModePanel_FormInput_AvailableModes_In_modeForm_1" NAME="AvailableModes" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.modeForm.addToSloshBucketButton, document.modeForm.SelectedModes, document.modeForm.removeFromSloshBucketButton);">
    </select>
  </td>
 </tr>
</table>

</form>
</body>
</html>
