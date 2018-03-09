<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<%@include file="ORReportOutputHelper.jsp" %>
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
		try
		{
			AddressAccessBean  addressBean = new AddressAccessBean ();  
			Enumeration en = addressBean.findByMemberId(new Long(UserId));
			while (en.hasMoreElements())
			{
				AddressAccessBean bean = (AddressAccessBean)en.nextElement();
				if(bean.getPrimary() != null && bean.getPrimary().equals("1") && 
						bean.getAddressType() != null && bean.getAddressType().equals("B"))
				{
					String firstName = bean.getFirstName();
					String lastName = bean.getLastName();
					buff.append("<b>" + reportsRB.get(reportPrefix + "FirstName") + "</b> ");
					if(firstName != null && !firstName.equals(""))
					{
						buff.append(firstName + "<BR>");
					}
					else
					{
						buff.append("<BR>");
					}
					buff.append("<b>" + reportsRB.get(reportPrefix + "LastName") + "</b> ");
					if(lastName != null && !lastName.equals(""))
					{
						buff.append(lastName + "<BR>");
					}
					else
					{
						buff.append("<BR>");
					}
				}
			}
		}
		catch(Exception ex)
		{
		}
	}
	buff.append("   </DIV><BR><BR>\n\n");
	return buff.toString();
}

%>