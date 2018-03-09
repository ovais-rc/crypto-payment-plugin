package com.ibm.commerce.foundation.entities;

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

import java.util.ArrayList;
import java.util.List;

import com.ibm.commerce.copyright.IBMCopyright;

public class ErrorUEResponse extends UEResponse implements UEErrors {
	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private List<ExceptionData> errors = new ArrayList<ExceptionData>();

	@Override
	public List<ExceptionData> getErrors() {
		return errors;
	}

	@Override
	public void setErrors(List<ExceptionData> errors) {
		this.errors = errors;
	}
}
