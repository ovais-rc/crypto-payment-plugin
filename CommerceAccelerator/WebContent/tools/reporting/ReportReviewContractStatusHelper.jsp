<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="ReportOutputHelper.jsp" %>
<%@page import = "com.ibm.commerce.user.objects.AddressAccessBean" %>

<%!

private String generateSpecificHeaderInformation(String reportPrefix, Hashtable reportsRB, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String ContractId                   =    (String) aReportDataBeanEnv.get("contract_id");
	   
	if(ContractId != null)
	   ContractId = UIUtil.toHTML(ContractId); 

	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(ContractId != null && !ContractId.equals(""))
	{
		 buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaContractIDTitle") + "</b> ");
         buff.append(ContractId + "<BR>");
	}
	String contractStatus = (String) aReportDataBeanEnv.get("Status");
    buff.append("<b>" + reportsRB.get("contractStatus") + ":</b>  " + contractStatus + "<br>\n");
	buff.append("   </DIV><BR><BR>\n\n");
	return buff.toString();
}

%>