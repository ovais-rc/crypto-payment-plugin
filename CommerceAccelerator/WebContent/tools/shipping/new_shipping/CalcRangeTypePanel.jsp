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
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>

<%@ include file="ShippingCommon.jsp" %>
<% 
String calcRuleId = request.getParameter(ShippingConstants.PARAMETER_CALCRULE_ID);
boolean foundCalcRuleId = (calcRuleId != null && calcRuleId.length() > 0);
String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
String disabledString = " disabled";
if(editable){
	disabledString = "";
}

System.out.println("foundCalcRuleId = " + foundCalcRuleId);
%>
<html>
<head>
<%= fHeader %>
<style type='text/css'>
.selectWidth {width: 200px;}
.selectWidenWidth {width: 300px;}
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCRANGE_TYPE_TITLE) %></title>
<script language="JavaScript">
<!---- hide script from old browsers

var debug = false;
var incomingFixedType;
var incomingPerUnitType;
var incomingWeightType;
var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
var method = o.<%= ShippingConstants.ELEMENT_RANGE_METHOD %>;
var scale = o.<%= ShippingConstants.ELEMENT_SCALE_LOOKUP_METHOD %>;
if (o != null) {
	if ( debug == true ) alert("calcRuleDetailsBean not null");
	var shjrules = o.<%= ShippingConstants.ELEMENT_SHPJRULES %>;
    if ( debug == true ) alert("shjrules.length= " + shjrules.length);
				 
}



function initializeState()
{
////////////////////////////////////////////////////////////////////
// as this page is a nexus, use the last type chosen to determine
// what 'visited' flags to clear if we switch branches
////////////////////////////////////////////////////////////////////

	if (method == '<%=ShippingConstants.CALRANGE_CALMETHOD_ID_FIXED%>') 
		document.typeForm.typeRadio[2].checked = true;
	else if (method == '<%=ShippingConstants.CALRANGE_CALMETHOD_ID_PER_UNIT%>') {
		if (scale == '<%=ShippingConstants.CALSCALE_CALMETHOD_ID_QUANTITY%>') 
			document.typeForm.typeRadio[0].checked = true;
		if (scale == '<%=ShippingConstants.CALSCALE_CALMETHOD_ID_WEIGHT%>') 
			document.typeForm.typeRadio[1].checked = true;
			
	}
	
	parent.setContentFrameLoaded(true);

}


function validatePanelData()
{
// nothing to validate

}


function savePanelData()
{
	var i = 0;
	var outgoingFixedType = false;
	var outgoingPerUnitType = false;
	var outgoingWeightType = false;
	while (!document.typeForm.typeRadio[i].checked)
	{
		i++;
	}


	switch(eval(i))
	{

		case 0: // Per Unit charge (amount per unit)
			parent.setNextBranch("calcRulePerUnitChargePanel");
			outgoingPerUnitType = true;
			parent.put("fixedType", false);
		    parent.put("perUnitType", true);
		    parent.put("weightType", false);
			break;
			

		case 1: // Percentage (percentage per order)
			parent.setNextBranch("calcRuleWeightChargePanel");
			outgoingWeightType = true
			parent.put("fixedType", false);
		    parent.put("perUnitType", false);
		    parent.put("weightType", true);
			break;

		case 2: // Fixed charge (amount per order)
			parent.setNextBranch("calcRuleFixedChargePanel");
			outgoingFixedType = true;
			parent.put("fixedType", true);
		    parent.put("perUnitType", false);
		    parent.put("weightType", false);
			break;

	}

	//////////////////////////////////////////////////////////////
	// if user is changing types ... set the visited flags
	// to false to avoid reading incorrect data
	//////////////////////////////////////////////////////////////


	var visitedWizTypeBefore = parent.get("visitedWizType", false);

	if (visitedWizTypeBefore)
	{

		if ((incomingFixedType != outgoingFixedType) || 
			(incomingPerUnitType != outgoingPerUnitType) ||
			(incomingWeightType != outgoingWeightType))
		{
				parent.put("visitedFixedTypePanel", false);
				parent.put("visitedPerUnitTypePanel", false);
				parent.put("visitedWeightTypePanel", false);
		}
	}

	parent.put("visitedWizType", true);
    return true;
}



//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>
<body class="content" onload="initializeState();">

<h1><%=shippingRB.get(ShippingConstants.MSG_CALCRANGE_TYPE_PROMPT)%></h1>

<LINE3><%= shippingRB.get("calcRangeTypeDesc") %></LINE3>

<form name="typeForm">

<p>
<LABEL for="typeRadio"><input name="typeRadio" id="typeRadio" type="radio" <%=disabledString%>></LABEL>

<%=shippingRB.get("calcRangeTypePerUnitPrompt")%></p>
<p>
<LABEL for="typeRadio"><input name="typeRadio" id="typeRadio" type="radio" <%=disabledString%>></LABEL>

<%=shippingRB.get("calcScaleTypeWeight")%></p>
<p>
<LABEL id="typeRadio"><input name="typeRadio" id="typeRadio" type="radio" checked <%=disabledString%>></LABEL>
<%=shippingRB.get(ShippingConstants.MSG_CALCRANGE_TYPE_FIXED_PROMPT)%></p>

</form>
</body>
</html>


