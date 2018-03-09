<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.emarketing.beans.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.exception.ECApplicationException" %>
<%@ page import="com.ibm.commerce.exception.ECSystemException" %>

<%@include file="../common/common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="EmailActivityCommon.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<meta http-equiv="Content-Type" content="text/html" />
<title><%= emailActivityRB.get("emailActivitySummaryDialogTitle") %></title>

<%  
    String emailActivityId = request.getParameter("emailActivityId");
    EmailActivitySummaryDataBean easdb = new com.ibm.commerce.emarketing.beans.EmailActivitySummaryDataBean(); 
    easdb.setId(new Integer(emailActivityId));
    DataBeanManager.activate(easdb, request);
%>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

//-->

</script>

</head>

<body class="content" onload="loadPanelData();">
<h1><%= emailActivityRB.get("emailActivitySummaryDialogTitle") %></h1>

<table border="0">
	<tbody>
	        <tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("asOf") %> <%=TimestampHelper.getDateTimeFromTimestamp(TimestampHelper.getCurrentTime(), jLocale) %></td> 
		        <td></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td>&nbsp</td>
		        <td></td>
		</tr>	
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("name") %>:</td> 
			<td align="left"><%= UIUtil.toHTML(easdb.getName()) %></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("description") %>:</td>
			<td align="left"><%= UIUtil.toHTML(easdb.getDescription()) %></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("campaign") %>:</td>
			<td align="left"><%= UIUtil.toHTML(easdb.getCampaignName()) %></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("emailTemplate") %>:</td> 
			<td align="left"><%= UIUtil.toHTML(easdb.getMessageContentName()) %></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("emailProfile") %>:</td>
			<% if (easdb.isCustomerProfileExist() ){
			%>
			<td align="left"><%= UIUtil.toHTML(easdb.getMemberGroupName()) %></td>		
			<%} else{ %>
			<td align="left"><%= emailActivityRB.get("CustomerProfileDeleted") %></td>
			<%}%>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("emailReplyTo") %>:</td>
			<td align="left"><%= UIUtil.toHTML(easdb.getReplyTo()) %></td>		
			
		</tr>
		<% if(easdb.getStatus().intValue() == com.ibm.commerce.emarketing.objimpl.EmailPromotionEntityBase.SENT_INTEGER.intValue()){
		%>   
		<TR>
			<TD width="20"></TD>
			<TD><%= emailActivityRB.get("sentTime") %>:</TD>
			<TD align="left"><%= TimestampHelper.getDateTimeFromTimestamp(easdb.getDeliveryDate(), jLocale) %></TD>		
			
		</TR>
		
		<%}
		%>
    </tbody>
</table>    

<% if(easdb.getStatus().intValue() != com.ibm.commerce.emarketing.objimpl.EmailPromotionEntityBase.SENT_INTEGER.intValue()){
%>   
<p>
<%=emailActivityRB.get("unsentMessage") %>
<% 
String timeToSend = (String) emailActivityRB.get("timeToSend");
int oneIndex = timeToSend.indexOf("%1");
timeToSend = timeToSend.substring(0,oneIndex) + TimestampHelper.getDateTimeFromTimestamp(easdb.getDeliveryDate(), jLocale) + timeToSend.substring(oneIndex+2);   
%>
<%=timeToSend %>
<%
}else {
%>
<br />
</p><table border="0">
	<tbody>		
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("numberOfAtmptRcpt") %>:</td>
			<td align="right"><%=easdb.getTotalNumOfAttemptedUser() %></td>
			<td></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("numberOfFailed") %>:</td>
			<td align="right"><%=easdb.getNumBounced() %></td>
			<td>(<%=easdb.getPercentageBounced() %><%= emailActivityRB.get("percentage") %>)</td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("numberOfRcpt") %>:</td>
			<td align="right"><%=easdb.getNumberOfAssumeReceived() %></td>
			<td>(<%=easdb.getPercentageAssumeReceived() %><%= emailActivityRB.get("percentage") %>)</td>
		</tr>
		<tr>
			<td width="20"></td>
			<td>&nbsp</td>
			<td align="right"></td>
			<td></td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("numberOfOpened") %>:</td>
			<td align="right"><%=easdb.getNumOpened() %></td>
			<td>(<%=easdb.getPercentageOpened() %><%= emailActivityRB.get("percentage") %>)</td>
		</tr>
		<tr>
			<td width="20"></td>
			<td><%= emailActivityRB.get("numberOfClicked") %>:</td>
			<td align="right"><%=easdb.getNumClicked() %></td>
			<td>(<%=easdb.getPercentageClicked() %><%= emailActivityRB.get("percentage") %>)</td>
		</tr>
	</tbody>
</table>

<% } %>
<p></p>
</body>
</html>
