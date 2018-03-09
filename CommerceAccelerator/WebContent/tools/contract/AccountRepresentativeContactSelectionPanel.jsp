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

<%@page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.user.beans.OrganizationDataBean,
      com.ibm.commerce.user.beans.OrgEntityDataBean,
      com.ibm.commerce.user.beans.UserDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   String orgId = "";
   String contactId = "";

   TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
   if (requestProperties != null) {
          orgId = UIUtil.toHTML((String)requestProperties.getString("OrgId"));
         contactId = UIUtil.toHTML((String)requestProperties.getString("ContactId"));
   }
%>

<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountRepresentativeContactSelectionPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>

 <script LANGUAGE="JavaScript">

  // This function detect if the panel has been load before
  function loadPanelData() {
    var contactId = "<%=contactId%>";
    loadContactData(contactId);

    if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(true);
    }
  }

  // This function loads up all the contact data for a specific organization
  function loadContactData(contactId) {
    with(self.document.contactForm) {
      ContactName.options[0] = new Option("<%= UIUtil.toJavaScript((String)contractsRB.get("accountRepresentativeContactSpecifyPrompt"))%>", "", false, false);
      <%
      if (!orgId.equals("")) {
        String DN = "";
   OrgEntityDataBean getUsersFromOrg = null;
        try {
      OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
      OrgEntityDB.setDataBeanKeyMemberId(orgId.toString());
      DataBeanManager.activate(OrgEntityDB, request);

      OrgEntityDataBean OrgEntityDescendants = new OrgEntityDataBean();
      OrgEntityDescendants.setDataBeanKeyMemberId(orgId.toString());
      DataBeanManager.activate(OrgEntityDescendants, request);
      getUsersFromOrg = OrgEntityDescendants;

      String parentMemberId = null;
      parentMemberId = OrgEntityDB.getParentMemberId();
      while (parentMemberId != null && parentMemberId.length() > 0) {

            OrgEntityDataBean parentOrg = new OrgEntityDataBean();
         parentOrg.setDataBeanKeyMemberId(parentMemberId);
         DataBeanManager.activate(parentOrg, request);
         // check if it has a business entity flag

         Vector beVector = parentOrg.getAttribute("BusinessEntity", "null");
         if (beVector != null && beVector.size() > 0) {
            String beFlag = (String)beVector.elementAt(0);
            if (beFlag != null && beFlag.equals("1")) {
               getUsersFromOrg = parentOrg;
               break;
            }
         }
         parentMemberId = parentOrg.getParentMemberId();
      }

      Long[] contactList = getUsersFromOrg.getDescendantUsers();
      DN = (OrgEntityDB.getDistinguishedName().toString()).trim();

      for (int j=0; j<contactList.length; j++) {
         UserDataBean UserProfDB = new UserDataBean();
         UserProfDB.setDataBeanKeyMemberId(contactList[j].toString());
            DataBeanManager.activate(UserProfDB, request);
            String contactName = UserProfDB.getDisplayName();
    %>
               ContactName.options[<%=j+1%>] = new Option("<%=UIUtil.toJavaScript((String)contactName)%>", "<%=contactList[j]%>", false, false);
      <% }
        } catch (Exception e) {
        } %>

         var acm = parent.parent.get("AccountRepresentativeModel", null);
         if (acm != null) {
            acm.org = "<%=orgId%>"
            acm.orgDN = "<%=UIUtil.toJavaScript(DN)%>";
         }
    <%}%>
      contactSelectionChange(contactId);
    }
  }

  // This function allows the user select an organization and get it's contact list
  function contactSelectionChange(contactId) {
    var allContact;

    allContact = self.document.contactForm.ContactName;
    for (var i=0; i<allContact.length; i++) {
      if (allContact.options[i].value == contactId) {
         allContact.selectedIndex = i;
         break;
      }
    }
    parent.contactDetailChange();
  }

  // This function performs augment usability
  function showLoadingMsg(flag) {
    if (flag == true) {
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(false);
      }
      top.showProgressIndicator(true);
      FinishDiv.style.display = "none";
      LoadingMsgDiv.style.display = "block";
    } else {
      if (parent.parent.setContentFrameLoaded) {
        parent.parent.setContentFrameLoaded(true);
      }
      top.showProgressIndicator(false);
      LoadingMsgDiv.style.display = "none";
      FinishDiv.style.display = "block";
    }
  }


</script>

</head>

<body ONLOAD="loadPanelData();showLoadingMsg(false);" class="content">

<div id="LoadingMsgDiv" style="display: none">
  &nbsp;<%= contractsRB.get("generalLoadingMessage") %>
</div>

<div id="FinishDiv" style="display: none">
<form NAME="contactForm" id="contactForm">
<table border=0 id="AccountRepresentativeContactSelectionPanel_Table_1">
 <tr>
  <td valign='top' id="AccountRepresentativeContactSelectionPanel_TableCell_1">
    <label for="AccountRepresentativeContactSelectionPanel_FormInput_ContactName_In_contactForm_1"><%= contractsRB.get("accountRepresentativeContactSelectionPrompt") %></label><br>
    <select NAME="ContactName" id="AccountRepresentativeContactSelectionPanel_FormInput_ContactName_In_contactForm_1" TABINDEX="1" SIZE="1" onChange="parent.contactDetailChange();"></select>
  </td>
 </tr>
</table>
</form>
</div>

</body>
</html>
