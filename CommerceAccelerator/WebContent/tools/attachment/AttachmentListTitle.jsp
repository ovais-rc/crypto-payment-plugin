<% 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005, 2016
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
// 040515           BLI       Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="java.text.MessageFormat" %>


<%@include file="../common/common.jsp" %>

<%!
	/**
	*	Replace '?' in strA with strB
	*
	*	@param strA
	*	@param strB
	*/
	public String stringReplace(String strA, String strB)
	{
		int i = strA.indexOf("?");
		
		if (i >= 0) {
			strA = strA.substring(0, i) + strB + strA.substring(i + 1);
		}
		
		return strA;
	}
%>

<%
	CommandContext cmdContext 	= (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment 		= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	// databeans
	CatalogEntryDescriptionAccessBean catalogEntryDescriptionAB		= null;
	CatalogGroupDescriptionAccessBean catalogGroupDescriptionAB 	= null;
	CatalogDescriptionAccessBean catalogDescriptionAB 				= null;
	
	// parameters to find usage and target
	JSPHelper jspHelper			= new JSPHelper(request);
	String objectType			= jspHelper.getParameter("objectType");
	String objectId				= jspHelper.getParameter("objectId");
	
	String strTitle 			= (String) rbAttachment.get("AttachmentList_String_Title");
	String strName 				= null;
	String languageId = cmdContext.getLanguageId().toString();
		
	boolean ATCHREL_DESCRIPTION_FOUND = true;
	boolean SINGLELANGSTORE = false;
	
	// catentry
	if (objectType != null && objectType.equals(ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_ENTRY)) {
	
		try {

			catalogEntryDescriptionAB = new CatalogEntryDescriptionAccessBean();
			catalogEntryDescriptionAB.setInitKey_catalogEntryReferenceNumber(objectId);
			catalogEntryDescriptionAB.setInitKey_language_id(languageId);
			
			strName = catalogEntryDescriptionAB.getName();
        
		} catch (Exception e) {
		
			strName = "";
		}

	// catalog
	} else if (objectType != null && objectType.equals(ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG)) {
	
		try {

			catalogDescriptionAB = new CatalogDescriptionAccessBean();
			catalogDescriptionAB.setInitKey_catalogReferenceNumber(objectId);
			catalogDescriptionAB.setInitKey_language_id(languageId);
			strName = catalogDescriptionAB.getName();
        
		} catch (Exception e) {
		
			strName = "";
		}

	
	// catgroup
	} else if (objectType != null && objectType.equals(ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP)) {

		try {

			catalogGroupDescriptionAB = new CatalogGroupDescriptionAccessBean();
			catalogGroupDescriptionAB.setInitKey_catalogGroupReferenceNumber(objectId);
			catalogGroupDescriptionAB.setInitKey_language_id(languageId);
			strName = catalogGroupDescriptionAB.getName();
        
		} catch (Exception e) {
		
			strName = "";
		}
	}

	MessageFormat mf = new MessageFormat(strTitle);
	Object[] args = {strName};
	strTitle = mf.format(args);

%>

<html>
<head>

	<title><%=(String) rbAttachment.get("AttachmentList_Title")%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">

	<script>
		objectName = "<%=UIUtil.toJavaScript(strName)%>";
	</script>
	
</head>

<body class=content oncontextmenu="return false;">

	<table border=0 cellpadding=0 cellspacing=0 style="width:100%">
		<tr>
			<td><h1><%=UIUtil.toHTML(strTitle)%></h1></td>
		</tr>
	</table>

</body>