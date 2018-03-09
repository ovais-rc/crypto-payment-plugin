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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.ws.rs.core.MultivaluedHashMap;
import javax.ws.rs.core.MultivaluedMap;

import com.ibm.commerce.copyright.IBMCopyright;

/**
 * Request wrapper for making local requests.
 */
public class LocalRequest extends HttpServletRequestWrapper {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private MultivaluedMap<String, String> headerMap = new MultivaluedHashMap<>();

	private String method = null;
	private String body = null;

	private ServletInputStream inputStream = null;
	private BufferedReader reader = null;

	/**
	 * Constructor.
	 * 
	 * @param request
	 *            The original HttpServletRequest.
	 * @param contentType
	 *            The content type.
	 * @param requestId
	 *            The request ID.
	 * @param method
	 *            The request method.
	 * @param body
	 *            The request body.
	 */
	public LocalRequest(HttpServletRequest request, String contentType,
			String requestId, String method, String body) {

		super(request);

		// headerMap.putSingle("Accept", MediaType.APPLICATION_JSON);
		// headerMap.putSingle("Accept-Charset", StandardCharsets.UTF_8.name());
		headerMap.putSingle("Content-Type", contentType);
		headerMap.putSingle("X-Request-ID", requestId);

		this.method = method;
		this.body = body;

	}

	@Override
	public String getCharacterEncoding() {
		return StandardCharsets.UTF_8.name();
	}

	@Override
	public void setCharacterEncoding(String enc)
			throws UnsupportedEncodingException {
		throw new UnsupportedOperationException();
	}

	@Override
	public String getMethod() {
		return method;
	}

	@Override
	public Cookie[] getCookies() {
		return null;
	}

	@Override
	public String getHeader(String name) {
		return headerMap.getFirst(name);
	}

	@Override
	public Enumeration<String> getHeaderNames() {
		return Collections.enumeration(headerMap.keySet());
	}

	@Override
	public Enumeration<String> getHeaders(String name) {
		List<String> valueList = headerMap.get(name);
		return valueList == null ? Collections.<String> emptyEnumeration()
				: Collections.enumeration(valueList);
	}

	@Override
	public long getDateHeader(String name) {
		return -1;
	}

	@Override
	public int getIntHeader(String name) {
		return -1;
	}

	@Override
	public int getContentLength() {
		return body.length();
	}

	@Override
	public long getContentLengthLong() {
		return body.length();
	}

	@Override
	public String getContentType() {
		return headerMap.getFirst("Content-Type");
	}

	@Override
	public ServletInputStream getInputStream() throws IOException {

		if (reader != null) {
			throw new IllegalStateException();
		}

		if (inputStream == null) {

			inputStream = new ServletInputStream() {

				byte[] b = body == null ? null : body
						.getBytes(StandardCharsets.UTF_8);
				private int i = 0;

				@Override
				public int read() throws IOException {
					return b != null && i < b.length ? b[i++] : -1;
				}

				@Override
				public void setReadListener(ReadListener readListener) {
					throw new UnsupportedOperationException();
				}

				@Override
				public boolean isReady() {
					return true;
				}

				@Override
				public boolean isFinished() {
					return b == null || i == b.length;
				}

			};

		}

		return inputStream;

	}

	@Override
	public BufferedReader getReader() throws IOException {

		if (inputStream != null) {
			throw new IllegalStateException();
		}

		if (reader == null) {
			reader = new BufferedReader(new StringReader(body));
		}

		return reader;

	}

}
