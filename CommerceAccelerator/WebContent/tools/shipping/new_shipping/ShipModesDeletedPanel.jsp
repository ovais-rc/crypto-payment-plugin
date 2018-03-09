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

	Vector shipModesDeleted = new Vector();
	Vector shipModesNotDeleted = new Vector();
	boolean shipModeIdInvalid = false;

	String shipModesDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_SHIPMODES_DELETED);
	if (shipModesDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(shipModesDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		shipModesDeleted.addElement(st.nextToken());
   		}
 	}

	String shipModesNotDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_SHIPMODES_NOT_DELETED);
	if (shipModesNotDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(shipModesNotDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		shipModesNotDeleted.addElement(st.nextToken());
   		}
 	}

	String shipModeIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_SHIPMODE_ID_INVALID);
	if (shipModeIdInvalidParameter != null)
 	{
  		shipModeIdInvalid = ShippingUtil.toBoolean(shipModeIdInvalidParameter);
 	}

%>

<html>
<head>
<%= fHeader%>
<title><%=shippingRB.get(ShippingConstants.MSG_SHIPMODES_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function shipModesList(){
  
  	parent.location.replace("<%=ShippingConstants.URL_SHIPMODE_LIST_VIEW%>");
 
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
	boolean noShipModesDeleted = true;
	if (shipModesDeleted != null && shipModesDeleted.size() > 0)
 	{
  		noShipModesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_SHIPMODES_DELETED)%>
		</p><ul>
<%
  		for (int i = 0; i < shipModesDeleted.size(); i++)
   		{
%>
    		<li><%=shipModesDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
<%
 	}
%>
	
<%
	if (shipModesNotDeleted != null && shipModesNotDeleted.size() > 0)
 	{
  		noShipModesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_SHIPMODES_NOT_DELETED)%>
		</p><ul>
<%
  		for (int i = 0; i < shipModesNotDeleted.size(); i++)
   		{
%>
    		<li><%=shipModesNotDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
<%
 	}
%>
 	


<%
	if (shipModeIdInvalid)
 	{
  		noShipModesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_DELETE_SHIPMODE_ID_INVALID)%>
<%
 	}
	if (noShipModesDeleted)
 	{
%>
	</p><p><%=shippingRB.get(ShippingConstants.MSG_NO_SHIPMODES_DELETED)%>
<%
 	}
%>
	
</p></body>

</html>
