<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.exception.ECException" %>

<%@include file="../../common/common.jsp" %>

<%
try {
	JSPHelper jspHelper = new JSPHelper(request);
	String filemgrResource = jspHelper.getParameter("filemgrResource");

	Hashtable model = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(filemgrResource);
	Hashtable filemgr = (Hashtable) model.get("ibm-wc-filemgr");

	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties uploadRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("filemgr.StoreFilesUploadRB", locale);
	ResourceBundleProperties filemgrRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup((String)filemgr.get("resource-bundle"), locale);
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>

	function uploadFile() {	   
		if (UploadForm.filename.value == "") {
			alertDialog("<%= uploadRB.getJSProperty("Upload.alert.minLength")%>");
			return;
		}

		var node = parent.tree.getHighlightedNode();
				
		if (node != null && node.contextMenu == "mf"){
			UploadForm.isFilePath.value = true;			
		}

		if (node == null || node.contextMenu == "fileAll") {
			alertDialog("<%= uploadRB.getJSProperty("Upload.alert.highlightFolder")%>");
			return;
		}
		
		top.showProgressIndicator(true);
		UploadForm.filepath.value = node.value;		
		UploadForm.newfile.value=UploadForm.filename.value;
		UploadForm.zipFile.value=UploadForm.checkZip.checked;
		UploadForm.submit();
		var authToken = parent.get("authToken");
		if (defined(authToken)) {
			parent.addURLParameter("authToken", UploadForm.authToken.value);	  
		}
	}

</script>

</head>

<body class="content">
<h1><%= filemgrRB.getProperty((String)filemgr.get("title"))%></h1>
<%= filemgrRB.getProperty((String)filemgr.get("instructions"))%>

<!--  <form enctype="multipart/form-data" method="post" name="UploadForm" action="StoreFileUpload" target="_parent"> -->
<form enctype="multipart/form-data" method="post" name="UploadForm" action="CatalogFileLoaderUpload" target="_parent"> 
	<input type="hidden" name="errorURL" value="StoreFilesDialogView" />
	<input type="hidden" name="authToken" value="${authToken}" id="WC_CatalogFileLoaderUpload_FormInput_authToken"/>
	<input type="hidden" name="<%= com.ibm.commerce.server.ECConstants.EC_URL %>" value="StoreFilesDialogView" />
	<input type="hidden" name="filemgrResource" value="<%= filemgrResource %>">
	<input type="hidden" name="filepath" value="" />
 	<input type="hidden" name="newfile" value="" /> 
 	<input type="hidden" name="zipFile" value="" />
 	<input type="hidden" name="isFilePath" value="" />
	
<!-- 	<input type="hidden" name="refcmd" value="StoreFileUpload" /> -->
  	<input type="hidden" name="refcmd" value="CatalogFileLoaderUpload" /> 
	<label for="filename"><%= uploadRB.getProperty("Upload.title")%></label>
	<br />
	<input id="filename" type="file" style="width: 300px;" name="filename" />
	<br />
	<br /> 
    
	<input type="checkbox" id="checkZip" name="checkZip"/> 
	<label for="checkZip"><%= uploadRB.getProperty("Upload.zipFile")%></label>
 
	<br /> 
	<input type="button" class="button" name="upload" value='<%= uploadRB.getProperty("Upload.button")%>' id="nbp" onClick="uploadFile(); return false;" onSubmit="parent.makeBusy()" />
</form>

<%= filemgrRB.getProperty((String)filemgr.get("instructions-tree"))%>
<%
} catch (Exception e) {
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>

</body>
</html>
