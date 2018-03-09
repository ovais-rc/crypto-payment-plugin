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

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.common.beans.StoreDefaultDataBean" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.fulfillment.beans.ShippingModeDataBean" %>
<%@page import="com.ibm.commerce.fulfillment.beans.ShippingModeDescriptionDataBean" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>

<%@include file="ShippingCommon.jsp" %>

<%    
	StoreDefaultDataBean storeDefault = new StoreDefaultDataBean();
	storeDefault.setDataBeanKeyStoreId(fStoreId.toString());
	DataBeanManager.activate(storeDefault, request);
	String defaultShipMode = storeDefault.getShipModeId();
	
	String orderByParm = request.getParameter(ShippingConstants.PARAMETER_ORDER_BY);

	ShippingModeListDataBean shipModeList;
	ShippingModeDataBean shipModes[] = null;
	int numberOfShipModes = 0;
	shipModeList = new ShippingModeListDataBean();
	DataBeanManager.activate(shipModeList, request);
	shipModes = shipModeList.getSortedShipModeList(orderByParm);
	if (shipModes != null) {
		numberOfShipModes = shipModes.length;
	}
	
%>

<html>

<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

function newShipMode () {
		
	var panelURL = "/webapp/wcs/tools/servlet/DialogView?XMLFile=shipping.ShipModeDialog";
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_SHIPMODE)) %>", panelURL, true);
	}
	else {
		parent.location.replace(panelURL);
	}
}


function changeShipMode() {

	var shipModeId = -1;
	
	if (arguments.length > 0) {
		shipModeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			shipModeId = getShipModeId(checked[0]);
		}
	}
	if (shipModeId != -1) {
		
  		var panelURL = "/webapp/wcs/tools/servlet/DialogView?XMLFile=shipping.ShipModeDialog&amp;" + "<%=ShippingConstants.PARAMETER_SHIPMODE_ID + "="%>"  + shipModeId;
	
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_UPDATE_SHIPMODE)) %>", panelURL, true);
		}
		else {
			parent.location.replace(panelURL);
		}
	}
}

function displayShipMode() {

	var shipModeId = -1;
	
	if (arguments.length > 0) {
		shipModeId = arguments[0];
	}
	if (shipModeId != -1) {
		

	    var panelURL = "<%= ShippingConstants.URL_SHIPMODE_DETAILS_DIALOG_VIEW + ShippingConstants.PARAMETER_SHIPMODE_ID + "="%>"  + shipModeId + "&amp;<%= ShippingConstants.PARAMETER_READONLY%>=true";  		
	
		if (top.setContent) {

			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DETAILS_SHIPMODE)) %>", panelURL, true);		}
		else {
			parent.location.replace(panelURL);
		}
	}
}

function deleteShipModes() {

	var checked = parent.getChecked();
	for (var i=0; i < checked.length; i++) {
		if (checked[i] == "<%=defaultShipMode%>") {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("shipModeNotDeleteDefault")) %>");
			return;
		}
	}
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("shipModesListDeleteConfirmation")) %>")) {
			var shipModeId = getShipModeId(checked[0]);
			var url = "<%= ShippingConstants.URL_SHIPMODE_DELETE + ShippingConstants.PARAMETER_SHIPMODE_IDS + "="%>" + shipModeId;
			for (var i=1; i<checked.length; i++) {
				shipModeId = getShipModeId(checked[i]);
				url += "," + shipModeId;
			}
			parent.location.replace(url);
		}
	}
		
	
}

function makeDefault() {
	var shipModeId = -1;
	
	if (arguments.length > 0) {
		shipModeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length != 1) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_DEFAULT_SELECT_ONE)) %>")
			
		}
		else {
			shipModeId = getShipModeId(checked[0]);
		}
	}
	if (shipModeId != -1) {
		
  		var panelURL = "<%= ShippingConstants.URL_SHIPMODE_DEFAULT + ShippingConstants.PARAMETER_SHIPMODE_ID + "="%>"  + shipModeId;
		parent.location.replace(panelURL);
	
	}
	
	
}
function getEditableFlag(value){
    if(value.indexOf("|")!=-1)
    {
		return value.substring(value.indexOf("|") + 1, value.length);
	}
	else
	{
		return value;
	}
}

function getShipModeId(value)
{
	if(value.indexOf("|")!=-1)
	{
		return value.substring(0,value.indexOf("|"));
	}
	else
	{
		return value;
	}
}

function selectShipMode()
{
	parent.refreshButtons();

	var checked = parent.getChecked();
	if (checked.length > 0) {
		for (var i=0;i<checked.length;i++){
			if(getEditableFlag(checked[i])=="N"){
		    	disableButton(parent.buttons.buttonForm.changeButton);
		    	disableButton(parent.buttons.buttonForm.deleteButton);
		    	disableButton(parent.buttons.buttonForm.makeDefaultButton);		    	
				break;			
			}
		}
	
	}

}

function getResultsSize () {
	return <%= numberOfShipModes %>;
}


function onLoad () {
	parent.loadFrames();
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="onLoad()" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter(ShippingConstants.PARAMETER_START_INDEX));
	int listSize = Integer.parseInt(request.getParameter(ShippingConstants.PARAMETER_LIST_SIZE));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfShipModes;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel(ShippingConstants.NAME_SPACE + ShippingConstants.SHIPMODE_LIST, totalpage, totalsize, fLocale) %>


<form name="ShipModesListForm">

<%= comm.startDlistTable((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();selectShipMode()") %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_CARRIER_COLUMN), ShippingConstants.ORDER_BY_CARRIER, ShippingConstants.ORDER_BY_CARRIER.equals(orderByParm) ) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_CODE_COLUMN), ShippingConstants.ORDER_BY_NAME, ShippingConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_EXPECTED_DELIVERY_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_DESCRIPTION_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_DEFAULT_COLUMN), null, false) %>

<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfShipModes) {
		endIndex = numberOfShipModes;
	}

	ShippingModeDataBean shipMode;
	ShippingModeDescriptionDataBean shipModeDescription;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {

		shipMode = (ShippingModeDataBean)shipModes[i];
		String shipModeId = shipMode.getDataBeanKeyShippingModeId();
	
		shipModeDescription = new ShippingModeDescriptionDataBean();
		shipModeDescription.setDataBeanKeyShipModeId(shipModeId);
		shipModeDescription.setDataBeanKeyLanguageId(fLanguageId);
		
		String description = "";
		String field2 = "";
		
		try{
			DataBeanManager.activate(shipModeDescription, request);
			description = shipModeDescription.getDescription();
			field2 = shipModeDescription.getField2();
		}
		catch(Exception e){}
		
		
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (shipMode.getStoreEntityIdInEntityType().equals(fStoreId)) { %>
<%= comm.addDlistCheck(shipMode.getShippingModeId() + "|Y", "parent.setChecked();selectShipMode()") %>
<%		} else { %>
<%= comm.addDlistCheck(shipMode.getShippingModeId() + "|N", "parent.setChecked();selectShipMode()") %>
<% } %>

<%= comm.addDlistColumn(shipMode.getCarrier(), "none") %>
<%		if (shipMode.getStoreEntityIdInEntityType().equals(fStoreId)) { %>
<%= comm.addDlistColumn(shipMode.getCode(), "javascript:changeShipMode(" + shipMode.getShippingModeIdInEntityType() + ")") %>
<%		} else { %>
<%= comm.addDlistColumn(shipMode.getCode(), "javascript:displayShipMode(" + shipMode.getShippingModeIdInEntityType() + ")") %>
<% } %>


<%= comm.addDlistColumn(field2, "none") %>
<%= comm.addDlistColumn(description, "none") %>
<% 
	if(defaultShipMode != null && defaultShipMode.equals(shipMode.getShippingModeId())){%>
	<%=	comm.addDlistColumn(UIUtil.toJavaScript((String)shippingRB.get("yesPrompt")), "none") %>
<%
	}
	
	else {%>
	<%=	comm.addDlistColumn("","none") %>
<%
	}
	
%>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>
<%	if (numberOfShipModes == 0) { %>
<p></p>
<p>
<%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_LIST_EMPTY) %>
<%	} %>
</p>
</form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>

