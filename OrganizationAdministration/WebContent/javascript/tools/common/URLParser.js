/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

/****************************************************************************************
 * URLParser class.
 * Parameter:
 *   url - A fully qualify URL.
 *   e.g.: http://host.server.com:8080/request/path/info?q=abc
 * Methods:
 *   getProtocol() - e.g.: http
 *   getServerName() - e.g.: host.sever.com
 *   getServerPort() - e.g.: 8080
 *   getQueryString() - e.g.: q=abc
 *   getRequestURI() - e.g.: /request/path/info
 *   getRequestPath() - e.g.: /request/path
 *   getPathInfo() - e.g.: /info
 *   getParameterNames() - Return an array of parameter names.
 *   getParameterValue() - Given a parameter name, returns the value associated with it.
 *   getParameterValues() - Given a parameter name, returns an array of values associated with it.
 ***************************************************************************************/

function URLParser(url) {
	this.url = url;
	this.getProtocol = URLParser_getProtocol;
	this.getServerName = URLParser_getServerName;
	this.getServerPort = URLParser_getServerPort;
	this.getQueryString = URLParser_getQueryString;
	this.getRequestURI = URLParser_getRequestURI;
	this.getRequestPath = URLParser_getRequestPath;
	this.getPathInfo = URLParser_getPathInfo;
	this.getParameterNames = URLParser_getParameterNames;
	this.getParameterValue = URLParser_getParameterValue;
	this.getParameterValues = URLParser_getParameterValues;
}

function URLParser_getProtocol() {
	var protocol = "";

	if (this.url.indexOf("://") != -1) {
		protocol = this.url.substring(0, this.url.indexOf("://"));
	}

	return protocol;
}

function URLParser_getServerName() {
	var server = "";

	if (this.url.indexOf("://") != -1) {
		// Gets rid of protocol part.
		server = this.url.substring(this.url.indexOf("://") + 3, this.url.length);

		// Looks for first "/" and gets rid of the rest.
		if (server.indexOf("/") != -1) {
			server = server.substring(0, server.indexOf("/"));
		}

		// Gets rid of port number.
		if (server.indexOf(":") != -1) {
			server = server.substring(0, server.indexOf(":"));
		}
	}

	return server;
}

function URLParser_getServerPort() {
	var defaultPort = 80;
	var port = "";

	if (this.url.indexOf("://") != -1) {
		port = this.url.substring(this.url.indexOf("://") + 3, this.url.length);

		// Looks for first "/" and gets rid of the rest.
		if (port.indexOf("/") != -1) {
			port = port.substring(0, port.indexOf("/"));
		}

		// Looks for port number. If not found, use the default port.
		if (port.indexOf(":") != -1) {
			port = port.substring(port.indexOf(":") + 1);
		}
		else {
			port = defaultPort;
		}
	}

	return port;
}

function URLParser_getQueryString() {
	var query = "";

	if (this.url.indexOf("?") != -1) {
		query = this.url.substring(this.url.indexOf("?")+1);
	}

	return query;
}

function URLParser_getPathInfo() {
	var uri = (this.url.indexOf("?") != -1)?(this.url.substring(0, this.url.indexOf("?"))):(this.url);

	return uri.substring(uri.lastIndexOf("/"));
}

function URLParser_getRequestPath() {
	var uri = this.getRequestURI();

	return uri.substring(0, uri.lastIndexOf("/"));
}

function URLParser_getRequestURI() {
	var uri = (this.url.indexOf("?") != -1)?(this.url.substring(0, this.url.indexOf("?"))):(this.url);
	var withoutProtocol = (uri.indexOf("://") != -1)?(uri.substring(this.url.indexOf("://") + 3, uri.length)):(uri);

	return withoutProtocol.substring(withoutProtocol.indexOf("/"));
}

function URLParser_getParameterNames() {
	var query = this.getQueryString();
	var parameters = query.split("&");
	var names = new Array();

	for (var i = 0; i < parameters.length; i++) {
		names[i] = parameters[i].substring(0, parameters[i].indexOf("="));
	}

	return names;
}

function URLParser_getParameterValue(name) {
	var query = this.getQueryString();
	var parameters = query.split("&");
	var pattern = new RegExp(name+"=", "i");
	var value = "";

	for (var i = 0; i < parameters.length; i++) {
		if (parameters[i].match(pattern)) {
			return parameters[i].substring(parameters[i].indexOf("=")+1);
		}
	}

	return value;
}

function URLParser_getParameterValues(name) {
	var query = this.getQueryString();
	var parameters = query.split("&");
	var pattern = new RegExp(name+"=", "i");
	var values = new Array();

	for (var i = 0; i < parameters.length; i++) {
		if (parameters[i].match(pattern)) {
			values[values.length] = parameters[i].substring(parameters[i].indexOf("=")+1);
		}
	}

	return values;
}