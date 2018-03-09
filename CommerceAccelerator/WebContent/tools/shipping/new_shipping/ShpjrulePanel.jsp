<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="java.util.*" %>

<%@ include file="ShippingCommon.jsp" %>
<%@ include file= "../../common/NumberFormat.jsp" %>

<jsp:useBean id="shipModeList" scope="request" class="com.ibm.commerce.tools.shipping.ShippingModeListDataBean">
<jsp:useBean id="ffmCenterListBean" scope="request" class="com.ibm.commerce.fulfillment.beans.FFMOrderItemsListDataBean">
<jsp:useBean id="zoneListBean" scope="request" class="com.ibm.commerce.tools.shipping.JurisdictionGroupRelListDataBean">


<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Integer langId = cmdContext.getLanguageId();
   String id = request.getParameter("shpjRuleId");
   String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
   boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
   String disabledString = " disabled";
   if(editable){
   	   disabledString = "";
   }

   String title = "";
   
   if (id == null) {
   	title = UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_PANEL_PROMPT));
   } else {
   	title = UIUtil.toHTML((String)shippingRB.get("shpjRuleChangePanelPrompt"));
   }
   com.ibm.commerce.fulfillment.beans.ShippingModeDataBean shipModes[] = null;
   int numberOfShipModes = 0;
   DataBeanManager.activate(shipModeList, request);
   shipModes = shipModeList.getShippingModeList();
   if (shipModes != null) {
	numberOfShipModes = shipModes.length;
   }
	
   com.ibm.commerce.fulfillment.beans.FFMOrderItemsDataBean ffmCenters[] = null; 
   int numberOfFFCs = 0;
   ffmCenterListBean.setDataBeanKeyLanguageId(fLanguageId);
   ffmCenterListBean.setDataBeanKeyStoreentId(fStoreId.toString());
   DataBeanManager.activate(ffmCenterListBean, request);
   ffmCenters = ffmCenterListBean.getFFMOrderItemsList();

   if (ffmCenters != null)  
   {
     numberOfFFCs = ffmCenters.length;
   }
	
	com.ibm.commerce.fulfillment.beans.JurisdictionGroupDataBean zones[] = null;
	int numberOfZones = 0;
	DataBeanManager.activate(zoneListBean, request);
	zones = zoneListBean.getJurisdictionGroupList();
	if (zones != null) {
		java.util.ArrayList tempJurstGPIdlist = new java.util.ArrayList();
		java.util.ArrayList tempJurstGPDBlist = new java.util.ArrayList();
		for(int i=0; i<zones.length; i++){
			String jurstGPId = zones[i].getJurisdictionGroupId();
			if(!tempJurstGPIdlist.contains(jurstGPId)){
				tempJurstGPIdlist.add(jurstGPId);
				tempJurstGPDBlist.add(zones[i]);
			}
		}
		zones = new com.ibm.commerce.fulfillment.beans.JurisdictionGroupDataBean[tempJurstGPDBlist.size()];
		tempJurstGPDBlist.toArray(zones);
		numberOfZones = zones.length;
	}
	


%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_PANEL_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShpjruleDialog.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

var debug = false;

function addAction () {
	// if this return false then validation failed... this window will stay open.
	// otherwise the when condition will be add and the window closed.
 with(document.shpjruleForm){
 
 	if(zoneSelect.options.length == 0) {
    		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("paragraph1")) %>");
		return false;
    	}
    	if(shipModeSelect.options.length == 0) {
    		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("paragraph2")) %>");
		return false;
    	}
 
	var shjrule = parent.get("<%= ShippingConstants.ELEMENT_SHPJRULE_BEAN %>", null);
	
	if(ffcSelect.options.length>0){
		shjrule.<%= ShippingConstants.ELEMENT_FFC_ID %> = ffcSelect.options[ffcSelect.selectedIndex].value;
		if(debug == true) alert("Inside document.shpjruleForm.ffcSelect.value = " + ffcSelect.options[ffcSelect.selectedIndex].value);
		
		shjrule.<%= ShippingConstants.ELEMENT_FFC_NAME %> = ffcSelect.options[ffcSelect.selectedIndex].text;
	
		if(debug == true) alert("Inside document.shpjruleForm.ffcSelect.text = " + ffcSelect.options[ffcSelect.selectedIndex].text);
	}
	
	shjrule.<%= ShippingConstants.ELEMENT_ZONE_ID %> = zoneSelect.options[zoneSelect.selectedIndex].value;
	
	if(debug == true) alert("Inside zoneSelect.options[zoneSelect.selectedIndex].value = " + zoneSelect.options[zoneSelect.selectedIndex].value);
	shjrule.<%= ShippingConstants.ELEMENT_ZONE_CODE %> =  zoneSelect.options[zoneSelect.selectedIndex].text;
	
	if(debug == true) alert("Inside zoneSelect.options[zoneSelect.selectedIndex].text = " + zoneSelect.options[zoneSelect.selectedIndex].text);
	
	shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_ID %> = shipModeSelect.options[shipModeSelect.selectedIndex].value;
	
	if(debug == true) alert("Inside shipModeSelect.options[shipModeSelect.selectedIndex].value = " + shipModeSelect.options[shipModeSelect.selectedIndex].value);
	shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_CODE %> = shipModeSelect.options[shipModeSelect.selectedIndex].text;
	
	if(debug == true) alert("Inside shipModeSelect.options[shipModeSelect.selectedIndex].text = " + shipModeSelect.options[shipModeSelect.selectedIndex].text);
	if (!isValidInteger(PrecedenceInput.value, <%=langId.intValue()%>)) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("notInteger")) %>");
		return false;
	}
	shjrule.<%= ShippingConstants.ELEMENT_PRECEDENCE %> = PrecedenceInput.value;
	
	var ruledatabean = top.getData("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", 1);
	
	for (var i=0; i < ruledatabean.shpjrules.length; i++) {
		if (ruledatabean.shpjrules[i].<%= ShippingConstants.ELEMENT_FFC_ID %> == shjrule.<%= ShippingConstants.ELEMENT_FFC_ID %> 
		    && ruledatabean.shpjrules[i].<%= ShippingConstants.ELEMENT_ZONE_ID %> == shjrule.<%= ShippingConstants.ELEMENT_ZONE_ID %> 
		    && ruledatabean.shpjrules[i].<%= ShippingConstants.ELEMENT_SHIPMODE_ID %> == shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_ID %> ) {
		    if (i == <%=(id == null ? null : UIUtil.toJavaScript(id))%>) continue;
		    alertDialog("<%= UIUtil.toJavaScript(shippingRB.get("shpjruleExists")) %>")
		    return false;
		}
		    
	}
	if(ruledatabean != null){
		if(debug == true) alert("ruledatabean not null");
        	if(debug == true) alert("numberOfShjrules before " + ruledatabean.shpjrules.length);
        
        	<% if (id == null || id.equals("")) {%>
    			ruledatabean.shpjrules[ruledatabean.shpjrules.length] = shjrule;
    		<%} else {%>
    			ruledatabean.shpjrules[<%=(id == null ? null : UIUtil.toJavaScript(id))%>] = shjrule;
    		<% } %>
    	
    	
        	if(debug == true) alert("numberOfShjrules after " + ruledatabean.shpjrules.length);

	}
  }

	if(debug == true) alert("exiting addAction");
	return true;
}

function cancelAction () {
	top.goBack();
}

function convertToInt() {
	var val = document.shpjruleForm.PrecedenceInput.value;
}

var any = new Object();
any.text = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";
any.value = "";
   			
	

function loadPanelData() {

	with (document.shpjruleForm) {
		var shjrule = null;
		var ffc_id;
		var zone_id;
		var mode_id;
		var prec;
		<% if (id != null && !id.equals("")) { %>
			var ruledatabean = top.getData("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", 1);
			shjrule = ruledatabean.shpjrules[<%=(id == null ? null : UIUtil.toJavaScript(id))%>];
			ffc_id = shjrule.<%= ShippingConstants.ELEMENT_FFC_ID %>
			zone_id = shjrule.<%= ShippingConstants.ELEMENT_ZONE_ID %>
			mode_id = shjrule.<%= ShippingConstants.ELEMENT_SHIPMODE_ID %>
			prec = shjrule.<%= ShippingConstants.ELEMENT_PRECEDENCE %>
        		
        	<% } %>
    		
    	
        	

	
	
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		
				if(debug == true) alert("Inside loadPanelData");
				var vt = new Object();
				// Load avalilable shipping modes to the select list
				
	 					var values = new Array();
				<%
						for (int i=0; i < numberOfShipModes; i++) {
							if(shipModes[i] == null) break;
				%>
						 vt = new Object();
    					 vt.text = "<%= shipModes[i].getCarrier()%>" + " - " + "<%= shipModes[i].getCode()%>";
    					 vt.value = "<%= shipModes[i].getDataBeanKeyShippingModeId() %>";
   						 values[<%= i %>] = vt;
					
				<%
						}
				%>
				
						//values[values.length] = any;
						if(debug == true) alert("after values[values.length]");
			
						loadTextValueSelectValues(shipModeSelect, values);
						if(debug == true) alert("after loadTextValueSelectValues");
			
						//shipModeSelect.selectedValue = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";
		
				if(debug == true) alert("after shipModeSelect");
				
				// Load avalilable zones to the select list
					
	 				values = new Array();
				<%
						for (int i=0; i < numberOfZones; i++) {
							if(zones[i] == null) break;
				%>
						 vt = new Object();
    					 vt.text = "<%= zones[i].getCode()%>";
    					 vt.value = "<%= zones[i].getDataBeanKeyIJurisdictionGroupId()%>";
   						 values[<%= i %>] = vt;
					
				<%
						}
				%>
					
						//values[values.length] = any;
		    			loadTextValueSelectValues(zoneSelect, values);	
						//zoneSelect.selectedValue = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";
		
					if(debug == true) alert("after zoneSelect");
			
						
				// Load avalilable fulfillment centers to the select list
					
	 				values = new Array();
				<%
						for (int i=0; i < numberOfFFCs; i++) {
							if(ffmCenters[i] == null) break;
				%>
						 vt = new Object();
    					 vt.text = "<%= ffmCenters[i].getDataBeanKeyName()%>";
    					 vt.value = "<%= ffmCenters[i].getDataBeanKeyFulfillmentCenterId()%>";
   						 values[<%= i %>] = vt;
					
				<%
						}
				%>
						//enable any fufillment center selection
						values[values.length] = any;
						loadTextValueSelectValues(ffcSelect, values);
						ffcSelect.selectedValue = "<%= shippingRB.get(ShippingConstants.MSG_ANY) %>";
						
						if(debug == true) alert("after ffcSelect");
					
	
	
	for (var f=0; f < ffcSelect.length; f++) {
		if (ffcSelect[f].value == ffc_id) {
		

			ffcSelect[f].selected = true
			break;
		}
	}
	
	
	for (var z=0; z < zoneSelect.length; z++) {
		if (zoneSelect[z].value == zone_id) {
			zoneSelect[z].selected = true
			break;
		}
	}
	
	for (var s=0; s < shipModeSelect.length; s++) {
		if (shipModeSelect[s].value == mode_id) {
			shipModeSelect[s].selected = true
			break;
		}
	}
	
	if (prec != null) { 
		PrecedenceInput.value = prec;
	} else {
		PrecedenceInput.value = 1;
	}

	} // end of with
	
	if(debug == true) alert("exiting loadPanelData");
	
				
}




//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= title %></h1>
<LINE3><%=UIUtil.toHTML((String)shippingRB.get("shpjRulePanelDesc"))%></LINE3>
<%
	CalcRuleDetailsDataBean calcRule = new CalcRuleDetailsDataBean();
	DataBeanManager.activate(calcRule, request);
%>

<% 
	if(calcRule.getId() != null){
%>

<p class="entry_text"><%= (String)shippingRB.get(ShippingConstants.MSG_SHPJRULE_CALCRULE) + " " + calcRule.getId().toString()%>

<%
	}
%>

<form name="shpjruleForm">

<p><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_FFC_PROMPT) %><br/>
	<LABEL for="ffcSelect"><select name="ffcSelect" id="ffcSelect" <%=disabledString%>>
	</select></LABEL>
</p>

<p><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_ZONE_PROMPT) %><br/>
	<LABEL for="zoneSelect"><select name="zoneSelect" id="zoneSelect" <%=disabledString%>>
	</select></LABEL>
</p>

<p><%= shippingRB.get(ShippingConstants.MSG_SHPJRULE_SHIPMODE_PROMPT) %><br/>
	<LABEL for="shipModeSelect"><select name="shipModeSelect" id="shipModeSelect" <%=disabledString%>>
	</select></LABEL>

</p>

<P><%= shippingRB.get(ShippingConstants.MSG_PRECEDENCE_PROMPT) %><BR>

<LABEL><INPUT name="PrecedenceInput" type="TEXT" size="30" maxlength="30" onblur="convertToInt()" <%=disabledString%>></LABEL>
<BR>

</form>

</body>

</html></jsp:useBean></jsp:useBean></jsp:useBean><HTML></HTML>
