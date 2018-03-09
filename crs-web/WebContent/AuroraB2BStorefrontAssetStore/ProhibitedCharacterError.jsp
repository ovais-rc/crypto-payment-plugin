
<%-- 
  *****
  * This JSP displays error message when trying to execute some URL that is found to be
  * harmful to the server.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="Common/EnvironmentSetup.jspf" %>
<%@ include file="Common/nocache.jspf" %>

<c:set var="pageCategory" value="Error" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="Common/CommonCSSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_TITLE"/></title>
		<%@ include file="Common/CommonJSToInclude.jspf"%>		
		<%@ include file="Common/CommonJSPFToInclude.jspf"%>
		
	</head>

	<body>
	
		<div id="page">
			
			<!-- Header Nav Start -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- Header Nav End -->
		
			<!--MAIN CONTENT STARTS HERE-->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
									<div id="box" class="my_account generic_error_container">
										<div id="errorPage">
											<h1 class="myaccount_header"><fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_TITLE" /></h1>
											<div id="WC_PCE_5" class="content">
												<div id="WC_PCE_6" class="info">						
					
													<br clear="all"/>
													<c:choose>
														<c:when test="${WCParam.ErrorCode == 'WildcardSearchError'}">
															<fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_WILDCARD_DESC" />
														</c:when>
														<c:otherwise>
															<fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_DESC" />
														</c:otherwise>
													</c:choose>
													<br /><br />
													<fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_BACK_DESC" />
													<br /><br />
													<a href="#" class="button_primary" id="WC_ProhibitedCharacterError_Link_1" tabindex="0" onclick="javascript:history.back(1);return false;">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message bundle="${storeText}" key="PROHIBITEDCHAR_ERROR_BACK"/></div>
														<div class="right_border"></div>
													</a>						
													<br /><br />
												</div>
											</div>
						
											<div id="WC_PCE_10" class="footer">
												<div id="WC_PCE_7" class="left_corner"></div>
												<div id="WC_PCE_8" class="left"></div>
												<div id="WC_PCE_9" class="right_corner"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- MAIN CONTENT END -->
			
			<!-- Footer Start -->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!-- Footer End -->
		</div>

		<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	<%@ include file="Common/JSPFExtToInclude.jspf"%> 
	</body>
</html>
