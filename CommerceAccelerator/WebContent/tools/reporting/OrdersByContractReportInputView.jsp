 <!-- ========================================================================
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
 -----------------------------------------------------------------------------
 OrderByContractReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.contract.beans.ContractDataBean"%>


<%@include file="common.jsp" %>
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportContractHelper.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>


<%
   CommandContext ContractCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   String         contractLangId  = ContractCC.getLanguageId().toString();
   String         contractID = (String) request.getParameter("contractId");
   if( contractID.equals("") ) contractID = new String("1");
   ContractDataBean contract = new ContractDataBean( new Long(contractID), new Integer(contractLangId));
   DataBeanManager.activate(contract, request);
%>

<html>
<head>
   <%=fHeader%>

   <title><%=reportsRB.get("OrderByContractReportInputViewTitle")%></title>

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
         
         onLoadStartDateEndDate("enquiryPeriod");
         if(parent.get("contractId") ==  null) onLoadContracts("myContracts");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         var contractIds = new Array();
         contractIds[0] = parent.get("contractId");

         var contractNames = new Array();
         contractNames[0] = parent.get("contractId");
	 
	 saveStartDateEndDate("enquiryPeriod");
         if(parent.get("contractId") ==  null) saveSelectContracts("myContracts");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.OrdersByContractReportOutputDialog");
         setReportFrameworkReportXML("reporting.OrdersByContractReport");
	 setReportFrameworkReportName("OrderByContractReport");
            
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(parent.get("contractId") ==  null) {
		setReportFrameworkParameter("ContractList", returnArrayAsSQLList(returnSelectContractIDs("myContracts"), false));
         	setReportFrameworkParameter("ContractListNames", returnArrayAsSQLList(returnSelectContractNames("myContracts"), false));
         }
	 if(parent.get("contractId") !=  null) {
		setReportFrameworkParameter("ContractList", contractIds);
                contractNames[0] = "<%=contract.getContractName()%>";
         	setReportFrameworkParameter("ContractListNames", contractNames);
         }
	 setReportFrameworkParameter("StartDate", returnStartDateAsJavaTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsJavaTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("startDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("endDate", returnEndDateAsTimestamp("enquiryPeriod"));
        
        saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateStartDateEndDate("enquiryPeriod") == false) return false;
         if(parent.get("contractId") ==  null) {
		if (validateSelectContracts("myContracts") == false) return false;
	 }
           return true;
      }


</script>
</head>

<body ONLOAD="initializeValues()" CLASS=content>

   <h1><%=reportsRB.get("OrderByContractReportInputViewTitle") %></h1>
   <i><%=reportsRB.get("OrderByContractReportDescription")%></i>
   <p>

   <div ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
<%         if(request.getParameter("contractId") == null || request.getParameter("contractId").equals("")) {
%>
      <%=generateContracts("myContracts", reportsRB, "OrderByContractReportSelectContractsTitle")%>
<%    }
%>
   </div>

</body>
</html>
