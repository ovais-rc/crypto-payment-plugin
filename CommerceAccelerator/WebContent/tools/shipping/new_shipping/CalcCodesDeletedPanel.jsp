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

	Vector calcCodesDeleted = new Vector();
	Vector calcCodesNotDeleted = new Vector();
	boolean calcCodeIdInvalid = false;

	String calcCodesDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODES_DELETED);
	if (calcCodesDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(calcCodesDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		calcCodesDeleted.addElement(st.nextToken());
   		}
 	}

	String calcCodesNotDeletedParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODES_NOT_DELETED);
	if (calcCodesNotDeletedParameter != null)
 	{
  		StringTokenizer st = new StringTokenizer(calcCodesNotDeletedParameter, ",");
  		while (st.hasMoreTokens())
   		{
    		calcCodesNotDeleted.addElement(st.nextToken());
   		}
 	}

	String calcCodeIdInvalidParameter = request.getParameter(ShippingConstants.PARAMETER_CALCCODE_ID_INVALID);
	if (calcCodeIdInvalidParameter != null)
 	{
  		calcCodeIdInvalid = ShippingUtil.toBoolean(calcCodeIdInvalidParameter);
 	}

%>

<html>
<head>
<%= fHeader%>
<title><%=shippingRB.get(ShippingConstants.MSG_CALCCODES_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function calcCodesList(){
  
  	parent.location.replace("<%=ShippingConstants.URL_CALCCODE_LIST_VIEW%>");
 
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
	boolean noCalcCodesDeleted = true;
	if (calcCodesDeleted != null && calcCodesDeleted.size() > 0)
 	{
  		noCalcCodesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_CALCCODES_DELETED)%>
	</p><ul>
<%
  		for (int i = 0; i < calcCodesDeleted.size(); i++)
   		{
%>
    <li><%=calcCodesDeleted.elementAt(i)%></li>
<%
   		}
%>
	</ul>
<%
 	}
%>

<%
	if (calcCodesNotDeleted != null && calcCodesNotDeleted.size() > 0)
 	{
  		noCalcCodesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_CALCCODES_NOT_DELETED)%>
	</p><ul>
<%
  		for (int i = 0; i < calcCodesNotDeleted.size(); i++)
   		{
%>
    <li><%=calcCodesNotDeleted.elementAt(i)%></li>
<%
   		}
%>
	</ul>
<%
 	}
%>

<%
	if (calcCodeIdInvalid)
 	{
  		noCalcCodesDeleted = false;
%>
	<p><%=shippingRB.get(ShippingConstants.MSG_DELETE_CALCCODE_ID_INVALID)%> <%
 	}
%> 
<%
	if (noCalcCodesDeleted)
 	{
%>
	</p><p><%=shippingRB.get(ShippingConstants.MSG_NO_CALCCODES_DELETED)%> <%
 	}
%>
</p></body>

</html>
