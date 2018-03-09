<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2002, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.tools.common.ui.UIProperties" %> 
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContextLocale.getLocale());
Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CategoryNLS", cmdContextLocale.getLocale());
Hashtable rbAttribute = (Hashtable)ResourceDirectory.lookup("catalog.AttributeNLS", cmdContextLocale.getLocale());
Locale jLocale = cmdContextLocale.getLocale();

ErrorDataBean errorBean = new ErrorDataBean ();
com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);

String exKey = errorBean.getMessageKey();
String exMsg = "";
//If the message type in the ErrorDataBean is type SYSTEM then 
//display the system message.  Otherwise the message is type USER
//so display the user message.
if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM ) {
	exMsg = errorBean.getSystemMessage();
} else {
	exMsg = errorBean.getMessage();
}

if (exKey.equals("_ERR_GENERIC")) {
	String[] paramObj = (String[])errorBean.getMessageParam();
	exMsg = paramObj[0];
}

TypedProperty requestProperty = errorBean.getRequestProperties();
String errorKeyForAlertDialog = "";
try {
	errorKeyForAlertDialog = (String) requestProperty.get(UIProperties.SUBMIT_FINISH_MESSAGE);
} catch (Exception ex) {
	errorKeyForAlertDialog = "AttributeUpdate_ERROR_updateValue";
}
String errorMessageForAlertDialog = (String) rbAttribute.get(errorKeyForAlertDialog);

%>

<HTML>
   <HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

	<TITLE><%=UIUtil.toHTML((String)rbProduct.get("productUpdateDetail_AttributeEditor"))%></TITLE>
   
   </HEAD>

   <BODY class="content">  
   	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   	<SCRIPT>
   		function savePanelData() {
   			alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttributeXMLFail1"))%>");
   		}
   		
   		function validatePanelData() {
   			alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttributeXMLFail1"))%>");
   		}
   		
   		function saveEntries() {
   			alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttributeXMLFail1"))%>");
   		}
   		
   		
   		alertDialog("<%=UIUtil.toJavaScript(errorMessageForAlertDialog)%>");
		parent.parent.gotoPanel("attributeEditorTitle");


   	</SCRIPT>
   </BODY>
</HTML>



