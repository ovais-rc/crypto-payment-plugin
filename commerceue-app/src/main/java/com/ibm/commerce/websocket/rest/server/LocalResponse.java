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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedHashMap;
import javax.ws.rs.core.MultivaluedMap;

import com.ibm.commerce.copyright.IBMCopyright;

/**
 * Response wrapper for making local requests.
 */
public class LocalResponse extends HttpServletResponseWrapper {

	/**
	 * IBM Copyright notice field.
	 */
	public static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;

	private MultivaluedMap<String, String> headerMap = new MultivaluedHashMap<>();

	private int status = 0;
	private ByteArrayOutputStream byteArrayOutputStream = null;

	private boolean committed = false;
	private int bufferSize = 0;
	private String characterEncoding = StandardCharsets.UTF_8.name();
	private String contentType = MediaType.APPLICATION_JSON;
	private Locale locale = null;
	private ServletOutputStream outputStream = null;
	private PrintWriter writer = null;

	/**
	 * Constructor.
	 * 
	 * @param response
	 *            The original HttpServletResponse.
	 */
	public LocalResponse(HttpServletResponse response) {
		super(response);
	}

	/**
	 * Returns the response ID.
	 * 
	 * @return The response ID.
	 */
	public String getResponseId() {
		return headerMap.getFirst("X-Response-ID");
	}

	@Override
	public int getStatus() {
		return status;
	}

	/**
	 * Returns the response body.
	 * 
	 * @return The response body.
	 * @throws UnsupportedEncodingException
	 */
	public String getBody() throws UnsupportedEncodingException {
		return byteArrayOutputStream == null ? null : byteArrayOutputStream
				.toString(characterEncoding);
	}

	@Override
	public void addCookie(Cookie cookie) {
	}

	@Override
	public void addDateHeader(String name, long date) {
	}

	@Override
	public void addHeader(String name, String value) {
		headerMap.add(name, value);
	}

	@Override
	public void addIntHeader(String name, int value) {
	}

	@Override
	public boolean containsHeader(String name) {
		return headerMap.containsKey(name);
	}

	@Override
	public String getHeader(String name) {
		return headerMap.getFirst(name);
	}

	@Override
	public Collection<String> getHeaderNames() {
		return headerMap.keySet();
	}

	@Override
	public Collection<String> getHeaders(String name) {
		List<String> valueList = headerMap.get(name);
		return valueList == null ? Collections.EMPTY_LIST : valueList;
	}

	@Override
	public void sendError(int sc, String msg) throws IOException {
		if (committed) {
			throw new IllegalStateException();
		} else {
			status = sc;
			if (byteArrayOutputStream != null) {
				byteArrayOutputStream.flush();
			}
			committed = true;
		}
	}

	@Override
	public void sendError(int sc) throws IOException {
		sendError(sc, null);
	}

	@Override
	public void sendRedirect(String location) throws IOException {
		throw new UnsupportedOperationException();
	}

	@Override
	public void setDateHeader(String name, long date) {
	}

	@Override
	public void setHeader(String name, String value) {
		headerMap.putSingle(name, value);
	}

	@Override
	public void setIntHeader(String name, int value) {
	}

	@Override
	public void setStatus(int sc, String sm) {
		setStatus(sc);
	}

	@Override
	public void setStatus(int sc) {
		if (committed) {
			throw new IllegalStateException();
		} else {
			status = sc;
		}
	}

	@Override
	public void flushBuffer() throws IOException {
		if (committed) {
			throw new IllegalStateException();
		} else {
			if (byteArrayOutputStream != null) {
				byteArrayOutputStream.flush();
			}
			committed = true;
		}
	}

	@Override
	public int getBufferSize() {
		return bufferSize;
	}

	@Override
	public String getCharacterEncoding() {
		return characterEncoding;
	}

	@Override
	public String getContentType() {
		return contentType;
	}

	@Override
	public Locale getLocale() {
		return locale;
	}

	@Override
	public ServletOutputStream getOutputStream() throws IOException {

		if (writer != null) {
			throw new IllegalStateException();
		}

		if (outputStream == null) {

			if (byteArrayOutputStream == null) {
				byteArrayOutputStream = new ByteArrayOutputStream(bufferSize);
			}

			outputStream = new ServletOutputStream() {

				@Override
				public void write(int b) throws IOException {
					byteArrayOutputStream.write(b);
				}

				@Override
				public void setWriteListener(WriteListener writeListener) {
					throw new UnsupportedOperationException();
				}

				@Override
				public boolean isReady() {
					return true;
				}

			};

		}

		return outputStream;

	}

	@Override
	public PrintWriter getWriter() throws IOException {

		if (outputStream != null) {
			throw new IllegalStateException();
		}

		if (writer == null) {

			if (byteArrayOutputStream == null) {
				byteArrayOutputStream = new ByteArrayOutputStream(bufferSize);
			}

			writer = new PrintWriter(new OutputStreamWriter(
					byteArrayOutputStream, characterEncoding));

		}

		return writer;

	}

	@Override
	public boolean isCommitted() {
		return committed;
	}

	@Override
	public void reset() {
		if (committed) {
			throw new IllegalStateException();
		} else {
			status = 0;
			if (byteArrayOutputStream != null) {
				byteArrayOutputStream.reset();
			}
		}
	}

	@Override
	public void resetBuffer() {
		if (committed) {
			throw new IllegalStateException();
		} else if (byteArrayOutputStream != null) {
			byteArrayOutputStream.reset();
		}
	}

	@Override
	public void setBufferSize(int size) {
		bufferSize = size;
	}

	@Override
	public void setCharacterEncoding(String charset) {
		characterEncoding = charset;
	}

	@Override
	public void setContentLength(int len) {
	}

	@Override
	public void setContentLengthLong(long len) {
	}

	@Override
	public void setContentType(String type) {
		contentType = type;
	}

	@Override
	public void setLocale(Locale loc) {
		locale = loc;
	}

}
