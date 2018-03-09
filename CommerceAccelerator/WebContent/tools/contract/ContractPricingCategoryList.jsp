<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================
 -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.UserAdminDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.contract.util.ContractCmdUtil" %>
<%@ page import="com.ibm.commerce.contract.objects.BusinessPolicyAccessBean" %>
<%@ page import="com.ibm.commerce.contract.helper.ECContractConstants" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.CategoryPricingTCDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PolicyListDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PolicyDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.MemberDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.CustomProductSetDataBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean" %>
<%@ page import="java.util.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>
<%
Hashtable memberCache = new Hashtable();
String memberType = null;
String memberDN = null;
String memberGroupName = null;
String memberGroupOwnerMemberType = null;
String memberGroupOwnerMemberDN = null;

%>


<%
   /*91199*/
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


<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= UIUtil.toHTML((String)contractsRB.get("contractPriceListTitle")) %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Pricing.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

<script LANGUAGE="JavaScript">
///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
// global contract pricing model...
// contains all of the price TCs currently defined!
var cpm;
var debug=false;


/*91199*/
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
         parent.parent.unlockAndLockContractTC("<%= contractId %>", 1);
      }
      else
      {
         // User clicks CANCEL to give up the unlock of this TC
         shouldTCbeSaved = false;
      }
   }

   // Persist the flag to the javascript ContractCommonDataModel
   var ccmd = parent.parent.get("ContractCommonDataModel", null);
   if (ccmd!=null)
   {
      ccmd.tcLockInfo["PricingTC"] = new Object();
      ccmd.tcLockInfo["PricingTC"].contractID = "<%= contractId %>";
      ccmd.tcLockInfo["PricingTC"].tcType = "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING %>";
      ccmd.tcLockInfo["PricingTC"].shouldTCbeSaved = shouldTCbeSaved;
      ccmd.tcLockInfo["PricingTC"].forceUnlock = forceUnlock;
   }

   if (!shouldTCbeSaved) { disableAllFormsElements(); } //disallow user to change any fields

   return;

}//end-function-handleTCLockStatus


//------------------------------------------------------------------------
// Function Name: disableAllFormsElements
//
// This function disables all the elements in the forms, so that user
// will not able to change any current contents to the forms fields.
//------------------------------------------------------------------------
function disableAllFormsElements()
{
   for (var i=0; i<document.ContractPriceListForm.elements.length; i++)
   {
      document.ContractPriceListForm.elements[i].disabled = true;
   }

   parent.hideButton("add");
   parent.hideButton("change");
   parent.hideButton("remove");
}


///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////
function loadPanelData() {

   if (! parent.parent.get) {
       alertDebug('No model found!');
       return;
   }

   parent.parent.put("ContractPricingPageVisited", "PRICING");

   // check to see if the model has already been loaded...
   var isModelLoaded = parent.parent.get("ContractCategoryPricingModelLoaded", null);

   //if (false) {
   if (isModelLoaded) {
       alertDebug('Contract Pricing - Reloading Page - Using stored pricing model...');

       // get the model
       cpm = parent.parent.get("ContractCategoryPricingModel", null);

       // populate the fields on this page using the model
       if (cpm != null) {
          // loadValues!!
       }
       else {
          alertDebug('Fatal Error: No pricing model found!');
          return;
       }

       // check to see if we are returning from an "add" price TC operation.
       // if we are, add the new TC to the model
       var newPriceTC = top.getData("ContractPricingNewPriceTC",null);

       if (newPriceTC != null) {
           alertDebug('New TC Found=\n'+dumpObject(newPriceTC));
           // add the new TC onto the end of the model

           // we need to check if this is a standard product set price TC.  if it is then
           // loop through the selections and create a price TC for each one that was added.
           if (newPriceTC.percentagePricingRadio == "standardPriceTC") {
               alertDebug('Found Standard Price TCs Length='+newPriceTC.adjustmentOnStandardProductSetSelectedCategories.length);
               for (var i=0; i<newPriceTC.adjustmentOnStandardProductSetSelectedCategories.length; i++) {
                   var tempPriceTC = new ContractPriceTC();
                   clonePriceTC(newPriceTC,tempPriceTC);
                   tempPriceTC.adjustmentOnStandardProductSetPolicyId = newPriceTC.adjustmentOnStandardProductSetSelectedCategories[i].value;
                   tempPriceTC.adjustmentOnStandardProductSetDisplayText = newPriceTC.adjustmentOnStandardProductSetSelectedCategories[i].text;
                   cpm.priceTC[cpm.priceTC.length] = tempPriceTC;
                   alertDebug('Adding Standard Price TC');
               }
           }
           else {
               cpm.priceTC[cpm.priceTC.length] = newPriceTC;
           }

           // clear out the saved TC
           top.saveData(null, "ContractPricingNewPriceTC");

           // if this is the first TC then popup the warning message...
           if (getDisplayRowsCount() == 1) {
           //  alertDialog('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPriceListNotEmpty")) %>');
           }
       }

       // check to see if we are returning from an "update" price TC operation.
       // if we are, add the replace the old TC with the updated one in the model
       var updatePriceTC = top.getData("ContractPricingUpdatePriceTC",null);
       var updatePriceTCindex = top.getData("ContractPricingUpdatePriceTCindex",null);

       if (updatePriceTC != null && updatePriceTCindex >= 0) {
           alertDebug('Updated TC Found for TC #'+updatePriceTCindex+'=\n'+dumpObject(updatePriceTC));
           // replace the old TC with the new one...
           cpm.priceTC[updatePriceTCindex] = updatePriceTC;
           // clear out the saved TC
           top.saveData(null, "ContractPricingUpdatePriceTC");
           top.saveData(null, "ContractPricingUpdatePriceTCindex");
           if (getDisplayRowsCount() == 1) {
           //  alertDialog('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPriceListNotEmpty")) %>');
           }
       }
   }
   else {
       alertDebug('Contract Pricing - First visit! - Creating a new pricing model...');

       // create a contract price list model which will store an array of price TCs
       cpm = new ContractCategoryPricingModel();

       // there is only *one* master catalog policy per store... use the finder to get it and create a PolicyObject()
       // put the master catalog price list policy in the pricing model
       <%
           try {
               Enumeration pricePolicyList;

               // try to find a master catalog for the store entity...
               pricePolicyList = new BusinessPolicyAccessBean().findStandardPriceListPolicyByStoreEntityId(fStoreId);

               if (!pricePolicyList.hasMoreElements()) { // if the list is empty then try to find a master catalog for the store group.
                   pricePolicyList = new BusinessPolicyAccessBean().findStandardPriceListPolicyByStore(fStoreId);
               }

               if (!pricePolicyList.hasMoreElements()) {
                   // error... there is no price policy defined for the store group or the store entity.
               }
               else {
                   BusinessPolicyAccessBean bpab = null;
                   while ( pricePolicyList.hasMoreElements() ) {
                     bpab = (BusinessPolicyAccessBean)pricePolicyList.nextElement();

                   PolicyDataBean pricePDB = new PolicyDataBean();
                 pricePDB.setId(bpab.getPolicyIdInEntityType());
                  DataBeanManager.activate(pricePDB, request);

                     if (ContractCmdUtil.isMasterPriceListPolicy(pricePDB.getPolicyName())) {

                        Vector memberStuff = (Vector) memberCache.get(pricePDB.getStoreMemberId());
                        if (memberStuff != null){
                              // get stuff from cache
                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
                        }
                        else {
                              // get stuff from db
                              memberStuff = new Vector();
                              MemberDataBean mdb = new MemberDataBean();
                        mdb.setId(pricePDB.getStoreMemberId());
                        DataBeanManager.activate(mdb, request);
                        memberStuff.addElement((String)mdb.getMemberType());
                              memberStuff.addElement((String)mdb.getMemberDN());
                              memberStuff.addElement((String)mdb.getMemberGroupName());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberType());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberDN());

                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

                              memberCache.put(pricePDB.getStoreMemberId(), memberStuff);
                        }

                        //MemberDataBean mdb = new MemberDataBean();
                        //mdb.setId(pricePDB.getStoreMemberId());
                        //DataBeanManager.activate(mdb, request);
       %>
                   cpm.masterCatalogPriceListPolicy =
                          new PolicyObject('<%=UIUtil.toJavaScript(pricePDB.getShortDescription())%>',
                                           '<%= UIUtil.toJavaScript(pricePDB.getPolicyName()) %>',
                                           '<%= pricePDB.getId() %>',
                                           '<%= UIUtil.toJavaScript(pricePDB.getStoreIdentity()) %>',
                                           new Member('<%= memberType %>',
                                                      '<%= UIUtil.toJavaScript(memberDN) %>',
                                                      '<%= UIUtil.toJavaScript(memberGroupName) %>',
                                                      '<%= memberGroupOwnerMemberType %>',
                                                      '<%= UIUtil.toJavaScript(memberGroupOwnerMemberDN) %>')
                                          );
       <%
                  } // end if
               } // end while
              } // end if
          }  // end try
          catch(Exception e) {
              System.out.println(e);
          }
       %>

       // put together the master list of all the product set policies for the store/storegroup
       var productSetPolicyList = new Array();
       <%
           try {
               // load the policies from the database
               PolicyListDataBean productSetPolicyList = new PolicyListDataBean();
               String policyType = productSetPolicyList.TYPE_PRODUCT_SET;
               PolicyDataBean policies[] = null;

               productSetPolicyList.setPolicyType(policyType);
               DataBeanManager.activate(productSetPolicyList, request);
               policies = productSetPolicyList.getPolicyList();

               for (int i = 0; i < policies.length; i++) {
                   PolicyDataBean productSetPDB = policies[i];

                   if (productSetPDB.getPolicyName().equals("Custom") &&
                       productSetPDB.getStoreIdentity().equals("-1")) continue;

                   if (productSetPDB.getProperties() == null) continue;

                   // get the member data for each policy

                   Vector memberStuff = (Vector) memberCache.get(productSetPDB.getStoreMemberId());
                   if (memberStuff != null){
                     // get stuff from cache
                     memberType = (String) memberStuff.elementAt(0);
                     memberDN = (String) memberStuff.elementAt(1);
                     memberGroupName = (String) memberStuff.elementAt(2);
                     memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                     memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
                   }
                   else {
                     // get stuff from db
                     memberStuff = new Vector();
                     MemberDataBean mdb = new MemberDataBean();
                       mdb.setId(productSetPDB.getStoreMemberId());
                       DataBeanManager.activate(mdb, request);
                       memberStuff.addElement((String)mdb.getMemberType());
                     memberStuff.addElement((String)mdb.getMemberDN());
                     memberStuff.addElement((String)mdb.getMemberGroupName());
                     memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberType());
                     memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberDN());

                     memberType = (String) memberStuff.elementAt(0);
                     memberDN = (String) memberStuff.elementAt(1);
                     memberGroupName = (String) memberStuff.elementAt(2);
                     memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                     memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

                     memberCache.put(productSetPDB.getStoreMemberId(), memberStuff);
                   }

                   //MemberDataBean mdb = new MemberDataBean();
                   //mdb.setId(productSetPDB.getStoreMemberId());
                   //DataBeanManager.activate(mdb, request);
       %>
                   productSetPolicyList[productSetPolicyList.length] =
                          new PolicyObject('<%=UIUtil.toJavaScript(productSetPDB.getShortDescription())%>',
                                           '<%= UIUtil.toJavaScript(productSetPDB.getPolicyName()) %>',
                                           '<%= productSetPDB.getId() %>',
                                           '<%= UIUtil.toJavaScript(productSetPDB.getStoreIdentity()) %>',
                                           new Member('<%= memberType %>',
                                                      '<%= UIUtil.toJavaScript(memberDN) %>',
                                                      '<%= UIUtil.toJavaScript(memberGroupName) %>',
                                                      '<%= memberGroupOwnerMemberType %>',
                                                      '<%= UIUtil.toJavaScript(memberGroupOwnerMemberDN) %>')
                                          );


       <%
              } // end for
          }  // end try
          catch(Exception e) {
              System.out.println(e);
          }
       %>

       // store the policy list in the pricing model
       cpm.productSetPolicyList = productSetPolicyList;

       // persist the model
       parent.parent.put("ContractCategoryPricingModel", cpm);

       alertDebug('Pricing Model Created:\n'+dumpObject(cpm));

       // set the loaded flag to true, as processing is different if this page is reloaded...
       parent.parent.put("ContractCategoryPricingModelLoaded", true);

       // check if this is an update
       if (<%= foundContractId %> == true) {
         // load the data from the databean
         <%
         // Create an instance of the databean to use if we are doing an update
         if (foundContractId) {
            CategoryPricingTCDataBean tcData = new CategoryPricingTCDataBean(new Long(contractId), new Integer(fLanguageId));
            DataBeanManager.activate(tcData, request);
            //
            // MASTER CATALOG PRICE TCS
            //
            for (int i = 0; i < tcData.getMasterCatalogAdjustments().size(); i++) {
                Vector tcElement = tcData.getMasterCatalogAdjustment(i);
         %>
                var newPriceTC = new ContractPriceTC();
                newPriceTC.tcInContract = true;
                newPriceTC.referenceNumber = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_REFERENCE_NUMBER) %>';
                newPriceTC.percentagePricingRadio = "masterPriceTC";
                newPriceTC.adjustmentOnMasterCatalogValue = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>';
                cpm.priceTC[cpm.priceTC.length] = newPriceTC;
         <% }
            //
            // SELECTIVE ADJUSTMENT PRICE TCS
            //
            for (int i = 0; i < tcData.getSelectiveAdjustments().size(); i++) {
                Vector tcElement = tcData.getSelectiveAdjustment(i);

                //
                // SELECTIVE ADJUSTMENT PRICE TCS (/w STANDARD PRODUCT SET)
                //
                String priceTCtype = (String)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_TYPE);

                if (priceTCtype.equals("standardPriceTC")) {
                    PolicyDataBean psPDB = (PolicyDataBean)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_PRODUCTSET_POLICY_DB);
        %>
                    var newPriceTC = new ContractPriceTC();
                    newPriceTC.tcInContract = true;
                    newPriceTC.referenceNumber = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_REFERENCE_NUMBER) %>';
                    newPriceTC.percentagePricingRadio = "standardPriceTC";
                    newPriceTC.adjustmentOnStandardProductSetValue = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>';
                    newPriceTC.adjustmentOnStandardProductSetPolicyId = '<%= psPDB.getId() %>';
                    newPriceTC.adjustmentOnStandardProductSetDisplayText = '<%= UIUtil.toJavaScript(psPDB.getShortDescription()) %>';
                    cpm.priceTC[cpm.priceTC.length] = newPriceTC;
       <%       } // end if

                //
                // SELECTIVE ADJUSTMENT PRICE TCS (/w CUSTOM PRODUCT SET)
                //
                else if (priceTCtype.equals("customPriceTC")) {
                    // this is a custom product set TC
                    // get the catentry/catgroups from the databean
                 CustomProductSetDataBean psdb = (CustomProductSetDataBean)tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_PRODUCTSET_SELECTIONS);
        %>
                    var newPriceTC = new ContractPriceTC();
                    newPriceTC.tcInContract = true;
                    newPriceTC.referenceNumber = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_REFERENCE_NUMBER) %>';
                    newPriceTC.percentagePricingRadio = "customPriceTC";
                    newPriceTC.adjustmentOnCustomProductSetName = '<%= UIUtil.toJavaScript(tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_PRODUCTSET_NAME)) %>';
                    newPriceTC.adjustmentOnCustomProductSetValue = '<%= tcElement.elementAt(CategoryPricingTCDataBean.PRICETC_ADJUSTMENT_VALUE) %>';
                    <%
                        // create the catalog entries
                        for (int j = 0; j<psdb.getCatalogEntries().size(); j++) {
                          try{
                            CatalogEntryAccessBean ceab = (CatalogEntryAccessBean)psdb.getCatalogEntry(j);
                            String refnum = ceab.getCatalogEntryReferenceNumber();
                            String memberId = ceab.getMemberId();
                            String partNumber = ceab.getPartNumber();
                            String displayText = partNumber;
                            try {
                                CatalogEntryDescriptionAccessBean cedab = ceab.getDescription(new Integer(fLanguageId));
                                displayText = cedab.getShortDescription() + " (" + partNumber + ")";
                            }
                            catch (Exception e) {
                                // if you can't get the NLV short description for the catentry,
                                // then use just use the SKU as the displayText
                                // this logic was defaulted above...
                                System.out.println(e);
                            }

                            Vector memberStuff = (Vector) memberCache.get(memberId);
                            if (memberStuff != null){
                              // get stuff from cache
                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
                            }
                            else {
                              // get stuff from db
                              memberStuff = new Vector();
                              MemberDataBean mdb = new MemberDataBean();
                                mdb.setId(memberId);
                                DataBeanManager.activate(mdb, request);
                                memberStuff.addElement((String)mdb.getMemberType());
                              memberStuff.addElement((String)mdb.getMemberDN());
                              memberStuff.addElement((String)mdb.getMemberGroupName());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberType());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberDN());

                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

                              memberCache.put(memberId, memberStuff);
                            }

                    %>
                            newPriceTC.adjustmentOnCustomProductSetSelection[newPriceTC.adjustmentOnCustomProductSetSelection.length] =
                                                                    new CatEntry('<%= UIUtil.toJavaScript(displayText) %>',
                                                                                 '<%= refnum %>',
                                                                                 '<%= UIUtil.toJavaScript(partNumber) %>',
                                                                                 new Member('<%= memberType %>',
                                                                                            '<%= UIUtil.toJavaScript(memberDN) %>',
                                                                                            '<%= UIUtil.toJavaScript(memberGroupName) %>',
                                                                                            '<%= memberGroupOwnerMemberType %>',
                                                                                            '<%= UIUtil.toJavaScript(memberGroupOwnerMemberDN) %>'),
                                                                                            'CE');
                    <%    }
                          catch(Exception e) {
                              System.out.println(e);
                          }
                        } // end for %>
                    <%
                        // create the catalog groups
                        for (int j = 0; j<psdb.getCatalogGroups().size(); j++) {
                          try{
                            CatalogGroupAccessBean cgab = (CatalogGroupAccessBean)psdb.getCatalogGroup(j);
                            String refnum = cgab.getCatalogGroupReferenceNumber();
                            String memberId = cgab.getMemberId();
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
                                System.out.println(e);
                            }

                            Vector memberStuff = (Vector) memberCache.get(memberId);
                            if (memberStuff != null){
                              // get stuff from cache
                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
                            }
                            else {
                              // get stuff from db
                              memberStuff = new Vector();
                              MemberDataBean mdb = new MemberDataBean();
                                mdb.setId(memberId);
                                DataBeanManager.activate(mdb, request);
                                memberStuff.addElement((String)mdb.getMemberType());
                              memberStuff.addElement((String)mdb.getMemberDN());
                              memberStuff.addElement((String)mdb.getMemberGroupName());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberType());
                              memberStuff.addElement((String)mdb.getMemberGroupOwnerMemberDN());

                              memberType = (String) memberStuff.elementAt(0);
                              memberDN = (String) memberStuff.elementAt(1);
                              memberGroupName = (String) memberStuff.elementAt(2);
                              memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
                              memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

                              memberCache.put(memberId, memberStuff);
                            }

                            //MemberDataBean mdb = new MemberDataBean();
                  //mdb.setId(memberId);
                  //DataBeanManager.activate(mdb, request);
                    %>
                            newPriceTC.adjustmentOnCustomProductSetSelection[newPriceTC.adjustmentOnCustomProductSetSelection.length] =
                                                                    new CatEntry('<%= UIUtil.toJavaScript(displayText) %>',
                                                                                 '<%= refnum %>',
                                                                                 '<%= UIUtil.toJavaScript(identifier) %>',
                                                                                 new Member('<%= memberType %>',
                                                                                            '<%= UIUtil.toJavaScript(memberDN) %>',
                                                                                            '<%= UIUtil.toJavaScript(memberGroupName) %>',
                                                                                            '<%= memberGroupOwnerMemberType %>',
                                                                                            '<%= UIUtil.toJavaScript(memberGroupOwnerMemberDN) %>'),
                                                                                            'CG');
                    <%    }
                          catch(Exception e) {
                              System.out.println(e);
                          }
                        } // end for %>
                    cpm.priceTC[cpm.priceTC.length] = newPriceTC;
       <%       } // end else
            } // end for
      } // end if
        %>
    } // end if
   } // end else

   // do any error handling...
   return;
}

function onLoadPage() {
   // load the button frame
   parent.loadFrames();

   if (parent.parent.setContentFrameLoaded) {
       parent.parent.setContentFrameLoaded(true);
   }

   /*91199*/ handleTCLockStatus();
}

///////////////////////////////////////
// BUTTON ACTION SCRIPTS
///////////////////////////////////////
function addPricing(){
   // create a blank price TC for use in the dialog.
   // if the user clicks ok in the dialog, the saved updates will be appended to current CPM
   // if he clicks cancel, then the original CPM is left untouched and the DL is reloaded
   // save the scratch price list model in the top frame
    var ccdm = parent.parent.get("ContractCommonDataModel",null);
    if (ccdm != null) {
        top.saveData(ccdm, "ccdm");
    }

   var scratchPriceTC = new ContractPriceTC();

   var ccdm = parent.parent.get("ContractCommonDataModel",null);

   top.saveData(scratchPriceTC, "scratchPriceTC");
   alertDebug('scratchPriceTC=\n'+dumpObject(scratchPriceTC));

   top.saveData(cpm, "ContractCPM");
   alertDebug('cpm=\n'+dumpObject(cpm));

   var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractAddPricingDialog";

   // save the model before launching the dialog
   top.saveModel(parent.parent.model);
   top.setReturningPanel("notebookPricingCatalog");

   top.setContent('<%= UIUtil.toJavaScript((String)contractsRB.get("contractAddPricingPanelTitle")) %>', url, true);
}

function changePricing(clickedId){
   var priceTCid;

   var ccdm = parent.parent.get("ContractCommonDataModel",null);
   if (ccdm != null) {
       top.saveData(ccdm, "ccdm");
   }

   // if there is no input argument, check the checkboxes
   if (clickedId == null) {
       // get the checked price list id
       var checked = parent.getChecked().toString();
       var checkedArray = checked.split(',');
       priceTCid = checkedArray[0];
   }
   else {
       priceTCid = clickedId;
   }

   if (priceTCid < 0 || priceTCid == null) {
       alertDebug('Fatal Error: priceTCid not found!');
       return;
   }

   // create a copy of the price TC for use in the dialog.
   // if the user clicks ok in the dialog, the saved updates will replace the current price TC
   // if he clicks cancel, then the original model is intact
   // save the scratch price list model in the top frame
   var scratchPriceTC = new ContractPriceTC();
   clonePriceTC(cpm.priceTC[priceTCid],scratchPriceTC);

   alertDebug('scratchPriceTC=\n'+dumpObject(scratchPriceTC));

   top.saveData(scratchPriceTC, "scratchPriceTC");

   // save the pricing model
   top.saveData(cpm, "ContractCPM");
   alertDebug('cpm=\n'+dumpObject(cpm));

   var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractChangePricingDialog&priceTCid=" + priceTCid;

   alertDebug('url='+url);

   // save the model before launching the dialog
   top.saveModel(parent.parent.model);
   top.setReturningPanel("notebookPricingCatalog");

   // let's go!
   top.setContent('<%= UIUtil.toJavaScript((String)contractsRB.get("contractChangePricingPanelTitle")) %>', url, true);
}


function removePricing() {
    var checked = parent.getChecked().toString();
    var checkedArray = checked.split(',');

    if (checkedArray.length > 0) {
        if (confirmDialog("<%=UIUtil.toJavaScript((String)contractsRB.get("contractPriceListDeleteConfirmation"))%>")) {

           // loop through all the pricing definitions...
           for (i=0; i < cpm.priceTC.length; i++) {
              for (j=0; j < checkedArray.length; j++) {
                 if (checkedArray[j] == i) {
                    // the pricing checkbox id matches that found in the checked array, set delete flag
                   cpm.priceTC[i].markedForDelete = true;
                 }
              }
           }
        }
    }
    alertDebug('After Delete... New CPM=\n'+dumpObject(cpm));

    parent.parent.put("ContractCategoryPricingModel", cpm);

    // reload page now that the pricing definitions have been deleted
    parent.location.reload();
}

///////////////////////////////////////
// MISCELLANEOUS SCRIPTS
///////////////////////////////////////
function getDisplayRowsCount() {
    var numRows = 0;
    var deletedRows = 0;
    if (cpm != null && cpm.priceTC.length>0){
       for (index = 0; index < cpm.priceTC.length; index++) {
           if (!cpm.priceTC[index].markedForDelete) {
               numRows++;
           }
           else {
               deletedRows++;
           }
       }
    }
    alertDebug("You have "+numRows+" display rows");
    alertDebug("You have "+deletedRows+" deleted rows");

    return numRows;
}

function getRowsCount() {
    var numRows = 0;
    if (cpm != null && cpm.priceTC.length>0){
        numRows = cpm.priceTC.length;
    }
    alertDebug('The following number is important (in the next mesg box)');
    alertDebug(numRows);
    return numRows;
}

function formatAdjustmentValue(adj, lang) {
    if (adj > 0) {
        return "+"+parent.parent.numberToStr(adj, lang);
    }
    else {
        return parent.parent.numberToStr(adj, lang);
    }
}


</script>

</head>

<!--BODY onload="loadPanelData()"-->
<body onload="onLoadPage()" class="content_list">

<h1><%= contractsRB.get("contractPriceListTitle") %></h1>

<script LANGUAGE="JavaScript">
loadPanelData();

</script>

<%
   int startIndex = Integer.parseInt(request.getParameter("startindex"));
   int listSize = Integer.parseInt(request.getParameter("listsize"));
   int endIndex = startIndex + listSize;
%>

<form NAME="ContractPriceListForm" id="ContractPriceListForm">
  <%= comm.startDlistTable((String)contractsRB.get("contractPriceListSummary")) %>
  <%= comm.startDlistRowHeading() %>
  <%= comm.addDlistCheckHeading() %>

  <%= comm.addDlistColumnHeading((String)contractsRB.get("contractPriceListCustomProductSetsHeading"),null,false)%>
  <%= comm.addDlistColumnHeading((String)contractsRB.get("contractPricingAdjustmentPercentageLabel"),null,false)%>

  <%= comm.endDlistRow() %>

  <script LANGUAGE="JavaScript">
  var j = 0;

  for (var i = 0; i < getRowsCount() ; i++){
   if (cpm.priceTC[i].markedForDelete == false) {
    if (j == 0){
      document.writeln('<TR CLASS="list_row1">');
      j = 1;
    }else{
      document.writeln('<TR CLASS="list_row2">');
      j = 0;
    }

    var changeURL = 'javascript:changePricing(' + i + ')';

    addDlistCheck(i, "none");

    if (cpm.priceTC[i].percentagePricingRadio == "masterPriceTC") {
        addDlistColumn('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingAllCategoriesLabel")) %>', changeURL);
        addDlistColumn(formatAdjustmentValue(cpm.priceTC[i].adjustmentOnMasterCatalogValue, "<%=fLanguageId%>"), "none" );
    }
    else if (cpm.priceTC[i].percentagePricingRadio == "standardPriceTC") {
        addDlistColumn(cpm.priceTC[i].adjustmentOnStandardProductSetDisplayText, changeURL);
        addDlistColumn(formatAdjustmentValue(cpm.priceTC[i].adjustmentOnStandardProductSetValue, "<%=fLanguageId%>"), "none");
    }
    else if (cpm.priceTC[i].percentagePricingRadio == "customPriceTC") {
        var customText = "";
        if (cpm.priceTC[i].adjustmentOnCustomProductSetSelection != null) {
            for (var custIndex=0; custIndex < cpm.priceTC[i].adjustmentOnCustomProductSetSelection.length; custIndex++) {
                if (cpm.priceTC[i].adjustmentOnCustomProductSetSelection[custIndex].displayText != "DELETED") {
                    customText += cpm.priceTC[i].adjustmentOnCustomProductSetSelection[custIndex].displayText + "<BR>";
                }
            }
        }

        addDlistColumn(customText, changeURL);
        addDlistColumn(formatAdjustmentValue(cpm.priceTC[i].adjustmentOnCustomProductSetValue, "<%=fLanguageId%>"), "none" );
    }

    document.writeln('</TR>');
   } // end if marked for delete
  } // end for

</script>

  <%= comm.endDlistTable() %>

  <script>
  if (getDisplayRowsCount() == 0){
    document.writeln('<br>');
    document.writeln('<%= UIUtil.toJavaScript((String)contractsRB.get("contractPriceListEmpty")) %>');
  }

</script>

</form>

<script>
 <!--
  parent.afterLoads();
  // adjust button frame position to line it up with base frame
  parent.setButtonPos('0px','42px');
 //-->

</script>
</body>
</html>
