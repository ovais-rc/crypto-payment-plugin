<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.command.ECStringConverter" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.WcsApp" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@ page import="com.ibm.commerce.exception.ECApplicationException" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.Util" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>

<%@ include file="common.jsp" %>
<jsp:useBean id="storeLang" scope="request" class="com.ibm.commerce.tools.common.ui.StoreLanguageBean">
</jsp:useBean>
<%
	CommandContext cmdContext = null;
	Locale locale = null;
	Hashtable commonResource = null;
	Hashtable logonResource = null;

	// Enable store type filtering
	storeLang.setStoreTypeFiltering(true);

	cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	locale = cmdContext.getLocale();
	commonResource = (Hashtable)ResourceDirectory.lookup("common.storeLanguageSelectionNLS", locale);
	logonResource = (Hashtable)ResourceDirectory.lookup("common.logonNLS", locale);
	
	String strStoreId = ECStringConverter.IntegerToString(cmdContext.getStoreId());
	String strLangId = ECStringConverter.IntegerToString(cmdContext.getLanguageId());
	String titleStr = (String)commonResource.get("storelangtitle");
	String ibmStr = (String)logonResource.get("ibm_commerce");
	String pageHeadingStr = (String)commonResource.get("pageheading");
	String storeListTitle = (String)commonResource.get("storelistname");
	String searchCriteriaTitle = (String)commonResource.get("searchCriteriaTitle");
	String languageListTitle = (String)commonResource.get("langlistname");
	String buttonStr = (String)commonResource.get("okbuttontext");
	String cancelButtonStr = (String)commonResource.get("cancelbuttontext");
	String helpButtonStr = (String)commonResource.get("help");
	String copyrightStr = (String)logonResource.get("copyright");
	String fulfillListTitle = (String)commonResource.get("fulfilllistname");
	String pleaseSpecify = (String)commonResource.get("pleaseSpecify");
	String none = (String)commonResource.get("none");
	
	// Find Store NLS strings
	String findStoreStr = (String)commonResource.get("findStore");
	String findStr = (String)commonResource.get("find");
	String listAllStr = (String)commonResource.get("listAll");
	String criteria1Str = (String)commonResource.get("searchCriteria1");
	String criteria2Str = (String)commonResource.get("searchCriteria2");
	String criteria3Str = (String)commonResource.get("searchCriteria3");
	String criteria4Str = (String)commonResource.get("searchCriteria4");
	String criteria5Str = (String)commonResource.get("searchCriteria5");
	String missingStoreNameMsg = (String)commonResource.get("missingStoreName");
	String noMatchMsg = (String)commonResource.get("noMatch");
	String noStoreSelectedMsg = (String)commonResource.get("noStoreSelected");
	String exceedLimitMsg = (String)commonResource.get("exceedLimit");
	String resultExceedLimitMsg = (String)commonResource.get("resultExceedLimit");
	String listAllConfirmationMsg = (String)commonResource.get("listAllConfirmation");
	
	JSPHelper jspHelper = new JSPHelper(request);
	
	String error = storeLang.Init(cmdContext);
	String url = null;
	String MerchantCenterURL = jspHelper.getParameter(ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL);
	String langId = jspHelper.getParameter("langId");
	String overLimitStr = jspHelper.getParameter("overLimit");
	boolean overLimit = false;
	
	if (overLimitStr == null) {
		overLimit = storeLang.hasMoreStores();	
	}
	else {
		overLimit = (overLimitStr.equalsIgnoreCase("false"))?(false):(true);
	}

	String popup = jspHelper.getParameter("popup");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%= titleStr %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body,form { height: 100%; margin: 0 0 0 0; }
TD.contrast { background-color: #DEDEDE; }

</style>
<script type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/URLParser.js"></script>
<script type="text/javascript">
<%
	if (!error.equals(ECToolsConstants.EC_TOOLS_STORES_FINDER_EMPTY) && !error.equals(ECToolsConstants.EC_TOOLS_STORES_EXCEED_LIMIT) && !error.equals("SUCCEED") ) {
		url = "ToolsLogon?XMLFile=common.mcLogon&" + ECConstants.EC_ERROR_CODE + "=" + error;
		out.println("document.location.replace(\"" + url + "\");");
	}
%>

var defaultLangId = "<%= storeLang.getDefaultLanguage() %>";
var currentStoreId = "<%= strStoreId %>";
var currentLangId = "<%= strLangId %>";
var origSearchStoreId = "<%= UIUtil.toHTML(storeLang.getSearchStoreId()) %>";
var origSearchCriteria = "<%= UIUtil.toHTML(storeLang.getSearchCriteria()) %>";
var hasMoreStores = <%= storeLang.hasMoreStores() %>;
var overLimit = <%= overLimit %>;
var invalidCharRegExp = new RegExp(/\W/g);
var userName = "<%= cmdContext.getUser().getDisplayName() %>";
var windowName = "MerchantCenter_" + userName.replace(invalidCharRegExp, "_");
var selectedStore = null;
var storeFinder = false;
var showAll = false;
var launch = false;

<% storeLang.getStoresJS("stores", out); %>

function cancelStoreSelection()	{
	if (top.getModel) {
		top.document.location.reload();
	}
	else {
		document.location.replace("ToolsLogon?<%= ECToolsConstants.EC_XMLFILE%>=common.mcLogon");
	}		
}

function preserveParameters(origUrl, newUrl) {
	var origURLParser = new URLParser(origUrl);
	var newURLParser = new URLParser(newUrl);
	var origParamNames = origURLParser.getParameterNames();

	for (var i = 0; i < origParamNames.length; i++) {
		if (origParamNames[i] != "krypto" && origParamNames[i] != "showStoreSelection" && newURLParser.getParameterValue(origParamNames[i]) == "") {
			newUrl += "&" + origParamNames[i] + "=" + origURLParser.getParameterValue(origParamNames[i]);
		}
	}
	
	return newUrl;
}

function openHelp() {
	var helpfile= '<%= WcsApp.configProperties.getValue("Websphere/HelpServerProtocol", "http") + "://" + WcsApp.configProperties.getValue("Websphere/HelpServerHostName") + ":" + WcsApp.configProperties.getValue("Websphere/HelpServerPort", "8001") + WcsApp.configProperties.getValue("Websphere/HelpServerContextPath", "/help")%>/SSZLC2_9.0.0/com.ibm.commerce.base.doc/f1/fadstore.htm?lang=<%=locale.toString()%>';
	window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes,copyhistory=no");
}

function getStoreIndex(storeId) {
	for (var x=0; x<stores.length; x++) {
		if (stores[x].storeId == storeId) {
			return x;
		}
	}
	return null;
}

function getStoreList() {
	var storeSelection = document.getElementById("storelb");
	var newOption;

	storeSelection.options.length = 0;
	
	if (stores.length > 0 && !hasMoreStores) {
		for (var x=0; x<stores.length; x++) {
			newOption = new Option(stores[x].name, stores[x].storeId);
			storeSelection.options[storeSelection.options.length] = newOption;
	
			if (x == 0 || stores[x].storeId == currentStoreId) {
				storeSelection.options[x].selected = true;
				selectedStore = x;
			}
		}
	}
			
	if (storeSelection.options.length == 0) {
		newOption = new Option("<%= UIUtil.toJavaScript(none) %>", "");
		storeSelection.options[storeSelection.options.length] = newOption;							
	}
}

function getLanguageList() {
	var langSelection = document.getElementById("langlb");
	var newOption;
	var selectedLangId = null;

	langSelection.options.length = 0;
	if (stores.length > 0 && selectedStore != null && !hasMoreStores) {
		for (var x=0; x<stores[selectedStore].languages.length; x++) {
			newOption = new Option(stores[selectedStore].languages[x].langDesc, stores[selectedStore].languages[x].langId);
			langSelection.options[langSelection.options.length] = newOption;
	
			if (stores[selectedStore].languages[x].langId == currentLangId) {
				selectedLangId = stores[selectedStore].languages[x].langId;
				langSelection.options[x].selected = true;
			}
			else if (selectedLangId != currentLangId && (x == 0 || stores[selectedStore].languages[x].langId == defaultLangId)) {
				selectedLangId = stores[selectedStore].languages[x].langId;
				langSelection.options[x].selected = true;
			}
		}
	}
	
	if (langSelection.options.length == 0) {
		newOption = new Option("<%= UIUtil.toJavaScript(none) %>", "");
		langSelection.options[langSelection.options.length] = newOption;
	}
}

function getFulfillmentList() {
	var ffcSelection = document.getElementById("fulfilllb");
	var newOption;

	ffcSelection.options.length = 0;
	
	if (stores.length > 0 && !hasMoreStores) {
		for (var x=0; x<stores[selectedStore].ffc.length; x++) {
			if (x == 0 && stores[selectedStore].ffc.length > 1) {
				newOption = new Option("<%= UIUtil.toJavaScript(pleaseSpecify) %>", "");
				ffcSelection.options[ffcSelection.options.length] = newOption;
			}
	
			newOption = new Option(stores[selectedStore].ffc[x].ffcDesc, stores[selectedStore].ffc[x].ffcId);
			ffcSelection.options[ffcSelection.options.length] = newOption;
			ffcSelection.options[0].selected = true;
		}
	}
	
	if (ffcSelection.options.length == 0) {
		newOption = new Option("<%= UIUtil.toJavaScript(none) %>", "");
		ffcSelection.options[ffcSelection.options.length] = newOption;
	}
}

function loadSearchParameters() {
	document.f1.searchStoreId.value = origSearchStoreId;
	
	if (origSearchCriteria != "" && document.f1.searchCriteria.options[origSearchCriteria-1]) {
		document.f1.searchCriteria.options[origSearchCriteria-1].selected = true;
	}
}

function updateForm(storeId) {
	selectedStore = getStoreIndex(storeId);
	getLanguageList();
	getFulfillmentList();
}

function findStore() {
	storeFinder = true;
	showAll = false;
}

function showAllStores() {
	storeFinder = false;
	showAll = true;
}

function launchMC(storeid, storetype, langid, ffmid) {
	var mc = "<%= UIUtil.toHTML(MerchantCenterURL) %>" + storetype + "&<%= ECConstants.EC_STORE_ID %>=" + storeid;
	var language = "<%= ECConstants.EC_LANGUAGE_ID %>";
	var fulfillment = "<%= ECToolsConstants.EC_TOOLS_FULFILLMENT_CENTER_ID %>";
	var curtime = new Date();
	var launchURL;

	if (stores.length == 0 || storeid == 0 || storeid == null) {		
		alertDialog("<%= UIUtil.toJavaScript(noStoreSelectedMsg) %>");
		launch = false;
		return false;
	}
		
	if (langid == "") {
		launchURL =  mc +  "&time=" + curtime.getTime();
	}
	else {
		launchURL =  mc +  "&" + language + "=" + langid + "&time=" + curtime.getTime();
	}

	launchURL = launchURL + "&" + fulfillment + "=" + ffmid;

	// preserves the rest of the parameters from the top URL.
	launchURL = preserveParameters(top.document.URL, launchURL);

	if (top.getModel || "<%= UIUtil.toHTML(popup) %>" == "false") { // if inside MC, just refresh it!
		top.location.replace(launchURL);
		return false;
	}
	else {
		window.open(launchURL, windowName, 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes').focus();
		return true;
	}
}

function submitHandler() {   	
  	if (showAll) {
		if (overLimit) {
			if (!confirmDialog("<%= UIUtil.toJavaScript(listAllConfirmationMsg) %>")) {
				return false;
			}
		}
  		document.f1.searchStoreId.value = "";
		document.f1.searchCriteria.options[0].selected = true;
		document.f1.listAllStores.value = "true";
   		return true;
   	}
   	else if (launch) {
		var ffmId = (document.f1.fid.selectedIndex > -1)?(document.f1.fid.options[document.f1.fid.selectedIndex].value):("");
		var langId = (document.f1.lid.selectedIndex > -1)?(document.f1.lid.options[document.f1.lid.selectedIndex].value):("");
		var storeId = (document.f1.sid.selectedIndex > -1)?(document.f1.sid.options[document.f1.sid.selectedIndex].value):(0);
		var storeType = (getStoreIndex(storeId) != null)?(stores[getStoreIndex(storeId)].type):("B2C");
	
		if (launchMC(storeId, storeType, langId, ffmId)) {
			document.location = "<%= UIUtil.getWebappPath(request) %>MCLaunched?&<%= ECConstants.EC_LANGUAGE_ID %>=" + langId + "&<%= ECConstants.EC_STORE_ID %>=" + storeId;
		}
		
		return false;		
   	}		
	else {
   		if (isEmpty(document.f1.searchStoreId.value)) {
   			alertDialog("<%= UIUtil.toJavaScript(missingStoreNameMsg) %>");
   			return false;
   		}
   		else {
   			return true;
		}   			
	}
}

function init() {
	getStoreList();
	getLanguageList();
	getFulfillmentList();
	loadSearchParameters();
<%	
	if (error.equals(ECToolsConstants.EC_TOOLS_STORES_FINDER_EMPTY)) {
		out.println("\talertDialog(\"" + UIUtil.toJavaScript(noMatchMsg) + "\");");
	}
	else if (error.equals(ECToolsConstants.EC_TOOLS_STORES_EXCEED_LIMIT)) {
%>	
	if (document.f1.searchStoreId.value == "") {
		alertDialog("<%= UIUtil.toJavaScript(exceedLimitMsg) %>");
	}
	else if (confirmDialog("<%= UIUtil.toJavaScript(resultExceedLimitMsg) %>")) {
		document.f1.listAllStores.value = "true";
		document.f1.submit();		
	}	
<%
	}
%>		
}

if (stores.length == 1 && stores[0].languages.length == 1 && stores[0].ffc.length<=1){
	var ffcId = (stores[0].ffc.length == 1)?(stores[0].ffc[0].ffcId):("");
	if (launchMC(stores[0].storeId, stores[0].type, stores[0].languages[0].langId, ffcId)) {
		document.location.replace("<%= UIUtil.getWebappPath(request) %>MCLaunched?<%= ECConstants.EC_LANGUAGE_ID %>=" + stores[0].languages[0].langId + "&<%= ECConstants.EC_STORE_ID %>=" + stores[0].storeId);
	}
}

</script>
</head>
<body onload="init();">
<form name="f1" method="post" action="StoreLanguageSelection" onsubmit="return submitHandler();">
<input type="hidden" name="<%= ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL %>" value="<%= UIUtil.toHTML(MerchantCenterURL) %>"/>
<input type="hidden" name="listAllStores" value="false"/>
<input type="hidden" name="overLimit" value="<%= overLimit %>"/>
<input type="hidden" name="popup" value="<%= UIUtil.toHTML(popup) %>" />
<div style="position: absolute; top: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<thead>
			<tr>
				<td class="blue"><%= ibmStr %></td>
			</tr>
		</thead>
	</table>
</div>
<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
	<tbody>
		<tr>
			<td valign="top" height="100%">		
				<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%">
					<tbody>
						<tr>
							<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
								<%= pageHeadingStr %>
							</td>
							<td class="contrast" height="40" width="361"></td>
						</tr>
						<tr>
							<td valign="top" style="padding-left: 25px;">
								<table border="0" cellpadding="5" cellspacing="0">
									<tbody>
										<tr>
											<td class="text"><label for="storelb"><%= storeListTitle %></label></td>
											<td style="padding-left: 10px;"><%= findStoreStr %></td>
										</tr>
										<tr>
											<td>
												<select id="storelb" name="sid" size="5" onchange="updateForm(this.options[this.selectedIndex].value);"></select>
											</td>
											<td valign="top">
												<table border="0" cellspacing="0" cellpadding="5">
													<tbody>
														<tr>
															<td><label for="searchStoreId"><%= storeListTitle %></label></td>
															<td><label for="searchCriteria"><%= searchCriteriaTitle %></label></td>
														</tr>
														<tr>
															<td><input type="text" id="searchStoreId" name="searchStoreId" maxlength="254"/></td>
															<td>							
																<select id="searchCriteria" name="searchCriteria">
																	<option value="1"><%= criteria1Str %></option>
																	<option value="2"><%= criteria2Str %></option>
																	<option value="3"><%= criteria3Str %></option>
																	<option value="4"><%= criteria4Str %></option>
																	<option value="5"><%= criteria5Str %></option>
																</select>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<button type="submit" onclick="findStore();"><%= findStr %></button>&nbsp;<button type="submit" onclick="showAllStores();"><%= listAllStr %></button>
															</td>
														</tr>
													</tbody>
												</table>
											</td>											
										</tr>
										<tr>
											<td class="text"><label for="fulfilllb"><%= fulfillListTitle %></label></td>
											<td></td>
										</tr>
										<tr>
											<td colspan="2">
												<select id="fulfilllb" name="fid"></select>
											</td>
										</tr>
										<tr>
											<td class="text"><label for="langlb"><%= languageListTitle %></label></td>
											<td></td>
										</tr>
										<tr>
											<td>
												<select id="langlb" name="lid"></select>
											</td>
											<td></td>
										</tr>
										<tr>
											<td height="15" colspan="2"></td>
										</tr>
										<tr>
											<td colspan="2">
												<button type="submit" onclick="launch=true;"><%= buttonStr %></button>
												&nbsp;
												<button type="button" onclick="cancelStoreSelection();"><%= cancelButtonStr %></button>
												&nbsp;
												<button type="button" onclick="openHelp();"><%= helpButtonStr %></button>
											</td>
										</tr>
									</tbody>
								</table>															
							</td>
							<td class="contrast" valign="top" height="50%">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td class="contrast" height="67" style="background-image: url('<%= UIUtil.getWebPrefix(request) %>images/tools/logon/logon.jpg'); background-repeat: repeat;"></td>
										</tr>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<div style="position: absolute; bottom: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<tfoot>
			<tr>
				<td bgcolor="#FFFFFF" height="1"></td>		
			</tr>
			<tr>
				<td class="legal"><%= copyrightStr %></td>
			</tr>	
		</tfoot>
	</table>
</div>
</form>
</body>
</html>
