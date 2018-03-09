<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>	
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="list" scope="request" class="com.ibm.commerce.tools.common.ui.NewDynamicListBean">
</jsp:useBean>

<%
    list.setRequest(request);  
    list.setParameters(request); 
    CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cc.getLocale();
	list.getUserJSfnc(); 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/newlist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/newbutton.js"></script>

<script type="text/javascript">
	var button_frame_loaded = false;
	var scroll_frame_loaded = false;
	<%= list.getJSvars() %>
	<%= list.getButtons() %>
	<%= list.getControlPanel() %>
</script>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" /> 
<title></title>

<script type="text/javascript">
function loadPanelData() {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
function savePanelData() {
	self.basefrm.savePanelData();
}
function validatePanelData(){
	self.basefrm.validatePanelData();
}
</script>

</head>

<%= list.getGeneralForm() %>
<%= list.getFrameset() %>
<%= list.setJSvars() %>

<script type="text/javascript">
function visibleList(s) {
	if ( defined(this.scrollcontrol) && defined(this.scrollcontrol.document.all.viewname) ){
		scrollcontrol.document.all.viewname.style.visibility = s;
	}
	if ( defined(this.basefrm.visibleList) ){
		basefrm.visibleList(s);
	}
}
</script>

</html>
