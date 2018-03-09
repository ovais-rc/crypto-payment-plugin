
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="pageCategory" value="MyAccount" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="ACTIVATION_TITLE"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
</head>
<body>
<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page">
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width" id="content_wrapper_border">
							<!-- Content Start -->
								<div id="box">

								<div class="content"id="WC_ActivationResendDisplay_div_1">

								<br clear="all"/>
								<br/>
					
								<%-- A message is displayed confirming that the activation email is resent --%>
								<div class="title" id="WC_ActivationResendDisplay_div_2">
									<h1><fmt:message bundle="${storeText}" key="ACTIVATION_SENT" /></h1>
								</div>
								<br />

								<wcf:url var="LogonFormURL" value="LogonForm">
									<wcf:param name="storeId"   value="${WCParam.storeId}"  />
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="myAcctMain" value="1"/>
								</wcf:url>
								<div class="button_footer_line">
									<a href="#" role="button" class="button_primary" id="WC_ActivationResendDisplay_Link_1" onclick="javascript:setPageLocation('<c:out value="${LogonFormURL}"/>')">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="Logon_Title"/></div>
										<div class="right_border"></div>
									</a>
								</div>			
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
    <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
