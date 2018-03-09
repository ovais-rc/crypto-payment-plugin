<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>
<%
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale locale = null;
	String StoreId = null;
	Integer langId = null;
	if( aCommandContext!= null ) {
   		locale = aCommandContext.getLocale();
		langId = aCommandContext.getLanguageId();
		StoreId = aCommandContext.getStoreId().toString();
	}
	if (locale == null) {
		locale = new Locale("en","US");
	}
	if (langId == null) {
		langId = new Integer("-1");
	}
   
	String iattachment = null;
	//  iattachment = jsphelper.getParameter("attachment_id" );
	iattachment = aCommandContext.getRequestProperties().getString("attachment_id" );
    String res_filename = null;   
	AttachmentAccessBean attachment = new AttachmentAccessBean();
	attachment.setInitKey_attachmentId(iattachment);
	res_filename = attachment.getFilename();
	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale);
	// Get the equal to operator description
    OperatorDescriptionAccessBean OPABDsc =null;
    OPABDsc = new OperatorDescriptionAccessBean();
    OPABDsc.setInitKey_languageId(langId.toString());
    OPABDsc.setInitKey_operatorId("0");
    String operatorDesc = OPABDsc.getDescription();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script> 
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">
var attributeObj;
attributeObj = top.getData("attributeData", 1);
function replaceAttchmentId() {
	attributeObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	attributeObj.<%=RFQConstants.EC_ATTR_VALUE%> ="<%= iattachment%>";
	attributeObj.res_filename = "<%= res_filename%>";
	attributeObj.<%= RFQConstants.EC_ATTR_OPERATOR %> = "0";
	attributeObj.<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = "<%=UIUtil.toJavaScript(operatorDesc) %>";
}
if ( "<%= iattachment%>" != "null"  && "<%= iattachment%>" != "" ) {
	replaceAttchmentId();
}
top.saveData(attributeObj,"attributeData");
top.goBack();
</script>
</head>
<body>
</body>
</html>
