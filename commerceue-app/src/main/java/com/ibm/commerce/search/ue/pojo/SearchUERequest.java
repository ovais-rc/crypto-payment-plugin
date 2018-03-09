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

public class SearchUERequest {
	private ContextData contextData;
	private List<JSONObject> content;

	public ContextData getContextData() {
		return contextData;
	}

	public void setContextData(ContextData contextData) {
		this.contextData = contextData;
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
		sb.append("contextData:").append(getContextData());
		sb.append(", content:").append(getContent());
		sb.append(" }");
		return sb.toString();
	}
}
