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
<%@page import="com.ibm.commerce.tools.shipping.CalcRuleDetailsDataBean" %>
<%@page import="com.ibm.commerce.tools.shipping.ShippingUtil" %>
<%@page import="com.ibm.commerce.fulfillment.beans.CalculationCodeDataBean" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
	

<%@include file="ShippingCommon.jsp" %>
<%@include file="../../common/List.jsp" %>
<%

	CalcRuleListDataBean  calcRuleList;
	CalcRuleDetailsDataBean calcRules[] = null;
	int numberOfCalcRules = 0;
	calcRuleList = new CalcRuleListDataBean();
	DataBeanManager.activate(calcRuleList, request);
	calcRules = calcRuleList.getShipChargesList();
	if (calcRules != null) {
		numberOfCalcRules = calcRules.length;
	}
	
	String calcCodeId = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID);
	CalculationCodeDataBean calcCode = new CalculationCodeDataBean();
	calcCode.setDataBeanKeyCalculationCodeId(calcCodeId);

	DataBeanManager.activate(calcCode, request);
	boolean editable = true;
	if(!calcCode.getStoreEntityIdInEntityType().equals(fStoreId))
	{
		editable = false;
	}
	
%>

<html>

<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_LIST_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers

function newCalcRule () {

   var panelURL = "<%= ShippingConstants.URL_CALCRULE_WIZARD_VIEW + "&" + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + UIUtil.toJavaScript(calcCodeId) %>";
	if (top.setContent) {
		top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CREATE_CALCRULE)) %>", panelURL, true);
	}
	else {
		parent.location.replace(panelURL);
	}
}

function changeCalcRule() {
	var calcRuleId = -1;
	
	if (arguments.length > 0) {
		calcRuleId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcRuleId = checked[0];
		}
	}
	if (calcRuleId != -1) {
		   
	    var panelURL = "<%= ShippingConstants.URL_CALCRULE_WIZARD_VIEW + "&" + ShippingConstants.PARAMETER_CALCRULE_ID + "=" %>" + calcRuleId + "<%= "&" + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + UIUtil.toJavaScript(calcCodeId) %>" ;

		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_UPDATE_CALCRULE)) %>", panelURL, true);
		}
		else {
			parent.location.replace(panelURL);
		}
	}
}


function deleteCalcRules() {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_LIST_DELETE_CONFIRMATION)) %>")) {
			var calcRuleId = checked[0];
			var url = "<%= UIUtil.toJavaScript(ShippingConstants.URL_CALCRULE_DELETE + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + calcCodeId + "&" +  ShippingConstants.PARAMETER_CALCRULE_IDS + "=")%>" + + calcRuleId;
			for (var i=1; i<checked.length; i++) {
				calcRuleId = checked[i];
				url += "," + calcRuleId;
			}
			parent.location.replace(url);
		}
	}
}


function summary() {

	var calcRuleId = -1;
	var url = "<%= ShippingConstants.URL_CALCRULE_NOTEBOOK_VIEW %>" + calcRuleId;
	
	if (arguments.length > 0) {
		calcRuleId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcRuleId = checked[0];
		}
	}
	if (calcRuleId != -1) {
		var url = "<%= ShippingConstants.URL_CALCRULE_NOTEBOOK_VIEW %>" + calcRuleId + "&" + "<%=ShippingConstants.PARAMETER_IS_SUMMARY %>" + "=true";

		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_SUMMARY_TITLE)) %>", url, true);
		}
		else {
			parent.location.replace(url);
		}
	}
}

function displayCalcRule() {

	var calcRuleId = -1;
	
	if (arguments.length > 0) {
		calcRuleId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			calcRuleId = checked[0];
		}
	}
	if (calcRuleId != -1) {
		   
		   
	    var panelURL = "<%= ShippingConstants.URL_CALCRULE_DETAILS_WIZARD_VIEW + "&amp;" + ShippingConstants.PARAMETER_CALCRULE_ID + "=" %>" + calcRuleId + "<%= "&amp;" + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + UIUtil.toJavaScript(calcCodeId) %>" + "&amp;<%=ShippingConstants.PARAMETER_READONLY%>=true";

		if (top.setContent) {
			top.setContent("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_DETAILS_CALCRULE)) %>", panelURL, true);
		}
		else {
			parent.location.replace(panelURL);
		}
	}
}

function selectCalcRule()
{

	var value=-1;
	if (arguments.length > 0) {
		value = arguments[0];
	}
	parent.refreshButtons();

	if (value == "false"){
    	disableButton(parent.buttons.buttonForm.newButton);		 

    	var checked = parent.getChecked();
		if (checked.length > 0) {
		for (var i=0;i<checked.length;i++){
		
		    	disableButton(parent.buttons.buttonForm.changeButton);
		    	disableButton(parent.buttons.buttonForm.deleteButton);
				break;			
			}
		}
	
	}
	
}
function userInitialButtons(){
	var value = "<%=String.valueOf(editable)%>";
	selectCalcRule(value);
}

function getResultsSize () {
	return <%= numberOfCalcRules %>;
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
	int totalsize = numberOfCalcRules;
	int totalpage = totalsize/listSize;
%>

<p class="entry_text"><%= UIUtil.toHTML((String)shippingRB.get("nameColumn")) +": " + calcCode.getCode()%>


<%= comm.addControlPanel(ShippingConstants.NAME_SPACE + ShippingConstants.CALCRULE_LIST, totalpage, totalsize, fLocale) %>


<form name="CalcRulesByCalcCodeListForm">
<%= comm.startDlistTable((String)shippingRB.get(ShippingConstants.MSG_CALCRULE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();selectCalcRule('"+ String.valueOf(editable) +"')") %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPCHARGE_CODE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPCHARGE_DESCRIPTION_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_START_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_END_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPCHARGE_RANGE_METHOD_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)shippingRB.get(ShippingConstants.MSG_SHIPCHARGE_UNIT_COLUMN), null, false) %>


<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfCalcRules) {
		endIndex = numberOfCalcRules;
	}

	CalcRuleDetailsDataBean calcRule;
	
	int indexFrom = startIndex;
	for (int i=indexFrom; i < endIndex; i++) {
	
		
		calcRule = (CalcRuleDetailsDataBean)calcRules[i];
		String calcRuleId = calcRule.getId().toString();
		String type = "";
		if (calcRule.getRangeMethod().toString().equals("-33")) {
			type = (String)shippingRB.get(ShippingUtil.getMethodCode(calcRule.getRangeMethod()));
		} else {
			type = (String)shippingRB.get(ShippingUtil.getMethodCode(calcRule.getScaleLookupMethod()));
		}
		
		String unitOfMeasure = calcRule.getUnitOfMeasure();
		if (unitOfMeasure != null && unitOfMeasure.equals("C62"))  { unitOfMeasure = "";}
		String startDate = "";
		String endDate = "";
		if (calcRule.getStartDate() != null) { 
			if (TimestampHelper.getYearFromTimestamp(calcRule.getStartDate()).equals("1900")) {
				startDate = UIUtil.toJavaScript((String)shippingRB.get("ruleAlwaysInEffect"));
			} else {
				startDate = TimestampHelper.getDateTimeFromTimestamp(calcRule.getStartDate(), fLocale);
			}
		}
		
		if (calcRule.getEndDate() != null) {
			if (TimestampHelper.getYearFromTimestamp(calcRule.getEndDate()).equals("2100")) {
				endDate = UIUtil.toJavaScript((String)shippingRB.get("ruleAlwaysInEffect"));
			} else {
				endDate = TimestampHelper.getDateTimeFromTimestamp(calcRule.getEndDate(), fLocale);
			}
		}
		
%>

<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(calcRuleId, "parent.setChecked();selectCalcRule('"+ String.valueOf(editable) +"')") %>
<% if (editable){
%>
<%= comm.addDlistColumn(calcRule.getScaleCode().toString(), "javascript:changeCalcRule("+ calcRuleId +")") %>
<%  } else {
%>
<%= comm.addDlistColumn(calcRule.getScaleCode().toString(), "javascript:displayCalcRule("+ calcRuleId +")") %>
<%  }
%>
<%= comm.addDlistColumn(calcRule.getScaleDescription(), "none") %>
<%= comm.addDlistColumn(startDate, "none") %>
<%= comm.addDlistColumn(endDate, "none") %>
<%= comm.addDlistColumn(type, "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(unitOfMeasure), "none") %>


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
<%	if (numberOfCalcRules == 0) { %>
<p></p><p>
<%= shippingRB.get(ShippingConstants.MSG_CALCRULE_LIST_EMPTY) %>
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
