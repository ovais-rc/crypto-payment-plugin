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
<%@page import="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishJobBean" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.databeans.PublishRecord" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>
<%@page import="java.util.Locale" %>

<%
    // Load the appropriate resource bundle
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties publishNLS = (ResourceBundleProperties) ResourceDirectory.lookup("publish.storePublishNLS", locale);		

	int defaultListSize = 10;
%>

<html>
<head>
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
	<script src="/wcadmin/javascript/tools/common/dynamiclist.js"></script>
	<script src="/wcadmin/javascript/tools/common/Util.js"></script>

	<jsp:useBean class="com.ibm.commerce.tools.devtools.publish.databeans.StorePublishJobBean" id="jobBean">
	<% 
    jobBean.setPathInfo("ScheduledDataDeploy");
    com.ibm.commerce.beans.DataBeanManager.activate(jobBean, request); %></jsp:useBean>
	
	
	<%
		// get the size of the table, and pass it to the Tools Framework Dynamic List code
		Vector publishRecords = jobBean.getPublishRecords();
		
		int listLength = (publishRecords == null) ? 0: publishRecords.size();
		
		int listSize = defaultListSize;
		if (request.getParameter("listsize") != null) {
			listSize = Integer.parseInt(request.getParameter("listsize"));
		}
	%>

<script>
	function onLoad()
	{
	
		top.writeBannerTitle(top.banner_title);
		parent.loadFrames();
		parent.setResultssize(<%= listLength %>);
		parent.set_t_item_page(<%= listLength %>, <%= listSize %>); 
		parent.setButtonPos('0px',(document.all.list.offsetTop - 7) + 'px');
		parent.afterLoads();
	}

	/******************************************************************************
	*
	*	Constants
	*
	******************************************************************************/
	var WEB_APP_PATH = top.getWebappPath();
	var STATUS_LIST_URL = WEB_APP_PATH + "NewDynamicListView?ActionXMLFile=publish.StorePublishStatusList&amp;cmd=StorePublishStatusListView";	
	
	/******************************************************************************
	*
	*	Button actions
	*
	******************************************************************************/
	
	function publishDetailsAction()
	{
		var jobNumParam = new String(parent.getChecked());
		var url = WEB_APP_PATH + "/DialogView?XMLFile=publish.StorePublishStatusDetails&" + jobNumParam; //sarSelected() + "&StoreName=" + fileSelected();
		//alertDialog(url);
		top.setContent("<%= publishNLS.getJSProperty("StorePublishStatusDetailsTitle")%>", url, true);
	}
	
	function refreshAction()
	{
        top.mccbanner.loadbct();
	}

<%
     Calendar rightNow = Calendar.getInstance();
     StringBuffer rightNowStr = new StringBuffer("");

     rightNowStr.append(rightNow.get(Calendar.YEAR)+":");
     rightNowStr.append((rightNow.get(Calendar.MONTH)+1)+":");
     rightNowStr.append(rightNow.get(Calendar.DAY_OF_MONTH)+":");
     rightNowStr.append(rightNow.get(Calendar.HOUR_OF_DAY)+":");
     rightNowStr.append(rightNow.get(Calendar.MINUTE)+":");
     rightNowStr.append(rightNow.get(Calendar.SECOND));
%>
	function removeRecordAction()
	{
          if ( confirmDialog('<%=  UIUtil.toJavaScript((String)publishNLS.getProperty("statusListSchedulerCleanConfirm")) %>') ) {
	       var jobNumParam = new String(parent.getChecked());
               var url = WEB_APP_PATH + '/CleanJob?URL=' + STATUS_LIST_URL + '&endTime=<%= rightNowStr %>&' + jobNumParam
               + '&authToken=' + encodeURI('${authToken}');
               top.setContent("<%= publishNLS.getProperty("statusListTitle") %>", url, false, null);
               
          }
	}
	
	function removeAllAction()
	{
          if ( confirmDialog('<%= UIUtil.toJavaScript((String)publishNLS.getProperty("statusListSchedulerCleanAllConfirm")) %>') ) {
               var url = '/webapp/wcs/admin/servlet/CleanJob?URL=' + STATUS_LIST_URL + '&endTime=<%= rightNowStr %>'
               + '&authToken=' + encodeURI('${authToken}');
               top.setContent("<%= publishNLS.getProperty("statusListTitle") %>", url, false, null);
          }
	}
	
     function helpwindow()
     {
              var helpfile= top.help['AC.storePublish.StatusList.Troubleshooting.Help'];
              var hwin = window.open("http://<%= WcsApp.configProperties.getValue("Websphere/HelpServerHostName") %>" + top.help_base + helpfile, "Help", "width=700,height=450,toolbar=no,resizable=yes,scrollbars=yes,menubar=yes,copyhistory=no");
 			  hwin.focus();
     }

	
	
	/******************************************************************************
	*
	*	List actions
	*
	******************************************************************************/
	
	function check(currentRow)
	{
		for (var i = 0; i < document.statusListForm.length; i++)
		{
			if (document.statusListForm.elements[i] == currentRow)
				document.statusListForm.elements[i].checked = true;
			else
				document.statusListForm.elements[i].checked = false;
		}
	}
	
	function sarSelected()
	{
		var check = new String(parent.getChecked());
		var sarName = check.substring(0,check.indexOf(";"));
		top.writeBannerTitle(top.banner_title + " - " + sarName);
		return encodeURIComponent(sarName);
	}
	function fileSelected()
	{
		var check = new String(parent.getChecked());
		var fileName = check.substring(check.indexOf(";")+1, check.indexOf("&"));
		return encodeURIComponent(fileName);
	}
	
</script>

<META name="GENERATOR" content="IBM WebSphere Studio">
<body class="content_list" onLoad="onLoad();">


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

<%= publishNLS.getProperty("statusListInstr1") %><br>
<%= publishNLS.getProperty("statusListInstr2") %><br>

<form id="list" name="statusListForm">
	<%-- -------------------------------------------------------------------------
		Tools Framework Dynamic List
	--------------------------------------------------------------------------- --%>
	<%= comm.startDlistTable((String)publishNLS.getProperty("")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistColumnHeading("", null, false) %>
	<%= comm.addDlistColumnHeading((String)publishNLS.getProperty("statusListJobNumber"), null, false, "15%" ) %>
	<%= comm.addDlistColumnHeading((String)publishNLS.getProperty("statusListStoreArchive"), null, false, "15%" ) %>
	<%= comm.addDlistColumnHeading((String)publishNLS.getProperty("statusListStart"), null, false, "20%" ) %>
	<%= comm.addDlistColumnHeading((String)publishNLS.getProperty("statusListFinished"), null, false, "20%" ) %>
	<%= comm.addDlistColumnHeading((String)publishNLS.getProperty("statusListStatus"), null, false, "30%" ) %>
	<%= comm.endDlistRowHeading() %>

	<%
		int rowSelect = 1;
		PublishRecord record = null;
		for (int i = startIndex; i < endIndex; i++)
		{
			record = (PublishRecord) publishRecords.elementAt(i);
			String jobNumber = record.getJob();
			String filename = record.getSARFilename();
			if (filename != null) {
				int index = filename.lastIndexOf('/');
				if (index == -1) {
					index = filename.lastIndexOf('\\');
				}
				filename = filename.substring(index + 1);
			}
			
			String status = record.getStatus();
			String start = record.getStartTime();
			String end = record.getEndTime();
			String check = (jobNumber == null) ? " " : "jobId=" + jobNumber;
			
			if (status != null) {
				status = status.trim();
			} else continue;
			
			String statusDescription = "";
			boolean publishFailed = false;
			
			if (status.equals("I"))
				statusDescription = (String) publishNLS.getProperty("statusIdle");
			else if (status.equals("R"))
				statusDescription = (String) publishNLS.getProperty("statusRun");
			else if (status.equals("C"))
				statusDescription = (String) publishNLS.getProperty("statusComplete");
			else if (status.equals("IF") || status.equals("RF") || status.equals("CF")){
				statusDescription = (String) publishNLS.getProperty("statusFail");
				publishFailed = true;
			}
			else
				statusDescription = status;
		
	%>
			<%= comm.startDlistRow(rowSelect) %>
			
				<%= comm.addDlistCheck(check, "check(this);parent.setChecked();" ) %>
	        	<%= comm.addDlistColumn(jobNumber, "none" ) %>
        		<%= comm.addDlistColumn(filename, "none" ) %>
        		<%= comm.addDlistColumn(start, "none" ) %>
        		<%= comm.addDlistColumn(end, "none" ) %>
        		
	            <% if ( publishFailed ) { %>
	               <%= comm.addDlistColumn(statusDescription, "javascript:helpwindow();" ) %>
	            <% } else { %>
	               <%= comm.addDlistColumn(statusDescription, "none" ) %>
	            <% } %>
        	
        	<%= comm.endDlistRow() %>
	<%
			rowSelect = (rowSelect == 1) ?  2 : 1;
		}
	%>
	<%= comm.endDlistTable() %>
</form>

</body>
</html>
