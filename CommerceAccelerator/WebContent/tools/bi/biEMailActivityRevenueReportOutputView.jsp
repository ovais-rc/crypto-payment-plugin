<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<%@page import="java.util.*" %>

<%@include file="/tools/common/common.jsp" %>
 
<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>
<%
   String reportPrefix = "biEMailActivityRevenue";
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>


<%!
   private String getCurrencyValue(String reportPrefix, Hashtable reportsRB, Locale locale)
{
String currency_value = "";
 
   int count = aReportDataBean.getNumberOfRows();

   if (count != 0)
   {
      String columnKey = null;

   	for (int i = 0;i<columnAttributes.size();i++)
   	{

   	 Hashtable currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
   
         for (Enumeration e=currentColumnAttributes.keys(); e.hasMoreElements();)
          {
            String key = (String) e.nextElement();
            //get the columnKey
            if (currentColumnAttributes.get("columnName").toString().equalsIgnoreCase("currency"))
               {
                columnKey = currentColumnAttributes.get("columnKey").toString();
                break;      
                }
           
           }
            if (columnKey != null) break;
        
         }
         //get the value of the currency column
      currency_value = aReportDataBean.getValue(0, columnKey);
    	 
    }
    
   return(currency_value);
    
}

 
     

%>


 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

   <HEAD>
     <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
      <%=generateHeaderInformation(reportPrefix, biNLS, request)%>
   </HEAD>

   <body class="content" onload="javascript:parent.setContentFrameLoaded(true)">
     <%=generateOutputHeading(reportPrefix, biNLS)%>
      <%=generateSpecificOutputInputCriteria(reportPrefix, biNLS, biCommandContext.getLocale())%>
      
      <DIV ID=pageBody STYLE="display: block; margin-left: 20">
        <b> <%=biNLS.get("currency")%>:       <%=getCurrencyValue(reportPrefix, biNLS,biCommandContext.getLocale())%>
        </b>
        <BR>
        <BR>
        <BR>
       </DIV>

      <%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>
   </BODY>

</HTML>
