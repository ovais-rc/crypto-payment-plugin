<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
--%>
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.CCQueueDataBean" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.commands.ECLivehelpConstants" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="LiveHelpCommon.jsp" %>

<%
CommandContext cmdcontext = 
   (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
JSPHelper jhelper = new JSPHelper(request);
String storeId = jhelper.getParameter("storeId");
String languageId =cmdcontext.getLanguageId().toString(); 

// Create XML string
String strCfg=ECLivehelpConstants.EC_CC_XML_HEADER	
			+ LiveHelpConfiguration.getOpenTagString(ECLivehelpConstants.EC_CC_XML_ROOT)
			+ LiveHelpConfiguration.getOpenTagString(ECLivehelpConstants.EC_CC_XML_QUEUES);
			try {
				CCQueueDataBean qDB=new CCQueueDataBean();
				DataBeanManager.activate(qDB, request);
				Vector vqDBs= qDB.getStoreQueues();		
				for (int nIdx=0; nIdx <vqDBs.size(); nIdx++) {
					qDB=(CCQueueDataBean) vqDBs.get(nIdx);
					qDB.refreshDisplayInformation(languageId);
					Vector vCSRs=qDB.getAssignedCSRInformation();
					strCfg= strCfg
						+ LiveHelpConfiguration.getQueueElementString(qDB.getQueueId(),
						qDB.getQueueDisplayName(),
						qDB.getQueueDescription(), 
						qDB.getAllCSRs());
					if (qDB.getAllCSRs().equals(ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED) && vCSRs!=null && vCSRs.size()>0 ) {
						for (int nIdx2=0; nIdx2<vCSRs.size();nIdx2++) {
							Hashtable htCSRInfo=(Hashtable) vCSRs.get(nIdx2);
							String CSRLogonId=(String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_LOGONID_UID);
							String CSRId=(String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_CSRID);
							strCfg= strCfg
								+ LiveHelpConfiguration.getCSRElementString(CSRId,CSRLogonId);
							strCfg= strCfg
							+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_CSR);
						}	// end for
					}	// end if
			strCfg= strCfg
					+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_QUEUE);
				}	// end for
			} catch (Exception e) {
				ECTrace.trace(
					ECTraceIdentifiers.COMPONENT_COLLABORATION,
					this.getClass().getName(),
					"CCQueueList.jsp",
					e.toString());
			
			}
	strCfg=	strCfg
		+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_QUEUES)
		+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_ROOT);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<title><%=(String)liveHelpNLS.get("customerCarePageTitleAgentQueueList")%></title>
</head>
<body class="content"
	onload="parent.setQueueConfiguration('<%=UIUtil.toHTML(strCfg)%>');">
</body>
</html>
