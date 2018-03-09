<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.exception.*" %>



<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>

<%
  String webalias = UIUtil.getWebPrefix(request);
  Integer store_id = null;
  String calendarText = new String("");
  Hashtable schedulerNLS = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();
  String startC = request.getParameter("startDateCriteria");
  String endC = request.getParameter("endDateCriteria");
  
  String startYear = new String("");
  String startMonth = new String("");
  String startDay = new String("");
  String startTime = new String("");
  
  String endYear = new String("");
  String endMonth = new String("");
  String endDay = new String("");
  String endTime = new String("");

  
  if(startC != null && (!startC.equals(""))) {
  	try {
  	 	java.sql.Timestamp startT = com.ibm.commerce.scheduler.beans.SchedulerStatusDataBean.convertTime(startC);
  	 	startYear = "" + (1900 + startT.getYear());
  	 	startMonth = "" + (startT.getMonth()+1);
  	 	startDay = "" + startT.getDate();
  	 	
  	 	if (startT.getHours() < 10)
  	 		startTime = "0" + startT.getHours();
  	 	else
  	 		startTime = "" + startT.getHours();
  	 	
  	 	if (startT.getMinutes() < 10)
  	 		startTime = startTime + ":0" + startT.getMinutes();
  	 	else
  	 		startTime = startTime + ":" + startT.getMinutes();
  	} catch (Exception e) {
  	}  
  }
  
  if (endC != null && (!endC.equals(""))) {
  	try {
  	 	java.sql.Timestamp endT = com.ibm.commerce.scheduler.beans.SchedulerStatusDataBean.convertTime(endC);
  	 	endYear = "" + (1900 + endT.getYear());
  	 	endMonth = "" + (endT.getMonth()+1);
  	 	endDay = "" + endT.getDate(); 
  	 	
  	 	if (endT.getHours() < 10)
  	 		endTime = "0" + endT.getHours();
  	 	else
  	 		endTime = "" + endT.getHours();
  	 	
  	 	if (endT.getMinutes() < 10)
  	 		endTime = endTime + ":0" + endT.getMinutes();
  	 	else
  	 		endTime = endTime + ":" + endT.getMinutes();
  	 	
  	} catch (Exception e) {
  	}    
  }

   try {
      // obtain the resource bundle for display
      calendarText = (String)((Hashtable)ResourceDirectory.lookup("campaigns.campaignsRB", cmdContext.getLocale())).get("calendarTool");
      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
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
<TITLE><%= schedulerNLS.get("schedulerChangeCriteriaTitle") %></TITLE>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!-- // hide from older browsers

     function displayResults() {
     
     	var startC = '';
     	var endC = '';
     	var criteria = '';
     	
     	if(schedulerForm.startTime.value != '') {
     		
     		if(schedulerForm.startYear.value != '' && schedulerForm.startMonth.value != '' && schedulerForm.startDay.value != '') 
     			startC = schedulerForm.startYear.value + ":" +  schedulerForm.startMonth.value + ":" + schedulerForm.startDay.value + ":" + schedulerForm.startTime.value + ":00";
     		else
     			startC = schedulerForm.startTime.value + ":00";
     	}
     	else if(schedulerForm.startYear.value != '' && schedulerForm.startMonth.value != '' && schedulerForm.startDay.value != '') {
     			startC = schedulerForm.startYear.value + ":" +  schedulerForm.startMonth.value + ":" + schedulerForm.startDay.value + ":00:00:00";     	     	
     	}
     	
     	if(schedulerForm.endTime.value != '') {
     		if (schedulerForm.endYear.value != '' && schedulerForm.endMonth.value != '' && schedulerForm.endDay.value != '') 
     			endC = schedulerForm.endYear.value + ":" +  schedulerForm.endMonth.value + ":" + schedulerForm.endDay.value + ":" + schedulerForm.endTime.value + ":00";
     		else
     			endC = schedulerForm.endTime.value + ":00";
     	}
     	else if(schedulerForm.endYear.value != '' && schedulerForm.endMonth.value != '' && schedulerForm.endDay.value != '') {
     		endC = schedulerForm.endYear.value + ":" +  schedulerForm.endMonth.value + ":" + schedulerForm.endDay.value + ":23:59:59:";
     	}
     
     	if (startC != '')
     		criteria = criteria + '&amp;startDateCriteria='+startC;
     	if (endC != '')
     		criteria = criteria + '&amp;endDateCriteria='+endC;
     
        <% if ( ECConstants.EC_NO_STOREID.equals(store_id) ) { %>
        	var url = 'NewDynamicListView?ActionXMLFile=adminconsole.SchedulerMain&amp;cmd=SchedulerMainView&amp;listsize=<%=getListSize()%>&amp;startindex=0&amp;orderby=<%=UIUtil.toJavaScript(orderByParm)%>&amp;refnum=0'+criteria;
	<% } else { %>
		var url = 'NewDynamicListView?ActionXMLFile=adminconsole.StoreSchedulerMain&amp;cmd=StoreSchedulerMainView&amp;listsize=<%=getListSize()%>&amp;startindex=0&amp;orderby=<%=UIUtil.toJavaScript(orderByParm)%>&amp;refnum=0'+criteria;
	<% } %>        	
                  
        parent.location.replace(url);
        
     }
     
function setupDate1()
{
    window.yearField = document.schedulerForm.startYear;
    window.monthField = document.schedulerForm.startMonth;
    window.dayField = document.schedulerForm.startDay;
}

function setupDate2()
{
    window.yearField = document.schedulerForm.endYear;
    window.monthField = document.schedulerForm.endMonth;
    window.dayField = document.schedulerForm.endDay;
}



    function onLoad() {
       if (parent.setContentFrameLoaded)
       {
          parent.setContentFrameLoaded(true);
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

<FORM NAME="schedulerForm">
<H1><%= schedulerNLS.get("schedulerChangeCriteriaTitle") %></H1>
<TABLE>
     <TR><TD></TD>
     	 <TD><%= schedulerNLS.get("schedulerYear") %></TD>
     	 <TD><%= schedulerNLS.get("schedulerMonth") %></TD>
     	 <TD><%= schedulerNLS.get("schedulerDay") %></TD>
     	 <TD></TD><TD></TD><TD></TD></TR>
     <TR><TD><LABEL for="S2"><%= schedulerNLS.get("schedulerStartCriteriaCaption") %></LABEL></TD>
     <TD><INPUT NAME="startYear" VALUE="<%= startYear %>" maxlength="4" size="4" id="S2"></TD>
     <TD><INPUT NAME="startMonth" VALUE="<%= startMonth %>" maxlength="2" size="2" id="S2"></TD>
     <TD><INPUT NAME="startDay" VALUE="<%= startDay %>" maxlength="2" size="2" id="S2"></TD>
     <TD><A HREF="javascript:setupDate1();showCalendar(document.schedulerForm.calImg1)">
               <IMG SRC="<%=webalias%>images/tools/calendar/calendar.gif" BORDER="0" alt="<%=calendarText%>" id=calImg1></A>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
     <TD><LABEL for="S3"><%= schedulerNLS.get("schedulerStartTime") %></LABEL></TD>
     <TD><INPUT NAME="startTime" VALUE="<%= startTime %>" maxlength="5" size="5" id="S3"></TD></TR>
     
     <TR><TD><LABEL for="S4"><%= schedulerNLS.get("schedulerEndCriteriaCaption") %></LABEL></TD>
     <TD><INPUT NAME="endYear" VALUE="<%= endYear %>" maxlength="4" size="4" id="S4"></TD>
     <TD><INPUT NAME="endMonth" VALUE="<%= endMonth %>" maxlength="2" size="2" id="S4"></TD>
     <TD><INPUT NAME="endDay" VALUE="<%= endDay %>" maxlength="2" size="2" id="S4"></TD>
     <TD><A HREF="javascript:setupDate2();showCalendar(document.schedulerForm.calImg2)">
               <IMG SRC="<%=webalias%>images/tools/calendar/calendar.gif" BORDER="0" alt="<%=calendarText%>" id=calImg2></A>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
     <TD><LABEL for="S5"><%= schedulerNLS.get("schedulerEndTime") %></LABEL></TD>
     <TD><INPUT NAME="endTime" VALUE="<%= endTime %>" maxlength="5" size="5" id="S5"></TD></TR>
     
</TABLE>


</FORM>

</BODY>
</HTML>
