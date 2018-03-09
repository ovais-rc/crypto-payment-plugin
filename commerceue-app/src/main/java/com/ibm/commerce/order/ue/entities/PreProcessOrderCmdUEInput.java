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

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.order.entities.Order;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "This is the PreProcessOrderCmd UE input pojo")
public class PreProcessOrderCmdUEInput extends TaskCmdUEInput {
	/**
	 * The order pojo object
	 */
	protected Order order;

	// only for PreUE, ReplaceUE and PostUE
	protected Map<String, Object> requestProperties; 
	
	// planned for ReplaceUE and PostUE
	protected Map<String, Object> responseProperties;
	
	/**
	 * The order reference number
	 */
	protected Long orderRn;

	/**
	 * The reference number of the address to bill
	 */
	protected Long billToRn;

	/**
	 * Whether to notify the merchant when the order has been processed
	 */
	protected Short notifyMerchant;

	/**
	 * Whether to notify the shopper when the order has been processed
	 */
	protected Short notifyShopper;

	/**
	 * QuotationSubmission parameter
	 */
	protected String quotationSubmission;

	/**
	 * the URL to redirect to if the order total expired in agreement with the
	 * expiry policy set by the setQuoteExpiryPolicy method
	 */
	protected String quoteExpiredURL;

	/**
	 * The behavior of the command if the order total expires or an order item's
	 * fulfillment center changes during inventory allocation
	 */
	protected String quoteExpiryPolicy;

	/**
	 * The time interval, in seconds, used with the url set by the
	 * setAvailabilityChangeURL method
	 */
	protected Long maxAvailabilityChange;

	/**
	 * The URL to redirect to
	 */
	protected String availabilityChangeURL;

	/**
	 * The URL to redirect to if any of the order items in the order cannot be
	 * allocated or backordered
	 */
	protected String noInventoryURL;

	/**
	 * Whether the customer should be notified when the order is successfully
	 * submitted
	 */
	protected Short notifyOrderSubmitted;

	/**
	 * The transferMode property of the command
	 */
	protected String transferMode;

	/**
	 * PO number
	 */
	protected String poNumber;

	// protected Integer field1;
	// protected BigDecimal field2;
	// protected String field3;

	public Map<String, Object> getRequestProperties() {
		return this.requestProperties;
	}

	public void setRequestProperties(Map<String, Object> requestProperties) {
		this.requestProperties = requestProperties;
	}

	public Map<String, Object> getResponseProperties() {
		return this.responseProperties;
	}

	public void setResponseProperties(Map<String, Object> responseProperties) {
		this.responseProperties = responseProperties;
	}

	@ApiModelProperty(value = "The order pojo object")
	public Order getOrder() {
		return this.order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	@ApiModelProperty(value = "The order reference number")
	public Long getOrderRn() {
		return this.orderRn;
	}

	public void setOrderRn(Long orderRn) {
		this.orderRn = orderRn;
	}

	@ApiModelProperty(value = "The reference number of the address to bill")
	public Long getBillToRn() {
		return this.billToRn;
	}

	public void setBillToRn(Long billToRn) {
		this.billToRn = billToRn;
	}

	@ApiModelProperty(value = "Whether to notify the merchant when the order has been processed")
	public Short getNotifyMerchant() {
		return this.notifyMerchant;
	}

	public void setNotifyMerchant(Short notifyMerchant) {
		this.notifyMerchant = notifyMerchant;
	}

	@ApiModelProperty(value = "Whether to notify the shopper when the order has been processed")
	public Short getNotifyShopper() {
		return this.notifyShopper;
	}

	public void setNotifyShopper(Short notifyShopper) {
		this.notifyShopper = notifyShopper;
	}

	@ApiModelProperty(value = "QuotationSubmission parameter")
	public String getQuotationSubmission() {
		return this.quotationSubmission;
	}

	public void setQuotationSubmission(String quotationSubmission) {
		this.quotationSubmission = quotationSubmission;
	}

	@ApiModelProperty(value = "The URL to redirect to if the order total expired in agreement with the expiry policy set by the setQuoteExpiryPolicy method")
	public String getQuoteExpiredURL() {
		return this.quoteExpiredURL;
	}

	public void setQuoteExpiredURL(String quoteExpiredURL) {
		this.quoteExpiredURL = quoteExpiredURL;
	}

	@ApiModelProperty(value = "The behavior of the command if the order total expires or an order item's fulfillment center changes during inventory allocation")
	public String getQuoteExpiryPolicy() {
		return this.quoteExpiryPolicy;
	}

	public void setQuoteExpiryPolicy(String quoteExpiryPolicy) {
		this.quoteExpiryPolicy = quoteExpiryPolicy;
	}

	@ApiModelProperty(value = "The time interval, in seconds, used with the url set by the setAvailabilityChangeURL method")
	public Long getMaxAvailabilityChange() {
		return this.maxAvailabilityChange;
	}

	public void setMaxAvailabilityChange(Long maxAvailabilityChange) {
		this.maxAvailabilityChange = maxAvailabilityChange;
	}

	@ApiModelProperty(value = "The URL to redirect to")
	public String getAvailabilityChangeURL() {
		return this.availabilityChangeURL;
	}

	public void setAvailabilityChangeURL(String availabilityChangeURL) {
		this.availabilityChangeURL = availabilityChangeURL;
	}

	@ApiModelProperty(value = "The URL to redirect to if any of the order items in the order cannot be allocated or backordered")
	public String getNoInventoryURL() {
		return this.noInventoryURL;
	}

	public void setNoInventoryURL(String noInventoryURL) {
		this.noInventoryURL = noInventoryURL;
	}

	@ApiModelProperty(value = "Whether the customer should be notified when the order is successfully submitted")
	public Short getNotifyOrderSubmitted() {
		return this.notifyOrderSubmitted;
	}

	public void setNotifyOrderSubmitted(Short notifyOrderSubmitted) {
		this.notifyOrderSubmitted = notifyOrderSubmitted;
	}

	@ApiModelProperty(value = "The transferMode property of the command")
	public String getTransferMode() {
		return this.transferMode;
	}

	public void setTransferMode(String transferMode) {
		this.transferMode = transferMode;
	}

	@ApiModelProperty(value = "PO number")
	public String getPoNumber() {
		return this.poNumber;
	}

	public void setPoNumber(String poNumber) {
		this.poNumber = poNumber;
	}

}
