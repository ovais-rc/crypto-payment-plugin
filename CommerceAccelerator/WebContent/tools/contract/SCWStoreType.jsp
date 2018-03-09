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
<%@page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@page import="com.ibm.commerce.tools.util.StringPair" %>
<%@page import="com.ibm.commerce.beans.*"%>
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="javax.servlet.http.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try{
   		StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   		DataBeanManager.activate(scDB, request);

		String[] store_types = {"RPS"};
		boolean bNoStoreTypeAvailForLang = false;

		Vector values = new Vector();
		
        	JSPHelper jspHelper = new JSPHelper(request);	
        	String fromAccelerator = null;
        	fromAccelerator = jspHelper.getParameter("fromAccelerator");
    		// are we launched from within the accelerator
       		if(fromAccelerator != null && fromAccelerator.equalsIgnoreCase("true")){
	      		String[] store_typesFA = jspHelper.getParameterValues("storetype");
	      		if(store_typesFA != null){     	
      				for(int i = 0; i < store_typesFA.length; i++){ 
        				values.addElement(store_typesFA[i]);
        			}
        		}
	      		store_typesFA = jspHelper.getParameterValues("storetype2");
	      		if(store_typesFA != null){     	
      				for(int i = 0; i < store_typesFA.length; i++){ 
        				values.addElement(store_typesFA[i]);
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
							values.addElement(cookies[j].getValue());
							break;
						}
					}
				}
			}
		}

		if(values.size() > 0){
			store_types = new String[values.size()];
			values.copyInto(store_types);
		}	

  		Vector vRPSlist = new Vector();	
   		vRPSlist = scDB.getProfileStores(store_types);

   		if (vRPSlist.size() == 1) {
   			String[] strArrStoreType = (String[])vRPSlist.elementAt(0);
   			if (strArrStoreType != null 
   				&& strArrStoreType[scDB.CONSTANT_INDEX_ID].equals("0")
   				&& strArrStoreType[scDB.CONSTANT_INDEX_DISPLAYNAME].equals("0")
   				&& strArrStoreType[scDB.CONSTANT_INDEX_DESCRIPTION].equals("0")) {
   				bNoStoreTypeAvailForLang = true;
   				vRPSlist.removeAllElements();
   			}
   		}
%>

<html>

<%
if (!vRPSlist.isEmpty()) {
%>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
	<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
	<script language="JavaScript">

	var storeTypeData = null;
	var descriptionArray = new Array();

	function init() {
		if(parent.get("SWCStoreTypeData") != null){	
			storeTypeData = parent.get("SWCStoreTypeData");	
		}else{	
			storeTypeData = new StoreType();
		}
		display();
		initDescriptionArray();	
		displayDescription();
	    	parent.setContentFrameLoaded(true);
	}

	function initDescriptionArray(){
		<%
			if (!vRPSlist.isEmpty()) {
				for (int i = 0; i <vRPSlist.size(); i++) {
					String[] storeType_array = (String[])vRPSlist.elementAt(i);
					%>
						descriptionArray["<%= UIUtil.toJavaScript(storeType_array[scDB.CONSTANT_INDEX_ID]) %>"] = "<%= UIUtil.toJavaScript(storeType_array[scDB.CONSTANT_INDEX_DESCRIPTION]) %>";
					<%
				}
			}
							
		%>
	}

	function StoreType(){
		var newObject = new Object();
		newObject.storeTypeStoreentId = '';	
		newObject.storeType = '';
		return newObject;
	}

	function display(){
		if(storeTypeData.storeTypeStoreentId != ''){
			document.SWCStoreTypeForm.storeTypeChoice.value = storeTypeData.storeTypeStoreentId;
		}
	}

	function displayDescription(){
		var descriptionText =  null;
		if(descriptionArray.length > 0){
			descriptionText = descriptionArray[document.getElementById("storeTypeChoice").value];
		}
		if(descriptionText != null && descriptionText != 'null' && document.getElementById("storeTypeChoice").value != 'specifyStoreType'){
			document.getElementById("storeTypeDesc").innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;' + '<I>' + descriptionText + '</I>';
		}else{
			document.getElementById("storeTypeDesc").innerHTML = '';
		}
	}

	function savePanelData() {
		loadData();
	     	parent.put("SWCStoreTypeData", storeTypeData);
	}

	function loadData(){
		storeTypeData.storeTypeStoreentId = document.SWCStoreTypeForm.storeTypeChoice.value;
		storeTypeData.storeType = document.SWCStoreTypeForm.storeTypeChoice.options[document.SWCStoreTypeForm.storeTypeChoice.selectedIndex].innerText;
	}

	function validatePanelData(){
	     if(document.SWCStoreTypeForm.storeTypeChoice.value == 'specifyStoreType'){     
	     		alertDialog("<%=UIUtil.toJavaScript((String)resourceBundle.get("storeTypeRequired"))%>");
	     		document.SWCStoreTypeForm.storeTypeChoice.focus();
	     		return false;
	     } 
	     return true;
	}
	
</script>
	</head>
	<body onload="init()" class="content">
		<h1><%=UIUtil.toHTML((String)resourceBundle.get("storeTypeTitle"))%></h1>
		<form name="SWCStoreTypeForm" id="SWCStoreTypeForm">

		<label for="storeTypeChoice">
		<%=UIUtil.toHTML((String)resourceBundle.get("storeTypeInstruction"))%><br><br>
		<%=UIUtil.toHTML((String)resourceBundle.get("storeTypeChoice"))%><br>
		</label>
		<select id="storeTypeChoice" size=1 width=100% onchange="displayDescription();">
		<option value="specifyStoreType" selected><%=resourceBundle.get("GeneralPleaseSpecify")%></option>
		<%
			if (!vRPSlist.isEmpty()) {
				for (int i = 0; i <vRPSlist.size(); i++) {
					String[] storeType_array = (String[])vRPSlist.elementAt(i);
					if (vRPSlist.size() == 1) {
					%>
						<option value="<%= UIUtil.toJavaScript(storeType_array[scDB.CONSTANT_INDEX_ID]) %>" selected><%= UIUtil.toHTML(storeType_array[scDB.CONSTANT_INDEX_DISPLAYNAME])%></option>
					<% } else { %>
						<option value="<%= UIUtil.toJavaScript(storeType_array[scDB.CONSTANT_INDEX_ID]) %>"><%= UIUtil.toHTML(storeType_array[scDB.CONSTANT_INDEX_DISPLAYNAME])%></option>
					<% }
				}
			}							
		%>
		</select>

		<br><br><br>
		<%=UIUtil.toHTML((String)resourceBundle.get("storeTypeDescription"))%><br><br>

 		<!-- The empty DIV below is used to insert dynamically the store type description -->
		<div id="storeTypeDesc">
		</div>
		</form>
	</body>
<%
} 
else {
%>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script language="JavaScript">
	function disableNextButton () {
		if (parent.NAVIGATION) {
			var nextButton = parent.NAVIGATION.document.getElementsByName("NextButton")[0];
			if (nextButton) {
				nextButton.disabled = "true";
				clearTimeout (buttonCheckTimeout);
			}
		}
	}

	function errorInit () {
		buttonCheckTimeout = setTimeout ("disableNextButton()", 1000);
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}	
	}
	
	function validatePanelData () {
		disableNextButton();
		return false;
	}
	
	
</script>
	</head>
	<body onload="errorInit()" class="content">
	      <center>
	      <br><br>
	      <h1>
	      <%
	      if (bNoStoreTypeAvailForLang) { %>
	      	<%=UIUtil.toHTML((String)resourceBundle.get("noStoreTypeForDefaultLanguageError"))%>
	      <% } else { %>
	      	<%=UIUtil.toHTML((String)resourceBundle.get("configurationMissingStoreTypeErrorMessage"))%>
	      <% } %>
	      </h1>
	      </center>
	      <br>
	</body>
<% } %>

</html>
<%
    }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
    <% }	
%>
