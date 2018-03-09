<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays user timeout session message.  It provides a link for the user  
  * to return to the login screen. 
  *****
--%>

<!-- BEGIN UserTimeoutView.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<%
	// Set error code.
	response.setStatus(400);
%>

<wcf:url var="LogonFormURL" value="m30LogonForm">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_TITLE"/>
		</title>
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

        <%@ include file="../../../include/CommonAssetsForHeader.jspf" %>
	</head>
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<div id="user_session_timeout" class="item_wrapper">
				<p><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_DETAILS"/></p>
				<div class="item_spacer"></div>
				<div class="single_button_container left">
					<a id="logon_form_link" href="${fn:escapeXml(LogonFormURL)}" title="<fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_LOGIN"/>">
						<div class="primary_button button_half"><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_LOGIN"/></div>
					</a>
				</div>
				<div class="clear_float"></div>
			</div>

			<%@ include file="../../../include/FooterDisplay.jspf" %>
		</div>
	<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END UserTimeoutView.jsp -->
