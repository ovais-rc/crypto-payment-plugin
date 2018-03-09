<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP removes a physical store from the store list.
  *****
--%>

<!-- BEGIN RemoveFromStoreList.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="physicalStoreId" value="" />
<c:if test="${!empty WCParam.physicalStoreId}">
	<c:set var="physicalStoreId" value="${WCParam.physicalStoreId}" />
</c:if>

<c:set var="wcPhysicalStores" value="${cookie.WC_physicalStores.value}" />
<c:if test="${(!empty wcPhysicalStores) && (fn:contains(wcPhysicalStores, physicalStoreId))}">
	<c:set var="physicalStoreIdSeparator" value="${physicalStoreId}%2C" />
	<c:set var="separatorPhysicalStoreId" value="%2C${physicalStoreId}" />
	<c:set var="wcPhysicalStores" value="${fn:replace(wcPhysicalStores, physicalStoreIdSeparator, '')}" scope="page" />
	<c:if test="${fn:contains(wcPhysicalStores, physicalStoreId)}">
		<c:set var="wcPhysicalStores" value="${fn:replace(wcPhysicalStores, separatorPhysicalStoreId, '')}" scope="page" />
	</c:if>
	<c:if test="${fn:contains(wcPhysicalStores, physicalStoreId)}">
		<c:set var="wcPhysicalStores" value="${fn:replace(wcPhysicalStores, physicalStoreId, '')}" scope="page" />
	</c:if>

	<%
		String stores = (String)pageContext.getAttribute("wcPhysicalStores");
		Cookie cookie = new Cookie ("WC_physicalStores", stores);
		cookie.setMaxAge(-1);
		cookie.setPath("/");
		response.addCookie(cookie);
	%>
</c:if>

<c:set var="wcPickUpStoreId" value="${cookie.WC_pickUpStore.value}" />
<c:if test="${(!empty wcPickUpStoreId) && (fn:contains(wcPickUpStoreId, physicalStoreId))}">
	<%
		Cookie cookie = new Cookie ("WC_pickUpStore", "");
		cookie.setMaxAge(0);
		cookie.setPath("/");
		response.addCookie(cookie);
	%>
</c:if>

<wcf:url var="refUrl" value="${WCParam.refUrl}">
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

	<wcf:param name="zipOrCity" value="${WCParam.zipOrCity}" />
	<wcf:param name="geoNodeId" value="${WCParam.geoNodeId}" />
	<wcf:param name="geoNodeShortDesc" value="${WCParam.geoNodeShortDesc}" />
	<wcf:param name="geoCodeLatitude" value="${WCParam.geoCodeLatitude}" />
	<wcf:param name="geoCodeLongitude" value="${WCParam.geoCodeLongitude}" />
	<wcf:param name="fromPage" value="${WCParam.fromPage}" />
	<c:if test="${WCParam.fromPage == 'ShoppingCart'}">
		<wcf:param name="orderId" value="${WCParam.orderId}" />	
	</c:if>
	<wcf:param name="recordSetReferenceId" value="${WCParam.recordSetReferenceId}" />
	<wcf:param name="page" value="${WCParam.page}" />
</wcf:url>

<% 
	String refUrl = pageContext.getAttribute("refUrl").toString();
	response.sendRedirect(refUrl); 
%>

<!-- END RemoveFromStoreList.jsp -->
