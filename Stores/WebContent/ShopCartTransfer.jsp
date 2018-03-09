<%
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
%><%@ page import="javax.servlet.*, 
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.messaging.util.*,
com.ibm.commerce.messaging.utils.MessagingUtilities,
com.ibm.commerce.messaging.shoppingcarttransfer.*,
java.io.ByteArrayOutputStream,
java.io.UnsupportedEncodingException,
com.ibm.etools.xmlschema.beans.DOMWriter" %><%
try
{

   response.setContentType("text/html;charset=UTF-8");
   // Get the requestObj passed in by TransferShopcartCmdImpl task command.
   JSPHelper JSPHelp = new JSPHelper(request);
   com.ibm.commerce.datatype.TypedProperty reqProperties = (com.ibm.commerce.datatype.TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);
   com.ibm.commerce.domain.order.ShoppingCartTransferRequest requestObj = (com.ibm.commerce.domain.order.ShoppingCartTransferRequest)reqProperties.get("requestObj");   

   java.util.Hashtable result = new java.util.Hashtable();			
   result = ShoppingCartTransferRequestConverter.convertRequestObjectToXSDBean(requestObj);					
   com.ibm.commerce.messaging.shoppingcarttransfer.shoppingCartTransferRequest xsdBean = (shoppingCartTransferRequest)(result.get("request"));
   java.io.ByteArrayOutputStream outStream = new java.io.ByteArrayOutputStream();  
   shoppingCartTransferRequestFactory factory = (shoppingCartTransferRequestFactory)(result.get("factory"));
			
   new DOMWriter(factory.getDocument(),outStream,factory.getEncoding(),factory.getEncodingTag(),null);

   byte[] bytes = outStream.toByteArray();
   String str = new String(bytes, "UTF-8");          
   out.write(str);


} catch (Exception e) { out.print( "Exception =>" + e); }

%>
