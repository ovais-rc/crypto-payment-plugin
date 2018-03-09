package com.ibm.commerce.order.ue.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016, 2017
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.math.BigDecimal;
import java.sql.Timestamp;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "This is the TaxIntegrationCustomOrderItem pojo which is part of TaxIntegrationCustomCmd UE input/ouput.")
public class TaxIntegrationCustomOrderItem {

	protected Long orderItemId;
	protected Long catalogEntryId;
	protected String partNumber;

	protected BigDecimal cost;

	protected BigDecimal discount;

	protected String[] jurisdictionCodes;

	protected String[] secondaryJurisdictionCodes;

	protected BigDecimal[] secondaryTaxAmounts;

	protected BigDecimal[] taxAmounts;

	protected Integer[] taxTypes;

	protected BigDecimal totalTax;

	protected boolean auditFlag;
	protected String businessName;

	protected String buyerName;

	protected String currencyCode;

	protected BigDecimal freight;

	protected String invoiceNumber;

	protected Double itemCnt;

	protected String sellerID;

	protected String sellerRegistrationId;

	protected String shipFromAddress;

	protected String shipFromCity;

	protected String shipFromCountry;

	protected String shipFromState;

	protected String shipFromTaxGeoCode;

	protected String shipFromZip;

	protected String shipToAddress;

	protected String shipToCity;

	protected String shipToCountry;

	protected String shipToState;

	protected String shipToTaxGeoCode;

	protected String shipToZip;

	protected Integer storeId;

	protected String taxCode;

	protected char transactionType;

	protected Timestamp timeShipped;

	protected BigDecimal[] taxRate;

	protected BigDecimal totalTaxRate;

	protected BigDecimal[] secondaryTaxRate;

	protected BigDecimal recyclingFee;

	protected BigDecimal salesTaxTotal;

	protected BigDecimal shippingTaxTotal;

	@ApiModelProperty(value = "The order item ID")
	public Long getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(Long orderItemId) {
		this.orderItemId = orderItemId;
	}

	@ApiModelProperty(value = "The catalog entry ID")
	public Long getCatalogEntryId() {
		return catalogEntryId;
	}

	public void setCatalogEntryId(Long catalogEntryId) {
		this.catalogEntryId = catalogEntryId;
	}

	@ApiModelProperty(value = "The part number")
	public String getPartNumber() {
		return partNumber;
	}

	public void setPartNumber(String partNumber) {
		this.partNumber = partNumber;
	}

	public void setTaxRate(BigDecimal[] taxRate) {
		this.taxRate = taxRate;
	}

	public void setSecondaryTaxRate(BigDecimal[] secondaryTaxRate) {
		this.secondaryTaxRate = secondaryTaxRate;
	}
	
	@ApiModelProperty(value = "Obtains the tax rate for a given type of jurisdiction level.Accepted types can be 'COUNTRY', 'TERRITORY', 'STATE', 'COUNTY', 'CITY' and 'DISTRICT'and the paramter should be set as this sequence:[COUNTRY,TERRITORY,STATE,COUNTY,CITY,DISTRICT] in array")
	public BigDecimal[] getTaxRate() {
		return this.taxRate;
	}

	@ApiModelProperty(value = "Obtains the tax rate for a given type of secondary jurisdiction level.Accepted types can be 'SECONDARYSTATE', 'SECONARYCOUNTY', 'SECONDARYCITY' and the paramter should be set as this sequence:[SECSTATE,SECCOUNTY,SECCITY] in array")
	public BigDecimal[] getSecondaryTaxRate() {
		return secondaryTaxRate;
	}

	@ApiModelProperty(value = "The total cost for this order item.If the order item is for 4 units at $10 each, then the total cost would be $40.")
	public BigDecimal getCost() {
		return cost;
	}

	public void setCost(BigDecimal cost) {
		this.cost = cost;
	}

	@ApiModelProperty(value = "The total value of all non-tax-exempt discounts for this line item.")
	public BigDecimal getDiscount() {
		return discount;
	}

	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}

	@ApiModelProperty(value = "Obtains all the jurisdiction levels (codes) where the taxes are being calculated.Accepted types can be 'COUNTRY', 'TERRITORY', 'STATE', 'COUNTY', 'CITY' and 'DISTRICT'and the paramter should be set as this sequence:[COUNTRY,TERRITORY,STATE,COUNTY,CITY,DISTRICT] in array")
	public String[] getJurisdictionCodes() {
		return jurisdictionCodes;
	}

	public void setJurisdictionCodes(String[] jurisdictionCodes) {
		this.jurisdictionCodes = jurisdictionCodes;
	}

	@ApiModelProperty(value = "Obtains all the secondary jurisdiction levels (secondary codes) where the taxes are being calculated.Accepted types can be 'SECONDARYSTATE', 'SECONARYCOUNTY', 'SECONDARYCITY' and the paramter should be set as this sequence:[SECSTATE,SECCOUNTY,SECCITY] in array")
	public String[] getSecondaryJurisdictionCodes() {
		return secondaryJurisdictionCodes;
	}

	public void setSecondaryJurisdictionCodes(String[] secondaryJurisdictionCodes) {
		this.secondaryJurisdictionCodes = secondaryJurisdictionCodes;
	}

	@ApiModelProperty(value = "Obtains the tax amounts calculated for each of the given secondary jurisdiction levels returned from the tax calculation modules.Accepted types can be 'SECONDARYSTATE', 'SECONARYCOUNTY', 'SECONDARYCITY' and the paramter should be set as this sequence:[SECONDARYSTATE, SECONARYCOUNTY, SECONDARYCITY] in array")
	public BigDecimal[] getSecondaryTaxAmounts() {
		return secondaryTaxAmounts;
	}

	public void setSecondaryTaxAmounts(BigDecimal[] secondaryTaxAmounts) {
		this.secondaryTaxAmounts = secondaryTaxAmounts;
	}

	@ApiModelProperty(value = "Obtains the tax amounts calculated for each of the given jurisdiction levels returned from the tax calculation modules.Accepted types can be 'COUNTRY', 'TERRITORY', 'STATE', 'COUNTY', 'CITY' and 'DISTRICT'and the paramter should be set as this sequence:[COUNTRY,TERRITORY,STATE,COUNTY,CITY,DISTRICT] in array")
	public BigDecimal[] getTaxAmounts() {
		return taxAmounts;
	}

	public void setTaxAmounts(BigDecimal[] taxAmounts) {
		this.taxAmounts = taxAmounts;
	}

	@ApiModelProperty(value = "Obtains all the taxing authority or jurisdiction levels where the taxes calculated.")
	public Integer[] getTaxTypes() {
		return taxTypes;
	}

	public void setTaxTypes(Integer[] taxTypes) {
		this.taxTypes = taxTypes;
	}

	@ApiModelProperty(value = "Obtains the total tax calculated for this order item for all relevant taxing authorities.")
	public BigDecimal getTotalTax() {
		return totalTax;
	}

	public void setTotalTax(BigDecimal totalTax) {
		this.totalTax = totalTax;
	}

	@ApiModelProperty(value = "Turns on or off the audit (logging) of tax calculations for this order item.This is usually turned on only for the actual purchase and left off for all other calculations. It is false by default.")
	public boolean getAuditFlag() {
		return auditFlag;
	}

	public void setAuditFlag(boolean auditFlag) {
		this.auditFlag = auditFlag;
	}
	
	@ApiModelProperty(value = "The name of the particular business location whichsells the order item.  In WCS we set this to the same value as the sellerId")
	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	@ApiModelProperty(value = "The name of the purchaser for this item.This field is typically used to determine if the purchaser has a tax exempt status or any other pertanent information.")
	public String getBuyerName() {
		return buyerName;
	}

	public void setBuyerName(String buyerName) {
		this.buyerName = buyerName;
	}

	@ApiModelProperty(value = "This 3-character ISO currency code identifies the currency in which the transaction is being made.")
	public String getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(String currencyCode) {
		this.currencyCode = currencyCode;
	}

	@ApiModelProperty(value = "The total sbipping charge for this order item.")
	public BigDecimal getFreight() {
		return freight;
	}

	public void setFreight(BigDecimal freight) {
		this.freight = freight;
	}

	@ApiModelProperty(value = "A unique string representing the Sales invoice.This method provides the ability to attach an identifier to the order itemIt is not used in the actual tax calculation.  It is typically used to track orders between systems.")
	public String getInvoiceNumber() {
		return invoiceNumber;
	}

	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber;
	}

	@ApiModelProperty(value = "The number of units of this order item being purchased.")
	public Double getItemCnt() {
		return itemCnt;
	}

	public void setItemCnt(Double itemCnt) {
		this.itemCnt = itemCnt;
	}

	@ApiModelProperty(value = "This method is used to set the seller identification.For WCS this is the Store Identifier.This is assigned when the store is initially created and cannot be changed.")
	public String getSellerID() {
		return sellerID;
	}

	public void setSellerID(String sellerID) {
		this.sellerID = sellerID;
	}

	@ApiModelProperty(value = "This is A seller registration identifier.This value is needed for international taxation.")
	public String getSellerRegistrationId() {
		return sellerRegistrationId;
	}

	public void setSellerRegistrationId(String sellerRegistrationId) {
		this.sellerRegistrationId = sellerRegistrationId;
	}

	@ApiModelProperty(value = "The street address from which the order item will be shipped.This is either the address of the store or the fulfillment center address.")
	public String getShipFromAddress() {
		return shipFromAddress;
	}

	public void setShipFromAddress(String shipFromAddress) {
		this.shipFromAddress = shipFromAddress;
	}

	@ApiModelProperty(value = "The city portion of the address from which the order item will be shipped.This is either the address of the store or the fulfillment center address.")
	public String getShipFromCity() {
		return shipFromCity;
	}

	public void setShipFromCity(String shipFromCity) {
		this.shipFromCity = shipFromCity;
	}

	@ApiModelProperty(value = "The country from which the order item will be shipped.This is from either the address of the store or the fulfillment center address.")
	public String getShipFromCountry() {
		return shipFromCountry;
	}

	public void setShipFromCountry(String shipFromCountry) {
		this.shipFromCountry = shipFromCountry;
	}

	@ApiModelProperty(value = "The state portion of the address from which the order item will be shipped.This is either the address of the store or the fulfillment center address.")
	public String getShipFromState() {
		return shipFromState;
	}

	public void setShipFromState(String shipFromState) {
		this.shipFromState = shipFromState;
	}

	@ApiModelProperty(value = "The tax jurisdiction code (geoCode) from which the order item will be shipped.This is either the address of the store or the fulfillment center address.")
	public String getShipFromTaxGeoCode() {
		return shipFromTaxGeoCode;
	}

	public void setShipFromTaxGeoCode(String shipFromTaxGeoCode) {
		this.shipFromTaxGeoCode = shipFromTaxGeoCode;
	}

	@ApiModelProperty(value = "The zip code or postal code of the address from which the order item will be shipped.This is either theaddress of the store or the fulfillment center address.")
	public String getShipFromZip() {
		return shipFromZip;
	}

	public void setShipFromZip(String shipFromZip) {
		this.shipFromZip = shipFromZip;
	}

	@ApiModelProperty(value = "The street address to which the order item will be shipped. ")
	public String getShipToAddress() {
		return shipToAddress;
	}

	public void setShipToAddress(String shipToAddress) {
		this.shipToAddress = shipToAddress;
	}

	@ApiModelProperty(value = "The city portion of the address to which the order item will be shipped. ")
	public String getShipToCity() {
		return shipToCity;
	}

	public void setShipToCity(String shipToCity) {
		this.shipToCity = shipToCity;
	}

	@ApiModelProperty(value = "The country to which the order item will be shipped.")
	public String getShipToCountry() {
		return shipToCountry;
	}

	public void setShipToCountry(String shipToCountry) {
		this.shipToCountry = shipToCountry;
	}

	@ApiModelProperty(value = "The state portion of the address to which the order item will be shipped.")
	public String getShipToState() {
		return shipToState;
	}

	public void setShipToState(String shipToState) {
		this.shipToState = shipToState;
	}

	@ApiModelProperty(value = "The tax jurisdiction code (geoCode) to which the order item will be shipped.")
	public String getShipToTaxGeoCode() {
		return shipToTaxGeoCode;
	}

	public void setShipToTaxGeoCode(String shipToTaxGeoCode) {
		this.shipToTaxGeoCode = shipToTaxGeoCode;
	}

	@ApiModelProperty(value = "The zip code or postal code of the address to which the order item will be shipped.")
	public String getShipToZip() {
		return shipToZip;
	}

	public void setShipToZip(String shipToZip) {
		this.shipToZip = shipToZip;
	}

	@ApiModelProperty(value = "The id of the input store to be used for determining the tax types.")
	public Integer getStoreId() {
		return storeId;
	}

	public void setStoreId(Integer storeId) {
		this.storeId = storeId;
	}

	@ApiModelProperty(value = "the tax treatment code for this order item.In WebSphere Commerce Suite this maps to the tax calculation code.This is usually associated with a group of products that are taxed the same. i.e. groceries, clothing, automobiles, etc.")
	public String getTaxCode() {
		return taxCode;
	}

	public void setTaxCode(String taxCode) {
		this.taxCode = taxCode;
	}

	@ApiModelProperty(value = "The type of transaction.The default type is a Sale.valid values are 'B' - Backout a previous sale,'C' - Credit,'P' - Purchase,'R' - Return,'S' - Sale")
	public char getTransactionType() {
		return transactionType;
	}

	public void setTransactionType(char transactionType) {
		this.transactionType = transactionType;
	}

	@ApiModelProperty(value = "The time and date the order item shipped. ")
	public Timestamp getTimeShipped() {
		return timeShipped;
	}

	public void setTimeShipped(Timestamp timeShipped) {
		this.timeShipped = timeShipped;
	}

	@ApiModelProperty(value = "Obtains the total tax rate for this order item for all relevant taxing authorities.")
	public BigDecimal getTotalTaxRate() {
		return totalTaxRate;
	}

	public void setTotalTaxRate(BigDecimal totalTaxRate) {
		this.totalTaxRate = totalTaxRate;
	}

	@ApiModelProperty(value = "Obtains the recycling fee for this order item.")
	public BigDecimal getRecyclingFee() {
		return recyclingFee;
	}

	public void setRecyclingFee(BigDecimal recyclingFee) {
		this.recyclingFee = recyclingFee;
	}

	@ApiModelProperty(value = "The sales tax total")
	public BigDecimal getSalesTaxTotal() {
		return salesTaxTotal;
	}

	public void setSalesTaxTotal(BigDecimal salesTaxTotal) {
		this.salesTaxTotal = salesTaxTotal;
	}

	@ApiModelProperty(value = "The shipping tax total")
	public BigDecimal getShippingTaxTotal() {
		return shippingTaxTotal;
	}

	public void setShippingTaxTotal(BigDecimal shippingTaxTotal) {
		this.shippingTaxTotal = shippingTaxTotal;
	}

}
