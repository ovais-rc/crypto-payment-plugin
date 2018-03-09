<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2011
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
%>

    <INPUT TYPE=hidden  name="<%= ECConstants.EC_CC_TYPE %>" VALUE="" >
    
    <TR><TD COLSPAN=3></TD></TR>
    <TR>
      <TD ALIGN="left"><%= resourceBundle.get("cardNumber") %></TD>
      <TD ALIGN="left"><label for="month1"><%= resourceBundle.get("cardExpireMonth") %></label></TD>
      <TD ALIGN="left"><label for="year1"><%= resourceBundle.get("cardExpiryYear") %></label></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
    </TR>

    <TR>   
      <TD>
       <LABEL> <INPUT TYPE=text SIZE=30 MAXLENGTH=256 NAME="<%= ECConstants.EC_CC_NUMBER %>" VALUE=""></LABEL>
      </TD>

      <TD>       
          <select name="<%= ECConstants.EC_CCX_MONTH %>" size=1 id="month1">
            <option selected></option>
            <option value="01"><%= resourceBundle.get("january") %></option>
            <option value="02"><%= resourceBundle.get("february") %></option>
            <option value="03"><%= resourceBundle.get("march") %></option>
            <option value="04"><%= resourceBundle.get("april") %></option>
            <option value="05"><%= resourceBundle.get("may") %></option>
            <option value="06"><%= resourceBundle.get("june") %></option>
            <option value="07"><%= resourceBundle.get("july") %></option>
            <option value="08"><%= resourceBundle.get("august") %></option>
            <option value="09"><%= resourceBundle.get("september") %></option>
            <option value="10"><%= resourceBundle.get("october") %></option>
            <option value="11"><%= resourceBundle.get("november") %></option>
            <option value="12"><%= resourceBundle.get("december") %></option>
          </select>        
      </TD>
      
      <TD>       
          <select name="<%= ECConstants.EC_CCX_YEAR %>" size=1 id="year1">
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

<!--
    <TR>  
      <TD><label for="payment"><%= resourceBundle.get("cardVerification") %></label></TD>
      <TD>        
        <INPUT TYPE="TEXT" NAME="Ecom_Payment_Card_Verification" ID="payment" SIZE="4" MAXLENGTH="4">
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD COLSPAN="3">
        <BR>
        <FONT><B><%= resourceBundle.get("cardholderInformation") %></B></FONT>
      </TD>
    </TR>
    <TR>
      <TD> <label for="street"><%= resourceBundle.get("avsStreetAddress") %><label></TD>
      <TD>      
        <INPUT TYPE="TEXT" NAME="Ecom_BillTo_Postal_Street_Line1" ID="street" SIZE="20" MAXLENGTH="128">
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="city"><%= resourceBundle.get("avsCity") %></label></TD>
      <TD>        
        <INPUT TYPE="TEXT" NAME="Ecom_BillTo_Postal_City" ID="city" SIZE="20" MAXLENGTH="50">
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="state"><%= resourceBundle.get("avsStateProvince") %></label></TD>
      <TD>  
        <INPUT TYPE="TEXT" NAME="Ecom_BillTo_Postal_StateProv" ID="state" SIZE="20" MAXLENGTH="50">
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="payment"><%= resourceBundle.get("avsPostalCode") %></label></TD>
      <TD>      
        <INPUT TYPE="TEXT" NAME="Ecom_BillTo_Postal_PostalCode" ID="payment" SIZE="14" MAXLENGTH="14">
      </TD>
      <TD></TD>
    </TR>
    <TR>
      <TD><label for="country1"><%= resourceBundle.get("avsCountryCode") %></label></TD>
      <TD>
        <SELECT NAME="Ecom_BillTo_Postal_CountryCode" id="country1">
          <OPTION VALUE="">
          <OPTION VALUE="124">Canada
          <OPTION VALUE="840">USA
        </SELECT>
      </TD>
      <TD></TD>
    </TR>
-->
