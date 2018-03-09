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

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import com.ibm.commerce.foundation.entities.PreUEResponse;
import com.ibm.commerce.order.entities.Order;

@ApiModel(description = "This is the pre UE response for the order controller commands")
public class OrderPreUEResponse extends PreUEResponse implements
		OrderUEResponse {

	private Order order;

	@Override
	@ApiModelProperty(value = "The order pojo object")
	public Order getOrder() {
		return this.order;
	}

	@Override
	public void setOrder(Order order) {
		this.order = order;
	}
}
