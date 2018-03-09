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
   

   // Get the PickBatch Reference Number passed in by GetPickPackListDetail command.
   JSPHelper JSPHelp = new JSPHelper(request);
   String pickBatchId = JSPHelp.getParameter(InventoryConstants.PICKBATCH_ID);
   //String pickBatchId = JSPHelp.getParameter(ICIConstants.ICI_PICKBATCH_ID);
   String languageId = JSPHelp.getParameter(InventoryConstants.LANGUAGE_ID);

   try {
   
   // Generate Order Create Message Header Information
   out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
   out.println("<!DOCTYPE Report_WCS_PickPackListDetail SYSTEM \"Report_WCS_PickPackListDetail_20.dtd\">");
   out.println("<Report_WCS_PickPackListDetail version=\"2.0\">");
   out.println("<ControlArea>");
   out.println("     <Verb value=\"Report\"> </Verb>");
   out.println("     <Noun value=\"WCS_PickPackListDetail\"> </Noun>");
   out.println("</ControlArea>");
   out.println("<DataArea>");
   out.println("     <ResponseStatus status=\"OK\" />");

   out.println("     <PickPackListReport>");

   String pickSlipXML = null; 
   
   PickBatchAccessBean pbBean = new PickBatchAccessBean();
   pbBean.setInitKey_pickBatchId(pickBatchId);
   
   pickSlipXML = pbBean.getPickSlipXml();
   
   out.println(pickSlipXML);

   
   	OrderReleaseAccessBean orb = new OrderReleaseAccessBean();
        Enumeration orbList = orb.findByPickBatchId(new Long(pickBatchId));

        while (orbList != null && orbList.hasMoreElements() )
        {

	        OrderReleaseAccessBean aBean = (OrderReleaseAccessBean) orbList.nextElement();
	        String packSlipXML = null;
                packSlipXML = aBean.getPackSlipXml();
		out.println(packSlipXML);
        }

   out.println("     </PickPackListReport>");
   out.println("</DataArea>");
   out.println("</Report_WCS_PickPackListDetail>");
   } catch (Exception e) {
      out.println("Exception => " + e);
   };
%>
