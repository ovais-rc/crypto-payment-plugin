<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%!
	/**
	 * Compare two strings and check if they are equal.
	 * 
	 * @param s1 First string to compare
	 * @param s2 Second string to compare
	 * @param locale The locale to compare on
	 * @return True for equal, or false otherwise.
	 */
	private boolean compstr (String s1, String s2, Locale locale) {
		Collator myCollator = Collator.getInstance (locale);
		boolean b = (myCollator.compare(s1,s2) == 0);
		return b;
	}

%>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Locale localeType = cmdContext.getLocale();
	String locale = localeType.toString();

	ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
	bnResourceBundle.setPropertyFileName("OrgEntity");
	DataBeanManager.activate(bnResourceBundle, request);
	
	SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
	Iterator entryIterator = smpFields.entrySet().iterator();
	entryIterator.next();
	
	
	Hashtable hshAddress1  = new Hashtable();
	Hashtable hshCity      = new Hashtable();
	Hashtable hshState     = new Hashtable();
	Hashtable hshCountry   = new Hashtable();
	Hashtable hshZipCode   = new Hashtable();
	   
	String Address1URL  = ECUserConstants.EC_ADDR_ADDRESS1;
	String CityURL      = ECUserConstants.EC_ADDR_CITY;
	String StateURL     = ECUserConstants.EC_ADDR_STATE;
	String CountryURL   = ECUserConstants.EC_ADDR_COUNTRY;
	String ZipCodeURL   = ECUserConstants.EC_ADDR_ZIPCODE;
	
	while (entryIterator.hasNext()) {
	
		Map.Entry entry = (Map.Entry) entryIterator.next();
		Hashtable hshField = (Hashtable) entry.getValue();
		String strName = (String) hshField.get("Name");
		
		if (compstr(strName,Address1URL,localeType)) {
			hshAddress1  = (Hashtable) entry.getValue();
		}
		if (compstr(strName,CityURL,localeType)) {
			hshCity  = (Hashtable) entry.getValue();
		}
		if (compstr(strName,StateURL,localeType)) {
			hshState  = (Hashtable) entry.getValue();
		}
		if (compstr(strName,CountryURL,localeType)) {
			hshCountry  = (Hashtable) entry.getValue();
		}
		if (compstr(strName,ZipCodeURL,localeType)) {
			hshZipCode  = (Hashtable) entry.getValue();
		}		
	}
	
	
	StringBuffer mandatoryLine = new StringBuffer("");
	if (((Boolean)hshAddress1.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLine.append(",street");
	}
	if (((Boolean)hshCity.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLine.append(",city");
	}
	if (((Boolean)hshState.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLine.append(",state");
	}
	if (((Boolean)hshZipCode.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLine.append(",zip");
	}
	if (((Boolean)hshCountry.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue()) {
		mandatoryLine.append(",country");
	}

	Hashtable formats = (Hashtable)ResourceDirectory.lookup("buyerconsole.nlsFormats");
	Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ locale);

	if (format == null) 
	{
	   format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
	}

	Hashtable orgEntityNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", cmdContext.getLocale());
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
	
	Hashtable user2NLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", cmdContext.getLocale());	 	
	
	String address1 = "";
	String address2 = "";
	String address3 = "";
	String city = "";
	String country = "";
	String state = "";
	String zipCode = "";
	
	String orgEntityId = request.getParameter("orgEntityId");
	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
	
	String memberId = request.getParameter("memberId");
	UserRegistrationDataBean bnUser = new UserRegistrationDataBean();
	
	if(!(orgEntityId == null || orgEntityId.trim().length()==0)) 
        {
		bnOrgEntity.setDataBeanKeyMemberId(orgEntityId);
		com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
		
		address1 = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS1);
		address2 = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS2);
		address3 = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ADDRESS3);
		city = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_CITY);
		country = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_COUNTRY);
		state = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_STATE);
		zipCode = bnOrgEntity.getAttribute(ECUserConstants.EC_ADDR_ZIPCODE);
	}
	
	if(!(memberId == null || memberId.trim().length()==0)) 
        {
		bnUser.setDataBeanKeyMemberId(memberId);
		com.ibm.commerce.beans.DataBeanManager.activate(bnUser, request);
		
		address1 = bnUser.getAttribute(ECUserConstants.EC_ADDR_ADDRESS1);
		address2 = bnUser.getAttribute(ECUserConstants.EC_ADDR_ADDRESS2);
		address3 = bnUser.getAttribute(ECUserConstants.EC_ADDR_ADDRESS3);
		city = bnUser.getAttribute(ECUserConstants.EC_ADDR_CITY);
		country = bnUser.getAttribute(ECUserConstants.EC_ADDR_COUNTRY);
		state = bnUser.getAttribute(ECUserConstants.EC_ADDR_STATE);
		zipCode = bnUser.getAttribute(ECUserConstants.EC_ADDR_ZIPCODE);
	}
%>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Vector.js"></script>

<jsp:useBean id="countryDB" class="com.ibm.commerce.user.beans.CountryStateListDataBean" scope="page">
	<% com.ibm.commerce.beans.DataBeanManager.activate(countryDB, request); %>
</jsp:useBean>

<script>
//get the list of all countries and states available from the database.
var countries = new Array();

<%
Vector countries = countryDB.getCountries();
CountryStateListDataBean.Country aCountry = null;
CountryStateListDataBean.StateProvince[] states = null;
		
for (int i=0; i<countries.size(); i++) {
	aCountry = (CountryStateListDataBean.Country)countries.elementAt(i);
%>
	countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"] = new Object();
	countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].name = "<%= UIUtil.toJavaScript(aCountry.getDisplayName()) %>";
<%
	states = aCountry.getStates();
	for (int k=0; k<states.length; k++) {		
	    if (k == 0) { %>
    	    countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].states = new Object();
    	<%
    	}
		%>
			countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].states["<%= UIUtil.toJavaScript(states[k].getCode()) %>"] = "<%= UIUtil.toJavaScript(states[k].getDisplayName()) %>";
		<%
	}
}
%>

function displayAddrItem(num)
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = "<%= mandatoryLine %>";
   
   var mandatory = (mandatoryFields.indexOf(addrOrderList[num]) == -1) ? false : true ;
   
   if (addrOrderList[num] == "street")
   {
      if (mandatory == true) {
      	 document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("street"))%><br>");
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ADDRESS1 %>\" class=\"hidden-label\">");
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("street1"))%>");
         document.writeln("</label>");
      } else {
      	 document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("street"))%><br>");
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ADDRESS1 %>\" class=\"hidden-label\">");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("street1"))%>");
         document.writeln("</label>");
      }

	    document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ADDRESS2 %>\" class=\"hidden-label\" >");
	    document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("street2"))%>");
	    document.writeln("</label>");
	
	    document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ADDRESS3 %>\" class=\"hidden-label\" >");
	    document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("street3"))%>");
	    document.writeln("</label>");
         
      document.writeln("<input size='65' type='text' name='<%=ECUserConstants.EC_ADDR_ADDRESS1%>' id='<%=ECUserConstants.EC_ADDR_ADDRESS1%>' maxlength='50'><br>");
      document.writeln("<input size='65' type='text' name='<%=ECUserConstants.EC_ADDR_ADDRESS2%>' id='<%=ECUserConstants.EC_ADDR_ADDRESS2%>' maxlength='50'><br>");
      document.writeln("<input size='65' type='text' name='<%=ECUserConstants.EC_ADDR_ADDRESS3%>' id='<%=ECUserConstants.EC_ADDR_ADDRESS3%>' maxlength='50'>");
   }
   else if (addrOrderList[num] == "city")
   {
      if (mandatory == true) {
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_CITY %>\">");
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("city"))%><br>");
         document.writeln("</label>");
      } else {
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_CITY %>\">");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("city"))%><br>");
         document.writeln("</label>");
      }
      document.writeln("<input size='30' type='text' name='<%=ECUserConstants.EC_ADDR_CITY%>' id='<%=ECUserConstants.EC_ADDR_CITY%>' maxlength='128'>");
   }
   else if (addrOrderList[num] == "state")
   {
      if (mandatory == true) {
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("state"))%><br>");
         
         document.writeln("<label for='<%= ECUserConstants.EC_ADDR_STATE %>_TXT' class='hidden-label'>");
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("state"))%>");
         document.writeln("</label>");
         
         document.writeln("<label for='<%= ECUserConstants.EC_ADDR_STATE %>_SEL' class='hidden-label'>");
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("state"))%>");
         document.writeln("</label>");
      } else {
      	 document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("state"))%><br>");
      	 
         document.writeln("<label for='<%= ECUserConstants.EC_ADDR_STATE %>_TXT' class='hidden-label'>");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("state"))%>");
         document.writeln("</label>");
         
         document.writeln("<label for='<%= ECUserConstants.EC_ADDR_STATE %>_SEL' class='hidden-label'>");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("state"))%>");
         document.writeln("</label>");
      }
      document.writeln("<input size='30' type='text' name='<%=ECUserConstants.EC_ADDR_STATE%>' id='<%=ECUserConstants.EC_ADDR_STATE%>_TXT' maxlength='128'  style='display:inline'>");
      document.writeln("<select name='<%=ECUserConstants.EC_ADDR_STATE%>_NOUSE' id='<%=ECUserConstants.EC_ADDR_STATE%>_SEL' style='display:none'></select>");
   }
   else if (addrOrderList[num] == "country")
   {
      if (mandatory == true) {
      	 document.writeln("<%=UIUtil.toJavaScript((String)userNLS.get("country"))%><br>");
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_COUNTRY %>\" class=\"hidden-label\">");
         document.writeln("<%=UIUtil.toJavaScript((String)userNLS.get("countryChangesState"))%>");
         document.writeln("</label>");
      } else {
      	 document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("country"))%><br>");
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_COUNTRY %>\" class=\"hidden-label\">");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("countryChangesState"))%>");
         document.writeln("</label>");
      }
      document.writeln("<select id='<%=ECUserConstants.EC_ADDR_COUNTRY%>' name='<%=ECUserConstants.EC_ADDR_COUNTRY%>' onchange='countryChange()'>");
      var foundCountry = false;
      for (country_code in countries) {
         if (country_code == "<%= country %>" || countries[country_code].name == "<%= country %>") {
                 foundCountry = true;
	         document.writeln('<option value="' + country_code + '" selected="selected">' + countries[country_code].name);
         } else {
	         document.writeln('<option value="' + country_code + '" >' + countries[country_code].name);
	 }
      }
      if (foundCountry == false && "<%= country.length() %>" != "0") {
            document.writeln('<option value="<%= UIUtil.toJavaScript(country) %>" selected="selected">' + "<%= country %>");
            countries["<%= UIUtil.toJavaScript(country) %>"] = new Object();
      }
      document.writeln('</select>');
   }
   else if (addrOrderList[num] == "zip")
   {
      if (mandatory == true) {
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ZIPCODE %>\">");
         document.writeln("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("zip"))%><br>");
         document.writeln("</label>");
      } else {
         document.writeln("<label for=\"<%= ECUserConstants.EC_ADDR_ZIPCODE %>\">");
         document.writeln("<%=UIUtil.toJavaScript((String)user2NLS.get("zip"))%><br>");
         document.writeln("</label>");
      }
      document.writeln("<input size='30' type='text' name='<%=ECUserConstants.EC_ADDR_ZIPCODE%>' id='<%=ECUserConstants.EC_ADDR_ZIPCODE%>' maxlength='40'>");
   }
}

function initializeAddressData()
{
   if ("<%=UIUtil.toJavaScript(orgEntityId)%>" != null || "<%=UIUtil.toJavaScript(orgEntityId)%>" != "" || "<%=UIUtil.toJavaScript(memberId)%>" != null || "<%=UIUtil.toJavaScript(memberId)%>" != "") {
      if (document.entryForm.address1.value == "") {
          document.entryForm.address1.value  = "<%= UIUtil.toJavaScript(address1) %>";
      }
      if (document.entryForm.address2.value == "") {
          document.entryForm.address2.value    = "<%= UIUtil.toJavaScript(address2) %>";
      }
      if (document.entryForm.address3.value == "") {
          document.entryForm.address3.value    = "<%= UIUtil.toJavaScript(address3) %>";
      }
      if (document.entryForm.city.value == "") {
          document.entryForm.city.value   = "<%= UIUtil.toJavaScript(city) %>";
      }
      if (document.entryForm.state.value == "") {
          document.entryForm.state.value  = "<%= UIUtil.toJavaScript(state) %>";
      }
      if (document.entryForm.zipCode.value == "") {
          document.entryForm.zipCode.value  = "<%= UIUtil.toJavaScript(zipCode) %>";
      }
      if (document.entryForm.country.value == "") {
          document.entryForm.country.value = "<%= UIUtil.toJavaScript(country) %>";
      }
   }
   countryChange(); // to populate state/province list given country name
}

function validateStreetAddress()
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = "<%= mandatoryLine %>";
   
   for (var i=0; i < 5; i++) {
   
   	var mandatory = (mandatoryFields.indexOf(addrOrderList[i]) == -1) ? false : true ;
   	if (addrOrderList[i] == "street")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.entryForm.address1.value))
  			{
      				return false;
  			} 
      		}
   	}
   }
   return true;
}

function validateCity()
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = "<%= mandatoryLine %>";
   
   for (var i=0; i < 5; i++) {
   
   	var mandatory = (mandatoryFields.indexOf(addrOrderList[i]) == -1) ? false : true ;
   	if (addrOrderList[i] == "city")
   	{
      		if (mandatory == true){
      			if (isEmpty(document.entryForm.city.value))
  			{
      				return false;
  			} 
      		}
	}
   }
   return true;
}


function validateState()
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = "<%= mandatoryLine %>";
   
   for (var i=0; i < 5; i++) {
   
   	var mandatory = (mandatoryFields.indexOf(addrOrderList[i]) == -1) ? false : true ;
   	if (addrOrderList[i] == "state")
   	{
      		if (mandatory == true){
      			if (isEmpty(getStateValue()))
  			{
      				return false;
  			} 
         	}
   	}
   }
   return true;
}

function validateZipCode()
{
   var addrOrder = "<%=(String)XMLUtil.get(format,"address.order")%>";
   var addrOrderList = addrOrder.split(",");
   
   var mandatoryFields = "<%= mandatoryLine %>";
   
   for (var i=0; i < 5; i++) {
   
   	var mandatory = (mandatoryFields.indexOf(addrOrderList[i]) == -1) ? false : true ;
   	if (addrOrderList[i] == "zip")
   	{
      		if (mandatory == true) {
      			if (isEmpty(document.entryForm.zipCode.value))
			{
      				return false;
  			} 
      		}
   	}
   }
   return true;
}


function validateStreetAddressLength()
{
  if(!isValidUTF8length(document.entryForm.address1.value, 50) || !isValidUTF8length(document.entryForm.address2.value, 50) || !isValidUTF8length(document.entryForm.address3.value, 50))
  {
  	return false;
  } else {
  	return true;
  }
}
  
function validateCityLength()
{ 
  if(!isValidUTF8length(document.entryForm.city.value, 128))
  {
  	return false;
  } else {
  	return true;
  }
}

function validateStateLength()
{ 
  if(!isValidUTF8length(getStateValue(), 128))
  {
  	return false;
  } else {
  	return true;
  }
}
  
function validateZipCodeLength()
{  
  if(!isValidUTF8length(document.entryForm.zipCode.value, 40))
  {
  	return false;
  } else {
  	return true;
  }
}

function getStateValue()
{
    var stateTextInputObj   = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_TXT");
    var stateSelectInputObj = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_SEL");

    if (stateSelectInputObj.style.display == "inline") {
        stateValue = stateSelectInputObj.value;
     } else {
        stateValue = stateTextInputObj.value;
     }
     return stateValue;
}

function countryChange() 
{
    var oCountry = document.entryForm.country;
    var stateTextInputObj   = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_TXT");
    var stateSelectInputObj = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_SEL");
    
    var stateTextLabelObj   = document.getElementById("LABEL_<%=ECUserConstants.EC_ADDR_STATE%>_TXT");
    var stateSelectLabelObj = document.getElementById("LABEL_<%=ECUserConstants.EC_ADDR_STATE%>_SEL");

    if (countries[oCountry.value].states) {
        // switch to state list
        populateStateList();
        swapDisplay(stateSelectInputObj, stateTextInputObj);
    } else {
        // switch to state text input
        swapDisplay(stateTextInputObj, stateSelectInputObj);
    }
}

function swapDisplay(obj1, obj2)
{
    obj1.style.display = "inline";
    obj1.name = "<%=ECUserConstants.EC_ADDR_STATE%>";
    
    obj2.style.display = "none";
    obj2.name = "<%=ECUserConstants.EC_ADDR_STATE%>_NOUSE";
}

function populateStateList()
{
    var stateTextInputObj   = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_TXT");
    var stateSelectInputObj = document.getElementById("<%=ECUserConstants.EC_ADDR_STATE%>_SEL");
    var oCountry = document.entryForm.country;
    
    // clear old options
    stateSelectInputObj.options.length = 0; 
    
    // add an empty option
    // aOption = document.createElement("OPTION");
    // stateSelectInputObj.options.add(aOption);
    // aOption.innerText = "";
    // aOption.value = "";
    
    // add all states
    var foundState = false;
    for (state_code in countries[oCountry.value].states) {
        // add a state
        aOption = document.createElement("OPTION");
        stateSelectInputObj.options.add(aOption);
        aOption.innerText = countries[oCountry.value].states[state_code];
        aOption.value = state_code;
        //alert(state_code + " " + "<%= UIUtil.toJavaScript(state) %>" + " " + aOption.innerText.toUpperCase() + " " + stateTextInputObj.value.toUpperCase());        
        if ( (state_code == "<%= UIUtil.toJavaScript(state) %>") || (aOption.innerText.toUpperCase() == stateTextInputObj.value.toUpperCase()) || (state_code == stateTextInputObj.value.toUpperCase())) {
            foundState = true;
            //alert (foundState);
            aOption.selected = true;
        }
    }
    if (foundState == false && "<%= state.length() %>" != "0") {
			aOption = document.createElement("OPTION");
			stateSelectInputObj.options.add(aOption);
			aOption.innerText = "<%= UIUtil.toJavaScript(state) %>";
			aOption.value = "<%= UIUtil.toJavaScript(state) %>";
			aOption.selected = true;
    }
}

function init()
{
   initializeAddressData();
}

</script>

<table border="0" cellpadding="1" cellspacing="0">
  <tr><th></th></tr>
  <tbody>
    <tr>
      <td valign="bottom">
        <script>displayAddrItem(0)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script>displayAddrItem(1)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script>displayAddrItem(2)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script>displayAddrItem(3)</script>
      </td>
    </tr>
    <tr>
      <td valign="bottom">
        <script>displayAddrItem(4)</script>
      </td>
    </tr>
</table>

