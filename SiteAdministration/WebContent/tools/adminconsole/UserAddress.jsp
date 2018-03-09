
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

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
	    java.sql.*" 
%>  

<%@include file="../common/common.jsp" %>

<%
try
{
	//String userId = request.getParameter("shrfnbr");
	//String locale = request.getParameter("locale");
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Locale localeType = cmdContext.getLocale();
	String locale = localeType.toString();
	String webalias = UIUtil.getWebPrefix(request);
	
    
	Hashtable formats = (Hashtable)ResourceDirectory.lookup("adminconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	} 

	
	Hashtable userWizardNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
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
<HTML>

<head><title><%= UIUtil.toHTML((String)userWizardNLS.get("userGeneralAddress")) %></title>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
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
         println("<%=UIUtil.toJavaScript((String)userWizardNLS.get("street"))%><BR>");
      else
         println("<%=UIUtil.toJavaScript((String)userNLS.get("street"))%><BR>");
      println("<INPUT size='65' type='text' name='address1' maxlength='50'><BR>");
      println("<INPUT size='65' type='text' name='address2' maxlength='50'><BR>");
      println("<INPUT size='65' type='text' name='address3' maxlength='50'>");
   }
   else if (addrOrderList[num] == "city")
   {
      if (mandatory == true)
         println("<%=UIUtil.toJavaScript((String)userWizardNLS.get("city"))%><BR>");
      else
         println("<%=UIUtil.toJavaScript((String)userNLS.get("city"))%><BR>");
      println("<INPUT size='30' type='text' name='city' maxlength='128'>");
   }
   else if (addrOrderList[num] == "state")
   {
      if (mandatory == true)
         println("<%=UIUtil.toJavaScript((String)userWizardNLS.get("state"))%><BR>");
      else
         println("<%=UIUtil.toJavaScript((String)userNLS.get("state"))%><BR>");
      println("<INPUT size='30' type='text' name='state' maxlength='128'>");
   }
   else if (addrOrderList[num] == "country")
   {
      if (mandatory == true)
         println("<%=UIUtil.toJavaScript((String)userWizardNLS.get("country"))%><BR>");
      else
         println("<%=UIUtil.toJavaScript((String)userNLS.get("country"))%><BR>");
      println("<INPUT size='30' type='text' name='country' maxlength='128'>");
   }
   else if (addrOrderList[num] == "zip")
   {
      if (mandatory == true)
         println("<%=UIUtil.toJavaScript((String)userWizardNLS.get("zip"))%><br>");
      else
         println("<%=UIUtil.toJavaScript((String)userNLS.get("zip"))%><br>");
      println("<INPUT size='30' type='text' name='zip' maxlength='40'>");
   }
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
   	else if (addrOrderList[i] == "city")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.address.city.value))
  			{
      				alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
	}
   	else if (addrOrderList[i] == "state")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.address.state.value))
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
   	else if (addrOrderList[i] == "zip")
   	{
      		if (mandatory == true) {
      			if (isEmpty(document.address.zip.value))
			{
      				alertDialog("<%=UIUtil.toJavaScript((String)userWizardNLS.get("missingMandatoryData"))%>");
      				return false;
  			} 
      		}
   	}
   }
   
   return true;
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



function initializeState()
{
   // alertDialog("DEBUG: initializeState()");

      
      if ("<%=UIUtil.toJavaScript(memberId2)%>" != null || "<%=UIUtil.toJavaScript(memberId2)%>" != '') {
      
      document.address.address1.value  = "<%=userBean.getAddress1()%>";
      document.address.address2.value    = "<%=userBean.getAddress2()%>";
      document.address.address3.value    = "<%=userBean.getAddress3()%>";
      document.address.city.value   = "<%=userBean.getCity()%>";
      document.address.state.value  = "<%=userBean.getState()%>";
      document.address.zip.value  = "<%=userBean.getZipCode()%>";
      document.address.country.value = "<%=userBean.getCountry()%>";
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

}

function validatePanelData()
{
  
  if(!isValidUTF8length(document.address.address1.value, 50))
  {
	document.address.address1.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.address2.value, 50))
  {
	document.address.address2.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.address3.value, 50))
  {
	document.address.address3.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.city.value, 128))
  {
	document.address.city.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  if(!isValidUTF8length(document.address.state.value, 128))
  {
	document.address.city.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  
  if(!isValidUTF8length(document.address.country.value, 128))
  {
	document.address.country.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  
  if(!isValidUTF8length(document.address.zip.value, 40))
  {
	document.address.zip.select();
  	alertDialog("<%= AdminConsoleExceedMaxLength %>");
  	return false;
  }
  
  return validateMandatory();
  
  
}

function validateNoteBookPanel() 
{
    return validatePanelData();
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
 
</SCRIPT>

</HEAD>
<BODY CLASS="content" onload="initializeState();">
<FORM name="address">
<h1><%= UIUtil.toHTML((String)userWizardNLS.get("userGeneralAddress")) %></h1>
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



