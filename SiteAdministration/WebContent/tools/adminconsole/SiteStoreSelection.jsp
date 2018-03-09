<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.base.objects.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@include file="../common/common.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="storeLang" scope="request" class="com.ibm.commerce.tools.common.ui.StoreLanguageBean"></jsp:useBean>
<%	
	CommandContext cmdContext = null;
	Locale locale = null;
	Hashtable adminConsoleNLS = null;
	String webalias = UIUtil.getWebPrefix(request);
	JSPHelper jspHelper = new JSPHelper(request);
	
	try {
		cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		locale = cmdContext.getLocale();		
		adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
	}
	catch (Exception e) {
		throw new ECApplicationException();
	}
	
	String storeLangError = storeLang.Init(cmdContext);
	
	String titleStr = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleSiteStoreTitle"));
	String ibmStr = UIUtil.toHTML((String)adminConsoleNLS.get("ibm_commerce"));
	String pageHeadingStr = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleStoreLangHeading"));
	String storeListTitle = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleStorelistname"));
	String languageListTitle = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleLanglistname"));
	String okButtonStr = UIUtil.toHTML((String)adminConsoleNLS.get("okButton"));
	String cancelButtonStr = UIUtil.toHTML((String)adminConsoleNLS.get("cancelButton"));
	String helpButtonStr = UIUtil.toHTML((String)adminConsoleNLS.get("help"));
	
	String tableSumSiteStr = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleTableSumSiteSelection"));
	String tableSumSiteButtonStr = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleTableSumSiteButton"));
	String tableSumStoreStr = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleTableSumStoreSelection"));
	String tableSumStoreButtonStr = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleTableSumStoreButton"));
	
	String copyright = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleCopyright"));
	
	// Find Store NLS strings
	String findStoreStr = (String)adminConsoleNLS.get("findStore");
	String findStr = (String)adminConsoleNLS.get("find");
	String listAllStr = (String)adminConsoleNLS.get("listAll");
	String criteria1Str = (String)adminConsoleNLS.get("searchCriteria1");
	String criteria2Str = (String)adminConsoleNLS.get("searchCriteria2");
	String criteria3Str = (String)adminConsoleNLS.get("searchCriteria3");
	String criteria4Str = (String)adminConsoleNLS.get("searchCriteria4");
	String criteria5Str = (String)adminConsoleNLS.get("searchCriteria5");
	String missingStoreNameMsg = (String)adminConsoleNLS.get("missingStoreName");
	String noMatchMsg = (String)adminConsoleNLS.get("noMatch");
	String noStoreSelectedMsg = (String)adminConsoleNLS.get("noStoreSelected");
	String none = (String)adminConsoleNLS.get("none");
	String exceedLimitMsg = (String)adminConsoleNLS.get("exceedLimit");
	String listAllConfirmationMsg = (String)adminConsoleNLS.get("listAllConfirmation");
	String storeEmptyMsg = (String) adminConsoleNLS.get("AdminConsoleStoresEmpty");
	
	String AdminConsoleURL = jspHelper.getParameter(ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL);
	String storeFinder = jspHelper.getParameter("storeFinder");
	int index = AdminConsoleURL.indexOf("?");
	String accommand =null;
	String nvname= null;
	String nvvalue=null; 
	
	if (index >=0) {
		accommand = AdminConsoleURL.substring(0, index);
		String nvp = AdminConsoleURL.substring(index+1);
		index = nvp.indexOf("=");
		nvname=nvp.substring(0, index);
		nvvalue = nvp.substring(index+1);
	}
	else { 
		accommand = AdminConsoleURL;
	}

	String overLimitStr = jspHelper.getParameter("overLimit");
	boolean overLimit = false;
	
	if (overLimitStr == null) {
		overLimit = storeLang.hasMoreStores();	
	}
	else {
		overLimit = (overLimitStr.equalsIgnoreCase("false"))?(false):(true);
	}
		
	Integer userLangId = null;
	String user_strLangId = null;
	Long userId = null;
	UserAccessBean uab = null;
	Enumeration storeList = null;
	
	String error = null;
	String redirURL = UIUtil.getWebappPath(request) + "ToolsLogon?XMLFile=adminconsole.AdminConsoleLogon";
	
	String strLangId = null;
	String strStoreId = null;
	String selectStore = null;
	String orig_strStoreId = null;
	String orig_strLangId = null;
	Integer temp_storeId = null;
	int storeSelected = 0;
	
	strStoreId = (String) request.getParameter(ECConstants.EC_STORE_ID);
	selectStore = (String) request.getParameter("selectStore");
	orig_strStoreId = (String) request.getParameter("origStoreId");
	orig_strLangId = (String) request.getParameter("origLangId");
	
	UserRegistrationDataBean urdb = new UserRegistrationDataBean();
	boolean isSiteAdmin = false;
	
	if (selectStore == null) {
		selectStore = "9";
	}		
	
	try {
		if (cmdContext != null) {
			userId = cmdContext.getUserId();
			uab = cmdContext.getUser();
			urdb.setDataBeanKeyMemberId(userId.toString());
			DataBeanManager.activate(urdb, request);
			
			Integer[] roleList = urdb.getRoles();
			
			for (int i=0; i < roleList.length; i++) {
				String roleId = roleList[i].toString();
				if (roleId.equals("-1")) {
					isSiteAdmin = true;
				}
			}
						
			if (uab != null) { 
				if (!isSiteAdmin && !(uab.isSiteAdministrator())) {             
					error = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleStoresNotAdministrator"));
				}
			}						

			temp_storeId = cmdContext.getStoreId();
			if (selectStore.equals("1") && (strStoreId == null) && (temp_storeId != null)) {
				strStoreId = ECStringConverter.IntegerToString(temp_storeId);
			} 
			
			// display the store name in user's preferred language 
			userLangId = cmdContext.getLanguageId();
			if (userLangId != null) {
				user_strLangId = ECStringConverter.IntegerToString(userLangId);
				strLangId = user_strLangId;
			} 
		}
	
		if ((cmdContext == null) || (uab == null)) { 
			error = UIUtil.toHTML((String) adminConsoleNLS.get("AdminConsoleStoresAccessControlRequired"));
		}
	
		if (orig_strStoreId == null && (selectStore.equals("1") && temp_storeId != null)) { 
			orig_strStoreId = ECStringConverter.IntegerToString(temp_storeId);
		} 
	
		if (orig_strLangId == null && (selectStore.equals("1") && userLangId != null)) {
			orig_strLangId = user_strLangId;
		} 
	}
	catch (Exception e) {
		throw new ECApplicationException();
	}	
%>
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
<html>
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

var selectedStore = null;
var showAll = false;
var storeFinder = <%= (storeFinder != null && storeFinder.equals("true"))?("true"):("false") %>;
var launch = false;
var selection = "<%= UIUtil.toJavaScript(selectStore) %>";
var currentStoreId = "<%= UIUtil.toJavaScript(strStoreId) %>";
var currentLangId = "<%= (strLangId != null)?(strLangId):(storeLang.getDefaultLanguage()) %>";
var hasMoreStores = <%= storeLang.hasMoreStores() %>;
var overLimit = <%= overLimit %>;
var defaultLangId = "<c:out value="<%= storeLang.getDefaultLanguage() %>" />";
var origSearchStoreId = "<c:out value="<%= storeLang.getSearchStoreId() %>" />";
var origSearchCriteria = "<c:out value="<%= storeLang.getSearchCriteria() %>" />";
var invalidCharRegExp = new RegExp(/\W/g);
var userName = "<%= cmdContext.getUser().getDisplayName() %>";
var windowName = "SiteAdminConsole_" + userName.replace(invalidCharRegExp, "_");

<% storeLang.getStoresJS("stores", out); %>

function getHelp() {
	return "AC.sitestoreselection.Help";
}

function openHelp() {
	var helpfile= '<%= WcsApp.configProperties.getValue("Websphere/HelpServerProtocol", "http") + "://" + WcsApp.configProperties.getValue("Websphere/HelpServerHostName") + ":" + WcsApp.configProperties.getValue("Websphere/HelpServerPort", "8001") + WcsApp.configProperties.getValue("Websphere/HelpServerContextPath", "/help")%>/SSZLC2_9.0.0/com.ibm.commerce.base.doc/f1/facslect.htm?lang=<%=locale.toString()%>';
	window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes, copyhistory=no");
}

function updateForm(storeId) {
	selectedStore = getStoreIndex(storeId);
	getLanguageList();
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

function loadSearchParameters() {
	document.f1.searchStoreId.value = origSearchStoreId;
	
	if (origSearchCriteria != "" && document.f1.searchCriteria.options[origSearchCriteria-1]) {
		document.f1.searchCriteria.options[origSearchCriteria-1].selected = true;
	}
}

function showStoreArea() {
	document.getElementById("storeArea").style.display = "block";
	selection = "1";
	
	if (stores.length == 0) {
<%	
	if (storeLangError.equals(ECToolsConstants.EC_TOOLS_STORES_FINDER_EMPTY)) {
		out.println("\t\talertDialog(\"" + UIUtil.toJavaScript(noMatchMsg) + "\");");
	}
	else if (storeLangError.equals(ECToolsConstants.EC_TOOLS_STORES_EXCEED_LIMIT)) {
		out.println("\t\talertDialog(\"" + UIUtil.toJavaScript(exceedLimitMsg) + "\");");
	}
	else {
		out.println("\t\talertDialog(\"" + UIUtil.toJavaScript(storeEmptyMsg) + "\");");
	}
%>	
	}	
	document.getElementById("fb1").style.width = (document.getElementById("fb1").offsetWidth > 100)? "auto" : "100px";
	document.getElementById("fb2").style.width = (document.getElementById("fb2").offsetWidth > 100)? "auto" : "100px";	
}

function hideStoreArea() {
	document.getElementById("storeArea").style.display = "none";
	selection = "0";
}

function cancelStoreSelection(selectStore, storeid, langid) {
	if (selectStore == "0") {
		launchAdminConsole(selectStore);
	}
	else if (selectStore == "1") {
		launchAdminConsole(selectStore, storeid, langid);
	}
	else {
		document.location.replace("ToolsLogon?" + "<%= ECToolsConstants.EC_XMLFILE%>" +  "=" + "adminconsole.AdminConsoleLogon");
	}
}

function launchAdminConsole(selectStore, storeid, langid) {
	var null_storeId = '<%=ECEntityConstants.Default_Null_Id_String%>';
	var store = '<%=ECConstants.EC_STORE_ID%>'; 
	var language = '<%=ECConstants.EC_LANGUAGE_ID%>';
	var launchURL = '<c:out value="<%= accommand %>" />';
	var temp_storeid = storeid; 
	var temp_langid = langid; 

	if ((selectStore == "1") || (selectStore == "9" && document.f1.siteAdmin[1].checked) ) {
		if (stores.length == 0) {
			alertDialog("<%= UIUtil.toJavaScript(noStoreSelectedMsg) %>");
			launch = false;
			return false;
		}

		if ((storeid == null) && (document.f1.sid.options.length != 0)) {
			temp_storeid = document.f1.sid.options[document.f1.sid.selectedIndex].value;
		}
	
		if ((langid == null) && (document.f1.lid.options.length != 0)) {
			temp_langid = document.f1.lid.options[document.f1.lid.selectedIndex].value;
		}
	
		// to launch store admin console
		launchURL = launchURL + "?XMLFile=adminconsole.StoreAdminConsole";

		if (temp_storeid != null && temp_storeid != "") {
			launchURL =  launchURL + "&" + store + "=" + temp_storeid;
		}

		if (temp_langid != null && temp_langid != "") {
			launchURL =  launchURL + "&" + language + "=" + temp_langid;
		}			
	}
	else {
		// to launch site admin console
		launchURL = launchURL + "?XMLFile=adminconsole.SiteAdminConsole";
		launchURL = launchURL + "&" + store + "=" + null_storeId;
	}

	if (top.getModel) { 
		// if inside AC, just refresh it!
		top.location.replace(launchURL);
		return false;
	}

	document.f1.submit();
	window.open(launchURL, windowName, 'width=1014,height=710,scrollbars=auto,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes').focus(); 
	return true;
}

function submitHandler() {
	if (showAll) {
		if (overLimit) {
			if (!confirmDialog("<%= UIUtil.toJavaScript(listAllConfirmationMsg) %>")) {
				return false;
			}
		}

		document.f1.storeFinder.value = "true";
		document.f1.searchStoreId.value = "";
		document.f1.searchCriteria.options[0].selected = true;
		document.f1.listAllStores.value = "true";
		return true;
	}		
	else if (launch) {
		if (launchAdminConsole(selection)) {
			var langId = (document.f1.lid.selectedIndex > -1)?(document.f1.lid.options[document.f1.lid.selectedIndex].value):(null);
			
			if (langId != null && langId != "") {
				document.location = "<%= UIUtil.getWebappPath(request) %>AdminConLaunched?<%= ECConstants.EC_LANGUAGE_ID %>=" + langId;
			}
			else {
				document.location = "<%= UIUtil.getWebappPath(request) %>AdminConLaunched";
			}				
		}
		return false;
	}
	else {
		showAll = false;
		document.f1.storeFinder.value = "true";
		
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
	var siteOption = document.getElementById("siteSelection");
	var storeOption = document.getElementById("storeSelection");
	
	if (document.getElementById("storelb") != null && document.getElementById("langlb")) {
		getStoreList();
		getLanguageList();
		loadSearchParameters();
	}
	
	if (siteOption != null && storeOption != null) {
		if (storeFinder || selection == "1") {
			storeOption.checked = true;
			showStoreArea();		
		}
		else {
			siteOption.checked = true;
			hideStoreArea();
		}
	}
}

</script>
</head>
<body onload="init();">
<form name="f1" method="post" action="AdminConSiteStoreSelection" onsubmit="return submitHandler();">
<input type="hidden" name="<%= ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL %>" value="<c:out value="<%= AdminConsoleURL %>" />"
<input type="hidden" name="storeFinder" value="false"/>
<input type="hidden" name="listAllStores" value="false"/>
<input type="hidden" name="overLimit" value="<%= overLimit %>"/>
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
								<%= titleStr %>
							</td>
							<td class="contrast" height="40" width="361"></td>
						</tr>
						<tr>
<%
	if (error != null) {	
%>						
							<td class="default" valign="top">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td class="message_box" id="message" style="padding: 25px;">
												<%= error %>
											</td>
										</tr>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td height="30"></td>
										</tr>
										<tr>
											<td style="padding-left: 25px;">
												<button type="button" onclick="cancelStoreSelection('<%= UIUtil.toJavaScript(selectStore) %>');"><%=UIUtil.toHTML(okButtonStr)%></button>
											</td>
										</tr>										
									</tbody>
								</table>	
							</td>

<%
	}
	else {
%>
							<td valign="top" style="padding-left: 25px;">						
								<table border="0" cellpadding="5" cellspacing="0">
									<tbody>
										<tr>
											<td class="text"><%=UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleSiteStoreMsg"))%></td>
										</tr>
<% 
		if ((uab.isSiteAdministrator() || isSiteAdmin)) { 
%> 								
										<tr>
											<td>
												<input type="radio" id="siteSelection" name="siteAdmin" value="true" onclick="javascript:hideStoreArea();"/><label for="siteSelection"><%=UIUtil.toHTML((String)adminConsoleNLS.get("siteStoreSelectSite"))%></label>
											</td>
										</tr>
<%
		}
%>	
										<tr>
											<td>
												<input type="radio" id="storeSelection" name="siteAdmin" value="false" onclick="javascript:showStoreArea();"/><label for="storeSelection"><%=UIUtil.toHTML((String)adminConsoleNLS.get("siteStoreSelectStore"))%></label>
											</td>
										</tr>
										<tr>
											<td valign="top" align="left" style="padding-left: 20px;">
												<table id="storeArea" border="0" cellpadding="5" cellspacing="0" style="display: none;">
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
																			<td colspan="2"><label for="searchStoreId"><%= storeListTitle %></label></td>
																		</tr>
																		<tr>
																			<td><input type="text" id="searchStoreId" name="searchStoreId" maxlength="254"/></td>
																			<td>
                															    <label for="searchCriteria">&nbsp;</label>									
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
																				<button id="fb1" type="submit" style="width:auto"><%= findStr %></button>&nbsp;<button id="fb2" style="width:auto" type="submit" onclick="showAll=true;"><%= listAllStr %></button>
																			</td>																			
																		</tr>
																	</tbody>
																</table>
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
													</tbody>
												</table>
											</td>
										</tr>
										<tr>
											<td height="15"></td>
										</tr>
										<tr>
											<td>
												<button type="submit" onclick="launch=true;"><%=UIUtil.toHTML(okButtonStr)%></button>
												&nbsp;
<% 
	if (orig_strStoreId == null) { 
%> 
												<button type="button" onclick="cancelStoreSelection('<%= UIUtil.toJavaScript(selectStore) %>');"><%=UIUtil.toHTML(cancelButtonStr)%></button>
<% 
	} 
	else { 
%> 
												<button type="button" onclick="cancelStoreSelection('<%= UIUtil.toJavaScript(selectStore) %>', '<%= UIUtil.toJavaScript(orig_strStoreId) %>', '<%= UIUtil.toJavaScript(orig_strLangId) %>');"><%=UIUtil.toHTML(cancelButtonStr)%></button>
<% 
	} 
%> 												

												&nbsp;
												<button type="button" onclick="openHelp();"><%=UIUtil.toHTML(helpButtonStr)%></button>
											</td>
										</tr>
									</tbody>
								</table>															
							</td>
<%
		}
%>							
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
				<td class="legal"><%= copyright %></td>
			</tr>	
		</tfoot>
	</table>
</div>
</form>
</body>
</html>
