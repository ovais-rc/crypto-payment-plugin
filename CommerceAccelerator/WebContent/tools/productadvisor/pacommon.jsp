<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.*" %>

<%@page session="false" %>
<% response.setContentType("text/html;charset=UTF-8"); %>

<% response.setHeader("Pragma", "No-cache"); %>
<% response.setDateHeader("Expires", 0); %>
<% response.setHeader("Cache-Control", "no-cache"); %>
<%!
//   static final String fHeader = "<LINK rel='stylesheet' href='/wcs/tools/common/centre.css'>";
   static String fHeader = "";
%>
<%!
// LL021223, to fix NL problems
private String getNLString(Hashtable nls, String strName)
{
	String strRet="";
	try{
		strRet=UIUtil.toJavaScript((String)nls.get(strName)); 
	}catch(Exception ex){
		ex.toString();	
	}
	return strRet;	
}
// LL021223, to fix NL problems
private String toHTML(Object str)
{
	String strRet="";
	try{
		strRet=UIUtil.toHTML((String)str);
	}catch(Exception ex){
		ex.toString();	
	}
	return strRet;	
}

%>

<%
   CommandContext paCommandContext = null;
   Hashtable productAdvisorRB = null;
   try{
   		paCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	   	fHeader = "<LINK rel='stylesheet' href='" + UIUtil.getCSSFile(paCommandContext.getLocale()) + "'>";
 		productAdvisorRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("productAdvisor.productAdvisorRB",paCommandContext.getLocale());
	} catch (Exception e){
		e.printStackTrace();
	}
%>