<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page language="java" %>

<%@ page import="java.util.Locale" %>
<%@ page import="java.text.MessageFormat" %>
<%@ page import="com.ibm.commerce.ras.ECMessage" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.ras.ECMessageHelper" %>
<%@ page import="com.ibm.commerce.exception.ECException" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ConfigProperties" %>
<%@ page import="com.ibm.commerce.exception.ECSystemException" %>
<%@ page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@ page import="com.ibm.commerce.tools.devtools.store.databeans.StoreFrontDataBean" %>
<%@ page import="com.ibm.commerce.tools.devtools.store.databeans.StoreImageDataBean" %>
<%@ page import="com.ibm.commerce.tools.devtools.store.databeans.StoreWebPathDataBean" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@ page import="com.ibm.commerce.registry.StoreRegistry" %>

<% response.setHeader("Pragma", "No-cache"); %>
<% response.setDateHeader("Expires", 0); %>
<% response.setHeader("Cache-Control", "no-cache"); %>

<%@ taglib uri="flow.tld" prefix="flow" %>
<flow:fileRef id="logo" fileId="vfile.logo"/>

<%@include file="../../common/common.jsp" %>

<%
	//Parameters may be encrypted. Use JSPHelper to get URL parameters instead of request.getParameter().
	JSPHelper jhelper = new JSPHelper(request);	
	
try
{
	// Set resource bundle, command context and locale
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties storeLogoRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreLogoRB", locale);
	
	
	Integer StoreId= cmdContext.getStoreId();	
	String StoreDir= cmdContext.getStore(StoreId).getDirectory();

	
	/* Check if the logo was uploaded successfully
	 * success can have 3 values:  	n = file failed to upload 
	 *				y = file was successful in uploading
	 *				na = file was not uploaded
	 */				
	String uploadedSuccess = jhelper.getParameter("success");
	String uploadedFileExt = jhelper.getParameter("uploadFileExt");

	if (uploadedSuccess == null) {
		uploadedSuccess = "na";  // Set upload not attempted              
	}

	// Find out if "MC" is on store.storelevel
	String STORE_LEVEL = "MC";
	String strStoreLevel = null;	
	StoreAccessBean storeAB = StoreRegistry.singleton().find(StoreId);
	if (storeAB != null) {	
		strStoreLevel = storeAB.getStoreLevel();
		if (strStoreLevel == null) {
			Integer[] storePathIds = StoreUtil.getStorePath(storeAB.getStoreEntityIdInEntityType(), ECConstants.EC_STRELTYP_VIEW);
			StoreAccessBean relatedStoreAccessBean = null;
			boolean storeLevelFound = false;	
			for (int i=1; i<storePathIds.length; i++) {
				if (!storeLevelFound) {	
					relatedStoreAccessBean = StoreRegistry.singleton().find(storePathIds[i]);
					strStoreLevel = relatedStoreAccessBean.getStoreLevel();
					if (strStoreLevel != null) {
						storeLevelFound = true;
					}
				}
			}
		}
	}
	if (strStoreLevel != null && strStoreLevel.toUpperCase().contains(STORE_LEVEL.toUpperCase())) {
%>
		<html>
			<head>
				<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
				<script src="/wcs/javascript/tools/common/Util.js"></script>
				
				<script>
					function initializeState() {
						top.showProgressIndicator(false);
						alertDialog('<%=UIUtil.toJavaScript(storeLogoRB.get("Logo.managementCenter"))%>');
						top.setHome();
					}
				</script>
			</head>
			<body class="content" onload="initializeState();">
				<br>
			</body>
		</html>
<%
	} else {
%>

<html>
<head>
	<meta name="GENERATOR" content="IBM WebSphere Studio">
	<meta name="Expires" content="0">
	<meta name="Pragma" content="no-cache">
	<meta name="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>

	<%
	// Get the recommended logo size form the storefront.xml file
	String errMessage ="";  // Error message string
	
	StoreFrontDataBean storeFrontDataBean = new StoreFrontDataBean();
	try {
		storeFrontDataBean.setCommandContext(cmdContext);
		storeFrontDataBean.populate();
	} catch (Exception e) {
		errMessage = storeLogoRB.getProperty("Logo.notConfigurable");
	}
	%>

	<%
	// get the stores webapp path
//	String StoresWebPath = ConfigProperties.singleton().getValue("WebServer/StoresWebPath");
	String StoresWebPath = "";
	WebModuleConfig webApp = (WebModuleConfig) com.ibm.commerce.server.WebApp.retrieveObject("Stores");
	if (webApp != null) {
		StoresWebPath = webApp.getContextPath()+"/servlet";
	}
	String SSLPort = ConfigProperties.singleton().getValue("WebServer/SSLPort");
	String storeLogoFileName = "/images/logo.gif";
	boolean logoAvailable = true;
	
	if (logo == null) {
		errMessage = storeLogoRB.getProperty("Logo.notConfigurable");
	}
	else if (errMessage.equals("")) {
	
		// If the file is uploaded successfully, the system may not be updated in time for the 
		// flow.tld taglib to be updated to point to the correct file.  So we should override it.
		if (uploadedFileExt != null && uploadedSuccess.equals("y")) {	
			logo = new StringBuffer("images/logo.").append(uploadedFileExt).toString();
		}
		
		// Search for the logo in the store path
		try {
			StoreWebPathDataBean webPathBean = new StoreWebPathDataBean();
			webPathBean.setCommandContext(cmdContext);
			storeLogoFileName=webPathBean.getWebPath(logo);
		}catch (Exception e) {
			logoAvailable = false;
		}
	}
	
	if (!errMessage.equals("")) { 
		%>
		</head><body class="content">
		<br>
		<script>
			parent.setContentFrameLoaded(true);
			top.alertDialog('<%=UIUtil.toJavaScript(errMessage)%>');
			top.setHome();
		</script>
		</body></html>
		<%
		return;	
	}
	%>
	

	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script>
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{

		parent.put("StoreId", "<%=StoreId%>");
		parent.put("StoreDir", "<%=StoreDir%>");
		parent.put("StoresWebPath", "<%=StoresWebPath%>");
		parent.put("SSLPort", "<%=SSLPort%>");
		
		// Display current logo.  To avoid image browser caching, append the time and date.
		var today=new Date();
		var time=today.getMonth() +''+ today.getDay() +''+ today.getMinutes() +''+ today.getSeconds() + '=';
		
		<%
		if (logoAvailable) {
			%>

			var imgLocation = self.location.protocol + "//" + self.location.hostname + <% if(SSLPort != null){%> ":<%=SSLPort%>" + <%}%>"<%=storeLogoFileName%>?"+time.valueOf();
			document.UploadLogoForm.currentLogo.src = imgLocation;
			<%
		}
		%>
		
		<%
		/* Known exceptions that can be thrown:
		*
		* JSP developer errors:
		* ECMessage._ERR_UPLOAD_MISSING_REFCMD
		* ECMessage._ERR_UPLOAD_REFCMD_MISSING_CONFIG_PARAMS
		* ECMessage._ERR_CMD_INVALID_PARAM
		*
		* User errors (should be handled)
		* ECMessage._ERR_UPLOAD_FILECONTENTTYPE_NOTALLOWED
		* ECMessage._ERR_UPLOAD_FILETYPE_NOTALLOWED
		* ECMessage._ERR_UPLOAD_FILESIZE_TOOBIG
		*
		* System erros:
		* ECMessage._ERR_UPLOAD_FILESAVE_EXCEPTION
		* ECMessage._ERR_REMOTE_EXCEPTION
		*
		* Should never happen:
		* ECMessage._ERR_UPLOAD_JAR_CONTAINS_FILETYPE_NOTALLOWED
		*/
					
		if (uploadedSuccess.equals("n")) {
			String msgKey = jhelper.getParameter("key");
			String displayMsg = null;

			if (msgKey == null) {
				displayMsg = storeLogoRB.getProperty("Logo.systemError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILECONTENTTYPE_NOTALLOWED.getKey())) {
				displayMsg = storeLogoRB.getProperty("Logo.fileTypeError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILETYPE_NOTALLOWED.getKey())) {
				displayMsg = storeLogoRB.getProperty("Logo.fileExtensionError");
			}else if (msgKey.equals(ECMessage._ERR_UPLOAD_FILESIZE_TOOBIG.getKey())) {
				displayMsg = storeLogoRB.getProperty("Logo.fileSizeError");
			}else if (msgKey.equals(ECMessage._ERR_FILE_NOT_FOUND.getKey())) {
				displayMsg = storeLogoRB.getProperty("Logo.fileNotFoundError");
			}else {
				displayMsg = storeLogoRB.getProperty("Logo.systemError");	
			}
			
			%>
			alertDialog('<%=UIUtil.toJavaScript(displayMsg) %>');
			<%
		}
		%>
		parent.setContentFrameLoaded(true);
	}

	
	function UploadAndApplyButton() 
	{
       		if (parent.isContentFrameLoaded() == false) 
       		{
              		return;
       		}
	
		if (document.UploadLogoForm.filename.value=="") {
			alertDialog('<%=UIUtil.toJavaScript(storeLogoRB.getProperty("Logo.AlertMinLength"))%>');
			return;
		}

		// Lets check the upload file extension.  We want to rename any file uploaded to logo.gif or logo.jpg
		uploadFileName = document.UploadLogoForm.filename.value;
		var pathstart = /^[a-zA-Z]:\\/;
		if ( ! uploadFileName.match( pathstart )) {
			alertDialog( '<%=UIUtil.toJavaScript(storeLogoRB.getProperty("Logo.fileNotFoundError"))%>' );
			return;
		}		
		strLength = uploadFileName.length;
		if (strLength > 3) {
			uploadFileExt = uploadFileName.substr(strLength-3,strLength-1);
			if (uploadFileExt.toLowerCase() == "jpg") {
				document.UploadLogoForm.rename.value = "logo.jpg";
				document.UploadLogoForm.URL.value='StoreLogoDialogView?success=y&uploadFileExt=jpg';
				}
		}

		top.showProgressIndicator(true);
		
		document.UploadLogoForm.submit();
	}
	
	function writeLogoSize() {
		document.getElementById('logoSizeDiv').innerHTML = 
			'<%=UIUtil.toJavaScript(storeLogoRB.getProperty("Logo.currentSize"))%>&nbsp;' + 
			document.UploadLogoForm.currentLogo.width + "x" + document.UploadLogoForm.currentLogo.height + 
			"&nbsp;<%=UIUtil.toJavaScript(storeLogoRB.getProperty("Logo.pixels"))%>";
	}
	
</script>


<body class="content" onload="initializeState();">

<h1><%= storeLogoRB.getProperty("Logo.title") %></h1>
<%= storeLogoRB.getProperty("Logo.instructions")%>

<%
// Check to is if a recommended max height and max width are specified in the storefront.xml file
%>
<jsp:useBean id="sidb" class="com.ibm.commerce.tools.devtools.store.databeans.StoreImageDataBean" scope="request">
<% sidb.setImageId("logo"); %>
<% com.ibm.commerce.beans.DataBeanManager.activate(sidb, request); %>
</jsp:useBean>	

<%
if (sidb !=null) {
	String imgHeight = sidb.getMaxWidth();
	String imgWidth = sidb.getMaxHeight();
	
	if (imgHeight != null && imgWidth != null) {
		Object[] arguments = {imgHeight, imgWidth};
		%>
		<br><br><%=MessageFormat.format(ECMessageHelper.doubleTheApostrophy(storeLogoRB.getProperty("Logo.note")),arguments)%>
		<%
	}
}
%>

	
<br>
<%
if (uploadedSuccess.equals("y")) {
	%>
	<br><b><%= storeLogoRB.getProperty("Logo.success") %></b>
	<br><%= storeLogoRB.getProperty("Logo.refresh") %>
	<%
}
%>
<br>
<table border="0">
<tr>
	<td>
	
		<form enctype="multipart/form-data" method="post" name="UploadLogoForm" action="StoreLogoUpdate">
			<input type="hidden" name="errorURL" value="StoreLogoDialogView?success=n" />
			<input type="hidden" name="URL" value="StoreLogoDialogView?success=y&uploadFileExt=gif" />
			<input type="hidden" name="filepath" value="images" />
			<input type="hidden" name="refcmd" value="StoreLogoUpdate" />
			<input type="hidden" name="rename" value="logo.gif" />
			<br />
			<label for="filename"><%= storeLogoRB.getProperty("Logo.fileInput.title")%></label>
			<br />
			<input type="file" style="width: 300px;" name="filename" id="filename"/>
			<br />
			<input type="button" class="button" name="upload" value="<%= storeLogoRB.getProperty("Logo.uploadButton")%>" id="nbp" onClick="UploadAndApplyButton()" />
	</td>
</tr>        
<tr>
	<td>		
			<br />
			<br />
			<%
			if (logoAvailable) {
				%>
				<%= storeLogoRB.getProperty("Logo.currentLogo") %>
				<br />
				<table cellpadding="0" cellspacing="0" border="0" width="1">
				<tr>
					<td bgcolor="#CCCCCC"><img alt="<%= storeLogoRB.getProperty("Logo.currentLogo") %>" src="#" name="currentLogo" onload="writeLogoSize();"/></td>
				</tr>
				</table>
				<%
			}
			%>
			<br />
			<div id="logoSizeDiv"></div>
			<br />
		</form>         
	</td>
</tr>
</table>

</body>
</html>

<%
}
}
catch (Exception e) 
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
