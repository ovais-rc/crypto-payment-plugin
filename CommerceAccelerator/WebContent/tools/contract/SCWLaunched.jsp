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
//*--------------------------------------------------------------------->

<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try{
		String titleStr = (String)resourceBundle.get("mcltitle");
		String msg1Str = (String)resourceBundle.get("message1");
		String msg2Str = (String)resourceBundle.get("message2");
		String msg3Str = (String)resourceBundle.get("message3");
		String copyrightStr = (String)logonResource.get("copyright");

		boolean fromAccelerator = false;
        	Cookie[] cookies = request.getCookies();   
        	for (int i = 0; i < cookies.length; i++){
			if (cookies[i].getName().equalsIgnoreCase("fromAcceleratorCookie")) {
				if (cookies[i].getValue().equals("true")) {
					fromAccelerator = true;
					msg3Str = "";
				}
				break;
			}
		} 
%>

<html>

<head>
<title> <%= titleStr%> </title>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/contract/StoreCreationWizardLogon.js">
</script>
</head>
<body>
<table width=100% height=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 id="SCWLaunched_Table_1">
	<tr>
		<td id="SCWLaunched_TableCell_1">
			<table width=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 id="SCWLaunched_Table_2">
				<tr>
				<% if (fromAccelerator == false) { %> 
					<td COLSPAN=4 HEIGHT="44" class="logon" id="SCWLaunched_TableCell_2">&nbsp;</td>
				 <% } %>
				</tr>
			</table>
			<table height=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 WIDTH=791 id="SCWLaunched_Table_3">
				<tr>
					<td WIDTH="20" ROWSPAN="3" id="SCWLaunched_TableCell_3">&nbsp;</td>
					<td class="h1" HEIGHT="30" id="SCWLaunched_TableCell_4"><%= titleStr%></td>
					<td ROWSPAN="3" VALIGN=TOP WIDTH="320" HEIGHT=100% id="SCWLaunched_TableCell_5"><img src="/wcs/images/tools/logon/logon.jpg" border="0" alt=""></td>
				</tr>

				<tr>
					<td VALIGN=TOP id="SCWLaunched_TableCell_6">
						<%= UIUtil.toHTML(msg1Str)%><p>
						<%= UIUtil.toHTML(msg2Str) %><p>
						<script>
							document.write(changeSpecialText("<%= UIUtil.toHTML(msg3Str) %>", '<B>', '</B>', '<B>', '</B>'));
						
</script>
					</td>
				</tr>
				<tr>
					<td HEIGHT=99% id="SCWLaunched_TableCell_7">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<% if (fromAccelerator == false) { %> 
		<td COLSPAN=4 class="legal" id="SCWLaunched_TableCell_8"><%= UIUtil.toHTML(copyrightStr) %></td>
	 <% } %>
	</tr>
</table>
</body>
</html>
<%
	}catch(Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
	<% }
%>
