<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>
<%@include file="/tools/bi/PriceQuotesIndividualHelper.jsp" %>


<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <TITLE><%=biNLS.get("priceQuotesReportTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadStartDateEndDate("enquiryPeriod");

		 onLoadStatOption("myHelperPriceQuotesIndividual");          
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }
      

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveStartDateEndDate("enquiryPeriod");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         saveStatOption("myHelperPriceQuotesIndividual");
      
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","bi.biPriceQuotesIndividualReportOutputDialog");
         setReportFrameworkReportXML("bi.biPriceQuotesIndividualReport");

		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for sorting option
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         
		if(returnOrderbyDesc("myHelperPriceQuotesIndividual")){
			setReportFrameworkParameter("sortDirection", "DESC");
		}
		else{
			setReportFrameworkParameter("sortDirection", "ASC");
		}         
         
       if(returnStatOptionCustomerName("myHelperPriceQuotesIndividual")){
		setReportFrameworkParameter("sortColumn", "CustomerLogonID");
	}

	else if(returnStatOptionSKU("myHelperPriceQuotesIndividual")){
		setReportFrameworkParameter("sortColumn", "SKU");
	}

	else{
		setReportFrameworkParameter("sortColumn", "DateQuoted");
	}         
       
		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for Report Name selection
         ////////////////////////////////////////////////////////////////////////////////////////////////////   
		 
		 if(document.all.CSRLOGONID.value == '' || document.all.CSRLOGONID.value == null){
			 setReportFrameworkReportName("biPriceQuotesIndividual");
			 setReportFrameworkParameter("CSRLogonID", "ForAll");
		 }
		 else{
			 setReportFrameworkReportName("biPriceQuotesIndividualCSRID");
			 setReportFrameworkParameter("CSRLogonID", document.all.CSRLOGONID.value);
		 }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
         
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }



      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateStartDateEndDate("enquiryPeriod") == false) 
			 return false;                 
         return true;
      }      


</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("priceQuotesReportTitle") %></H1>
   <%=biNLS.get("priceQuotesDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>   
<FORM NAME="frmCSRData">
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr height=25>
	<td ALIGN="LEFT">
       <LABEL FOR="frmCSRDataText1"><%=biNLS.get("priceQuotesCSRLogonID")%></LABEL>
	</td>
</TR>
<TR>
	<td ALIGN="LEFT">
       <INPUT TYPE="TEXT" NAME="CSRLOGONID" SIZE="20" ID="frmCSRDataText1" onkeypress="trapKey(event);"></Input> 
    </td>
</TR>
</TABLE>
</FORM>     
<b><%=biNLS.get("timePeriod")%></b>  
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td> <br>
    <DIV ID=pageBody STYLE="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </DIV>
	</td>
</tr>
</table>
                                
<br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
				<B><LABEL><%=biNLS.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		
		</tr>
</table>
   	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<%=generateStatOption("myHelperPriceQuotesIndividual", biNLS)%>
	 </DIV>
</BODY>
</HTML>
