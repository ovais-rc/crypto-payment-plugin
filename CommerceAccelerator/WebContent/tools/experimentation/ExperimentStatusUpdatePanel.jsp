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
	import="com.ibm.commerce.experimentation.util.ExperimentUtil,
	com.ibm.commerce.tools.experimentation.ExperimentConstants" %>

<%@ include file="common.jsp" %>

<%
	Vector experimentStatusUpdated = new Vector();
	Vector experimentStatusNotUpdated = new Vector();
	boolean experimentIdInvalid = false;

	String experimentStatusUpdatedParameter = request.getParameter(ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_UPDATED);
	if (experimentStatusUpdatedParameter != null) {
		StringTokenizer st = new StringTokenizer(experimentStatusUpdatedParameter, ",");
		while (st.hasMoreTokens()) {
			experimentStatusUpdated.addElement(st.nextToken());
		}
	}

	String experimentStatusNotUpdatedParameter = request.getParameter(ExperimentConstants.PARAMETER_EXPERIMENT_STATUS_NOT_UPDATED);
	if (experimentStatusNotUpdatedParameter != null) {
		StringTokenizer st = new StringTokenizer(experimentStatusNotUpdatedParameter, ",");
		while (st.hasMoreTokens()) {
			experimentStatusNotUpdated.addElement(st.nextToken());
		}
	}

	String experimentIdInvalidParameter = request.getParameter(ExperimentConstants.PARAMETER_EXPERIMENT_ID_INVALID);
	if (experimentIdInvalidParameter != null) {
		experimentIdInvalid = ExperimentUtil.toBoolean(experimentIdInvalidParameter);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= experimentRB.get("experimentStatusUpdateDialogTitle") %></title>

<script language="JavaScript">
<!-- hide script from old browsers
function experimentList () {
	parent.location.replace("<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=experiment.ExperimentList&cmd=ExperimentListView&orderby=name");
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<br/>

<%
	boolean noExperimentStatusUpdated = true;
	if (experimentStatusUpdated != null && experimentStatusUpdated.size() > 0) {
		noExperimentStatusUpdated = false;
%>
<p><%= experimentRB.get("experimentStatusUpdated") %></p>
<ul>
<%		for (int i=0; i<experimentStatusUpdated.size(); i++) { %>
<li><%= experimentStatusUpdated.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (experimentStatusNotUpdated != null && experimentStatusNotUpdated.size() > 0) {
		noExperimentStatusUpdated = false;
%>
<p><%= experimentRB.get("experimentStatusNotUpdated") %></p>
<ul>
<%		for (int i=0; i<experimentStatusNotUpdated.size(); i++) { %>
<li><%= experimentStatusNotUpdated.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (experimentIdInvalid) {
		noExperimentStatusUpdated = false;
%>
<p><%= experimentRB.get("experimentIdInvalid") %></p>
<%	} %>

<%	if (noExperimentStatusUpdated) { %>
<p><%= experimentRB.get("noExperimentStatusUpdated") %></p>
<%	} %>

</body>

</html>