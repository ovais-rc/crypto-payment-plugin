<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2006,2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="com.ibm.commerce.tools.common.ui.ToolsLogonBean" %>
<%@page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@page import="com.ibm.commerce.contentmanagement.objects.*" %>
<%@page import="com.ibm.commerce.tools.contentmanagement.commands.util.*"%>

<%@ include file="../common/common.jsp" %>

<%
	// obtain the resource bundle for display
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	
    Hashtable rbWorkspace = (Hashtable)ResourceDirectory.lookup("workspaceadmin.WorkspaceAdminNLS", locale);
	
    String strTitle =(String)rbWorkspace.get("WorkspaceInfoTitle");

	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	String strTaskgroupId = jspHelper.getParameter("taskgroupId");
	String strTaskId = jspHelper.getParameter("taskId");
	String strLaunchTaskDetailsWindow = jspHelper.getParameter("launchTaskDetailsWindow");
%>

<HTML>
<HEAD>
<TITLE><%=strTitle%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// btnOK_onClick()
	//
	// - this function is called when the OK button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function btnOK_onClick()
	{
		top.goBack();
	}	
	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		var windowLaunched = <%= strLaunchTaskDetailsWindow %>;
		
		// Don't call setContentFrameLoaded if this is the launched window.
		if (!(windowLaunched==true)) {
			parent.setContentFrameLoaded(true);
		}
		
		if (typeof(SelectedApprovers) != "undefined")	
			sortSelect(SelectedApprovers);

		if (typeof(SelectedContributors) != "undefined")	
			sortSelect(SelectedContributors);
			
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// sortSelect(select)
	// -- sorts a select object
	//////////////////////////////////////////////////////////////////////////////////////
    	function sortSelect(select) 
    	{
        	var options = new Array (select.options.length);
        
	        for (var i = 0; i < options.length; i++)
	            options[i] = new Option (select.options[i].text, 
	                                     select.options[i].value, 
	                                     select.options[i].defaultSelected, 
	                                     select.options[i].selected);
	        options.sort(compareOption);
	        
	        select.options.length = 0;
	        for (var i = 0; i < options.length; i++)
	            select.options[i] = options[i];
    	}

	//////////////////////////////////////////////////////////////////////////////////////
	// compareOption(option1, option2)
	// -- compares two option objects
	//////////////////////////////////////////////////////////////////////////////////////
    	function compareOption(option1, option2) 
    	{
        	return option1.text > option2.text ? 1 : option1.text == option2.text ? 0 : -1;
    	}
	//////////////////////////////////////////////////////////////////////////////////////
	// launchTaskDetailsWindow
	// -- launched a window and displays the active task information. (TaskDetailsView)
	//////////////////////////////////////////////////////////////////////////////////////
	function launchTaskDetailsWindow() {
		
		var taskGroupId = <%= strTaskgroupId %>;
		var taskId = <%= strTaskId %>;
		
		if( taskId !="" && taskGroupId != "") {
			
			if((top.m_wndTaskDetails==null) || (top.m_wndTaskDetails.closed))	{
				
				// determine the URL for the task details page
				var webPath="https://"+self.location.hostname;
				var webPort = "<%= com.ibm.commerce.server.WcsApp.configProperties.getValue("WebServer/ToolsPort").trim() %>";

				if (webPort!=null && webPort!="" && webPort != "null") {
					webPath += ":" + webPort;
				}
				webPath+=top.webappPath;
				var strLaunchURL = webPath+"TaskDetailsView?XMLFile=workspaceadmin.TaskDetailsDialog&redirectURL=" + top.getWebPath() + "DialogView&taskgroupId=" + taskGroupId + "&taskId=" + taskId + "&launchTaskDetailsWindow=true";
				
				top.m_wndTaskDetails = top.openChildWindow( strLaunchURL, "WorkspaceTaskDetails", "'width=1014,height=710,scrollbars=yes,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes");
			}
		}
	}

</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<%
		//retrieve Taskgroup info
		boolean bQuickPublish=false;
		boolean bPersistent=false;
		String strTaskgroupIdentifier="";
		String strTaskgroupDueDate="";
		try{
			TaskGroupAccessBean abTaskGroup = new TaskGroupAccessBean();
			abTaskGroup.setInitKey_taskGroupId(new Long(strTaskgroupId));
			strTaskgroupIdentifier=abTaskGroup.getIdentifier();
			bQuickPublish=(abTaskGroup.getQuickPublishTypeInEntityType().intValue()==1);
			bPersistent=(abTaskGroup.getPersistentTypeInEntityType().intValue()==1);
	
			java.sql.Timestamp tsDueDate=abTaskGroup.getDueDateInEntityType();
			if(tsDueDate!=null)
			{
				java.text.DateFormat df = java.text.DateFormat.getDateInstance(java.text.DateFormat.MEDIUM, locale);
				strTaskgroupDueDate=df.format(tsDueDate);
			}
		}catch(Exception ex){
			//ex.printStackTrace();
		}
		
		//retrieve Taskgroup desc
		String strTaskgroupName="";
		String strTaskgroupDesc="";
		try{
			TaskGroupDescriptionAccessBean abTaskgroupDesc= new TaskGroupDescriptionAccessBean();
			abTaskgroupDesc.setInitKey_taskGroupId(new Long(strTaskgroupId));
			abTaskgroupDesc.setInitKey_languageId(cmdContext.getLanguageId());
			strTaskgroupName=abTaskgroupDesc.getName();
			strTaskgroupDesc=abTaskgroupDesc.getDescription(); 
		}catch(Exception ex){
			//ex.printStackTrace();
		}

		if(strTaskgroupName==null) strTaskgroupName="";
		if(strTaskgroupDesc==null) strTaskgroupDesc="";
		
		//Approvers
		Vector vApprovers=WorkspaceHelper.getTaskgroupApprovers(new Long(strTaskgroupId));
		Vector vAvailableApproverIdNames=WorkspaceHelper.getAvailableApproverIdNames(cmdContext);
		for(int i=0; i<vApprovers.size(); i++)
		{ 
			long lApproverId = ((Long)vApprovers.elementAt(i)).longValue();
			boolean bFound=false;
			for(int j=0; j<vAvailableApproverIdNames.size() && (bFound==false); j++)
			{
				Vector vIDName=(Vector)vAvailableApproverIdNames.elementAt(j);
				long lID=( new Long(vIDName.elementAt(0).toString())).longValue();
				if(lApproverId==lID)
				{
					vApprovers.set(i,vAvailableApproverIdNames.remove(j));
					bFound=true;
				}	
			}
			if(bFound==false)
			{
				vApprovers.remove(i);
			}
		}
		
	%>

	<TABLE style="width:100%">
		<TR>
			<TD>
				<B><%=UIUtil.toHTML((String)rbWorkspace.get("taskgroup")) %></B>
			</TD>	
		</TR>
		
		<TR> <TD><TABLE>
			<!-- Identifier -->   
			<TR>
				<TD>
					<%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupIdentifier"))%>
				</TD>
				<TD>	
					<%=UIUtil.toHTML(strTaskgroupIdentifier)%>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
	
			<!-- Name -->  
			<TR>
				<TD>
					<%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupName"))%>
				</TD>
				<TD>
					<%=UIUtil.toHTML(strTaskgroupName)%>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
	
			<%if(strTaskgroupDueDate.length()>0) {%>
				<TR>
					<TD>
						<%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupDueDate1"))%>
					</TD>
					<TD>
						<%=strTaskgroupDueDate%>
					</TD>
				</TR>
				<TR HEIGHT=1></TR>
			<%}%>
		</TABLE></TD></TR>
		
		<TR><TD><TABLE style="width:100%">
			<!-- Persistent radio button --> 		  		
			<TR>
				<TD>
					<%if(bPersistent) { %>
						<%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupPersistent"))%>
					<%}else{%>				
						<%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupNotPersistent"))%>
					<%}%>					
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
			<!-- QuickPublish check box -->  
			<% if(bQuickPublish) { %> 		
				<TR>
					<TD>
						<% if(bQuickPublish) { %>
							<%=UIUtil.toHTML((String)rbWorkspace.get("QuickPublish"))%>
						<%} else {%>	
							<%=UIUtil.toHTML((String)rbWorkspace.get("NotQuickPublish"))%>
						<%}%>
					</TD>
				</TR>
				<TR HEIGHT=1></TR>
			<%}%>
			
			<!-- Description -->
			<TR>
				<TD>
					<LABEL for="TGDesc"><%=UIUtil.toHTML((String)rbWorkspace.get("TaskgroupDescription"))%></LABEL>
				</TD>
			</TR>
			<TR style="width:100%">	
				<TD>
					<TEXTAREA ID="TGDesc" NAME=TGDesc ROWS=4 WRAP="HARD" READONLY style="background-color:#EFEFEF; overflow :auto; width:95%" ><%=UIUtil.toHTML(strTaskgroupDesc)%></TEXTAREA>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
	
			<!-- Approvers  -->   		
			<%if(vApprovers.size()>0) {%>
				<TR>
					<TD>
						<LABEL for="SelectedApprovers"> <%= UIUtil.toHTML((String)rbWorkspace.get("SelectedApprovers"))%> </LABEL>
					</TD>
				</TR>
				<TR style="width:100%">	
					<TD>
					    <SELECT ID="SelectedApprovers" NAME="SelectedApprovers" CLASS="selectWidth" SIZE="3" MULTIPLE READONLY style="background-color:#EFEFEF; overflow :auto; width:50%" >
							<% for(int i=0; i<vApprovers.size(); i++) 
							   {
							   	 Vector vIDNames=(Vector)vApprovers.elementAt(i);
							   	 //String strID	= vIDNames.elementAt(0).toString();
							   	 String strName	= UIUtil.toHTML(vIDNames.elementAt(1).toString());
							%>	
					   		<OPTION><%=strName%></OPTION>
							<% }%>				   		
					    </SELECT>
					</TD>
				</TR>
			<%}%>
		</TABLE></TD></TR>
	</TABLE>


	<%
		//retrieve Task info
		String strTaskIdentifier="";
		String strDueDate="";
		Integer nTaskType=null;
		try{
				TaskAccessBean abTask = new TaskAccessBean();
				abTask.setInitKey_taskId(new Long(strTaskId));
				strTaskIdentifier=abTask.getIdentifier();
				nTaskType=abTask.getTypeInEntityType();
				
				java.sql.Timestamp tsDueDate=abTask.getDueDateInEntityType();
				if(tsDueDate != null)
				{
					java.text.DateFormat df = java.text.DateFormat.getDateInstance(java.text.DateFormat.MEDIUM, locale);
					strDueDate=df.format(tsDueDate);
				}
		}catch(Exception ex){
			//ex.printStackTrace();
		}
		
	if(nTaskType.intValue()==1)
	{				
		//retrieve Task desc
		String strTaskName="";
		String strTaskDesc="";
		try{
			TaskDescriptionAccessBean abTaskDesc= new TaskDescriptionAccessBean();
			abTaskDesc.setInitKey_taskId(new Long(strTaskId));
			abTaskDesc.setInitKey_languageId(cmdContext.getLanguageId());
			strTaskName=abTaskDesc.getName();
			strTaskDesc=abTaskDesc.getDescription(); 
		}catch(Exception ex){
			//ex.printStackTrace();
		}

		if(strTaskName==null) strTaskName="";
		if(strTaskDesc==null) strTaskDesc="";
	
		//Contributors
		Vector vContributors=WorkspaceHelper.getTaskMemberIds(new Long(strTaskId));
		Vector vAvailableContributorIdNames=WorkspaceHelper.getAvailableContributorIdNames(cmdContext);
		for(int i=0; i<vContributors.size(); i++)
		{ 
			long lApproverId = ((Long)vContributors.elementAt(i)).longValue();
			boolean bFound=false;
			for(int j=0; j<vAvailableContributorIdNames.size() && (bFound==false); j++)
			{
				Vector vIDName=(Vector)vAvailableContributorIdNames.elementAt(j);
				long lID=( new Long(vIDName.elementAt(0).toString())).longValue();
				if(lApproverId==lID)
				{
					vContributors.set(i,vAvailableContributorIdNames.remove(j));
					bFound=true;
				}	
			}
			if(bFound==false)
			{
				vContributors.remove(i);
			}	
		}
	%>	
	
	
	
	<TABLE style="width:100%">
		<TR HEIGHT=10></TR>
		<TR>
			<TD>
				<B><%=UIUtil.toHTML((String)rbWorkspace.get("task")) %></B>
			</TD>	
		</TR>

		<TR><TD><TABLE>
			<!-- Identifier -->   
			<TR>
				<TD>
					<%=UIUtil.toHTML((String)rbWorkspace.get("TaskIdentifier"))%>
				</TD>
				<TD>	
					<%=UIUtil.toHTML(strTaskIdentifier)%>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
	
			<!-- Name -->  
			<TR>
				<TD>
					<%=UIUtil.toHTML((String)rbWorkspace.get("TaskName"))%>
				</TD>
				<TD>
					<%=UIUtil.toHTML(strTaskName)%>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
			
			<%if(strDueDate.length()>0) {%>
				<TR>
					<TD>
						<%=UIUtil.toHTML((String)rbWorkspace.get("TaskDueDate1"))%>
					</TD>
					<TD>
						<%=strDueDate%>
					</TD>
				</TR>
				<TR HEIGHT=1></TR>
			<%}%>

		</TABLE></TD></TR>

		<TR><TD><TABLE style="width:100%">
			<!-- Description -->
			<TR>
				<TD>
					<LABEL for="TKDesc"><%=UIUtil.toHTML((String)rbWorkspace.get("TaskDescription"))%>
					</LABEL>
				</TD>
			</TR>
			<TR style="width:100%">	
				<TD>
					<TEXTAREA ID="TKDesc" NAME=TKDesc ROWS=4 WRAP="HARD" READONLY style="background-color:#EFEFEF; overflow :auto; width=95%" ><%=UIUtil.toHTML(strTaskDesc)%></TEXTAREA>
				</TD>
			</TR>
			<TR HEIGHT=1></TR>
	
			<!-- Contributors  -->   		
			<%if(vContributors.size()>0) {%>
				<TR>
					<TD>
						<LABEL for="SelectedContributors"> <%= UIUtil.toHTML((String)rbWorkspace.get("SelectedContributor"))%> </LABEL>
					</TD>
				</TR>
				<TR style="width:100%">	
					<TD >
					    <SELECT ID="SelectedContributors" NAME="SelectedContributors" CLASS="selectWidth" SIZE="3" MULTIPLE READONLY style="background-color:#EFEFEF; overflow :auto; width:50%" >
							<% for(int i=0; i<vContributors.size(); i++) 
							   {
							   	 Vector vIDNames=(Vector)vContributors.elementAt(i);
							   	 //String strID	= vIDNames.elementAt(0).toString();
							   	 String strName	= UIUtil.toHTML(vIDNames.elementAt(1).toString());
							%>	
					   		<OPTION><%=strName%></OPTION>
							<% }%>				   		
					    </SELECT>
					</TD>
				</TR>
			<%}%>
		</TABLE></TD></TR>
	</TABLE>
	
<%
	}	//if(nTaskType.intValue()==1)
%>		
</BODY>
</HTML>

