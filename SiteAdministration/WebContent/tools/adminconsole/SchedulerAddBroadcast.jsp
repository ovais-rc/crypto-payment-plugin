<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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

<%@include file="../common/common.jsp" %>


<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.scheduler.beans.*" %>

<jsp:useBean id="urlItems" scope="request" class="com.ibm.commerce.scheduler.beans.UrlRegistryItemsDataBean">
</jsp:useBean>
<jsp:useBean id="schedulerItems" scope="request" class="com.ibm.commerce.scheduler.beans.SchedulerItemsDataBean">
</jsp:useBean>


<%
  String webalias = UIUtil.getWebPrefix(request);
  Integer store_id = null;
  Hashtable schedulerNLS = null;
  Hashtable adminconsoleNLS = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();
  String add_job_result_page = request.getParameter("RESULTPAGE");
  if (add_job_result_page == null ) add_job_result_page = "";
  String jobId = request.getParameter("jobId");
  String pathInfo =  request.getParameter("pathInfo");
  if (pathInfo == null) pathInfo = "";
  String queryString =  request.getParameter("queryString");
  if (queryString == null) queryString = "";
  String name =  request.getParameter("name");
  if (name == null) name = "";

   try {
      // obtain the resource bundle for display
      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
      adminconsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", cmdContext.getLocale());
      if (jobId != null && !jobId.equals("")) {
          schedulerItems.setJobRefNum(jobId);
          DataBeanManager.activate(schedulerItems, request);
          pathInfo = schedulerItems.getPathInfo(0);
          queryString = schedulerItems.getQueryString(0);
          name = schedulerItems.getUserReferenceNumber(0);
      }
      else DataBeanManager.activate(urlItems, request);
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
<TITLE><%= (jobId != null && !jobId.equals("")) ? schedulerNLS.get("schedulerEditBroadcastTitle") : schedulerNLS.get("schedulerAddBroadcastTitle") %></TITLE>

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

          
          // commands that must be specified
          if (schedulerForm.pathInfo.value == '') {
               alertDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerPathInfoMissing")) %>');
               return false;
          } else {
               pathInfo = '&pathInfo=' + schedulerForm.pathInfo.value
          }

          // optional parameters
          if (schedulerForm.name.value != '') params = params + '&name=' + escape(schedulerForm.name.value);
          if (schedulerForm.queryString.value != '') {
          	if (lengthValidation(schedulerForm.queryString, 1000)) params = params + '&queryString=' + escape(schedulerForm.queryString.value);
          	else return false;
          }

          // location.href = url + pathInfo + start + params;
          document.schedulerForm.submit();
          
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
</script>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()"  class="content">
<FORM NAME="schedulerForm" METHOD="POST" ACTION="<%= (jobId != null && !jobId.equals("")) ? "EditJob" : "AddBroadcastJob" %>">
<% if (jobId != null && !jobId.equals("")) { %>
	<input type="hidden" name="jobId" value="<%=UIUtil.toHTML(jobId)%>">
<% } %>
<input type="hidden" name="authToken" value="${authToken}" id="WC_SchedulerForm_FormInput_authToken"/>
<input type="hidden" name="RESULTPAGE" value="YES">
<input type="hidden" name="URL" value="MsgMessagingSystemResponseView">
<input type="hidden" name="ERR_COM" value="SchedulerAddBroadcastView">
<input type="hidden" name="langId" value="<%=cmdContext.getPreferredLanguage()%>">
<H1><%= (jobId != null && !jobId.equals("")) ? schedulerNLS.get("schedulerEditBroadcastTitle") : schedulerNLS.get("schedulerAddBroadcastTitle") %></H1>
<TABLE>
     <TR><TD><LABEL for="S1"><%= schedulerNLS.get("schedulerPathInfoCaption") %></LABEL></TD><TR>
     <TR><TD>
<select name="pathInfo" id="S1">
<%
     if (jobId == null || jobId.equals("")) {
%>
               
<%

          for (int i=0; i < urlItems.size(); i++) {
          	String isSELECTED = "";
          	if (urlItems.getURL(i).equals(pathInfo)) isSELECTED = "SELECTED";          
               out.println("<option value='" + urlItems.getURL(i) + "' " + isSELECTED + ">");
               out.println(urlItems.getURL(i));
               out.println("</option>");
          }
%></select>
<%
     } else {
%><input type="hidden" name="pathInfo" value="<%= UIUtil.toHTML(pathInfo) %>">
<select name="displayPathInfo" id="S1">
<%     
     	out.println("<option value='" + UIUtil.toHTML(pathInfo) + "'>");
        out.println(UIUtil.toHTML(pathInfo));
        out.println("</option>");
     }
%></select>

          </TD></TR>

     <TR><TD><LABEL for="S2"><%= schedulerNLS.get("schedulerQueryStringCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="queryString" VALUE="<%= UIUtil.toHTML(queryString)  %>" SIZE="40" id="S2"></TD></TR>
     <TR><TD><LABEL for="S4"><%= schedulerNLS.get("schedulerNameCaption") %></LABEL></TD></TR>
     <TR><TD><INPUT NAME="name" VALUE="<%= UIUtil.toHTML(name) %>" SIZE="40" id="S4"></TD></TR>
</TABLE>


</FORM>
</BODY>
</HTML>

