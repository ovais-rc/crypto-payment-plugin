

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

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.

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
   com.ibm.commerce.utils.TimestampHelper,
   com.ibm.commerce.contract.helper.ECContractConstants,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.price.utils.*,
   com.ibm.commerce.user.beans.OrganizationDataBean,
   com.ibm.commerce.tools.contract.beans.ProductSetTCDataBean,
   com.ibm.commerce.tools.contract.beans.ContractListDataBean,
   com.ibm.commerce.tools.contract.beans.AccountListDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.ejb.helpers.SessionBeanHelper,
   com.ibm.commerce.common.objects.StoreRelationshipJDBCHelperBean" %>

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
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_GENERAL_OTHERS_PAGES);
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
   String contractName = null;
   String contractReference = null;
   boolean doesNotHaveContractReference = false;
   ContractDataBean contract = null;

   if (foundContractId) {
      contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
      contract.setCommandContext(contractCommandContext);
      DataBeanManager.activate(contract, request);

      String cRef = contract.getReferenceContractId();
      if (cRef == null || cRef.length() == 0) {
         doesNotHaveContractReference = true;
      }
      else {
         // has a contract reference
         contractReference = cRef;
         doesNotHaveContractReference = false;
      }
   } else {
      doesNotHaveContractReference = true;
   }
%>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractGeneralPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">



//------------------------------------------------------------------------
// Function Name: prepareUnlockWarningMsgMap
//
// This function store the message chunks to the parent for preparing
// a proper warning message to be displayed to user.
//------------------------------------------------------------------------
function prepareUnlockWarningMsgMap()
{
   parent.setUnlockWarningMsgMap("msgInvalidLockForTC", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockTCByOthers")) %>" );
   parent.setUnlockWarningMsgMap("msgInvalidLockForPages", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockPagesByOthers")) %>" );
   parent.setUnlockWarningMsgMap("tcNamePricing", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>" );
   parent.setUnlockWarningMsgMap("tcNameShipping", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Shipping")) %>" );
   parent.setUnlockWarningMsgMap("tcNamePayment", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Payment")) %>" );
   parent.setUnlockWarningMsgMap("tcNameReturns", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Returns")) %>" );
   parent.setUnlockWarningMsgMap("tcNameOrderApproval", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OrderApproval")) %>" );
   parent.setUnlockWarningMsgMap("tcNameGeneralPages", "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OtherPages")) %>" );
}



function showContractGeneralFormDivisions()
 {
  with (document.generalForm)
   {
      contractGeneralFormDiv.style.display = "block";
   }
 }

function showEndDateDivisions()
 {
  with (document.generalForm)
   {
    var runLong = NeverExpires.checked;
    if (runLong == true)
     {
      endDateDiv.style.display = "none";
     }
    else
     {
      if(EndYear.value == '' && EndMonth.value == '' && EndDay.value == ''){
      EndYear.value = getCurrentYear() + 1;
   EndMonth.value = getCurrentMonth();
   EndDay.value = getCurrentDay();
   EndTime.value = "00:00";
      }
      endDateDiv.style.display = "block";
     }
   }
 }

function showStartDateDivisions()
 {
  with (document.generalForm)
   {
    var runLong = StartImmediate.checked;
    if (runLong == true)
     {
      startDateDiv.style.display = "none";
     }
    else
     {
      if(StartYear.value == '' && StartMonth.value == '' && StartDay.value == ''){
      StartYear.value = getCurrentYear();
   StartMonth.value = getCurrentMonth();
   StartDay.value = getCurrentDay();
   StartTime.value = "00:00";
      }
      startDateDiv.style.display = "block";
     }
   }
 }

function loadPanelData() {

  with (document.generalForm) {

    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(false);
    }

    var refSelected = 0;

    if (parent.get) {
      var hereBefore = parent.get("ContractGeneralModelLoaded", null);
      if (hereBefore != null) {
   //alert('General - back to same page - load from model');
   // have been to this page before - load from the model
        var o = parent.get("ContractGeneralModel", null);
   if (o != null) {
      loadValue(Name, o.name);
           loadValue(Title, o.title);
      loadValue(Description, o.description);
      NeverExpires.checked = o.endNeverExpires;
      StartImmediate.checked = o.StartImmediateChecked;

      if (o.StartImmediateChecked == false) {
         loadValue(StartYear, o.startYear);
         loadValue(StartMonth, o.startMonth);
         loadValue(StartDay, o.startDay);
         loadValue(StartTime, o.startTime);

      }
      if (o.endNeverExpires == false) {
         loadValue(EndYear, o.endYear);
         loadValue(EndMonth, o.endMonth);
         loadValue(EndDay, o.endDay);
         loadValue(EndTime, o.endTime);
      }

      refSelected = o.contractReferenceSelected;
      <% if (doesNotHaveContractReference == true) { %>
         ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("contractReferenceListOne"))%>", "0", true, true);
      <% } else { %>
         ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("keepExistingReference"))%>", "0", false, false);
      <% } %>
      for (var i = 0; i < o.contractReferenceList.length; i++) {
         if (o.contractReferenceSelected == (i + 1)) {
            ContractReference.options[i+1] = new Option(o.contractReferenceList[i].name,
                           i, true, true);
         } else {
            ContractReference.options[i+1] = new Option(o.contractReferenceList[i].name,
                           i, false, false);
         }
      }
   } // end if model is found
     } // end if here before
     else {
   // this is the first time on this page
   //alert('General - first time on page');

   // create the model
        var cgm = new ContractGeneralModel();
        parent.put("ContractGeneralModel", cgm);
   parent.put("ContractGeneralModelLoaded", true);

   //alert('Acct <%= accountId %>');

   cgm.priceListMismatchMessageText = "<%=UIUtil.toJavaScript((String)contractsRB.get("priceListMismatch"))%>";

   /***********************************************************************/
   // create the common data model
   /***********************************************************************/
   var ccdm = new ContractCommonDataModel();
   parent.put("ContractCommonDataModel", ccdm);

   var currArray = new Array();
<%
   StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
   // get the supported currencies for a store
   CurrencyManager cm = CurrencyManager.getInstance();
   String[] supportedCurrencies = cm.getSupportedCurrencies(storeAB);
   String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());

   // supported and default currencies for store
   for (int i=0; i<supportedCurrencies.length; i++) {
%>
   currArray[<%= i %>] = "<%= supportedCurrencies[i] %>";
<%
   }

   // master catalog id for store
   String catalogId = "";
   String catalogIdentifier = "";
   String catalogMemberId = "";
   try {
      catalogId = storeAB.getMasterCatalog().getCatalogReferenceNumber();
      catalogIdentifier = storeAB.getMasterCatalog().getIdentifier();
      catalogMemberId = storeAB.getMasterCatalog().getMemberId();
   }
   catch (Exception e) {
      StoreDataBean sdb = new StoreDataBean(storeAB);
      CatalogDataBean cdb[] = sdb.getStoreCatalogs();
      for (int i=0; i<cdb.length; i++) {
         catalogId = cdb[i].getCatalogId();
         catalogIdentifier = cdb[i].getIdentifier();
         catalogMemberId = cdb[i].getMemberId();
         break;
      }
   }
%>
   ccdm.storeCurrArray = currArray;
   ccdm.storeDefaultCurr = "<%= defaultCurrency %>";
   ccdm.storeId = "<%= fStoreId %>";
   ccdm.flanguageId = "<%= fLanguageId %>";
   ccdm.fLocale = "<%= fLocale %>";
   ccdm.catalogId = "<%= catalogId %>";
   ccdm.catalogIdentifier = "<%= UIUtil.toJavaScript(catalogIdentifier) %>";
   ccdm.catalogMemberId = "<%= catalogMemberId %>";
   ccdm.storeMemberId = "<%= fStoreMemberId %>";
   ccdm.storeIdentity = "<%= UIUtil.toJavaScript(fStoreIdentity) %>";

   <%
   try {
           MemberDataBean mdb = new MemberDataBean();
           mdb.setId(catalogMemberId);
           DataBeanManager.activate(mdb, request);
   %>
           ccdm.catalogMemberDN = "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>"; // this should be deprecated... just use the XML compliant object below instead...
           ccdm.CatalogOwner = new CatalogOwner('<%= mdb.getMemberType() %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                     '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>');
   <%
   }
   catch (Exception e) {
   }
   %>

   <%
   try {
           MemberDataBean mdb = new MemberDataBean();
           mdb.setId(fStoreMemberId.toString());
           DataBeanManager.activate(mdb, request);
   %>
           ccdm.storeMemberDN = "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>"; // this should be deprecated... just use the XML compliant object below instead...
           ccdm.StoreOwner = new StoreOwner('<%= mdb.getMemberType() %>',
                                                 '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                 '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                 '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                 '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>');
   <%
   }
   catch (Exception e) {
   }
   %>

   <%
   try {
      AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
      DataBeanManager.activate(account, request);

           MemberDataBean mdb = new MemberDataBean();
           mdb.setId(account.getOwnerReferenceNumber().toString());
           DataBeanManager.activate(mdb, request);
        %>
      cgm.accountName = "<%= UIUtil.toJavaScript(account.getAccountName()) %>";
      cgm.accountOwnerReferenceNumber = "<%= account.getOwnerReferenceNumber() %>";
      cgm.accountOwnerReferenceDN = '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>'; // this should be deprecated... just use the XML compliant object below instead...
           ccdm.AccountOwner = new AccountOwner('<%= mdb.getMemberType() %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                     '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>');
   <%
      // if baseContract param is not set, then set it
      boolean setBaseContractParam = false;
         try {
            String baseContractParm = contractCommandContext.getRequestProperties().getString("baseContract");
            if (baseContractParm == null || baseContractParm.length() == 0)
               setBaseContractParam = true;
         } catch (Exception e) {
               setBaseContractParam = true;
         }
         // this means the parameter was not passed in
         if (setBaseContractParam == true && account.getAccountName() != null) {
            if (account.getAccountName().indexOf("BaseContracts") >= 0) {
      %>
               parent.put("baseContract", true);
      <%    } else { %>
               parent.put("baseContract", false);
      <%    }  %>
         var contractPanel = parent.pageArray["genericCatalogFilterTitle"];
         contractPanel.parms[contractPanel.parms.length] = "baseContract";
   <% }
   }
   catch (Exception e) {
   }
   %>

   // check if this is an update
   if (<%= foundContractId %> == true) {
      //alert('Load from the databean');
      // load the data from the databean
      cgm.referenceNumber = "<%= contractId %>";
      if (<%= doesNotHaveContractReference %> == false) {
         ccdm.referenceNumber = "<%= contractReference %>";
      }

      <%
      // Create an instance of the databean to use if we are doing an update
      if (foundContractId) {
         out.println("cgm.priceListType = \"" + contract.getPriceListType(true) + "\";");
         out.println("cgm.lastUpdateTime = \"" + contract.getUpdateDate() + "\";");
         out.println("Name.value = \"" + UIUtil.toHTML((String)contract.getContractName()) + "\";");
         contractName = UIUtil.toHTML((String)contract.getContractName());

         out.println("Title.value = \"" + UIUtil.toJavaScript((String)contract.getContractTitle()) + "\";");
         out.println("Description.value = decodeNewLines('" + UIUtil.toJavaScript((String)contract.getContractDescription()) + "');");
         if (contract.getStartDate() == null) {
         //Use default StartDate
         out.println("StartImmediate.checked = true;");
         /*
         out.println("StartYear.value = getCurrentYear();");
         out.println("StartMonth.value = getCurrentMonth();");
         out.println("StartDay.value = getCurrentDay();");
         out.println("StartTime.value = \"00:00\";");
         */
         }
      else {
           //Use user StartDate
         out.println("StartImmediate.checked = false;");
         out.println("StartYear.value = \"" + TimestampHelper.getYearFromTimestamp(contract.getStartDate()) + "\";");
            out.println("StartMonth.value = \"" + TimestampHelper.getMonthFromTimestamp(contract.getStartDate()) + "\";");
            out.println("StartDay.value = \"" + TimestampHelper.getDayFromTimestamp(contract.getStartDate()) + "\";");
            out.println("StartTime.value = \"" + TimestampHelper.getTimeFromTimestamp(contract.getStartDate()) + "\";");
         }


      if (contract.getEndDate() == null) {
         out.println("NeverExpires.checked = true;");
         /*
         out.println("EndYear.value = parseInt(StartYear.value) + 1");
            out.println("EndMonth.value = StartMonth.value;");
            out.println("EndDay.value = StartDay.value;");
            out.println("EndTime.value = StartTime.value;");
            */
         }
      else {
         out.println("NeverExpires.checked = false;");
         out.println("EndYear.value = \"" + TimestampHelper.getYearFromTimestamp(contract.getEndDate()) + "\";");
         out.println("EndMonth.value = \"" +  TimestampHelper.getMonthFromTimestamp(contract.getEndDate()) + "\";");
         out.println("EndDay.value = \"" +  TimestampHelper.getDayFromTimestamp(contract.getEndDate()) + "\";");
         out.println("EndTime.value = \"" +  TimestampHelper.getTimeFromTimestamp(contract.getEndDate()) + "\";");
      }
         out.println("cgm.majorVersionNumber = \"" +  contract.getMajorVersionNumber() + "\";");
         out.println("cgm.minorVersionNumber = \"" +  contract.getMinorVersionNumber() + "\";");
         out.println("cgm.origin = \"" +  contract.getContractOrigin() + "\";");
         out.println("cgm.usage = \"" +  contract.getContractUsage() + "\";");
         out.println("cgm.creditLineAllowed = " +  contract.getCreditLineAllowed() + ";");
         out.println("cgm.remarks = \"" + UIUtil.toJavaScript((String)contract.getContractComment()) + "\";");

                        // we need to know if this updated contract has any inclusions or exclusions...
         ProductSetTCDataBean tcData = new ProductSetTCDataBean(new Long(contractId), new Integer(fLanguageId));
         DataBeanManager.activate(tcData, request);

         if (tcData.getCustomInclusionPS().size() > 0 ||
             tcData.getCustomExclusionPS().size() > 0 ||
             tcData.getStandardInclusionPS().size() > 0 ||
             tcData.getStandardExclusionPS().size() > 0) {
             out.println("ccdm.contractHasInclusionExclusionTCs = true;");
         }
         else {
             out.println("ccdm.contractHasInclusionExclusionTCs = false;");
         }
      }
      %>
   } // end if update contract mode 1st time load
   else { // new contract 1st time load
      StartImmediate.checked = false;
      StartYear.value = getCurrentYear();
      StartMonth.value = getCurrentMonth();
      StartDay.value = getCurrentDay();
      StartTime.value = "00:00";
      NeverExpires.checked = false;
      showEndDateDivisions();
      showStartDateDivisions();
      EndYear.value = getCurrentYear() + 1;
      EndMonth.value = getCurrentMonth();
      EndDay.value = getCurrentDay();
      EndTime.value = "00:00";
   }

   var contractRefList = new Array();
   var descriptionArray = new Array();
        <%
   //ContractListDataBean contractList =
   //   new ContractListDataBean(new Long(accountId), fLanguageId, "name", "ActivatedList", fStoreId.toString(), ECContractConstants.EC_CONTRACT_USAGE_TYPE_ORGANIZATION_BUYER.intValue() );
   //contractList.setUseCursor(false);
   //DataBeanManager.activate(contractList, request);
   //ContractDataBean contracts[]  = contractList.getContractList();
   int loopOne = 0;
   %>

   <% if (doesNotHaveContractReference == true) { %>
      ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("contractReferenceListOne"))%>", "0", true, true);
   <% } else { %>
      ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("keepExistingReference"))%>", "0", false, false);
   <% } %>
   descriptionArray[0] = new Object();
   descriptionArray[0].store = "";
   descriptionArray[0].account = "";

   <% // REMOVE CODE WHERE IT LISTs CONTRACTS IN THE SAME ACCOUNT TO USE AS A BASE CONTRACT
      //for (int i = 0; i < contracts.length; i++) {
      //    loopOne = i + 1;
      //    ContractDataBean cdb = contracts[i];
      //         MemberDataBean mdb = new MemberDataBean();
      //         mdb.setId(cdb.getMemberId().toString());
      //       DataBeanManager.activate(mdb, request);
   %>
      // if this code is put back in, need to add < to every %= tag
      //    contractRefList[contractRefList.length] = new ContractReferenceElement('%= UIUtil.toJavaScript(cdb.getContractName()) %>',
      //                     '%= cdb.getContractOrigin() %>',
      //                     '%= cdb.getMajorVersionNumber() %>',
      //                     '%= cdb.getMinorVersionNumber() %>',
      //                     '%= mdb.getMemberType() %>',
           //                                             '%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
           //                                              '%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
           //                                                  '%= mdb.getMemberGroupOwnerMemberType() %>',
      //                                                     '%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>',
      //                                                     '%= cdb.getContractId() %>', '%= cdb.getPriceListType() %>');
      //    if ("%= contractReference %>" == "%= cdb.getContractId() %>") {
      //       refSelected = "%= loopOne %>";
      //       ContractReference.options[%= i+1 %>] = new Option("%= UIUtil.toJavaScript(cdb.getContractName()) %>",
      //                      "%= i+1 %>", true, true);
      //    } else {
      //       ContractReference.options[%= i+1 %>] = new Option("%= UIUtil.toJavaScript(cdb.getContractName()) %>",
      //                      "%= i+1 %>", false, false);
      //    }
      //    descriptionArray[%= loopOne %>] = new Object();
      //    descriptionArray[%= loopOne %>].store = "%= UIUtil.toJavaScript(fStoreId.toString()) %>";
      //    descriptionArray[%= loopOne %>].account = "%= UIUtil.toJavaScript(accountId) %>"; 
   <% //}
   // get from base contracts accounts
   try{
   Integer[] relatedStores = SessionBeanHelper
						.lookupSessionBean(StoreRelationshipJDBCHelperBean.class).findRelatedStores(fStoreId, com.ibm.commerce.server.ECConstants.EC_STRELTYP_CONTRACT);
   // loop through the related stores
   // if there is not one, always look in same store
   //System.out.println("relatedStores.length " + relatedStores.length);
   if (relatedStores.length == 0) {
      relatedStores = new Integer[1];
      relatedStores[0] = fStoreId;
   }

   for (int rel=0; rel<relatedStores.length; rel++) {
     //System.out.println("relatedStore " + relatedStores[rel].toString());
     AccountListDataBean baseAccountList = new AccountListDataBean();
     StoreAccessBean storeABRel = com.ibm.commerce.server.WcsApp.storeRegistry.find(relatedStores[rel]);
     baseAccountList.setUseCursor(false);
     baseAccountList.setAccountNameLike("BaseContracts");
     baseAccountList.setStoreId(relatedStores[rel].toString());
     baseAccountList.setRequestProperties(contractCommandContext.getRequestProperties());
     baseAccountList.setCommandContext(contractCommandContext);
     baseAccountList.populate();
     AccountDataBean baseAccounts[]  = baseAccountList.getAccountList();
     if (baseAccounts != null) {
      for (int aLoop = 0; aLoop < baseAccounts.length; aLoop++) {
         String baseAccountId = baseAccounts[aLoop].getAccountId();
         // make sure we don't list the same contracts twice
         if (accountId.equals(baseAccountId) == false) {
           ContractListDataBean contractListFromBaseAccount =
            new ContractListDataBean(new Long(baseAccountId), fLanguageId, "name", "ActivatedList", relatedStores[rel].toString(), ECContractConstants.EC_CONTRACT_USAGE_TYPE_ORGANIZATION_BUYER.intValue() );
           contractListFromBaseAccount.setUseCursor(false);
           contractListFromBaseAccount.setRequestProperties(contractCommandContext.getRequestProperties());
           contractListFromBaseAccount.setCommandContext(contractCommandContext);
           contractListFromBaseAccount.populate();
           ContractDataBean contractsFromBaseAccount[]  = contractListFromBaseAccount.getContractList();

           if (contractsFromBaseAccount != null) {
             for (int cLoop = 0; cLoop < contractsFromBaseAccount.length; cLoop++) {
            ContractDataBean cdb = contractsFromBaseAccount[cLoop];
               cdb.setCommandContext(contractCommandContext);
               MemberDataBean mdb = new MemberDataBean();
               mdb.setId(cdb.getMemberId().toString());
               mdb.setRequestProperties(contractCommandContext.getRequestProperties());
               mdb.setCommandContext(contractCommandContext);
               mdb.populate();
   %>
//alert('<%=cdb.getContractName()%> <%= cdb.getPriceListType() %> ');
            contractRefList[contractRefList.length] = new ContractReferenceElement('<%= UIUtil.toJavaScript(cdb.getContractName()) %>',
                          '<%= cdb.getContractOrigin() %>',
                          '<%= cdb.getMajorVersionNumber() %>',
                          '<%= cdb.getMinorVersionNumber() %>',
                          '<%= mdb.getMemberType() %>',
                                                       '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                        '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                            '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                             '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>',
                                                             '<%= cdb.getContractId() %>', '<%= cdb.getPriceListType() %>');

            if ("<%= contractReference %>" == "<%= cdb.getContractId() %>") {
               refSelected = "<%= loopOne + cLoop + 1%>";
               ContractReference.options[<%= loopOne+cLoop+1 %>] = new Option("<%= UIUtil.toJavaScript(cdb.getContractName()) %>",
                              "<%= loopOne+cLoop+1 %>", true, true);
            } else {
               ContractReference.options[<%= loopOne+cLoop+1 %>] = new Option("<%= UIUtil.toJavaScript(cdb.getContractName()) %>",
                              "<%= loopOne+cLoop+1 %>", false, false);
            }
            descriptionArray[<%= loopOne+cLoop+1 %>] = new Object();
            descriptionArray[<%= loopOne+cLoop+1 %>].store = "<%= UIUtil.toJavaScript(storeABRel.getIdentifier()) %>";
            descriptionArray[<%= loopOne+cLoop+1 %>].account = "<%= UIUtil.toJavaScript(baseAccounts[aLoop].getAccountName()) %>";

   <%              }
             loopOne += contractsFromBaseAccount.length;
           }
         } // is this the base account
      } // end for aLoop
     } // end if
   } // end for
   } catch (Exception e) {
      System.out.println(e);
   } %>
        cgm.contractReferenceList = contractRefList;
        cgm.descriptionArray = descriptionArray;


     } // end else first time to this page

    showEndDateDivisions();
    showStartDateDivisions();
    showContractGeneralFormDivisions();

    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
    }

    // handle error messages back from the validate page
    if (parent.get("contractNameRequired", false))
     {
      parent.remove("contractNameRequired");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractNameRequired"))%>");
      Name.focus();
     }
    else if (parent.get("contractNameTooLong", false))
     {
      parent.remove("contractNameTooLong");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractNameTooLong"))%>");
      Name.focus();
     }
    else if (parent.get("contractTitleRequired", false))
     {
      parent.remove("contractTitleRequired");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractTitleRequired"))%>");
      Title.focus();
     }
    else if (parent.get("contractTitleTooLong", false))
     {
      parent.remove("contractTitleTooLong");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractTitleTooLong"))%>");
      Title.focus();
     }
    else if (parent.get("contractDescriptionTooLong", false))
     {
      parent.remove("contractDescriptionTooLong");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractDescriptionTooLong"))%>");
      Description.focus();
     }
    else if (parent.get("invalidStartDate", false))
     {
      parent.remove("invalidStartDate");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidDate"))%>");
      StartYear.select();
      StartYear.focus();
     }
    else if (parent.get("invalidStartTime", false))
     {
      parent.remove("invalidStartTime");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidTime"))%>");
      StartTime.select();
      StartTime.focus();
     }
    else if (parent.get("invalidEndDate", false))
     {
      parent.remove("invalidEndDate");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidDate"))%>");
      endDateDiv.style.display = "block";
      EndYear.select();
      EndYear.focus();
    }
    else if (parent.get("invalidEndTime", false))
     {
      parent.remove("invalidEndTime");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("invalidTime"))%>");
      endDateDiv.style.display = "block";
      EndTime.select();
      EndTime.focus();
     }
    else if (parent.get("invalidEndAfterStartDate", false))
     {
      parent.remove("invalidEndAfterStartDate");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("pleaseEnterEndAfterStartDateTime"))%>");
      endDateDiv.style.display = "block";
      EndYear.select();
      EndYear.focus();
     }
    else if (parent.get("contractExists", false))
     {
      parent.remove("contractExists");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractExists"))%>");
      Name.focus();
     }
    else if (parent.get("contractMarkForDelete", false))
     {
      parent.remove("contractMarkForDelete");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractMarkedForDeleteError"))%>");
      Name.focus();
     }
    else if (parent.get("contractHasBeenChanged", false))
     {
      parent.remove("contractHasBeenChanged");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractChanged"))%>");
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractNotSaved"))%>");
      Title.focus();
     }
    else
     {
   if (<%= foundContractId %> == true)
      Title.focus();
   else
            Name.focus();
     }
    document.generalForm.ContractReference.selectedIndex = refSelected;
    displayDescription();

    } // end if parent.get
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
   myFormNames[0]  = "generalForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("GeneralOthersPages",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OtherPages")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockPages")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockPagesPrompt")) %>",
                      myFormNames,
                      6);


   /*90288*/ prepareUnlockWarningMsgMap();

 } // end function

function savePanelData()
 {
  //alert ('General savePanelData');
  with (document.generalForm)
   {
    if (parent.get)
     {
        var o = parent.get("ContractGeneralModel", null);
        if (o != null) {
      o.name = Name.value;
                o.title = Title.value;
      o.description = Description.value;
      o.StartImmediateChecked = StartImmediate.checked;
      o.startYear = StartYear.value;
      o.startMonth = StartMonth.value;
      o.startDay = StartDay.value;
      o.startTime = StartTime.value;
      o.endNeverExpires = NeverExpires.checked;
      o.endYear = EndYear.value;
      o.endMonth = EndMonth.value;
      o.endDay = EndDay.value;
      o.endTime = EndTime.value;
      o.contractReferenceSelected = ContractReference.selectedIndex;
        }
        var ccdm = parent.get("ContractCommonDataModel", null);
        if (ccdm != null) {
      if (o.contractReferenceSelected == "0") {
         ccdm.referenceNumber = "";
      } else {
         ccdm.referenceNumber = o.contractReferenceList[o.contractReferenceSelected - 1].id;
      }
      parent.put("base_contract_id", ccdm.referenceNumber);
      var contractPanel = parent.pageArray["genericCatalogFilterTitle"];
      contractPanel.parms[contractPanel.parms.length] = "base_contract_id";
      var contractPanel2 = parent.pageArray["notebookShippingChargeAdjustment"];
      contractPanel2.parms[contractPanel2.parms.length] = "base_contract_id";
        }
     }
   }
 }

function setupStartDate() {
      window.yearField = document.generalForm.StartYear;
      window.monthField = document.generalForm.StartMonth;
      window.dayField = document.generalForm.StartDay;
}

function setupEndDate() {
      window.yearField = document.generalForm.EndYear;
      window.monthField = document.generalForm.EndMonth;
      window.dayField = document.generalForm.EndDay;
}

function displayDescription(){
        var o = parent.get("ContractGeneralModel", null);
        if (o != null) {
      var descriptionText = null;
      if(o.descriptionArray.length > 0 && document.getElementById("ContractReference")!=null){//document.getElementById("ContractReference") add 
         descriptionText = '&nbsp;&nbsp;<%=UIUtil.toJavaScript((String)contractsRB.get("contractReferenceInformation"))%><br>' +
               '&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toJavaScript((String)contractsRB.get("storeName"))%>&nbsp;' +
               '<i>' + o.descriptionArray[document.getElementById("ContractReference").selectedIndex].store + '</i>' +
               '<br>' +
               '&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toJavaScript((String)contractsRB.get("accountName"))%>&nbsp;' +
               '<i>' + o.descriptionArray[document.getElementById("ContractReference").selectedIndex].account + '</i>';
      }
      if(descriptionText != null && descriptionText != 'null' && document.getElementById("ContractReference")!=null && document.getElementById("ContractReference").selectedIndex != 0){
         document.getElementById("contractRefDesc").innerHTML = descriptionText;
      }else{
         document.getElementById("contractRefDesc").innerHTML = '';
      }
   }
}


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<script FOR=document EVENT="onclick()">
      document.all.CalFrame.style.display="none";

</script>

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" marginheight=0 marginwidth=0 noresize frameborder=0 scrolling=no src="/webapp/wcs/tools/servlet/Calendar"></iframe>');
</script>

<h1><%= contractsRB.get("contractGeneralPanelPrompt") %></h1>

<form NAME="generalForm" id="generalForm">

<div id="contractGeneralFormDiv" style="display: none; margin-left: 0">

<% if (foundContractId) { %>
   <p><%= contractsRB.get("contractNameDisplay") %> <i><%= contractName %></i>
   <input NAME="Name" TYPE="HIDDEN" VALUE="" id="ContractGeneralPanel_FormInput_Name_In_generalForm_1">
<% } else { %>
   <p><label for="ContractGeneralPanel_FormInput_Name_In_generalForm_2"><%= contractsRB.get("contractNamePrompt") %></label><br>
   <input NAME="Name" TYPE="TEXT" size=30 maxlength=200 id="ContractGeneralPanel_FormInput_Name_In_generalForm_2">
<% } %>

<p><label for="ContractGeneralPanel_FormInput_Title_In_generalForm_1"><%= contractsRB.get("contractTitlePrompt") %></label><br>
<input NAME="Title" TYPE="TEXT" size=30 maxlength=254 id="ContractGeneralPanel_FormInput_Title_In_generalForm_1">

<p><label for="ContractGeneralPanel_FormInput_Description_In_generalForm_2"><%= contractsRB.get("contractDescriptionPrompt") %></label><br>
<textarea NAME="Description" id="ContractGeneralPanel_FormInput_Description_In_generalForm_2" ROWS="4" COLS="50" WRAP=physical onKeyDown="limitTextArea(this.form.Description,4000);" onKeyUp="limitTextArea(this.form.Description,4000);">
</textarea>

<br><br><br>

<input NAME="StartImmediate" TYPE="CHECKBOX" VALUE="CHECKED" ONCLICK="showStartDateDivisions()" id="ContractGeneralPanel_FormInput_StartImmediate_In_generalForm_1">
    <label for="ContractGeneralPanel_FormInput_StartImmediate_In_generalForm_1"><%= contractsRB.get("contractStartsImmediately") %></label>

<div id="startDateDiv" style="display: none; margin-left: 25">
 <table border=0 cellspacing=0 cellpadding=0 id="ContractGeneralPanel_Table_1">
  <tr>
      <td id="ContractGeneralPanel_TableCell_1">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_2">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_3"><label for="ContractGeneralPanel_FormInput_StartYear_In_generalForm_1"><%= contractsRB.get("yearPrompt") %></label></td>
      <td id="ContractGeneralPanel_TableCell_4">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_5"><label for="ContractGeneralPanel_FormInput_StartMonth_In_generalForm_1"><%= contractsRB.get("monthPrompt") %></label></td>
      <td id="ContractGeneralPanel_TableCell_6">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_7"><label for="ContractGeneralPanel_FormInput_StartDay_In_generalForm_1"><%= contractsRB.get("dayPrompt") %></label></td>
  </tr>
  <tr>
         <td id="ContractGeneralPanel_TableCell_8"><%=contractsRB.get("contractStartPrompt")%></td>
         <td id="ContractGeneralPanel_TableCell_9">&nbsp;</td>
    <td id="ContractGeneralPanel_TableCell_10"><input TYPE=TEXT NAME="StartYear" SIZE=4 MAXLENGTH=4 id="ContractGeneralPanel_FormInput_StartYear_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_11"></td><td id="ContractGeneralPanel_TableCell_12"><input TYPE=TEXT NAME="StartMonth" SIZE=2 MAXLENGTH=2 id="ContractGeneralPanel_FormInput_StartMonth_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_13"></td><td id="ContractGeneralPanel_TableCell_14"><input TYPE=TEXT NAME="StartDay" SIZE=2 MAXLENGTH=2 id="ContractGeneralPanel_FormInput_StartDay_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_15">&nbsp;</td>
    <td id="ContractGeneralPanel_TableCell_16"><a HREF="javascript:setupStartDate();showCalendar(document.generalForm.calImg1)" id="ContractGeneralPanel_Link_1">
    <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg1 ALT="<%= UIUtil.toJavaScript((String)contractsRB.get("calendarTool")) %>"></td>

         <td id="ContractGeneralPanel_TableCell_17">&nbsp;</td>
         <td id="ContractGeneralPanel_TableCell_18"><label for="ContractGeneralPanel_FormInput_StartTime_In_generalForm_1"><%= contractsRB.get("timePrompt") %></label></td>
         <td id="ContractGeneralPanel_TableCell_19">&nbsp;</td>
         <td id="ContractGeneralPanel_TableCell_20"><input NAME="StartTime" TYPE="TEXT" SIZE="5" MAXLENGTH="5" id="ContractGeneralPanel_FormInput_StartTime_In_generalForm_1"></td>
  </tr>
 </table>
</div>

<br>
<input NAME="NeverExpires" TYPE="CHECKBOX" VALUE="CHECKED" ONCLICK="showEndDateDivisions()" id="ContractGeneralPanel_FormInput_NeverExpires_In_generalForm_1">
    <label for="ContractGeneralPanel_FormInput_NeverExpires_In_generalForm_1"><%= contractsRB.get("contractDoesNotExpire") %></label>

<div id="endDateDiv" style="display: none; margin-left: 25">
 <table border=0 cellspacing=0 cellpadding=0 id="ContractGeneralPanel_Table_2">
  <tr>
      <td id="ContractGeneralPanel_TableCell_21">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_22">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_23"><label for="ContractGeneralPanel_FormInput_EndYear_In_generalForm_1"><%= contractsRB.get("yearPrompt") %></label></td>
      <td id="ContractGeneralPanel_TableCell_24">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_25"><label for="ContractGeneralPanel_FormInput_EndMonth_In_generalForm_1"><%= contractsRB.get("monthPrompt") %></label></td>
      <td id="ContractGeneralPanel_TableCell_26">&nbsp;</td>
      <td id="ContractGeneralPanel_TableCell_27"><label for="ContractGeneralPanel_FormInput_EndDay_In_generalForm_1"><%= contractsRB.get("dayPrompt") %></label></td>
  </tr>
  <tr>
         <td id="ContractGeneralPanel_TableCell_28"><%=contractsRB.get("contractEndPrompt")%></td>
         <td id="ContractGeneralPanel_TableCell_29">&nbsp;</td>
    <td id="ContractGeneralPanel_TableCell_30"><input TYPE=TEXT NAME="EndYear" SIZE=4 MAXLENGTH=4 id="ContractGeneralPanel_FormInput_EndYear_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_31"></td><td id="ContractGeneralPanel_TableCell_32"><input TYPE=TEXT NAME="EndMonth" SIZE=2 MAXLENGTH=2 id="ContractGeneralPanel_FormInput_EndMonth_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_33"></td><td id="ContractGeneralPanel_TableCell_34"><input TYPE=TEXT NAME="EndDay" SIZE=2 MAXLENGTH=2 id="ContractGeneralPanel_FormInput_EndDay_In_generalForm_1"></td>
    <td id="ContractGeneralPanel_TableCell_35">&nbsp;</td>
    <td id="ContractGeneralPanel_TableCell_36"><a HREF="javascript:setupEndDate();showCalendar(document.generalForm.calImg2)" id="ContractGeneralPanel_Link_2">
    <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg2 ALT="<%= UIUtil.toJavaScript((String)contractsRB.get("calendarTool")) %>"></td>

         <td id="ContractGeneralPanel_TableCell_37">&nbsp;</td>
         <td id="ContractGeneralPanel_TableCell_38"><label for="ContractGeneralPanel_FormInput_EndTime_In_generalForm_1"><%= contractsRB.get("timePrompt") %></label></td>
         <td id="ContractGeneralPanel_TableCell_39">&nbsp;</td>
         <td id="ContractGeneralPanel_TableCell_40"><input NAME="EndTime" TYPE="TEXT" SIZE="5" MAXLENGTH="5" id="ContractGeneralPanel_FormInput_EndTime_In_generalForm_1"></td>
  </tr>
 </table>
</div>

<br><br>

   <label for="ContractGeneralPanel_FormInput_ContractReference_In_generalForm_1"><%= contractsRB.get("contractReferenceTitle") %></label><br>
   <select NAME="ContractReference" id="ContractGeneralPanel_FormInput_ContractReference_In_generalForm_1" TABINDEX="1" SIZE="1" onchange="displayDescription();">
   </select>
   <!-- The empty DIV below is used to insert dynamically the contract reference description -->
   <div id="contractRefDesc">
   </div>

</div><!-- ContractGeneralFormDiv -->

</form>
</body>
</html>