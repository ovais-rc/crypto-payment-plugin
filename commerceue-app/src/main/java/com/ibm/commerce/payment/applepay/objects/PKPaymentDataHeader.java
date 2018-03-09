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

public class PKPaymentDataHeader implements Serializable {
	
	private static final long serialVersionUID = 5043880205804131521L;
	private String applicationData;
	private String ephemeralPublicKey;
	private String wrappedKey;
	private String publicKeyHash;
	private String transactionId;
	/**
	 * @return the applicationData
	 */
	public String getApplicationData() {
		return applicationData;
	}
	/**
	 * @param applicationData the applicationData to set
	 */
	public void setApplicationData(String applicationData) {
		this.applicationData = applicationData;
	}
	/**
	 * @return the ephemeralPublicKey
	 */
	public String getEphemeralPublicKey() {
		return ephemeralPublicKey;
	}
	/**
	 * @param ephemeralPublicKey the ephemeralPublicKey to set
	 */
	public void setEphemeralPublicKey(String ephemeralPublicKey) {
		this.ephemeralPublicKey = ephemeralPublicKey;
	}
	/**
	 * @return the wrappedKey
	 */
	public String getWrappedKey() {
		return wrappedKey;
	}
	/**
	 * @param wrappedKey the wrappedKey to set
	 */
	public void setWrappedKey(String wrappedKey) {
		this.wrappedKey = wrappedKey;
	}
	/**
	 * @return the publicKeyHash
	 */
	public String getPublicKeyHash() {
		return publicKeyHash;
	}
	/**
	 * @param publicKeyHash the publicKeyHash to set
	 */
	public void setPublicKeyHash(String publicKeyHash) {
		this.publicKeyHash = publicKeyHash;
	}
	/**
	 * @return the transactionId
	 */
	public String getTransactionId() {
		return transactionId;
	}
	/**
	 * @param transactionId the transactionId to set
	 */
	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

}
