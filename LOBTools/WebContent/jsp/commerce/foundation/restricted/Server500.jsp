<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%


	Throwable exception = pageContext.getException();

	java.util.List errors = new java.util.ArrayList();
	request.setAttribute("com.ibm.commerce.exceptions", errors);

	while (exception.getCause() != null) {
		exception = exception.getCause();
		if (exception instanceof javax.servlet.ServletException) {
			exception = ((javax.servlet.ServletException) exception).getRootCause();
		}
		if (exception instanceof com.ibm.commerce.foundation.common.exception.AbstractSystemException
				|| exception instanceof com.ibm.commerce.foundation.common.exception.AbstractApplicationException 
				|| exception instanceof com.ibm.commerce.foundation.client.facade.bod.AbstractBusinessObjectDocumentException) {
			break;
		}
	}

	java.util.Map error = new java.util.HashMap();
	error.put("message", exception.getMessage());
	if (exception instanceof com.ibm.commerce.foundation.common.exception.AbstractSystemException) {
		error.put("code", ((com.ibm.commerce.foundation.common.exception.AbstractSystemException) exception).getErrorCode());
		response.setStatus(200);
	// it really shouldn't be an abstract application exception but just in case....
	} else if(exception instanceof com.ibm.commerce.foundation.common.exception.AbstractApplicationException)  {
		error.put("code", ((com.ibm.commerce.foundation.common.exception.AbstractApplicationException) exception).getErrorCode());
		response.setStatus(200);
	} else if(exception instanceof com.ibm.commerce.foundation.client.facade.bod.AbstractBusinessObjectDocumentException)  {
		java.util.List clientErrors = ((com.ibm.commerce.foundation.client.facade.bod.AbstractBusinessObjectDocumentException) exception).getClientErrors();
		if (clientErrors != null && clientErrors.size() > 0) {
			com.ibm.commerce.foundation.client.facade.bod.ClientError clientError = (com.ibm.commerce.foundation.client.facade.bod.ClientError) clientErrors.get(0);
			// Check if the client error has a message defined as a common exception.
			String message = com.ibm.commerce.foundation.client.facade.bod.servlet.config.URLtoBusinessObjectDocumentUtility.getInstance(pageContext.getServletContext()).getLocalizedCommonException(clientError.getErrorKey(),clientError.getLocale());
			error.put("code", clientError.getErrorKey());
			
			if (message != null && message.trim().length() > 0 ) {			
				error.put("message", message);
			} else {
				error.put("message", clientError.getLocalizedMessage());
			}
		}
		response.setStatus(200);
	} else {
		error.put("message", "Service request failed.");
		error.put("code", "500");
	}
	errors.add(error);


	// because the client does not process the content of a
	// server 500 response.
	//response.setStatus(200);

%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<errors>
	<c:forEach var="exception" items="${requestScope['com.ibm.commerce.exceptions']}">
		<exception code="${exception.code}"><wcf:cdata data="${exception.message}"/></exception>
	</c:forEach>
</errors>