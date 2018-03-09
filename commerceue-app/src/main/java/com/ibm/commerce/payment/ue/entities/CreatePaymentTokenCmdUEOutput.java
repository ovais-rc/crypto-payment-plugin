package com.ibm.commerce.payment.ue.entities;

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

import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;

public class CreatePaymentTokenCmdUEOutput extends TaskCmdUEOutput{

	private Map paymentToken;

	/**
	 * Set the payment token
	 * @param token
	 */
	public void setPaymentToken(Map token){
		this.paymentToken = token;
	}
	
	/**
	 * Get the payment token
	 * @return payment token
	 */
    public Map getPaymentToken(){
    	return paymentToken;
    }	
	
}
