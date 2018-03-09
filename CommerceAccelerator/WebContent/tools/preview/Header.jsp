<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<%@include file="../common/common.jsp" %> 
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.context.content.ContentContext" %>  
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.context.preview.PreviewContext" %>
<%@page import ="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>
<%@page import ="com.ibm.commerce.context.base.Context" %>
<%@page import ="com.ibm.commerce.content.preview.command.CMWSPreviewSetupCmdImpl" %>
<%@page import ="com.ibm.commerce.server.JSPHelper" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.util.Date" %>

<%  
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  PreviewContext previewCtxt = (com.ibm.commerce.context.preview.PreviewContext) cmdContext.getContext("com.ibm.commerce.context.preview.PreviewContext");
  String webalias = UIUtil.getWebPrefix(request);
  StoreAccessBean storeInfo = cmdContext.getStore();
  String storeIdentifier = storeInfo.getIdentifier();
  Timestamp  previewStartTimeStamp = previewCtxt.getTimestamp();
  String previewSpaceDesc  = null;
  String PreviewTimeStatus = null;
  String PreviewInvDesc = null;
  String previewWorkspace = null;
  String previewStartTime = null;
  String previewRollTime=null;
  String PreviewInvStatusTitle=null;
  int startHour = previewStartTimeStamp.getHours();
  int startMin = previewStartTimeStamp.getMinutes();
  int startSec = 0;
  int startYear=1900+previewStartTimeStamp.getYear(); 
  int startMonth=previewStartTimeStamp.getMonth()+1;
  int startDay=previewStartTimeStamp.getDate();
 
  Hashtable previewNLS = (Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale());      
  
  String  previewYear = UIUtil.toHTML((String)previewNLS.get("PreviewYear"));
  String  previewMonth = UIUtil.toHTML((String)previewNLS.get("PreviewMonth"));
  String  previewDay = UIUtil.toHTML((String)previewNLS.get("PreviewDay"));
  String  previewHour = UIUtil.toHTML((String)previewNLS.get("PreviewHour"));
  String  previewMinute = UIUtil.toHTML((String)previewNLS.get("PreviewMinute"));
  String  previewSecond = UIUtil.toHTML((String)previewNLS.get("PreviewSecond"));

  JSPHelper helper= new JSPHelper(request);
  
  String startTime = helper.getParameter(CMWSPreviewConstants.SCHED_START_TIME);
  boolean status = Boolean.valueOf(helper.getParameter(CMWSPreviewConstants.PRVW_TIME_STATUS)).booleanValue();
  int invStatus = Integer.valueOf(helper.getParameter(CMWSPreviewConstants.PRVW_INVCONST_TYPE)).intValue(); 
   
  try {
	  
	  previewStartTime = UIUtil.toHTML((String)previewNLS.get("PreviewStartTimeMsg")); // + startTime; 

   	  com.ibm.commerce.context.content.ContentContext ctx = (com.ibm.commerce.context.content.ContentContext) cmdContext.getContext("com.ibm.commerce.context.content.ContentContext"); 
	  if (ctx != null) {
		  previewWorkspace = ctx.getWorkspace();
	  }
	  if (previewWorkspace != null) {
	  		previewSpaceDesc = UIUtil.toHTML((String)previewNLS.get("PreviewContextWrkspc")) + previewWorkspace;
	  } else {
	  		previewSpaceDesc = UIUtil.toHTML((String)previewNLS.get("PreviewContextBase")) ;	  
	  }
	
	  if (status == true){
	  		PreviewTimeStatus = UIUtil.toHTML((String)previewNLS.get("PreviewTimeStatusStatic"));
	  }		
	  else {
	  		PreviewTimeStatus = UIUtil.toHTML((String)previewNLS.get("PreviewTimeStatusRolling"));
	  }

	  if (invStatus == -1){
	  		PreviewInvDesc = UIUtil.toHTML((String)previewNLS.get("PreviewInvStatusDupWthCnst"));
	  }	else if (invStatus == 1){
	  		PreviewInvDesc = UIUtil.toHTML((String)previewNLS.get("PreviewInvStatusDupWthoutCnst"));
	  }	else if (invStatus == 0){
	  		PreviewInvDesc = UIUtil.toHTML((String)previewNLS.get("PreviewInvStatusReal"));
	  }
	  PreviewInvStatusTitle = UIUtil.toHTML((String)previewNLS.get("PreviewInvStatusTitle")); 
	  	  		
  }
  catch (Exception e){
   System.out.println("Inside the exception block.............." + e);
  }
  
%>  

<HTML>
<HEAD>
<script LANGUAGE="JavaScript">
<!-- Begin
// time origin
var clientTime = new Date();

function checkYear(year) { 
return (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) ? true : false;
}
function funClock() {
var daysmonth=new Array("0","31","28","31","30","31","30","31","31","30","31","30","31");

if (!document.layers && !document.all)
return;
var runTime = new Date();
var hours = <%= startHour %> + runTime.getHours() - clientTime.getHours();
var minutes = <%= startMin %> + runTime.getMinutes() - clientTime.getMinutes();
var seconds = <%= startSec %> + runTime.getSeconds() - clientTime.getSeconds();
var year=<%= startYear %> + runTime.getFullYear() - clientTime.getFullYear();
var day=<%= startDay %> + runTime.getDate() - clientTime.getDate();
var month=<%= startMonth %> + runTime.getMonth() - clientTime.getMonth();

if (checkYear(year)){
daysmonth[2]="29";
}

if(seconds < 0){
seconds=seconds+60;
minutes--;
}
if(minutes < 0){
minutes=minutes+60;
hours--;
}
if (hours < 0) {
hours = hours+24;
day--;
}
if(seconds >= 60){
seconds=seconds-60;
minutes=minutes + 1;
}
if(minutes >= 60){
minutes=minutes-60;
hours=hours+1;
}
if (hours >= 24) {
hours = hours-24;
day=day+1;
}
if (day > daysmonth[month] ) {
	day=day-daysmonth[month];
	month=month+1;
}
if (month > 12){
	month=month-12;
	year=year+1;
}
if (month<10)
month="0"+month;
if (day<10)
day="0"+day;

hours=((hours < 10) ? "0" : "") + hours ;
minutes=((minutes < 10) ? "0" : "") + minutes ;
seconds=((seconds < 10) ? "0" : "") + seconds ;

movingtime = hours + ":" + minutes + ":" + seconds;
movingdate = year+"/"+month+"/"+day;

<% if (status == false) { %>
if (document.layers) {
document.layers.prdate.document.write(movingdate);
document.layers.prtime.document.write(movingtime);
document.layers.prdate.document.close();
document.layers.prtime.document.close();
}
else if (document.all) {
prdate.innerText = movingdate;
prtime.innerText = movingtime;
}
<%}%>
setTimeout("funClock()", 1000)
}
window.onload = funClock;
//  End -->
</script>
<TITLE>Store Preview</TITLE> 
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<style type="text/css">

	BODY { font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black; margin: 0 0 0 0; padding: 0 0 0 0; background-color: EFEFEF; word-wrap: break-word; scrollbar-arrow-color: #552BA1; scrollbar-3dlight-color: #552BA1; scrollbar-face-color: #EDEDED; scrollbar-track-color: #CFCECF;}
	TABLE.content { margin-left: 10pt; margin-top: 10pt; font-family: Verdana; font-size: 10pt; color: Black; word-wrap: break-word;}
	H1 { font-family: Verdana,Arial,Helvetica; font-size: 15pt; color: #565665; font-weight: normal; word-wrap: break-word; }
		.stripe_bk {background-image: url("<%=webalias%>images/tools/catalog/preview_stripe.gif");  background-repeat: repeat-x; background-color: #EFEFEF;}
	

</style>
</HEAD>
<BODY  class="stripe_bk" onload="funClock()">
<table class="content"><TBODY>
<tr><td>&nbsp;</td></tr>
<tr><td>
<b><%= previewStartTime %>&nbsp;&nbsp;(<%= previewYear %>/<%= previewMonth %>/<%= previewDay %>&nbsp;<%= previewHour %>:<%= previewMinute %>:<%= previewSecond %>):&nbsp;&nbsp;</b><%= UIUtil.toHTML(startTime)%><br>
<b><%=PreviewInvStatusTitle %></b>&nbsp;<%= PreviewInvDesc %><br>
<b><%= PreviewTimeStatus %></b>&nbsp;
        <%  if (status == false) {%>              
<!--        <label id=prdate style="color: #552BA1;text-color: #552BA1" color="#552BA1"></label> -->
        <b>(<%= previewYear %>/<%= previewMonth %>/<%= previewDay %>&nbsp;<%= previewHour %>:<%= previewMinute %>:<%= previewSecond %>):&nbsp;</b>
        <span id=prdate></span>&nbsp;
        <span id=prtime></span>
		<%} %>  
		</td></tr></TBODY>
		</table>
</BODY>	
</HTML>

