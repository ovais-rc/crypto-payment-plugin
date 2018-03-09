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
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.messaging.databeans.CISEditAttDataBean" %>
<%@ page import="com.ibm.commerce.messaging.databeans.TransportDataBean" %>
<%@ page import="com.ibm.commerce.messaging.util.MessagingSystemConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.exception.ECSystemException" %>
<%@ page import="com.ibm.commerce.exception.ExceptionHandler" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<jsp:useBean id="csParameters" scope="request" class="com.ibm.commerce.messaging.databeans.CISEditAttDataBean"></jsp:useBean>
<jsp:useBean id="transportList" scope="request" class="com.ibm.commerce.messaging.databeans.TransportDataBean"></jsp:useBean>

<%
JSPHelper jspHelper	= new JSPHelper(request);
String store_id 	= jspHelper.getParameter(MessagingSystemConstants.TC_STORETRANS_STORE_ID);
String transport_id 	= jspHelper.getParameter(MessagingSystemConstants.TC_STORETRANS_TRANSPORT_ID);
String profile_id 	= jspHelper.getParameter(MessagingSystemConstants.TC_PROFILE_PROFILE_ID);
String msgtype_id 	= jspHelper.getParameter(MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID);
String deviceformat_id 	= jspHelper.getParameter(MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID);
String lowpriority	= jspHelper.getParameter(MessagingSystemConstants.TC_PROFILE_LOWPRIORITY);
String highpriority 	= jspHelper.getParameter(MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY);

Hashtable messagingNLS = null;
int numberOfCSParameters = 0;
String transport_name 	= null;

CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

try {
	// obtain the resource bundle for display
	messagingNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.MsgMessagingNLS", cmdContext.getLocale());

	DataBeanManager.activate(csParameters, request);

	if ( (transport_id != null) && (!transport_id.equals("")) ) {
		transportList.setTransport_ID(new Integer(transport_id));
	}
	
	DataBeanManager.activate(transportList, request);
	// there should only be one element
	if (transportList.getSize() > 0) {
		transport_name = transportList.getName(0);
	}

} catch (ECSystemException ecSysEx) {
	ExceptionHandler.displayJspException(request, response, ecSysEx);
} catch (Exception exc) {
	ExceptionHandler.displayJspException(request, response, exc);
}


if (csParameters != null)
{
	numberOfCSParameters = csParameters.numberOfElements();
}
%>

<HTML>
<HEAD>
<%= fHeader%>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<TITLE><%= messagingNLS.get("messageTypeConfigTitle") %></TITLE>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function lengthValidation( param ) {
	if (!parent.isValidUTF8length(param.value, 254)) {
		param.focus();
		param.select();
		alertDialog('<%=UIUtil.toJavaScript(messagingNLS.get("messageTypeConfigExceedMaxLength"))%>');
		return false;
	}
	return true;
}

function convertParametersToXML() {
	parent.remove('CSEDITATT');
	parent.remove('ISEDITATT');
	// declare variables
	var CSEDITATT = new Object();
	var ISEDITATT = new Object();

	CSEDITATT.store_id = "<%= UIUtil.toJavaScript(store_id) %>";
	CSEDITATT.transport_id = "<%= UIUtil.toJavaScript(transport_id) %>";
	CSEDITATT.profile_id= "<%= UIUtil.toJavaScript(profile_id) %>";
	ISEDITATT.profile_id= "<%= UIUtil.toJavaScript(profile_id) %>";

<%
	int CS_Index = 0;
	int IS_Index = 0;
	String objName = null;
	// assign variable values
	for (int i= 0 ; i < numberOfCSParameters ; i++)
	{
		if ( csParameters.getOrigin(i).equals("CS") ) {
			objName = "CSEDITATT";
			CS_Index++;
      		} else {
			objName = "ISEDITATT";
			IS_Index++;
		}
		%>

		<%
		if ( !csParameters.getOrigin(i).equals("CS") && !csParameters.getName(i).equals("host") && !csParameters.getName(i).equals("protocol") ) {
		%>
			if (!lengthValidation(messagingForm.<%= csParameters.getName(i) %>))
				return false;
		<%
		}
		%>	
			
		<%
		if ( csParameters.getOrigin(i).equals("CS") ) {
		%>
			<%= objName %>.<%= csParameters.getName(i) %> = new Object();
			<%= objName %>.<%= csParameters.getName(i) %>.cseditatt_id = "<%= csParameters.getID(i) %>";
		<%
		} else {
		%>
			<%= objName %>.<%= csParameters.getName(i) %> = new Object();
			<%= objName %>.<%= csParameters.getName(i) %>.iseditatt_id = "<%= csParameters.getID(i) %>";
		<%
		}
		%>
		
		<%
		if ( !csParameters.getOrigin(i).equals("CS") && !csParameters.getName(i).equals("host") && !csParameters.getName(i).equals("protocol") ) {
		%>
			<%= objName %>.<%= csParameters.getName(i) %>.value = messagingForm.<%= csParameters.getName(i) %>.value;
		<%
		} else {
		%>
			<%= objName %>.<%= csParameters.getName(i) %>.value = "<%= csParameters.getValue(i) %>";
		<%
		}
	}
	if (CS_Index > 0) {
	%>
		parent.put('CSEDITATT', CSEDITATT);
	<%
	}
	if (IS_Index > 0) {
	%>
		parent.put('ISEDITATT', ISEDITATT);
	<%
	}
	%>
	return true;
}


function validatePanelData() {
	var PROFILE = new Object();
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_STORE_ID %> 		= "<%= UIUtil.toJavaScript(store_id) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_TRANSPORT_ID %> 	= "<%= UIUtil.toJavaScript(transport_id) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_PROFILE_ID %> 		= "<%= UIUtil.toJavaScript(profile_id) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_MSGTYPE_ID %> 		= "<%= UIUtil.toJavaScript(msgtype_id) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_DEVICEFORMAT_ID %> 	= "<%= UIUtil.toJavaScript(deviceformat_id) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_LOWPRIORITY %> 		= "<%= UIUtil.toJavaScript(lowpriority) %>";
	PROFILE.<%= MessagingSystemConstants.TC_PROFILE_HIGHPRIORITY %> 	= "<%= UIUtil.toJavaScript(highpriority) %>";
	parent.put('PROFILE', PROFILE);
	return convertParametersToXML();
}


function loadPanelData()
{
	if (parent.setContentFrameLoaded)
	{
		parent.setContentFrameLoaded(true);
	}
}

// -->
</script>

</HEAD>
<BODY ONLOAD="loadPanelData();"  class="content">
<H1><%= messagingNLS.get("messageTypeConfigTitle") %></H1>


<FORM NAME="messagingForm">
<%
if (numberOfCSParameters > 0) {
	%>
	<table class="list" width="75%"
	summary="<%= messagingNLS.get("messageTypeConfigTableDesc") %>">

	<TR class="list_roles">
	<TD class="list_header" id="col1">
	<nobr>&nbsp;&nbsp;&nbsp;<%= messagingNLS.get("messageTypeConfigParameterColumn") %>&nbsp;&nbsp;&nbsp;</nobr>
	</TD>

	<TD width="100%" class="list_header" id="col2">
	<nobr>&nbsp;&nbsp;&nbsp;<%= messagingNLS.get("messageTypeConfigValueColumn") %>&nbsp;&nbsp;&nbsp;</nobr>
	</TD>


	</TR>

	<%
	String classId = "list_row1";
	int endIndex = numberOfCSParameters;

	for (int i= 0 ; i<endIndex ; i++)
	{
		// host and protocol parameters are not configurable for hosted stores
		if ( !csParameters.getName(i).equals("host") && !csParameters.getName(i).equals("protocol") ) { %>
			<TR class=<%=classId%>>
			<TD class="list_info1" align="left" id="row<%=i%>" headers="col1">
			<nobr>&nbsp;<LABEL for="input<%=i%>"><%= (messagingNLS.get(csParameters.getName(i)) != null)? messagingNLS.get(csParameters.getName(i)): csParameters.getName(i) %></LABEL>&nbsp;</nobr>
			</TD>
			<TD class="list_info1" align="left" headers="col2 row<%=i%>">
			&nbsp;<INPUT NAME="<%= csParameters.getName(i) %>" VALUE="<%= csParameters.getValue(i) %>" SIZE="50" id="input<%=i%>">&nbsp;
			</TD>
			</TR>
		<%
		}
		if (classId.equals("list_row1")) {
			classId="list_row2";
		} else {
			classId="list_row1";
		}
	}
	%>
	</TABLE>
	<%
} else {
	%>
	<BLOCKQUOTE>&nbsp;&nbsp;&nbsp;&nbsp;
	<%= messagingNLS.get("messagingTransportConfigureNoAvail") %>
	</BLOCKQUOTE></p><p>&nbsp;</p>
<%
}
%>

</FORM>
</BODY>
</HTML>
