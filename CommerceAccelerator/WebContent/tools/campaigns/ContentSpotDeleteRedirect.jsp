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
	import="com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="common.jsp" %>

<%
	Vector emsDeleted = null;
	Vector emsNotDeleted = null;
	Boolean emsIdInvalid = null;

	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		emsDeleted = (Vector) requestProperties.get("emsDeleted", null);
		emsNotDeleted = (Vector) requestProperties.get("emsNotDeleted", null);
		emsIdInvalid = (Boolean) requestProperties.get("emsIdInvalid", Boolean.FALSE);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<script language="JavaScript">
<%
	String url = null;
	if (emsNotDeleted.size() == 0 && !emsIdInvalid.booleanValue()) {
		url = UIUtil.getWebappPath(request) + "NewDynamicListView?ActionXMLFile=campaigns.ContentSpotList&amp;cmd=ContentSpotListView";
	}
	else {
		url = UIUtil.getWebappPath(request) + "DialogView?XMLFile=campaigns.ContentSpotDeletedDialog";
		if (emsDeleted.size() > 0) {
			url += "&emsDeleted=" + emsDeleted.elementAt(0);
			for (int i=1; i<emsDeleted.size(); i++) {
				url += ",";
				url += emsDeleted.elementAt(i);
			}
		}
		if (emsNotDeleted.size() > 0) {
			url += "&emsNotDeleted=" + emsNotDeleted.elementAt(0);
			for (int i=1; i<emsNotDeleted.size(); i++) {
				url += ",";
				url += emsNotDeleted.elementAt(i);
			}
		}
		url += "&emsIdInvalid=" + emsIdInvalid;
	}
%>
window.location.replace("<%= url %>");
</script>
</head>

<body class="content">

</body>

</html>