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
import com.ibm.commerce.foundation.entities.Message;
import com.ibm.commerce.foundation.entities.ReplaceUEResponse;
import com.ibm.commerce.order.entities.Order;

public class OrderCustomJobUEResponse extends ReplaceUEResponse {
	
	/**
	 * IBM copyright notice field.
	 */

	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private List<Order> orders;
	private List<Message> messages;
	
	/** 
	 * Gets the list of the order object.
	 * @return the order
	 */
	public List<Order> getOrders() {
		return orders;
	}
	/**
	 * Sets the list of the order object.
	 * @param order the order to set
	 */
	public void setOrders(List<Order> orders) {
		this.orders = orders;
	}
	/**
	 * Gets the list of outbound message.
	 * @return the message
	 */
	public List<Message> getMessages() {
		return messages;
	}
	/**
	 * Sets the list of message content.
	 * @param message the message to set
	 */
	public void setMessages(List<Message> messages) {
		this.messages = messages;
	}

}
