<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.user.beans.UserAdminDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.MemberDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.ProductSetTCDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.CategoryPricingTCDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PolicyDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PolicyListDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.CustomProductSetDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.ProductSetHelper" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean" %>
<%@ page import="java.util.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%Hashtable memberCache = new Hashtable();
String memberType = null;
String memberDN = null;
String memberGroupName = null;
String memberGroupOwnerMemberType = null;
String memberGroupOwnerMemberDN = null;
%>
<%
// load all the standard product set policies from the database
PolicyListDataBean productSetPolicyList = new PolicyListDataBean();
String policyType = productSetPolicyList.TYPE_PRODUCT_SET;
PolicyDataBean policies[] = null;

productSetPolicyList.setPolicyType(policyType);
DataBeanManager.activate(productSetPolicyList, request);
policies = productSetPolicyList.getPolicyList();
%>

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
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING);
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
<%=fHeader%>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(fLocale)%>"
   type="text/css">

<style type='text/css'>
.selectWidth {
   width: 400px;
}

.sloshBucketWidth {
   width: 300px;
}
</style>

<title><%=contractsRB.get("contractPricingConstraintsPanelTitle")%></title>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/ProductConstraints.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/Pricing.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/ContractPricingDialog.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

<script LANGUAGE="JavaScript">
///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
var cpcm;
var debug=false;




///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////
function onLoad() {

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
   myFormNames[0]  = "inclusionProductSetForm";
   myFormNames[1]  = "exclusionProductSetForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);


   if (! parent.get) {
       alertDebug('No model found!');

      handleTCLockStatus("PricingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      1);

       return;
   }

   parent.put("ContractPricingPageVisited", "CONSTRAINTS");

   // check to see if the model has already been loaded...
   var isModelLoaded = parent.get("ContractProductConstraintsModelLoaded", null);

   //if (false) {
   if (isModelLoaded) {
       alertDebug('Contract Pricing Constraints - Reloading Page - Using stored pricing model...');

       // get the model
       cpcm = parent.get("ContractProductConstraintsModel", null);

       // populate the fields on this page using the model
       if (cpcm != null) {
           // if the javascript model already exists, then load the option boxes from the save data
           loadTextValueSelectValues(document.inclusionProductSetForm.selected_ps_si, cpcm.selected_ps_si);
           loadTextValueSelectValues(document.inclusionProductSetForm.available_ps_si, cpcm.available_ps_si);

           loadTextValueSelectValues(document.exclusionProductSetForm.selected_ps_se, cpcm.selected_ps_se);
           loadTextValueSelectValues(document.exclusionProductSetForm.available_ps_se, cpcm.available_ps_se);
       }
       else {
          alertDebug('Fatal Error: No pricing constraints model found!');

            handleTCLockStatus("PricingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      1);
          return;
       }
   }
   else {
       alertDebug('Contract Pricing Constraints - First visit! - Creating a new pricing constraints model...');

       // create a contract product constraints model which will store product set TCs
       cpcm = new ContractProductConstraintsModel();

       // put together the master list of all the product set policies for the store/storegroup
       var productSetPolicyList = new Array();
       <%try {
   for (int i = 0; i < policies.length; i++) {
      PolicyDataBean productSetPDB = policies[i];

      if (productSetPDB.getPolicyName().equals("Custom")
         && productSetPDB.getStoreIdentity().equals("-1"))
         continue;

      if (productSetPDB.getProperties() == null)
         continue;

      // get the member data for each policy

      Vector memberStuff =
         (Vector) memberCache.get(productSetPDB.getStoreMemberId());
      if (memberStuff != null) {
         // get stuff from cache
         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
      } else {
         // get stuff from db
         memberStuff = new Vector();
         MemberDataBean mdb = new MemberDataBean();
         mdb.setId(productSetPDB.getStoreMemberId());
         DataBeanManager.activate(mdb, request);
         memberStuff.addElement((String) mdb.getMemberType());
         memberStuff.addElement((String) mdb.getMemberDN());
         memberStuff.addElement((String) mdb.getMemberGroupName());
         memberStuff.addElement(
            (String) mdb.getMemberGroupOwnerMemberType());
         memberStuff.addElement((String) mdb.getMemberGroupOwnerMemberDN());

         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

         memberCache.put(productSetPDB.getStoreMemberId(), memberStuff);
      }

      //MemberDataBean mdb = new MemberDataBean();
      //mdb.setId(productSetPDB.getStoreMemberId());
      //DataBeanManager.activate(mdb, request);                   %>
                   productSetPolicyList[productSetPolicyList.length] =
                          new PolicyObject('<%=UIUtil.toJavaScript(productSetPDB.getShortDescription())%>',
                                           '<%=UIUtil.toJavaScript(productSetPDB.getPolicyName())%>',
                                           '<%=productSetPDB.getId()%>',
                                           '<%=UIUtil.toJavaScript(productSetPDB.getStoreIdentity())%>',
                                           new Member('<%=memberType%>',
                                                      '<%=UIUtil.toJavaScript(memberDN)%>',
                                                      '<%=UIUtil.toJavaScript(memberGroupName)%>',
                                                      '<%=memberGroupOwnerMemberType%>',
                                                      '<%=UIUtil.toJavaScript(memberGroupOwnerMemberDN)%>')
                                          );


       <%} // end for
} // end try
catch (Exception e) {
   System.out.println(e);
}%>

       // store the policy list in the constraints model
       cpcm.productSetPolicyList = productSetPolicyList;

       // persist the model
       parent.put("ContractProductConstraintsModel", cpcm);

       // set the loaded flag to true, as processing is different if this page is reloaded...
       parent.put("ContractProductConstraintsModelLoaded", true);

       // check if this is an update
       if (<%=foundContractId%> == true) {
         // load the data from the databean

         <%
// Create an instance of the databean to use if we are doing an update
if (foundContractId) { // THIS IS AN UPDATE!!!!
   ProductSetTCDataBean tcData =
      new ProductSetTCDataBean(
         new Long(contractId),
         new Integer(fLanguageId));
   DataBeanManager.activate(tcData, request);

   // rebuild the CUSTOM INCLUSION PS
   for (int i = 0; i < tcData.getCustomInclusionPS().size(); i++) {
      Vector tcElement = tcData.getCustomInclusionPS(i);

      // this is a custom product set TC
      // get the catentry/catgroups from the databean
      CustomProductSetDataBean psdb =
         (CustomProductSetDataBean) tcElement.elementAt(
            ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_SELECTIONS);%>
                cpcm.pstc_ci.tcInContract = true;
                cpcm.pstc_ci.referenceNumber = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_REFERENCE_NUMBER)%>';
                cpcm.pstc_ci.inclusionCustomProductSetName = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_NAME))%>';
          <%
// create the catalog entries
for (int j = 0; j < psdb.getCatalogEntries().size(); j++) {
   try {
      CatalogEntryAccessBean ceab =
         (CatalogEntryAccessBean) psdb.getCatalogEntry(j);
      String refnum = ceab.getCatalogEntryReferenceNumber();
      String memberId = ceab.getMemberId();
      String partNumber = ceab.getPartNumber();
      String displayText = partNumber;
      try {
         CatalogEntryDescriptionAccessBean cedab =
            ceab.getDescription(new Integer(fLanguageId));
         displayText = cedab.getShortDescription() + " (" + partNumber + ")";
      } catch (Exception e) {
         // if you can't get the NLV short description for the catentry,
         // then use just use the SKU as the displayText
         // this logic was defaulted above...
         System.out.println(e);
      }

      Vector memberStuff = (Vector) memberCache.get(memberId);
      if (memberStuff != null) {
         // get stuff from cache
         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
      } else {
         // get stuff from db
         memberStuff = new Vector();
         MemberDataBean mdb = new MemberDataBean();
         mdb.setId(memberId);
         DataBeanManager.activate(mdb, request);
         memberStuff.addElement((String) mdb.getMemberType());
         memberStuff.addElement((String) mdb.getMemberDN());
         memberStuff.addElement((String) mdb.getMemberGroupName());
         memberStuff.addElement(
            (String) mdb.getMemberGroupOwnerMemberType());
         memberStuff.addElement((String) mdb.getMemberGroupOwnerMemberDN());

         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

         memberCache.put(memberId, memberStuff);
      }

      //MemberDataBean mdb = new MemberDataBean();
      //mdb.setId(memberId);
      //DataBeanManager.activate(mdb, request);%>
                     cpcm.pstc_ci.inclusionCustomProductSetSelection[cpcm.pstc_ci.inclusionCustomProductSetSelection.length] =
                                                                    new CatEntry('<%=UIUtil.toJavaScript(displayText)%>',
                                                                                 '<%=refnum%>',
                                                                                 '<%=UIUtil.toJavaScript(partNumber)%>',
                                                                                 new Member('<%=memberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberDN)%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupName)%>',
                                                                                            '<%=memberGroupOwnerMemberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupOwnerMemberDN)%>'),
                                                                                 'CE');
          <%} catch (Exception e) {
   System.out.println(e);
}
} // end for

// create the catalog groups
for (int j = 0; j < psdb.getCatalogGroups().size(); j++) {
   try {
      CatalogGroupAccessBean cgab =
         (CatalogGroupAccessBean) psdb.getCatalogGroup(j);
      String refnum = cgab.getCatalogGroupReferenceNumber();
      String memberId = cgab.getMemberId();
      String identifier = cgab.getIdentifier();
      String displayText = identifier;
      try {
         CatalogGroupDescriptionAccessBean cgdab =
            cgab.getDescription(new Integer(fLanguageId));
         displayText = cgdab.getName();
      } catch (Exception e) {
         // if you can't get the NLV catgroup name for the catgroup,
         // then use the catgroup identifier as the displayText
         // this logic was defaulted above...
         System.out.println(e);
      }

      Vector memberStuff = (Vector) memberCache.get(memberId);
      if (memberStuff != null) {
         // get stuff from cache
         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
      } else {
         // get stuff from db
         memberStuff = new Vector();
         MemberDataBean mdb = new MemberDataBean();
         mdb.setId(memberId);
         DataBeanManager.activate(mdb, request);
         memberStuff.addElement((String) mdb.getMemberType());
         memberStuff.addElement((String) mdb.getMemberDN());
         memberStuff.addElement((String) mdb.getMemberGroupName());
         memberStuff.addElement(
            (String) mdb.getMemberGroupOwnerMemberType());
         memberStuff.addElement((String) mdb.getMemberGroupOwnerMemberDN());

         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

         memberCache.put(memberId, memberStuff);
      }

      //MemberDataBean mdb = new MemberDataBean();
      //mdb.setId(memberId);
      //DataBeanManager.activate(mdb, request);%>
                     cpcm.pstc_ci.inclusionCustomProductSetSelection[cpcm.pstc_ci.inclusionCustomProductSetSelection.length] =
                                                                    new CatEntry('<%=UIUtil.toJavaScript(displayText)%>',
                                                                                 '<%=refnum%>',
                                                                                 '<%=UIUtil.toJavaScript(identifier)%>',
                                                                                 new Member('<%=memberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberDN)%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupName)%>',
                                                                                            '<%=memberGroupOwnerMemberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupOwnerMemberDN)%>'),
                                                                                 'CG');
          <%} catch (Exception e) {
   System.out.println(e);
}
} // end for
} // end for (CUSTOM INCLUSION PS loop)

// rebuild the CUSTOM EXCLUSION PS
for (int i = 0; i < tcData.getCustomExclusionPS().size(); i++) {
   Vector tcElement = tcData.getCustomExclusionPS(i);

   // this is a custom product set TC
   // get the catentry/catgroups from the databean
   CustomProductSetDataBean psdb =
      (CustomProductSetDataBean) tcElement.elementAt(
         ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_SELECTIONS);%>
                cpcm.pstc_ce.tcInContract = true;
                cpcm.pstc_ce.referenceNumber = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_REFERENCE_NUMBER)%>';
                cpcm.pstc_ce.exclusionCustomProductSetName = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_NAME))%>';
          <%
// create the catalog entries
for (int j = 0; j < psdb.getCatalogEntries().size(); j++) {
   try {
      CatalogEntryAccessBean ceab =
         (CatalogEntryAccessBean) psdb.getCatalogEntry(j);
      String refnum = ceab.getCatalogEntryReferenceNumber();
      String memberId = ceab.getMemberId();
      String partNumber = ceab.getPartNumber();
      String displayText = partNumber;
      try {
         CatalogEntryDescriptionAccessBean cedab =
            ceab.getDescription(new Integer(fLanguageId));
         displayText = cedab.getShortDescription() + " (" + partNumber + ")";
      } catch (Exception e) {
         // if you can't get the NLV short description for the catentry,
         // then use just use the SKU as the displayText
         // this logic was defaulted above...
         System.out.println(e);
      }

      Vector memberStuff = (Vector) memberCache.get(memberId);
      if (memberStuff != null) {
         // get stuff from cache
         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
      } else {
         // get stuff from db
         memberStuff = new Vector();
         MemberDataBean mdb = new MemberDataBean();
         mdb.setId(memberId);
         DataBeanManager.activate(mdb, request);
         memberStuff.addElement((String) mdb.getMemberType());
         memberStuff.addElement((String) mdb.getMemberDN());
         memberStuff.addElement((String) mdb.getMemberGroupName());
         memberStuff.addElement(
            (String) mdb.getMemberGroupOwnerMemberType());
         memberStuff.addElement((String) mdb.getMemberGroupOwnerMemberDN());

         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

         memberCache.put(memberId, memberStuff);
      }

      //MemberDataBean mdb = new MemberDataBean();
      //mdb.setId(memberId);
      //DataBeanManager.activate(mdb, request);%>
                     cpcm.pstc_ce.exclusionCustomProductSetSelection[cpcm.pstc_ce.exclusionCustomProductSetSelection.length] =
                                                                    new CatEntry('<%=UIUtil.toJavaScript(displayText)%>',
                                                                                 '<%=refnum%>',
                                                                                 '<%=UIUtil.toJavaScript(partNumber)%>',
                                                                                 new Member('<%=memberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberDN)%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupName)%>',
                                                                                            '<%=memberGroupOwnerMemberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupOwnerMemberDN)%>'),
                                                                                 'CE');
          <%} catch (Exception e) {
   System.out.println(e);
}
} // end for

// create the catalog groups
for (int j = 0; j < psdb.getCatalogGroups().size(); j++) {
   try {
      CatalogGroupAccessBean cgab =
         (CatalogGroupAccessBean) psdb.getCatalogGroup(j);
      String refnum = cgab.getCatalogGroupReferenceNumber();
      String memberId = cgab.getMemberId();
      String identifier = cgab.getIdentifier();
      String displayText = identifier;
      try {
         CatalogGroupDescriptionAccessBean cgdab =
            cgab.getDescription(new Integer(fLanguageId));
         displayText = cgdab.getName();
      } catch (Exception e) {
         // if you can't get the NLV catgroup name for the catgroup,
         // then use the catgroup identifier as the displayText
         // this logic was defaulted above...
         System.out.println(e);
      }

      Vector memberStuff = (Vector) memberCache.get(memberId);
      if (memberStuff != null) {
         // get stuff from cache
         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);
      } else {
         // get stuff from db
         memberStuff = new Vector();
         MemberDataBean mdb = new MemberDataBean();
         mdb.setId(memberId);
         DataBeanManager.activate(mdb, request);
         memberStuff.addElement((String) mdb.getMemberType());
         memberStuff.addElement((String) mdb.getMemberDN());
         memberStuff.addElement((String) mdb.getMemberGroupName());
         memberStuff.addElement(
            (String) mdb.getMemberGroupOwnerMemberType());
         memberStuff.addElement((String) mdb.getMemberGroupOwnerMemberDN());

         memberType = (String) memberStuff.elementAt(0);
         memberDN = (String) memberStuff.elementAt(1);
         memberGroupName = (String) memberStuff.elementAt(2);
         memberGroupOwnerMemberType = (String) memberStuff.elementAt(3);
         memberGroupOwnerMemberDN = (String) memberStuff.elementAt(4);

         memberCache.put(memberId, memberStuff);
      }

      //MemberDataBean mdb = new MemberDataBean();
      //mdb.setId(memberId);
      //DataBeanManager.activate(mdb, request);%>
                     cpcm.pstc_ce.exclusionCustomProductSetSelection[cpcm.pstc_ce.exclusionCustomProductSetSelection.length] =
                                                                    new CatEntry('<%=UIUtil.toJavaScript(displayText)%>',
                                                                                 '<%=refnum%>',
                                                                                 '<%=UIUtil.toJavaScript(identifier)%>',
                                                                                 new Member('<%=memberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberDN)%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupName)%>',
                                                                                            '<%=memberGroupOwnerMemberType%>',
                                                                                            '<%=UIUtil.toJavaScript(memberGroupOwnerMemberDN)%>'),
                                                                                 'CG');
          <%} catch (Exception e) {
   System.out.println(e);
}
} // end for
} // end for (CUSTOM EXCLUSION PS loop)

// rebuild the STANDARD INCLUSION PS based on the saved contract
for (int i = 0; i < tcData.getStandardInclusionPS().size(); i++) {
   Vector tcElement = tcData.getStandardInclusionPS(i);

   // this is a standard product set TC%>
                var newStandardPSTC = new ContractStandardProductSetTC();
                newStandardPSTC.tcInContract = true;
                newStandardPSTC.referenceNumber = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_REFERENCE_NUMBER)%>';
                newStandardPSTC.productSetPolicyName = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(
      ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_NAME))%>';
                newStandardPSTC.productSetPolicyId = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_ID)%>';
                newStandardPSTC.productSetPolicyDescription = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(
      ProductSetTCDataBean
         .PRODUCTSET_TC_PRODUCTSET_POLICY_SHORT_DESCRIPTION))%>';
                cpcm.pstc_si[cpcm.pstc_si.length] = newStandardPSTC;

                // add the option to the "selected" sloshbucket!
                with (document.inclusionProductSetForm) {
                    selected_ps_si.options[selected_ps_si.options.length] = new Option(newStandardPSTC.productSetPolicyDescription,
                                                                                       newStandardPSTC.productSetPolicyId,
                                                                                       false,false);
                } // end with
          <%} // end for (STANDARD INCLUSION PS loop)

// rebuild the STANDARD EXCLUSION PS based on the saved contract
for (int i = 0; i < tcData.getStandardExclusionPS().size(); i++) {
   Vector tcElement = tcData.getStandardExclusionPS(i);

   // this is a standard product set TC%>
                var newStandardPSTC = new ContractStandardProductSetTC();
                newStandardPSTC.tcInContract = true;
                newStandardPSTC.referenceNumber = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_REFERENCE_NUMBER)%>';
                newStandardPSTC.productSetPolicyName = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(
      ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_NAME))%>';
                newStandardPSTC.productSetPolicyId = '<%=tcElement.elementAt(ProductSetTCDataBean.PRODUCTSET_TC_PRODUCTSET_POLICY_ID)%>';
                newStandardPSTC.productSetPolicyDescription = '<%=UIUtil.toJavaScript(
   tcElement.elementAt(
      ProductSetTCDataBean
         .PRODUCTSET_TC_PRODUCTSET_POLICY_SHORT_DESCRIPTION))%>';
                cpcm.pstc_se[cpcm.pstc_se.length] = newStandardPSTC;

                // add the option to the "selected" sloshbucket!
                with (document.exclusionProductSetForm) {
                    selected_ps_se.options[selected_ps_se.options.length] = new Option(newStandardPSTC.productSetPolicyDescription,
                                                                                       newStandardPSTC.productSetPolicyId,
                                                                                       false,false);
                } // end with
          <%} // end for (STANDARD EXCLUSION PS loop)

} // end if (foundContractId)%>

       } // end if (foundContractId)

       // build the availble slosh bucket since this is the first time the model has been loaded
       buildAvailableSloshBuckets(document.inclusionProductSetForm,
                                  document.inclusionProductSetForm.available_ps_si,
                                  document.inclusionProductSetForm.selected_ps_si);

       buildAvailableSloshBuckets(document.exclusionProductSetForm,
                                  document.exclusionProductSetForm.available_ps_se,
                                  document.exclusionProductSetForm.selected_ps_se);


       // save the standard product into the model immediately in case the user refresh the page
       cpcm.selected_ps_si = getTextValueSelectValues(document.inclusionProductSetForm.selected_ps_si)
       cpcm.available_ps_si = getTextValueSelectValues(document.inclusionProductSetForm.available_ps_si);
       cpcm.selected_ps_se = getTextValueSelectValues(document.exclusionProductSetForm.selected_ps_se)
       cpcm.available_ps_se = getTextValueSelectValues(document.exclusionProductSetForm.available_ps_se);

    } // end else (model is not loaded)

    // load the dialog values to those defined in the javascript model!
    loadPanelData();

    // handle error messages back from the validate page
    if (parent.get("contractVerifyProductConstraints", false)) {
        parent.remove("contractVerifyProductConstraints");
        alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractVerifyProductConstraints"))%>");
    }

    if (parent.setContentFrameLoaded) {
        parent.setContentFrameLoaded(true);
    }


    handleTCLockStatus("PricingTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      1);

}

function loadPanelData() {
    // set the model checkboxes values...
    if (cpcm.inclusionProductSetSwitch == true ||
        cpcm.pstc_ci.inclusionCustomProductSetSelection.length > 0 ||
        cpcm.pstc_si.length > 0) {
        // set the flag to true.
        cpcm.inclusionProductSetSwitch = true;
    }
    // set the model checkboxes values...
    if (cpcm.exclusionProductSetSwitch == true ||
        cpcm.pstc_ce.exclusionCustomProductSetSelection.length > 0 ||
        cpcm.pstc_se.length > 0) {
        // set the flag to true.
        cpcm.exclusionProductSetSwitch = true;
    }

    // set all the checkbox switches
    loadCheckboxValue(document.inclusionProductSetForm.inclusionProductSetSwitch, cpcm.inclusionProductSetSwitch);
    loadCheckboxValue(document.exclusionProductSetForm.exclusionProductSetSwitch, cpcm.exclusionProductSetSwitch);

    // load the custom INCLUSION product set multiselect box
    loadMultiSelect(document.inclusionProductSetForm.inclusionCustomProductSetSelection,
                    cpcm.pstc_ci.inclusionCustomProductSetSelection);

    initializeSloshBuckets(document.inclusionProductSetForm.selected_ps_si,
                           document.inclusionProductSetForm.removeFromSloshBucketButton,
                           document.inclusionProductSetForm.available_ps_si,
                           document.inclusionProductSetForm.addToSloshBucketButton);

    // update the remove button context for the multiselect box
    setButtonContext(document.inclusionProductSetForm.inclusionCustomProductSetSelection,
                     document.inclusionProductSetForm.inclusionProductSetRemoveButton);

    // load the custom EXCLUSION product set multiselect box
    loadMultiSelect(document.exclusionProductSetForm.exclusionCustomProductSetSelection,
                    cpcm.pstc_ce.exclusionCustomProductSetSelection);

    initializeSloshBuckets(document.exclusionProductSetForm.selected_ps_se,
                           document.exclusionProductSetForm.removeFromSloshBucketButton,
                           document.exclusionProductSetForm.available_ps_se,
                           document.exclusionProductSetForm.addToSloshBucketButton);

    // update the remove button context for the multiselect box
    setButtonContext(document.exclusionProductSetForm.exclusionCustomProductSetSelection,
                     document.exclusionProductSetForm.exclusionProductSetRemoveButton);

    // show the appropriate divisions
    showConstraintDivisions();

    alertDebug('Got Product Constraint TC Model!\n'+dumpObject(cpcm));
}

function savePanelData() {
    // assume that the custom product sets have been modified
    cpcm.pstc_ci.modifiedInSession = true;
    cpcm.pstc_ce.modifiedInSession = true;

    // set the "markedForDelete" flag appropriately on the custom product sets.
    checkForDeletedCustomProductSet(cpcm.pstc_ci, cpcm.pstc_ci.inclusionCustomProductSetSelection);
    checkForDeletedCustomProductSet(cpcm.pstc_ce, cpcm.pstc_ce.exclusionCustomProductSetSelection);

    // save all the form fields into the price TC attributes
    cpcm.inclusionProductSetSwitch = getCheckboxValue(document.inclusionProductSetForm.inclusionProductSetSwitch);
    cpcm.exclusionProductSetSwitch = getCheckboxValue(document.exclusionProductSetForm.exclusionProductSetSwitch);

    // save the standard product set available and selected sloshbuckets
    cpcm.selected_ps_si = getTextValueSelectValues(document.inclusionProductSetForm.selected_ps_si)
    cpcm.available_ps_si = getTextValueSelectValues(document.inclusionProductSetForm.available_ps_si);
    cpcm.selected_ps_se = getTextValueSelectValues(document.exclusionProductSetForm.selected_ps_se)
    cpcm.available_ps_se = getTextValueSelectValues(document.exclusionProductSetForm.available_ps_se);

    // custom inclusion product set
    // the product set name is generated using this timestamp helper class.
    // a product set name will always be generated on this page for the custom product sets,
    // regardless or whether the TC is a new one or an update.
    cpcm.pstc_ci.inclusionCustomProductSetName = '<%=ProductSetHelper.generatePSname()%>';
    <%Thread.sleep(10);
// sleep for 1 millisecond to make sure we generate a new ID!%>
    cpcm.pstc_ce.exclusionCustomProductSetName = '<%=ProductSetHelper.generatePSname()%>';

    alertDebug('Saved Product Set TC Model\n'+dumpObject(cpcm));
}

function validatePanelData() {
    return true;
}

///////////////////////////////////////
// BUTTON ACTION SCRIPTS
///////////////////////////////////////
function gotoSearchDialog(selectionArray) {
    // save the appropriate array in the model.  it will be used to store
    // user selected categories and items on the finder result set dialog.
    // the array will be reloaded by this panel upon return from the finder.
    // the selected categories/items will be added to the price tc model,
    // and displayed in the option box.
    top.saveData(selectionArray, "finderSelectionArray");

    // save all of the the panel data
    savePanelData();

    // save the model before launching the dialog
    top.saveModel(parent.model);

    // get the master catalog id for store
    var catalogId = "";
    var contractId = "";

    var ccdm = parent.get("ContractCommonDataModel",null);
    if (ccdm != null) {
        catalogId = ccdm.catalogId;
   contractId = ccdm.referenceNumber;
    }

    // let's go to finder...
    // build object to pass to BCT
    var url = "/webapp/wcs/tools/servlet/PriceListProductFindDialogView";
    var urlparm = new Object();
    urlparm.XMLFile = "contract.PriceListProductFindDialog";
    urlparm.catalogId = catalogId;
    urlparm.contractId = contractId;
    urlparm.categoryId = "";  // HACK! this is all categories
    urlparm.categoryDisplayText = cpcm.pricelistDisplayText;
    urlparm.searchActionType = "CGCE";
    urlparm.searchSelectionType = "CG";
    urlparm.targetView = "PriceListProductSearchResultsView";
    urlparm.targetXML = "contract.PriceListProductSearchResultsDialog";

    top.setReturningPanel("notebookProductConstraints");

    top.setContent("<%=UIUtil.toJavaScript((String) contractsRB.get("contractProductFindPanelTitle"))%>", url, true, urlparm);
}

function gotoBrowseDialog(selectionArray) {
    // save the appropriate array in the model.  it will be used to store
    // user selected categories and items on the finder result set dialog.
    // the array will be reloaded by this panel upon return from the finder.
    // the selected categories/items will be added to the price tc model,
    // and displayed in the option box.
    top.saveData(selectionArray, "browserSelectionArray");

    // save all of the the panel data
    savePanelData();

   // save the contract common data model for use by the browser tree
    var ccdm = parent.get("ContractCommonDataModel",null);
    if (ccdm != null) {
        top.saveData(ccdm, "ccdm");
    }

    // save the price list category selection.  it will be used by the finder
    // to narrow the search results
    top.saveData(null, "priceListCategory");

    // save the model before launching the dialog
    top.saveModel(parent.model);

    // let's go to finder...
    var url="/webapp/wcs/tools/servlet/PriceListProductBrowseDialogView?XMLFile=contract.PriceListProductBrowseDialog";

    top.setReturningPanel("notebookProductConstraints");

    // let's go!
    top.setContent('<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractProductBrowsePanelTitle"))%>', url, true);
}

function addToSelectedPS(aForm, anAvailableBox, aSelectedBox) {
  with (aForm) {
    move(anAvailableBox, aSelectedBox);
    updateSloshBuckets(anAvailableBox,
                       addToSloshBucketButton,
                       aSelectedBox,
                       removeFromSloshBucketButton);
  }
}

function removeFromSelectedPS(aForm, anAvailableBox, aSelectedBox) {
  with (aForm) {
    move(aSelectedBox, anAvailableBox);
    updateSloshBuckets(aSelectedBox,
                       removeFromSloshBucketButton,
                       anAvailableBox,
                       addToSloshBucketButton);
  }
}

///////////////////////////////////////
// MISCELLANEOUS SCRIPTS
///////////////////////////////////////
function getNoSelectionErrorMsg() {
    // this is only here because the function that uses it is in an external .js file and this NLS text
    return "<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingSelectEntryToRemove"))%>";
}

function buildAvailableSloshBuckets(aForm, anAvailableBox, aSelectedBox) {
    // load the available standard product sets
    // only create the available option if it does not already exist in the selected box...
    with (aForm) {

    <%try {
   for (int i = 0; i < policies.length; i++) {
      PolicyDataBean productSetPDB = policies[i];
      if (productSetPDB.getPolicyName().equals("Custom")
         && productSetPDB.getStoreIdentity().equals("-1"))
         continue;

      if (productSetPDB.getProperties() == null)
         continue;%>
         if (! isInTextValueList(aSelectedBox,"<%=productSetPDB.getId()%>")) {
            anAvailableBox.options[anAvailableBox.options.length] = new Option("<%=UIUtil.toJavaScript(productSetPDB.getShortDescription())%>",
                                                                               "<%=productSetPDB.getId()%>",
                                                                               false,
                                                                               false);
         }
   <%} // end for
} // end try
catch (Exception e) {
   System.out.println(e);
}%>

    } // end with
}

function checkForDeletedCustomProductSet(pstc, selections) {
    // assume that the custom product sets have been deleted
    pstc.markedForDelete = true;

    for (i=0;i<selections.length;i++) {
        if (selections[i].refnum != "DELETED") {
            // one of the items/catgroups is not set to delete, so flip the flag
            pstc.markedForDelete = false;
            break;
        }
   }

   return;
}

function handleInclusionCheckbox() {
    var wasUnchecked = ! getCheckboxValue(document.inclusionProductSetForm.inclusionProductSetSwitch);

    if (wasUnchecked &&
        (document.inclusionProductSetForm.selected_ps_si.length>0 ||
        document.inclusionProductSetForm.inclusionCustomProductSetSelection.length>0)) {

        if (confirmDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get(
      "contractPricingConstraintsConfirmUncheckCheckbox"))%>")) {
            // remove all the standard product set definitions
            if (document.inclusionProductSetForm.selected_ps_si.length>0) {
                setItemsSelected(document.inclusionProductSetForm.selected_ps_si);
                removeFromSelectedPS(document.inclusionProductSetForm,
                                     document.inclusionProductSetForm.available_ps_si,
                                     document.inclusionProductSetForm.selected_ps_si);
            }

            // remove all the custom product set definitions
            if (document.inclusionProductSetForm.inclusionCustomProductSetSelection.length>0) {
                setItemsSelected(document.inclusionProductSetForm.inclusionCustomProductSetSelection);
                removeFromMultiSelect(document.inclusionProductSetForm.inclusionCustomProductSetSelection,
                                      document.inclusionProductSetForm.inclusionProductSetRemoveButton,
                                      cpcm.pstc_ci.inclusionCustomProductSetSelection);
            }
        }
        else {
            // reactivate the checkbox and quit
            document.inclusionProductSetForm.inclusionProductSetSwitch.checked = true;
            return;
        }
    }

    showConstraintDivisions();
}

function handleExclusionCheckbox() {
    var wasUnchecked = ! getCheckboxValue(document.exclusionProductSetForm.exclusionProductSetSwitch);

    if (wasUnchecked &&
        (document.exclusionProductSetForm.selected_ps_se.length>0 ||
        document.exclusionProductSetForm.exclusionCustomProductSetSelection.length>0)) {

        if (confirmDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get(
      "contractPricingConstraintsConfirmUncheckCheckbox"))%>")) {
            // remove all the standard product set definitions
            if (document.exclusionProductSetForm.selected_ps_se.length>0) {
                setItemsSelected(document.exclusionProductSetForm.selected_ps_se);
                removeFromSelectedPS(document.exclusionProductSetForm,
                                     document.exclusionProductSetForm.available_ps_se,
                                     document.exclusionProductSetForm.selected_ps_se);
            }

            // remove all the custom product set definitions
            if (document.exclusionProductSetForm.exclusionCustomProductSetSelection.length>0) {
                setItemsSelected(document.exclusionProductSetForm.exclusionCustomProductSetSelection);
                removeFromMultiSelect(document.exclusionProductSetForm.exclusionCustomProductSetSelection,
                                      document.exclusionProductSetForm.exclusionProductSetRemoveButton,
                                      cpcm.pstc_ce.exclusionCustomProductSetSelection);
            }
        }
        else {
            // reactivate the checkbox and quit
            document.exclusionProductSetForm.exclusionProductSetSwitch.checked = true;
            return;
        }
    }

    showConstraintDivisions();
}

function showConstraintDivisions() {
    document.all.exclusionProductSetSwitchDiv.style.display = "block";
    document.all.inclusionProductSetSwitchDiv.style.display = "block";

    document.all.inclusionProductSetDiv.style.display =
         getDivisionStatus(getCheckboxValue(document.inclusionProductSetForm.inclusionProductSetSwitch));
    document.all.exclusionProductSetDiv.style.display =
         getDivisionStatus(getCheckboxValue(document.exclusionProductSetForm.exclusionProductSetSwitch));

    // if both slosh buckets are empty then don't even show the standard product set option!
    if (isListBoxEmpty(document.exclusionProductSetForm.available_ps_se) &&
        isListBoxEmpty(document.exclusionProductSetForm.selected_ps_se)) {
       document.all.exclusionStandardProductSetDiv.style.display = "none";
    }
    else {
       document.all.exclusionStandardProductSetDiv.style.display = "block";
    }

    // if both slosh buckets are empty then don't even show the standard product set option!
    if (isListBoxEmpty(document.inclusionProductSetForm.available_ps_si) &&
        isListBoxEmpty(document.inclusionProductSetForm.selected_ps_si)) {
       document.all.inclusionStandardProductSetDiv.style.display = "none";
    }
    else {
       document.all.inclusionStandardProductSetDiv.style.display = "block";
    }
}


</script>

</head>

<!--
///////////////////////////////////////
// HTML SECTION
///////////////////////////////////////
-->

<body onLoad="onLoad()" class="content">

<h1><%=contractsRB.get("contractPricingConstraintsPanelTitle")%></h1>

<!-- ################################################################################# -->
<!-- EXCLUSION DIVISION -->
<!-- ################################################################################# -->

<form name="exclusionProductSetForm" id="exclusionProductSetForm">

<div id="exclusionProductSetSwitchDiv"
   style="display: block; margin-left: 0">
<table border=0 cellpadding=0 cellspacing=0 width="100%"
   id="ContractProductConstraintsPanel_Table_1">
   <tr>
      <td width="0" id="ContractProductConstraintsPanel_TableCell_1"></td>
      <td width="20" align="left"
         id="ContractProductConstraintsPanel_TableCell_2"><input type=checkbox
         name=exclusionProductSetSwitch VALUE=1
         onClick='handleExclusionCheckbox();'
         id="ContractProductConstraintsPanel_FormInput_1"></td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_3"><label for="ContractProductConstraintsPanel_FormInput_1"><%=contractsRB.get("contractPricingConstraintsExclusionProductSetLabel")%></label></td>
   </tr>
</table>
</div>

<div id="exclusionProductSetDiv" style="display: block; margin-left: 0">
<p>
<div id="exclusionStandardProductSetDiv"
   style="display: block; margin-left: 0"><!-- ################################################################################# -->
<!-- STANDARD EXCLUSION --> <!-- ################################################################################# -->
<table border=0 cellpadding=0 cellspacing=0 width="80%"
   id="ContractProductConstraintsPanel_Table_2">
   <tr valign="top">
      <td width="10" id="ContractProductConstraintsPanel_TableCell_4"></td>
      <td width="20" id="ContractProductConstraintsPanel_TableCell_5">&nbsp;&nbsp;</td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_6"><%=contractsRB.get("contractPricingConstraintsContractOptimizedCategories")%><br>
      <table border=0 cellpadding=0 cellspacing=0
         id="ContractProductConstraintsPanel_Table_3">
         <tr valign="top">
            <td width=210 id="ContractProductConstraintsPanel_TableCell_7"></td>
            <td width=150 id="ContractProductConstraintsPanel_TableCell_8"></td>
            <td width=10 id="ContractProductConstraintsPanel_TableCell_9"></td>
            <td width=210 id="ContractProductConstraintsPanel_TableCell_10"></td>
         </tr>
         <tr>
            <td VALIGN="BOTTOM" ALIGN="LEFT" CLASS="sloshBucketWidth"
               id="ContractProductConstraintsPanel_TableCell_11"><label for="ContractProductConstraintsPanel_FormInput_selected_ps_se_In_exclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsExclusionSelectedProductSets")%></label><br>
            <select NAME="selected_ps_se" TABINDEX="1" CLASS="sloshBucketWidth"
               SIZE="5" MULTIPLE
               id="ContractProductConstraintsPanel_FormInput_selected_ps_se_In_exclusionProductSetForm_1"
               onChange="javascript:updateSloshBuckets(this, document.exclusionProductSetForm.removeFromSloshBucketButton, document.exclusionProductSetForm.available_ps_se, document.exclusionProductSetForm.addToSloshBucketButton);">
            </select></td>
            <td WIDTH=150px ALIGN=CENTER
               id="ContractProductConstraintsPanel_TableCell_12">
            <table cellpadding="2" cellspacing="2">
            <tr><td>
            <input TYPE="button" TABINDEX="4" STYLE="width: 120px"
               NAME="addToSloshBucketButton" CLASS=enabled
               VALUE="  <%=UIUtil.toJavaScript(contractsRB.get("GeneralSloshBucketAdd"))%>  "
               ONCLICK="addToSelectedPS(this.form, available_ps_se, selected_ps_se)"
               id="ContractProductConstraintsPanel_FormInput_2" >
            </td></tr>
            <tr><td>
            <input TYPE="button" TABINDEX="2" STYLE="width: 120px" CLASS=enabled
               NAME="removeFromSloshBucketButton"
               VALUE="  <%=UIUtil.toJavaScript(contractsRB.get("GeneralSloshBucketRemove"))%>  "
               ONCLICK="removeFromSelectedPS(this.form, available_ps_se, selected_ps_se)"
               id="ContractProductConstraintsPanel_FormInput_3">
              </td></tr>
              </table>
            </td>
            <td width=10 id="ContractProductConstraintsPanel_TableCell_13"></td>
            <td VALIGN="BOTTOM" ALIGN="LEFT" CLASS="sloshBucketWidth"
               id="ContractProductConstraintsPanel_TableCell_14"><label for="ContractProductConstraintsPanel_FormInput_available_ps_se_In_exclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsExclusionAvailableProductSets")%></label><br>
            <select NAME="available_ps_se" TABINDEX="3" CLASS="sloshBucketWidth"
               SIZE="5" MULTIPLE
               id="ContractProductConstraintsPanel_FormInput_available_ps_se_In_exclusionProductSetForm_1"
               onChange="javascript:updateSloshBuckets(this, document.exclusionProductSetForm.addToSloshBucketButton, document.exclusionProductSetForm.selected_ps_se, document.exclusionProductSetForm.removeFromSloshBucketButton);">
            </select></td>
         </tr>
      </table>
      </td>
   </tr>
</table>
<p>
</div>

<table border=0 cellpadding=0 cellspacing=0 width="80%"
   id="ContractProductConstraintsPanel_Table_4">
   <tr valign="top">
      <td width="10" id="ContractProductConstraintsPanel_TableCell_15"></td>
      <td width="20" id="ContractProductConstraintsPanel_TableCell_16">&nbsp;&nbsp;</td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_17">
      <table border=0 cellpadding=0 cellspacing=0
         id="ContractProductConstraintsPanel_Table_5">
         <tr>
            <td id="ContractProductConstraintsPanel_TableCell_18"></td>
            <td id="ContractProductConstraintsPanel_TableCell_19"></td>
            <td id="ContractProductConstraintsPanel_TableCell_20"></td>
         </tr>
         <tr>
            <td valign="top" colspan=2
               id="ContractProductConstraintsPanel_TableCell_21"><label for="ContractProductConstraintsPanel_FormInput_exclusionCustomProductSetSelection_In_exclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsExcludedCategoriesAndItems")%></label><br>
            </td>
            <td id="ContractProductConstraintsPanel_TableCell_22"></td>
         </tr>
         <tr valign="top">
            <td valign="top" id="ContractProductConstraintsPanel_TableCell_23">
            <select name="exclusionCustomProductSetSelection"
               id="ContractProductConstraintsPanel_FormInput_exclusionCustomProductSetSelection_In_exclusionProductSetForm_1"
               class='selectWidth' multiple size=5
               onChange="javascript:setButtonContext(this, document.exclusionProductSetForm.exclusionProductSetRemoveButton);">
            </select></td>
            <td width=10px id="ContractProductConstraintsPanel_TableCell_24">&nbsp;</td>
            <td width=110px valign="top"
               id="ContractProductConstraintsPanel_TableCell_25">
            <table cellpadding="2" cellspacing="2">
            <tr><td>
            <button type='BUTTON' value='exclusionProductSetFindButton'
               name='exclusionProductSetFindButton' style="width: 110px"
               CLASS=enabled
               onClick='gotoSearchDialog(cpcm.pstc_ce.exclusionCustomProductSetSelection);'><%=contractsRB.get("findElipsis")%></button>
            </td></tr>
            <tr><td>
            <button type='BUTTON' value='exclusionProductSetBrowseButton'
               name='exclusionProductSetBrowseButton' style="width: 110px"
               CLASS=enabled
               onClick='gotoBrowseDialog(cpcm.pstc_ce.exclusionCustomProductSetSelection);'><%=contractsRB.get("browseElipsis")%></button>
            </td></tr>
            <tr><td>
            <button type='BUTTON' value='exclusionProductSetRemoveButton'
               name='exclusionProductSetRemoveButton' style="width: 110px"
               CLASS=enabled
               onClick='removeFromMultiSelect(this.form.exclusionCustomProductSetSelection, this, cpcm.pstc_ce.exclusionCustomProductSetSelection);'><%=contractsRB.get("remove")%></button>
              </td></tr>
              </table>
            </td>
         </tr>
      </table>
      </td>
   </tr>
</table>
</div>

</form>


<!-- ################################################################################# -->
<!-- INCLUSION DIVISION -->
<!-- ################################################################################# -->

<form name="inclusionProductSetForm" id="inclusionProductSetForm">

<div id="inclusionProductSetSwitchDiv"
   style="display: block; margin-left: 0">
<table border=0 cellpadding=0 cellspacing=0 width="100%"
   id="ContractProductConstraintsPanel_Table_6">
   <tr>
      <td width="0" id="ContractProductConstraintsPanel_TableCell_26"></td>
      <td width="20" align="left"
         id="ContractProductConstraintsPanel_TableCell_27"><input
         type=checkbox name=inclusionProductSetSwitch VALUE=1
         onClick='handleInclusionCheckbox();'
         id="ContractProductConstraintsPanel_FormInput_4"></td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_28"><label for="ContractProductConstraintsPanel_FormInput_4"><%=contractsRB.get("contractPricingConstraintsInclusionProductSetLabel")%></label></td>
   </tr>
</table>
</div>

<div id="inclusionProductSetDiv" style="display: block; margin-left: 0">
<p>

<div id="inclusionStandardProductSetDiv"
   style="display: block; margin-left: 0"><!-- ################################################################################# -->
<!-- STANDARD INCLUSION --> <!-- ################################################################################# -->
<table border=0 cellpadding=0 cellspacing=0 width="80%"
   id="ContractProductConstraintsPanel_Table_7">
   <tr valign="top">
      <td width="10" id="ContractProductConstraintsPanel_TableCell_29"></td>
      <td width="20" id="ContractProductConstraintsPanel_TableCell_30">&nbsp;&nbsp;</td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_31"><%=contractsRB.get("contractPricingConstraintsContractOptimizedCategories")%><br>
      <table border=0 cellpadding=0 cellspacing=0
         id="ContractProductConstraintsPanel_Table_8">
         <tr valign="top">
            <td width=210 id="ContractProductConstraintsPanel_TableCell_32"></td>
            <td width=150 id="ContractProductConstraintsPanel_TableCell_33"></td>
            <td width=10 id="ContractProductConstraintsPanel_TableCell_34"></td>
            <td width=210 id="ContractProductConstraintsPanel_TableCell_35"></td>
         </tr>
         <tr>
            <td VALIGN="BOTTOM" ALIGN="LEFT" CLASS="sloshBucketWidth"
               id="ContractProductConstraintsPanel_TableCell_36"><label for="ContractProductConstraintsPanel_FormInput_selected_ps_si_In_inclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsInclusionSelectedProductSets")%></label><br>
            <select NAME="selected_ps_si" TABINDEX="1" CLASS="sloshBucketWidth"
               id="ContractProductConstraintsPanel_FormInput_selected_ps_si_In_inclusionProductSetForm_1"
               SIZE="5" MULTIPLE
               onChange="javascript:updateSloshBuckets(this, document.inclusionProductSetForm.removeFromSloshBucketButton, document.inclusionProductSetForm.available_ps_si, document.inclusionProductSetForm.addToSloshBucketButton);">
            </select></td>
            <td WIDTH=150px ALIGN=CENTER
               id="ContractProductConstraintsPanel_TableCell_37">
            <table cellpadding="2" cellspacing="2">
            <tr><td>
            <input TYPE="button" TABINDEX="4" STYLE="width: 120px"
               NAME="addToSloshBucketButton" CLASS=enabled
               VALUE="  <%=UIUtil.toJavaScript(contractsRB.get("GeneralSloshBucketAdd"))%>  "
               ONCLICK="addToSelectedPS(this.form, available_ps_si, selected_ps_si)"
               id="ContractProductConstraintsPanel_FormInput_5">
            </td></tr>
            <tr><td>
            <input TYPE="button" TABINDEX="2" STYLE="width: 120px" CLASS=enabled
               NAME="removeFromSloshBucketButton"
               VALUE="  <%=UIUtil.toJavaScript(contractsRB.get("GeneralSloshBucketRemove"))%>  "
               ONCLICK="removeFromSelectedPS(this.form, available_ps_si, selected_ps_si)"
               id="ContractProductConstraintsPanel_FormInput_6">
              </td></tr>
              </table>
            </td>
            <td width=10 id="ContractProductConstraintsPanel_TableCell_38"></td>
            <td VALIGN="BOTTOM" ALIGN="LEFT" CLASS="sloshBucketWidth"
               id="ContractProductConstraintsPanel_TableCell_39"><label for="ContractProductConstraintsPanel_FormInput_available_ps_si_In_inclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsInclusionAvailableProductSets")%></label><br>
            <select NAME="available_ps_si" TABINDEX="3" CLASS="sloshBucketWidth"
               SIZE="5" MULTIPLE
               id="ContractProductConstraintsPanel_FormInput_available_ps_si_In_inclusionProductSetForm_1"
               onChange="javascript:updateSloshBuckets(this, document.inclusionProductSetForm.addToSloshBucketButton, document.inclusionProductSetForm.selected_ps_si, document.inclusionProductSetForm.removeFromSloshBucketButton);">
            </select></td>
         </tr>
      </table>
      </td>
   </tr>
</table>
<p>
</div>

<table border=0 cellpadding=0 cellspacing=0 width="80%"
   id="ContractProductConstraintsPanel_Table_9">
   <tr valign="top">
      <td width="10" id="ContractProductConstraintsPanel_TableCell_40"></td>
      <td width="20" id="ContractProductConstraintsPanel_TableCell_41">&nbsp;&nbsp;</td>
      <td width="600" align="left"
         id="ContractProductConstraintsPanel_TableCell_42">
      <table border=0 cellpadding=0 cellspacing=0
         id="ContractProductConstraintsPanel_Table_10">
         <tr>
            <td id="ContractProductConstraintsPanel_TableCell_43"></td>
            <td id="ContractProductConstraintsPanel_TableCell_44"></td>
            <td id="ContractProductConstraintsPanel_TableCell_45"></td>
         </tr>
         <tr>
            <td valign="top" colspan=2
               id="ContractProductConstraintsPanel_TableCell_46"><label for="ContractProductConstraintsPanel_FormInput_inclusionCustomProductSetSelection_In_inclusionProductSetForm_1"><%=contractsRB.get("contractPricingConstraintsIncludedCategoriesAndItems")%></label><br>
            </td>
         </tr>
         <tr valign="top">
            <td valign="top" id="ContractProductConstraintsPanel_TableCell_47">
            <select name="inclusionCustomProductSetSelection"
               id="ContractProductConstraintsPanel_FormInput_inclusionCustomProductSetSelection_In_inclusionProductSetForm_1"
               class='selectWidth' multiple size=5
               onChange="javascript:setButtonContext(this, document.inclusionProductSetForm.inclusionProductSetRemoveButton);">
            </select></td>
            <td width=10px id="ContractProductConstraintsPanel_TableCell_48">&nbsp;</td>
            <td width=110px valign="top" align="center"
               id="ContractProductConstraintsPanel_TableCell_49">
            <table cellpadding="2" cellspacing="2">
            <tr><td>
            <button type='BUTTON' value='inclusionProductSetFindButton'
               name='inclusionProductSetFindButton' style="width: 110px"
               CLASS=enabled
               onClick='gotoSearchDialog(cpcm.pstc_ci.inclusionCustomProductSetSelection);'><%=contractsRB.get("findElipsis")%></button>
            </td></tr>
            <tr><td>
            <button type='BUTTON' value='inclusionProductSetBrowseButton'
               name='inclusionProductSetBrowseButton' style="width: 110px"
               CLASS=enabled
               onClick='gotoBrowseDialog(cpcm.pstc_ci.inclusionCustomProductSetSelection);'><%=contractsRB.get("browseElipsis")%></button>
            </td></tr>
            <tr><td>
            <button type='BUTTON' value='inclusionProductSetRemoveButton'
               name='inclusionProductSetRemoveButton' style="width: 110px"
               CLASS=enabled
               onClick='removeFromMultiSelect(this.form.inclusionCustomProductSetSelection, this, cpcm.pstc_ci.inclusionCustomProductSetSelection);'><%=contractsRB.get("remove")%></button>
              </td></tr>
              </table>
            </td>
         </tr></table>
      </td>
   </tr>
</table>
</div>

</form>


</body>
</html>


