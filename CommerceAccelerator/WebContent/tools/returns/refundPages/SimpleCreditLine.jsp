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

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable resourceBundle = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	
%>


<TABLE>
     <TR><TD><LABEL for="accountNumber1"><%= UIUtil.toHTML( (String)resourceBundle.get("accountNumber")) %></LABEL></TD></TR>

     <TR>
     <TD>
          <INPUT TYPE=text SIZE=30 MAXLENGTH=256 NAME="accountNumber" ID="accountNumber1" VALUE=""  >
     </TD>
     </TR>
</TABLE>
