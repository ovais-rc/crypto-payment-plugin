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

import java.util.Map;

import com.ibm.commerce.copyright.IBMCopyright;

public class TaskCmdUEOutput {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private Integer commandStoreId;
	private Map<String, Object> defaultProperties;
	private Long userId;

	public Integer getCommandStoreId() {
		return this.commandStoreId;
	}

	public void setCommandStoreId(Integer commandStoreId) {
		this.commandStoreId = commandStoreId;
	}

	public Map<String, Object> getDefaultProperties() {
		return this.defaultProperties;
	}

	public void setDefaultProperties(Map<String, Object> defaultProperties) {
		this.defaultProperties = defaultProperties;
	}

	public Long getUserId() {
		return this.userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}
}
