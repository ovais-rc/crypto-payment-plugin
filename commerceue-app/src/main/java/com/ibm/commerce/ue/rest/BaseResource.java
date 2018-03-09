package com.ibm.commerce.ue.rest;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.util.List;

import javax.ws.rs.core.Response;

public abstract class BaseResource {

	/**
	 * Creates a response.
	 * 
	 * @param items
	 *            The items.
	 * @param count
	 *            The count.
	 * @return The response.
	 */
	public Response createResponse(List<?> items, Long count) {
		ResponseContainer<?> responseContainer = new ResponseContainer(items,
				count);
		return Response.ok(responseContainer).build();
	}

}
