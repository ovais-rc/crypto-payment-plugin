


<%-- 
  *****
  * This JSP is called whenever a generic error occurs in the store and no specific errorViewName
  *  has been provided to redirect to.  This page handles 3 situations:
  *  - The store is set to closed or locked state
  *  - The customer is not authorized to access a page they requested
  *  - All other generic errors
  * If the store is closed or locked, a message is displayed to the customer telling them the store is closed.
  * If the user does not have authority to access a specific page, then page redirects to the stores logon page.
  * For all other errors, a generic error message is displayed.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="Common/EnvironmentSetup.jspf" %>
<%@ include file="Common/nocache.jspf" %>
<%@ include file="include/ErrorMessageSetup.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ page import="com.ibm.commerce.datatype.WcParam" %>

<c:set var="pageCategory" value="Error" scope="request"/>

<%
	// Set error code.
	response.setStatus(400);

	// check to see if the wcparam is available; initialise it if it is not available
	if (null == request.getAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM)) {
		request.setAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM, new WcParam(request));
	}
	WcParam wcParam = (WcParam) request.getAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM);
%>

<c:if test="${empty storeId }">
	<c:set var="storeId" value="${WCParam.storeId}"/>
</c:if>
<c:if test="${empty catalogId }">
	<c:set var="catalogId" value="${WCParam.catalogId}"/>
</c:if>

<c:if test="${empty catalogId}">
	<wcf:rest var="storeDB" url="store/{storeId}/online_store" cached="true">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="profileName" value="IBM_Admin_Summary" encode="true"/>
	</wcf:rest>
	<c:set var="catalogId" value="${storeDB.resultList[0].defaultCatalog[0].catalogIdentifier.uniqueID}"/>
</c:if>

<wcst:aliasBean id="errorBean" name="ErrorDataBean"/>
<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title>
		<%--
		//  If the store is closed or suspended, we get the message state _ERR_BAD_STORE_STATE (CMN1072E).
		//  We should display the store is closed page.
		--%>
		
		<c:choose>
			<c:when test="${errorBean.messageKey eq '_ERR_BAD_STORE_STATE'}">
				<fmt:message bundle="${storeText}" key="GENERICERR_TEXT3"/> 
			</c:when>
			<c:otherwise>
				<fmt:message bundle="${storeText}" key="ERROR_TITLE"/>
			</c:otherwise>
		</c:choose>
	</title>
	<script>
		if(self!=top){
			<%-- 
				Preview_Window is the name given to the top most window if 
				CMC has launched the store in preivew mode 
			--%>
			if(!top || top.name != 'Preview_Window') {
				<%-- If not launched from Preview, then make the top window, this HREF --%>
				top.location.href = location.href;
			}else if  (top && top.name == 'Preview_Window' && top.frames["previewFrame"].location != location.href){
				<%-- The case of having this error message shown in an iframe, we want to jump out of it. --%>
				top.frames["previewFrame"].location.href = location.href;
			}
		}
	</script>
	<%@ include file="Common/CommonJSToInclude.jspf"%>
	<%@ include file="Common/CommonJSPFToInclude.jspf"%>
	
	<c:if test="${errorBean.messageKey eq '_ERR_CMD_CMD_NOT_FOUND'}">
		<wcf:url var="homePageUrl" patternName="HomePageURLWithLang" value="TopCategories1">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url> 
		<meta http-equiv="Refresh" content="0;URL=${homePageUrl}"/>
    </c:if>
	
	<script type="text/javascript">
	  $(document).ready(function() {
			setDeleteCartCookie();
		});
	</script>

</head>
 
<body>

<div id="page">
    <!-- Header Nav Start -->
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	
	<div class="content_wrapper_position">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width">

	<!-- Main Content Start -->
	<div id="content_wrapper_border" role="main">
		<!-- Content Start -->
		<div id="box" class="my_account generic_error_container">
			<div id="errorPage">
				<h1 class="myaccount_header"><fmt:message bundle="${storeText}" key="ERROR_TITLE"/></h1>
			</div>
				
			<div id="WC_GenericError_5" class="content">
				<div id="WC_GenericError_6" class="info">
					<c:choose>
						<c:when test="${errorBean.messageKey != null}">
							<c:choose>
								<c:when test="${errorBean.messageKey eq '_ERR_USER_AUTHORITY'}">
									<c:choose>
										<c:when test="${userType eq 'G'}">
											<span><fmt:message bundle="${storeText}" key="AUTHORIZATION_ERROR1" /></span>
											<br />
											<br />
											<c:url var="LogonFormURL" value="LogonForm">
												<c:param name="storeId" value="${storeId}" />
												<c:param name="langId" value="${langId}" />
												<c:param name="catalogId" value="${catalogId}" />
												<c:param name="myAcctMain" value="1" />
											</c:url>
											<div id="WC_GenericError_7">
												<a href="<c:out value="${LogonFormURL}"/>" class="button_primary" id="WC_GenericError_Link_1">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message bundle="${storeText}" key="Logon_Title" /></div>
													<div class="right_border"></div>
												</a>
											</div>
										</c:when>
										<c:otherwise>
											<span><fmt:message bundle="${storeText}" key="AUTHORIZATION_ERROR2" /></span>
										</c:otherwise>
									</c:choose>
								</c:when>

								<c:when test="${errorBean.messageKey eq '_ERR_BAD_STORE_STATE'}">
									<span class="warning"><fmt:message bundle="${storeText}" key="GENERICERR_TEXT4" /></span>
								</c:when>
								
								<c:when test="${errorBean.messageKey eq '_ERR_INVALID_COOKIE' || CommandContext.commandName eq 'CookieErrorView'}">
									<span><fmt:message bundle="${storeText}" key="INVALID_COOKIE_ERROR" /></span>
									<br />
									<br />
									<c:url var="LogonFormURL" value="LogonForm">
										<c:param name="storeId" value="${storeId}" />
										<c:param name="langId" value="${langId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="myAcctMain" value="1" />
									</c:url>
									<div id="WC_GenericError_7">
										<a href="<c:out value="${LogonFormURL}"/>" class="button_primary" id="WC_GenericError_Link_1">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="Logon_Title" /></div>
											<div class="right_border"></div>
										</a>
									</div>
								</c:when>

								<c:when test="${errorBean.messageKey eq '_ERR_CATENTRY_NOT_EXISTING_IN_STORE' || errorBean.messageKey eq '_ERR_PROD_NOT_PUBLISHED' || errorBean.messageKey eq '_ERR_RETRIEVE_PRICE.1002' || WCParam.excMsgKey eq '_ERR_CATENTRY_NOT_EXISTING_IN_STORE'}">
									<span><fmt:message bundle="${storeText}" key="PRODUCT_ERROR" /></span>
								</c:when>

								<c:otherwise>
									<flow:ifEnabled feature="ProductionServer">
										<span >
										<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT">                                     
											<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US" /></fmt:param>
										</fmt:message>
										</span>
										<br />
									</flow:ifEnabled>
									<flow:ifDisabled feature="ProductionServer">
										<span><fmt:message bundle="${storeText}" key="GENERICERR_TEXT2" /></span>
										<br /><br />
										<span class="genericError_message">
											<c:if test="${!empty errorMessage}">
												<c:forEach items="${errorMessage}" var="anErrorMsg">
													<c:out value="${anErrorMsg}"/>
												</c:forEach>
											</c:if>
										</span>
									</flow:ifDisabled>
								</c:otherwise>
							</c:choose>
						</c:when>

						<c:otherwise>
							<flow:ifEnabled feature="ProductionServer">
								<span >
								<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT">                                     
									<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US" /></fmt:param>
								</fmt:message>
								</span>
								<br />
							</flow:ifEnabled>
							<flow:ifDisabled feature="ProductionServer">
								<span><fmt:message bundle="${storeText}" key="GENERICERR_TEXT2" /></span>
							</flow:ifDisabled>								
						</c:otherwise>

					</c:choose>
					</div>
				</div>
							
				<div id="WC_GenericError_8" class="footer">
					<div id="WC_GenericError_9" class="left_corner"></div>
					<div id="WC_GenericError_10" class="left"></div>
					<div id="WC_GenericError_11" class="right_corner"></div>
				</div>
			</div>
		</div>
		<!-- Content End -->
	</div>
	<!-- Main Content End -->
	
	</div>
	</div>
	</div>
	</div>
	</div>
	</div>

	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->
</div>
<wcst:alias name="BIConfigRegistry" var="BIConfigRegistry" />
<wcst:mapper source="BIConfigRegistry" method="useHostedLibraries" var="BIConfigRegistryUseHostLibraries" />
<c:set var="useHostedLib" value="${BIConfigRegistryUseHostLibraries[storeId]}" />
<flow:ifEnabled feature="Analytics">
	<c:choose>
		<c:when test="${useHostedLib == true}">
			<cm:pageview category="ERROR" />
		</c:when>
		<c:otherwise>
			<cm:error />
		</c:otherwise>
	</c:choose>
</flow:ifEnabled>

<%@ include file="Common/JSPFExtToInclude.jspf"%> 
</body>
</html>
