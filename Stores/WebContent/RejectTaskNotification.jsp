<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

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

(c) Copyright IBM Corp. 1997, 2002

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
com.ibm.commerce.contentmanagement.common.CMWorkspaceConstants,
com.ibm.commerce.ubf.util.BusinessFlowConstants,
com.ibm.commerce.user.beans.*,
com.ibm.commerce.user.objects.*"%><%
CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
response.setContentType("text/html;charset=UTF-8");
%>

<%

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
     

ResourceBundle notificationRB = ResourceBundle.getBundle("RejectTaskNotification", locale);
JSPHelper jspHelper 	= new JSPHelper(request);

     	String SUCCESS_INTRO = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTINTROKEY);
     	String SUCCESS_PART1 = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTTASKNAMEKEY);
     	String SUCCESS_PART2 = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTTASKGROUPNAMEKEY);
     	String SUCCESS_PART3 = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTWORKSPACENAMEKEY);
     	String SUCCESS_PART4 = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTDUEDATEKEY);
     	String SUCCESS_PART5 = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_CONTENTCOMMENTSKEY);
     	String ERROR_MSG = notificationRB.getString(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_ERRORMESSAGEKEY);
     
     	String taskName = jspHelper.getParameter(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_TASKNAMEKEY);
 	String taskGroupName = jspHelper.getParameter(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_TASKGROUPNAMEKEY);
 	String workspaceName = jspHelper.getParameter(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_WORKSPACENAMEKEY);
 	String dueDate = jspHelper.getParameter(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_DUEDATEKEY);
 	
 	String comments = jspHelper.getParameter(CMWorkspaceConstants.CM_CONT_MAN_REJECTEMAIL_COMMENTSKEY);
	
	taskName = jspHelper.htmlTextEncoder(taskName);
	taskGroupName = jspHelper.htmlTextEncoder(taskGroupName);
	workspaceName = jspHelper.htmlTextEncoder(workspaceName);
	dueDate = jspHelper.htmlTextEncoder(dueDate);
	comments = jspHelper.htmlTextEncoder(comments);
	
	if (taskName==null) {
         out.println(ERROR_MSG);
	    return;
	}
	
	out.println(SUCCESS_INTRO);
	out.println("");
	out.println(SUCCESS_PART1 + taskName );
	out.println(SUCCESS_PART2 + taskGroupName );
	out.println(SUCCESS_PART3 + workspaceName );
	out.println(SUCCESS_PART4 + dueDate );
	out.println(SUCCESS_PART5 + comments);
    
%>

