
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>
<fmt:message bundle="${storeText}" key="BROWSING_HISTORY" var="contentPageName" scope="request"/>
<c:if test="${!empty catalogId }">
	<wcf:url var="AjaxBrowsingHistoryEspotDisplayURL" value="AjaxBrowsingHistoryEspotDisplay" type="Ajax">
		<wcf:param name="langId" value="${langId}" />						
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	</wcf:url>
</c:if>	

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
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="BROWSING_HISTORY"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
	
	
		<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
		<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
		<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM" />
		<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
		<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR"/>
		<%-- Missing Message --%>
		<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
		<fmt:message bundle="${storeText}" key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU"/>
		
	
		MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
		MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
		MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);	
	</script>
</head>
<body>

	<!-- Page Start -->
	<div id="page" class="nonRWDPage">	

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<!-- Header Nav End -->
		
	<!-- Main Content Start -->
	<div id="contentWrapper">
		<div id="content" role="main">		
			<div class="row margin-true">
				<div class="col12">				
					<%out.flush();%>
						<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  														
							<wcpgl:param name="pageGroup" value="Content"/>
						</wcpgl:widgetImport>
					<%out.flush();%>					
				</div>
			</div>
			<div class="rowContainer" id="container_MyAccountDisplayB2B">
				<div class="row margin-true">					
					<div class="col4 acol12 ccol3">
						<%out.flush();%>
							<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
						<%out.flush();%>		
					</div>
					<div class="col8 acol12 ccol9 right">	
						<div id="box" class="myAccountMarginRight">
							<div class="my_account" id="WC_NonAjaxBrowseHistory_div_1">														
								<div class="widget_recentlyviewed_position" id="WC_NonAjaxBrowseHistory_div_6">
									<fmt:message bundle="${storeText}" var="titleString" key="BROWSING_HISTORY"/>												
										<%out.flush();%>
										<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
											<wcpgl:param name="emsName" value="RecViewed_CatEntries" />
											<wcpgl:param name="errorViewName" value="AjaxOrderItemDisplayView"/>
											<wcpgl:param name="widgetOrientation" value="horizontal"/>
											<wcpgl:param name="espotTitle" value="${titleString}"/>
										</wcpgl:widgetImport>
										<%out.flush();%>
								</div>
										
								<div class="footer" id="WC_NonAjaxBrowseHistory_div_7">
									<div class="left_corner" id="WC_NonAjaxBrowseHistory_div_8"></div>
									<div class="tile" id="WC_NonAjaxBrowseHistory_div_9"></div>
									<div class="right_corner" id="WC_NonAjaxBrowseHistory_div_10"></div>
								</div>
							</div>
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
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
