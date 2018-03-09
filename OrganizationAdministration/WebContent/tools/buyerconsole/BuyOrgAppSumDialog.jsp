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
   CommandContext cmdContext = 
   		(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
      
   String localeUsed = locale.toString();
   
   com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
   String orgEntityId = URLParameters.getParameter("orgEntityId");
   String aprv_ids = URLParameters.getParameter("aprv_ids");   
   String aprv_ids2 = URLParameters.getParameter("aprv_ids2");
   OrgEntityDataBean oedb = new OrgEntityDataBean();
   AddressDataBean dbAddress = new AddressDataBean();

   if(!(orgEntityId == null || orgEntityId.trim().length()==0)) 
   {
     	oedb.setDataBeanKeyMemberId(orgEntityId);
     	oedb.populate();
     	
		java.util.Enumeration enumAddresses 
			= new AddressAccessBean().findByMemberId(new Long(orgEntityId));
		AddressAccessBean a = (AddressAccessBean)enumAddresses.nextElement();
		
		dbAddress.setAddressId(a.getAddressId());
		dbAddress.setCommandContext(cmdContext);
		dbAddress.populate();
   }
   
   Long[] uIds = oedb.getChildUsers();
   
     
   String parentMemberId = oedb.getParentMemberId();
   OrgEntityDataBean oedb2 = new OrgEntityDataBean();
   if(!(parentMemberId == null || parentMemberId.trim().length()==0)) 
   {
     oedb2.setDataBeanKeyMemberId(parentMemberId);
     com.ibm.commerce.beans.DataBeanManager.activate(oedb2, request);
   }
   
   String orgName = oedb.getOrgEntityName();
   
   
   Hashtable formats = (Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
   Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale.toString());

   if (format == null) 
   {
   	format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
   } 
   
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

  String memberId2 = uIds[0].toString();

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
  

%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<SCRIPT SRC="<%=webalias%>javascript/tools/csr/user.js"></SCRIPT>
<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   parent.put("aprv_ids", "<%=aprv_ids%>" + "," + "<%=aprv_ids2%>");
   parent.setContentFrameLoaded(true);

}


function savePanelData()
{

}
 
function validatePanelData()
{
   return true;
}

function displayAddrItem(num)
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");

   var mandatory = true;
   if (addrOrderList[num] == "street")
   {
      //println("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("street"))%><BR>");
      document.write("<i><%=UIUtil.toHTML(oedb.getAttribute(ECUserConstants.EC_ADDR_ADDRESS1))%></i><BR>");
      document.write("<i><%=UIUtil.toHTML(oedb.getAttribute(ECUserConstants.EC_ADDR_ADDRESS2))%></i><BR>");
      document.write("<i><%=UIUtil.toHTML(oedb.getAttribute(ECUserConstants.EC_ADDR_ADDRESS3))%></i>");
   }
   else if (addrOrderList[num] == "city")
   {
      //println("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("city"))%><BR>");
      document.write("<i><%=UIUtil.toHTML(oedb.getAttribute(ECUserConstants.EC_ADDR_CITY))%></i>");
   }
   else if (addrOrderList[num] == "state")
   {
      //println("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("state"))%><BR>");
      document.write("<i><%=UIUtil.toHTML(dbAddress.getStateProvDisplayName())%></i>");
   }
   else if (addrOrderList[num] == "country")
   {
     
      //println("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("country"))%><BR>");
      document.write("<i><%=UIUtil.toHTML(dbAddress.getCountryDisplayName())%></i>");
   }
   else if (addrOrderList[num] == "zip")
   {
      //println("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("zip"))%><BR>");
      document.write("<i><%=UIUtil.toHTML(oedb.getAttribute(ECUserConstants.EC_ADDR_ZIPCODE))%></i>");
   }
}

function printTitle()
{
   <%if(userBean.getPersonTitle() != null && displayTitle) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralTitle"))%>:");
      document.write("<i><%=UIUtil.toHTML(userBean.getPersonTitle())%></i>");
   <%}%>
}

function printFirstName()
{
   <%if(userBean.getFirstName() != null) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralFirstName"))%>");
      document.write("</TD><TD><i><%=UIUtil.toHTML(userBean.getFirstName())%></i>");
  <%}%>

}

function printInit()
{
   <%if(userBean.getMiddleName() != null && displayMiddleName) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralInitial"))%>");
      document.write("</TD><TD><i><%=UIUtil.toHTML(userBean.getMiddleName())%></i>");
  <%}%>

}

function printLastName()
{

   <%if(userBean.getLastName() != null && displayMiddleName) {
   %>
      document.write("<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralLastName"))%>");
      document.write("</TD><TD><i><%=UIUtil.toHTML(userBean.getLastName())%></i>");
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
<H1><%=UIUtil.toHTML((String)orgEntityNLS.get("orgAppSum"))%></H1>


<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityStatus"))%>">
<TR>
<TD>
<%=UIUtil.toHTML((String)orgEntityNLS.get("orgEntityNameColumn"))%>:
<%
    if(orgName != null) {
       out.println("</TD><TD><i>" + orgName + "</i><BR>");
    }
%>
</TD>
</TR>

<TR>
<TD>
<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralDistinguishedName"))%>:
<%
    if(oedb.getDistinguishedName() != null) {
       out.println("</TD><TD><i>" + oedb.getDistinguishedName() + "</i><BR>");
    }
%>
</TD>
</TR>

    <TR><TD valign="top"><%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityAddress"))%>:
    </TD>
      <TD>
        <script>displayAddrItem(0)</script>
      </TD>
    </TR>
    <TR><TD></TD>
      <TD>
        <script>displayAddrItem(1)</script>
      </TD>
    </TR>
    <TR><TD></TD>
      <TD>
        <script>displayAddrItem(2)</script>
      </TD>
    </TR>
    <TR><TD></TD>
      <TD>
        <script>displayAddrItem(3)</script>
      </TD>
    </TR>
    <TR><TD></TD>
      <TD>
        <script>displayAddrItem(4)</script>
      </TD>
    </TR>
    

<TR><TD><BR><TD></TR>

<TR>
<TD>
<%=UIUtil.toHTML((String)orgEntityNLS.get("orgEntityParentNameColumn"))%>:
<%
    if(oedb2.getOrgEntityName() != null) {
       out.println("</TD><TD><i>" + oedb2.getOrgEntityName() + "</i><BR>");
    }
%>
</TD>
</TR>

<TR><TD><BR><TD></TR>

</table>

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("usrAppSum"))%></H1>
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
	document.write("<TR><TD>");
	printInit();
	document.write("</TD></TR>");
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
<i><%=UIUtil.toHTML(roleNames)%></i>
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



</FORM>
</BODY>
</HTML>

