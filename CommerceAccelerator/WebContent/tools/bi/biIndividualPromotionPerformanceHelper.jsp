<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="/tools/reporting/ORReportOutputHelper.jsp" %>

<%!

private String generateSpecificHeaderInformation(String reportPrefix, Hashtable biNLS, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	
	String PromotionType			=	  (String) aReportDataBeanEnv.get("promotiongrp");
   
	if(PromotionType != null)
	   PromotionType = UIUtil.toHTML(PromotionType); 

	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	buff.append("<b>"+biNLS.get(reportPrefix + "ReportTypeSelectionTitle")+"</b>" +" ");
	if(PromotionType.equals("OrderLevelPromotion"))
		buff.append(biNLS.get("orderLevel"));
	else if (PromotionType.equals("ProductLevelPromotion"))
		buff.append(biNLS.get("productLevel"));
	else if (PromotionType.equals("ShippingPromotion"))
		buff.append(biNLS.get("shippingLevel"));
	else
		buff.append(biNLS.get("allPromotions"));

	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

%>