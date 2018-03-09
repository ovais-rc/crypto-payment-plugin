<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 041201           PY        Initial create
////////////////////////////////////////////////////////////////////////////////
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its reliability, 
//* serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands and products 
//* in order to illustrate concepts as completely as possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by actual persons 
//* or business enterprises is entirely coincidental.
//*--------------------------------------------------------------------------------------

//* This JSP file provides sample content for the NoURL view. If the command requires a
//* URL, use the NoURL view as the redirect URL when the command completes successfully.
//* This is the default behavior. If the message is sent over MQ, then the view is
//* ignored. If the message is sent over HTTP, then the backend system might require
//* a redirect URL (not necessarily noURL) to continue processing.
--%><%@ page 
import="com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
java.util.*,
com.ibm.commerce.ras.ECTrace,
com.ibm.commerce.ras.ECTraceIdentifiers" 
language="java" 
session="false"
contentType="text/html; charset=UTF-8"%><%

try {

  String localeString = null;
  Locale locale = Locale.getDefault();
  CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
  if( aCommandContext!= null )
  {
     locale = aCommandContext.getLocale();
     localeString = locale.toString();
  }
  ResourceBundle nls = ResourceBundle.getBundle("com/ibm/commerce/ras/properties/ecServerMessages", locale);
  String message = nls.getString("_STA_CMD_EXECUTED_CMD");

  int index = message.indexOf("\"{0}\"");

  if (index != -1) {
    message = message.substring(0,index);// + commandName + message.substring(index +3);
  }

  out.println(message); 

} catch (Exception e) {

  System.out.println ("An exception occurred.  Enable the COMPONENT_SERVER trace to see the exception details.");
  if(ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_SERVER)){
     e.printStackTrace();
  }

}
%>
