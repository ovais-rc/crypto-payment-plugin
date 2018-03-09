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
      com.ibm.commerce.common.objects.StoreAccessBean,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.tools.contract.beans.AccountListDataBean,
      com.ibm.commerce.tools.contract.beans.AccountDataBean,
      com.ibm.commerce.user.beans.OrgEntityDataBean,
      com.ibm.commerce.user.beans.OrganizationDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountRepresentativePanelTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>

 <script LANGUAGE="JavaScript">

  // This function detect if the panel has been load before
  function loadPanelData() {

    if (parent.parent.get) {
   var hereBefore = parent.parent.get("AccountRepresentativeModelLoaded", null);
   if (hereBefore != null) {
      loadOrgData();

      // have been to this page before - load from the model
            var o = parent.parent.get("AccountRepresentativeModel", null);
      if (o != null) {
        organizationChange(o.org);
        parent.contactSelectionBody.location.replace("AccountRepresentativeContactSelectionPanelView?OrgId=" + o.org + "&ContactId=" + o.contact);
        // handle error messages back from the validate page
           if (parent.parent.get("accountRepresentativeOrgRequired", false)) {
               parent.parent.remove("accountRepresentativeOrgRequired");
               alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountRepresentativeOrgRequired"))%>");
           }
         }

        } else {

      // this is the first time on this page - load up the model
      var acm = parent.parent.get("AccountRepresentativeModel", null);
      if (acm == null) {
         acm = new AccountRepresentativeModel();
            parent.parent.put("AccountRepresentativeModel", acm);
            parent.parent.put("AccountRepresentativeModelLoaded", true);
         }
         parent.parent.put("AccountRepresentativeModelLoaded", true);
         loadOrgData();
      parent.contactSelectionBody.location.replace("AccountRepresentativeContactSelectionPanelView?OrgId=" + acm.org + "&ContactId=" + acm.initialContact);
   }
    }
  }

  // This function loads up all the organization data
  function loadOrgData() {
    with(self.document.orgForm) {
        var acm = parent.parent.get("AccountRepresentativeModel", null);
      if (acm != null) {
         <%
      int count = 0;
      OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
      OrgEntityDB.setDataBeanKeyMemberId(fStoreMemberId);
      DataBeanManager.activate(OrgEntityDB, request);

      OrgEntityDataBean OrgEntityDescendants = new OrgEntityDataBean();
      OrgEntityDescendants.setDataBeanKeyMemberId(fStoreMemberId);
      DataBeanManager.activate(OrgEntityDescendants, request);
      Long[] orgList = OrgEntityDescendants.getDescendantOrgEntities();
      %>
      OrgName.options[<%=count%>] = new Option("<%=UIUtil.toJavaScript((String)OrgEntityDB.getOrganizationName())%>", "<%=fStoreMemberId%>", false, false);
      <%
      for (int j=0; j<orgList.length; j++) {
         Long orgId = orgList[j];
         OrganizationDataBean orgDB = new OrganizationDataBean();
         orgDB.setDataBeanKeyMemberId(orgId.toString());
         DataBeanManager.activate(orgDB, request);
         if (!fStoreMemberId.equals(orgId.toString())) {
            count++; %>
            if (acm.initialOrg == "<%=orgId%>")
               OrgName.options[<%=count%>] = new Option("<%=UIUtil.toJavaScript((String)orgDB.getOrganizationName())%>", "<%=orgId%>", true, true);
            else
               OrgName.options[<%=count%>] = new Option("<%=UIUtil.toJavaScript((String)orgDB.getOrganizationName())%>", "<%=orgId%>", false, false);
      <%    }
      } %>
   }
    }
  }

  // This function allows the user select an organization
  function organizationChange(orgId) {
    var allOrg;

    allOrg = self.document.orgForm.OrgName;
    for (var i=0; i<allOrg.length; i++) {
      if (allOrg.options[i].value == orgId) {
         allOrg.selectedIndex = i;
         break;
      }
    }
  }


</script>

</head>

<body ONLOAD="loadPanelData();" class="content">

<h1><%= contractsRB.get("accountRepresentativePanelTitle") %></h1>

<form NAME="orgForm" id="orgForm">

<table border="0" id="AccountRepresentativeOrganizationPanel_Table_1">
 <tr>
  <td valign='top' id="AccountRepresentativeOrganizationPanel_TableCell_1">
    <label for="AccountRepresentativeOrganizationPanel_FormInput_OrgName_In_orgForm_1"><%= contractsRB.get("accountRepresentativeOrganizationPrompt") %></label><br>
    <select NAME="OrgName" id="AccountRepresentativeOrganizationPanel_FormInput_OrgName_In_orgForm_1" TABINDEX="1" SIZE="1" onChange="parent.contactSelectionChange();"></select>
  </td>
 </tr>
</table>

</form>
</body>
</html>
