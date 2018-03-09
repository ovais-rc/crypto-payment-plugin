<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- Start- JSP File Name: BillingAddressDropdownbox.jsp --%>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>    
<%// Get the parameter for the payment TC Id, if the payment TC is not empty, the protocol data will be retrieved from the payment TC 
//Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
JSPHelper urlParameters = new JSPHelper(request);
String paymentTCId = urlParameters.getParameter("paymentTCId");
//String showPONumber = urlParameters.getParameter("showPONumber");
String orderId = urlParameters.getParameter("orderId");
//System.out.println("orderId in Billing dropdbox:"+orderId);
String billingParmName = urlParameters.getParameter("billingParmName");
String billingAddressText = urlParameters.getParameter("billingAddressText");
if(billingParmName == null || billingParmName.trim().length()<=0){
	billingParmName = "billing_address_id";
}
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
String currentBillingAddress = urlParameters.getParameter("currentBillingAddress");
if(currentBillingAddress == null || currentBillingAddress.trim().length()<=0){
	currentBillingAddress = (String)edp_ProtocolData.get(billingParmName);
}

//Get the usable billing address list for the order and the payment TC
com.ibm.commerce.order.beans.UsableBillingAddressListDataBean usableBillingAddressListDataBean = new com.ibm.commerce.order.beans.UsableBillingAddressListDataBean();
//System.out.println("paymentTCId 0:"+paymentTCId);
if(paymentTCId != null && paymentTCId.trim().length()>0 && !paymentTCId.equals("null")){	
//System.out.println("here");
//System.out.println("paymentTCId:"+paymentTCId);
	usableBillingAddressListDataBean.setOrderId(orderId);
	usableBillingAddressListDataBean.setPaymentTCId(paymentTCId);
	com.ibm.commerce.beans.DataBeanManager.activate(usableBillingAddressListDataBean, request);
}else{
//System.out.println("there");	
	usableBillingAddressListDataBean.setOrderId(orderId);
	com.ibm.commerce.beans.DataBeanManager.activate(usableBillingAddressListDataBean, request);
}
com.ibm.commerce.user.beans.AddressDataBean[] addressDataBean = usableBillingAddressListDataBean.getBillingAddresses();
%>
<%//Display the usable billing address list and select the current billing address as the default-%>
<label for="billing_address_id">
	<span class="required">*</span>
	<%= UIUtil.toHTML(billingAddressText)%>		
</label>
<td colspan="4" valign="middle" >
<select name="<%=billingParmName%>"  id="billing_address_id">
	  <% 
	  for(int i = 0; i<addressDataBean.length;i++)
	  {
	 	 com.ibm.commerce.user.beans.AddressDataBean address = addressDataBean[i];
	 	 String nickName = address.getNickName();
	 	 nickName = UIUtil.toHTML(nickName);
	 	 String addressId = address.getAddressId();
	 	 if (!(address.isSelfAddress() && (address.getCountry()==null || address.getCountry().trim().length()<=0))  && !(nickName.equals("defaultShipping") || nickName.equals("defaultBilling")))
	 	 { // System.out.println("currentBillingAddress:"+currentBillingAddress);
	 	    //System.out.println("address:"+address.getAddressId());
	 	 	if(address.getAddressId().equals(currentBillingAddress)){%>
	  			<option selected="selected" value="<%=addressId%>" > <%=nickName%> </option>
	  		<%}
	  		else{%>
	  			<option  value="<%=addressId%>"><%=nickName%> </option>
       		<%}
	  	}
	  } %>	
</select>
</td>

