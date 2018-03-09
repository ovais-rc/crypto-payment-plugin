<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>dulicateRequest.jsp</TITLE>
</HEAD>
<BODY>
<P>!! busy, please try again !!</P>
<BR>
<%
	String url = (String)request.getAttribute("reExecuteURL");
    out.write("reExecuteURL="+url);
    
%>
</p>
<FORM METHOD=POST ACTION="<%= url %>">
<P><INPUT TYPE=SUBMIT VALUE="continue" >
</FORM>
<br>

</BODY>
</HTML>
