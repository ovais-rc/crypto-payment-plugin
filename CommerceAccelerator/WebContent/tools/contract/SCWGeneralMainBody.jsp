<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2007, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
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
%>

<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %>                          
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %> 
<%@page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@include file="../common/common.jsp" %>
<%@include file="SCWCommon.jsp" %>
<%

    try{	
       	String storeTypeString = ""; 
        JSPHelper jspHelper = new JSPHelper(request);	
        String fromAccelerator = null;
      	String storeViewName = null;
 
        fromAccelerator = jspHelper.getParameter("fromAccelerator");
   		storeViewName = jspHelper.getParameter("storeViewName");
    	// are we launched from within the accelerator
       	if(fromAccelerator != null && fromAccelerator.equalsIgnoreCase("true")){
	      	String[] store_types = null;
	   		store_types = jspHelper.getParameterValues("storetype");
	      	if(store_types != null){     	
      			for(int i = 0; i < store_types.length; i++){
        			storeTypeString += store_types[i];
        		}
        	}
	   	store_types = jspHelper.getParameterValues("storetype2");
	      	if(store_types != null){     	
      			for(int i = 0; i < store_types.length; i++){
        			storeTypeString += store_types[i];
        		}
        	}
        } // end fromAccelerator
		else {
			Cookie[] cookies = request.getCookies();
			String storetypeSize = null;
			for (int i = 0; i < cookies.length; i++){
				if (cookies[i].getName().equalsIgnoreCase("storetypeSize")) {
					storetypeSize = cookies[i].getValue();
					break;
				}
			}
	
			if(storetypeSize != null){
				int storetypeLength = (new Integer(storetypeSize)).intValue();
				for(int k = 0; k < storetypeLength; k++){
					for (int j = 0; j < cookies.length; j++){
						if (cookies[j].getName().equalsIgnoreCase("storetype" + k)) {
							storeTypeString += cookies[j].getValue();
							break;
						}
					}
				}
			}
	}	
	StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   	DataBeanManager.activate(scDB, request);

   	Vector storecat = scDB.getStoreCategories();  	
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script language="JavaScript">
var generalData = null;
var storeCatDescArray = new Array();
var orgChildArray = new Array();

function initForm() {

	top.put("fromAccelerator", "<%=fromAccelerator%>");
	if ("<%=fromAccelerator%>" == "true") {
		top.put("launchSeparateWindow", "false");
		top.put("storeId", "<%= cc.getStoreId() %>");
		if ("<%= storeViewName %>" != "") {
			top.put("storeViewName", "<%= storeViewName %>");
		}
	}
	if(parent.parent.get("SWCGeneral") != null){	
		generalData = parent.parent.get("SWCGeneral");	
	}else{	
		generalData = new GeneralData();
	}	
	initStoreCatDescriptionArray();	

	display();	
		
	if (parent.parent.get("DuplicatedContractName", false)){
        	parent.parent.remove("DuplicatedContractName");
        	document.SWCGeneralForm.storeuniqueidentifier.select();
        	alertDialog("<%= UIUtil.toJavaScript((String)resourceBundle.get("storeIdentifierAlreadyExistsErrorMessage"))%>");
        }		
	if (parent.parent.get("StoreIdentifierAlreadyExists", false)){
        	parent.parent.remove("StoreIdentifierAlreadyExists");
        	document.SWCGeneralForm.storeuniqueidentifier.select();
        	alertDialog("<%= UIUtil.toJavaScript((String)resourceBundle.get("storeIdentifierAlreadyExistsErrorMessage"))%>");
        }	
	if (parent.parent.get("StoreOwnerOwnsDifferentType", false)){
        	parent.parent.remove("StoreOwnerOwnsDifferentType");
        	//document.SWCGeneralForm.storeuniqueidentifier.select();
        	alertDialog("<%= UIUtil.toJavaScript((String)resourceBundle.get("storeOwnerOwnsDifferentTypeErrorMessage"))%>");
        }        
	if (parent.parent.get("EmailIsMultibyte", false)){
        	parent.parent.remove("EmailIsMultibyte");
        	document.SWCGeneralForm.notificationrecipientemail.select();
        	alertDialog("<%= UIUtil.toJavaScript((String)resourceBundle.get("emailIsMultibyteErrorMessage"))%>");
        }	
                			
     	parent.parent.setContentFrameLoaded(true);
     	
}


function initStoreCatDescriptionArray(){
	<%
		if (!storecat.isEmpty()) {
			for (int i = 0; i <storecat.size(); i++) {
				String[] storeCat_array = (String[])storecat.elementAt(i);
				%>	
					storeCatDescArray["<%= UIUtil.toJavaScript(storeCat_array[scDB.CONSTANT_INDEX_ID]) %>"] = '<%= UIUtil.toJavaScript(storeCat_array[scDB.CONSTANT_INDEX_DESCRIPTION]) %>';					
				<%
			}
		}							
	%>
	<%
		Vector orgs = scDB.getUserOrgs();							
		if (!orgs.isEmpty()) {								
			for (int i = 0; i <orgs.size(); i++) {
				StringPair orgsStringPair = (StringPair)orgs.elementAt(i);				
				String orgsId = orgsStringPair.getKey();
	%>
		orgChildArray["<%=orgsId%>"] = new Object();															
		orgChildArray["<%=orgsId%>"].names = new Array();
	<%

			}
		}
	%>	
}


function GeneralData(){
	var newObject = new Object();	
	newObject.storeName = '';
	newObject.storeIdentifier = '';
	newObject.storeDescription = '';
	newObject.notificationEmail = '';
	newObject.storeCategory = '';
	newObject.storeDefaultCurrency = '';
	newObject.storeOrganization = '';
	newObject.storeOrganizationSharedOwnerChecked = false;
	newObject.storeDefaultCurrencyName = '';
	newObject.storeOrganizationName = '';
	newObject.storeCategoryName = '';
	return newObject;
}


function display(){
	document.SWCGeneralForm.storedisplayname.value = generalData.storeName;
	document.SWCGeneralForm.storeuniqueidentifier.value = generalData.storeIdentifier;
	document.SWCGeneralForm.storedescription.value = generalData.storeDescription;
	document.SWCGeneralForm.notificationrecipientemail.value = generalData.notificationEmail;
	
	if(generalData.storeDefaultCurrency != ''){
		document.SWCGeneralForm.defaultStoreCurrency.value = generalData.storeDefaultCurrency;
	}	
	if(generalData.storeOrganization != ''){
		document.SWCGeneralForm.storeOrganization.value = generalData.storeOrganization;
	}

	if(generalData.storeOrganizationSharedOwnerChecked == true){
		document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked = true;
	}
	if(generalData.storeCategory != ''){
		document.SWCGeneralForm.storeCategory.value = generalData.storeCategory;
		
	}
	
	<%
	if(storecat.isEmpty() || storecat.size() == 1){
	%>
		document.getElementById("storeCat").style.display = "none";
	<%
	}	
	%>
		
	displayStoreCatDescription();
}


function savePanelData() {
	loadData();
    parent.parent.put("SWCGeneral", generalData);
}


function loadData(){
	generalData.storeName = document.SWCGeneralForm.storedisplayname.value;
	generalData.storeIdentifier = document.SWCGeneralForm.storeuniqueidentifier.value;
	generalData.storeDescription = document.SWCGeneralForm.storedescription.value;
	generalData.notificationEmail = document.SWCGeneralForm.notificationrecipientemail.value;	
	generalData.storeDefaultCurrency = document.SWCGeneralForm.defaultStoreCurrency.value;
	generalData.storeOrganization = document.SWCGeneralForm.storeOrganization.value;

	if (document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked == true) {
		generalData.storeOrganizationSharedOwnerChecked  = true;
	} else {
		generalData.storeOrganizationSharedOwnerChecked  = false;
	}
	generalData.storeDefaultCurrencyName = document.SWCGeneralForm.defaultStoreCurrency.options[document.SWCGeneralForm.defaultStoreCurrency.selectedIndex].innerText;
	generalData.storeOrganizationName = document.SWCGeneralForm.storeOrganization.options[document.SWCGeneralForm.storeOrganization.selectedIndex].innerText

	<%
	if(!storecat.isEmpty()){
		if(storecat.size() == 1){
			String[] storecat_array = (String[])storecat.elementAt(0);
			String storecatId = storecat_array[scDB.CONSTANT_INDEX_ID];
			String storecatName = storecat_array[scDB.CONSTANT_INDEX_DISPLAYNAME];
		
	%>
			generalData.storeCategory = "<%= UIUtil.toJavaScript(storecatId) %>";
			generalData.storeCategoryName = "<%= UIUtil.toJavaScript(storecatName) %>";
	<%
		}else{
	%>
			generalData.storeCategory = document.SWCGeneralForm.storeCategory.value;
			generalData.storeCategoryName = document.SWCGeneralForm.storeCategory.options[document.SWCGeneralForm.storeCategory.selectedIndex].innerText;		
	<%
		}
	}	
	%>
}

function isValidInputTextForSomeChars(myString){
  var invalidChars = "~!@#$%^&*()<>?/|'";
  for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
      return false;
    }
  }
return true;
}

function validatePanelData() {

     if(document.SWCGeneralForm.storeuniqueidentifier.value == ''){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeIdentifierRequired"))%>");
     		document.SWCGeneralForm.storeuniqueidentifier.focus();
     		return false;
     }else if(!isValidInputTextForSomeChars(document.SWCGeneralForm.storeuniqueidentifier.value)){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeIdentifierInvalid"))%>");
     		document.SWCGeneralForm.storeuniqueidentifier.focus();
     		return false;
     }else if(document.SWCGeneralForm.storedisplayname.value == ''){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeDisplayNameRequired"))%>");
     		document.SWCGeneralForm.storedisplayname.focus();
     		return false;
     }else if(!parent.parent.isValidInputText(document.SWCGeneralForm.storedisplayname.value)){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeDisplayNameInvalid"))%>");
     		document.SWCGeneralForm.storedisplayname.focus();
     		return false;
     }else if(document.SWCGeneralForm.storedescription.value == ''){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeDescriptionRequired"))%>");
     		document.SWCGeneralForm.storedescription.focus();
     		return false;
     }else if(!parent.parent.isValidInputText(document.SWCGeneralForm.storedescription.value)){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeDescriptionInvalid"))%>");
     		document.SWCGeneralForm.storedescription.focus();
     		return false;     		
     }else if(document.SWCGeneralForm.notificationrecipientemail.value == ''){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeEmailRequired"))%>");
     		document.SWCGeneralForm.notificationrecipientemail.focus();
     		return false;
     }else if(!parent.parent.isValidEmail(document.SWCGeneralForm.notificationrecipientemail.value)){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeEmailInvalid"))%>");
     		document.SWCGeneralForm.notificationrecipientemail.focus();
     		return false;     		
     }else if(document.SWCGeneralForm.defaultStoreCurrency.value == 'specifyStoreCurrency'){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeCurrencyRequired"))%>");
     		document.SWCGeneralForm.defaultStoreCurrency.focus();
     		return false;
     }else if(document.SWCGeneralForm.storeOrganization.value == 'specifyStoreOrg'){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeOrgRequired"))%>");
     		document.SWCGeneralForm.storeOrganization.focus();
     		return false;
     }
     
     <%
	if(!storecat.isEmpty() && storecat.size() > 1){
     %>     
     else if(document.SWCGeneralForm.storeCategory.value == 'specifyStoreCat'){     
     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeCatRequired"))%>");
     		document.SWCGeneralForm.storeCategory.focus();
     		return false;
     }   
     <%
	}	
     %>
         
     return true;
}


function displayStoreCatDescription(){
	var descriptionText = null;
	if(document.getElementById("storeCategory").value != 'specifyStoreCat'){
		descriptionText = storeCatDescArray[document.getElementById("storeCategory").value];
		if(descriptionText != null && descriptionText != 'null'){
			document.getElementById("storeCatDesc").innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;' + '<I>' + descriptionText + '</I>';
		}else{
			document.getElementById("storeCatDesc").innerHTML = '';
		}
	}else{	
		document.getElementById("storeCatDesc").innerHTML = '';
	}
}

function getDivisionStatus(aSwitch) {
    return (aSwitch == true || aSwitch != 0) ? "block" : "none";
}

function showDivisions() {


     if (document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked) 
     	parent.childOrgListChange();
     else {
     	parent.hiddenChildOrgSelectionBody();
     	return;
     }
     

}


function setChildOrgSelectionBody() {


     if (document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked)
     	parent.showChildOrgSelectionBody();
     else 
     	parent.hiddenChildOrgSelectionBody();
}


  // This function allows the user select an organization and get it's contact list
  function storeOrgSelectionChange() {
  
 	 var o = parent.parent.get("SWCGeneral", null); 
	 if (o==null) o= new Object(); 
	 o.storeOrganizationSharedOwner = null;
     parent.parent.put("SWCGeneral", o);
	 if (document.SWCGeneralForm.storeOrganizationSharedOwnerChecked.checked) 
	 	parent.childOrgListChange();
	 else return;
  }
</script>
</head>

<body onload="initForm();setChildOrgSelectionBody();"  class="content">

<h1><%=UIUtil.toHTML((String)resourceBundle.get("storeGeneralPanelTitle"))%></h1>

<form name="SWCGeneralForm" id="SWCGeneralForm">
<label for="storeuniqueidentifier">
<%=UIUtil.toHTML((String)resourceBundle.get("storeUniqueIdentifier"))%>
</label><br>
<input id="storeuniqueidentifier" type="TEXT" size=50 maxlength=50></INPUT><br><br>

<label for="storedisplayname">
<%=UIUtil.toHTML((String)resourceBundle.get("storeDisplayName"))%>
</label><br>
<input id="storedisplayname" type="TEXT" maxlength=50 size=50></INPUT><br><br>

<label for="storedescription">
<%=UIUtil.toHTML((String)resourceBundle.get("storeDescription"))%>
</label><br>
<textarea id="storedescription" value='' rows="3" cols="52" WRAP="HARD"></textarea><br><br>

<label for="notificationrecipientemail">
<%=UIUtil.toHTML((String)resourceBundle.get("notificationrecipientemail"))%>
</label><br>
<input id="notificationrecipientemail" type="TEXT" size=50 maxlength=50></INPUT><br><br>

<label for="defaultStoreCurrency">
<%=UIUtil.toHTML((String)resourceBundle.get("defaultStoreCurrency"))%>
</label><br>
<select id="defaultStoreCurrency" size=1 width=100%>
	<option value="specifyStoreCurrency" selected><%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%></option>
	<%
		Vector curr = scDB.getCurrencies();							
		if (!curr.isEmpty()) {
			for (int i = 0; i <curr.size(); i++) {
				StringPair currStringPair = (StringPair)curr.elementAt(i);
				String currId = currStringPair.getKey();
				String currDesc = currStringPair.getValue();				
			%>									
				<option value="<%= UIUtil.toJavaScript(currId) %>"><%= UIUtil.toHTML(currDesc) %></option>
			<%
			}
		}							
	%>
</select> <br><br>

<label for="storeOrganization">
<%=UIUtil.toHTML((String)resourceBundle.get("storeOrganization"))%>
</label><br>


<select id="storeOrganization" size=1 width=100% onchange="storeOrgSelectionChange();">
	<option value="specifyStoreOrg" selected><%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%></option>
	<%
		//Vector orgs = scDB.getUserOrgs();							
		if (!orgs.isEmpty()) {								
			for (int i = 0; i <orgs.size(); i++) {
				StringPair orgsStringPair = (StringPair)orgs.elementAt(i);
				String orgsId = orgsStringPair.getKey();
				String orgsDesc = orgsStringPair.getValue();
	%>															
		<option value="<%= UIUtil.toJavaScript(orgsId) %>"><%= UIUtil.toHTML(orgsDesc) %></option>
	<%
			}
		}
	%>
</select><br><br>

<input type=checkbox name=storeOrganizationSharedOwnerChecked onClick='showDivisions();' id="SWCGeneralForm_FormInput_storeOrganizationSharedOwnerChecked">
	<label for="SWCGeneralForm_FormInput_storeOrganizationSharedOwnerChecked">
	<%= UIUtil.toHTML((String)resourceBundle.get("storeOrganizationSharedOwnerChecked")) %>
	</label>


<div id="storeCat">
<br>
<label for="storeCategory">
<%=UIUtil.toHTML((String)resourceBundle.get("storeCategory"))%>
</label><br>
<select id="storeCategory" size=1 width=100% onchange="displayStoreCatDescription();">
	<option value="specifyStoreCat" selected><%=UIUtil.toHTML((String)resourceBundle.get("GeneralPleaseSpecify"))%></option>
	<%
		if (!storecat.isEmpty()) {
			for (int i = 0; i <storecat.size(); i++) {
				String[] storecat_array = (String[])storecat.elementAt(i);
				String storecatId = storecat_array[scDB.CONSTANT_INDEX_ID];
				String storecatName = storecat_array[scDB.CONSTANT_INDEX_DISPLAYNAME];							
			%>			
				<option value="<%= UIUtil.toJavaScript(storecatId) %>"><%= UIUtil.toHTML(storecatName) %></option>
			<%
			}
		}							
	%>
</select><br><br>

<%=UIUtil.toHTML((String)resourceBundle.get("storeCategoryDesc"))%>
<br>
<!-- The empty DIV below is used to insert dynamically the store category description -->
<div id="storeCatDesc">
</div>
</div>

</form>
</body>
</html>
<%
	}catch(Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
	<% }
%>

