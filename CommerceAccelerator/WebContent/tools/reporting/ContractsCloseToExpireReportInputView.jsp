<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 ContractCloseToExpiredReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.contract.beans.AccountDataBean"%>

<%@include file="common.jsp" %>
<%@include file="ReportAccountHelper.jsp" %>
<%@include file="ReportTimeToExpiredHelper.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<%
   CommandContext AccountCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   String         accountLangId  = AccountCC.getLanguageId().toString();
   String         accountID = (String) request.getParameter("accountId");
   if( accountID.equals("") ) accountID = new String("1");
   AccountDataBean account = new AccountDataBean( new Long(accountID), new Integer(accountLangId));
   DataBeanManager.activate(account, request);
%>

<html>
<head>
   <%=fHeader%>

   <title><%=reportsRB.get("ContractCloseToExpiredReportInputViewTitle")%></title>

   <script SRC="/wcs/javascript/tools/common/Util.js">
</script>
   <script SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
   <script SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
   <script SRC="/wcs/javascript/tools/reporting/ReportHelpers.js">
</script>

   <script>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         
         onLoadTimeToExpired("days");
         if(parent.get("accountId") == null) onLoadAccounts("myAccounts");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         var accountIds = new Array();
         accountIds[0] = parent.get("accountId");

         var accountNames = new Array();
         accountNames[0] = parent.get("accountId");

         saveTimeToExpired("days");
         if(parent.get("accountId") ==  null) saveSelectAccounts("myAccounts");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.ContractsCloseToExpireReportOutputDialog");
         setReportFrameworkReportXML("reporting.ContractsCloseToExpireReport");
	 setReportFrameworkReportName("ContractCloseToExpiredReport");
                

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(parent.get("accountId") ==  null) {
            setReportFrameworkParameter("accountList", returnArrayAsSQLList(returnSelectAccountIDs("myAccounts"), false));
            setReportFrameworkParameter("accountListNames", returnArrayAsSQLList(returnSelectAccountNames("myAccounts"), false));
         }

         if(parent.get("accountId") !=  null) {
            setReportFrameworkParameter("accountList", accountIds); 
            accountNames[0] = "<%=account.getAccountName()%>";
            setReportFrameworkParameter("accountListNames",accountNames );
         }
         setReportFrameworkParameter("Days", returnTimeToExpired("days"));         
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateTimeToExpired("days") == false) return false;
         if(parent.get("accountId") ==  null) {
                 if (validateSelectAccounts("myAccounts") == false) return false;
         }
           return true;
      }


</script>
</head>

<body ONLOAD="initializeValues()" CLASS=content>

   <h1><%=reportsRB.get("ContractCloseToExpiredReportInputViewTitle") %></h1>
   <i><%=reportsRB.get("ContractCloseToExpiredReportDescription")%></i>
   <p>

   <div ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateTimeToExpired("days", reportsRB, "ContractCloseToExpiredReportEnterDayTitle", "ReportDay")%>
<%         if( request.getAttribute("accountId") == null || request.getParameter("accountId").equals("")) {
%>
      <%=generateAccounts("myAccounts", reportsRB, "OrderByAccountReportSelectAccountsTitle")%>
<%    }
%>
   </div>
</body>
</html>
