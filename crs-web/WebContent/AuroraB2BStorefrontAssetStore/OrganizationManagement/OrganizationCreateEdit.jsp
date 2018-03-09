<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<fmt:message var="addtionalBCT" bundle="${storeText}" key="ORGANIZATIONMANAGE_ORGS_AND_USERS" scope="request"/>
<wcf:url var="additionalBCT_URL" value="OrganizationsAndUsersView" scope="request">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>


<c:choose>
	<c:when test="${!empty param.orgEntityId}">
		<c:set var="orgEntityId" value="${param.orgEntityId}" scope="request"/>
	</c:when>
	<c:when test="${!empty WCParam.orgEntityId}">
		<c:set var="orgEntityId" value="${WCParam.orgEntityId}" scope="request"/>
	</c:when>
</c:choose>

<fmt:message var="contentPageName" key="ORG_CREATE_ORG_HEADING" bundle="${storeText}" scope="request"/>
<c:if test="${!empty orgEntityId}">
	<wcf:rest var="orgEntityDetails" url="store/${WCParam.storeId}/organization/${orgEntityId}" scope="request">
		<wcf:param name="responseFormat" value="json" />
		<wcf:param name="profileName" value="IBM_Org_Entity_Details"/> <%-- Check if we can use summary here... distinguishName is not in summary.. but if we add DN to summary ? TODO--%>
	</wcf:rest>
	<c:set var="contentPageName" value="${orgEntityDetails.displayName}" scope="request"/>
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

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../Common/CommonCSSToInclude.jspf"%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>${contentPageName}</title>

		<!-- Include script files -->
		<%@ include file="../Common/CommonJSToInclude.jspf"%>
		<script type="text/javascript">  
		$(document).ready(function() {
			<fmt:message key="ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS" bundle="${storeText}" var="ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS"/>
			MessageHelper.setMessage("ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS","<c:out value='${ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS}'/>");
		});
		</script>
	</head>
	
	<body>
		<!-- Page Start -->
		<div id="page" class="nonRWDPage">
			<%@ include file="../Common/CommonJSPFToInclude.jspf"%>
			<div id="wrapper" class="ucp_active">
				<div class="highlight">
					<!-- Header Widget -->
					<div id="headerWrapper">
						<%out.flush();%>
						<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
						<%out.flush();%>
					</div>
				</div>
			</div>
			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main">
					<div class="rowContainer" id="container_orgUserList_detail">
						<div class="row margin-true">
							<!-- breadcrumb -->
							<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  
									<wcpgl:param name="pageGroup" value="Content" />
									<wcpgl:param name="doNotCacheForMyAccount" value="true"/>
								</wcpgl:widgetImport>
							<%out.flush();%>
							<div class="col12"></div>
						</div>
										
						<div class="row margin-true">
							<!-- Left Nav -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
								<%out.flush();%>	
							</div>
							<!-- Content area -->
							<c:choose>
								<c:when test="${!empty orgEntityId}">
									<div class="col8 acol12 ccol9 right">
										<%@include file="OrganizationEditSection.jsp"%>
									</div>
								</c:when>
								<c:otherwise>
									<div class="col8 acol12 ccol9 right">
										<%@include file="OrganizationCreateSection.jsp"%>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<!-- Footer Widget -->
					<div class="highlight">
						<div id="footerWrapper">
							<%out.flush();%>
							<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
							<%out.flush();%>
						</div>
					</div>
				</div>
			</div>				
			<!-- Main Content End -->

			<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
			<%@ include file="../Common/JSPFExtToInclude.jspf"%>
		</div>
	</body>
</html>
