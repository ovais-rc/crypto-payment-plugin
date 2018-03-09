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

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.order.entities.Order;
import com.ibm.commerce.payment.entities.PaymentInstruction;

@ApiModel(description = "This is the GetPunchoutURLCmd UE input pojo")
public class GetPunchoutURLCmdUEInput extends TaskCmdUEInput{
	
	/**
	 * payment instruction data which is passed to user exit
	 */
	PaymentInstruction paymentInstruction;

	/**
	 * Order noun
	 */
	Order order;
	
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
	@ApiModelProperty(value = "payment instruction data which is passed to user exit")
    public PaymentInstruction getPaymentInstruction(){
    	return paymentInstruction;
    }
	
	/**
	 * Get Order Noun.
	 * @return Order
	 */
	@ApiModelProperty(value = "order noun which is passed to user exit")
	public Order getOrder(){
		return this.order;
	}
	
	/**
	 * Set order noun.
	 * @param order
	 */
	public void setOrder(Order order){
		this.order = order;
	} 	

}
