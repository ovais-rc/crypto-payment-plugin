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
	Vector experimentDeleted = new Vector();
	Vector experimentNotDeleted = new Vector();
	boolean experimentIdInvalid = false;

	String experimentDeletedParameter = request.getParameter(ExperimentConstants.PARAMETER_EXPERIMENT_DELETED);
	if (experimentDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(experimentDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			experimentDeleted.addElement(st.nextToken());
		}
	}

	String experimentNotDeletedParameter = request.getParameter(ExperimentConstants.PARAMETER_EXPERIMENT_NOT_DELETED);
	if (experimentNotDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(experimentNotDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			experimentNotDeleted.addElement(st.nextToken());
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
<title><%= experimentRB.get("experimentDeleteDialogTitle") %></title>

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
	boolean noExperimentDeleted = true;
	if (experimentDeleted != null && experimentDeleted.size() > 0) {
		noExperimentDeleted = false;
%>
<p><%= experimentRB.get("experimentDeleted") %></p>
<ul>
<%		for (int i=0; i<experimentDeleted.size(); i++) { %>
<li><%= experimentDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (experimentNotDeleted != null && experimentNotDeleted.size() > 0) {
		noExperimentDeleted = false;
%>
<p><%= experimentRB.get("experimentNotDeleted") %></p>
<ul>
<%		for (int i=0; i<experimentNotDeleted.size(); i++) { %>
<li><%= experimentNotDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (experimentIdInvalid) {
		noExperimentDeleted = false;
%>
<p><%= experimentRB.get("experimentIdInvalid") %></p>
<%	} %>

<%	if (noExperimentDeleted) { %>
<p><%= experimentRB.get("noExperimentDeleted") %></p>
<%	} %>

</body>

</html>