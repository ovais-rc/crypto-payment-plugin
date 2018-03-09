<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 ReportGenericView.jsp
 ===========================================================================-->
<%@ page language="java" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.command.HttpCommandContext" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.ras.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@page import="com.ibm.commerce.tools.reporting.*" %>
<%@page import="com.ibm.commerce.tools.reporting.commands.*" %>
<%@page import="com.ibm.commerce.tools.reporting.commands.EReportConstants" %>
<%@page import="com.ibm.commerce.tools.reporting.framework.*" %>
<%@page import="com.ibm.commerce.tools.reporting.reports.*" %>
<%@page import="com.ibm.commerce.tools.reporting.util.*" %>
<%@page import="com.ibm.commerce.tools.test.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@include file="../common/common.jsp" %>
<%


   CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   TypedProperty  queryHash = ServletHelper.extractRequestParameters(request);
//   TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");


   Locale locale = commandContext.getLocale();
   // obtain the resource bundle for display
   //Hashtable Reporting=(Hashtable)ResourceDirectory.lookup("reporting.resource",locale);
   //Hashtable ReportingStrings=(Hashtable)ResourceDirectory.lookup("reports.StoreOverviewReportSample",locale);

   ReportDataBean aReportDataBean = new ReportDataBean();
   DataBeanManager.activate(aReportDataBean,request);

%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV=expires CONTENT="fri,31 Dec 1990 10:00:00 GMT">
<!--
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
-->
<% response.setContentType("text/html;charset=UTF-8"); %>
</HEAD>
<SCRIPT SRC="/javascript/tools/reporting/reporting_wizard.js"></SCRIPT>
<SCRIPT LANGUAGE="JAVASCRIPT">

function initializeState()
{

   	parent.setContentFrameLoaded(true);
}




function previousAction()
{
	top.goBack();
}

</SCRIPT>


<BODY BGCOLOR="#FFFFFF" onload="initializeState()"  class="content">

<center><%= aReportDataBean.getTitleName()  %></center>

<%= aReportDataBean.getMessageValue()  %>

<%
	   if ( aReportDataBean.getErrorCode() == 0)   // if(2)
      {			
		   if ( aReportDataBean.getNumberOfRows() != 0)  //if(3)
         {
%>	
            <br><br><br>
            <center>
			   <table border=1>
			
<%
			   for (int i = 0; i < aReportDataBean.getNumberOfColumns(); i++)
            {
%>
			   <th bgColor="#DDE3F2">
			   <center>		
			   <%= aReportDataBean.getColumnTitlesName(i) %>
			   </center>			
			   </th>			
<%
			   } // end of for i loop
%>
			
<%
            // Print output data
            // Receive output data from the reporting control center
            for (int i = 0; i < aReportDataBean.getNumberOfRows(); i++)
            {
%>
               <tr>
<%
               for (int j = 0; j < aReportDataBean.getNumberOfColumns();j++)
                  {
%>
                     <td>
                     <center>
                     <%= aReportDataBean.getValue(i,j) %>
                     </center>
                     </td>
<%
                  } // end of for j loop
%>
               </tr>
<%
               } // end of for i loop
            } // end of if(3)
%>
            </table>
            </center>
<%
      } // end of if(2)
%>

</BODY>
</HTML>
