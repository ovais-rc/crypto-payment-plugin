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
<%@ page import="com.ibm.commerce.server.*" %>
<%
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
%>

<INPUT TYPE=hidden  name="<%= ECConstants.EC_CC_TYPE %>" VALUE="VISA" >

<TABLE>
    <TR><TD COLSPAN=2></TD></TR>
    <TR>
    <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("cardType")) %></TD>
    <TD ALIGN="left"><I><%= "VISA" %></I></TD>
    </TR>
</TABLE>

<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    <TR>
      <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("cardNumber")) %></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label for="month1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpireMonth")) %></label></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label for="year1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYear")) %></label></TD>
    </TR>
    
    <TR>
      <TD>
       <LABEL> <INPUT TYPE=text SIZE=30 MAXLENGTH=256 NAME="<%= ECConstants.EC_CC_NUMBER %>" VALUE="" onchange="snipJSPOnChange(this.name)" ></LABEL>
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
          <select name="<%= ECConstants.EC_CCX_MONTH %>" size=1 onchange="snipJSPOnChange(this.name)" id="month1">
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
          <select name="<%= ECConstants.EC_CCX_YEAR %>" size=1 onchange="snipJSPOnChange(this.name)" id="year1">
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