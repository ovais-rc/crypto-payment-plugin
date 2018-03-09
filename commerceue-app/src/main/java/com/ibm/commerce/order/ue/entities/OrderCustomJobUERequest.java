package com.ibm.commerce.order.ue.entities;
/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015, 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */
import java.util.List;

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.foundation.entities.UERequest;
import com.ibm.commerce.order.entities.Order;

public class OrderCustomJobUERequest extends UERequest {

	/**
	 * IBM copyright notice field.
	 */
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private List<Order> orderList;

	/**
	 * Gets the list of order object.
	 * @return list of order
	 */
	public List<Order> getOrders() {
		return orderList;
	}

	/**
	 * Sets the list of order object.
	 * @param orderList the order list to set
	 */
	public void setOrders(List<Order> orderList) {
		this.orderList = orderList;
	}
}
