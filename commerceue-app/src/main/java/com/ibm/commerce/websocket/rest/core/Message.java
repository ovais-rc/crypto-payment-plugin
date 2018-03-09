package com.ibm.commerce.websocket.rest.core;

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

import com.ibm.commerce.copyright.IBMCopyright;

/**
 * A WebSocket-REST message.
 */
public class Message {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	/**
	 * Message types.
	 */
	public static enum Type {
		REQUEST, RESPONSE
	}

	private Type type = null;
	private String contentType = null;
	private String requestId = null;
	private String responseId = null;
	private String method = null;
	private String path = null;
	private Integer status = null;
	private String body = null;

	/**
	 * Constructor.
	 */
	public Message() {
	}

	/**
	 * Returns the message type.
	 * 
	 * @return The message type.
	 */
	public Type getType() {
		return type;
	}

	/**
	 * Sets the message type.
	 * 
	 * @param type
	 *            The message type.
	 */
	public void setType(Type type) {
		this.type = type;
	}

	/**
	 * Returns the content type.
	 * 
	 * @return The content type.
	 */
	public String getContentType() {
		return contentType;
	}

	/**
	 * Sets the content type.
	 * 
	 * @param type
	 *            The content type.
	 */
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	/**
	 * Returns the request ID.
	 * 
	 * @return The request ID.
	 */
	public String getRequestId() {
		return requestId;
	}

	/**
	 * Sets the request ID.
	 * 
	 * @param requestId
	 *            The request ID.
	 */
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	/**
	 * Returns the response ID.
	 * 
	 * @return The response ID.
	 */
	public String getResponseId() {
		return responseId;
	}

	/**
	 * Sets the response ID.
	 * 
	 * @param responseId
	 *            The response ID.
	 */
	public void setResponseId(String responseId) {
		this.responseId = responseId;
	}

	/**
	 * Returns the request method.
	 * 
	 * @return The request method.
	 */
	public String getMethod() {
		return method;
	}

	/**
	 * Sets the request method.
	 * 
	 * @param method
	 *            The request method.
	 */
	public void setMethod(String method) {
		this.method = method;
	}

	/**
	 * Returns the request path.
	 * 
	 * @return The request path.
	 */
	public String getPath() {
		return path;
	}

	/**
	 * Sets the request path.
	 * 
	 * @param path
	 *            The request path.
	 */
	public void setPath(String path) {
		this.path = path;
	}

	/**
	 * Returns the response status.
	 * 
	 * @return The response status.
	 */
	public Integer getStatus() {
		return status;
	}

	/**
	 * Sets the response status.
	 * 
	 * @param status
	 *            The response status.
	 */
	public void setStatus(Integer status) {
		this.status = status;
	}

	/**
	 * Returns the request or response body.
	 * 
	 * @return The request or response body.
	 */
	public String getBody() {
		return body;
	}

	/**
	 * Sets the request or response body.
	 * 
	 * @param body
	 *            The request or response body.
	 */
	public void setBody(String body) {
		this.body = body;
	}

	@Override
	public String toString() {
		return "Message [type=" + type + ", contentType=" + contentType
				+ ", requestId=" + requestId + ", responseId=" + responseId
				+ ", method=" + method + ", path=" + path + ", status="
				+ status + ", body=" + body + "]";
	}

}
