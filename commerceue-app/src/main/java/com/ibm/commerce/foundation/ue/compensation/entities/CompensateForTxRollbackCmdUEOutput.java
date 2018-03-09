package com.ibm.commerce.foundation.ue.compensation.entities;

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

import java.util.List;

import com.ibm.commerce.foundation.entities.TaskCmdUEOutput;

public class CompensateForTxRollbackCmdUEOutput  extends TaskCmdUEOutput{
	/**
	 * IBM copyright notice field.
	 */
	public static final String COPYRIGHT = com.ibm.commerce.copyright.IBMCopyright.SHORT_COPYRIGHT;
	
	/*
	 * a list of UE invocations
	 */
	protected List<UEInvocation> ueInvocations;
	
	/**
	 * 
	 * @return a list of UE invocations happened within this transaction
	 */
	public List<UEInvocation> getUEInvocations(){
		return ueInvocations;
	}
	
	/**
	 * set a list of UE invocations happened within this transaction
	 * @param ueInvocations a list of UE invocations happened within this transaction
	 */
	public void setUEInvocations(List<UEInvocation> ueInvocations){
		this.ueInvocations = ueInvocations;
	}

}
