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

	Vector zonesDeleted = new Vector();
	Vector zonesNotDeleted = new Vector();
	boolean zoneIdInvalid = false;

	String zonesDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_ZONES_DELETED);
	if (zonesDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(zonesDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		zonesDeleted.addElement(st.nextToken());
   		}
 	}

	String zonesNotDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_ZONES_NOT_DELETED);
	if (zonesNotDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(zonesNotDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		zonesNotDeleted.addElement(st.nextToken());
   		}
 	}

	String zoneIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_ZONE_ID_INVALID);
	if (zoneIdInvalidParameter != null)
 	{
  		zoneIdInvalid = ShippingUtil.toBoolean(zoneIdInvalidParameter);
 	}

%>

<html>
<head>
<%= fHeader%>
<title><%=shippingRB.get(ShippingConstants.MSG_ZONES_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function zonesList(){
  
  	parent.location.replace("<%=ShippingConstants.URL_ZONE_LIST_VIEW%>");
 
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
	boolean noZonesDeleted = true;
	if (zonesDeleted != null && zonesDeleted.size() > 0)
 	{
  		noZonesDeleted = false;
%>
		<p><%=shippingRB.get(ShippingConstants.MSG_ZONES_DELETED)%></p>
		<ul>
<%
  		for (int i = 0; i < zonesDeleted.size(); i++)
   		{
%>
    		<li><%=zonesDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
<%
 	}
%>

<%
	if (zonesNotDeleted != null && zonesNotDeleted.size() > 0)
 	{
  		noZonesDeleted = false;
%>
		<p><%=shippingRB.get(ShippingConstants.MSG_ZONES_NOT_DELETED)%></p>
		<ul>
<%
  		for (int i = 0; i < zonesNotDeleted.size(); i++)
   		{
%>
    		<li><%=zonesNotDeleted.elementAt(i)%></li>
<%
   		}
%>
		</ul>
<%	
 	}
%>

<%
	if (zoneIdInvalid)
 	{
  		noZonesDeleted = false;
%>
		<p><%=shippingRB.get(ShippingConstants.MSG_DELETE_ZONE_ID_INVALID)%></p> 
<%
 	}
%> 
<%
	if (noZonesDeleted)
 	{
%>
		<p><%=shippingRB.get(ShippingConstants.MSG_NO_ZONES_DELETED)%></p> 
<%
 	}
%>
    </body>

</html>
