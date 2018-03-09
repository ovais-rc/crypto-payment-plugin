<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006, 2016
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%><%--
//*---------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been  
//* thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its 
//* reliability, serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands 
//* and products in order to illustrate concepts as completely as 
//* possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by 
//* actual persons 
//* or business enterprises is entirely coincidental.
//*---------------------------------------------------------------------
//*
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 041029           Xia       Initial Create
////////////////////////////////////////////////////////////////////////////////
--%><%@ include file="OrderNotificationHelper.jspf" 
%><%! 
public String getFormattedName(Hashtable addressInfo, Hashtable localeAddrFormat) {
	StringBuffer nameLine = new StringBuffer();

	try {
		String nameFormat = (String) XMLUtil.get(localeAddrFormat, "line1.elements");
		// name format
		String[] nameFields = Util.tokenize(nameFormat, ",");
		for (int j = 0; j < nameFields.length; j++) {
			if (nameFields[j].equals("space")) {
				nameLine.append(" ");
			} else if (nameFields[j].equals("comma")) {
				nameLine.append(",");
			} else if (nameFields[j].equals("title")) {
				nameLine.append((String) addressInfo.get("title"));
			} else if (nameFields[j].equals("firstName")) {
				nameLine.append((String) addressInfo.get("firstName"));
			} else if (nameFields[j].equals("lastName")) {
				nameLine.append((String) addressInfo.get("lastName"));
			} else if (nameFields[j].equals("middleName")) {
				nameLine.append((String) addressInfo.get("middleName"));
			}
		}
	} catch (Exception ex) {
		return nameLine.toString();
	}

	return nameLine.toString().trim();
}

public String getFormattedAddress(int lineNumber, Hashtable addressInfo, Hashtable localeAddrFormat) {
	String result = "";
	StringBuffer addrLine = new StringBuffer();

	try {
		StringBuffer aStrBuffer = new StringBuffer();
		aStrBuffer.append("line");
		aStrBuffer.append(lineNumber);
		aStrBuffer.append(".elements");
		String addrFormat = (String) XMLUtil.get(localeAddrFormat, aStrBuffer.toString());
		String[] addressFields = Util.tokenize(addrFormat, ",");
		for (int j = 0; j < addressFields.length; j++) {
			if (addressFields[j].equals("space")) {
				addrLine.append(" ");
			} else if (addressFields[j].equals("comma")) {
				if (!addrLine.toString().trim().equals("") && !addrLine.toString().trim().endsWith(",")) {
					addrLine.append(",");
				}
			} else if (addressFields[j].equals("address1")) {
				addrLine.append((String) addressInfo.get("address1"));
			} else if (addressFields[j].equals("address2")) {
				addrLine.append((String) addressInfo.get("address2"));
			} else if (addressFields[j].equals("address3")) {
				addrLine.append((String) addressInfo.get("address3"));
			} else if (addressFields[j].equals("city")) {
				addrLine.append((String) addressInfo.get("city"));
			} else if (addressFields[j].equals("region")) {
				addrLine.append((String) addressInfo.get("state"));
			} else if (addressFields[j].equals("country")) {
				addrLine.append((String) addressInfo.get("country"));
			} else if (addressFields[j].equals("postalCode")) {
				addrLine.append((String) addressInfo.get("zipCode"));
			}
		}

		result = addrLine.toString().trim();
		if (result.endsWith(",")) {
			result = result.substring(0, result.length() - 1);

		}
	} catch (Exception ex) {
		return addrLine.toString();
	}

	return result;
}

public Hashtable getAddressInfo(String addressId, HttpServletRequest request, HttpServletResponse response) {
	Hashtable addressInfo = new Hashtable();

	try {
		AddressDataBean address = new AddressDataBean();
		address.setAddressId(addressId);
		DataBeanManager.activate(address, request, response);

		// put customer name into addressInfo hashtable
		if (address.getPersonTitle() != null) {
			addressInfo.put("title", address.getPersonTitle());
		} else {
			addressInfo.put("title", "");
		}
		if (address.getFirstName() != null) {
			addressInfo.put("firstName", address.getFirstName());
		} else {
			addressInfo.put("firstName", "");
		}
		if (address.getMiddleName() != null) {
			addressInfo.put("middleName", address.getMiddleName());
		} else {
			addressInfo.put("middleName", "");
		}
		if (address.getLastName() != null) {
			addressInfo.put("lastName", address.getLastName());
		} else {
			addressInfo.put("lastName", "");
		}

		// put customer address into addressInfo hashtable
		if (address.getAddress1() != null) {
			addressInfo.put("address1", address.getAddress1());
		} else {
			addressInfo.put("address1", "");
		}
		if (address.getAddress2() != null) {
			addressInfo.put("address2", address.getAddress2());
		} else {
			addressInfo.put("address2", "");
		}
		if (address.getAddress3() != null) {
			addressInfo.put("address3", address.getAddress3());
		} else {
			addressInfo.put("address3", "");
		}
		if (address.getCity() != null) {
			addressInfo.put("city", address.getCity());
		} else {
			addressInfo.put("city", "");
		}
		if (address.getState() != null) {
			addressInfo.put("state", address.getState());
		} else {
			addressInfo.put("state", "");
		}
		if (address.getZipCode() != null) {
			addressInfo.put("zipCode", address.getZipCode());
		} else {
			addressInfo.put("zipCode", "");
		}
		if (address.getCountry() != null) {
			addressInfo.put("country", address.getCountry());
		} else {
			addressInfo.put("country", "");
		}

	} catch (Exception ex) {
		return addressInfo;
	}
	return addressInfo;
}

public Hashtable getAddressInfo(HashMap protocolData) {
	Hashtable addressInfo = new Hashtable();

	try {
		// put customer name into addressInfo hashtable
		String paymentBillPhone = (String) protocolData.get("billto_phone_number");
		if (paymentBillPhone == null) {
			paymentBillPhone = "";
		}
		addressInfo.put("phone", paymentBillPhone);
		String paymentBillTitle = (String) protocolData.get("billto_title");
		if (paymentBillTitle == null) {
			paymentBillTitle = "";
		}
		addressInfo.put("title", paymentBillTitle);

		String paymentBillFirstname = (String) protocolData.get("billto_firstname");
		if (paymentBillFirstname == null) {
			paymentBillFirstname = "";
		}
		addressInfo.put("firstName", paymentBillFirstname);

		String paymentBilMiddlename = (String) protocolData.get("billto_middlename");
		if (paymentBilMiddlename == null) {
			paymentBilMiddlename = "";
		}
		addressInfo.put("middleName", paymentBilMiddlename);
		String paymentBillLastname = (String) protocolData.get("billto_lastname");
		if (paymentBillLastname == null) {
			paymentBillLastname = "";
		}
		addressInfo.put("lastName", paymentBillLastname);

		String paymentBillAddress1 = (String) protocolData.get("billto_address1");
		if (paymentBillAddress1 == null) {
			paymentBillAddress1 = "";
		}
		addressInfo.put("address1", paymentBillAddress1);

		String paymentBillAddress2 = (String) protocolData.get("billto_address2");
		if (paymentBillAddress2 == null) {
			paymentBillAddress2 = "";
		}
		addressInfo.put("address2", paymentBillAddress2);

		String paymentBillAddress3 = (String) protocolData.get("billto_address3");
		if (paymentBillAddress3 == null) {
			paymentBillAddress3 = "";
		}

		addressInfo.put("address3", paymentBillAddress3);

		String paymentBillCity = (String) protocolData.get("billto_city");
		if (paymentBillCity == null) {
			paymentBillCity = "";
		}
		addressInfo.put("city", paymentBillCity);
		String paymentBillState = (String) protocolData.get("billto_stateprovince");
		if (paymentBillState == null) {
			paymentBillState = "";
		}

		addressInfo.put("state", paymentBillState);

		String paymentBillZipCode = (String) protocolData.get("billto_zipcode");
		if (paymentBillZipCode == null) {
			paymentBillZipCode = "";
		}
		addressInfo.put("zipCode", paymentBillZipCode);
		String paymentBillCountry = (String) protocolData.get("billto_country");
		if (paymentBillCountry == null) {
			paymentBillCountry = "";
		}
		addressInfo.put("country", paymentBillCountry);

	} catch (Exception ex) {
		return addressInfo;
	}
	return addressInfo;
}

// Method to get catalog entry name for an order item
public String getOrderItemName(String catalogEntryId, HttpServletRequest request, HttpServletResponse response) {
	String name;

	try {
		CatalogEntryDataBean aCatalogEntry = new CatalogEntryDataBean();
		aCatalogEntry.setCatalogEntryID(catalogEntryId);

		com.ibm.commerce.beans.DataBeanManager.activate(aCatalogEntry, request, response);

		// The databean did not expose the name method	
		name = aCatalogEntry.getDescription().getName();
		if (name == null) {
			return "";
		}
	} catch (Exception ex) {
		return "";
	}
	return name;

}
public String getFormattedQuantity(double quantity, Locale locale) {
	java.text.NumberFormat numberFormat = java.text.NumberFormat.getNumberInstance(locale);
	return numberFormat.format(quantity);
}
public String getShipMode(String shipModeId, String langId, HttpServletRequest request, HttpServletResponse response) {

	try {

		if (shipModeId != null && !shipModeId.equals("")) {
			ShippingModeDataBean shipMode = new ShippingModeDataBean();
			shipMode.setInitKey_shippingModeId(shipModeId);
			DataBeanManager.activate(shipMode, request, response);

			return shipMode
				.getDescription(new Integer(langId), new Integer(shipMode.getShippingModeId()))
				.getDescription();
		} else {
			return "";
		}

	} catch (Exception ex) {
		return "";
	}

}
//Get the request ship date for the order item
public String formatTimestamp(Timestamp timestamp, Locale loc) {

	String result = "";
	try {
		result = TimestampHelper.getDateFromTimestamp(timestamp, loc);
	} catch (Exception ex) {
		result = "";
	}
	return result;
}

public String formatAmount(FormattedMonetaryAmountDataBean formatDB) {
	String result = "";
	try {
		if (formatDB != null) {
			formatDB.setNumberUsage(NumberUsageConstants.COMMERCE_TEXT);
			result = formatDB.toString();
		}
	} catch (Exception ex) {
		result = "";
	}
	return result;
}
%><%!
// TextAlign numbers
private static final int HEADING_SIDE = 50;
private static final int NUMBER_SIDE = 20;
private static final String ENCODING = "UTF-8";
%><%
try {

	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	GlobalizationContext globalCtx =
		(GlobalizationContext) commandContext.getContext(GlobalizationContext.CONTEXT_NAME);
	Locale jLocale = globalCtx.getLocale();
	StoreAccessBean storeAB = commandContext.getStore();
	JSPHelper jhelper = new JSPHelper(request);
	String orderId = jhelper.getParameter("orderId");
	OrderDataBean orderDB = new OrderDataBean();
	OrderItemDataBean[] afirstOrderItems = null;
	OrderSummaryDataBean orderSummaryDB = new OrderSummaryDataBean();

	if ((orderId != null) && !(orderId.equals(""))) {
		orderDB.setSecurityCheck(false);
		orderDB.setOrderId(orderId);
		DataBeanManager.activate(orderDB, request, response);
		afirstOrderItems = orderDB.getOrderItemDataBeans();
		orderSummaryDB.setOrderId(orderId);
		DataBeanManager.activate(orderSummaryDB, request, response);
	}

	StringBuffer addressStrBuffer = null;
	addressStrBuffer = new StringBuffer();
	addressStrBuffer.append("addressFormats.");
	addressStrBuffer.append(jLocale.toString());
	Hashtable addrFormats = (Hashtable) ResourceDirectory.lookup("order.addressFormats");
	Hashtable localeAddrFormat = (Hashtable) XMLUtil.get(addrFormats, addressStrBuffer.toString());

	if (localeAddrFormat == null) {
		localeAddrFormat = (Hashtable) XMLUtil.get(addrFormats, "addressFormats.default");
	}

	ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", jLocale);
	Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
	StoreEntityDescriptionAccessBean storeEntDescAB = storeAB.getDescription(new Integer(storeAB.getLanguageId()));
	StoreAddressDataBean storeAddressDB = new StoreAddressDataBean();
	storeAddressDB.setDataBeanKeyStoreAddressId(storeEntDescAB.getContactAddressId());
	DataBeanManager.activate(storeAddressDB, request, response);

	//Print the email head message in the mail body
	StringBuffer someText = new StringBuffer();
	String message = orderNotificationRB.getString("OrderChangedNotificationHeaderMsg1");
	Object[] params = { storeEntDescAB.getDisplayName()};
	someText.append(MessageFormat.format(message, params));
	someText.append(System.getProperty("line.separator"));
	someText.append(System.getProperty("line.separator"));
	message = orderNotificationRB.getString("OrderChangedNotificationHeaderMsg2");
	StringBuffer messageBuffer = new StringBuffer();
	params[0] = orderId;
	messageBuffer.append(MessageFormat.format(message, params));
	someText.append(messageBuffer.toString());
	out.println(orderNotificationRB.getString("delimeter"));
	out.println(someText.toString());
	out.println("");

	String storeName = storeEntDescAB.getDisplayName();
	String storeDescription = storeEntDescAB.getDescription();
	if (storeName != null) {
		out.println(storeName);
	}
	if (storeDescription != null) {
		out.println(storeDescription);
	}
	if (storeAddressDB.getEmail1() != null) {
		out.print(orderNotificationRB.getString("OrderChangedNotificationEmail"));
		out.print(" ");
		out.println(storeAddressDB.getEmail1());
	}
	if (storeAddressDB.getPhone1() != null) {
		out.print(orderNotificationRB.getString("OrderChangedNotificationPhone"));
		out.print(" ");
		out.println(storeAddressDB.getPhone1());
	}

	out.println(orderNotificationRB.getString("delimeter"));
	//Start to show order summary
	out.println("");
	out.println(orderNotificationRB.getString("OrderChangedNotificationOrderInfo"));

	for (int i = 0;
		afirstOrderItems != null
			&& i < afirstOrderItems.length
			&& afirstOrderItems[i].getCatalogEntryId().length() != 0;
		i++) {
		out.println(orderNotificationRB.getString("shortDelimeter"));
		out.println("");
		out.println(orderNotificationRB.getString("OrderChangedNotificationShippingRecipient"));
		out.println("");
		if (afirstOrderItems[i].getAddressId() != null && !(afirstOrderItems[i].getAddressId().equals(""))) {
			Hashtable addressInfo = getAddressInfo(afirstOrderItems[i].getAddressId(), request, response);
			out.print("          ");
			out.println(getFormattedName(addressInfo, localeAddrFormat));
			out.print("          ");
			out.println(getFormattedAddress(2, addressInfo, localeAddrFormat));
			out.print("          ");
			out.println(getFormattedAddress(3, addressInfo, localeAddrFormat));
			out.print("          ");
			out.println(getFormattedAddress(4, addressInfo, localeAddrFormat));
			out.print(" ");
		}
		out.println("");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProducts"));
		out.println("");
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductName"));
		out.print(" ");
		out.println(UIUtil.toHTML(getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request, response)));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductSKU"));
		out.print(" ");
		out.println(UIUtil.toHTML(afirstOrderItems[i].getPartNumber()));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductQuantity"));
		out.print(" ");
		out.println(getFormattedQuantity(afirstOrderItems[i].getQuantityInEntityType().doubleValue(), jLocale));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationShipVia"));
		out.print(" ");
		out.println(
			UIUtil.toHTML(
				getShipMode(afirstOrderItems[i].getShippingModeId(), storeAB.getLanguageId(), request, response)));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductExpedite"));
		out.print(" ");
		out.println(afirstOrderItems[i].getIsExpedited());
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductRequestedShipDate"));
		out.print(" ");
		out.println(UIUtil.toHTML(formatTimestamp(afirstOrderItems[i].getRequestedShipDate(), jLocale)));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductShipDate"));
		out.print(" ");
		out.println(UIUtil.toHTML(formatTimestamp(afirstOrderItems[i].getTimeShippedInEntityType(), jLocale)));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductPrice"));
		out.print(" ");
		out.println(
			UIUtil.toHTML(
				formatAmount(
					afirstOrderItems[i].getPriceInEntityType(),
					orderDB.getCurrency(),
					storeAB,
					storeAB.getLanguageIdInEntityType())));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductDiscount"));
		out.print(" ");
		BigDecimal totalAdjust = afirstOrderItems[i].getTotalAdjustmentByDisplayLevel(new Integer(0));
		if (totalAdjust == null) {
			totalAdjust = new java.math.BigDecimal(0);
		} else {
			totalAdjust = totalAdjust.negate();
		}
		out.println(
			UIUtil.toHTML(formatAmount(totalAdjust, orderDB.getCurrency(), storeAB, storeAB.getLanguageIdInEntityType())));
		out.print("          ");
		out.print(orderNotificationRB.getString("OrderChangedNotificationProductTotal"));
		out.print(" ");

		BigDecimal total = afirstOrderItems[i].getFormattedTotalProduct().getAmount();
		if (total == null) {
			total = new java.math.BigDecimal(0);
		}

		totalAdjust = afirstOrderItems[i].getTotalAdjustmentByDisplayLevel(new Integer(1));
		if (totalAdjust == null) {
			totalAdjust = new java.math.BigDecimal(0);
		}
		totalAdjust = totalAdjust.negate();

		total = total.add(totalAdjust);

		out.println(
			UIUtil.toHTML(formatAmount(total, orderDB.getCurrency(), storeAB, storeAB.getLanguageIdInEntityType())));
		out.println("");
	}
	out.println(orderNotificationRB.getString("shortDelimeter"));
	out.println("");

	out.println(orderNotificationRB.getString("delimeter"));

	//display order totals
	out.println("");
	out.println(orderNotificationRB.getString("OrderChangedNotificationOrderInformation"));
	out.println("");
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationOrderDiscount"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(
				formatAmount(orderDB.getFormattedTotalDiscountAdjustment()),
				NUMBER_SIDE,
				ENCODING));
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationSurcharge"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(
				formatAmount(orderDB.getFormattedTotalSurchargeAdjustment()),
				NUMBER_SIDE,
				ENCODING));
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationShipping"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(formatAmount(orderDB.getFormattedTotalShippingCharge()), NUMBER_SIDE, ENCODING));
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationShippingTax"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(formatAmount(orderDB.getFormattedTotalShippingTax()), NUMBER_SIDE, ENCODING));
	out.println(
		TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderChangedNotificationTax"), HEADING_SIDE, ENCODING)
			+ TextAlignHelper.rightAlign(formatAmount(orderDB.getFormattedTotalTax()), NUMBER_SIDE, ENCODING));
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationOrderTotal"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(formatAmount(orderDB.getGrandTotal()), NUMBER_SIDE, ENCODING));
	out.println(
		TextAlignHelper.leftAlign(
			orderNotificationRB.getString("OrderChangedNotificationCurrency"),
			HEADING_SIDE,
			ENCODING)
			+ TextAlignHelper.rightAlign(orderDB.getCurrency(), NUMBER_SIDE, ENCODING));
	if (orderSummaryDB.getCouponDisplayList() != null && orderSummaryDB.getCouponDisplayList().trim().length() > 0) {

		out.println(
			TextAlignHelper.leftAlign(
				orderNotificationRB.getString("OrderChangedNotificationCoupon"),
				HEADING_SIDE,
				ENCODING)
				+ TextAlignHelper.rightAlign(orderSummaryDB.getCouponDisplayList(), NUMBER_SIDE, ENCODING));
	}
	out.println("");
	out.println(orderNotificationRB.getString("delimeter"));
	out.println("");

	//Display payment instructions
	out.println(orderNotificationRB.getString("OrderChangedNotificationPaymentInfo"));
	out.println("");
	out.print(orderNotificationRB.getString("OrderChangedNotificationPaymentStatus"));
	out.print(" ");
	String paymentStatus = (String) getCOPaymentStatus(orderLabels, request, response, orderId);
	out.println(UIUtil.toHTML(paymentStatus));
	//Display PIs

	EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
	edpPIDataBean.setOrderId(new Long(orderId));
	com.ibm.commerce.beans.DataBeanManager.activate(edpPIDataBean, request, response);
	ArrayList pis = edpPIDataBean.getPaymentInstructions();
	Iterator iteForPI = pis.iterator();

	while (iteForPI.hasNext()) {
		out.println(orderNotificationRB.getString("shortDelimeter"));
		out.println("");
		EDPPaymentInstruction aPI = (EDPPaymentInstruction) iteForPI.next();
		HashMap protocolData = aPI.getProtocolData();
		out.print(orderNotificationRB.getString("OrderChangedNotificationPaymentMethod"));
		out.print(" ");
		out.println(aPI.getPaymentMethod());
		out.print(orderNotificationRB.getString("OrderChangedNotificationPaymentAmount"));
		out.print(" ");
		out.println(formatAmount(aPI.getAmount(), orderDB.getCurrency(), storeAB, storeAB.getLanguageIdInEntityType()));
		String accountNumber = (String) protocolData.get("account");
		if (accountNumber == null) {
			accountNumber = "";
		}
		out.print(orderNotificationRB.getString("OrderChangedNotificationPaymentAccount"));
		out.print(" ");
		out.println(accountNumber);
		out.print(orderNotificationRB.getString("OrderChangedNotificationPaymentBillAddress"));
		out.print(" ");
		Hashtable addressInfo3 = getAddressInfo(protocolData);
		out.println(getFormattedName(addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(2, addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(3, addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(4, addressInfo3, localeAddrFormat));
	}
	out.println(orderNotificationRB.getString("shortDelimeter"));
	out.println("");

} catch (Exception e) {
	out.println(e);
}
%>
