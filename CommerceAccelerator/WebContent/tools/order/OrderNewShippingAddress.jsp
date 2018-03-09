<%--
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
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<jsp:useBean class="com.ibm.commerce.tools.taxation.databeans.StateProvBean" id="StateProvBean" scope="request">  
<% com.ibm.commerce.beans.DataBeanManager.activate(StateProvBean, request); %></jsp:useBean>
<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 	
	
	//Return if the address field is required
	public boolean ifAddressFieldRequired(Hashtable addrField) {
	
		try {
			if (null == addrField)
				return false;
				
			if (null == addrField.get(ECUserConstants.EC_RB_REQUIRED))
				return false;
			
			if (((Boolean)addrField.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
				return true;
			
		} catch (Exception ex) {
			
		}
		
		return false;
		
	}
	
	
%>

<%-- 
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>

<%
try {

	//Get resource bundle for displaying text on the page
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContextLocale.getLocale();
	Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	UIUtil convert = null;
     
	JSPHelper jspHelp = new JSPHelper(request);
	String strProfileType = jspHelp.getParameter(ECUserConstants.EC_USER_PROFILETYPE);
	UserRegistrationDataBean bnRegister = new UserRegistrationDataBean();
   	//bnRegister.setProfileType(strProfileType);
   	com.ibm.commerce.beans.DataBeanManager.activate (bnRegister, request);

   	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
   	bnResourceBundle.setPropertyFileName("Address_" + jLocale);
   	com.ibm.commerce.beans.DataBeanManager.activate(bnResourceBundle, request);

   	Hashtable hshRegister = bnResourceBundle.getPropertyHashtable();

   	ErrorDataBean bnError = new ErrorDataBean();
   	com.ibm.commerce.beans.DataBeanManager.activate (bnError, request);
   	
   	CountryListDataBean countryNames = new CountryListDataBean();
	com.ibm.commerce.beans.DataBeanManager.activate(countryNames, request);
   	String[][] nameList = countryNames.getCountryList();
   	
   	String countryName = request.getParameter("countryName");
    String [] areStates = StateProvBean.getState(countryName);
    String selectBoxHtmlForState = "";
    if(areStates!=null)
    {
        for (int i=0; i < areStates.length; i++) 
        {
            String selectBoxHtmlForPartState ="<option value = \"";
            if(areStates[i] == null){ break; }
            String states = areStates[i].replaceAll("'","\\\\'");
            selectBoxHtmlForPartState = selectBoxHtmlForPartState + states + "\">" + states+ "</option>" ;
            selectBoxHtmlForState = selectBoxHtmlForState + selectBoxHtmlForPartState;
        }
    }

	String NickNameURL = bnRegister.getNickNameURL();
   	String FirstNameURL = bnRegister.getFirstNameURL();
   	String LastNameURL  = bnRegister.getLastNameURL();
   	String Address1URL  = bnRegister.getAddress1URL();
   	String Address2URL  = bnRegister.getAddress2URL();
   	String CityURL      = bnRegister.getCityURL();
   	String StateURL     = bnRegister.getStateURL();
   	String CountryURL   = bnRegister.getCountryURL();
   	String ZipCodeURL   = bnRegister.getZipCodeURL();
   	String Phone1URL    = bnRegister.getPhone1URL();
   	String Email1URL    = bnRegister.getEmail1URL();
 

   	Hashtable hshFirstName = null;
   	Hashtable hshLastName  = null;
   	Hashtable hshAddress1  = null;
   	Hashtable hshAddress2  = null;
   	Hashtable hshCity      = null;
   	Hashtable hshState     = null;
   	Hashtable hshCountry   = null;
   	Hashtable hshZipCode   = null;
   	Hashtable hshPhone1    = null;
   	Hashtable hshEmail1    = null;

	if (hshRegister != null) {
		hshFirstName = (Hashtable)hshRegister.get(FirstNameURL);
		hshLastName  = (Hashtable)hshRegister.get(LastNameURL);
		hshAddress1  = (Hashtable)hshRegister.get(Address1URL);
		hshAddress2  = (Hashtable)hshRegister.get(Address2URL);
		hshCity      = (Hashtable)hshRegister.get(CityURL);
		hshState     = (Hashtable)hshRegister.get(StateURL);
		hshCountry   = (Hashtable)hshRegister.get(CountryURL);
		hshZipCode   = (Hashtable)hshRegister.get(ZipCodeURL);
		hshPhone1    = (Hashtable)hshRegister.get(Phone1URL);
		hshEmail1    = (Hashtable)hshRegister.get(Email1URL);
	}

%>

<html>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
	
   <title><%= UIUtil.toHTML((String)orderMgmtNLS.get("newShippingAddressTitle")) %></title>
   	<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
   	<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
   	<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
   	<script language="javascript" type="text/javascript">
     <!-- <![CDATA[

     	var model = top.getModel(1);
	var order = model["order"];

     	var customerId = order["customerId"];

     	var address = new Address();
	model["address"] = address;
     	var sAHTML = address;      
 
	sAHTML.nickName = sAHTML.nickName.replace(/\"/g, "&quot;");
	sAHTML.firstName = sAHTML.firstName.replace(/\"/g, "&quot;");
      sAHTML.lastName = sAHTML.lastName.replace(/\"/g, "&quot;");
      sAHTML.address1 = sAHTML.address1.replace(/\"/g, "&quot;");
      sAHTML.address2 = sAHTML.address2.replace(/\"/g, "&quot;");
      sAHTML.city = sAHTML.city.replace(/\"/g, "&quot;");
      sAHTML.region = sAHTML.region.replace(/\"/g, "&quot;");
      sAHTML.country = sAHTML.country.replace(/\"/g, "&quot;");
      sAHTML.postalCode = sAHTML.postalCode.replace(/\"/g, "&quot;");
      sAHTML.phoneNumber = sAHTML.phoneNumber.replace(/\"/g, "&quot;");
      sAHTML.email = sAHTML.email.replace(/\"/g, "&quot;");


      /****************************************************************************
      * Save all required state information.
      * return - always returns TRUE
      ****************************************************************************/
      function savePanelData()
      { 
        var shipAddrForm       = document.shippingAddress;

        // Save shipping address
        updateEntry(address, "nickName", shipAddrForm.nickName.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "firstName", shipAddrForm.firstName.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "lastName",  shipAddrForm.lastName.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "address1",  shipAddrForm.address1.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "address2",  shipAddrForm.address2.value.replace(/(\s+~$|^\s+)/g, ""));

        updateEntry(address, "city",   shipAddrForm.city.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "region", shipAddrForm.region.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "country",shipAddrForm.country.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "postalCode", shipAddrForm.postalCode.value.replace(/(\s+~$|^\s+)/g, ""));

        updateEntry(address, "phoneNumber", shipAddrForm.phoneNumber.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "email",       shipAddrForm.email.value.replace(/(\s+~$|^\s+)/g, ""));
        updateEntry(address, "addrType", "SB");
	
	parent.put("order", order);
	parent.put("address", address);
        return(true);

      }// END savePanelData

      function isValidLength(fieldName, maxLen) {
         if (fieldName.value != "") {
            if (!isValidUTF8length(fieldName.value, maxLen)) {
               alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
               fieldName.select();
               return false;
            }
         }
         return true;
      }

      function validateInputLength() {
	   if (!isValidLength(document.shippingAddress.nickName, 254))
         	return false;
         if (!isValidLength(document.shippingAddress.firstName, 128))
         	return false;
         if (!isValidLength(document.shippingAddress.lastName, 128))
         	return false;
         if (!isValidLength(document.shippingAddress.address1, 50))
         	return false;
         if (!isValidLength(document.shippingAddress.address2, 50))
         	return false;
         if (!isValidLength(document.shippingAddress.city, 128))
         	return false;
         if (!isValidLength(document.shippingAddress.country, 128))
         	return false;
         if (!isValidLength(document.shippingAddress.region, 128))
         	return false;
         if (!isValidLength(document.shippingAddress.postalCode, 40))
         	return false;
         if (!isValidLength(document.shippingAddress.phoneNumber, 32))
         	return false;
         if (!isValidLength(document.shippingAddress.email, 256))
         	return false;
         	
         return true;
      }

      function validateInputLengthOnChange(fieldName, maxLen) {
         isValidLength(fieldName, maxLen);
      }

      function validatePanelData() {    

          mandatoryFields = address.mandatoryFields.split(",");
          for (var i=0; i<mandatoryFields.length; i++) {
             if ( address[mandatoryFields[i]] == ""  ) {
                displayAlert(mandatoryFields[i]);
                return false;
             }           
          }
       
          if ( (address.email != "") && (find(address.email, "@") == "false") ) {
             displayAlert("invalidEmail");
             return false;
          }
            
          if (!validateInputLength())
		return false;

         return true;
      }

      function initializeState() {
        checkForErrors();
       	parent.setContentFrameLoaded(true);
       	var addressInfo = parent.get("addressInfo");
       	if (addressInfo != null)
	    {	      
	      document.shippingAddress.nickName.value = addressInfo.nickName;
		  document.shippingAddress.firstName.value = addressInfo.firstName; 
		  document.shippingAddress.lastName.value = addressInfo.lastName;     	 
		  document.shippingAddress.address1.value = addressInfo.address1;
		  document.shippingAddress.address2.value = addressInfo.address2;
		  document.shippingAddress.city.value = addressInfo.city;
		  document.shippingAddress.country.value = addressInfo.country; 		 
		  document.shippingAddress.postalCode.value = addressInfo.postalCode; 
		  document.shippingAddress.phoneNumber.value = addressInfo.phoneNumber;     
		  document.shippingAddress.email.value = addressInfo.email; 
		  document.shippingAddress.postalCode.value = addressInfo.postalCode;
	      	      
	     <% if (areStates == null) { %>
			document.shippingAddress.region.value  = addressInfo.region;
	     <% } else { %>
	     	     var selectOne = false;
	             for (var i = 0; i < document.ffcForm.region.length; i++) {
	             	if (document.shippingAddress.region.options[i].value == addressInfo.state) {
	             		document.shippingAddress.region.options[i].selected = true;
	             		selectOne = true;
	             		break;
	             	}
	             }
	             if (!selectOne)
	             	document.shippingAddress.region.options[0].selected = true; 
	      <% } %>
	             
	    }
       	 
      }
      
      function checkForErrors() {
         if ( defined(parent.getErrorParams()) ) {
            errorCode = parent.getErrorParams();
            displayAlert(errorCode);
         }
      }
      
      function displayAlert(errorField) {
	   if (errorField == "nickName") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingNickNameMsg")) %>");
            document.shippingAddress.nickName.focus();
         } else if (errorField == "firstName") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingFirstNameMsg")) %>");
            document.shippingAddress.firstName.focus();
         } else if (errorField == "lastName") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingLastNameMsg")) %>");
            document.shippingAddress.lastName.focus();
         } else if (errorField == "address1") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingAddressMsg")) %>");
            document.shippingAddress.address1.focus();
         } else if (errorField == "city") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingCityMsg")) %>");
            document.shippingAddress.city.focus();
         } else if (errorField == "country") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingCountryMsg")) %>");
            document.shippingAddress.country.focus();
         } else if (errorField == "region") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingRegionMsg")) %>");
            document.shippingAddress.region.focus();
         } else if (errorField == "postalCode") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingPostalCodeMsg")) %>");
            document.shippingAddress.postalCode.focus();
         } else if (errorField == "phoneNumber") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingPhoneNumberMsg")) %>");
            document.shippingAddress.phoneNumber.focus();
         } else if (errorField == "email") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("enterShippingEmailMsg")) %>");
            document.shippingAddress.email.focus();
         } else if (errorField == "invalidEmail") {
            alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidShippingEmailMsg")) %>");
            document.shippingAddress.email.focus();
         }
      }  
      
    function newCountrySelected()
	{
	    var countrySelected = document.shippingAddress.country.selectedIndex;
	    var countryName = document.shippingAddress.country.options[countrySelected].value;	    
	    var addressInfo = new Object;
	    
	    var city = document.shippingAddress.city.value;
	    
	    addressInfo.nickName = document.shippingAddress.nickName.value;
		addressInfo.firstName = document.shippingAddress.firstName.value; 
		addressInfo.lastName = document.shippingAddress.lastName.value;     	 
		addressInfo.address1 = document.shippingAddress.address1.value;
		addressInfo.address2 = document.shippingAddress.address2.value;
		addressInfo.city = document.shippingAddress.city.value;
		addressInfo.country = document.shippingAddress.country.options[countrySelected].value; 
		addressInfo.region = document.shippingAddress.region.value; 
		addressInfo.postalCode = document.shippingAddress.postalCode.value; 
		addressInfo.phoneNumber = document.shippingAddress.phoneNumber.value;     
		addressInfo.email = document.shippingAddress.email.value; 
		addressInfo.postalCode = document.shippingAddress.postalCode.value;
		
		parent.put("addressInfo", addressInfo);    
		
	    parent.setContentFrameLoaded(false);
	    
	    var url = "/webapp/wcs/tools/servlet/OrderNewShippingAddress";
		
	    var param = new Object();	    
      param.countryName = countryName;		
	    top.mccmain.submitForm(url,param,"CONTENTS");    
	    		
	}    

	function updateShippingAddress() {
		savePanelData();
		if (!validatePanelData())
			return;
		
		parent.setContentFrameLoaded(false);
		document.shippingAddress.XML.value = parent.convertToXML(model, "XML");
		document.shippingAddress.URL.value = "/wcs/tools/order/OrderShippingAddressRedirect.html";
		document.shippingAddress.customerId.value = customerId;
		document.shippingAddress.action = "/webapp/wcs/tools/servlet/CSROrderItemAddressUpdate";			
		document.shippingAddress.submit();
	}
   //[[>-->
   </script>
   
</head>
<body onload="initializeState();" class="content">
<form name="shippingAddress" method="post" action="">
	<input type="hidden" name="URL" value="" /> 
	<input type="hidden" name="XML" value="" />
	<input type="hidden" name="customerId" value="" />
     <h1><%= orderMgmtNLS.get("newShippingAddressTitle") %></h1>
     <script type="text/javascript">
     <!-- <![CDATA[
     document.writeln('<table>');
     <%
     String typeOfAddress = "sAHTML";
     Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
     Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());

     if (localeAddrFormat == null) 
     {
	localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
     }
     
     String defaultmandatoryLine = "nickName";
     if (ifAddressFieldRequired(hshFirstName))
	defaultmandatoryLine += ",firstName";
     if (ifAddressFieldRequired(hshLastName))
	defaultmandatoryLine += ",lastName";
     if (ifAddressFieldRequired(hshAddress1))
	defaultmandatoryLine += ",address1";
     if (ifAddressFieldRequired(hshAddress2))
	defaultmandatoryLine += ",address2";
     if (ifAddressFieldRequired(hshCity))
	defaultmandatoryLine += ",city";
     if (ifAddressFieldRequired(hshState))
	defaultmandatoryLine += ",region";
     if (ifAddressFieldRequired(hshCountry))
	defaultmandatoryLine += ",country";
     if (ifAddressFieldRequired(hshZipCode))
	defaultmandatoryLine += ",postalCode";
     if (ifAddressFieldRequired(hshPhone1))
	defaultmandatoryLine += ",phoneNumber";
     if (ifAddressFieldRequired(hshEmail1))
	defaultmandatoryLine += ",email";
	
	
	
     String[] defaultmandatoryFields = Util.tokenize(defaultmandatoryLine, ",");
     String[] mandatoryFields = new String[defaultmandatoryFields.length];
     String mandatoryLine = "";
     int mandatoryindex = 0; 
     String addressLine = "";
     String required = "";
     for (int i=0;i<localeAddrFormat.size();i++) {
        addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
        String[] addressFields = Util.tokenize(addressLine, ",");
        %>
        var counter = 0;
        <%
        for (int j=0; j<addressFields.length; j++) {
           required = "";
           if ( (!addressFields[j].equals("space")) && (!addressFields[j].equals("comma")) &&
                (!addressFields[j].equals("title")) && (!addressFields[j].equals("address3")) ) {
              //check if it is mandatory
              for (int k=0; k<defaultmandatoryFields.length; k++) {
                 if ( defaultmandatoryFields[k].equals(addressFields[j]) ) {
                    required = "Mandatory";
                    if (mandatoryindex == 0) {
                    	mandatoryLine += addressFields[j]; 
                    } else {
                    	mandatoryLine += "," + addressFields[j]; 
                    }
                    mandatoryFields[mandatoryindex] = addressFields[j];
                    mandatoryindex++;	
                 }
              }
              %>
              if ( (counter%2 == 0) && ("<%= addressFields[j] %>" != "address1") && ("<%= addressFields[j] %>" != "address2") && ("<%= addressFields[j] %>" != "email") && ("<%= addressFields[j] %>" != "phoneNumber") )
                 document.writeln("<TR>");
               
              if ( "<%= addressFields[j] %>" == "address1" ) {
                 document.writeln('<TR><TD  valign="top" align="left" colspan=2>');
                 document.writeln('<label for="addr1"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get("streetAddress"+required)) %></label><BR>');
                 document.writeln('<input id="addr1" type="text" name="<%= addressFields[j] %>" value="' + <%= typeOfAddress + "." + addressFields[j] %> + '" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.shippingAddress.<%= addressFields[j] %>, 50);"><BR>');
              } else if ( "<%= addressFields[j] %>" == "address2" ) {
                 document.writeln('<input id="addr1" type="text" name="<%= addressFields[j] %>" value="' + <%= typeOfAddress + "." + addressFields[j] %> + '" size=50 maxlength=50 onChange="validateInputLengthOnChange(document.shippingAddress.<%= addressFields[j] %>, 50);">');
                 document.writeln('</TD></TR>');
              } else if ( "<%= addressFields[j] %>" == "phoneNumber" ) {
                 document.writeln('<TR><TD  valign="top" align="left">');
                 document.writeln('<label for="addr2"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label><BR>');
                 document.writeln('<input id="addr2" type="text" name="<%= addressFields[j] %>" value="' + <%= typeOfAddress + "." + addressFields[j] %> + '" size=32 maxlength=32 onChange="validateInputLengthOnChange(document.shippingAddress.<%= addressFields[j] %>, 32);">');              
                 document.writeln('</TD></TR>');
              } else if ( "<%= addressFields[j] %>" == "postalCode" ) {
                 document.writeln('<TD  valign="top" align="left">');
                 document.writeln('<label for="addr3"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label><BR>');
                 document.writeln('<input id="addr3" type="text" name="<%= addressFields[j] %>" value="' + <%= typeOfAddress + "." + addressFields[j] %> + '" size=35 maxlength=40 onChange="validateInputLengthOnChange(document.shippingAddress.<%= addressFields[j] %>, 40);">');              
                 document.writeln('</TD>');
              } else if ( "<%= addressFields[j] %>" == "country" ) {
                 document.writeln('<TD  valign="top" align="left">');
                 document.writeln('<label for="addr4"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label><BR>');
                 document.writeln('<select id="addr4" name="<%= addressFields[j] %>" onChange="newCountrySelected()" >');                 
                 document.writeln('<option value="" selected></option>');
                 <% for (int k=0; k<nameList.length; k++) { %> 
                    document.writeln("<option value='<%=nameList[k][1]%>'><%=nameList[k][1]%></option>");
                 <% } %>
                 document.writeln('</select>');
                 document.writeln('</TD>');   
              }else if ( "<%= addressFields[j] %>" == "region" ) {
                        <% 
                           if (areStates!= null){ 
                        %>                         
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label> <BR>');
                           document.writeln('<select name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" class="selectWidth" >');
                        
                           document.writeln('<%=selectBoxHtmlForState%>');                                                
                           document.writeln('</select></TD></TR>');
                        <% } 
                        else {
                        %> 
                           document.writeln('<TD  valign="top" align="left">');
                           document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label> <BR>');
                           document.writeln('<input type="text" name="<%= addressFields[j] %>" id="<%= addressFields[j] %>" value="" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.billingAddress.<%= addressFields[j] %>, 128);">');              
                           document.writeln('</TD></TR>');
                        <%
                        }
                        %>
                                                           
                        } 
              else {
                 document.writeln('<TD  valign="top" align="left">');
                 document.writeln('<label for="<%= addressFields[j] %>"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get(addressFields[j]+required)) %></label><BR>');
                 document.writeln('<input id="<%= addressFields[j] %>" type="text" name="<%= addressFields[j] %>" value="' + <%= typeOfAddress + "." + addressFields[j] %> + '" size=35 maxlength=128 onChange="validateInputLengthOnChange(document.shippingAddress.<%= addressFields[j] %>, 128);">');              
                 document.writeln('</TD>');
              }
              
              if ( (counter%2 != 0) && ("<%= addressFields[j] %>" != "address1") && ("<%= addressFields[j] %>" != "address2") && ("<%= addressFields[j] %>" != "email") && ("<%= addressFields[j] %>" != "phoneNumber") )
                 document.writeln('</TR>');
                 
              counter++;
           <%
           } //end if
        } //end for
     } //end for
     %>
     
     //add email address
     <% 
     	required = "";
    	for (int k=0; k<defaultmandatoryFields.length; k++) {
             if ( defaultmandatoryFields[k].equals("email") ) {
                   required = "Mandatory";
                   mandatoryLine += ",email"; 
                   mandatoryFields[mandatoryindex] = "email"; 
             }
        }
     %>
     document.writeln('<TR><TD  valign="top" align="left" colspan=2>');

     document.writeln('<label for="email"><%= UIUtil.toJavaScript((String)orderMgmtNLS.get("email"+required)) %></label><BR>');
     document.writeln('<input id="email" type="text" name="email" value="' + <%= typeOfAddress + ".email" %> + '" size=50 maxlength=256 onChange="validateInputLengthOnChange(document.shippingAddress.email, 256);">');              
     document.writeln('</TD></TR>');

     updateEntry(address, "mandatoryFields", "<%= mandatoryLine %>");
     document.writeln('</table>');
     //[[>-->
     </script>
</form>  

<%
} catch (Exception e) {
   System.out.println ("Exception ");
   e.printStackTrace();
   out.println(e);
}
%>
</body>
</html>
