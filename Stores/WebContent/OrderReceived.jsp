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
// 020723           KNG              Initial Create
//
// 020815           KNG              Make changes from code review
////////////////////////////////////////////////////////////////////////////////
--%><%@ include file="OrderNotificationHelper.jspf" 
%><%!
public String getFormattedName(Hashtable addressInfo, Hashtable localeAddrFormat) 
{
    StringBuffer nameLine = new StringBuffer();
    
    try 
    {
        String nameFormat = (String)XMLUtil.get(localeAddrFormat, "line1.elements"); // name format
        String[] nameFields = Util.tokenize(nameFormat, ",");
        for (int j=0; j<nameFields.length; j++) 
        {
            if (nameFields[j].equals("space")) {
                nameLine.append(" "); 
            } else if (nameFields[j].equals("comma")) {
                nameLine.append(","); 
            } else if (nameFields[j].equals("title")) {
                nameLine.append((String)addressInfo.get("title")); 
            } else if (nameFields[j].equals("firstName")) {
                nameLine.append((String)addressInfo.get("firstName")); 
            } else if (nameFields[j].equals("lastName")) {
                nameLine.append((String)addressInfo.get("lastName"));
            } else if (nameFields[j].equals("middleName")) {
                nameLine.append((String)addressInfo.get("middleName"));
            }
        }
    } catch (Exception ex) {
    	return nameLine.toString();
    }

    return nameLine.toString().trim();
}

public String getFormattedAddress(int lineNumber, Hashtable addressInfo, Hashtable localeAddrFormat) 
{
    String result = "";
    StringBuffer addrLine = new StringBuffer();
    
    try 
    {
    	StringBuffer aStrBuffer = new StringBuffer();
    	aStrBuffer.append("line");
    	aStrBuffer.append(lineNumber);
    	aStrBuffer.append(".elements");
        String addrFormat = (String)XMLUtil.get(localeAddrFormat, aStrBuffer.toString());
        String[] addressFields = Util.tokenize(addrFormat, ",");
        for (int j=0; j<addressFields.length; j++) 
        {
            if (addressFields[j].equals("space")) {
                addrLine.append(" "); 
            } else if (addressFields[j].equals("comma")) {
            	if (!addrLine.toString().trim().equals("") && !addrLine.toString().trim().endsWith(",")) {
                	addrLine.append(",");
                }
            } else if (addressFields[j].equals("address1")) {
                addrLine.append((String)addressInfo.get("address1")); 
            } else if (addressFields[j].equals("address2")) {
                addrLine.append((String)addressInfo.get("address2")); 
            } else if (addressFields[j].equals("address3")) {
                addrLine.append((String)addressInfo.get("address3")); 
            } else if (addressFields[j].equals("city")) {
                addrLine.append((String)addressInfo.get("city"));
            } else if (addressFields[j].equals("region")) {
                addrLine.append((String)addressInfo.get("state")); 
            } else if (addressFields[j].equals("country")) {
                addrLine.append((String)addressInfo.get("country")); 
            } else if (addressFields[j].equals("postalCode")) {
                addrLine.append((String)addressInfo.get("zipCode")); 
            }
        }
        
        result = addrLine.toString().trim();
        if (result.endsWith(",")) {
        	result = result.substring(0, result.length()-1);
        
        }
    } catch (Exception ex) {
    	return addrLine.toString();
    }

    return result;
}

public Hashtable getAddressInfo(String addressId, HttpServletRequest request) {
	Hashtable addressInfo = new Hashtable();    

	try {
	AddressDataBean address = new AddressDataBean();
	address.setAddressId(addressId);
	DataBeanManager.activate(address, request);

	// put customer name into addressInfo hashtable
	if( address.getPersonTitle() != null ) {
        	addressInfo.put("title", address.getPersonTitle());
	} else {
		addressInfo.put("title", "" );
	}
	if( address.getFirstName() != null ) {
		addressInfo.put("firstName", address.getFirstName());
	} else {
		addressInfo.put("firstName", "");
	}
	if( address.getMiddleName() != null ) {
		addressInfo.put("middleName", address.getMiddleName());
	} else {
		addressInfo.put("middleName", "");
	}
	if( address.getLastName() != null ) {
		addressInfo.put("lastName", address.getLastName());
	} else {
		addressInfo.put("lastName", "");
	}
    
	// put customer address into addressInfo hashtable
	if( address.getAddress1() != null ) {
		addressInfo.put("address1", address.getAddress1());
	} else {
		addressInfo.put("address1", "");
	}
	if( address.getAddress2() != null ) {
		addressInfo.put("address2", address.getAddress2());
	} else {
		addressInfo.put("address2", "");
	}
	if( address.getAddress3() != null ) {
		addressInfo.put("address3", address.getAddress3());
	} else {
		addressInfo.put("address3", "");
	}
	if( address.getCity() != null ) {
		addressInfo.put("city", address.getCity());
	} else {
		addressInfo.put("city", "");
	}
	if( address.getState() != null ) {
		addressInfo.put("state", address.getState());
	} else {
		addressInfo.put("state", "");
	}
	if( address.getZipCode() != null ) {
		addressInfo.put("zipCode", address.getZipCode());
	} else {
		addressInfo.put("zipCode", "");
	}
	if( address.getCountry() != null ) {
		addressInfo.put("country", address.getCountry());
	} else {
		addressInfo.put("country", "");
	}
	
	} catch (Exception ex) {
		return addressInfo;
	}
	return addressInfo;
}

%><%!
	// TextAlign numbers
	private static final int HEADING_SIDE = 50;
	private static final int NUMBER_SIDE = 20;
	private static final String ENCODING = "UTF-8";
%><%
try{

	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = commandContext.getLocale();
	StoreAccessBean storeAB = commandContext.getStore();
	JSPHelper jhelper = new JSPHelper(request);
	String orderId = jhelper.getParameter("orderId");
	OrderSummaryDataBean orderSummaryDB = new OrderSummaryDataBean();
	if ((orderId != null) && !(orderId.equals(""))) {
		orderSummaryDB.setOrderId(orderId);
		DataBeanManager.activate(orderSummaryDB, request);
	}

	StringBuffer addressStrBuffer = null;
	addressStrBuffer = new StringBuffer();
	addressStrBuffer.append("addressFormats.");
	addressStrBuffer.append(jLocale.toString());
	Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
	Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, addressStrBuffer.toString());
    
	if (localeAddrFormat == null) {
		localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
	}
	
	ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", jLocale );
	StoreEntityDescriptionAccessBean storeEntDescAB = storeAB.getDescription(new Integer(storeAB.getLanguageId()));
	StoreAddressDataBean storeAddressDB = new StoreAddressDataBean();
	storeAddressDB.setDataBeanKeyStoreAddressId(storeEntDescAB.getContactAddressId());
	com.ibm.commerce.beans.DataBeanManager.activate(storeAddressDB, request);
	StringBuffer someText = new StringBuffer();
	String message = orderNotificationRB.getString("orderReceivedHeaderMsg1");
	int index = message.indexOf("%1");
	someText.append(message.substring(0,index));
	someText.append(storeEntDescAB.getDisplayName());
	someText.append(message.substring(index+2));
	someText.append(System.getProperty("line.separator"));
	someText.append(System.getProperty("line.separator"));	
	message = orderNotificationRB.getString("orderReceivedHeaderMsg2");
	StringBuffer messageBuffer = new StringBuffer();
	index = message.indexOf("%1");
	messageBuffer.append(message.substring(0,index));
	messageBuffer.append(orderId);
	messageBuffer.append(message.substring(index+2));
	someText.append(messageBuffer.toString());
	out.println( orderNotificationRB.getString("delimeter") );
	out.println( someText.toString() );
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
		out.print( orderNotificationRB.getString("orderReceivedEmail") );
		out.print(" ");
		out.println( storeAddressDB.getEmail1() );
	}
	if (storeAddressDB.getPhone1() != null) {
		out.print( orderNotificationRB.getString("orderReceivedPhone") );
		out.print(" ");
		out.println( storeAddressDB.getPhone1() );
	}
	
	out.println( orderNotificationRB.getString("delimeter") );
	out.println( orderNotificationRB.getString("orderReceivedShippingInfo") );
	out.println("");
	String[] distinctShipAddressId = null;
	distinctShipAddressId = orderSummaryDB.getOrderItemDistinctShippingAddressIds();
	if (distinctShipAddressId != null) {
		for (int i=0; i<distinctShipAddressId.length; i++) {
			out.println( orderNotificationRB.getString("orderReceivedShippingRecipient") );
			Hashtable addressInfo = getAddressInfo(distinctShipAddressId[i].toString(), request);
			out.println( getFormattedName(addressInfo, localeAddrFormat) );
			out.println( getFormattedAddress(2, addressInfo, localeAddrFormat) );
			out.println( getFormattedAddress(3, addressInfo, localeAddrFormat) );
			out.println( getFormattedAddress(4, addressInfo, localeAddrFormat) );
    			out.println("");

			Integer[] indexes = orderSummaryDB.getOrderItemIndex(distinctShipAddressId[i].toString());
			if (indexes != null) {
				for (int k=0; k<indexes.length; k++) {
					int index2 = indexes[k].intValue();
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductName"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemName(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductSKU"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemSKU(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductQuantity"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemQuantity(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationShipVia"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemShippingMethod(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductPrice"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemPrice(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductDiscount"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemLevelDiscountForDisplay(index2));
					out.print(orderNotificationRB.getString("MerchantOrderNotificationProductTotal"));
					out.print(" ");
					out.println(orderSummaryDB.getOrderItemSubTotal(index2));
					out.println("");
				}
			}
		}
	}

	// display the products without a shipping address
	Integer[] indexes2 = orderSummaryDB.getOrderItemIndexWithNoShipAddress();
	if (indexes2 != null) {
		out.println( orderNotificationRB.getString("orderReceivedShippingRecipient") );
		out.println( orderNotificationRB.getString("orderReceivedShippingNA") );
    		out.println("");

		for (int k=0; k<indexes2.length; k++) {
			int index2 = indexes2[k].intValue();
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductName"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemName(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductSKU"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemSKU(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductQuantity"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemQuantity(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationShipVia"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemShippingMethod(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductPrice"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemPrice(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductDiscount"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemLevelDiscountForDisplay(index2));
			out.print(orderNotificationRB.getString("MerchantOrderNotificationProductTotal"));
			out.print(" ");
			out.println(orderSummaryDB.getOrderItemSubTotal(index2));
			out.println("");
		}
	}	
	out.print(orderNotificationRB.getString("separator"));
	out.println(orderNotificationRB.getString("separator"));
	
	//display order totals
	out.println("");
	out.println( orderNotificationRB.getString("orderReceivedOrderInformation") );
	out.println("");
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedOrderDiscount"), HEADING_SIDE, ENCODING)	+ TextAlignHelper.rightAlign(orderSummaryDB.getOrderLevelDiscountForDisplay(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedMinusAdjustment"), HEADING_SIDE, ENCODING)	+ TextAlignHelper.rightAlign(orderSummaryDB.getOrderLevelMinusAdjustment(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedShipping"), HEADING_SIDE, ENCODING)		+ TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalShippingCharges(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedShippingTax"), HEADING_SIDE, ENCODING)	+ TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalShippingTax(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedTax"), HEADING_SIDE, ENCODING)		+ TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalTax(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedOrderTotal"), HEADING_SIDE, ENCODING)	+ TextAlignHelper.rightAlign(orderSummaryDB.getOrderGrandTotal(), NUMBER_SIDE, ENCODING) );
	out.println( TextAlignHelper.leftAlign(orderNotificationRB.getString("orderReceivedCurrency"), HEADING_SIDE, ENCODING)		+ TextAlignHelper.rightAlign(orderSummaryDB.getOrderCurrency(), NUMBER_SIDE, ENCODING) );
	out.println("");
	out.print( orderNotificationRB.getString("separator") );
	out.println( orderNotificationRB.getString("separator") );

	//Display payment information and status
	out.println(orderNotificationRB.getString("orderReceivedPaymentInfo"));
	out.println("");
	out.print(orderNotificationRB.getString("orderReceivedPaymentStatus"));
	out.print(" ");
	Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
	String paymentStatus = (String) getCOPaymentStatus(orderLabels, request, response, orderId);
	out.println(UIUtil.toHTML(paymentStatus));
	
	//Display payment methods	
	OrderDataBean orderDB = new OrderDataBean();	
	EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
	if ((orderId != null) && !(orderId.equals(""))) {
		edpPIDataBean.setOrderId(new Long(orderId));
		DataBeanManager.activate(edpPIDataBean, request, response);
		orderDB.setOrderId(orderId);
		DataBeanManager.activate(orderDB, request, response);
	}
	ArrayList pis = edpPIDataBean.getPaymentInstructions();
	Iterator iteForPI = pis.iterator();

	while (iteForPI.hasNext()) {
		out.println(orderNotificationRB.getString("shortDelimeter"));
		out.println("");
		EDPPaymentInstruction aPI = (EDPPaymentInstruction) iteForPI.next();
		HashMap protocolData = aPI.getProtocolData();
		out.print(orderNotificationRB.getString("orderReceivedPaymentMethod"));
		out.print(" ");
		out.println(aPI.getPaymentMethod());
		out.print(orderNotificationRB.getString("orderReceivedPaymentAmount"));
		out.print(" ");
		out.println(formatAmount(aPI.getAmount(), orderDB.getCurrency(), storeAB, storeAB.getLanguageIdInEntityType()));
		String accountNumber = (String) protocolData.get("account");
		if (accountNumber == null) {
			accountNumber = "";
		}
		out.print(orderNotificationRB.getString("orderReceivedPaymentAccount"));
		out.print(" ");
		out.println(accountNumber);
		out.print(orderNotificationRB.getString("orderReceivedPaymentBillAddress"));
		out.print(" ");
		Hashtable addressInfo3 = getAddressInfo(protocolData.get("billing_address_id").toString(),request);
		out.println(getFormattedName(addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(2, addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(3, addressInfo3, localeAddrFormat));
		out.println(getFormattedAddress(4, addressInfo3, localeAddrFormat));
	}	
	out.println("");
	out.println( orderNotificationRB.getString("delimeter") );

} catch (Exception e){
	out.println(e);
}
%>
