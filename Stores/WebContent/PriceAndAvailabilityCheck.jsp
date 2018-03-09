<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%><%@ page import="javax.servlet.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.messaging.util.*,
com.ibm.commerce.messaging.utils.MessagingUtilities,
com.ibm.commerce.messaging.priceandavailabilityrequest.*,
java.io.ByteArrayOutputStream,
java.io.UnsupportedEncodingException,
com.ibm.etools.xmlschema.beans.DOMWriter" %><%
try
{
   response.setContentType("text/html;charset=UTF-8");
   // Get the requestObj passed in by TransferShopcartCmdImpl task command.
   JSPHelper JSPHelp = new JSPHelper(request);
   com.ibm.commerce.datatype.TypedProperty reqProperties = (com.ibm.commerce.datatype.TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);
   com.ibm.commerce.domain.order.PriceAndAvailabilityRequest requestObj = (com.ibm.commerce.domain.order.PriceAndAvailabilityRequest) reqProperties.get("requestObj");   

   java.util.Hashtable result = new java.util.Hashtable();
	        //com.ibm.commerce.messaging.priceandavailabilityrequest.priceAndAvailabilityRequest xsdBean =
   result = PriceAndAvailabilityRequestConverter.convertRequestObjectToXSDBean(requestObj);
   com.ibm.commerce.messaging.priceandavailabilityrequest.priceAndAvailabilityRequest xsdBean = (priceAndAvailabilityRequest)(result.get("request"));
   priceAndAvailabilityRequestFactory factory = (priceAndAvailabilityRequestFactory)(result.get("factory"));
   
   java.io.ByteArrayOutputStream outStream = new java.io.ByteArrayOutputStream();
   new DOMWriter(factory.getDocument(),outStream,factory.getEncoding(),factory.getEncodingTag(),null);


		byte[] bytes = outStream.toByteArray();
		String str = (new String(bytes, "UTF-8")).trim();			
		out.write(str);


} catch (Exception e) { out.print( "Exception =>" + e); }
%>
