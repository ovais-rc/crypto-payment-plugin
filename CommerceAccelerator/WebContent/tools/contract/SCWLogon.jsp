<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
    try{	
      	String[] store_types = null;
      	String store_id = null;
      	String callingURL = null;     	
      	String callingURLPresent = null;
      	String redirectingURL = null;
      	String originalLangId = null;
      	String paymentOverride = null;
      	String paymentCheck = null;
      	String fromAccelerator = null;
      	String storeViewName = null;
      	String includeEmptyCatalog = null;
      	boolean missingStoreId = false;

    	JSPHelper jspHelper = new JSPHelper(request);	      	
   	store_types = jspHelper.getParameterValues("storetype");
   	store_id = jspHelper.getParameter("storeId");
   	callingURL = jspHelper.getParameter("callingURL");   	
   	callingURLPresent = jspHelper.getParameter("callingURLPresent");
   	originalLangId = jspHelper.getParameter("originalLangId");
   	paymentOverride = jspHelper.getParameter("paymentOverride");
   	paymentCheck = jspHelper.getParameter("paymentCheck");
   	fromAccelerator = jspHelper.getParameter("fromAccelerator");
   	storeViewName = jspHelper.getParameter("storeViewName");
   	includeEmptyCatalog = jspHelper.getParameter("includeEmptyCatalog");

      	HttpServletResponse r = (HttpServletResponse) cc.getResponse();

      	if(storeViewName != null){
      		Cookie storeViewNameCookie = new Cookie("storeViewNameCookie" , storeViewName);
        	storeViewNameCookie.setPath("/");       	
        	r.addCookie(storeViewNameCookie);
        }  

      	if(callingURL != null){
      		Cookie callingURLCookie = new Cookie("callingURLCookie" , callingURL);
        	callingURLCookie.setPath("/");       	
        	r.addCookie(callingURLCookie);
        }

      	if(store_id != null){
      		Cookie storeIdCookie = new Cookie("storeIdCookie" , store_id);
        	storeIdCookie.setPath("/");       	
        	r.addCookie(storeIdCookie);
        }
        else {
       		String cmdContextStore_id = cc.getStoreId().toString();
       			if (cmdContextStore_id == null || cmdContextStore_id.equals("0")) {
       				missingStoreId = true;
       			}
       			else {
       				Cookie storeIdCookie = new Cookie("storeIdCookie" , cmdContextStore_id);
				storeIdCookie.setPath("/");       	
        			r.addCookie(storeIdCookie);
       			}
        }

      	if(store_types != null){     	
      		Cookie storetypeSizeCookie = new Cookie("storetypeSize" , (new Integer(store_types.length)).toString());
        	storetypeSizeCookie.setPath("/");       	
        	r.addCookie(storetypeSizeCookie);

      		for(int i = 0; i < store_types.length; i++){
        		Cookie cookie = new Cookie("storetype" + i , store_types[i]);
        		cookie.setPath("/");    	
        		r.addCookie(cookie);
        	}
        }

        // Passing in parameters to the payment page via cookies
        if(paymentOverride != null && paymentOverride.equalsIgnoreCase("true")){
        	Cookie paymentOverrideCookie = new Cookie("paymentOverrideCookie" , "true");
        	paymentOverrideCookie.setPath("/");       	
        	r.addCookie(paymentOverrideCookie);
        }

       	if(paymentCheck != null && paymentCheck.equalsIgnoreCase("true")){
        	Cookie paymentCheckCookie = new Cookie("paymentCheckCookie" , "true");
        	paymentCheckCookie.setPath("/");       	
        	r.addCookie(paymentCheckCookie);
        }

	// are we launched from within the accelerator
       	if(fromAccelerator != null && fromAccelerator.equalsIgnoreCase("true")){
        	Cookie fromAcceleratorCookie = new Cookie("fromAcceleratorCookie" , "true");
        	fromAcceleratorCookie.setPath("/");       	
        	r.addCookie(fromAcceleratorCookie);
        }

        // Getting the url of the calling page.
        if(callingURLPresent != null){
        	Cookie[] cookies = request.getCookies();   
        	for (int i = 0; i < cookies.length; i++){
			if (cookies[i].getName().equalsIgnoreCase("callingURLCookie")) {
				redirectingURL = cookies[i].getValue();
				break;
			}
		}       
        }


	// Passing in parameters to the Shared Catalog page via cookies	
        if(includeEmptyCatalog != null && includeEmptyCatalog.equalsIgnoreCase("false")){
        	Cookie includeEmptyCatalogCookie = new Cookie("includeEmptyCatalogCookie" , "false");
        	includeEmptyCatalogCookie.setPath("/");       	
        	r.addCookie(includeEmptyCatalogCookie);
        }


        // getting the user type to check later if the user is registered
        String userRegisteredType = cc.getUser().getRegisterType();

%>        

<html>
<head>
<title></title>
</head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
   <%
   if (!missingStoreId) { %>
	<script language="JavaScript" src="/wcs/javascript/tools/contract/StoreCreationWizardLogon.js">
</script>
	<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
      	<script language="JavaScript">
		var languagePageURL = "/webapp/wcs/tools/servlet/SCWLanguageSelection?<%=ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL%>=StoreCreationWizardView";
         	if(<%= originalLangId %> != null){         		
         		languagePageURL += "&langId=<%= originalLangId %>";
         	}
         	
         	if(<%= callingURLPresent %> != null){
            		window.location="<%= UIUtil.toJavaScript(redirectingURL) %>";
		}else if('<%= userRegisteredType %>' == 'G'){
            		window.location="/webapp/wcs/tools/servlet/ToolsLogon?XMLFile=contract.scwizardLogon";
		}else{
			languagePageURL = preserveParameters(document.URL, languagePageURL);
			window.location=<c:out value="languagePageURL" />;
			//top.setContent('My Title',languagePageURL,false);
         	}

      
</script>
   <% } %>
<body class="content">
      <center>
      <br><br>
      <h1>
      <%
	 if (missingStoreId) { %>
            <%=UIUtil.toHTML((String)resourceBundle.get("configurationMissingStoreIdErrorMessage"))%>
         <% }
         else { %>
            <%=UIUtil.toHTML((String)resourceBundle.get("configurationErrorMessage"))%>
         <% }
      %>
      </h1>
      </center>
      <br>
</body>
</html>

 <%
 }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
   <% }	
%>

