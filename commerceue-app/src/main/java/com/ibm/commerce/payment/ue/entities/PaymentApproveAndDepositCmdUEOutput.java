package com.ibm.commerce.payment.ue.entities;

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

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;
import com.ibm.commerce.payment.entities.FinancialTransaction;

public class PaymentApproveAndDepositCmdUEOutput extends TaskCmdUEOutput{

	FinancialTransaction financialTransaction;
	
	/**
	 * Set payment transaction data
	 * @param financialTransaction
	 */
	public void setFinancialTransaction(FinancialTransaction financialTransaction){
		this.financialTransaction = financialTransaction;
	}
	
	/**
	 * Return payment transaction data
	 * @return
	 */
    public FinancialTransaction getFinancialTransaction(){
    	return this.financialTransaction;
    }
}
