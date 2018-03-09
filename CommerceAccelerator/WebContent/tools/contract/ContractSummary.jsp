
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.common.objects.StoreAccessBean,
   com.ibm.commerce.common.beans.StoreDataBean,
   com.ibm.commerce.catalog.beans.CatalogDataBean,
   com.ibm.commerce.user.beans.AddressDataBean,
   com.ibm.commerce.contract.objects.ContractAccessBean,
   com.ibm.commerce.tools.contract.beans.AddressListDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.CategoryPricingTCDataBean,
   com.ibm.commerce.tools.contract.beans.CustomPricingTCDataBean,
   com.ibm.commerce.tools.contract.beans.OrderApprovalTCDataBean,
   com.ibm.commerce.tools.contract.beans.ReturnTCDataBean,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.contract.objects.TradingAgreementAccessBean,
   com.ibm.commerce.contract.objects.TermConditionAccessBean,
   com.ibm.commerce.contract.objects.ReferralInterfaceTCAccessBean,
   com.ibm.commerce.contract.objects.BusinessPolicyAccessBean,
   com.ibm.commerce.tools.contract.beans.CatalogFilterDataBean,
   com.ibm.commerce.tools.contract.beans.PriceTCMasterCatalogWithFilteringDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingModeDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShipToAddressDataBean,
   com.ibm.commerce.tools.contract.beans.AddressBookTCDataBean,
   com.ibm.commerce.tools.contract.beans.HandlingChargeTCDataBean,
   com.ibm.commerce.tools.contract.beans.InvoicingTCDataBean,
   com.ibm.commerce.tools.contract.beans.PurchaseOrderTCDataBean,
   com.ibm.commerce.tools.contract.beans.ProductSetTCDataBean,
   com.ibm.commerce.tools.contract.beans.CustomProductSetDataBean,
   com.ibm.commerce.tools.contract.beans.DisplayCustomizationTCDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeAdjustmentFilterDataBean,
   com.ibm.commerce.tools.contract.beans.CatalogShippingAdjustmentDataBean,
   com.ibm.commerce.tools.contract.beans.ShippingChargeAdjustmentDataBean,
   com.ibm.commerce.account.util.AccountTCHelper,
   com.ibm.commerce.contract.helper.ECContractConstants,
   com.ibm.commerce.catalog.objects.ItemAccessBean,
   com.ibm.commerce.catalog.objects.CatalogEntryAccessBean,
   com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean,
   com.ibm.commerce.catalog.objects.CatalogGroupAccessBean,
   com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean,
   com.ibm.commerce.catalog.beans.CatalogEntryDataBean,
   com.ibm.commerce.tools.catalog.beans.CatalogGroupDataBean,
   com.ibm.commerce.tools.contract.beans.PaymentTCDataBean,
   com.ibm.commerce.utils.TimestampHelper,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.price.utils.*,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.user.objects.OrganizationAccessBean,
   com.ibm.commerce.user.objects.MemberAccessBean,
   com.ibm.commerce.contract.objects.ParticipantAccessBean,
   com.ibm.commerce.contract.helper.ContractUtil,
   com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.context.content.resources.ManagedResourceKey,
   com.ibm.commerce.context.content.resources.ResourceManager,
   com.ibm.commerce.context.content.locking.LockData,
   com.ibm.commerce.contract.content.resources.ContractContainer,
   com.ibm.commerce.user.beans.UserDataBean,
   com.ibm.commerce.payment.beans.PaymentPolicyListDataBean,
   com.ibm.commerce.contract.util.*" %>

<%@page import="com.ibm.commerce.contract.objects.TermConditionAccessBean,
      com.ibm.commerce.contract.objects.PriceTCConfigBuildBlockAccessBean,
      com.ibm.commerce.contract.objects.ComponentAdjustmentAccessBean,
      com.ibm.commerce.contract.objects.ComponentOfferAccessBean"
%>



<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%

try {

   //get contract Usage parameter
   String usageParm = request.getParameter("contractUsage");
   if(usageParm == null || usageParm.length() == 0){
      usageParm = "1";
   }
   Integer usage = new Integer(usageParm);
   Integer contractStoreId;

   //get contract Store ID parameter
   String contractStoreIdParm = request.getParameter("contractStoreId");
   if(contractStoreIdParm == null || contractStoreIdParm.equals("null") || contractStoreIdParm.equals("-1")){
      contractStoreId = null;
   }else{
      contractStoreId = new Integer(contractStoreIdParm);
   }

   //set title depending on the usage
   String title = "";
   if( ContractCmdUtil.isHostingContract(usage) ){
         title = UIUtil.toHTML((String)contractsRB.get("resellerSummaryTitle"));
   }
   else if(ContractCmdUtil.isReferralContract(usage)){
         title = UIUtil.toHTML((String)contractsRB.get("distributorSummaryTitle"));
   }
   else if(ContractCmdUtil.isDelegationGridContract(usage)){
         title = UIUtil.toHTML((String)contractsRB.get("delegationGridSummaryTitle"));
   }
      else{
         title = UIUtil.toHTML((String)contractsRB.get("contractSummaryTitle"));
   }

%>
 <script type="text/javascript" language="JavaScript">

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

function formatAdjustmentValue(adj) {
    if (!defined(parent.numberToStr)) {
       return adj;
    }
    if (adj > 0) {
        return "+"+parent.numberToStr(adj, "<%=fLanguageId%>");
    } else if (adj == '') {
        return "0";
    }
    else {
        return parent.numberToStr(adj, "<%=fLanguageId%>");
    }
}

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

 <title><%= title%></title>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

</head>

<body onload="loadPanelData()" class="content">

<h2><%= title %></h2>

<% Long contractAccountId = null; %>

<% // show this contract, and any base contracts
String customerContractId = contractId;
String nextContractIdToDisplay = contractId;

while (nextContractIdToDisplay != null) {
   contractId = nextContractIdToDisplay;
%>

<%

   try {
    ContractDataBean contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
    DataBeanManager.activate(contract, request);
    nextContractIdToDisplay = ContractCmdUtil.getCurrentContract(contract.getReferenceFamilyId());

   try {

      //If the contract is a distributor or reseller contract, we do not use the accountId
      if(ContractCmdUtil.isHostingContract(usage) || ContractCmdUtil.isReferralContract(usage) || ContractCmdUtil.isDelegationGridContract(usage)){
      }
      else{
         contractAccountId = contract.getAccountId();
      }
   }catch(Exception e){
      //out.println("Exception: " + e.toString());
   }
   %>
   <%if(ContractCmdUtil.isBuyerContract(usage)){%>
     <% if (contractId.equals(customerContractId)) { %>
        <h3><%= contractsRB.get("customerContractLabel") %> <%= UIUtil.toHTML(contract.getContractName()) %></h3>
     <% } else { %>
        <h3><%= contractsRB.get("baseContractLabel") %> <%= UIUtil.toHTML(contract.getContractName())  %></h3>
     <% } %>
      <h4><%= contractsRB.get("contractGeneralPanelPrompt") %></h4>

      <%= contractsRB.get("summaryContractName") %> <i><%= UIUtil.toHTML(contract.getContractName())  %></i><br />
      <% if (contract.getContractTitle() != null) { %>
         <%= contractsRB.get("summaryContractShortDescription") %> <i><%= UIUtil.toHTML(contract.getContractTitle())  %></i><br />
      <% } else { %>
         <%= contractsRB.get("summaryContractShortDescription") %><br />
      <% } %>
      <%= contractsRB.get("summaryContractDescription") %> <i><script type="text/javascript">document.writeln(decodeNewLinesForHtml('<%= UIUtil.toJavaScript(contract.getContractDescription()) %>'))
</script></i><br />
      <%if(ContractCmdUtil.isBuyerContract(usage)){%>
         <% if (contract.getStartDate() != null) { %>
            <%= contractsRB.get("summaryContractStartDate") %> <i><%= TimestampHelper.getDateTimeFromTimestamp(contract.getStartDate(), fLocale) %></i><br />
         <% } else { %>
            <%= contractsRB.get("summaryContractStartDateNow") %><br />
         <% } %>
         <% if (contract.getEndDate() == null) { %>
            <%= contractsRB.get("summaryContractEndDateNotAllowed") %><br />
         <% } else { %>
            <%= contractsRB.get("summaryContractEndDateAllowed") %> <i><%= TimestampHelper.getDateTimeFromTimestamp(contract.getEndDate(), fLocale) %></i><br />
         <% } %>
         <%= contractsRB.get("contractState") %> <i><%=contractsRB.get("contractStatus" + contract.getContractState())%></i><br />
         <%= contractsRB.get("origin") %> <i><%=contractsRB.get("contractOrigin" + contract.getContractOriginValue()) %></i><br />
         <%= contractsRB.get("storeName")%>&nbsp;<i><%= contract.getContractStore() %></i><br />
    <%= contractsRB.get("accountName")%>&nbsp;<i><%= contract.getContractAccount() %></i><br />
      <% } %>
      <% String cRef = contract.getReferenceContractName();
         if (cRef == null) {
      %>
         <%= contractsRB.get("contractReferenceTitle") %> <i><%= contractsRB.get("contractNoReferenceContract") %></i>
      <% }
      else {
      %>
         <%= contractsRB.get("contractReferenceTitle") %> <i><%= cRef %></i><br />
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toHTML((String)contractsRB.get("storeName"))%>&nbsp;
   <i><%= contract.getReferenceContractStore() %></i><br />
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toHTML((String)contractsRB.get("accountName"))%>&nbsp;
   <i><%= contract.getReferenceContractAccount() %></i><br />
      <% } %>

   <% try {
         String contractReferenceList = "";
         ContractAccessBean cab = new ContractAccessBean();
         cab.setInitKey_referenceNumber(contractId);
         Enumeration refCntrList = cab.getContractsReferringToContractId();

         while (refCntrList.hasMoreElements()) {
            TradingAgreementAccessBean abRefContract = (TradingAgreementAccessBean) refCntrList.nextElement();
            ContractDataBean refCDB = new ContractDataBean(abRefContract.getTradingIdInEntityType(), new Integer(fLanguageId));
               DataBeanManager.activate(refCDB, request);
               contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               contractReferenceList += refCDB.getContractName();
               contractReferenceList += "</i><br />";
               contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + contractsRB.get("contractState") + "&nbsp";
               contractReferenceList += "<i>" + contractsRB.get("contractStatus" + refCDB.getContractState()) + "</i><br />";
               contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + contractsRB.get("storeName") + "&nbsp";
      contractReferenceList += "<i>" + refCDB.getContractStore() + "</i><br />";
      contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + contractsRB.get("accountName") + "&nbsp";
      contractReferenceList += "<i>" + refCDB.getContractAccount() + "</i><br />";
         }

         if (contractReferenceList.length() == 0) {
      %>
         <br /><%= contractsRB.get("summaryContractReferenceNo") %>
      <% }
      else {
      %>
         <br /><%= contractsRB.get("summaryContractReferenceYes") %> <br /><%= contractReferenceList %>
      <% }
      } catch (Exception e) {
      }
   %>
     <h4><%= contractsRB.get("contractBuyerPanelPrompt") %></h4>
      <%    // check participant
         ParticipantAccessBean abParticipant = new ParticipantAccessBean();
         Enumeration participants = abParticipant.findByTradingAndRole(new Long(contractId), new Integer(2));

         if (!participants.hasMoreElements()) {%>
            <%//no participants found%>
            <%= contractsRB.get("summaryContractBuyerOrganizationsNotAllowed") %><br />
         <%}else{%>
            <%= contractsRB.get("summaryContractBuyerOrganizationsAllowed") %><br />
               <%for (;participants.hasMoreElements() ;) {
               ParticipantAccessBean tempParticipant = new ParticipantAccessBean();
               tempParticipant = (ParticipantAccessBean)participants.nextElement();
               if (tempParticipant.getMemberId() == null || tempParticipant.getMemberId().length() == 0) {
            %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("AllList") %></i><br />
            <%    break;
               }
            }// end for
            // get orgs
            Vector buyers = contract.getBuyerName();
            if (buyers != null) {
               for (int i = 0; i < buyers.size(); i++) { %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contract.getBuyerName(i) %></i><br />
            <% }
            }
            // get member groups
            Vector mbrGrps = contract.getMemberGroupName();
            if (mbrGrps != null) {
               for (int i = 0; i < mbrGrps.size(); i++) { %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contract.getMemberGroupName(i) %></i><br />
            <% }
            }
         } // end if
   } // end if buyer contract
      else if(ContractCmdUtil.isDelegationGridContract(usage)){%>
     <% if (contractId.equals(customerContractId)) { %>
        <h3><%= contractsRB.get("delegationGridLabel") %> <%= UIUtil.toHTML(contract.getContractName()) %></h3>
     <% } else { %>
        <h3><%= contractsRB.get("baseDelegationGridLabel") %> <%= UIUtil.toHTML(contract.getContractName()) %></h3>
     <% } %>
      <h4><%= contractsRB.get("delegationGridGeneralPanelPrompt") %></h4>

      <%= contractsRB.get("summarydelegationGridName") %> <i><%= UIUtil.toHTML(contract.getContractName()) %></i><br />
      <% if (contract.getContractTitle() != null) { %>
         <%= contractsRB.get("summarydelegationGridShortDescription") %> <i><%= UIUtil.toHTML(contract.getContractTitle()) %></i><br />
      <% } else { %>
         <%= contractsRB.get("summarydelegationGridShortDescription") %><br />
      <% } %>

      <% String cRef = contract.getReferenceContractName();
         if (cRef == null) {
      %>
         <%= contractsRB.get("delegationGridReferenceTitle") %> <i><%= contractsRB.get("delegationGridNoReferenceContract") %></i>
      <% }
      else {
      %>
         <%= contractsRB.get("delegationGridReferenceTitle") %> <i><%= cRef %></i><br />
      <% } %>

   <% try {
         String contractReferenceList = "";
         ContractAccessBean cab = new ContractAccessBean();
         cab.setInitKey_referenceNumber(contractId);
         Enumeration refCntrList = cab.getContractsReferringToContractId();

         while (refCntrList.hasMoreElements()) {
            TradingAgreementAccessBean abRefContract = (TradingAgreementAccessBean) refCntrList.nextElement();
            ContractDataBean refCDB = new ContractDataBean(abRefContract.getTradingIdInEntityType(), new Integer(fLanguageId));
               DataBeanManager.activate(refCDB, request);
               contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               contractReferenceList += refCDB.getContractName();
               contractReferenceList += "</i><br />";
               contractReferenceList += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + contractsRB.get("contractState") + "&nbsp";
               contractReferenceList += "<i>" + contractsRB.get("contractStatus" + refCDB.getContractState()) + "</i><br />";
         }

         if (contractReferenceList.length() == 0) {
      %>
         <br /><%= contractsRB.get("summarydelegationGridReferenceNo") %>
      <% }
      else {
      %>
         <br /><%= contractsRB.get("summarydelegationGridReferenceYes") %> <br /><%= contractReferenceList %>
      <% }
      } catch (Exception e) {
      }
   %>

      <%    // check participant

            // get member groups
            Vector mbrGrps = contract.getMemberGroupName("ServiceRepresentative");
            if (mbrGrps != null && mbrGrps.size() > 0) {
%>
            <br /><%= contractsRB.get("summarydelegationGridBuyerOrganizationsAllowed") %><br />
<%
               for (int i = 0; i < mbrGrps.size(); i++) { %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contract.getMemberGroupName(i) %></i><br />
            <% }
            } else {
%>
               <br /><%= contractsRB.get("summarydelegationGridBuyerOrganizationsNotAllowed") %><br />
<%
         } // end if
%>
  <h4><%= contractsRB.get("delegationGridRemarksTitle") %></h4>
   <% if (contract.getContractComment() == null || contract.getContractComment().length() == 0) { %>
      <%= contractsRB.get("summaryDelegationGridRemarksNotAllowed") %><br />
   <% } else { %>
      <i><script type="text/javascript">document.writeln(decodeNewLinesForHtml('<%= UIUtil.toHTML(contract.getContractComment()) %>'))
</script></i><br />
   <% }

   } // end if delegation grid contract
         %>


<% } catch (Exception e) {
      //out.println(e);
   }
%>


<%if(ContractCmdUtil.isReferralContract(usage) ){%>
   <% try{
          ContractDataBean distContract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
          DataBeanManager.activate(distContract, request);
          OrganizationAccessBean oab = new OrganizationAccessBean();
          oab.setInitKey_memberId(distContract.getMemberId().toString());

       %>
      <%//do all of the Distributor, Reseller summary %>

      <h4><%= contractsRB.get("distributorGeneralInformation") %></h4>
      <%= contractsRB.get("distributorName") %> <i><%= UIUtil.toHTML(distContract.getContractName()) %></i><br />
      <% if (distContract.getContractTitle() != null) { %>
         <%= contractsRB.get("distributorShortDescription") %> <i><%= UIUtil.toHTML(distContract.getContractTitle()) %></i><br />
      <% } else { %>
         <%= contractsRB.get("distributorShortDescription") %><br />
      <% } %>

      <%= contractsRB.get("origin") %> <i><%=distContract.getContractOrigin() %></i><br />
      <%= contractsRB.get("contractState") %> <i><%=contractsRB.get("distributorStatus" + distContract.getContractState())%> </i><br />
   <br />
      <h4><%= contractsRB.get("participantInformation") %></h4>
      <%
         ParticipantAccessBean abParticipant = new ParticipantAccessBean();
         Enumeration participants = abParticipant.findAllInTradingLevel(new Long(contractId));

         if (!participants.hasMoreElements()) {%>
            <%//no participants found%>
            <%= contractsRB.get("participantListEmpty")%><br />
         <%}else{%>
           <%for (;participants.hasMoreElements() ;) {
               ParticipantAccessBean tempParticipant = new ParticipantAccessBean();
               tempParticipant = (ParticipantAccessBean)participants.nextElement();
               OrganizationAccessBean partOab = new OrganizationAccessBean();
               partOab.setInitKey_memberId(tempParticipant.getMemberId().toString());
               if(!tempParticipant.getRoleId().equals("0")) {//don't show the creator role%>
                  <%= contractsRB.get("participant" + tempParticipant.getRoleId())%>:
                  <%try{
                     if(partOab.getOrganizationName()!= null){%>
                        <i><%=partOab.getOrganizationName()%></i> <br />
                     <%}
                  }catch(Exception e){%>
                     <%=contractsRB.get("participantNameEmpty") %> <br />
                  <%}//end of null org name
                  }//end of if
             }// end for
         }//end else%>

   <%
       }catch(Exception e){// for distributor/reseller
         //out.println("Exception: " + e.toString());
   }//end of distributor/reseller catch
   %>

   <%//end of distributor summary%>
   <%//************************************************************************************************************%>

   <%}else if(ContractCmdUtil.isHostingContract(usage)){%>
      <% try{
             ContractDataBean resellerContract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
             DataBeanManager.activate(resellerContract, request);

            OrganizationAccessBean oab = new OrganizationAccessBean();
            oab.setInitKey_memberId(resellerContract.getMemberId().toString());
      %>

   <h4><%= contractsRB.get("resellerGeneralInformation") %></h4>
   <%= contractsRB.get("resellerName") %> <i><%= UIUtil.toHTML(resellerContract.getContractName()) %></i><br />
   <% if (resellerContract.getContractTitle() != null) { %>
      <%= contractsRB.get("resellerShortDesc") %> <i><%= UIUtil.toHTML(resellerContract.getContractTitle()) %></i><br />
   <% } else { %>
      <%= contractsRB.get("resellerShortDesc") %><br />
   <% } %>
<br />
   <h4><%= contractsRB.get("resellerStore") %></h4>
   <%if (contractStoreId != null) {%>
      <%StoreAccessBean    storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(contractStoreId);%>
      <%if (storeAB != null) {%>
         <%= contractsRB.get("storeName") %> <i><%=storeAB.getIdentifier()%></i><br />
         <%= contractsRB.get("storeState") %> <i><%=contractsRB.get("storeStatus" + storeAB.getStatus())%> </i><br />
      <%}//end if %>
   <%}else{%>
      <%= contractsRB.get("resellerStoreEmpty") %><br />
   <%}//end of storeAB if%>
<br />
   <h4><%= contractsRB.get("participantInformation") %></h4>
   <%
      ParticipantAccessBean abParticipant = new ParticipantAccessBean();
      Enumeration participants = abParticipant.findAllInTradingLevel(new Long(contractId));

      if (!participants.hasMoreElements()) {%>
         <%//no participants found%>
         <%= contractsRB.get("participantListEmpty")%><br />
      <%}else{%>
        <%for (;participants.hasMoreElements() ;) {%>
            <%ParticipantAccessBean tempParticipant = new ParticipantAccessBean();%>
            <%tempParticipant = (ParticipantAccessBean)participants.nextElement();%>
            <%OrganizationAccessBean partOab = new OrganizationAccessBean();%>
            <%partOab.setInitKey_memberId(tempParticipant.getMemberId().toString());%>
            <%if(!tempParticipant.getRoleId().equals("0")) {//don't show the creator role%>
               <%= contractsRB.get("participant" + tempParticipant.getRoleId())%>:
               <%try{%>
                     <%if(partOab.getOrganizationName() != null){%>
                        <i><%=partOab.getOrganizationName()%></i><br />
                     <%}%>
               <%}catch(Exception e){%>
                     <%=contractsRB.get("participantNameEmpty") %> <br />
               <%}//end of null org name%>
            <%}//end if%>
         <% }// end for%>
      <%}//end else%>

   <%
       }catch(Exception e){
         //out.println("Exception: " + e.toString());
   }//end of reseller catch
   %>

<%//end of reseller summary%>




<%} else if(ContractCmdUtil.isBuyerContract(usage)){%>

<%//************************************************************************************************************%>
<% try {
   CategoryPricingTCDataBean tcData = new CategoryPricingTCDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>
  <h4><%= contractsRB.get("contractPriceListTitle") %></h4>

   <% if (tcData.getMasterCatalogAdjustments().size() +
      tcData.getSelectiveAdjustments().size() +
      tcData.getCustomAdjustments().size() == 0) { %>
      <%= contractsRB.get("summaryCatalogPricingNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryCatalogPricingAllowed") %><br />
   <%    // MASTER CATALOG PRICE TCs
                   for (int i = 0; i < tcData.getMasterCatalogAdjustments().size(); i++) {
            Vector tcElement = tcData.getMasterCatalogAdjustment(i);
   %>
      <i><script type="text/javascript">changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryCatalogPricingCategory")) %>',
                    true,
                    '<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingAllCategoriesLabel")) %>',
                    formatAdjustmentValue('<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>'));

</script></i><br />
   <%    }
                   // SELECTIVE ADJUSTMENT PRICE TCs
                        for (int i = 0; i < tcData.getSelectiveAdjustments().size(); i++) {
                            Vector tcElement = tcData.getSelectiveAdjustment(i);

                            //
                            // SELECTIVE ADJUSTMENT PRICE TCS (/w STANDARD PRODUCT SET)
                            //
                            String priceTCtype = (String)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_TYPE);

                            if (priceTCtype.equals("standardPriceTC")) {
                                 PolicyDataBean psPDB = (PolicyDataBean)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_PRODUCTSET_POLICY_DB);
   %>
               <i><script type="text/javascript">changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryCatalogPricingCategory")) %>',
                           true,
                           '<%= UIUtil.toJavaScript((String)psPDB.getShortDescription()) %>',
                           formatAdjustmentValue('<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>'));

</script></i><br />
   <%
                       }
                            else if (priceTCtype.equals("customPriceTC")) {
                          // this is a custom product set TC
                         // get the catentry/catgroups from the databean
                          CustomProductSetDataBean cpsdb = (CustomProductSetDataBean)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_PRODUCTSET_SELECTIONS);
   %>
               <i><script type="text/javascript">changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryCatalogPricingSubcategoryAndItems")) %>',
                           true,
                           '',
                           formatAdjustmentValue('<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>'));

</script></i><br />
   <%

                          // create the catalog entries
                         for (int j = 0; j < cpsdb.getCatalogEntries().size(); j++) {
                         try {
                                     CatalogEntryAccessBean ceab = (CatalogEntryAccessBean)cpsdb.getCatalogEntry(j);
                                                    String partNumber = ceab.getPartNumber();
                                                    String displayText = partNumber;
                                                    try {
                                                        CatalogEntryDescriptionAccessBean cedab = ceab.getDescription(new Integer(fLanguageId));
                                                        displayText = cedab.getName() + " (" + partNumber + ")";
                                                    }
                                                    catch (Exception e) {
                                                        // if you can't get the NLV short description for the catentry,
                                                        // then use just use the SKU as the displayText
                                                        // this logic was defaulted above...
                                                    }
                    %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
               <%          } catch(Exception e) {  }
                          } // end for

                          // create the catalog groups
                         for (int j = 0; j < cpsdb.getCatalogGroups().size(); j++) {
                                try {
                                  CatalogGroupAccessBean cgab = (CatalogGroupAccessBean)cpsdb.getCatalogGroup(j);
                                            String identifier = cgab.getIdentifier();
                                            String displayText = identifier;
                                            try {
                                                CatalogGroupDescriptionAccessBean cgdab = cgab.getDescription(new Integer(fLanguageId));
                                                displayText = cgdab.getName();
                                            }
                                            catch (Exception e) {
                                                // if you can't get the NLV catgroup name for the catgroup,
                                                // then use the catgroup identifier as the displayText
                                                // this logic was defaulted above...
                                            }
                    %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
                    <%        } catch(Exception e) { }
                          } // end for
            } // end else
         } // end for selective
      } // end if
   %>

<% } catch (Exception e) {
       out.println(e);
      //ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "ContractSummary.jsp", "none", "an exception was thrown when coupon bean was populated");
	  System.out.println(e.toString());
	  e.printStackTrace();
	  throw e;
   }
%>
<%//************************************************************************************************************%>


<%}//end of buyer contract%>

<%//************************************************************************************************************%>
<%//USED FOR ALL CONTRACTS%>

<% try {
   PriceTCMasterCatalogWithFilteringDataBean tcData = new PriceTCMasterCatalogWithFilteringDataBean();
   tcData.setDatabeanMode(PriceTCMasterCatalogWithFilteringDataBean.MODE_CATALOG_FILTER_UI);
   tcData.setContractId(new Long(contractId));
   //tcData.setTraceMode(true);
   DataBeanManager.activate(tcData, request);
   String catalog = (String)contractsRB.get("summaryCatalogFilterMasterNotSpecified");
   String filterTitle = (String)contractsRB.get("genericCatalogFilterTitle");
   String noFiltersText = (String)contractsRB.get("summaryCatalogFilterNotSpecified");
   String filtersSetText = (String)contractsRB.get("summaryCatalogFilterInclusionList");
   if (ContractCmdUtil.isDelegationGridContract(usage)) {
      catalog = "";
      filterTitle = (String)contractsRB.get("delegationGridCatalogFilterTitle");
      noFiltersText = (String)contractsRB.get("summarydelegationGridPricesNone");
      filtersSetText = (String)contractsRB.get("summarydelegationGridPrices");
   }
   String categoryExcluded = "";
   String categoryIncluded = "";
   String catentryExcluded = "";
   String catentryIncluded = "";
   boolean categoryIncludedSynch = false;
   boolean categoryIncludedUnsynch = false;
%>

  <h4><%= filterTitle %></h4>
<%
   // loop through the catalog filters and setup the JROM...
   for (int i=0; i<tcData.getCatalogFilters().size(); i++) {
      CatalogFilterDataBean cfdb = tcData.getCatalogFilter(i);
      if (! cfdb.isActionType(CatalogFilterDataBean.ACTION_TYPE_DELETE)){
         if (cfdb.isFilterType(CatalogFilterDataBean.FILTER_TYPE_CATALOG)) {
            if (cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_INCLUDE)) {
               if (ContractCmdUtil.isDelegationGridContract(usage)) {
                  catalog = " " + contractsRB.get("summarydelegationGridPricesEntireCatalog");
               } else {
                catalog = " " + contractsRB.get("summaryCatalogFilterMasterSpecified");
               }
               catalog += " ";
               catalog += "<script type=\"text/javascript\">document.write(formatAdjustmentValue('";
               catalog += cfdb.getAdjustment();
               catalog += "'));</script>";
               catalog += "%";
            }
         } else if (cfdb.isFilterType(CatalogFilterDataBean.FILTER_TYPE_CATEGORY)) {
            CatalogGroupAccessBean cgab = new CatalogGroupAccessBean();
                      cgab.setInitKey_catalogGroupReferenceNumber(cfdb.getReferenceNumber());
                                String identifier = cgab.getIdentifier();
                                String displayText = identifier;
                                try {
                                                CatalogGroupDescriptionAccessBean cgdab = cgab.getDescription(new Integer(fLanguageId));
                                                displayText = cgdab.getName();
                                }
                                catch (Exception e) {
                                                // if you can't get the NLV catgroup name for the catgroup,
                                                // then use the catgroup identifier as the displayText
                                                // this logic was defaulted above...
                                }

            if (cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_INCLUDE)) {
               categoryIncluded += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               categoryIncluded += displayText;
               categoryIncluded += " ";
               categoryIncluded += "<script type=\"text/javascript\">document.write(formatAdjustmentValue('";
               categoryIncluded += cfdb.getAdjustment();
               categoryIncluded += "'));</script>";
               categoryIncluded += "%";               
               categoryIncluded += "</i><br />";
               if (cfdb.getSynched().equals(Boolean.TRUE)) {
                  categoryIncludedSynch = true;
               } else if (cfdb.getSynched().equals(Boolean.FALSE)) {
                  categoryIncludedUnsynch = true;
               }
            } else if (cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_EXCLUDE)) {
               categoryExcluded += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               categoryExcluded += displayText;
               categoryExcluded += "</i><br />";
            }
         } else if (cfdb.isFilterType(CatalogFilterDataBean.FILTER_TYPE_CATENTRY)) {
            CatalogEntryDataBean ceab = new CatalogEntryDataBean();
            ceab.setCatalogEntryID(cfdb.getReferenceNumber());
            ceab.setCommandContext(contractCommandContext);
            ceab.populate();
                          String partNumber = ceab.getPartNumber();
                          String displayText = partNumber;
                                 try {
                                          CatalogEntryDescriptionAccessBean cedab = ceab.getDescription();
                                          displayText = cedab.getName() + " (" + partNumber + ")";
                                 }
                                 catch (Exception e) {
                                         // if you can't get the NLV short description for the catentry,
                                         // then use just use the SKU as the displayText
                                         // this logic was defaulted above...
                                  }
            if (cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_INCLUDE)) {
               catentryIncluded += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               catentryIncluded += displayText;
               catentryIncluded += " ";
               catentryIncluded += "<script type=\"text/javascript\">document.write(formatAdjustmentValue('";
               catentryIncluded += cfdb.getAdjustment();
               catentryIncluded += "'));</script>";  
               catentryIncluded += "%";             
               catentryIncluded += "</i><br />";
            } else if (cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_EXCLUDE)) {
               catentryExcluded += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>";
               catentryExcluded += displayText;
               catentryExcluded += "</i><br />";
            }
         }
      }
   }
   if (tcData.getCatalogFilters().size() == 0) {
%>
      <%= noFiltersText %><br />
<% } else {

   // see if this filter uses a specific price list type
      PolicyListDataBean pldb = tcData.getPriceListPolicies();
      PolicyDataBean[] _policies = pldb.getPolicyList();
      for (int i=0; i<_policies.length; i++) {
        PolicyDataBean pricePDB = _policies[i];
   String priceListPref = ContractUtil.getPolicyPriceListType(pricePDB.getProperties());
        Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", fLocale);
        int plTypeCount = 0;
        while(true){
            String option = (String)fixedResourceBundle.get("priceList_internalName_type_" + (plTypeCount + 1));
       if(option == null){
      break;
       } else if (option.equals(priceListPref)) {
    %>
         <%= contractsRB.get("priceListLabel") %><i><%= UIUtil.toJavaScript((String) contractsRB.get("priceList_displayText_type_" + (plTypeCount + 1))) %></i><br />
    <%
         break;
       }
       plTypeCount++;
         }
      } // end for
      if (!ContractCmdUtil.isDelegationGridContract(usage)) {
%>
          <%= catalog %><br /><br />
<%    }

      if (categoryIncluded.length() != 0 || catentryIncluded.length() != 0 || ContractCmdUtil.isDelegationGridContract(usage)) {
%>

         <%if (!ContractCmdUtil.isDelegationGridContract(usage)) {
              if(categoryIncludedSynch == true) { %>
              <%= contractsRB.get("includeCategorySynchronizedLabel")%> <i><%= contractsRB.get("includeCategorySynchronizedYes")%></i><br />
         <%   } else if(categoryIncludedUnsynch == true) { %>
              <%=contractsRB.get("includeCategorySynchronizedLabel")%> <i><%= contractsRB.get("includeCategorySynchronizedNo")%></i><br />
         <%   }
           }
         %>
         <%= filtersSetText %><br />
<%
         if (ContractCmdUtil.isDelegationGridContract(usage)) {
%>
       <%= catalog %><br />
<%       }
%>
         <%= categoryIncluded %><%= catentryIncluded %><br />
<%    }
      if (categoryExcluded.length() != 0 || catentryExcluded.length() != 0) {
%>
         <%= contractsRB.get("summaryCatalogFilterExclusionList") %><br />
         <%= categoryExcluded %><%= catentryExcluded %><br />
<%       }
   }
   } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
        // Create an instance of the databean to use if we are doing an update
   CustomPricingTCDataBean tcData = new CustomPricingTCDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>
<%
   String[] priceListName = tcData.getPriceListName();
   String[] priceListId = tcData.getPriceListId();
   String[] offerId = tcData.getOfferId();
   if (priceListId == null || priceListId.length == 0) {
%>
     <!--  <%= contractsRB.get("summaryCustomPricingNotAllowed") %><br />  -->
<% } else {
%>
     <h5><%= contractsRB.get("contractCustomPriceListTitle") %></h5>
     <%= contractsRB.get("summaryCustomPricingAllowed") %><br />
<%
   }

   StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);

   if ( (priceListName != null || priceListName.length == 0) && storeAB != null ) {
      CurrencyManager cm = CurrencyManager.getInstance();
      String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());

      // get member id for the master catalog from the store access bean
      String catalogMemberId = "";
      try {
         catalogMemberId = storeAB.getMasterCatalog().getMemberId();
      }
      catch (Exception e) {
         StoreDataBean sdb = new StoreDataBean(storeAB);
         DataBeanManager.activate(sdb, request);
         CatalogDataBean cdb[] = sdb.getStoreCatalogs();
         for (int i = 0; i < cdb.length; i++) {
            catalogMemberId = cdb[i].getMemberId();
            break;
         }
      }

      // there should only be one price list for each contract
      for (int i = 0; i < priceListName.length; i++) {
         if (priceListId != null) {
            for (int j = 0; j < priceListId.length; j++) {
               if (priceListId[j].equals(String.valueOf(i))) {
                  String productName = "";
                  String skuNumber = "";
                  try {
                     CatalogEntryAccessBean ceab = new CatalogEntryAccessBean().findByMemberIdAndSKUNumber(new Long(catalogMemberId), tcData.getOfferSkuNumber()[j]);
                     productName = ceab.getDescription(contractCommandContext.getLanguageId()).getName();
                     skuNumber = tcData.getOfferSkuNumber()[j];
                  }
                  catch (Exception e) {
                     try {
                        CatalogEntryAccessBean ceab = new CatalogEntryAccessBean();
                        ceab.setInitKey_catalogEntryReferenceNumber(tcData.getOfferReferenceNumber()[j]);
                        productName = ceab.getDescription(contractCommandContext.getLanguageId()).getName();
                        skuNumber = ceab.getPartNumber();
                     } catch (Exception e2) {
                     }
                  }
                  if (offerId != null) {
                     for (int k = 0; k < offerId.length; k++) {
                        if (priceListId[j].equals(String.valueOf(i)) && offerId[k].equals(String.valueOf(j))) {
%>
                           <i><script type="text/javascript">if (defined(parent.numberToCurrency))
                              changeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryCustomPricingText")) %>",
                                      true,
                                      "<%= UIUtil.toJavaScript((String)productName) %>",
                                      "<%= UIUtil.toJavaScript((String)skuNumber) %>",
                                    parent.numberToCurrency(<%=  tcData.getOfferPriceValue()[k] %>, "<%=  tcData.getOfferPriceCurrency()[k] %>", "<%= fLanguageId %>"),
                                      "<%= tcData.getOfferPriceCurrency()[k] %>");
                              else
                              changeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryCustomPricingText")) %>",
                                      true,
                                      "<%= UIUtil.toJavaScript((String)productName) %>",
                                      "<%= UIUtil.toJavaScript((String)skuNumber) %>",
                                      "<%=  tcData.getOfferPriceValue()[k] %>",
                                      "<%= tcData.getOfferPriceCurrency()[k] %>");

</script></i><br />
<%
                        } // end if pricelistid
                     } // end for
                  } // end if offerId
               } // end if pricelist id
            } // end for
         } // end if null
      } // end for
   } // end if pricelistname
%>

<% } catch (Exception e) {
      //out.println(e);
   }
%>
<%//************************************************************************************************************%>

<%
// Kit Component Pricing Contract Summary

   //-----------------------------------------------------------
   // Retrieving the PriceTCConfigBuildBlock terms & conditions
   //-----------------------------------------------------------

   PriceTCConfigBuildBlockAccessBean pcbbAB = null;
   Long myPriceTCConfigBB_refNum = null;
   Long myPriceTCConfigBB_priceListId = null;

   try
   {
      Long pcbbAB_contractId = new Long(contractId);
      Enumeration priceConfigTCenum
         = new TermConditionAccessBean().findByTradingAndTCSubType
                  (pcbbAB_contractId, ECContractConstants.EC_ELE_PRICE_TC_CONFIG_BUILD_BLOCK);

      if (priceConfigTCenum!=null)
      {
         // According to design, there's only one PriceTCConfigBuildBlock per contract
         if (priceConfigTCenum.hasMoreElements())
         {
            // Load the PriceTCConfigBuildBlock
            TermConditionAccessBean tcAB = (TermConditionAccessBean) priceConfigTCenum.nextElement();
            String tcRefNum = tcAB.getReferenceNumber();
            myPriceTCConfigBB_refNum = new Long(tcRefNum);
            pcbbAB = new PriceTCConfigBuildBlockAccessBean();
            pcbbAB.setInitKey_referenceNumber(tcRefNum);
         }
      }

      if (pcbbAB!=null)
      {
         %>
         <h5><%= contractsRB.get("KCP_Title") %></h5>
         <%= contractsRB.get("KCP_TxtForSale") %> <br />
         <%


         //---------------------------------------------------------------------
         // Create a HashMap to store all the kit component pricing information.
         // We will use the HashMap to generate proper HTML codes to display
         // the kit pricing summary.
         //---------------------------------------------------------------------
         java.util.HashMap allKitDataMap = new java.util.HashMap();
         java.util.Vector allKitDataMapKeys = new java.util.Vector();


         //-----------------------------------
         // Retrive all the kit % adjustments
         //-----------------------------------
         Enumeration priceConfigTCKitPercentageAdjEnum
            = new ComponentAdjustmentAccessBean().findByTermcond(myPriceTCConfigBB_refNum);

         String percentageAdjustmentType = "PERT";
         String fixedPriceAdjustmentType = "PRICE";

         if (priceConfigTCKitPercentageAdjEnum!=null)
         {
            while (priceConfigTCKitPercentageAdjEnum.hasMoreElements())
            {
               // Load the percentage adjustments for all kits within the TC
               ComponentAdjustmentAccessBean caAB = (ComponentAdjustmentAccessBean) priceConfigTCKitPercentageAdjEnum.nextElement();


               //----------------------------------------------------------------------
               // Flatten a kit component pricing data into a linear string as the
               // following format and using a pipe '|' as the data separator:
               //       "adjustment_type | catentryId | adjustment_value"
               //
               // And store the data into the allKitDataMap using the kitID as the key
               //----------------------------------------------------------------------

               String mapKey = caAB.getKitId().toString();
               StringBuffer kitComponentPricingData = new StringBuffer("");
               kitComponentPricingData.append(percentageAdjustmentType).append("|");
               kitComponentPricingData.append(caAB.getCatentryId()).append("|");
               kitComponentPricingData.append(caAB.getAdjustment());

               //--------------------------------------------------------------------------
               // Let's get the kit pricing list and add the new pricing data into the list
               //--------------------------------------------------------------------------
               java.util.Vector myKitPriceList = null;

               if (allKitDataMap.containsKey(mapKey)==false)
               {
                  // create a kit pricing list if not exists
                  myKitPriceList = new java.util.Vector();
                  allKitDataMap.put(mapKey, myKitPriceList);
               }
               else
               {
                  // Get back the current kit pricing list
                  Object tmpList = allKitDataMap.get(mapKey);
                  myKitPriceList = (java.util.Vector) tmpList;
               }

               myKitPriceList.add(kitComponentPricingData.toString());

               // Store all the unqiue map keys for easy access to
               // the allKitDataMap in later usage.
               if (!allKitDataMapKeys.contains(mapKey))
               {
                  allKitDataMapKeys.add(mapKey);
               }


            }//end-while

         }//end-if (priceConfigTCKitPercentageAdjEnum!=null)


         //---------------------------------------
         // Retrive all the kit price adjustments
         //---------------------------------------

         Long tmpPriceListID = new Long(pcbbAB.getPriceListId());
         Enumeration priceConfigTCKitPriceAdjEnum
            = new ComponentOfferAccessBean().findByPriceList(tmpPriceListID);

         if (priceConfigTCKitPriceAdjEnum!=null)
         {
            while (priceConfigTCKitPriceAdjEnum.hasMoreElements())
            {
               // Load the price adjustments for all kits within the TC
               ComponentOfferAccessBean coAB = (ComponentOfferAccessBean) priceConfigTCKitPriceAdjEnum.nextElement();


               //----------------------------------------------------------------------
               // Flatten a kit component pricing data into a linear string as the
               // following format and using a pipe '|' as the data separator:
               //       "adjustment_type | catentryId | adjustment_value | currency"
               //
               // And store the data into the allKitDataMap using the kitID as the key
               //----------------------------------------------------------------------

               String mapKey = coAB.getKitId().toString();
               StringBuffer kitComponentPricingData = new StringBuffer("");
               kitComponentPricingData.append(fixedPriceAdjustmentType).append("|");
               kitComponentPricingData.append(coAB.getCatentryId()).append("|");
               kitComponentPricingData.append(coAB.getPrice()).append("|");
               kitComponentPricingData.append(coAB.getCurrency());

               //--------------------------------------------------------------------------
               // Let's get the kit pricing list and add the new pricing data into the list
               //--------------------------------------------------------------------------
               java.util.Vector myKitPriceList = null;

               if (allKitDataMap.containsKey(mapKey)==false)
               {
                  // create a kit pricing list if not exists
                  myKitPriceList = new java.util.Vector();
                  allKitDataMap.put(mapKey, myKitPriceList);
               }
               else
               {
                  // Get back the current kit pricing list
                  Object tmpList = allKitDataMap.get(mapKey);
                  myKitPriceList = (java.util.Vector) tmpList;
               }

               myKitPriceList.add(kitComponentPricingData.toString());

               // Store all the unqiue map keys for easy access to
               // the allKitDataMap in later usage.
               if (!allKitDataMapKeys.contains(mapKey))
               {
                  allKitDataMapKeys.add(mapKey);
               }

            }//end-while

         }//end-if (priceConfigTCKitPriceAdjEnum!=null)



         //---------------------------------------------------
         // Display all the kit component pricing records here
         //---------------------------------------------------

         for (int i=0; i<allKitDataMapKeys.size(); i++)
         {
            //---------------------------------------------------------
            // Retrieve the catalog entry name & SKU for the kit itself
            //---------------------------------------------------------

            String mapKey = (String) allKitDataMapKeys.elementAt(i);
            String kitId = mapKey;
            CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
            catEntryDB.setCatalogEntryID(kitId);
            com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
            String kitName = catEntryDB.getDescription().getName();
            String kitSKU  = catEntryDB.getPartNumber();

            // Display the kit's name & SKU


            %>
            <script type="text/javascript">
                  var tmpMsg  = "<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_DKit_Title")) %>";
                  var kitName = "<%= UIUtil.toJavaScript(kitName) %>";
                  var kitSKU  = "<%= UIUtil.toJavaScript(kitSKU)  %>";
                  tmpMsg = tmpMsg.replace(/%1/, kitName);
                  tmpMsg = tmpMsg.replace(/%2/, kitSKU);
                  tmpMsg = "<br /><i>&nbsp;&nbsp;&nbsp;" + tmpMsg + "</i><br />";
                  document.write(tmpMsg);
            </script>
            <%


            //------------------------------------------------
            // Retrieve the kit's pricing adjustment data list
            //------------------------------------------------

            Vector pricingDataList = (Vector) allKitDataMap.get(mapKey);

            for (int j=0; j<pricingDataList.size(); j++)
            {
               // Parsing the pricing data linear string
               String pricingData = (String) pricingDataList.elementAt(j);
               String tmpData[] = new String[4];
               int tokenCounter = 0;
               StringTokenizer tokenizer = new StringTokenizer(pricingData, "|");
               while (tokenizer.hasMoreTokens())
               {
                  tmpData[tokenCounter++] = tokenizer.nextToken();
               }

               String adjType    = tmpData[0];
               String catentryId = tmpData[1];
               String adjValue   = tmpData[2];

               //------------------------------------------------------------
               // Retrieve the catalog entry name & SKU for the kit component
               //------------------------------------------------------------
               catEntryDB = new CatalogEntryDataBean();
               catEntryDB.setCatalogEntryID(catentryId);
               com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
               String kitComponentName = catEntryDB.getDescription().getName();
               String kitComponentSKU  = catEntryDB.getPartNumber();

               // Handle different adjustment type: percentage or fixed price

               if (percentageAdjustmentType.equals(adjType))
               {
                  // Check makrup or markdown ?

                  String isMarkDown = "false";

                  if ("-".equals(adjValue.substring(0,1)))
                  {
                     // It's markdown, trim the leading '-' sign
                     adjValue = adjValue.substring(1);
                     isMarkDown = "true";
                  }
                  else
                  {
                     // It's markup
                     isMarkDown = "false";
                  }

                  %>
                  <script type="text/javascript">
                        var tmpMsg  = "<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_DKitComponentPercentageAdjustment")) %>";
                        var kitName = "<%= UIUtil.toJavaScript(kitComponentName) %>";
                        var kitSKU  = "<%= UIUtil.toJavaScript(kitComponentSKU)  %>";
                        var adjValue = null;
                        if (defined(parent.numberToStr)) {
                           adjValue = parent.numberToStr(Math.abs(<%= adjValue %>), "<%= fLanguageId %>");
                        } else {
                           adjValue = "<%= adjValue %>";
                        }
                        var adjType = ("<%= isMarkDown %>" == "true") ? "<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_LabelMarkDown")) %>" : "<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_LabelMarkUp")) %>";
                        tmpMsg = tmpMsg.replace(/%1/, kitName);
                        tmpMsg = tmpMsg.replace(/%2/, kitSKU);
                        tmpMsg = tmpMsg.replace(/%3/, adjValue);
                        tmpMsg = tmpMsg.replace(/%4/, adjType);
                        tmpMsg = "<i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + tmpMsg + "</i><br />";
                        document.write(tmpMsg);
                  </script>
                  <%
               }
               else
               {
                  // Fixed price with currency
                  String displayAdjustmentCurrency = tmpData[3];

                  // For fixed price adjustment, display the
                  // kit's name, SKU, and price adjustment.
                  %>
                  <script type="text/javascript">
                        var tmpMsg  = "<%= UIUtil.toJavaScript((String)contractsRB.get("KCP_DKitComponentPriceAdjustment")) %>";
                        var kitName = "<%= UIUtil.toJavaScript(kitComponentName) %>";
                        var kitSKU  = "<%= UIUtil.toJavaScript(kitComponentSKU)  %>";
                        //var adjValue= Math.abs(<%= adjValue %>);
                        var adjValue= null;
                        if (defined(parent.numberToCurrency)) {
                           adjValue = parent.numberToCurrency(<%= adjValue %>, "<%=  displayAdjustmentCurrency %>", "<%= fLanguageId %>");
                        } else {
                           adjValue = "<%= adjValue %>";
                        }
                        var adjCurrency = "<%= displayAdjustmentCurrency %>";
                        tmpMsg = tmpMsg.replace(/%1/, kitName);
                        tmpMsg = tmpMsg.replace(/%2/, kitSKU);
                        tmpMsg = tmpMsg.replace(/%3/, adjValue);
                        tmpMsg = tmpMsg.replace(/%5/, adjCurrency);
                        tmpMsg = "<i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + tmpMsg + "</i><br />";
                        document.write(tmpMsg);
                  </script>
                  <%
               }

            }//end-for-j

         }//end-for-i

      }//end-if (pcbbAB!=null)
      else
      {
         %>
         <!-- <%= contractsRB.get("KCP_TxtNone") %> <br /> -->
         <%
      }

   }
   catch (Exception ex)
   {
      com.ibm.commerce.ras.ECTrace.trace
         (com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT,
         "ContractSummary.jsp", "PriceTCConfigBuildBlock loading", ex.toString());
   }

// Kit Component Pricing Contract Summary End
%>

<% if(!ContractCmdUtil.isDelegationGridContract(usage)){ // delegation grids don't have product set tcs
  try {
          // Create an instance of the databean to use if we are doing an update
            ProductSetTCDataBean tcData = new ProductSetTCDataBean(new Long(contractId), new Integer(fLanguageId));
            DataBeanManager.activate(tcData, request);
%>

<%if(ContractCmdUtil.isReferralContract(usage) ){%>
      <h4><%= contractsRB.get("distributorProductSetInclusion") %></h4>
<%}else if(ContractCmdUtil.isHostingContract(usage) ){%>
      <h4><%= contractsRB.get("resellerCatalogEntitlement") %></h4>
<%}else{%>
     <h4><%= contractsRB.get("contractPricingConstraintsPanelTitle") %></h4>
 <%}%>

   <% if (tcData.getCustomExclusionPS().size() +
      tcData.getStandardExclusionPS().size() == 0) { %>
         <%if(ContractCmdUtil.isReferralContract(usage) ){%>
               <%= contractsRB.get("distributorProductSetInclusionEmpty") %><br />
         <%}else if(ContractCmdUtil.isHostingContract(usage) ){%>
               <%= contractsRB.get("resellerCatalogEntitlementEmpty") %><br />
         <%}else{%>
               <%= contractsRB.get("summaryProductConstraintsExclusionNotAllowed") %><br />
          <%}%>

   <% } else { %>
      <%= contractsRB.get("summaryProductConstraintsExclusionList") %><br />
   <%
           // rebuild the STANDARD EXCLUSION PS based on the saved contract
            for (int i = 0; i < tcData.getStandardExclusionPS().size(); i++) {
                Vector tcElement = tcData.getStandardExclusionPS(i);

                // this is a standard product set TC
          %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_SHORT_DESCRIPTION) %></i><br />
          <%
            } // end for (STANDARD EXCLUSION PS loop)

            // rebuild the CUSTOM EXCLUSION PS
            for (int i = 0; i < tcData.getCustomExclusionPS().size(); i++) {
                Vector tcElement = tcData.getCustomExclusionPS(i);

                // this is a custom product set TC
                // get the catentry/catgroups from the databean
                CustomProductSetDataBean cpsdb = (CustomProductSetDataBean)tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_SELECTIONS);
                // create the catalog entries
                for (int j = 0; j < cpsdb.getCatalogEntries().size(); j++) {
          try {
          CatalogEntryAccessBean ceab = (CatalogEntryAccessBean)cpsdb.getCatalogEntry(j);
                         String partNumber = ceab.getPartNumber();
                         String displayText = partNumber;
                         try {
                              CatalogEntryDescriptionAccessBean cedab = ceab.getDescription(new Integer(fLanguageId));
                              displayText = cedab.getName() + " (" + partNumber + ")";
                         }
                         catch (Exception e) {
                              // if you can't get the NLV short description for the catentry,
                              // then use just use the SKU as the displayText
                              // this logic was defaulted above...
                         }
          %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
          <%       }
                   catch(Exception e) {//in catalog groups
                   }
                } // end for

                // create the catalog groups
                for (int j = 0; j < cpsdb.getCatalogGroups().size(); j++) {
          try {
              CatalogGroupAccessBean cgab = (CatalogGroupAccessBean)cpsdb.getCatalogGroup(j);
                        String identifier = cgab.getIdentifier();
                        String displayText = identifier;
                        try {
                             CatalogGroupDescriptionAccessBean cgdab = cgab.getDescription(new Integer(fLanguageId));
                             displayText = cgdab.getName();
                        }
                        catch (Exception e) {//nlv
                             // if you can't get the NLV catgroup name for the catgroup,
                             // then use the catgroup identifier as the displayText
                             // this logic was defaulted above...
                        }
          %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
          <%       }
                   catch(Exception e) {//do nothing
                   }
                } // end for
             } // end for (CUSTOM EXCLUSION PS loop)
       } // end else
   %>
   <%//************************************************************************************************************%>
   <%//only do this bit if we are dealing with an Organization buyer contract%>
   <%if(ContractCmdUtil.isBuyerContract(usage)){%>

   <br />
   <% if (tcData.getCustomInclusionPS().size() +
      tcData.getStandardInclusionPS().size() == 0) { %>
      <%if(ContractCmdUtil.isReferralContract(usage) ){%>
         <%= contractsRB.get("summaryProductConstraintsInclusionNotAllowed") %><br />
      <%}else if(ContractCmdUtil.isHostingContract(usage) ){%>
            <%= contractsRB.get("summaryProductConstraintsInclusionNotAllowed") %><br />
      <%}else{%>
            <%= contractsRB.get("summaryProductConstraintsInclusionNotAllowed") %><br />
       <%}%>


   <% } else { %>
      <%= contractsRB.get("summaryProductConstraintsInclusionList") %><br />
   <%
            // rebuild the STANDARD INCLUSION PS based on the saved contract
            for (int i = 0; i < tcData.getStandardInclusionPS().size(); i++) {
                Vector tcElement = tcData.getStandardInclusionPS(i);
                // this is a standard product set TC
   %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_SHORT_DESCRIPTION) %></i><br />
        <%
            } // end for (STANDARD INCLUSION PS loop)

            // rebuild the CUSTOM INCLUSION PS
            for (int i = 0; i < tcData.getCustomInclusionPS().size(); i++) {
                Vector tcElement = tcData.getCustomInclusionPS(i);

                // this is a custom product set TC
                // get the catentry/catgroups from the databean
                CustomProductSetDataBean cpsdb = (CustomProductSetDataBean)tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_SELECTIONS);
                // create the catalog entries
                for (int j = 0; j < cpsdb.getCatalogEntries().size(); j++) {
          try {
          CatalogEntryAccessBean ceab = (CatalogEntryAccessBean)cpsdb.getCatalogEntry(j);
                         String partNumber = ceab.getPartNumber();
                         String displayText = partNumber;
                         try {
                              CatalogEntryDescriptionAccessBean cedab = ceab.getDescription(new Integer(fLanguageId));
                              displayText = cedab.getName() + " (" + partNumber + ")";
                         }
                         catch (Exception e) {// catalog nlv
                              // if you can't get the NLV short description for the catentry,
                              // then use just use the SKU as the displayText
                              // this logic was defaulted above...
                         }
          %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
          <%       }
                   catch(Exception e) {
                   }
                } // end for

                // create the catalog groups
                for (int j = 0; j < cpsdb.getCatalogGroups().size(); j++) {
          try {
              CatalogGroupAccessBean cgab = (CatalogGroupAccessBean)cpsdb.getCatalogGroup(j);
                        String identifier = cgab.getIdentifier();
                        String displayText = identifier;
                        try {
                             CatalogGroupDescriptionAccessBean cgdab = cgab.getDescription(new Integer(fLanguageId));
                             displayText = cgdab.getName();
                        }
                        catch (Exception e) {
                             // if you can't get the NLV catgroup name for the catgroup,
                             // then use the catgroup identifier as the displayText
                             // this logic was defaulted above...
                        }
          %>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayText %></i><br />
          <%       }
                   catch(Exception e) {
                   }
                } // end for
             } // end for (CUSTOM INCLUSION PS loop)
       } // end else
      %>
<%} // end ORGANIZATION_BUYER else for inclusions/exclusions %>
<% } catch (Exception e) {//end catch
      //out.println(e);
   }
   } // end if delegation grids don't have product set tcs
%>

<%//************************************************************************************************************%>
<%if(ContractCmdUtil.isBuyerContract(usage)){%>
<% try {
   ShippingTCShippingModeDataBean tcData = new ShippingTCShippingModeDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingModePanelPrompt") %></h4>
   <% if (tcData.getShippingMode().size() == 0) { %>
      <%= contractsRB.get("summaryShippingModesNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingModesAllowed") %><br />
   <% for (int i = 0; i < tcData.getShippingMode().size(); i++) {
         Vector tcElement = tcData.getShippingMode(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br />
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShippingChargeDataBean tcData = new ShippingTCShippingChargeDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingChargePanelPrompt") %></h4>
   <% if (tcData.getShippingCharge().size() == 0) { %>
      <%= contractsRB.get("summaryShippingChargeTypeNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingChargeTypeAllowed") %><br />
   <%
      for (int i = 0; i < tcData.getShippingCharge().size(); i++) {
         Vector tcElement = tcData.getShippingCharge(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br />
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<%//************************************************************************************************************%>

<% try {
   ShippingTCShipToAddressDataBean tcData = new ShippingTCShipToAddressDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingAddressPanelPrompt") %></h4>
   <% if (tcData.getShippingAddress().size() == 0) { %>
      <%= contractsRB.get("summaryShippingAddressesNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingAddressesAllowed") %><br />

<%
      if (contractAccountId == null) {
         // just show nickname
         for (int i = 0; i < tcData.getShippingAddress().size(); i++) {
            Vector tcElement = tcData.getShippingAddress(i);
%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= (String)tcElement.elementAt(1) %></i><br />
<%
         }
      } else {
         AccountDataBean account = new AccountDataBean(contractAccountId, new Integer(fLanguageId));
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

               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= adb.getNickName() %></i><br />

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

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;<%=strZipCode%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%><%=strCity%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br /><br />

      <%       } else if (fLocale.toString().equals("fr_FR")||fLocale.toString().equals("de_DE")){ %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strZipCode%>&nbsp;<%=strCity%></i><br />
                  <% if (fLocale.toString().equals("de_DE")) { %>
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%></i><br />
                  <% } %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br /><br />
      <%       } else { %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCity%>&nbsp;<%=strState%>&nbsp;<%=strZipCode%></i> <br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br /><br />
      <%          }
            } // end if addressId
         } // end for
      } // end contractAccountId
      } // end if

      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(new Long(contractId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_SHIPPING);
      DataBeanManager.activate(tcDataAdrBook, request);
      boolean personalAdrBook = tcDataAdrBook.getUsePersonalAddressBook();
      boolean parentAdrBook = tcDataAdrBook.getUseParentOrgAddressBook();
      boolean accountAdrBook = tcDataAdrBook.getUseAccountAddressBook();
      if (personalAdrBook == true || parentAdrBook == true || accountAdrBook == true) {
%>
       <br /><%= contractsRB.get("summaryShippingAddressBooks") %><br />
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

} // end if buyer contract

if(ContractCmdUtil.isBuyerContract(usage) || ContractCmdUtil.isDelegationGridContract(usage)){
%>
<%//************************************************************************************************************%>

<% try {
     ShippingTCShippingChargeAdjustmentFilterDataBean tcData = new ShippingTCShippingChargeAdjustmentFilterDataBean();
     tcData.setContractId(new Long(contractId));
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
                 if (defined(parent.numberToCurrency)) {
                    document.write(parent.numberToCurrency('<%=scdb.getAdjustmentValue()%>','<%=scdb.getCurrency()%>','<%=fLanguageId%>'));
                 } else {
                    document.write('<%=scdb.getAdjustmentValue()%>');
                 }
               </script>
               <%=scdb.getCurrency()%>
<%           } else if (scdb.getAdjustmentType() == scdb.ADJUSTMENT_TYPE_PERCENTAGE_OFF) { %>
               <script type="text/javascript">
                 if (defined(parent.numberToStr)) {
                    document.write(parent.numberToStr('<%=scdb.getAdjustmentValue()%>','<%=fLanguageId%>'));
                 } else {
                    document.write('<%=scdb.getAdjustmentValue()%>');
                 }
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


<%}//end of buyer or delegation %>
<%//************************************************************************************************************%>
<% if(ContractCmdUtil.isReferralContract(usage)){%>

      <% try {%>
      <br /><h4><%= contractsRB.get("distributorReferralInterface") %></h4>
         <%Enumeration tcEnum = null;
         TermConditionAccessBean tcab = new TermConditionAccessBean();
         tcab.setInitKey_referenceNumber(contractId.toString());
         //out.println(":851:");
         tcEnum = new TermConditionAccessBean().findByTradingAndTCSubType(new Long(contractId), "ReferralInterfaceTC");
         if (!tcEnum.hasMoreElements()) {%>
            <%//no referral tc's found%>
            <%= contractsRB.get("distributorReferralInterfaceEmpty")%><br />
         <%}else{%>
            <%for (;tcEnum.hasMoreElements() ;) {
               String refNum;
               ReferralInterfaceTCAccessBean ReferralInterfaceAB = new ReferralInterfaceTCAccessBean();
               refNum = ((TermConditionAccessBean)tcEnum.nextElement()).getReferenceNumber();
               ReferralInterfaceAB.setInitKey_referenceNumber(refNum);
               BusinessPolicyAccessBean[] policy = ReferralInterfaceAB.getPolicies();
               if(policy == null || policy.length == 0){ %>
                     <%= contractsRB.get("distributorReferralInterfaceEmpty")%><br />
               <%}else{%>
                  <%= contractsRB.get("distributorReferralInterfacePolicies") %>
                  <% for (int i = 0; i < policy.length; i++) {%>
                     <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <i> <%=policy[i].getPolicyName() %></i>
                  <%}//end of for %>

                  <%
                  com.ibm.commerce.contract.beans.ReferralDataBean rdb = new com.ibm.commerce.contract.beans.ReferralDataBean();
                  rdb.setDataBeanKeyStoreId(fStoreId);
                  rdb.setDataBeanKeyContractId(new Long(contractId));
                  rdb.setCommandContext(contractCommandContext);
                  rdb.populate();
                  %>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorIdentifier")%><i> <%=rdb.getIdentifier()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorBackOrdersAllowed")%><i> <%=rdb.getBackOrders()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorTimeout")%><i> <%=rdb.getRequestTimeout()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorUOM")%><i> <%=rdb.getUomStandard()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorBatchAvailabilityRequestEnabled")%><i> <%=rdb.getBatchAvailabilityRequestEnabled()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorBatchAvailabilityRequestAuthorize")%><i> <%=rdb.getBatchAvailabilityRequestAuthenticationRequired()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorBatchAvailabilityRequestTimeout")%><i> <%=rdb.getBatchAvailabilityRequestTimeout()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorQuotationRequestEnabled")%><i> <%=rdb.getQuoteRequestEnabled()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorQuotationRequestAuthorize")%><i> <%=rdb.getQuoteRequestAuthenticationRequired()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorQuotationRequestTimeout")%><i> <%=rdb.getQuoteRequestTimeout()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorShopcartTransferRequestEnabled")%><i> <%=rdb.getShopcartRequestEnabled()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorShopcartTransferRequestAuthorize")%><i> <%=rdb.getShopcartRequestAuthenticationRequired()%></i>
                  <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <%= contractsRB.get("distributorShopcartTransferRequestTimeout")%><i> <%=rdb.getShopcartRequestTimeout()%></i>

               <%}//end of policyID not null%>

            <%}//end for referralTCs.hasMoreElements()%>
         <%}//end if, else%>

      <% } catch (Exception e) {
                  //out.println(e);
            }
      %>

<%} // end if distributor %>
<%//************************************************************************************************************%>

<%//USED FOR ORGANIZATION_BUYER contracts%>

<%if(ContractCmdUtil.isBuyerContract(usage)){%>
<% try {
      PaymentTCDataBean ptc = new PaymentTCDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(ptc, request);
%>

      <%if(ContractCmdUtil.isReferralContract(usage) ){%>
         <h4><%= contractsRB.get("distributorPayment") %></h4>
      <%}else if(ContractCmdUtil.isHostingContract(usage) ){%>
         <h4><%= contractsRB.get("resellerPayment") %></h4>
      <%}else{%>
            <h4><%= contractsRB.get("contractPaymentTitle") %></h4>
       <%}%>

   <%
         String[] displayName = ptc.getDisplayName();
      if (displayName == null || displayName.length == 0) {
   %>
      <%= contractsRB.get("summaryPaymentListNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryPaymentList") %><br />
   <%
        for (int i = 0; i < displayName.length; i++) {
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayName[i] %></i><br />
   <%
        }
         }
   %>

   <%
   ContractDataBean contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(contract, request);
   if (contract.getCreditLineAllowed()) {
   %>
      <%= contractsRB.get("summaryPaymentCreditAllowed") %><br />
   <% } else { %>
      <%if(ContractCmdUtil.isReferralContract(usage) ){%>
         <%= contractsRB.get("distributorPaymentCreditNotAllowed") %><br />
      <%}else if(ContractCmdUtil.isHostingContract(usage) ){%>
         <%= contractsRB.get("resellerPaymentCreditNotAllowed") %><br />
      <%}else{%>
            <%= contractsRB.get("summaryPaymentCreditNotAllowed") %><br />
       <%}%>


   <% }

      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(new Long(contractId), new Integer(fLanguageId), ECContractConstants.EC_ATTR_BILLING);
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

<%//************************************************************************************************************%>

<% try {
   ReturnTCDataBean tcData = new ReturnTCDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>
  <h4><%= contractsRB.get("contractReturnChargePanelPrompt") %></h4>
   <% if (tcData.getReturnChargeReferenceNumber().length() == 0) { %>
      <%= contractsRB.get("summaryReturnsNotAllowed") %><br />
   <% } else {
         PolicyDataBean pdbCharge = new PolicyDataBean();
         pdbCharge.setId(new Long(tcData.getReturnChargePolicyNumber()));
         pdbCharge.setLanguageId(new Integer(fLanguageId));
         pdbCharge.populate();
         PolicyDataBean pdbApproval = new PolicyDataBean();
         pdbApproval.setId(new Long(tcData.getReturnApprovalPolicyNumber()));
         pdbApproval.setLanguageId(new Integer(fLanguageId));
         pdbApproval.populate();
   %>
      <%= contractsRB.get("summaryReturnsText") %> <i><%= pdbCharge.getShortDescription() %></i><br />
      <%= contractsRB.get("summaryReturnsApproval") %> <i><%= pdbApproval.getShortDescription() %></i><br />
   <% } %>

  <h4><%= contractsRB.get("contractReturnPaymentPanelPrompt") %></h4>
   <% if (tcData.getReturnPaymentReferenceNumbers() == null || tcData.getReturnPaymentReferenceNumbers().length == 0) { %>
      <%= contractsRB.get("summaryReturnsPaymentsNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryReturnsPaymentAllowed") %><br />
   <% for (int i = 0; i < tcData.getReturnPaymentReferenceNumbers().length; i++) {
         PolicyDataBean pdbPayment = new PolicyDataBean();
         pdbPayment.setId(new Long(tcData.getReturnPaymentPolicyNumber(i)));
         pdbPayment.setLanguageId(new Integer(fLanguageId));
         pdbPayment.populate();
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdbPayment.getShortDescription() %></i><br />
   <%    }
      } %>

<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   OrderApprovalTCDataBean tc = new OrderApprovalTCDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(tc, request);
%>
  <h4><%= contractsRB.get("contractOrderApprovalHeading") %></h4>
   <% if (tc.getHasOrderApproval() == false) { %>
      <%= contractsRB.get("summaryOrderApprovalNotAllowed") %><br />
   <% } else { %>
      <script type="text/javascript">if (defined(parent.numberToCurrency))
         changeSpecialText('<%= contractsRB.get("summaryOrderApprovalAllowed") %>',
                  false,
                  parent.numberToCurrency(<%=   tc.getValue() %>, "<%=  tc.getCurrency() %>", "<%= fLanguageId %>"),
                  '<%= tc.getCurrency() %>');
         else
         changeSpecialText('<%= contractsRB.get("summaryOrderApprovalAllowed") %>',
                  false,
                  '<%=   tc.getValue() %>',
                  '<%= tc.getCurrency() %>');

</script>

   <% } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ContractDataBean cdb = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
   DataBeanManager.activate(cdb, request);
%>
  <h4><%= contractsRB.get("contractDocumentationPanelPrompt") %></h4>
   <% if (cdb.getContractAttachments().size() == 0) { %>
      <%= contractsRB.get("summaryAttachmentsNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryAttachmentsAllowed") %><br />
      <% Vector docs = cdb.getContractAttachments();
         for (int index = 0; index < docs.size(); index++) {
      %>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= (String)docs.elementAt(index) %></i><br />
      <% } %>
   <% } %>

<!-- REMOVE THIS LINE TO ADD THE HANDLING CHARGES INTO THE PAGE
  <h4><%= contractsRB.get("contractHandlingChargesPanelPrompt") %></h4>
<% try {
     HandlingChargeTCDataBean tc = new HandlingChargeTCDataBean(new Long(contractId), new Integer(fLanguageId));
     DataBeanManager.activate(tc, request);

     java.math.BigDecimal handlingAmount = tc.getHandlingAmount();
     java.math.BigDecimal maximumHandlingAmount = tc.getMaximumHandlingAmount();
     Double maximumPercentage = tc.getMaximumPercentage();
     boolean firstReleaseFree = tc.getFirstReleaseFree();
     String orderCurrency = tc.getOrderCurrency();

     if (handlingAmount == null || handlingAmount.floatValue() <= 0) { %>
       <%= contractsRB.get("summaryHandlingChargesNotAllowed") %><br />
     <% } else { %>
       <%= contractsRB.get("summaryHandlingChargesAllowed") %>
       <script type="text/javascript">
         document.writeln(parent.formatNumber(<%= handlingAmount %>, "<%= fLanguageId %>", 2));
       </script>
       <%= orderCurrency %><br />

       <% if (firstReleaseFree) { %>
         <%= contractsRB.get("contractFirstReleaseFree")%><br />
       <% } %>
       <% if (maximumHandlingAmount != null && maximumHandlingAmount.floatValue() > 0) { %>
         <%= contractsRB.get("summaryHandlingChargesMaximum") %>
         <% if (maximumPercentage != null && maximumPercentage.floatValue() > 0) { %>
           <br />
           <script type="text/javascript">
             changeSpecialText('<%= contractsRB.get("summaryHandlingChargesPercentage") %>',
                               false,
                               parent.formatNumber(<%= maximumHandlingAmount %>, "<%= fLanguageId %>", 2) + ' <%= orderCurrency %>',
                               <%= maximumPercentage %>
                              );
           </script>
         <% } else { %>
           <script type="text/javascript">
             document.writeln(parent.formatNumber(<%= maximumHandlingAmount %>, "<%= fLanguageId %>", 2));
           </script>
           <%= orderCurrency %><br />
         <% } %>
       <% } %>
     <% }
   } catch (Exception e) {
      //out.println(e);
   }
%>
REMOVE THIS LINE TO ADD THE HANDLING CHARGES INTO THE PAGE -->

  <h4><%= contractsRB.get("contractRemarksTitle") %></h4>
   <% if (cdb.getContractComment() == null || cdb.getContractComment().length() == 0) { %>
      <%= contractsRB.get("summaryContractRemarksNotAllowed") %><br />
   <% } else { %>
      <i><script type="text/javascript">document.writeln(decodeNewLinesForHtml('<%= UIUtil.toHTML(cdb.getContractComment()) %>'))
</script></i><br />
   <% } %>
   <%
	 	request.setAttribute("summaryTradingId",contractId);
	 	%><jsp:include page="ExtendedTCSummary.jsp" /><% 
 } catch (Exception e) {
      //out.println(e);
   }
%>

   
<%if(ContractCmdUtil.isBuyerContract(usage)){%>

<h4><%= contractsRB.get("CCL_SummaryTitle") %></h4>

<%
   /*90288*/
   //-------------------------------------------------------------
   // The following code segment performs the job of retrieving
   // all the lock details for a given contract ID
   //-------------------------------------------------------------
   try
   {
      // Prepare the lock record keys. Each key is a combination of
      // a contract id and the terms and conditions type in hashcode integer.
      Long lockKeyForPriceTC[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_PRICE_TC.hashCode()) };
      Long lockKeyForShippingTC[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_SHIPPING_TC.hashCode()) };
      Long lockKeyForPaymentTC[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_PAYMENT_TC.hashCode()) };
      Long lockKeyForReturnTC[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_RETURN_TC.hashCode()) };
      Long lockKeyForOrderApprovalTC[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_ORDERAPPROVAL_TC.hashCode()) };
      Long lockKeyForGeneralPages[]
         = { new Long(contractId), new Long(ECContractConstants.EC_ELE_CONTRACT.hashCode()) };

      //===============================================================
      // *DEVELOPER'S NOTE*
      // To support a new TC type, please add a similar declaration
      // statement here to define a lock key pair for the new TC.
      //
      // For example,
      //
      //    Long lockKeyForMyNewTC[]
      //       = { new Long(contractId),
      //           new Long("MyNewTC".hashCode()) };
      //
      //===============================================================



      //=========================================================
      // *DEVELOPER'S NOTE*
      // If you add a new TC, please increment the numeric value
      // of the variable numOfKeys by 1.
      //
      // For example,
      //   int numOfKeys = 7;
      //
      //=========================================================
      int numOfKeys = 6; // currently support 6 TCs


      ManagedResourceKey[] myManagedRescKeys = new ManagedResourceKey[numOfKeys];
      for (int k1=0; k1<numOfKeys; k1++)
      {
         myManagedRescKeys[k1] = new ManagedResourceKey();
      }
      myManagedRescKeys[0].setInternalKeys(lockKeyForPriceTC);
      myManagedRescKeys[1].setInternalKeys(lockKeyForShippingTC);
      myManagedRescKeys[2].setInternalKeys(lockKeyForPaymentTC);
      myManagedRescKeys[3].setInternalKeys(lockKeyForReturnTC);
      myManagedRescKeys[4].setInternalKeys(lockKeyForOrderApprovalTC);
      myManagedRescKeys[5].setInternalKeys(lockKeyForGeneralPages);

      //===============================================================
      // *DEVELOPER'S NOTE*
      // To support a new TC type, please add a similar assignment
      // statement here to set the new lock key for the new TC.
      //
      // For example,
      //
      //   myManagedRescKeys[6].setInternalKeys(lockKeyForMyNewTC);
      //
      //===============================================================


      // Obtain the resource manager that will manage the resource TERMCOND
      ResourceManager myRescManager = ContractContainer.singleton().getResourceManager(ContractContainer.RESOURCE_TERMCOND);

      // Retrieve the locks details for the contract
      LockData[] lockInfo = myRescManager.getLockData(myManagedRescKeys);
      String lockDetailsLine = (String) contractsRB.get("CCL_MsgUnlockConfirm2");
      boolean contractHasLocks = false;

      for (int k3=0; k3<lockInfo.length; k3++)
      {
         if (lockInfo[k3]!=null)
         {

            if (!contractHasLocks)
            {
               %>
               <%= contractsRB.get("CCL_MsgUnlockConfirm1") %> <br />
               <%
            }

            contractHasLocks = true;
            String lockTimeStamp = (lockInfo[k3].getLockTimestamp()==null)? " " : TimestampHelper.getDateTimeFromTimestamp(lockInfo[k3].getLockTimestamp(), fLocale);
            String memberIdStr   = (lockInfo[k3].getMemberId()==null)? "" : lockInfo[k3].getMemberId().toString();
            String tcName = "";

            // Retrieve the logon ID for the lock owner
            UserDataBean dbUser = new UserDataBean();
            dbUser.setDataBeanKeyMemberId(memberIdStr);
            dbUser.setCommandContext(contractCommandContext);
            dbUser.populate();

            switch(k3)
            {
               case 0: tcName = (String) contractsRB.get("CCL_TCName_CatalogFilter");  break;
               case 1: tcName = (String) contractsRB.get("CCL_TCName_Shipping");       break;
               case 2: tcName = (String) contractsRB.get("CCL_TCName_Payment");        break;
               case 3: tcName = (String) contractsRB.get("CCL_TCName_Returns");        break;
               case 4: tcName = (String) contractsRB.get("CCL_TCName_OrderApproval");  break;
               case 5: tcName = (String) contractsRB.get("CCL_TCName_OtherPages");     break;

               //===============================================================
               // *DEVELOPER'S NOTE*
               // To support a new TC type, please add a similar case statement
               // here.
               //
               // For example,
               //
               //    case 6: tcName = (String) contractsRB.get("CCL_TCName_MyNewTC"); break;
               //
               //===============================================================

            }

            if (k3==5)
            {
               // For General, Participants, Remarks and Attachments Pages,
               // use different message key.
               lockDetailsLine = (String) contractsRB.get("CCL_MsgUnlockConfirm2P");
            }

            %>
            <i>
            <script type="text/javascript">changeSpecialText('<%= UIUtil.toJavaScript(lockDetailsLine) %>',
                    true,
                    '<%= UIUtil.toJavaScript(dbUser.getLogonId()) %>',
                    '<%= UIUtil.toJavaScript(lockTimeStamp) %>',
                    '<%= UIUtil.toJavaScript(tcName) %>');
            </script>
            </i><br />
            <%
         }

      }//end-for-k3

      if (!contractHasLocks)
      {
         %>
         <%= contractsRB.get("CCL_NotInLock") %> <br />
         <%
      }
   }
   catch (Exception e)
   {
      e.printStackTrace();
   }
   /*90288*/


} // end if buyer contract
%>

<% // only show account for customer contract
if (contractAccountId != null && contractId.equals(customerContractId)) { %>
<br />
<br />
<h2><%= contractsRB.get("accountSummaryTitle") %></h2>
<% try {
    AccountDataBean account = new AccountDataBean(contractAccountId, new Integer(fLanguageId));
    account.setContractId(customerContractId);
    DataBeanManager.activate(account, request);
%>
  <h4><%= contractsRB.get("accountCustomerPanelTitle") %></h4>

   <%= contractsRB.get("summaryAccountCustomerOrganization") %> <i><%= account.getCustomerName() %></i><br />
   <%= contractsRB.get("summaryAccountCustomerContact") %> <i><%= account.getCustomerContactName() %></i><br />
   <%= contractsRB.get("summaryAccountCustomerContactInformation") %> <i><%= account.getCustomerContactInformation() %></i><br />
   <% if (account.getAllowCatalogPurchases() == true) { %>
      <%= contractsRB.get("summaryAccountPurchasesAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryAccountPurchasesNotAllowed") %><br />
   <% } %>
   <%
      String accountName = account.getAccountName();
      if (accountName != null && accountName.indexOf("BaseContracts") >= 0) {
   %>
         <%= contractsRB.get("accountCustomerBaseContracts") %><br />
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
         <%= contractsRB.get("accountCustomerPriceListPreference") %>: <i><%= UIUtil.toJavaScript((String) contractsRB.get("priceList_displayText_type_" + (plTypeCount + 1))) %></i><br />
    <%      if (account.getMustUsePriceListPreference()) {
    %>
            <%= contractsRB.get("accountCustomerMustUsePriceListPreference") %><br />
    <%      }
         break;
       }
       plTypeCount++;
         }
      } // end priceListPref
   %>

  <h4><%= contractsRB.get("accountRepresentativePanelTitle") %></h4>

   <%= contractsRB.get("summaryAccountRepresentativeOrganization") %> <i><%= account.getSellingOrgName() %></i><br />
   <%= contractsRB.get("summaryAccountRepresentativeDepartment") %>
      <% if (account.getRepresentativeName() != null) { %>
         <i><%= account.getRepresentativeName() %></i><br />
      <% } else { %>
         <br />
      <% } %>
   <%= contractsRB.get("summaryAccountRepresentativeRep") %> <i><%= account.getRepresentativeContactName() %></i><br />

<% } catch (Exception e) {
      //out.println(e);
   }
%>



<%
   try
   {
      DisplayCustomizationTCDataBean tc = new DisplayCustomizationTCDataBean(contractAccountId,
                                                                             new Integer(fLanguageId));
      DataBeanManager.activate(tc, request);
%>

   <h4><%= contractsRB.get("accountDisplayCustomizationTitle") %></h4>

   <%
      if (tc.getHasDisplayLogo())
      {
   %>
         <%= contractsRB.get("summaryDisplayCustomizationLogo") %> <i><%= tc.getAttachment(1).getAttachmentURL() %></i><br />
   <%
      }
     else
      {
   %>
         <%= contractsRB.get("summaryDisplayCustomizationLogo") %> <i></i><br />
   <%
      }
   %>
      <%= contractsRB.get("summaryDisplayCustomizationTextField1") %>
      <% if (tc.getDisplayText(1) != null) { %>
            <i><%= tc.getDisplayText(1) %></i>
      <% } %>
      <br />
      <%= contractsRB.get("summaryDisplayCustomizationTextField2") %>
      <% if (tc.getDisplayText(2) != null) { %>
            <i><%= tc.getDisplayText(2) %></i>
      <% } %>
      <br />
<%
   }
   catch (Exception e)
   {
      //out.println(e);
   }
%>


<% try {
   PurchaseOrderTCDataBean potc = new PurchaseOrderTCDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(potc, request);

   String[] POBNumber = potc.getPOBNumber();
   String[] POLNumber = potc.getPOLNumber();
   String[] POLCurrency = potc.getPOLCurrency();
   String[] POLValue = potc.getPOLValue();
%>
  <h4><%= contractsRB.get("contractPurchaseOrderTitle") %></h4>
   <% if (potc.getPOIndividual() == 1) { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualAllowed") %><br />
      <%= contractsRB.get("summaryPurchaseOrderUniquenessAllowed") %><br />
   <% } else if (potc.getPOIndividual() == 0) { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualAllowed") %><br />
      <%= contractsRB.get("summaryPurchaseOrderUniquenessNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryPurchaseOrderIndividualNotAllowed") %><br />
   <% } %>

   <% if (potc.getPOLNumber() != null) {
        for (int i = 0; i < potc.getPOLNumber().length; i++) { %>
      <script type="text/javascript">if (defined(parent.numberToCurrency))
         changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryPurchaseOrderSpendingAllowed")) %>',
                  false,
                  '<%= UIUtil.toJavaScript((String)POLNumber[i]) %>',
                  parent.numberToCurrency(<%= POLValue[i] %>, "<%= POLCurrency[i] %>", "<%= fLanguageId %>"),
                  '<%= POLCurrency[i] %>');
         else
         changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryPurchaseOrderSpendingAllowed")) %>',
                  false,
                  '<%= UIUtil.toJavaScript((String)POLNumber[i]) %>',
                  '<%= POLValue[i] %>',
                  '<%= POLCurrency[i] %>');

</script>
      <br />
   <%   }
      } %>

   <% if (potc.getPOBNumber() != null) {
        for (int i = 0; i < potc.getPOBNumber().length; i++) { %>
      <script type="text/javascript">changeSpecialText('<%= UIUtil.toJavaScript((String)contractsRB.get("summaryPurchaseOrderSpendingNotAllowed")) %>',
                  false,
                  '<%= UIUtil.toJavaScript((String)POBNumber[i]) %>');

</script>
      <br />
   <%   }
      } %>

<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   InvoicingTCDataBean tc = new InvoicingTCDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(tc, request);
%>
  <h4><%= contractsRB.get("contractInvoicingPanelPrompt") %></h4>
   <% if (!tc.getHasEMail() && !tc.getHasInTheBox() && !tc.getHasRegularMail()) { %>
      <%= contractsRB.get("summaryInvoicingNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryInvoicingAllowed") %><br />
      <% if (tc.getHasEMail()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingEmail") %></i><br />
      <% }
         if (tc.getHasInTheBox()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingInTheBox") %></i><br />
      <% }
         if (tc.getHasRegularMail()) { %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= contractsRB.get("contractInvoicingRegularMail") %></i><br />
   <%       }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   PaymentTCDataBean ptc = new PaymentTCDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(ptc, request);
%>
  <h4><%= contractsRB.get("accountFinancialFormPanelTitle") %></h4>
   <%
      String[] displayName = ptc.getDisplayName();
      if (displayName != null && displayName.length > 0) {
   %>
      <%= contractsRB.get("summaryFinancialCreditLineAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryFinancialCreditLineNotAllowed") %><br />
   <% } %>

<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
      PaymentTCDataBean ptc = new PaymentTCDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(ptc, request);
%>

   <h4><%= contractsRB.get("contractPaymentTitle") %></h4>

   <%
         String[] displayName = ptc.getDisplayName();
         String[] paymentPolicyName = ptc.getPolicyName();
      if (displayName == null || displayName.length == 0 ||
         (displayName.length == 1 && PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[0]))) {
   %>
         <%= contractsRB.get("summaryPaymentListNotAllowed") %><br />
   <%    } else { %>
         <%= contractsRB.get("summaryPaymentList") %><br />
   <%
         for (int i = 0; i < displayName.length; i++) {
            if (!PaymentPolicyListDataBean.isCreditPaymentPolicy(paymentPolicyName[i])) {
   %>
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= displayName[i] %></i><br />
   <%          }
         }
         }

      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(contractAccountId, new Integer(fLanguageId), ECContractConstants.EC_ATTR_BILLING);
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
   ShippingTCShippingModeDataBean tcData = new ShippingTCShippingModeDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingModePanelPrompt") %></h4>
   <% if (tcData.getShippingMode().size() == 0) { %>
      <%= contractsRB.get("summaryShippingModesNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingModesAllowed") %><br />
   <% for (int i = 0; i < tcData.getShippingMode().size(); i++) {
         Vector tcElement = tcData.getShippingMode(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br />
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShippingChargeDataBean tcData = new ShippingTCShippingChargeDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingChargePanelPrompt") %></h4>
   <% if (tcData.getShippingCharge().size() == 0) { %>
      <%= contractsRB.get("summaryShippingChargeTypeNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingChargeTypeAllowed") %><br />
   <%
      for (int i = 0; i < tcData.getShippingCharge().size(); i++) {
         Vector tcElement = tcData.getShippingCharge(i);
         PolicyDataBean pdb = new PolicyDataBean();
         pdb.setId(new Long((String)tcElement.elementAt(1)));
         pdb.setLanguageId(new Integer(fLanguageId));
         pdb.populate();
         //DataBeanManager.activate(pdb, request);
   %>
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= pdb.getShortDescription() %></i><br />
   <% }
      } %>
<% } catch (Exception e) {
      //out.println(e);
   }
%>

<% try {
   ShippingTCShipToAddressDataBean tcData = new ShippingTCShipToAddressDataBean(contractAccountId, new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);
%>

  <h4><%= contractsRB.get("contractShippingAddressPanelPrompt") %></h4>
   <% if (tcData.getShippingAddress().size() == 0) { %>
      <%= contractsRB.get("summaryShippingAddressesNotAllowed") %><br />
   <% } else { %>
      <%= contractsRB.get("summaryShippingAddressesAllowed") %><br />

<%
         AccountDataBean account = new AccountDataBean(contractAccountId, new Integer(fLanguageId));
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

               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%= adb.getNickName() %></i><br />

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

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;<%=strZipCode%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%><%=strCity%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br /><br />

      <%       } else if (fLocale.toString().equals("fr_FR")||fLocale.toString().equals("de_DE")){ %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strZipCode%>&nbsp;<%=strCity%></i><br />
                  <% if (fLocale.toString().equals("de_DE")) { %>
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strState%></i><br />
                  <% } %>
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br /><br />
      <%       } else { %>

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strAddress1%>&nbsp;<%=strAddress2%>&nbsp;<%=strAddress3%></i><br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCity%>&nbsp;<%=strState%>&nbsp;<%=strZipCode%></i> <br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i><%=strCountry%>&nbsp;</i><br /><br />
      <%          }
            } // end if addressId
         } // end for
      } // end if

      AddressBookTCDataBean tcDataAdrBook = new AddressBookTCDataBean(contractAccountId, new Integer(fLanguageId), ECContractConstants.EC_ATTR_SHIPPING);
      DataBeanManager.activate(tcDataAdrBook, request);
      boolean personalAdrBook = tcDataAdrBook.getUsePersonalAddressBook();
      boolean parentAdrBook = tcDataAdrBook.getUseParentOrgAddressBook();
      boolean accountAdrBook = tcDataAdrBook.getUseAccountAddressBook();
      if (personalAdrBook == true || parentAdrBook == true || accountAdrBook == true) {
%>
       <br /><%= contractsRB.get("summaryShippingAddressBooks") %><br />
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

<%//************************************************************************************************************%>

<% try {
     ShippingTCShippingChargeAdjustmentFilterDataBean tcData = new ShippingTCShippingChargeAdjustmentFilterDataBean();
     tcData.setContractId(contractAccountId);
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
               if (defined(parent.numberToCurrency)) {
                 document.write(parent.numberToCurrency('<%=scdb.getAdjustmentValue()%>','<%=scdb.getCurrency()%>','<%=fLanguageId%>'));
               } else {
                 document.write('<%=scdb.getAdjustmentValue()%>');
               }
               </script>
               <%=scdb.getCurrency()%>
<%           } else if (scdb.getAdjustmentType() == scdb.ADJUSTMENT_TYPE_PERCENTAGE_OFF) { %>
               <script type="text/javascript">
               if (defined(parent.numberToStr)) {
                 document.write(parent.numberToStr('<%=scdb.getAdjustmentValue()%>','<%=fLanguageId%>'));
               } else {
                 document.write('<%=scdb.getAdjustmentValue()%>');
               }
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
    AccountDataBean account = new AccountDataBean(contractAccountId, new Integer(fLanguageId));
    account.setContractId(customerContractId);
    DataBeanManager.activate(account, request);
%>

  <h4><%= contractsRB.get("accountRemarksTitle") %></h4>
   <% if (account.getAccountRemarks() == null || account.getAccountRemarks().length() == 0) { %>
      <%= contractsRB.get("summaryAccountRemarksNotAllowed") %><br />
   <% } else { %>
      <i><script type="text/javascript">document.writeln(decodeNewLinesForHtml('<%= UIUtil.toJavaScript(account.getAccountRemarks()) %>'))
</script></i><br />
   <% } %>
   <%
	 	request.setAttribute("summaryTradingId",contractAccountId.toString());
	 	%><jsp:include page="ExtendedTCSummary.jsp" /><% 
 } catch (Exception e) {
      //out.println(e);
   }
%>

<% } // end if for contractAccountId is not null %>
<%}//end if we are not in distributor or reseller%>

<% } // end while (nextContractIdToDisplay != null)
} catch (Exception e) {
 e.printStackTrace();
}

%>
<br />
</body>
</html>
