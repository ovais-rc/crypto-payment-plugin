<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2003, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>                    
 <!--TABLE>
 </TABLE-->
 <%
 String  forPIUPdate =(String) request.getAttribute("forPIUPdate");
 if(forPIUPdate != null && forPIUPdate.equalsIgnoreCase("Y")){  

 %>
 <%// Get the parameter for the payment TC Id, if the payment TC is not empty, the protocol data will be retrieved from the payment TC 
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
JSPHelper urlParameters = new JSPHelper(request);
String orderId = urlParameters.getParameter("orderId");
//System.out.println("orderId in COD:"+orderId);
String paymentTCId = urlParameters.getParameter("paymentTCId");
String showPONumber = urlParameters.getParameter("showPONumber");
java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
//java.math.BigDecimal edp_PayMethodAmount = new java.math.BigDecimal(urlParameters.getParameter("edp_PayMethodAmount"));
String purchaseorder_id ="";
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
if(edp_ProtocolData != null){
	purchaseorder_id = (String)edp_ProtocolData.get("purchaseorder_id");
}
if( purchaseorder_id == null ){ purchaseorder_id =""; }

String billingAddressSelectListPath="./BillingAddressDropdownbox.jsp";
String billingAddressText = (String)resourceBundle.get("paymentBillingAddress");
%>
 <table cellpadding="3" cellspacing="0" border="0" id="StandardPayLater_Table_1">
	<tr>
		<td colspan="4" valign="middle" id="StandardPayLater_TableCell_33">
			<label for="StandardPayLater_InputText_3">
				<span class="required">*</span>
				<%= UIUtil.toHTML( (String)resourceBundle.get("paymentInstructionAmount"))%>
			</label>
		</td>
		<td colspan="4" valign="middle" id="StandardPayLater_TableCell_34">
			<input type="text" name="piAmount" value="<%=edp_PayMethodAmount%>" id="StandardPayLater_InputText_3" />
			<input type=hidden name="paymentTCId" value="<%=paymentTCId%>" />	
			<% if("true".equals(showPONumber)){%> <input type="hidden" name="purchaseorder_id" value="<%=purchaseorder_id%>" id="StandardPayLater_InputText_4" /> <%}%> 
		</td>
	</tr>

	<%-- load billing address dropdown box from a seperate page --%>
	<tr>
		<td colspan="4"  valign="middle" id="StandardPayLater_TableCell_36">
		   <jsp:include page="<%=billingAddressSelectListPath%>" >
		   <jsp:param name="billingParmName" value="billing_address_id" />
		   <jsp:param name="paymentTCId" value="<%=paymentTCId%>" />
		   <jsp:param name="orderId" value="<%=orderId%>" />
		   <jsp:param name="billingAddressText" value="<%=billingAddressText %>"/>
		   </jsp:include>
		</td>
	</tr>	
</table>
<%} else {%>
 <TABLE>
 </TABLE>
 <%}%>
