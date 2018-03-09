

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.*,
      com.ibm.commerce.beans.*,
      com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
      com.ibm.commerce.tools.contract.beans.PolicyDataBean,
      com.ibm.commerce.tools.contract.beans.MemberDataBean,
      com.ibm.commerce.tools.contract.beans.ContractDataBean,
      com.ibm.commerce.tools.contract.beans.PriceTCMasterCatalogWithFilteringDataBean,
      com.ibm.commerce.tools.contract.beans.CatalogFilterDataBean,
      com.ibm.commerce.tools.contract.beans.CustomPricingTCDataBean,
      com.ibm.commerce.catalog.beans.CatalogEntryDataBean,
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

<%@page import="com.ibm.commerce.contract.objects.TermConditionAccessBean,
      com.ibm.commerce.contract.objects.PriceTCConfigBuildBlockAccessBean,
      com.ibm.commerce.contract.objects.ComponentAdjustmentAccessBean,
      com.ibm.commerce.contract.objects.ComponentOfferAccessBean"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>


<%
   /*90288*/
   //--------------------------------------------------------------
   // Checking the terms and conditions lock for Pricing TC
   // in contract change mode. This is not applicable if a draft
   // contract is not even created.
   //--------------------------------------------------------------
   int lockHelperRC       = 0;
   String tcLockOwner     = "";
   String tcLockTimestamp = "";

   if (foundContractId)
   {
      com.ibm.commerce.contract.util.ContractTCLockHelper myLockHelper
            = new com.ibm.commerce.contract.util.ContractTCLockHelper
                  (contractCommandContext,
                   new Long(contractId),
                   com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING);
      lockHelperRC    = myLockHelper.managingLock();
      tcLockOwner     = myLockHelper.getCurrentLockOwnerLogonId();
      tcLockTimestamp = myLockHelper.getCurrentLockCreationTimestamp();
   }
%>



<html lang="en">
<head>

<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CatalogFilter.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CustomPricing.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/KitPricing.js">
</script>



<script LANGUAGE="JavaScript">
///////////////////////////////////////
// Defining the JROM and JLOM model
///////////////////////////////////////

var debug=false; // global flag to turn on alerts.

// store last clicked tree node instead of using "lastClickedTreeNode" attribute of "catalogFilterMainFrame" iframe
var gLastClickedTreeNode = null; 

var cfm = new Object();
cfm.JROM = new Object();
cfm.JROM.rows = new Array();
cfm.JLOM = new Array();

cfm.JPOM = new Array();
cfm.JPOM[0] = 99999;  // the 0% adjustment is always primed into the JPOM

cfm.parentJROM = new Object();
cfm.parentJROM.rows = new Array();
cfm.JROM.fromContractList = false;
cfm.JROM.hostingMode = false;
cfm.JROM.baseContractMode = false;
cfm.JROM.defaultMarkType = "markdown";
cfm.JROM.languageId = "<%= fLanguageId %>";

/*d79166*/
// Defining the JKIT model for kit component pricing tcs
cfm.JKIT = new KitPricingModel();

cfm.JROM.delegationGrid = false;
// check if this is the delegation grid notebook
var cgm = parent.get("ContractGeneralModel");
if (cgm != null && cgm.usage == "DelegationGrid") {
     cfm.JROM.delegationGrid = true;
}

<%
  Vector grandParentBaseContracts = new Vector();

  PriceTCMasterCatalogWithFilteringDataBean JROMdb = new PriceTCMasterCatalogWithFilteringDataBean();
  JROMdb.setDatabeanMode(PriceTCMasterCatalogWithFilteringDataBean.MODE_CATALOG_FILTER_UI);
  if (foundContractId) {
     JROMdb.setContractId(new Long(contractId));
  }

  TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
  if (requestProperties != null) {
   JROMdb.setBaseContractId(requestProperties.getLong("base_contract_id", null));
  }

  String baseContractParm = "";
   try {
     baseContractParm = UIUtil.toHTML(contractCommandContext.getRequestProperties().getString("baseContract"));
     if (baseContractParm != null && baseContractParm.length() > 0) {
        // this means the parameter was passed in - so we came from the contract list
      JROMdb.setDoNotFindDefaultContract();
%>
   cfm.JROM.fromContractList = true;
<%
     }
   } catch (Exception e) {
   }

   try {
     String hosting = contractCommandContext.getRequestProperties().getString("hosting");
     if (hosting != null && hosting.length() > 0 && hosting.equals("true")) {
        JROMdb.setHostingMode(true);
%>
   cfm.JROM.hostingMode = true;
<%
     }
   } catch (Exception e) {
   }

   if (baseContractParm != null && baseContractParm.length() > 0 && baseContractParm.equals("true")) {
%>
   cfm.JROM.baseContractMode = true;
<%
   }

   String contractStoreId = null;
   try {
     contractStoreId = contractCommandContext.getRequestProperties().getString("contractStoreId");
     contractStoreId = UIUtil.toHTML(contractStoreId);
     if (contractStoreId != null && contractStoreId.length() > 0) {
   JROMdb.setStoreId(new Integer(contractStoreId));
     }
   } catch (Exception e) {
     
   }

  DataBeanManager.activate(JROMdb, request);

  StoreDataBean sdb = new StoreDataBean();
  sdb.setStoreId(JROMdb.getStoreId().toString());
  DataBeanManager.activate(sdb, request);

  String exclusions = JROMdb.getExcludedProductSetIds();
  String storeName = sdb.getIdentifier();
  Long baseContract = JROMdb.getBaseContractId();
  try {
%>
   cfm.JROM.storeId = '<%= fStoreId %>';
   cfm.JROM.contractId = '<%= JROMdb.getContractId() %>';
   cfm.JROM.termConditionId = '<%= JROMdb.getTermConditionId() %>';
   cfm.JROM.includeEntireCatalog = '<%= JROMdb.getIncludeEntireCatalog() %>';
   cfm.JROM.catalogReferenceNumber = '<%= JROMdb.getCatalogReferenceNumber() %>';
   cfm.JROM.catalogIdentifier = '<%= UIUtil.toJavaScript(JROMdb.getCatalogIdentifier()) %>';
<%
   if (JROMdb.getCatalogOwner() != null) {
%>
      cfm.JROM.catalogOwner = new Member('<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberType()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberDN()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupName()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupOwnerMemberType()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupOwnerMemberDN()) %>')
<%
   }
   if (JROMdb.getContractOwner() != null) {
%>
      cfm.JROM.contractOwner = new Member('<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupOwnerMemberDN()) %>')
<%
   }
%>
   // setup default values
   cfm.JROM.contractLastUpdateTime = '<%= JROMdb.getContractLastUpdateTime() %>';
   cfm.JROM.contractState = '99';
   cfm.JROM.tcLastUpdateTime = '<%=UIUtil.toJavaScript((String)contractsRB.get("lastUpdateNA"))%>';
   cfm.JROM.publishStatus = '99';
   cfm.JROM.publishTime = '<%=UIUtil.toJavaScript((String)contractsRB.get("lastUpdateNA"))%>';
   cfm.JROM.baseContractTitle = "";
   cfm.JROM.baseContractPriceListType = "";
   cfm.JROM.priceListTypeIndex = 0;
   cfm.JROM.includedCategoriesAreSynched = false;
   cfm.JROM.includedCategoriesAreUnSynched = false;

   // reset values based on non-null results
<%
   if (JROMdb.getContractState() != null) {
%>
      cfm.JROM.contractState = '<%= JROMdb.getContractState() %>';
<%
   }
   if (JROMdb.getTClastUpdateTime() != null) {
%>
      // this is the value displayed in the title bar as the last update time.
      cfm.JROM.tcLastUpdateTime = '<%= TimestampHelper.getDateTimeFromTimestamp(JROMdb.getTClastUpdateTime(), fLocale) %>';
<%
   }
   if (JROMdb.getFilterPublishStatus() != null) {
%>
      cfm.JROM.publishStatus = '<%= JROMdb.getFilterPublishStatus() %>';
<%
   }
   if (JROMdb.getFilterPublishTime() != null) {
%>
      cfm.JROM.publishTime = '<%= TimestampHelper.getDateTimeFromTimestamp(JROMdb.getFilterPublishTime(), fLocale) %>';
<%
   }
%>

   //alert('Hosting = ' + cfm.JROM.hostingMode);
   //alert('baseContract = ' + cfm.JROM.baseContractMode);
   // Getting constants from the databean.
   cfm.JROM.DEFAULT_ITEM_PRECEDENCE = '<%= PriceTCMasterCatalogWithFilteringDataBean.DEFAULT_ITEM_PRECEDENCE %>';
   cfm.JROM.DEFAULT_PRODUCT_PRECEDENCE = '<%= PriceTCMasterCatalogWithFilteringDataBean.DEFAULT_PRODUCT_PRECEDENCE %>';
   cfm.JROM.MAXIMUM_CATENTRY_LEVEL_ADJUSTMENTS = 10;

   cfm.JROM.PUBLISH_STATUS_SUCCESS = '<%= PriceTCMasterCatalogWithFilteringDataBean.PUBLISH_STATUS_SUCCESS %>';
   cfm.JROM.PUBLISH_STATUS_INPROGRESS = '<%= PriceTCMasterCatalogWithFilteringDataBean.PUBLISH_STATUS_INPROGRESS %>';
   cfm.JROM.PUBLISH_STATUS_FAILED = '<%= PriceTCMasterCatalogWithFilteringDataBean.PUBLISH_STATUS_FAILED %>';
   cfm.JROM.CONTRACT_STATUS_INPROGRESS = '<%= ECContractConstants.EC_STATE_DEPLOY_IN_PROGRESS %>';
   cfm.JROM.CONTRACT_STATUS_DRAFT = '<%= ECContractConstants.EC_STATE_DRAFT %>';

   // if there is no shared catalog, then this tool is effectively disabled
   cfm.JROM.hasSharedCatalog = <%= JROMdb.hasSharedCatalog() %>;

   cfm.JROM.FILTER_TYPE_CATALOG = '<%= CatalogFilterDataBean.FILTER_TYPE_CATALOG %>';
   cfm.JROM.FILTER_TYPE_CATEGORY = '<%= CatalogFilterDataBean.FILTER_TYPE_CATEGORY %>';
   cfm.JROM.FILTER_TYPE_CATENTRY = '<%= CatalogFilterDataBean.FILTER_TYPE_CATENTRY %>';
   cfm.JROM.FILTER_TYPES = new Array("Catalog", "Category", "Catentry");

   cfm.JROM.FILTER_TYPE_PREFIXES = new Array("CA", "CG", "CE");

   cfm.JROM.ENTITLEMENT_TYPE_EXCLUDE = '<%= CatalogFilterDataBean.ENTITLEMENT_TYPE_EXCLUDE %>';
   cfm.JROM.ENTITLEMENT_TYPE_INCLUDE = '<%= CatalogFilterDataBean.ENTITLEMENT_TYPE_INCLUDE %>';
   cfm.JROM.ENTITLEMENT_TYPES = new Array("Exclude", "Include");
   cfm.JROM.FIXED_PRICE_TYPE = "FixedPrice";

   cfm.JROM.ACTION_TYPE_NOACTION = '<%= CatalogFilterDataBean.ACTION_TYPE_NOACTION %>';
   cfm.JROM.ACTION_TYPE_NEW = '<%= CatalogFilterDataBean.ACTION_TYPE_NEW %>';
   cfm.JROM.ACTION_TYPE_UPDATE = '<%= CatalogFilterDataBean.ACTION_TYPE_UPDATE %>';
   cfm.JROM.ACTION_TYPE_DELETE = '<%= CatalogFilterDataBean.ACTION_TYPE_DELETE %>';
   cfm.JROM.ACTION_TYPES = new Array("noaction", "new", "update", "delete");

   cfm.JROM.areButtonsDisabled = true; // default when the tree is first loaded...

   alertDebug("storeId="+cfm.JROM.storeId);
   alertDebug("contractId="+cfm.JROM.contractId);
   alertDebug("termConditionId="+cfm.JROM.termConditionId);
   alertDebug("includeEntireCatalog="+cfm.JROM.includeEntireCatalog);
   alertDebug("catalogRefenceNumber="+cfm.JROM.catalogReferenceNumber);
   alertDebug("catalogIdentifier="+cfm.JROM.catalogIdentifier);
   alertDebug("catalogOwner="+dumpObject(cfm.JROM.catalogOwner));
   alertDebug("hasSharedCatalog="+cfm.JROM.hasSharedCatalog);
   alertDebug("contractOwner="+dumpObject(cfm.JROM.contractOwner));
   alertDebug("contractLastUpdateTime="+cfm.JROM.contractLastUpdateTime);
   alertDebug("contractState="+cfm.JROM.contractState);
   //alert("contractState="+cfm.JROM.contractState);
   alertDebug("tcLastUpdateTime="+cfm.JROM.tcLastUpdateTime);
   alertDebug("publishStatus="+cfm.JROM.publishStatus);
   alertDebug("publishTime="+cfm.JROM.publishTime);

<%
   // loop through the catalog filters and setup the JROM...
   for (int i=0; i<JROMdb.getCatalogFilters().size(); i++) {
      CatalogFilterDataBean cfdb = JROMdb.getCatalogFilter(i);

      if (! cfdb.isActionType(CatalogFilterDataBean.ACTION_TYPE_DELETE)){
%>

         cfm.JROM.rows['<%=cfdb.getNodeReferenceNumber()%>'] = new JROMrow('<%=cfdb.getNodeReferenceNumber()%>',
                           <%=cfdb.getPrecedence()%>,
                           '<%=cfdb.getFilterType()%>',
                           '<%=cfdb.getReferenceNumber()%>',
                           '<%=cfdb.getEntitlementType()%>',
                           '<%=cfdb.getSynched().toString()%>',
                           <%=cfdb.getAdjustment()%>);

         alertDebug('Adding JROM Row!\n'+dumpObject(cfm.JROM.rows['<%=cfdb.getNodeReferenceNumber()%>']));
<%
         // add catentry-level adjustment filters to the JPOM...
         if (cfdb.isFilterType(CatalogFilterDataBean.FILTER_TYPE_CATENTRY)) {
%>
            addToJPOM(new Number(<%=cfdb.getAdjustment()%>));
<%
         }
         // set synch flag from included categories
         // all excluded categories are synched
         // all included/excluded products/items are not synched
         if (cfdb.isFilterType(CatalogFilterDataBean.FILTER_TYPE_CATEGORY) && cfdb.isEntitlementType(CatalogFilterDataBean.ENTITLEMENT_TYPE_INCLUDE)) {
            if (cfdb.getSynched().equals(Boolean.TRUE)) {
%>
               cfm.JROM.includedCategoriesAreSynched = true;
<%
            } else if (cfdb.getSynched().equals(Boolean.FALSE)) {
%>
               cfm.JROM.includedCategoriesAreUnSynched = true;
<%          }
         }
      }
   }

  // get the adjustments from the parent contract
  if (baseContract != null) {
%>
   // there is a base contract, so we only allow synched categories
   // if the base contract is a hosting contract, you can have unsynched
   if(<%=ContractCmdUtil.isBuyerContract(JROMdb.getBaseContractId())%>){
      cfm.JROM.includedCategoriesAreSynched = true;
      cfm.JROM.includedCategoriesAreUnSynched = false;
   }
<%
   ContractDataBean contract = new ContractDataBean(baseContract, new Integer(fLanguageId));
   contract.setRequestProperties(contractCommandContext.getRequestProperties());
   contract.setCommandContext(contractCommandContext);
   contract.populate();
%>
   cfm.JROM.baseContractTitle = "<%= UIUtil.toJavaScript((String)contract.getContractName()) %>";
<%

   PriceTCMasterCatalogWithFilteringDataBean parentJROMdb = new PriceTCMasterCatalogWithFilteringDataBean();
   parentJROMdb.setDatabeanMode(PriceTCMasterCatalogWithFilteringDataBean.MODE_CATALOG_FILTER_UI);
   parentJROMdb.setContractId(baseContract);
   DataBeanManager.activate(parentJROMdb, request);

   // loop through the catalog filters and setup the JROM...
   for (int i=0; i<parentJROMdb.getCatalogFilters().size(); i++) {
      CatalogFilterDataBean cfdb = parentJROMdb.getCatalogFilter(i);

      if (! cfdb.isActionType(CatalogFilterDataBean.ACTION_TYPE_DELETE)){
%>
         cfm.parentJROM.rows['<%=cfdb.getNodeReferenceNumber()%>'] = new JROMrow('<%=cfdb.getNodeReferenceNumber()%>',
                           <%=cfdb.getPrecedence()%>,
                           '<%=cfdb.getFilterType()%>',
                           '<%=cfdb.getReferenceNumber()%>',
                           '<%=cfdb.getEntitlementType()%>',
                           '<%=cfdb.getSynched().toString()%>',
                           <%=cfdb.getAdjustment()%>);
         alertDebug('Adding parent JROM Row!\n'+dumpObject(cfm.parentJROM.rows['<%=cfdb.getNodeReferenceNumber()%>']));
<%
      }
   }

   // get the price list type associated with the base contract
   PolicyListDataBean pldb = parentJROMdb.getPriceListPolicies();
   if (pldb != null) {
     PolicyDataBean[] _policies = pldb.getPolicyList();
     for (int i2=0; i2<_policies.length; i2++) {
         PolicyDataBean pricePDB = _policies[i2];
%>
         cfm.JROM.baseContractPriceListType = '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>';
<%   }
   }

      // get the filters from grandparent contracts
   Long grandBaseContract = parentJROMdb.getBaseContractId();
   while (grandBaseContract != null) {
      grandParentBaseContracts.addElement(grandBaseContract);
      PriceTCMasterCatalogWithFilteringDataBean grandParentJROMdb = new PriceTCMasterCatalogWithFilteringDataBean();
      grandParentJROMdb.setDatabeanMode(PriceTCMasterCatalogWithFilteringDataBean.MODE_CATALOG_FILTER_UI);
      grandParentJROMdb.setContractId(grandBaseContract);
      DataBeanManager.activate(grandParentJROMdb, request);

      // loop through the catalog filters and setup the JROM...
      for (int i=0; i<grandParentJROMdb.getCatalogFilters().size(); i++) {
         CatalogFilterDataBean cfdb = grandParentJROMdb.getCatalogFilter(i);

        if (! cfdb.isActionType(CatalogFilterDataBean.ACTION_TYPE_DELETE)){
         // only set if we do not already have an entry for this filter
%>
      if (cfm.parentJROM.rows['<%=cfdb.getNodeReferenceNumber()%>'] == null) {
           cfm.parentJROM.rows['<%=cfdb.getNodeReferenceNumber()%>'] = new JROMrow('<%=cfdb.getNodeReferenceNumber()%>',
                           <%=cfdb.getPrecedence()%>,
                           '<%=cfdb.getFilterType()%>',
                           '<%=cfdb.getReferenceNumber()%>',
                           '<%=cfdb.getEntitlementType()%>',
                           '<%=cfdb.getSynched().toString()%>',
                           <%=cfdb.getAdjustment()%>);
              alertDebug('Adding grand parent JROM Row!\n'+dumpObject(cfm.parentJROM.rows['<%=cfdb.getNodeReferenceNumber()%>']));//Debug
            }
<%
       }
   }
        // get the price list type associated with the base contract
        pldb = grandParentJROMdb.getPriceListPolicies();
        if (pldb != null) {
         PolicyDataBean[] _policies = pldb.getPolicyList();
         for (int i2=0; i2<_policies.length; i2++) {
            PolicyDataBean pricePDB = _policies[i2];
%>
       if (cfm.JROM.baseContractPriceListType == "") {
                cfm.JROM.baseContractPriceListType = '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>';
            }
<%   }
   }
   grandBaseContract = grandParentJROMdb.getBaseContractId();
   } // end while
  }
}
catch(Exception e) {
com.ibm.commerce.ras.ECTrace.trace(com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT, "Catalog Tree", "load", "Exception: " + e.toString());
%>
   alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("loadFiltersErrorMessage"))%>");
<%
}
%>

// only synched for base and hosting contracts
if (cfm.JROM.hostingMode == true || cfm.JROM.baseContractMode == true || cfm.JROM.fromContractList == false) {
   // we only allow synched categories
   cfm.JROM.includedCategoriesAreSynched = true;
   cfm.JROM.includedCategoriesAreUnSynched = false;
}

// put together the list of price policies associated with this TC - existing tcs
cfm.JROM.priceListPolicyArray = new Array();
cfm.JROM.priceListIdArray = new Array();

// put together the list of potential price policies associated with this TC - new tcs
cfm.JROM.possiblePriceListPolicyArray = new Array();
cfm.JROM.possiblePriceListIdArray = new Array();
cfm.JROM.needToSelectPriceList = true;
<%
   try {
      PolicyListDataBean pldb = JROMdb.getPriceListPolicies();
      PolicyDataBean[] _policies = pldb.getPolicyList();

      for (int i=0; i<_policies.length; i++) {
         // this is an existing tc
         PolicyDataBean pricePDB = _policies[i];

         // get the member data bean for the store member ID owner of this policy
         MemberDataBean mdb = new MemberDataBean();
              mdb.setId(pricePDB.getStoreMemberId());
              DataBeanManager.activate(mdb, request);
%>
cfm.JROM.needToSelectPriceList = false;
cfm.JROM.priceListIdArray[cfm.JROM.priceListIdArray.length] = '<%= ContractUtil.getPolicyPriceList(pricePDB.getProperties()) %>';

cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length] =

         new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
               '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
               '<%= pricePDB.getId() %>',
               '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
               new Member('<%= UIUtil.toJavaScript(mdb.getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>'),
                     '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>'
                                        );
alertDebug("Price Policy["+cfm.JROM.priceListPolicyArray.length+"]="+dumpObject(cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length-1]));

   <%
      } // end for
   }  // end try
catch (NullPointerException e) {
%>
   //alertDialog("<%=UIUtil.toJavaScript("CREATING NEW TERM CONDITION")%>");
   <%
   // this loads all policies, may need to choose
   // load the store policies from the database
   PolicyListDataBean policyListAll = new PolicyListDataBean();
   policyListAll.setPolicyType(policyListAll.TYPE_PRICE);
   policyListAll.setStoreId(JROMdb.getStoreId());
   DataBeanManager.activate(policyListAll, request);
   PolicyDataBean policiesAll[] = policyListAll.getPolicyList();
   for (int i=0; i<policiesAll.length; i++) {
      PolicyDataBean pricePDB = policiesAll[i];
      String plType = ContractUtil.getPolicyPriceListType(pricePDB.getProperties());

      if (ContractCmdUtil.isMasterPriceListPolicy(pricePDB.getPolicyName()) || !plType.equals(ContractUtil.TYPEUNKNOWN)) {
         // get the member data bean for the store member ID owner of this policy
         MemberDataBean mdb = new MemberDataBean();
              mdb.setId(pricePDB.getStoreMemberId());
              DataBeanManager.activate(mdb, request);
%>
cfm.JROM.possiblePriceListIdArray[cfm.JROM.possiblePriceListIdArray.length] = '<%= ContractUtil.getPolicyPriceList(pricePDB.getProperties()) %>';

cfm.JROM.possiblePriceListPolicyArray[cfm.JROM.possiblePriceListPolicyArray.length] =

         new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
               '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
               '<%= pricePDB.getId() %>',
               '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
               new Member('<%= UIUtil.toJavaScript(mdb.getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>'),
         '<%= plType %>'
                                        );
alertDebug("Price Policy["+cfm.JROM.possiblePriceListPolicyArray.length+"]="+dumpObject(cfm.JROM.possiblePriceListPolicyArray[cfm.JROM.possiblePriceListPolicyArray.length-1]));

   <% }
   } // end for
}
   catch(Exception e) {
   %>
      alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("loadFiltersErrorMessage"))%>");
   <%
   }
   %>

   // handle fixed pricing
<%
   String priceListType = "E";
   try {
       // This field represents the type of the fixed price list
       Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", fLocale);
       if (fixedResourceBundle != null) {
              Object plt = fixedResourceBundle.get("priceListType");
              if (plt != null) {
                     priceListType = (String)plt;
              }
       }
   } catch (Exception e) {
   }
%>

   // create a contract price list model which will store an array of price TCs
   cpm = new ContractCustomPricingModel();
   cfm.FIXED = cpm;
   cpm.tcInContract = false;
   cpm.modifiedInSession = false;
   cpm.name = "";
   cpm.description = "";
   cpm.precedence = "1001";
   cpm.type = "<%= priceListType %>";

<%
   StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
   // get the default currenty for a store
   CurrencyManager cm = CurrencyManager.getInstance();
   String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());
%>
   cpm.storeDefaultCurrency = "<%= defaultCurrency %>";
   /*d79166*/ cfm.JKIT.storeDefaultCurrency = "<%= defaultCurrency %>";

<%
   MemberDataBean mdb = new MemberDataBean();
   mdb.setId(fStoreMemberId);
   DataBeanManager.activate(mdb, request);
%>
   cpm.member = new Member("<%= mdb.getMemberType() %>", "<%=UIUtil.toJavaScript( mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>");
   /*d79166*/ cfm.JKIT.owner = cpm.member;

<%
   // See it there is existing data
   if (JROMdb.getContractId() != null) {
         try {
       TradingPositionContainerAccessBean priceList = CustomPricingTCDataBean.getPriceListAccessBean(JROMdb.getContractId());
       if (priceList != null) {

      MemberDataBean plmdb = new MemberDataBean();
      plmdb.setId(priceList.getMemberId());
         DataBeanManager.activate(plmdb, request);
%>
            cpm.tcInContract = true;
            cpm.name = "<%= UIUtil.toJavaScript(priceList.getName()) %>";
            cpm.description = "<%= UIUtil.toJavaScript(priceList.getDescription()) %>";
            cpm.precedence = "<%= priceList.getPrecedence() %>";
            cpm.referenceNumber = "<%= CustomPricingTCDataBean.getPriceListTermcondId(JROMdb.getContractId()) %>";
            cpm.plReferenceNumber = "<%= priceList.getTradingPositionContainerId() %>";
            cpm.type = "<%= priceList.getType() %>";
            cpm.member = new Member("<%= plmdb.getMemberType() %>", "<%=UIUtil.toJavaScript( plmdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(plmdb.getMemberGroupName()) %>", "<%= plmdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(plmdb.getMemberGroupOwnerMemberDN()) %>");
<%
      Vector offerList = CustomPricingTCDataBean.getPriceListOffers(priceList.getTradingPositionContainerId());
      int offerListSize = 0;
      if (offerList != null) {
         offerListSize = offerList.size();
      }
      for (int k = 0; k < offerListSize; k++) {
           Vector row = (Vector)offerList.elementAt(k);
%>
           // check if we already have this catentry, if we do, then just add the new price
           var newCustomPriceTC = null;
           var index = 'CE-<%= row.elementAt(0).toString() %>';
           if (cpm.customPriceTC[index] != null) {
               newCustomPriceTC = cpm.customPriceTC[index];
              } else {
                 newCustomPriceTC = new CustomPriceTC();
                 newCustomPriceTC.markedForDelete = false;
                        newCustomPriceTC.action = "noaction";
                        newCustomPriceTC.fromContract = true;
                        newCustomPriceTC.productPublished = "<%= row.elementAt(4).toString() %>";
                        newCustomPriceTC.productField1 = "";
                        newCustomPriceTC.productId = "<%= row.elementAt(0).toString() %>";
              }

                     if (cpm.storeDefaultCurrency == "<%= row.elementAt(2).toString() %>") {
                             newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= row.elementAt(1).toString() %>", "<%= row.elementAt(2).toString() %>", true);
                     } else {
                             newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= row.elementAt(1).toString() %>", "<%= row.elementAt(2).toString() %>", false);
                     }

                     cpm.customPriceTC[index] = newCustomPriceTC;
<%
            } // end for
           } // end if priceList

   } catch (Exception ex) {
      com.ibm.commerce.ras.ECTrace.trace(com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT, "CatalogTree", "populate", ex.toString());
   }
   } // end foundContractId
%>
   // create a contract price list model which will store an array of price TCs from the base contract
   parentCpm = new ContractCustomPricingModel();
   cfm.parentFIXED = parentCpm;
<%
   // See it there is existing data from the base contract
   if (baseContract != null) {
         try {
       TradingPositionContainerAccessBean priceList = CustomPricingTCDataBean.getPriceListAccessBean(baseContract);
       if (priceList != null) {
      Vector offerList = CustomPricingTCDataBean.getPriceListOffers(priceList.getTradingPositionContainerId());
      int offerListSize = 0;
      if (offerList != null) {
         offerListSize = offerList.size();
      }
      for (int k = 0; k < offerListSize; k++) {
           Vector row = (Vector)offerList.elementAt(k);
%>
           var newCustomPriceTC = null;
                     var index = 'CE-<%= row.elementAt(0).toString() %>';
           if (parentCpm.customPriceTC[index] != null) {
               newCustomPriceTC = parentCpm.customPriceTC[index];
              } else {
                        newCustomPriceTC = new CustomPriceTC();
                     }

                     if (cpm.storeDefaultCurrency == "<%= row.elementAt(2).toString() %>") {
                          newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= row.elementAt(1).toString() %>", "<%= row.elementAt(2).toString() %>", true);
                     }

                     parentCpm.customPriceTC[index] = newCustomPriceTC;
<%
            } // end for
           } // end if priceList

      // get the fixed prices from grandparent contracts
      for (int gp = 0; gp < grandParentBaseContracts.size(); gp++) {
       priceList = CustomPricingTCDataBean.getPriceListAccessBean((Long)grandParentBaseContracts.elementAt(gp));
       if (priceList != null) {
      Vector offerList = CustomPricingTCDataBean.getPriceListOffers(priceList.getTradingPositionContainerId());
      int offerListSize = 0;
      if (offerList != null) {
         offerListSize = offerList.size();
      }
      for (int k = 0; k < offerListSize; k++) {
           Vector row = (Vector)offerList.elementAt(k);
%>
           var newCustomPriceTC = null;
                     var index = 'CE-<%= row.elementAt(0).toString() %>';
           if (parentCpm.customPriceTC[index] != null) {
               newCustomPriceTC = parentCpm.customPriceTC[index];
              } else {
                        newCustomPriceTC = new CustomPriceTC();
                     }

                     if (cpm.storeDefaultCurrency == "<%= row.elementAt(2).toString() %>") {
                          newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= row.elementAt(1).toString() %>", "<%= row.elementAt(2).toString() %>", true);
                     }

                     parentCpm.customPriceTC[index] = newCustomPriceTC;
<%
            } // end for
           } // end if priceList
      } // end for gp
   } catch (Exception ex) {
      com.ibm.commerce.ras.ECTrace.trace(com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT, "CatalogTree", "populate", ex.toString());
   }
    } // end baseContract


/*d79166*/
   //-----------------------------------------------------------
   // Retrieving the PriceTCConfigBuildBlock terms & conditions
   // and storing the kit adjustments data into the JKIT model
   //-----------------------------------------------------------

   PriceTCConfigBuildBlockAccessBean pcbbAB = null;
   StringBuffer pcbbDebugMsg = new StringBuffer("[pcbb] \\n");
   Long myPriceTCConfigBB_refNum = null;
   Long myPriceTCConfigBB_priceListId = null;

if (JROMdb.getContractId()!=null)
{
   try
   {
      Long pcbbAB_contractId = JROMdb.getContractId();
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

            %>
               cfm.JKIT.referenceNumber = "<%= tcRefNum %>";
               cfm.JKIT.action          = "noaction";
            <%

            myPriceTCConfigBB_refNum = new Long(tcRefNum);
            pcbbAB = new PriceTCConfigBuildBlockAccessBean();
            pcbbAB.setInitKey_referenceNumber(tcRefNum);
         }
      }

      if (pcbbAB!=null)
      {
         pcbbDebugMsg.append("ref#=").append(pcbbAB.getReferenceNumber()).append("\\n");
         pcbbDebugMsg.append("tradingId=").append(pcbbAB.getTradingId()).append("\\n");
         pcbbDebugMsg.append("productSetId=").append(pcbbAB.getProductSetId()).append("\\n");

         // Percentage price list
         Long[] tmpIDs = pcbbAB.getPercentagePriceListIds();
         pcbbDebugMsg.append("percentagePriceListIds=");
         for (int i=0; i < tmpIDs.length; i++)
            { pcbbDebugMsg.append(tmpIDs[i]).append(","); }
         pcbbDebugMsg.append("\\n");

         // Price list
         tmpIDs = pcbbAB.getPriceListIds();
         pcbbDebugMsg.append("priceListIds=");
         for (int i=0; i < tmpIDs.length; i++)
            { pcbbDebugMsg.append(tmpIDs[i]).append(","); }
         pcbbDebugMsg.append("\\n");

%>

   if (cfm.JROM.needToSelectPriceList == true) {
      // no filter tc, try to get policy from cbb tc
<%
      PolicyListDataBean pldb = new PolicyListDataBean();
      pldb.setFindBy(PolicyListDataBean.FIND_BY_TC_TYPE);
      pldb.setTC(myPriceTCConfigBB_refNum);
      pldb.setPolicyType(PolicyListDataBean.TYPE_PRICE);
      pldb.setCommandContext(contractCommandContext);
      pldb.populate();

            PolicyDataBean[] _policies = pldb.getPolicyList();

            for (int i=0; i<_policies.length; i++) {
               // this is an existing tc
               PolicyDataBean pricePDB = _policies[i];

               // get the member data bean for the store member ID owner of this policy
               MemberDataBean plcymdb = new MemberDataBean();
                  plcymdb.setId(pricePDB.getStoreMemberId());
                  DataBeanManager.activate(plcymdb, request);
%>
         cfm.JROM.needToSelectPriceList = false;
         cfm.JROM.priceListIdArray[cfm.JROM.priceListIdArray.length] = '<%= ContractUtil.getPolicyPriceList(pricePDB.getProperties()) %>';

         cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length] =

                  new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
                              '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
                              '<%= pricePDB.getId() %>',
                              '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
                              new Member('<%= UIUtil.toJavaScript(plcymdb.getMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupName()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberDN()) %>'),
                                 '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>'
                                        );
         alertDebug("CBB Price Policy["+cfm.JROM.priceListPolicyArray.length+"]="+dumpObject(cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length-1]));
<%
            } // end for
%>
   } // end if needToSelectPriceList
<%
         //-----------------------------------
         // Retrive all the kit % adjustments
         //-----------------------------------
         pcbbDebugMsg.append("Kit % Adjustment: \\n");
         Enumeration priceConfigTCKitPercentageAdjEnum
            = new ComponentAdjustmentAccessBean().findByTermcond(myPriceTCConfigBB_refNum);

         if (priceConfigTCKitPercentageAdjEnum!=null)
         {
            while (priceConfigTCKitPercentageAdjEnum.hasMoreElements())
            {
               // Load the percentage adjustments for all kits within the TC
               ComponentAdjustmentAccessBean caAB = (ComponentAdjustmentAccessBean) priceConfigTCKitPercentageAdjEnum.nextElement();
               pcbbDebugMsg.append("   kitId=").append(caAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(caAB.getCatentryId());
               pcbbDebugMsg.append(",adjustment=").append(caAB.getAdjustment()).append("\\n");

               %>
                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= caAB.getKitId() %>";

                  if (cfm.JKIT.configurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= caAB.getKitId() %>";
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].action = "noaction";
                  }


                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= caAB.getCatentryId() %>";

                  if (cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= caAB.getCatentryId() %>";
                  }

                  tmpAdjValue = "<%= caAB.getAdjustment() %>";

                  // Check it's a negative value (markdown)
                  if (tmpAdjValue.substring(0, 1) == "-")
                  {
                     // Mark Down
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "1";
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue.substring(1, tmpAdjValue.length); // trim the '-' sign
                  }
                  else
                  {
                     // Mark Up
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "2";
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue;
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(caAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  <%

            }//end-while

         }//end-if (priceConfigTCKitPercentageAdjEnum!=null)


         //---------------------------------------
         // Retrive all the kit price adjustments
         //---------------------------------------

         pcbbDebugMsg.append("Kit Price Adjustment: \\n");
         Long tmpPriceListID = new Long(pcbbAB.getPriceListId());
         Enumeration priceConfigTCKitPriceAdjEnum
            = new ComponentOfferAccessBean().findByPriceList(tmpPriceListID);

         if (priceConfigTCKitPriceAdjEnum!=null)
         {
            pcbbDebugMsg.append("   Price Adjustments with priceListId(").append(tmpPriceListID).append("): \\n");

            while (priceConfigTCKitPriceAdjEnum.hasMoreElements())
            {
               // Load the price adjustments for all kits within the TC
               ComponentOfferAccessBean coAB = (ComponentOfferAccessBean) priceConfigTCKitPriceAdjEnum.nextElement();
               pcbbDebugMsg.append("      kitId=").append(coAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(coAB.getCatentryId());
               pcbbDebugMsg.append(",currency=").append(coAB.getCurrency());
               pcbbDebugMsg.append(",price=").append(coAB.getPrice()).append("\\n");

               %>

                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= coAB.getKitId() %>";

                  if (cfm.JKIT.configurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= coAB.getKitId() %>";
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].action = "noaction";
                  }

                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= coAB.getCatentryId() %>";

                  if (cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= coAB.getCatentryId() %>";
                  }

                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType
                        = "3"; // fixed price adjustment

                  // Handle multiple currency
                  tmpPriceCurrencyID = "<%= coAB.getCurrency() %>";
                  if (cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]
                           = new KPMPriceAdjustment();
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(coAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceAdjustmentValue
                        = "<%= coAB.getPrice() %>";
                  cfm.JKIT.configurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceCurrency
                        = "<%= coAB.getCurrency() %>";

               <%

            }//end-while

         }//end-if (priceConfigTCKitPriceAdjEnum!=null)

         // to debug, call alert() with pcbbDebugMsg.toString();
      }
   }
   catch (Exception ex)
   {
      com.ibm.commerce.ras.ECTrace.trace
         (com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT,
         "CatalogTree", "PriceTCConfigBuildBlock loading", ex.toString());
   }

}//end-if (contract id != null)

if (baseContract != null)
{
   try
   {
      Enumeration priceConfigTCenum
         = new TermConditionAccessBean().findByTradingAndTCSubType
                  (baseContract, ECContractConstants.EC_ELE_PRICE_TC_CONFIG_BUILD_BLOCK);

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

   if (cfm.JROM.needToSelectPriceList == true) {
      // no filter tc, try to get policy from cbb tc
<%
      PolicyListDataBean pldb = new PolicyListDataBean();
      pldb.setFindBy(PolicyListDataBean.FIND_BY_TC_TYPE);
      pldb.setTC(myPriceTCConfigBB_refNum);
      pldb.setPolicyType(PolicyListDataBean.TYPE_PRICE);
      pldb.setCommandContext(contractCommandContext);
      pldb.populate();

            PolicyDataBean[] _policies = pldb.getPolicyList();

            for (int i=0; i<_policies.length; i++) {
               // this is an existing tc
               PolicyDataBean pricePDB = _policies[i];

               // get the member data bean for the store member ID owner of this policy
               MemberDataBean plcymdb = new MemberDataBean();
                  plcymdb.setId(pricePDB.getStoreMemberId());
                  DataBeanManager.activate(plcymdb, request);
%>
         cfm.JROM.needToSelectPriceList = false;
         cfm.JROM.priceListIdArray[cfm.JROM.priceListIdArray.length] = '<%= ContractUtil.getPolicyPriceList(pricePDB.getProperties()) %>';

         cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length] =

                  new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
                              '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
                              '<%= pricePDB.getId() %>',
                              '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
                              new Member('<%= UIUtil.toJavaScript(plcymdb.getMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupName()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberDN()) %>'),
                                 '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>'
                                        );
         alertDebug("CBB Price Policy["+cfm.JROM.priceListPolicyArray.length+"]="+dumpObject(cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length-1]));
<%
            } // end for
%>
   } // end if needToSelectPriceList
<%
         //-----------------------------------
         // Retrive all the kit % adjustments
         //-----------------------------------
         pcbbDebugMsg.append("Kit % Adjustment: \\n");
         Enumeration priceConfigTCKitPercentageAdjEnum
            = new ComponentAdjustmentAccessBean().findByTermcond(myPriceTCConfigBB_refNum);

         if (priceConfigTCKitPercentageAdjEnum!=null)
         {
            while (priceConfigTCKitPercentageAdjEnum.hasMoreElements())
            {
               // Load the percentage adjustments for all kits within the TC
               ComponentAdjustmentAccessBean caAB = (ComponentAdjustmentAccessBean) priceConfigTCKitPercentageAdjEnum.nextElement();
               pcbbDebugMsg.append("   kitId=").append(caAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(caAB.getCatentryId());
               pcbbDebugMsg.append(",adjustment=").append(caAB.getAdjustment()).append("\\n");

               %>
                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= caAB.getKitId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= caAB.getKitId() %>";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].action = "noaction";
                  }


                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= caAB.getCatentryId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= caAB.getCatentryId() %>";
                  }

                  tmpAdjValue = "<%= caAB.getAdjustment() %>";

                  // Check it's a negative value (markdown)
                  if (tmpAdjValue.substring(0, 1) == "-")
                  {
                     // Mark Down
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "1";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue.substring(1, tmpAdjValue.length); // trim the '-' sign
                  }
                  else
                  {
                     // Mark Up
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "2";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue;
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(caAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  <%

            }//end-while

         }//end-if (priceConfigTCKitPercentageAdjEnum!=null)


         //---------------------------------------
         // Retrive all the kit price adjustments
         //---------------------------------------

         pcbbDebugMsg.append("Kit Price Adjustment: \\n");
         Long tmpPriceListID = new Long(pcbbAB.getPriceListId());
         Enumeration priceConfigTCKitPriceAdjEnum
            = new ComponentOfferAccessBean().findByPriceList(tmpPriceListID);

         if (priceConfigTCKitPriceAdjEnum!=null)
         {
            pcbbDebugMsg.append("   Price Adjustments with priceListId(").append(tmpPriceListID).append("): \\n");

            while (priceConfigTCKitPriceAdjEnum.hasMoreElements())
            {
               // Load the price adjustments for all kits within the TC
               ComponentOfferAccessBean coAB = (ComponentOfferAccessBean) priceConfigTCKitPriceAdjEnum.nextElement();
               pcbbDebugMsg.append("      kitId=").append(coAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(coAB.getCatentryId());
               pcbbDebugMsg.append(",currency=").append(coAB.getCurrency());
               pcbbDebugMsg.append(",price=").append(coAB.getPrice()).append("\\n");

               %>

                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= coAB.getKitId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= coAB.getKitId() %>";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].action = "noaction";
                  }

                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= coAB.getCatentryId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= coAB.getCatentryId() %>";
                  }

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType
                        = "3"; // fixed price adjustment

                  // Handle multiple currency
                  tmpPriceCurrencyID = "<%= coAB.getCurrency() %>";
                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]
                           = new KPMPriceAdjustment();
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(coAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceAdjustmentValue
                        = "<%= coAB.getPrice() %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceCurrency
                        = "<%= coAB.getCurrency() %>";

               <%

            }//end-while

         }//end-if (priceConfigTCKitPriceAdjEnum!=null)

         // to debug, call alert() with pcbbDebugMsg.toString();
      }
      
      // get the dynamic kit adjustments from grandparent contracts
      for (int gp = 0; gp < grandParentBaseContracts.size(); gp++) {
      priceConfigTCenum
         = new TermConditionAccessBean().findByTradingAndTCSubType
                  ((Long)grandParentBaseContracts.elementAt(gp), ECContractConstants.EC_ELE_PRICE_TC_CONFIG_BUILD_BLOCK);

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

   if (cfm.JROM.needToSelectPriceList == true) {
      // no filter tc, try to get policy from cbb tc
<%
      PolicyListDataBean pldb = new PolicyListDataBean();
      pldb.setFindBy(PolicyListDataBean.FIND_BY_TC_TYPE);
      pldb.setTC(myPriceTCConfigBB_refNum);
      pldb.setPolicyType(PolicyListDataBean.TYPE_PRICE);
      pldb.setCommandContext(contractCommandContext);
      pldb.populate();

            PolicyDataBean[] _policies = pldb.getPolicyList();

            for (int i=0; i<_policies.length; i++) {
               // this is an existing tc
               PolicyDataBean pricePDB = _policies[i];

               // get the member data bean for the store member ID owner of this policy
               MemberDataBean plcymdb = new MemberDataBean();
                  plcymdb.setId(pricePDB.getStoreMemberId());
                  DataBeanManager.activate(plcymdb, request);
%>
         cfm.JROM.needToSelectPriceList = false;
         cfm.JROM.priceListIdArray[cfm.JROM.priceListIdArray.length] = '<%= ContractUtil.getPolicyPriceList(pricePDB.getProperties()) %>';

         cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length] =

                  new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
                              '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
                              '<%= pricePDB.getId() %>',
                              '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
                              new Member('<%= UIUtil.toJavaScript(plcymdb.getMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberDN()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupName()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberType()) %>',
                                 '<%= UIUtil.toJavaScript(plcymdb.getMemberGroupOwnerMemberDN()) %>'),
                                 '<%= ContractUtil.getPolicyPriceListType(pricePDB.getProperties())%>'
                                        );
         alertDebug("CBB Price Policy["+cfm.JROM.priceListPolicyArray.length+"]="+dumpObject(cfm.JROM.priceListPolicyArray[cfm.JROM.priceListPolicyArray.length-1]));
<%
            } // end for
%>
   } // end if needToSelectPriceList
<%
         //-----------------------------------
         // Retrive all the kit % adjustments
         //-----------------------------------
         pcbbDebugMsg.append("Kit % Adjustment: \\n");
         Enumeration priceConfigTCKitPercentageAdjEnum
            = new ComponentAdjustmentAccessBean().findByTermcond(myPriceTCConfigBB_refNum);

         if (priceConfigTCKitPercentageAdjEnum!=null)
         {
            while (priceConfigTCKitPercentageAdjEnum.hasMoreElements())
            {
               // Load the percentage adjustments for all kits within the TC
               ComponentAdjustmentAccessBean caAB = (ComponentAdjustmentAccessBean) priceConfigTCKitPercentageAdjEnum.nextElement();
               pcbbDebugMsg.append("   kitId=").append(caAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(caAB.getCatentryId());
               pcbbDebugMsg.append(",adjustment=").append(caAB.getAdjustment()).append("\\n");

               %>
                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= caAB.getKitId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= caAB.getKitId() %>";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].action = "noaction";
                  }


                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= caAB.getCatentryId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= caAB.getCatentryId() %>";
                  }

                  tmpAdjValue = "<%= caAB.getAdjustment() %>";

                  // Check it's a negative value (markdown)
                  if (tmpAdjValue.substring(0, 1) == "-")
                  {
                     // Mark Down
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "1";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue.substring(1, tmpAdjValue.length); // trim the '-' sign
                  }
                  else
                  {
                     // Mark Up
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType = "2";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].percentageOfferAdjustmentValue
                           = tmpAdjValue;
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(caAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  <%

            }//end-while

         }//end-if (priceConfigTCKitPercentageAdjEnum!=null)


         //---------------------------------------
         // Retrive all the kit price adjustments
         //---------------------------------------

         pcbbDebugMsg.append("Kit Price Adjustment: \\n");
         Long tmpPriceListID = new Long(pcbbAB.getPriceListId());
         Enumeration priceConfigTCKitPriceAdjEnum
            = new ComponentOfferAccessBean().findByPriceList(tmpPriceListID);

         if (priceConfigTCKitPriceAdjEnum!=null)
         {
            pcbbDebugMsg.append("   Price Adjustments with priceListId(").append(tmpPriceListID).append("): \\n");

            while (priceConfigTCKitPriceAdjEnum.hasMoreElements())
            {
               // Load the price adjustments for all kits within the TC
               ComponentOfferAccessBean coAB = (ComponentOfferAccessBean) priceConfigTCKitPriceAdjEnum.nextElement();
               pcbbDebugMsg.append("      kitId=").append(coAB.getKitId());
               pcbbDebugMsg.append(",catentryId=").append(coAB.getCatentryId());
               pcbbDebugMsg.append(",currency=").append(coAB.getCurrency());
               pcbbDebugMsg.append(",price=").append(coAB.getPrice()).append("\\n");

               %>

                  // Using the kit ID as the configurations array element identifier
                  tmpKitIdNodeIndex = "CE-<%= coAB.getKitId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex] = new KPMConfiguration();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].catalogEntryRef = "<%= coAB.getKitId() %>";
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].action = "noaction";
                  }

                  // Using the catentry ID as the build blocks array element identifier
                  tmpBBIdNodeIndex = "CE-<%= coAB.getCatentryId() %>";

                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex]
                           = new KPMBuildBlock();
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].catalogEntryRef
                           = "<%= coAB.getCatentryId() %>";
                  }

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].adjustmentType
                        = "3"; // fixed price adjustment

                  // Handle multiple currency
                  tmpPriceCurrencyID = "<%= coAB.getCurrency() %>";
                  if (cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]==null)
                  {
                     // create one if not exists
                     cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID]
                           = new KPMPriceAdjustment();
                  }

                  <%
                  // Retrieve the catalog entry name & SKU
                  CatalogEntryDataBean catEntryDB = new CatalogEntryDataBean();
                  catEntryDB.setCatalogEntryID(coAB.getCatentryId().toString());
                  com.ibm.commerce.beans.DataBeanManager.activate(catEntryDB, request);
                  %>

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].name
                        = "<%= UIUtil.toJavaScript(catEntryDB.getDescription().getName()) %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].sku
                        = "<%= UIUtil.toJavaScript(catEntryDB.getPartNumber()) %>";

                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceAdjustmentValue
                        = "<%= coAB.getPrice() %>";
                  cfm.JKIT.parentConfigurationList[tmpKitIdNodeIndex].buildBlockList[tmpBBIdNodeIndex].priceOffers[tmpPriceCurrencyID].priceCurrency
                        = "<%= coAB.getCurrency() %>";

               <%

            }//end-while

         }//end-if (priceConfigTCKitPriceAdjEnum!=null)

         // to debug, call alert() with pcbbDebugMsg.toString();
      }       
      } // end for grandParentBaseContracts
   }
   catch (Exception ex)
   {
      com.ibm.commerce.ras.ECTrace.trace
         (com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT,
         "CatalogTree", "PriceTCConfigBuildBlock loading", ex.toString());
   }

}//end-if (contract id != null)

/*d79166*/


%>

//alert("Synch " + cfm.JROM.includedCategoriesAreSynched + " UnSynch " + cfm.JROM.includedCategoriesAreUnSynched);

//displayJROM();
//displayJLOM();
//displayJKIT();

alertDebug("JROM Loaded!");
alertDebug("JPOM Loaded!\n"+printJPOM());

// This function returns the JROM object
function getJROM(){
//alert('getJROM in CatalogTree.jsp');
   return cfm.JROM;
}

// This function returns the fixed tcs
function getFIXED(){
//alert('getFIXED in CatalogTree.jsp');
   return cfm.FIXED;
}

// This function returns the parent contract fixed tcs
function getParentFIXED(){
//alert('getParentFIXED in CatalogTree.jsp');
   return cfm.parentFIXED;
}

// This function returns the JROM array of rows
function getJROMRows(){
//alert('getJROMRows in CatalogTree.jsp');
   return cfm.JROM.rows;
}

// This function returns the JLOM array of rows
function getJLOM(){
//alert('getJLOM in CatalogTree.jsp');
   return cfm.JLOM;
}

// This function returns the JPOM hash table
function getJPOM() {
//alert('getJPOM in CatalogTree.jsp');
   return cfm.JPOM;
}

/*d79166*/
// This function returns the kit pricing tcs model JKIT
function getJKIT()
{
   return cfm.JKIT;
}

// This function returns the NL text of the cancel message
function getCancelMessageNLText(){
//alert('getCancelMessageNLText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("cancelMessage"))%>";
}

// This function returns the NL text of the message displayed when the user clicks on an excluded node.
function getNotExpandableNLText(){
//alert('getNotExpandableNLText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("notExpandableMessage"))%>";
}

// This function returns the NL text of the generic error message
function getGenericErrorMessageText(){
//alert('getGenericErrorMessageText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("catalogFiltersNotSaved"))%>";
}

// This function returns the NL text of the concurrency error message
function getConcurrencyErrorMessageText(){
//alert('getConcurrencyErrorMessageText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("concurrencyErrorMessage"))%>";
}

// This function returns the NL text of the error message when publishing is not complete
function getPublishNotCompleteErrorMessageText(){
//alert('getPublishNotCompleteErrorMessageText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("publishingInProgressMessage"))%>";
}

// This function returns the NL text of the "Cancel Settings" menu item
function getCancelSettingsMenuText(){
//alert('getCancelSettingsMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("cancelsettings"))%>";
}

// This function returns the NL text of the "Include" menu item
function getIncludeCatalogMenuText(){
//alert('getIncludeCatalogMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("includeCatalog"))%>";
}

// This function returns the NL text of the "Exclude" menu item
function getExcludeMenuText(){
//alert('getExcludeMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("exclude"))%>";
}

// This function returns the NL text of the "Calculate Price" menu item
function getCalculatePriceMenuText(){
//alert('getCalculatePriceMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("calculatePrice"))%>";
}

// This function returns the NL text of the confirmation message for exclusion.
function getConfirmExclusionMessageText(){
//alert('getConfirmExclusionMessageText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("confirmExcludeMessage"))%>";
}

// This function returns the NL text of the indicator message.
function getIndicatorMessage(){
//alert('getIndicatorMessage in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("indicatorMessage"))%>";
}

// This function returns the NL text of the includeCategorySynchronizedQuestion message.
function getIncludeCategorySynchronizedQuestion(){
//alert('getIncludeCategorySynchronizedQuestion in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("includeCategorySynchronizedQuestion"))%>";
}

// This function returns the NL text of the "calculating Price" indicator message.
function getCalculateMessage(){
//alert('getCalculateMessage in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("calculateMessage"))%>";
}

// This function returns the NL text of the "calculating Price" indicator message.
function getLoadingMessage(){
//alert('getLoadingMessage in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("generalLoadingMessage"))%>";
}

// This function returns the NL text of the category "SetPriceAdjustment" menu text.
function getCategorySetPriceAdjustmentMenuText(){
//alert('getCategorySetPriceAdjustmentMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("adjustCategory"))%>";
}

// This function returns the NL text of the catentry "SetPriceAdjustment" menu text.
function getCatentrySetPriceAdjustmentMenuText(){
//alert('getCatentrySetPriceAdjustmentMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("adjustCatentry"))%>";
}

// This function returns the NL text of the category "IncludeWithAdjustment" menu text.
function getCategoryIncludeWithAdjustmentMenuText(){
//alert('getCategoryIncludeWithAdjustmentMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("includeCategory"))%>";
}

// This function returns the NL text of the catentry "IncludeWithAdjustment" menu text.
function getCatentryIncludeWithAdjustmentMenuText(){
//alert('getCatentryIncludeWithAdjustmentMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("includeCatentry"))%>";
}

// This function returns the NL text of the category "Set Price-Override Limit" menu text.
function getDelegationGridCatalogFilterMenuText(){
//alert('getDelegationGridCatalogFilterMenuText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("delegationGridCatalogFilterMenu"))%>";
}

// This function returns the NL text of the reseller category adjustment text.
function getResellerAdjustmentText(){
//alert('getResellerAdjustmentText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("fixed"))%>";
}

// This function returns the NL text of the bundle adjustment text.
function getBundleAdjustmentText(){
//alert('getBundleAdjustmentText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("bundle"))%>";
}

// This function returns the NL text of the kit adjustment text.
function getKitAdjustmentText(){
//alert('getKitAdjustmentText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("kit"))%>";
}

// This function returns the NL text of the message when price calculation cannot be performed .
function getCannotPerformCalculatePriceMessageText(){
//alert('getCannotPerformCalculatePriceMessageText in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("cannotPerformCalculatePriceMessage"))%>";
}

// This function returns the NL text displayed when the user tries to display an unready IFRAME.
function getIFRAMEnotLoadedMessage(){
//alert('getIFRAMEnotLoadedMessage in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("iframeNotLoaded"))%>";
}

// This function returns the reseller store name.
function getStoreName(){
//alert('getStoreName in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript(storeName)%>";
}

top.mccmain.mcccontent.isInsideWizard = function() {
   if(document.getElementById("tree").src == "/webapp/wcs/tools/servlet/ContractCatalogFilterDeploymentInProgressPanel"){
      return false;
   }else{
      return true;
   }
}

function validatePanelData(){
//alert('validatePanelData in CatalogTree.jsp');

	if(parent.hasCalled_validatePricingTCLock) {
		return true;
	}

   if(!tree.hasSettings()){
      if(!confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateNoSettingMessage"))%>")){
         return false;
      }
   }

   if(cfm.JROM.hostingMode == false && cfm.JROM.baseContractMode == false && cfm.JROM.fromContractList == false && !tree.doesExcludedNodeHaveIncludedParent(tree.tree)){
      alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateExcludedNodeWithNoParentIncludedMessage"))%>");
      return false;
   }

   if (cfm.JROM.priceListIdArray.length == 0 && tree.hasSettings()) {
      alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("priceListSelectionMessage"))%>");
      return false;
   }

   /*d91409*/
   // The kit pricing adjustment validation is actually done in the
   // kit component pricing form. A validation result flag is set to
   // the KitPricingModel's isValidated attribute. We will use this
   // attribute to determin the passing of the validation.
   if (!cfm.JKIT.isValidated)
   {
      return false;
   }


   // d92760
   // Skip pricing TC lock validation if there's no PricingTC lock created
   if (cfm.JROM.tcLockInfo)
   {
      if (cfm.JROM.tcLockInfo["PricingTC"]!=null)
      {
         if (!parent.validatePricingTCLock(getInvalidPricingTCLockMessage()))
         {
            return false;
         }
      }
   }

   return true;
}

function validateNoteBookPanel(){
//alert('validateNoteBookPanel in CatalogTree.jsp');
   //if(!tree.hasSettings()){
   //   if(!confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateNoSettingMessage"))%>")){
   //      return false;
   //   }
   //}

   if(cfm.JROM.hostingMode == false && cfm.JROM.baseContractMode == false && cfm.JROM.fromContractList == false && !tree.doesExcludedNodeHaveIncludedParent(tree.tree)){
      alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateExcludedNodeWithNoParentIncludedMessage"))%>");
      return false;
   }

   if (cfm.JROM.priceListIdArray.length == 0 && tree.hasSettings()) {
      if (cfm.JROM.delegationGrid == false) {
         alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("priceListSelectionMessage"))%>");
      } else {
        alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("delegationGridCatalogFilterNoNominalCostMessage"))%>");
      }
      return false;
   }

   /*d91409*/
   // The kit pricing adjustment validation is actually done in the
   // kit component pricing form. A validation result flag is set to
   // the KitPricingModel's isValidated attribute. We will use this
   // attribute to determin the passing of the validation.
   if (!cfm.JKIT.isValidated)
   {
      return false;
   }



   return true;
}

function getContractNVP()
{
//alert('getContractNVP in CatalogTree.jsp');
   if (<%= foundContractId %> == true) {
      return "&contractId=<%=contractId%>";
   } else {
      return "";
   }
}

function getHostingNVP()
{
//alert('getHostingNVP in CatalogTree.jsp');
   var parms = "";
   if (cfm.JROM.hostingMode == true) {
      parms += "&hosting=true";
   }
   if (cfm.JROM.includedCategoriesAreUnSynched == true) {
      parms += "&loadUnsynchData=true";
   }
   if (cfm.JROM.fromContractList == true) {
      parms += "&fromContractList=true";
      if (cfm.JROM.baseContractMode == true) {
         parms += "&baseContract=true";
      } else {
         parms += "&baseContract=false";
      }
   }

    <% if (contractStoreId != null && contractStoreId.length() > 0) { %>
   parms += "&contractStoreId=<%=contractStoreId%>";
    <% } %>

   parms+="&priceListIds=";
   // loop through the price policies and find the price list ids
   for (var i=0; i<cfm.JROM.priceListIdArray.length; i++) {
      if (i != 0) {
         parms+=",";
      }
      parms+=cfm.JROM.priceListIdArray[i];
   }
   //alert(parms);
   return parms;
}

function getExclusions()
{
//alert('getExclusions in CatalogTree.jsp');
   if ("<%= exclusions %>" == "" || "<%= exclusions %>" == "null" ) {
      return "";
   } else {
      return "&excludedProductSetIds=<%=exclusions%>";
   }
}

function updateCatalogFilterTitleDivision() {
//alert('updateCatalogFilterTitleDivision in CatalogTree.jsp');
   titleFrame.updateCatalogFilterTitleDivision();
}

function refreshCatalogFilterTitleDivision() {
//alert('refreshCatalogFilterTitleDivision in CatalogTree.jsp');
   titleFrame.refreshCatalogFilterTitleDivision();
}

function init(){
//alert('init in CatalogTree.jsp');
   loadPanelData();
//alert('Shared Catalog ' + cfm.JROM.hasSharedCatalog);
   // if either the contract or the TC state is "in progress" then replace the tree frame to show the "in progress, please reload" frame.
   if (cfm.JROM.contractState == cfm.JROM.CONTRACT_STATUS_INPROGRESS ||
      cfm.JROM.publishStatus == cfm.JROM.PUBLISH_STATUS_INPROGRESS){
         titleFrame.doNotShowCatalogFilterTitleDivision();
           top.setContent("<%=UIUtil.toHTML((String)contractsRB.get("genericCatalogFilterTitle"))%>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterRefreshDialog&mode=deploymentInProgress" + getContractNVP() + getHostingNVP(),
               false);
   }
   // if this store does not have a shared catalog, then the catalog filter is disabled
   else if ((! cfm.JROM.hasSharedCatalog && cfm.JROM.fromContractList == false) ||
       (! cfm.JROM.hasSharedCatalog && cfm.JROM.hostingMode == true)) {
      titleFrame.doNotShowCatalogFilterTitleDivision();
           top.setContent("<%=UIUtil.toHTML((String)contractsRB.get("genericCatalogFilterTitle"))%>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterNoSharedCatalogDialog&mode=noSharedCatalog" + getContractNVP()  + getHostingNVP(),
               false);
   }
   else{
      document.getElementById("tree").src = "/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=contract.CatalogFilterTree" + getContractNVP() + getHostingNVP() + getExclusions();
   }
}

function disableDialogButtons() {
//alert('disableDialogButtons in CatalogTree.jsp');
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].disabled = true;
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].className='disabled';
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].id='disabled';
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].disabled = true;
   //parent.NAVIGATION.document.getElementsByName("OKButton")[0].style.background = '#1C5890';
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].style.background = '#1C5890';

   cfm.JROM.areButtonsDisabled = true;
}

function enableDialogButtons() {

   // d92760
   // Disable the SAVE button if the following conditons fulfill:
   // 1. when a PricingTC lock is existed for this contract
   // 2. but the lock is not owned by the current user
   // 3. and this page is displayed for "Update Catalog Filter"
   if (cfm.JROM.tcLockInfo)
   {
      if (cfm.JROM.tcLockInfo["PricingTC"]!=null)
      {
         if (cfm.JROM.tcLockInfo["PricingTC"].shouldTCbeSaved==false)
         {
            disableDialogButtons();
            return;
         }
      }
   }


//alert('enableDialogButtons in CatalogTree.jsp');
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].disabled = false;
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].className='enabled';
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].id='enabled';   
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].disabled = false;
   //parent.NAVIGATION.document.getElementsByName("OKButton")[0].style.background = '#2A70B0';
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].style.background = '#2A70B0';

   cfm.JROM.areButtonsDisabled = false;
}

function loadPanelData() {

  //alert ('Filter loadPanelData');

    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(false);
    }

    if (parent.get && cfm.JROM.fromContractList) {
      var hereBefore = parent.get("ContractFilterModelLoaded", null);
      if (hereBefore != null) {
   //alert('Filter - back to same page - load from model');
   // have been to this page before - load from the model
        var o = parent.get("ContractFilterModel", null);
   if (o != null) {
      // use the saved model, but update with
      // the parent selection data from the new model
      var pjr = cfm.parentJROM;
      var pfx = cfm.parentFIXED;
      var pjk = cfm.JKIT.parentConfigurationList;
      var title = cfm.JROM.baseContractTitle;
      var type = cfm.JROM.baseContractPriceListType;
      var is = cfm.JROM.includedCategoriesAreSynched;
      var ius = cfm.JROM.includedCategoriesAreUnSynched;
      //alert('O ' + o.JROM.includedCategoriesAreSynched + ' ' + o.JROM.includedCategoriesAreUnSynched);

      // update the saved model
      o.parentJROM = pjr;
      o.parentFIXED = pfx;
      o.JKIT.parentConfigurationList = pjk;
      o.JROM.baseContractTitle = title;
      o.JROM.baseContractPriceListType = type;
   //alert('O base contract type ' + o.JROM.baseContractPriceListType + ' type index ' + o.JROM.priceListTypeIndex);
      o.JROM.includedCategoriesAreSynched = is;
      o.JROM.includedCategoriesAreUnSynched = ius;

      // get the JLOM from the saved model and remove the deleted entries
      var currentJLOM = o.JLOM;
      var newJLOM = new Array();
      for (JLOMID in currentJLOM){
         if (currentJLOM[JLOMID].mode != "DELETED") {
         newJLOM[JLOMID] = new JLOMrow (JLOMID, currentJLOM[JLOMID].precedence, currentJLOM[JLOMID].nodeType, currentJLOM[JLOMID].refID,
                   currentJLOM[JLOMID].mode, currentJLOM[JLOMID].synch, currentJLOM[JLOMID].adjustment);
         }
      }
      o.JLOM = newJLOM;
      //
      // set this page with the saved model
      cfm = o;
      refreshCatalogFilterTitleDivision();
   } // end if model is found
     } // end if here before
     else {
   // this is the first time on this page
   //alert('Filter - first time on page');

   // save the model
        parent.put("ContractFilterModel", cfm);
   parent.put("ContractFilterModelLoaded", true);
   //updateCatalogFilterTitleDivision();

     } // end else first time to this page

    } // end if parent.get

   /*90288*/ handleTCLockStatus();

 } // end function

function savePanelData()
 {
  //alert ('Filter savePanelData');
  /*d79166*/ tree.saveKitComponentsInPanel();
  if (parent.get && cfm.JROM.fromContractList) {
        var o = parent.get("ContractFilterModel", null);
        if (o != null) {
      //alert('CFM ' +  cfm.JROM.includedCategoriesAreSynched + ' ' + cfm.JROM.includedCategoriesAreUnSynched);
      o = cfm;
   //alert('save O base contract type ' + o.JROM.baseContractPriceListType + ' type index ' + o.JROM.priceListTypeIndex);
      //alert("catalogOwner="+dumpObject(cfm.JROM.catalogOwner));
        }
  }
 }


/*90288*/
//-------------------------------------------------------
// These variables capture the return code and some
// lock details of executing the ContractTCLockHelper
//-------------------------------------------------------
var contractTCLockHelperRC = "<%= lockHelperRC %>";
var contractTCLockOwner    = "<%= tcLockOwner %>";
var contractTCLockTime     = "<%= tcLockTimestamp %>";
var shouldTCbeSaved        = false;


//------------------------------------------------------------------------
// Function Name: handleTCLockStatus
//
// This function handle the current lock status for this terms and
// conditions. It will determine the dialog to interact with user
// according to the lock status return code during loading this page.
//------------------------------------------------------------------------
function handleTCLockStatus()
{
   if (contractTCLockHelperRC==0)
   {
      // Skip it because this is a new contract not even created yet
      return;
   }

   var forceUnlock = false;

   if (   (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ACQUIRE_NEWLOCK %>")
       || (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_RENEW_LOCK %>") )
   {
      // New lock has been acquired for the current user on this TC
      shouldTCbeSaved = true;
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_NOT_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, and user is not allowed to unlock.
      // Show warning message to the user

      shouldTCbeSaved = false;
      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>";
      var warningMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>";
      warningMsg = warningMsg.replace(/%3/, tcName);
      warningMsg = warningMsg.replace(/%1/, contractTCLockOwner);
      warningMsg = warningMsg.replace(/%2/, contractTCLockTime);

      alertDialog(warningMsg);
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, but user is allowed to unlock.
      // Promopt user to unlock

      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>";
      var promptMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>";
      promptMsg = promptMsg.replace(/%3/, tcName);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);
      promptMsg = promptMsg.replace(/%2/, contractTCLockTime);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);

      if (confirmDialog(promptMsg))
      {
         // User clicks OK to unlock this TC
         shouldTCbeSaved = true;
         forceUnlock = true;
         parent.unlockAndLockContractTC("<%= contractId %>", 1);
      }
      else
      {
         // User clicks CANCEL to give up the unlock of this TC
         shouldTCbeSaved = false;
      }
   }

   // Persist the flag to the javascript ContractCommonDataModel
   var ccmd = parent.get("ContractCommonDataModel", null);
   if (ccmd!=null)
   {
      // ContractCommonDataModel exists in Contract Notebook
      ccmd.tcLockInfo["PricingTC"] = new Object();
      ccmd.tcLockInfo["PricingTC"].contractID = "<%= contractId %>";
      ccmd.tcLockInfo["PricingTC"].tcType = "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING %>";
      ccmd.tcLockInfo["PricingTC"].shouldTCbeSaved = shouldTCbeSaved;
      ccmd.tcLockInfo["PricingTC"].forceUnlock = forceUnlock;
   }
   else
   {
      // ContractCommonDataModel does NOT exist in Contract Notebook
      // but we can use the JROM to store the lock information
      cfm.JROM.tcLockInfo = new Array();
      cfm.JROM.tcLockInfo["PricingTC"] = new Object();
      cfm.JROM.tcLockInfo["PricingTC"].contractID = "<%= contractId %>";
      cfm.JROM.tcLockInfo["PricingTC"].tcType = "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING %>";
      cfm.JROM.tcLockInfo["PricingTC"].shouldTCbeSaved = shouldTCbeSaved;
      cfm.JROM.tcLockInfo["PricingTC"].forceUnlock = forceUnlock;
   }

   // Should the SAVE button be enabled?
   // This will base on the current pricing TC is determined
   // not to be saved and other conditions as well.
   if (!shouldTCbeSaved)
   {
      if (parent.get("ContractCommonDataModel")==null)
      {
         // I'm coming from Update Catalog Filter, disable the 'SAVE' button
         // so that the user is not able to save his changes. We assume the
         // ContractCommonDataModel will be created once the Contract Notebook
         // is entered.
         disableDialogButtons();
      }
      else
      {
         // I'm inside Contract Notebook, do nothing, the Contract notebook
         // will omit the pricing TC submission to backend.
      }
   }

   return;

}//end-function-handleTCLockStatus


/*90288*/
// This function returns the NL text of the message when the pricing TC lock is failed to verify .
function getInvalidPricingTCLockMessage()
{
   var msg = "<%=UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockTCByOthers"))%>";
   var tcName = "<%=UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter"))%>";
   msg = msg.replace(/%3/, tcName);
   return msg;
}


</script>
</head>

<frameset id="catalogFilterMainFrame" framespacing="0" border="0" frameborder="0" rows="20%, 80%, 0%" onload="init();">
   <frame name="titleFrame" id="titleFrame" src="/webapp/wcs/tools/servlet/ContractCatalogFilterTitlePanel?contractId=<%=contractId%>&fromContractList=<%= baseContractParm%>&accountId=<%= UIUtil.toJavaScript(accountId) %>" name="titleFrame" title="<%=UIUtil.toJavaScript((String)contractsRB.get("catalogTreeTitlePanel"))%>">
   <frame name="tree" id="tree" src="/wcs/tools/common/blank.html" name="tree" title="<%=UIUtil.toJavaScript((String)contractsRB.get("catalogTreePanel"))%>">
   <frame name="kitPricingFrame" id="kitPricingFrame" src="/wcs/tools/common/blank.html" title="<%=UIUtil.toJavaScript((String)contractsRB.get("catalogTreePanel"))%>">
</frameset>

</html>


