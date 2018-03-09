<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.tools.contentmanagement.commands.util.*"%>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.contentmanagement.objects.*"%>

<%@include file="../common/common.jsp" %>

<%!
	private static final int MAX_COMMENT_LENGTH=32768;//32*1024;
	private String retrieveTaskGroupComments(String strTaskgroupId, Locale locale, String strErrorMsg) 
	{
		StringBuffer sbRet= new StringBuffer("");
		ServerJDBCHelperBean jdbcHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		
		try{
			StringBuffer sbTemp= new StringBuffer();
			sbTemp.append(" select CMFTGCMT.COMMENTS, CMFTGCMT.POSTEDDATE, CMFTGCMT.MEMBER_ID ");
			sbTemp.append(" from CMFTGCMT");
			sbTemp.append(" where CMFTGCMT.CMFTASKGRP_ID=?");
			sbTemp.append(" order by CMFTGCMT.POSTEDDATE");
			Object [] params = new Object[] {strTaskgroupId};
			Vector vResultSet=jdbcHelper.executeParameterizedQuery(sbTemp.toString(), params);
			for(int i=0, nLength=0; i<vResultSet.size(); i++)
			{
				Vector vRow= (Vector)vResultSet.elementAt(i);
				String strCmt=(String)vRow.elementAt(0);
				if(strCmt==null) 
				{
					strCmt="";
				}	
					
				int nCmtLength=strCmt.length();	
				if((nCmtLength+nLength)<MAX_COMMENT_LENGTH)
				{
					//Date
					java.sql.Timestamp tsDate= (java.sql.Timestamp)vRow.elementAt(1);
					String strTimestamp="";
					if(tsDate!=null)
					{
						java.text.DateFormat df = java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG,locale);
						strTimestamp= df.format(tsDate);
					}
					//User
					String strMemberId=vRow.elementAt(2).toString();
					String strUserName="";
					try{
						com.ibm.commerce.user.objects.UserAccessBean abUser = new com.ibm.commerce.user.objects.UserAccessBean();
						abUser.setInitKey_memberId(strMemberId);
						strUserName=abUser.getDisplayName();
					}catch(Exception ex){
						strUserName="";
					}
					//format and append the comment
					sbRet.append("[ ");
					sbRet.append(strTimestamp);
					sbRet.append(" -- ");
					sbRet.append(strUserName);
					sbRet.append(" ]");
					sbRet.append(System.getProperty("line.separator"));
					sbRet.append(strCmt);
					sbRet.append(System.getProperty("line.separator"));
					sbRet.append(System.getProperty("line.separator"));
				}
				else	
				{	// >= 32K
					sbRet.append(strErrorMsg);
					break;	
				}
					
			}
		}catch(Exception ex){
			//ex.printStackTrace();
		}
		
		return sbRet.toString();
	}
%>

<%
	// obtain the resource bundle for display
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	
    Hashtable rbWorkspace = (Hashtable)ResourceDirectory.lookup("workspaceadmin.WorkspaceAdminNLS", locale);

    String strTitle =(String)rbWorkspace.get("TitleTaskgroupComments");
	
	
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strTaskgroupId = helper.getParameter("taskgroupId");
	String strTaskgroupName="";
	try{
		TaskGroupDescriptionAccessBean abTaskGroupDesc = new TaskGroupDescriptionAccessBean();
		abTaskGroupDesc.setInitKey_taskGroupId(new Long(strTaskgroupId));
		abTaskGroupDesc.setInitKey_languageId(cmdContext.getLanguageId());
		strTaskgroupName=abTaskGroupDesc.getName();
	}catch(Exception ex){
		ex.printStackTrace();
		throw ex;
	}
    
	if(strTaskgroupName==null || strTaskgroupName.trim().length()==0)
	{
		try{
		    TaskGroupAccessBean abTaskGroup = new TaskGroupAccessBean();
		    abTaskGroup.setInitKey_taskGroupId(new Long(strTaskgroupId));
		    strTaskgroupName=abTaskGroup.getIdentifier();
		}catch(Exception ex){
			ex.printStackTrace();
			throw ex;
		}	
	}
	
	if(strTaskgroupName==null) strTaskgroupName="";
	
	//retrieve Taskgroup comments
	String strExistingComments=retrieveTaskGroupComments(strTaskgroupId, locale, (String)rbWorkspace.get("CommentsSizeExceeded"));	
	
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML(strTitle)%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
 
<SCRIPT type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		<% if(strExistingComments.length()>0){ %>
			TGExistingComments.value="<%=UIUtil.toJavaScript(strExistingComments)%>";
		<%}else{%>
			TGExistingComments.value="<%=UIUtil.toJavaScript((String)rbWorkspace.get("NoExistingComments"))%>";
		<%}%>

		parent.setContentFrameLoaded(true);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// savePanelData() 
	//
	// - Stores HTML form data into model (parent frame) 
	//////////////////////////////////////////////////////////////////////////////////////
	function savePanelData() 
	{
		parent.put("taskgroupId", "<%=strTaskgroupId%>");
		parent.put("comment", TGNewComments.value);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// validatePanelData() 
	//
	// - Validates data entered by user 
	//////////////////////////////////////////////////////////////////////////////////////
	function validatePanelData()
	{
		//check the length of comments
		if (isValidUTF8length(TGNewComments.value, 4000) == false) 
		{ 
			alertDialog("<%= UIUtil.toJavaScript((String)rbWorkspace.get("msgFieldSizeExceeded"))%>"); 
			return false;
		}

		return true;
	} 

	//////////////////////////////////////////////////////////////////////////////////////
	// submitErrorHandler(errMessage, errorStatus) 
	//
	// - Called when error is received from controller command. 
	//////////////////////////////////////////////////////////////////////////////////////
	function submitErrorHandler(errMessage, errorStatus) 
	{
		alertDialog("<%= UIUtil.toJavaScript((String)rbWorkspace.get("msgTaskgroupUpdateCommentsControllerCmdFailed"))%>"); 
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// submitFinishHandler(finishMessage) 
	//
	// - Called upon successful completion of controller command. 
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFinishHandler(finishMessage)
	{
		alertDialog("<%= UIUtil.toJavaScript((String)rbWorkspace.get("msgTaskgroupUpdateCommentsControllerCmdFinished"))%>"); 
		top.goBack();
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content STYLE="margin-top: 0px;" ONLOAD="onLoad();" >

	<TABLE style="width:100%">
		<TR HEIGHT=5></TR>

		<!-- Name/Identifier -->   
		<TR>
			<TD>
				<B><%=UIUtil.toHTML((String)rbWorkspace.get("taskgroup"))%></B>
				&nbsp;
				<%=UIUtil.toHTML(strTaskgroupName)%>
			</TD>
		</TR>
		<TR HEIGHT=5></TR>
		<!-- Existing comments -->
		<TR>
			<TD>
				<LABEL for="TGExistingComments"><%=UIUtil.toHTML((String)rbWorkspace.get("ExistingComments"))%>
				</LABEL>
			</TD>
		</TR>
		<TR style="width:100%">
			<TD>
				<TEXTAREA READONLY style="background-color:#EFEFEF; overflow :auto; width:95%" ID="TGExistingComments" NAME=TGExistingComments ROWS=10 WRAP="HARD" ></TEXTAREA>
			</TD>
		</TR>
		<TR HEIGHT=10></TR>
		
		<!-- New comments -->
		<TR>
			<TD>
				<LABEL for="TGNewComments"><%=UIUtil.toHTML((String)rbWorkspace.get("NewComments"))%>
				</LABEL>
			</TD>
		</TR>
		<TR style="width:100%">
			<TD>
				<TEXTAREA ID="TGNewComments" NAME=TGNewComments ROWS=16 WRAP="HARD" style="overflow :auto; width:95%"></TEXTAREA>
			</TD>
		</TR>
		
		
	</TABLE>
 
</BODY>
</HTML>
