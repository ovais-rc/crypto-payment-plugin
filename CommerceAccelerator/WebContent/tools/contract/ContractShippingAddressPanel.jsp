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
      com.ibm.commerce.user.beans.AddressDataBean,
      com.ibm.commerce.user.beans.OrganizationDataBean,
      com.ibm.commerce.contract.helper.ECContractConstants,
      com.ibm.commerce.tools.contract.beans.AddressListDataBean,
      com.ibm.commerce.tools.contract.beans.AccountDataBean,
      com.ibm.commerce.tools.contract.beans.AddressBookTCDataBean,
      com.ibm.commerce.tools.contract.beans.ShippingTCShipToAddressDataBean" %>

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
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractShippingAddressDetailPrompt") %></title>
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
    with (addressSelectionBody.document.addressForm) {
      if (parent.setContentFrameLoaded) {
        parent.setContentFrameLoaded(true);
      }

      if (parent.get) {
        var hereBefore = parent.get("ContractShippingAddressModelLoaded", null);
        if (hereBefore != null) {
     // have been to this page before - load from the model
          var o = parent.get("ContractShippingAddressModel", null);
     if (o != null) {
             loadTextValueSelectValues(SelectedAddresses, o.selectedAddresses);
           loadTextValueSelectValues(AvailableAddresses, o.availableAddresses);
           usePersonal.checked = o.usePersonal;
           useParent.checked = o.useParent;
           useAccount.checked = o.useAccount;
     }
        } else {
     // this is the first time on this page - create the model
          var csm = new ContractShippingAddressModel();

     // initialize available Addresses
     <%
       AddressListDataBean addressList = new AddressListDataBean();
       AddressDataBean address[] = null;
       int numberOfAddress = 0;
       int count = 0;
       int selectSize = 0;
       String name = null;
       String id = null;
       String selectRefNum[] = null;
       Long fAccountHolderMemberId = null;

       try {
           if (editingAccount && !foundAccountId) {
            // new account - page cannot load addresses
           %>
            alertDialog('<%= UIUtil.toJavaScript(contractsRB.get("accountSaveBeforeShippingAddress")) %>');
           <%
           } else {
           // saved account, new contract, or saved contract
           AccountDataBean account = new AccountDataBean(new Long(UIUtil.toHTML(accountId)), new Integer(fLanguageId));
              DataBeanManager.activate(account, request);
           fAccountHolderMemberId = new Long(account.getCustomerId());

           addressList.setMemberId(fAccountHolderMemberId);
        DataBeanManager.activate(addressList, request);
        address = addressList.getAddressList();
        if (address != null) {
         numberOfAddress = address.length;
        }

        // check whether it's an update or a new contract
        if (foundContractId || (editingAccount && foundAccountId) ) {
         // saved contract or saved account
         String tradingId = null;
         if (foundContractId) {
            tradingId = contractId;
         } else {
            tradingId = UIUtil.toHTML(accountId);
         }

         AddressBookTCDataBean bookTcData = new AddressBookTCDataBean(new Long(tradingId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_SHIPPING);
         DataBeanManager.activate(bookTcData, request);
         if (bookTcData.getHasTC()) {
%>
                     csm.hasAddressBookTC = true;
                     csm.addressBookReferenceNumber = '<%= bookTcData.getReferenceNumber() %>';
            usePersonal.checked = <%= bookTcData.getUsePersonalAddressBook() %>;
               useParent.checked = <%= bookTcData.getUseParentOrgAddressBook() %>;
               useAccount.checked = <%= bookTcData.getUseAccountAddressBook() %>;
<%
            }

         String selectName[] = null;
         ShippingTCShipToAddressDataBean tcData = new ShippingTCShipToAddressDataBean(new Long(tradingId), new Integer(fLanguageId));
         DataBeanManager.activate(tcData, request);
         int a = 0;
         int s = 0;

         selectSize = tcData.getShippingAddress().size();
         selectRefNum = new String[selectSize];
         selectName = new String[selectSize];
         for (int i=0; i<selectSize; i++) {
            Vector tcElement = tcData.getShippingAddress(i);
            selectRefNum[i] = (String)tcElement.elementAt(0);
            selectName[i] = (String)tcElement.elementAt(1);
         }
         
         for(int x=0; x<selectSize; x++){
              boolean flag = false;
             for (int y=0; y<numberOfAddress; y++){
            	 name = address[y].getNickName();
           		 id = address[y].getAddressId();
             	 if (name.equals(selectName[x])) {
                     flag = true;
                     break;
                  }
             }
             
              if (flag == true) {
                  out.println("SelectedAddresses.options[" + s + "] = new Option(\"" + UIUtil.toJavaScript(name) + "\",\"" + id + "\", false, false);");
                  s++;
               }
             
         }
         
         
         for (int k=0; k<numberOfAddress; k++) {
            name = address[k].getNickName();
            id = address[k].getAddressId();
            //Long idValue = new Long(id);

            // check if the address is not the default address
            //if (idValue.longValue() >= 0) {
               boolean flag = false;
               for (int j=0; j<selectSize; j++) {
                  if (name.equals(selectName[j])) {
                     flag = true;
                     break;
                  }
               }
               if (flag == false && !"B".equals(address[k].getAddressType())) {
                  out.println("AvailableAddresses.options[" + a + "] = new Option(\"" + UIUtil.toJavaScript(name) + "\",\"" + id + "\", false, false);");
                  a++;
               }
            //} else {
            //   count++;
            //}
         }

        } else {
         // new contract
         int optIndex = 0;
         for (int i=0; i<numberOfAddress; i++) {
            name = address[i].getNickName();
            id = address[i].getAddressId();
            //Long idValue = new Long(id);

            // check if the address is not the default address
            //if (idValue.longValue() >= 0) {
            if(!"B".equals(address[i].getAddressType())){
               out.println("AvailableAddresses.options[" + optIndex + "] = new Option(\"" + UIUtil.toJavaScript(name) + "\",\"" + id + "\", false, false);");
               optIndex++;
            }
            //} else {
            //   count++;
            //}
         }
        }
        } // end if new account
        numberOfAddress = numberOfAddress - count;
       } catch (Exception e) {
       out.println(e.toString());
       }
     %>

     csm.memberId = "<%=fAccountHolderMemberId%>";
     <%
        try {
         OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
         OrgEntityDB.setDataBeanKeyMemberId(fAccountHolderMemberId.toString());
         OrgEntityDB.setCommandContext(contractCommandContext);
         OrgEntityDB.populate();
         //DataBeanManager.activate(OrgEntityDB, request);
         String DN = OrgEntityDB.getDistinguishedName(); %>
         csm.memberDN = "<%= UIUtil.toJavaScript(DN) %>";
        <%
        } catch (Exception e) {
        }
        %>

     csm.initialAddresses = getTextValueSelectValues(SelectedAddresses);
     <% if (selectRefNum != null) {
      for (int h=0; h<selectSize; h++) { %>
        csm.initialRefNum[<%=h%>] = "<%=selectRefNum[h]%>";
        <% }
        } %>
          parent.put("ContractShippingAddressModel", csm);
     parent.put("ContractShippingAddressModelLoaded", true);
      }

      initializeSloshBuckets(SelectedAddresses,
                               removeFromSloshBucketButton,
                               AvailableAddresses,
                               addToSloshBucketButton);

   // save panel data in case of user refresh the panel
      savePanelData();
      }
    }
  }

  function savePanelData() {
    with (addressSelectionBody.document.addressForm) {
      if (parent.get) {
        var o = parent.get("ContractShippingAddressModel", null);
        if (o != null) {
           o.selectedAddresses = getTextValueSelectValues(SelectedAddresses);
           o.availableAddresses = getTextValueSelectValues(AvailableAddresses);
           o.usePersonal = usePersonal.checked;
           o.useParent = useParent.checked;
           o.useAccount = useAccount.checked;
        }
      }
    }
  }

  // This function allows the user select an address and get it's detail at the bottom of the panel
  var name = "";
  function addressDetailChange(name) {

    var sBucket = "sBucket";
    var aBucket = "aBucket";
    var address = null;
    var index, allAddresses;

    if (parent.setContentFrameLoaded) {
        parent.setContentFrameLoaded(false);
    }

    if (name == sBucket) {
      index = addressSelectionBody.document.addressForm.SelectedAddresses.selectedIndex;
      allAddresses = addressSelectionBody.document.addressForm.SelectedAddresses;
    } else if (name == aBucket) {
      index = addressSelectionBody.document.addressForm.AvailableAddresses.selectedIndex;
      allAddresses = addressSelectionBody.document.addressForm.AvailableAddresses;
    } else {
        address="ContractShippingAddressDetailPanelView?AddressId=";
     addressDetailBody.location.replace(address);
    }

    if (index >= 0) {
      //check if there's mulitiple selection in the Bucket
      var count = 0;
      for (var j=0; j<allAddresses.length; j++) {
        if (allAddresses.options[j].selected) {
          count++;
        }
      }
      if (count == 1) {
        if (defined(addressDetailBody.showLoadingMsg)) {
       addressDetailBody.showLoadingMsg(true);
        }
        address = allAddresses.options[index].value;
     addressDetailBody.location.replace("ContractShippingAddressDetailPanelView?AddressId=" + address);
   } else {
        address="ContractShippingAddressDetailPanelView?AddressId=";
     addressDetailBody.location.replace(address);
   }
    } else {
   address="ContractShippingAddressDetailPanelView?AddressId=";
   addressDetailBody.location.replace(address);
    }
  }

  function visibleList (s) {
   if (defined(this.addressSelectionBody) == false || this.addressSelectionBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.addressSelectionBody.visibleList)) {
      this.addressSelectionBody.visibleList(s);
      return;
   }

   if (defined(this.addressSelectionBody.document.forms[0])) {
      for (var i = 0; i < this.addressSelectionBody.document.forms[0].elements.length; i++) {
         if (this.addressSelectionBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.addressSelectionBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }
  }


</script>

</head>

<frameset rows="370,*" frameborder="no" border="0" framespacing="0">
   <frame src="ContractShippingAddressSelectionPanelView" name="addressSelectionBody" title="<%= UIUtil.toJavaScript(contractsRB.get("contractShippingAddressSelectionPanelTitle")) %>" scrolling="auto" noresize>
   <frame src="ContractShippingAddressDetailPanelView?AddressId=" name="addressDetailBody" title="<%= UIUtil.toJavaScript(contractsRB.get("contractShippingAddressDetailPanelTitle")) %>" scrolling="auto" noresize>
</frameset>

</html>
