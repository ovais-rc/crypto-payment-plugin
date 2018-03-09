package com.ibm.commerce.websocket.rest.server;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016, 2017
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.CloseReason;
import javax.websocket.CloseReason.CloseCodes;
import javax.websocket.EndpointConfig;
import javax.websocket.Session;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.RandomStringUtils;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.websocket.rest.core.Message;
import com.ibm.commerce.websocket.rest.core.Message.Type;

/**
 * The WebSocket-REST bridge server message processor.
 */
public class MessageProcessor extends Thread {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private static final String CLASS_NAME = MessageProcessor.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASS_NAME);

	private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper()
			.setSerializationInclusion(Include.NON_NULL);

	private static final long RUN_POLL_TIMEOUT_MILLIS = 900000L;
	private static final long QUEUE_OFFER_TIMEOUT_MILLIS = 60000L;
	private static final long SEND_POLL_TIMEOUT_MILLIS = 60000L;

	private SynchronousQueue<Message> synchronousQueue = new SynchronousQueue<>();

	private Session session = null;

	private HttpServletRequest request = null;
	private HttpServletResponse response = null;

	/**
	 * Constructor.
	 * 
	 * @param session
	 *            The WebSocket session.
	 * @param endpointConfig
	 *            The endpoint configuration.
	 */
	public MessageProcessor(Session session, EndpointConfig endpointConfig) {

		super(MessageProcessor.class.getSimpleName());

		this.session = session;

		Map<String, Object> userPropertyMap = endpointConfig
				.getUserProperties();
		request = (HttpServletRequest) userPropertyMap
				.get(HttpServletRequest.class.getName());
		response = (HttpServletResponse) userPropertyMap
				.get(HttpServletResponse.class.getName());

	}

	@Override
	public void run() {

		final String METHOD_NAME = "run";
		LOGGER.entering(CLASS_NAME, METHOD_NAME);

		CloseReason closeReason = null;

		try {

			while (true) {

				Message message = synchronousQueue.poll(
						RUN_POLL_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
				if (message == null) {
					break;
				}
				Message result = process(message);
				synchronized (session) {
					session.getBasicRemote().sendText(
							OBJECT_MAPPER.writeValueAsString(result));
				}

			}

		} catch (InterruptedException ie) {
			LOGGER.log(Level.FINER, ie.getMessage(), ie);
		} catch (Throwable t) {
			LOGGER.log(Level.SEVERE, t.getMessage(), t);
			closeReason = new CloseReason(CloseCodes.UNEXPECTED_CONDITION,
					t.getMessage());
		}

		try {
			synchronized (session) {
				if (session.isOpen()) {
					if (closeReason == null) {
						session.close();
					} else {
						session.close(closeReason);
					}
				}
			}
		} catch (IOException ioe) {
			LOGGER.logp(Level.SEVERE, CLASS_NAME, METHOD_NAME,
					ioe.getMessage(), ioe);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	/**
	 * Queues a message. Should only be called by
	 * {@link BridgeServerEndpoint#onMessage(Session, Message)} on a separate
	 * thread.
	 * 
	 * @param message
	 *            The message.
	 */
	public void queue(Message message) {

		final String METHOD_NAME = "queue";
		LOGGER.entering(CLASS_NAME, METHOD_NAME, message);

		try {
			if (!synchronousQueue.offer(message, QUEUE_OFFER_TIMEOUT_MILLIS,
					TimeUnit.MILLISECONDS)) {
				throw new IllegalStateException(
						"Message is not being processed.");
			}
		} catch (RuntimeException re) {
			throw re;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	/**
	 * Processes a REQUEST message. Should only be called by {@link #run()} and
	 * {@link #send(Message)} on this thread.
	 * 
	 * @param message
	 *            The REQUEST message.
	 * @return The corresponding RESPONSE message.
	 */
	public Message process(Message message) {

		final String METHOD_NAME = "process";
		LOGGER.entering(CLASS_NAME, METHOD_NAME, message);

		Message result = null;

		try {

			if (message.getType() != Type.REQUEST) {
				throw new IllegalStateException("Unexpected message type.");
			}

			String contentType = message.getContentType();
			if (contentType == null) {
				contentType = MediaType.APPLICATION_JSON;
			}

			String requestId = message.getRequestId();
			if (requestId == null) {
				requestId = RandomStringUtils.randomAlphanumeric(16);
			}

			RequestDispatcher localRequestDispatcher = request
					.getRequestDispatcher(message.getPath());
			LocalRequest localRequest = new LocalRequest(request, contentType,
					requestId, message.getMethod(), message.getBody());
			LocalResponse localResponse = new LocalResponse(response);
			localRequestDispatcher.forward(localRequest, localResponse);

			String responseId = localResponse.getResponseId();
			if (responseId == null) {
				responseId = RandomStringUtils.randomAlphanumeric(16);
			}

			result = new Message();
			result.setType(Type.RESPONSE);
			result.setRequestId(requestId);
			result.setResponseId(responseId);
			result.setStatus(localResponse.getStatus());
			result.setBody(localResponse.getBody());

		} catch (RuntimeException re) {
			throw re;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME, result);
		return result;

	}

	/**
	 * Sends a REQUEST message. Can be called by
	 * {@link BridgeServerClientRequestFilter#filter(javax.ws.rs.client.ClientRequestContext)}
	 * and equivalent on this thread.
	 * 
	 * @param message
	 *            The REQUEST message.
	 * @return The corresponding RESPONSE message.
	 */
	public Message send(Message message) {

		final String METHOD_NAME = "send";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, message);
		}

		Message result = null;

		try {

			if (message.getType() != Type.REQUEST) {
				throw new IllegalStateException("Unexpected message type.");
			}

			String requestId = message.getRequestId();
			if (requestId == null) {
				requestId = RandomStringUtils.randomAlphanumeric(16);
				message.setRequestId(requestId);
			}

			synchronized (session) {
				session.getBasicRemote().sendText(
						OBJECT_MAPPER.writeValueAsString(message));
			}

			while (true) {

				Message message2 = synchronousQueue.poll(
						SEND_POLL_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
				if (message2 == null) {
					throw new IllegalStateException("No inbound message.");
				}

				Type type2 = message2.getType();
				if (type2 == Type.REQUEST) {
					Message result2 = process(message2);
					synchronized (session) {
						session.getBasicRemote().sendText(
								OBJECT_MAPPER.writeValueAsString(result2));
					}
				} else if (type2 == Type.RESPONSE) {
					if (!requestId.equals(message2.getRequestId())) {
						throw new IllegalStateException(
								"Request IDs don't match.");
					}
					result = message2;
					break;
				} else {
					throw new IllegalStateException("Unexpected message type.");
				}

			}

		} catch (RuntimeException re) {
			throw re;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		LOGGER.exiting(CLASS_NAME, METHOD_NAME, result);
		return result;

	}

}
