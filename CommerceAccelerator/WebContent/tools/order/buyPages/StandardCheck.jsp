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

<%
// Get the parameter for the payment TC Id, if the payment TC is not empty, the protocol data will be retrieved from the payment TC 
JSPHelper urlParameters = new JSPHelper(request);
String paymentTCId = urlParameters.getParameter("paymentTCId");
String edp_PIInfo_Form = urlParameters.getParameter("edp_PIInfo_Form");
String orderId =  urlParameters.getParameter("orderId");
java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
//java.math.BigDecimal edp_PayMethodAmount = new java.math.BigDecimal(urlParameters.getParameter("edp_PayMethodAmount"));
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
String account = "";
String check_routing_number ="";
String purchaseorder_id="";
//String showPONumber =(String)request.getAttribute("showPONumber");
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
		} else if(attribute.getName().equalsIgnoreCase("check_routing_number")){
		 	if(pAttrValue.getPAttrValue()!=null){
		       check_routing_number =pAttrValue.getPAttrValue().toString();	
		      }	
		}
	}//end for
}//end the outer if
else if(edp_ProtocolData != null && !edp_ProtocolData.isEmpty()){
//If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData	
	purchaseorder_id =(String) edp_ProtocolData.get("purchaseorder_id");
	paymentTCId =(String) edp_ProtocolData.get("paymentTCId");
	account=(String) edp_ProtocolData.get("account");
	Object routing_number= edp_ProtocolData.get("check_routing_number");
	if(routing_number != null){
	 check_routing_number = routing_number.toString();
	}

}
if(account == null ){account ="";}
if( purchaseorder_id == null ){ purchaseorder_id =""; }
if( paymentTCId == null ){ paymentTCId =""; }

String billingAddressSelectListPath="./BillingAddressDropdownbox.jsp";
String billingAddressText = (String)resourceBundle.get("paymentBillingAddress");
//System.out.println("account:"+account);
%>



<%-- The section to collect the protocol data for this payment method --%>
<table cellpadding="3" cellspacing="0" border="0" id="StandardACH_Table_1">
    
	<tr>
		<td colspan="4" valign="middle"  id="StandardACH_TableCell_11">
			<label for ="StandardACH_InputText_1"><span class="required">*</span>
			<%= UIUtil.toHTML( (String)resourceBundle.get("checkRoutingNumber")) %></label>
			
		</td>
		<td colspan="4" valign="middle" id="StandardACH_TableCell_12">
			<input type="text" name = "check_routing_number" value ="<%=check_routing_number%>" id="StandardACH_InputText_1" />
			<input type="hidden" name="paymentTCId" value="<%=paymentTCId%>" />	
			<% if("true".equals(showPONumber)){%> <input type="hidden" name="purchaseorder_id" value="<%=purchaseorder_id%>" id="StandardACH_InputText_2" /> <%}%> 
		
		</td>

	</tr>
	<tr>
		<td colspan="4" valign="middle" id="StandardACH_TableCell_21">
			<label for="StandardACH_InputText_2"><span class="required">*</span>
			<%= UIUtil.toHTML( (String)resourceBundle.get("checkAccountNumber")) %></label>
		</td>
		<td colspan="4" valign="middle" id="StandardACH_TableCell_22">
			<input type="text" name = "account" value ="<%=account%>" id="StandardACH_InputText_2" 
				<% if(valueFromPaymentTC){%> onchange="javascript:accountChanged(document.<%=edp_PIInfo_Form%>" <%}%> 
			/>
			<% if(valueFromPaymentTC){%> <input type="hidden" name="valueFromPaymentTC" value="true" /> <%}%> 
		</td>

	</tr>			
	<%// The section to collect the amount for this payment method %>
	<tr>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_33">
			<label for="StandardACH_InputText_3"><span class="required">*</span>
			<%= UIUtil.toHTML( (String)resourceBundle.get("paymentInstructionAmount"))%></label>
		</td>
		<td colspan="4" valign="middle" id="StandardAmex_TableCell_34">
			<input type="text" name = "piAmount" value="<%=edp_PayMethodAmount%>" id="StandardACH_InputText_3" />
		</td>
	</tr>
	
		<%//load billing address dropdown box from a seperate page 
	    // Note, check is customer editable payment method, should disable piAmout and billing address when display existing check --%>
	<tr>
		<td colspan="4" valign="middle" id="StandardACH_TableCell_36">
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
<TABLE>
    <TR><TD COLSPAN=3></TD></TR>
    
    <TR>
      <TD><B><%= UIUtil.toHTML( (String)resourceBundle.get("checkInfo")) %></B></TD>
    </TR>
    <TR><TD>
    <BR></TD>
    </TR>
    
    <TR>
      <TD ALIGN="left"><label for="AccountNum"><%= UIUtil.toHTML( (String)resourceBundle.get("checkAccountNumber")) %></label></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=17 NAME="<%= ECConstants.EC_CC_ACCOUNT %>" VALUE="" onchange="snipJSPOnChange(this.name)" id="AccountNum">
      </TD>
    </TR>

    <TR>
      <TD ALIGN="left"><label for="RouteNum"><%= UIUtil.toHTML( (String)resourceBundle.get("checkRoutingNumber")) %></label></TD>
    </TR>
    
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 MAXLENGTH=9 NAME="check_routing_number" VALUE="" onchange="snipJSPOnChange(this.name)" id="RouteNum">
      </TD>
    </TR>    
</TABLE>
<%}%>
