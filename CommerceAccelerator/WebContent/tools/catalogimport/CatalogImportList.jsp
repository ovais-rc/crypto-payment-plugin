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
// YYMMDD    F/D#      WHO       Description
//------------------------------------------------------------------------------
// 020904	     KNG		       Initial Create
// 050921 	113525    viviswan	   Migrate to using WC logging framework
// 051018   Li1438    niratnak     Modifying Catalog Import logging feature
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.common.beans.*" %>
<%@page import="com.ibm.commerce.catalogimport.commands.*" %>
<%@include file="../../tools/common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();
Integer storeId 	= cmdContextLocale.getStoreId();

Hashtable catalogImportNLS = (Hashtable)ResourceDirectory.lookup("catalogimport.catalogImportNLS", jLocale);

com.ibm.commerce.server.JSPHelper jHelper = new com.ibm.commerce.server.JSPHelper(request);

// get standard list parameters
int startIndex 		= Integer.parseInt(jHelper.getParameter("startindex"));
int listSize 		= Integer.parseInt(jHelper.getParameter("listsize"));
int endIndex		= startIndex + listSize;

//get the new Bean and perform the search
FileUploadListDataBean list = new FileUploadListDataBean();
list.setStoreId(storeId.toString());
list.setStartIndex(startIndex + "");
list.setMaxLength(listSize + "");
com.ibm.commerce.beans.DataBeanManager.activate(list, request);


int totalsize = 0;
if (list != null) {
	totalsize = list.getResultSetSize();
}
%>


<HTML>
<HEAD>
	<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">
	<TITLE><%= UIUtil.toHTML((String)catalogImportNLS.get("catalogImportListTitle")) %></TITLE>

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
	<SCRIPT src="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

	<SCRIPT LANGUAGE="JavaScript">
	//---------------------------------------------------------------------
	//  Required javascript function for wizard panel and list
	//---------------------------------------------------------------------
	function onLoad() {
		parent.loadFrames();
//		parent.setResultssize(<%= listSize %>);
//		parent.afterLoads();
//		parent.setButtonPos('0px',(document.all.list.offsetTop - 7) + 'px');
	}

	function getResultsSize() {
		return <%= totalsize %>;
	}

	function getCatalogUploadBCT() {
		return "<%=UIUtil.toJavaScript((String)catalogImportNLS.get("catalogImportListUploadBCT"))%>";
	}

	function getCatalogUploadImagesBCT() {
		return "<%=UIUtil.toJavaScript((String)catalogImportNLS.get("catalogImportListUploadImagesBCT"))%>";
	}

	function upload() {
		top.setContent(getCatalogUploadBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=catalogimport.catalogUpload',true);
	}

	function uploadImages() {
		top.setContent(getCatalogUploadImagesBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=filemgr.CatalogFilesDialog&filemgrResource=filemgr.CatalogView',true);
	}

	function publish() {
		var check = parent.getChecked();
		if (check.length == 1) {
			param = check[0].split('_');
			if (param[1] == "0") {
				fileUploadId = param[0];
				redirectURL = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=catalogimport.catalogImportList&cmd=CatalogImportListView";

				var url = "/webapp/wcs/tools/servlet/CatalogImportJobAdd";
				var urlPara = new Object();
				urlPara.fileUploadId=fileUploadId;
				urlPara.URL=redirectURL;

				top.showContent(url, urlPara);
			}
		}

	}

	function getCatalogViewLogBCT() {
		return "<%=UIUtil.toJavaScript((String)catalogImportNLS.get("catalogImportListViewLogBCT"))%>";
	}

	function viewlogs() {
		var check = parent.getChecked();
		if (check.length == 1) {
			param = check[0].split('_');
			if (param[1] == "3" || param[1] == "2") {
				top.setContent(getCatalogViewLogBCT(),'/wcs/tools/catalogimport/CatalogViewLog.html',true);
			}
		}
	}

	function refresh() {
		var url = "/webapp/wcs/tools/servlet/NewDynamicListView";
		var urlPara = new Object();
		urlPara.ActionXMLFile = "catalogimport.catalogImportList";
		urlPara.cmd = "CatalogImportListView";
		top.showContent(url, urlPara);
	}

	function disableButton(b) {
		if (defined(b)) {
			b.disabled=false;
			b.className='disabled';
			b.id='disabled';
		}
	}

	function isButtonDisabled(b) {
		if (b.className =='disabled' &&	b.id == 'disabled')
			return true;
		return false;
	}

	function checkButtons() {
		var check = parent.getChecked();
		if (check.length == 1) {
			param = check[0].split('_');

			if (param[1] != "0") {
			    if (isButtonDisabled(parent.buttons.buttonForm.catalogImportListPublishButton) == false) {
			    	disableButton(parent.buttons.buttonForm.catalogImportListPublishButton);
			    }
			}
			//Uncommented the if condition for  li1438
			//Modified (the if condition is commented) for defect # 113525
			if (param[1] != "3" && param[1] != "2") {
			    if (isButtonDisabled(parent.buttons.buttonForm.catalogImportListLogsButton) == false) {
			    	disableButton(parent.buttons.buttonForm.catalogImportListLogsButton);
			    }
			}
		}
	}

	parent.set_t_item_page(<%= totalsize %>, <%= listSize %>);
	</SCRIPT>
</HEAD>


<BODY CLASS="content">

<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
	onLoad();
}
-->
</SCRIPT>

<FORM NAME="CatalogImportForm" >
<P><%= catalogImportNLS.get("catalogImportListDescription") %><BR><BR>

<%= comm.startDlistTable("catalogImportListTable") %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(false) %>
<%= comm.addDlistColumnHeading((String)catalogImportNLS.get("catalogImportListFile"), null, false) %>
<%= comm.addDlistColumnHeading((String)catalogImportNLS.get("catalogImportListFileSize"), null, false) %>
<%= comm.addDlistColumnHeading((String)catalogImportNLS.get("catalogImportListUploadTime"), null, false) %>
<%= comm.addDlistColumnHeading((String)catalogImportNLS.get("catalogImportListStatus"), null, false) %>
<%= comm.endDlistRow() %>

<%
// determine the endindex for this page
if (endIndex > list.getListSize()) {
	endIndex = list.getListSize();
}

String [] statusNLV = new String[5];
statusNLV[0] = (String)catalogImportNLS.get("statusNew");
statusNLV[1] = (String)catalogImportNLS.get("statusPublishing");
statusNLV[2] = (String)catalogImportNLS.get("statusPublished");
statusNLV[3] = (String)catalogImportNLS.get("statusFailed");
statusNLV[4] = (String)catalogImportNLS.get("statusCancelled");

// TABLE CONTENT
int rowselect = 1;
for (int i=0; i<endIndex; i++) {
   FileUploadDataBean fileUploadDB = list.getFileUploadData(i);
   String fileUploadId = fileUploadDB.getFileUploadId();
   String fileName = fileUploadDB.getFileName();
   String fileSize = fileUploadDB.getFileSize();
   String timeCreated = fileUploadDB.getUploadTime();
   int status = Integer.parseInt(fileUploadDB.getStatus());
%>
	<%= comm.startDlistRow(rowselect) %>
<%
	if (i == 0) {
%>
	<%= comm.addDlistCheck(fileUploadId + "_" + status, "parent.setChecked(); checkButtons();") %>
<%
	} else {
%>
	<%= comm.addDlistCheck(fileUploadId + "_-1", "parent.setChecked(); checkButtons();") %>
<%
	}
%>
	<%= comm.addDlistColumn(fileName, "none") %>
	<%= comm.addDlistColumn(fileSize, "none") %>
	<%= comm.addDlistColumn(timeCreated, "none") %>
	<%= comm.addDlistColumn(statusNLV[status], "none") %>
	<%= comm.endDlistRow() %>
	<%
	if (rowselect == 1) {
		rowselect = 2;
	} else {
		rowselect = 1;
	}
}
%>
<%= comm.endDlistTable() %>

<%
if (false) {
%>

	<P><P>
	<TABLE CELLSPACING=0 CELLPADDING=3 BORDER=0>
	<TR>
		<TD COLSPAN=7>
		<%= UIUtil.toHTML((String)catalogImportNLS.get("catalogImportListNoItems")) %>
		</TD>
	</TR>
	</TABLE>
<% } %>
</FORM>


<SCRIPT LANGUAGE="JavaScript">
<!--
	parent.afterLoads();
	parent.setResultssize(getResultsSize());
//-->
</SCRIPT>


</BODY>
</HTML>
