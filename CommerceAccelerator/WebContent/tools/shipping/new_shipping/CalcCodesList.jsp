
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
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.fulfillment.beans.CalculationCodeDataBean" %>
<%@page import="com.ibm.commerce.fulfillment.beans.CalculationCodeDescriptionDataBean" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
	

<%@ include file="ShippingCommon.jsp" %>

<%
	
	CalculationCodeListDataBean calcCodeList;
	CalculationCodeDataBean calcCodes[] = null;
	int numberOfCalcCodes = 0;
	calcCodeList = new CalculationCodeListDataBean();
	DataBeanManager.activate(calcCodeList, request);
	calcCodes = calcCodeList.getCalcCodeList();
	if (calcCodes != null) {
		numberOfCalcCodes = calcCodes.length;
	}

%>

<html>

<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCCODE_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

function newCalcCode () {
	var url = "<%= ShippingConstants.URL_CALCCODE_WIZARD_VIEW %>";
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_CALCCODE)) %>", url, true);
	}
	else {
		parent.location.replace(url);
	}
}

function changeCalcCode() {

	var calcCodeId = -1;
	
	if (arguments.length > 0) {
		calcCodeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcCodeId = getCalcCodeId(checked[0]);
		}
	}
	if (calcCodeId != -1) {
		var url = "<%= ShippingConstants.URL_CALCCODE_NOTEBOOK_VIEW + ShippingConstants.PARAMETER_CALCCODE_ID + "="%>" + calcCodeId;
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_UPDATE_CALCCODE)) %>", url, true);
		}
		else {
			parent.location.replace(url);
		}
	}
}

function displayCalcCode() {

	var calcCodeId = -1;
	
	if (arguments.length > 0) {
		calcCodeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcCodeId = getCalcCodeId(checked[0]);
		}
	}
	if (calcCodeId != -1) {
		var url = "<%= ShippingConstants.URL_CALCCODE_DETAILS_NOTEBOOK_VIEW + ShippingConstants.PARAMETER_CALCCODE_ID + "="%>" + calcCodeId +"&amp;<%=ShippingConstants.PARAMETER_READONLY%>=true";
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DETAILS_CALCCODE)) %>", url, true);
		}
		else {
			parent.location.replace(url);
		}
	}
}


function deleteCalcCodes() {

	var checked = parent.getChecked();
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_LIST_DELETE_CONFIRMATION)) %>")) {
			var calcCodeId = getCalcCodeId(checked[0]);
			var url = "<%= ShippingConstants.URL_CALCCODE_DELETE + ShippingConstants.PARAMETER_CALCCODE_IDS + "="%>" + calcCodeId;
			for (var i=1; i<checked.length; i++) {
				calcCodeId = getCalcCodeId(checked[i]);
				url += "," + calcCodeId;
			}
			parent.location.replace(url);
		}
	}
}

function disableCalcCode (statusValue) {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				var calcCodeId = getCalcCodeId(checked[0]);
				var url = "/webapp/wcs/tools/servlet/CalcCodeDisable";
				url += "?<%= ShippingConstants.PARAMETER_CALCCODE_IDS %>=" + calcCodeId;
				for (var i=1; i<checked.length; i++) {
					calcCodeId = getCalcCodeId(checked[i]);
					url += "," + calcCodeId;
				}
				url += "&amp;<%= ShippingConstants.PARAMETER_CALCCODE_STATUS %>=" + statusValue;
				parent.location.replace(url);
			}
		}

function resumeCalcCode () {
			disableCalcCode("");
		}

function suspendCalcCode () {
			disableCalcCode("<%= ShippingConstants.CALCCODE_STATUS_DISABLED %>");
		}


function defineCalcRules() {

	var calcCodeId = -1;
	
	if (arguments.length > 0) {
		calcCodeId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcCodeId = getCalcCodeId(checked[0]);
		}
	}
	if (calcCodeId != -1) {
	     var url = "<%= ShippingConstants.URL_CALCCODE_CALCRULES_LIST_VIEW  + "&" + ShippingConstants.PARAMETER_CALCCODE_ID + "="%>" + calcCodeId;
	
		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_CALCRULES_LIST_TITLE)) %>", url, true);
		}
		else {
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

function getCalcCodeId(value)
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

function selectCalcCode()
{
	parent.refreshButtons();

	var checked = parent.getChecked();
	if (checked.length > 0) {
		for (var i=0;i<checked.length;i++){
			if(getEditableFlag(checked[i])=="N"){
		    	disableButton(parent.buttons.buttonForm.changeButton);
		    	disableButton(parent.buttons.buttonForm.deleteButton);
		    	disableButton(parent.buttons.buttonForm.resumeButton);		    	
		    	disableButton(parent.buttons.buttonForm.suspendButton);		    			    	
				break;			
			}
		}
	
	}

}

function getResultsSize () {
	return <%= numberOfCalcCodes %>;
}

function onLoad () {
	var calrule = top.get("createCalRule", false);
	if (calrule == true) {
		alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get("createCalRules")) %>");
		top.remove("createCalRule");
	}
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
	int totalsize = numberOfCalcCodes;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel(ShippingConstants.NAME_SPACE + ShippingConstants.CALCCODE_LIST, totalpage, totalsize, fLocale) %>

<form name="CalcCodesListForm">
<%= comm.startDlistTable((String)shippingRB.get(ShippingConstants.MSG_CALCCODE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();selectCalcCode()") %>
<%= comm.addDlistColumnHeading((String)shippingRB.get("calcCodeListNameColumn"), ShippingConstants.ORDER_BY_NAME, ShippingConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_LIST_DESCRIPTION_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_LIST_STATUS_COLUMN), null, false) %>

<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfCalcCodes) {
		endIndex = numberOfCalcCodes;
	}

	CalculationCodeDataBean calcCode;
	CalculationCodeDescriptionDataBean calcCodeDescription;
	int indexFrom = startIndex;
	for (int i=indexFrom; i < endIndex; i++) {
	
		calcCode = (CalculationCodeDataBean)calcCodes[i];
		String calcCodeId = calcCode.getDataBeanKeyCalculationCodeId();
			
		calcCodeDescription = new CalculationCodeDescriptionDataBean();
		calcCodeDescription.setDataBeanKeyCalculationCodeId(calcCodeId);
		calcCodeDescription.setDataBeanKeyLanguageId(fLanguageId);
		String description = "";
		try{
			DataBeanManager.activate(calcCodeDescription, request);
			description = UIUtil.toHTML(calcCodeDescription.getDescription());
		}
		catch(Exception e){
			//use the calcode.description instead.
			description = UIUtil.toHTML(calcCode.getDescription());
		}
		
		String pub = calcCode.getPublished();
		String status = "";
		if (pub.equals("0")) {
			status = UIUtil.toHTML((String)shippingRB.get("notPublished"));
		} else if (pub.equals("1")) {
			status = UIUtil.toHTML((String)shippingRB.get("published"));
		} else if (pub.equals("2")) {
			status = UIUtil.toHTML((String)shippingRB.get("markForDeletion"));
		}
		
%>
<%= comm.startDlistRow(rowselect) %>
<%	if (calcCode.getStoreEntityIdInEntityType().equals(fStoreId)) { %>
<%= comm.addDlistCheck(calcCode.getCalculationCodeId() + "|Y", "parent.setChecked();selectCalcCode()") %>
<%= comm.addDlistColumn(calcCode.getCode(), "javascript:changeCalcCode(" + calcCode.getCalculationCodeIdInEntityType() + ")") %>
<%	} else { %>
<%= comm.addDlistCheck(calcCode.getCalculationCodeId() + "|N", "parent.setChecked();selectCalcCode()") %>
<%= comm.addDlistColumn(calcCode.getCode(), "javascript:displayCalcCode(" + calcCode.getCalculationCodeIdInEntityType() + ")") %>
<%  } %>

<%= comm.addDlistColumn(description, "none") %>
<%= comm.addDlistColumn(status, "none") %>
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
<%	if (numberOfCalcCodes == 0) { %>
<p></p><p>
<%= shippingRB.get(ShippingConstants.MSG_CALCCODE_LIST_EMPTY) %>
<%	} %>
</p></form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());

//-->
</script>

</body>

</html>