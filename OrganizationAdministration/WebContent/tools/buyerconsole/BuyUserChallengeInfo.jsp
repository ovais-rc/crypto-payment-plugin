<!--========================================================================== 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
===========================================================================-->

<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Locale locale = cmdContext.getLocale();

  // obtain the resource bundle for display
  Hashtable userWizardNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   
  boolean displayChallengeQuestionAnswer = "true".equalsIgnoreCase(com.ibm.commerce.server.WcsApp.configProperties.getValue("OrgAdminConsole/ShowChallengeInformation"));
  
  JSPHelper jspHelper = new JSPHelper(request);
  String memberId = jspHelper.getParameter("memberId");
  UserRegistrationDataBean bnUser = new UserRegistrationDataBean();
   
  if(!(memberId == null || memberId.trim().length()==0)) 
  {
      bnUser.setDataBeanKeyMemberId(memberId);
      com.ibm.commerce.beans.DataBeanManager.activate(bnUser, request);
  }
%>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>

<script>
<!---- hide script from old browsers
function initializeUserChallengeInfoData()
{
   if ("<%=memberId%>" != null || "<%=memberId%>" != "") {
      if (document.entryForm.<%= ECUserConstants.EC_UREG_CHALLENGEQUESTION %>.value == "") {
          document.entryForm.<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEQUESTION ) %>.value  = "<%= UIUtil.toHTML( bnUser.getAttribute(ECUserConstants.EC_UREG_CHALLENGEQUESTION) ) %>";
      }
      if (document.entryForm.<%= ECUserConstants.EC_UREG_CHALLENGEANSWER %>.value == "") {
          document.entryForm.<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEANSWER ) %>.value    = "<%= UIUtil.toHTML( bnUser.getAttribute(ECUserConstants.EC_UREG_CHALLENGEANSWER) ) %>";
      }
   }
}

function validateChQuestionLength()
{
  if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_UREG_CHALLENGEQUESTION %>.value, 254))
  {
  	return false;
  } else {
  	return true;
  }
}

function validateChAnswerLength()
{
  if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_UREG_CHALLENGEANSWER %>.value, 254))
  {
  	return false;
  } else {
  	return true;
  }
}
//-->
</script>

<table border="0" cellpadding="1" cellspacing="0">
  <tr><th></th></tr>
  <tbody>

  <%
  if (displayChallengeQuestionAnswer)
  {
  %>

  <tr>
  <td>
      <label>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralchQuestion"))%><br>
      <input size="30" type="input" name="<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEQUESTION ) %>" maxlength="254">
      </label>
  </td>
  <td>
      <label>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralchAnswer"))%><br>
      <input size="30" type="input" name="<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEANSWER ) %>" maxlength="254">
      </label>
  </td>
  </tr>

  <%
  }
  else
  {
  %>
      <input type="hidden" name="<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEQUESTION ) %>" />
      <input type="hidden" name="<%= UIUtil.toHTML( ECUserConstants.EC_UREG_CHALLENGEANSWER ) %>" />  
  <%
  }//end-if (displayChallengeQuestionAnswer)
  %>
</table>

<script language="JavaScript">
<!---- hide script from old browsers
   initializeUserChallengeInfoData();
//-->
</script>
