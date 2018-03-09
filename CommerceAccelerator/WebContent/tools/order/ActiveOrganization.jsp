<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
%>

<HTML>
<head>
  <script language="JavaScript" type="text/javascript">
  function getFromTop(){
		var orgName = top.get("selectedOrgName");
		return orgName; 
		
	}
</SCRIPT>
</head>

<BODY> 
  <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="bottom" align="left">
             <%= UIUtil.toHTML((String)resourceBundle.get("activeOrganization")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><script>document.write(getFromTop()); </script></i>
          </td>
        </tr>
        
   </table>
   <br />
  
  

</BODY>

</HTML>



