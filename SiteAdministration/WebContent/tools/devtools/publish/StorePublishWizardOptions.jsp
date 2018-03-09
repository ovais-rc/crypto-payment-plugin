<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../../common/common.jsp" %>
	
<%-- -------------------------------------------------------------------------
	Tools Framework Dynamic List Java code
--------------------------------------------------------------------------- --%>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.devtools.DevToolsConfiguration" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.StorePublishConfig" %>

<%@page import="java.util.Locale" %>

<%
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties serviceNLS = (ResourceBundleProperties)ResourceDirectory.lookup("publish.storePublishNLS", locale);		
	
	Enumeration e = request.getParameterNames();
	String pName;
	String pValue;
	while (e.hasMoreElements()){
		pName = (String) e.nextElement();
		pValue = (String) request.getParameter(pName);
		//System.out.println("XXXXXXXX --- Parameter: key: " + pName + "    value: " + pValue);
	}
	
	String sParamLen = "0";
	int paramLen = 0;
	sParamLen = request.getParameter("paramLength");
	if (sParamLen != null){
		//try{
			paramLen = Integer.parseInt(sParamLen);
	//	} catch (Exception e){
	//		System.out.println("Failed to convert the following value to an integer: " + sParamLen);		
	//	}
	}
	//System.out.println("The parameter length is " + paramLen);
%>

<html>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script src="/wcadmin/javascript/tools/common/dynamiclist.js"></script>
	<script src="/wcadmin/javascript/tools/common/Util.js"></script>
	<script src="/wcadmin/javascript/tools/devtools/publish/StorePublishWizard.js"></script>	

<script>

	
	function initializeState()
	{
		parent.setContentFrameLoaded(true);
	}
	
 	function validatePanelData(){
		//alert('parent.get(elTagValid):'+parent.get("elTagValid"));
		var flag=true;
		if(parent.get("elTagValid")== 'true'){
			flag=confirmDialog("<%= (String)serviceNLS.getJSProperty("_ERR_MIGRATE_GUI_EL_TAGS")%>");
		}
		return flag;
	}
</script>
<META name="GENERATOR" content="IBM WebSphere Studio">
</head>
<BODY ONLOAD="initializeState();" class=content>

<H1><%= serviceNLS.getProperty("StorePublishOptionsTitle") %></H1><BR>
<%=serviceNLS.getProperty("option.Instruction")%><BR><BR>
<!--%= serviceNLS.getProperty("param.storeArchive") %&nbsp;-->
<SCRIPT>
	var publishStatusTitle = "<%= serviceNLS.getProperty("statusListTitle")%>";
	var sarName= parent.get("storeArchiveFilename");
	document.writeln("<i>" + sarName + "</i>");
</SCRIPT>

<BR><BR><BR>
<%=serviceNLS.getProperty("option.Instruction2")%><BR>
<FORM NAME="options">
<table class="list" width="75%">

<TR class="list_roles">
<TH class="list_header" id="col1">
<nobr>&nbsp;&nbsp;&nbsp;<%= serviceNLS.getProperty("param.param") %>&nbsp;&nbsp;&nbsp;</nobr>
</TH>

<TH width="100%" class="list_header" id="col2">
<nobr>&nbsp;&nbsp;&nbsp;<%= serviceNLS.getProperty("param.value") %>&nbsp;&nbsp;&nbsp;</nobr>
</TH>
</TR>
<script>
parameterInfos = parent.get("paramInfos");
</script>
<%
int toggle = 2;
for (int i=0; i < paramLen; i++){
	toggle = (toggle == 1) ? 2 : 1;
%>
<TR class=list_row<%=toggle%>>
<TD class="list_info1"  id="row<%=i%>_1" headers="col1" >
<nobr>&nbsp;
<script>
document.writeln(parameterInfos[<%=i%>].displayName);
</script>
&nbsp;</nobr>
</TD>
<TD class="list_info2"  headers="col2" id="row<%=i%>_2">
&nbsp;
<SCRIPT>
	document.writeln(parameterInfos[<%=i%>].value);
</SCRIPT>
&nbsp;
</TD>
</TR>
<% } %>
</TABLE>
<BR><BR>
<!--%= serviceNLS.getProperty("option.Instruction") %-->
<!--BR><BR-->
<!--%= serviceNLS.getProperty("option.targetWebDocRoot") %--><BR>
<!--INPUT NAME="docRoot"  SIZE="95" id="input1"><BR><BR-->
<%
/* String storesDocRoot =
		DevToolsConfiguration.getConfigurationVariable("StoresDocRoot");
String storesWebPath =
		DevToolsConfiguration.getConfigurationVariable("StoresWebPath");
String unpackDestination =
		(new java.io.File(storesDocRoot, storesWebPath)).getPath();	
*/
String unpackDestination =StorePublishConfig.getInstance().getProperty(DevToolsConfiguration.STORES_WEB_PATH);

%>
<%= serviceNLS.getProperty("option.targetInfo") %><BR><BR>
<I><%=unpackDestination%></I>
<!--INPUT TYPE=CHECKBOX NAME="precomp" id="input2"-->
<!--%= serviceNLS.getProperty("option.checkbox") %--><BR>

</FORM>
</BODY>
</HTML>