<% 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2004, 2005
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
// 040515           MF        Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil"%>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory"%>
<%@ page import="com.ibm.commerce.beans.DataBeanManager"%>
<%@ page import="com.ibm.commerce.server.MimeUtils" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",jLocale);	
%>

<html>
<head>

	<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Title"))%></title>
	<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>" type="text/css" />
	<script src="/wcs/javascript/tools/common/Util.js"></script>
<script>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateInput()
	//
	// @return true if the input is a valid url otherwise false
	//
	// - this function is called to validate the url
	//////////////////////////////////////////////////////////////////////////////////////
	function validateInput() 
	{

		//  Check if the field is empty
		if ( trim(SourceFilePath.value) == ""  )
		{
			SourceFilePath.select();
			alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Error_Empty"))%>");
			return false;
		}

		//  Check the maximum length
		if ( !isValidUTF8length(SourceFilePath.value, 254)  )
		{
			SourceFilePath.select();
			alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Error_ExceedsLength"))%>");
			return false;
		}


		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// preview()
	//
	// - this function will preview the url specified in the url input box
	//////////////////////////////////////////////////////////////////////////////////////
	function preview() 
	{
		if (validateInput() == false) return;
		var path = SourceFilePath.value;
		if(path.indexOf("://") == -1){
			path = "http://" + path;
		}
		window.open(path, '_blank');
	}

	</script>
	
</head>

<body class="content" onload="onLoad();" oncontextmenu="return false;">

<h1><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Title"))%></h1>

<script>
	document.writeln("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Instruction"))%>");
</script>
<br />
<br />
<br />
	<table style="width:100%;">
        <tr><td><label for="sourceFileId"><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Label_URL"))%></label></td></tr>
		<tr><td><input size=64 maxlength=254 id="sourceFileId" name="SourceFilePath" value=""/>
			<a href='javascript:preview()'><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Button_Preview"))%></a>
		</td></tr>
	</table>

</body>

</html>
