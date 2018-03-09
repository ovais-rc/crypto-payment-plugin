<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.taxation.beans.*" %>
<%@page import="java.util.*" %>

<%@include file="ShippingCommon.jsp" %>

<%
	CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	String zoneId = request.getParameter(ShippingConstants.PARAMETER_ZONE_ID);
	String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
	boolean editable = (readOnly == null || readOnly.equals("")||readOnly.equals("false"));
	String disabledString = " disabled ";
	if(editable){
		disabledString = "";
	}
	String parCountryName = request.getParameter(ShippingConstants.PARAMETER_COUNTRY_NAME);
	boolean newZone = (zoneId == null || zoneId.equals(""))&& editable;
	String title;
	String panelPrompt = "";
	if(newZone){
		title = (String)shippingRB.get(ShippingConstants.MSG_ZONE_NEW_DIALOG_TITLE);
		panelPrompt = UIUtil.toHTML((String)shippingRB.get("zonePanelDesc"));
	}
	else if(editable){
		title = (String)shippingRB.get(ShippingConstants.MSG_ZONE_CHANGE_DIALOG_TITLE);
	}
	else{
		title = (String)shippingRB.get(ShippingConstants.MSG_ZONE_DETAILS_DIALOG_TITLE);
	}
	
  
    CountryListDataBean countryList;
	CountryDataBean[] countries = null;
	int numberOfCountries = 0;
	countryList = new CountryListDataBean();
	DataBeanManager.activate(countryList, request);
	countries = countryList.getCountryList();  
	if (countries != null) {
		numberOfCountries = countries.length;
	}
	
	System.out.println("Number of countries: " + numberOfCountries);
	System.out.println(ShippingConstants.PARAMETER_COUNTRY_NAME + " " + parCountryName);
	
	
	StateProvinceListDataBean stateList;
	StateProvinceDataBean[] states = null;
	int numberOfStates = 0;
	stateList = new StateProvinceListDataBean();
	stateList.setCountryName(parCountryName);
	//DataBeanManager.activate(stateList, request);
	states = stateList.getStateProvinceList();
	if (states != null) {
		numberOfStates = states.length;
	}
	

%>

<html>

<head>
<%= fHeader %>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 300px;}
</style>
<title><%= title %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript"
	src="/wcs/javascript/tools/shipping/ZoneDialog.js"></script>
<script language="JavaScript"
	src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">


var debug = true;
var values = new Array();
var any = new Object();
any.text = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";
any.value = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";


function newCountrySelected(){

      //alert('Inside newCountrySelected');
	
	 var newIndex = document.zoneForm.countryList.selectedIndex;
	 //alert('new index' + newIndex);
	
     var countryName = document.zoneForm.countryList[newIndex].value; 
         //alert('new countryName' + countryName);
	
     var panelURL;
<%
	if (newZone) {
%>
		//panelURL = "<%= ShippingConstants.URL_ZONE_NEW_DIALOG_VIEW + "&" + ShippingConstants.PARAMETER_COUNTRY_NAME + "=" %>" + countryName;
		panelURL = "DialogView?XMLFile=shipping.ZoneNewDialog&"  + <%=ShippingConstants.PARAMETER_COUNTRY_NAME%> + "="  + countryName;
<%
	}
	else{
%>
	    panelURL = "<%= ShippingConstants.URL_ZONE_CHANGE_DIALOG_VIEW + ShippingConstants.PARAMETER_ZONE_ID + "=" + UIUtil.toJavaScript(zoneId) + "&" + ShippingConstants.PARAMETER_COUNTRY_NAME + "=" %>" + countryName;
<%
	}
%>
     //alert('panelURL' + panelURL);
	
     var param = new Object();
     param.<%= ShippingConstants.PARAMETER_COUNTRY_NAME %> = countryName;
     
     savePanelData();
     
     //alert('seved panel data');
	
     parent.setContentFrameLoaded(true);
     
     //top.mccmain.submitForm(panelURL, param, "contents");
    if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_ZONE)) %>", panelURL, true);
	}
	else {
		parent.location.replace(panelURL);
	}
    // window.location.replace(panelURL);
     
}

function validatePanelData () {

	//alert('Inside zone panel - validatePanelData');
	with (document.zoneForm) {
		<% if (newZone) { %>
		if (!zoneNameText.value) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_NAME_REQUIRED)) %>");
			zoneNameText.focus();
			return false;
		}
		if (!isValidUTF8length(zoneNameText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_ZONE_NAME %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_NAME_TOO_LONG)) %>");
			zoneNameText.select();
			zoneNameText.focus();
			return false;
		}
		<% } %>
		
		if (!isValidUTF8length(cityText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_ZONE_CITY %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CITY_TOO_LONG)) %>");
			cityText.select();
			cityText.focus();
			return false;
		}
		if (!isValidUTF8length(stateText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_ZONE_STATE %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_STATE_TOO_LONG)) %>");
			stateText.select();
			stateText.focus();
			return false;
		}
		if (!isValidUTF8length(zipStartText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_ZONE_ZIPSTART %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZIPCODE_START_TOO_LONG)) %>");
			zipStartText.select();
			zipStartText.focus();
			return false;
		}
		if (!isValidUTF8length(zipEndText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_ZONE_ZIPEND %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZIPCODE_END_TOO_LONG)) %>");
			zipEndText.select();
			zipEndText.focus();
			return false;
		}
		
	}
	
	return true;
}

// Is an item in an array of text-value pairs
function isNameInTextArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index].text == n)
		return true;
   }
   return false;
}

function indexOfTextInList(select, v)
 {
  for (var i = 0; i < select.options.length; i++)
   {
    if (select.options[i].text == v)
	return i;
   }
  return -1;
 }

function loadPanelData () {
	with (document.zoneForm) {
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_ZONE_BEAN %>", null);
	
			if (o != null) {
				
				 // Load country list and set selected index to the zone's country
				<%
						for (int i=0; i < numberOfCountries; i++) {
							if(countries[i] == null) break;
				%>
						 	var vt = new Object();
    					 		vt.value = "<%= countries[i].getCountryAbbr()%>";
    					 		vt.text = "<%= countries[i].getName()%>";
   						 	values[<%= i %>] = vt;
					
				<% } %>
								
				// if country/region name is not in the list, add it
				if(o.<%=ShippingConstants.ELEMENT_COUNTRY %> != null){
					if(!isNameInTextArray(o.<%=ShippingConstants.ELEMENT_COUNTRY %>, values)){
						 var vt1 = new Object();
    						 vt1.text = o.<%=ShippingConstants.ELEMENT_COUNTRY %>;
    					 	 vt1.value = o.<%=ShippingConstants.ELEMENT_COUNTRY %>;
   						 values[values.length] = vt1;
					}
				}
				else{
					values[values.length] = any;
				}
					
				
				loadTextValueSelectValues(countryList, values);
				var countryIndex = indexOfTextInList(countryList, o.<%=ShippingConstants.ELEMENT_COUNTRY %>);
				if(countryIndex >= 0){
					countryList.selectedIndex = countryIndex;
				}
				else{
					countryList.selectedIndex  = indexOfTextInList(countryList, "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>");
				
				}
				/**
				// Load state list and set selected index to the zone's state 
	 			var stateValues = new Array();
		
				for (int i=0; i < numberOfStates; i++) {
					if(states[i] == null) break;

					stateValues[i] = states[i].getName();
  
				}

				loadSelectValues(stateList, stateValues);
				var stateIndex = indexOfValueList(stateList, o.<%= ShippingConstants.ELEMENT_STATE %>);
				if(stateIndex >= 0){
					stateList.selectedIndex = stateIndex;
				}
				else{
					loadValue(stateText, o.<%= ShippingConstants.ELEMENT_STATE %>);
				}
				*/
				<%
				if (numberOfStates == 0) {
				%>
					loadValue(stateText, o.<%= ShippingConstants.ELEMENT_STATE %>);
				<%
				}
				%>
				loadValue(cityText, o.city);
				loadValue(zipStartText, o.<%= ShippingConstants.ELEMENT_ZIP_START %>);
				loadValue(zipEndText, o.<%= ShippingConstants.ELEMENT_ZIP_END %>);
				if (o.<%= ShippingConstants.ELEMENT_ZIP_START %> != null && o.<%= ShippingConstants.ELEMENT_ZIP_START %> != "") {
					zipCodeRange.checked = true;
					basedOnZip();
				}
			
			}

			if (parent.get("zoneNameRequired", false)) {
				parent.remove("zoneNameRequired");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_NAME_REQUIRED)) %>");
				zoneNameText.focus();
				return;
			}

			if (parent.get("zoneNameTooLong", false)) {
				parent.remove("zoneNameTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_NAME_TOO_LONG)) %>");
				zoneNameText.select();
				zoneNameText.focus();
				return;
			}

			if (parent.get("stateTooLong", false)) {
				parent.remove("stateTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_STATE_TOO_LONG)) %>");
				stateText.select();
				stateText.focus();
				return;
			}
			
			if (parent.get("cityTooLong", false)) {
				parent.remove("cityTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CITY_TOO_LONG)) %>");
				cityText.select();
				cityText.focus();
				return;
			}

			if (parent.get("zipcodeStartTooLong", false)) {
				parent.remove("zipcodeStartTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZIPCODE_START_TOO_LONG)) %>");
				zipStartText.select();
				zipStartText.focus();
				return;
			}
			
			if (parent.get("zipcodeEndTooLong", false)) {
				parent.remove("zipcodeEndTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZIPCODE_END_TOO_LONG)) %>");
				zipEndText.select();
				zipEndText.focus();
				return;
			}

			if (parent.get("zoneExists", false)) {
				parent.remove("zoneExists");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_EXISTS)) %>");
				zoneNameText.select();
				zoneNameText.focus();
				return;
			}

			if (parent.get("zoneChanged", false)) {
				parent.remove("zoneChanged");
				if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_CHANGED)) %>")) {
					parent.put("forceSave", true);
					parent.finish();
					parent.remove("forceSave");
				}
			}
			
			
		}
	}
}



function savePanelData () {
	with (document.zoneForm) {
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_ZONE_BEAN %>", null);
			if (o != null) {
				<% if (newZone) { %>
				o.<%= ShippingConstants.ELEMENT_CODE %> = zoneNameText.value;
				<% } %>
				o.<%= ShippingConstants.ELEMENT_COUNTRY %> = countryList.options[countryList.selectedIndex].text;
				o.<%= ShippingConstants.ELEMENT_COUNTRY_ABBR %> = countryList.options[countryList.selectedIndex].value;
				/*
				if(stateList.selectedIndex > 0){
					o.<%= ShippingConstants.ELEMENT_STATE %> = stateList.options[stateList.selectedIndex].value;
				}
				else{
				*/
					o.<%= ShippingConstants.ELEMENT_STATE %> = stateText.value;
				//}
				o.<%= ShippingConstants.ELEMENT_CITY %> = cityText.value;
				if (zipCodeRange.checked == true) {
					o.<%= ShippingConstants.ELEMENT_ZIP_START %> = zipStartText.value;
					o.<%= ShippingConstants.ELEMENT_ZIP_END %> = zipEndText.value;
				}
				
				<% if (!newZone) { %>
				if (zipCodeRange.checked == false) {
					o.<%= ShippingConstants.ELEMENT_ZIP_START %> = null;
					o.<%= ShippingConstants.ELEMENT_ZIP_END %> = null;
				}
				<% } %>
	
			}
		}
	}
}

function basedOnZip() {
	if (document.zoneForm.zipCodeRange.checked) {
		document.all["zipRange"].style.display = "block";	
	} else {
		document.all["zipRange"].style.display = "none";	
	}
}

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= title %></h1>
<LINE3><%= panelPrompt %></LINE3>

<form name="zoneForm">
<TABLE BORDER='0' summary="<%=UIUtil.toHTML(panelPrompt)%>">
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_CODE_PROMPT) %><BR>

<%	
	if (!newZone) { 
%>
<SCRIPT language="JavaScript">
var o = parent.get("<%= ShippingConstants.ELEMENT_ZONE_BEAN %>", null);
document.writeln("<i>" + o.<%= ShippingConstants.ELEMENT_CODE %> + "</i></TD></TR>");
</SCRIPT>
<% 
	} else { 
%>
<LABEL for="zoneNameText"><input name="zoneNameText" id="zoneNameText" type="text" size="30" maxlength="30"></LABEL></TD></TR>
<%
	}
%>
<TR><TD><BR></TD></TR>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_REGION_PROMPT) %><BR>
<LABEL for="countryList"><select name="countryList" id="countryList" <%=disabledString%>></LABEL>
</select>
</TD></TR>
<TR><TD><BR></TD></TR>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_STATE_PROMPT) %><BR>

<%
	if (numberOfStates != 0) {
%>
<LABEL for="stateList"><select name="stateList" id="stateList" <%=disabledString%>></LABEL>
<%		

		for (int i=0; i < states.length; i++) {
			if(states[i] == null) break;
%>
			<option value='<%=states[i].getName()%>'><%=states[i].getName()%></option>
<%		
		}

%>
</select>
<%
	}
	else {
%>
<LABEL for="stateText"><input name="stateText" id="stateText" type="text" size="30" maxlength="128" <%=disabledString%>/></LABEL>
<%		
	}
%>
</TD></TR>
<TR><TD><BR></TD></TR>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_CITY_PROMPT)%><BR>
<LABEL for="cityText"><input name="cityText" id="cityText" type="text" size="30" maxlength="128" <%=disabledString%>/></LABEL></TD></TR>

<TR><TD><BR></TD></TR>
<TR><TD><LABEL>
<INPUT TYPE="CheckBox" NAME="zipCodeRange" SIZE="1" onClick="basedOnZip()" <%=disabledString%>>

<%=UIUtil.toHTML((String)shippingRB.get("zoneZipCodeRange"))%></LABEL><BR>
<DIV ID="zipRange" STYLE="display:none;">
<TABLE>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_ZIPCODE_START_PROMPT)%><BR>

<LABEL for="zipStartText"><input name="zipStartText" id="zipStartText" type="text" size="30" maxlength="40" <%=disabledString%>/></LABEL></TD></TR>

<TR><TD><%= shippingRB.get(ShippingConstants.MSG_ZONE_ZIPCODE_END_PROMPT)%><BR>
<LABEL for="zipEndText"><input name="zipEndText" id="zipEndText" type="text" size="30" maxlength="40" <%=disabledString%>/></LABEL></TD></TR>

</TABLE>
</DIV>
</TD></TR>
</TABLE>
</form>

</body>

</html>
