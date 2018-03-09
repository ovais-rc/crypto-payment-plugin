 <%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.contract.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.ShippingModeDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.AddressDataBean" %>
<%@ page import="com.ibm.commerce.order.beans.OrderPaymentInfoDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.OrgEntityDataBean" %>
<%@ page import="com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean" %>
<%@ page import="com.ibm.commerce.edp.api.EDPPaymentInstruction"%>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.order.calculation.GetOrderLevelParameterCmd" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 


<%@include file="../common/common.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 
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
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
			return "";
		 }	
		return name;

	}

	
	
	public String getOrderLevelMenuAdjustment(OrderDataBean tmpOrderBean, Integer storeId)
	{
	
		BigDecimal origOrderLevelMenuAdjustment = null;
		try {
			GetOrderLevelParameterCmd getAdjustment = (GetOrderLevelParameterCmd) CommandFactory.createCommand(GetOrderLevelParameterCmd.NAME, storeId);
			if (getAdjustment != null) {
				// Get order level menu adjustment
				getAdjustment.setOrder(tmpOrderBean);
				getAdjustment.setOrderItems(tmpOrderBean.getOrderItems());
				getAdjustment.setUsageId(new Integer(-1));
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
	
	

	//retrieve address by given an address id
	public AddressDataBean getAddress(String addressId, HttpServletRequest request) {
		try {
			if (addressId != null && !addressId.equals("")) {
				AddressDataBean address = new AddressDataBean();
				address.setAddressId(addressId);
				//DataBeanManager.activate(address, request);
				address.populate();
			
				return address;
			} else {
				return null;
			}
		} catch (Exception ex) {
			//Exception
			System.out.println("DEBUG: Exception in getAddress()");
			ex.printStackTrace();
			return null;
		}
		
	}




	// retrieve the shipmode description
	public String getShipMode(String shipModeId, Integer storeId, String langId,HttpServletRequest request) {
		
		
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
					if ( paymentTCInfo[i].getPolicyId().equals(policyId) && paymentTCInfo[i].getTCId().equals(TCId) )
						payMethodDescription = paymentTCInfo[i].getLongDescription();
				}
			}

			// if still no description then display unknown
			if (payMethodDescription == null)
				payMethodDescription = (String)tmpOrderLabels.get("orderSummaryDetPaymentUnknown");

		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderSummaryDetails.jsp");	
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
			System.out.println("Exception in OrderSummaryDetails.jsp");	
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
			System.out.println("Exception in OrderSummaryDetails.jsp");	
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
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		}
		
		return ccnumber;
	}
	
	//Get the estimated ship date for the order
	public String getEstimatedShipDate(OrderDataBean tmpOrderBean, Locale loc)
	{
			
		String result = "";
		try {
			result = TimestampHelper.getDateTimeFromTimestamp(tmpOrderBean.getEstimatedShipDate(), loc);
			
		} catch (Exception ex) {
			
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
			System.out.println("Exception in OrderSummaryDetails.jsp");	
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
				if ((null != actualShipDate) && !(actualShipDate.trim().equals("")))
					return true;
			}

		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		
		}
		
		return result;
		

				
		
	}
	
	

	public double getOrderLevelDiscountForDisplay(OrderDataBean tmpOrderBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			discount = tmpOrderBean.getTotalAdjustmentByDisplayLevel(new Integer(1));
		} catch (Exception ex) { }
		if (discount != null)
			displayDiscount = discount.doubleValue() * -1;
		return displayDiscount;
			
	}
	
	public double getOrderItemLevelDiscountForDisplay(OrderItemDataBean tmpOrderItemBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			discount = tmpOrderItemBean.getTotalAdjustmentByDisplayLevel(new Integer(0));
		} catch (Exception ex) { }
		if (discount != null)
			displayDiscount = discount.doubleValue() * -1;
		return displayDiscount;
	}
	
	
	public String getContractName(String contractId, HttpServletRequest request) {
		String contractName = "";
		try {
			if (contractId != null && !contractId.equals("")) {
				com.ibm.commerce.contract.beans.ContractDataBean contractDataBean = new com.ibm.commerce.contract.beans.ContractDataBean();
				contractDataBean.setDataBeanKeyReferenceNumber(contractId); 
				//DataBeanManager.activate(contractDataBean, request);
				contractDataBean.populate();
				contractName = contractDataBean.getName();
			} else {
				contractName = "";
			}
	
		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		
			contractName = "";
		}
		
		return contractName;
			
	}


	public String getLogonID(String memberId, HttpServletRequest request) {
		try {
			UserRegistrationDataBean userRegDataBean = new UserRegistrationDataBean();
			userRegDataBean.setUserId(memberId); 
			//DataBeanManager.activate(userRegDataBean, request);
			userRegDataBean.populate();

			return userRegDataBean.getLogonId();
	
		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();
		
			return "";
		}
			
	}
	

	public String getPONumber(String orderId) {
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
			System.out.println("Exception in OrderSummaryDetails.jsp (getPONumber method)");	
			ex.printStackTrace();
		
			return poNumber;
		}
		return poNumber;
	}
	
	

	
	public String getOrganizationName(OrderDataBean tmpOrderBean, HttpServletRequest request) {
	

		try {
			UserRegistrationDataBean userRegDataBean = new UserRegistrationDataBean();
			String memberId = tmpOrderBean.getMemberId();
			
			
			if ((null != memberId) && !(memberId.trim().equals("")) )
			{
				userRegDataBean.setUserId(memberId); 
				//DataBeanManager.activate(userRegDataBean, request);
				userRegDataBean.populate();

				String orgId = userRegDataBean.getOrganizationId();
						
				if ((orgId != null) && !(orgId.trim().equals("")))
				{
				
					OrgEntityDataBean orgDataBean = new OrgEntityDataBean();
					orgDataBean.setOrgEntityId(orgId);
					//DataBeanManager.activate(orgDataBean, request);
					orgDataBean.populate();
					return orgDataBean.getOrgEntityName();
			
				}
			}	
			
			
			
	
		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderSummaryDetails.jsp");	
			ex.printStackTrace();

			
		}

		
		return "";
			
	}

	public String getOrderGrandTotal(OrderDataBean tmpOrderBean) {
		try {
			return tmpOrderBean.getGrandTotal().getAmount().toString();

		} catch (Exception ex) {
		
			//Exception
			System.out.println("Exception in OrderSummaryDetailsB2B.jsp (getOrderItemSubTotal)");	
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
			System.out.println("Exception in OrderSummaryDetailsB2B.jsp (getOrderItemSubTotal)");	
			ex.printStackTrace();
		
			
		}
	
		return total;
	
	
	
	}

%>


<%
String webalias = UIUtil.getWebPrefix(request);
CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
TypedProperty requestProperty = (TypedProperty) request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);
Locale jLocale = cmdContext.getLocale();
DateFormat df = DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT,jLocale);
Integer storeId = cmdContext.getStoreId();
String langId = cmdContext.getLanguageId().toString();

Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);

Hashtable buyAdminNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", jLocale);

Hashtable contractsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.contractRB", jLocale);

//Obtain the order id
com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderId = URLParameters.getParameter("orderId");


OrderDataBean orderBean = new OrderDataBean ();
OrderItemDataBean[] afirstOrderItems = null;


if ((orderId != null) && !(orderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(orderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	afirstOrderItems = orderBean.getOrderItemDataBeans();
}



Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

if (localeAddrFormat == null) {
	localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
}


%>

<HTML>
  <HEAD>  
    <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
    
    <TITLE><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetDialogTitle").toString()) %></TITLE>   
    <script src="<%=webalias%>javascript/tools/common/Util.js"></script>
    <script src="<%=webalias%>javascript/tools/order/OrderMgmtUtil.js"></script>
    <script src="<%=webalias%>javascript/tools/common/FieldEntryUtil.js"></script>
    <script src="<%=webalias%>javascript/tools/common/Vector.js"></script>


    <script>
      var langId = parent.get("langId");
      var locale = parent.get("locale");
      var currency = "<%= orderBean.getCurrency() %>";
      
      function printAction() {
      	window.print();
      }

      function gotoContractSummary(contractId){
		top.saveModel(parent.model);
		url = top.getWebappPath() + "DialogView?XMLFile=buyerconsole.BuyerContractSummary";
		url += "&contractId=" + contractId;
		top.setContent("<%= (String) contractsRB.get("contractSummaryTitle")%>", url, true); 	  
	  }
 
      
      function nlvFormatAddress(firstName, lastName, address1, address2, address3, city, region, country, postalCode, phoneNumber, emailAddress) {
	
	var newLine = "";
	<%
		for (int i = 2; i < localeAddrFormat.size(); i++) {
		String addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
		String[] addressFields = Util.tokenize(addressLine, ","); 
		for (int j = 0; j < addressFields.length; j++) {
	%>
	
		if ("<%=addressFields[j]%>" == "firstName")
			newLine += firstName;
		if ("<%=addressFields[j]%>" == "lastName")
			newLine += lastName;
		if ("<%=addressFields[j]%>" == "space")
			newLine += " ";
		if ("<%=addressFields[j]%>" == "comma") 
			newLine += ",";
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

      

      
    </SCRIPT>
  </HEAD>
  <BODY CLASS=content ONLOAD="parent.setContentFrameLoaded(true);">        
	<H1><%=UIUtil.toHTML((String)orderLabels.get("orderDetailsTitle")) %></H1>    
	<!-- Order item details information -->
      	<P><B><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderInformation")) %></B>
      	<BR><BR>
      	
      	
      	
      	<TABLE>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderNumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML((String)orderBean.getOrderId()) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLastUpdate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>

			<% 
			
			String orderLastUpdate;			
			if (orderBean.getLastUpdateInEntityType() != null) {
				orderLastUpdate = TimestampHelper.getDateTimeFromTimestamp(orderBean.getLastUpdateInEntityType(), jLocale);
			} else
			 	orderLastUpdate = (String) orderLabels.get("orderSummaryDetNotAvailable");
			%>		           


			<TD><I><%= UIUtil.toHTML((String) orderLastUpdate) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetProductOrderState")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML((String)orderLabels.get(orderBean.getStatus())) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrderOriginatorLogon")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML((String)getLogonID(orderBean.getMemberId(), request)) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetOrganizationName")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
		<%
			String orgName = getOrganizationName(orderBean, request);
			if ((null != orgName) && !(orgName.trim().equals(""))) {		
		%>

			<TD><I><%= UIUtil.toHTML((String)getOrganizationName(orderBean, request)) %></TD>
		<% } else { %>
			
			<TD><I><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetNotAvailable")) %></TD>
		<% } %>
		
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetPONumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
		<%
			String PONum = getPONumber(orderBean.getOrderId());
			
			if ((null != PONum) && !(PONum.trim().equals(""))) {		
		%>
			
			<TD><I><%= UIUtil.toHTML((String) PONum) %></TD>
		<% } else { %>
			
			<TD><I><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetNotAvailable")) %></TD>
		<% } %>
			
			
		</TR>
		
		
	</TABLE>
	<BR>

      	
      	
	<table class="list" width=95% cellpadding=2 cellspacing=1 summary="<%= UIUtil.toHTML(orderMgmtNLS.get("orderInfo").toString()) %>">
		<tr class="list_roles" align="center"> 
			<td class="list_header" id="iNa"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
			<td class="list_header" id="iQu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemQuantity").toString()) %></td>
			<td class="list_header" id="iCt"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetContractName").toString()) %></td>
			<td class="list_header" id="iPr"><%= UIUtil.toHTML(orderMgmtNLS.get("itemPrice").toString()) %></td>
			<td class="list_header" id="iPr"><%= UIUtil.toHTML(orderMgmtNLS.get("orderItemLevelDiscount").toString()) %></td>
			<td class="list_header" id="iTo"><%= UIUtil.toHTML(orderMgmtNLS.get("itemTotal").toString()) %></td>
		</tr>


	<%
		String classId="list_row2";
		for (int i=0; afirstOrderItems != null && i<afirstOrderItems.length && afirstOrderItems[i].getCatalogEntryId().length()!=0; i++) {
	%>
		<TR CLASS=<%= UIUtil.toHTML(classId) %>>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request)) %>
			</TD>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(afirstOrderItems[i].getPartNumber()) %>
			</TD>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(afirstOrderItems[i].getQuantity()) %>
			</TD>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getContractName(afirstOrderItems[i].getContractId(), request)) %>	
			</TD>
			<TD CLASS="list_info1" align="right">
				<SCRIPT>document.writeln(parent.numberToCurrency("<%=afirstOrderItems[i].getPrice()%>", currency, langId))</SCRIPT>
			</TD>
			<TD CLASS="list_info1" align="right">
				<SCRIPT>document.writeln(parent.numberToCurrency("<%=getOrderItemLevelDiscountForDisplay(afirstOrderItems[i])%>", currency, langId))</SCRIPT>
			</TD>	
			<TD CLASS="list_info1" align="right">
				<SCRIPT>document.writeln(parent.numberToCurrency("<%=getOrderItemSubTotal(afirstOrderItems[i])%>", currency, langId))</SCRIPT>
			</TD>	
		</TR>
	<%
			if (classId.equals("list_row2")) classId="list_row1";
			else classId="list_row2";
		}
	%>
	
	</table>
	<BR>
	<table width=95%>
	
		<tr>
	          <td COLSPAN=6 align=right>
		    <table cellpadding=0 cellspacing=0 border=0>      
	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("orderLevelDiscount")) %></td>
				<td align=right width=130>
					<script>
						var orderLevelDiscount = <%= getOrderLevelDiscountForDisplay(orderBean)%>;
						document.writeln(parent.numberToCurrency(orderLevelDiscount, currency, langId));
					</script>
					
	 				
				</td>
			</tr>
			
			
	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("minusAdjustment")) %></td>
				<td align=right width=130>
					<script>
						var orderLevelMenuAdjustment = -1*<%= UIUtil.toJavaScript(getOrderLevelMenuAdjustment(orderBean, storeId)) %>;
						document.writeln(parent.numberToCurrency(orderLevelMenuAdjustment, currency, langId));
					</script>


				</td>
			</tr>
			

	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalShippingCharge")) %></td>
				<td align=right width=130>
					<script>
						var totalShippingCharge = <%= UIUtil.toJavaScript(orderBean.getTotalShippingCharge()) %>;
						document.writeln(parent.numberToCurrency(totalShippingCharge, currency, langId));
					</script>
				
				</td>
			</tr>
	
			
			<tr>
			       	<td></td>
				<td></td>
				<td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalTax")) %></td>
				<td align=right width=130>
					<script>
						var totalTax = <%= UIUtil.toJavaScript(orderBean.getTotalTax()) %>;
						var totalShippingTax = <%= UIUtil.toJavaScript(orderBean.getTotalShippingTax()) %>;
						document.writeln(parent.numberToCurrency(totalTax+totalShippingTax, currency, langId));
					</script>
										
				</td>
			</tr>

		      
	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("grandTotal")) %> &nbsp;[<%= orderBean.getCurrency() %>]</td>
				<td align=right width=130>
					<script>
						var grandTotal = <%= UIUtil.toJavaScript(getOrderGrandTotal(orderBean)) %>;
						document.writeln(parent.numberToCurrency(grandTotal, currency, langId));
					</script>

	 					
				</td>
			</tr>

	              
	              
	              
	              
	            </table>
	          </td>
        	</tr>
        	
        	
	</table>


	<!-- Order item shipping information -->
	<BR><BR>
	<P><B><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetShippingInfo")) %>
	<BR><BR>
	
	
      	<TABLE>
      		
		<% 
			String estimateDate = getEstimatedShipDate(orderBean, jLocale);
			if (!(ifActualShipDateExist(orderBean)) && (estimateDate != null) && !(estimateDate.trim().equals(""))) { %>
			
				<TR>
					<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetEstimatedShipDate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
					<TD><I><%= UIUtil.toHTML((String)estimateDate) %></TD>
				</TR>
			<% } else if (!(ifActualShipDateExist(orderBean))) { %>
				<TR>
					<TD ALIGN=LEFT><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetEstimatedShipDate")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
					<TD><I><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetNotAvailable")) %></TD>
				</TR>
			<% } %>
		
	</TABLE>
	
	<BR>
	<table class="list" width=95% cellpadding=2 cellspacing=1 summary="<%= UIUtil.toHTML(orderMgmtNLS.get("orderInfo").toString()) %>">
		<tr class="list_roles" align="center"> 
			<td class="list_header" id="iNa"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
			<td class="list_header" id="iCt"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetContractName").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetActualShipDate").toString()) %></td>			
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShipmentTrackingId").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingMethod").toString()) %></td>
			<td class="list_header" id="iNu"><%= UIUtil.toHTML(orderLabels.get("orderSummaryDetShippingAddress").toString()) %></td>			
							
		
		</tr>


	<%
		classId="list_row2";
		AddressDataBean shippingAddress = null;
		for (int i=0; afirstOrderItems != null && i<afirstOrderItems.length && afirstOrderItems[i].getCatalogEntryId().length()!=0; i++) {
	%>
		<TR CLASS=<%= UIUtil.toHTML(classId) %>>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request)) %>
			</TD>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(afirstOrderItems[i].getPartNumber()) %>
			</TD>
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getContractName(afirstOrderItems[i].getContractId(), request)) %>
			</TD>

			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getOrderItemActualShipDate(afirstOrderItems[i], jLocale)) %>
			</TD>
			
	
			<TD CLASS="list_info1" align="left">
				
			<%
			String[] trackingIds = null;
			try {
				trackingIds = afirstOrderItems[i].getTrackingIds();
			} catch (Exception ex) {
				//Exception
				System.out.println("Exception in OrderSummaryDetails.jsp (obtain tracking ids)");	
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
					<BR>
			
			<%
					}
				}
			
			
				
			%>
			
			<% } %>
			
			</TD>
					
			
			<TD CLASS="list_info1" align="left">
				<%= UIUtil.toHTML(getShipMode(afirstOrderItems[i].getShippingModeId(), storeId, langId, request)) %>
			</TD>
				
						
			
			<TD CLASS="list_info1" align="left">
			
				<%  
				shippingAddress = getAddress(afirstOrderItems[i].getAddressId(), request);
				if (null != shippingAddress) {
				
				 %>
				 
			<SCRIPT>
				document.write(nlvFormatAddress("<%= UIUtil.toJavaScript(shippingAddress.getFirstName())%>",
								"<%= UIUtil.toJavaScript(shippingAddress.getLastName())%>",
								"<%= UIUtil.toJavaScript(shippingAddress.getAddress1())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getAddress2())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getAddress3())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getCity())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getState())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getCountry())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getZipCode())%>", 
								"<%= UIUtil.toJavaScript(shippingAddress.getPhone1())%>"))
			</SCRIPT>

				 
				 
				 <% } %>
			
			

			</TD>
			
				


		</TR>
	<%
			if (classId.equals("list_row2")) classId="list_row1";
			else classId="list_row2";
		}
	%>
	
		
	
	</table>



	
	<!-- Order billing address information -->
	<BR><BR>
	<P><B><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetBillingAddress")) %>
	<BR>&nbsp;</BR>
	<TABLE>
	
	<TR><TD align="left"><I>
	
	<%
	AddressDataBean billingAddress = null;
	billingAddress = getAddress(orderBean.getAddressId(), request);
	if (null != billingAddress) {
						
	%>
				 
		<SCRIPT>
		document.write(nlvFormatAddress("<%= UIUtil.toJavaScript(billingAddress.getFirstName())%>",
						"<%= UIUtil.toJavaScript(billingAddress.getLastName())%>",
						"<%= UIUtil.toJavaScript(billingAddress.getAddress1())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getAddress2())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getAddress3())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getCity())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getState())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getCountry())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getZipCode())%>", 
						"<%= UIUtil.toJavaScript(billingAddress.getPhone1())%>",
						"<%= UIUtil.toJavaScript(billingAddress.getEmail1())%>"))
		</SCRIPT>

				 
			
			
	<% } else { %>
		<SCRIPT>
		document.write("<%=UIUtil.toJavaScript((String)orderLabels.get("orderSummaryDetNotProvided"))%>");
		</SCRIPT>
	<% } %>
	
	</TD></TR>
	</TABLE>

	<!-- Order payment information -->
	<BR><BR>
	<P><B><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetPaymentInformation")) %>
	<BR>&nbsp;</BR>
    
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
            <td class="list_header" id="po"><%= UIUtil.toHTML(orderMgmtNLS.get("paymentPONumber").toString()) %></td>			
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
		      String poNumber = (String)protocalData.get("purchaseorder_id");
		      if (poNumber==null){
		        poNumber="";
		       }%>
	          <td align="left">    <%=poNumber.toString()%>  </td>
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
						"<%= UIUtil.toJavaScript(paymentBillFirstname)%>",
						"<%= UIUtil.toJavaScript(paymentBillLastname)%>",
						"<%= UIUtil.toJavaScript(paymentBillAddress1)%>", 
						"<%= UIUtil.toJavaScript(paymentBillAddress2)%>", 
						"<%= UIUtil.toJavaScript(paymentBillAddress3)%>", 
						"<%= UIUtil.toJavaScript(paymentBillCity)%>", 
						"<%= UIUtil.toJavaScript(paymentBillState)%>", 
						"<%= UIUtil.toJavaScript(paymentBillCountry)%>", 
						"<%= UIUtil.toJavaScript(paymentBillZipCode) %>", 
						"<%= UIUtil.toJavaScript(paymentBillPhone)%>",
						null))
			//[[>-->
			</script>
           </td>
	          
	   </tr>
	
	<%
	   }
	%>
	  </table>
    

	
  	<!-- Buyer information -->
	<BR><BR>
	<P><B><%= UIUtil.toHTML((String)buyAdminNLS.get("BuyerInformation")) %></B>
	<BR>&nbsp;</BR>
	
	<TABLE>
	<%  String memberId = orderBean.getMemberId();
		UserRegistrationDataBean userRegDataBean = new UserRegistrationDataBean();
		userRegDataBean.setUserId(memberId); 
		//DataBeanManager.activate(userRegDataBean, request);
		userRegDataBean.populate();
		String buyerLastName = userRegDataBean.getLastName();
		buyerLastName = (buyerLastName == null) ? "" : buyerLastName; 
		String buyerFirstName = userRegDataBean.getFirstName();
		buyerFirstName = (buyerFirstName == null) ? "" : buyerFirstName; 
		String buyerMiddleName = userRegDataBean.getMiddleName();
		buyerMiddleName = (buyerMiddleName == null) ? "" : buyerMiddleName; 

		String buyerPhone = userRegDataBean.getPhone1();
		if ((null == buyerPhone) || (buyerPhone.trim().equals(""))) {
			buyerPhone = (String)orderLabels.get("orderSummaryDetNotAvailable");
		}

		String buyerEmail = userRegDataBean.getEmail1();
		if ((null == buyerEmail) || (buyerEmail.trim().equals(""))) {
			buyerEmail = (String)orderLabels.get("orderSummaryDetNotAvailable");
		}

		String buyerEmployeeId = userRegDataBean.getEmployeeId();
		if ((null == buyerEmployeeId) || (buyerEmployeeId.trim().equals(""))) {
			buyerEmployeeId = (String)orderLabels.get("orderSummaryDetNotAvailable");
		}
	
		if (jLocale.toString().equals("ja_JP")||jLocale.toString().equals("ko_KR")
			||jLocale.toString().equals("zh_CN")||jLocale.toString().equals("zh_TW")) { 
	%>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralLastName")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerLastName) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralInitial")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerMiddleName) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralFirstName")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerFirstName) %></TD>
		</TR>

	<% } else { %>

		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralFirstName")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerFirstName) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralInitial")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerMiddleName) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("userGeneralLastName")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerLastName) %></TD>
		</TR>

	<%	} %>


		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("buyerPhone")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerPhone) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("buyerEmail")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerEmail) %></TD>
		</TR>
		<TR>
			<TD ALIGN=LEFT><%= UIUtil.toHTML((String)buyAdminNLS.get("buyerEmployeeId")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></TD>
			<TD><I><%= UIUtil.toHTML(buyerEmployeeId) %></TD>
		</TR>

    	</TABLE>	
		<BR>

    	

	
		
   
  </BODY>
</HTML>


