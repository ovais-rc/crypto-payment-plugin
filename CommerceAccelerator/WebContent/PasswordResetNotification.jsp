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

(c) Copyright IBM Corp. 1997, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp


==============================================================================--%>

<%@ page import="javax.servlet.*,
java.io.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.usermanagement.commands.ECUserConstants,
com.ibm.commerce.security.commands.ECSecurityConstants" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>


<%
CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
response.setContentType("text/html;charset=UTF-8");
Integer langId = null;
String localeString = null;
Locale locale = null;
langId = aCommandContext.getLanguageId();
try
   {
      LanguageAccessBean languageAccessBean = new LanguageAccessBean();
      languageAccessBean.setInitKey_languageId( langId.toString() );  
      localeString = languageAccessBean.getLocaleName();
	if (localeString != null)
	      locale = new Locale( localeString.substring(0,2), localeString.substring(3) );
	else
		locale = Locale.getDefault();
   }
   catch(Exception e)
   {
      localeString ="en_US";
	locale = new Locale( localeString.substring(0,2), localeString.substring(3) );
   } 


try {
	JSPHelper jsphelper=new JSPHelper(request);
     JSPResourceBundle bnResourceBundle= new JSPResourceBundle(java.util.ResourceBundle.getBundle("PasswordResetNotification",locale));
	String strLogonId = jsphelper.getParameter(ECUserConstants.EC_UREG_LOGONID);
	String strPassword = jsphelper.getParameter(ECUserConstants.EC_UREG_LOGONPASSWORD);
     String ERROR_MSG = bnResourceBundle.getString("PasswordResetNotification.ErrorMessage1");
     String SUCCESS_PART2 = bnResourceBundle.getString("PasswordResetNotification.MessagePart2");
     String SUCCESS_PART1 = bnResourceBundle.getString("PasswordResetNotification.MessagePart1");
	if (strLogonId==null || strPassword==null ) {
         out.println(ERROR_MSG);
	    return;
	}

     out.println(SUCCESS_PART1 + " " + strLogonId + " " +  SUCCESS_PART2 + " " + strPassword);

} catch (Exception e){
	out.print( "Exception " + e);
}
%>
