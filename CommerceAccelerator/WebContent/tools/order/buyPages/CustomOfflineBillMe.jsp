<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%--
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 021121	    KNG		Initial Create
////////////////////////////////////////////////////////////////////////////////
--%>
    <%@ page import="com.ibm.commerce.tools.util.UIUtil" %>           
    <%@ page language="java" import="java.util.*" %>                    
    <%@ page import="com.ibm.commerce.server.*" %>                      

<%                                                      
   
String  forPIUPdate =(String) request.getAttribute("forPIUPdate");
if(forPIUPdate != null && forPIUPdate.equalsIgnoreCase("Y")){
%>
<%// Get the parameter for the payment TC Id, if the payment TC is not empty, the protocol data will be retrieved from the payment TC 
JSPHelper urlParameters = new JSPHelper(request);
String paymentTCId = urlParameters.getParameter("paymentTCId");
java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
//java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
java.math.BigDecimal edp_OrderTotalAmount = (java.math.BigDecimal)request.getAttribute("edp_OrderTotalAmount");
if((paymentTCId == null || paymentTCId.trim().length()<=0 || "null".equalsIgnoreCase(paymentTCId)) && (edp_ProtocolData != null && !edp_ProtocolData.isEmpty())){
//If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData  
	paymentTCId =(String) edp_ProtocolData.get("paymentTCId");
}
if(paymentTCId == null ){paymentTCId ="";}
com.ibm.commerce.payment.beans.PaymentTCInfo paymentTCInfo = (com.ibm.commerce.payment.beans.PaymentTCInfo) request.getAttribute("paymentTCInfo");
%> 
<label for="WC_BillMe_FormInput_piAmount"></label>
<input type="hidden" name="piAmount" value="<%=edp_OrderTotalAmount%>" id="WC_BillMe_FormInput_piAmount" />
<!-- table cellpadding="3" cellspacing="0" border="0" id="WC_CustomOfflineBillMe_Table_1">  
<tr>
  <td  valign="middle" id="WC_CustomOfflineBillMe_TableCell_1"><%//=shortDescription%></td>
</tr>
</table-->
<%}else{%>
<% 
  String cardType = (String) request.getAttribute("cardType");
    if (cardType == null) cardType="BillMe";
%>
<INPUT TYPE="hidden" name="<%= ECConstants.EC_CC_TYPE %>" VALUE="<%=cardType%>" >
<%}%>
