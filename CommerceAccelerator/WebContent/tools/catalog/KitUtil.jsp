<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.utils.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.ras.*" %>

<%!
public String getNLString(Hashtable nls, String strName)
{
	String strRet="";
	try{
		strRet=UIUtil.toJavaScript((String)nls.get(strName)); 
	}catch(Exception ex){
		ex.toString();	//pass jtest
	}
	return strRet;	
}

public String toHTML(String str)
{
	String strRet="";
	try{
		strRet=UIUtil.toHTML(str);
	}catch(Exception ex){
		ex.toString();	//pass jtest
	}
	return strRet;	
}

public String toJavaScript(String str)
{
	String strRet="";
	try{
		strRet=UIUtil.toJavaScript(str);
	}catch(Exception ex){
		ex.toString();	//pass jtest
	}
	return strRet;	
}

public void jspTrace(String strMsg)
{
	ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, 
				  this.getClass().getName(), 
				  "JSP_METHOD",
				  strMsg);
}

public void jspTrace(Exception ex)
{
	jspTrace("Exception= "+ex.toString());
}

%>
