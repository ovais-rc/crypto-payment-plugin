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
import java.lang.reflect.Method;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.websocket.server.ServerEndpointConfig;

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.websphere.wsoc.WsWsocServerContainer;

/**
 * The WebSocket-REST bridge server servlet.
 */
public class BridgeServerServlet extends HttpServlet {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private static final String CLASS_NAME = BridgeServerServlet.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASS_NAME);

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		final String METHOD_NAME = "doGet";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] { req, resp });
		}

		ServletContext servletContext = getServletContext();

		WsWsocServerContainer serverContainer = (WsWsocServerContainer) servletContext
				.getAttribute("javax.websocket.server.ServerContainer");
		ServerEndpointConfig serverEndpointConfig = ServerEndpointConfig.Builder
				.create(BridgeServerEndpoint.class, "/_bridge_server").build();

		try {
			Map<String, Object> userPropertyMap = serverEndpointConfig
					.getUserProperties();
			HttpServletRequest request = cloneUnwrappedRequest(req);
			HttpServletResponse response = cloneUnwrappedResponse(resp);
			userPropertyMap.put(HttpServletRequest.class.getName(), request);
			userPropertyMap.put(HttpServletResponse.class.getName(), response);
		} catch (Exception e) {
			throw new ServletException(e);
		}

		serverContainer.doUpgrade(req, resp, serverEndpointConfig, null);

		LOGGER.exiting(CLASS_NAME, METHOD_NAME);

	}

	/**
	 * Clones the unwrapped request.
	 * 
	 * @param request
	 *            The HttpServletRequest.
	 * @return Clone of the unwrapped request.
	 * @throws Exception
	 */
	protected HttpServletRequest cloneUnwrappedRequest(
			HttpServletRequest request) throws Exception {

		final String METHOD_NAME = "cloneUnwrappedRequest";
		LOGGER.entering(CLASS_NAME, METHOD_NAME, request);

		HttpServletRequest unwrappedRequest = request;
		while (unwrappedRequest instanceof HttpServletRequestWrapper) {
			unwrappedRequest = (HttpServletRequest) ((HttpServletRequestWrapper) unwrappedRequest)
					.getRequest();
		}
		Method cloneMethod = unwrappedRequest.getClass().getMethod("clone");
		HttpServletRequest clone = (HttpServletRequest) cloneMethod
				.invoke(unwrappedRequest);

		LOGGER.exiting(CLASS_NAME, METHOD_NAME, clone);
		return clone;

	}

	/**
	 * Clones the unwrapped response.
	 * 
	 * @param response
	 *            The HttpServletResponse.
	 * @return Clone of the unwrapped response.
	 * @throws Exception
	 */
	protected HttpServletResponse cloneUnwrappedResponse(
			HttpServletResponse response) throws Exception {

		final String METHOD_NAME = "cloneUnwrappedResponse";
		LOGGER.entering(CLASS_NAME, METHOD_NAME, response);

		HttpServletResponse unwrappedResponse = response;
		while (unwrappedResponse instanceof HttpServletResponseWrapper) {
			unwrappedResponse = (HttpServletResponse) ((HttpServletResponseWrapper) unwrappedResponse)
					.getResponse();
		}
		Method cloneMethod = unwrappedResponse.getClass().getMethod("clone");
		HttpServletResponse clone = (HttpServletResponse) cloneMethod
				.invoke(unwrappedResponse);

		LOGGER.exiting(CLASS_NAME, METHOD_NAME, clone);
		return clone;

	}

}
