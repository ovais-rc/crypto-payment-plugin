package com.ibm.commerce.websocket.rest.server;

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

import java.io.IOException;
import java.util.logging.Logger;

import javax.ws.rs.client.ClientRequestContext;
import javax.ws.rs.client.ClientRequestFilter;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;

import org.apache.commons.lang3.RandomStringUtils;

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.websocket.rest.core.Message;
import com.ibm.commerce.websocket.rest.core.Message.Type;

/**
 * JAX-RS client request filter that forwards requests to the WebSocket-REST
 * bridge server.
 */
@Provider
public class BridgeServerClientRequestFilter implements ClientRequestFilter {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private static final String CLASS_NAME = BridgeServerClientRequestFilter.class
			.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASS_NAME);

	@Override
	public void filter(ClientRequestContext requestContext) throws IOException {

		final String METHOD_NAME = "filter";
		LOGGER.entering(CLASS_NAME, METHOD_NAME, requestContext);

		Thread currentThread = Thread.currentThread();
		if (currentThread instanceof MessageProcessor) {

			String requestId = requestContext.getHeaderString("X-Request-ID");
			if (requestId == null) {
				requestId = RandomStringUtils.randomAlphanumeric(16);
			}

			Message message = new Message();
			message.setType(Type.REQUEST);
			message.setRequestId(requestId);
			message.setMethod(requestContext.getMethod());
			message.setPath(requestContext.getUri().toString());
			message.setBody((String) requestContext.getEntity());

			Message result = ((MessageProcessor) currentThread).send(message);

			Response response = Response.status(result.getStatus())
					.entity(result.getBody()).build();
			requestContext.abortWith(response);

		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

}
