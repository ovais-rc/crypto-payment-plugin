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
<%@ page import="java.text.Collator" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.Util" %>
<%@ page import="com.ibm.commerce.tools.xml.XMLUtil" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%!
	/**
	 * Compare two strings and check if they are equal.
	 * 
	 * @param s1 First string to compare
	 * @param s2 Second string to compare
	 * @param locale The locale to compare on
	 * @return True for equal, or false otherwise.
	 */
	private boolean compstr (String s1, String s2, Locale _locale) {
		Collator myCollator = Collator.getInstance (_locale);
		boolean b = (myCollator.compare(s1,s2) == 0);
		return b;
	}

%>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);

   String localeUsed = locale.toString();
   JSPHelper jspHelper = new JSPHelper(request);
   Hashtable xmlTree = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyUserAdminDetail");

   Hashtable localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "nlsNameFormats."+ localeUsed);
   if (localeNameFormat == null)
   {
     localeNameFormat = (Hashtable)XMLUtil.get(xmlTree, "nlsNameFormats.default");
   }

   boolean displayLastNameFirst = false;
   boolean displayTitle = false;
   boolean displayMiddleName = false;
   int displayLastNamePos = 0;
   int displayFirstNamePos = 0;

   String nameFormatStr = (String)XMLUtil.get(localeNameFormat,"name.fields");
   if (nameFormatStr != null)
   {
     String[] nameFormatFields = Util.tokenize(nameFormatStr, ",");

     for (int i=0; i < nameFormatFields.length; i++)
     {
       if ( compstr(nameFormatFields[i], "title", locale) ) {
         displayTitle = true;
       } else if ( compstr(nameFormatFields[i], "middleName", locale) ) {
         displayMiddleName = true;
       } else if ( compstr(nameFormatFields[i], "lastName", locale) ) {
         displayLastNamePos = i;
       } else if ( compstr(nameFormatFields[i], "firstName", locale) ) {
         displayFirstNamePos = i;
       }
     }
     if (displayLastNamePos < displayFirstNamePos) {
       displayLastNameFirst = true;
     }
   }
   
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
function initializeUserInfoData()
{
   if ("<%=memberId%>" != null || "<%=memberId%>" != "") {
      <%
      if (displayTitle)
      {
      %>
          if (document.entryForm.<%= ECUserConstants.EC_ADDR_PERSONTITLE %>.value == "") {
              document.entryForm.<%= ECUserConstants.EC_ADDR_PERSONTITLE %>.value  = "<%= UIUtil.toJavaScript(bnUser.getAttribute(ECUserConstants.EC_ADDR_PERSONTITLE)) %>";
          }
      <%
      }
      %>
      if (document.entryForm.<%= ECUserConstants.EC_ADDR_FIRSTNAME %>.value == "") {
          document.entryForm.<%= ECUserConstants.EC_ADDR_FIRSTNAME %>.value    = "<%= UIUtil.toJavaScript(bnUser.getAttribute(ECUserConstants.EC_ADDR_FIRSTNAME)) %>";
      }
      <%
      if (displayMiddleName)
      {
      %>
          if (document.entryForm.<%= ECUserConstants.EC_ADDR_MIDDLENAME %>.value == "") {
              document.entryForm.<%= ECUserConstants.EC_ADDR_MIDDLENAME %>.value    = "<%= UIUtil.toJavaScript(bnUser.getAttribute(ECUserConstants.EC_ADDR_MIDDLENAME)) %>";
          }
      <%
      }
      %>
      if (document.entryForm.<%= ECUserConstants.EC_ADDR_LASTNAME %>.value == "") {
          document.entryForm.<%= ECUserConstants.EC_ADDR_LASTNAME %>.value   = "<%= UIUtil.toJavaScript(bnUser.getAttribute(ECUserConstants.EC_ADDR_LASTNAME)) %>";
      }
   }
}

function validateTitleLength()
{
    <%
    if (displayTitle)
    {
    %>
        if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_ADDR_PERSONTITLE %>.value, 50))
        {
  	    return false;
        } else {
  	    return true;
        }
    <%
    }
    else
    {
    %>
        return true;
    <%
    }
    %>
}

function validateFirstNameLength()
{
  if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_ADDR_FIRSTNAME %>.value, 128))
  {
  	return false;
  } else {
  	return true;
  }
}

function validateMiddleNameLength()
{
   <%
   if (displayMiddleName)
   {
   %>
       if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_ADDR_MIDDLENAME %>.value, 128))
       {
  	   return false;
       } else {
  	   return true;
       }
   <%
   }
   else
   {
   %>
       return true;
   <%
   }
   %>
}

function validateLastName()
{
  if(document.entryForm.<%= ECUserConstants.EC_ADDR_LASTNAME %>.value == "")
  {
  	return false;
  } else {
  	return true;
  }
}

function validateLastNameLength()
{
  if(!isValidUTF8length(document.entryForm.<%= ECUserConstants.EC_ADDR_LASTNAME %>.value, 128))
  {
  	return false;
  } else {
  	return true;
  }
}

function printTitle()
{
      document.write("<label for=\"<%= ECUserConstants.EC_ADDR_PERSONTITLE %>\">");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralTitle"))%><br>");
      document.write("</label>");
      document.write("<input size=\"30\" type=\"input\" name=\"<%= ECUserConstants.EC_ADDR_PERSONTITLE %>\" id=\"<%= ECUserConstants.EC_ADDR_PERSONTITLE %>\">");
      
}

function printFirstName()
{
      document.write("<label for=\"<%= ECUserConstants.EC_ADDR_FIRSTNAME %>\">");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralFirstName"))%><br>");
      document.write("</label>");
      document.write("<input size=\"30\" type=\"input\" name=\"<%= ECUserConstants.EC_ADDR_FIRSTNAME %>\" id=\"<%= ECUserConstants.EC_ADDR_FIRSTNAME %>\">");
}

function printInit()
{
      document.write("<label for=\"<%= ECUserConstants.EC_ADDR_MIDDLENAME %>\">");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralInitial"))%><br>");
      document.write("</label>");
      document.write("<input size=\"30\" type=\"input\" name=\"<%= ECUserConstants.EC_ADDR_MIDDLENAME %>\" id=\"<%= ECUserConstants.EC_ADDR_MIDDLENAME %>\">");
}

function printLastName()
{
      document.write("<label for=\"<%= ECUserConstants.EC_ADDR_LASTNAME %>\">");
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastNameReq"))%><br>");
      document.write("</label>");
      document.write("<input size=\"30\" type=\"input\" name=\"<%= ECUserConstants.EC_ADDR_LASTNAME %>\" id=\"<%= ECUserConstants.EC_ADDR_LASTNAME %>\">");
}
//-->
</script>

<table border="0" cellpadding="1" cellspacing="0">
  <tr><th></th></tr>
  <tbody>
<%
   if (displayTitle)
   {
%>
     <script language="javascript">
     <!---- hide script from old browsers
	document.write("<tr><td>");
	printTitle();
	document.write("</td></tr>");
     //-->
     </script>
<%
   }
   
   if (displayLastNameFirst)
   {
%>
     <script language="javascript">
     <!---- hide script from old browsers
	document.write("<tr><td>");
	printLastName();
	document.write("</td></tr>");
     //-->
     </script>
<%
   }
%>

     <script language="javascript">
     <!---- hide script from old browsers
	document.write("<tr><td>");
	printFirstName();
	document.write("</td>");
     //-->
     </script>

<%
   if (displayMiddleName)
   {
%>
     <script language="javascript">
     <!---- hide script from old browsers
	document.write("<tr><td>");
	printInit();
	document.write("</td></tr>");
     //-->
     </script>
<%
   }
%>

     <script language="javascript">
     <!---- hide script from old browsers
	document.write("</tr>");
     //-->
     </script>

<%
   if (!displayLastNameFirst)
   {
%>
     <script language="javascript">
     <!---- hide script from old browsers
	document.write("<tr><td>");
	printLastName();
	document.write("</td></tr>");
     //-->
     </script>
<%
   }
%>
</table>
<script language="JavaScript">
<!---- hide script from old browsers
   initializeUserInfoData();
//-->
</script>
