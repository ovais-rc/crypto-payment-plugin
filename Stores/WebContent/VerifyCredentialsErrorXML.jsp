<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%> 

<% 
	response.setContentType("text/xml");

  	com.ibm.commerce.server.JSPHelper jsphelper = new com.ibm.commerce.server.JSPHelper(request);


%><?xml version="1.0" encoding="UTF-8"?>
<WCS_Error type="Credentials">
	<<%= com.ibm.commerce.server.ECConstants.EC_ERROR_CODE %>><%= request.getAttribute(com.ibm.commerce.server.ECConstants.EC_ERROR_CODE) %></<%= com.ibm.commerce.server.ECConstants.EC_ERROR_CODE %>>  
</WCS_Error>