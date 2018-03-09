<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" 
    import="java.util.*,
            com.ibm.commerce.tools.common.*,
            com.ibm.commerce.tools.util.*,
            com.ibm.commerce.server.*,
            com.ibm.commerce.user.beans.*,
            com.ibm.commerce.user.objects.*,            
		    com.ibm.commerce.beans.*,
            com.ibm.commerce.tools.xml.*,
            com.ibm.commerce.command.*,
            com.ibm.commerce.common.beans.*,
	    	com.ibm.commerce.usermanagement.commands.ECUserConstants,
		    com.ibm.commerce.user.beans.*,
		    java.sql.*,
		    com.ibm.commerce.tools.segmentation.SegmentStatesDataBean,
		    com.ibm.commerce.tools.segmentation.SegmentCountriesDataBean"  
%>  

<%@include file="../common/common.jsp" %>

<%
try
{
	//String userId = request.getParameter("shrfnbr");
	//String locale = request.getParameter("locale");
	String webalias = UIUtil.getWebPrefix(request);
	
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Locale localeType = cmdContext.getLocale();
	String locale = localeType.toString();
    
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable userWizardNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", cmdContext.getLocale());
	String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));	 
	
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	 
	    
        UserRegistrationDataBean userBean = new UserRegistrationDataBean();  
        String memberId2 = request.getParameter("memberId");
        if(!(memberId2 == null || memberId2.trim().length()==0)) 
        {
           userBean.setDataBeanKeyMemberId(memberId2);
           com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
        }
	
	UIUtil convert = null;
	
	
%>   
<html xmlns="http://www.w3.org/1999/xhtml">

<head><title><%= UIUtil.toHTML((String)userWizardNLS.get("userGeneralAddress")) %></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" />
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js"></script>
<script type="text/javascript" language="JavaScript1.2" src="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<script type="text/javascript" src="<%=webalias%>javascript/tools/common/Util.js"></script>

<script type="text/javascript">
function displayAddrItem(num)
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   var mandatoryFields = parent.get("mandatoryFields");

   var mandatory = (mandatoryFields.indexOf(addrOrderList[num]) == -1) ? false : true ;
   if (addrOrderList[num] == "street")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)userWizardNLS.get("street"))%><br />");
      else        
      	 println("<%=UIUtil.toHTML((String)userNLS.get("street"))%><br />");
      println("<label for='address1'></label>");
      println("<input size='65' type='text' name='address1' maxlength='50' id='address1' /><br />");
      println("<label for='address2'></label>");
      println("<input size='65' type='text' name='address2' maxlength='50' id='address2' /><br />");        
      println("<label for='address3'></label>");
      println("<input size='65' type='text' name='address3' maxlength='50' id='address3' /><br />");    
   }
   else if (addrOrderList[num] == "city")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)userWizardNLS.get("city"))%><br />");
      else
         println("<%=UIUtil.toHTML((String)userNLS.get("city"))%><br />");
      println("<label for='city1'></label>");
      println("<input size='30' type='text' name='city' maxlength='128' id='city1' /><br />");   
   }
   else if (addrOrderList[num] == "state")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)userWizardNLS.get("state"))%><br />");
      else
         println("<%=UIUtil.toHTML((String)userNLS.get("state"))%><br />");

      println("<label for='state1'></label>");
	  println("<select name='state' id='state1'>"); 
 	  <%
 	    // Fetch the list of states from the database
 		SegmentStatesDataBean segmentStates = new SegmentStatesDataBean();
		DataBeanManager.activate(segmentStates, request);
		SegmentStatesDataBean.State[] states = segmentStates.getStates();
		
		for (int i=0; i<states.length; i++) {
 	  %>
	  		println("<option value='<%= UIUtil.toHTML(states[i].getAbbr()) %>'><%= UIUtil.toHTML(states[i].getName()) %>");
	  <% } %>
	  
	  println("</select>");
   }
   else if (addrOrderList[num] == "country")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)userWizardNLS.get("country"))%><br />");
      else
         println("<%=UIUtil.toHTML((String)userNLS.get("country"))%><br />"); 

      println("<label for='country1'></label>");
	  println("<select name='country' id='country1'>"); 
 	  <%
 	    // Fetch the list of countries from the database
 		SegmentCountriesDataBean segmentCountries = new SegmentCountriesDataBean();
		DataBeanManager.activate(segmentCountries, request);
		SegmentCountriesDataBean.Country[] countries = segmentCountries.getCountries();
		
		for (int i=0; i<countries.length; i++) {
 	  %>
	  		println("<option value='<%= UIUtil.toHTML(countries[i].getAbbr()) %>'><%= UIUtil.toHTML(countries[i].getName()) %>");
	  <% } %>
	  
	  println("</select></BR>");

   }
   else if (addrOrderList[num] == "zip")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)userWizardNLS.get("zip"))%><br />");
      else
         println("<%=UIUtil.toHTML((String)userNLS.get("zip"))%><br />"); 
      println("<label for='zip1'></label>");
      println("<input size='30' type='text' name='zip' maxlength='40' id='zip1' /><br />"); 
   }
}

function compare()
{
   for (var i=0; i<document.address.elements.length; i++)
   { 
      var e = document.address.elements[i];
      if (parent.get("addressUpdated")=="false" && e.type == "text")
      {
        if (e.name == "address1" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "address2" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "address3" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "city" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "state" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "zip" && e.value != '')
           parent.put("addressUpdated", "true");
        if (e.name == "country" && e.value != '')
           parent.put("addressUpdated", "true");           
      }

   }

  if (parent.get("addressUpdated") == "true")
     return true;
  else
     return false;
}

function setStateChanged()
{
   if (compare() == true)
   {
     if (parent.get("changesMade") == "false")
        parent.put("changesMade",      "true");
   }
}

function isStateChanged()
{
	return parent.get("changesMade");
}

function validateMandatory()
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   var mandatoryFields = parent.get("mandatoryFields");
   
   for (var i=0; i < 5; i++) {
   
   	var mandatory = (mandatoryFields.indexOf(addrOrderList[i]) == -1) ? false : true ;
   	if (addrOrderList[i] == "street")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.address.address1.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   	else if (addrOrderList[i] == "country")
   	{
      		if (mandatory == true) {
      			if (isEmpty(document.address.country.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   }
   
   return true;
}

function initializeState()
{
   // alertDialog("DEBUG: initializeState()");

      
      if ("<%=UIUtil.toJavaScript(memberId2)%>" != null || "<%=UIUtil.toJavaScript(memberId2)%>" != '') {
      
      document.address.address1.value  = "<%=UIUtil.toJavaScript(userBean.getAddress1())%>";
      document.address.address2.value    = "<%=UIUtil.toJavaScript(userBean.getAddress2())%>";
      document.address.address3.value    = "<%=UIUtil.toJavaScript(userBean.getAddress3())%>";
      document.address.city.value   = "<%=UIUtil.toJavaScript(userBean.getCity())%>";
      document.address.state.value  = "<%=UIUtil.toJavaScript(userBean.getState())%>";
      document.address.zip.value  = "<%=UIUtil.toJavaScript(userBean.getZipCode())%>";
      document.address.country.value = "<%=UIUtil.toJavaScript(userBean.getCountry())%>";
   }

   
   if (parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS1%>") != null) 
      document.address.address1.value = parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS1%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS2%>") != null) 
      document.address.address2.value = parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS2%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS3%>") != null) 
      document.address.address3.value = parent.get("<%=ECUserConstants.EC_ADDR_ADDRESS3%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_CITY%>") != null) 
      document.address.city.value = parent.get("<%=ECUserConstants.EC_ADDR_CITY%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_STATE%>") != null) 
      document.address.state.value = parent.get("<%=ECUserConstants.EC_ADDR_STATE%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_ZIPCODE%>") != null) 
      document.address.zip.value = parent.get("<%=ECUserConstants.EC_ADDR_ZIPCODE%>");
   if (parent.get("<%=ECUserConstants.EC_ADDR_COUNTRY%>") != null) 
      document.address.country.value = parent.get("<%=ECUserConstants.EC_ADDR_COUNTRY%>");
      
   
   
	parent.setContentFrameLoaded(true);   
//	displayValidationError();

}

function validatePanelData()
{
  if(!isValidUTF8length(document.address.address1.value, 50))
  {
	document.address.address1.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.address2.value, 50))
  {
	document.address.address2.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.address3.value, 50))
  {
	document.address.address3.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.city.value, 128))
  {
	document.address.city.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.state.value, 128))
  {
	document.address.city.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.country.value, 128))
  {
	document.address.country.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.zip.value, 40))
  {
	document.address.zip.select();
  	alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
  	return false;
  }
  
  return validateMandatory();
  
}

function savePanelData()
{
   // alertDialog("DEBUG: validateEntries()");
   parent.put("address1", document.address.address1.value);
   parent.put("address2", document.address.address2.value);
   parent.put("address3", document.address.address3.value);
   parent.put("city", document.address.city.value);
   parent.put("state", document.address.state.value);
   parent.put("zipCode", document.address.zip.value);
   parent.put("country", document.address.country.value);

   // var selected = document.address.country.selectedIndex;
   // addressInfo.country = document.address.country.options[selected].value;
 
	//parent.put("addressInfo", addressInfo);     
	setStateChanged();

	// alertDialog("address state changed? " + isStateChanged());
   return true;
}


function validateNoteBookPanel() 
{
    return validatePanelData();
}
 
</script>

</head>
<body class="content" onload="initializeState();">
<form action="" name="address">
<h1><%= UIUtil.toHTML((String)userWizardNLS.get("userGeneralAddress")) %></h1>
<table border="0" cellpadding="2" cellspacing="2">
  <tr><th></th></tr>
  <tbody>
    <tr>
      <td valign="bottom">
        <script type="text/javascript">displayAddrItem(0)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script type="text/javascript">displayAddrItem(1)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script type="text/javascript">displayAddrItem(2)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script type="text/javascript">displayAddrItem(3)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script type="text/javascript" >displayAddrItem(4)</script>
      </td>
    </tr>
  </tbody>
</table>
</form>

<%
}
catch (Exception e)
{
	e.printStackTrace();
}
%>

</body>

</html>



