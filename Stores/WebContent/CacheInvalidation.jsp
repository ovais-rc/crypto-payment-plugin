<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>

<% response.setHeader("Pragma", "No-cache");           %>
<% response.setDateHeader("Expires", 0);               %>
<% response.setHeader("Cache-Control", "no-cache");    %>


<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML lang="en">
<HEAD>
	<TITLE>Cache Invalidation Report Page</TITLE>
</HEAD>

<BODY text="#000000" link="#0000FF" vlink="#008484" alink="#FF0000" 
 BGCOLOR=#8FFA28FF8>

<CENTER>
<TABLE>
	<TR>
	<TD><strong><%="Cache Invalidation Command Results"%></strong></TD>
	</TR>
</TABLE>
</CENTER>

<br>&nbsp;
<br>&nbsp;
<br>&nbsp;
<center>
The DynaCacheInvalidation command was executed 
successfully</center>
<br>&nbsp;

</BODY>
</HTML>



