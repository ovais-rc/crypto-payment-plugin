<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../common/common.jsp" %>  

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.devtools.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@page import="com.ibm.commerce.server.ConfigProperties" %>
<%@page import="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>
<%@page import="com.ibm.commerce.server.WebModuleConfig" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>

<%

  String webalias = UIUtil.getWebPrefix(request);
  String calendarText = "";
  String storeUrl = "";
  String inventTxt = "";
  String dateTxt = "";
  String legacyR = "";
  Integer store_id = null;
  Hashtable schedulerNLS = null;
  Hashtable previewNLS = null;  
  String frozenTime="";
  String elapsingTime=""; 
  
  
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();

  String add_job_result_page = request.getParameter("RESULTPAGE");
  if (add_job_result_page == null ) { add_job_result_page = "";}

  String start =  request.getParameter("start");
  if (start == null) { start = ""; }

  String startYear = request.getParameter("startYear");
  if (startYear == null) { startYear = ""; }

  String startMonth = request.getParameter("startMonth");
  if (startMonth == null) { startMonth = ""; }

  String startDay = request.getParameter("startDay");
  if (startDay == null) { startDay = ""; }

  String startTime = request.getParameter("startTime");
  if (startTime == null) { startTime = ""; }

   try {
      // obtain the resource bundle for display
      calendarText = (String)((Hashtable)ResourceDirectory.lookup("campaigns.campaignsRB", cmdContext.getLocale())).get("calendarTool");
      storeUrl = (String)((Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale())).get("storeURL");
      inventTxt = (String)((Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale())).get("inventTXT");
      dateTxt = (String)((Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale())).get("dateTXT");
	  ResourceBundleProperties legacyResource = (ResourceBundleProperties)ResourceDirectory.lookup("publish.userNLS2",cmdContext.getLocale());
	  legacyR = (String) legacyResource.getJSProperty("alertStoreURIUnavailable");
	  legacyResource = (ResourceBundleProperties)ResourceDirectory.lookup("publish.userNLS2",cmdContext.getLocale());

      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
      previewNLS = (Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale());      
      frozenTime=(String)previewNLS.get("FrozenTime");
      elapsingTime=(String)previewNLS.get("ElapsingTime");
   } catch (ECSystemException ecSysEx) {
     ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
     ExceptionHandler.displayJspException(request, response, exc);
   } 


	String indexJspPath = "";
	try {
		StoreDataBean sdb = new StoreDataBean();
		sdb.setStoreId(store_id.toString());
		sdb.setCommandContext(cmdContext);
  		com.ibm.commerce.beans.DataBeanManager.activate (sdb, request);  
		indexJspPath = sdb.getFilePath("index.jsp");
			
	} catch (Exception e) {
		e.printStackTrace();
		
	}
		
%>

<HTML>
<HEAD>
<%= fHeader %>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<TITLE><%= UIUtil.toHTML((String)previewNLS.get("previewDialogHtmlTitle")) %></TITLE>
<SCRIPT  LANGUAGE="JavaScript" SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="<%=webalias%>javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!---- //hide script from old browsers
       //

     function validatePanelData() {

		return true;
  
    }
    
	function timeMessage(){

		var message = "<%= UIUtil.toJavaScript((String)previewNLS.get("TimeMessage")) %>";
		return message ;
	}

	function getstoreURLNotSpecifiedMessage(){

		var message = "<%= UIUtil.toJavaScript((String)previewNLS.get("StoreUrlNotSpecifiedMsg")) %>";
		return message ;
	}
	
	function getIncorrectStoreUrlMsg () {
		var message = "<%= UIUtil.toJavaScript((String)previewNLS.get("IncorrectStoreUrlMsg")) %>";
		return message ;
	}

	function getWebPath(){
		var webPath = "<%= (String) UIUtil.toJavaScript(DevToolsConfiguration.getConfigURLVariable(DevToolsConfiguration.WEB_APP_PATH)) %>";
		return webPath;
	}

	function getStoresWebPath(){
		var webAppPathValue = "<%= ConfigProperties.singleton().getValue("WebServer/StoresWebPath")%>";
		return webAppPathValue;
	}	
	
	function getPreviewWebPath(){
		var webPath = "<%= WcsApp.configProperties.getWebModule(CMWSPreviewConstants.PREVIEW_WEBAPP_NAME).getContextPath() %>";		
		return webPath;
	}
	
	function getToolsWebPath(){
		
		var webPath = "<%= WcsApp.configProperties.getWebModule(CMWSPreviewConstants.TOOLS_WEBAPP_NAME).getContextPath() %>";	
		return webPath;
	}
	
	function getToolsWebPort(){
		
		var webPort = "<%= WcsApp.configProperties.getWebModule(CMWSPreviewConstants.TOOLS_WEBAPP_NAME).getSSLPort() %>";
		if (webPort==null || webPort=="" || webPort == "null")
		{
			return'';
		}
		return webPort;
	}
	
	function getPreviewWebPort(){
		var webPort = "<%= WcsApp.configProperties.getWebModule(CMWSPreviewConstants.PREVIEW_WEBAPP_NAME).getSSLPort() %>";		
		if (webPort==null || webPort=="" || webPort == "null")
		{
			return'';
		}
		return webPort;
	}
	
	function getNewPreviewSessionParameter(){
		var para = "<%= CMWSPreviewConstants.NEW_PREVIEW_SESSION %>";
		return para;
	}

	function defaultStore()
	{

//		var indexJsp = "<%= indexJspPath %>";
//
//		if (indexJsp == null || indexJsp == "")
//		{
//			alertDialog("<%= legacyR %>");
//			//alertDialog("The store index.jsp could not be found");
//			return;
//		}
		
		modalDialogArgs = new Array();
		modalDialogArgs.inputTextTitle = "Preview";
		modalDialogArgs.inputTextValue = getWebPath();
		webapp = modalDialogArgs.inputTextValue;
		if (webapp == null)
			return;
		
		loc = ""
		if (webapp.charAt(0) != "/")
			loc += "/";
		
		loc += webapp;
		
		var endsWith = webapp.slice(-1);
		
		if (endsWith != "/")
			loc += "/";

		loc += "servlet";
		loc += "/StoreView";
		loc += "?<%= ECConstants.EC_STORE_ID %>=<%= store_id.toString() %>&<%= ECConstants.EC_LANGUAGE_ID %>=<%= cmdContext.getLanguageId().toString() %>";

		return loc;
		
	}


    function setupDate1() {
    	window.yearField = document.previewForm.startYear;
    	window.monthField = document.previewForm.startMonth;
    	window.dayField = document.previewForm.startDay;
    }
// Calculate Time
	function setupTime() {

	var timeNow = new Date();
	var hours = timeNow.getHours();
	var minutes = timeNow.getMinutes();
	var timeValue = "" + hours; 
    timeValue = ((timeValue <10)? "0":"") + timeValue
    timeValue += ((minutes < 10) ? ":0" : ":") + minutes
	return timeValue;
	}

	function init() {
    	previewForm.startYear.value = getCurrentYear();
	    previewForm.startMonth.value = getCurrentMonth();
    	previewForm.startDay.value = getCurrentDay();
	    previewForm.startTime.value = setupTime();
 
	}

    function onLoad() {
	   previewForm.redirecturl.value = defaultStore();
	   init();
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
		}  else {
	
%>
			top.goBack();
<%		
		}
	}  
%>       
          parent.setContentFrameLoaded(true);
       }
    } 

// --> 

function hideDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "none";
}

function showDateTimeFields()
{
	document.all["dateTimeArea"].style.display = "block";
}
</script>
<style type="text/css">

TD.contrast { background-color: #DEDEFF; }
TD.logon_input { padding-left: 4px; padding-top: 8px; }
	BODY { font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black; margin: 0 0 0 0; padding: 0 0 0 0; background-color: EFEFEF; word-wrap: break-word; scrollbar-arrow-color: #552BA1; scrollbar-3dlight-color: #552BA1; scrollbar-face-color: #EDEDED; scrollbar-track-color: #CFCECF;}
	BODY.content { margin-left: 10pt; margin-top: 10pt; font-family: Verdana; font-size: 10pt; color: Black; word-wrap: break-word;}
	H1 { font-family: Verdana,Arial,Helvetica; font-size: 15pt; color: #565665; font-weight: normal; word-wrap: break-word; }
/* form classes*/
	.formtext {font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black;}
	.forminput {font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black; width:370px; margin-bottom: 25px;}
	.formtextarea {font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black;  width:370px; height:52px; margin-bottom: 25px;}
	.formdropdown {font-family: Verdana,Arial,Helvetica; font-size: 10pt; color: Black;  margin-bottom: 25px;}
	.formselect {margin-bottom: 25px;}
/* form classes*/
</style>

</HEAD>
<BODY ONLOAD="onLoad()"  class="content"> 
<!--<BODY ONLOAD="validatePanelData()"  class="content">-->
<SCRIPT LANGUAGE="JavaScript" FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";
</SCRIPT>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" MARGINHEIGHT=0 MARGINWIDTH=0 FRAMEBORDER=0 SCROLLING=NO SRC="Calendar">
</IFRAME>
<h1><%= UIUtil.toHTML((String)previewNLS.get("StorePreviewTitle")) %></h1>

<FORM NAME="previewForm" METHOD="POST" ACTION="">

<input type="hidden" name="RESULTPAGE" value="YES" id="S1" >
<input type="hidden" name="start" value="00:00:00" id="S1">
<input type="hidden" name="langId" value="<%=cmdContext.getPreferredLanguage()%>" id="S1"> 
<input type="hidden" name="workspace" value="<%=UIUtil.toHTML(request.getParameter("workspace"))%>" id="S1">
<input type="hidden" name="taskgrp" value="<%=UIUtil.toHTML(request.getParameter("taskgroup"))%>" id="S1">
<input type="hidden" name="task" value="<%=UIUtil.toHTML(request.getParameter("task"))%>" id="S1">
<TABLE id="StorePreview_Launch_Table_5">  
     <TR><TD><label for="s3"><%= storeUrl %></label></TD></TR>
     <TR><TD><label for="S2">
     <script> document.writeln("http://"+ top.location.hostname);</script>
     <INPUT NAME="redirecturl" SIZE="80" id="S2" VALUE=""></label></TD></TR> 
   <tr><td>&nbsp;</td></tr>
     <TR><TD><B><%= UIUtil.toHTML((String)previewNLS.get("DateTimeTitle")) %></B></TD></TR>
       <TR><TD><%= dateTxt %></TD></TR>
       <tr><td><label for="timeoption0"><input type="radio" name="timeoption" value="true"  id ="timeoption0" checked onclick="javascript:hideDateTimeFields();"><%= UIUtil.toHTML((String)previewNLS.get("SchedulerCurrentTimeCaption")) %>
     </label>
     </td>
     </tr>
     <tr><td>
     <label for="timeoption1"><input type="radio" name="timeoption" value="false"  id ="timeoption1"onclick="javascript:showDateTimeFields();" ><%= UIUtil.toHTML((String)previewNLS.get("SchedulerSpecifyTimeCaption")) %>
     </label></td>
     </tr>
     <tr><td><DIV ID="dateTimeArea" STYLE="display:none;">
     <table>
     <tr><td><%= UIUtil.toHTML((String)schedulerNLS.get("schedulerYear")) %></td>
     <td><%= UIUtil.toHTML((String)schedulerNLS.get("schedulerMonth")) %></td>
     <td><%= UIUtil.toHTML((String)schedulerNLS.get("schedulerDay")) %>&nbsp;&nbsp;</td>
     <td>&nbsp;</td>
     <td><%= UIUtil.toHTML((String)previewNLS.get("schedulerHour")) %></td></tr>
     <tr>
          <TD><label for="S5"><INPUT NAME="startYear" VALUE="<%= UIUtil.toHTML(startYear) %>" maxlength="4" size="4" id="S5"></label></TD>
	     <TD><label for="S6"><INPUT NAME="startMonth" VALUE="<%= UIUtil.toHTML(startMonth) %>" maxlength="2" size="4" id="S6"></label></TD>
	     <TD><label for="S7"><INPUT NAME="startDay" VALUE="<%= UIUtil.toHTML(startDay) %>" maxlength="2" size="4" id="S7"></label></TD>
	     <TD><A HREF="javascript:setupDate1();showCalendar(document.previewForm.calImg1)">
	               <IMG SRC="<%=webalias%>images/tools/calendar/calendar.gif" HEIGHT="20"  WIDTH="20" BORDER="0" alt="<%=UIUtil.toHTML(calendarText)%>" id=calImg1></A>&nbsp;</TD>
	             

	             <TD>
		<label for="S8"><INPUT NAME="startTime" VALUE="<%= UIUtil.toHTML(startTime) %>" maxlength="5" size="4" id="S8"></label>     
       	</TD>
     </tr>
     </table></div></td></tr>
    
       <TR><TD><%= UIUtil.toHTML((String)previewNLS.get("PreviewTimeStatusOption")) %></TD></TR>
     <TR><TD><label for="frozen"><input type="radio" name="status" value="true"  id ="frozen" checked><%= UIUtil.toHTML((String)previewNLS.get("PreviewTimeStatusOption1"))%>
     </label>
     </TD></TR>
     <TR><TD><label for="elapsing"><input type="radio" name="status" value="false"  id ="elapsing" ><%= UIUtil.toHTML((String)previewNLS.get("PreviewTimeStatusOption2")) %>
    </label> </TD></TR>
    <tr><td>&nbsp;</td></tr>
    <TR><TD><LABEL for="S9"><span title="&nbsp;<%= UIUtil.toHTML((String)previewNLS.get("inventTXT1")) %>&nbsp;<%= UIUtil.toHTML((String)previewNLS.get("inventTXT2")) %>&nbsp;">
    <B><%= UIUtil.toHTML((String)previewNLS.get("ProductTitle")) %></B></LABEL>
    <IMG onclick="javascript:alertDialog('<%= UIUtil.toJavaScript((String)previewNLS.get("inventTXT1")) %>&nbsp;<%= UIUtil.toJavaScript((String)previewNLS.get("inventTXT2")) %>');" SRC="<%=webalias%>images/tools/catalog/info_pop.gif" BORDER="0" alt="<%= UIUtil.toHTML((String)previewNLS.get("inventTXT1")) %>&nbsp;<%= UIUtil.toHTML((String)previewNLS.get("inventTXT2")) %>&nbsp;<%= UIUtil.toHTML((String)previewNLS.get("inventTXT3")) %>">
    </span>
    </TD></TR>
     <TR><TD colspan="5" ><LABEL for="S10"><%= UIUtil.toHTML((String)previewNLS.get("inventTXT3")) %></LABEL></TD></tr>
     <tr>
            <TD>
     		<SELECT NAME="invstatus" id="S10">
			<OPTION value="0" SELECTED> <%= UIUtil.toHTML((String)previewNLS.get("InvOption1")) %> </OPTION>
			<OPTION value="1"><%= UIUtil.toHTML((String)previewNLS.get("InvOption2")) %></OPTION>
			<OPTION value="-1"><%= UIUtil.toHTML((String)previewNLS.get("InvOption3")) %></OPTION>
			</SELECT>
    		</TD></TR>
    		
 </TABLE>   		
</FORM>
 
</BODY>
</HTML>

