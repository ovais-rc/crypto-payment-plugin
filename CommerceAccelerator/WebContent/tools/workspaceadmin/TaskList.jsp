<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2004, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.contentmanagement.beans.*"%>
<%@ page import="com.ibm.commerce.contentmanagement.objects.TaskAccessBean"%>
<%@ page import="com.ibm.commerce.context.task.TaskContext"%>
<%@ page import="com.ibm.commerce.catalog.content.util.SalesCatalogSyncHelper"%>

<%@include file="../common/common.jsp" %>

<%!
	private String getCurrentTaskId(CommandContext cmdContext) {
		String taskId = "";
		TaskContext taskContext = (TaskContext) cmdContext.getContext(TaskContext.class.getName());
		if (taskContext != null) {
			String taskIdentifier = taskContext.getTask();

			if (taskIdentifier == null || taskIdentifier.trim().length() == 0) {
				taskId = "";
			} else {
				try {
					TaskAccessBean abTask = new TaskAccessBean();
					taskId = abTask.findByIdentifier(taskIdentifier).getTaskId();
				} catch (Exception e) {
					taskId = "";
				}
			}
		}
		return taskId;
	}
%>

<%
	// resource bundle
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();

    Hashtable rbWorkspace = (Hashtable)ResourceDirectory.lookup("workspaceadmin.WorkspaceAdminNLS", locale);
    String strTitle =(String)rbWorkspace.get("titleTaskList");

	// url parameters
	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	String strOrderByParam  = jspHelper.getParameter("orderby");
    String strListScopeParam= jspHelper.getParameter("listscope");
	int nStartIndex = Integer.parseInt(request.getParameter("startindex"));
	int nPageSize = Integer.parseInt(request.getParameter("listsize"));
	int nPageNumber=(nStartIndex/nPageSize) + 1;

	// retrieve the tasks using TaskListDataBean
	Vector vTasks = new Vector();	
	int nTotalMumberOfTasks = 0;
	
	TaskListDataBean dbTaskList = new TaskListDataBean();
	dbTaskList.setListOrderby(strOrderByParam);								//TaskListDataBean.ORDER_BY_NAME);
	dbTaskList.setListScope(strListScopeParam);								//TaskListDataBean.LIST_SCOPE_ALL_TASKS);
	dbTaskList.setStartIndex(new Integer(nStartIndex));
	dbTaskList.setPageSize(new Integer(nPageSize));
	DataBeanManager.activate(dbTaskList, cmdContext);
	
	vTasks=dbTaskList.getTaskList();
	nTotalMumberOfTasks=dbTaskList.getTotalNumberOfTasks().intValue();

	int nMumberOfTasksToDisplay = vTasks.size();		
	//int nMumberOfPages = (nTotalMumberOfTasks+nPageSize-1)/nPageSize;

	// retrieve current task from content context
	String strCurrentTaskId=getCurrentTaskId(cmdContext);
	
	// in workspace and need to synchronize it?
	boolean bIsWorkspaceToBeSynchronized=SalesCatalogSyncHelper.isWorkspaceToBeSynchronized(cmdContext);
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML(strTitle)%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
 
<SCRIPT type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>

if(top.taskId!='<%=strCurrentTaskId%>')
	reloadAccelerator();

function onLoad()
{
  	<% if(strCurrentTaskId.length()==0) { %>
  		//parent.hideButton("btnTaskListWorkOnBase");
  		parent.Buttons.btnTaskListWorkOnBaseButton.Class="disabled";
  	<%}else{%>
  		//parent.displayButton("btnTaskListWorkOnBase");
  		parent.Buttons.btnTaskListWorkOnBaseButton.Class="enabled";
  	<%}%>	

  	<% if(bIsWorkspaceToBeSynchronized) { %>
  		parent.Buttons.btnSynchronizeWorkspaceButton.Class="enabled";
  	<%}else{%>
  		parent.Buttons.btnSynchronizeWorkspaceButton.Class="disabled";
  	<%}%>	


	parent.afterLoads();
	parent.setResultssize(<%= nTotalMumberOfTasks %>);
	parent.loadFrames();
  	
  	handleCommandResponses();
}


function userInitialButtons()
{
	//clear TFW checked record
	parent.checkeds.removeAllElements();
	
	var strCheckedTaskId=top.getData("SELECTED_TASK_ID");	
			
	if(strCheckedTaskId==null || strCheckedTaskId=="")
		strCheckedTaskId="<%=strCurrentTaskId%>";
	
	//If the selection can be found on this page, click on it, button status will be updated		
	var bCheckedTaskOnPage=false;
	for (var i=0; i<document.ListForm.elements.length; i++) 
	{
		document.ListForm.elements[i].checked = false;

		if(document.ListForm.elements[i].name == strCheckedTaskId)		
		{
			document.ListForm.elements[i].click();
			bCheckedTaskOnPage=true;
		}
	}
	
	//if the selection is not on the page, need to enable/disable buttons		
  	if(bCheckedTaskOnPage==false)
  	{
        setChecked();
  		enableButtons();
  	}
}


function getBCTTitle()
{
	return "<%=UIUtil.toJavaScript(rbWorkspace.get("viewTasksBCT"))%>";
}

var m_selectedTaskId=null;
var m_selectedTaskgroupId=null;
var m_selectedWorkspaceId=null;
var m_selectedTaskStatus=null;
var m_selectedTaskType=null;
var m_confirmPreviewClosingOnWorkOn='<%= UIUtil.toJavaScript(rbWorkspace.get("confirmPreviewClosingOnWorkOn")) %>';
var m_confirmPreviewClosingOnExit='<%= UIUtil.toJavaScript(rbWorkspace.get("confirmPreviewClosingOnExit")) %>';
var m_confirmWorkOnTask='<%= UIUtil.toJavaScript(rbWorkspace.get("msgConfirmWorkOnTask")) %>';
var m_confirmExitWorkspace='<%= UIUtil.toJavaScript(rbWorkspace.get("msgConfirmExitWorkspace")) %>';
var m_confirmCompleteTask='<%= UIUtil.toJavaScript(rbWorkspace.get("msgConfirmCompleteTask")) %>';
var m_confirmApproveTaskgroup='<%= UIUtil.toJavaScript(rbWorkspace.get("msgConfirmApproveTaskgroup")) %>';
var m_confirmRejectTaskgroup='<%= UIUtil.toJavaScript(rbWorkspace.get("msgConfirmRejectTaskgroup")) %>';


function onClickTaskCheckbox(strWorkspaceId, strTaskgroupId, strTaskId, strStatus, strType)
{
	var bChecked=false;

	for (var i=0; i<document.ListForm.elements.length; i++) 
	{
		if(document.ListForm.elements[i].name == strTaskId)		
			bChecked=document.ListForm.elements[i].checked;		
		else
			document.ListForm.elements[i].checked = false;
	}		

	if(bChecked)
	{
		m_selectedTaskId=strTaskId;
		m_selectedTaskgroupId=strTaskgroupId;
		m_selectedWorkspaceId=strWorkspaceId;
		m_selectedTaskStatus=strStatus;
		m_selectedTaskType=strType;
		top.saveData(strTaskId,"SELECTED_TASK_ID");
	}
	else
	{
		m_selectedTaskId=null;
		top.saveData(null,"SELECTED_TASK_ID");
	}

	setChecked();
	
	enableButtons();
}

//This function does not keep the elements on other pages.
function setChecked()
{
    parent.checkeds.removeAllElements();
    
    for (var i=0; i<parent.basefrm.document.ListForm.elements.length; i++) {
       var e = parent.basefrm.document.ListForm.elements[i];
       if (e.type == 'checkbox') {
           if (e.name != 'select_deselect' && e.checked ) {
               parent.checkeds.addElement(e.name);
           }
       }
     }
     
     parent.refreshButtons();
}

function enableButtons()
{
	var enableWorkOn='disabled';
	var enableComplete='disabled';
	//var enableReturnToWorking='disabled';
	var enableWorkOnBase='disabled';
	var enableShowDetails='disabled';
	var enableComments='disabled';
	var enableApprove ='disabled';
	var enableReject ='disabled';
	var enableSynchronizeWorkspace = 'disabled';

	if(m_selectedTaskId!=null)
	{
		if(m_selectedTaskStatus=='1')	//selected an active task
		{
			if(("<%=strCurrentTaskId%>"=="") || (m_selectedTaskId != "<%=strCurrentTaskId%>"))
				enableWorkOn='enabled';
				
			if(m_selectedTaskType=='1')				
				enableComplete='enabled';			//enable complete a contribute task
				
			if(m_selectedTaskType=='2'){				//selected an active approval task
				enableApprove ='enabled';
				enableReject ='enabled';
			}	
		}
		else if	((m_selectedTaskStatus=='0') && (m_selectedTaskType=='2'))	//selected an inactive approval task
		{
			if(("<%=strCurrentTaskId%>"=="") || (m_selectedTaskId != "<%=strCurrentTaskId%>"))
				enableWorkOn='enabled';
		}
		
		enableShowDetails='enabled';
		enableComments='enabled';
	}
	
	if("<%=strCurrentTaskId%>"!="")
		enableWorkOnBase='enabled';
		
  	<% if(bIsWorkspaceToBeSynchronized) { %>
  		enableSynchronizeWorkspace='enabled';
  	<%}%>
		
		
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListWorkOnButton,enableWorkOn);
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListCompleteButton,enableComplete);
    //parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListReturnToWorkingButton,enableReturnToWorking);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListWorkOnBaseButton,enableWorkOnBase);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListShowDetailsButton,enableShowDetails);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListCommentsButton,enableComments);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnTaskListApproveButton,enableApprove);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnRejectButton,enableReject);	
    parent.AdjustRefreshButton(parent.buttons.buttonForm.btnSynchronizeWorkspaceButton,enableSynchronizeWorkspace);	

}

function onBtnWorkOn()
{
	//construct and submit the xml
	var oXML= new Object();
	oXML.workspaceId	= m_selectedWorkspaceId;
	oXML.taskgroupId	= m_selectedTaskgroupId;
	oXML.taskId		= m_selectedTaskId;
	oXML.cleanContext 	= false;
	
	// check to see if a preview window is opened and display a warning
	if (top.previewWindowOpened()) {
		if (!parent.confirmDialog(m_confirmPreviewClosingOnWorkOn )) {
			return;
		}
		top.closeChildWindows();
	} 
	else
	{ 
		if (parent.confirmDialog(m_confirmWorkOnTask)==false) {
			return;
		}
	}
    
	convertSubmitXML("ContentContextSetControllerCmd", oXML);
}

function onBtnSynchronizeWorkspace()
{
	//construct and submit the xml
	var oXML= new Object();
	oXML.workspaceId	= m_selectedWorkspaceId;
    
	convertSubmitXML("WorkspaceSynchronizeControllerCmd", oXML);
}


function onBtnWorkOnBase()
{
	//construct and submit the xml
	var oXML= new Object();
	oXML.cleanContext 	= true;
	// check to see if a preview window is opened and display a warning
	if (top.previewWindowOpened()) {
		if (!parent.confirmDialog(m_confirmPreviewClosingOnExit )) {
			return;
		}
		top.closeChildWindows();
	} 
	else
	{ 
		if (parent.confirmDialog(m_confirmExitWorkspace)==false) {
			return;
		}
	}

	convertSubmitXML("ContentContextSetControllerCmd", oXML);
}

function onBtnComplete()
{
	if (parent.confirmDialog(m_confirmCompleteTask)==false) {
		return;
	}

	var oXML = new Object();
	oXML.taskId =m_selectedTaskId;
	oXML.taskgroupId =m_selectedTaskgroupId;
	oXML.action="ACTION_COMPLETE";
	oXML.switchContext="true";

	convertSubmitXML("TaskChangeStatusControllerCmd",oXML);
}

//function onBtnReturnToWorking()
//{
//	var oXML = new Object();
//	oXML.taskId 	= m_selectedTaskId;
//	oXML.taskgroupId= m_selectedTaskgroupId;
//	oXML.action     = "ACTION_RETURN_TO_WORKING";
//	convertSubmitXML("TaskChangeStatusControllerCmd",oXML);
//}

function onBtnRefresh()
{
	parent.changeView();
}


//function onBtnPreview()
//{
//	var url = top.getWebPath() + "DialogView";
//	var urlPara = new Object();
//	urlPara.XMLFile = "preview.PreviewDialog";		
//	top.setContent("<%=UIUtil.toJavaScript(rbWorkspace.get("btnTaskListPreview"))%>", url, true, urlPara);     
//}


function onBtnApprove()
{
	if (parent.confirmDialog(m_confirmApproveTaskgroup)==false) {
		return;
	}

	var oXML = new Object();
	oXML.taskgroupId =m_selectedTaskgroupId;
	oXML.action="ACTION_APPROVE";
	oXML.switchContext="true";

	convertSubmitXML("TaskgroupChangeStatusControllerCmd",oXML);
}

function onBtnReject()
{
	if (parent.confirmDialog(m_confirmRejectTaskgroup)==false) {
		return;
	}

	var oXML = new Object();
	oXML.taskgroupId =m_selectedTaskgroupId;
	oXML.action="ACTION_REJECT";
	oXML.switchContext="true";

	convertSubmitXML("TaskgroupChangeStatusControllerCmd",oXML);
}

function onBtnShowDetails()
{
	var	param= new Object();
		param["XMLFile"]="workspaceadmin.TaskDetailsDialog";
		param["redirectURL"]=top.getWebPath() + "DialogView";
		param["taskgroupId"]=m_selectedTaskgroupId;
		param["taskId"]=m_selectedTaskId;
		
   	top.setContent("<%=UIUtil.toJavaScript(rbWorkspace.get("taskDetailsBCT"))%>", top.getWebPath() + "DialogView", true, param);
}

function onBtnComments()
{
	var	param= new Object();
		param["XMLFile"]="workspaceadmin.TaskCommentsDialog";
		param["redirectURL"]=top.getWebPath() + "DialogView";
		param["taskgroupId"]=m_selectedTaskgroupId;
		
   	top.setContent("<%=UIUtil.toJavaScript(rbWorkspace.get("taskCommentsBCT"))%>", top.getWebPath() + "DialogView", true, param);
}

//////////////////////////////////////////////////////////////////////////////////////
// convertSubmitXML(strAction, oXMLObj)
//
// - convert the oXMLObj to XML and submit it through the "fmWorking" frame
//////////////////////////////////////////////////////////////////////////////////////
function convertSubmitXML(strAction, oXMLObj)
{
	var oParam = oParam=new Array();
	
	oParam["XML"]=convertToXML(oXMLObj, "XML");
	
	//return to this page after finishing the cmd
	oParam["<%=com.ibm.commerce.server.ECConstants.EC_REDIRECTURL%>"]="NewDynamicListView";
	oParam["ActionXMLFile"]="workspaceadmin.TaskListActions";
	oParam["cmd"]="TaskListView";
	oParam["listscope"]="<%=UIUtil.toJavaScript(strListScopeParam)%>";
	oParam["orderby"]="<%=UIUtil.toJavaScript(strOrderByParam)%>";
	oParam["startindex"]="<%=nStartIndex%>";
	oParam["pagenumber"]="<%=nPageNumber%>";

	parent.scrollcontrol.document.all.gotopage.value="<%=nPageNumber%>";
	
	top.mccmain.submitForm(strAction,oParam,null);
}

function handleCommandResponses()
{
  <% 
	// handle msg from the controller commands
	String strMessage = jspHelper.getParameter("SubmitFinishMessage");
	if (strMessage!=null && strMessage.trim().length()>0) 
	{
		String jsStrMsgText		= UIUtil.toJavaScript(rbWorkspace.get(strMessage));
	%>	
		alertDialog("<%= jsStrMsgText %>");
		parent.document.generalForm.SubmitFinishMessage.value="";
		
  <% }  %>
}

function reloadAccelerator()
{
	var strTopLocation=top.location.href;
	
	if(strTopLocation.indexOf("gotoMenuPath=tasks/viewTasks")<0)
		strTopLocation=top.location+"&gotoMenuPath=tasks/viewTasks";	
		
	top.logout_page = '';	
	top.location=strTopLocation;
}

function addDlistColumnWithTitle(content,link,sty,strTitle) {
	var len = arguments.length;
	
	if (hindex >= headings.length) {
		hindex=0;
	}		
	
	heading_id = 't' + tableno + (hindex++);
	
	document.write('<td id="' + heading_id + '" class="' + list_col_style + '"');
	
	if(strTitle)
		document.write(' title="'+ strTitle+'" ');
		
	if (len>2 && sty!=null && !testNone(sty.toLowerCase())) {
		document.write(' style="' + sty + '"');
	}
	
	document.writeln('>');
	
	if (len>1 && link!=null && !testNone(link.toLowerCase())) {
		document.writeln('<a class="' + list_link_style + '" href="' + link + '">' + content + '</a></td>');
	}
	else{
		document.writeln(content + '</td>');
	}
}

</SCRIPT>
</HEAD>


<BODY CLASS=content ONLOAD="onLoad();" >

      <%= comm.addControlPanel("workspaceadmin.TaskListActions", nPageSize, nTotalMumberOfTasks, locale) %>

      <FORM NAME="ListForm" id="ListForm">
        <%= comm.startDlistTable((String)rbWorkspace.get("taskListTable")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading(false) %>
        <%= comm.addDlistColumnHeading((String)rbWorkspace.get("taskListName"),TaskListDataBean.ORDER_BY_NAME,strOrderByParam.equals(TaskListDataBean.ORDER_BY_NAME) ) %>
        <%= comm.addDlistColumnHeading((String)rbWorkspace.get("taskListStatus"),TaskListDataBean.ORDER_BY_STATUS,strOrderByParam.equals(TaskListDataBean.ORDER_BY_STATUS) ) %>
        <%= comm.addDlistColumnHeading((String)rbWorkspace.get("taskListDueDate"),TaskListDataBean.ORDER_BY_DUE_DATE,strOrderByParam.equals(TaskListDataBean.ORDER_BY_DUE_DATE) ) %>
        <%= comm.addDlistColumnHeading((String)rbWorkspace.get("taskListTaskgroup"),TaskListDataBean.ORDER_BY_TASKGRP,strOrderByParam.equals(TaskListDataBean.ORDER_BY_TASKGRP) ) %>
        <%= comm.addDlistColumnHeading((String)rbWorkspace.get("taskListWorkspace"),TaskListDataBean.ORDER_BY_WORKSPACE,strOrderByParam.equals(TaskListDataBean.ORDER_BY_WORKSPACE) ) %>

        <%= comm.endDlistRow() %>

        <%
		for (int i = 0; i < nMumberOfTasksToDisplay; i++) 
		{
			TaskListItem task=(TaskListItem)vTasks.elementAt(i);
			String strWorkspaceId=task.getWorkspaceId();
			String strTaskgroupId=task.getTaskgroupId();
			String strTaskId=task.getTaskId();
			String strName=UIUtil.toHTML(task.getName());
			String strDesc=UIUtil.toHTML(task.getDescription());
			String strStatus=task.getStatus();
			Integer nStatus=task.getStatusInInteger();
			Integer nType=task.getTypeInInteger();
			String strDueDate=task.getDueDate();
			String strTaskgroup=UIUtil.toHTML(task.getTaskgroupName());
			String strWorkspace=UIUtil.toHTML(task.getWorkspaceName());

			String onClickTaskCheckboxParam="'"+strWorkspaceId+"','"+strTaskgroupId+"','"+strTaskId+"','"+nStatus+"','"+nType+"'";		
			
			String strRowstyle=null;
			if(strTaskId.equals(strCurrentTaskId))
			{
				strRowstyle="background-color: #EDAC40;";
			}
	    %>
	        <%= comm.startDlistRow((i%2)+1) %>
	        
	        <%= comm.addDlistCheck( strTaskId, "onClickTaskCheckbox("+onClickTaskCheckboxParam+")") %>
	        <%-- = comm.addDlistColumn( strName, null, strRowstyle) --%>
	        <script>
	        	addDlistColumnWithTitle("<%=UIUtil.toJavaScript(strName)%>",null,"<%=UIUtil.toJavaScript(strRowstyle)%>","<%=UIUtil.toJavaScript(strDesc)%>");
	        </script>	
	        <%= comm.addDlistColumn( strStatus, null, strRowstyle ) %>
	        <%= comm.addDlistColumn( strDueDate, null, strRowstyle ) %>
	        <%= comm.addDlistColumn( strTaskgroup, null, strRowstyle ) %>
	        <%= comm.addDlistColumn( strWorkspace, null, strRowstyle ) %>
	        
	        <%= comm.endDlistRow() %>
	        
        <%}//End of for %>
        
        <%= comm.endDlistTable() %>
			
		<% if (nMumberOfTasksToDisplay == 0) {%>
			<br><%= UIUtil.toHTML((String)rbWorkspace.get("taskListEmpty")) %>
		<%}%>

      </FORM>

</BODY>
</HTML>

