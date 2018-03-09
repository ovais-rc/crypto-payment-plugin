package com.ibm.commerce.foundation.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015, 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import com.ibm.commerce.copyright.IBMCopyright;
//ExceptionData
public class ExceptionData {
	
	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private String code;
	
	private String message;
	
	private String messageKey;
	
	private String correlationId;
	
	private String[] messageArguments;
	
	public ExceptionData(){}

	public ExceptionData(String code, String message, String messageKey,
			String correlationId) {
		super();
		this.code = code;
		this.message = message;
		this.messageKey = messageKey;
		this.correlationId = correlationId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String errorCode) {
		this.code = errorCode;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String errorMessage) {
		this.message = errorMessage;
	}

	public String getMessageKey() {
		return messageKey;
	}

	public void setMessageKey(String messageKey) {
		this.messageKey = messageKey;
	}

	public String getCorrelationId() {
		return correlationId;
	}

	public void setCorrelationId(String correlationId) {
		this.correlationId = correlationId;
	}
	
	public void setMessageArguments(String[] params){
		this.messageArguments = params;
		
	}
	
	public String[] getMessageArguments(){
		return this.messageArguments;
	}
	
	

}