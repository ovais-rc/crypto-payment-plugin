<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

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
	  String ReportType					  = (String) aReportDataBeanEnv.get("ReportType");
      Timestamp currentTime = TimestampHelper.getCurrentTime();

      buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	  if (ReportType != null && ReportType.equals("UserInput"))
      {
		  if (StartDate != null)
		  {
		     buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRange") + "</b> ");
	         buff.append(getFormattedDate(StartDate,locale) + " ");
		     buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRangeTo") + "</b> ");
	         buff.append(getFormattedDate(EndDate,locale) + "<BR>");
		  }
	  }
	  else if(ReportType != null && ReportType.equals("Predefined"))
	   {  
		  String timePeriod = (String) aReportDataBeanEnv.get("Time");
		  buff.append("<b>" + reportsRB.get("Report") + ":</b>  " + timePeriod + "<br>\n");
	   }

     String selectedParam = (String) aReportDataBeanEnv.get("SelectedParam");
     String selectedParamValue = null;
     
     if(selectedParam.equals("INDL"))
     {
     	selectedParamValue = (String) aReportDataBeanEnv.get("CSRLogonID");
        buff.append("<b>" + reportsRB.get(reportPrefix + "SelectedCSRLogonID") + "</b> ");
        buff.append(selectedParamValue);  
      }
      else if(selectedParam.equals("TEAM"))
      {
      	selectedParamValue = (String) aReportDataBeanEnv.get("CSRTeamName");
        buff.append("<b>" + reportsRB.get(reportPrefix + "SelectedCSRTeamName") + "</b> ");
      	buff.append(selectedParamValue);    
      }
      else 
      {
      	selectedParamValue = "None";
 	    buff.append("<b>" + reportsRB.get(reportPrefix + "SelectedParameter") + "</b> ");
        buff.append(reportsRB.get(reportPrefix+"NoParameterSelected")); 
      }
      buff.append("<BR>");
      buff.append("<p></p>");
      
      
	  buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");
	  buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
	  buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<BR>");
      buff.append("   </DIV>\n   <BR><BR>\n");
      
      return buff.toString();
   }

%>