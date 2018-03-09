package com.ibm.commerce.search.ue.rest;

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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.container.ResourceContext;
import javax.ws.rs.core.Configuration;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.core.UriInfo;

import org.apache.wink.json4j.JSON;
import org.apache.wink.json4j.JSONArray;
import org.apache.wink.json4j.JSONException;
import org.apache.wink.json4j.JSONObject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ibm.commerce.search.ue.pojo.SearchUERequest;
import com.ibm.commerce.ue.rest.BaseResource;

/**
 * Base class for all analytics root resource classes.
 */
public abstract class AbstractSearchResource extends BaseResource {

	private static final Logger LOGGER = Logger
			.getLogger(AbstractSearchResource.class.getName());
	private static final String CLASSNAME = AbstractSearchResource.class
			.getName();

	/**
	 * The URI of the request.
	 */
	@JsonIgnore
	@Context
	protected UriInfo uri;

	/**
	 * The security context of request.
	 */
	@JsonIgnore
	@Context
	protected SecurityContext securityContext;

	/**
	 * The configuration of request.
	 */
	@JsonIgnore
	@Context
	protected Configuration configuration;

	/**
	 * The <code>javax.servlet.http.HttpServletRequest</code> object in the
	 * context.
	 */
	@JsonIgnore
	@Context
	protected HttpServletRequest request;

	/**
	 * The servlet context.
	 */
	@JsonIgnore
	@Context
	protected ServletContext servletContext;

	/**
	 * The resource context.
	 */
	@JsonIgnore
	@Context
	protected ResourceContext resourceContext;

	/**
	 * The Http headers of the request.
	 */
	@JsonIgnore
	@Context
	protected HttpHeaders headers;

	/**
	 * Elapsed time.
	 */
	protected Date now;
	
	/**
	 * This method gets Map from HttpServletRequest based on JSON input format.
	 * 
	 * @param request
	 *            the request
	 * @return the map from request
	 * @throws Exception
	 *             the exception
	 */
	public Map<String, Object> getMapFromRequest(HttpServletRequest request)
			throws Exception {
		final String METHODNAME = "getMapFromRequest(HttpServletRequest)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME);
		}

		Map<String, Object> paramMap = null;
		InputStream inputStream = null;
		try {
			ByteArrayOutputStream bufferOut = new ByteArrayOutputStream();
			inputStream = request.getInputStream();
			int result = inputStream.read();
			while (result != -1) {
				bufferOut.write(result);
				result = inputStream.read();
			}
			String inputBody = bufferOut.toString("UTF-8");
			if (inputBody.length() > 0) {
				paramMap = (JSONObject) JSON.parse(inputBody);
			} else {
				paramMap = new java.util.HashMap<String, Object>();
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					LOGGER.severe("inputstream not successfully closed" + e);
				}
			}
		}

		LOGGER.exiting(CLASSNAME, METHODNAME, paramMap);
		return paramMap;
	}

	/**
	 * Returns a list of values for the given control parameter of the current
	 * SearchCriteria object.
	 * 
	 * @param contentView
	 *            Content view JSON objects from the request
	 * @param controlParameterName
	 *            Name of the control parameter
	 * @return control parameter value
	 * @throws JSONException
	 */
	public List<String> getControlParameterValues(List<JSONObject> contentView,
			String controlParameterName) throws JSONException {
		final String METHODNAME = "getControlParameterValues(List<JSONObject>, String)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { contentView,
					controlParameterName });
		}

		List<String> controlParameterValues = null;
		for (int i = 0; i < contentView.size(); i++) {
			JSONObject controlParameter = contentView.get(i);
			if (controlParameter.has(controlParameterName)) {
				controlParameterValues = (JSONArray) controlParameter
						.get(controlParameterName);
				break;
			}
		}

		LOGGER.exiting(CLASSNAME, METHODNAME, controlParameterValues);
		return controlParameterValues;
	}

	/**
	 * Assigns the given value to the first value in the given control parameter
	 * of the current SearchCriteria object.
	 * 
	 * @param contentView
	 *            Content view JSON objects from the request
	 * @param controlParameterName
	 *            Name of the control parameter
	 * @param controlParameterValue
	 *            Value of the control parameter
	 * @throws JSONException
	 */
	public void setControlParameterValue(List<JSONObject> contentView,
			String controlParameterName, String controlParameterValue)
			throws JSONException {
		final String METHODNAME = "setControlParameterValue(List<JSONObject>, String, String)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { contentView,
					controlParameterName, controlParameterValue });
		}

		List<String> controlParameterValues = new ArrayList<String>();
		controlParameterValues.add(controlParameterValue);
		setControlParameterValues(contentView, controlParameterName,
				controlParameterValues);

		LOGGER.exiting(CLASSNAME, METHODNAME);
	}

	/**
	 * Assigns the given values to the given control parameter of the current
	 * SearchCriteria object.
	 * 
	 * @param contentView
	 *            Content view JSON objects from the request
	 * @param controlParameterName
	 *            Name of the control parameter
	 * @param controlParameterValues
	 *            Values of the control parameter
	 * @throws JSONException
	 */
	public void setControlParameterValues(List<JSONObject> contentView,
			String controlParameterName, List<String> controlParameterValues)
			throws JSONException {
		final String METHODNAME = "setControlParameterValue(List<JSONObject>, String, List<String>)";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASSNAME, METHODNAME, new Object[] { contentView,
					controlParameterName, controlParameterValues });
		}

		boolean found = false;
		for (int i = 0; i < contentView.size(); i++) {
			JSONObject controlParameter = contentView.get(i);
			if (controlParameter.has(controlParameterName)) {
				// Only override the given control parameter
				JSONArray values = (JSONArray) controlParameter
						.get(controlParameterName);
				values.clear();
				values.put(controlParameterValues);
				found = true;
				break;
			}
		}
		if (!found) {
			// Create a new parameter when not specified
			JSONObject controlParameter = new JSONObject();
			JSONArray values = new JSONArray();
			values.put(controlParameterValues);
			controlParameter.put(controlParameterName, values);
			contentView.add(controlParameter);
		}

		LOGGER.exiting(CLASSNAME, METHODNAME);
	}
	
	/**
	 * Log the given request.
	 * 
	 * @param request
	 */
	public void logRequest(SearchUERequest request) {
		now = new Date();
		if (LOGGER.isLoggable(Level.FINER)) {
			if (request != null) {
				LOGGER.finer("Request headers: " + headers.getRequestHeaders());
				LOGGER.finer("Request context: " + request.getContextData());
				LOGGER.finer("Request content: " + request.getContent());
			} else {
				LOGGER.finer("Request is null");
			}
		}
	}
	
	/**
	 * Log the given response.
	 * 
	 * @param response
	 */
	public void logResponse(Response response) {
		Long elapsedTime = System.currentTimeMillis() - now.getTime();
		if (LOGGER.isLoggable(Level.FINER)) {
			if (response != null) {
				LOGGER.finer("Response headers: " + response.getStringHeaders());
				LOGGER.finer("Response status: " + Status.fromStatusCode(response.getStatus()));
				LOGGER.finer("Response entity: " + response.getEntity());
				LOGGER.finer("Elapsed time: " + elapsedTime + " ms");
			} else {
				LOGGER.finer("Response is null");
			}
		}
	}
}
