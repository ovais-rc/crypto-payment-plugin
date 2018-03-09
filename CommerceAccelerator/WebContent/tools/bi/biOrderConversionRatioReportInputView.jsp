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
<%@include file="/tools/bi/OrderConversionRatioHelper.jsp" %>


<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <TITLE><%=biNLS.get("orderConversionRatioInputWindowTitle")%></TITLE>

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
	     onLoadStatOption("myHelperOrderConversionRatio");  
	     document.all.CSRTeamName.value = "";
         document.all.CSRLogonID.value = "";       
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
         saveStatOption("myHelperOrderConversionRatio");
         
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","bi.biOrderConversionRatioReportOutputDialog");
         setReportFrameworkReportXML("bi.biOrderConversionRatioReport");
         
		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for sorting option
         ////////////////////////////////////////////////////////////////////////////////////////////////////

	if(returnOrderbyDesc("myHelperOrderConversionRatio")){
		setReportFrameworkParameter("sortDirection", "DESC");
	}
	else{
		setReportFrameworkParameter("sortDirection", "ASC");
	}
	if(returnStatOptionCSRName("myHelperOrderConversionRatio")){
		setReportFrameworkParameter("sortColumn", "CSRName");
	}else if(returnStatOptionCSRLogonID("myHelperOrderConversionRatio")){
		setReportFrameworkParameter("sortColumn", "CSRLogonID");
	}else{
		setReportFrameworkParameter("sortColumn", "Rate");
	}	  
	
	 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars for Report Name selection
         ////////////////////////////////////////////////////////////////////////////////////////////////////         
         
	 //if(document.all.CSRLogonID.value == '' || document.all.CSRLogonID.value == null)
     if(document.all.CSRTeamName.value != '' || document.all.CSRLogonID.value != '') {
			if(document.all.rbname[0].checked)
			{
				setReportFrameworkParameter("CSRLogonID", document.all.CSRLogonID.value);         
				setReportFrameworkParameter("SelectedParam","INDL");
				setReportFrameworkReportName("biOrderConversionRatioCSRLogonID");
			}         
			else 
	      	 {     
				setReportFrameworkParameter("CSRTeamName", document.all.CSRTeamName.value);         
				setReportFrameworkParameter("SelectedParam","TEAM");
				setReportFrameworkReportName("biOrderConversionRatioCSRTeamName");
			 } 
	 }         
	 else
	 {
		setReportFrameworkParameter("SelectedParam","NONE");       
        setReportFrameworkReportName("biOrderConversionRatio");
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

	function disableCSR()
	{
		frmCSRTeam.CSRLogonID.disabled=true;
		frmCSRTeam.CSRTeamName.disabled=false;
		frmCSRTeam.CSRTeamName.focus();
	}
	function disableTeam()
	{
		frmCSRTeam.CSRTeamName.disabled=true;
		frmCSRTeam.CSRLogonID.disabled=false;
		frmCSRTeam.CSRLogonID.focus();
	}      

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("orderConversionRatioReportTitle") %></H1>
   <%=biNLS.get("orderConversionRatioDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>  
   <p>

<DIV ID=pageBody STYLE="display: block; margin-left: 0">
	<FORM NAME="frmCSRTeam">
		<TABLE CELLPADDING=0 CELLSPACING=0>
			<TR HEIGHT=25>
				<TD VALIGN=TOP>
                    <LABEL FOR="frmCSRDataRadio1"></LABEL>
                    <INPUT TYPE=RADIO NAME=rbname checked="checked" onclick="disableTeam()" ID="frmCSRDataRadio1"></INPUT>
                    <LABEL FOR="frmCSRDataText1"><%=biNLS.get("orderConversionRatioCSRLogonID")%></LABEL>
                </TD>
			</TR>
			<TR HEIGHT=25>
				<TD VALIGN=TOP>
                    <INPUT TYPE=TEXT NAME="CSRLogonID" SIZE="30" ID="frmCSRDataText1" onkeypress="trapKey(event);">
				</TD>
			</TR>
			<TR HEIGHT=25>
				<TD VALIGN=TOP>
                    <LABEL FOR="frmCSRDataRadio2"></LABEL>
                    <INPUT TYPE=RADIO NAME=rbname onclick="disableCSR()" ID="frmCSRDataRadio2"></INPUT>
                    <LABEL FOR="frmCSRDataText2"><%=biNLS.get("orderConversionRatioTeamname")%></LABEL>
                </TD>
			</TR>
			<TR HEIGHT=25>
				<TD VALIGN=TOP>
                    <INPUT TYPE=TEXT NAME="CSRTeamName" SIZE="30" ID="frmCSRDataText2" onkeypress="trapKey(event);">
				</TD>
			</TR>
		</TABLE>
	</FORM>
</DIV>  
<b><%=biNLS.get("timePeriod")%></b>  
<BR>
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
		<%=generateStatOption("myHelperOrderConversionRatio", biNLS)%>
	 </DIV>

</BODY>
</HTML>
