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
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@page import="com.ibm.commerce.beans.*"%>
<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try{
   		StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   		DataBeanManager.activate(scDB, request);

   		Vector vCPSlist = new Vector();
   		vCPSlist = scDB.getCatalogProfileStores();

   		boolean includeEmptyCatalogOption = true;	

        	JSPHelper jspHelper = new JSPHelper(request);	
        	String fromAccelerator = null;
        	fromAccelerator = jspHelper.getParameter("fromAccelerator");
    		// are we launched from within the accelerator
       		if(fromAccelerator != null && fromAccelerator.equalsIgnoreCase("true")){
       			String includeEmptyCatalog = null;
       			includeEmptyCatalog = jspHelper.getParameter("includeEmptyCatalog");
        		if(includeEmptyCatalog != null && includeEmptyCatalog.equalsIgnoreCase("false")){
        			includeEmptyCatalogOption = false;
        		}
        	} // end fromAccelerator
        	else {
        		// Getting includeEmptyCatalogCookie
        		Cookie[] cookies = request.getCookies();   
        		for (int i = 0; i < cookies.length; i++){
				if (cookies[i].getName().equalsIgnoreCase("includeEmptyCatalogCookie")) {
					Boolean booIncludeEmptyCatalogCookieValue = new Boolean (cookies[i].getValue());
					includeEmptyCatalogOption = booIncludeEmptyCatalogCookieValue.booleanValue();
				}	
			}
		}

		//Throw an exception to show error message if Empty catalog option is not allowed 
		//and no CPS store is returned (for this language).
		if (!includeEmptyCatalogOption && vCPSlist.isEmpty()) {
			throw new Exception ();
		}
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript">
var sharedCatalogData = null;
var descriptionArray = new Array();

function init() {

	if(!<%= includeEmptyCatalogOption %>){
		var instructions = '<%=UIUtil.toJavaScript((String)resourceBundle.get("noEmptyCatalogInstruction"))%>';
		document.getElementById("sharedCatalogInstructions").innerText = instructions;	
	}

	if(parent.get("SWCSharedCatalogData") != null){	
		sharedCatalogData = parent.get("SWCSharedCatalogData");	
	}else{	
		sharedCatalogData = new SharedCatalog();
	}
	display();
	initDescriptionArray();	
	displayDescription();
    	parent.setContentFrameLoaded(true);
}


function initDescriptionArray(){
	<%
		if (!vCPSlist.isEmpty()) {
			for (int i = 0; i <vCPSlist.size(); i++) {
				String[] sharedCatalog_array = (String[])vCPSlist.elementAt(i);
				%>			
					descriptionArray["<%= sharedCatalog_array[scDB.CONSTANT_INDEX_ID] %>"] = '<%= UIUtil.toJavaScript(sharedCatalog_array[scDB.CONSTANT_INDEX_DESCRIPTION]) %>';					
				<%
			}
		}
							
	%>
}


function SharedCatalog(){
	var newObject = new Object();	
	newObject.sharedCatalogStoreentId = '';
	newObject.sharedCatalog = '';
	return newObject;
}


function display(){
	if(sharedCatalogData.sharedCatalogStoreentId != ''){
		document.sharedCatalogForm.sharedCatalogChoice.value = sharedCatalogData.sharedCatalogStoreentId;
	}
}


function displayDescription(){
	var descriptionText = null;
	if(document.getElementById("sharedCatalogChoice").value != "none"){
		if(descriptionArray.length > 0){
			descriptionText = descriptionArray[document.getElementById("sharedCatalogChoice").value];
		}
		if(descriptionText != null && descriptionText != 'null'){
			document.getElementById("sharedCatalogDesc").innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;' + '<I>' + descriptionText + '</I>';
		}else{
			document.getElementById("sharedCatalogDesc").innerHTML = '';
		}
	}else if(<%= includeEmptyCatalogOption %>){	
		document.getElementById("sharedCatalogDesc").innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;' + '<I>' + '<%=UIUtil.toJavaScript((String)resourceBundle.get("newSharedCatalogDesc"))%>' + '</I>';
	}
}


function savePanelData() {
	loadData();
     	parent.put("SWCSharedCatalogData", sharedCatalogData);
}


function loadData(){
	sharedCatalogData.sharedCatalogStoreentId = document.sharedCatalogForm.sharedCatalogChoice.value;
	
	if(document.sharedCatalogForm.sharedCatalogChoice.value != 'none'){
		sharedCatalogData.sharedCatalog = document.sharedCatalogForm.sharedCatalogChoice.options[document.sharedCatalogForm.sharedCatalogChoice.selectedIndex].innerText;
	}else{
		sharedCatalogData.sharedCatalog = '<%=UIUtil.toJavaScript((String)resourceBundle.get("sharedCatalogNoneText"))%>'
	}
}

</script>

<body onload="init()" class="content">
<h1><%=UIUtil.toHTML((String)resourceBundle.get("sharedCatalogTitle"))%></h1>

<DIV id="sharedCatalogInstructions")>
<%=UIUtil.toHTML((String)resourceBundle.get("sharedCatalogInstruction"))%>
</DIV>

<br><%=UIUtil.toHTML((String)resourceBundle.get("sharedCatalogInstruction2"))%><br><br>
<form name="sharedCatalogForm" id="sharedCatalogForm">
<label for="sharedCatalogChoice">
<%=UIUtil.toHTML((String)resourceBundle.get("sharedCatalogChoice"))%>
</label><br>
<select id="sharedCatalogChoice" size=1 width=100% onchange="displayDescription();">
  <%
	if(includeEmptyCatalogOption){
  %>
	<option value="none" selected><%=resourceBundle.get("sharedCatalogNone")%></option>
  <%
	}
  %>

	<%
		if (!vCPSlist.isEmpty()) {
			for (int i = 0; i <vCPSlist.size(); i++) {
				String[] sharedCatalog_array = (String[])vCPSlist.elementAt(i);
				%>
					<option value="<%= UIUtil.toJavaScript(sharedCatalog_array[scDB.CONSTANT_INDEX_ID]) %>"><%= UIUtil.toHTML(sharedCatalog_array[scDB.CONSTANT_INDEX_DISPLAYNAME]) %></option>
				<%
			}
		}							
	%>
</select>

<br><br><br>
<%=UIUtil.toHTML((String)resourceBundle.get("sharedCatalogDescription"))%>
<br><br>
<!-- The empty DIV below is used to insert dynamically the shared catalog description -->
<div id="sharedCatalogDesc">
</div>
</form>
</body>
</html>
<%
    }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
    <%
    }	
%>

