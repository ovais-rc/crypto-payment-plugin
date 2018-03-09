

<%-- 
  *****
  * This JSP is called whenever the current session has timed out.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<%
	// Set error code.
	response.setStatus(400);
%>

<c:set var="pageCategory" value="MyAccount" scope="request"/>
<c:choose>
	<c:when test="${empty WCParam.catalogId}">
	 	<%-- The page will be reloaded with the selected catalogId --%>
		<wcf:url var="sWebAppPath" value="ReLogonFormView">
			<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${CommandContext.languageId}"/>
		</wcf:url>
		<meta http-equiv="Refresh" content="0;URL=<c:out value="${sWebAppPath}"/>"/>
	</c:when>
	<c:otherwise>

	<!DOCTYPE HTML>

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
	<!-- BEGIN UserTimeoutView.jsp -->
	<html lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_TITLE"/></title>

		<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
		
		<script type="text/javascript">
		  $(document).ready(function() {
				setDeleteCartCookie();
				GlobalLoginJS.deleteLoginCookies();
				var logonUserCookie = getCookie("WC_LogonUserId_"+WCParamJS.storeId);
		                if (logonUserCookie != null){
		                    setCookie("WC_LogonUserId_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
		                }
			});
		</script>		
	</head>
	
	<body>

		<!-- JSP File Name:  UserTimeoutView.jsp -->
		<div id="page">
    
		    <!-- Header Nav Start -->
		    <!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- Header Nav End -->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
			<!-- Header Nav End -->
		     
			 <!--MAIN CONTENT STARTS HERE-->
			<div id="content_wrapper_border">
				<div id="box" class="my_account generic_error_container">
					<div id="errorPage">			
						<h1 class="myaccount_header"><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_TITLE"/></h1>
					</div>
					<wcf:url var="LogonFormURL" value="LogonForm">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								<wcf:param name="myAcctMain" value="1" />
					</wcf:url>
					<div id="WC_UserTimeoutView_5" class="content">
						<div id="WC_UserTimeoutView_6" class="info">
							<fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_DETAILS"/>
							<br/>
							<br/>
							<a href="#" class="button_primary" id="WC_AjaxAddressBookForm_div_19" tabindex="0" onclick="javascript:GlobalLoginJS.InitHTTPSecure('Header_GlobalLogin');">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_LOGIN"/></div>
								<div class="right_border"></div>
							</a>
		
							<br clear="all"/>					
						</div>
					</div>
				
					<div id="WC_UserTimeoutView_7" class="footer">
						<div id="WC_UserTimeoutView_8" class="left_corner"></div>
						<div id="WC_UserTimeoutView_9" class="left"></div>
						<div id="WC_UserTimeoutView_10" class="right_corner"></div>
					</div>
				</div>
			</div>	
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- MAIN CONTENT ENDS HERE -->

		<!-- Footer Start -->
		<div class="footer_wrapper_position">
			<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
			<%out.flush();%>
		</div>
		<!-- Footer End -->
	</div>

	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
	</html>

	</c:otherwise>
</c:choose>
<!-- END UserTimeoutView.jsp -->
