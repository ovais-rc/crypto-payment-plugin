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
com.ibm.commerce.beans.*,
com.ibm.commerce.messaging.util.*,
com.ibm.commerce.order.beans.*,
com.ibm.commerce.order.objects.*,
com.ibm.commerce.inventory.beans.*,
com.ibm.commerce.inventory.commands.*,
com.ibm.commerce.inventory.objects.*" %><%
   

   // Get the PickBatch Reference Number passed in by PickBatchCreate command.
   JSPHelper JSPHelp = new JSPHelper(request);
   //String pickBatchId = JSPHelp.getParameter(InventoryConstants.PICKBATCH_ID);
   String backendPickBatchId = JSPHelp.getParameter(ICIConstants.ICI_BACKEND_PICKBATCH_ID);
   //String morePickBatch = JSPHelp.getParameter(InventoryConstants.MOREORDERRELEASES);

   String languageId = JSPHelp.getParameter(InventoryConstants.LANGUAGE_ID);

   
   // Generate Order Create Message Header Information
   out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
   out.println("<!DOCTYPE Response_WCS_PickBatch SYSTEM \"Response_WCS_PickBatch_10.dtd\">");
   out.println("<Response_WCS_PickBatch version=\"1.0\">");
   out.println("<ControlArea>");
   out.println("     <Verb value=\"Response\"> </Verb>");
   out.println("     <Noun value=\"WCS_PickBatch\"> </Noun>");
   out.println("</ControlArea>");
   out.println("<DataArea>");
   out.print("     <ResponseStatus status=\"ERROR\" code=\"");

   try
   {
	ErrorDataBean errorBean = new ErrorDataBean (); 
	com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);
	
	out.println(errorBean.getMessageKey() + "\" >");
        out.println("     ExceptionData: " + errorBean.getExceptionData());
	out.println("     " + errorBean.getMessage() );
	
   }catch (Exception e) {
        out.println("Unexpected_Error\" >");
   }

   out.println("     </ResponseStatus>");

   out.println("</DataArea>");
   out.println("</Response_WCS_PickBatch>");
   
%>
