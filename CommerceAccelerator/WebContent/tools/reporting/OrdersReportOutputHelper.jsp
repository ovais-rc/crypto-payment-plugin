<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="ReportHeaderSummaryHelper.jsp" %>
<%@page import = "com.ibm.commerce.user.objects.AddressAccessBean" %>
<%!

/// get first name and last name and user ID...
private String generateSpecificHeaderInformation(String reportPrefix, Hashtable reportsRB, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String UserId                   =    (String) aReportDataBeanEnv.get("user_id");
   
	if(UserId != null)
	   UserId = UIUtil.toHTML(UserId); 

	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(UserId != null && !UserId.equals(""))
	{
		 buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaUserIDTitle") + "</b> ");
         buff.append(UserId + "<BR>");
	}
	buff.append("   </DIV><BR><BR>\n\n");
	return buff.toString();
}


%>