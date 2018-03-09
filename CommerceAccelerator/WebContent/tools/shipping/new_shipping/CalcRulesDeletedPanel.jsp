<!-- ========================================================================
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
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="java.util.*" %>


<%@include file="ShippingCommon.jsp" %>

<%

	Vector calcRulesDeleted = new Vector();
	Vector calcRulesNotDeleted = new Vector();
	boolean calcRuleIdInvalid = false;
	String calcCodeId = (String) request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID);

	String calcRulesDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_CALCRULES_DELETED);
	if (calcRulesDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(calcRulesDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		calcRulesDeleted.addElement(st.nextToken());
   		}
 	}

	String calcRulesNotDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_CALCRULES_NOT_DELETED);
	if (calcRulesNotDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(calcRulesNotDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		calcRulesNotDeleted.addElement(st.nextToken());
   		}
 	}

	String calcRuleIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_CALCRULE_ID_INVALID);
	if (calcRuleIdInvalidParameter != null)
 	{
  		calcRuleIdInvalid = ShippingUtil.toBoolean(calcRuleIdInvalidParameter);
 	}

%>

<html>
<head>
<%= fHeader%>
<title><%=shippingRB.get(ShippingConstants.MSG_CALCRULES_DELETED_DIALOG_TITLE)%></title>
<script
language="JavaScript">

function calcRuleList(){

	var url = "<%= UIUtil.toJavaScript(ShippingConstants.URL_CALCCODE_CALCRULES_LIST_VIEW  + "&" + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + calcCodeId) %>";
  
  	parent.location.replace(url);
 
}

function loadPanelData(){
 
  if (parent.setContentFrameLoaded){
    
    	parent.setContentFrameLoaded(true);
  }
}

</script>
<meta
name="GENERATOR"
content="IBM WebSphere Studio">
</head>

<body
onload="loadPanelData()"
class="content">

<br>

<%
	boolean noCalcRulesDeleted = true;
	if (calcRulesDeleted != null && calcRulesDeleted.size() > 0)
 	{
  		noCalcRulesDeleted = false;
%>
<p><%=shippingRB.get(ShippingConstants.MSG_CALCRULES_DELETED)%>
</p>
<ul>
	<%
  		for (int i = 0; i < calcRulesDeleted.size(); i++)
   		{
%>
	<li><%=calcRulesDeleted.elementAt(i)%></li>
	<%
   		}
%>
</ul>
<%
 	}
%>

<%
	if (calcRulesNotDeleted != null && calcRulesNotDeleted.size() > 0)
 	{
  		noCalcRulesDeleted = false;
%>
<p><%=shippingRB.get(ShippingConstants.MSG_CALCRULES_NOT_DELETED)%>
</p>
<ul>
	<%
  		for (int i = 0; i < calcRulesNotDeleted.size(); i++)
   		{
%>
	<li><%=calcRulesNotDeleted.elementAt(i)%></li>
	<%
   		}
%>
</ul>
<%
 	}
%>

<%
	if (calcRuleIdInvalid)
 	{
  		noCalcRulesDeleted = false;
%>
<p><%=shippingRB.get(ShippingConstants.MSG_DELETE_CALCRULE_ID_INVALID)%>
<%
 	}
%> <%
	if (noCalcRulesDeleted)
 	{
%></p>
<p><%=shippingRB.get(ShippingConstants.MSG_NO_CALCRULES_DELETED)%>
<%
 	}
%></p>
</body>

</html>
