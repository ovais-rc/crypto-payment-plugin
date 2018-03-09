<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,

   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.contract.beans.PaymentTCDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingModeDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShipToAddressDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeAdjustmentFilterDataBean,
   com.ibm.commerce.tools.contract.beans.CatalogShippingAdjustmentDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingChargeAdjustmentDataBean,
   com.ibm.commerce.tools.contract.beans.AddressBookTCDataBean,
   com.ibm.commerce.user.beans.AddressDataBean,
   com.ibm.commerce.payment.beans.*,
   com.ibm.commerce.account.util.AccountTCHelper,
   com.ibm.commerce.payment.beans.PaymentPolicyListDataBean,
   com.ibm.commerce.contract.helper.ECContractConstants,   
   com.ibm.commerce.tools.contract.beans.AddressListDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.InvoicingTCDataBean,
   com.ibm.commerce.tools.contract.beans.DisplayCustomizationTCDataBean,
   com.ibm.commerce.tools.contract.beans.PurchaseOrderTCDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">

function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
 }

function changeSpecialText(rawDisplayText, spaces, textOne, textTwo, textThree, textFour) {
    var displayText = rawDisplayText.replace(/%1/, textOne);
    if (textTwo != null)
       displayText = displayText.replace(/%2/, textTwo);
    if (textThree != null)
       displayText = displayText.replace(/%3/, textThree);
    if (textFour != null)
       displayText = displayText.replace(/%4/, textFour);
    if (spaces == true)
       document.writeln("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + displayText);
    else
       document.writeln(displayText);
}

</script>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountSummaryTitle") %></title>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h2><%= contractsRB.get("accountSummaryTitle") %></h2>

<% try {
    AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
    DataBeanManager.activate(account, request);
%>
  <h4><%= contractsRB.get("accountCustomerPanelTitle") %></h4>

   <%= contractsRB.get("summaryAccountCustomerOrganization") %> <i><%= account.getCustomerName() %></i><br>
   <%= contractsRB.get("summaryAccountCustomerContact") %> <i><%= account.getCustomerContactName() %></i><br>
   <%= contractsRB.get("summaryAccountCustomerContactInformation") %> <i><script>document.writeln(decodeNewLinesForHtml('<%= UIUtil.toJavaScript(account.getCustomerContactInformation()) %>'))
</script></i><br>
   <% if (account.getAllowCatalogPurchases() == true) { %>
      <%= contractsRB.get("summaryAccountPurchasesAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryAccountPurchasesNotAllowed") %><br>
   <% } %>
   <%
      String accountName = account.getAccountName();
      if (accountName != null && accountName.indexOf("BaseContracts") >= 0) {
   %>
         <%= contractsRB.get("accountCustomerBaseContracts") %><br>
   <%
      }

      String priceListPref = account.getPriceListPreference();
      if (priceListPref != null && priceListPref.length() > 0) {
         Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", fLocale); 
         int plTypeCount = 0;
         while(true){	
            String option = (String)fixedResourceBundle.get("priceList_internalName_type_" + (plTypeCount + 1));
	    if(option == null){
		break;
	    } else if (option.equals(priceListPref)) {
    %>
    		<%= contractsRB.get("accountCustomerPriceListPreference") %>: <i><%= UIUtil.toJavaScript((String) contractsRB.get("priceList_displayText_type_" + (plTypeCount + 1))) %></i><br>	    
    <%    	if (account.getMustUsePriceListPreference()) {
    %>
    			<%= contractsRB.get("accountCustomerMustUsePriceListPreference") %><br>
    <%		}	
	    	break;
	    }
	    plTypeCount++;				
         }	
      } // end priceListPref
   %>   

  <h4><%= contractsRB.get("accountRepresentativePanelTitle") %></h4>

   <%= contractsRB.get("summaryAccountRepresentativeOrganization") %> <i><%= account.getSellingOrgName() %></i><br>
   <%= contractsRB.get("summaryAccountRepresentativeDepartment") %>
      <% if (account.getRepresentativeName() != null) { %>
         <i><%= account.getRepresentativeName() %></i><br>
      <% } else { %>
         <br>
      <% } %>
   <%= contractsRB.get("summaryAccountRepresentativeRep") %> <i><%= account.getRepresentativeContactName() %></i><br>

<% } catch (Exception e) {
      //out.println(e);
   }
%>



<%
   try
   {
      DisplayCustomizationTCDataBean tc = new DisplayCustomizationTCDataBean(new Long(accountId),
                                                                             new Integer(fLanguageId));
      DataBeanManager.activate(tc, request);
%>

   <h4><%= contractsRB.get("accountDisplayCustomizationTitle") %></h4>

   <%
      if (tc.getHasDisplayLogo())
      {
   %>
         <%= contractsRB.get("summaryDisplayCustomizationLogo") %> <i><%= tc.getAttachment(1).getAttachmentURL() %></i><br>
   <%
      }
     else
      {
   %>
         <%= contractsRB.get("summaryDisplayCustomizationLogo") %> <i></i><br>
   <%
      }
   %>
      <%= contractsRB.get("summaryDisplayCustomizationTextField1") %>
      <% if (tc.getDisplayText(1) != null) { %>
            <i><%= tc.getDisplayText(1) %></i>
      <% } %>
      <br>
      <%= contractsRB.get("summaryDisplayCustomizationTextField2") %>
      <% if (tc.getDisplayText(2) != null) { %>
            <i><%= tc.getDisplayText(2) %></i>
      <% } %>
      <br>
<%
   }
   catch (Exception e)
   {
      //out.println(e);
   }
%>


<% try {
   PurchaseOrderTCDataBean potc = new PurchaseOrderTCDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(potc, request);

   String[] POBNumber = potc.getPOBNumber();
   String[] POLNumber = potc.getPOLNumber();
   String[] POLCurrency = potc.getPOLCurrency();
   String[] POLValue = potc.getPOLValue();
%>
  <h4><%= contractsRB.get("contractPurchaseOrderTitle") %></h4>
   <% if (potc.getPOIndividual() == 1) { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualAllowed") %><br>
      <%= contractsRB.get("summaryPurchaseOrderUniquenessAllowed") %><br>
   <% } else if (potc.getPOIndividual() == 0) { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualAllowed") %><br>
      <%= contractsRB.get("summaryPurchaseOrderUniquenessNotAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualNotAllowed") %><br>
   <% } %>

   <% if (potc.getPOLNumber() != null) {
        for (int i = 0; i < potc.getPOLNumber().length; i++) { %>
      <script>changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryPurchaseOrderSpendingAllowed")) %>',
                  false,
                  '<%= UIUtil.toJavaScript((String)POLNumber[i]) %>',
                  parent.numberToCurrency(<%= POLValue[i] %>, "<%= POLCurrency[i] %>", "<%= fLanguageId %>"),
                  '<%= POLCurrency[i] %>');

</script>
      <br>
   <%   }
      } %>

   <% if (potc.getPOBNumber() != null) {
        for (int i = 0; i < potc.getPOBNumber().length; i++) { %>
      <script>changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryPurchaseOrderSpendingNotAllowed")) %>',
                  false,
                  '<%= UIUtil.toJavaScript((String)POBNumber[i]) %>');

</script>
      <br>
   <%   }
      } %>

<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   InvoicingTCDataBean tc = new InvoicingTCDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(tc, request);
%>
  <h4><%= contractsRB.get("contractInvoicingPanelPrompt") %></h4>
   <% if (!tc.getHasEMail() && !tc.getHasInTheBox() && !tc.getHasRegularMail()) { %>
      <%= contractsRB.get("summaryInvoicingNotAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryInvoicingAllowed") %><br>
      <% if (tc.getHasEMail()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingEmail") %></i><br>
      <% }
         if (tc.getHasInTheBox()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingInTheBox") %></i><br>
      <% }
         if (tc.getHasRegularMail()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingRegularMail") %></i><br>
   <%       }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   PaymentTCDataBean ptc = new PaymentTCDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(ptc, request);
%>
  <h4><%= contractsRB.get("accountFinancialFormPanelTitle") %></h4>
   <%
   String[] paymentPolicyName = ptc.getPolicyName();
   boolean foundCredit = false;
   if(paymentPolicyName.length > 0) {
      for (int loop=0; loop < paymentPolicyName.length; loop++) {
         if (PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[loop])) {
            foundCredit = true;
            break;
         }
      }
   }
   if (foundCredit == true) {
   %>
      <%= contractsRB.get("summaryFinancialCreditLineAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryFinancialCreditLineNotAllowed") %><br>
   <% } %>

<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
      PaymentTCDataBean ptc = new PaymentTCDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(ptc, request);
%>

   <h4><%= contractsRB.get("contractPaymentTitle") %></h4>

   <%
         String[] displayName = ptc.getDisplayName();
         String[] paymentPolicyName = ptc.getPolicyName();
      if (displayName == null || displayName.length == 0 || 
         (displayName.length == 1 && PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[0]))) {
   %>
         <%= contractsRB.get("summaryPaymentListNotAllowed") %><br>
   <%    } else { %>
         <%= contractsRB.get("summaryPaymentList") %><br>
   <%
         for (int i = 0; i < displayName.length; i++) {
            if (!PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[i])) {
   %>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayName[i] %></i><br>
   <%          }
         }
         }

      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(new Long(accountId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_BILLING);
      DataBeanManager.activate(tcDataAdrBook, request);   
      boolean personalAdrBook = tcDataAdrBook.getUsePersonalAddressBook();
      boolean parentAdrBook = tcDataAdrBook.getUseParentOrgAddressBook();
      boolean accountAdrBook = tcDataAdrBook.getUseAccountAddressBook();
      if (personalAdrBook == true || parentAdrBook == true || accountAdrBook == true) {
%>
       <br /><%= contractsRB.get("summaryBillingAddressBooks") %><br />      
<%       if (personalAdrBook == true) { %>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookPersonal") %></i><br />
<%      } %>
<%       if (parentAdrBook == true) { %>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookParent") %></i><br />
<%      } %>
<%       if (accountAdrBook == true) { %>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookAccount") %></i><br />
<%      } %>
<%
      }
%>   
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShippingModeDataBean tcData = new ShippingTCShippingModeDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingModePanelPrompt") %></h4>
   <% if (tcData.getShippingMode().size() == 0) { %>
      <%= contractsRB.get("summaryShippingModesNotAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryShippingModesAllowed") %><br>
   <% for (int i = 0; i < tcData.getShippingMode().size(); i++) {
         Vector tcElement = tcData.getShippingMode(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br>
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShippingChargeDataBean tcData = new ShippingTCShippingChargeDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingChargePanelPrompt") %></h4>
   <% if (tcData.getShippingCharge().size() == 0) { %>
      <%= contractsRB.get("summaryShippingChargeTypeNotAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryShippingChargeTypeAllowed") %><br>
   <%
      for (int i = 0; i < tcData.getShippingCharge().size(); i++) {
         Vector tcElement = tcData.getShippingCharge(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br>
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShipToAddressDataBean tcData = new ShippingTCShipToAddressDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingAddressPanelPrompt") %></h4>
   <% if (tcData.getShippingAddress().size() == 0) { %>
      <%= contractsRB.get("summaryShippingAddressesNotAllowed") %><br>
   <% } else { %>
      <%= contractsRB.get("summaryShippingAddressesAllowed") %><br>

<%
         AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
         DataBeanManager.activate(account, request);
         Long fAccountHolderMemberId = new Long(account.getCustomerId());
         AddressListDataBean addressList = new AddressListDataBean();
         AddressDataBean address[] = null;
         addressList.setMemberId(fAccountHolderMemberId);
         DataBeanManager.activate(addressList, request);
         address = addressList.getAddressList();

         for (int i = 0; i < tcData.getShippingAddress().size(); i++) {
            Vector tcElement = tcData.getShippingAddress(i);

            String addressId = null;
            for (int k = 0; k < address.length; k++) {
               if (address[k].getNickName().equals((String)tcElement.elementAt(1))) {
                  addressId = address[k].getAddressId();
                  break;
               }
            }
            if (addressId != null) {
               AddressDataBean adb = new AddressDataBean();
               adb.setAddressId(addressId);
               adb.setCommandContext(contractCommandContext);
               adb.populate();
               //DataBeanManager.activate(adb, request);
   %>

               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= adb.getNickName() %></i><br>

   <%          String strAddress1 = adb.getAddress1();
               String strAddress2 = adb.getAddress2();
               String strAddress3 = adb.getAddress3();
               String strCity = adb.getCity();
               String strState = adb.getStateProvDisplayName();
               String strCountry = adb.getCountryDisplayName();
               String strZipCode = adb.getZipCode();

               if (strAddress2 == null) strAddress2 = "";
               if (strAddress3 == null) strAddress3 = "";
               if (strState == null) strState = ""; %>

      <%          if (fLocale.toString().equals("ja_JP")||fLocale.toString().equals("ko_KR")||fLocale.toString().equals("zh_CN")||fLocale.toString().equals("zh_TW")) { %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;<%=strZipCode%></i><br>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%><%=strCity%></i><br>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br><br>

      <%       } else if (fLocale.toString().equals("fr_FR")||fLocale.toString().equals("de_DE")){ %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strZipCode%>&nbsp;<%=strCity%></i><br>
                  <% if (fLocale.toString().equals("de_DE")) { %>
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%></i><br>
                  <% } %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br><br>
      <%       } else { %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCity%>&nbsp;<%=strState%>&nbsp;<%=strZipCode%></i> <br>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br><br>
      <%          }
            } // end if addressId
         } // end for
      } // end if
      
      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(new Long(accountId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_SHIPPING);
      DataBeanManager.activate(tcDataAdrBook, request);   
      boolean personalAdrBook = tcDataAdrBook.getUsePersonalAddressBook();
      boolean parentAdrBook = tcDataAdrBook.getUseParentOrgAddressBook();
      boolean accountAdrBook = tcDataAdrBook.getUseAccountAddressBook();
      if (personalAdrBook == true || parentAdrBook == true || accountAdrBook == true) {
%>
	<br><%= contractsRB.get("summaryShippingAddressBooks") %><br>      
<%	if (personalAdrBook == true) { %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookPersonal") %></i><br>
<%      } %>
<%	if (parentAdrBook == true) { %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookParent") %></i><br>
<%      } %>
<%	if (accountAdrBook == true) { %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractShippingAddressBookAccount") %></i><br>
<%      } %>
<%
      }      
            
       %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>
<%//************************************************************************************************************%>

<% try {
     ShippingTCShippingChargeAdjustmentFilterDataBean tcData = new ShippingTCShippingChargeAdjustmentFilterDataBean();
     tcData.setContractId(new Long(accountId));
     tcData.setStoreId(fStoreId);
     DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingChargeAdjustmentTitle") %></h4>
<%   
     if (tcData.getCatalogShippingAdjustments().size() == 0) { 
%>
       <%= contractsRB.get("summaryShippingChargeAdjustmentNotAllowed") %><br />
<%   }
     else {
%>
       <%= contractsRB.get("summaryShippingChargeAdjustmentAllowed") %><br />
<%
       PolicyDataBean pdb = new PolicyDataBean();
       for (int i=0; i<tcData.getCatalogShippingAdjustments().size(); i++) {
         CatalogShippingAdjustmentDataBean csadb = tcData.getCatalogShippingAdjustment(i);
         Vector tcs = csadb.getShippingChargeAdjustmentDataBeans();
         if (tcs != null) {
           for (int j=0; j<tcs.size(); j++) {
             ShippingChargeAdjustmentDataBean scdb = csadb.getShippingChargeAdjustmentDataBean(j); 
             String policyID = scdb.getPolicyId();
             String policyNAME = "";
             if (policyID==null) {
               policyID = ShippingChargeAdjustmentDataBean.POLICY_ALL_SHIPMODES;
               policyNAME = UIUtil.toJavaScript((String)contractsRB.get("allShipmodes"));
             } else {
               pdb.setId(new Long(policyID));
               pdb.setLanguageId(contractCommandContext.getLanguageId());
               DataBeanManager.activate(pdb, request);
               policyNAME = pdb.getShortDescription();
             }
             if (csadb.isFilterType(csadb.FILTER_TYPE_CATALOG)) {
%>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("AdjustmentTargetToEntireOrder") %></i>&nbsp;
<%           } else { %>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=scdb.getReferenceName()%></i>&nbsp;
<%           } %>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=policyNAME%></i>&nbsp; <i>
<%           if (scdb.getAdjustmentType() == scdb.ADJUSTMENT_TYPE_AMOUNT_OFF) { %>
               <script type="text/javascript">
                 document.write(parent.numberToCurrency('<%=scdb.getAdjustmentValue()%>','<%=scdb.getCurrency()%>','<%=fLanguageId%>'));
               </script>
               <%=scdb.getCurrency()%>
<%           } else if (scdb.getAdjustmentType() == scdb.ADJUSTMENT_TYPE_PERCENTAGE_OFF) { %>
               <script type="text/javascript">
                    document.write(parent.numberToStr('<%=scdb.getAdjustmentValue()%>','<%=fLanguageId%>'));
                 </script>
                &nbsp;<%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %>
<%           } %>
             </i>&nbsp;<br />
<%         }
         }
       }
     }  
%>
<% } catch (Exception e) {
      //out.println(e);
   }
%>
<%//end of Shipping charge adjustment TCs%>



<% try {
    AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
    DataBeanManager.activate(account, request);
%>

  <h4><%= contractsRB.get("accountRemarksTitle") %></h4>
   <% if (account.getAccountRemarks() == null || account.getAccountRemarks().length() == 0) { %>
      <%= contractsRB.get("summaryAccountRemarksNotAllowed") %><br>
   <% } else { %>
      <i><script>document.writeln(decodeNewLinesForHtml('<%= UIUtil.toJavaScript(account.getAccountRemarks()) %>'))
</script></i><br>
   <% } %>
   <%
	 	request.setAttribute("summaryTradingId",accountId);
	 	%><jsp:include page="ExtendedTCSummary.jsp"/><% 
   } catch (Exception e) {
      //out.println(e);
   }
%>

</body>
</html>


