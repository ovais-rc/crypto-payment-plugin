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
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.websocket.CloseReason;
import javax.websocket.CloseReason.CloseCodes;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.websocket.rest.core.Message;

/**
 * The WebSocket-REST bridge server endpoint.
 */
@ServerEndpoint(value = "/_bridge_server")
public class BridgeServerEndpoint {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private static final String CLASS_NAME = BridgeServerEndpoint.class
			.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASS_NAME);

	private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper()
			.setSerializationInclusion(Include.NON_NULL);

	private MessageProcessor messageProcessor = null;

	@OnOpen
	public void onOpen(Session session, EndpointConfig endpointConfig) {

		final String METHOD_NAME = "onOpen";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] { session,
					endpointConfig });
		}

		messageProcessor = new MessageProcessor(session, endpointConfig);
		messageProcessor.start();

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	@OnMessage
	public void onMessage(Session session, String message) {

		final String METHOD_NAME = "onMessage";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] { session,
					message });
		}

		if (!messageProcessor.isAlive()) {
			throw new IllegalStateException();
		}

		try {
			messageProcessor.queue(OBJECT_MAPPER.readValue(message,
					Message.class));
		} catch (IOException ioe) {
			throw new RuntimeException(ioe);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	@OnClose
	public void onClose(Session session, CloseReason closeReason) {

		final String METHOD_NAME = "onClose";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] { session,
					closeReason });
		}

		messageProcessor.interrupt();

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	@OnError
	public void onError(Session session, Throwable t) {

		final String METHOD_NAME = "onError";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME,
					new Object[] { session, t });
		}

		try {
			LOGGER.log(Level.SEVERE, t.getMessage(), t);
			synchronized (session) {
				if (session.isOpen()) {
					CloseReason closeReason = new CloseReason(
							CloseCodes.UNEXPECTED_CONDITION, t.getMessage());
					session.close(closeReason);
				}
			}
		} catch (IOException ioe) {
			LOGGER.log(Level.SEVERE, ioe.getMessage(), ioe);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

}
