<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="pageCategory" value="MyAccount" scope="request"/>

<!-- BEGIN AccountDisplay.jsp -->
<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../Common/CommonCSSToInclude.jspf" %>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@ include file="../../Common/CommonJSToInclude.jspf" %>
			
	<title><fmt:message bundle="${storeText}" key="REGISTER_LOGIN"/></title>
</head>

<body>

<div id="page">

	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>	

	<!-- Header Nav Start -->
	<c:if test="${b2bStore eq 'true'}">
    	<c:if test="${userType =='G'}">
			<c:set var="hideHeader" value="true"/>
		</c:if>
	</c:if>
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
     	<div class="content_wrapper">
     		<div class="content_left_shadow">
     			<div class="content_right_shadow">
          			<div class="main_content">
						<div class="sign_in_registration" id="WC_AccountDisplay_div_1">
							<%@include file="AccountDisplayContent.jspf" %>
							<br clear="all"/>
							<div class="ad" id="WC_AccountDisplay_div_31">
								<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url= "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.ContentRecommendation/ContentRecommendation.jsp">
									<wcpgl:param name="storeId" value="${WCParam.storeId}" />
									<wcpgl:param name="emsName" value="SignInPageESpot" />
									<wcpgl:param name="numberContentPerRow" value="1" />
									<wcpgl:param name="catalogId" value="${WCParam.catalogId}" />
									<wcpgl:param name="errorViewName" value="AjaxOrderItemDisplayView" />
								</wcpgl:widgetImport>
								<%out.flush();%>
							</div>
							<br />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Main Content End -->

	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>

<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END AccountDisplay.jsp -->
