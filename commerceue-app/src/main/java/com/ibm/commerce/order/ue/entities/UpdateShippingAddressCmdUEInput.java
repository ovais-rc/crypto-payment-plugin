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

import com.ibm.commerce.foundation.common.entities.ContactInfo;
import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.order.entities.Order;

@ApiModel(description = "This is the UpdateShippingAddressCmd UE input pojo")
public class UpdateShippingAddressCmdUEInput extends TaskCmdUEInput {
	/**
	 * The order pojo object containing order items whose shipping addresses will be updated
	 */
	protected Order order;
	
	/**AddressIds which is used to update shipping addresses of order items
	 * 
	 */
	protected Long[] addressIds;
	
	/**
	 * Whether shipping address validation is required. The default value is false
	 */
	protected Boolean validateRequired;
	
	/**
	 * Whether the shipping addresses use the default shipping addresses for registered user. If no other appropriate addresses are found, the default value is true.
	 */
	protected Boolean defaultAddressUsed;
	
	/**
	 * The pojo array converted from ShippingAddressAccessBeans
	 */
	protected ContactInfo[] shippingAddresses;
	
	@ApiModelProperty(value = "The order pojo object containing order items whose shipping addresses will be updated")
	public Order getOrder(){
		return this.order;
	}
	
	public void setOrder(Order order){
		this.order = order;
	}
	
	@ApiModelProperty(value = "AddressIds which is used to update shipping addresses of order items")
	public Long[] getAddressIds(){
		return this.addressIds;
	}
	
	public void setAddressIds(Long[] addressIds){
		this.addressIds = addressIds;
	}
	
	@ApiModelProperty(value = "Whether shipping address validation is required. The default value is false")
	public Boolean getValidateRequired(){
		return this.validateRequired;
	}
	
	public void setValidateRequired(Boolean validateRequired){
		this.validateRequired = validateRequired;
	}
	
	@ApiModelProperty(value = "Whether the shipping addresses use the default shipping addresses for registered user. If no other appropriate addresses are found, the default value is true.")
	public Boolean getDefaultAddressUsed(){
		return this.defaultAddressUsed;
	}
	
	public void setDefaultAddressUsed(Boolean defaultAddressUsed){
		this.defaultAddressUsed = defaultAddressUsed;
	}
	
	@ApiModelProperty(value = "The pojo array converted from ShippingAddressAccessBeans")
	public ContactInfo[] getShippingAddresses(){
		return this.shippingAddresses;
	}
	
	public void setShippingAddresses(ContactInfo[] shippingAddresses){
		this.shippingAddresses = shippingAddresses;
	}
}
