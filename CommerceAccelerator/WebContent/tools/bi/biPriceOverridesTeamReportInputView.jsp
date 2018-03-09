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
<%@include file="/tools/bi/PriceOverridesTeamHelper.jsp" %>


<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <TITLE><%=biNLS.get("teamPriceOverridesInputWindowTitle")%></TITLE>

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
         
		 onLoadStatOption("myHelperPriceOverridesTeam");                
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
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","bi.biPriceOverridesTeamReportOutputDialog");
         setReportFrameworkReportXML("bi.biPriceOverridesTeamReport");
         
		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for sorting option
         ////////////////////////////////////////////////////////////////////////////////////////////////////

				if(returnOrderbyDesc("myHelperPriceOverridesTeam")){
					setReportFrameworkParameter("sortDirection", "DESC");
				 }
				 else{
					setReportFrameworkParameter("sortDirection", "ASC");
					 }

         
	if(returnStatOptionCSRTeamName("myHelperPriceOverridesTeam")){
		setReportFrameworkParameter("sortColumn", "CSRTeamName");
	}
	else{
		setReportFrameworkParameter("sortColumn", "Amount");
	}	  
	
	 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for Report Name selection
         ////////////////////////////////////////////////////////////////////////////////////////////////////               
         
	 if(document.all.CSRTEAMNAME.value == '' || document.all.CSRTEAMNAME.value == null)
	 {
	  setReportFrameworkParameter("CSRTeamName", "None");         	
          setReportFrameworkReportName("biPriceOverridesTeamDefault");	 }         
     else
     {         
        setReportFrameworkParameter("CSRTeamName", document.all.CSRTEAMNAME.value);         
        setReportFrameworkReportName("biPriceOverridesTeamWithTeamName");
     }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("ReportType", "UserInput");
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
         return true;
      }

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("teamPriceOverridesReportTitle") %></H1>
   <%=biNLS.get("teamPriceOverridesDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>  
   <p>

<FORM NAME="frmCSRData">
<TABLE>
<TR>    
	<td ALIGN="LEFT">
       <LABEL FOR="frmCSRDataText1"><%=biNLS.get("teamPriceOverridesTeamname")%></LABEL>
	</td>
</TR>
<TR>
	<td>
       <INPUT TYPE="TEXT" NAME="CSRTEAMNAME" SIZE="20" ID="frmCSRDataText1" onkeypress="trapKey(event);"></Input> 
    </td>    
</tr>
</table>        
</FORM>
       
<b><%=biNLS.get("timePeriod")%></b>  
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td><br>
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
		<%=generateStatOption("myHelperPriceOverridesTeam", biNLS)%>
	 </DIV>

</BODY>
</HTML>
