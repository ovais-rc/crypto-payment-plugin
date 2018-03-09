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

public class PKPaymentMethod implements Serializable {
	
	private static final long serialVersionUID = 1311594776793207595L;
	
	private String displayName;
	private String network;
	private String type;
	private String paymentPass;
	
	/**
	 * @return the displayName
	 */
	public String getDisplayName() {
		return displayName;
	}
	/**
	 * @param displayName the displayName to set
	 */
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	/**
	 * @return the network
	 */
	public String getNetwork() {
		return network;
	}
	/**
	 * @param network the network to set
	 */
	public void setNetwork(String network) {
		this.network = network;
	}
	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return the paymentPass
	 */
	public String getPaymentPass() {
		return paymentPass;
	}
	/**
	 * @param paymentPass the paymentPass to set
	 */
	public void setPaymentPass(String paymentPass) {
		this.paymentPass = paymentPass;
	}

}
