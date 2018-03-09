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
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.CCQueueDataBean" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.commands.ECLivehelpConstants" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdcontext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	String storeId = cmdcontext.getStoreId().toString(); 
	String languageId =cmdcontext.getLanguageId().toString(); 
	Locale locale = cmdcontext.getLocale();
	Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", locale);
	String sWebPath=UIUtil.getWebPrefix(request);
	String sWebAppPath=UIUtil.getWebappPath(request);
	CCQueueDataBean qDB=new CCQueueDataBean();
	DataBeanManager.activate(qDB, request);
	Vector vqDBs= qDB.getStoreQueues();		
	int numberOfQueues = 0;
	if (vqDBs!=null) {
		numberOfQueues=vqDBs.size();
		}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader %>
<script src="<%=sWebPath%>javascript/tools/common/Util.js"></script>
<script src="<%=sWebPath%>javascript/tools/common/dynamiclist.js"></script>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>"
	type="text/css" />
<title><%=(String)liveHelpNLS.get("customerCareConfigTitle")%></title>
<script>
	/**
	 * load page data
	 */
        function onLoad()
        {
          parent.loadFrames();
        }

	/**
	 * returns total number of queues
	 */
        function getResultsSize() {
            return <%= numberOfQueues %>;
        }
	/**
	 * launches new Customer Care Queue page
	 */
        function newCCQueue()
        {
          top.setContent("<%=UIUtil.toJavaScript((String)liveHelpNLS.get("newCCQueueDialogTitle"))%>",
          		 "<%=sWebAppPath%>DialogView?XMLFile=livehelp.newCCQueueDialog", true);
        }
	/**
	 * launches update Customer Care queue page
	 * @param qId Queue Id
	 */
        function changeCCQueueWithId(qId)
        {
			if (qId !=null && qId != "") {
          		top.setContent("<%=UIUtil.toJavaScript((String)liveHelpNLS.get("changeCCQueueDialogTitle"))%>",
          		 "<%=sWebAppPath%>DialogView?XMLFile=livehelp.changeCCQueueDialog&<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>=" + qId, true);
        	}
        }

	/**
	 * launches update Customer Queue page
	 */
        function changeCCQueue()
        {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				var qId = checked[0];
				changeCCQueueWithId(qId); 
        	}
        }
	/**
	 * launches assign Customer Care Queue page
	 */
        function assignCCQueue()
        {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				var qId = checked[0];
          		top.setContent("<%=UIUtil.toJavaScript((String)liveHelpNLS.get("assignCCQueueDialogTitle"))%>",
          		 "<%=sWebAppPath%>DialogView?XMLFile=livehelp.assignCCQueueDialog&<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>=" + qId, true);
        	}
        }
	/**
	 * deletes selected Customer Care Queue and refresh Queue List
	 */
        function deleteCCQueue()
        {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				if (confirmDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get("deleteCCQueueConfirmation")) %>")) {
					var qId = checked[0];
					var url = "<%=sWebAppPath%>CCQueueDelete?storeId=<%=storeId%>&<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>=" + qId;
					url+="&<%=ECConstants.EC_REDIRECTURL%>=NewDynamicListView&ActionXMLFile=livehelp.customerCareConfig&cmd=CCQueueConfigurationView";
					parent.location.replace(url);
				}
			}
	     }

	</script>
</head>

<body class="content_list">
<script>
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      </script>

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
 	int rowselect = 1;
	int totalsize = numberOfQueues;
	int totalpage = 0;
	if (listSize != 0) {
		totalpage = totalsize/listSize;
	  }
%>
<%= comm.addControlPanel("livehelp.customerCareConfig", totalpage, totalsize, locale) %>
<form name="customerCareConfigFORM" id="WC_CCQueueConfiguration_Form_1"><%= comm.startDlistTable(UIUtil.toHTML((String)liveHelpNLS.get("ccQueueListSummary"))) %>
<%= comm.startDlistRowHeading() %> <%= comm.addDlistCheckHeading() %> <%= comm.addDlistColumnHeading(UIUtil.toHTML((String)liveHelpNLS.get("customerCareConfigQueueListQueueIdColumn")),null, false ) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)liveHelpNLS.get("customerCareConfigQueueListQueueNameColumn")),null, false ) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)liveHelpNLS.get("customerCareConfigQueueListQueueDisplayNameColumn")),null, false ) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)liveHelpNLS.get("customerCareConfigQueueListQueueDescriptionColumn")),null, false ) %>
<%= comm.addDlistColumnHeading(UIUtil.toHTML((String)liveHelpNLS.get("customerCareConfigQueueListQueueAssignmentColumn")),null,false ) %>
<%= comm.endDlistRow() %> <%
        	if (endIndex > totalsize) {
          		endIndex = totalsize;
          	}

          	int indexFrom = startIndex;
          for (int i = indexFrom; i < endIndex; i++)
          { 
			qDB=(CCQueueDataBean) vqDBs.get(i);
			qDB.refreshDisplayInformation(languageId);
			String sAssignedCSRs="";
			if (qDB.getAllCSRs().equals(ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED)) {
				Vector vCSRInfos=qDB.getAssignedCSRInformation();
				if (vCSRInfos!=null && vCSRInfos.size()>0 ) {
					for (int nIdx2=0; nIdx2<vCSRInfos.size();nIdx2++) {
						String CSRLogonId="";
						Hashtable htCSRInfo=((Hashtable) vCSRInfos.get(nIdx2));
						if (htCSRInfo!=null) {
							CSRLogonId=(String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_LOGONID_UID);
	  						if (CSRLogonId!=null) {CSRLogonId=CSRLogonId.trim();}
							if (sAssignedCSRs.equals("")) {
								sAssignedCSRs=CSRLogonId;
								}
							else {
								sAssignedCSRs=sAssignedCSRs + ", " + CSRLogonId;
								}
						} 
					}
				}
			}	
			else {
				sAssignedCSRs=(String)liveHelpNLS.get("customerCareConfigQueueListQueueAssignmentColumnValueAll");
			}

          %> <%= comm.startDlistRow(rowselect) %> <%= comm.addDlistCheck( qDB.getQueueId(),"none" ) %>
<%= comm.addDlistColumn( UIUtil.toHTML(qDB.getQueueId()), "javascript:changeCCQueueWithId('"+ qDB.getQueueId()+"');" ) %>
<%= comm.addDlistColumn( UIUtil.toHTML(qDB.getQueueName()), "none" ) %>
<%= comm.addDlistColumn( UIUtil.toHTML(qDB.getQueueDisplayName()), "none" ) %>
<%= comm.addDlistColumn( UIUtil.toHTML(qDB.getQueueDescription()), "none" ) %>
<%= comm.addDlistColumn( UIUtil.toHTML(sAssignedCSRs), "none" ) %> <%= comm.endDlistRow() %>
<%
			if (rowselect == 1) {
            	rowselect = 2;
            } else {
               rowselect = 1;
            }
          }
    %> <%= comm.endDlistTable() %> <% if (numberOfQueues == 0)
   {
%>
<p></p>
<p><%=(String) liveHelpNLS.get("customerCareConfigQueueListIsEmpty")%> <%
  }
%></p>
</form>

<script>
        <!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
       //-->
      </script>

</body>

</html>



