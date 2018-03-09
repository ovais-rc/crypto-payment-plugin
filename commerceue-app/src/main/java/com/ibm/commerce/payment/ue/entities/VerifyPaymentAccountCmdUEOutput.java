package com.ibm.commerce.payment.ue.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016, 2017
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;

public class VerifyPaymentAccountCmdUEOutput extends TaskCmdUEOutput{

	private Map result;

	/**
	 * Set the payment account verification result
	 * @param result
	 */
	public void setVerificationResult(Map result){
		this.result = result;
	}
	
	/**
	 * Get the payment account verification result
	 * @return the payment account verification result
	 */
    public Map getVerificationResult(){
    	return result;
    }	
	
}
