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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
try {
	
	CommandContext cmdContext = 
		(CommandContext)request.getAttribute("CommandContext");
	Locale localeType = cmdContext.getLocale();
	String locale = localeType.toString();
	String webalias = UIUtil.getWebPrefix(request);
    
	Hashtable formats = 
		(Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
	Hashtable format = 
		(Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	Hashtable orgEntityNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", cmdContext.getLocale());
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
	String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax"));
	
	Hashtable user2NLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	 	
	
	String orgEntityId = request.getParameter("orgEntityId");
	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
	
	if(!(orgEntityId == null || orgEntityId.trim().length()==0)) 
        {
	bnOrgEntity.setOrgEntityId(orgEntityId);
	com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
	}
	
	
	
%>   
<HTML>

<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityAddress")) %></title>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>">
<SCRIPT SRC="/wcs/javascript/tools/csr/user.js"></SCRIPT>
<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>


<SCRIPT>
function displayAddrItem(num)
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = parent.get("mandatoryFields");

   var mandatory = (mandatoryFields.indexOf(addrOrderList[num]) == -1) ? false : true ;
   
   if (addrOrderList[num] == "street")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)orgEntityNLS.get("street"))%><BR>");
      else
         println("<%=UIUtil.toHTML((String)user2NLS.get("street"))%><BR>");
      println("<INPUT size='65' type='text' name='address1' maxlength='50'><BR>");
      println("<INPUT size='65' type='text' name='address2' maxlength='50'><BR>");
      println("<INPUT size='65' type='text' name='address3' maxlength='50'>");
   }
   else if (addrOrderList[num] == "city")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)orgEntityNLS.get("city"))%><BR>");
      else
         println("<%=UIUtil.toHTML((String)user2NLS.get("city"))%><BR>");
      println("<INPUT size='30' type='text' name='city' maxlength='128'>");
   }
   else if (addrOrderList[num] == "state")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)orgEntityNLS.get("state"))%><BR>");
      else
         println("<%=UIUtil.toHTML((String)user2NLS.get("state"))%><BR>");

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
         println("<%=UIUtil.toHTML((String)userNLS.get("country"))%><BR>");
      else
         println("<%=UIUtil.toHTML((String)user2NLS.get("country"))%><BR>");

      println("<label for='country1'></label>");
	  println("<select name='country' id='country1'>"); 
 	  <%
 	    // Fetch the list of countries from the database
 		SegmentCountriesDataBean segmentCountries = new SegmentCountriesDataBean();
		DataBeanManager.activate(segmentCountries, request);
		SegmentCountriesDataBean.Country[] countries = segmentCountries.getCountries();
		
		for (int i=0; i<countries.length; i++) {
 	  %>
	  		println("<option value='<%=countries[i].getAbbr()%>'><%=countries[i].getName()%>");
	  <% } %>
	  
	  println("</select></BR>");

   }
   else if (addrOrderList[num] == "zip")
   {
      if (mandatory == true)
         println("<%=UIUtil.toHTML((String)orgEntityNLS.get("zip"))%><br>");
      else
         println("<%=UIUtil.toHTML((String)user2NLS.get("zip"))%><br>");
      println("<INPUT size='30' type='text' name='zip' maxlength='40'>");
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

function displayValidationError()
{
	// check for errors from validation
	var mM = "missingMandatoryField";
	var iFM = "inputFieldMax";
	
	var code = parent.getErrorParams();
	if (code != null)
	{
		if (code.indexOf(mM)!=-1)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
			code = code.split("_");
			if (code[1]=="address1")
				document.address.address1.focus();
			else if (code[1]=="city")
				document.address.city.focus();
			else if (code[1]=="state")
				document.address.state.focus();
			else if (code[1]=="zip")
				document.address.zip.focus();
			else if (code[1]=="country")
				document.address.country.focus();
		} else if (code.indexOf(iFM)!=-1) {
			alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax"))%>");
			code = code.split("_");
			if (code[1]=="address1")
				document.address.address1.select();
			else if (code[1]=="address2")
				document.address.address2.select();
			else if (code[1]=="address3")
				document.address.address3.select();
			else if (code[1]=="city")
				document.address.city.select();
			else if (code[1]=="state")
				document.address.state.select();
			else if (code[1]=="zip")
				document.address.zip.select();
			else if (code[1]=="country")
				document.address.country.select();
		}
	}
}

function initializeState()
{
   // alertDialog("DEBUG: initializeState()");

   if ("<%=UIUtil.toJavaScript(orgEntityId)%>" != null || "<%=UIUtil.toJavaScript(orgEntityId)%>" != '') {
      
      document.address.address1.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS1))%>";
      document.address.address2.value    = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS2))%>";
      document.address.address3.value    = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS3))%>";
      document.address.city.value   = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_CITY))%>";
      document.address.state.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_STATE))%>";
      document.address.zip.value  = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ZIPCODE))%>";
      document.address.country.value = "<%=UIUtil.toJavaScript(bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_COUNTRY))%>";
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
	displayValidationError();

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
      				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   	else if (addrOrderList[i] == "city")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.address.city.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
	}
   	else if (addrOrderList[i] == "state")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.address.state.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
         	}
   	}
   	else if (addrOrderList[i] == "country")
   	{
      		if (mandatory == true) {
      			if (isEmpty(document.address.country.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   	else if (addrOrderList[i] == "zip")
   	{
      		if (mandatory == true) {
      			if (isEmpty(document.address.zip.value))
			{
      				alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   }
   
   return true;
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


function validateNoteBookPanel() 
{
    return validatePanelData();
}

 
</SCRIPT>

</HEAD>
<BODY class="content" onload="initializeState();">
<FORM name="address">
<h1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityAddress")) %></h1>
<TABLE border="0" cellpadding="2" cellspacing="2">
  <TR><TH></TH></TR>
  <TBODY>
    <TR>
      <TD valign="bottom">
        <script>displayAddrItem(0)</script>
      </TD>
    </TR>
    <TR>
      <TD valign="bottom">
        <script>displayAddrItem(1)</script>
      </TD>
    </TR>
    <TR>
      <TD valign="bottom">
        <script>displayAddrItem(2)</script>
      </TD>
    </TR>
    <TR>
      <TD valign="bottom">
        <script>displayAddrItem(3)</script>
      </TD>
    </TR>
    <TR>
      <TD valign="bottom">
        <script>displayAddrItem(4)</script>
      </TD>
    </TR>
</TABLE>
</FORM>

<%
}
catch (Exception e)
{
	e.printStackTrace();
}
%>

</BODY>

</HTML>



