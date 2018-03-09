package com.ibm.commerce.payment.applepay.objects;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.io.Serializable;

public class PKPaymentToken implements Serializable {
	
	private static final long serialVersionUID = -4505637845942252410L;
	
	private PKPaymentData paymentData;
	private PKPaymentMethod paymentMethod;
	private String transactionIdentifier;
	
	/**
	 * @return the paymentData
	 */
	public PKPaymentData getpaymentData() {
		return paymentData;
	}
	/**
	 * @param paymentData the paymentData to set
	 */
	public void setpaymentData(PKPaymentData paymentData) {
		this.paymentData = paymentData;
	}
	/**
	 * @return the paymentMethod
	 */
	public PKPaymentMethod getPaymentMethod() {
		return paymentMethod;
	}
	/**
	 * @param paymentMethod the paymentMethod to set
	 */
	public void setPaymentMethod(PKPaymentMethod paymentMethod) {
		this.paymentMethod = paymentMethod;
	}
	/**
	 * @return the transactionIdentifier
	 */
	public String getTransactionIdentifier() {
		return transactionIdentifier;
	}
	/**
	 * @param transactionIdentifier the transactionIdentifier to set
	 */
	public void setTransactionIdentifier(String transactionIdentifier) {
		this.transactionIdentifier = transactionIdentifier;
	}

	
}
