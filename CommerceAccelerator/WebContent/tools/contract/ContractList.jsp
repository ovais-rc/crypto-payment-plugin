<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.tools.common.ui.taglibs.*,
   com.ibm.commerce.utils.TimestampHelper,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.store.util.StoreConstants,
   com.ibm.commerce.contract.helper.ECContractConstants,
   com.ibm.commerce.contract.util.ECContractCmdConstants,
   com.ibm.commerce.contract.util.ECContractErrorCode,
   com.ibm.commerce.contract.util.ContractCmdUtil,
   com.ibm.commerce.tools.contract.beans.ContractListDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.context.content.resources.ManagedResourceKey,
   com.ibm.commerce.context.content.resources.ResourceManager,
   com.ibm.commerce.context.content.locking.LockData,
   com.ibm.commerce.contract.content.resources.ContractContainer,
   com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean,
   com.ibm.commerce.user.beans.UserDataBean,
   com.ibm.commerce.ras.ECTrace,
   com.ibm.commerce.ras.ECTraceIdentifiers,
   com.ibm.commerce.registry.StoreRegistry,
   com.ibm.commerce.common.beans.StoreEntityDataBean,
   com.ibm.commerce.common.objects.StoreAccessBean,
   com.ibm.commerce.common.objects.StoreJDBCHelperBean" %>


<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>


<%
   String orderByParm = request.getParameter("orderby");
   String stateParm = request.getParameter("state");
   String accountIdParm = request.getParameter("accountId");

   //search parameters
   String contractSearchNameParm = request.getParameter("contractSearchName");
   String contractNameFilterParm = request.getParameter("contractNameFilter");
   String contractSearchShortDescParm = request.getParameter("contractSearchShortDesc");
   String contractSearchShortDescFilterParm = request.getParameter("contractSearchShortDescFilter");
   String contractSearchStoreNameParm = request.getParameter("contractSearchStoreName");
   String contractSearchStoreNameFilterParm = request.getParameter("contractSearchStoreNameFilter");
   String searchModeParm = request.getParameter ("searchMode");


   // handle errors from the controller commands
   String errorStatus = request.getParameter(ECContractCmdConstants.SUBMIT_ERROR_STATUS);
   String errorMessage = null;

   if (errorStatus.length() != 0) {
      if (errorStatus.equals(ECContractErrorCode.EC_ERR_WRONG_CONTRACT_STATE))
         errorMessage = (String)contractsRB.get("contractStateError");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_MISSING_PRICE_TC))
         errorMessage = (String)contractsRB.get("contractMissingPriceTC");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_MISSING_BUYER_PARTICIPANT))
         errorMessage = (String)contractsRB.get("contractMissingBuyerParticipant");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_CONTRACT_EXPIRED))
         errorMessage = (String)contractsRB.get("contractExpiredInvalidEndDate");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_SHIPPING_CHARGE_TC))
         errorMessage = (String)contractsRB.get("contractMissingShippingChargeType");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_ORDER_APPROVAL_TC))
         errorMessage = (String)contractsRB.get("contractOnlyOneOrderApprovalTC");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_CANNOT_HAVE_MORE_THAN_ONE_MC_OPTIONAL_ADJUSTMENT_TC))
         errorMessage = (String)contractsRB.get("contractOnlyOneMasterCatalogTC");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGE))
         errorMessage = (String)contractsRB.get("contractOnlyOneReturnChargeTC");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_RETURN_TC_RETURN_CHARGER_AND_REFUND_METHOD_DO_NOT_MATCH))
         errorMessage = (String)contractsRB.get("contractMissingReturns");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_USER_AUTHORITY_DEPLOY_IN_AUTO_APPROVAL))
         errorMessage = (String)contractsRB.get("contractGenericWrongAuthorityError");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_NO_CANCEL_WITH_ACTIVE_CONTRACT_REFERRAL))
         errorMessage = (String)contractsRB.get("contractCannotCancelWithReference");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_NO_SUSPEND_WITH_ACTIVE_CONTRACT_REFERRAL))
         errorMessage = (String)contractsRB.get("contractCannotSuspendWithReference");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_NO_SUBMIT_WITH_NON_ACTIVE_CONTRACT_REFERRAL))
         errorMessage = (String)contractsRB.get("contractMustReferToActiveContract");
      else if (errorStatus.equals(ECContractErrorCode.EC_ERR_CATALOG_FILTER_OR_PRODUCTSET_TC_NOT_FOUND))
         errorMessage = (String)contractsRB.get("noCatalogFilterOrProductSetTC");
      else
         errorMessage = (String)contractsRB.get("contractGenericActionError");
      }
   String usageParm = request.getParameter("contractUsage");
   Integer usage = new Integer(usageParm);

   String reportParm = request.getParameter("reportMode");
   if (reportParm == null){
         reportParm = "0";
   }
   Integer reportMode = new Integer(reportParm);

   //hostingMode distinguishes between hosting (e.g.: SPE) or channel (e.g.: PCD) mode.
   // 0 = channel mode, 1 = Hosting mode
   String hostingModeParm = request.getParameter("hostingMode");
   if (hostingModeParm == null){
         hostingModeParm = "0";
   }

   // get the hub store type
   String storeTypeString = "";
   StoreAccessBean store = StoreRegistry.singleton().find(fStoreId);
   String strStoreType = store.getStoreType ();
   if ( strStoreType.equals( "HCP" ) ) { // Hosting
      storeTypeString = "&storetype=BMP&storetype2=MPS";
   } else if ( strStoreType.equals( "CHS" ) ) { // Channel
      storeTypeString = "&storetype=BRP&storetype2=RPS";
   } else if ( strStoreType.equals( "SCP" ) ) { // Supplier
      storeTypeString = "&storetype=SPS";
   }

   StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   DataBeanManager.activate(scDB, request);
   Vector storecat = scDB.getStoreCategories();  	
   	
   //accountId not used for Distributors and Resellers, so set to -1
   if(ContractCmdUtil.isHostingContract(usage) || ContractCmdUtil.isReferralContract(usage) || ContractCmdUtil.isDelegationGridContract(usage)){
      accountIdParm = "-1";
   }
   if (accountIdParm.length() == 0){
         accountIdParm = "-1";
   }

   boolean baseContractAccount = false;

   if (accountIdParm.equals("-1") == false) {
      AccountDataBean account = new AccountDataBean(new Long(accountIdParm), new Integer(fLanguageId));
      DataBeanManager.activate(account, request);
      String accountName = account.getAccountName();
      if (accountName != null && accountName.indexOf("BaseContracts") >= 0) {
         baseContractAccount = true;
      }
   }

   ContractDataBean contracts[] = null;
   int numberOfContracts = 0;

   //call the DataBean's contructor depending on the usage
   ContractListDataBean contractList;
   if(ContractCmdUtil.isHostingContract(usage) || ContractCmdUtil.isReferralContract(usage) || ContractCmdUtil.isDelegationGridContract(usage)){
      contractList = new ContractListDataBean(fLanguageId, orderByParm, stateParm, fStoreId.toString(), usage.intValue());
   }
   else {
      contractList = new ContractListDataBean(new Long(accountIdParm), fLanguageId, orderByParm, stateParm, fStoreId.toString(), usage.intValue() );
   }

   //set parameters for contract search
   if (contractSearchNameParm != null && contractSearchNameParm.trim().length() > 0) {
      contractList.setSearchName (contractSearchNameParm);
   }
   if (contractNameFilterParm != null && contractNameFilterParm.trim().length() > 0) {
      contractList.setSearchNameFilter (contractNameFilterParm);
   }
   if (contractSearchShortDescParm != null && contractSearchShortDescParm.trim().length() > 0) {
      contractList.setSearchDesc (contractSearchShortDescParm);
   }
   if (contractSearchShortDescFilterParm != null && contractSearchShortDescFilterParm.trim().length() > 0) {
      contractList.setSearchDescFilter (contractSearchShortDescFilterParm);
   }
   if (contractSearchStoreNameParm != null && contractSearchStoreNameParm.trim().length() > 0) {
      contractList.setSearchStoreName (contractSearchStoreNameParm);
   }
   if (contractSearchStoreNameFilterParm != null && contractSearchStoreNameFilterParm.trim().length() > 0) {
      contractList.setSearchStoreNameFilter (contractSearchStoreNameFilterParm);
   }

   //get the start and list sizes from the xml file
   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   int endIndex = startIndex + listSize;

   //initialize the start and end indicies
   contractList.setIndexEnd("" + endIndex);
   contractList.setIndexBegin("" + startIndex);

   DataBeanManager.activate(contractList, request);
   contracts = contractList.getContractList();

   //set up the total number of contracts found
   int totalNumberOfContracts = 0;

   if (contracts != null) {
      numberOfContracts = contracts.length;
      totalNumberOfContracts = contractList.getResultSetSize(); // this line has a problem when runnning in WSAD
   }

   //set up paging
   int rowselect = 1;
   int totalpage = 0;
   if (listSize != 0) {
      totalpage = totalNumberOfContracts/listSize;
   }


%>
      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>

<script type="text/javascript">

   /*d79167*/
   var contractsLockStatusList  = new Array();
   var contractsLockDetailsList = new Array();

   function setContractLockStatus(contractID, locked)
   {
      contractsLockStatusList[contractID] = locked;
   }

   function getContractLockStatus(contractID)
   {
      if (contractsLockStatusList[contractID]==null)
      {
         // default return false
         return false;
      }
      else if (contractsLockStatusList[contractID]=="true")
      {
         return true;
      }
      else if (contractsLockStatusList[contractID]=="false")
      {
         return false;
      }
      else
      {
         // default return false
         return false;
      }
   }

   //--------------------------------------------------------------------------
   // Function Name: setContractLockDetails
   //
   // This function stores the lock information details for a contract. The
   // following is a list of valid tcType values:
   //       "0" - Price TC
   //       "1" - Shipping TC
   //       "2" - Payment TC
   //       "3" - Returns TC
   //       "4" - Order Approval TC
   //       "5" - General, Participants, Remarks, Attachments Pages
   //--------------------------------------------------------------------------
   function setContractLockDetails(contractID, tcType, logonID, lockTimeStamp)
   {
      if (contractsLockDetailsList[contractID]==null)
      {
         contractsLockDetailsList[contractID] = new Array();
      }

      contractsLockDetailsList[contractID][tcType] = new Object();
      contractsLockDetailsList[contractID][tcType].contractID = contractID;
      contractsLockDetailsList[contractID][tcType].tcTypNume  = tcType;
      contractsLockDetailsList[contractID][tcType].lockBy     = logonID;
      contractsLockDetailsList[contractID][tcType].lockTime   = lockTimeStamp;
   }

   function getContractLockDetails(contractID)
   {
      return contractsLockDetailsList[contractID];
   }

</script>

   <head>
      <%= fHeader %>
      <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

         <title> <!--%= title %--></title>

      <script type="text/javascript">

   function userInitialButtons() {
      checkButtons();
   }

   function onLoad() {
      parent.loadFrames();
   }

   function getResultsSize() {
      return <%= totalNumberOfContracts %>;
   }

   function getListTitle() {
      //returns the last title in BCT (for View dropdown and Refresh button)
      return top.mccbanner.trail[top.mccbanner.counter].name;
   }

   function getAccountId() {
      return "<%= UIUtil.toJavaScript(accountIdParm) %>";
   }

   function getcontractSearchName() {
      return trim("<%= UIUtil.toJavaScript(contractSearchNameParm)%>");
   }
   function getcontractNameFilter() {
      return trim("<%= UIUtil.toJavaScript(contractNameFilterParm)%>");
   }
   function getcontractSearchShortDesc() {
      return trim("<%= UIUtil.toJavaScript(contractSearchShortDescParm)%>");
   }
   function getcontractSearchShortDescFilter() {
      return trim("<%= UIUtil.toJavaScript(contractSearchShortDescFilterParm)%>");
   }
   function getcontractSearchStoreName() {
      return trim("<%= UIUtil.toJavaScript(contractSearchStoreNameParm)%>");
   }
   function getcontractSearchStoreNameFilter() {
      return trim("<%= UIUtil.toJavaScript(contractSearchStoreNameFilterParm)%>");
   }
   function getSearchMode() {
      return trim("<%=UIUtil.toJavaScript(searchModeParm)%>");
   }
   function getHostingMode() {
      return trim("<%=UIUtil.toJavaScript(hostingModeParm)%>");
   }
   //Appends persistent search parameters to URL
   function constructURL (sURL) {
      var newUrl = sURL;
      if (getcontractSearchName() != null && getcontractSearchName().length > 0) {
         newUrl+="&contractSearchName=" + getcontractSearchName();
         //alert ("Added searchname " + getcontractSearchName());
      }
      if (getcontractNameFilter() != null && getcontractNameFilter().length > 0) {
         newUrl+="&contractNameFilter=" + getcontractNameFilter();
      }
      if (getcontractSearchShortDesc() != null && getcontractSearchShortDesc().length > 0) {
         newUrl+="&contractSearchShortDesc=" + getcontractSearchShortDesc();
         //alert ("Added searchdesc " + getcontractSearchShortDesc());
      }
      if (getcontractSearchShortDescFilter() != null && getcontractSearchShortDescFilter().length > 0) {
         newUrl+="&contractSearchShortDescFilter=" + getcontractSearchShortDescFilter();
      }
      if (getcontractSearchStoreName() != null && getcontractSearchStoreName().length > 0) {
         newUrl+="&contractSearchStoreName=" + getcontractSearchStoreName();
      }
      if (getcontractSearchStoreNameFilter() != null && getcontractSearchStoreNameFilter().length > 0) {
         newUrl+="&contractSearchStoreNameFilter=" + getcontractSearchStoreNameFilter();
      }
      if (getSearchMode() != null && getSearchMode().length > 0) {
         newUrl+="&searchMode=" + getSearchMode();
      }
      if (getHostingMode() != null && getHostingMode().length > 0) {
         newUrl+="&hostingMode=" + getHostingMode();
      }
      //keep the order by parameter persistant
      newUrl+="&orderby=<%= UIUtil.toJavaScript(orderByParm) %>";
      return newUrl;
   }

   //Construct REDIRECT URL for different type of usage and searchMode
   function constructRedirURL (redirURL) {
      var newRedirURL = redirURL;
      if(<%=ContractCmdUtil.isReferralContract(usage)%>){
         if (getSearchMode() == "1" ) {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.DistributorSearchResultsList&cmd=ContractListView";
         } else {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.DistributorList&cmd=ContractListView";
         }
      }
      else if(<%=ContractCmdUtil.isHostingContract(usage)%>){
         if (getSearchMode() == "1" ) {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.ResellerSearchResultsList&cmd=ContractListView";
         } else {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.ResellerList&cmd=ContractListView";
         }

         if (getHostingMode() == "1" ) {
            newRedirURL+="&hostingMode=" + getHostingMode();
         }
      }
      else if(<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
         if (getSearchMode() == "1" ) {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.DelegationGridSearchResultsList&cmd=ContractListView";
         } else {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.DelegationGridList&cmd=ContractListView";
         }
      }
      else {
         if (getSearchMode() == "1" ) {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.ContractSearchResultsList&cmd=ContractListView";
         } else {
            newRedirURL+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.ContractList&cmd=ContractListView";
         }
      }

      return newRedirURL;
   }

   function newContract(){
    if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
      top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("delegationGridWizardTitle"))%>",
         "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.DelegationGridNotebook&contractUsage=<%= usage.intValue()%>&delegationGrid=true",
         true);
    } else {
     if ("<%= baseContractAccount %>" == "true") {
      top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractWizardTitle"))%>",
         "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&accountId=<%= UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=true",
         true);
     } else {
      top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractWizardTitle"))%>",
         "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=false",
         true);
     }
    }
   }

   function createStore() {
      //alert("/webapp/wcs/tools/servlet/WizardView?XMLFile=contract.StoreCreationWizard&fromAccelerator=true<%=storeTypeString%>&includeEmptyCatalog=false&storeViewName=ABC");
      top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractCreateResellerTitle"))%>",
            constructURL("/webapp/wcs/tools/servlet/WizardView?XMLFile=contract.StoreCreationWizard&fromAccelerator=true<%=storeTypeString%>"),
            true);

   }

   function importContract() {
      if (<%=ContractCmdUtil.isHostingContract(usage)%>){
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractImportResellerTitle"))%>",
               constructURL("/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ResellerImportPanel&goBack=true&contractUsage=<%= usage.intValue()%>"),
               true);
   }
   else if (<%=ContractCmdUtil.isReferralContract(usage)%>){
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractImportDistributorTitle"))%>",
         constructURL("/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DistributorImportPanel&goBack=true&contractUsage=<%= usage.intValue()%>"),
      true);
      }
   else if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractImportDelegationGridTitle"))%>",
         constructURL("/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DelegationGridImportPanel&goBack=true&contractUsage=<%= usage.intValue()%>"),
      true);
      }
      else {
   top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractImportTitle"))%>",
         constructURL("/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractImportPanel&goBack=true&contractUsage=<%= usage.intValue()%>&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>"),
         true);
      }

   }

   function exportContract() {
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.exportButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("exportBCT")) %>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractExportPanel&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&state=<%=  UIUtil.toJavaScript(stateParm) %>",
            true);
      }
   }

   function changeContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.changeButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("delegationGridNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.DelegationGridNotebook&contractId=" + contractId +
            "&contractUsage=<%= usage.intValue()%>&delegationGrid=true",
            true);
         } else {
          if ("<%= baseContractAccount %>" == "true") {
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=true",
            true);
          } else {
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=false",
            true);
          }
         }
      }
   }

   function filterContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.updateCatalogFilterButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         if ("<%= baseContractAccount %>" == "true") {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("filterCatalog"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=true",
               true);
         } else {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("filterCatalog"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=false",
               true);
         }
      }
   }
  //LI 2261 
  function updateExtendedTermCondition(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.updateCatalogFilterButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         if ("<%= baseContractAccount %>" == "true") {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("UpdateExtTermCondition"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.UpdateTermConditionDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=true",
               true);
         } else {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("UpdateExtTermCondition"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.UpdateTermConditionDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=false",
               true);
         }
      }
   }
   function filterHostingContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.filterCatalogButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         if ("<%= baseContractAccount %>" == "true") {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("filterCatalog"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>"
               + "&baseContract=true&hosting=true&contractStoreId=" + contractStoreId,
               true);
         } else {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("filterCatalog"))%>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.CatalogFilterDialog&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>"
               + "&baseContract=false&hosting=true&contractStoreId=" + contractStoreId,
               true);
         }
      }
   }

   function changeContractById(checked) {
      if (checked.length > 0 && defined(parent.buttons.buttonForm.changeButton)) {
         var parms = checked.split(',');
         var contractId = parms[0];
         if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("delegationGridNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.DelegationGridNotebook&contractId=" + contractId +
            "&contractUsage=<%= usage.intValue()%>&delegationGrid=true",
            true);
         } else {
          if ("<%= baseContractAccount %>" == "true") {
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=true",
            true);
          } else {
           top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractNotebookTitle"))%>",
            "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>&baseContract=false",
            true);
          }
         }
      }
   }

   function viewContract() {
      var checked = parent.getChecked().toString();

      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.viewButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         if(contractStoreId == "null" || contractStoreId == null){
            contractStoreId ="-1";
         }

         if (<%=ContractCmdUtil.isHostingContract(usage)%>){
            top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ResellerSummary&contractId=" + contractId +
               "&contractUsage=<%= usage.intValue()%>&contractStoreId=" + contractStoreId,
               true);
         }
         else if (<%=ContractCmdUtil.isReferralContract(usage)%>){
            top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DistributorSummary&contractId=" + contractId +
               "&contractUsage=<%= usage.intValue()%>&contractStoreId=" + contractStoreId,
               true);
         }
         else if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
            top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DelegationGridSummary&contractId=" + contractId +
               "&contractUsage=<%= usage.intValue()%>",
               true);
         }
         else {
            top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
               "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractSummary&contractId=" + contractId +
               "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>",
               true);

         }

      }
   }

   function viewContractById(checked, contractStoreId) {
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.viewButton) == false) {
            //alert("checked: " + checked);
            var parms = checked.split(',');
            var contractId = parms[0];
            if(contractStoreId == "null" || contractStoreId == null){
               contractStoreId =-1;
            }
            //alert("contractStoreId: " + contractStoreId);
            if (<%=ContractCmdUtil.isHostingContract(usage)%>){

               top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
                  "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ResellerSummary&contractId=" + contractId +
                  "&contractUsage=<%= usage.intValue()%>&contractStoreId=" + contractStoreId,
                  true);
            }
            else if (<%=ContractCmdUtil.isReferralContract(usage)%>){
               top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
                  "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DistributorSummary&contractId=" + contractId +
                  "&contractUsage=<%= usage.intValue()%>&contractStoreId=" + contractStoreId,
                  true);
            }
            else if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
               top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
                  "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.DelegationGridSummary&contractId=" + contractId +
                  "&contractUsage=<%= usage.intValue()%>",
                  true);
            }
            else {
               top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
                  "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractSummary&contractId=" + contractId +
                  "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>",
                  true);
            }
         }
   }

   function copyContract() {
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.copyButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("duplicateBCT")) %>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractDuplicate&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&contractUsage=<%= usage.intValue()%>",
            true);
      }
   }

   function cancelDeleteContract(){
      var checked = parent.getChecked();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.deleteButton) == false) {

      <%
         String cdDialogString = "";
         if(ContractCmdUtil.isReferralContract(usage)){
            cdDialogString = UIUtil.toJavaScript((String)contractsRB.get("distributorListDeleteConfirmation"));
         }
         else if (ContractCmdUtil.isHostingContract(usage)){
            cdDialogString = UIUtil.toJavaScript((String)contractsRB.get("resellerListDeleteConfirmation"));
         }
         %>
         if (confirmDialog("<%=cdDialogString%>")) {
            var parms = checked[0].split(',');
            var contractId = parms[0];
            var url = "/webapp/wcs/tools/servlet/ContractCancel?contractId=" + contractId + "&deleteContract=true";
            url = constructURL (url);
            url = constructRedirURL (url);
            url+="&contractUsage=<%= usage.intValue()%>";
            url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
            parent.location.replace(url);
            for (var i = 1; i < checked.length; i++) {
               parms = checked[i].split(',');
               contractId = parms[0];
               url = "/webapp/wcs/tools/servlet/ContractCancel?contractId=" + contractId + "&deleteContract=true";
               url = constructURL (url);
               url = constructRedirURL (url);
               url+="&contractUsage=<%= usage.intValue()%>";
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               parent.location.replace(url);
            }

         }
      }
   }


   function deleteContract() {
      var checked = parent.getChecked();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.deleteButton) == false) {

      <%
         String dialogString = UIUtil.toJavaScript((String)contractsRB.get("contractListDeleteConfirmation"));
         if (ContractCmdUtil.isDelegationGridContract(usage)) {
            dialogString = UIUtil.toJavaScript((String)contractsRB.get("delegationGridListDeleteConfirmation"));
         }
         %>
         if (confirmDialog("<%=dialogString%>")) {
            var parms = checked[0].split(',');
            var contractId = parms[0];
            var url = "/webapp/wcs/tools/servlet/ContractDelete?contractId=" + contractId;
            for (var i = 1; i < checked.length; i++) {
               parms = checked[i].split(',');
               contractId = parms[0];
               url += "&contractId=" + contractId;

            }
            url = constructURL (url);
            url = constructRedirURL (url);
            url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
            url+="&contractUsage=<%= usage.intValue()%>";
            url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
            parent.location.replace(url);
         }
      }
   }

   function refreshContract() {
      top.mccbanner.loadbct();
   }


   /*d79167*/
   function unlockContract()
   {
      var checked = parent.getChecked();

      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.unlockButton) == false)
      {

      <%
         String unlockMsgPrompt_part1 = UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockConfirm1"));
         String unlockMsgPrompt_part2 = UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockConfirm2"));
         String unlockMsgPrompt_part2P= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockConfirm2P"));
         String unlockMsgPrompt_part3 = UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgUnlockConfirm3"));
         String labelPriceTC          = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter"));
         String labelShippingTC       = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Shipping"));
         String labelPaymentTC        = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Payment"));
         String labelReturnsTC        = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Returns"));
         String labelOrderApprovalTC  = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OrderApproval"));
         String labelOtherPages       = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OtherPages"));
         
         Hashtable storeCreationWizardRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB",
                                                                                           fLocale);
         if (storeCreationWizardRB == null) {
           out.println("StoreCreationWizard resources bundle is null");
         }
         
         String allowUnlock = UIUtil.toJavaScript((String)storeCreationWizardRB.get("allowAcctRepUnlockTC"));
		 String cantUnlockMsg = UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC"));
         //=========================================================
         // *DEVELOPER'S NOTE*
         // If you add a new TC, please add a similar statement here.
         //
         // For example,
         //
         //    String labelMyNewTC = UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_MyNewTC"));
         //
         //=========================================================
      %>


         var parms = checked[0].split(',');
         var contractId = parms[0];
         var myLocksInfo = getContractLockDetails(contractId);
         var info = getContractLockDetails(contractId);
         var tcMsg = "<%= unlockMsgPrompt_part2 %>";
         var msgPrompt = "";

         if ("<%= allowUnlock %>"=="false"){
           tcMsg = "<%= cantUnlockMsg %>";  
         }

         // The index value means:
         // "0" - Price TC
         // "1" - Shipping TC
         // "2" - Payment TC
         // "3" - Returns TC
         // "4" - Order Approval TC
         // "5" - General, Remarks, Attachments Pages

         <%--
         //=========================================================
         // *DEVELOPER'S NOTE*
         // If you add a new TC, please add a new javascript if
         // statement block similar as the one below, use the
         // proper index number to reference the info array, and
         // replace the label text such as labelMyNewTC.
         //
         //=========================================================
         --%>

         if (info["0"]!=null)
         {
            // Price TC is locked
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelPriceTC %>");
            tcLine = tcLine.replace(/%1/, info["0"].lockBy);
            tcLine = tcLine.replace(/%2/, info["0"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if (info["1"]!=null)
         {
            // Shipping TC is locked
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelShippingTC %>");
            tcLine = tcLine.replace(/%1/, info["1"].lockBy);
            tcLine = tcLine.replace(/%2/, info["1"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if (info["2"]!=null)
         {
            // Payment TC is locked
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelPaymentTC %>");
            tcLine = tcLine.replace(/%1/, info["2"].lockBy);
            tcLine = tcLine.replace(/%2/, info["2"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if (info["3"]!=null)
         {
            // Returns TC is locked
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelReturnsTC %>");
            tcLine = tcLine.replace(/%1/, info["3"].lockBy);
            tcLine = tcLine.replace(/%2/, info["3"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if (info["4"]!=null)
         {
            // Order approval TC is locked
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelOrderApprovalTC %>");
            tcLine = tcLine.replace(/%1/, info["4"].lockBy);
            tcLine = tcLine.replace(/%2/, info["4"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if (info["5"]!=null)
         {
            // General, remarks, attachment, participants pages are locked
//            var tcLine = "<%= unlockMsgPrompt_part2P %>";
            var tcLine = tcMsg;
            tcLine = tcLine.replace(/%3/, "<%= labelOtherPages %>");
            tcLine = tcLine.replace(/%1/, info["5"].lockBy);
            tcLine = tcLine.replace(/%2/, info["5"].lockTime);
            msgPrompt += tcLine + "<br />";
         }

         if ("<%= allowUnlock %>"=="false"){
           alertDialog(msgPrompt);
           return;
         }

         var unlockMsgPrompt = "<%= unlockMsgPrompt_part1 %>"
                             + "<br />"
                             + msgPrompt
                             + "<%= unlockMsgPrompt_part3 %>";

         if (confirmDialog(unlockMsgPrompt))
         {
            url = "/webapp/wcs/tools/servlet/ContractUnlock?contractId=" + contractId;
            url = constructRedirURL (url);
            url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
            url+="&contractUsage=<%= usage.intValue()%>";
            url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
            url = constructURL (url);

            //alert(url);
            parent.location.replace(url);
         }

      }//end-if

   }//end-function


   function disableButton(b) {
      if (defined(b)) {
         b.disabled=true;
         b.className='disabled';
         b.id='disabled';
      }
   }

   function isButtonDisabled(b) {
      if (b.className =='disabled' &&  b.id == 'disabled')
         return true;
      return false;
   }

   function selectAllButtons() {
      parent.selectDeselectAll();
      checkButtons();
   }


   // This function will enable or disable buttons based on the status of the selected contract
   function checkButtons()
   {
      var checked = parent.getChecked();
      if (checked.length == 1)
      {
         var parms = checked[0].split(',');
         var contractState = parms[1];

         var contractStoreId = parms[2];
         if(contractStoreId == "null")
         {
            contractStoreId =null;
         }

         /*d79167*/
         // If the contract is not in lock state, the Unlock
         // button should be disabled.
         var contractId = parms[0];
         if (getContractLockStatus(contractId)==false)
         {
            disableButton(parent.buttons.buttonForm.unlockButton);
         }


         if (contractState == "<%= ECContractConstants.EC_STATE_DRAFT.toString() %>")
         {
            if (<%=ContractCmdUtil.isReferralContract(usage)%> || <%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               //state is in inactive for distributor(not used), closed for reseller if store exists, otherwise this state does not exist
               //alert("Store Inactive or Closed");
               //Distributor buttons
               //disableButton(parent.buttons.buttonForm.activateButton);
               disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               //Reseller buttons
               //disableButton(parent.buttons.buttonForm.openStoreButton);
               disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.resumeStoreButton);
               if(<%=ContractCmdUtil.isReferralContract(usage)%>)
               {
                  disableButton(parent.buttons.buttonForm.suspendStoreButton);
               }

               /*90288*/
               if (getContractLockStatus(contractId))
               {
                  // If the contract is locked, disaable submit & deploy buttons
                  disableButton(parent.buttons.buttonForm.submitButton);
                  disableButton(parent.buttons.buttonForm.deployButton);
               }
            }
            else
            {
            // state is Draft
               disableButton(parent.buttons.buttonForm.versionButton);
               //disableButton(parent.buttons.buttonForm.approveButton);
               //disableButton(parent.buttons.buttonForm.rejectButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
               //for 2261
               disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
               disableButton(parent.buttons.buttonForm.activateButton);
               disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.resumeButton);
               disableButton(parent.buttons.buttonForm.suspendButton);
               disableButton(parent.buttons.buttonForm.openStoreButton);
               disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.reportsButton);
               disableButton(parent.buttons.buttonForm.cancelButton);

               /*90288*/
               if (getContractLockStatus(contractId))
               {
                  // If the contract is locked, disaable submit & deploy buttons
                  disableButton(parent.buttons.buttonForm.submitButton);
                  disableButton(parent.buttons.buttonForm.deployButton);
               }
            }//end of organisation states
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_PENDING.toString() %>")
         {
            if (<%=ContractCmdUtil.isReferralContract(usage)%> || <%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               //alert("Store in Active or Open");
               //state is in active for distributor, open for reseller if store exists, otherwise this state does not exist
               //distributor buttons
               disableButton(parent.buttons.buttonForm.activateButton);
               //disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               //reseller buttons
               disableButton(parent.buttons.buttonForm.openStoreButton);
               //disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.resumeStoreButton);
               //disableButton(parent.buttons.buttonForm.suspendStoreButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }
            else
            {
            // state is Submitted
               disableButton(parent.buttons.buttonForm.versionButton);
               disableButton(parent.buttons.buttonForm.changeButton);
               disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
               disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
               disableButton(parent.buttons.buttonForm.submitButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               disableButton(parent.buttons.buttonForm.activateButton);
               disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.resumeButton);
               disableButton(parent.buttons.buttonForm.suspendButton);
               disableButton(parent.buttons.buttonForm.openStoreButton);
               disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.reportsButton);
               disableButton(parent.buttons.buttonForm.deleteButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }//end of organisation states
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_APPROVED.toString() %>")
         {
            // state is Approved
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
            disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
            disableButton(parent.buttons.buttonForm.filterCatalogButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.reportsButton);
            disableButton(parent.buttons.buttonForm.changeCategoryButton);
            /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            if (!<%=ContractCmdUtil.isReferralContract(usage)%> && !<%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               disableButton(parent.buttons.buttonForm.deleteButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }
            /*90288*/
            if (getContractLockStatus(contractId))
            {
               // If the contract is locked, disaable submit & deploy buttons
               disableButton(parent.buttons.buttonForm.submitButton);
               disableButton(parent.buttons.buttonForm.deployButton);
            }
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_REJECTED.toString() %>")
         {
            // state is Rejected
            disableButton(parent.buttons.buttonForm.versionButton);
            disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
            disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
            disableButton(parent.buttons.buttonForm.filterCatalogButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.deployButton);
            disableButton(parent.buttons.buttonForm.deployToStoreButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.reportsButton);
            disableButton(parent.buttons.buttonForm.changeCategoryButton);
            disableButton(parent.buttons.buttonForm.deleteButton);
            /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_ACTIVE.toString() %>")
         {
            // state is Activated
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.deployButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            if (!<%=ContractCmdUtil.isReferralContract(usage)%> && !<%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               // BRM need to cancel contract first
               disableButton(parent.buttons.buttonForm.deleteButton);
            }
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_SUSPENDED.toString() %>")
         {
            // state is Inactive or Suspended
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.deployButton);
            disableButton(parent.buttons.buttonForm.deployToStoreButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.changeCategoryButton);
            if (!<%=ContractCmdUtil.isReferralContract(usage)%> && !<%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               disableButton(parent.buttons.buttonForm.deleteButton);
            }
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_CLOSED.toString() %>")
         {
            // state is Closed
            disableButton(parent.buttons.buttonForm.versionButton);
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
            disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
            disableButton(parent.buttons.buttonForm.filterCatalogButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.deployButton);
            disableButton(parent.buttons.buttonForm.deployToStoreButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            //disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.cancelButton);
            /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_CANCELED.toString() %>")
         {
            // state is Cancelled
            disableButton(parent.buttons.buttonForm.versionButton);
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
            disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
            disableButton(parent.buttons.buttonForm.filterCatalogButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.deployButton);
            disableButton(parent.buttons.buttonForm.deployToStoreButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.cancelButton);
            disableButton(parent.buttons.buttonForm.changeCategoryButton);
            /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_DEPLOY_IN_PROGRESS.toString() %>")
         {
            if ((<%=ContractCmdUtil.isReferralContract(usage)%> || <%=ContractCmdUtil.isHostingContract(usage)%>) && contractStoreId !=null)
            {
               //state is in inactive for distributor, suspended for reseller if store exists, otherwise this in deploying state
               //alert("Store Inactive or Suspended StoreID: " + contractStoreId);
               //distributor buttons
               //disableButton(parent.buttons.buttonForm.activateButton);
               disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               //reseller buttons
               //disableButton(parent.buttons.buttonForm.resumeStoreButton);
               disableButton(parent.buttons.buttonForm.suspendStoreButton);
               disableButton(parent.buttons.buttonForm.openStoreButton);
               disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.changeCategoryButton);
               disableButton(parent.buttons.buttonForm.filterCatalogButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }
            else
            {
               // state is DeploymentInProgress
               disableButton(parent.buttons.buttonForm.versionButton);
               disableButton(parent.buttons.buttonForm.changeButton);
               disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
               disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
               disableButton(parent.buttons.buttonForm.submitButton);
               //disableButton(parent.buttons.buttonForm.approveButton);
               //disableButton(parent.buttons.buttonForm.rejectButton);
               disableButton(parent.buttons.buttonForm.deployButton);
               disableButton(parent.buttons.buttonForm.deployToStoreButton);
               disableButton(parent.buttons.buttonForm.activateButton);
               disableButton(parent.buttons.buttonForm.deactivateButton);
               disableButton(parent.buttons.buttonForm.resumeButton);
               disableButton(parent.buttons.buttonForm.suspendButton);
               disableButton(parent.buttons.buttonForm.openStoreButton);
               disableButton(parent.buttons.buttonForm.closeStoreButton);
               disableButton(parent.buttons.buttonForm.exportButton);
               disableButton(parent.buttons.buttonForm.cancelButton);
               disableButton(parent.buttons.buttonForm.reportsButton);
               disableButton(parent.buttons.buttonForm.deleteButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }
         }
         else if (contractState == "<%= ECContractConstants.EC_STATE_DEPLOY_FAILED.toString() %>")
         {
            // state is Deployment Failed
            //this is the same for Reseller/Distributors
            disableButton(parent.buttons.buttonForm.versionButton);
            disableButton(parent.buttons.buttonForm.changeButton);
            disableButton(parent.buttons.buttonForm.updateCatalogFilterButton);
            disableButton(parent.buttons.buttonForm.updateExtendedTermConditionButton);
            disableButton(parent.buttons.buttonForm.filterCatalogButton);
            disableButton(parent.buttons.buttonForm.submitButton);
            //disableButton(parent.buttons.buttonForm.approveButton);
            //disableButton(parent.buttons.buttonForm.rejectButton);
            disableButton(parent.buttons.buttonForm.activateButton);
            disableButton(parent.buttons.buttonForm.deactivateButton);
            disableButton(parent.buttons.buttonForm.resumeButton);
            disableButton(parent.buttons.buttonForm.suspendButton);
            disableButton(parent.buttons.buttonForm.resumeStoreButton);
            disableButton(parent.buttons.buttonForm.suspendStoreButton);
            disableButton(parent.buttons.buttonForm.openStoreButton);
            disableButton(parent.buttons.buttonForm.closeStoreButton);
            disableButton(parent.buttons.buttonForm.reportsButton);
            disableButton(parent.buttons.buttonForm.changeCategoryButton);
            disableButton(parent.buttons.buttonForm.exportButton);
            /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            if (!<%=ContractCmdUtil.isReferralContract(usage)%> && !<%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               disableButton(parent.buttons.buttonForm.deleteButton);
               /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);
            }
         }
      }
      else // Multiple contracts selected
      {
         var wrongState = false;
         // can only delete draft, cancelled, closed
         for (index = 0; index < checked.length; index++)
         {
            var parms = checked[index].split(',');
            var contractState = parms[1];
            var contractStoreId = parms[2];
            if(contractStoreId == "null")
            {
               contractStoreId =null;
            }

            if (<%=ContractCmdUtil.isReferralContract(usage)%> || <%=ContractCmdUtil.isHostingContract(usage)%>)
            {
               if (contractState == "<%= ECContractConstants.EC_STATE_DEPLOY_IN_PROGRESS.toString() %>" && contractStoreId ==null )
               {
                  wrongState = true;
                  break;
               }
               else
               {
                  wrongState = true;<%//set wrong state =true for now because at this point in time we do not support multiple deletes for reseller/distributor contracts%>
               }
            }
            else
            {
               if (!(contractState == "<%= ECContractConstants.EC_STATE_DRAFT.toString() %>" ||
                     contractState == "<%= ECContractConstants.EC_STATE_CLOSED.toString() %>" ||
                     contractState == "<%= ECContractConstants.EC_STATE_CANCELED.toString() %>"))
               {
                  wrongState = true;
                  break;
               }
            }

         }//end-for

         if (wrongState == true)
         {
            disableButton(parent.buttons.buttonForm.deleteButton);
         }

         /*d79167*/ disableButton(parent.buttons.buttonForm.unlockButton);

      }//end-else

   }//end-function-checkButtons


   function versionContract() {
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.versionButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var url = "/webapp/wcs/tools/servlet/ContractNewVersion?contractId=" + contractId;
         url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
         url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
         url+="&contractUsage=<%= usage.intValue()%>";
         url = constructRedirURL (url);
         url = constructURL (url);
         //alert (url);
         parent.location.replace(url);
      }
   }

   function submitContract()
   {
      /*d92108*/
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.submitButton) == false)
      {
         var parms = checked.split(',');
         var contractId = parms[0];
         checkLockForContract(contractId);
      }
   }


   /*d92108*/
   //--------------------------------------------------------------
   // This function dynamically creates an invisible iframe as the
   // channel to invoke backend services to check any lock currently
   // exist for the contract.
   //--------------------------------------------------------------
   function checkLockForContract(contractID)
   {
      //alert("checkLockForContract");
      var callbackID = "checkLockForContract";
      var lockHelperIFrame = document.createElement("IFRAME");
      lockHelperIFrame.id="ContractList_LockHelperIFrame";
      lockHelperIFrame.src="/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
      lockHelperIFrame.style.position = "absolute";
      lockHelperIFrame.style.visibility = "hidden";
      lockHelperIFrame.style.height="0";
      lockHelperIFrame.style.width="0";
      lockHelperIFrame.frameborder="0";
      lockHelperIFrame.MARGINHEIGHT="0";
      lockHelperIFrame.MARGINWIDTH="0";


      // Require to remove the existing ContractList_LockHelperIFrame iframe if it
      // is existed, and replace a new one. Otherwise, after the first time
      // of this function is being called, all the subsequence calls to
      // this function will not take effect invoking the URL in the iframe.
      var oldElem = document.getElementById("ContractList_LockHelperIFrame");
      if (oldElem)
      {
         //alert("oldElem is found");
         var removedNode = oldElem.parentNode.replaceChild(lockHelperIFrame, oldElem);
      }
      else
      {
         //alert("oldElem is not found");
         document.body.appendChild(lockHelperIFrame);
      }


      // Prepare the proper URL to invoke the helper
      var webAppPath = "/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
      var queryString = "?contractid=" + contractID
                        + "&tctype=0"
                        + "&service=4"
                        + "&callbackid=" + callbackID;

      document.all[lockHelperIFrame.id].src=webAppPath + queryString;
   }


   /*d92108*/
   //----------------------------------------------------------------
   // This is a callback function from the ContractTCLockHelperFrame
   //----------------------------------------------------------------
   function contractTCLockHelperFrameDone(callbackID, overallResultCode, resultCodes)
   {
      //alert("contractTCLockHelperFrameDone");
      if (resultCodes!=null)
      {
         if (resultCodes[1]==1)
         {
            // The contract is currently locked
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgContractIsLocked")) %>");
            refreshContract();
         }
         else
         {
            // The contract does not have any locks, free to proceed
            proceedToSubmitContract();
         }
      }
   }


   /*d92108*/
   function proceedToSubmitContract()
   {
      //alert ("proceedToSubmitContract");
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.submitButton) == false)
      {
         var parms = checked.split(',');
         var contractId = parms[0];
         var url = "";

         url = "/webapp/wcs/tools/servlet/ContractSubmit?contractId=" + contractId;
         url+="&storeId=<%= contractCommandContext.getStoreId() %>";
         url = constructRedirURL (url);
         url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
         url+="&contractUsage=<%= usage.intValue()%>";

         if ( !((<%=ContractCmdUtil.isReferralContract(usage)%>) &&
                (<%=ContractCmdUtil.isHostingContract(usage)%>) &&
               (<%=ContractCmdUtil.isDelegationGridContract(usage)%>))
            )
         {
            url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
         }
         
         //d148285  allow product set publish on contract submit and TC redeploy
         //uncomment the following one line code if you want to enable the feature "allow product set publish on contract submit and TC redeploy"         
		 // url+= "&isPublishProductSet=true";	
         url = constructURL (url);
         //alert(url);
         parent.location.replace(url);
      }
   }


   function deployContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.deployButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var url = "";
         url = "/webapp/wcs/tools/servlet/ContractDeploy?contractId=" + contractId;
         url+="&targetStoreId=<%= contractCommandContext.getStoreId() %>";
         url = constructRedirURL (url);
         url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";

         if ( !((<%=ContractCmdUtil.isReferralContract(usage)%>) &&
                (<%=ContractCmdUtil.isHostingContract(usage)%>)
               (<%=ContractCmdUtil.isDelegationGridContract(usage)%>))
            ) {
            url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
             }
         url = constructURL (url);
         //alert(url);
         parent.location.replace(url);
      }
   }

   function deployContractToStore(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.deployToStoreButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("deployBCT")) %>",
            "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractDeploy&contractId=" + contractId +
            "&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>&targetStoreId=<%= contractCommandContext.getStoreId() %>",
            true);
      }
   }
   function activateContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0) {

         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         //if in the store inactive state

         var url = "";
         if(<%=ContractCmdUtil.isReferralContract(usage)%>){
            if(isButtonDisabled(parent.buttons.buttonForm.activateButton) == false){
               url = "/webapp/wcs/tools/servlet/ContractResume?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               //url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
         else if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if(isButtonDisabled(parent.buttons.buttonForm.resumeStoreButton) == false ){
               url = "/webapp/wcs/tools/servlet/ContractResume?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
         else {
            if(isButtonDisabled(parent.buttons.buttonForm.resumeButton) == false){
               url = "/webapp/wcs/tools/servlet/ContractResume?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }

      }
   }

   function deactivateContract() {
      var checked = parent.getChecked().toString();
      if (checked.length > 0) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var url = "";

         if(<%=ContractCmdUtil.isReferralContract(usage)%>){
            if( isButtonDisabled(parent.buttons.buttonForm.deactivateButton) == false){
               url = "/webapp/wcs/tools/servlet/ContractSuspend?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
         else if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if( isButtonDisabled(parent.buttons.buttonForm.closeStoreButton) == false || isButtonDisabled(parent.buttons.buttonForm.openStoreButton) == false){
               url = "/webapp/wcs/tools/servlet/ContractSuspend?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);
               //alert(url);
               parent.location.replace(url);
            }
         }
         else {
            if( isButtonDisabled(parent.buttons.buttonForm.suspendButton) == false){
               url = "/webapp/wcs/tools/servlet/ContractSuspend?contractId=" + contractId;
               url = constructRedirURL (url);
               url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
      }
   }

   function cancelContract(checked, deleteId){
      var checked = parent.getChecked().toString();

      if(checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.cancelButton) == false){
         var parms = checked.split(',');
         var contractId = parms[0];
         var url = "/webapp/wcs/tools/servlet/ContractCancel?contractId=" + contractId;
         url = constructRedirURL (url);
         url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
         url+="&contractUsage=<%= usage.intValue()%>";
         url+="&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>";
         url = constructURL (url);
         //alert(url);
         parent.location.replace(url);
      }//end of checked if
   }


   function findContract() {
      if (getSearchMode() == "1" ) {
         top.goBack();
      } else
         if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if(<%=reportMode.intValue()%> == 1){
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerReportTitle"))%>",
                  "/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.ResellerReportSearchDialog&contractUsage=<%= usage.intValue()%>&hostingMode=" + getHostingMode(),
                  false);
            }
         else {
            //Pass in current location, tile and search parameters for cancel button in search dialog
            top.mccbanner.trail[1].prevSearchLocation = constructURL (top.mccbanner.trail[top.mccbanner.counter].location);
            top.mccbanner.trail[1].prevSearchTitle = getListTitle();
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerTitle"))%>",
               "/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.ResellerSearchDialog&contractUsage=<%= usage.intValue()%>&hostingMode=" + getHostingMode(),
               true);
         }
      }
      else if(<%=ContractCmdUtil.isReferralContract(usage)%>){
         //Pass in current location, tile and search parameters for cancel button in search dialog
         top.mccbanner.trail[1].prevSearchLocation = constructURL (top.mccbanner.trail[top.mccbanner.counter].location);
         top.mccbanner.trail[1].prevSearchTitle = getListTitle();
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractSearchDistributorTitle"))%>",
            "/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.DistributorSearchDialog&contractUsage=<%= usage.intValue()%>",
            true);
      }
      else if(<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
         //Pass in current location, tile and search parameters for cancel button in search dialog
         top.mccbanner.trail[1].prevSearchLocation = constructURL (top.mccbanner.trail[top.mccbanner.counter].location);
         top.mccbanner.trail[1].prevSearchTitle = getListTitle();
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractSearchDelegationGridTitle"))%>",
            "/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.DelegationGridSearchDialog&contractUsage=<%= usage.intValue()%>",
            true);
      }
      else {
         //Pass in current location, tile and search parameters for cancel button in search dialog
         top.mccbanner.trail[1].prevSearchLocation = constructURL (top.mccbanner.trail[top.mccbanner.counter].location);
         top.mccbanner.trail[1].prevSearchTitle = getListTitle();
         top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("contractSearchTitle"))%>",
            "/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.ContractSearchDialog&contractUsage=<%= usage.intValue()%>&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>",
            true);
      }
   }

   function reportContract(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.reportsButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         if(contractStoreId == "null" || contractStoreId == null){
            contractStoreId =-1;
         }

         if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if (getHostingMode() == "0") {
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
                  "/webapp/wcs/tools/servlet/ResellerReportsHomeView?HostedStoreId=" + contractStoreId,
                  "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
                  true);
            }
            else {
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
                  "/webapp/wcs/tools/servlet/StoreLevelReportsHomeView?HostedStoreId=" + contractStoreId,
               "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
               true);
            }
         }
         else if(<%=ContractCmdUtil.isReferralContract(usage)%>){
            //there are currently no distributor/referral reports available.  This may be implemented in the future.
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
               "/webapp/wcs/tools/servlet/ResellerReportsHomeView?HostedStoreId=" + contractStoreId,
               "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
               true);
         }
         else {
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
               "/webapp/wcs/tools/servlet/ShowContextList?context=contract&contextConfigXML=contract.brmReportContext&ActionXMLFile=contract.rptContractContextList" +
               "&contractId=" + contractId +"&contractUsage=<%= usage.intValue()%>&accountId=<%=  UIUtil.toJavaScript(accountIdParm) %>",
               true);
         }
      }
   }

   function changeCategory(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0 && isButtonDisabled(parent.buttons.buttonForm.changeCategoryButton) == false) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];

         if(contractStoreId == "null" || contractStoreId == null){
            contractStoreId =-1;
         }

         if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if (getHostingMode() == "1") {
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("changeCategoryTitle"))%>",
                  "/webapp/wcs/tools/servlet/DialogView?XMLFile=store.StoreCategoryUpdate&targetStoreId=" + contractStoreId +
                  "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
                  true);
            }
         }
         else {
               // Do nothing.  Only for Reseller type in Hosting.
         }
      }
   }

   function reportContractById(checked, contractStoreId) {
      if (checked.length > 0) {
         var parms = checked.split(',');
         var contractId = parms[0];

         if(contractStoreId == "null" || contractStoreId == null){
            contractStoreId =-1;
         }

         if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if (getHostingMode() == "0") {
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
                  "/webapp/wcs/tools/servlet/ResellerReportsHomeView?ResellerStoreId=" + contractStoreId,
                  "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
                  true);
            }
            else {
               top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
                  "/webapp/wcs/tools/servlet/StoreLevelReportsHomeView?HostedStoreId=" + contractStoreId,
                  "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
                  true);
            }
         }
         else if(<%=ContractCmdUtil.isReferralContract(usage)%>){
            top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("reports"))%>",
               "/webapp/wcs/tools/servlet/ShowContextList?context=contract&contextConfigXML=contract.brmReportContext&ActionXMLFile=contract.rptContractContextList" +
               "&contractId=" + contractId + "&contractUsage=<%= usage.intValue()%>",
               true);
         }
         else {
               //If not Reseller or Distributor this function should not be available
         }
      }
   }

   //Reseller Store Functions
   function openStore(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0) {
         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         //alert("In Open Store.  parms: " + parms );
         //if in the store inactive state

         var url = "";
         if(<%=ContractCmdUtil.isReferralContract(usage)%>){
            //no open store in distributor, should not be using this method
         }
         else if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if(isButtonDisabled(parent.buttons.buttonForm.openStoreButton) == false || isButtonDisabled(parent.buttons.buttonForm.resumeStoreButton) == false ){
               url = "/webapp/wcs/tools/servlet/StoreOpen?targetStoreId=" + contractStoreId;
               if (getSearchMode() == "1" ) {
                  url+="&URL=NewDynamicListView&ActionXMLFile=contract.ResellerSearchResultsList&cmd=ContractListView";
               } else {
                  url+="&URL=NewDynamicListView&ActionXMLFile=contract.ResellerList&cmd=ContractListView";
               }
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
         else {
            //should not be using this method
         }
      }
   }

   //Reseller Store Functions
   function closeStore(){
      var checked = parent.getChecked().toString();
      if (checked.length > 0) {

         var parms = checked.split(',');
         var contractId = parms[0];
         var contractStoreId = parms[2];
         //if in the store inactive state

         var url = "";
         if(<%=ContractCmdUtil.isReferralContract(usage)%> && isButtonDisabled(parent.buttons.buttonForm.activateButton) == false){
               //should not be using this method
         }
         else if(<%=ContractCmdUtil.isHostingContract(usage)%>){
            if(isButtonDisabled(parent.buttons.buttonForm.closeStoreButton) == false || isButtonDisabled(parent.buttons.buttonForm.resumeStoreButton) == false ){
               url = "/webapp/wcs/tools/servlet/StoreClose?targetStoreId=" + contractStoreId;
               if (getSearchMode() == "1" ) {
                  url+="&URL=NewDynamicListView&ActionXMLFile=contract.ResellerSearchResultsList&cmd=ContractListView";
               } else {
                  url+="&URL=NewDynamicListView&ActionXMLFile=contract.ResellerList&cmd=ContractListView";
               }
               url+="&state=<%=  UIUtil.toJavaScript(stateParm) %>";
               url+="&contractUsage=<%= usage.intValue()%>";
               url = constructURL (url);

               //alert(url);
               parent.location.replace(url);
            }
         }
         else {
            //should not be using this method
         }
      }
   }

   function popupStoreHomepage(link) {
      var store_url = "http://";
      store_url += self.location.hostname;
      store_url += link;
      promptDialog('<%= UIUtil.toJavaScript((String)contractsRB.get("confirmationInstruction2")) %>', store_url, store_url.length);
      /*
      popupWindow = window.open(store_url,
         'storeHomepage',
         'toolbar=yes,menubar=yes,location=yes,scrollbars=yes,resize=yes,status=yes',
         false);
      popupWindow.focus();
      */
   }

   if ((<%=ContractCmdUtil.isHostingContract(usage)%> && getHostingMode() == "0" && <%=reportMode.intValue()%> != 1) 
         || <%= storecat.isEmpty() %> ) {
      parent.hideButton("changeCategory");
   }


</script>

   </head>

   <body class="content_list">

      <script type="text/javascript">
   <!--
      // For IE
      if (document.all) {
         onLoad();
      }
      //-->

   //Reset previous search location so Reseller Report will go back to HOME.
   top.mccbanner.trail[1].prevSearchLocation = "";
   top.mccbanner.trail[1].prevSearchTitle = "";

   //DISPLAY SEARCH CRITERIA
   if (getSearchMode() == "1" ) {

   var displayState="";
   numOfCriteria=0;

   if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "AllList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("AllList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DraftList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("DraftList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "SubmittedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("SubmittedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ApprovedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("ApprovedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "RejectedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("RejectedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployingList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("DeployingList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployFailList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("DeployFailList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ActivatedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("ActivatedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ClosedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("ClosedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "OpenedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("OpenedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "SuspendedList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("SuspendedList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "CancelledList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("CancelledList"))%>";
   else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "InactiveList")
      displayState="<%=UIUtil.toJavaScript(contractsRB.get("InactiveList"))%>";

   document.write ("<b><%=UIUtil.toJavaScript(contractsRB.get("contractListSearchCriteriaHeader"))%></b>&nbsp;");


   //Display distributor search criteria
   if(<%=ContractCmdUtil.isReferralContract(usage)%>) {
      if (getcontractSearchName() != null && getcontractSearchName().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchDistributorName"))%>: <i>" + getcontractSearchName() + "</i><br /></dd>");
         numOfCriteria++;
      }
      if (getcontractSearchShortDesc() != null && getcontractSearchShortDesc().length > 0) {
            document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchDistributorShortDesc"))%>: <i>" + getcontractSearchShortDesc() + "</i><br /></dd>");
            numOfCriteria++;
         }
      document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchDistributorStatus"))%>: <i>" + displayState +"</i><br /></dd>");
   }
   //Display hosted reseller search criteria
   else if (<%=ContractCmdUtil.isHostingContract(usage)%>){
      if (getcontractSearchName() != null && getcontractSearchName().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerName"))%>: <i>" + getcontractSearchName() + "</i><br /></dd>");
         numOfCriteria++;
      }
      if (getcontractSearchShortDesc() != null && getcontractSearchShortDesc().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerShortDesc"))%>: <i>" + getcontractSearchShortDesc() + "</i><br /></dd>");
         numOfCriteria++;
      }
      if (getcontractSearchStoreName() != null && getcontractSearchStoreName().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerStoreName"))%>: <i>" + getcontractSearchStoreName() + "</i><br /></dd>");
         numOfCriteria++;
      }
      document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchResellerStoreState"))%>: <i>" + displayState +"</i><br /></dd>");
   }
   //Display delegation grid search criteria
   else if (<%=ContractCmdUtil.isDelegationGridContract(usage)%>){
      if (getcontractSearchName() != null && getcontractSearchName().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchName"))%>: <i>" + getcontractSearchName() + "</i><br /></dd>");
         numOfCriteria++;
      }
      if (getcontractSearchShortDesc() != null && getcontractSearchShortDesc().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchShortDesc"))%>: <i>" + getcontractSearchShortDesc() + "</i><br /></dd>");
         numOfCriteria++;
      }
      document.write ("<dd><%=contractsRB.get("contractSearchStatus")%>: <i>" + displayState +"</i><br /></dd>");
   }
   //Display search criteria
   else {
      if (getcontractSearchName() != null && getcontractSearchName().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchName"))%>: <i>" + getcontractSearchName() + "</i><br /></dd>");
         numOfCriteria++;
      }
      if (getcontractSearchShortDesc() != null && getcontractSearchShortDesc().length > 0) {
         document.write ("<dd><%=UIUtil.toJavaScript(contractsRB.get("contractSearchShortDesc"))%>: <i>" + getcontractSearchShortDesc() + "</i><br /></dd>");
         numOfCriteria++;
      }
      document.write ("<dd><%=contractsRB.get("contractSearchStatus")%>: <i>" + displayState +"</i><br /></dd>");
   }

   //dynamically align list and button depending on how many criteria
   if (numOfCriteria == 0)
      parent.setButtonPos('0px','52px');
   else if (numOfCriteria == 1)
      parent.setButtonPos('0px','67px');
   else if (numOfCriteria == 2)
      parent.setButtonPos('0px','83px');
   else if (numOfCriteria == 3)
      parent.setButtonPos('0px','99px');

}
parent.set_t_item_page(<%=totalNumberOfContracts%>, <%=listSize%>);

</script>
      <form action="" name="ContractListFORM" id="ContractListFORM">
         <%=comm.startDlistTable((String)contractsRB.get("contractListSummary"))%>
         <%=comm.startDlistRowHeading()%>
         <%=comm.addDlistCheckHeading(false, "selectAllButtons()")%>

         <%if(ContractCmdUtil.isHostingContract(usage)){
            // if the contract is a Reseller or Hosted Store Contract
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListStoreNameColumn"), ContractListDataBean.ORDER_BY_STORE_NAME, orderByParm.equals(ContractListDataBean.ORDER_BY_STORE_NAME))   );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("resellerListNameColumn"),ContractListDataBean.ORDER_BY_NAME,orderByParm.equals(ContractListDataBean.ORDER_BY_NAME) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("resellerListStateColumn"),ContractListDataBean.ORDER_BY_STORE_STATE,orderByParm.equals(ContractListDataBean.ORDER_BY_STORE_STATE),null,false ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListVersionColumn"),ContractListDataBean.ORDER_BY_VERSION,orderByParm.equals(ContractListDataBean.ORDER_BY_VERSION) ) );

         } else if(ContractCmdUtil.isReferralContract(usage)){
            // if the contract is a Referral or Distributor Contract
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("resellerListNameColumn"),ContractListDataBean.ORDER_BY_NAME,orderByParm.equals(ContractListDataBean.ORDER_BY_NAME) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListTitleColumn"),ContractListDataBean.ORDER_BY_DESCRIPTION,orderByParm.equals(ContractListDataBean.ORDER_BY_DESCRIPTION) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListStateColumn"),ContractListDataBean.ORDER_BY_STATE,orderByParm.equals(ContractListDataBean.ORDER_BY_STATE),null,false ) );

         } else if(ContractCmdUtil.isDelegationGridContract(usage)){
             // if the contract is a Delegation Grid Contract
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListNameColumn"),ContractListDataBean.ORDER_BY_NAME,orderByParm.equals(ContractListDataBean.ORDER_BY_NAME) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListTitleColumn"),ContractListDataBean.ORDER_BY_DESCRIPTION,orderByParm.equals(ContractListDataBean.ORDER_BY_DESCRIPTION) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListStateColumn"),ContractListDataBean.ORDER_BY_STATE,orderByParm.equals(ContractListDataBean.ORDER_BY_STATE),null,false ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListVersionColumn"),ContractListDataBean.ORDER_BY_VERSION,orderByParm.equals(ContractListDataBean.ORDER_BY_VERSION) ) );

         } else {
            // if the contract is a BRM Contract
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListNameColumn"),ContractListDataBean.ORDER_BY_NAME,orderByParm.equals(ContractListDataBean.ORDER_BY_NAME) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListTitleColumn"),ContractListDataBean.ORDER_BY_DESCRIPTION,orderByParm.equals(ContractListDataBean.ORDER_BY_DESCRIPTION) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListStartColumn"),ContractListDataBean.ORDER_BY_START_DATE,orderByParm.equals(ContractListDataBean.ORDER_BY_START_DATE) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListEndColumn"),ContractListDataBean.ORDER_BY_END_DATE,orderByParm.equals(ContractListDataBean.ORDER_BY_END_DATE) ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListStateColumn"),ContractListDataBean.ORDER_BY_STATE,orderByParm.equals(ContractListDataBean.ORDER_BY_STATE),null,false ) );
            out.print(comm.addDlistColumnHeading((String)contractsRB.get("contractListVersionColumn"),ContractListDataBean.ORDER_BY_VERSION,orderByParm.equals(ContractListDataBean.ORDER_BY_VERSION) ) );
            /*d79167*/ out.print(comm.addDlistColumnHeading((String)contractsRB.get("CCL_LockedStatusColumnName"),"",false,null,false ) );
         }
         out.print(comm.endDlistRow());

         //make sure the endIndex is greater than the number of contracts
         if (endIndex > totalNumberOfContracts) {
            endIndex = totalNumberOfContracts;
         }

         int indexFrom = startIndex;
         for (int i = 0; i < numberOfContracts; i++)
         {
            ContractDataBean contract = contracts[i];
            // need id and state%>
            <%=comm.startDlistRow(rowselect)%>

            <% if (ContractCmdUtil.isHostingContract(usage))
               {
                  if( contract.getContractStoreStatus() == null)
                  {
                     out.print(comm.addDlistCheck( contract.getContractId() + ',' + contract.getContractState() + ',' + contract.getContractStoreId(), "parent.setChecked();checkButtons();"));
                  }
                  else
                  {
                     out.print(comm.addDlistCheck( contract.getContractId() + ',' + contract.getContractStoreStatus() + ',' + contract.getContractStoreId(), "parent.setChecked();checkButtons();" ));
                  }

                  String [] storeentIndentifier = contract.getStoreentIndentifiersFromContract();

                  if ((storeentIndentifier != null) && (storeentIndentifier.length > 0))
                  {
                     //Assume that the first element is store name for PCD
                     if (contract.getContractStoreURL() != null)
                     {
                        out.print(comm.addDlistColumn( storeentIndentifier[0], "javascript:popupStoreHomepage('"+contract.getContractStoreURL()+"')" ));
                     }
                     else
                     {
                        out.print(comm.addDlistColumn( storeentIndentifier[0] ,"none" ));
                     }
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( "&nbsp;" ,"none" ));
                  }

                  if(reportMode.intValue() == 1)
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "javascript: reportContractById('"+ contract.getContractId() + "','"+ contract.getContractStoreId() + "'  )" ));
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "javascript: viewContractById('"+ contract.getContractId() + "','"+ contract.getContractStoreId() + "'  )" ));
                  }

                  if( contract.getContractStoreStatus() == null || contract.getContractState().equals(ECContractConstants.EC_STATE_DEPLOY_FAILED.toString()) )
                  {
                     //Go here if a store does not exist or if the state is deployment failed

                     // *d73013*
                     // Check if the contract state is "3" (active) and also the current
                     // system timestamp has passed the contract's end date timestamp, we
                     // should replace the contract status as 'Expired'.
                     if ( "3".equals(contract.getContractState())
                            && (contract.getEndDate()!=null)
                            && (TimestampHelper.systemCurrentTimestamp().getTime() - contract.getEndDate().getTime() > 0) )
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("resellerStatusExpired") ,"none" ));
                     }
                     else
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("resellerStatus" + contract.getContractState()) ,"none" ));
                     }

                  }
                  else
                  {
                     out.print(comm.addDlistColumn( (String)contractsRB.get("resellerStoreStatus" + contract.getContractStoreStatus()) ,"none" ));
                  }

                  out.print(comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(contract.getCreateDate(), fLocale) ,"none" ));

               }//end-if-ContractCmdUtil.isHostingContract(usage)

               else if (ContractCmdUtil.isReferralContract(usage))
               {
                  if( contract.getContractStoreStatus() == null)
                  {
                     out.print(comm.addDlistCheck( contract.getContractId() + ',' + contract.getContractState() + ',' + contract.getContractStoreId(), "parent.setChecked();checkButtons();"));
                  }
                  else
                  {
                     out.print(comm.addDlistCheck( contract.getContractId() + ',' + contract.getContractStoreStatus() + ',' + contract.getContractStoreId(), "parent.setChecked();checkButtons();" ));
                  }

                  if(reportMode.intValue() == 1)
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "javascript: reportContractById('"+ contract.getContractId() + "','"+ contract.getContractStoreId() + "'  )" ));
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "javascript: viewContractById('"+ contract.getContractId() + "','"+ contract.getContractStoreId() + "'  )" ));
                  }

                  out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractTitle()), "none" ));

                  if( contract.getContractStoreStatus() == null || contract.getContractState().equals(ECContractConstants.EC_STATE_DEPLOY_FAILED.toString()) )
                  {
                     //Go here if a store does not exist or if the state is deployment failed


                     // *d73013*
                     // Check if the contract state is "3" (active) and also the current
                     // system timestamp has passed the contract's end date timestamp, we
                     // should replace the contract status as 'Expired'.
                     if ( "3".equals(contract.getContractState())
                            && (contract.getEndDate()!=null)
                            && (TimestampHelper.systemCurrentTimestamp().getTime() - contract.getEndDate().getTime() > 0) )
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("distributorStatusExpired") ,"none" ));
                     }
                     else
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("distributorStatus" + contract.getContractState()) ,"none" ));
                     }
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( (String)contractsRB.get("distributorStoreStatus" + contract.getContractStoreStatus()) ,"none" ));
                  }

               }//end-if-ContractCmdUtil.isReferralContract(usage)

               else
               {
                  out.print(comm.addDlistCheck( contract.getContractId() + ',' + contract.getContractState() + ',' + contract.getContractStoreId(), "parent.setChecked();checkButtons();"));

                  if ((contract.getContractState().equals(ECContractConstants.EC_STATE_DRAFT.toString()) ||
                     contract.getContractState().equals(ECContractConstants.EC_STATE_REJECTED.toString()) ))
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "javascript: changeContractById('"+ contract.getContractId() + "')" ));
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractName()), "none" ));
                  }

                  out.print(comm.addDlistColumn( UIUtil.toHTML(contract.getContractTitle()), "none" ));

                  if (ContractCmdUtil.isBuyerContract(usage))
                  {
                     if (contract.getStartDate() == null)
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("contractNoStartDate"), "none" ));
                     }
                     else
                     {
                        out.print(comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(contract.getStartDate(), fLocale), "none" ));
                     }

                     if (contract.getEndDate() == null)
                     {
                        out.print(comm.addDlistColumn( (String)contractsRB.get("contractNoExpiryDate"), "none" ));
                     }
                     else
                     {
                        out.print(comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(contract.getEndDate(), fLocale), "none" ));
                     }
                  }

		  String statusText = null;
                  // Check if the contract state is "3" (active) and also the current
                  // system timestamp has passed the contract's end date timestamp, we
                  // should replace the contract status as 'Expired'.
                  if ( "3".equals(contract.getContractState())
                         && (contract.getEndDate()!=null)
                         && (TimestampHelper.systemCurrentTimestamp().getTime() - contract.getEndDate().getTime() > 0) )
                  {
                     statusText = (String)contractsRB.get("contractStatusExpired");
                  }
                  else
                  {
                     statusText = (String)contractsRB.get("contractStatus" + contract.getContractState());
                  }
                  if ("3".equals(contract.getContractState()) && contract.isDeployedToStore(fStoreId) == false) {
                  	statusText += " ";
                  	statusText += (String)contractsRB.get("contractNotInThisStore");
                  }
                  out.print(comm.addDlistColumn( statusText ,"none" ));

                  out.print(comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(contract.getCreateDate(), fLocale) ,"none" ));

               }//end-else-if


            if (ContractCmdUtil.isBuyerContract(usage))
            {
               try
               {
                  //-------------------------------------------------------------
                  // The following code segment performs the job of retrieving
                  // all the lock details for a given contract ID. It also
                  // generates javascript codes to store up the lock information
                  // in the browser runtime model.
                  //-------------------------------------------------------------

                  // Prepare the lock record keys. Each key is a combination of
                  // a contract id and the terms and conditions type in hashcode integer.
                  Long lockKeyForPriceTC[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_PRICE_TC.hashCode()) };

                  Long lockKeyForShippingTC[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_SHIPPING_TC.hashCode()) };

                  Long lockKeyForPaymentTC[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_PAYMENT_TC.hashCode()) };

                  Long lockKeyForReturnTC[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_RETURN_TC.hashCode()) };

                  Long lockKeyForOrderApprovalTC[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_ORDERAPPROVAL_TC.hashCode()) };

                  Long lockKeyForGeneralPages[]
                     = { new Long(contract.getContractId()), new Long(ECContractConstants.EC_ELE_CONTRACT.hashCode()) };

                  //===============================================================
                  // *DEVELOPER'S NOTE*
                  // To support a new TC type, please add a similar declaration
                  // statement here to define a lock key pair for the new TC.
                  //
                  // For example,
                  //
                  //    Long lockKeyForMyNewTC[]
                  //       = { new Long(contract.getContractId()),
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
                  int numOfKeys = 6;  // currently support 6 TCs


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
                  boolean contractHasLocks = false;

                  // Retrieve the locks details for the contract
                  LockData[] lockInfo = myRescManager.getLockData(myManagedRescKeys);
                  for (int k3=0; k3<lockInfo.length; k3++)
                  {
                     if (lockInfo[k3]!=null)
                     {
                        contractHasLocks = true;
                        String lockTimeStamp = (lockInfo[k3].getLockTimestamp()==null)? " " : TimestampHelper.getDateTimeFromTimestamp(lockInfo[k3].getLockTimestamp(), fLocale);
                        String memberIdStr   = (lockInfo[k3].getMemberId()==null)? "" : lockInfo[k3].getMemberId().toString();

                        // Retrieve the logon ID for the lock owner
                        UserDataBean dbUser = new UserDataBean();
                        dbUser.setDataBeanKeyMemberId(memberIdStr);
                        dbUser.setCommandContext(contractCommandContext);
                        dbUser.populate();

                        // Use javascript to capture the lock details data for each contract
                        %>
                        <script type="text/javascript">setContractLockDetails("<%= contract.getContractId() %>", "<%= k3 %>", "<%= UIUtil.toJavaScript(dbUser.getLogonId()) %>", "<%= UIUtil.toJavaScript(lockTimeStamp) %>");</script>
                        <%
                     }
                  }//end-for-k3

                  // Set the lock status to the visual dynamic list
                  if (contractHasLocks)
                  {
                     out.print(comm.addDlistColumn( (String)contractsRB.get("CCL_LockStatus_Yes"), ""));
                  }
                  else
                  {
                     out.print(comm.addDlistColumn( (String)contractsRB.get("CCL_LockStatus_No"), ""));
                  }

                  // Use javascript to capture the lock status data for each contract
                  %>
                  <script type="text/javascript">setContractLockStatus("<%= contract.getContractId() %>", "<%= contractHasLocks %>");</script>
                  <%

               }
               catch (Exception exp)
               {
                  ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/ContractList.jsp",
                       "service",
                       "Exception in processing locking information, exception=" + exp.toString());

                  exp.printStackTrace();
               }

            } //end-if-buyerContract



               out.print(comm.endDlistRow());
               if (rowselect == 1)
               {
                  rowselect = 2;
               }
               else
               {
                  rowselect = 1;
               }

         }// end of for



         %>

         <%= comm.endDlistTable() %>

         <%if (numberOfContracts == 0) { %>

            <br /><br />
             <%if(ContractCmdUtil.isReferralContract(usage)){%>
               <%= contractsRB.get("distributorListEmpty") %>
            <%}else if(ContractCmdUtil.isHostingContract(usage)){
               if(reportMode.intValue() == 1){%>
                  <%= contractsRB.get("resellerReportListEmpty") %>
            <% } else { %>
                  <%= contractsRB.get("resellerListEmpty") %>
            <% }
              }else if(ContractCmdUtil.isDelegationGridContract(usage)){ %>
              <%= contractsRB.get("delegationGridListEmpty") %>
            <%  }else {%>
               <%= contractsRB.get("contractListEmpty") %>
            <%}%>
         <%  }%>

   </form>

   <script type="text/javascript">
        <!--
        parent.afterLoads();

   // set the right option in the view drop down menu
   if (<%=ContractCmdUtil.isHostingContract(usage)%>){
      if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "AllList")
            parent.setoption(0);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployingList")
            parent.setoption(1);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployFailList")
            parent.setoption(2);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "OpenedList")
               parent.setoption(3);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ClosedList")
            parent.setoption(4);
         else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "SuspendedList")
            parent.setoption(5);
   }
   else if (<%=ContractCmdUtil.isReferralContract(usage)%>){
      if ("<%= UIUtil.toJavaScript(stateParm) %>" == "AllList")
            parent.setoption(0);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployingList")
            parent.setoption(1);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployFailList")
            parent.setoption(2);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ActivatedList")
               parent.setoption(3);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "InactiveList")
            parent.setoption(4);
   }
   else {
      if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "AllList")
            parent.setoption(0);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DraftList")
            parent.setoption(1);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "SubmittedList")
         parent.setoption(2);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ApprovedList")
            parent.setoption(3);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "RejectedList")
            parent.setoption(4);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployingList")
            parent.setoption(5);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "DeployFailList")
                  parent.setoption(6);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ActivatedList")
                  parent.setoption(7);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "InactiveList")
                  parent.setoption(8);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "ClosedList")
                  parent.setoption(9);
      else if ("<%=  UIUtil.toJavaScript(stateParm) %>" == "CancelledList")
                  parent.setoption(10);

   }
   parent.setResultssize(getResultsSize());

    <% if (errorMessage != null) { %>
      alertDialog('<%= UIUtil.toJavaScript(errorMessage) %>');
    <% } %>
      //-->

</script>

</body>

</html>


