<!--
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
-->

<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.TermConditionAccessBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>

<%! 	

	public boolean checkIfShippingTCExist(String contractId, HttpServletRequest request) {
						
		try {
			com.ibm.commerce.contract.beans.ContractDataBean contractDataBean = new com.ibm.commerce.contract.beans.ContractDataBean();
			contractDataBean.setDataBeanKeyReferenceNumber(contractId); 
			DataBeanManager.activate(contractDataBean, request);
			
			TermConditionAccessBean[] tcList = contractDataBean.getTCsByTCSubType(ECOptoolsConstants.EC_OPTOOL_TC_SUBTYPE_SHIPPING_TC_SHIP_TO_ADDRESS);
			if (tcList.length >= 1)
				return true;
			else 
				return false;
			


		} catch (Exception ex) {
			return false;
		}
		
	}
	
	
	
	
%>


<%
try {

	JSPHelper jspHelp = new JSPHelper(request);
	String orderItemId = jspHelp.getParameter("orderItemId");
	
	OrderItemDataBean anOrderItem = new OrderItemDataBean();
	String contractId = "";
	String partNumber = "";

	
	if ((orderItemId != null) && !(orderItemId.equals(""))) {
		anOrderItem.setOrderItemId(orderItemId);
		com.ibm.commerce.beans.DataBeanManager.activate(anOrderItem, request);
		contractId = anOrderItem.getContractId();
		partNumber = anOrderItem.getPartNumber();
	}

	boolean ifShippingTCExist = checkIfShippingTCExist(contractId, request);


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
	<script type="text/javascript">
	<!-- <![CDATA[
		var model = top.getModel(1);		
		var order = model["order"];
		var customerId = order["customerId"];
	//[[>-->
	</script>
  </head>

  <body class="content">

    <form name="shippingAddressForm" target="_self" action="/webapp/wcs/tools/servlet/NewDynamicListView" method="get">
    <input type="hidden" name="XMLFile" value="order.orderShippingAddressListDialog" />

    <%
    if (ifShippingTCExist) {
    %>
    	<input type="hidden" name="ActionXMLFile" value="order.orderShippingTCAddressList" />
	
    <%
    	} else {
    %>
	<input type="hidden" name="ActionXMLFile" value="order.orderShippingAddressList" />
	
    <%
    	}
    %>
		
    <input type="hidden" name="cmd" value="OrderShippingAddressList" />
    <input type="hidden" name="listsize" value="10" />
    <input type="hidden" name="startindex" value="0" />
    <input type="hidden" name="customerId" value="" />
    <input type="hidden" name="<%=ECOptoolsConstants.EC_OPTOOL_CONTRACT_ID%>" value="" />
    <input type="hidden" name="partNumber" value="" />
   
    </form>

    <script language="javascript" type="text/javascript">
	<!-- <![CDATA[
      document.shippingAddressForm.customerId.value = customerId;
      document.shippingAddressForm.<%=ECOptoolsConstants.EC_OPTOOL_CONTRACT_ID%>.value = '<%=UIUtil.toJavaScript(contractId)%>';
      document.shippingAddressForm.partNumber.value = '<%=UIUtil.toJavaScript(partNumber)%>';
      document.shippingAddressForm.submit();
    //[[>-->
    </script>
  </body>
  
  
<%
} catch (Exception ex) {
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, ex);
}
%>

</html>