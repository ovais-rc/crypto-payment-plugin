package com.ibm.commerce.member.ue.entities;

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

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.member.entities.Person;

public interface PersonUEResponse {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	public abstract Person getPerson();

	public abstract void setPerson(Person person);
}
