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

import java.util.List;

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.payment.entities.PaymentInstruction;

public class SessionCleanCmdUEInput extends TaskCmdUEInput{
	
List<PaymentInstruction> paymentInstructions;
	
	/**
	 * Set payment instruction data
	 * @param paymentInstructions
	 */
	public void setPaymentInstructions(List<PaymentInstruction> paymentInstructions){
		this.paymentInstructions = paymentInstructions;
	}
	
	/**
	 * Return payment instruction data
	 * @return PaymentInstructions
	 */
    public List<PaymentInstruction> getPaymentInstructions(){
    	return this.paymentInstructions;
    }


}
