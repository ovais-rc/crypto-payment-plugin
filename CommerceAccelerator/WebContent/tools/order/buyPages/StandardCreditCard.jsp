<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2011
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<!-- Start - JSP File Name: StandardCreditCard.jsp -->
<%
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
String  forPIUPdate =(String) request.getAttribute("forPIUPdate");
if(forPIUPdate != null && forPIUPdate.equalsIgnoreCase("Y")){
%>
<%// Get the parameter for the payment TC Id, if the payment TC is not empty, the protocol data will be retrieved from the payment TC 

JSPHelper urlParameters = new JSPHelper(request);
String paymentTCId = urlParameters.getParameter("paymentTCId");
//java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
java.math.BigDecimal edp_OrderTotalAmount = (java.math.BigDecimal)request.getAttribute("edp_OrderTotalAmount");
com.ibm.commerce.payment.beans.PaymentTCInfo paymentTCInfo = (com.ibm.commerce.payment.beans.PaymentTCInfo) request.getAttribute("paymentTCInfo");
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
String account = "";
int expire_month =0;
int expire_year =0;
String cardBrand = "";
String strCardNumber = "";
String strCardExpiryMonth = "";
String strCardExpiryYear = "";
if(paymentTCInfo != null){
 cardBrand = paymentTCInfo.getBrand();
 strCardNumber = paymentTCInfo.getCardNumber();
 strCardExpiryMonth = paymentTCInfo.getCardExpiryMonth();
 strCardExpiryYear = paymentTCInfo.getCardExpiryYear();
}
if(strCardNumber == null ||strCardNumber.trim().length()<=0 || "null".equalsIgnoreCase(strCardNumber) ){
    strCardNumber ="";
}
if(strCardExpiryMonth == null ||strCardExpiryMonth.trim().length()<=0 || "null".equalsIgnoreCase(strCardExpiryMonth) ){
    strCardExpiryMonth ="";
}
if(strCardExpiryYear == null ||strCardExpiryYear.trim().length()<=0 || "null".equalsIgnoreCase(strCardExpiryYear) ){
    strCardExpiryYear ="";
}
if((paymentTCId == null || paymentTCId.trim().length()<=0 || "null".equalsIgnoreCase(paymentTCId)) && (edp_ProtocolData != null && !edp_ProtocolData.isEmpty())){
//If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData  
	paymentTCId =(String) edp_ProtocolData.get("paymentTCId");	
	account=(String) edp_ProtocolData.get("cardNumber");		
	Object month = edp_ProtocolData.get("cardExpiryMonth");
    if(month == null){
       month = edp_ProtocolData.get("expire_month");
    }
	if(month != null){
		expire_month = new Integer(month.toString()).intValue();
	}
	Object year = edp_ProtocolData.get("cardExpiryYear");
    if(year == null){
        year= edp_ProtocolData.get("expire_year");
    }
	if(year!=null){
		expire_year = new Integer(year.toString()).intValue();
	}
}

java.util.Date now = new java.util.Date();
if(expire_month == 0){
	expire_month = now.getMonth()+1;
}
if(expire_year == 0){
	expire_year = now.getYear()+1900;
}
if(account == null ){account ="";}
if(paymentTCId == null ){paymentTCId ="";}
%>
<%//The section to collect the protocol data for this payment method --%>
<label for="WC_StandardCreditCard_FormInput_cardBrand"></label>
<label for="WC_StandardCreditCard_FormInput_piAmount"></label>
<input type="hidden" name="cardBrand" value="<%=cardBrand%>" id="WC_StandardCreditCard_FormInput_cardBrand"/>
<input type="hidden" name="piAmount" value="<%=edp_OrderTotalAmount%>" id="WC_StandardCreditCard_FormInput_piAmount" />

<table cellpadding="3" cellspacing="0" border="0" id="WC_StandardCreditCard_Table_1">    
	<tr>
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_11">
			<label for="WC_StandardCreditCard_cardNumber">
				<span class="required">*</span>
				 <%= UIUtil.toHTML( (String)resourceBundle.get("cardNumber")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_12">
		<label for="WC_StandardCreditCard_cardNumber"></label>
			<% if(strCardNumber.trim().length() <= 0){%>
				<input type="text" size="20" name="cardNumber" value="<%=account%>" id="WC_StandardCreditCard_cardNumber" />
			<% }else{%> 			
				<%= strCardNumber%> 
            	<input type="hidden" size="20" name="cardNumber" value="<%=strCardNumber%>" id="WC_StandardCreditCard_cardNumber"/>		
		    <%}%>
          </td>
	</tr>
	<tr>
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_21">
			<label for="WC_StandardCreditCard_cardExpiryMonth">
				<span class="required">*</span>
				<%= UIUtil.toHTML( (String)resourceBundle.get("cardExpireMonth")) %>
			</label>
		</td>
				
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_22">
          <% if(strCardExpiryMonth.trim().length() <= 0){%>
			<select name="cardExpiryMonth" size="1" id="WC_StandardCreditCard_cardExpiryMonth">
				<option	<%if(expire_month == 1){%> selected="selected"<% }%> value="01">01</option>
				<option	<%if(expire_month == 2){%> selected="selected"<% }%> value="02">02</option>
				<option	<%if(expire_month == 3){%> selected="selected"<% }%> value="03">03</option>
				<option	<%if(expire_month == 4){%> selected="selected"<% }%> value="04">04</option>
				<option	<%if(expire_month == 5){%> selected="selected"<% }%> value="05">05</option>
				<option	<%if(expire_month == 6){%> selected="selected"<% }%> value="06">06</option>
				<option	<%if(expire_month == 7){%> selected="selected"<% }%> value="07">07</option>
				<option	<%if(expire_month == 8){%> selected="selected"<% }%> value="08">08</option>
				<option	<%if(expire_month == 9){%> selected="selected"<% }%> value="09">09</option>
				<option	<%if(expire_month == 10){%> selected="selected"<% }%> value="10">10</option>
				<option	<%if(expire_month == 11){%> selected="selected"<% }%> value="11">11</option>
				<option	<%if(expire_month == 12){%> selected="selected"<% }%> value="12">12</option>			
			</select>
            <% }else{%>
             <select name="cardExpiryMonth" size="1" id="WC_StandardCreditCard_cardExpiryMonth">
                    <option selected="selected" value="<%=strCardExpiryMonth%>" ><%=strCardExpiryMonth%></option>
             </select> 
             <%}%>
		</td>

	</tr>
	<tr>	
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_31">
			<label for="WC_StandardCreditCard_cardExpiryYear">
				<span class="required">*</span>
				<%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYear")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_32">
			<% if(strCardExpiryYear.trim().length() <= 0){%>
			<select name="cardExpiryYear" size="1" id="WC_StandardCreditCard_cardExpiryYear">
			   <%java.util.Date tempdate = new java.util.Date();
				 int tempyear = tempdate.getYear()+1900;
				 for(int incres = 0; incres < 10; incres++){
			   %>
			   		<option	<%if((tempyear+incres) == expire_year){%> selected="selected"<% }%> value="<%=tempyear+incres%>"><%=tempyear+incres%></option>
			   <%
			   	 }
			   %>
			</select>
            <% }else{%>
             <select name="cardExpiryYear" size="1" id="WC_StandardCreditCard_cardExpiryYear">
                    <option selected="selected" value="<%=strCardExpiryYear%>" ><%=strCardExpiryYear%></option>
             </select> 
             <%}%>
		</td>
	</tr>	
</table>

<%} else {%>
<%
String cardType = (String)request.getAttribute("cardType");

if (cardType == null) {
%>
<TABLE>
    <TR><TD COLSPAN=2></TD></TR>
    <TR>
    <TD ALIGN="left"><label for="<%= ECConstants.EC_CC_TYPE %>"><%= UIUtil.toHTML( (String)resourceBundle.get("cardType")) %></label></TD>
    <TD ALIGN="left"><input TYPE="text" SIZE="30" maxlength="256" NAME="<%= ECConstants.EC_CC_TYPE %>" ID="<%= ECConstants.EC_CC_TYPE %>" VALUE=""></TD>
    </TR>
</TABLE>
<%
}
else {
%>

<INPUT TYPE="hidden"  name="<%= ECConstants.EC_CC_TYPE %>" VALUE="" >
<TABLE>
    <TR><TD COLSPAN=2></TD></TR>
    <TR>
    <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("cardType")) %></TD>
    <TD ALIGN="left"><I><%= cardType %></I></TD>
    </TR>
    <TR><TD COLSPAN=2></TD></TR>
</TABLE>

<%
}
%>

<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    <TR>
      <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("cardNumber")) %></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label id="month1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpireMonth")) %></label></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label id="year1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYear")) %></label></TD>
    </TR>
    
    <TR>
      <TD>
        <LABEL><INPUT TYPE=text SIZE=30 MAXLENGTH=256 NAME="<%= ECConstants.EC_CC_NUMBER %>" VALUE="" onchange="snipJSPOnChange(this.name)" ></LABEL>
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
          <LABEL for="month1">
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
          </LABEL>
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
      	  <LABEL for="year1">
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
          </LABEL>
      </TD>
    </TR>
</TABLE>
<%}%>
<!-- End - JSP File Name: StandardCreditCard.jsp -->
