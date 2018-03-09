<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<% 
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           BLI       Creation Date
// 041206    96655  BLI       Made changes to preview path
// 040105    97731  BLI       Added port in the url to preview attachment file
// 040110    98329  BLI       Created a new row for the view title
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.comm" %>
<%@ page import="com.ibm.commerce.server.MimeUtils" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="java.text.MessageFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ page import="com.ibm.commerce.server.WcsApp" %>
<%@ page import="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>


<%@include file="../common/common.jsp" %>
<%@include file="../attachment/Worksheet.jspf" %>

<%	response.setContentType("text/html;charset=UTF-8"); %>

<%
	// obtain the common campaign resource bundle for NLS properties
	CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS", jLocale);	

	JSPHelper jspHelper  = new JSPHelper(request);
	String orderByParm     = jspHelper.getParameter("orderby");
	String launchTool      = jspHelper.getParameter("tool");
	String strDirectoryId  = jspHelper.getParameter("directoryId");
	String port            = WcsApp.configProperties.getWebModule(CMWSPreviewConstants.PREVIEW_WEBAPP_NAME).getSSLPort().toString();
	String url             = request.getRequestURL().toString();
	String urlForPreview   = getPreviewPath(url , port);
	
	int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize   = Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex   = startIndex + listSize;

	String view = jspHelper.getParameter("view");
	String thumbnailViewSelected 	= "";
	String listViewSelected 		= "";

	String fHeader = "<META HTTP-EQUIV='Cache-Control' CONTENT='no-cache'>" + "<LINK rel='stylesheet' href='" + UIUtil.getCSSFile(jLocale) + "'>";
%>

<html>
	<%=fHeader%>
	<head>
	<title><%= rbAttachment.get("PickAttachmentAssetsToolResultList_Title") %></title>

	<jsp:useBean id="myAttachmentResultDataBean" scope="request" class="com.ibm.commerce.tools.attachment.beans.AttachmentResultDataBean">
	<jsp:setProperty name="myAttachmentResultDataBean" property="*" />
<%
		myAttachmentResultDataBean.setIndexBegin("" + startIndex);
		myAttachmentResultDataBean.setIndexEnd("" + endIndex);
		DataBeanManager.activate(myAttachmentResultDataBean, request,null);
%>
	</jsp:useBean>

<%
	int myCount 	= myAttachmentResultDataBean.getResultSetSize();
	int totalsize 	= myCount;
	int totalpage 	= totalsize/listSize;
	
	String errorCode = myAttachmentResultDataBean.getErrorCode();
	
	MessageFormat mf = new MessageFormat((String) rbAttachment.get("PickAttachmentAssetsToolResultList_DuplicateManagedFiles"));
	Object[] args = {errorCode};
	String duplicateManagedFileMessage = mf.format(args);

	Hashtable hAttachmentPropertiesXML = (Hashtable)ResourceDirectory.lookup("attachment.AttachmentProperties");
	Hashtable hAttachmentProperties = (Hashtable) hAttachmentPropertiesXML.get("attachmentProperties");
	Hashtable hAttachmentMimeTypes = (Hashtable) hAttachmentProperties.get("previewMimeType");
	Vector vAttachmentMimeTypes = (Vector) hAttachmentMimeTypes.get("mimeType");
	Vector attachmentMimeTypes = new Vector();
	Hashtable hMimeType;
	
	for (int i = 0; i < vAttachmentMimeTypes.size(); i++) {
		hMimeType = (Hashtable) vAttachmentMimeTypes.elementAt(i);
		attachmentMimeTypes.addElement(hMimeType.get("value"));
	}
%>

	<script language="JavaScript" src="<%=UIUtil.getWebPrefix(request)%>javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
	<script language="JavaScript" src="<%=UIUtil.getWebPrefix(request)%>javascript/tools/common/dynamiclist.js"></script>
	<script language="JavaScript" src="<%=UIUtil.getWebPrefix(request)%>javascript/tools/common/Util.js"></script>
	<script language="JavaScript" src="<%=UIUtil.getWebPrefix(request)%>javascript/tools/catalog/button.js"></script>
	<script language="JavaScript">	
	
		var attachmentFileSet			= new AttachmentFileSet();
		var selectedAttachmentFileSet 	= top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
		<% if ( myAttachmentResultDataBean.isCorruptedManagedFile() ) { %>
			var corruptedManagedFile = true ;
		<% } else { %>	
			var corruptedManagedFile = false ;
		<% } %>

		if (selectedAttachmentFileSet == null) {
			selectedAttachmentFileSet = new Array();
		}

		/**
		*	this function triggers when a file is selected
		*/
		function performUpdate(isAll, checkObject, index) {

			var objectChecked = false;
			
			if (isAll) {
			
				checkAll(checkObject.checked);
				
			} else {
				
				eval("objectChecked = attachmentAssetsListFORM.fileset_" + index + ".checked;");
							
				if (!parent.parent.selectMultiple) {
					checkAll(false);
				}

				eval("attachmentAssetsListFORM.fileset_" + index + ".checked = objectChecked;");
				attachmentFileSet.checkFile(checkObject.value, objectChecked);
			}
			
			selectedAttachmentFileSet = attachmentFileSet.getSelectedFiles();
<%		if (view.equals("list")) { %>
			if (parent.parent.selectMultiple) {
				attachmentList.rows(0).cells(0).firstChild.checked = (selectedAttachmentFileSet.length == getResultsSize());
			}
<%		} %>
			top.saveData(selectedAttachmentFileSet, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
			parent.parent.masterGlobalFrameActionButtons1Id.enableAssignButton((selectedAttachmentFileSet.length > 0));
		}

		/**
		*	check all checkboxes
		*/
		function checkAll(value) {

			attachmentFileSet.checkAll(value);

			for (var i = 0; i < <%=myAttachmentResultDataBean.getListSize()%>; i++) {
				eval("attachmentAssetsListFORM.fileset_" + i + ".checked = value;");
			}
		}

		/**
		*	return the number of result submitted
		*/
		function getResultsSize () 
		{
			return <%=myCount%>;
		}

		/**
		*	upload file to the current directory
		*/
		function uploadFile() {

			if (trim(uploadFileForm.filename.value) == "")
			{
				alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_EmptyFile"))%>');
				return;
			}
		
			top.showProgressIndicator(true);

			var newDirectory = new Object();
			newDirectory.id = parent.parent.currentTreeNode.id;
			newDirectory.create = false;
			top.saveData(newDirectory, "newDirectory");

			document.uploadFileForm.url.value = "PickAttachmentAssetsToolResult";
			document.uploadFileForm.directory.value = "" + parent.parent.currentTreeNode.path;
			document.uploadFileForm.action = "AttachmentUpload";
			document.uploadFileForm.submit();
		}
		
		/**
		*	show thumbnail view
		*/
		function switchView(view) {
		
			var attachmentView = view;

			top.saveData(attachmentView, "attachmentView");
			
<%			if (launchTool == null || launchTool.equalsIgnoreCase("search")) {%>
				parent.parent.setSearchResultListFrame(parent.parent.searchForm.searchCriteria);
<%			} else {%>
				parent.parent.setBrowseResultListFrame("<%=UIUtil.toJavaScript(strDirectoryId)%>");
<%			} // if %>
		}
		
		/**
		*	init function
		*/
		function onLoad () {
			parent.loadFrames();

<%		if (view.equals("thumbnail")) { %>
			resizeImages(120);
<%		} %>

            if (corruptedManagedFile) {
            	alertDialog("<%=UIUtil.toJavaScript(duplicateManagedFileMessage)%>");
            }

		}
		
		/**
		*	resize all images on this document
		*/
		function resizeImages(size) {

			var images = document.images;
			var image = null;
			var ratio = 0;
			
			for (var i = 0; i < images.length; i++) {

				image = images[i];

				if (image.width > image.height) {
					
					ratio = size / image.width;
					image.height = image.height * ratio;

				} else {

					image.height = size;
				}

			}
		}

</script>
</head>

<body onload="onLoad();" class="content_list" oncontextmenu="return false;" style="margin-right:20px">

	<script language="JavaScript">
	
		var filename;
		var cmFilePath;
		var atchTgtId;
		var mimeType;
		var checked = false;

<%	for (int i = 0; i < myAttachmentResultDataBean.getListSize(); i++) { %>

		filename	= "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilename())%>";
		cmFilePath	= "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>";
		atchTgtId	= "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getAttachmentTargetId())%>";
		mimeType 	= "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getMimeType())%>";
		checked		= false;
		
		attachmentFileSet.updateFile(filename, cmFilePath, atchTgtId, checked, mimeType, parent.atchAstId);

<%	} // for %>
	
		parent.set_t_item_page(<%=totalsize%>, <%=listSize%>);
		
		var tableString = "";
		var pictureSize = 120;
		var offSet = 100;
		var windowsWidth = document.documentElement.clientWidth;
		var currentWidth = offSet;
		
	</script>


	
<%		
		if (view.equals("thumbnail")) {
			thumbnailViewSelected = "selected";
		} else {
			listViewSelected = "selected";
		}
%>

		<table border="0" cellpadding="0" cellspacing="0" width="100%">

		<tbody>
		
		<tr>
			<td height="1" valign="top" align="left"><label for=viewOptions><%=UIUtil.toHTML((String) rbAttachment.get("View"))%></label><br/></td>
		</tr>
		
		<tr>
			<td height="1" valign="top" align="left">
				<select name=viewOptions id="viewOptions" onchange="switchView(viewOptions.options[viewOptions.selectedIndex].value)">
					<option <%=listViewSelected%> value='list'/><%=UIUtil.toHTML((String) rbAttachment.get("ListView"))%>
					<option <%=thumbnailViewSelected%> value='thumbnail'/><%=UIUtil.toHTML((String) rbAttachment.get("ThumbnailView"))%>
				</select>
			</td>
<%
			if (launchTool == null || launchTool.equalsIgnoreCase("search") == false) 
			{ 
%>
				<td height="1" valign="top" align="right">
                    <label for="filename" class="hidden-label"><%=UIUtil.toHTML((String) rbAttachment.get("PickAttachmentAssetsToolResultList_Browse_Filename"))%></label>
					<form enctype="multipart/form-data" method="post" name="uploadFileForm" action="">
						<input type="hidden" name="url" value="test"/>
						<input type="hidden" name="directory" value="testDirectory"/>
						<input type="file" id="filename" name="filename"/>&nbsp;
						<button id="nbp" onclick="uploadFile(); return false;"><%=UIUtil.toHTML((String) rbAttachment.get("PickAttachmentAssetsToolResultList_Upload_Button"))%></button>
					</form>
				</td>
<%
			}
%>
		</tr>
		
		</tbody></table>
		
		<form name="attachmentAssetsListFORM" id="attachmentAssetsListFORM">
<%		if (view.equals("thumbnail")) { %>
			<table id="attachmentThumbnailTable" class="attachmentThumbnailTable" border="0" cellpadding="2" cellspacing="2" 
<%			if (myCount == 0) { %> style="display:none;" > <% }
			else              { %> > <% } %>
			<tbody><tr>
<%			for (int i = 0; i < myAttachmentResultDataBean.getListSize(); i++) { 

				String mimeType = com.ibm.commerce.server.MimeUtils.getContentTypeFromFilename(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath());
				String imagePath = "";

				// display preview if it's an image
				if (isPreviewMimeType(mimeType, attachmentMimeTypes)) {
					imagePath = urlForPreview  + myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath();
					
				// display no preview available
				} else {
					imagePath = "/wcs/images/tools/attachment/generic_file.jpg";
				}
%>
				<script>

<%		if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize().equals(ECAttachmentConstants.EC_ATCH_URL_FILESIZE)) { %>

				tableString += '<td width=120 align="center">';
				tableString += '<input type="checkbox" name="fileset_<%=i%>" onclick="performUpdate(false, this, <%=i%>);" value="<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>"/><br/>';
				tableString += '<a href="<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>" target="_blank"><img border=1 height=120 src="<%=UIUtil.toJavaScript(imagePath)%>"/></a>';
				tableString += '<br/><font size="1"><%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilename())%></font>';
				tableString += '</td>';
<%		} else if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize().equals(ECAttachmentConstants.EC_DUPLICATE_MANAGED_FILE)) { %>
				var filesSize = "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize())%>";
				tableString += '<td width=120 align="center">';
				tableString += '<input disabled type="checkbox" name="" onclick="" value=""/><br/>';
				tableString += '<img border=1 height=120 src="<%=UIUtil.toJavaScript(imagePath)%>"/>';
				tableString += '<br/><font size="1"><b><%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilename())%></b></font>';
				tableString += '<br/><font size="1">' + filesSize + '</font>';
				tableString += '</td>';			
<%		} else { %>

				var filesSize = <%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize())%>;
				filesSize = filesSize / 1000.0;
				if (filesSize < 1) { 
					filesSize = 1 
				};
				filesSize = top.numberToStr(filesSize, <%=((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString()%>, 0);

				tableString += '<td width=120 align="center">';
				tableString += '<input type="checkbox" name="fileset_<%=i%>" onclick="performUpdate(false, this, <%=i%>);" value="<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>"/><br/>';
				tableString += '<a href="<%=UIUtil.toJavaScript(urlForPreview + myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>" target="_blank"><img border=1 height=120 src="<%=UIUtil.toJavaScript(imagePath)%>"/></a>';
				tableString += '<br/><font size="1"><%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilename())%></font>';
				tableString += '<br/><font size="1">' + filesSize + ' <%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolResultList_SizeUnit"))%></font>';
				tableString += '</td>';

<%		} %>
					

					
					currentWidth += pictureSize;
					
					if (currentWidth > (windowsWidth - offSet)) {
						tableString += '</tr><tr>';
						currentWidth = offSet;
					}
				</script>

<%			} // for %>
				<script>
				tableString += '</tr>';
				document.writeln(tableString);
				</script>
			</tbody></table>
<%		} else { %>

			<%=comm.startDlistTable("attachmentList")%>
			<%=comm.startDlistRowHeading()%>
			<script>addDlistCheckHeading(parent.parent.selectMultiple, "performUpdate(true, this);");</script>
<%			if (launchTool == null || launchTool.equalsIgnoreCase("search")) {%>
				<%=comm.addDlistColumnHeading((String) rbAttachment.get("PickAttachmentAssetsToolResultList_Search_Filename"), null, false)%>
<%			} else {%>
				<%=comm.addDlistColumnHeading((String) rbAttachment.get("PickAttachmentAssetsToolResultList_Browse_Filename"), null, false)%>
<%			} // if %>
			<%=comm.addDlistColumnHeading("&nbsp;", null, false, "2")%>
			<%=comm.addDlistColumnHeading((String) rbAttachment.get("PickAttachmentAssetsToolResultList_Size"), null, false)%>
			<%=comm.endDlistRow()%>
<%
			if (endIndex > myCount) {
				endIndex = myCount;
			}
	
			for (int i = 0; i < myAttachmentResultDataBean.getListSize(); i++) {
			
				String alt = (String) rbAttachment.get("PickAttachmentAssetsToolResultList_ManagedFile");
				String multiLang = "<img alt='" + alt + "' src='/wcs/images/tools/attachment/unknown_or_new.gif'>";

				if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getAttachmentType().equals(ECAttachmentConstants.EC_ATCH_LANGUAGE_TYPE_UNIVERSAL)) {
				
					alt = (String) rbAttachment.get("PickAttachmentAssetsToolResultList_Universal");
					multiLang = "<img alt='" + alt + "' src='/wcs/images/tools/attachment/non_language_specified.gif'>";
					
				} else if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getAttachmentType().equals(ECAttachmentConstants.EC_ATCH_LANGUAGE_TYPE_SPECIFIC)) {
				
					alt = (String) rbAttachment.get("PickAttachmentAssetsToolResultList_LanguageSpecified");
					multiLang = "<img alt='" + alt + "' src='/wcs/images/tools/attachment/language_specific.gif'>";
				}
%>

			<%=comm.startDlistRow((i % 2) + 1)%>
	
			<script>

<%		if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize().equals(ECAttachmentConstants.EC_ATCH_URL_FILESIZE)) { %>
				var filesSize = "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize())%>";
				addDlistCheck("fileset_<%=i%>", "performUpdate(false, this, <%=i%>);", "<%= UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>");
				addDlistColumn("<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getDisplayName())%>", '<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>" target="_blank"', "none");
				addDlistColumn("<%=multiLang%>", "none", "width:10px;");
				addDlistColumn(filesSize, "none", "width:100px;text-align:right;");

<%		} else if (myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize().equals(ECAttachmentConstants.EC_DUPLICATE_MANAGED_FILE)){ %>				
				var filesSize = "<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize())%>";
				//addDlistCheck("fileset_<%=i%>", "performUpdate(false, this, <%=i%>);", "<%= UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>");
				addDlistCheck("", "", "");
				addDlistColumn("<b>  <%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getDisplayName())%> </b>", "none", "none");
				addDlistColumn("<%=multiLang%>", "none", "width:10px;");
				addDlistColumn(filesSize, "none", "width:100px;text-align:right;");				
<%		} else { %>

				var filesSize = <%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFileSize())%>;
				filesSize = filesSize / 1000.0;
				if (filesSize < 1) {
					filesSize = 1 ;
				}
				filesSize = top.numberToStr(filesSize, <%=((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLanguageId().toString()%>, 0);
				addDlistCheck("fileset_<%=i%>", "performUpdate(false, this, <%=i%>);", "<%= UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>");
				addDlistColumn("<%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getDisplayName())%>", '<%=urlForPreview%><%=UIUtil.toJavaScript(myAttachmentResultDataBean.getAttachmentDataBeanAt(i).getFilenamePath())%>" target="_blank"', "none");
				addDlistColumn("<%=multiLang%>", "none", "width:10px;");
				addDlistColumn(filesSize + " <%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolResultList_SizeUnit"))%>", "none", "width:100px;text-align:right;");


<%		} %>
			</script>

			<%=comm.endDlistRow()%>

<%			}  // for %>

			<%=comm.endDlistTable()%>

		
<%		} // if %>

<%			if (myCount == 0) { %>
<%				if (launchTool == null || launchTool.equalsIgnoreCase("search")) {%>

			<p/><p/><%=rbAttachment.get("PickAttachmentAssetsToolResultList_Search_EmptyMessage")%>
<%				} else {%>
			<p/><p/><%=rbAttachment.get("PickAttachmentAssetsToolResultList_Browse_EmptyMessage")%>
<%				} // if %>

<%		} // else %>

	</form>

	<script language="JavaScript">
	
		parent.afterLoads();
		parent.setResultssize(getResultsSize());
		
	</script>
	<br/><br/>




</body>

</html>