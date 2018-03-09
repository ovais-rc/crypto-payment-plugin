<?xml version="1.0" encoding="UTF-8"?>

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

<%@ page import="javax.servlet.*" %><%@ page import="com.ibm.commerce.server.*" %><%@ page import="com.ibm.commerce.beans.*" %><%@ page import="com.ibm.commerce.datatype.*" %><%@ page import="java.util.*" %><%@page import="com.ibm.commerce.server.JSPHelper" %><WCS_Error type="GenericSystemError">
<% 
response.setContentType("text/xml;charset=UTF-8");
try { %><RequestAttributes>
<%


  JSPHelper jsphelper = new JSPHelper(request);

  Enumeration e1 = request.getParameterNames();
  while(e1.hasMoreElements() ) {
    String param_name = (String)e1.nextElement();
    String param_value = jsphelper.getParameter(param_name);
%>	<<%= param_name %>><%=param_value%></<%=param_name%>>    
<%   
  }

  e1 = request.getAttributeNames();
  while(e1.hasMoreElements() ) {
    String param_name = (String)e1.nextElement();
    String param_value = jsphelper.getParameter(param_name);
%>	<<%= param_name %>><%=param_value%></<%=param_name%>>
<%   

  }


%></RequestAttributes>
<%
} catch (Exception e) {}

try {
	ErrorDataBean errorBean = new ErrorDataBean ();
	errorBean.populate();
%><Exception>
		<ExceptionType><%= errorBean.getExceptionType()%></ExceptionType>
		<MessageKey><%= errorBean.getMessageKey() %></MessageKey>
		<Message><%= errorBean.getMessage() %></Message>
		<OrginatingCommand><%= errorBean.getOriginatingCommand() %></OrginatingCommand>
		<ExceptionParameters>	
<%
TypedProperty nvps = errorBean.getExceptionData();
if (nvps != null) {
	Enumeration en = nvps.keys();

	while(en.hasMoreElements()) {
		String name = (String)en.nextElement();
%>		<<%= name %>><%= nvps.getString(name, "") %><<%=name%>>
<% }
} %>	</ExceptionParameters>
	<ExceptionStack>
		<%= errorBean.getStackTrace() %>
	</ExceptionStack>
</Exception>	
<%
	} catch(Exception e) {}
%>	
</WCS_Error>
