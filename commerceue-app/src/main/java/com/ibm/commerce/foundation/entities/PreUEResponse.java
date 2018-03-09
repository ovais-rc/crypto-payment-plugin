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

import java.util.Map;

import com.ibm.commerce.copyright.IBMCopyright;

public class PreUEResponse extends UEResponse implements UEInputs {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private Map<String, Object> commandInputs;

	@Override
	public void setCommandInputs(Map<String, Object> commandInputs) {
		this.commandInputs = commandInputs;
	}

	@Override
	public Map<String, Object> getCommandInputs() {
		return commandInputs;
	}

}
