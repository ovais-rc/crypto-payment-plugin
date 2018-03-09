package com.ibm.commerce.payment.applepay.util;

import java.util.Map;

import com.ibm.commerce.payment.applepay.objects.PKPaymentData;
import com.ibm.commerce.payment.applepay.objects.PKPaymentDataHeader;
import com.ibm.commerce.payment.applepay.objects.PKPaymentMethod;
import com.ibm.commerce.payment.applepay.objects.PKPaymentToken;

public class ApplePayUtils {

	
    public static final String UNDEFINED = "undefined";
    
	/**
	 * Compose PKPaymentToken base on PI's extended data.
	 * @param extData
	 * @return PKPaymentToken
	 */
	@SuppressWarnings("rawtypes")
	public static PKPaymentToken composePaymentToken(Map extData){
		
		//compose PKPaymentMethod
		PKPaymentMethod paymentMethod = new PKPaymentMethod();
		String displayName = (String) extData.get("applepay_paymentMethod_displayName");
		String network = (String) extData.get("applepay_paymentMethod_network");
		String type = (String) extData.get("applepay_paymentMethod_type");
		String paymentPass = (String) extData.get("applepay_paymentMethod_paymentPass");
		if(displayName != null && displayName != UNDEFINED){
			paymentMethod.setDisplayName(displayName);
		}
		if(network != null){
			paymentMethod.setNetwork(network);
		}
		if(type != null){
			paymentMethod.setType(type);
		}
		if(paymentPass != null){
			paymentMethod.setPaymentPass(paymentPass);
		}
		
		//compose PKPaymentDataHeader
		PKPaymentDataHeader header = new PKPaymentDataHeader();
		String applicationData = (String) extData.get("applepay_paymentData_header_applicationData");
		String ephemeralPublicKey = (String) extData.get("applepay_paymentData_header_ephemeralPublicKey");
		String wrappedKey = (String) extData.get("applepay_paymentData_header_wrappedKey");
		String publicKeyHash = (String) extData.get("applepay_paymentData_header_publicKeyHash");
		String transactionId = (String) extData.get("applepay_paymentData_header_transactionId");
		if(applicationData != null && applicationData != UNDEFINED){
			header.setApplicationData(applicationData);
		}
		if(ephemeralPublicKey != null && ephemeralPublicKey != UNDEFINED){
			header.setEphemeralPublicKey(ephemeralPublicKey);
		}
		if(wrappedKey != null && wrappedKey != UNDEFINED){
			header.setWrappedKey(wrappedKey);
		}
		if(publicKeyHash != null && publicKeyHash != UNDEFINED){
			header.setPublicKeyHash(publicKeyHash);
		}
		if(transactionId != null && transactionId != UNDEFINED){
			header.setTransactionId(transactionId);
		}
		
		//compose PKPaymentData
		PKPaymentData paymentData = new PKPaymentData();
		String data = (String) extData.get("applepay_paymentData_data");
		String signature = (String) extData.get("applepay_paymentData_signature");
		String version = (String) extData.get("applepay_paymentData_version");
		if(data != null && data != UNDEFINED){
			paymentData.setData(data);
		}
		if(signature != null && signature != UNDEFINED){
			paymentData.setSignature(signature);
		}
		if(version != null && version != UNDEFINED){
			paymentData.setVersion(version);
		}
		if(header != null){
			paymentData.setHeader(header);
		}
		
		
		//compose PKPaymentToken
		PKPaymentToken paymentToken = new PKPaymentToken();
		String transactionIdentifier = (String) extData.get("applepay_transactionIdentifier");
		if(paymentData != null){
			paymentToken.setpaymentData(paymentData);
		}
		if(paymentMethod != null){
			paymentToken.setPaymentMethod(paymentMethod);
		}
		if(transactionIdentifier != null){
			paymentToken.setTransactionIdentifier(transactionIdentifier);
		}
		
		return paymentToken;
	}	
	
}
