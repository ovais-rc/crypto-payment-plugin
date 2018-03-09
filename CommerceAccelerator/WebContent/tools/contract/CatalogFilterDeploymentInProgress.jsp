

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<html>
<head>
<%@page import = "java.util.*,
         com.ibm.commerce.beans.*,
         com.ibm.commerce.command.CommandContext,
         com.ibm.commerce.tools.catalog.beans.*,
         com.ibm.commerce.tools.catalog.util.*,
         com.ibm.commerce.catalog.objects.*,
         com.ibm.commerce.common.objects.StoreAccessBean,
         com.ibm.commerce.tools.util.*"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   /*93206*/
   //--------------------------------------------------------------
   // Checking the terms and conditions lock for Pricing TC
   // in contract change mode. This is not applicable if a draft
   // contract is not even created.
   //--------------------------------------------------------------
   int lockHelperRC = 0;

   if (foundContractId)
   {
      // In the Update CatalogFilter wizard, after a user clicks 'Save' button,
      // it will deploy the pricing terms and conditions. During the deployment
      // in progress, the wizard will reload the CatalogTree.jsp file that will
      // causing the pricing TC being locked again. The following code will
      // unlock the pricing TC if the current user is the lock's owner, so that
      // even the user exit from this page by clicking the bread crumb, this
      // pricing TC won't be in dangling lock situration.
      //
      com.ibm.commerce.contract.util.ContractTCLockHelper myLockHelper
            = new com.ibm.commerce.contract.util.ContractTCLockHelper
                  (contractCommandContext,
                   new Long(contractId),
                   com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING);
      lockHelperRC = myLockHelper.verifyAndUnlockTC();
   }
%>


<%
   String displayString = "";
   String publishStatusFieldString = "";
   String publishStatusValueString = "";

   String modeParm = request.getParameter("mode");
   if (modeParm == null) {
      modeParm = "error";
   }
   String hostingParm = request.getParameter("hosting");
   if (hostingParm == null) {
      hostingParm = "";
   }
   String baseContractParm = request.getParameter("baseContract");
   if (baseContractParm == null) {
      baseContractParm = "";
   }
   String contractStoreParm = request.getParameter("contractStoreId");
   if (contractStoreParm == null) {
      contractStoreParm = "";
   }

   if (modeParm.equals("deploymentInProgress")) {
      displayString = UIUtil.toHTML((String)contractsRB.get("publishingInProgressMessage"));
      publishStatusFieldString = UIUtil.toHTML((String)contractsRB.get("publishStatus"));
      publishStatusValueString = UIUtil.toHTML((String)contractsRB.get("publishInProgress"));
   }
   else if (modeParm.equals("noSharedCatalog")) {
      displayString = UIUtil.toHTML((String)contractsRB.get("noSharedCatalogErrorMessage"));
   }
   else {
      displayString = UIUtil.toHTML((String)contractsRB.get("configurationErrorMessage"));
   }
%>

<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">
<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script>
function getContractNVP()
{
   if (<%= foundContractId %> == true) {
      return "&contractId=<%=contractId%>";
   } else {
      return "";
   }
}
function getHostingNVP()
{
   var parms = "";
   if ("<%= UIUtil.toJavaScript(hostingParm) %>" == "true") {
      parms += "&hosting=true";
   }
   if ("<%= UIUtil.toJavaScript(baseContractParm) %>" == "true") {
      parms += "&baseContract=true";
   } else if ("<%= UIUtil.toJavaScript(baseContractParm) %>" == "false") {
      parms += "&baseContract=false";
   }
   if ("<%= UIUtil.toJavaScript(contractStoreParm) %>" != "") {
      parms += "&contractStoreId=<%= UIUtil.toJavaScript(contractStoreParm) %>";
   }
   return parms;
}
   function init(){
      parent.setContentFrameLoaded(true);
   }

</script>
</head>

<body class="content" onload="init();">

<table border="0" width="100%" id="CatalogFilterDeploymentInProgress_Table_1">
   <tr>
      <td id="CatalogFilterDeploymentInProgress_TableCell_1">
         <h1><%=UIUtil.toHTML((String)contractsRB.get("genericCatalogFilterTitle"))%></h1>
      </td>
      <td ALIGN=RIGHT id="CatalogFilterDeploymentInProgress_TableCell_2">
         <table border="0" id="CatalogFilterDeploymentInProgress_Table_2">
            <tr>
               <td class="list_info1" id="CatalogFilterDeploymentInProgress_TableCell_3">
                  <%= publishStatusFieldString %>
               </td>
               <td class="list_info1" id="CatalogFilterDeploymentInProgress_TableCell_4">
                               <%= publishStatusValueString %>
               </td>
            </tr>
         </table>
      </td>

   </tr>
</table>

<table border="0" width="100%" id="CatalogFilterDeploymentInProgress_Table_3">
   <tr>
      <%= displayString %>
   </tr>
</table>

</body>
</html>
