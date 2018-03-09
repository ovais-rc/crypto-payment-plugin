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

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.payment.entities.PaymentInstruction;

@ApiModel(description = "This is the GetPunchoutURLCmd UE output pojo")
public class GetPunchoutURLCmdUEOutput extends TaskCmdUEOutput{

	/**
	 * authentication url
	 */
	String punchoutURL;
	
	/**
	 * Payment Instruction object.
	 */
	PaymentInstruction paymentInstruction;

	/**
	 * Return authentication url
	 * @return payment authentication url
	 */
	@ApiModelProperty(value = "payment authentication url")
	public String getPunchoutURL(){
		return punchoutURL;			
	}
	
	/**
	 * get punchout payment authentication url
	 * @param url payment authentication url
	 */
	public void setPunchoutURL(String url){
			punchoutURL = url;			
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
