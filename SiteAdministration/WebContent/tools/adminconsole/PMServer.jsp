<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.util.Hashtable" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %> 
<%@ page import="com.ibm.commerce.server.ECConstants" %> 
<%@ page import="com.ibm.commerce.server.SessionHelper" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %> 
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.tools.optools.order.beans.QueryPMBean" %> 
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="java.net.*" %>
<%@ include file="../common/common.jsp" %>
<% String webalias = UIUtil.getWebPrefix(request); %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<TITLE></TITLE>

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

</HEAD>

<BODY>

<!-- This parameter is optional but sometimes give me problem; Could you CTS to avoid page cache -->
<!-- BUTTON type=submit>OK</BUTTON> -->

<%
    // obtain the resource bundle for display
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    Hashtable adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    String pURL = QueryPMBean.getPaymentManagerWebPath() + "/PaymentServerUI/PaymentServer";

    Long userId = cmdContext.getUserId();    
%>

<FORM name=PaymentManager action="<%=pURL%>" method="post">
<INPUT type=hidden name="lang" value="<%= locale.toString() %>">

<%
  if (!QueryPMBean.isPMOperational())
  {
    String PMSystemNotAvailableStr = UIUtil.toJavaScript((String)adminConsoleNLS.get("PMSystemNotAvailable"));
    
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
    alert ('<%= PMSystemNotAvailableStr %>');

    // go back to home page
    //top.setContentRemoteAccess(false);
    if (top.goBack) 
    {
      top.goBack();
    }
    else
    {
      document.location.replace(top.getWebappPath() + "AdminConHome");
    }
</SCRIPT>

<%
  }

  if (!QueryPMBean.getUseExternalPM())
  {
%>
    <INPUT type="hidden" name="f_pmauthobject" value="">

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
    //note:  Retrieve WCS SESSION Cookie
    //       WCS Administrator must enable cookie.
      var adminCookie = document.cookie;

      var log_pos = adminCookie.indexOf("WC_AUTHENTICATION_<%= userId %>=");
      var authobj = "";
  
      if(log_pos!=-1) {
	  var log_start = log_pos + 19 + <%= userId.toString().length() %>;
	  var log_end = adminCookie.indexOf(";", log_start);
	  if(log_end==-1) log_end=adminCookie.length;
	  authobj = adminCookie.substring(log_start,log_end);
      }
    document.PaymentManager.f_pmauthobject.value=unescape(authobj);
</SCRIPT>

<%
  }
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
    document.PaymentManager.submit();
</SCRIPT>

</FORM>
</body>
</html>
