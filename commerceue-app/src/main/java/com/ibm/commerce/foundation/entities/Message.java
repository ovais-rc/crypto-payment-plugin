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

public class Message {
	/**
	 * IBM copyright notice field.
	 */

	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	protected String storeId = "0";
	protected String xml = null;
	protected String msgType = null;
	protected String locale = null;
	protected boolean isSync = false;
	
	/**
	* Gets the value of locale.
	 * @return the locale
	 */
	public String getLocale() {
		return locale;
	}

	/**
	 * @param locale the locale to set
	 */
	public void setLocale(String locale) {
		this.locale = locale;
	}


	/**
	 * @return the sync
	 */
	public boolean isSync() {
		return isSync;
	}

	/**
	 * Set the value of isSync.
	 * @param sync the sync to set
	 */
	public void setSync(boolean isSync) {
		this.isSync = isSync;
	}

	/**
	 * Gets the value of message type.
	 * @return the msgType
	 */
	public String getMsgType() {
		return msgType;
	}

	/**
	 * Sets the value of message type.
	 * @param msgType the msgType to set
	 */
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}

	/**
	 * Gets the value of store id.
	 * @return the storeId
	 */
	public String getStoreId() {
		return storeId;
	}

	/**
	 * Sets the value of store Id.
	 * @param storeId the storeId to set
	 */
	public void setStoreId(String storeId) {
		this.storeId = storeId;
	}

	/**
	 * Gets the value of message xml content.
	 * @return the xml
	 */
	public String getXml() {
		return xml;
	}

	/**
	 * Sets the value of message xml content.
	 * @param xml the xml to set
	 */
	public void setXml(String xml) {
		this.xml = xml;
	}

}
