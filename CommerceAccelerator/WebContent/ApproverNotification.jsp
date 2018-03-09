<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--============================================================================

   The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions. IBM, therefore, cannot guarantee
reliability, serviceability or function of these programs. All programs
contained herein are provided to you "AS IS".

   The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible. All of these are names are ficticious and any similarity to the
names and addresses used by actual persons or business enterprises is entirely
coincidental.

Licensed Materials - Property of IBM

5697-D24	5798-NC3

(c) Copyright IBM Corp. 1997, 2016

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

==============================================================================--%><%@ 
page import="javax.servlet.*,
java.io.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.common.objimpl.*,
com.ibm.commerce.common.beans.*,
com.ibm.commerce.ubf.objects.*,
com.ibm.commerce.ubf.registry.*,
com.ibm.commerce.ubf.util.BusinessFlowConstants,
com.ibm.commerce.user.beans.*,
com.ibm.commerce.user.objects.*"%><%
CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
response.setContentType("text/html;charset=UTF-8");
try {
	// Use JSPHelper to extract parameters:
	JSPHelper jsphelper=new JSPHelper(request);
	String strEntityId = jsphelper.getParameter(BusinessFlowConstants.EC_ENTITY_ID);
	Long lngFlowId = new Long(jsphelper.getParameter(BusinessFlowConstants.EC_FLOWID));

	String langId = (aCommandContext.getLanguageId()).toString();
	if(langId == null) { langId = com.ibm.commerce.server.WcsApp.siteDefaultLanguageId.toString(); }

	Locale locale = null;
	try {
		LanguageAccessBean languageAccessBean = new LanguageAccessBean();
		languageAccessBean.setInitKey_languageId( langId );  
		String localeString = languageAccessBean.getLocaleName();
		locale = new Locale( localeString.substring(0,2), localeString.substring(3) );
	} catch(Exception e) {
		locale = Locale.getDefault();
		String langName = locale.getLanguage() + "_" + locale.getCountry();
	}

	//out.print("DEBUG:");
	//out.print("  lngFlowId=");	if(null != lngFlowId)	{ out.print(lngFlowId);		}
	//out.print("  strEntityId=");	if(null != strEntityId)	{ out.print(strEntityId);	}
	//out.print("  langId="); 	if(null != langId)	{ out.print(langId);		}
	//out.println("\n");

	JSPResourceBundle bnResourceBundle= new JSPResourceBundle(java.util.ResourceBundle.getBundle("ApprovalNotification",locale));
	String APPROVAL_REQUIRED = bnResourceBundle.getString("ApprovalNotification.ApprovalRequired");
	out.println(APPROVAL_REQUIRED + "\n");

	BusinessFlowManager flowManager= BusinessFlowManager.getInstance();
	BusinessFlow flow= flowManager.getFlow(lngFlowId);
	try {
		//out.println("  " + flow.getDescription(aCommandContext.getLanguageId()));
		BusinessFlowType bft = flow.getBusinessFlowType();
		if ( bft != null )
		{
			out.println("  " + bft.getDescription(aCommandContext.getLanguageId()));
		}
	} catch(javax.persistence.NoResultException e1) {
		//out.println(" Exception: " + e1);	// Did not find description in desired language.
	}
} catch (Exception e) {
	out.print( "Exception " + e);
}
%>