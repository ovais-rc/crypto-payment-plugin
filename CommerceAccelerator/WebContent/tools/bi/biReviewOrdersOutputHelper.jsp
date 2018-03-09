<!-- ========================================================================
  Licensed Materials - Property of IBM

  5724-A18

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>

<%!

private String generateSpecificHeaderInformation(String reportPrefix, Hashtable biNLS, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String ProfileName                   =    (String) aReportDataBeanEnv.get("mbrgrpname");
	
	if(ProfileName != null)
	   ProfileName = UIUtil.toHTML(ProfileName); 
	
	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(ProfileName != null && !ProfileName.equals(""))
	{
		 buff.append("<b>" + biNLS.get(reportPrefix + "ReportInputCriteriaProfileTitle") + "</b> ");
         buff.append(ProfileName + "<BR>");
	}
	
	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

%>