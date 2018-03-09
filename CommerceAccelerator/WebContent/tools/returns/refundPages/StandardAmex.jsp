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
<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    <TR>
      <TD ALIGN="left"><LABEL for="INPUT1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardNumberLabel")) %></LABEL></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><LABEL for="INPUT2"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryMonthLabel")) %></LABEL></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><LABEL for="INPUT3"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYearLabel")) %></LABEL></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=256 ID="INPUT1" NAME="<%= ECConstants.EC_CC_NUMBER %>" VALUE="" >
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
          <select name="<%= ECConstants.EC_CCX_MONTH %>" ID="INPUT2" size=1 >
            <option selected></option>
            <option value="01"><%= UIUtil.toHTML( (String)resourceBundle.get("january")) %></option>
            <option value="02"><%= UIUtil.toHTML( (String)resourceBundle.get("february")) %></option>
            <option value="03"><%= UIUtil.toHTML( (String)resourceBundle.get("march")) %></option>
            <option value="04"><%= UIUtil.toHTML( (String)resourceBundle.get("april")) %></option>
            <option value="05"><%= UIUtil.toHTML( (String)resourceBundle.get("may")) %></option>
            <option value="06"><%= UIUtil.toHTML( (String)resourceBundle.get("june")) %></option>
            <option value="07"><%= UIUtil.toHTML( (String)resourceBundle.get("july")) %></option>
            <option value="08"><%= UIUtil.toHTML( (String)resourceBundle.get("august")) %></option>
            <option value="09"><%= UIUtil.toHTML( (String)resourceBundle.get("september")) %></option>
            <option value="10"><%= UIUtil.toHTML( (String)resourceBundle.get("october")) %></option>
            <option value="11"><%= UIUtil.toHTML( (String)resourceBundle.get("november")) %></option>
            <option value="12"><%= UIUtil.toHTML( (String)resourceBundle.get("december")) %></option>
          </select>        
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
          <select name="<%= ECConstants.EC_CCX_YEAR %>" ID="INPUT3" size=1 >
            <option selected></option>
			   <%java.util.Date tempdate = new java.util.Date();
				 int tempyear = tempdate.getYear()+1900;
				 for(int incres = 0; incres < 10; incres++){
			   %>
			   		<option	value="<%=tempyear+incres%>"><%=tempyear+incres%></option>
			   <%
			   	 }
			   %>
          </SELECT>     
      </TD>
    </TR>
</TABLE>