<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>
<%!

   private String generateCustomOutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();

      String StartDate                    = (String) aReportDataBeanEnv.get("StartDate");
      String EndDate                      = (String) aReportDataBeanEnv.get("EndDate");
      Timestamp currentTime = TimestampHelper.getCurrentTime();

	  buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	  
	  String CSRLogonID = (String) aReportDataBeanEnv.get("CSRLogonID");
      if (!CSRLogonID.equals("ForAll") && CSRLogonID != null)
      {
         buff.append("<b>" + reportsRB.get(reportPrefix + "SelectedCSRLogonID") + "</b> ");
		 buff.append(CSRLogonID + "<BR>" );
      }

      buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRange") + "</b> ");
	  buff.append(getFormattedDate(StartDate,locale) + " ");
	  buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRangeTo") + "</b> ");
	  buff.append(getFormattedDate(EndDate,locale) + "<BR>");
	  buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");
	  buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
	  buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<BR>");
      buff.append("   </DIV>\n   <BR><BR>\n");
      
      return buff.toString();
   }

%>