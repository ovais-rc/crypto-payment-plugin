package com.ibm.commerce.order.ue.entities;

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

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.order.entities.Order;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "This is the OrderMessagingCmd UE output pojo")
public class OrderMessagingCmdUEOutput extends TaskCmdUEOutput{
	/**
	 * The order pojo object
	 */
	protected Order order;
	
	/**
	 * The order reference number
	 */
	protected Long orderRn;
	
	@ApiModelProperty(value = "The order pojo object")
	public Order getOrder(){
		return this.order;
	}
	
	public void setOrder(Order order){
		this.order = order;
	}
	
	@ApiModelProperty(value = "The order reference number")
	public Long getOrderRn(){
		return this.orderRn;
	}
	
	public void setOrderRn(Long orderRn){
		this.orderRn = orderRn;
	}
	
}