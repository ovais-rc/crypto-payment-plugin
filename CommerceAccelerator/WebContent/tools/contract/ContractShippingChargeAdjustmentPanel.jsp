

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.*,
      com.ibm.commerce.beans.*,
      com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
      com.ibm.commerce.tools.contract.beans.PolicyDataBean,
      com.ibm.commerce.tools.contract.beans.MemberDataBean,
      com.ibm.commerce.tools.contract.beans.ContractDataBean,
      com.ibm.commerce.tools.contract.beans.ShippingTCShippingChargeAdjustmentFilterDataBean,
      com.ibm.commerce.tools.contract.beans.CatalogShippingAdjustmentDataBean,
      com.ibm.commerce.tools.contract.beans.ShippingChargeAdjustmentDataBean,
      com.ibm.commerce.order.objects.TradingPositionContainerAccessBean,
      com.ibm.commerce.contract.helper.ECContractConstants,
      com.ibm.commerce.command.CommandContext,
      com.ibm.commerce.tools.catalog.beans.*,
      com.ibm.commerce.common.beans.*,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.utils.TimestampHelper,
      com.ibm.commerce.tools.catalog.util.*,
      com.ibm.commerce.price.utils.*,
      com.ibm.commerce.catalog.objects.*,
      com.ibm.commerce.contract.util.*,
      com.ibm.commerce.contract.helper.ContractUtil,
      com.ibm.commerce.common.objects.StoreAccessBean,
      com.ibm.commerce.tools.util.*"
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

<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ShippingChargeAdjustmentFilter.js">
</script>



<script LANGUAGE="JavaScript">
///////////////////////////////////////
// Defining the JROM and JLOM model
///////////////////////////////////////

var debug=false; // global flag to turn on alerts.
// create global object for shipping charge adjustment filter
var sfm = new Object();
sfm.JROM = new Object();
sfm.JROM.nodes = new Array();
sfm.JLOM = new Array();

sfm.JROM.availablePolicies = new Array();
sfm.JROM.languageId = "<%= fLanguageId %>";

sfm.parentJROM = new Object();
sfm.parentJROM.nodes = new Array();

sfm.JROM.delegationGrid = false;
// check if this is the delegation grid notebook
var cgm = parent.get("ContractGeneralModel");
if (cgm != null && cgm.usage == "DelegationGrid") {
     sfm.JROM.delegationGrid = true;
}

<%
  // check whether it's an update or a new contract
  String tradingId = null;
  if (foundContractId || (editingAccount && foundAccountId) ) {
    // saved contract or saved account
    if (foundContractId) {
      tradingId = contractId;
    } else {
      tradingId = accountId;
    }
  }

  String delegationGrid = "false";
  try {
     delegationGrid = contractCommandContext.getRequestProperties().getString("delegationGrid");
  } catch (Exception e) {
  }

  ShippingTCShippingChargeAdjustmentFilterDataBean JROMdb = new ShippingTCShippingChargeAdjustmentFilterDataBean();
  if (tradingId != null) {
    JROMdb.setContractId(new Long(tradingId));
  }

  TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");

  String base_contract_id = requestProperties.getString("base_contract_id", null);

  JROMdb.setStoreId(fStoreId);

  DataBeanManager.activate(JROMdb, request);

  String storeName = fStoreIdentity;
  MemberDataBean mdb = new MemberDataBean();
  mdb.setId(fStoreMemberId);
  DataBeanManager.activate(mdb, request);
  try {
%>
    sfm.JROM.storeId = '<%= fStoreId %>';
    sfm.JROM.storeName = '<%= storeName %>';
    sfm.JROM.storeOwnerDn = '<%= mdb.getMemberDN() %>';
    sfm.JROM.contractId = '<%= JROMdb.getContractId() %>';
    sfm.JROM.catalogReferenceNumber = '<%= JROMdb.getCatalogReferenceNumber() %>';
    sfm.JROM.catalogIdentifier = '<%= UIUtil.toJavaScript(JROMdb.getCatalogIdentifier()) %>';

<%
    if (JROMdb.getCatalogOwner() != null) {
%>
      sfm.JROM.catalogOwner = new Member('<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberType()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberDN()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupName()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupOwnerMemberType()) %>',
                  '<%= UIUtil.toJavaScript(JROMdb.getCatalogOwner().getMemberGroupOwnerMemberDN()) %>')
<%
    }
    if (JROMdb.getContractOwner() != null) {
%>
      sfm.JROM.contractOwner = new Member('<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(JROMdb.getContractOwner().getMemberGroupOwnerMemberDN()) %>')
<%
    }
%>
    // setup default values
    sfm.JROM.contractLastUpdateTime = '<%= JROMdb.getContractLastUpdateTime() %>';

    // get Store default currency
<%
    StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
    // get the default currenty for a store
    CurrencyManager cm = CurrencyManager.getInstance();
    String defaultCurrency = cm.getDefaultCurrency(storeAB, contractCommandContext.getLanguageId());
%>
    sfm.JROM.storeDefaultCurrency = "<%= defaultCurrency %>";
    // Getting constants from the databean.

    // if there is no shared catalog, then this tool is effectively disabled
    // actually should target to order directly, which requires a different UI.
    sfm.JROM.hasSharedCatalog = <%= JROMdb.hasSharedCatalog() %>;

    sfm.JROM.FILTER_TYPE_CATALOG = '<%= CatalogShippingAdjustmentDataBean.FILTER_TYPE_CATALOG %>';
    sfm.JROM.FILTER_TYPE_CATEGORY = '<%= CatalogShippingAdjustmentDataBean.FILTER_TYPE_CATEGORY %>';
    sfm.JROM.FILTER_TYPE_CATENTRY = '<%= CatalogShippingAdjustmentDataBean.FILTER_TYPE_CATENTRY %>';
    sfm.JROM.FILTER_TYPES = new Array("Catalog", "Category", "Catentry");

    sfm.JROM.FILTER_TYPE_PREFIXES = new Array("CA", "CG", "CE");

    sfm.JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF = '<%= ShippingChargeAdjustmentDataBean.ADJUSTMENT_TYPE_PERCENTAGE_OFF %>';
    sfm.JROM.ADJUSTMENT_TYPE_AMOUNT_OFF = '<%= ShippingChargeAdjustmentDataBean.ADJUSTMENT_TYPE_AMOUNT_OFF %>';
    sfm.JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP = "up";
    sfm.JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN = "down";

    sfm.JROM.ACTION_TYPE_NOACTION = '<%= ShippingChargeAdjustmentDataBean.ACTION_TYPE_NOACTION %>';
    sfm.JROM.ACTION_TYPE_NEW = '<%= ShippingChargeAdjustmentDataBean.ACTION_TYPE_NEW %>';
    sfm.JROM.ACTION_TYPE_UPDATE = '<%= ShippingChargeAdjustmentDataBean.ACTION_TYPE_UPDATE %>';
    sfm.JROM.ACTION_TYPE_DELETE = '<%= ShippingChargeAdjustmentDataBean.ACTION_TYPE_DELETE %>';
    sfm.JROM.ACTION_TYPES = new Array("noaction", "new", "update", "delete");

    sfm.JROM.POLICY_ALL_SHIPMODES = '<%= ShippingChargeAdjustmentDataBean.POLICY_ALL_SHIPMODES %>';

    sfm.JROM.areButtonsDisabled = true; // default when the tree is first loaded...

    alertDebug("storeId="+sfm.JROM.storeId + " \n" +
               "storeName=" + sfm.JROM.storeName + " \n" +
               "storeOwnerDn=" + sfm.JROM.storeOwnerDn + " \n" +
               "contractId="+sfm.JROM.contractId + " \n" +
               "catalogRefenceNumber="+sfm.JROM.catalogReferenceNumber + " \n" +
               "catalogIdentifier="+sfm.JROM.catalogIdentifier + " \n" +
               "catalogOwner="+dumpObject(sfm.JROM.catalogOwner) + " \n" +
               "hasSharedCatalog="+sfm.JROM.hasSharedCatalog + " \n" +
               "contractOwner="+dumpObject(sfm.JROM.contractOwner) + " \n" +
               "contractLastUpdateTime="+sfm.JROM.contractLastUpdateTime + " \n" +
               "storeDefaultCurrency=" + sfm.JROM.storeDefaultCurrency);
<%  // find all the available shipmode business policies for the current store
    PolicyListDataBean pldb = new PolicyListDataBean();
    pldb.setOrderBy(PolicyListDataBean.ORDER_BY_NAME);
    pldb.setPolicyType(PolicyListDataBean.TYPE_SHIPPING_MODE);
    pldb.setStoreId(fStoreId);
    pldb.setFindBy(PolicyListDataBean.FIND_BY_TYPE_STORE_ENTITY);
    DataBeanManager.activate(pldb, request);

    PolicyDataBean[] availablePolicyList = pldb.getPolicyList();
    // availablePolicyList is used by each iframe table form.
    if (availablePolicyList != null) {
      for (int k=0; k<availablePolicyList.length; k++) {
%>
        sfm.JROM.availablePolicies['<%=availablePolicyList[k].getId()%>'] = new AvailablePolicy('<%=availablePolicyList[k].getId()%>',
                                                                                                '<%=UIUtil.toJavaScript(availablePolicyList[k].getPolicyName())%>',
                                                                                                '<%=UIUtil.toJavaScript(availablePolicyList[k].getShortDescription())%>');
<%
      }
    } else {
%>
      alertDebug("Found no shipmode available in current store!");
<%
    }

    // loop through the catalog shipping adjustment and setup the JROM nodes...
    for (int i=0; i<JROMdb.getCatalogShippingAdjustments().size(); i++) {
      CatalogShippingAdjustmentDataBean csadb = JROMdb.getCatalogShippingAdjustment(i);
%>
      var _adjustmentTCs = new Array();
      sfm.JROM.nodes['<%=csadb.getNodeReferenceNumber()%>'] = new JROMNode('<%=csadb.getNodeReferenceNumber()%>',
                           '<%=csadb.getFilterType()%>',
                           '<%=csadb.getReferenceNumber()%>',
                           _adjustmentTCs);
<%
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
            policyNAME = UIUtil.toJavaScript(scdb.getPolicyName());
          }
%>

          sfm.JROM.nodes['<%=csadb.getNodeReferenceNumber()%>'].adjustmentTCs['<%=policyID%>'] = new AdjustmentTC(
          '<%=policyID%>',
          '<%=policyNAME%>',
          '<%=scdb.getReferenceId()%>',
          <%=scdb.getTargetType()%>,
          <%=scdb.getAdjustmentType()%>,
          '<%=scdb.getAdjustmentValue()%>',
          '<%=scdb.getOwnerDn()%>',
          '<%=scdb.getCurrency()%>',
          '<%=scdb.getReferenceName()%>',
          '<%=scdb.getTermcondId()%>',
          <%=scdb.getActionType()%>);

          alertDebug('Adding JROM Node!\n'+dumpObject(sfm.JROM.nodes['<%=csadb.getNodeReferenceNumber()%>']));
<%
        }
      } else {
%>
          alertDebug('Found empty shipping charge adjustment for node: ' + '<%=csadb.getNodeReferenceNumber()%>');
<%
      }
    }
%>
<%
  } catch(Exception e) {
    com.ibm.commerce.ras.ECTrace.trace(com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT, "Catalog ShippingAdjustment Tree", "load", "Exception: " + e.toString());
%>
    alertDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("loadFiltersErrorMessage"))%>");
<%
  }
%>

alertDebug("display JROM\n" + displayJROM());
alertDebug("JROM Loaded!");
//alert("number to currency for 1.00000: \n" + parent.numberToCurrency('1.00000', sfm.JROM.storeDefaultCurrency, '<%=fLanguageId%>'));
// this method is used to format the value of adjustment based on the currency and language
function getFormattedAdjustment(adjustment, type) {
  if (type == sfm.JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
    return parent.numberToCurrency(adjustment, sfm.JROM.storeDefaultCurrency, '<%=fLanguageId%>');
  } else {
    return adjustment;
  }
}


// This function returns the JROM object
function getJROM(){
//alert('getJROM in ContractShippingChargeAdjustmentPanel.jsp');
   return sfm.JROM;
}

// This function returns the JROM array of nodes
function getJROMNodes(){
//alert('getJROMNodes in ContractShippingChargeAdjustmentPanel.jsp');
   return sfm.JROM.nodes;
}
// This function returns the array of available shipmode policies.
function getAvailableShipmodes() {
   return sfm.JROM.availablePolicies;
}

// This function returns the JLOM array of nodes
function getJLOM(){
//alert('getJLOM in ContractShippingChargeAdjustmentPanel.jsp');
   return sfm.JLOM;
}
// This function returns the NL text of the cancel message
function getCancelMessageNLText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("cancelMessage"))%>";
}

// This function returns the NL text of the message displayed when the user clicks on an excluded node.
function getNotExpandableNLText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("notExpandableMessage"))%>";
}

// This function returns the NL text of the generic error message
function getGenericErrorMessageText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("catalogFiltersNotSaved"))%>";
}

// This function returns the NL text of the concurrency error message
function getConcurrencyErrorMessageText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("concurrencyErrorMessage"))%>";
}

// This function returns the NL text of the error message when publishing is not complete
function getPublishNotCompleteErrorMessageText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("publishingInProgressMessage"))%>";
}

// This function returns the NL text of the "Cancel Settings" menu item
function getCancelSettingsMenuText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("cancelsettings"))%>";
}

// This function returns the NL text of the "Set Discount" menu item for shipping charge adjustment.
function getSetDiscountMenuText(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("setShippingChargeAdjustment"))%>";
}

// This function returns the NL text of the indicator message.
function getIndicatorMessage(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("indicatorMessage"))%>";
}
// This function returns the NL text of general loading message for each tree node.
function getLoadingMessage(){
//alert('getLoadingMessage in CatalogTree.jsp');
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("generalLoadingMessage"))%>";
}

// This function returns the NL text displayed when the user tries to display an unready IFRAME.
function getIFRAMEnotLoadedMessage(){
   return "<%=UIUtil.toJavaScript((String)contractsRB.get("iframeNotLoaded"))%>";
}

// This function returns the reseller store name.
function getStoreName(){
   return "<%=UIUtil.toJavaScript(storeName)%>";
}
// this function returns the quantity of the available shipmode policies in the current store.
function getShipmodePolicyQty() {
  var shipmodes = getAvailableShipmodes();
   var i = 0;
   for(policyId in shipmodes){
      i++;
   }
   return i;
}

function validatePanelData(){
//alert('validatePanelData in ContractShippingChargeAdjustmentPanel.jsp');
   //if(!tree.hasSettings()){
   //   if(!confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateNoSettingMessage"))%>")){
   //      return false;
   //   }
   //}

   return true;
}

function validateNoteBookPanel(){
//alert('validateNoteBookPanel in CatalogTree.jsp');
   //if(!tree.hasSettings()){
   //   if(!confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("validateNoSettingMessage"))%>")){
   //      return false;
   //   }
   //}
   return true;
}

function refreshCatalogFilterTitleDivision() {
//alert('refreshCatalogFilterTitleDivision in ContractShippingChargeAdjustmentPanel.jsp');
   titleFrame.refreshCatalogFilterTitleDivision();
}

function getContractNVP()
{
   var parms = "";
   if (<%= foundContractId %> == true) {
      parms += "&contractId=<%=contractId%>";
   } else if ((<%= editingAccount %> == true) && (<%= foundAccountId %> == true)) {
      parms += "&contractId=<%=accountId%>";
   }
   parms += "&delegationGrid=<%=delegationGrid%>";
   return parms;
}

function init(){
   alertDebug('init in ContractShippingChargeAdjustmentPanel.jsp');
   loadPanelData();
   document.getElementById("tree").src = "/webapp/wcs/tools/servlet/DynamicTreeView?XMLFile=contract.ShippingChargeAdjustmentTree" + getContractNVP();
}

function disableDialogButtons() {
//alert('disableDialogButtons in ContractShippingChargeAdjustmentPanel.jsp');
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].disabled = true;
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].disabled = true;
   //parent.NAVIGATION.document.getElementsByName("OKButton")[0].style.background = '#1C5890';
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].style.background = '#1C5890';

   sfm.JROM.areButtonsDisabled = true;
}

function enableDialogButtons() {
//alert('enableDialogButtons in ContractShippingChargeAdjustmentPanel.jsp');
   parent.NAVIGATION.document.getElementsByName("OKButton")[0].disabled = false;
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].disabled = false;
   //parent.NAVIGATION.document.getElementsByName("OKButton")[0].style.background = '#2A70B0';
   //parent.NAVIGATION.document.getElementsByName("CancelButton")[0].style.background = '#2A70B0';

   sfm.JROM.areButtonsDisabled = false;
}

function loadPanelData() {

    alertDebug ('Filter loadPanelData');

    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(false);
    }

    if (parent.get) {
      var hereBefore = parent.get("ContractShippingChargeAdjustmentModelLoaded", null);
      if (hereBefore != null) {
        alertDebug('Filter - back to same page - load from model');
      // have been to this page before - load from the model
        var o = parent.get("ContractShippingChargeAdjustmentModel", null);
        if (o != null) {
          // use the saved model, but update with

          // get the JLOM from the saved model and remove the deleted entries
          //var currentJLOM = o.JLOM;
          //var newJLOM = new Array();
          // rebuild a new JLOM and remove all the deleted TCs
          //for (JLOMID in currentJLOM){

          //   if (getAdjustmentTCsSize(currentJLOM[JLOMID].adjustmentTCs)>0) {
          //       newAdjustmentTCs = new Array();
          //       for(POLICYID in currentJLOM[JLOMID].adjustmentTCs) {
          //           if (currentJLOM[JLOMID].adjustmentTCs[POLICYID].actionType != sfm.JROM.ACTION_TYPE_DELETE) {
          //              newAdjustmentTCs[POLICYID] = new AdjustmentTC(currentJLOM[JLOMID].adjustmentTCs[POLICYID].policyId,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].policyName,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].refId,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].targetType,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].adjustmentType,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].adjustmentValue,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].ownerDn,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].currency,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].referenceName,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].termcondId,
          //                                                                         currentJLOM[JLOMID].adjustmentTCs[POLICYID].actionType);
          //           }
          //       }
                 // Check if the newLJOM[JLOMID] has the empty adjustments
                 // if empty, no need to create a node in the new JLOM array
          //       if (getAdjustmentTCsSize(newAdjustmentTCs)>0) {
          //         newJLOM[JLOMID] = new JLOMNode (currentJLOM[JLOMID].nodeId, currentJLOM[JLOMID].nodeType, currentJLOM[JLOMID].refId, newAdjustmentTCs);
          //       }
          //   }
          //}
          //o.JLOM = newJLOM;
          // set this page with the saved model
          sfm = o;
          refreshCatalogFilterTitleDivision();
        } // end if model is found
      } // end if here before
      else {
      // this is the first time on this page
        alertDebug('Filter - first time on page');

      // save the model
        parent.put("ContractShippingChargeAdjustmentModel", sfm);
        parent.put("ContractShippingChargeAdjustmentModelLoaded", true);
       } // end else first time to this page
       alertDebug(displayJLOM());


    } // end if parent.get



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
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("ShippingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Shipping")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      null,
                      2);

} // end function

function savePanelData()
{
  alertDebug('Filter savePanelData');
  if (parent.get) {
    var o = parent.get("ContractShippingChargeAdjustmentModel", null);
    if (o != null) {
      o = sfm;
      alertDebug('See JLOM: \n' + dumpObject(o.JLOM));
    }
  }
}




</script>
</head>

<frameset framespacing="0" border="0" frameborder="0" rows="20%, 80%" onload="init()">
   <frame name="titleFrame" id="titleFrame" src="/webapp/wcs/tools/servlet/ContractShippingChargeAdjustmentPanelTitleView?contractId=<%=UIUtil.toHTML(tradingId)%>&base_contract_id=<%=UIUtil.toHTML(base_contract_id)%>&accountEdit=<%=editingAccount%>&accountId=<%=UIUtil.toHTML(accountId)%>&delegationGrid=<%=UIUtil.toHTML(delegationGrid)%>" title="<%=UIUtil.toJavaScript((String)contractsRB.get("catalogTreeTitlePanel"))%>">
   <frame name="tree" id="tree" src="/wcs/tools/common/blank.html" name="tree" title="<%=UIUtil.toJavaScript((String)contractsRB.get("catalogTreePanel"))%>">
</frameset>

</html>


