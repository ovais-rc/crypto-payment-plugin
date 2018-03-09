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


<%@page import="com.ibm.commerce.tools.shipping.ShippingModeListDataBean" %>
<%@page import="com.ibm.commerce.tools.shipping.ShippingConstants" %>
<%@page import="com.ibm.commerce.fulfillment.beans.ShippingModeDataBean" %>

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="java.util.*" %>

<%@include file="ShippingCommon.jsp" %>

<%

	   String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
	   boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
	   String disabledString = " disabled";
	   if(editable){
	          disabledString = "";
	   }

       String shipModeId = request.getParameter(ShippingConstants.PARAMETER_SHIPMODE_ID);
       boolean newShipMode = (shipModeId == null || shipModeId.equals(""))&& editable;
       
       String title;
       String panelPrompt;
       if(newShipMode){
              title = (String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_NEW_DIALOG_TITLE);
              panelPrompt = (String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_NEW_PANEL_PROMPT);
       }
       else if(editable){
              title = (String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_CHANGE_DIALOG_TITLE);
              panelPrompt = "";
       }
	   else{
			  title = (String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_DETAILS_DIALOG_TITLE);;
			  panelPrompt = "";
	   }
       
  
       ShippingModeListDataBean shipModeList;
       ShippingModeDataBean shipModes[] = null;
       int numberOfShipModes = 0;
       shipModeList = new ShippingModeListDataBean();
       DataBeanManager.activate(shipModeList, request);
       shipModes = shipModeList.getShippingModeList();
       if (shipModes != null) {
              numberOfShipModes = shipModes.length;
       }

  
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= title %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShipModeDialog.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">


var debug = false;

function showProviderDivisions() {
       
       if (document.shipModeForm.providerRadio[0].checked) {       
              document.all.providerNewNameDiv.style.display = "block";
              document.all.providerExistingNameDiv.style.display = "none";
       }
       else if (document.shipModeForm.providerRadio[1].checked) {
              document.all.providerNewNameDiv.style.display = "none";
              document.all.providerExistingNameDiv.style.display = "block";
       }
       
}

function showServiceDivisions() {
       if (document.shipModeForm.serviceRadio[0].checked) {
              document.all.serviceNewNameDiv.style.display = "block";
              document.all.serviceExistingNameDiv.style.display = "none";
       }
       else if (document.shipModeForm.serviceRadio[1].checked) {
              document.all.serviceNewNameDiv.style.display = "none";
              document.all.serviceExistingNameDiv.style.display = "block";
       }
}



function loadPanelData() {

       with (document.shipModeForm) {
       
              if (parent.setContentFrameLoaded) {
                     parent.setContentFrameLoaded(true);
              }
              
              if (parent.get) {
                     var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
       
                     if (o != null) {
                                   
                            if (<%=newShipMode%>) {
                            if (debug == true)       alert('loading for the new ship mode');
                                   // Load providers list and set selected index to the shipmode's provider 
                                    var values = new Array();
                                   <% for (int i=0; i < numberOfShipModes; i++) {
                                          if(shipModes[i] == null) break;
                                   %>
                                          values[<%= i %>] = "<%= UIUtil.toJavaScript( shipModes[i].getCarrier() )%>";
                                   <% } %>
                                   var redValues = new Array();
                                   var ind1 = 0;
                                   for (var x = 0; x < values.length; x++) {
                                          for (var y = values.length -1; y > -1; y--) {
                                                 if (values[x] == values[y] && x != y ) {
                                                        values[y] = null;
                                                 }
                                          }
                                   }
                                   for (var z=0; z < values.length; z++) {
                                          if (values[z] != null) {
                                                 redValues[ind1] = values[z];
                                                 ind1++;
                                          }
                                   }
                                   loadSelectValues(providersList, redValues);
                                   // Load service list and set selected index to the shipmode's service 
                                    var serviceValues = new Array();
                                    
                                    <% for (int i=0; i < numberOfShipModes; i++) {
                                          if(shipModes[i] == null) break;
                                   %>
                                          serviceValues[<%= i %>] = "<%= UIUtil.toJavaScript( shipModes[i].getCode() )%>";
                                   <% } %>
                                   var redValues2 = new Array();
                                   var ind2 = 0;
                                   for (var m = 0; m < serviceValues.length; m++) {
                                          for (var n = serviceValues.length -1; n > -1; n--) {
                                                 if (serviceValues[m] == serviceValues[n] && m != n ) {
                                                        serviceValues[n] = null;
                                                 }
                                          }
                                   }
                                   for (var p=0; p < serviceValues.length; p++) {
                                          if (serviceValues[p] != null) {
                                                 redValues2[ind2] = serviceValues[p];
                                                 ind2++;
                                          }
                                   }
                                   
                                   loadSelectValues(servicesList, redValues2);
                            }                                                        
                            
                     
                            loadValue(displayNameInput, o.<%= ShippingConstants.ELEMENT_FIELD1 %>);
                            loadValue(descriptionText, o.<%= ShippingConstants.ELEMENT_DESCRIPTION %>);
                            loadValue(additionalDescriptionText, o.<%= ShippingConstants.ELEMENT_FIELD2 %>);
                            loadValue(trackURLInput, o.trackURL);
                            
                            
                                                        
                            if(<%=newShipMode%>){
                            
                            showProviderDivisions();
                            showServiceDivisions();
                            
                            if (parent.get("providerNameRequired", false)) {
                                   parent.remove("providerNameRequired");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PROVIDER_NAME_REQUIRED)) %>");
                                   return;
                            }

                            if (parent.get("serviceNameRequired", false)) {
                                   parent.remove("serviceNameRequired");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SERVICE_NAME_REQUIRED)) %>");
                                   return;
                            }
                     
                            if (parent.get("providerNameTooLong", false)) {
                                   parent.remove("providerNameTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PROVIDER_NAME_TOO_LONG)) %>");
                                   providerNewNameInput.select();
                                   providerNewNameInput.focus();
                                   return;
                            }

                     
                            if (parent.get("serviceNameTooLong", false)) {
                                   parent.remove("serviceNameTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SERVICE_NAME_TOO_LONG)) %>");
                                   serviceNewNameInput.select();
                                   serviceNewNameInput.focus();
                                   return;
                            }
                            
                            }

                     
                            if (parent.get("shipModeDescriptionTooLong", false)) {
                                   parent.remove("shipModeDescriptionTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DESCRIPTION_TOO_LONG)) %>");
                                   descriptionText.select();
                                   descriptionText.focus();
                                   return;
                            }
                     
                            if (parent.get("displayNameTooLong", false)) {
                                   parent.remove("displayNameTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_NAME_TOO_LONG)) %>");
                                   displayNameInput.select();
                                   displayNameInput.focus();
                                   return;
                            }

                            if (parent.get("addDescriptionTooLong", false)) {
                                   parent.remove("addDescriptionTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_ADD_DESCR_TOO_LONG)) %>");
                                   additionalDescriptionText.select();
                                   additionalDescriptionText.focus();
                                   return;
                            }
                            
                            if (<%=newShipMode%> && parent.get("shipModeExists", false)) {
                                   parent.remove("shipModeExists");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.ERROR_SHIPMODE_EXISTS)) %>");
                                   if (parent.get("newPR", false)) {
                                          providerNewNameInput.value = o.<%=ShippingConstants.ELEMENT_CARRIER%>;
                                   } else {
                                          providerRadio[1].checked = true;
                                          showProviderDivisions();
                                   }
                                   if (parent.get("newSR", false)) {
                                          serviceNewNameInput.value = o.<%=ShippingConstants.ELEMENT_CODE%>;
                                   } else {
                                          serviceRadio[1].checked = true;
                                          showServiceDivisions();
                                   }
                                   return;
                            }
                            
                            if (parent.get("shipModeChanged", false)) {
                                   parent.remove("shipModeChanged");
                                   if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.ERROR_SHIPMODE_CHANGED)) %>")) {
                                          parent.put("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>", true);
                                          parent.finish();
                                          parent.remove("<%= ShippingConstants.ELEMENT_FORCE_SAVE %>");
                                   }
                            }
                            
                            if (parent.get("trackURLTooLong", false)) {
                                   parent.remove("trackURLTooLong");
                                   alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_URL_TOO_LONG)) %>");
                                   trackURLInput.select();
                                   trackURLInput.focus();
                                   return;
                            }
              
       
                     } // end of if (o != null) {
                     
                     if(<%= editable %>){
                     	displayNameInput.focus();
                     }
                     //
              } // end of if (parent.get)
       } // end of with
}

function validatePanelData () {

    if (debug == true)       alert('inside validatePanelData');
       with (document.shipModeForm) {
              if (<%=newShipMode%>) {
              
              if (providerRadio[0].checked) {
       
                     if (!providerNewNameInput.value) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PROVIDER_NAME_REQUIRED)) %>");
                            providerNewNameInput.focus();
                            return false;
                     }
              }
                     if (debug == true)       alert('tested provider name');
                     
                     if (serviceRadio[0].checked) {
       
                     if (!serviceNewNameInput.value) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SERVICE_NAME_REQUIRED)) %>");
                            serviceNewNameInput.focus();
                            return false;
                     }
                     }
                     
                     if (debug == true)       alert('tested service name');
       
                     if (providerRadio[0].checked) {
       
                     if (!isValidUTF8length(providerNewNameInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_PROVIDER_NAME %>)) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PROVIDER_NAME_TOO_LONG)) %>");
                            providerNewNameInput.select();
                            providerNewNameInput.focus();
                            return false;
                     }
                     }
                     
                     if (debug == true)       alert('tested provider name length');
                     
                     if (serviceRadio[0].checked) {
       
       
                     if (!isValidUTF8length(serviceNewNameInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SERVICE_NAME %>)) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SERVICE_NAME_TOO_LONG)) %>");
                            serviceNewNameInput.select();
                            serviceNewNameInput.focus();
                            return false;
                     }
                     }
                     if (debug == true)       alert('tested service name length');
       
              }
              
              if (!isValidUTF8length(displayNameInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_FIELD1 %>)) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_NAME_TOO_LONG)) %>");
                            displayNameInput.select();
                            displayNameInput.focus();
                            return false;
              }
                     if (debug == true)       alert('tested service name displayName');
       
              
              if (!isValidUTF8length(descriptionText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_DESCR %>)) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DESCRIPTION_TOO_LONG)) %>");
                            descriptionText.select();
                            descriptionText.focus();
                            return false;
              }
              
                            if (debug == true)       alert('tested service name description');
       
              if (!isValidUTF8length(additionalDescriptionText.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_FIELD2 %>)) {
                            alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_ADD_DESCR_TOO_LONG)) %>");
                            additionalDescriptionText.select();
                            additionalDescriptionText.focus();
                            return false;
              }
                            if (debug == true)       alert('tested service name additionalDescriptionTextdescription');
                            
              if (!isValidUTF8length(trackURLInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_URL %>)) {
                     alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_URL_TOO_LONG)) %>");
                     trackURLInput.select();
                     trackURLInput.focus();
                     return false;
              }
       
              
       }
       if (debug == true)       alert('inside validatePanelData - exiting true');
       
       return true;
}


function savePanelData () {
       if (debug == true)       alert('inside savePanelData');
       with (document.shipModeForm) {
              if (parent.get) {
                     var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
                     if (o != null) {
                            if (debug == true)       alert('inside savePanelData, model not null');
                            o.<%= ShippingConstants.ELEMENT_DESCRIPTION %> = descriptionText.value;
                            o.<%= ShippingConstants.ELEMENT_FIELD1 %> = displayNameInput.value;
                            o.<%= ShippingConstants.ELEMENT_FIELD2 %> = additionalDescriptionText.value;
                            o.<%= ShippingConstants.ELEMENT_DESCRIPTION %> = descriptionText.value;
                            o.<%= ShippingConstants.ELEMENT_TRACK_URL %> = trackURLInput.value;
                            if (<%=newShipMode%>){
                                   if (providerRadio[0].checked) {
                                          parent.put("newPR", true);
                                          o.<%= ShippingConstants.ELEMENT_CARRIER %> = providerNewNameInput.value;
                                   }
                                   else if (providerRadio[1].checked) {
                                          parent.put("newPR", false);
                                          o.<%= ShippingConstants.ELEMENT_CARRIER %> = providersList.value;
                                   }
       
                                   if (serviceRadio[0].checked) {
                                          parent.put("newSR", true);
                                          o.<%= ShippingConstants.ELEMENT_CODE %> = serviceNewNameInput.value;       
                                   }
                                   else if (serviceRadio[1].checked) {
                                          parent.put("newSR", false);
                                          o.<%= ShippingConstants.ELEMENT_CODE %> = servicesList.value;       
                                   }
                            } 
                     }
              }
       }
}

</script>


<META name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= title %></h1>
<LINE3><%= panelPrompt %></LINE3>

<form name="shipModeForm">
<% 
       if (!newShipMode) { 
%>
<p><%= shippingRB.get(ShippingConstants.MSG_SHIPPING_PROVIDER_PROMPT) %><br/>
<SCRIPT>
var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
document.writeln('<i>'+o.carrier+'</i>');
</SCRIPT>
<p><%= shippingRB.get(ShippingConstants.MSG_SHIPPING_SERVICE_PROMPT) %><br/>
<SCRIPT>
var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
document.writeln('<i>'+o.code+'</i>');
</SCRIPT>
<%
       } else { 
%> 
<!--Shipping Provider Divisions -->
<p><TABLE>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_SHIPPING_PROVIDER_PROMPT) %></TD></TR>
<TR><TD>
<LABEL for="providerRadio"><input tabindex="1" type="radio" name="providerRadio" id="providerRadio" onclick="showProviderDivisions();" checked/></LABEL>
<%= shippingRB.get(ShippingConstants.MSG_NEW_PROVIDER_PROMPT) %></TD></TR>
       
<TR><TD>       <div id="providerNewNameDiv" style="display: block; margin-left: 50"><%= UIUtil.toHTML((String)shippingRB.get("shipModesListNameColumn"))%><br>

<LABEL for="providerNewNameInput"><input name="providerNewNameInput" id="providerNewNameInput" type="text" size="30" maxlength="30"/></LABEL></div>
</TD></TR>


<TR><TD>
<LABEL for="providerRadio"><input tabindex="1" type="radio" name="providerRadio" id="providerRadio" onclick="showProviderDivisions();" /></LABEL>
<%= shippingRB.get(ShippingConstants.MSG_EXISTING_PROVIDER_PROMPT) %></TD></TR>

       
<TR><TD>       <div id="providerExistingNameDiv" style="display: none; margin-left: 50"><%=UIUtil.toHTML((String)shippingRB.get("shipModesListNameColumn"))%><br>

<LABEL for="providersList"><select name="providersList" id="providersList">
       </select></LABEL></div>
</TD></TR>

<TR><TD><BR></TD></TR>
<!-- Service Name Divisions -->
<TR><TD><p></TD></TR>
<TR><TD><%= shippingRB.get(ShippingConstants.MSG_SHIPPING_SERVICE_PROMPT) %></TD></TR>
<TR><TD>
<LABEL for="serviceRadio"><input tabindex="1" type="radio" name="serviceRadio" id="serviceRadio" onclick="showServiceDivisions();" checked/></LABEL>
<%= shippingRB.get(ShippingConstants.MSG_NEW_SERVICE_PROMPT) %></TD></TR>

<TR><TD>       <div id="serviceNewNameDiv" style="display: block; margin-left: 50"><%= UIUtil.toHTML((String)shippingRB.get("shipModesListNameColumn"))%><br>
<LABEL for="serviceNewNameInput"><input name="serviceNewNameInput" id="serviceNewNameInput" type="text" size="30" maxlength="30"/></LABEL>
       </div>
</TD></TR>

<TR><TD>
<LABEL for="serviceRadio"><input tabindex="1" type="radio" name="serviceRadio" id="serviceRadio" onclick="showServiceDivisions();" /></LABEL>
<%= shippingRB.get(ShippingConstants.MSG_EXISTING_SERVICE_PROMPT) %></TD></TR>

<TR><TD>       <div id="serviceExistingNameDiv" style="display: none; margin-left: 50"><%= UIUtil.toHTML((String)shippingRB.get("shipModesListNameColumn"))%><br>
<LABEL for="servicesList"><select name="servicesList" id="servicesList">
       </select></LABEL></div>
</TD></TR>
</TABLE>

<%
       } //close if (newShipMode)
%>

<br/>
<p><%= shippingRB.get("shipModeListDescriptionColumn") %>
<br/>
<LABEL for="descriptionText"><input name="descriptionText" id="descriptionText" type="text" size="50" maxlength="40" <%=disabledString%>/></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_DISPLAY_NAME_PROMPT)%>
<br/>
<LABEL for="displayNameInput"><input name="displayNameInput" id="displayNameInput" type="text" size="50" maxlength="40" <%=disabledString%>/></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_ADD_DESCRIPTION_PROMPT) %>
<br/>
<LABEL for="additionalDescriptionText"><input name="additionalDescriptionText" id="additionalDescriptionText" type="text" size="50" maxlength="40" <%=disabledString%>/></LABEL>

<p><%= shippingRB.get("trackURL") %><br>
<LABEL for="trackURLInput"><input name="trackURLInput" id="trackURLInput" type="TEXT" size="30" maxlength="254" <%=disabledString%>/></LABEL>

</form>

</body>

</html>
