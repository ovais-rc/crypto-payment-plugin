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
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %> 
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>
<%
 	//*** GET LOCALE FROM COMANDCONTEXT ***//
 	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	Locale   locale = null;
 	String  StoreId = null;
 	Integer lang = null;
 	if( aCommandContext!= null ){
 		locale = aCommandContext.getLocale();
 		lang = aCommandContext.getLanguageId();
 		StoreId = aCommandContext.getStoreId().toString();
 	}
 	if (locale == null) {
 		locale = new Locale("en","US");
 	}
 	if (lang == null) {
 		lang = new java.lang.Integer("-1");
	} 		
	String iattachment = null;
	// iattachment = jsphelper.getParameter("attachment_id" );
	iattachment = aCommandContext.getRequestProperties().getString("attachment_id" );
	String res_filename = null;   
	AttachmentAccessBean attachment = new AttachmentAccessBean();
	attachment.setInitKey_attachmentId(iattachment);
	res_filename = attachment.getFilename();
 	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
 	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
	// Get the equal to operator description
	OperatorDescriptionAccessBean OPABDsc =null;
	OPABDsc = new OperatorDescriptionAccessBean();
	OPABDsc.setInitKey_languageId(lang.toString());
	OPABDsc.setInitKey_operatorId("0");
	String operatorDesc = OPABDsc.getDescription();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/DateUtil.js"></script>
<script type="text/javascript"> 
var anProduct = new Object();
if (top.getData("anProduct") != undefined && top.getData("anProduct") != null) {   
	anProduct = top.getData("anProduct");
	top.saveData(null,"anProduct");
} else {
    anProduct = top.getData("anProduct",1);
} 
var anAttribute = new Object();
if (top.getData("anAttribute") != undefined && top.getData("anAttribute") != null) {   
	anAttribute = top.getData("anAttribute");
	top.saveData(null,"anAttribute");
} else {
	anAttribute = top.getData("anAttribute",1);
}     
function replaceAttchmentId() {
	if ( anAttribute != null) {
		for(var i = 0;i < anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length;i++) {
			if (anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_PATTRVALUE_ID%> == anAttribute.<%=RFQConstants.EC_PATTRVALUE_ID%>) {
				anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_VALUE%> = "<%= iattachment%>"; 
         		anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].res_filename = "<%= res_filename%>";
         		anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].<%=RFQConstants.EC_ATTR_OPERATOR%> = "0";
	  		    anProduct.<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[i].operatorName = "<%=UIUtil.toJavaScript(operatorDesc) %>";
         		break; 
			}
        }
    }
}    
if ( "<%= iattachment%>" != "null"  && "<%= iattachment%>" != "" ) {
	replaceAttchmentId();
}
top.sendBackData(anProduct,"anProduct");
top.goBack();
</script>
</head>
<body>  
</body>
</html>
