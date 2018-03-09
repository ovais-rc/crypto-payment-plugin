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

public class UEInvocation {
	
	/**
	 * IBM copyright notice field.
	 */
	public static final String COPYRIGHT = com.ibm.commerce.copyright.IBMCopyright.SHORT_COPYRIGHT;
	
	/**
	 * The UE name
	 */
	protected String ueName;
	
	/**
	 * The request Id in this UE call
	 */
	protected String requestId;
	
	/**
	 * The response Id returned from UE call
	 */
	protected String responseId;
	
	/**
	 * The compensation result
	 */
	protected String compensationResult;

	/**
	 * 
	 * @return name of the UE
	 */
	public String getUEName() {
		return ueName;
	}
	
	/**
	 * 
	 * @return request Id of the UE which is unique reference of an UE invocation.
	 */
	public String getRequestId() {
		return requestId;
	}

	/**
	 * 
	 * @return response Id of the UE which is unique reference of an UE transaction.
	 */
	public String getResponseId() {
		return responseId;
	}
	
	/**
	 * 
	 * @return compensation result for this UE. e.g. succeed, fail
	 */
	public String getCompensationResult() {
		return compensationResult;
	}
	
	/**
	 * set the name of the UE
	 * @param name of the UE
	 */
	public void setUEName(String name) {
		ueName = name;
	}
	
	/**
	 * set the request Id.
	 * @param reqId  request Id of the UE which is unique reference of an UE invocation.
	 */
	public void setRequestId(String reqId) {
		this.requestId = reqId;
	}

	/**
	 * set the response Id
	 * @param respId response Id of the UE which is unique reference of an UE transaction.
	 */
	public void setResponseId(String respId) {
		responseId = respId;
	}
	
	/**
	 * set the compensation result. 
	 * @param compensationRst compensation result for this UE. e.g. succeed, fail
	 */
	public void setCompensationResult(String compensationRst) {
		compensationResult = compensationRst;
	}
	
}
