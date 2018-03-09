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

import java.util.Vector;

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.order.entities.Order;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "This is the OrderNotifyCmd UE input pojo")
public class OrderNotifyCmdUEInput extends TaskCmdUEInput {
	/**
	 * The order pojo object
	 */
	protected Order order;
	
	/**
	 * Enable or disable order notification
	 */
	protected Boolean notificationEnabled;
	
	/**
	 * Notification template id
	 */
	protected Integer notificationTemplateId;
	
	/**
	 * The recipients email addresses
	 */
	protected Vector<String> recipients;
	
	@ApiModelProperty(value = "The order pojo object")
	public Order getOrder(){
		return this.order;
	}
	
	public void setOrder(Order order){
		this.order = order;
	}
	
	@ApiModelProperty(value = "Enable or disable order notification")
	public Boolean getNotificationEnabled(){
		return this.notificationEnabled;
	}
	
	public void setNotificationEnabled(Boolean notificationEnabled){
		this.notificationEnabled = notificationEnabled;
	}
	@ApiModelProperty(value = "Notification template id")
	public Integer getNotificationTemplateId(){
		return this.notificationTemplateId;
	}
	
	public void setNotificationTemplateId(Integer notificationTemplateId){
		this.notificationTemplateId = notificationTemplateId;
	}
	@ApiModelProperty(value = "The recipients email addresses")
	public Vector<String> getRecipients(){
		return this.recipients;
	}
	
	public void setRecipients(Vector<String> recipients){
		this.recipients = recipients;
	}
}
