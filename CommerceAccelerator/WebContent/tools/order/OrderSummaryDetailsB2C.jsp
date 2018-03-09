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
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction"%>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.contract.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.order.calculation.GetOrderLevelParameterCmd" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.order.calculation.CalculationConstants" %>
<%@ page import="com.ibm.commerce.couponredemption.databeans.*" %>
<%@ page import="com.ibm.commerce.order.utils.OrderConstants" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.ras.*" %>

<%@ page import="com.ibm.commerce.order.utils.*" %>

<%@include file="../common/common.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 

	public String getPolicyName(OrderItemDataBean orderItemDataBean, HttpServletRequest request) {
	
		try 
		{
	
		    String policyIdOfOrderItem = orderItemDataBean.getShipCarrAccntDataBean().getPolicyID();
	
			UsableShippingDataBean usableShippingDataBean = new UsableShippingDataBean();
			usableShippingDataBean.setOrderItem(orderItemDataBean);
			com.ibm.commerce.beans.DataBeanManager.activate(usableShippingDataBean, request);

			ShipChargeTCPolicyData shipChargeTCPolicyData [] = usableShippingDataBean.getShipChargeTCPolicyData();

			for (int loop = 0; loop < shipChargeTCPolicyData.length; loop++) {
				
				String policyName = shipChargeTCPolicyData[loop].getPolicyName();
				String policyId = shipChargeTCPolicyData[loop].getPolicyId();
				
				if (policyIdOfOrderItem.equalsIgnoreCase(policyId)) {
					return policyName;
				}
			}
			
			return "";
			
		 } catch (Exception ex) {
		 	ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemName", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
			return "";
		 }	
	
	}

	// Method to get catalog entry name for an order item
	public String getOrderItemName(String catalogEntryId, HttpServletRequest request) {
		String name;
	     
		try {
			CatalogEntryDataBean aCatalogEntry	= new CatalogEntryDataBean(); 
			aCatalogEntry.setCatalogEntryID(catalogEntryId);
		
			com.ibm.commerce.beans.DataBeanManager.activate(aCatalogEntry, request);

		  
			// The databean did not expose the name method	
			name = aCatalogEntry.getDescription().getName();
			if (name == null) {
				return "";
			}   
		 } catch (Exception ex) {
		 	ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemName", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
			return "";
		 }	
		return name;

	}

	
	//get the Order Level minus adjustment which is type of discount given by a CSR. 
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
		
		if (null != origOrderLevelMenuAdjustment) {
			return origOrderLevelMenuAdjustment.toString();
		} else {
			return "0";
		}
	

	}
	
	

	//retrieve address by given an address id
	public AddressDataBean getAddress(String addressId, HttpServletRequest request) {
		try {
			if (addressId != null && !addressId.equals("")) {
				AddressDataBean address = new AddressDataBean();
				address.setAddressId(addressId);
				DataBeanManager.activate(address, request);
			
				return address;
			} else {
				return null;
			}
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getAddress", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
			return null;
		}
		
	}




	// retrieve the shipmode description
	public String getShipMode(String shipModeId, String langId,HttpServletRequest request) {
		
		
		try {
		
   			if (shipModeId != null && !shipModeId.equals("")) {
   				ShippingModeDataBean shipMode = new ShippingModeDataBean();
   				shipMode.setInitKey_shippingModeId(shipModeId);
   				DataBeanManager.activate(shipMode, request);
   			
   				return shipMode.getDescription(new Integer(langId), new Integer(shipMode.getShippingModeId())).getDescription();
   			} else {
   				return "";
   			}
   			
   		} catch (Exception ex) {
   			return "";
   		}
   		
   		
	}
		
	// retrieve the payment status for Advanced Order
	public String getCOPaymentStatus(Hashtable tmpOrderLabels, HttpServletRequest request, String orderId) {
		String paymentState = null;
		com.ibm.commerce.edp.beans.EDPPaymentStatusDataBean eDPPaymentStatusDataBean	=	new com.ibm.commerce.edp.beans.EDPPaymentStatusDataBean();
		eDPPaymentStatusDataBean.setOrderId(new Long(orderId));
		eDPPaymentStatusDataBean.setNeedGlobalized(false);
		try {
			com.ibm.commerce.beans.DataBeanManager.activate(eDPPaymentStatusDataBean, request);
			paymentState = eDPPaymentStatusDataBean.getPaymentStatus();
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentStatus", "Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		}
	

		if (paymentState == null) {
		   paymentState = (String)tmpOrderLabels.get("orderSummaryDetPaymentStateNotApplicable");
		} else {
		   if (paymentState.equals("Failure")){
               paymentState = "Failed";
           }
		   paymentState = (String)tmpOrderLabels.get(paymentState);
		}

		return paymentState;

	}
	
	
	// retrieve the payment method description in correct locale
	public String getPaymentMethodDescription(String orderId, Hashtable tmpOrderLabels, HttpServletRequest request) {
		String policyId = null;
		String TCId = null;
		String payMethodDescription = null;
		
		OrderPaymentInfoDataBean orderPayInfoBean = new OrderPaymentInfoDataBean();
		
		// get description if it was saved as a name value pair
		try {
			Enumeration payInfoEnumeration = orderPayInfoBean.findByOrder(new Long(orderId));
			while (payInfoEnumeration.hasMoreElements()) {
		
   				OrderPaymentInfoAccessBean ordpayinfoBean = (OrderPaymentInfoAccessBean)payInfoEnumeration.nextElement();
   				if ( ordpayinfoBean.getPaymentPairName().equals("description") ) {
					payMethodDescription = ordpayinfoBean.getPaymentPairValue();
				} else if ( ordpayinfoBean.getPaymentPairName().equals(ECContractCmdConstants.EC_CONTRACT_TC_ID) ) {
      					TCId = ordpayinfoBean.getPaymentPairValue();
   				} else if ( ordpayinfoBean.getPaymentPairName().equals(ECContractCmdConstants.EC_POLICY_ID) ) {
      					policyId = ordpayinfoBean.getPaymentPairValue();
   				}   				
			}

			// if no description yet then try to get description by using TCId & policyId
			if ( (payMethodDescription == null) && (TCId != null) && (!TCId.equals("")) ) {
				UsablePaymentTCListDataBean usablePaymentTCs = new UsablePaymentTCListDataBean();
				usablePaymentTCs.setOrderId(new Long(orderId));
				com.ibm.commerce.beans.DataBeanManager.activate(usablePaymentTCs, request);

				//revisit@kng
				// Try to find the payment TC that has that policyId
				PaymentTCInfo[] paymentTCInfo = usablePaymentTCs.getPaymentTCInfo();
				for (int i = 0; i < paymentTCInfo.length; i++) {
					if ( paymentTCInfo[i].getPolicyId().equals(policyId) && paymentTCInfo[i].getTCId().equals(TCId) ) {
						payMethodDescription = paymentTCInfo[i].getLongDescription();
					}
				}
			}
			else if ((payMethodDescription == null)&& (policyId != null) && (!policyId.equals(""))) {
				UsablePaymentTCListDataBean usablePaymentTCs = new UsablePaymentTCListDataBean();
				usablePaymentTCs.setOrderId(new Long(orderId));
				com.ibm.commerce.beans.DataBeanManager.activate(usablePaymentTCs, request);

				//revisit@kng
				// Try to find the payment TC that has that policyId
				PaymentTCInfo[] paymentTCInfo = usablePaymentTCs.getPaymentTCInfo();
				for (int i = 0; i < paymentTCInfo.length; i++) {
					if ( paymentTCInfo[i].getPolicyId().equals(policyId)) {
						payMethodDescription = paymentTCInfo[i].getLongDescription();
					}
				}
			}

			// if still no description then display unknown
			if (payMethodDescription == null) {
				payMethodDescription = (String)tmpOrderLabels.get("orderSummaryDetPaymentUnknown");
			}
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentMethodDescription", "Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		}
		
		return payMethodDescription;
	}

	// retrieve the credit card brand
	public String getPaymentCreditCardBrand(String orderId) {
		String cctype = "";
		
		OrderPaymentInfoDataBean orderPayInfoBean = new OrderPaymentInfoDataBean();
		try {
			Enumeration payInfoEnumeration = orderPayInfoBean.findByOrder(new Long(orderId));
			while (payInfoEnumeration.hasMoreElements()) {
			
   				OrderPaymentInfoAccessBean ordpayinfoBean = (OrderPaymentInfoAccessBean)payInfoEnumeration.nextElement();
   				if ( ordpayinfoBean.getPaymentPairName().equals(ECConstants.EC_CC_TYPE) ) {
 					cctype = ordpayinfoBean.getPaymentPairValue();
   				} 
			}
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentCreditCardBrand", "Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		}
		
		return cctype;	
	}

	// retrieve offline method
	public String getPaymentOfflineMethod(String orderId) {
		String offlineMethod = "";
		
		OrderPaymentInfoDataBean orderPayInfoBean = new OrderPaymentInfoDataBean();
		try {
			Enumeration payInfoEnumeration = orderPayInfoBean.findByOrder(new Long(orderId));
			while (payInfoEnumeration.hasMoreElements()) {
			
   				OrderPaymentInfoAccessBean ordpayinfoBean = (OrderPaymentInfoAccessBean)payInfoEnumeration.nextElement();
   				if ( ordpayinfoBean.getPaymentPairName().equals("$METHOD") ) {
 					offlineMethod = ordpayinfoBean.getPaymentPairValue();
   				} 
			}
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentOfflineMethod", "Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		}
		
		return offlineMethod;	
	}

	// retrieve the credit card number
	public String getPaymentCreditCardNumber(String orderId) {
		String ccnumber = "";
		
		OrderPaymentInfoAccessBean orderPayInfoBean = new OrderPaymentInfoAccessBean();
		try {
			Enumeration payInfoEnumeration = orderPayInfoBean.findByOrder(new Long(orderId));
			while (payInfoEnumeration.hasMoreElements()) {
			
   				OrderPaymentInfoAccessBean ordpayinfoBean = (OrderPaymentInfoAccessBean)payInfoEnumeration.nextElement();
   				if ( ordpayinfoBean.getPaymentPairName().equals(ECConstants.EC_CC_NUMBER) ) {
 					ccnumber = ordpayinfoBean.getPaymentPairValue();
   				} 
			}
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getPaymentCreditCardNumber", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
		}
		
		return ccnumber;
	}
	
	//Get the estimated ship date for the order
	public String getEstimatedShipDate(OrderDataBean tmpOrderBean, Locale loc)
	{
		try {
		    String findEstimatedShipDateSQL = "";
		         //when order is not shipped but released, then the estimated ship date is equal to timereleased+shippingoffset
		        //when order is not released but just allocated, the estimated ship date should be max(now, estavailtime+shipping offset)
		      if(tmpOrderBean.getStatus().equals(OrderConstants.ORDER_RELEASED)){
   		        findEstimatedShipDateSQL = 
		           "SELECT "
		           + "MAX("
		           + TimestampHelper.getSQLSyntaxTimestampPlusInteger("T1.TIMERELEASED ", "T1.SHIPPINGOFFSET")
		           + ")"
				   + " FROM ORDERITEMS T1 WHERE T1.ORDERS_ID=?";
			   }	   		    
   		      else{
			 findEstimatedShipDateSQL =
				"SELECT "
					+ "MAX("
					+ TimestampHelper.getSQLSyntaxTimestampPlusInteger("T1.ESTAVAILTIME", "T1.SHIPPINGOFFSET")
					+ "),"
					+ TimestampHelper.getSQLSyntaxTimestampPlusInteger(TimestampHelper.getSQLCurrentTimestamp(), "MAX(T1.SHIPPINGOFFSET)")
					+ " FROM ORDERITEMS T1 WHERE T1.ORDERS_ID=?";
			 }	
             
             ServerJDBCHelperBean abServerJDBCHelper = com.ibm.commerce.ejb.helpers.SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
			 Object[] parameters = new Object[1];
			 parameters[0] = tmpOrderBean.getOrderId();
			 
			 Vector vecRows = abServerJDBCHelper.executeParameterizedQuery(findEstimatedShipDateSQL, parameters);	
			 for (int i=0; i<vecRows.size(); i++)
			{
				Vector vResult = (Vector) vecRows.elementAt(i);

				if(vResult.size()>1){
					Timestamp t1 = (Timestamp)vResult.elementAt(0);
					Timestamp t2 = (Timestamp)vResult.elementAt(1);
					
					if (t1 == null)
						return TimestampHelper.getDateTimeFromTimestamp(t2,loc);
					else if (t2 == null)
						return TimestampHelper.getDateTimeFromTimestamp(t1,loc);
					else
						return (t1.compareTo(t2) > 0 ? TimestampHelper.getDateTimeFromTimestamp(t1,loc) : TimestampHelper.getDateTimeFromTimestamp(t2,loc));
				}
				else {
				     return TimestampHelper.getDateTimeFromTimestamp((Timestamp)vResult.elementAt(0),loc);
				}
			}			
					
		} catch (Exception ex) {
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getEstimatedShipDate", "Exception in OrderSummaryDetails.jsp");
			return null;
		}
		return "";
	}
	
	//Get the request ship date for the order item
	public String getOrderItemRequestShipDate(OrderItemDataBean tmpOrderItemBean, Locale loc)
	{
						
		String result = "";
		try {
			result = TimestampHelper.getDateFromTimestamp(tmpOrderItemBean.getRequestedShipDate(), loc);
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemRequestShipDate", "Exception in OrderSummaryDetails.jsp");		
			ex.printStackTrace();
		
		}
		return result;
    }

	//Get the actual ship date for the order item
	public String getOrderItemActualShipDate(OrderItemDataBean tmpOrderItemBean, Locale loc)
	{
						
		String result = "";
		try {
			result = TimestampHelper.getDateTimeFromTimestamp(tmpOrderItemBean.getTimeShippedInEntityType(), loc);
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemActualShipDate", "Exception in OrderSummaryDetails.jsp");		
			ex.printStackTrace();
		
		}
		return result;
				
		
	}


	//Check that if any of the order items in the order has an actual ship date 
	public boolean ifActualShipDateExist(OrderDataBean tmpOrderBean)
	{
						
		boolean result = false;

		try {
			OrderItemDataBean[] orderItems = null;
			orderItems = tmpOrderBean.getOrderItemDataBeans();
			
			for (int i=0; orderItems != null && i<orderItems.length && orderItems[i].getCatalogEntryId().length()!=0; i++) {
				String actualShipDate = orderItems[i].getTimeShipped();
				if ((null != actualShipDate) && !(actualShipDate.trim().equals(""))) {
					return true;
				}
			}

		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "ifActualShipDateExists", "Exception in OrderSummaryDetails.jsp");		
			ex.printStackTrace();
		
		}
		
		return result;
		

				
		
	}
	
	
        //get Order Level Discount for display
	public double getOrderLevelDiscountForDisplay(OrderDataBean tmpOrderBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			//discount = tmpOrderBean.getTotalAdjustmentByDisplayLevel(new Integer(1));
			discount = tmpOrderBean.getAdjustmentTotal(CalculationConstants.USAGE_DISCOUNT,	CalculationConstants.DISPLAYLEVEL_ORDER);
		} catch (Exception ex) {
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderLevelDiscountForDisplay", "Exception in OrderSummaryDetails.jsp");	
		}
		if (discount != null) {
			displayDiscount = discount.doubleValue() * -1;
		}
		return displayDiscount;
			
	}
	
	//get OrderItem Level Discount for display	
	public double getOrderItemLevelDiscountForDisplay(OrderItemDataBean tmpOrderItemBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			//discount = tmpOrderItemBean.getTotalAdjustmentByDisplayLevel(new Integer(0));
			discount = tmpOrderItemBean.getAdjustmentTotal(CalculationConstants.USAGE_DISCOUNT,	CalculationConstants.DISPLAYLEVEL_ORDERITEM);
		} catch (Exception ex) {
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemLevelDiscountForDisplay", "Exception in OrderSummaryDetails.jsp");
		}
		if (discount != null) {
			displayDiscount = discount.doubleValue() * -1;
		}
		return displayDiscount;
	}
	
	//get Surcharge Adjustment
	public double getSurchargeAdjustment(OrderDataBean tmpOrderBean) {
		double displaySurcharge = 0;
		java.math.BigDecimal surcharge = new java.math.BigDecimal(0);
		try {
			//surcharge = tmpOrderBean.getTotalAdjustmentByDisplayLevel(CalculationConstants.USAGE_SURCHARGE);
			surcharge = tmpOrderBean.getSurchargeAdjustmentTotal();
		} catch (Exception ex) {
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2B.jsp", "getSurchargeAdjustment", "Exception in OrderSummaryDetails.jsp");	
		}
		if (surcharge != null) {
			displaySurcharge = surcharge.doubleValue();
		}
		return displaySurcharge;		
	}
		
	
	public String getLogonID(String memberId, HttpServletRequest request) {
		try {
			UserRegistrationDataBean userRegDataBean = new UserRegistrationDataBean();
			userRegDataBean.setUserId(memberId); 
			DataBeanManager.activate(userRegDataBean, request);
			return userRegDataBean.getLogonId();
	
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getLogonID", "Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		
			return "";
		}
			
	}
	
	
	public String getOrderGrandTotal(OrderDataBean tmpOrderBean) {
		try {
			return tmpOrderBean.getGrandTotal().getAmount().toString();

		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderGrandTotal", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
		
			return "0";
		}
	}
	
	public double getOrderItemSubTotal(OrderItemDataBean tmpOrderItem) {
		double total = 0;
		try {
		
			total = tmpOrderItem.getFormattedTotalProduct().getAmount().doubleValue();
			double discount = getOrderItemLevelDiscountForDisplay(tmpOrderItem);
			total = total - discount;
			
		} catch (Exception ex) {
			//Exception
			ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "getOrderItemSubTotal", "Exception in OrderSummaryDetails.jsp");
			ex.printStackTrace();
			
		}
	
		return total;
	
	}
	
	public String getFormattedQuantity(double quantity, Locale locale) {
		java.text.NumberFormat numberFormat = java.text.NumberFormat.getNumberInstance(locale);
		return numberFormat.format(quantity);
	}

	
	public String getShippingInstruction(OrderItemDataBean anOrderItem){
        String result = "";
        try {
            result = anOrderItem.getShipInstructsDataBean().getShipInstructions();
        }catch(Exception e){
            result = "";
        }
        return result;
	}
	
	public String getShipCarrAccntNum(OrderItemDataBean anOrderItem){
        String result = "";
        try {
            result = anOrderItem.getShipCarrAccntDataBean().getShipCarrAccntNum();
        }catch(Exception e){
            result = "";
        }
        return result;
	}
	public String getExpedited(OrderItemDataBean anOrderItem,Hashtable orderLables){
	    String result = "";
	    try{
	    if (anOrderItem.getIsExpedited().equals("Y")){
	        result = (String)orderLables.get("expedited");
	    }else{
	        result = (String)orderLables.get("notExpedited");
	    }
	    }catch(Exception e){
	        result = "";
	    }
	    return result;
	}	
%>



<%

CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
Locale jLocale = cmdContext.getLocale();
DateFormat df = DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT,jLocale);
Integer storeId = cmdContext.getStoreId();
String langId = cmdContext.getLanguageId().toString();

StoreDataBean  storeBean = new StoreDataBean();
storeBean.setStoreId(storeId.toString());
com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);

Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);


//Obtain the order id
//String orderId = "10852";
com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String sendNotification = URLParameters.getParameter("sendNotification");
String orderId = URLParameters.getParameter("orderId");



OrderDataBean orderBean = new OrderDataBean ();
OrderItemDataBean[] afirstOrderItems = null;


if ((orderId != null) && !(orderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(orderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	afirstOrderItems = orderBean.getOrderItemDataBeans();
}


//Obtain the coupons associated with this order
Long orderIdLong = new Long(Long.parseLong(orderBean.getOrderId()));
//Long orderIdLong = new Long(10051);
ViewAppliedCouponDataBean couponBean = new ViewAppliedCouponDataBean();
Vector couponList = new Vector();

try {
	couponBean.setOrderId(orderIdLong);
	com.ibm.commerce.beans.DataBeanManager.activate(couponBean, request);
	//couponBean.populate();
	couponList = couponBean.getBcIds();
} catch (Exception e) {
	ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "none", "an exception was thrown when coupon bean was populated");
	e.printStackTrace();
}

//Vector couponList = null;
StringBuffer couponIdDisplay = new StringBuffer();


Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

if (localeAddrFormat == null) {
	localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
}


com.ibm.commerce.tools.optools.order.beans.OrderCommentDataBean orderCommentBean = new com.ibm.commerce.tools.optools.order.beans.OrderCommentDataBean();
orderCommentBean.setOrderId(orderId);
OrderCommentAccessBean[] currentComments = null;
try {
	com.ibm.commerce.beans.DataBeanManager.activate(orderCommentBean, request);
	currentComments = orderCommentBean.getOrderComments();
} catch (Exception ex) {
	//Exception
	ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "none", "an exception when population OrderCommentDataBean");	
	ex.printStackTrace();
}

%>


<html>
  <head>  
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

    <title><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetDialogTitle").toString()) %></title>   
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
    <script type="text/javascript">
  	<!-- <![CDATA[
      var langId = <%=UIUtil.toJavaScript(langId)%>;
      var currency = "<%=UIUtil.toJavaScript(orderBean.getCurrency())%>";
      
      function init() {
      	parent.setContentFrameLoaded(true);
      	
      	<% if ( (sendNotification != null) && (sendNotification.equals("true")) ) { %>
      		alertDialog("<%= UIUtil.toJavaScript((String)orderLabels.get("notificationSuccessful")) %>");
      	<% } else if ( (sendNotification != null) && (sendNotification.equals("false")) ) { %>
      		alertDialog("<%= UIUtil.toJavaScript((String)orderLabels.get("notificationfailed")) %>");
      	<% } %>
      }
      
      function printAction() {
      	window.print();
      }
   
      function emailOrder() {
	top.setContent('<%= UIUtil.toJavaScript((String)orderLabels.get("emailOrder")) %>','/webapp/wcs/tools/servlet/DialogView?XMLFile=order.notify&amp;orderId=<%= orderId %>', true)
      }
      
      function nlvFormatAddress(title, firstName, lastName, address1, address2, address3, city, region, country, postalCode, phoneNumber, emailAddress) {
	
	var newLine = "";
	<%
		for (int i = 1; i < localeAddrFormat.size(); i++) {
		String addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
		String[] addressFields = Util.tokenize(addressLine, ","); 
		for (int j = 0; j < addressFields.length; j++) {
	%>
	
		if ("<%=addressFields[j]%>" == "title")
			newLine += title;
		if ("<%=addressFields[j]%>" == "firstName")
			newLine += firstName;
		if ("<%=addressFields[j]%>" == "lastName")
			newLine += lastName;
		if ("<%=addressFields[j]%>" == "space")
			newLine += " ";
		<% 
		   String nextAddrField = "";
		   int p = j+1;
		   while (p < addressFields.length) {
		      	if ((null != addressFields[p]) 
		      	&& !(addressFields[p].trim().equals("space")) 
		      	&& !(addressFields[p].trim().equals("comma"))) 
		      	{
		      		nextAddrField = addressFields[p].trim();
     				break;
		      		
			} else
				p++;
		   
		   }
		   
		   

		   int q = j-1;
		   String prevAddrField = "";
		   while (q >= 0) {
 
		      	if ((null != addressFields[q]) 
		      	&& !(addressFields[q].trim().equals("space")) 
		      	&& !(addressFields[q].trim().equals("comma"))) 
		      	{
		      		prevAddrField = addressFields[q].trim();
        			break;
			} else
				q--;
		   
		   }
		   

		   
		   if (!(nextAddrField.equals("")) && !(prevAddrField.equals("")))  {
		%>
		
		
		if ((trim(<%=nextAddrField%>) != "") && (trim(<%=prevAddrField%>) != "")) {
			if ("<%=addressFields[j]%>" == "comma") 
				newLine += ",";
		}
		
		<%}%>
		if ("<%=addressFields[j]%>" == "address1")
			newLine += address1;
		if ("<%=addressFields[j]%>" == "address2")
			newLine += address2;
		if ("<%=addressFields[j]%>" == "address3")
			newLine += "";
		if ("<%=addressFields[j]%>" == "city")
			newLine += city;
		if ("<%=addressFields[j]%>" == "region")
			newLine += region;
		if ("<%=addressFields[j]%>" == "country")
			newLine += country;
		if ("<%=addressFields[j]%>" == "postalCode")
			newLine += postalCode;
		if ("<%=addressFields[j]%>" == "phoneNumber")
			newLine += "<%=UIUtil.toHTML((String)orderMgmtNLS.get("bPhone"))%>" + " "  + phoneNumber;
		<% } %>
		newLine += "<BR>";
	<% 
		} 
	%>
		if (emailAddress != null)
			newLine += "<%=UIUtil.toHTML((String)orderMgmtNLS.get("bEmail"))%>" + " "  + emailAddress;
		
		newLine += "<BR>";
		return newLine;
	}

    //[[>-->
    </script>
  </head>
  <body class="content" onload="init();">        
	<h1><%=UIUtil.toHTML((String)orderLabels.get("orderDetailsTitle")) %></h1>    
	<!-- Order item details information -->
    <p><b><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderInformation")) %></b></p>
    <br /><br />
    <table>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderNumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML((String)orderBean.getOrderId()) %></i></td>
		</tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLastUpdate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>

			<% 
			
			String orderLastUpdate;			
			if (orderBean.getLastUpdateInEntityType() != null) {
				orderLastUpdate = TimestampHelper.getDateTimeFromTimestamp(orderBean.getLastUpdateInEntityType(), jLocale);
			} else
			 	orderLastUpdate = (String) orderLabels.get("orderSummaryDetNotAvailable");
			%>		           


			<td><i><%= UIUtil.toHTML((String)orderLastUpdate) %></i></td>
		</tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetProductOrderState")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML((String)orderLabels.get(orderBean.getStatus())) %></i></td>
		</tr>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderOriginatorLogon")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML((String)getLogonID(orderBean.getMemberId(), request)) %></i></td>
		</tr>
	</table>
	<br />
	<table class="list" width="95%" cellpadding="8" cellspacing="1" summary='<%= UIUtil.toHTML(orderMgmtNLS.get("orderInfo").toString()) %>'>
		<tr class="list_roles"> 
			<td class="list_header" id="iNa" align="left"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
			<td class="list_header" id="iNu" align="left"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
			<td class="list_header" id="iQu" align="left"><%= UIUtil.toHTML(orderMgmtNLS.get("itemQuantity").toString()) %></td>
		    <td class="list_header" id="iEx" align="left"><%= UIUtil.toHTML(orderMgmtNLS.get("itemExpedite").toString()) %></td>
		    <td class="list_header" id="iRe" align="left"><%= UIUtil.toHTML(orderMgmtNLS.get("itemReqestedShipDate").toString()) %></td>
			<td class="list_header" id="iPr" align="right"><%= UIUtil.toHTML(orderMgmtNLS.get("itemPrice").toString()) %></td>
			<td class="list_header" id="iPr" align="right"><%= UIUtil.toHTML(orderMgmtNLS.get("orderItemLevelDiscount").toString()) %></td>
			<td class="list_header" id="iTo" align="right"><%= UIUtil.toHTML(orderMgmtNLS.get("itemTotal").toString()) %></td>
		</tr>

	<%
		String classId="list_row2";
		for (int i=0; afirstOrderItems != null && i<afirstOrderItems.length && afirstOrderItems[i].getCatalogEntryId().length()!=0; i++) {
	%>
		<tr class="<%= UIUtil.toHTML(classId) %>">
			<td class="list_info1" align="left">
				<%=getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request)%>
			</td>
			<td class="list_info1" align="left">
				<%=afirstOrderItems[i].getPartNumber()%>
			</td>
			<td class="list_info1" align="left">
				<%=getFormattedQuantity(afirstOrderItems[i].getQuantityInEntityType().doubleValue(), jLocale)%>
			</td>
			
		    <td class="list_info1" align="left">
		        <%= getExpedited(afirstOrderItems[i],orderLabels)%>
		    </td>
		
		    <td class="list_info1" align="right">
			    <%= UIUtil.toHTML(getOrderItemRequestShipDate(afirstOrderItems[i], jLocale)) %>
		    </td>
			
			<td class="list_info1" align="right">
				<script>document.writeln(parent.numberToCurrency("<%=afirstOrderItems[i].getPrice()%>", currency, langId))</script>
			</td>
			<td class="list_info1" align="right">
				<script>document.writeln(parent.numberToCurrency("<%=getOrderItemLevelDiscountForDisplay(afirstOrderItems[i])%>", currency, langId))</script>
			</td>	
			<td class="list_info1" align="right">
				<script>document.writeln(parent.numberToCurrency("<%=getOrderItemSubTotal(afirstOrderItems[i])%>", currency, langId))</script>
			</td>	
		</tr>
	<%
			if (classId.equals("list_row2")) {
				classId="list_row1";
			} else {
				classId="list_row2";
			}
		}
	%>
	
	</table>
	<br />
	<table width="95%">
		<tr>
	    	<td colspan="6" align="right">
		    	<table cellpadding="0" cellspacing="0" border="0">      
	              	<tr>
		        		<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("orderLevelDiscount")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
  							<!-- <![CDATA[
								var orderLevelMenuAdjustment = -1*<%= UIUtil.toJavaScript(getOrderLevelMenuAdjustment(cmdContext, orderBean, storeId)) %>;
								var orderLevelDiscount = <%= getOrderLevelDiscountForDisplay(orderBean)%> - orderLevelMenuAdjustment;
								document.writeln(parent.numberToCurrency(orderLevelDiscount, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
					<tr>
		        		<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("minusAdjustment")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
							<!-- <![CDATA[
							document.writeln(parent.numberToCurrency(orderLevelMenuAdjustment, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("surchargeAdjustment")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
  							<!-- <![CDATA[
  							    var surchargeAdjustment = <%= getSurchargeAdjustment(orderBean)%>
								document.writeln(parent.numberToCurrency(surchargeAdjustment, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
					<!--//add by for d98785....-->
<tr>
   <td></td>
   <td></td>
   <td colspan="2" align="right" nowrap="nowrap">
		<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalOriginalShippingCharge")) %></td>
   <td align="right" width="130">
	<script type="text/javascript">
  		<!-- <![CDATA[
  			var totalOriginalShippingCharge = <%=UIUtil.toJavaScript(orderBean.getTotalShippingCharge()) %>;								
  			document.writeln(parent.numberToCurrency(totalOriginalShippingCharge, currency, langId));
		//[[>-->
	</script>
   </td>
</tr>
<tr>
	<td></td>
	<td></td>
	<td colspan="2" align="right" nowrap="nowrap">
		<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalShippingAdjustment")) %></td>
	<td align="right" width="130">
	    <script type="text/javascript">
  		<!-- <![CDATA[
  		var totalShippingChargeAdjustment =  <%= UIUtil.toJavaScript(orderBean.getShippingAdjustmentTotal().toString()) %>;
		document.writeln(parent.numberToCurrency(totalShippingChargeAdjustment, currency, langId));
				//[[>-->
	     </script>
	</td>
</tr>	<!--//end add d98785....-->					
					<tr>
		        		<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalShippingCharge")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
							<!-- <![CDATA[
							var totalShippingCharge = <%= UIUtil.toJavaScript(orderBean.getShippingChargeTotal().toString()) %>;
							document.writeln(parent.numberToCurrency(totalShippingCharge, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
					<tr>
			       		<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalTax")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
							<!-- <![CDATA[
							var totalTax = <%= UIUtil.toJavaScript(orderBean.getTotalTax()) %>;
							var totalShippingTax = <%= UIUtil.toJavaScript(orderBean.getTotalShippingTax()) %>;
							document.writeln(parent.numberToCurrency(totalTax+totalShippingTax, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderLabels.get("couponLabel")) %></td>
						<td align="right" width="130">
							<script type="text/javascript">
							<!-- <![CDATA[
					<%
										Enumeration e=couponList.elements();
										while(e.hasMoreElements())
										{	Long coupon = (Long) e.nextElement();
											couponIdDisplay.append(coupon.toString());
											if (e.hasMoreElements()) {
												couponIdDisplay.append(",");
											}
										}
									%>
									document.writeln("<%= couponIdDisplay.toString() %>");
							//[[>-->
							</script>
						</td>
					</tr>
					<tr>
		        		<td></td>
						<td></td>
						<td colspan="2" align="right" nowrap="nowrap"><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("grandTotal")) %> &nbsp;[<%= orderBean.getCurrency() %>]</td>
						<td align="right" width="130">
							<script type="text/javascript">
							<!-- <![CDATA[
							var grandTotal = <%= UIUtil.toJavaScript(getOrderGrandTotal(orderBean)) %>;
							document.writeln(parent.numberToCurrency(grandTotal, currency, langId));
							//[[>-->
							</script>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<!-- Order item shipping information -->
	<br /><br />
	<p><b><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetShippingInfo")) %></b></p>
	<br /><br />
    <table>
		<% 
			String estimateDate = getEstimatedShipDate(orderBean, jLocale);
			if (!(ifActualShipDateExist(orderBean)) && (estimateDate != null) && !(estimateDate.trim().equals(""))) { %>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetEstimatedShipDate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML((String)estimateDate) %></i></td>
		</tr>
		<% } else if (!(ifActualShipDateExist(orderBean))) { %>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetEstimatedShipDate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetNotAvailable")) %></i></td>
		</tr>
		<% } %>
	</table>
	<br />
	<table class="list" width="95%" cellpadding="8" cellspacing="1" summary='<%= UIUtil.toHTML(orderMgmtNLS.get("orderInfo").toString()) %>'>
		<tr class="list_roles" align="left"> 
			<td class="list_header" id="iNa"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetActualShipDate").toString()) %></td>			
			<td class="list_header" id="IEp"><%= UIUtil.toHTML(orderMgmtNLS.get("itemExpedite").toString()) %></td>
			<td class="list_header" id="IRd"><%= UIUtil.toHTML(orderMgmtNLS.get("itemReqestedShipDate").toString()) %></td>		
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShipmentTrackingId").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingMethod").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingAddress").toString()) %></td>			
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingInstructions").toString()) %></td>			
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingChargeType").toString()) %></td>			
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingCarrierAccntNum").toString()) %></td>			
		</tr>
	<%
		classId="list_row2";
		AddressDataBean shippingAddress = null;
		for (int i=0; afirstOrderItems != null && i<afirstOrderItems.length && afirstOrderItems[i].getCatalogEntryId().length()!=0; i++) {
	%>
		<tr class="<%= UIUtil.toHTML(classId) %>">
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request)) %>
			</td>
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(afirstOrderItems[i].getPartNumber()) %>
			</td>
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(getOrderItemActualShipDate(afirstOrderItems[i], jLocale)) %>
			</td>
		    <td class="list_info1" align="left">
			    <%= afirstOrderItems[i].getIsExpedited()%>
		    </td>
			<td class="list_info1" align="right">
	    	    <%= UIUtil.toHTML(getOrderItemRequestShipDate(afirstOrderItems[i], jLocale)) %>
     		</td>
			<td class="list_info1" align="left">
			<%
			String[] trackingIds = null;
			try {
				trackingIds = afirstOrderItems[i].getTrackingIds();
			} catch (Exception ex) {
				//Exception
				ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "none", "Exception in OrderSummaryDetails.jsp (obtain tracking ids)");	
				ex.printStackTrace();
				trackingIds = null;
			}			
		
			if (trackingIds != null)
			{
				
				for (int j=0; j< trackingIds.length; j++) 
				{
					if ((null != trackingIds[j]) && !(trackingIds[j].trim().equals("")) ) 
					{
						
			%>	
					<%= UIUtil.toHTML(trackingIds[j]) %>
					<br />
			
			<%
					}
				}
			
			
				
			%>
			
			<% } %>
			
			</td>
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(getShipMode(afirstOrderItems[i].getShippingModeId(), langId, request)) %>
			</td>
			<td class="list_info1" align="left">
				<%  
				shippingAddress = getAddress(afirstOrderItems[i].getAddressId(), request);
				if (null != shippingAddress) {
				 %>
				<script type="text/javascript">
  				<!-- <![CDATA[
				document.write(nlvFormatAddress("<%= UIUtil.toHTML(shippingAddress.getPersonTitle())%>",
								"<%= UIUtil.toHTML(shippingAddress.getFirstName())%>",
								"<%= UIUtil.toHTML(shippingAddress.getLastName())%>",
								"<%= UIUtil.toHTML(shippingAddress.getAddress1())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getAddress2())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getAddress3())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getCity())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getStateProvDisplayName())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getCountryDisplayName())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getZipCode())%>", 
								"<%= UIUtil.toHTML(shippingAddress.getPhone1())%>"))
				//[[>-->
				</script>
				<% } %>
			</td>
			<td>
			    <%=UIUtil.toHTML(getShippingInstruction(afirstOrderItems[i]))%>
			</td>
				
			<td>
				<%=UIUtil.toHTML(getPolicyName(afirstOrderItems[i], request))%>
			</td>
			
			<td>
				<%=UIUtil.toHTML(getShipCarrAccntNum(afirstOrderItems[i]))%>
			</td>
			
		</tr>
	<%
			if (classId.equals("list_row2")) {
				classId="list_row1";
			} else {
				classId="list_row2";
			}
		}
	%>
	</table>
	<!-- Order billing address information -->
	<br /><br />
	<p><b><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetBillingAddress")) %></b></p>
	<br />&nbsp;
	<table>
		<tr>
			<td align="left">
			<i>
	
	<%
	AddressDataBean billingAddress = null;
	billingAddress = getAddress(orderBean.getAddressId(), request);
	if (null != billingAddress) {
						
	%>
				 
			<script type="text/javascript">
  			<!-- <![CDATA[
			document.write(nlvFormatAddress("<%= UIUtil.toHTML(billingAddress.getPersonTitle())%>",
						"<%= UIUtil.toHTML(billingAddress.getFirstName())%>",
						"<%= UIUtil.toHTML(billingAddress.getLastName())%>",
						"<%= UIUtil.toHTML(billingAddress.getAddress1())%>", 
						"<%= UIUtil.toHTML(billingAddress.getAddress2())%>", 
						"<%= UIUtil.toHTML(billingAddress.getAddress3())%>", 
						"<%= UIUtil.toHTML(billingAddress.getCity())%>", 
						"<%= UIUtil.toHTML(billingAddress.getStateProvDisplayName())%>", 
						"<%= UIUtil.toHTML(billingAddress.getCountryDisplayName())%>", 
						"<%= UIUtil.toHTML(billingAddress.getZipCode())%>", 
						"<%= UIUtil.toHTML(billingAddress.getPhone1())%>",
						"<%= UIUtil.toHTML(billingAddress.getEmail1())%>"))
			//[[>-->
			</script>

	<% } else { %>
			<script type="text/javascript">
  			<!-- <![CDATA[
			document.write("<%=UIUtil.toJavaScript((String)orderLabels.get("orderSummaryDetNotProvided"))%>");
			//[[>-->
			</script>
	<% } %>
			</i>
			</td>
		</tr>
	</table>
	<!-- Order payment information -->
	<br /><br />
	<p><b><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetPaymentInformation")) %></b></p>
	<br />&nbsp;
		<table>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetPaymentStatus")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i>
			     <%= UIUtil.toHTML((String)getCOPaymentStatus(orderLabels, request,orderId)) %>
			</i></td>
		</tr>
	  </table>
	<br />
	<%
		EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
		edpPIDataBean.setOrderId(new Long(orderId));
		com.ibm.commerce.beans.DataBeanManager.activate(edpPIDataBean, request);
		ArrayList pis = edpPIDataBean.getPaymentInstructions();
		Iterator iteForPI = pis.iterator();
	%>
	<table class="list" width="95%" cellpadding="8" cellspacing="1" summary='<%= UIUtil.toHTML(orderMgmtNLS.get("paymentInstructions").toString()) %>'>
		<tr class="list_roles" align="left"> 
			<td class="list_header" id="pm"><%= UIUtil.toHTML(orderMgmtNLS.get("orderSummaryPaymentMethod").toString()) %></td>
			<td class="list_header" id="pa"><%= UIUtil.toHTML(orderMgmtNLS.get("paymentInstructionAmount").toString()) %></td>
            <td class="list_header" id="an"><%= UIUtil.toHTML(orderMgmtNLS.get("account").toString()) %></td> 
            <td class="list_header" id="ba"><%= UIUtil.toHTML(orderMgmtNLS.get("paymentBillingAddress").toString()) %></td>			
		</tr>
	<%
		while (iteForPI.hasNext()){
		   EDPPaymentInstruction aPI = (EDPPaymentInstruction)iteForPI.next();
		   HashMap protocalData = aPI.getProtocolData();		   
	%>
	   <tr>
	        <td align="left"> <%=aPI.getPaymentMethod()%> </td>
	        <td align="left"> 
	        	<script type="text/javascript">
  					<!-- <![CDATA[
						document.writeln(parent.numberToCurrency(<%=aPI.getAmount()%>, currency, langId));
					//[[>-->
				</script>
	        </td>
	        
	        <%
		      String accountNumber = (String)protocalData.get("account");
		        if (accountNumber !=null &&  !accountNumber.equals("")) {
			 %>
			   <td align="left">    <%=accountNumber%>  </td>
		     <% } else {%>
		       <td align="left">   <%=""%>  </td>
		     <% }
		     %>
		     
		       
	         <% 
	         String paymentBillFirstname  = (String)protocalData.get("billto_firstname");
	         if (paymentBillFirstname == null){
	             paymentBillFirstname = "";
	         }
	         String paymentBillLastname   = (String)protocalData.get("billto_lastname");
	         if (paymentBillLastname == null){
	             paymentBillLastname = "";
	         }
	         String paymentBillAddress1   = (String)protocalData.get("billto_address1");
	         if (paymentBillAddress1 == null){
	             paymentBillAddress1 = "";
	         }
	         String paymentBillAddress2   = (String)protocalData.get("billto_address2");
	         if (paymentBillAddress2 == null){
	             paymentBillAddress2 = "";
	         }
	         String paymentBillAddress3   = (String)protocalData.get("billto_address3");
	         if (paymentBillAddress3 == null){
	             paymentBillAddress3 = "";
	         }
	         String paymentBillCity       = (String)protocalData.get("billto_city");
	         if (paymentBillCity == null){
	             paymentBillCity = "";
	         }
	         String paymentBillState      = (String)protocalData.get("billto_stateprovince");
	         if (paymentBillState == null){
	             paymentBillState = "";
	         }
	         String paymentBillZipCode    = (String)protocalData.get("billto_zipcode");
	         if (paymentBillZipCode == null){
	             paymentBillZipCode = "";
	         }
	         String paymentBillCountry    = (String)protocalData.get("billto_country");
	         if (paymentBillCountry == null){
	             paymentBillCountry = "";
	         }
	         String paymentBillPhone    = (String)protocalData.get("billto_phone_number");
	         if (paymentBillPhone == null){
	             paymentBillPhone = "";
	         }
	        %>
		    <td align="left"> 
		     <script type="text/javascript">
  			  <!-- <![CDATA[
			   document.write(nlvFormatAddress("",
						"<%= UIUtil.toHTML(paymentBillFirstname)%>",
						"<%= UIUtil.toHTML(paymentBillLastname)%>",
						"<%= UIUtil.toHTML(paymentBillAddress1)%>", 
						"<%= UIUtil.toHTML(paymentBillAddress2)%>", 
						"<%= UIUtil.toHTML(paymentBillAddress3)%>", 
						"<%= UIUtil.toHTML(paymentBillCity)%>", 
						"<%= UIUtil.toHTML(paymentBillState)%>", 
						"<%= UIUtil.toHTML(paymentBillCountry)%>", 
						"<%= UIUtil.toHTML(paymentBillZipCode) %>", 
						"<%= UIUtil.toHTML(paymentBillPhone)%>",
						null))
			//[[>-->
			</script>
           </td>
	   </tr>
	
	<%
	   }
	%>
	  </table>
	
	<!-- Order comments information -->
	<br /><br />
	<p><b><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetComments")) %></b></p>
	<br />&nbsp;
	<table>
	<%  if ( (null == currentComments) || (currentComments.length == 0) ) { %>
		<tr><td><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetNoCommentsEntered")) %></td></tr>
	<%  } else {
		for (int i=0;i<currentComments.length;i++) { %>
			<%
			String commentsTime = null;
			String commentText = null;
			try {
				commentsTime = df.format(com.ibm.commerce.base.objects.WCSStringConverter.StringToTimestamp(currentComments[i].getLastupdate().toString()));
				commentText = currentComments[i].getComment();
		 	} catch (Exception ex) {
		 		ECTrace.trace(ECTraceIdentifiers.COMPONENT_STOREOPERATIONS, "OrderSummaryDetailsB2C.jsp", "none", "Exception in OrderSummaryDetails.jsp (Obtain Order comments)");
				ex.printStackTrace();
				commentsTime = null;
				commentText = null;
			}	
			
			if (null != commentsTime && null != commentText) {
			%>
		<tr><td><b>[<%= UIUtil.toHTML((String)commentsTime) %>]</b><br /><i><%= UIUtil.toHTML((String)commentText) %></i></td></tr>
			<% } else { %>	
		<tr></tr>
		<% 	}
		  }
    	} %> 
    </table>	
</body>
</html>


