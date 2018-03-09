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

import com.ibm.commerce.foundation.entities.BaseContext;

public class ContextData extends BaseContext {
	private String catalogId;
	private String langId;

	public String getCatalogId() {
		return catalogId;
	}

	public void setCatalogId(String catalogId) {
		this.catalogId = catalogId;
	}

	public String getLangId() {
		return langId;
	}

	public void setLangId(String langId) {
		this.langId = langId;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("{ ");
		sb.append("catalogId:").append(getCatalogId());
		sb.append(", langId:").append(getLangId());
		sb.append(", storeId:").append(getStoreId());
		sb.append(", callerId:").append(getCallerId());
		sb.append(", runAsId:").append(getRunAsId());
		sb.append(", channelId:").append(getChannelId());
		sb.append(" }");
		return sb.toString();
	}
}
