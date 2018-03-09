<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*
//*-------------------------------------------------------------------
//*Note: DataBeanManager.activate() is not called because there is no 
//*CommandContext set up when jsp is executed by messaging system thru
//*scheduler 
//*-------------------------------------------------------------------
//*
--%>
<%@ page import="javax.servlet.*,
java.io.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.common.objimpl.*,
com.ibm.commerce.common.beans.*,
com.ibm.commerce.messaging.util.MessagingSystemConstants,
com.ibm.commerce.rfq.objects.*,
com.ibm.commerce.rfq.beans.*,
com.ibm.commerce.rfq.utils.*,
com.ibm.commerce.user.beans.*,
com.ibm.commerce.user.objects.*,
com.ibm.commerce.utf.utils.UTFConstants" %>
<jsp:useBean id="rsp" class="com.ibm.commerce.rfq.beans.RFQResponseDataBean" ></jsp:useBean>

<% 
CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
response.setContentType("text/html;charset=UTF-8");
try {
   //response data
   String rsprfn = "";
   String rspName="";
   String rspDesc = "";
  


    // Use JSPHelper to extract parameters:
    JSPHelper jsphelper=new JSPHelper(request);
   
   rsprfn = jsphelper.getParameter("response_id");
        rsp.setRfqResponseId(rsprfn);
	rspName = rsp.getName();
   	rspDesc = rsp.getRemarks();		

	String langId = (aCommandContext.getLanguageId()).toString();
	if(langId == null) { langId = com.ibm.commerce.server.WcsApp.siteDefaultLanguageId.toString(); }

    Locale locale = null;


    try {
	LanguageAccessBean languageAccessBean = new LanguageAccessBean();
	languageAccessBean.setInitKey_languageId( langId );  
	String localeString = languageAccessBean.getLocaleName();
	locale = new Locale( localeString.substring(0,2), localeString.substring(3) );
    } catch(Exception e) {
	locale = Locale.getDefault();
	String langName = locale.getLanguage() + "_" + locale.getCountry();
    }

	out.println(RFQMessageHelper.getUserMessage("RESName",null,locale) +" "+ rspName);
	out.println(RFQMessageHelper.getUserMessage("RESREMARK",null,locale) +" "+rspDesc);

} catch (Exception e) {
    out.print( "Exception " + e);
}
%>