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
<%@ include file="LiveHelpCommon.jsp" %>

<%
try
{
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fLiveHelpHeader%>

<script>
/**
 * sets Customer Care Queue information in applet.
 * @param strCfg java.lang.String
 */
 function setQueueConfiguration (strCfg)
{
	CCAGENTFRAME.setQueueConfiguration(strCfg);
}

/**
 * sets Customer Care Monitoring list information in applet.
 * @param strCfg java.lang.String
 */
function setMonitoringConfiguration (strCfg)
{
	CCAGENTFRAME.setMonitoringConfiguration(strCfg);
}

/**
 * sets Customer Care Site URL list information in applet.
 * @param strCfg String
 */
function setSiteURLConfiguration (strCfg)
{
	CCAGENTFRAME.setSiteURLConfiguration(strCfg);
}

/**
 * sets Customer Care Store URL list information in applet.
 * @param strCfg String
 */
function setStoreURLConfiguration (strCfg)
{
	CCAGENTFRAME.setStoreURLConfiguration(strCfg);
}

/**
 * sets Customer Care Store question list information in applet.
 * @param strCfg String
 */
function setStoreQuestionConfiguration (strCfg)
{
	CCAGENTFRAME.setStoreQuestionConfiguration(strCfg);
}

/**
 * start initialize Customer Care information 
 */

function initAgentApplet ()
{
	CCAGENTFRAME.initAgentApplet(false);
}

/**
 * refresh CCINFARME frame with new URL.
 * @param newLocation String
 */

function getCCInformation (newLocation)
{
	CCINFOFRAME.document.location.href=newLocation;
}
</script>
<title><%=(String)liveHelpNLS.get("customerCarePageTitleAgentFrameset")%></title>
</head>
<frameset rows="1,*" id="WC_CCAgentFrameSetPage_Frameset_1">
	<frame name="CCINFOFRAME" id="WC_CCAgentFrameSetPage_Frame_1"
		title='<%=UIUtil.toHTML((String)liveHelpNLS.get("customerCareFrameTitleConfig"))%>'
		src="<%=sWebAppPath%>CCAgentBlankPageView" marginwidth="0"
		scrolling="no" frameborder="0" noresize="noresize" />
	<frame name="CCAGENTFRAME" id="WC_CCAgentFrameSetPage_Frame_2"
		title='<%=UIUtil.toHTML((String)liveHelpNLS.get("customerCareFrameTitleApplet"))%>'
		src="<%=sWebAppPath%>LiveHelpAgentLoginView" marginwidth="0"
		scrolling="no" frameborder="0" noresize="noresize" />
</frameset>
</html>
<%
}
catch(Exception e)
{
  ExceptionHandler.displayJspException(request, response, e);
}
%>
