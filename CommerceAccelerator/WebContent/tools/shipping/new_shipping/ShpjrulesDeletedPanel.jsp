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

	Vector shpjrulesDeleted = new Vector();
	Vector shpjrulesNotDeleted = new Vector();
	boolean shpjruleIdInvalid = false;

	String shpjrulesDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_SHPJRULES_DELETED);
	if (shpjrulesDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(shpjrulesDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		shpjrulesDeleted.addElement(st.nextToken());
   		}
 	}

	String shpjrulesNotDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_SHPJRULES_NOT_DELETED);
	if (shpjrulesNotDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(shpjrulesNotDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		shpjrulesNotDeleted.addElement(st.nextToken());
   		}
 	}

	String shpjruleIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_SHPJRULE_ID_INVALID);
	if (shpjruleIdInvalidParameter != null)
 	{
  		shpjruleIdInvalid = ShippingUtil.toBoolean(shpjruleIdInvalidParameter);
 	}

%>

<html>
<head>
<%= fHeader%>
<title><%=shippingRB.get(ShippingConstants.MSG_SHPJRULES_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function shpjruleList(){
  
  	parent.location.replace("<%=ShippingConstants.URL_SHPJRULES_VIEW%>");
 
}

function loadPanelData(){
 
  if (parent.setContentFrameLoaded){
    
    	parent.setContentFrameLoaded(true);
  }
}

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<br>

<%
	boolean noShpjrulesDeleted = true;
	if (shpjrulesDeleted != null && shpjrulesDeleted.size() > 0)
 	{
  		noShpjrulesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_SHPJRULES_DELETED)%>
		<ul>
<%
  		for (int i = 0; i < shpjrulesDeleted.size(); i++)
   		{
%>
    		<li><%=shpjrulesDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
	</p>
<%
 	}
%>
	
<%
	if (shpjrulesNotDeleted != null && shpjrulesNotDeleted.size() > 0)
 	{
  		noShpjrulesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_SHPJRULES_NOT_DELETED)%>
		<ul>
<%
  		for (int i = 0; i < shpjrulesNotDeleted.size(); i++)
   		{
%>
    		<li><%=shpjrulesNotDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
	</p>
<%
 	}
%>
 	


<%
	if (shpjruleIdInvalid)
 	{
  		noShpjrulesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_DELETE_SHPJRULE_ID_INVALID)%></p>
<%
 	}
	if (noShpjrulesDeleted)
 	{
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_NO_SHPJRULES_DELETED)%></p>
<%
 	}
%>
	
</body>

</html>
