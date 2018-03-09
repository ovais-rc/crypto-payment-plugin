<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>

<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.contract.util.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.order.utils.OrderConstants" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.commands.*" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.order.calculation.GetOrderLevelParameterCmd" %>
<%@ page import="com.ibm.commerce.ordermanagement.commands.AdvancedOrderEditBeginCmd" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.order.calculation.CalculationConstants" %>
<%@ page import="com.ibm.commerce.couponredemption.databeans.*" %>
<%@ page import="com.ibm.commerce.approval.util.ApprovalConstants" %>
<%@ page import="com.ibm.commerce.ubf.util.BusinessFlowConstants" %>
<%@ page import="com.ibm.commerce.ubf.objects.FlowInstanceAccessBean" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!
	// retrieve purchase order number
	public String getPONumber(String orderId, HttpServletRequest request) {
		String poNumber = "";
		try {
			OrderPaymentMethodDataBean ordPayMthdDB = new OrderPaymentMethodDataBean();
			Enumeration eOrdPayMthd = ordPayMthdDB.findByOrder(new Long(orderId));
			if (eOrdPayMthd.hasMoreElements()) {
   				OrderPaymentMethodAccessBean ordPayMthdAB = (OrderPaymentMethodAccessBean)eOrdPayMthd.nextElement();
   				poNumber = ordPayMthdAB.getPurchaseOrderNumber();
   			}
		} catch (Exception ex) {
			//Exception
			ex.printStackTrace();

			return poNumber;
		}
		return poNumber;
	}


	public String getOrderLevelMenuAdjustment(CommandContext tmpCmdContext, OrderDataBean tmpOrderBean, Integer storeId)
	{

		BigDecimal origOrderLevelMenuAdjustment = null;
		try {
			GetOrderLevelParameterCmd getAdjustment = (GetOrderLevelParameterCmd) CommandFactory.createCommand(GetOrderLevelParameterCmd.NAME, storeId);
			if (getAdjustment != null) {
				// Get order level menu adjustment
				getAdjustment.setCommandContext(tmpCmdContext);
				getAdjustment.setOrder(tmpOrderBean);
				getAdjustment.setOrderItems(tmpOrderBean.getOrderItems());
				getAdjustment.setUsageId(CalculationConstants.USAGE_DISCOUNT);
				getAdjustment.execute();
				origOrderLevelMenuAdjustment = getAdjustment.getAmount();
			}



		} catch (Exception ex) {
			return "0";

		}

		if (null != origOrderLevelMenuAdjustment)
			return origOrderLevelMenuAdjustment.toString();
		else
			return "0";



	}

	public String getCouponsForDisplay(OrderDataBean tempOrderBean, Integer storeId, HttpServletRequest request) {
		String orderId = tempOrderBean.getOrderId();


		//Obtain the coupons associated with this order
		Long orderIdLong = new Long(Long.parseLong(orderId));
		//Long orderIdLong = new Long(10051);
		ViewAppliedCouponDataBean couponBean = new ViewAppliedCouponDataBean();
		Vector couponList = new Vector();
		String couponIdDisplay = "";

		try {
			couponBean.setOrderId(orderIdLong);
			com.ibm.commerce.beans.DataBeanManager.activate(couponBean, request);
			//couponBean.populate();
			couponList = couponBean.getBcIds();
			couponIdDisplay = "";

			for (Enumeration e=couponList.elements(); e.hasMoreElements();)
			{	Long coupon = (Long) e.nextElement();
				couponIdDisplay += coupon.toString();
				if (e.hasMoreElements()) {
					couponIdDisplay += ",";
				}
			}


		} catch (Exception e) {
			e.printStackTrace();
		}

		//return couponList;
		return couponIdDisplay;
	}

	// Kick off an UBF event to cancel the order approval flow
	public void cancelOrderApprovalFlow(String orderId, CommandContext cmdContext, TypedProperty requestProperties) throws Exception {

		try {
			com.ibm.commerce.ubf.registry.BusinessFlowManager businessFlowManager = com.ibm.commerce.ubf.registry.BusinessFlowManager.getInstance();
			com.ibm.commerce.ubf.registry.BusinessFlowType aFlowType = businessFlowManager.getFlowTypeByIdentifier(ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS);
			FlowInstanceAccessBean anInstance;

			try {
				// try to get the flow instance
				anInstance = new FlowInstanceAccessBean().findFlowInstanceByFlowTypeAndEntity(aFlowType.getID(), new java.lang.Long(orderId));
			} catch (javax.persistence.NoResultException e) {
				// do nothing as it's OK if the flow instance doesn't already exist.
				// in this case, no need to send in entityId to UBF
				return;
			}
		} catch (Exception ex) {
			
			ex.printStackTrace();
			throw ex;

		}


		// Add the parms needed by the BusinessFlowEvent to requestProperties
		requestProperties.put(BusinessFlowConstants.EC_BUSINESS_FLOW_EVENT_IDENTIFIER, ApprovalConstants.EC_EVENT_APPROVAL_CANCEL);
		requestProperties.put(BusinessFlowConstants.EC_FLOWTYPE_IDENTIFIER, ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS);
		requestProperties.put(BusinessFlowConstants.EC_ENTITY_ID, orderId);

		// Raise the BusinessFlowEvent to handle the cancelation
		com.ibm.commerce.ubf.event.BusinessFlowEventData data = new com.ibm.commerce.ubf.event.BusinessFlowEventData(cmdContext, requestProperties);
		try {
			com.ibm.commerce.ubf.event.BusinessFlowEvent event = new com.ibm.commerce.ubf.event.BusinessFlowEvent(data,true);
		} catch (com.ibm.commerce.exception.ECException ex) {

			String errMsgKey = ex.getErrorMessageKey();
			if ((null == errMsgKey) ||
			(null != errMsgKey && !errMsgKey.equals("_ERR_FINDER_EXCEPTION")))
				throw ex;



		}
	}

	private String findOrigMatchingId(OrderItemAccessBean copyOrderItemsAB, OrderItemAccessBean[] origOrderItemsAB) {
		String copyCatEntId = null;
		String tmpCatEntId = null;
		String result = "";

		try {
			copyCatEntId = copyOrderItemsAB.getCatalogEntryId();

			for (int i=0; i<origOrderItemsAB.length; i++) {
				tmpCatEntId = origOrderItemsAB[i].getCatalogEntryId();

				if (copyCatEntId.equals(tmpCatEntId)) {
					result = origOrderItemsAB[i].getOrderItemId();
					break;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return result;
	}

	private void copyOrderItemProperties(String origOrderItemId, String copyOrderItemId) {
		try {
			OrderItemAccessBean origOrderItemAB = new OrderItemAccessBean();
			origOrderItemAB.setInitKey_orderItemId(origOrderItemId);

			OrderItemAccessBean copyOrderItemAB = new OrderItemAccessBean();
			copyOrderItemAB.setInitKey_orderItemId(copyOrderItemId);
			copyOrderItemAB.setLastUpdate(origOrderItemAB.getLastUpdate());
			copyOrderItemAB.setPrice(origOrderItemAB.getPrice());
			copyOrderItemAB.setShippingCharge(origOrderItemAB.getShippingCharge());
			copyOrderItemAB.setShippingTaxAmount(origOrderItemAB.getShippingTaxAmount());
			copyOrderItemAB.setStatus(origOrderItemAB.getStatus());
			copyOrderItemAB.setTaxAmount(origOrderItemAB.getTaxAmount());
			copyOrderItemAB.setTimeCreated(origOrderItemAB.getTimeCreated());
			copyOrderItemAB.setTotalAdjustment(origOrderItemAB.getTotalAdjustment());
			copyOrderItemAB.setTotalProduct(origOrderItemAB.getTotalProduct());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private void copyOrderProperties(String origOrderId, String copyOrderId) {
		try {
			OrderAccessBean origOrderAB = new OrderAccessBean();
			origOrderAB.setInitKey_orderId(origOrderId);

			OrderAccessBean copyOrderAB = new OrderAccessBean();
			copyOrderAB.setInitKey_orderId(copyOrderId);
			copyOrderAB.setPlaceOrderTime(origOrderAB.getPlaceOrderTime());
			copyOrderAB.setTotalAdjustment(origOrderAB.getTotalAdjustment());
			copyOrderAB.setTotalProductPrice(origOrderAB.getTotalProductPrice());
			copyOrderAB.setTotalShippingCharge(origOrderAB.getTotalShippingCharge());
			copyOrderAB.setTotalShippingTax(origOrderAB.getTotalShippingTax());
			copyOrderAB.setTotalTax(origOrderAB.getTotalTax());

			OrderItemAccessBean[] copyOrderItemsAB = copyOrderAB.getOrderItems();
			OrderItemAccessBean[] origOrderItemsAB = origOrderAB.getOrderItems();
			String matchingId = null;
			for (int i=0; i<copyOrderItemsAB.length; i++) {
				matchingId = findOrigMatchingId(copyOrderItemsAB[i], origOrderItemsAB);
				copyOrderItemProperties(matchingId, copyOrderItemsAB[i].getOrderItemId());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}


%>

<%
try {
	//Get resource bundle for displaying text on the page
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Integer storeId = cmdContext.getStoreId();
	Long adminId = cmdContext.getUserId();
	Hashtable orderMgmtNLS = (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);


	JSPHelper jspHelp = new JSPHelper(request);
	String XMLFile = jspHelp.getParameter("XMLFile");
	String orderId = jspHelp.getParameter(ECConstants.EC_ORDER_RN);
	String customerId = jspHelp.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
	String backupOrderId = "";
	String originatorId = "";
	String billingAddressId = "";
	String orderLevelMenuAdjustment = "0";
	String totalShippingCharge = "0";
	String orderGrandTotal = "0";
	String couponsUsedInOrder = "";
	String orderStatus = "";
	String orderLastUpdate = "";
	String remainingAmt = "0";

	// clone the original order
	if (orderId != null && orderId.length() != 0) {
		OrderDataBean originalOrder = new OrderDataBean();
		originalOrder.setOrderId(orderId);
		originalOrder.setSecurityCheck(false);
		DataBeanManager.activate(originalOrder, request);

		originatorId = originalOrder.getMemberId();
		if (customerId == null || customerId.length() == 0)
			customerId = originatorId;
		billingAddressId = originalOrder.getAddressId();


		try {
			orderLevelMenuAdjustment = getOrderLevelMenuAdjustment(cmdContext, originalOrder, storeId);

		} catch (Exception ex)
		{
			ex.printStackTrace();
			orderLevelMenuAdjustment = "0";

		}

		try {
			totalShippingCharge = originalOrder.getTotalShippingCharge();
		} catch (Exception ex)
		{
			ex.printStackTrace();
			
			totalShippingCharge = "0";

		}


		try {
			orderGrandTotal = originalOrder.getGrandTotal().getAmount().toString();

		} catch (Exception ex)
		{
			ex.printStackTrace();


		}

		try {
			couponsUsedInOrder = getCouponsForDisplay(originalOrder, storeId, request);
		} catch (Exception ex)
		{
			ex.printStackTrace();
			
		}


		try {
			orderStatus = originalOrder.getStatus();
		} catch (Exception ex)
		{
			ex.printStackTrace();
			
		}
		try {
			orderLastUpdate = originalOrder.getLastUpdate();
		} catch (Exception ex)
		{
			ex.printStackTrace();
			
		}
		try {
			remainingAmt = originalOrder.getPaymentAmountRemaining().getAmount().toString();			
		} catch (Exception ex) {
			ex.printStackTrace();
			
		}

		//orderEditBegin...
	     TypedProperty property =(TypedProperty) cmdContext.getRequestProperties().clone();
		 cancelOrderApprovalFlow(orderId, cmdContext, property);

//		AdvancedOrderEditBeginCmd orderEditCmd =
//			(AdvancedOrderEditBeginCmd) CommandFactory.createCommand(
//				AdvancedOrderEditBeginCmd.NAME,
//				storeId);
//		//cancelOrderApprovalFlow(orderId, cmdContext, property);//TODO: CDC add to ORderEdit.
//		if (orderEditCmd != null) {
//			TypedProperty reqProperty =(TypedProperty)cmdContext.getRequestProperties().clone();
//			//reqProperty.put("forUserId",customerId);
//			orderEditCmd.setRequestProperties(reqProperty);
//			orderEditCmd.setCommandContext(cmdContext);
//			orderEditCmd.setOrderId(orderId);
//			orderEditCmd.setAccCheck(false);
//			orderEditCmd.setTakeOverLock(takeOverLock);
//			orderEditCmd.execute();
//		}
//		//end orderEditBegin

		//if (!"E".equals(originalOrder.getStatus())) {
		//	TypedProperty property = cmdContext.getRequestProperties();
		//	cancelOrderApprovalFlow(orderId, cmdContext, property);//TODO: CDC add to ORderEdit.

		//	property.put(OrderConstants.EC_ORDER_RN, orderId);
		//property.put("shopperId", originatorId);
		//	CSROrderCopyCmd CSROrderCopyCmdapi = (CSROrderCopyCmd) CommandFactory.createCommand(CSROrderCopyCmd.NAME, storeId);
		//	cmdContext.setRequestProperties(property);
		//	CSROrderCopyCmdapi.setCommandContext(cmdContext);
		//	CSROrderCopyCmdapi.setRequestProperties(property);

		//	CSROrderCopyCmdapi.execute();
		//	backupOrderId = CSROrderCopyCmdapi.getBackupOrderId();

		//	CSROrderStatusChangeCmd changeBStatus = (CSROrderStatusChangeCmd) CommandFactory.createCommand(CSROrderStatusChangeCmd.NAME, storeId);
		//	changeBStatus.setCommandContext(cmdContext);
		//	changeBStatus.setNewStatus("T");
		//	Vector BackupOrders = new Vector();
		//	BackupOrders.addElement(backupOrderId);
		//	changeBStatus.setOrderIds(BackupOrders);
		//	changeBStatus.execute();

		// Save the original orderid in the backup order description
		//	OrderAccessBean bkupOrderBean = new OrderAccessBean();
		//	bkupOrderBean.setInitKey_orderId(backupOrderId);
		//		bkupOrderBean.setDescription(orderId);
		//		if (originalOrder.getStatus().equals("P")
		//		    || originalOrder.getStatus().equals("I")
		//		    || originalOrder.getStatus().equals("W")
		//		    || originalOrder.getStatus().equals("N")
		//		    || originalOrder.getStatus().equals("L") )  {
		//			bkupOrderBean.setLock("2");  // inventory has not been updated
		//		} else {
		//			bkupOrderBean.setLock("3");  // inventory has been updated.
		//		}
		//make backupOrder to look like original order
		//		copyOrderProperties(orderId, backupOrderId);

		//		CSROrderStatusChangeCmd changeEStatus = (CSROrderStatusChangeCmd) CommandFactory.createCommand(CSROrderStatusChangeCmd.NAME, storeId);
		//		changeEStatus.setNewStatus("E");
		//		Vector AllOrders = new Vector();
		//		AllOrders.addElement(orderId);
		//		changeEStatus.setOrderIds(AllOrders);
		//		changeEStatus.setCommandContext(cmdContext);
		//		changeEStatus.execute();

		// add comments to backup order
		//		String backupOrderComment = Util.replace((String)orderMgmtNLS.get("backupOrderComment"),"%1",orderId);
		//		OrderCommentAccessBean comment = new OrderCommentAccessBean(new Long(backupOrderId), backupOrderComment);
		//	}
	}
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript">
	<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------


var order = parent.get("order");

if (!defined(order)) {
	order = new Object();
	parent.put("order", order);
	parent.put("preCommand", "");
	initCustomerBillAddrXML();
	initOrdersXML();
	initPaymentXML();
	initCommentXML();
	initOrigAdjustmentsXML();

	parent.put("editOrderInfo", "true");
	parent.put("isSave", "false");
	parent.put("callPrepareRequired", "false");
}

var preCommand = parent.get("PreCommand");

function initCustomerBillAddrXML() {

	addEntry(order, "customerId", "<%=customerId%>");
	addEntry(order, "billingAddressId", "<%=billingAddressId%>");
	addEntry(order, "originatorId", "<%=originatorId%>");

}

function initOrdersXML() {

	firstOrder = new Object();
	backupOrder = new Object();

	firstOrder.id = "<%=orderId%>";
	firstOrder.billingAddressId = "<%=billingAddressId%>";
	backupOrder.id = "<%=backupOrderId%>";

	addEntry(order, "firstOrder", firstOrder);
	addEntry(order, "backupOrder", backupOrder);

}

function initOrigAdjustmentsXML() {
	backupOrder = order["backupOrder"];

	totalAdjustment = new TotalAdjustment();
	totalAdjustment.value = <%=orderLevelMenuAdjustment%>;
	addEntry(backupOrder, "totalAdjustment", totalAdjustment);

	totalShipping = new ShippingCharge();
	totalShipping.value = <%=totalShippingCharge%>;
	addEntry(backupOrder, "totalShipping", totalShipping);

	grandTotal = <%=orderGrandTotal%>;
	addEntry(backupOrder, "grandTotal", grandTotal);

	couponIds = "<%=couponsUsedInOrder%>";
	addEntry(backupOrder,"couponIds", couponIds);

	orderStatus = "<%=orderStatus%>";
	addEntry(backupOrder, "orderStatus", orderStatus);

	orderLastUpdate = "<%=orderLastUpdate%>";
	addEntry(backupOrder, "orderLastUpdate", orderLastUpdate);

}

function initPaymentXML() {
        firstOrder = order["firstOrder"];

    paymentRemainingAmount = new Object();
    paymentRemainingAmount["remainingValue"] = <%=remainingAmt%>;
    addEntry(firstOrder, "paymentRemainingAmount", paymentRemainingAmount);
	payment = new Object();

	// get original order payment information
	<%
	OrderPaymentInfoAccessBean orderPayInfoBean = new OrderPaymentInfoAccessBean();
	Enumeration payInfoEnumeration = orderPayInfoBean.findByOrder(new Long(orderId));
	int i = 0;
	for (i = 0; payInfoEnumeration.hasMoreElements(); i++) {
		orderPayInfoBean = (OrderPaymentInfoAccessBean)payInfoEnumeration.nextElement();

		//need workaround for $METHOD because XML doesn't like it
		if ( orderPayInfoBean.getPaymentPairName().equals("$METHOD") ) {
		%>
			payment["METHOD"] = "<%=orderPayInfoBean.getPaymentPairValue()%>";
		<%
		} else if ( orderPayInfoBean.getPaymentPairName().equals(ECContractCmdConstants.EC_CONTRACT_TC_ID) ) {
		%>
			payment["paymentTCId"] = "<%=orderPayInfoBean.getPaymentPairValue()%>";
		<%
		} else if (orderPayInfoBean.getPaymentPairName().indexOf("/") < 0 
					&& orderPayInfoBean.getPaymentPairValue().indexOf("/") < 0
					&& orderPayInfoBean.getPaymentPairName().indexOf("@") < 0 
					&& orderPayInfoBean.getPaymentPairValue().indexOf("@") < 0
					&& orderPayInfoBean.getPaymentPairName().indexOf("&") < 0 
					&& orderPayInfoBean.getPaymentPairValue().indexOf("&") < 0
					&& orderPayInfoBean.getPaymentPairName().indexOf("<") < 0 
					&& orderPayInfoBean.getPaymentPairValue().indexOf("<") < 0
					&& orderPayInfoBean.getPaymentPairName().indexOf(">") < 0 
					&& orderPayInfoBean.getPaymentPairValue().indexOf(">") < 0) {
		%>
			payment["<%= orderPayInfoBean.getPaymentPairName() %>"] = "<%=UIUtil.toJavaScript(orderPayInfoBean.getPaymentPairValue())%>";
		<%
		}
	}

	// save the purchase order number in the model
	String poNumber = getPONumber(orderId, request);
	if ( (poNumber != null) && !(poNumber.equals("")) ) {
	%>
		payment["PONumber"] = "<%= poNumber %>";
	<%
	}
        %>
	addEntry(firstOrder, "payment", payment);
}

function initCommentXML() {

	comment = new Object();
        comment.value = "";
        comment.sendEmail = "false";

	<%
		AddressDataBean address = null;

		OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();

		registerDataBean.setUserId(customerId);
		try {
			DataBeanManager.activate(registerDataBean, request);
			String addressId = registerDataBean.getAddressId();

			if (addressId != null && addressId.length() != 0) {
				address = new AddressDataBean();
				address.setAddressId(addressId);
				DataBeanManager.activate(address, request);
			}

		} catch (Exception ex) {
			address = null;

		}


		if (address == null) {
			// When the customer is a guest shopper, the address will be null
			// Therefore, need to get the billing address instead
			if ((null != billingAddressId) && !(billingAddressId.equals("")))
			{
				address = new AddressDataBean();
				address.setAddressId(billingAddressId);
				DataBeanManager.activate(address, request);
			}
		}


		String email = "";
		if (address != null) {
			email = address.getEmail1();
			if ((email == null) || (email.equals("")) ) {
				email = address.getEmail2();
				if (email == null)
					email = "";
			}

		}
	%>

	comment.emailAddress = "<%=UIUtil.toJavaScript(email)%>";
        addEntry(order, "comment", comment);
}

function getXML() {
	return parent.modelToXML("XML");
}

//Support For Customers,Shopping Under Multiple Accounts.
// The customerId is added to the URL to populate Organization Selection List box.
function getRedirectURL() {
   var url ="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderItemsPageB2B&cmd=OrderItemsPageB2B&firstOrderId="+"<%=orderId%>"+"&customerId="+"<%=customerId%>";
   //alert("url:"+url);
   return url;
}

function executeNextPage() {
	var authToken = parent.get("authToken");
	if (!defined(authToken)) {
		parent.put("authToken", document.formToSubmit.authToken.value);
	}

	top.mccbanner.trail[top.mccbanner.counter].location = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=<%=XMLFile%>&orderId=<%=orderId%>";
	if ( preCommand != null && preCommand != "") {
		document.formToSubmit.action=preCommand;
		document.formToSubmit.URL.value = getRedirectURL();
		document.formToSubmit.XML.value = getXML();
		document.formToSubmit.submit();
	} else {
		this.location.replace(getRedirectURL());
	}
}

 //[[>-->
</script>
</head>
<body class="content" onload="executeNextPage();">

<form name="formToSubmit" action="" method="post">
	<input type="hidden" name="authToken" value="${authToken}" id="WC_OrderEditOrderInitB2BForm_FormInput_authToken"/>
	<input type="hidden" name="URL" value="" />
	<input type="hidden" name="XML" value="" />
</form>
</body>
<%
} catch (Exception ex) {
	ex.printStackTrace();
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, ex);
}
%>
</html>


