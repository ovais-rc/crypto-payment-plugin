<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
--> 
<%@ page language="java" %>

<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.usermanagement.commands.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ include file= "../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");

   String userGeneralLogonIdEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLogonIdEmpty"));
   String userGeneralLastNameEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLastNameEmpty"));
   String userGeneralPasswordEmpty = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralPasswordEmpty"));
   String userGeneralPasswordNotMatched = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralPasswordNotMatched"));
   String userGeneralLogonIdUpdateFailed = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralLogonIdUpdateFailed"));
   String userGeneralAdminTypeUpdateFailed = UIUtil.toJavaScript((String)userWizardNLS.get("userGeneralAdminTypeUpdateFailed"));
   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));

   com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
   String localeUsed = locale.toString();
   com.ibm.commerce.server.JSPHelper jspHelper1 = new JSPHelper(request);
   //String xmlFileParm = jspHelper1.getParameter("XMLFile");
   String xmlFileParm = URLParameters.getParameter("XMLFile");
   Hashtable xmlTree = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyUserAppSumDialog");

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
       if ( nameFormatFields[i].equals("title") )
         displayTitle = true;
       else if ( nameFormatFields[i].equals("middleName") )
         displayMiddleName = true;
       else if ( nameFormatFields[i].equals("lastName") )
         displayLastNamePos = i;
       else if ( nameFormatFields[i].equals("firstName") )
         displayFirstNamePos = i;
     }
     if (displayLastNamePos < displayFirstNamePos)
       displayLastNameFirst = true;
   } else {
       displayMiddleName = true;
       displayLastNameFirst = true;
   }
  
   UserAdminDataBean userBean = new UserAdminDataBean();  

String memberId2 = URLParameters.getParameter("userId");

//   String memberId2 = request.getParameter("userId");
   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     userBean.setMemberId(memberId2);
     com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
   }
   
   UserRegistrationDataBean urdb = new UserRegistrationDataBean();

   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     urdb.setDataBeanKeyMemberId(memberId2);
     com.ibm.commerce.beans.DataBeanManager.activate(urdb, request);
   }
   
   Integer[] rootRoles = urdb.getRoles();
   String roleNames = "";
   if (rootRoles != null) { 
   for (int i =0; i < rootRoles.length; i++) {
   
       RoleDataBean rdb = new RoleDataBean();
       rdb.setDataBeanKeyRoleId(rootRoles[i].toString());
      
       com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
       roleNames = roleNames + rdb.getName();
       if (i != (rootRoles.length - 1)) roleNames = roleNames + ", ";
       
          
   }
   }
   
   String orgId = urdb.getParentMemberId();
   OrgEntityDataBean oedb = new OrgEntityDataBean();
   if(!(orgId == null || orgId.trim().length()==0)) 
   {
     oedb.setDataBeanKeyMemberId(orgId);
     com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
   }
   
   String orgName = oedb.getOrgEntityName();
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
  
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
  
  

}
 
function validatePanelData()
{
  

   return true;
}

function printTitle()
{
   <%if(userBean.getPersonTitle() != null && displayTitle) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralTitle"))%>:");
      document.write("<i><%=userBean.getPersonTitle()%></i>");
   <%}%>
}

function printFirstName()
{
   <%if(userBean.getFirstName() != null) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralFirstName"))%>");
      document.write("</TD><TD><i><%=userBean.getFirstName()%></i>");
  <%}%>

}

function printInit()
{
   <%if(userBean.getMiddleName() != null && displayMiddleName) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralInitial"))%>");
      document.write("</TD><TD><i><%=userBean.getMiddleName()%></i>");
  <%}%>

}

function printLastName()
{

   <%if(userBean.getLastName() != null && displayMiddleName) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastName"))%>");
      document.write("</TD><TD><i><%=userBean.getLastName()%></i>");
  <%}%>


}



</SCRIPT>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState();" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("usrAppSum"))%></H1>


<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)userWizardNLS.get("AdminConsoleTableSumUserAdminGeneral"))%>">
<%
   if (displayTitle) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printTitle();
	document.write("</TD></TR>");
     </script>
<%
   }

   if (displayLastNameFirst) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printLastName();
	document.write("</TD></TR>");
     </script>
<%
   }
%>

     <script language="javascript">
	document.write("<TR><TD>");
	printFirstName();
	document.write("</TD>");
     </script>

<%
   if (displayMiddleName) 
   {
%>
     <script language="javascript">
	document.write("<TD>");
	printInit();
	document.write("</TD>");
     </script>
<%
   }
%>

     <script language="javascript">
	document.write("</TR>");
     </script>

<%
   if (!displayLastNameFirst) 
   {
%>
     <script language="javascript">
	document.write("<TR><TD>");
	printLastName();
	document.write("</TD></TR>");
     </script>
<%
   }
%>

<TR>
<TD>
<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLogonId"))%>:
<%
    if(userBean.getLogonId() != null) {
       out.println("</TD><TD><i>" + userBean.getLogonId() + "</i><BR>");
    }
%>
</TD>
</TR>

<TR>
<TD>
<%=UIUtil.toHTML((String)userWizardNLS.get("userAdminFindOrg"))%>:
<%
    if(orgName != null) {
       out.println("</TD><TD><i>" + orgName + "</i><BR>");
    }
%>
</TD>
</TR>

<TR>
<TD>
<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles"))%>:
</TD><TD>
<i><%=roleNames%></i>
</TD>
</TR>

<TR>
<TD>
<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralDeptNum"))%>:
<%
    if(urdb.getDepartmentNumber() != null) {
       out.println("</TD><TD><i>" + urdb.getDepartmentNumber() + "</i><BR>");
    }
%>
</TD>
</TR>


<TR>
<TD>
<%=UIUtil.toHTML((String)userWizardNLS.get("email1"))%>:
<%
    if(urdb.getEmail1() != null) {
       out.println("</TD><TD><i>" + urdb.getEmail1() + "</i><BR>");
    }
%>
</TD>
</TR>



<TR><TD><BR><TD></TR>

</table>

<%
        String dateTemp = memberId2;

       if(dateTemp != null && dateTemp.trim().length()!=0) {
%>

<table>
<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralRegistration"))%>: 
</TD>
<%
	if(userBean.getRegistration() != null && userBean.getRegistration().trim().length()!=0) {
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t3 = Timestamp.valueOf(userBean.getRegistration());
		   	String adjustedDate3 = TimestampHelper.getDateFromTimestamp(t3, locale);
			out.println(adjustedDate3 + " ");
			String adjustedTime3 = TimestampHelper.getTimeFromTimestamp(t3);
			out.println(adjustedTime3);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>

<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastVisit"))%>: 
</TD>
<%
	if(userBean.getLastSession() != null && userBean.getLastSession().trim().length()!=0) {
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t = Timestamp.valueOf(userBean.getLastSession());
		   	String adjustedDate = TimestampHelper.getDateFromTimestamp(t, locale);
			out.println(adjustedDate);
			String adjustedTime = TimestampHelper.getTimeFromTimestamp(t);
			out.println(adjustedTime);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>

<TR>
<TD>	<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastUpdated"))%>:
</TD>
<%
	if(userBean.getRegistrationUpdate() != null && userBean.getRegistrationUpdate().trim().length()!=0) {	
%>
<TD>		<% out.println("<i>"); %>
		<% 
			Timestamp t2 = Timestamp.valueOf(userBean.getRegistrationUpdate());
		   	String adjustedDate2 = TimestampHelper.getDateFromTimestamp(t2, locale);
			out.println(adjustedDate2);
			String adjustedTime2 = TimestampHelper.getTimeFromTimestamp(t2);
			out.println(adjustedTime2);
		%>
		<% out.println("</i>"); %>
</TD>
<%
	}
%>
</TR>


</table>
<%
	}
%>


</FORM>
</BODY>
</HTML>

