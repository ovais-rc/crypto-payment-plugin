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
String edp_PIInfo_Form = urlParameters.getParameter("edp_PIInfo_Form");
String orderId =  urlParameters.getParameter("orderId");
java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
//java.math.BigDecimal edp_PayMethodAmount = new java.math.BigDecimal(urlParameters.getParameter("edp_PayMethodAmount"));
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
String account = "";
String cc_brand="";
int expire_month =0;
int expire_year =0;
String cc_cvc ="";
String purchaseorder_id="";
String showPONumber = urlParameters.getParameter("showPONumber");
String currentBillingAddress = urlParameters.getParameter("currentBillingAddress");
String billingParmName ="billing_address_id";
if(currentBillingAddress == null || currentBillingAddress.trim().length()<=0){
	currentBillingAddress = (String)edp_ProtocolData.get(billingParmName);
} 
boolean valueFromPaymentTC = false;
if(paymentTCId != null && paymentTCId.trim().length()>0){
	com.ibm.commerce.contract.beans.PaymentTCDataBean paymentTCbean= new com.ibm.commerce.contract.beans.PaymentTCDataBean();
	paymentTCbean.setDataBeanKeyReferenceNumber(paymentTCId);
	com.ibm.commerce.beans.DataBeanManager.activate(paymentTCbean, request);
	com.ibm.commerce.utf.objects.PAttrValueAccessBean[] pAttrValues=paymentTCbean.getPAttrValues();
	for(int i =0;i<pAttrValues.length;i++){
	com.ibm.commerce.utf.objects.PAttrValueAccessBean pAttrValue = pAttrValues[i];
		com.ibm.commerce.utf.beans.PAttributeDataBean	attribute = new com.ibm.commerce.utf.beans.PAttributeDataBean();
		attribute.setPAttributeId(pAttrValue.getAttributeId());
		com.ibm.commerce.beans.DataBeanManager.activate(attribute, request);
		if("account".equalsIgnoreCase(attribute.getName())){		
		   if(pAttrValue.getPAttrValue()!=null){
		     	valueFromPaymentTC = true;
		   		com.ibm.commerce.edp.beans.EDPSensitiveDataMaskHelperDataBean  edpMaskBean = new com.ibm.commerce.edp.beans.EDPSensitiveDataMaskHelperDataBean();
		    	edpMaskBean.setPlainString(pAttrValue.getPAttrValue().toString());
		   	 	com.ibm.commerce.beans.DataBeanManager.activate(edpMaskBean, request);
		    	account = edpMaskBean.getMaskedString();
		   }else{
		    	account = "";
		   }
		} else if(attribute.getName().equalsIgnoreCase("cc_brand")){
		 	if(pAttrValue.getPAttrValue()!=null){
		       cc_brand =pAttrValue.getPAttrValue().toString();	
		      }	
		}else if(attribute.getName().equalsIgnoreCase("expire_month")){
			Object month = pAttrValue.getPAttrValue();
			if(month!=null){
				expire_month = new Integer(month.toString()).intValue();
			}		     	
		}else if(attribute.getName().equalsIgnoreCase("expire_year")){
			Object year = pAttrValue.getPAttrValue();
			if(year!=null){
				expire_year = new Integer(year.toString()).intValue();
			}		      		
		}
	}//end for
}//end the outer if
else if(edp_ProtocolData != null && !edp_ProtocolData.isEmpty()){
//If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData	
	purchaseorder_id =(String) edp_ProtocolData.get("purchaseorder_id");
	paymentTCId =(String) edp_ProtocolData.get("paymentTCId");
	account=(String) edp_ProtocolData.get("account");
	cc_brand=(String) edp_ProtocolData.get("cc_brand");
	Object month = edp_ProtocolData.get("expire_month");
	if(month!=null){
		expire_month = new Integer(month.toString()).intValue();
	}
	Object year= edp_ProtocolData.get("expire_year");
	if(year!=null){
		expire_year = new Integer(year.toString()).intValue();
	}
	
	if(edp_ProtocolData.get("cc_cvc")!=null){
	 	cc_cvc=edp_ProtocolData.get("cc_cvc").toString();
	}else{
	 	cc_cvc="";
	}

}
java.util.Date now = new java.util.Date();
if(expire_month == 0){
	expire_month = now.getMonth()+1;
}
final int startYear = 1900;
if(expire_year == 0){
	expire_year=now.getYear()+startYear;
}
//Set the default value("Amex") of cc_brand for this payment method
if(cc_brand == null || cc_brand.length()<=0){
  cc_brand="Amex";
}
if(account == null ){account ="";}
if( purchaseorder_id == null ){ purchaseorder_id =""; }
if( paymentTCId == null ){ paymentTCId =""; }

String billingAddressSelectListPath="./BillingAddressDropdownbox.jsp";
String billingAddressText = (String)resourceBundle.get("paymentBillingAddress");
//System.out.println("account:"+account);
%>
<!-- Start - JSP File Name: StandardAmex.jsp -->


<%-- The section to collect the protocol data for this payment method --%>

<table cellpadding="3" cellspacing="0" border="0" id="StandardAmex_Table_1">
	<tr>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_11">
			<label for="StandardAmex_InputText_1">
				<span class="required">*</span>
				 <%= UIUtil.toHTML( (String)resourceBundle.get("cardNumber")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_12">
			<input type="text" name="account" value="<%=account%>" id="StandardAmex_InputText_1" 
				<% if(valueFromPaymentTC){%> onchange="javascript:accountChanged(document.<%=edp_PIInfo_Form%>" <%}%> 
				/>
				<% if(valueFromPaymentTC){%> <input type="hidden" name="valueFromPaymentTC" value="true" /> <%}%> 
			
			<input type="hidden" name="cc_brand" value="<%=cc_brand%>" />
			<input type="hidden" name="paymentTCId" value="<%=paymentTCId%>" />	
			<% if("true".equals(showPONumber)){%> <input type="hidden" name="purchaseorder_id" value="<%=purchaseorder_id%>" id="StandardAmex_InputText_2" /> <%}%> 
		</td>
	</tr>
	<tr>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_21">
			<label for="edp_Amex_cardExpiryMonth">
				<span class="required">*</span>
				<%= UIUtil.toHTML( (String)resourceBundle.get("cardExpireMonth")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_22">
			<select name="expire_month" size=1 id="edp_Amex_cardExpiryMonth">
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
		</td>
	</tr>
	
	<tr>	
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_31">
			<label for="edp_Amex_cardExpiryYear">
				<span class="required">*</span>
				<%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYear")) %>
			</label>
		</td>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_32">
			<select name="expire_year" size=1 id="edp_Amex_cardExpiryYear">
			   <%java.util.Date tempdate = new java.util.Date();
				 int tempyear = tempdate.getYear()+1900;
				 for(int incres = 0; incres < 10; incres++){
			   %>
			   		<option	<%if((tempyear+incres) == expire_year){%> selected="selected"<% }%> value="<%=tempyear+incres%>"><%=tempyear+incres%></option>
			   <%
			   	 }
			   %>
			</select>
		</td>
	</tr>
   <%// The section to collect the amount for this payment method --%>
	<tr>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_33">
			<label for="StandardAmex_InputText_3"><span class="required">*</span>
			<%= UIUtil.toHTML( (String)resourceBundle.get("paymentInstructionAmount"))%></label>
		</td>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_34">
			<input type="text" name = "piAmount" value="<%=edp_PayMethodAmount%>" id="StandardAmex_InputText_3" />
		</td>
	</tr>
		<%-- load billing address dropdown box from a seperate page --%>
	<tr>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_36">
		   <jsp:include page="<%=billingAddressSelectListPath%>" >
		   		<jsp:param name="billingParmName" value="billing_address_id" />
		   		<jsp:param name="paymentTCId" value="<%=paymentTCId%>" />
		   		<jsp:param name="orderId" value="<%=orderId%>" />
		   		<jsp:param name="currentBillingAddress" value="<%=currentBillingAddress%>"/>
		   		<jsp:param name="billingAddressText" value="<%=billingAddressText %>"/>
		   </jsp:include>
		</td>
	</tr>
</table>

<%} else {%>
  <INPUT TYPE=hidden  name="<%= ECConstants.EC_CC_BRAND %>" VALUE="Amex" >
  <table>
    <TR><TD COLSPAN=3></TD></TR>
    <TR>
      <TD ALIGN="left"><label for="CardNum"><%= UIUtil.toHTML( (String)resourceBundle.get("cardNumber")) %></label></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label for="month1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpireMonth")) %></label></TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD ALIGN="left"><label for="year1"><%= UIUtil.toHTML( (String)resourceBundle.get("cardExpiryYear")) %></label></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=256 NAME="<%= ECConstants.EC_CC_ACCOUNT %>" VALUE="" onchange="snipJSPOnChange(this.name)" id="CardNum" >
      </TD>
      <TD ALIGN="left">&nbsp;&nbsp;&nbsp;</TD>
      <TD>       
          <select name="<%= ECConstants.EC_CD_MONTH %>" size=1 onchange="snipJSPOnChange(this.name)" id="month1">
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
          <select name="<%= ECConstants.EC_CD_YEAR %>" size=1 onchange="snipJSPOnChange(this.name)" id="year1">
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
</table>

<%}%>
