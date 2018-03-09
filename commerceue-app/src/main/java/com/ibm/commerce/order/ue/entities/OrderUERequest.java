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

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.order.entities.Order;

public interface OrderUERequest {

	/**
	 * IBM copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	public Order getOrder();

	public void setOrder(Order order);
}
