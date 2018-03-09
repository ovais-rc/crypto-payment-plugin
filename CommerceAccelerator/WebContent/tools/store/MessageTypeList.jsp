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
// 020723	    KNG		Initial Create
//
// 020815	    KNG		Make changes from code review
////////////////////////////////////////////////////////////////////////////////
--%>

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.messaging.databeans.ProfileDataBean" %>
<%@ page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>


<%@include file="../common/common.jsp" %>

<jsp:useBean id="messagingList" scope="request" class="com.ibm.commerce.messaging.databeans.ProfileDataBean">
</jsp:useBean>

<%
Hashtable messagingNLS = null;
int numberOfMessageProfiles = 0;
Integer store_id = null;
CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
store_id = cmdContext.getStoreId();

JSPHelper URLParameters	 = new JSPHelper(request);
int startIndex 	= Integer.parseInt(URLParameters.getParameter("startindex"));

try {
	// obtain the resource bundle for display
	messagingNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", cmdContext.getLocale());
	
	messagingList.setStore_ID(store_id);
	DataBeanManager.activate(messagingList, request);

} catch (ECSystemException ecSysEx) {
	ExceptionHandler.displayJspException(request, response, ecSysEx);
} catch (Exception exc) {
	ExceptionHandler.displayJspException(request, response, exc);
}

if (messagingList != null)
{
	numberOfMessageProfiles = messagingList.getSize();
}
%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%= messagingNLS.get("messageTypeTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getResultsSize() { 
	return <%= numberOfMessageProfiles  %>; 
}

function configure()
{
	var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=store.messageTypeConfig&amp;<%=MessagingSystemConstants.TC_PROFILE_STORE_ID%>=<%=store_id%>";

	var checked = parent.getChecked();
	if (checked.length > 0)
	{
		if ( checked[0] == "select_deselect" ) {
			alertDialog("<%= UIUtil.toJavaScript((String) messagingNLS.get("messageTypeListNoConfigure")) %>");
			return;
		}
		url += "&amp;" +  checked[0];
	}
	else {
		return;
	}
	
	if (top.setContent)
	{
		top.setContent("<%= UIUtil.toJavaScript((String) messagingNLS.get("messageTypeListConfigureBCT")) %>",
				url,
				true);		
	}
	else
	{
		parent.location.replace(url);
	}
}

function changeMessageTransportBySelect(item)
{
	var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=store.messageTypeConfig&amp;<%=MessagingSystemConstants.TC_PROFILE_STORE_ID%>=<%=store_id%>";
	url += "&amp;" +  item;
  	
	if (top.setContent)
	{
		top.setContent("<%= UIUtil.toJavaScript((String) messagingNLS.get("messageTypeListConfigureBCT")) %>",
				url,
				true);
	}
	else
	{
		parent.location.replace(url);
	}
}

function onLoad()
{
	parent.loadFrames();
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
</HEAD>
<BODY class="content" ONLOAD="onLoad()">
<%
int listSize = Integer.parseInt(URLParameters.getParameter("listsize"));
int endIndex = startIndex + listSize;
if (endIndex > numberOfMessageProfiles) {
	endIndex = numberOfMessageProfiles;
}
int totalsize = numberOfMessageProfiles;
int totalpage = totalsize/listSize;
	
%>
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("store.messageTypeList", totalpage, totalsize, cmdContext.getLocale() )%>

<FORM NAME="MessageTypeForm">
<%
if (numberOfMessageProfiles > 0) {
%>
	<INPUT TYPE='hidden' NAME='name' VALUE=''>
	<INPUT TYPE='hidden' NAME='description' VALUE=''>

	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)messagingNLS.get("messageTypeListDesc")) %>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading(false, null) %>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingNLS.get("messageTypeListName"), null, false )%>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)messagingNLS.get("messageTypeListTransport"), null, false )%>
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

	<%
	int rowselect=1;
	StringBuffer chkbox_name = null;
	StringBuffer viewAction = null;
	for (int i=startIndex; i<endIndex ; i++)
	{
		chkbox_name = new StringBuffer();
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_PROFILE_ID);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getProfile_ID(i));
		chkbox_name.append("&amp;");
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getTransport_ID(i));
		chkbox_name.append("&amp;");
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getMsgType_ID(i));
		chkbox_name.append("&amp;");
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getDeviceFormat_ID(i));
		chkbox_name.append("&amp;");
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_LOWPRIORITY);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getLowPriority(i));
		chkbox_name.append("&amp;");
		chkbox_name.append(MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY);
		chkbox_name.append("=");
		chkbox_name.append(messagingList.getHighPriority(i));
		%>

		<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
		<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name.toString(), "none" ) %>
		<%
		viewAction = new StringBuffer();
		viewAction.append("javascript:changeMessageTransportBySelect('");
		viewAction.append(chkbox_name.toString());
		viewAction.append("');");
		%>
		<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingNLS.get(messagingList.getMsgTypeName(i)) != null)? (String)messagingNLS.get(messagingList.getMsgTypeName(i)) : messagingList.getMsgTypeName(i)), viewAction.toString()) %> 
		<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((messagingNLS.get(messagingList.getTransportName(i)) != null) ? (String) messagingNLS.get(messagingList.getTransportName(i)) : messagingList.getTransportName(i)), "none" ) %> 
		<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

		<%
		if(rowselect==1)
		{
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
	%>
	
	<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

<%
} else {
	out.println("<p>&nbsp;</p><p><blockquote>");
	out.println(messagingNLS.get("messageTypeListNoAvail"));
	out.println("</blockquote></p>");
}
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>
