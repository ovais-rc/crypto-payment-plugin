<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.experimentation.ExperimentConstants" %>

<%@ include file="common.jsp" %>

<%
	Vector experimentStatusUpdated = null;
	Vector experimentStatusNotUpdated = null;
	Boolean experimentIdInvalid = null;

	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		experimentStatusUpdated = (Vector) requestProperties.get(ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_UPDATED, null);
		experimentStatusNotUpdated = (Vector) requestProperties.get(ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_NOT_UPDATED, null);
		experimentIdInvalid = (Boolean) requestProperties.get(ExperimentConstants.PARAMETER_EXPERIMENT_ID_INVALID, Boolean.FALSE);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= experimentRB.get("experimentStatusUpdateDialogTitle") %></title>

<script language="JavaScript">
<!-- hide script from old browsers
<%
	String url = null;
	if (experimentStatusNotUpdated.size() == 0 && !experimentIdInvalid.booleanValue()) {
		url = UIUtil.getWebappPath(request) + "NewDynamicListView?ActionXMLFile=experiment.ExperimentList&cmd=ExperimentListView&orderby=name";
	}
	else {
		url = UIUtil.getWebappPath(request) + "DialogView?XMLFile=experiment.ExperimentStatusUpdateDialog";
		if (experimentStatusUpdated.size() > 0) {
			url += "&" + ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_UPDATED + "=" + experimentStatusUpdated.elementAt(0);
			for (int i=1; i<experimentStatusUpdated.size(); i++) {
				url += ",";
				url += experimentStatusUpdated.elementAt(i);
			}
		}
		if (experimentStatusNotUpdated.size() > 0) {
			url += "&" + ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_NOT_UPDATED + "=" + experimentStatusNotUpdated.elementAt(0);
			for (int i=1; i<experimentStatusNotUpdated.size(); i++) {
				url += ",";
				url += experimentStatusNotUpdated.elementAt(i);
			}
		}
		url += "&" + ExperimentConstants.PARAMETER_EXPERIMENT_ID_INVALID + "=" + experimentIdInvalid;
	}
%>
window.location.replace("<%= url %>");
//-->
</script>
</head>

<body class="content">
</body>

</html>