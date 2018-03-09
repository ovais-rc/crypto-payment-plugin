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

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "This is the TaxIntegrationCustomCmd UE output pojo")
public class TaxIntegrationCustomCmdUEOutput extends TaskCmdUEOutput {
	protected List<TaxIntegrationCustomOrderItem> taxOrderItems = new ArrayList<TaxIntegrationCustomOrderItem>();
	protected BigDecimal totalTax;
	protected BigDecimal totalRecyclingFee;

	@ApiModelProperty(value = "taxOrderItem pojo list")
	public List<TaxIntegrationCustomOrderItem> getTaxOrderItems() {
		return taxOrderItems;
	}

	public void setTaxOrderItems(List<TaxIntegrationCustomOrderItem> taxOrderItems) {
		this.taxOrderItems = taxOrderItems;
	}

	@ApiModelProperty(value = "The total tax of the order")
	public BigDecimal getTotalTax() {
		return totalTax;
	}

	@ApiModelProperty(value = "The total recycling fee of the order")
	public BigDecimal getTotalRecyclingFee() {
		return totalRecyclingFee;
	}

	public void setTotalTax(BigDecimal totalTax) {
		this.totalTax = totalTax;
	}

	public void setTotalRecyclingFee(BigDecimal totalRecyclingFee) {
		this.totalRecyclingFee = totalRecyclingFee;
	}
}
