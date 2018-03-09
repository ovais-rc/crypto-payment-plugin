<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- 
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<%@include file="../../common/common.jsp" %>
	
<%-- -------------------------------------------------------------------------
	Tools Framework Dynamic List Java code
--------------------------------------------------------------------------- --%>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.devtools.databeans.SARBean" %>
<%@page import="com.ibm.commerce.tools.devtools.sar.registry.SarRegistry" %>
<%@page import="com.ibm.commerce.tools.devtools.sar.registry.SampleSar" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishParametersDataBean" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.StorePublishConfig" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.List" %>
<%@page import="java.io.File" %>

<%
	// load the resource bundle
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties serviceNLS = (ResourceBundleProperties) ResourceDirectory.lookup("publish.storePublishNLS", locale);		
	int defaultListSize = 10;
%> 

<html>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script src="/wcadmin/javascript/tools/common/dynamiclist.js"></script>
	<script src="/wcadmin/javascript/tools/common/Util.js"></script>
	<% //System.out.println(request.getParameter("view")); %>
	<jsp:useBean class="com.ibm.commerce.tools.devtools.publish.databeans.StoreArchiveListDataBean" id="SARBean">
	<jsp:setProperty name="SARBean" property="viewName" param="view" />
	<% com.ibm.commerce.beans.DataBeanManager.activate(SARBean, request); %>
	</jsp:useBean>

	<% 
		// get the size of the table, and pass it to the Tools Framework Dynamic List code
		int listLength = 0;
		int listSize = 0;

		List sarlist = SARBean.getStoreArchiveList();
		if(!SARBean.getInstanceFileExist()) {
	%>
		<script>
			alertDialog("<%= (String)serviceNLS.getJSProperty("alertDevToolsConfigDisabled")%>");
		</script>
	<%
		}else {
			
			listLength = sarlist.size();
			listSize = defaultListSize;
			if (request.getParameter("listsize") != null) {
				listSize = Integer.parseInt(request.getParameter("listsize"));
			}
		}
	%>

<script> 
	parent.validatePanelData = function()
	{
		if (typeof(parent.getFirstRowChecked) == "undefined"){
			alertDialog("<%= (String)serviceNLS.getJSProperty("details.JSFileMissing")%>");
			return false;
		}
		if (parent.getFirstRowChecked() == null){
			alertDialog("<%= (String)serviceNLS.getJSProperty("alertNoSarSelected")%>");
			return false;
		}
		return true;

	}

	function onLoad()
	{
		top.writeBannerTitle(top.banner_title);
		parent.loadFrames();
		parent.setResultssize(<%= listLength %>);
		parent.set_t_item_page(<%= listLength %>, <%= listSize %>); 
		parent.afterLoads();
		parent.setButtonPos('0px',(document.all.list.offsetTop - 7) + 'px');
		
		if (typeof(parent.initListSelected) != "undefined"){
			parent.initListSelected();
		}
		//parent.initListSelected();
		//parent.setContentFrameLoaded(true);
		
	}

	<%
		StringBuffer buf = new StringBuffer();
		buf.append("var sample = new Array();");
		buf.append("\n");

		SampleSar[] sampleSars = SarRegistry.createRegistry().getSampleSar();

		for (int i = 0; i < sampleSars.length; i++)
		{
			String sampleSite = UIUtil.toJavaScript(sampleSars[i].getSampleSite(locale));
			String sampleFilename = UIUtil.toJavaScript(sampleSars[i].getFile().getPath());
			buf.append("sample['" + sampleFilename + "']='" + sampleSite + "';\n");
		}		
		out.println(buf.toString());
	%>
		
	function previewAction()
	{
		var storeArchive = new String (parent.getChecked());
		storeArchive = storeArchive.slice(storeArchive.indexOf("_") + 1);
		//alertDialog(storeArchive);
		//alertDialog(getCheckedValue());
		
		var url = sample[getCheckedValue()];
		//alertDialog(url);
		if (url != null && url != '')
		{
			url = top.getWebPrefix() + "/tools/devtools/preview/" + url;
			window.open(url, '', 'location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=no,top=50,left=50').focus();
		}
		else
		{
			alertDialog("<%= (String)serviceNLS.getJSProperty("alertPreviewUnavailable")%>");
		}
	}

	function check(currentRow)
	{
		for (var i = 0; i < document.archiveForm.length; i++)
		{
			if (document.archiveForm.elements[i] == currentRow)
				document.archiveForm.elements[i].checked = true;
			else
				document.archiveForm.elements[i].checked = false;
		}
	}
	
	function getCheckedValue()
	{
		for (var i = 0; i < document.archiveForm.length; i++)
		{
			if (document.archiveForm.elements[i].checked == true)
				return document.archiveForm.elements[i].value;
		}
	}
	
	function openMultiOrgHelp()
	{
		var helpfile= top.help['AC.storePublish.WizardMultiOrg.Help'];
		window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes, copyhistory=no");
	}
	
</script>

<body class="content_list" onLoad="onLoad();">

<%= serviceNLS.getProperty("publishInstr1") %><br>
<br>
<%
String edition = StorePublishConfig.getInstance().getProperty("wc.product.edition", "");
if ((edition != null) && (edition.toLowerCase().indexOf("pro") == -1) && (edition.toLowerCase().indexOf("express") == -1)){
%>
<%= serviceNLS.getProperty("publishInstr3") %><br>
<%
}
%>

<%
	int startIndex = 0;
	if (request.getParameter("startindex") != null) {
		startIndex = Integer.parseInt(request.getParameter("startindex"));
	}
	
	int endIndex = startIndex + listSize;
	if (endIndex > listLength) {
		endIndex = listLength;
	}
%>

<form id="list" name="archiveForm">

	<%-- -------------------------------------------------------------------------
		Tools Framework Dynamic List
	--------------------------------------------------------------------------- --%>
	<%= comm.startDlistTable((String)serviceNLS.getProperty("filename")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistColumnHeading("", null, false) %>
	<%= comm.addDlistColumnHeading((String)serviceNLS.getProperty("archive.storeArchive"), null, false, "30%" ) %>
	<%= comm.addDlistColumnHeading((String)serviceNLS.getProperty("archive.Desc"), null, false, "70%" ) %>
	<%= comm.endDlistRowHeading() %>
	

	<%
		int rowSelect = 1;
		
		File curSar = null;
		
		StorePublishParametersDataBean paramBean = new StorePublishParametersDataBean();
		
		for (int i=startIndex; i < endIndex; i++)
		{
		
			curSar = (File) sarlist.get(i);
			String filename = curSar.getPath();
			String name = curSar.getName(); //(new File(filename)).getName();  // temporary
			
			// Get the store archive description
			paramBean.setStoreArchiveFilename(filename);
			paramBean.setDescriptionOnly(true);
			String description = filename;
			
			try {
				com.ibm.commerce.beans.DataBeanManager.activate(paramBean, request);
				Properties paramProperties = paramBean.getProperties();
				description = paramProperties.getProperty("sar.description", filename);
			} catch (Exception e) {
				// if an exception is caught while retrieving the description, display filename instead
				description = filename;
			}
			
			
	//		System.out.println(filename);
	//		String storename = SARBean.getStoreName(i);
	%>
	
	     	        
			<%= comm.startDlistRow(rowSelect) %>
			<%= comm.addDlistCheck("cbox_" + i, "check(this);parent.setChecked();", filename ) %>			

		       	<%= comm.addDlistColumn(name, "none" ) %>

        		<%= comm.addDlistColumn(description, "none" ) %>
        	
        	
	        <%= comm.endDlistRow() %>
	        
	 
	        
	        	
			<%
				rowSelect = (rowSelect == 1) ?  2 : 1;
		}
			%>
			
			<%= comm.endDlistTable() %>

	<BR><BR>
</form>

</body>
</html>
