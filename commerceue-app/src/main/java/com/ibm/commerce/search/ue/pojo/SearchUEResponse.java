package com.ibm.commerce.search.ue.pojo;

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

import java.util.List;

import org.apache.wink.json4j.JSONObject;

import com.ibm.commerce.foundation.entities.ExceptionData;
import com.ibm.commerce.foundation.entities.UEErrors;

public class SearchUEResponse implements UEErrors {
	private List<ExceptionData> errors;
	private List<JSONObject> content;

	@Override
	public List<ExceptionData> getErrors() {
		return errors;
	}

	@Override
	public void setErrors(List<ExceptionData> errors) {
		this.errors = errors;
	}

	public List<JSONObject> getContent() {
		return content;
	}

	public void setContent(List<JSONObject> content) {
		this.content = content;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("{ ");
		sb.append("errors:").append(getErrors());
		sb.append(", content:").append(getContent());
		sb.append(" }");
		return sb.toString();
	}
}
