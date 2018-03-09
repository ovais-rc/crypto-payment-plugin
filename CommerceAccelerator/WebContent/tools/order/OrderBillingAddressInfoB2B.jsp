<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<%@ page language="java"
	 import="java.util.*,
	 	 com.ibm.commerce.tools.util.*,
	 	 com.ibm.commerce.tools.test.*,
	         com.ibm.commerce.server.*,
	         com.ibm.commerce.beans.*,
	         com.ibm.commerce.order.beans.*,
	         com.ibm.commerce.order.objects.*,
	         com.ibm.commerce.price.utils.*,    
	         com.ibm.commerce.user.beans.*,
	         com.ibm.commerce.user.objects.*,
	         com.ibm.commerce.tools.optools.order.helpers.*,
	         com.ibm.commerce.tools.optools.order.beans.*,
		 com.ibm.commerce.tools.optools.order.commands.*,
		 com.ibm.commerce.usermanagement.commands.*,
	         com.ibm.commerce.fulfillment.objects.*,
	         com.ibm.commerce.command.*,
	         com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%!
public String getFormatAddress(Hashtable orderMgmtNLS, Hashtable localeAddrFormat, 
				Hashtable addressInfo) {

	
	String newLine = "";
	
	try {
		
		for (int i=2; i<localeAddrFormat.size(); i++) {
			
			String addressLine = (String)XMLUtil.get(localeAddrFormat, "line" + i + ".elements");
			String[] addressFields = Util.tokenize(addressLine, ",");
			for (int j=0; j<addressFields.length; j++) {
				
				if (addressFields[j].equals("space")) {
					newLine += " "; 
				} else if (addressFields[j].equals("comma")) {
					newLine += ","; 
				} else if (addressFields[j].equals("address1")) {
					newLine += (String)addressInfo.get("address1"); 
				} else if (addressFields[j].equals("address2")) {
					newLine += (String)addressInfo.get("address2"); 
				} else if (addressFields[j].equals("address3")) {
					newLine += (String)addressInfo.get("address3");
				} else if (addressFields[j].equals("city")) {
					newLine += (String)addressInfo.get("city"); 
				} else if (addressFields[j].equals("region")) {
					newLine += (String)addressInfo.get("region"); 
				} else if (addressFields[j].equals("country")) {
					newLine += (String)addressInfo.get("country"); 
				} else if (addressFields[j].equals("postalCode")) {
					newLine += (String)addressInfo.get("postalCode"); 
				} else if (addressFields[j].equals("phoneNumber")) {
					newLine += UIUtil.toHTML((String)orderMgmtNLS.get("bPhone")) + " " + (String)addressInfo.get("phoneNumber");
				}
			
			}
			newLine += "<BR>";
		
		}
		newLine += UIUtil.toHTML((String)orderMgmtNLS.get("bEmail")) + " " + (String)addressInfo.get("email");
		
		newLine += "<BR><BR>";
	} catch (Exception ex) {
		newLine += "Billing address information is not available.";
	}
	
	return newLine;
	
}

%>

     
      <%
      try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
      	Hashtable orderMgmtNLS = (Hashtable) ResourceDirectory.lookup("order.orderMgmtNLS", jLocale); 
      	Hashtable orderLabels  = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale); 
            
	JSPHelper jspHelper = new JSPHelper(request);
	String displayForOrder = jspHelper.getParameter("displayForOrder");
	String customerId 	= jspHelper.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
	String billingAddressId	= jspHelper.getParameter("billingAddressId");

	Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
     	Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

     	if (localeAddrFormat == null) {
		localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
	}
	
	Hashtable addressInfo = new Hashtable();
	
	AddressDataBean addr = new AddressDataBean();
	addr.setAddressId(billingAddressId);
	DataBeanManager.activate(addr, request);
	
	if (addr.getAddress1() != null)
		addressInfo.put("address1", addr.getAddress1());
	else
		addressInfo.put("address1", "");
	if (addr.getAddress2() != null)
		addressInfo.put("address2", addr.getAddress2());
	else
		addressInfo.put("address2", "");
	if (addr.getAddress3() != null)
		addressInfo.put("address3", addr.getAddress3());
	else
		addressInfo.put("address3", "");
	if (addr.getCity() != null)
		addressInfo.put("city", addr.getCity());
	else
		addressInfo.put("city", "");
	if (addr.getState() != null)
		addressInfo.put("region", addr.getState());
	else
		addressInfo.put("region", "");	
	if (addr.getCountry() != null)
		addressInfo.put("country", addr.getCountry());
	else
		addressInfo.put("country", "");
	if (addr.getZipCode() != null)
		addressInfo.put("postalCode", addr.getZipCode());
	else
		addressInfo.put("postalCode", "");
	if (addr.getPhone1() != null)
		addressInfo.put("phoneNumber", addr.getPhone1());
	else
		addressInfo.put("phoneNumber", "");
	if (addr.getEmail1() != null )
		addressInfo.put("email", addr.getEmail1());
	else
		addressInfo.put("email", "");
		
	String displayInfo = getFormatAddress(orderMgmtNLS, localeAddrFormat, addressInfo);
 %>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
       
<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("billingAddressPage")) %></title>     
      <script type="text/javascript">
	<!-- <![CDATA[
      
        function onLoad()
        {
        }
	

	function savePanelData() {
		return true;
	}

	function validatePanelData() {
		return true;
	}

	function validateNoteBookPanel() {
		return validatePanelData();

	}
     
     	function debugAlert(msg) {
//     		alert("DEBUG: " + msg);
     	}
		//[[>-->    
      </script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    </head>

<body class="content">
	<% if (displayForOrder == null || displayForOrder.length() == 0) {%>
		<h1><%= UIUtil.toHTML( (String)orderMgmtNLS.get("billingAddressInfo")) %></h1>
	<% } %>
<script type="text/javascript">
	<!-- <![CDATA[
	document.write("<%=displayInfo%>");
	//[[>-->
</script>
<script type="text/javascript">
	<!-- <![CDATA[
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //[[>-->
</script>

<%
      } catch (Exception e)	{
      
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
      }
    %>
    
    </body>
  </html>
