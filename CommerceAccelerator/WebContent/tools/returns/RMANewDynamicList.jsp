<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>	
<%@include file="../common/common.jsp" %>

<jsp:useBean id="list" scope="request" class="com.ibm.commerce.tools.common.ui.NewDynamicListBean"></jsp:useBean>

<%
    list.setRequest(request);  
    list.setParameters(request); 

    CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cc.getLocale();
%>

  <%= list.getUserJSfnc() %>
<SCRIPT SRC="/wcs/javascript/tools/common/newlist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/newbutton.js"></SCRIPT>

<script>
  var button_frame_loaded = false;
  var scroll_frame_loaded = false;

  <%= list.getJSvars() %>
  <%= list.getButtons() %>
  <%= list.getControlPanel() %>
</script>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"> 
<TITLE>List Title</TITLE>
</HEAD>

<%=
    list.getGeneralForm()
%>
<%=
    list.getFrameset()
%>
<%=
    list.setJSvars()
%>

<script>
  function visibleList(s)
  {
      if ( defined(this.scrollcontrol) && defined(this.scrollcontrol.document.all.viewname) ){
             scrollcontrol.document.all.viewname.style.visibility = s;
      }
      if ( defined(this.basefrm.visibleList) ){
             basefrm.visibleList(s);
      }
  }

function validatePanelData()
{
	if (defined(basefrm.validatePanelData)==true && basefrm.validatePanelData()==false) 
		return false;
	return true;
} 
function validateNoteBookPanel()
{
	if (defined(basefrm.validateNoteBookPanel)==true && basefrm.validateNoteBookPanel()==false) 
		return false;
	return true;
} 
function rmaFinishHandler(finishMessage)
{
	if (defined(basefrm.rmaFinishHandler)==true) 
		basefrm.rmaFinishHandler(finishMessage);
}
</script>
</HTML>
