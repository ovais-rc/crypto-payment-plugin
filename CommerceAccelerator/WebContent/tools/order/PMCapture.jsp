<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@include file="../common/common.jsp" %>
<%
   // Get commandcontext, locale, and processing option
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale aLocale = cmdContext.getLocale();
   Hashtable orderMgmtNLS = (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", aLocale);
   
   Long userId = cmdContext.getUserId();

%>

<html>
<head> 
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css" />
<title></title>
<%
   String paymentHostName = WcsApp.configProperties.getValue( "PaymentManager/Hostname" );
   String paymentIPAddress = "";
   String requestHostName = "";
   String requestIPAddress = "";
   String hostname = "";
   
   try{
   	paymentIPAddress = InetAddress.getByName(paymentHostName).getHostAddress();
   
   	requestHostName = request.getServerName();
   	requestIPAddress = InetAddress.getByName(requestHostName).getHostAddress();
   
   	if(paymentIPAddress.equals(requestIPAddress) && requestHostName.indexOf('.')==-1 && paymentHostName.indexOf('.')!=-1){
   		hostname = paymentHostName.substring(0,paymentHostName.indexOf('.'));
   	}
   	else{
   		hostname   = WcsApp.configProperties.getValue( "PaymentManager/Hostname" );
   	}
   }catch(UnknownHostException e1){
   	hostname   = WcsApp.configProperties.getValue( "PaymentManager/Hostname" );
   }
   
   
   	String portnumber = WcsApp.configProperties.getValue( "PaymentManager/WebServerPort" );
	String nonSSL  = WcsApp.configProperties.getValue( "PaymentManager/UseNonSSLPMClient" );
	String protocol;
	String url;
	
	if (nonSSL.compareTo("1") == 0) {
		protocol = "http://";
	} else {
	    protocol = "https://";
	}
	
	if (portnumber == null || portnumber.length() == 0) {
	    url = protocol + hostname;
	} else {
		url = protocol + hostname + ":" + portnumber;
	}
%>
<BASE HREF="<%=url%>"/>

</head>
<body class="content">
<form name="PaymentManager" action="<%=QueryPMBean.getPaymentManagerWebPath()%>/PaymentServerUI/OrderSearch" method="post">
<input type="hidden" name="clearResults" value="1" />
<input type="hidden" name="showResults" value="1" />
<input type="hidden" name="f_orderNumber" value='<%=UIUtil.toHTML(request.getParameter("orderId"))%>' />
<input type="hidden" name="f_merchantNumber" value="<%=cmdContext.getStoreId()%>" />
<input type="hidden" name="lang" value="<%= aLocale.toString() %>" />

<!--INPUT type=hidden name=refresh value=1-->
<% if (!QueryPMBean.getUseExternalPM()) { %>
<input type="hidden" name="f_pmauthobject" value="" />
<% } %>

</form>

<script type="text/javascript">
<!-- <![CDATA[
<% if (!QueryPMBean.getUseExternalPM()) { %>
  var adminCookie = document.cookie;

  //note:  Retrieve WCS SESSION Cookie
  //       WCS Administrator must enable cookie.

  var log_pos = adminCookie.indexOf("WC_AUTHENTICATION_<%= userId %>=");
  var authobj = "";
  
  if(log_pos!=-1) {
	var log_start = log_pos + 19 + <%= userId.toString().length() %>;
	var log_end = adminCookie.indexOf(";", log_start);
	if(log_end==-1) log_end=adminCookie.length;
	authobj = adminCookie.substring(log_start,log_end);
  }

  document.PaymentManager.f_pmauthobject.value=unescape(authobj);
<% } %>
//[[>-->
</script>

<% if (!QueryPMBean.isPMOperational()) { %>
      <%= UIUtil.toHTML( (String)orderMgmtNLS.get("WPMNotAvailable")) %>
<% } else { %>
<script type="text/javascript">
<!-- <![CDATA[
  document.PaymentManager.submit();
//[[>-->
</script>
<% } %>

</body>
</html>
