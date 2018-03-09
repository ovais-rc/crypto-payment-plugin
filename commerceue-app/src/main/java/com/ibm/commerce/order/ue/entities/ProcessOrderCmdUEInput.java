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

import java.util.Hashtable;
import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;
import com.ibm.commerce.order.entities.Order;


public class ProcessOrderCmdUEInput extends TaskCmdUEInput {
	/**
	 * The order pojo object
	 */
	protected Order order;
	
	//only for PreUE, ReplaceUE and PostUE
	protected Map<String, Object> requestProperties;
	
	//planned for ReplaceUE and PostUE
	protected Map<String, Object> responseProperties;
	
	/**
	 * The order reference number
	 */
	//properties same as PreProcessOrderUEInput
	protected Long orderRn;
	
	/**
	 * Whether to notify the merchant when the order has been processed
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
	 * The behavior of the command if the order total expires or an order item's fulfillment 
	 * center changes during inventory allocation
	 */
	protected String quoteExpiryPolicy;
	
	/**
	 * The time interval, in seconds, used with the url set by the setAvailabilityChangeURL method
	 */
	protected Long maxAvailabilityChange;
	
	/**
	 * The URL to redirect to
	 */
	protected String availabilityChangeURL;
	
	/**
	 * The URL to redirect to if any of the order items in the order cannot be allocated or backordered
	 */
	protected String noInventoryURL;
	
	/**
	 * Whether the customer should be notified when the order is successfully submitted
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
	
	
	/**
	 * The reduceParentQuantities parameter
	 */
	//properties different from PreProcessOrderUEInput
	protected String reduceParentQuantities;
	
	/**
	 * The external user id
	 */
	protected String externalUserId;
	
	/**
	 * The external password
	 */
	protected String externalPassword;
	
	/**
	 * Attributes for order notification
	 */
	protected Hashtable notificationAttributes;
	
	public Map<String, Object> getRequestProperties(){
		return this.requestProperties;
	}
	
	public void setRequestProperties(Map<String, Object> requestProperties){
		this.requestProperties = requestProperties;
	}
	
	public Map<String, Object> getResponseProperties(){
		return this.responseProperties;
	}
	
	public void setResponseProperties(Map<String, Object> responseProperties){
		this.responseProperties = responseProperties;
	}
	
	
	public Order getOrder(){
		return this.order;
	}
	
	public void setOrder(Order order){
		this.order = order;
	}
	
	public Long getOrderRn(){
		return this.orderRn;
	}
	
	public void setOrderRn(Long orderRn){
		this.orderRn = orderRn;
	}
	
	public Long getBillToRn(){
		return this.billToRn;
	}
	
	public void setBillToRn(Long billToRn){
		this.billToRn = billToRn;
	}
	
	public Short getNotifyMerchant(){
		return this.notifyMerchant;
	}
	
	public void setNotifyMerchant(Short notifyMerchant){
		this.notifyMerchant = notifyMerchant;
	}
	
	public Short getNotifyShopper(){
		return this.notifyShopper;
	}
	
	public void setNotifyShopper(Short notifyShopper){
		this.notifyShopper = notifyShopper;
	}
	
	public String getQuotationSubmission(){
		return this.quotationSubmission;
	}
	
	public void setQuotationSubmission(String quotationSubmission){
		this.quotationSubmission = quotationSubmission;
	}
	
	public String getQuoteExpiredURL(){
		return this.quoteExpiredURL;
	}
	
	public void setQuoteExpiredURL(String quoteExpiredURL){
		this.quoteExpiredURL = quoteExpiredURL;
	}
	
	public String getQuoteExpiryPolicy(){
		return this.quoteExpiryPolicy;
	}
	
	public void setQuoteExpiryPolicy(String quoteExpiryPolicy){
		this.quoteExpiryPolicy = quoteExpiryPolicy;
	}
	
	public Long getMaxAvailabilityChange(){
		return this.maxAvailabilityChange;
	}
	
	public void setMaxAvailabilityChange(Long maxAvailabilityChange){
		this.maxAvailabilityChange = maxAvailabilityChange;
	}
	
	public String getAvailabilityChangeURL(){
		return this.availabilityChangeURL;
	}
	
	public void setAvailabilityChangeURL(String availabilityChangeURL){
		this.availabilityChangeURL = availabilityChangeURL;
	}
	
	public String getNoInventoryURL(){
		return this.noInventoryURL;
	}
	
	public void setNoInventoryURL(String noInventoryURL){
		this.noInventoryURL = noInventoryURL;
	}
	
	public Short getNotifyOrderSubmitted(){
		return this.notifyOrderSubmitted;
	}
	
	public void setNotifyOrderSubmitted(Short notifyOrderSubmitted){
		this.notifyOrderSubmitted = notifyOrderSubmitted;
	}
	
	public String getTransferMode(){
		return this.transferMode;
	}
	
	public void setTransferMode(String transferMode){
		this.transferMode = transferMode;
	}
	
	public String getPoNumber(){
		return this.poNumber;
	}
	
	
	
	public void setPoNumber(String poNumber){
		this.poNumber = poNumber;
	}
	
	public String getReduceParentQuantities(){
		return this.reduceParentQuantities;
	}
	
	public void setReduceParentQuantities(String reduceParentQuantities){
		this.reduceParentQuantities = reduceParentQuantities;
	}
	
	public String getExternalUserId(){
		return this.externalUserId;
	}
	
	public void setExternalUserId(String externalUserId){
		this.externalUserId = externalUserId;
	}
	
	public String getExternalPassword(){
		return this.externalPassword;
	}
	
	public void setExternalPassword(String externalPassword ){
		this.externalPassword = externalPassword;
	}
	
	public Hashtable getNotificationAttributes(){
		return this.notificationAttributes;
	}
	
	public void setNotificationAttributes(Hashtable notificationAttributes){
		this.notificationAttributes = notificationAttributes;
	}
}
