<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>

<%!

/// get first name and last name and user ID...
private String generateSpecificHeaderInformation(String reportPrefix, Hashtable biNLS, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String OrderId                   =    (String) aReportDataBeanEnv.get("order_id");
	String Order_Status			=	  (String) aReportDataBeanEnv.get("order_status");
   
	if(OrderId != null)
	   OrderId = UIUtil.toHTML(OrderId); 
	if(Order_Status != null)
	   Order_Status = UIUtil.toHTML(Order_Status); 

	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(OrderId != null && !OrderId.equals(""))
	{
		 buff.append("<b>" + biNLS.get(reportPrefix + "ReportInputCriteriaOrderIDTitle") + "</b> ");
         buff.append(OrderId + "<BR>");
	}
	buff.append("<b>"+biNLS.get(reportPrefix + "ReportStatusSelectionTitle")+"</b>" +" ");
	if(Order_Status.equals("1"))
		buff.append(biNLS.get("pending"));
	else if(Order_Status.equals("2"))
		buff.append(biNLS.get("canceled"));
	else if(Order_Status.equals("3"))
		buff.append(biNLS.get("submitted"));
	else if(Order_Status.equals("4"))
		buff.append(biNLS.get("paymentsuccessful"));
	else if(Order_Status.equals("5"))
		buff.append(biNLS.get("inventoryfailed"));
	else if(Order_Status.equals("6"))
		buff.append(biNLS.get("paymentauthorized"));
	else if(Order_Status.equals("7"))
		buff.append(biNLS.get("shipped"));
	else
		buff.append(biNLS.get("ordertemplate"));

	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

%>