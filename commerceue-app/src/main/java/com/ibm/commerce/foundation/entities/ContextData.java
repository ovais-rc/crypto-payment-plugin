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

import java.util.Locale;
import java.util.Map;

import com.ibm.commerce.copyright.IBMCopyright;

public class ContextData {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private Map<String, String> baseContext;
	
	private Map<String, String> accessControlContext;
	
	private Locale locale;

	public Map<String, String> getBaseContext() {
		return baseContext;
	}

	public void setBaseContext(Map<String, String> baseContext) {
		this.baseContext = baseContext;
	}

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	public Map<String, String> getAccessControlContext() {
		return accessControlContext;
	}

	public void setAccessControlContext(Map<String, String> accessControlContext) {
		this.accessControlContext = accessControlContext;
	}
}
