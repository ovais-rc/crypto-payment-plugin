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

import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.order.entities.Order;


/**
 * ProcessOrderSubmitEventUEOutput is the object which transfers from the User
 * Exit server to commerce server when UE for command ProcessOrderSubmitEventCmd
 * is enabled.
 */
public class ProcessOrderSubmitEventCmdUEOutput extends TaskCmdUEOutput {
	protected Order order;
	// Object fields may be null according to different ueType
	// only for PreUE, ReplaceUE and PostUE
	protected Map<String, Object> requestProperties; 
	
	// planned for ReplaceUE, and PostUE
	protected Map<String, Object> responseProperties;

	protected Long orderId;

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public Map<String, Object> getRequestProperties() {
		return requestProperties;
	}

	public void setRequestProperties(Map<String, Object> requestProperties) {
		this.requestProperties = requestProperties;
	}

	public Map<String, Object> getResponseProperties() {
		return responseProperties;
	}

	public void setResponseProperties(Map<String, Object> responseProperties) {
		this.responseProperties = responseProperties;
	}

	public Long getOrderId() {
		return orderId;
	}

	public void setOrderId(Long orderId) {
		this.orderId = orderId;
	}

}
