<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%-- @ page session="false" --%>
<%-- @ page language="java" --%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%
	response.setContentType("text/html;charset=UTF-8");
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");

	// obtain the common segment resource bundle for NLS properties
	CommandContext segmentCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (segmentCommandContext == null) {
		System.out.println("commandContext is null");
		return;
	}

	Hashtable segmentsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, segmentCommandContext.getLocale());
	if (segmentsRB == null) {
		System.out.println("Segment resouces bundle is null");
	}

	String fHeader = "<META HTTP-EQUIV='Cache-Control' CONTENT='no-cache'>" + "<LINK rel='stylesheet' href='" + UIUtil.getCSSFile(segmentCommandContext.getLocale()) + "'>";
%>
