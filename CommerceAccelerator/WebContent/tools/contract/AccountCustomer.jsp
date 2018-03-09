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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.common.objects.StoreAccessBean,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.user.beans.OrganizationDataBean,
      com.ibm.commerce.user.beans.UserDataBean,
      com.ibm.commerce.tools.contract.beans.AccountDataBean,
      com.ibm.commerce.user.beans.AddressDataBean,
      com.ibm.commerce.tools.contract.beans.AddressListDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

 <title><%= contractsRB.get("accountCustomerPanelTitle") %></title>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Vector.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/contract/Account.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script type="text/javascript" language="JavaScript">

  // This function creates the AccountCommonDataModel
  function loadCommonDataModel() {
    var acdm = new AccountCommonDataModel();
    parent.put("AccountCommonDataModel", acdm);

    <%
    try {
      OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
      OrgEntityDB.setDataBeanKeyMemberId(fStoreMemberId.toString());
      OrgEntityDB.setCommandContext(contractCommandContext);
      OrgEntityDB.populate();
      //DataBeanManager.activate(OrgEntityDB, request);
      String DN = OrgEntityDB.getDistinguishedName(); %>
      acdm.storeMemberId = "<%= fStoreMemberId %>";
      acdm.storeMemberDN = "<%= UIUtil.toJavaScript(DN) %>";
      acdm.storeId = <%= fStoreId %>;
      acdm.flanguageId = "<%= fLanguageId %>";
      acdm.fLocale = "<%= fLocale %>";
      acdm.storeIdentity = "<%=UIUtil.toJavaScript(fStoreIdentity)%>";
    <%
    } catch (Exception e) {
    }
    %>
  }

  // This function checks if the account customer page is an update
  function checkForUpdate(acm, arm) {
    // check if this is an update
    <%
      if (foundAccountId) {
         AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
         DataBeanManager.activate(account, request);
    %>
   // put data to the AccountCustomerModel
   acm.referenceNumber = "<%= accountId %>";
   acm.lastUpdateTime = "<%= account.getUpdateDate() %>";
   <%
   try {
      OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
      OrgEntityDB.setDataBeanKeyMemberId(account.getCustomerId().toString());
      OrgEntityDB.setCommandContext(contractCommandContext);
      OrgEntityDB.populate();
      //DataBeanManager.activate(OrgEntityDB, request);
      String DN = OrgEntityDB.getDistinguishedName(); %>
      acm.org = "<%=account.getCustomerId()%>";
      acm.orgDN = "<%=UIUtil.toJavaScript(DN)%>";
      acm.initialOrg = acm.org;
      acm.initalOrgDN = acm.orgDN;
      <%
      String accountRemarks = account.getAccountRemarks();
      if (accountRemarks == null)
        accountRemarks=new String("");
      %>
      acm.remarks = "<%=UIUtil.toJavaScript((String)accountRemarks)%>";

   <%
   } catch (Exception e) {
   } %>

   <% if (account.getCustomerContactId() != null) { %>
   <% try {
         UserDataBean UserDB = new UserDataBean();
            UserDB.setDataBeanKeyMemberId(account.getCustomerContactId().toString());
            UserDB.setCommandContext(contractCommandContext);
            UserDB.populate();
            //DataBeanManager.activate(UserDB, request);
            String DN = (UserDB.getDistinguishedName().toString()).trim(); %>
            acm.contact = "<%=account.getCustomerContactId()%>";
            acm.contactDN = "<%=UIUtil.toJavaScript(DN)%>";
               acm.initialContact = acm.contact;
            acm.initialContactDN = acm.contactDN;
   <%       } catch (Exception e) {
            } %>
         <% } %>

   acm.info = decodeNewLines('<%=UIUtil.toJavaScript((String)account.getCustomerContactInformation())%>');
   <% if (account.getAllowCatalogPurchases()) { %>
            acm.allowPurchase = true;
         <% } %>
        acm.accountName = "<%=UIUtil.toJavaScript((String)account.getAccountName())%>";
        acm.priceListType = "<%=UIUtil.toJavaScript((String)account.getPriceListPreference())%>";
        <% if (account.getMustUsePriceListPreference()) { %>
            acm.mustUsePriceListPreference = true;
         <% } %>

        // put data to the AccountRepresentativeModel
        <%
        try {
         OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
      OrgEntityDB.setDataBeanKeyMemberId(account.getRepresentativeId().toString());
      OrgEntityDB.setCommandContext(contractCommandContext);
      OrgEntityDB.populate();
      //DataBeanManager.activate(OrgEntityDB, request);
      String DN = OrgEntityDB.getDistinguishedName();
   %>
      arm.org = "<%=account.getRepresentativeId()%>";
      arm.orgDN = "<%=UIUtil.toJavaScript(DN)%>";
      arm.initialOrg = arm.org;
      arm.initialOrgDN = arm.orgDN;
   <%
   } catch (Exception e) {
   } %>

   <% if (account.getRepresentativeContactId() != null) { %>
   <% try {
         UserDataBean UserDB = new UserDataBean();
            UserDB.setDataBeanKeyMemberId(account.getRepresentativeContactId().toString());
            UserDB.setCommandContext(contractCommandContext);
            UserDB.populate();
            //DataBeanManager.activate(UserDB, request);
            String DN = (UserDB.getDistinguishedName().toString()).trim(); %>
         arm.contact = "<%=account.getRepresentativeContactId()%>";
         arm.contactDN = "<%=UIUtil.toJavaScript(DN)%>";
            arm.initialContact = arm.contact;
            arm.initialContactDN = arm.contactDN;
   <%    } catch (Exception e) {
         }  %>
   <% } %>
    <%} %>
  }

  // This function allows the user select an organization and get it's contact list
  function contactSelectionChange()
  {
    var orgId, index, allOrg;

    //index = organizationBody.document.orgForm.OrgName.selectedIndex;
    //allOrg = organizationBody.document.orgForm.OrgName;
    //orgId = allOrg.options[index].value;
    orgId = organizationBody.document.orgForm.BuzOrg_ID.value;

    if (defined(contactSelectionBody.showLoadingMsg))
    {
       contactSelectionBody.showLoadingMsg(true);
    }
    if(defined(contactDetailBody.showLoadingMsg))
    {
       contactDetailBody.showLoadingMsg("blank");
    }
    if (parent.setContentFrameLoaded)
    {
       parent.setContentFrameLoaded(false);
    }

    // Need to save the contactInfoBody panel data into the AccountCustomerModel
    // before reloading the contactSelectionBody frame which will trigger an
    // automatically reload of the contactInfoBody frame. If a user enters
    // some information in the contactInfoBody panel, reloading the
    // contactSelectionBody frame will cause losing the user's data from the
    // contactInfoBody panel. Thus, we need to save the contactInfoBody panel
    // data before doing a reload of contactSelectionBody frame.
    savePanelData();

    contactSelectionBody.location.replace("AccountCustomerContactSelectionPanelView?OrgId=" + orgId + "&ContactId=");

  }

  // This function allows the user select a contact and get it's contact detail
  function contactDetailChange() {
    var contactId, index, allContact;

    index = contactSelectionBody.document.contactForm.ContactName.selectedIndex;
    allContact = contactSelectionBody.document.contactForm.ContactName;
    contactId = allContact.options[index].value;

    if (defined(contactDetailBody.showLoadingMsg)) {
      if(contactId == ""){
         contactDetailBody.showLoadingMsg("blank");
       }else{
         contactDetailBody.showLoadingMsg("load");
       }
    }
    if (parent.setContentFrameLoaded) {
         parent.setContentFrameLoaded(false);
    }
    contactDetailBody.location.replace("AccountCustomerContactDetailPanelView?ContactId=" + contactId);
  }



  function savePanelData()
  {
     //------------------------------------------------------------------------
     // There's a chance the contactInfoBody.document.inforForm is NULL.
     // When a user clicks on an organization entry, the contact person
     // panel will be reloaded, then it will also reload the contact
     // information panel. During the moment of loading the contact
     // information panel, the object contactInfoBody.document.inforForm
     // does not exist yet. If the user clicks/selects other organization
     // entry while loading the contact information panel, this savePanelData()
     // function will be invoked and cause javascript exception about the
     // contactInfoBody.document.inforForm is null. Thus, we should make sure
     // the infoForm is existed before using it.
     //------------------------------------------------------------------------
     if (!contactInfoBody.document.infoForm) { return; } //skip


     if (parent.get)
     {
        var o = parent.get("AccountCustomerModel", null);
        if (o != null)
        {
           <%
           if (!foundAccountId)
           {
           %>
              //var orgIndex = organizationBody.document.orgForm.OrgName.selectedIndex;
              //o.org = organizationBody.document.orgForm.OrgName.options[orgIndex].value;
              //o.accountName = organizationBody.document.orgForm.OrgName.options[orgIndex].text;
              o.org = organizationBody.document.orgForm.BuzOrg_ID.value;
              o.accountName = organizationBody.document.orgForm.BuzOrg_Name.value;
           <%
           }//end-if
           %>

           var contactIndex = contactSelectionBody.document.contactForm.ContactName.selectedIndex;
           o.contact = contactSelectionBody.document.contactForm.ContactName.options[contactIndex].value;
           o.info = contactInfoBody.document.infoForm.Info.value;
           o.allowPurchase = contactInfoBody.document.infoForm.AllowOutsidePurchase.checked;
           o.forBaseContracts = contactInfoBody.document.infoForm.ForBaseContracts.checked;

           var priceListIndex = contactInfoBody.document.infoForm.priceListChoice.selectedIndex;
           o.priceListType = contactInfoBody.document.infoForm.priceListChoice.options[priceListIndex].value;
           o.mustUsePriceListPreference = contactInfoBody.document.infoForm.MustUsePriceListPreference.checked;

           parent.put("AccountCustomerModel",o);
        }

     }//end-if

  }//end-function

  function visibleList (s) {
   if (defined(this.organizationBody) == false || this.organizationBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.organizationBody.visibleList)) {
      this.organizationBody.visibleList(s);
      return;
   }

   if (defined(this.organizationBody.document.forms[0])) {
      for (var i = 0; i < this.organizationBody.document.forms[0].elements.length; i++) {
         if (this.organizationBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.organizationBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }

   if (defined(this.contactSelectionBody) == false || this.contactSelectionBody.document.readyState != "complete") {
      return;
   }

   if (defined(this.contactSelectionBody.visibleList)) {
      this.contactSelectionBody.visibleList(s);
      return;
   }

   if (defined(this.contactSelectionBody.document.forms[0])) {
      for (var i = 0; i < this.contactSelectionBody.document.forms[0].elements.length; i++) {
         if (this.contactSelectionBody.document.forms[0].elements[i].type.substring(0,6) == "select") {
            this.contactSelectionBody.document.forms[0].elements[i].style.visibility = s;
         }
      }
   }
  }


</script>

</head>

<% if (!foundAccountId)
   {
      // User selects to create a new account, set the update mode to false.
      // This update mode attribute will be used in the contactInfoBody panel
      // to determine enabling/disabling the checkbox of "This acount is for
      // base contract".
      request.getSession().setAttribute("com.ibm.commerce.tools.contract.AccountCustomer.jsp.updateMode", "FALSE");
%>
<frameset rows="51%,13%,18%,18%" frameborder="no" border="0" framespacing="0">
   <frame src="AccountCustomerOrganizationPanelView" name="organizationBody" title="<%= UIUtil.toJavaScript(contractsRB.get("accountCustomerBodyPanelTitle")) %>" scrolling="auto" noresize="noresize" />
<% }
   else
   {
      // User selects to update an existing account, set the update mode to true.
      // This update mode attribute will be used in the contactInfoBody panel
      // to determine enabling/disabling the checkbox of "This acount is for
      // base contract".
      request.getSession().setAttribute("com.ibm.commerce.tools.contract.AccountCustomer.jsp.updateMode", "TRUE");
%>
<frameset rows="51%,13%,18%,18%" frameborder="no" border="0" framespacing="0">
   <frame src="AccountCustomerOrganizationStaticView?accountId=<%= accountId %>" name="organizationBody" title="<%= UIUtil.toJavaScript(contractsRB.get("accountCustomerBodyPanelTitle")) %>"  scrolling="auto" noresize="noresize" />
<% } %>
   <frame src="/wcs/tools/common/blank.html" name="contactSelectionBody" title="<%= UIUtil.toJavaScript(contractsRB.get("accountCustomerSelectionPanelTitle")) %>" scrolling="auto" noresize="noresize" />
   <frame src="/wcs/tools/common/blank.html" name="contactDetailBody" title="<%= UIUtil.toJavaScript(contractsRB.get("accountCustomerDetailPanelTitle")) %>" scrolling="auto" noresize="noresize" />
   <frame src="/wcs/tools/common/blank.html" name="contactInfoBody" title="<%= UIUtil.toJavaScript(contractsRB.get("accountCustomerInfoPanelTitle")) %>" scrolling="auto" noresize="noresize" />
</frameset>

</html>
