<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.common.beans.StoreAddressDataBean" %>
<%@page import="com.ibm.commerce.common.objects.StoreEntityDescriptionAccessBean" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.user.beans.CountryStateListDataBean" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Locale" %>

<%@include file="../../common/common.jsp" %>

<jsp:useBean id="countryDB" class="com.ibm.commerce.user.beans.CountryStateListDataBean" scope="page">
	<% com.ibm.commerce.beans.DataBeanManager.activate(countryDB, request); %>
</jsp:useBean>

<%
try
{
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties storeProfileRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreProfileRB", locale);
%>

<%
	String country = null;
	String zipcode = null;
	String city = null;
	String state = null;
	String address1 = null;
	String address2 = null;
	String phone = null;
	String fax = null;
	String email = null;
	
	StoreEntityDescriptionAccessBean storeDescription = null;
	
	try {
		storeDescription = cmdContext.getStore().getDescription(cmdContext.getLanguageId());
	}catch(javax.persistence.NoResultException e1){
		storeDescription = null; // JTest filler
	}

	if (storeDescription != null) {
		Integer addressId = storeDescription.getContactAddressIdInEntityType();
	
		if (addressId != null)
		{
			StoreAddressDataBean storeAddressDB = new StoreAddressDataBean();
			storeAddressDB.setDataBeanKeyStoreAddressId(addressId.toString());
			DataBeanManager.activate(storeAddressDB, request);
	
			country = storeAddressDB.getCountry();
			zipcode = storeAddressDB.getZipCode();
			city = storeAddressDB.getCity();
			state = storeAddressDB.getState();
			address1 = storeAddressDB.getAddress1();
			address2 = storeAddressDB.getAddress2();
			phone = storeAddressDB.getPhone1();
			fax = storeAddressDB.getFax1();
			email = storeAddressDB.getEmail1();
		}
	}
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
function country() {
	this.code;
	this.name;
	this.states;
}

function state() {
	this.code;
	this.name;
}

//retrieve saved information from the framework or populate data from the bean.
//addressData will contain the latest selections from user.
var addressData = parent.get(parent.CONTACT_DATA_ID);
		
if (addressData == null)
{
	addressData = new AddressData();
	addressData.address1 = "<%= UIUtil.toJavaScript(address1) %>";
	addressData.address2 = "<%= UIUtil.toJavaScript(address2) %>";
	addressData.city = "<%= UIUtil.toJavaScript(city) %>";
	addressData.state = "<%= UIUtil.toJavaScript(state) %>";
	addressData.country = "<%= UIUtil.toJavaScript(country) %>";
	addressData.zipcode = "<%= UIUtil.toJavaScript(zipcode) %>";
	addressData.phone = "<%= UIUtil.toJavaScript(phone) %>";
	addressData.fax = "<%= UIUtil.toJavaScript(fax) %>";
	addressData.email = "<%= UIUtil.toJavaScript(email) %>";
}

//get the list of all countries and states available from the database.
var countryVector = new Vector();
var statesForCurrentCountry = new Vector();

var countries = new Array();

<%
Vector countries = countryDB.getCountries();
CountryStateListDataBean.Country aCountry = null;
CountryStateListDataBean.StateProvince[] states = null;
boolean countryFound = false;
		
for (int i=0; i<countries.size(); i++) {
	aCountry = (CountryStateListDataBean.Country)countries.elementAt(i);
	
	if (country != null && !country.equals("") && (aCountry.getCode().equals(country) || aCountry.getDisplayName().equals(country))) {
		countryFound = true;
	}
%>
	countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"] = new Object();
	countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].name = "<%= UIUtil.toJavaScript(aCountry.getDisplayName()) %>";
	
	var countryTemp = new country();
	countryTemp.code = "<%= UIUtil.toJavaScript(aCountry.getCode()) %>";
	countryTemp.name = "<%= UIUtil.toJavaScript(aCountry.getDisplayName()) %>";
	var countryStates = new Vector();
<%
	states = aCountry.getStates();
	for (int k=0; k<states.length; k++) {
		if (k==0) {
		%>
			countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].states = new Object();
		<%
		}
		%>
			countries["<%= UIUtil.toJavaScript(aCountry.getCode()) %>"].states["<%= UIUtil.toJavaScript(states[k].getCode()) %>"] = "<%= UIUtil.toJavaScript(states[k].getDisplayName()) %>";

			var stateTemp = new state();
			stateTemp.code = "<%= UIUtil.toJavaScript(states[k].getCode()) %>";
			stateTemp.name = "<%= UIUtil.toJavaScript(states[k].getDisplayName()) %>";
			countryStates.addElement(stateTemp);
			if (addressData.country == countryTemp.code) {
				statesForCurrentCountry.addElement(stateTemp);
			}
		<%
	}
	%>
	countryTemp.states = countryStates;
	countryVector.addElement(countryTemp);
<%
}

if (!countryFound && country != null && !country.equals("")) {
%>
  if (countryVector.size() != 0) {
		var countryTemp = new country();
		countryTemp.code = "<%= country %>";
		countryTemp.name = "<%= country %>";
		countryTemp.states = new Vector();;
		countryVector.addElement(countryTemp);
	}
<%
}
%>

/******************************************************************************
*
*	Reload the state field to be input or select depending on the data.
*
******************************************************************************/	
function loadStatesUI(form, paramPrefix)
{
		var currentState = form[paramPrefix + "state"].value;
    var currentCountryCode = form[paramPrefix + "country"].value;
    var stateDivObj = document.getElementById(paramPrefix + "stateDiv");
		while(stateDivObj.hasChildNodes()) {
			stateDivObj.removeChild(stateDivObj.firstChild);
		}

    if (countries[currentCountryCode].states) {
        // switch to state list
        stateDivObj.appendChild(createStateWithOptions(paramPrefix, currentCountryCode, currentState));
    } else {
        // switch to state text input
        stateDivObj.appendChild(createState(paramPrefix, currentState));
    }
}


/******************************************************************************
*
*	Create an input element to represent the state.
*
******************************************************************************/	
function createState(paramPrefix, currentState)
{
		var stateInput = document.createElement("input");
		stateInput.setAttribute("id", paramPrefix + "state");
		stateInput.setAttribute("name", paramPrefix + "state");
		stateInput.setAttribute("style", "width: 200px");
		stateInput.setAttribute("maxlength", "128");
		//stateInput.setAttribute("value", currentState);
		return stateInput
}

/******************************************************************************
*
*	Create an select element to represent the state and load it with the 
* corresponding states as defined in the database.
*
******************************************************************************/	
function createStateWithOptions(paramPrefix, currentCountryCode, currentState)
{
		var stateSelect = document.createElement("select");
		stateSelect.setAttribute("id", paramPrefix + "state");
		stateSelect.setAttribute("name", paramPrefix + "state");
		
    // clear old options
    stateSelect.options.length = 0;
    
    // add all states
    //var foundState = false;
    for (state_code in countries[currentCountryCode].states) {
        // add a state
        aOption = document.createElement("option");
        stateSelect.options.add(aOption);
        aOption.text = countries[currentCountryCode].states[state_code];
        aOption.value = state_code;

        //if (state_code == currentState || countries[currentCountryCode].states[state_code] == currentState) {
        //    foundState = true;
        //    aOption.selected = true;
        //}
    }
    //if (foundState == false && currentState != "") {
		//	aOption = document.createElement("option");
		//	stateSelect.options.add(aOption);
		//	aOption.text = currentState;
		//	aOption.value = currentState;
		//	aOption.selected = true;
    //}
    
    return stateSelect;
}

	/******************************************************************************
	*
	*	Address data object.
	*
	******************************************************************************/	
	function AddressData()
	{
		this.address1;
		this.address2;
		this.city;
		this.state;
		this.country;
		this.zipcode;
		this.phone;
		this.fax;
		this.email;
	}

	function populateForm(addressData)
	{
		document.address.address1.value = addressData.address1;
		document.address.address2.value = addressData.address2;
		document.address.city.value = addressData.city;
		document.address.state.value = addressData.state;
		document.address.country.value = addressData.country;
		for (i=0; i<countryVector.size(); i++) {
        	aCountry = countryVector.elementAt(i);
        	if (aCountry.name == addressData.country) {
        		document.address.country.value = aCountry.code;
        	}
    }
		document.address.zipcode.value = addressData.zipcode;
		document.address.phone.value = addressData.phone;
		document.address.fax.value = addressData.fax;
		document.address.email.value = addressData.email;
	}

	function processErrors()
	{
		var errorCode = parent.get(parent.ERROR_CODE);

		if (errorCode == null)
			return;

		// alertDialog("Unexpected error");
		
		parent.remove(parent.ERROR_CODE);
	}		
		
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		processErrors();		
		parent.setContentFrameLoaded(true);	
	}

	function savePanelData()
	{
		var addressData = new AddressData();
		addressData.address1 = document.address.address1.value;
		addressData.address2 = document.address.address2.value;
		addressData.city = document.address.city.value;
		addressData.state = document.address.state.value;
		addressData.country = document.address.country.value;
		addressData.zipcode = document.address.zipcode.value;
		addressData.phone = document.address.phone.value;
		addressData.fax = document.address.fax.value;
		addressData.email = document.address.email.value;
		
		parent.addURLParameter("authToken", "${authToken}");
		parent.put(parent.CONTACT_DATA_ID, addressData);
	}
</script>

</head>
<body class="content" onload="">
<h1><%= (String)storeProfileRB.getProperty("ContactPanel") %></h1>


<form name="address"><%
	if (locale.toString().equals("de_DE") || locale.toString().equals("fr_FR"))
	{
%>
<table>
    <tr>
        <% String addressTitle = (String)storeProfileRB.get("Address.address"); %>
        <td colspan="2"><label for="address1"><%= addressTitle %></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%" type='text' id="address1" name="address1" value=" " maxlength="50" title='<%= addressTitle + " 1" %>'></td>
    </tr>
    <tr>        
        <td colspan="2"><label for="address2"></label><input style="width: 100%" type='text' value=" " id="address2" name="address2" maxlength="50" title='<%= addressTitle + " 2" %>'></td>
    </tr>
    <tr>
        <td><label for="zipcode"><%= (String)storeProfileRB.getProperty("Address.zip/postalcode") %></label></td>
        <td colspan="2"><label for="city"><%= (String)storeProfileRB.getProperty("Address.city") %></label></td>
    </tr>
    <tr>
        <td><input style="width: 200px" type='text'value=" " id="zipcode" name="zipcode" maxlength="40"></td>
        <td><input style="width: 200px" type='text'value=" " id="city" name="city" maxlength="128"></td>
    </tr>
    <tr>
        <td><label for="state"><%= (String)storeProfileRB.getProperty("Address.state/province") %></label></td>
        <td><label for="country"><%= (String)storeProfileRB.getProperty("Address.country") %></label></td>
    </tr>
    <tr>
        <td>
        	<div id="stateDiv">
	<script>
	if (addressData.country == "") {
		document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
	} else {
		if (statesForCurrentCountry.size() == 0) {
			document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
		} else {
			document.writeln('<select id="state_db" name="state">');
        		document.writeln('<option value="">');
			for (k=0; k<statesForCurrentCountry.size(); k++) {
				aState = statesForCurrentCountry.elementAt(k);
				document.writeln('<option value="' + aState.code + '" >' + aState.name);
			}
			document.writeln('</select>');
		}
	}
	</script>
					</div>
        </td>
        <td>
        <script>
        document.writeln('<select id="country_db" name="country" onChange="javascript:loadStatesUI(document.address, \'\')">');
        document.writeln('<option value="">');
        for (i=0; i<countryVector.size(); i++) {
        	aCountry = countryVector.elementAt(i);
		document.writeln('<option value="' + aCountry.code + '" >' + aCountry.name);
	}
	document.writeln('</select>');
	</script>
        </td>
    </tr>
    <tr>
        <td><label for="phone"><%= (String)storeProfileRB.getProperty("Address.phone") %></label></td>
        <td><label for="fax"><%= (String)storeProfileRB.getProperty("Address.fax") %></label></td>
    </tr>
    <tr>
        <td><input style="width: 200px" type="text" value=" "id="phone" name="phone" maxlength="32"></td>
        <td><input style="width: 200px" type="text"value=" " id="fax" name="fax" maxlength ="32"></td>
    </tr>
    <tr>
        <td colspan="2"><label for="email"><%= (String)storeProfileRB.getProperty("Address.email") %></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%"value=" " type="text" id="email" name="email" maxlength="254"></td>
    </tr>
</table>

<%
	}
	else if (locale.toString().equals("ja_JP") || locale.toString().equals("ko_KR") || locale.toString().equals("zh_CN") || locale.toString().equals("zh_TW"))
	{
%>

<table>
    <tr>
        <td><label for="country_db"><%= (String)storeProfileRB.getProperty("Address.country") %></label></td>
        <td colspan="2"><label for="zipcode_db"><%= (String)storeProfileRB.get("Address.zip/postalcode") %></label></td>
    </tr>
    <tr>
        <td>
        <script>
        document.writeln('<select id="country_db" name="country" onChange="javascript:loadStatesUI(document.address, \'\')">');
        document.writeln('<option value="">');
        for (i=0; i<countryVector.size(); i++) {
        	aCountry = countryVector.elementAt(i);
		document.writeln('<option value="' + aCountry.code + '" >' + aCountry.name);
	}
	document.writeln('</select>');
	</script>
        </td>
        <td><input style="width: 200px"value=" " type='text' id="zipcode_db" name="zipcode" maxlength="40"></td>
    </tr>
    <tr>
        <td><label for="state_db"><%= (String)storeProfileRB.get("Address.state/province") %></label></td>
        <td><label for="city_db"><%= (String)storeProfileRB.get("Address.city") %></label></td>
    </tr>
    <tr>
        <td>
        	<div id="stateDiv">
	<script>
	if (addressData.country == "") {
		document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
	} else {
		if (statesForCurrentCountry.size() == 0) {
			document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
		} else {
			document.writeln('<select id="state_db" name="state">');
        		document.writeln('<option value="">');
			for (k=0; k<statesForCurrentCountry.size(); k++) {
				aState = statesForCurrentCountry.elementAt(k);
				document.writeln('<option value="' + aState.code + '" >' + aState.name);
			}
			document.writeln('</select>');
		}
	}
	</script>
					</div>
        </td>
        <td><input style="width: 200px"value=" " type='text' id="city_db" name="city" maxlength="128"></td>
    </tr>
    <tr>
    <% String addressTitle = (String)storeProfileRB.get("Address.address"); %>
        <td colspan="2"><label for="address1_db"><%= addressTitle %></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%" value=" " type='text' id="address1_db" name="address1" maxlength="50" title='<%= addressTitle + " 1" %>'></td>
    </tr>
    <tr>
        <td colspan="2"><label for="address2_db"></label><input style="width: 100%" value=" " type='text' id="address2_db" name="address2" maxlength="50" title='<%= addressTitle + " 2" %>'></td>
    </tr>
    <tr>
        <td><label for="phone_db"><%= (String)storeProfileRB.get("Address.phone") %></label></td>
        <td><label for="fax_db"><%= (String)storeProfileRB.get("Address.fax") %></label></td>
    </tr>
    <tr>
        <td><input style="width: 200px" value=" " type="text" id="phone_db" name="phone" maxlength="32"></td>
        <td><input style="width: 200px" value=" " type="text" id="fax_db" name="fax" maxlength="32"></td>
    </tr>
    <tr>
        <td colspan="2"><label for="email_db"><%= (String)storeProfileRB.get("Address.email") %></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%" value=" " type="text" id="email_db" name="email" maxlength="254"></td>
    </tr>
</table>

<%
	}
	else
	{
%>
<table>
    <tr>
    	<% String addressTitle = (String) storeProfileRB.getProperty("Address.address"); %>
        <td colspan="2"><label for="address1_1"><%= addressTitle%></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%" value=" " title='<%= addressTitle + " 1"%>' type="text" id="address1_1" name="address1" maxlength="50"></td>
    </tr>
    <tr>
        <td colspan="2"><label for="address2_1"></label><input style="width: 100%" value=" " title='<%= addressTitle + " 2"%>' type="text" id="address2_1" name="address2" maxlength="50"></td>
    </tr>
    <tr>
        <td><label for="city_1"><%= (String)storeProfileRB.getProperty("Address.city") %></label></td>
        <td><label for="state_1"><%= (String)storeProfileRB.getProperty("Address.state/province") %></label></td>
    </tr>
    <tr>
        <td><input style="width: 200px" value=" " type="text" id="city_1" name="city" maxlength="128"></td>
        <td>
        	<div id="stateDiv">
	<script>
	if (addressData.country == "") {
		document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
	} else {
		if (statesForCurrentCountry.size() == 0) {
			document.writeln('<input style="width: 200px" type="text" id="state_db" name="state" maxlength="128">');
		} else {
			document.writeln('<select id="state_db" name="state">');
        		document.writeln('<option value="">');
			for (k=0; k<statesForCurrentCountry.size(); k++) {
				aState = statesForCurrentCountry.elementAt(k);
				document.writeln('<option value="' + aState.code + '" >' + aState.name);
			}
			document.writeln('</select>');
		}
	}
	</script>
					</div>
        </td>
    </tr>
    <tr>
        <td><label for="country_1"><%= (String)storeProfileRB.getProperty("Address.country") %></label></td>
        <td><label for="zipcode_1"><%= (String)storeProfileRB.getProperty("Address.zip/postalcode") %></label></td>
    </tr>
    <tr>
        <td>
        <script>
        document.writeln('<select id="country_db" name="country" onChange="javascript:loadStatesUI(document.address, \'\')">');
        document.writeln('<option value="">');
        for (i=0; i<countryVector.size(); i++) {
        	aCountry = countryVector.elementAt(i);
		document.writeln('<option value="' + aCountry.code + '" >' + aCountry.name);
	}
	document.writeln('</select>');
	</script>
        </td>
        <td><input style="width: 200px"value=" " type="text" id="zipcode_1" name="zipcode" maxlength="40"></td>
    </tr>
    <tr>
        <td><label for="phone_1"><%= (String)storeProfileRB.getProperty("Address.phone") %></label></td>
        <td><label for="fax_1"><%= (String)storeProfileRB.getProperty("Address.fax") %></label></td>
    </tr>
    <tr>
        <td><input style="width: 200px" value=" " type="text" id="phone_1" name="phone" maxlength="32"></td>
        <td><input style="width: 200px" value=" " type="text" id="fax_1" name="fax" maxlength="32"></td>
    </tr>
    <tr>
        <td colspan="2"><label for="email_1"><%= (String)storeProfileRB.getProperty("Address.email") %></label></td>
    </tr>
    <tr>
        <td colspan="2"><input style="width: 100%" value=" " type="text" id="email_1" name="email" maxlength="254"></td>
    </tr>
</table>
<%
	}
%></form>

<script>
populateForm(addressData);
initializeState();
</script>

</body>
<%
}
catch (Exception e) 
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
</html>
