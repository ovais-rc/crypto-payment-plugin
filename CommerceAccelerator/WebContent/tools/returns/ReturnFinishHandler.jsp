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

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>

<%
Hashtable returnsNLS = (Hashtable)request.getAttribute("returnsNLS");
String returnId = (String)request.getAttribute("returnId");
%>

<SCRIPT>
function rmaFinishHandler(finishMessage)
{
	if (finishMessage=="finishApprovedMsg")
	{
		var msgArray="<%= UIUtil.toJavaScript((String)returnsNLS.get("finishApprovedMsg")) %>".split("?");
		alertDialog(msgArray[0]+"<%=returnId%>"+msgArray[1]);
		top.goBack();
	}
	else if (finishMessage=="finishNotApprovedMsg")
	{
		var msgArray="<%= UIUtil.toJavaScript((String)returnsNLS.get("finishNotApprovedMsg")) %>".split("?");
		alertDialog(msgArray[0]+"<%=returnId%>"+msgArray[1]);
		top.goBack();
	}
	else if (finishMessage=="finishRmaExpiredMsg")
	{
		alertDialog("<%= UIUtil.toJavaScript((String)returnsNLS.get("finishRmaExpiredMsg")) %>");
		parent.gotoPanel("ReturnConfAndAdjustPage");
	}
	else if (finishMessage=="okApprovedMsg")
	{
		var msgArray="<%= UIUtil.toJavaScript((String)returnsNLS.get("okApprovedMsg")) %>".split("?");
		alertDialog(msgArray[0]+"<%=returnId%>"+msgArray[1]);
		top.goBack();
	}
	else if (finishMessage=="okNotApprovedMsg")
	{
		var msgArray="<%= UIUtil.toJavaScript((String)returnsNLS.get("okNotApprovedMsg")) %>".split("?");
		alertDialog(msgArray[0]+"<%=returnId%>"+msgArray[1]);
		top.goBack();
	}
	else
		top.goBack();
}
</SCRIPT>