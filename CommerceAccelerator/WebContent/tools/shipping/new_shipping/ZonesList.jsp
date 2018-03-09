<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
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
<%@page import="com.ibm.commerce.fulfillment.beans.JurisdictionDataBean" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
	

<%@ include file="ShippingCommon.jsp" %>

<%
	

	JurisdictionListDataBean jurisdictionList;
	JurisdictionDataBean zones[] = null;
	int numberOfZones = 0;
	jurisdictionList = new JurisdictionListDataBean();
	DataBeanManager.activate(jurisdictionList, request);
	zones = jurisdictionList.getJurisdictionList();
	if (zones != null) {
		numberOfZones = zones.length;
	}


%>

<html>

<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_ZONE_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

function newZone () {
var panelURL = "<%= ShippingConstants.URL_ZONE_NEW_DIALOG_VIEW %>";
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_ZONE)) %>", panelURL, true);
	}
	else {
		parent.location.replace(panelURL);
	}

	
}

function changeZone() {
	var zoneId = -1;
	if (arguments.length > 0) {
		zoneId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			zoneId = getJurisdictionId(checked[0]);
		}
	}
	if (zoneId != -1) {
	
	    var panelURL = "<%= ShippingConstants.URL_ZONE_CHANGE_DIALOG_VIEW + ShippingConstants.PARAMETER_ZONE_ID + "="%>"  + zoneId;
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_UPDATE_ZONE)) %>", panelURL, true);
		}
		else {
			parent.location.replace(panelURL);
		}
	}
}
function displayZone()
{
	var zoneId = -1;
	if (arguments.length > 0) {
		zoneId = arguments[0];
	}
	
	if(zoneId!=-1)	{
	    var panelURL = "<%= ShippingConstants.URL_ZONE_DETAILS_DIALOG_VIEW + ShippingConstants.PARAMETER_ZONE_ID + "="%>"  + zoneId + "&amp;<%= ShippingConstants.PARAMETER_READONLY%>=true";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DETAILS_ZONE)) %>", panelURL, true);			
		}
		else {
			parent.location.replace(panelURL);
		}
	}
	
}
function deleteZones() {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_DELETE_CONFIRMATION)) %>")) {
			var zoneId = checked[0];
			var url = "<%= ShippingConstants.URL_ZONE_DELETE + ShippingConstants.PARAMETER_ZONE_IDS + "="%>" + getJurisdictionId(zoneId);
			for (var i=1; i<checked.length; i++) {
				zoneId = checked[i];
				url += "," + getJurisdictionId(zoneId);
			}
			parent.location.replace(url);
		}
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
function getJurisdictionId(value){
    if(value.indexOf("|")!=-1)
    {
 		return value.substring(0, value.indexOf("|"));
	}
	else
	{
		return value;
	}
}

function selectZone(){
	parent.refreshButtons();
	var checked = parent.getChecked();
	if (checked.length > 0) {
		for (var i=0;i<checked.length;i++){
			if(getEditableFlag(checked[i])=="N"){
		    		disableButton(parent.buttons.buttonForm.changeButton);
		    		disableButton(parent.buttons.buttonForm.deleteButton);
				break;			
			}
		}
	
	}

}


function getResultsSize () {
	return <%= numberOfZones %>;
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
	String orderByParm = request.getParameter(ShippingConstants.PARAMETER_ORDER_BY);
	int startIndex = Integer.parseInt(request.getParameter(ShippingConstants.PARAMETER_START_INDEX));
	int listSize = Integer.parseInt(request.getParameter(ShippingConstants.PARAMETER_LIST_SIZE));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfZones;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel(ShippingConstants.NAME_SPACE + ShippingConstants.ZONE_LIST, totalpage, totalsize, fLocale) %>

<form name="zonesListForm">
<%= comm.startDlistTable((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();selectZone()") %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_ZONE_COLUMN), ShippingConstants.ORDER_BY_NAME, ShippingConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_REGION_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_STATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_CITY_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_ZIPCODE_START_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_ZONE_LIST_ZIPCODE_END_COLUMN), null, false) %>
	
	    
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfZones) {
		endIndex = numberOfZones;
	}

	JurisdictionDataBean zone;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
	
		zone = (JurisdictionDataBean)zones[i];
			
		
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (zone.getStoreEntityIdInEntityType().equals(fStoreId)) { %>
<%= comm.addDlistCheck(zone.getJurisdictionId() + "|Y", "parent.setChecked();selectZone()") %>
<%= comm.addDlistColumn(zone.getCode(), "javascript:changeZone("+ zone.getJurisdictionId()+ ")") %>
<%		} else { %>
<%= comm.addDlistCheck(zone.getJurisdictionId().toString() + "|N", "parent.setChecked();selectZone()") %>
<%= comm.addDlistColumn(zone.getCode(), "javascript:displayZone("+ zone.getJurisdictionId()+ ")") %>
<% } %>

<%= comm.addDlistColumn(zone.getCountry(), "none") %>
<%= comm.addDlistColumn(zone.getState(), "none") %>
<%= comm.addDlistColumn(zone.getCity(), "none") %>
<%= comm.addDlistColumn(zone.getZipcodeStart(), "none") %>
<%= comm.addDlistColumn(zone.getZipcodeEnd(), "none") %>
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
<%	if (numberOfZones == 0) { %>
<p/>
<p>
<%= shippingRB.get(ShippingConstants.MSG_ZONE_LIST_EMPTY) %>
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
