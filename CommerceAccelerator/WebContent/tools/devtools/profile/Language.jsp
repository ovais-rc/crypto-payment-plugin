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
	var languageList = new Object();
	var STORE_DATA = "STORE_LANGUAGE_DATA";

	/******************************************************************************
	*
	*	Store language object.
	*
	******************************************************************************/	
	function StoreLanguageData(supportedLanguageIds, defaultId)
	{
		this.supportedLanguageIds = supportedLanguageIds;  // maps to the STORELANG table
		this.defaultId = defaultId;  // maps to the STORE.LANGUAGE_ID column
	}

	function populateForm(storeLanguageData)
	{
		var supportedIds = storeLanguageData.supportedLanguageIds;
		
		for (var i = 0; i < supportedIds.length; i++) {
			var description = languageList[supportedIds[i]];
			
			if (supportedIds[i] == storeLanguageData.defaultId)
				description = addDefault(description);
				
			document.f1.selectedLanguages.options[i] = new Option(description, supportedIds[i]);
		}
		
		// Available languages
		var vSupportedIds = new Vector("vSupportedIds");
		vSupportedIds.addElements(supportedIds);
		
		var j = 0;
		for (var id in languageList) {
			if (!vSupportedIds.contains(id)) {
				document.f1.availableLanguages.options[j++] = new Option(languageList[id], id);
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
			StringPair langStringPair = null;
			String langId = null;
			String desc = null;
			
			StoreProfileEditorDataBean spDB = new StoreProfileEditorDataBean();
			DataBeanManager.activate(spDB, request);
			Vector allLanguages = spDB.getAllLanguages();
			
			for (int i = 0; i <allLanguages.size(); i++) {
				langStringPair = (StringPair)allLanguages.elementAt(i);
				langId = langStringPair.getKey();
				desc = langStringPair.getValue();
				out.println("languageList['" + langId + "'] = '" + UIUtil.toJavaScript(desc) + "';");
			}	
		%>

		var storeLanguageData = parent.get(STORE_DATA);
		
		if (storeLanguageData == null)
		{
			var supportedLanguageIds = new Array();
			var defaultId = new Object();
			<%
				Vector supportedLanguages = spDB.getSupportedLanguages();
				for (int j=0; j < supportedLanguages.size(); j++){
					langStringPair = (StringPair)supportedLanguages.elementAt(j);
					langId = langStringPair.getKey();
					out.println("supportedLanguageIds[" + j + "] = '" + langId + "';");
				}
				
				if (cmdContext.getStore().getLanguageId() != null) {
					for (int k = 0; k < allLanguages.size(); k++) {
						langStringPair = (StringPair)allLanguages.elementAt(k);
						langId = langStringPair.getKey();
						if (langId.equals(cmdContext.getStore().getLanguageId())) {
							out.println("defaultId = '" + cmdContext.getStore().getLanguageId() + "';");
						}
					}
				}		
			%>

			storeLanguageData = new StoreLanguageData(supportedLanguageIds, defaultId);
		}
		
		populateForm(storeLanguageData);
		parent.setContentFrameLoaded(true);
		initializeSloshBuckets(document.f1.selectedLanguages, document.f1.removeButton, 
                  				document.f1.availableLanguages, document.f1.addButton);
		disableDefaultButton();
	}

	function savePanelData()
	{
		var supportedIds = new Array();
		for (var i = 0; i < document.f1.selectedLanguages.length; i++) {
			supportedIds[i] = document.f1.selectedLanguages.options[i].value;
		}

		var storeData = new StoreLanguageData(supportedIds, findDefaultId());
		parent.addURLParameter("authToken", "${authToken}");		
		parent.put(STORE_DATA, storeData);
	}

	/******************************************************************************
	*
	*	Button methods.
	*
	******************************************************************************/
	function addToSelectedCollateral() {
		move(document.f1.availableLanguages, document.f1.selectedLanguages);
		updateSloshBuckets(document.f1.availableLanguages, document.f1.addButton, document.f1.selectedLanguages, document.f1.removeButton)
	}

	function removeFromSelectedCollateral() {
		for (var i = 0; i < document.f1.selectedLanguages.length; i++) {
			if (findDefaultIndex(document.f1.selectedLanguages.options[i].text) == true &&
				document.f1.selectedLanguages.options[i].selected) {
				alertDialog ('<%=(String)storeProfileRB.getJSProperty("Language.alert.remove3") %>');
				return;
			}
		}
	
		move(document.f1.selectedLanguages, document.f1.availableLanguages);
		updateSloshBuckets(document.f1.selectedLanguages, document.f1.removeButton, document.f1.availableLanguages, document.f1.addButton)
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

		var itemCount = countSelected(document.f1.selectedLanguages);
		if (itemCount == 0) {
			// default button should be shown as disabled
			return;		
		} else if (itemCount > 1) {
			alertDialog ('<%=(String)storeProfileRB.getJSProperty("Language.alert.default1") %>');
			return;
		} 

		var defaultIndex = -1;
		for (var i = 0; i < document.f1.selectedLanguages.length; i++) {
			if (findDefaultIndex(document.f1.selectedLanguages.options[i].text) == true){
				defaultIndex = i;
				break;
			}
		}

		var selectedIndex = -1;
		for (var i = 0; i < document.f1.selectedLanguages.length; i++) {
			if (document.f1.selectedLanguages.options[i].selected) {
				selectedIndex = i;
			}
		}
			
		if (defaultIndex != -1)
			document.f1.selectedLanguages.options[defaultIndex].text = languageList[document.f1.selectedLanguages.options[defaultIndex].value];

		document.f1.selectedLanguages.options[selectedIndex].text = addDefault(document.f1.selectedLanguages.options[selectedIndex].text);

		//5706
		// need to reset the selected (it is not highlighted so user will not know it is still selected)
		// and if they press remove now, you will get a wrong message about default cannot be removed.
		// should get message about please select before remove
		if (selectedIndex != -1) {
			document.f1.selectedLanguages.options[selectedIndex].selected = false;
			disableDefaultButton();
		}
	}
	
	///////////////////////////////////////////////////////////////////////////
	// Updates the state of the "Set Default" button
	///////////////////////////////////////////////////////////////////////////
	function updateDefaultButton() {
		if (countSelected(document.f1.selectedLanguages) == 0)
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
		return (text + " <%= (String)storeProfileRB.getJSProperty("Language.defaultString") %>");
	}

	///////////////////////////////////////////////////////////////////////////
	// Determines if the given string contains the default tag
	// Param: text the text which needs to be searched
	// Returns: true if the given string contains the default tag,
	//			false otherwise
	///////////////////////////////////////////////////////////////////////////
	function findDefaultIndex(text) {
		pattern = new RegExp(escape("<%= (String)storeProfileRB.getJSProperty("Language.defaultString") %>"));
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
		for (var i = 0; i < document.f1.selectedLanguages.length; i++) {
			if (findDefaultIndex(document.f1.selectedLanguages.options[i].text) == true){
				return document.f1.selectedLanguages.options[i].value;
			}
		}
		return null;
	}
</script>

</head>
<body class="content" onload="initializeState();updateDefaultButton();">
<h1><%= (String)storeProfileRB.getProperty("LanguagePanel") %></h1>
<p><%= (String)storeProfileRB.getProperty("Language.text") %></p>

<form name="f1">
<center>
<table>
    <tr>
        <td width="40%"><label for="selectedLanguages"><%= (String)storeProfileRB.getProperty("Language.selected") %></label></td>
        <td width="20%">&nbsp;</td>
        <td width="40%"><label for="availableLanguages"><%= (String)storeProfileRB.getProperty("Language.available") %></label></td>
    </tr>

    <tr>
        <td>
        	<select id="selectedLanguages" name="selectedLanguages" multiple size="15" class="selectWidth" tabindex="1"
					onChange="JavaScript:updateSloshBuckets(this, document.f1.removeButton, 
                  				document.f1.availableLanguages, document.f1.addButton);updateDefaultButton()" >
              </select>
		</td>
		<td align="center">
			<table>
				<tr><td>
					<button type="button" name="addButton" value="<%= (String)storeProfileRB.get("Language.add") %>" class="disabled" onclick="addToSelectedCollateral()">
						<span class="buttonText"><%= (String)storeProfileRB.get("Language.add") %></span>
					</button>
				</td></tr>
				<tr><td>
					<button type="button" name="removeButton" value="<%= (String)storeProfileRB.get("Language.remove") %>" class="disabled" onclick="removeFromSelectedCollateral()">
						<span class="buttonText"><%= (String)storeProfileRB.get("Language.remove") %></span>
					</button>
				</td></tr>
			</table>
        </td>
        <td>
        	<select id="availableLanguages" name="availableLanguages" multiple size="15" class="selectWidth" tabindex="4"
        			onChange="JavaScript:updateSloshBuckets(this, document.f1.addButton, 
                  				document.f1.selectedLanguages, document.f1.removeButton);disableDefaultButton()" >
	</select>
        </td>
    </tr>

    <tr>
        <td>
        	<input width="100%" type="button"  class="button" id="defaultButton" value="<%= (String)storeProfileRB.get("Language.default") %>" onclick="setToDefault()">
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
