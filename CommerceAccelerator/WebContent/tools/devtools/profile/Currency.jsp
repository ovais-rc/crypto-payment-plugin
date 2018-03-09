<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2014
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.util.StringPair" %>
<%@page import="com.ibm.commerce.tools.devtools.store.databeans.StoreProfileEditorDataBean" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Locale" %>
<%@include file="../../common/common.jsp" %>

<%
try {

	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties storeProfileRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreProfileRB", locale);
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Vector.js" type="text/javascript"></script>
<script language="JavaScript1.2" src="/wcs/javascript/tools/common/SwapList.js"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<style type='text/css'>
.selectWidth {width: auto}
</style> 

<script>
	var currencyList = new Object();
	var STORE_DATA = "STORE_CURRENCY_DATA";
	var nonRemovableList = new Array();

	/******************************************************************************
	*
	*	Store currency object.
	*
	******************************************************************************/	
	function StoreCurrencyData(supportedCurrencyIds, defaultId)
	{
		this.supportedCurrencyIds = supportedCurrencyIds;  // maps to the CURLIST table
		this.defaultId = defaultId;  // maps to the STOREENT.SETCCURR column
	}

	function populateForm(storeCurrencyData)
	{
		var supportedIds = storeCurrencyData.supportedCurrencyIds;
		
		for (var i = 0; i < supportedIds.length; i++) {
			var description = currencyList[supportedIds[i]];
			
			if (supportedIds[i] == storeCurrencyData.defaultId)
				description = addDefault(description);
				
			document.f1.selectedCurrencies.options[i] = new Option(description, supportedIds[i]);
		}
		
		// Available currencies
		var vSupportedIds = new Vector("vSupportedIds");
		vSupportedIds.addElements(supportedIds);
		
		var j = 0;
		for (var id in currencyList) {
			if (!vSupportedIds.contains(id)) {
				document.f1.availableCurrencies.options[j++] = new Option(currencyList[id], id);
			}
		}
	}
	
	
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		<%
			StringPair currStringPair = null;
			String curCode = null;
			String desc = null;
			
			StoreProfileEditorDataBean spDB = new StoreProfileEditorDataBean();
			DataBeanManager.activate(spDB, request);
			Vector allCurrencies = spDB.getAllCurrencies();
			
			for (int i = 0; i <allCurrencies.size(); i++) {
				currStringPair = (StringPair)allCurrencies.elementAt(i);
				curCode = currStringPair.getKey();
				desc = currStringPair.getValue();
				out.println("currencyList['" + curCode + "'] = '" + UIUtil.toJavaScript(desc) + "';");	
			}	
		%>

		var storeCurrencyData = parent.get(STORE_DATA);
		
		if (storeCurrencyData == null)
		{
			var supportedCurrencyIds = new Array();
			var defaultId = new Object();
			<%
				Vector supportedCurrencies = spDB.getSupportedCurrencies();
				for (int j=0; j < supportedCurrencies.size(); j++){
					currStringPair = (StringPair)supportedCurrencies.elementAt(j);
					curCode = currStringPair.getKey();
					out.println("supportedCurrencyIds[" + j + "] = '" + curCode + "';");
				
				}
				
				if (cmdContext.getStore().getDefaultCurrency() != null) {
					out.println("defaultId = '" + cmdContext.getStore().getDefaultCurrency() + "';");
				}
							
			%>
			storeCurrencyData = new StoreCurrencyData(supportedCurrencyIds, defaultId);
		}
		<%
				//create nonRemovableCurrencyIds
				Vector currenciesInRelatedStoresOnly = spDB.getSupportedCurrenciesFromRelatedStoresOnly();
				for (int k=0; k < currenciesInRelatedStoresOnly.size(); k++){
					currStringPair = (StringPair)currenciesInRelatedStoresOnly.elementAt(k);
					curCode = currStringPair.getKey();
					out.println("nonRemovableList[" + k + "] = '" + curCode + "';");
				}
		%>
		populateForm(storeCurrencyData);
		parent.setContentFrameLoaded(true);
		initializeSloshBuckets(document.f1.selectedCurrencies, document.f1.removeButton, 
                  				document.f1.availableCurrencies, document.f1.addButton);
		disableDefaultButton();
	}

	function savePanelData()
	{
		var supportedIds = new Array();
		for (var i = 0; i < document.f1.selectedCurrencies.length; i++) {
			supportedIds[i] = document.f1.selectedCurrencies.options[i].value;
		}

		var storeData = new StoreCurrencyData(supportedIds, findDefaultId());
		parent.addURLParameter("authToken", "${authToken}");
		parent.put(STORE_DATA, storeData);
	}

	/******************************************************************************
	*
	*	Button methods.
	*
	******************************************************************************/
	function addToSelectedCollateral() {
		move(document.f1.availableCurrencies, document.f1.selectedCurrencies);
		updateSloshBuckets(document.f1.availableCurrencies, document.f1.addButton, document.f1.selectedCurrencies, document.f1.removeButton);
	}

	function removeFromSelectedCollateral() {
		//check for removing of currencies from store's path
		var currencyNames = "";
		var errorMsg = "<%=(String)storeProfileRB.getJSProperty("Currency.alert.remove4") %>";
		for (var k = 0; k < document.f1.selectedCurrencies.length; k++) {
			if (document.f1.selectedCurrencies.options[k].selected) {
				for (var j=0; j<nonRemovableList.length; j++) {
					if (nonRemovableList[j] == document.f1.selectedCurrencies.options[k].value) {
						if (currencyNames == "") {
							currencyNames += currencyList[nonRemovableList[j]];
						} else {
							currencyNames += ", " + currencyList[nonRemovableList[j]];
						} 
					}
				}
			}
		}
		if (currencyNames != "") {
			errorMsg = errorMsg.replace(/%1/, currencyNames);
			errorMsg = errorMsg.replace(/%1/, currencyNames);
			alertDialog (errorMsg);
			return;
		}
		
		//check for removing of default currency
		for (var i = 0; i < document.f1.selectedCurrencies.length; i++) {
			if (findDefaultIndex(document.f1.selectedCurrencies.options[i].text) == true &&
				document.f1.selectedCurrencies.options[i].selected) {
				alertDialog ('<%=(String)storeProfileRB.getJSProperty("Currency.alert.remove3") %>');
				return;
			}
		}
	
		move(document.f1.selectedCurrencies, document.f1.availableCurrencies);
		updateSloshBuckets(document.f1.selectedCurrencies, document.f1.removeButton, document.f1.availableCurrencies, document.f1.addButton)
		disableDefaultButton();
	}
	
	/******************************************************************************
	*
	*	Default button methods.
	*
	******************************************************************************/
	///////////////////////////////////////////////////////////////////////////
	// Sets the selected option as the default
	///////////////////////////////////////////////////////////////////////////
	function setToDefault() {

		var itemCount = countSelected(document.f1.selectedCurrencies);
		if (itemCount == 0) {
			// default button should be shown as disabled
			return;		
		} else if (itemCount > 1) {
			alertDialog ('<%=(String)storeProfileRB.getJSProperty("Currency.alert.default1") %>');
			return;
		} 

		var defaultIndex = -1;
		for (var i = 0; i < document.f1.selectedCurrencies.length; i++) {
			if (findDefaultIndex(document.f1.selectedCurrencies.options[i].text) == true){
				defaultIndex = i;
				break;
			}
		}

		var selectedIndex = -1;
		for (var i = 0; i < document.f1.selectedCurrencies.length; i++) {
			if (document.f1.selectedCurrencies.options[i].selected) {
				selectedIndex = i;
			}
		}
			
		if (defaultIndex != -1)
			document.f1.selectedCurrencies.options[defaultIndex].text = currencyList[document.f1.selectedCurrencies.options[defaultIndex].value];

		document.f1.selectedCurrencies.options[selectedIndex].text = addDefault(document.f1.selectedCurrencies.options[selectedIndex].text);

		//5706
		// need to reset the selected (it is not highlighted so user will not know it is still selected)
		// and if they press remove now, you will get a wrong message about default cannot be removed.
		// should get message about please select before remove
		if (selectedIndex != -1) {
			document.f1.selectedCurrencies.options[selectedIndex].selected = false;
			disableDefaultButton();
		}
	}

	///////////////////////////////////////////////////////////////////////////
	// Updates the state of the "Set Default" button
	///////////////////////////////////////////////////////////////////////////
	function updateDefaultButton() {
		if (countSelected(document.f1.selectedCurrencies) == 0)
			return;

		enableDefaultButton();
	}
	
	///////////////////////////////////////////////////////////////////////////
	// Enables the "Set Default" button
	///////////////////////////////////////////////////////////////////////////
	function enableDefaultButton() {
		var button = document.getElementById("defaultButton");
		button.className = "enabled";
		button.disabled = false;	
	}

	///////////////////////////////////////////////////////////////////////////
	// Disables the "Set Default" button
	///////////////////////////////////////////////////////////////////////////
	function disableDefaultButton() {
		var button = document.getElementById("defaultButton");
		button.disabled = true;
		button.className = "disabled";
	}

	///////////////////////////////////////////////////////////////////////////
	// Adds the default tag to the input field
	// Param: text the text to which the default tag needs to be added to
	///////////////////////////////////////////////////////////////////////////
	function addDefault(text) {
		return (text + " <%= (String)storeProfileRB.getJSProperty("Currency.defaultString") %>");
	}

	///////////////////////////////////////////////////////////////////////////
	// Determines if the given string contains the default tag
	// Param: text the text which needs to be searched
	// Returns: true if the given string contains the default tag,
	//			false otherwise
	///////////////////////////////////////////////////////////////////////////
	function findDefaultIndex(text) {
		pattern = new RegExp(escape("<%= (String)storeProfileRB.getJSProperty("Currency.defaultString") %>"));
		matchingpos = escape(text).search(pattern);       
		if (matchingpos != -1) {
			return true;
		} else {
			return false;
		}
	}

	///////////////////////////////////////////////////////////////////////////
	// Finds the value of the option that is the default
	// Returns: a option value if there is a default set,
	//			null otherwise
	///////////////////////////////////////////////////////////////////////////
	function findDefaultId() {
		for (var i = 0; i < document.f1.selectedCurrencies.length; i++) {
			if (findDefaultIndex(document.f1.selectedCurrencies.options[i].text) == true){
				return document.f1.selectedCurrencies.options[i].value;
			}
		}
		return null;
	}
</script>

</head>
<body class="content" onload="initializeState();updateDefaultButton();">
<h1><%= (String)storeProfileRB.getProperty("CurrencyPanel") %></h1>
<p><%= (String)storeProfileRB.getProperty("Currency.text") %></p>

<form name="f1">
<center>
<table>
    <tr>
        <td width="40%"><label for="selectedCurrencies"><%= (String)storeProfileRB.getProperty("Currency.selected") %></label></td>
        <td width="20%">&nbsp;</td>
        <td width="40%"><label for="availableCurrencies"><%= (String)storeProfileRB.getProperty("Currency.available") %></label></td>
    </tr>

    <tr>
        <td>
        	<select id="selectedCurrencies" name="selectedCurrencies" multiple size="15" class="selectWidth" tabindex="1"
					onChange="JavaScript:updateSloshBuckets(this, document.f1.removeButton, 
                  				document.f1.availableCurrencies, document.f1.addButton);updateDefaultButton()" >
              <option  selected>selected</option>
	        </select>
		</td>
		<td align="center">
			<table>
				<tr><td>
					<button type="button" name="addButton" value="<%= (String)storeProfileRB.get("Currency.add") %>" class="disabled" onclick="addToSelectedCollateral()">
						<span class="buttonText"><%= (String)storeProfileRB.get("Currency.add") %></span>
					</button>
				</td></tr>
				<tr><td>
					<button type="button" name="removeButton" value="<%= (String)storeProfileRB.get("Currency.remove") %>" class="disabled" onclick="removeFromSelectedCollateral()">
						<span class="buttonText"><%= (String)storeProfileRB.get("Currency.remove") %></span>
					</button>
				</td></tr>
			</table>
        </td>
        <td>
        	<select id="availableCurrencies" name="availableCurrencies" multiple size="15" class="selectWidth" tabindex="4"
        			onChange="JavaScript:updateSloshBuckets(this, document.f1.addButton, 
                  				document.f1.selectedCurrencies, document.f1.removeButton);disableDefaultButton()" >
		<option  selected>selected</option>
	      </select>
        </td>
    </tr>

    <tr>
        <td>
        	<input width="100%" type="button" class="button" id="defaultButton" value="<%= (String)storeProfileRB.get("Currency.default") %>" onclick="setToDefault()">
	        <br><br>
		</td>
    </tr>
</table>
<center>
</form>

</body>
<%
}
catch (Exception e) 
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
</html>
