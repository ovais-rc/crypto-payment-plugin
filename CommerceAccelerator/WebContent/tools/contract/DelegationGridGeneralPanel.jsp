<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2017 All Rights Reserved.

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
   com.ibm.commerce.ejb.helpers.SessionBeanHelper,
   com.ibm.commerce.common.objects.StoreRelationshipJDBCHelperBean,
   com.ibm.commerce.tools.contract.beans.ProductSetTCDataBean,
   com.ibm.commerce.tools.contract.beans.ContractListDataBean,
   com.ibm.commerce.tools.contract.beans.AccountListDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.user.objects.MemberGroupAccessBean,   
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.contract.beans.ContractDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   String contractName = null;
   String contractReference = null;
   boolean doesNotHaveContractReference = false;
   ContractDataBean contract = null;
   
   String contractFamilyId = "";

   if (foundContractId) {
      contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
      DataBeanManager.activate(contract, request);

      contractFamilyId = contract.getFamilyId();
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
 <style type='text/css'>
 .selectWidth {width: 200px;}
 </style> 
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("delegationGridGeneralPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
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

function showContractGeneralFormDivisions()
 {
  with (document.generalForm)
   {
      contractGeneralFormDiv.style.display = "block";
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
        var o2 = parent.get("ContractBuyerModel", null);
   if (o != null && o2 != null) {
      loadValue(Name, o.name);
      loadValue(Title, o.title);
      loadTextValueSelectValues(SelectedMemberGroups, o2.selectedMemberGroups);
      loadTextValueSelectValues(AvailableMemberGroups, o2.availableMemberGroups);

      baseDelegationGridSwitch.checked = o.BaseDelegationGridChecked;
      if (<%= foundContractId %> == true) {
	// disable base delegation selection on update
	baseDelegationGridSwitch.disabled = true;      
      }
      
      refSelected = o.contractReferenceSelected;
      <% if (doesNotHaveContractReference == true) { %>
         ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridReferenceListOne"))%>", "0", true, true);
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
   var cbm = new ContractBuyerModel();        
   parent.put("ContractGeneralModel", cgm);
   parent.put("ContractGeneralModelLoaded", true);
   parent.put("ContractBuyerModel", cbm);
   parent.put("ContractBuyerModelLoaded", true);   

   cgm.usage = "DelegationGrid";
   cgm.origin = "Deployment";
   cgm.StartImmediateChecked = true;
   cgm.endNeverExpires = true;
   
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

   parent.put("baseContract", false);
   var contractPanel = parent.pageArray["delegationGridCatalogFilterTitle"];
   contractPanel.parms[contractPanel.parms.length] = "baseContract";

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
         out.println("cgm.lastUpdateTime = \"" + contract.getUpdateDate() + "\";");
         out.println("Name.value = \"" + UIUtil.toHTML((String)contract.getContractName()) + "\";");
         contractName = UIUtil.toHTML((String)contract.getContractName());

         out.println("Title.value = \"" + UIUtil.toJavaScript((String)contract.getContractTitle()) + "\";");

         out.println("cgm.majorVersionNumber = \"" +  contract.getMajorVersionNumber() + "\";");
         out.println("cgm.minorVersionNumber = \"" +  contract.getMinorVersionNumber() + "\";");
         out.println("cgm.origin = \"" +  contract.getContractOrigin() + "\";");
         out.println("cgm.usage = \"" +  contract.getContractUsage() + "\";");
         out.println("cgm.creditLineAllowed = " +  contract.getCreditLineAllowed() + ";");
         out.println("cgm.remarks = \"" + UIUtil.toJavaScript((String)contract.getContractComment()) + "\";");

         out.println("ccdm.contractHasInclusionExclusionTCs = false;");
         
         int mbrGrpSize = contract.getMemberGroupName("ServiceRepresentative").size();
         if (mbrGrpSize == 0) {
              // no participants, so this is a base delegation grid
	%>
		baseDelegationGridSwitch.checked = true;
	<% } %>
	// disable base delegation selection on update
	baseDelegationGridSwitch.disabled = true;
	<%
         for (int i = 0; i < mbrGrpSize; i++) {
            out.println("SelectedMemberGroups.options[" + i + "] = new Option(\"" +
               UIUtil.toJavaScript(contract.getMemberGroupName(i)) + "\",\"" +
               contract.getMemberGroupId(i) + "\", false, false);");
            out.println("cbm.contractMemberGroups[" + i + "] = new Object();");
            out.println("cbm.contractMemberGroups[" + i + "].value = '" + contract.getMemberGroupId(i) + "';");
            out.println("cbm.contractMemberGroups[" + i + "].text = '" + UIUtil.toJavaScript(contract.getMemberGroupName(i)) + "';");
         }         
      }
      %>
   } // end if update contract mode 1st time load
   else { // new contract 1st time load

                         
   }
   
   // initialize available member groups
   count = 0;
   <%
    try {
      Vector memberGroupTypes = new Vector();
      memberGroupTypes.add(MemberDataBean.PRICE_OVERRIDE_MEMBER_GROUP);
      Vector list = new MemberDataBean().getMemberGroups(memberGroupTypes);
            if (list != null && list.size() > 0)
            {
               for (int loop = 0; loop < list.size(); loop++) {
         Vector row = (Vector)list.elementAt(loop);
            String memberGroupName = row.elementAt(0).toString();
            String memberGroupOwnerId = row.elementAt(1).toString();
            String memberGroupId = row.elementAt(2).toString();
            MemberDataBean _mbrGrpOwner = new MemberDataBean();
         _mbrGrpOwner.setId(memberGroupOwnerId);
         _mbrGrpOwner.populate();
   %>
      // add the member group to the available list
      if (!isInTextValueList(SelectedMemberGroups, "<%= UIUtil.toJavaScript(memberGroupId) %>")) {
         AvailableMemberGroups.options[count++] = new Option("<%= UIUtil.toJavaScript(memberGroupName) %>", "<%= UIUtil.toJavaScript(memberGroupId) %>", false, false);
      }
      cbm.MemberGroupOwners['<%= memberGroupId %>'] =
                   new Member('<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupOwnerMemberDN()) %>');
   <%
         } // end for
      } // end if
     } catch (Exception e)
      {
      out.println(e);
      }
    %>
                                                  
   var contractRefList = new Array();
   var descriptionArray = new Array();   

   <% if (doesNotHaveContractReference == true) { %>
      ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridReferenceListOne"))%>", "0", true, true);
   <% } else { %>
      ContractReference.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("keepExistingReference"))%>", "0", false, false);
   <% } %>
   descriptionArray[0] = new Object();
   descriptionArray[0].store = "";

   <%
   // get base delegation grids - have no ServiceRepresentative participants
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
     StoreAccessBean storeABRel = com.ibm.commerce.server.WcsApp.storeRegistry.find(relatedStores[rel]);   
     //System.out.println("relatedStore " + relatedStores[rel].toString());
           ContractListDataBean contractListFromStore =
            new ContractListDataBean(new Long(-1), fLanguageId, "name", "ActivatedList", relatedStores[rel].toString(), ECContractConstants.EC_CONTRACT_USAGE_TYPE_DELEGATION_GRID.intValue() );
           contractListFromStore.setUseCursor(false);
           contractListFromStore.setRequestProperties(contractCommandContext.getRequestProperties());
           contractListFromStore.setCommandContext(contractCommandContext);
           contractListFromStore.populate();
           ContractDataBean contractsFromStore[]  = contractListFromStore.getContractList();

           if (contractsFromStore != null) {
 		//System.out.println("contractsFromStore " + contractsFromStore.length);           
             for (int cLoop = 0; cLoop < contractsFromStore.length; cLoop++) {
            ContractDataBean cdb = contractsFromStore[cLoop];
            Vector sr = cdb.getMemberGroupName("ServiceRepresentative");   
              
            if ((sr == null || sr.size() == 0) && cdb.getFamilyId().equals(contractFamilyId) == false) {   
            	// no ServiceRepresentative role, so this is a base grid      
                 MemberDataBean mdb = new MemberDataBean();
               mdb.setId(cdb.getMemberId().toString());
               mdb.setRequestProperties(contractCommandContext.getRequestProperties());
               mdb.setCommandContext(contractCommandContext);
               mdb.populate();
   %>
		var toAdd = contractRefList.length + 1;
            contractRefList[contractRefList.length] = new ContractReferenceElement('<%= UIUtil.toJavaScript(cdb.getContractName()) %>',
                          '<%= cdb.getContractOrigin() %>',
                          '<%= cdb.getMajorVersionNumber() %>',
                          '<%= cdb.getMinorVersionNumber() %>',
                          '<%= mdb.getMemberType() %>',
                                                       '<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>',
                                                        '<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>',
                                                            '<%= mdb.getMemberGroupOwnerMemberType() %>',
                                                             '<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>',
                                                             '<%= cdb.getContractId() %>');

            if ("<%= contractReference %>" == "<%= cdb.getContractId() %>") {
               refSelected = toAdd;
               ContractReference.options[toAdd] = new Option("<%= UIUtil.toJavaScript(cdb.getContractName()) %>",
                              toAdd, true, true);
            } else {
               ContractReference.options[toAdd] = new Option("<%= UIUtil.toJavaScript(cdb.getContractName()) %>",
                              toAdd, false, false);
            }
            descriptionArray[toAdd] = new Object();
            descriptionArray[toAdd].store = "<%= UIUtil.toJavaScript(storeABRel.getIdentifier()) %>";

   <%         } // has ServiceRep participant
           } // end cLoop
     } // end if contractsFromStore
   } // end for
   } catch (Exception e) {
      System.out.println(e);
   } %>
        cgm.contractReferenceList = contractRefList;
        cgm.descriptionArray = descriptionArray;        


     } // end else first time to this page

    showContractGeneralFormDivisions();
    BaseGridDivision();

    if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
    }

    // handle error messages back from the validate page
    if (parent.get("contractNameRequired", false))
     {
      parent.remove("contractNameRequired");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridNameRequired"))%>");
      Name.focus();
     }
    else if (parent.get("contractNameTooLong", false))
     {
      parent.remove("contractNameTooLong");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridNameTooLong"))%>");
      Name.focus();
     }
    else if (parent.get("contractTitleRequired", false))
     {
      parent.remove("contractTitleRequired");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridTitleRequired"))%>");
      Title.focus();
     }
    else if (parent.get("contractTitleTooLong", false))
     {
      parent.remove("contractTitleTooLong");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridTitleTooLong"))%>");
      Title.focus();
     }
    else if (parent.get("contractExists", false))
     {
      parent.remove("contractExists");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridExists"))%>");
      Name.focus();
     }
    else if (parent.get("contractMarkForDelete", false))
     {
      parent.remove("contractMarkForDelete");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridMarkedForDeleteError"))%>");
      Name.focus();
     }
    else if (parent.get("contractHasBeenChanged", false))
     {
      parent.remove("contractHasBeenChanged");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridChanged"))%>");
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridNotSaved"))%>");
      Title.focus();
     }
    else if (parent.get("memberGroupRequired", false))
     {
      parent.remove("memberGroupRequired");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridMemberGroupRequired"))%>");
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

   initializeSloshBuckets(SelectedMemberGroups,
                             removeFromSloshBucketMbrGrpButton,
                             AvailableMemberGroups,
                             addToSloshBucketMbrGrpButton);
                             
    } // end if parent.get
   } // end with
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
               o.contractReferenceSelected = ContractReference.selectedIndex;
               o.BaseDelegationGridChecked = baseDelegationGridSwitch.checked;               
        }
        var o2 = parent.get("ContractBuyerModel", null);
        if (o2 != null) {
           o2.selectedMemberGroups = getTextValueSelectValues(SelectedMemberGroups);
           o2.availableMemberGroups = getTextValueSelectValues(AvailableMemberGroups);
        }        
        var ccdm = parent.get("ContractCommonDataModel", null);
        if (ccdm != null) {
      if (o.contractReferenceSelected == "0") {
         ccdm.referenceNumber = "";
      } else {
         ccdm.referenceNumber = o.contractReferenceList[o.contractReferenceSelected - 1].id;
      }
      parent.put("base_contract_id", ccdm.referenceNumber);
      var contractPanel = parent.pageArray["delegationGridCatalogFilterTitle"];
      contractPanel.parms[contractPanel.parms.length] = "base_contract_id";
      var contractPanel2 = parent.pageArray["delegationGridShippingChargesTitle"];
      contractPanel2.parms[contractPanel2.parms.length] = "base_contract_id";         
        }
     }
   }
 }

function getDivisionStatus(aSwitch) {
    return (aSwitch == true || aSwitch != 0) ? "none" : "block";
}

function BaseGridDivision() {

  with (document.generalForm)
   {
   contractBaseGridFormDiv.style.display = getDivisionStatus(baseDelegationGridSwitch.checked);
   }
}

function addToSelectedMemberGroups()
 {
  with (document.generalForm)
   {
    move(AvailableMemberGroups, SelectedMemberGroups);
    updateSloshBuckets(AvailableMemberGroups,
                       addToSloshBucketMbrGrpButton,
                       SelectedMemberGroups,
                       removeFromSloshBucketMbrGrpButton);
   }
 }

function removeFromSelectedMemberGroups()
 {
  with (document.generalForm)
   {
    move(SelectedMemberGroups, AvailableMemberGroups);
    updateSloshBuckets(SelectedMemberGroups,
                       removeFromSloshBucketMbrGrpButton,
                       AvailableMemberGroups,
                       addToSloshBucketMbrGrpButton);
   }
 }
 
function displayDescription(){
        var o = parent.get("ContractGeneralModel", null);
        if (o != null) {
      var descriptionText = null;
      if(o.descriptionArray.length > 0){
         descriptionText = '&nbsp;&nbsp;<%=UIUtil.toJavaScript((String)contractsRB.get("delegationGridReferenceInformation"))%><br>' +
               '&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toJavaScript((String)contractsRB.get("storeName"))%>&nbsp;' +
               '<i>' + o.descriptionArray[document.getElementById("ContractReference").selectedIndex].store + '</i>';
      }
      if(descriptionText != null && descriptionText != 'null' && document.getElementById("ContractReference").selectedIndex != 0){
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

<h1><%= contractsRB.get("delegationGridGeneralPanelPrompt") %></h1>

<form NAME="generalForm" id="generalForm">

<div id="contractGeneralFormDiv" style="display: none; margin-left: 0">

<% if (foundContractId) { %>
   <p><%= contractsRB.get("delegationGridNameDisplay") %> <i><%= contractName %></i>
   <input NAME="Name" TYPE="HIDDEN" VALUE="" id="ContractGeneralPanel_FormInput_Name_In_generalForm_1">
<% } else { %>
   <p><label for="ContractGeneralPanel_FormInput_Name_In_generalForm_2"><%= contractsRB.get("delegationGridNamePrompt") %></label><br>
   <input NAME="Name" TYPE="TEXT" size=30 maxlength=200 id="ContractGeneralPanel_FormInput_Name_In_generalForm_2">
<% } %>

<p><label for="ContractGeneralPanel_FormInput_Title_In_generalForm_1"><%= contractsRB.get("delegationGridTitlePrompt") %></label><br>
<input NAME="Title" TYPE="TEXT" size=30 maxlength=254 id="ContractGeneralPanel_FormInput_Title_In_generalForm_1">

<br><br>

<input type=checkbox name=baseDelegationGridSwitch onClick='BaseGridDivision();' id="ContractOrderApprovalPanel_FormInput_orderApprovalRequiredSwitch_In_orderApprovalRequiredSwitchForm_1">
<label for="ContractOrderApprovalPanel_FormInput_orderApprovalRequiredSwitch_In_orderApprovalRequiredSwitchForm_1"><%= contractsRB.get("delegationGridBaseGridSwitchLabel") %></label>

<br><br>
       
<div id="contractBaseGridFormDiv" style="display: none; margin-left: 30">

<label for="ContractBuyerPanel_FormInput_delegationGridEntitledGroups_In_generalForm_1"><%= contractsRB.get("delegationGridEntitledGroups") %></label><br>
<table border=0 id="ContractBuyerPanel_Table_1">
 <tr>
  <td width=160 id="ContractBuyerPanel_TableCell_1"></td>
  <td width=70 id="ContractBuyerPanel_TableCell_2"></td>
  <td width=10 id="ContractBuyerPanel_TableCell_3"></td>
  <td width=160 id="ContractBuyerPanel_TableCell_4"></td>
 </tr>
 <tr>
  <td valign='top' id="ContractBuyerPanel_TableCell_13">
    <label for="ContractBuyerPanel_FormInput_SelectedMemberGroups_In_generalForm_1"><%= contractsRB.get("contractMemberGroupSelected") %></label><br>
    <select NAME="SelectedMemberGroups" id="ContractBuyerPanel_FormInput_SelectedMemberGroups_In_generalForm_1" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.generalForm.removeFromSloshBucketMbrGrpButton, document.generalForm.AvailableMemberGroups, document.generalForm.addToSloshBucketMbrGrpButton);">
    </select>
  </td>
  <td width=100px id="ContractBuyerPanel_TableCell_14">
   <table cellpadding="2" cellspacing="2">
   <tr><td>
    <INPUT TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketMbrGrpButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedMemberGroups()">
   </td></tr>
   <tr><td>              
    <INPUT TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketMbrGrpButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedMemberGroups()">
   </td></tr>
   </table>                 
  </td>
  <td width=10 id="ContractBuyerPanel_TableCell_15"></td>
  <td valign='top' id="ContractBuyerPanel_TableCell_16">
    <label for="ContractBuyerPanel_FormInput_AvailableMemberGroups_In_generalForm_1"><%= contractsRB.get("contractMemberGroupAvailable") %></label><br>
    <select NAME="AvailableMemberGroups" id="ContractBuyerPanel_FormInput_AvailableMemberGroups_In_generalForm_1" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.generalForm.addToSloshBucketMbrGrpButton, document.generalForm.SelectedMemberGroups, document.generalForm.removeFromSloshBucketMbrGrpButton);">
    </select>
  </td>
 </tr>
</table>

   <label for="ContractGeneralPanel_FormInput_ContractReference_In_generalForm_1"><%= contractsRB.get("delegationGridReferenceTitle") %></label><br>
   <select NAME="ContractReference" id="ContractGeneralPanel_FormInput_ContractReference_In_generalForm_1" TABINDEX="1" SIZE="1" onchange="displayDescription();">
   </select>
   <!-- The empty DIV below is used to insert dynamically the contract reference description -->
   <div id="contractRefDesc">
   </div>
</div><!-- ContractBaseGridFormDiv -->

</div><!-- ContractGeneralFormDiv -->

</form>
</body>
</html>


