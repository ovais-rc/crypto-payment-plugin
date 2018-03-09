<!--
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
-->
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@page import="com.ibm.commerce.tools.segmentation.SegmentUtil" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.Vector" %>

<%@include file="../common/common.jsp" %>

<%
response.setContentType("text/html;charset=UTF-8");
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);

Vector segmentsDeleted = new Vector();
Vector segmentsNotDeleted = new Vector();
boolean segmentIdInvalid = false;

String segmentsDeletedParameter = request.getParameter(SegmentConstants.PARAMETER_SEGMENTS_DELETED);
if (segmentsDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(segmentsDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    segmentsDeleted.addElement(st.nextToken());
   }
 }

String segmentsNotDeletedParameter = request.getParameter(SegmentConstants.PARAMETER_SEGMENTS_NOT_DELETED);
if (segmentsNotDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(segmentsNotDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    segmentsNotDeleted.addElement(st.nextToken());
   }
 }

String segmentIdInvalidParameter = request.getParameter(SegmentConstants.PARAMETER_SEGMENT_ID_INVALID);
if (segmentIdInvalidParameter != null)
 {
  segmentIdInvalid = SegmentUtil.toBoolean(segmentIdInvalidParameter);
 }

%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<%= fHeader%>
<TITLE><%=resources.get(SegmentConstants.MSG_SEGMENTS_DELETED_DIALOG_TITLE)%></TITLE>
<SCRIPT>

function segmentList()
 {
  if (top.goBack)
   {
    top.goBack();
   }
  else
   {
    parent.location.replace("<%=SegmentConstants.URL_SEGMENTS_VIEW%>");
   }
 }

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }

</SCRIPT>
</HEAD>

<BODY ONLOAD="loadPanelData()" class="content">

<BR>

<%
boolean noSegmentsDeleted = true;
if (segmentsDeleted != null && segmentsDeleted.size() > 0)
 {
  noSegmentsDeleted = false;
%>
<P><%=resources.get(SegmentConstants.MSG_SEGMENTS_DELETED)%>
<UL>
<%
  for (int i = 0; i < segmentsDeleted.size(); i++)
   {
%>
<LI><%=segmentsDeleted.elementAt(i)%></LI>
<%
   }
%>
</UL>
<%
 }
%>

<%
if (segmentsNotDeleted != null && segmentsNotDeleted.size() > 0)
 {
  noSegmentsDeleted = false;
%>
<P><%=resources.get(SegmentConstants.MSG_SEGMENTS_NOT_DELETED)%>
<UL>
<%
  for (int i = 0; i < segmentsNotDeleted.size(); i++)
   {
%>
<LI><%=segmentsNotDeleted.elementAt(i)%></LI>
<%
   }
%>
</UL>
<%
 }
%>

<%
if (segmentIdInvalid)
 {
  noSegmentsDeleted = false;
%>
<P><%=resources.get(SegmentConstants.MSG_DELETE_SEGMENT_ID_INVALID)%>
<%
 }
%>

<%
if (noSegmentsDeleted)
 {
%>
<P><%=resources.get(SegmentConstants.MSG_NO_SEGMENTS_DELETED)%>
<%
 }
%>

</BODY>

</HTML>
