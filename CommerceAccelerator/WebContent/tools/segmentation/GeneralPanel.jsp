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
<%@page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Locale" %>

<%
response.setContentType("text/html;charset=UTF-8");
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);
%>

<HTML>

<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= resources.get(SegmentConstants.MSG_GENERAL_PANEL_TITLE) %></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/segmentation/SegmentNotebook.js"></SCRIPT>
<SCRIPT>
function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
  if (parent.get)
   {
    var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
    if (o != null)
     {
      if (document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>)
       {
        loadValue(document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>, o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>);
       }
      loadValue(document.generalForm.<%=SegmentConstants.ELEMENT_DESCRIPTION%>, o.<%=SegmentConstants.ELEMENT_DESCRIPTION%>);
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_NAME_REQUIRED%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_NAME_REQUIRED%>");
      alertDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENT_NAME_REQUIRED))%>");
      document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.focus();
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_NAME_TOO_LONG%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_NAME_TOO_LONG%>");
      alertDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG))%>");
      document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.select();
      document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.focus();
      return;
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DESCRIPTION_TOO_LONG%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_DESCRIPTION_TOO_LONG%>");
      alertDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENT_STRING_TOO_LONG))%>");
      document.generalForm.<%=SegmentConstants.ELEMENT_DESCRIPTION%>.select();
      document.generalForm.<%=SegmentConstants.ELEMENT_DESCRIPTION%>.focus();
      return;
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_EXISTS%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_EXISTS%>");
      if (confirmDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENT_EXISTS))%>"))
       {
        parent.put("<%=SegmentConstants.ELEMENT_FORCE_SAVE%>", true);
        parent.finish();
        parent.remove("<%=SegmentConstants.ELEMENT_FORCE_SAVE%>");
       }
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_CHANGED%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_CHANGED%>");
      if (confirmDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_SEGMENT_CHANGED))%>"))
       {
        parent.put("<%=SegmentConstants.ELEMENT_FORCE_SAVE%>", true);
        parent.finish();
        parent.remove("<%=SegmentConstants.ELEMENT_FORCE_SAVE%>");
       }
     }

    if (parent.get("<%=SegmentConstants.ELEMENT_NAME_NOT_AVAILABLE%>", false))
     {
      parent.remove("<%=SegmentConstants.ELEMENT_NAME_NOT_AVAILABLE%>");
      alertDialog("<%=UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_NAME_NOT_AVAILABLE))%>");
     }
   }
  if (document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>)
   {
    document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.focus();
   }
  else
   {
    document.generalForm.<%=SegmentConstants.ELEMENT_DESCRIPTION%>.focus();
   }
 }

function savePanelData()
 {
  if (parent.get)
   {
    var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
    if (o != null)
     {
      if (document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>)
       {
        o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%> = document.generalForm.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>.value;
       }
      o.<%=SegmentConstants.ELEMENT_DESCRIPTION%> = document.generalForm.<%=SegmentConstants.ELEMENT_DESCRIPTION%>.value;
     }

     if(o.id!= "")
     {
     	parent.pageArray["segmentNotebookCustomersInclusionChangePanel"].url = parent.pageArray["segmentNotebookCustomersInclusionChangePanel"].url+ "&"+"<%=SegmentConstants.PARAMETER_SEGMENT_ID%>"+"="+o.id;
     	parent.pageArray["segmentNotebookCustomersExclusionChangePanel"].url = parent.pageArray["segmentNotebookCustomersExclusionChangePanel"].url+ "&"+"<%=SegmentConstants.PARAMETER_SEGMENT_ID%>"+"="+o.id;
     }
   }
 }
</SCRIPT>
</HEAD>

<BODY ONLOAD="loadPanelData()" class="content">

<H1><%= resources.get(SegmentConstants.MSG_GENERAL_PANEL_TITLE) %></H1>

<%= resources.get(SegmentConstants.MSG_SEGMENT_NOTEBOOK_INSTRUCTION) %>

<FORM NAME="generalForm" ACTION="javascript:">

<SCRIPT>
var newSegment = true;
var o = null;
if (parent.get)
 {
  o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
  if (o != null && o.<%=SegmentConstants.ELEMENT_ID%> != "")
   {
    newSegment = false;
   }
 }
if (newSegment)
 {
  document.writeln('<P><%= UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_NAME_PROMPT)) %><BR>');
  document.writeln('<INPUT NAME="<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>" TYPE="TEXT" MAXLENGTH="254">');
 }
else
 {
  document.writeln('<%= UIUtil.toJavaScript((String) resources.get(SegmentConstants.MSG_NAME_LABEL)) %>&nbsp;');
  document.writeln(o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>);
 }
</SCRIPT>

<P><label for="<%=SegmentConstants.ELEMENT_DESCRIPTION%>"><%= resources.get(SegmentConstants.MSG_DESCRIPTION_PROMPT) %></label><BR>
<textarea name="<%=SegmentConstants.ELEMENT_DESCRIPTION%>" id="<%=SegmentConstants.ELEMENT_DESCRIPTION%>" rows="6" cols="50" wrap>
</textarea>

</FORM>

</BODY>

</HTML>
