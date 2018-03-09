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

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.payment.entities.PaymentInstruction;

@ApiModel(description = "This is the ProcessPunchoutResponseCmd UE output pojo")
public class ProcessPunchoutResponseCmdUEOutput  extends TaskCmdUEOutput{
	
	/**
	 * Response parameters
	 */
	Map responseParams;
	
	/**
	 * Payment Instruction object.
	 */
	PaymentInstruction paymentInstruction;

	/**
	 * Return response parameters
	 * @return response parameters
	 */
	@ApiModelProperty(value = "Response parameters")
	public Map getResponseParams(){
		return responseParams;
	}
	
	/**
	 * Set response parameters
	 * @param params response parameters
	 */
	public void setResponseParams(Map params){
		responseParams = params;
	}
	
	/**
	 * Set payment instruction object.
	 * @param paymentInstruction
	 */
	public void setPaymentInstruction(PaymentInstruction paymentInstruction){
		this.paymentInstruction = paymentInstruction;
	}
	
	/**
	 * Get payment instruction object.
	 * @return payment instruction
	 */
	@ApiModelProperty(value = "payment instruction object")
    public PaymentInstruction getPaymentInstruction(){
    	return paymentInstruction;
    }
	
	

}
