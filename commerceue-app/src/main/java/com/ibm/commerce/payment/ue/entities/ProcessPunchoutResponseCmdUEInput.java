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

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.payment.entities.PaymentInstruction;

@ApiModel(description = "This is the ProcessPunchoutResponseCmd UE input pojo")
public class ProcessPunchoutResponseCmdUEInput  extends TaskCmdUEInput{
	
	/**
	 * call back parameters
	 */
	Map callbackParams;

	/**
	 * Set call back parameters
	 * @param params call back parameters
	 */
	public void setCallBackParams(Map params){	
		callbackParams = params;
	}
	
	/**
	 * Return call back parameters
	 * @return call back parameters
	 */
	@ApiModelProperty(value = "call back parameters")
	public Map getCallBackParams(){
		return callbackParams;
	}
	
	/**
	 * payment instruction data which is passed to user exit
	 */
	PaymentInstruction paymentInstruction;

	/**
	 * Set payment instruction data
	 * @param paymentInstruction
	 */
	public void setPaymentInstruction(PaymentInstruction paymentInstruction){
		this.paymentInstruction = paymentInstruction;
	}
	
	/**
	 * Return payment instruction data
	 * @return payment instruction data
	 */
    public PaymentInstruction getPaymentInstruction(){
    	return paymentInstruction;
    }

}
