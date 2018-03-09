<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP performs search for geo node ID or geo code that is used by the store locator search result page.
  *****
--%>

<!-- BEGIN StoreLocatorSearch.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<wcst:alias name="SpecialCharacterHelper" var="escapedZipOrCity">
	<wcf:param name="parameter" value="${param.zipOrCity}"/>
</wcst:alias>


<c:set var="storeLocatorPageGroup" value="true" />
<c:set var="storeLocatorSearchPage" value="true" />

<c:set var="zipOrCity" value="" />
<c:if test="${!empty WCParam.zipOrCity}">
	<c:set var="zipOrCity" value="${fn:trim(WCParam.zipOrCity)}" />
</c:if>
<c:if test="${!empty escapedZipOrCity}">
	<c:set var="zipOrCity" value="${fn:trim(escapedZipOrCity)}" />
</c:if>

<c:if test="${!empty zipOrCity}">
	<c:catch var="geoNodeException">
		<wcf:rest var="geoNodes" url="/store/{storeId}/geonode">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="q" value="byGeoNodeTypeAndName"/>
			<wcf:param name="type" value="CITY"/>
			<wcf:param name="name" value="${fn:trim(escapedZipOrCity)}"/>
			<wcf:param name="siteLevelSearch" value="false"/>
		</wcf:rest>
	</c:catch>

	<c:set var="geoNodeId" value="" />
	<c:set var="multipleCity" value="false" />
	<c:choose>
		<c:when test="${!empty zipOrCity && empty geoNodeException}">
			<c:set var="resultNum" value="${geoNodes.recordSetTotal}" />
			<c:if test="${resultNum > 0}">
				<c:set var="geoNodeId" value="${geoNodes.uniqueID}" />
				<c:set var="geoNodeShortDesc" value="${geoNodes.Description[0].shortDescription}" />
			</c:if>
			<c:if test="${resultNum > 1}">
				<c:set var="multipleCity" value="true" />
			</c:if>
		</c:when>
		<c:otherwise>
			<c:if test="${!empty WCParam.geoNodeId}">
				<c:set var="geoNodeId" value="${WCParam.geoNodeId}" />
			</c:if>
		</c:otherwise>
	</c:choose>

	<c:if test="${empty geoNodeId}">
		<%@ include file="../Snippets/StoreLocator/SearchZipCode.jspf" %>
	</c:if>
</c:if>

<wcf:url var="refUrl" value="m30StoreLocatorResultView">
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="langId" value="${WCParam.langId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="productId" value="${WCParam.productId}" />

	<c:if test="${!empty WCParam.pgGrp}">
		<wcf:param name="pgGrp" value="${WCParam.pgGrp}" />
		<c:choose>
			<c:when test="${WCParam.pgGrp == 'catNav'}">
				<wcf:param name="categoryId" value="${WCParam.categoryId}" />
				<wcf:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
				<wcf:param name="top_category" value="${WCParam.top_category}" />
				<wcf:param name="sequence" value="${WCParam.sequence}" />
			</c:when>
			<c:when test="${WCParam.pgGrp == 'search'}">
				<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
				<wcf:param name="pageSize" value="${WCParam.pageSize}" />
				<wcf:param name="searchTerm" value="${WCParam.searchTerm}" />
				<wcf:param name="beginIndex" value="${WCParam.beginIndex}" />
				<wcf:param name="sType" value="${WCParam.sType}" />
			</c:when>
		</c:choose>
	</c:if>

	<wcf:param name="fromPage" value="${WCParam.fromPage}" />
	<c:if test="${WCParam.fromPage == 'ShoppingCart'}">
		<wcf:param name="orderId" value="${WCParam.orderId}" />
	</c:if>
	<wcf:param name="geoNodeId" value="${geoNodeId}" />
	<wcf:param name="geoNodeShortDesc" value="${geoNodeShortDesc}" />
	<wcf:param name="multipleCity" value="${multipleCity}" />
	<wcf:param name="geoCodeLatitude" value="${geoCodeLatitude}" />
	<wcf:param name="geoCodeLongitude" value="${geoCodeLongitude}" />
	<c:if test="${!empty zipOrCity}">
		<wcf:param name="zipOrCity" value="${zipOrCity}"/>
		<wcf:param name="whichSearch" value="zipOrCity"/>
	</c:if>
</wcf:url>

<%
	String refUrl = pageContext.getAttribute("refUrl").toString();
	response.sendRedirect(refUrl);
%>

<!-- END StoreLocatorSearch.jsp -->
