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
<%@include file="../common/List.jsp" %>


<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.scheduler.beans.*" %>

<jsp:useBean id="registryItems" scope="request" class="com.ibm.commerce.scheduler.beans.RegistryItemsDataBean">
</jsp:useBean>



<%

  Integer store_id = null;
  Hashtable schedulerNLS = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  String webalias = UIUtil.getWebPrefix(request);
  store_id = cmdContext.getStoreId();
  String component = request.getParameter("component");
  if (component == null) component = new String("");

   try {

      // obtain the resource bundle for display
      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
      DataBeanManager.activate(registryItems, request);

   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));          
	  int endIndex = getStartIndex() + getListSize();
    	  if (endIndex > registryItems.size())
      		endIndex = registryItems.size();
          int totalsize = registryItems.size();
          int totalpage = totalsize/listSize;
          int pageNumber = startIndex/listSize + 1;
	
%>

<HTML>
<HEAD>
<%= fHeader %>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<TITLE><%= schedulerNLS.get("registryTitle") %></TITLE>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!---- //hide script from old browsers

function getResultsSize() { 
     return <%= registryItems.size()  %>; 
}

     function refreshRegistry() {
          var checked = parent.getChecked();
          var url = top.getWebappPath() + "RefreshRegistry?registryName=" + checked[0] + "&authToken=" + encodeURI("${authToken}") +
        		  "&URL=NewDynamicListView?ActionXMLFile=adminconsole.RegistryMain&amp;cmd=AdminRegistryListView&pagenumber=" + <%= pageNumber %> + "&component="+ checked[0];
          parent.location.replace(url);
     }

     function refreshRegistryBySelect(item) {
          var url = top.getWebappPath() + "RefreshRegistry?registryName=" + item + "&authToken=" + encodeURI("${authToken}") +
        		  "&URL=NewDynamicListView?ActionXMLFile=adminconsole.RegistryMain&amp;cmd=AdminRegistryListView&pagenumber=" + <%= pageNumber %> + "&component="+item;
          parent.location.replace(url);
     }

     function refreshRegistryAll() {
          var url = top.getWebappPath() + "RefreshRegistry?authToken=" + encodeURI("${authToken}") +
        		  "&URL=NewDynamicListView?ActionXMLFile=adminconsole.RegistryMain&amp;cmd=AdminRegistryListView&pagenumber=" + <%= pageNumber %> + "&component=ALL";
          parent.location.replace(url);
     }

     function refreshPage() {
          var url = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=adminconsole.RegistryMain&amp;cmd=AdminRegistryListView&pagenumber=' + <%= pageNumber %>;
          parent.location.replace(url);
     }

       function onLoad()
       {
          parent.loadFrames()
       }
-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad()" class="content">
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.RegistryMain", totalpage, totalsize, cmdContext.getLocale() )%>
<FORM NAME="schedulerForm" ACTION="AdminRegistryListView" METHOD="POST">

<%= addHiddenVars() %>


<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)schedulerNLS.get("registryTableDesc")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("registryComponentCaption"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("registryStatusCaption"), null, false )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>


<%
    int rowselect=1;
    String nextRegName;
    String nextRegStatus;
    String chkbox_name = null;
    for (int i=getStartIndex(); i<endIndex ; i++)
    {
	nextRegName = registryItems.getComponent(i);
        nextRegStatus = registryItems.getStatus(i);
        if (component.equals(nextRegName) || component.equals("ALL")) nextRegStatus = "R";
    	chkbox_name = nextRegName;
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerNLS.get("registry" + nextRegName) != null)? (String)schedulerNLS.get("registry" + nextRegName) : nextRegName), "javascript:refreshRegistryBySelect('"+ chkbox_name +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerNLS.get("registryStatus_" + nextRegStatus) != null)? (String)schedulerNLS.get("registryStatus_" + nextRegStatus) : nextRegStatus), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>

