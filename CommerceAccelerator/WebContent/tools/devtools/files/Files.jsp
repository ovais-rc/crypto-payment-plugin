<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
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

<%@page import="com.ibm.commerce.beans.ErrorDataBean" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@page import="com.ibm.commerce.server.ConfigProperties" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Locale" %>
<%@page import="com.ibm.commerce.tools.common.ui.UIProperties" %>

<%@include file="../../common/common.jsp" %>

<%
try {
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties dialogRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("filemgr.StoreFilesRB", locale);

	JSPHelper jspHelper = new JSPHelper(request);
	String filemgrResource = jspHelper.getParameter("filemgrResource");

	Hashtable model = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(filemgrResource);
	Hashtable filemgr = (Hashtable) model.get("ibm-wc-filemgr");

%>

<%
	ErrorDataBean errorBean = new ErrorDataBean ();
	com.ibm.commerce.beans.DataBeanManager.activate(errorBean, request);
%>
<head>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<script>
	var busy = false;
	function isBusy() {
		return busy;
	}
	
	function makeBusy() {
		top.showProgressIndicator(true);
		busy = true;
	}

	/******************************************************************************
	*
	*	Input validation.
	*
	******************************************************************************/
	function validateFilename(str) {
		if (str == null)
			return -1;

		pattern = new RegExp("[\/*?\"<>:|%]");
		return str.search(pattern);
	}

	function getMaxLength() {
		var rootDirLength = <%= new File(new StringBuffer(ConfigProperties.singleton().getWebServerAlias("wcsstore")).append(File.separator).append(cmdContext.getStore().getDirectory()).toString(), (String) filemgr.get("sub-directory")).getAbsolutePath().toString().length() %>;
		var maxPath = 250 - rootDirLength;
		return (maxPath < 215) ? maxPath : 215;
	}
	
	function getParentLength() {
		var node = tree.getHighlightedNode().value;

		node = node.substring(0, node.length - 1); // remove the trailing slash

		var index = node.lastIndexOf("/");
		
		if (index == -1) {
			index = node.lastIndexOf("\\");
		}
		
		if (index == -1)
			return 0;

		return index + 2;
	}
	
	function validateFileLength(str) {
		var allowedLength = getMaxLength() - getParentLength();
		if (str.length > allowedLength)
			return false;
		return true;
	}

	function validateDirectoryLength(str) {
		var allowedLength = getMaxLength() - tree.getHighlightedNode().value.length;
		if (str.length > allowedLength)
			return false;
		return true;
	}

	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState() {
		<%
			String alertMsg = "";
			String errorMsg = "";
			if (errorBean.getExceptionType() == com.ibm.commerce.exception.ECException.APPLICATION_ERROR) {
				errorMsg = errorBean.getMessage();
			} else {
				errorMsg = errorBean.getSystemMessage();
			}
			
			// modified for defect 145368
			//String sucMsgFrmCmd = jspHelper.getParameter("SubmitFinishMessage");
			//String errorMsgFrmCmd = jspHelper.getParameter("SubmitErrorMessage");

			//if (sucMsgFrmCmd != null && sucMsgFrmCmd !="")
			//	alertMsg = sucMsgFrmCmd;
			//else if (errorMsgFrmCmd != null && errorMsgFrmCmd !="")
			//	alertMsg = errorMsgFrmCmd;
			//else 
			//	alertMsg = errorMsg;
			
			String strResourceName	= "catalogimport.catalogImportNLS";				
			String failMsgName 		= "msgUploadFailed";						//failMsgName
			String failMsg 			= null;										//default failMsg
			String successMsgName	= "msgUploadFinished";						//successMsg
			String successMsg		= null;										//default successMsg
			String fileSelectFailure = "msgFileSelectFailure";
			
 			Hashtable 	resourceNL = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup(strResourceName, locale);			
 			 			
			String successStatus = jspHelper.getParameter(UIProperties.SUBMIT_FINISH_STATUS);
			
			if (successStatus != null)
			{
				if (successStatus.equalsIgnoreCase("SUCCESS")){
					String strTemp=null;				
				    if ( resourceNL != null ){			  
					   strTemp = (String) resourceNL.get(successMsgName);				
				    }				   
					if (strTemp != null){
				   		successMsg = strTemp;				   				   				   				   
					}
				}												
			}
			
			String errorStatus = jspHelper.getParameter(UIProperties.SUBMIT_ERROR_STATUS);			
			
			if (errorStatus != null)
			{
				if(errorStatus.equalsIgnoreCase("ERROR"))	
				{
					String strTemp=null;
				
				    if ( resourceNL != null ){			   
					   strTemp= (String) resourceNL.get(failMsgName);
			    	}
				   
					if (strTemp != null){
					   failMsg = strTemp;
					}
				}
				// modified for displaying error message
				else if(errorStatus.equalsIgnoreCase("FILE_ERROR"))	
				{
					String strTemp=null;
				
				    if ( resourceNL != null ){			   
					   strTemp= (String) resourceNL.get(fileSelectFailure);
			    	}
				   
					if (strTemp != null){
					   failMsg = strTemp;
					}
				} // modification ends
				 
			}

			if (successMsg != null && successMsg !="")
				alertMsg = successMsg;
			else if (failMsg != null && failMsg !="")
				alertMsg = failMsg;
			else 
				alertMsg = errorMsg;				
		%>
		
		var alertMsg = "<%= UIUtil.toJavaScript(alertMsg) %>";
		if (alertMsg != "")
			alertDialog(alertMsg);

		parent.setContentFrameLoaded(true);
	}

	/******************************************************************************
	*
	*	Tree hooks.
	*
	******************************************************************************/
	function remove() {
		var node = tree.getHighlightedNode();

		FileTreeForm.action.value = "delete";
		FileTreeForm.filename.value = tree.getNamePath(node);
		FileTreeForm.submit();
	}

	function deleteDirectory() { if (!isBusy()) remove(); }
	function deleteFile() { if (!isBusy()) remove(); }

	function rename() {
		var node = tree.getHighlightedNode();
		var defaultVal = node.name;
		var index = defaultVal.lastIndexOf(".");
		var ext = "";
		if (index != -1) {
			ext = defaultVal.substr(index, defaultVal.length - 1); 
			defaultVal = defaultVal.substr(0, index);
		}

		var result;
		
		while (true) {
			result = promptDialog("<%= dialogRB.getJSProperty("Files.rename.prompt") %>", defaultVal);

			if (result == null)
				return;
		
			if (trim(result) == "") {
				alertDialog("<%= dialogRB.getJSProperty("Files.alert.empty") %>");
			} else if (validateFilename(result) > -1) {
				alertDialog("<%= dialogRB.getJSProperty("Files.alert.characters") %>");
			} else if (!validateFileLength(result)) {
				var msg = "<%= dialogRB.getJSProperty("Files.alert.length") %>";
				var length =  getMaxLength() - getParentLength() + 1;
				alertDialog(msg.replace("{0}", length));
			} else {
				break;
			}
		}
		
		result = result + ext;
		
		FileTreeForm.action.value = "rename";
		FileTreeForm.filename.value = node.value;
		FileTreeForm.renameTo.value = result;
		FileTreeForm.submit();
	}

	function renameFile() { if (!isBusy()) rename(); }
	function renameDirectory() { if (!isBusy()) rename(); }

	function createDirectory() {
		if (isBusy())
			return;
	
		var result;
		
		while (true) {
			result = promptDialog("<%= dialogRB.getJSProperty("Files.createDir.prompt") %>");
			
			if (result == null)
				return;
		
			if (trim(result) == "") {
				alertDialog("<%= dialogRB.getJSProperty("Files.alert.empty") %>");
			} else if (validateFilename(result) > -1) {
				alertDialog("<%= dialogRB.getJSProperty("Files.alert.characters") %>");
			} else if (!validateDirectoryLength(result)) {
				var msg = "<%= dialogRB.getJSProperty("Files.alert.length") %>";
				var length = getMaxLength() - tree.getHighlightedNode().value.length + 1;
				alertDialog(msg.replace("{0}", length));
			} else {
				break;
			}
		}

		if (result == null || trim(result) == "")
			return;
		
		var node = tree.getHighlightedNode();
		result = node.value + result;
		
//		alertDialog("create " + result);
		
		FileTreeForm.action.value = "mkdir";
		FileTreeForm.filename.value = result;
		FileTreeForm.submit();
		var authToken = parent.get("authToken");
		if (defined(authToken)) {
			parent.addURLParameter("authToken", FileTreeForm.authToken.value);	  
		}
	}
	
	function onSubmit() {
		makeBusy();
	}

</script>
</head>

<!--  <form name="FileTreeForm" method="post" action="StoreFileUpdate" onSubmit="onSubmit();"> --><!-- target="tree" -->
<form name="FileTreeForm" method="post" action="CatalogFileLoaderUpload" onSubmit="onSubmit();">  <!-- target="tree" -->
	<input type="hidden" name="<%= com.ibm.commerce.server.ECConstants.EC_URL %>" value="StoreFilesDialogView">
	<input type="hidden" name="<%= com.ibm.commerce.server.ECConstants.EC_ERROR_VIEWNAME %>" value="StoreFilesDialogView">
	<input type="hidden" name="authToken" value="${authToken}" id="WC_CatalogFileLoaderUpload_FormInput_authToken"/>
	<input type="hidden" name="filemgrResource" value="<%= filemgrResource %>">
	<input type="hidden" name="action" value="">
	<input type="hidden" name="filename" value="">
	<input type="hidden" name="renameTo" value="">	
	<input type="hidden" name="changeTree" value="true">
</form>

<frameset framespacing="0" border="0" frameborder="0" rows="240px, *" onload="initializeState();">
	<frame id="titleFrame" src="StoreFilesTitleView?filemgrResource=<%= filemgrResource %>" name="titleFrame" title="<%= dialogRB.getProperty("Files.title") %>">
	<frame id="tree" src="DynamicTreeView?XMLFile=filemgr.StoreFilesTree&filemgrResource=<%= filemgrResource %>&renderChildrenOnDemand=true" name="tree" title="<%= dialogRB.getProperty("Files.title") %>">
</frameset>	

<%
} catch (Exception e) {
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
</html>
