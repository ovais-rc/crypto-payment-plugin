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
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.Vector" %>

<%@include file="../common/common.jsp" %>

<%
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);

Vector segmentsDeleted = null;
Vector segmentsNotDeleted = null;
Boolean segmentIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  segmentsDeleted = (Vector) requestProperties.get(SegmentConstants.PARAMETER_SEGMENTS_DELETED, null);
  segmentsNotDeleted = (Vector) requestProperties.get(SegmentConstants.PARAMETER_SEGMENTS_NOT_DELETED, null);
  segmentIdInvalid = (Boolean) requestProperties.get(SegmentConstants.PARAMETER_SEGMENT_ID_INVALID, Boolean.FALSE);
 }
%>

<HTML>
<HEAD>
<%= fHeader%>
<SCRIPT>

<%
if (segmentsNotDeleted.size() == 0 && !segmentIdInvalid.booleanValue())
 {
%>

if (top.goBack)
 {
  top.goBack();
 }
else
 {
  window.location.replace("<%=SegmentConstants.URL_SEGMENTS_VIEW%>");
 }

<%
 }
else
 {
  String segmentsDeletedList = "";
  if (segmentsDeleted.size() > 0)
   {
    segmentsDeletedList = (String) segmentsDeleted.elementAt(0);
    for (int i = 1; i < segmentsDeleted.size(); i++)
     {
      segmentsDeletedList += "," + segmentsDeleted.elementAt(i);
     }
   }
  String segmentsNotDeletedList = "";
  if (segmentsNotDeleted.size() > 0)
   {
    segmentsNotDeletedList = (String) segmentsNotDeleted.elementAt(0);
    for (int i = 1; i < segmentsNotDeleted.size(); i++)
     {
      segmentsNotDeletedList += "," + segmentsNotDeleted.elementAt(i);
     }
   }
%>

var parameters = new Object();
parameters.<%=SegmentConstants.PARAMETER_XML_FILE%> = "segmentation.SegmentsDeletedDialog";
parameters.<%=SegmentConstants.PARAMETER_SEGMENTS_DELETED%> = "<%=segmentsDeletedList%>";
parameters.<%=SegmentConstants.PARAMETER_SEGMENTS_NOT_DELETED%> = "<%=segmentsNotDeletedList%>";
parameters.<%=SegmentConstants.PARAMETER_SEGMENT_ID_INVALID%> = "<%=segmentIdInvalid%>";

top.setContent("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENTS_DELETED_DIALOG_TITLE))%>",
               "<%=SegmentConstants.URL_SEGMENTS_DELETED_DIALOG_VIEW%>",
               false,
               parameters);

<%
 }
%>

</SCRIPT>
</HEAD>

<BODY class="content">

</BODY>

</HTML>
