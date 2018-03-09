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
	JSPHelper jspHelper = new JSPHelper(request);

%>
<HTML>
<HEAD>
   <TITLE><%= UIUtil.toHTML( (String)resourceBundle.get("checkholderInformation")) %></TITLE>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
   <script src="/wcs/javascript/tools/common/Util.js"></script>
</HEAD>

<BODY class="content">
<FORM name="frmStandardACH">

<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    
    <TR>
      <TD><B><%= UIUtil.toHTML( (String)resourceBundle.get("checkInfo")) %><B></TD>
    </TR>
    <TR><TD>
    <BR></TD>
    </TR>
    
    <TR>
      <TD ALIGN="left"><LABEL for="checkingAccountNumber1"><%= UIUtil.toHTML( (String)resourceBundle.get("checkAccountNumber")) %></LABEL></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=17 NAME="checkingAccountNumber" ID="checkingAccountNumber1" VALUE="" >
      </TD>
    </TR>

    <TR>
      <TD ALIGN="left"><LABEL for="checkRoutingNumber1"><%= UIUtil.toHTML( (String)resourceBundle.get("checkRoutingNumber")) %></LABEL></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=9 NAME="checkRoutingNumber" ID="checkRoutingNumber1" VALUE="" >
      </TD>
    </TR>    
</TABLE>
</FORM>

</BODY>
</HTML>
