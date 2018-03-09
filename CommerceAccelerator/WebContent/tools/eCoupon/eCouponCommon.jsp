<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.ibm.commerce.ras.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.promotions.*" %>
<%@page import="com.ibm.commerce.tools.ecoupon.*" %>
<%@page import="com.ibm.commerce.order.utils.*" %>

<%@include file="../common/common.jsp" %>
<%
     CommandContext commContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (commContext == null) 
	{
		return;
	}	
     String fLanguageId= commContext.getLanguageId().toString();
     Integer fStoreId= commContext.getStoreId();
     Locale fLocale = commContext.getLocale();

     // obtain the resource bundle for display

     Hashtable eCouponWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("eCoupon.eCouponWizardNLS",fLocale);

   String feCouponHeader =
     "<meta http-equiv='Cache-Control' content='no-cache'>" +
     "<meta http-equiv=expires content='fri,31 Dec 1990 10:00:00 GMT'>" +
     "<link rel='stylesheet' href='" +
     UIUtil.getCSSFile(fLocale) +
     "'type='text/css'>";
%>
