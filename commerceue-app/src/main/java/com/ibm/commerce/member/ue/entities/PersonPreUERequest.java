package com.ibm.commerce.member.ue.entities;

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.foundation.entities.PreUERequest;
import com.ibm.commerce.member.entities.Person;

public class PersonPreUERequest extends PreUERequest implements PersonUERequest {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private Person person;

	@Override
	public Person getPerson() {
		return this.person;
	}

	@Override
	public void setPerson(Person person) {
		this.person = person;
	}

}
