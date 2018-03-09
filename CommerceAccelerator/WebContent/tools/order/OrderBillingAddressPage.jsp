

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
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
public String getAddressFieldValue(String fieldName, String address1, String address2, String address3, 
				String city, String region, String country, String postalCode, 
				String phoneNumber) {
				
			if (fieldName.equals("address1")) {
				return address1; 
			} else if (fieldName.equals("address2")) {
				return address2; 
			} else if (fieldName.equals("address3")) {
				return address3; 
			} else if (fieldName.equals("city")) {
				return city; 
			} else if (fieldName.equals("region")) {
				return region; 
			} else if (fieldName.equals("country")) {
				return country; 
			} else if (fieldName.equals("postalCode")) {
				return postalCode; 
			} else if (fieldName.equals("phoneNumber")) {
				return phoneNumber;
			} else
				return "";
				
				

}
public String getFormatAddress(Hashtable orderMgmtNLS, Hashtable localeAddrFormat, 
				String address1, String address2, String address3, 
				String city, String region, String country, String postalCode, 
				String phoneNumber, String emailAddress) {

	String newLine = "";
	
	for (int i=2; i<localeAddrFormat.size(); i++) {
		String addressLine = (String)XMLUtil.get(localeAddrFormat, "line" + i + ".elements");
		String[] addressFields = Util.tokenize(addressLine, ",");
		for (int j=0; j<addressFields.length; j++) {
			if (addressFields[j].equals("space")) {
				newLine += " "; 
			} else if (addressFields[j].equals("comma")) {
			
			   String nextAddrField = "";
			   int p = j+1;
			   while (p < addressFields.length) {
			      	if ((null != addressFields[p]) 
			      	&& !(addressFields[p].trim().equals("space")) 
			      	&& !(addressFields[p].trim().equals("comma"))) 
			      	{
			      		nextAddrField = addressFields[p].trim();
	     				break;
		      		
				} else
					p++;
			   
			   }
		   
		   

			   int q = j-1;
			   String prevAddrField = "";
			   while (q >= 0) {
 
			      	if ((null != addressFields[q]) 
			      	&& !(addressFields[q].trim().equals("space")) 
			      	&& !(addressFields[q].trim().equals("comma"))) 
			      	{
			      		prevAddrField = addressFields[q].trim();
	        			break;
				} else
					q--;
		   
			   }
		   

		   
			   if (!(nextAddrField.equals("")) && !(prevAddrField.equals("")))  {
			   
			   	String nextAddrFieldValue = getAddressFieldValue(nextAddrField, address1, address2, address3, city, region, country, postalCode, phoneNumber);
			   	String prevAddrFieldValue = getAddressFieldValue(prevAddrField, address1, address2, address3, city, region, country, postalCode, phoneNumber);
				if (!(nextAddrFieldValue.trim().equals("")) && !(prevAddrFieldValue.trim().equals(""))) 
					newLine += ","; 
			   }	
			} else if (addressFields[j].equals("address1")) {
				newLine += address1; 
			} else if (addressFields[j].equals("address2")) {
				newLine += address2; 
			} else if (addressFields[j].equals("address3")) {
				newLine += address3; 
			} else if (addressFields[j].equals("city")) {
				newLine += city; 
			} else if (addressFields[j].equals("region")) {
				newLine += region; 
			} else if (addressFields[j].equals("country")) {
				newLine += country; 
			} else if (addressFields[j].equals("postalCode")) {
				newLine += postalCode; 
			} else if (addressFields[j].equals("phoneNumber")) {
				newLine += UIUtil.toHTML((String)orderMgmtNLS.get("sPhone")) + " " + phoneNumber;
			}
		}
		newLine += "<BR>";
	}
	newLine += UIUtil.toHTML((String)orderMgmtNLS.get("bEmail")) + " " + emailAddress;
	newLine += "<BR><BR>";
	return newLine;

}

%>

     
      <%
      try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
      	Hashtable orderMgmtNLS = (Hashtable) ResourceDirectory.lookup("order.orderMgmtNLS", jLocale); 
      	Hashtable orderLabels  = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale); 
        
        boolean firstOrderExist = false;
        boolean secondOrderExist = false;
        
	JSPHelper jspHelper = new JSPHelper(request);
	String displayForOrder = jspHelper.getParameter("displayForOrder");
	String customerId 	= jspHelper.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
	String firstBillingAddressId	= jspHelper.getParameter("1stBillingAddressId");
	String firstOrderId		= jspHelper.getParameter("1stOrderId");
	if (firstOrderId != null && firstOrderId.length() != 0)
		firstOrderExist = true;
	String secondBillingAddresId	= jspHelper.getParameter("2ndBillingAddressId");
	String secondOrderId		= jspHelper.getParameter("2ndOrderId");
	if (secondOrderId != null && secondOrderId.length() != 0)
		secondOrderExist = true;
	String orderByParam 	= jspHelper.getParameter("orderby");
	
	if (orderByParam == null) {
		orderByParam = "";
	}
	
  	String xmlFile 	= jspHelper.getParameter("ActionXMLFile");
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;

 	AddressAccessBean addressbean = new AddressAccessBean();

	Vector alladdress = new Vector();
    
       	// find all the address entries with this customer
    	if (customerId != null && customerId.length() != 0) {
    		if (orderByParam.equals("nickName") || orderByParam.length() == 0) {
			for (Enumeration e = addressbean.findByMemberIdOrderByNickName(new Long(customerId)); e.hasMoreElements();) {
				//Create an AddressDataBean to be sure access to this data is ok for current user
				AddressAccessBean addr = (AddressAccessBean) e.nextElement();
				AddressDataBean addrDB = new AddressDataBean();
				addrDB.setAddressId(addr.getAddressId());
				com.ibm.commerce.beans.DataBeanManager.activate(addrDB, request);
				alladdress.addElement(addrDB);
			}
		} else if (orderByParam.equals("lastName")) {
			for (Enumeration e = addressbean.findByMemberIdOrderByLastName(new Long(customerId)); e.hasMoreElements();) {
				//Create an AddressDataBean to be sure access to this data is ok for current user
				AddressAccessBean addr = (AddressAccessBean) e.nextElement();
				AddressDataBean addrDB = new AddressDataBean();
				addrDB.setAddressId(addr.getAddressId());
				com.ibm.commerce.beans.DataBeanManager.activate(addrDB, request);
				alladdress.addElement(addrDB);
			}
		}
	}

	int allsize = alladdress.size();
	int actualsize = 0;

	String[] addrType = new String[allsize];	
	Vector addrId = new Vector();
	Vector nickName = new Vector();
	Vector lastName = new Vector();
	Vector firstName = new Vector();
	Vector address1 = new Vector();
	Vector address2 = new Vector();
	Vector address3 = new Vector();
	Vector city = new Vector();
	Vector region = new Vector();
	Vector country = new Vector();
	Vector postalCode = new Vector();
	Vector phoneNumber = new Vector();
	Vector emailAddr = new Vector();
	int primIndex = -1;

	String defaultAddressId = "";
	for (int i = 0; i < allsize; i++) {
		addrType[i] = ((AddressDataBean)alladdress.elementAt(i)).getAddressType();
	        if (addrType[i].equals(ECUserConstants.EC_ADDR_RESIDENTIAL) || 
				addrType[i].equals(ECUserConstants.EC_ADDR_SHIPPINGBILLING) || 
				addrType[i].equals(ECUserConstants.EC_ADDR_BILLING)) {
											
			if (((AddressDataBean)alladdress.elementAt(i)).getAddressId() != null) {
				String tempAddrId = ((AddressDataBean)alladdress.elementAt(i)).getAddressId();
				addrId.addElement(tempAddrId);
				if (addrType[i].equals(ECUserConstants.EC_ADDR_RESIDENTIAL)) 
					defaultAddressId = tempAddrId;
			} else {
				addrId.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getNickName() != null) {
				nickName.addElement(((AddressDataBean)alladdress.elementAt(i)).getNickName());
			} else {
				nickName.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getLastName() != null) {
				lastName.addElement(((AddressDataBean)alladdress.elementAt(i)).getLastName());
			} else {
				lastName.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getFirstName() != null) {
				firstName.addElement(((AddressDataBean)alladdress.elementAt(i)).getFirstName());
			} else {
				firstName.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getAddress1() != null) {
				address1.addElement(((AddressDataBean)alladdress.elementAt(i)).getAddress1());
			} else {
				address1.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getAddress2() != null) {
				address2.addElement(((AddressDataBean)alladdress.elementAt(i)).getAddress2());
			} else {
				address2.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getAddress3() != null) {
				address3.addElement(((AddressDataBean)alladdress.elementAt(i)).getAddress3());
			} else {
				address3.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getCity() != null) {
				city.addElement(((AddressDataBean)alladdress.elementAt(i)).getCity());
			} else {
				city.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getState() != null) {
				region.addElement(((AddressDataBean)alladdress.elementAt(i)).getState());
			} else {
				region.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getCountry() != null) {
				country.addElement(((AddressDataBean)alladdress.elementAt(i)).getCountry());
			} else {
				country.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getZipCode() != null) {
				postalCode.addElement(((AddressDataBean)alladdress.elementAt(i)).getZipCode());
			} else {
				postalCode.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getPhone1() != null) {
				phoneNumber.addElement(((AddressDataBean)alladdress.elementAt(i)).getPhone1());
			} else {
				phoneNumber.addElement("");
			}
			if (((AddressDataBean)alladdress.elementAt(i)).getEmail1() != null) {
				emailAddr.addElement(((AddressDataBean)alladdress.elementAt(i)).getEmail1());
			} else {
				emailAddr.addElement("");
			}
	
			if (((AddressDataBean)alladdress.elementAt(i)).getPrimary().equals("1")) {
				primIndex = i;
			}
		        actualsize++;
	        }
 	}
	Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
     	Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

     	if (localeAddrFormat == null) {
		localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
	}
	
	
	int totalsize = actualsize;
	int totalpage = 0;
	if (listSize > 0) {
		totalpage = totalsize / listSize;
	}

Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
 %>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("billingAddressPage")) %></title>     
      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
      <script type="text/javascript">
	<!-- <![CDATA[
      	var order;
      	var address;
	<% if (displayForOrder == null || displayForOrder.length() == 0) { %>
      		order = parent.parent.get("order");
      		address = parent.parent.get("address");
      	<% } else {%>
      		order = parent.parent.parent.get("order");
      		address = parent.parent.parent.get("address");
      	<% } %>
      	
      	var customerId = order["customerId"];
      
      	var billingAddressId = "";
      	<% if (firstOrderExist) { %>
      		var firstOrder = order.firstOrder;
      		if (defined(firstOrder))
     			billingAddressId = firstOrder.billingAddressId;   
 	<% } else { %>
 		var secondOrder = order.secondOrder;
 	 	if (defined(secondOrder))
 			billingAddressId = secondOrder.billingAddressId;
 	<% } %>
 	
        function onLoad()
        {
        	parent.setInstruction('<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("billingAddressInstruction"))%>');
		parent.loadFrames();
		loadPanelData();
		
		//Clean up the XML
		<% if (displayForOrder == null || displayForOrder.length() == 0) { %>
			parent.parent.remove("orderItem");
			parent.parent.remove("address");
      		<% } else {%>
			parent.parent.parent.remove("orderItem");
			parent.parent.parent.remove("address");
     	 	<% } %>
     	 	
     	 	


        }
        
        function getResultsSize() {
        	return <%=totalsize%>;
	}

	function loadPanelData() {
				
		var addressEle = document.BillingAddressListFORM.elements;
		if (billingAddressId != "") {
			for (var i=0; i<addressEle.length; i++) {
				if (addressEle[i].name == billingAddressId) {
					addressEle[i].checked = true;
				}
			}
		} else if ("<%=defaultAddressId%>" != "" ) {
			for (var i=0; i<addressEle.length; i++) {
				if (addressEle[i].name == "<%=defaultAddressId%>") {
					addressEle[i].checked = true;
					selectOne(addressEle[i].name);
					break;
				}
			}
		} else if ("<%=totalsize%>" != "0" && "<%=primIndex%>" != "-1") {
			selectOne(addressEle[<%=primIndex%>].name);
		}
		
	}
	

	function getBillingAddressId() {
		return billingAddressId;
	}

	function launchNewBillingAddress() {
	
		<% if (displayForOrder == null || displayForOrder.length() == 0) { %>
			// save parent.parent "model" to TOP frame before calling 2nd wizard
			top.saveModel(parent.parent.model);

			// set returning panel to be current panel
			top.setReturningPanel(parent.parent.getCurrentPanelAttribute("name"));
		<% } else { %>
			top.saveModel(parent.parent.parent.model);
			
			top.setReturningPanel(parent.parent.parent.getCurrentPanelAttribute("name"));
		<% } %>

		// launch add products 
		top.setContent("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("newBillingAddressTrail")) %>", 
			       "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderNewBillingAddressDialog", true);

	}

	function savePanelData() {
		<% if (firstOrderExist) { %>
			var firstOrder = order.firstOrder;
		    	if (!defined(firstOrder)) {
		    		firstOrder = new Object();
		    		updateEntry(order, "firstOrder", firstOrder);
		    	} 
		    	firstOrder.billingAddressId = getBillingAddressId();
	 	<% } %>
	 	<% if (secondOrderExist) { %>
		 	var secondOrder = order.secondOrder;
		 	 if (!defined(secondOrder)) {
		 	 	secondOrder = new Object();
		 	 	updateEntry(order, "secondOrder", secondOrder);
		 	 }
		 	 secondOrder.billingAddressId = getBillingAddressId();
 		<% } %>
 		
 		var authToken = parent.parent.get("authToken");
		if (defined(authToken)) {
			parent.parent.addURLParameter("authToken", authToken);
		}
	}

	function validatePanelData() {
		return true;
	}

	function validateNoteBookPanel() {
		return validatePanelData();

	}

	function selectOne(addressId) {
		
		if (billingAddressId == addressId)
			billingAddressId = "";
		else
			billingAddressId = addressId;
		
		for (var i=0; i<document.BillingAddressListFORM.elements.length; i++) {
			if (billingAddressId != document.BillingAddressListFORM.elements[i].name) {
				document.BillingAddressListFORM.elements[i].checked = false;
			} 
		}
		order.billingAddressId = billingAddressId;

	}
     
     	function debugAlert(msg) {
//     		alert("DEBUG: " + msg);
     	}
	  //[[>-->    
      </script>
      
    </head>
<!--Support For Customers,Shopping Under Multiple Accounts. -->
<body class="content">
<%= comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale) %>
<form name="BillingAddressListFORM">
<%request.setAttribute("resourceBundle", orderAddProducts);%> 
<jsp:include page="ActiveOrganization.jsp"
	flush="true" /> 
	<br />
	<input type="hidden" name="URL" value="" /> 
	<input type="hidden" name="XML" value="" />
	<input type="hidden" name="billingAddressId" value="" />
	<input type="hidden" name="customerId" value="" />
        
	<%= comm.startDlistTable((String)orderMgmtNLS.get("billingAddressTableSummary")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading(false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("bNickName"), "nickName", orderByParam.equals("nickName")) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("bLastName"), "lastName", orderByParam.equals("lastName")) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("bFirstName"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("bBillingAddress"), null, false) %>
	<%= comm.endDlistRow() %>
	
	<%
	if (totalsize != 0) {
		if (endIndex > actualsize) {
			endIndex = actualsize;
		}
	} else {
		endIndex = 0;
	}
	
	
	//TABLE CONTENT
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
	%>
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck(addrId.elementAt(i).toString(), "selectOne('" + addrId.elementAt(i) + "')") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(nickName.elementAt(i).toString()), "none") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(lastName.elementAt(i).toString()), "none") %>
			<%= comm.addDlistColumn(UIUtil.toHTML(firstName.elementAt(i).toString()), "none") %>
			<%
			String formatAddress = getFormatAddress(orderMgmtNLS, localeAddrFormat, 
						(String)address1.elementAt(i), 
						(String)address2.elementAt(i), 
						(String)address3.elementAt(i), 
						(String)city.elementAt(i), 
						(String)region.elementAt(i), 
						(String)country.elementAt(i), 
						(String)postalCode.elementAt(i), 
						(String)phoneNumber.elementAt(i),
						(String)emailAddr.elementAt(i));
			%>			
			<%= comm.addDlistColumn(UIUtil.toHTML(formatAddress), "none") %>		
		<%= comm.endDlistRow() %>
		
		<%
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
	%>
	
	<%= comm.endDlistTable() %>
	
<%
	if (totalsize == 0) {
%>

<p></p><p></p>
<table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%= orderMgmtNLS.get("noAddressToList") %>
	</td>
</tr>
</table>	
<% }
%>	
</form>

   <script type="text/javascript">
	<!-- <![CDATA[
           parent.afterLoads();
           parent.setResultssize(getResultsSize());
       //[[>-->
   </script>

   <script type="text/javascript">
	<!-- <![CDATA[
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