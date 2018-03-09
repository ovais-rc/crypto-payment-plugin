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

import java.util.Map;

import com.ibm.commerce.foundation.entities.TaskCmdUEInput;

public class VerifyPaymentAccountCmdUEInput extends TaskCmdUEInput{
	Map protocolData;
	
	/**
	 * Set payment protocol data
	 * @param protocolData
	 */
	public void setProtocolData(Map protocolData){
		this.protocolData = protocolData;
	}
	
	/**
	 * Return payment protocol data
	 * @return protocolData
	 */
    public Map getProtocolData(){
    	return this.protocolData;
    }

}
