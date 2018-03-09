<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

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
	String LogonId                   =    (String) aReportDataBeanEnv.get("logon_id");
	
	if(LogonId != null)
	   LogonId = UIUtil.toHTML(LogonId); 
	
	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(LogonId != null && !LogonId.equals(""))
	{
		 buff.append("<b>" + biNLS.get(reportPrefix + "ReportInputCriteriaLogonIdTitle") + "</b> ");
         buff.append(LogonId + "<BR>");
	}
	
	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

%>