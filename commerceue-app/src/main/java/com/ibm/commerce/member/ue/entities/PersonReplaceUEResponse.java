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

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import com.ibm.commerce.foundation.entities.ReplaceUEResponse;
import com.ibm.commerce.member.entities.Person;

@ApiModel(description = "This is the replace UE response for the user registration controller commands")
public class PersonReplaceUEResponse extends ReplaceUEResponse implements
		PersonUEResponse {

	private Person person;

	@Override
	@ApiModelProperty(value = "The person pojo object")
	public Person getPerson() {
		return this.person;
	}

	@Override
	public void setPerson(Person person) {
		this.person = person;
	}
}

