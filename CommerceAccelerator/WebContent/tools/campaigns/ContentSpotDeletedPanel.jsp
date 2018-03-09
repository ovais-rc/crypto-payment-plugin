<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.campaigns.CampaignUtil" %>

<%@ include file="common.jsp" %>

<%
	Vector emsDeleted = new Vector();
	Vector emsNotDeleted = new Vector();
	boolean emsIdInvalid = false;

	String emsDeletedParameter = request.getParameter("emsDeleted");
	if (emsDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(emsDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			emsDeleted.addElement(st.nextToken());
		}
	}

	String emsNotDeletedParameter = request.getParameter("emsNotDeleted");
	if (emsNotDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(emsNotDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			emsNotDeleted.addElement(st.nextToken());
		}
	}

	String emsIdInvalidParameter = request.getParameter("emsIdInvalid");
	if (emsIdInvalidParameter != null) {
		emsIdInvalid = CampaignUtil.toBoolean(emsIdInvalidParameter);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("contentSpotDeletedDialogTitle") %></title>
<script language="JavaScript">
function contentSpotList () {
	parent.location.replace("<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=campaigns.ContentSpotList&amp;cmd=ContentSpotListView");
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
</script>
</head>

<body onload="loadPanelData()" class="content">

<br/>
<%
	boolean noEmsDeleted = true;
	if (emsDeleted != null && emsDeleted.size() > 0) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get("contentSpotDeleted") %>
</p><ul>
<%		for (int i=0; i<emsDeleted.size(); i++) { %>
<li><%= emsDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (emsNotDeleted != null && emsNotDeleted.size() > 0) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get("contentSpotNotDeleted") %>
</p><ul>
<%		for (int i=0; i<emsNotDeleted.size(); i++) { %>
<li><%= emsNotDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (emsIdInvalid) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get("deleteContentSpotIdInvalid") %></p>
<%
	}
	if (noEmsDeleted) {
%>
<p><%= campaignsRB.get("noContentSpotDeleted") %></p>
<%	} %>

</body>

</html>