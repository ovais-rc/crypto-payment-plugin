<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
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
String strCheckAccountNumber = "";
String strCheckRoutingNumber ="";
if(paymentTCInfo != null){
 	strCheckAccountNumber = paymentTCInfo.getCheckingAccountNumber();
	strCheckRoutingNumber = paymentTCInfo.getCheckRoutingNumber();
}

String check_account_number = "";
String check_routing_number = "";

if((paymentTCId == null || paymentTCId.trim().length()<=0 || "null".equalsIgnoreCase(paymentTCId)) && (edp_ProtocolData != null && !edp_ProtocolData.isEmpty())){
//If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData  
	paymentTCId =(String) edp_ProtocolData.get("paymentTCId");	
	check_account_number=(String) edp_ProtocolData.get("checkingAccountNumber");		
	check_routing_number = (String)edp_ProtocolData.get("checkRoutingNumber"); 
}

if(strCheckAccountNumber == null ||strCheckAccountNumber.trim().length()<=0 || "null".equalsIgnoreCase(strCheckAccountNumber)){
    strCheckAccountNumber ="";
}
if(strCheckRoutingNumber == null ||strCheckRoutingNumber.trim().length()<=0 || "null".equalsIgnoreCase(strCheckRoutingNumber)){
    strCheckRoutingNumber ="";
}
if(check_account_number == null ||check_account_number.trim().length()<=0 || "null".equalsIgnoreCase(check_account_number)){
    check_account_number ="";
}
if(check_routing_number == null ||check_routing_number.trim().length()<=0 || "null".equalsIgnoreCase(check_routing_number)){
    check_routing_number ="";
}
if(paymentTCId == null ||paymentTCId.trim().length()<=0 || "null".equalsIgnoreCase(paymentTCId)){
    paymentTCId ="";
}


%>
<label for="WC_StandardBankServACH_FormInput_piAmount"></label>
<input type="hidden" name="piAmount" value="<%=edp_OrderTotalAmount%>" id="WC_StandardBankServACH_FormInput_piAmount" />
<table cellpadding="3" cellspacing="0" border="0" id="WC_StandardBankServACH_Table_1">
<tr>
		<td colspan="4" valign="middle" id="WC_StandardBankServACH_TableCell_11">
			<label for="WC_StandardBankServACH_checkAccountNumber">
				<span class="required">*</span>
				 <%= UIUtil.toHTML( (String)resourceBundle.get("checkAccountNumber")) %>
			</label>
		</td>
	<td colspan="4" valign="middle" id="WC_StandardCreditCard_TableCell_12">
		<label for="WC_StandardBankServACH_FormInput_checkingAccountNumber"></label>
		<% if(strCheckAccountNumber.trim().length() <= 0){%>
		 <input type="text" size="20" name="checkingAccountNumber" value="<%=check_account_number%>" id="WC_StandardBankServACH_FormInput_checkingAccountNumber" />
		<% }else{%> 			
		<%= strCheckAccountNumber%> 
    	 <input type="hidden" size="20" name="checkingAccountNumber" value="<%=strCheckAccountNumber%>" id="WC_StandardBankServACH_FormInput_checkingAccountNumber"/>		
		<%}%>
	</td>
</tr>
<tr>
		<td colspan="4" valign="middle" id="WC_StandardBankServACH_TableCell_21">
			<label for="WC_StandardBankServACH_FormInput_checkRoutingNumber">
				<span class="required">*</span>
				<%= UIUtil.toHTML((String)resourceBundle.get("checkRoutingNumber")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="WC_StandardBankServACH_TableCell_22">		
				<label for="WC_StandardBankServACH_FormInput_checkRoutingNumber"></label>
				<% if(strCheckRoutingNumber.trim().length() <= 0){%>
				 <input type="text" size="20" name="checkRoutingNumber" value="<%=check_routing_number%>" id="WC_StandardBankServACH_FormInput_checkRoutingNumber" />
				<% }else{%> 			
				<%= strCheckRoutingNumber%> 
    	 		<input type="hidden" size="20" name="checkRoutingNumber" value="<%=strCheckRoutingNumber%>" id="WC_StandardBankServACH_FormInput_checkRoutingNumber"/>		
				<%}%>
		</td>
</tr>
</table>
<%} else {%>
<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    
    <TR>
      <TD><B><%= UIUtil.toHTML( (String)resourceBundle.get("checkInfo")) %><B></TD>
    </TR>
    <TR><TD>
    <BR></TD>
    </TR>
    
    <TR>
      <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("checkAccountNumber")) %></TD>
    </TR>
    
    <TR>
      <TD>
      <LABEL>  <INPUT TYPE=text SIZE=30 MAXLENGTH=17 NAME="checkingAccountNumber" VALUE="" onchange="snipJSPOnChange(this.name)" ></LABEL>
      </TD>
    </TR>

    <TR>
      <TD ALIGN="left"><%= UIUtil.toHTML( (String)resourceBundle.get("checkRoutingNumber")) %></TD>
    </TR>
    
    <TR>
      <TD>
        <LABEL><INPUT TYPE=text SIZE=30 MAXLENGTH=9 NAME="checkRoutingNumber" VALUE="" onchange="snipJSPOnChange(this.name)" ></LABEL>
      </TD>
    </TR>    
</TABLE>
<%}%>
