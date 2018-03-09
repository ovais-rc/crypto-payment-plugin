<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../common/common.jsp" %>

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>

<%@ page import="com.ibm.commerce.scheduler.beans.*" %>

<jsp:useBean id="urlItems" scope="request" class="com.ibm.commerce.scheduler.beans.UrlRegistryItemsDataBean">
</jsp:useBean>
<jsp:useBean id="schedulerItems" scope="request" class="com.ibm.commerce.scheduler.beans.SchedulerItemsDataBean">
</jsp:useBean>
<jsp:useBean id="appTypeItems" scope="request" class="com.ibm.commerce.scheduler.beans.ApplicationTypeDataBean">
</jsp:useBean>


<%
  String webalias = UIUtil.getWebPrefix(request);
  String fixedTime =  request.getParameter("fixedTime");
  if (fixedTime == null) fixedTime = "0";  
  String calendarText = new String("");
  Integer store_id = null;
  Hashtable schedulerNLS = null;
  Hashtable adminconsoleNLS = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();
  String add_job_result_page = request.getParameter("RESULTPAGE");
  if (add_job_result_page == null ) add_job_result_page = "";
  String jobId = request.getParameter("jobId");
  if (jobId == null) jobId = "";
  String pathInfo =  request.getParameter("pathInfo");
  if (pathInfo == null) pathInfo = "";
  String queryString =  request.getParameter("queryString");
  if (queryString == null) queryString = "";
  String description = request.getParameter("description");
  if(description == null) description = "";
  String start =  request.getParameter("start");
  if (start == null) start = "";
  String host =  request.getParameter("host");
  if (host == null) host = "";
  String interval =  request.getParameter("interval");
  if (interval == null) interval = "";
  String attempts =  request.getParameter("attempts");
  if (attempts == null) attempts = "";
  String delay =  request.getParameter("delay");
  if (delay == null) delay = "";
  String policy =  request.getParameter("schedulerPolicy");
  if (policy == null) policy = "";
  String priority =  request.getParameter("priority");
  if (priority == null) priority = "";
  String applicationType =  request.getParameter("applicationType");
  if (applicationType == null) applicationType = "";
  String name =  request.getParameter("name");
  if (name == null) name = "";
  
  String startYear = request.getParameter("startYear");
  if (startYear == null) startYear = "";
  String startMonth = request.getParameter("startMonth");
  if (startMonth == null) startMonth = "";
  String startDay = request.getParameter("startDay");
  if (startDay == null) startDay = "";
  String startTime = request.getParameter("startTime");
  if (startTime == null) startTime = "";

   try {
      // obtain the resource bundle for display
      calendarText = (String)((Hashtable)ResourceDirectory.lookup("campaigns.campaignsRB", cmdContext.getLocale())).get("calendarTool");
      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
      adminconsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
      if (jobId != null && !jobId.equals("") & add_job_result_page.equals("")) {
          schedulerItems.setJobRefNum(jobId);
          DataBeanManager.activate(schedulerItems, request);
          if (pathInfo.equals("")) pathInfo = schedulerItems.getPathInfo(0);
          if (queryString.equals("")) queryString = schedulerItems.getQueryString(0);
          if (description.equals("")) description = schedulerItems.getDescription(0);
          if (!queryString.equals("")) {
              if (queryString.contains("fixedTime=1")) {
                  fixedTime="1";
                  String matchString = "fixedTime=1";
                  int length = 11;
                  if (queryString.contains("&fixedTime=1")) {
                  	matchString = "&fixedTime=1"; 
                  	length = 12;  
                  }
                  queryString = queryString.substring(0,queryString.lastIndexOf(matchString))+ 
                  	queryString.substring(queryString.lastIndexOf(matchString) + length);          
              } 
          } 
          if (start.equals("")) start = schedulerItems.getStart(0);
          if (host.equals("")) host = schedulerItems.getHost(0);
          if (interval.equals("")) interval = schedulerItems.getInterval(0);
          if (attempts.equals("")) attempts = schedulerItems.getAttempts(0);
          if (delay.equals("")) delay = schedulerItems.getDelay(0);
          if (policy.equals("")) policy = schedulerItems.getSequence(0);
          if (priority.equals("")) priority = schedulerItems.getPriority(0);
          if (applicationType.equals("")) applicationType = schedulerItems.getApplicationType(0);
          if (name.equals("")) name = schedulerItems.getUserReferenceNumber(0);
                    
      } else DataBeanManager.activate(urlItems, request);
      
      // if the start is invalid, they will have to enter it.
      try {      
      	if (start != null && !start.equals("")) {
          Timestamp sTIME = Timestamp.valueOf(start);
          startYear = new String(""+(1900 + sTIME.getYear()));
          startMonth = new String(""+(sTIME.getMonth()+1));
          startDay = new String(""+sTIME.getDate());
          
          if (sTIME.getHours() < 10)
  	 	startTime = "0" + sTIME.getHours();
  	  else
  	 	startTime = "" + sTIME.getHours();
  	 	
  	  if (sTIME.getMinutes() < 10)
  	 	startTime = startTime + ":0" + sTIME.getMinutes();
  	  else
  	 	startTime = startTime + ":" + sTIME.getMinutes();          
      	}
      } catch (Exception e) {}
      
      DataBeanManager.activate(appTypeItems, request);
   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

%>

<HTML>
<HEAD>
<%= fHeader %>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<TITLE><%= (jobId != null && !jobId.equals("")) ? schedulerNLS.get("schedulerEditTitle") : schedulerNLS.get("schedulerAddTitle") %></TITLE>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!---- //hide script from old browsers
       //

      function lengthValidation( param, length ) {
          if (!parent.isValidUTF8length(param.value, length)) {
               param.focus();
               param.select();
               alertDialog('<%=UIUtil.toJavaScript(adminconsoleNLS.get("AdminConsoleExceedMaxLength"))%>');
               return false;
          }
          return true;
      }      
       
    function validatePanelData() {

          // building the URL
          var params = '';
          var pathInfo = '';
          var start = '';

          start = schedulerForm.startYear.value + ":" +  schedulerForm.startMonth.value + ":" + schedulerForm.startDay.value + ":" + schedulerForm.startTime.value + ":00";

          // commands that must be specified
          if (schedulerForm.pathInfo.value == '') {
               alertDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerPathInfoMissing")) %>');
               return false;
          } else {
               pathInfo = '&pathInfo=' + schedulerForm.pathInfo.value
          }
          if (schedulerForm.startTime.value == '') {
               alertDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerStartMissing")) %>');
               return false;
          } else {
          	document.schedulerForm.start.value = start;
               	start = '&start=' + start;
          }          

          // optional parameters
          if (schedulerForm.name.value != '') params = params + '&name=' + escape(schedulerForm.name.value);
          
          if (schedulerForm.queryString.value != '') {
          	if (lengthValidation(schedulerForm.queryString, 1000)) {
          		params = params + '&queryString=' + escape(schedulerForm.queryString.value);
          	}
          	else {
          		return false;
          	}
          }
          
          if(schedulerForm.description!=null && schedulerForm.description.value!=''){
             if(lengthValidation(schedulerForm.description,1000)){
                 params = params + '&description=' + escape(schedulerForm.description.value);
             }
             else{
                return false;
             }
          }
          
          if (schedulerForm.host.value != '') {
          	if (lengthValidation(schedulerForm.host, 128)) {
          		params = params + '&host=' + escape(schedulerForm.host.value);
          	}
          	else {
          		return false;
          	}
          }
          
          if (schedulerForm.interval.value != '') {
          	if(isValidPositiveInteger(schedulerForm.interval.value)) { 
          		if(schedulerForm.applicationType.value == '<%= ECConstants.EC_SCHED_BROADCAST %>' && schedulerForm.interval.value > 0) {
          			schedulerForm.interval.focus();
          			schedulerForm.interval.select();
          			alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerBroadcastIntervalWarning"))%>') ;
          			return false;
          		}
          		params = params + '&interval=' + schedulerForm.interval.value;
          	}
          	else {
          		schedulerForm.interval.focus();
          		schedulerForm.interval.select();
          		alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerIncorrectIntervalValue"))%>');
          		return false;
          	}
          }
          
          if (schedulerForm.attempts.value != '') {
          	if(isValidPositiveInteger(schedulerForm.attempts.value)) {
          		if(schedulerForm.applicationType.value == '<%= ECConstants.EC_SCHED_BROADCAST %>' && schedulerForm.attempts.value > 0) {
          			schedulerForm.attempts.focus();
          			schedulerForm.attempts.select();
          			alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerBroadcastAttemptsWarning"))%>') ;
          			return false;
          		}
          		params = params + '&attempts=' + schedulerForm.attempts.value;
          	}
          	else {
          		schedulerForm.attempts.focus();
          		schedulerForm.attempts.select();
          		alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerIncorrectAttemptsValue"))%>');
          		return false;          
          	}
          }
          
          if (schedulerForm.delay.value != '') {
          	if(isValidPositiveInteger(schedulerForm.delay.value)) { 
          		if(schedulerForm.applicationType.value == '<%= ECConstants.EC_SCHED_BROADCAST %>' && schedulerForm.delay.value > 0) {
          			schedulerForm.delay.focus();
          			schedulerForm.delay.select();
          			alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerBroadcastDelayWarning"))%>') ;
          			return false;
          		}
          		params = params + '&delay=' + schedulerForm.delay.value; 
          	} else {
          		schedulerForm.delay.focus();
          		schedulerForm.delay.select();
          		alertDialog('<%=UIUtil.toJavaScript(schedulerNLS.get("schedulerIncorrectRetriesValue"))%>');
          		return false;
          	}
          }
          
          if (schedulerForm.applicationType.value != '') {          	
          	params = params + '&applicationType=' + schedulerForm.applicationType.value;
          }

          if(schedulerForm.schedulerPolicy.value != '') {
          	params = params + '&schedulerPolicy=' + schedulerForm.schedulerPolicy.value;
          }
	  
          if(schedulerForm.priority.value != '') {
          	params = params + '&priority=' + schedulerForm.priority.value;
          }
          document.schedulerForm.submit();
    }
    
    function setupDate1() {
    	window.yearField = document.schedulerForm.startYear;
    	window.monthField = document.schedulerForm.startMonth;
    	window.dayField = document.schedulerForm.startDay;
    }

    function onLoad() {
       if (parent.setContentFrameLoaded)
       {

<% 
	if("YES".equals(add_job_result_page)) {
	
		com.ibm.commerce.beans.ErrorDataBean errorBean = new com.ibm.commerce.beans.ErrorDataBean();
  		com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);  
	
		if (errorBean.getMessage() != null && ((String)errorBean.getMessage()).length() > 0) {
	
%>  		
  			alertDialog('<%= UIUtil.toJavaScript((String)errorBean.getMessage() ) %>');
<%		
		} else {
	
%>
			top.goBack();
<%		
		}
	}  
%>       
          parent.setContentFrameLoaded(true);
       }
    }
    
	function showDescription(selectElement) {
		if (selectElement.options[selectElement.selectedIndex].value === "CustomJob") {
			document.getElementById("descLabel").style.display = "block";
			document.getElementById("descInput").style.display = "block";
		} else {
			document.getElementById("descLabel").style.display = "none";
			document.getElementById("descInput").style.display = "none";
		}
	}

// -->
</script>
</HEAD>
<BODY ONLOAD="onLoad()"  class="content">
<SCRIPT FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";
</SCRIPT>

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" marginheight=0 marginwidth=0 noresize frameborder=0 scrolling=no src="Calendar"></iframe>');
</script>

<FORM NAME="schedulerForm" METHOD="POST" ACTION="<%= (jobId != null && !jobId.equals("")) ? "EditJob" : "AddJob" %>">
<% if (jobId != null && !jobId.equals("")) { %>
	<input type="hidden" name="jobId" value="<%=UIUtil.toHTML(jobId)%>">
<% } %>
<input type="hidden" name="authToken" value="${authToken}" id="WC_SchedulerForm_FormInput_authToken"/>
<input type="hidden" name="RESULTPAGE" value="YES">
<input type="hidden" name="URL" value="MsgMessagingSystemResponseView">
<input type="hidden" name="ERR_COM" value="SchedulerAddView">
<input type="hidden" name="start" value="00:00:00">
<input type="hidden" name="langId" value="<%=cmdContext.getPreferredLanguage()%>">
<H1><%= (jobId != null && !jobId.equals("")) ? schedulerNLS.get("schedulerEditTitle") : schedulerNLS.get("schedulerAddTitle")  %></H1>
<TABLE>
     <TR><TD><LABEL for="S1"><%= schedulerNLS.get("schedulerPathInfoCaption") %></LABEL></TD></TR>
     <TR><TD>

<%
     if (jobId == null || jobId.equals("")) {
%>
               <select name="pathInfo" id="S1" onchange="showDescription(this)">
<%

          for (int i=0; i < urlItems.size(); i++) {
          	String isSELECTED = "";
          	if (urlItems.getURL(i).equals(pathInfo)) isSELECTED = "SELECTED";
               out.println("<option value='" + urlItems.getURL(i) + "' " + isSELECTED + ">");
               out.println(urlItems.getURL(i));
               out.println("</option>");
          }
%>
          </select>
<%
     } else {
%>
               <select name="displayPathInfo" id="S1"><option value="<%= UIUtil.toHTML(pathInfo) %>"><%= UIUtil.toHTML(pathInfo) %></option></select>
               <input type="hidden" name="pathInfo" value="<%= UIUtil.toHTML(pathInfo) %>">
<%
     } 
%>
          </TD></TR>
     <TR><TD><LABEL for="S2"><%= schedulerNLS.get("schedulerQueryStringCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="queryString" SIZE="40" id="S2" VALUE="<%= UIUtil.toHTML(queryString) %>"></TD></TR>
     
     <%
        if(jobId == null || jobId.equals("")){  //add scheduler
          if(!pathInfo.equals("CustomJob")){
      %>
      <TR><TD id="descLabel" style="display:none"><LABEL for="D4"><%=schedulerNLS.get("schedulerDescriptionCaption") %></LABEL></TD></TR>
      <TR><TD id="descInput" style="display:none"><INPUT NAME="description"  SIZE="40" id="D4" VALUE="<%=UIUtil.toHTML(description)%>"></TD></TR>
      <% }else{%>
      <TR><TD id="descLabel"><LABEL for="D4"><%=schedulerNLS.get("schedulerDescriptionCaption") %></LABEL></TD></TR>
      <TR><TD id="descInput"><INPUT NAME="description"  SIZE="40" id="D4" VALUE="<%=UIUtil.toHTML(description)%>"></TD></TR>
         <%}
        }else if(pathInfo.equals("CustomJob")){  //edit scheduler
       %>
        <TR><TD><LABEL for="S2"><%=schedulerNLS.get("schedulerDescriptionCaption") %></LABEL></TD></TR>  
        <TR><TD><input name="description" value="<%=UIUtil.toHTML(description)%>"  size="40" id="S2"></TD></TR>
      <% }%>
     
     
     <TR><TD><TABLE>
     <TR><TD><TR><TD>&nbsp;</TD>
     	 <TD><%= schedulerNLS.get("schedulerYear") %></TD>
     	 <TD><%= schedulerNLS.get("schedulerMonth") %></TD>
     	 <TD><%= schedulerNLS.get("schedulerDay") %></TD>
     	 <TD></TD><TD></TD><TD></TD></TR>     
     <TR>
     <TD><LABEL for="S2"><%= schedulerNLS.get("schedulerStartCaption") %></LABEL></TD>
     <TD><INPUT NAME="startYear" VALUE="<%= UIUtil.toHTML(startYear) %>" maxlength="4" size="4" id="S2"></TD>
     <TD><INPUT NAME="startMonth" VALUE="<%= UIUtil.toHTML(startMonth) %>" maxlength="2" size="2" id="S2"></TD>
     <TD><INPUT NAME="startDay" VALUE="<%= UIUtil.toHTML(startDay) %>" maxlength="2" size="2" id="S2"></TD>
     <TD><A HREF="javascript:setupDate1();showCalendar(document.schedulerForm.calImg1)">
               <IMG SRC="<%=webalias%>images/tools/calendar/calendar.gif" BORDER="0" alt="<%=calendarText%>" id=calImg1></A>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
     <TD><LABEL for="S3"><%= schedulerNLS.get("schedulerStartTime") %></LABEL></TD>
     <TD><INPUT NAME="startTime" VALUE="<%= UIUtil.toHTML(startTime) %>" maxlength="5" size="5" id="S3"></TD>
     <TD><TD><TD><TD><LABEL for="fixedTime"><%=schedulerNLS.get("schedulerFixedTime")%></LABEL>     

	     <INPUT TYPE="checkbox" NAME="fixedTime" id="fixedTime"  value="1" <%=(fixedTime.equals("1"))? "checked" : ""%> >
	     </TD></TD></TD></TD>
     </TR>
     </TABLE></TD></TR>

     <TR><TD><LABEL for="S4"><%= schedulerNLS.get("schedulerNameCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="name"  SIZE="40" id="S4" VALUE="<%= UIUtil.toHTML(name) %>"></TD></TR>    
     <TR><TD><LABEL for="S6"><%= schedulerNLS.get("schedulerHostCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="host"  SIZE="40" id="S6" VALUE="<%= UIUtil.toHTML(host) %>"></TD></TR>
     <TR><TD><LABEL for="S7"><%= schedulerNLS.get("schedulerIntervalCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="interval"  SIZE="10" id="S7" VALUE="<%= UIUtil.toHTML(interval) %>"></TD></TR>
     <TR><TD><LABEL for="S8"><%= schedulerNLS.get("schedulerAttemptsCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="attempts"  SIZE="10" id="S8" VALUE="<%= UIUtil.toHTML(attempts) %>"></TD></TR>
     <TR><TD><LABEL for="S9"><%= schedulerNLS.get("schedulerDelayCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="delay"  SIZE="10" id="S9" VALUE="<%= UIUtil.toHTML(delay) %>"></TD></TR>
     <TR><TD><LABEL for="S10"><%= schedulerNLS.get("schedulerSchedulerPolicyCaption") %></LABEL></TD></TR>
     <TR><TD>
     <select name="schedulerPolicy" id="S10">
     	<option value="0" <%= (policy.equals("0") || policy.equals("")) ? "SELECTED" : "" %>><%= schedulerNLS.get("schedulerPolicyValue_0")%></option>
     	<option value="1" <%= (policy.equals("1")) ? "SELECTED" : "" %>><%= schedulerNLS.get("schedulerPolicyValue_1")%></option>
     </select>
     
     </TD></TR>
     <TR><TD><LABEL for="S11"><%= schedulerNLS.get("schedulerPriorityCaption") %></LABEL> <%=schedulerNLS.get("schedulerPriorityNote")%></TD></TR>
     <TR><TD><select name="priority" id="S11"><%
     
     if (priority.equals("")) priority = "" + java.lang.Thread.NORM_PRIORITY;
     
     for(int i=java.lang.Thread.MIN_PRIORITY; i <= java.lang.Thread.MAX_PRIORITY; i++) {
     
     %>
     <option VALUE="<%=i%>" <%= (priority.equals(""+i)) ? "SELECTED" : ""  %>><%=i%></option>
     <%
     
     }
     
     %></TD></TR>
     <TR><TD><LABEL for="S12"><%= schedulerNLS.get("schedulerApplicationTypeCaption") %></LABEL></TD></TR>
     <TR><TD><select NAME="applicationType" id="S12">
     		<option value=""></option>
     		
<%
	  String isSelected = "";
          for (int i=0; i < appTypeItems.size(); i++) {
            if (!appTypeItems.getApplicationType(i).equals(ECConstants.EC_SCHED_BROADCAST)) {           
               if (appTypeItems.getApplicationType(i).equals(applicationType)) {
                  isSelected = "SELECTED";
               } else {
                  isSelected = "";
               }
               out.println("<option value='" + appTypeItems.getApplicationType(i) + "' "  +  isSelected + ">");
               out.println(((schedulerNLS.get("schedulerAppType_"+appTypeItems.getApplicationType(i)) != null) ? schedulerNLS.get("schedulerAppType_"+appTypeItems.getApplicationType(i)) : appTypeItems.getApplicationType(i)));
               out.println("</option>");
            }
          }
%>     		
    	</select>
     </TD></TR>
</TABLE>


</FORM>
</BODY>
</HTML>

