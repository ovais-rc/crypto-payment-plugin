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
  * This JSP store the selected pickup store ID to the cookie.
  *****
--%>

<!-- BEGIN SaveStoreSelection.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="fromPage" value="" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<c:set var="pickUpAtStoreId" value="" />
<c:if test="${!empty WCParam.pickUpAtStoreId}">
	<c:set var="pickUpAtStoreId" value="${WCParam.pickUpAtStoreId}" scope="page" />
</c:if>

<c:if test="${!empty pickUpAtStoreId}">
	<%
		String selectedStore = (String)pageContext.getAttribute("pickUpAtStoreId");
		Cookie cookie = new Cookie ("WC_pickUpStore", selectedStore);
		cookie.setMaxAge(-1);
		cookie.setPath("/");
		response.addCookie(cookie);
	%>
</c:if>

<wcf:url var="refUrl" value="${WCParam.refUrl}">
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="langId" value="${WCParam.langId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="productId" value="${WCParam.productId}" />
</wcf:url>


<%-- Get the BOPIS shipping mode uniqueId to update all order items with the in-store pickup shipping mode id. --%>
<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>

<wcf:rest var="usableShippingInfo" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	<wcf:param name="pageSize" value="1"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>

<c:set var="doneLoop" value="false"/>
<c:forEach items="${usableShippingInfo.orderItem}" var="curOrderItem">
	<c:if test="${not doneLoop}">
		<c:forEach items="${curOrderItem.usableShippingMode}" var="curShipmode">
			<c:if test="${not doneLoop}">
				<c:if test="${curShipmode.shipModeCode == 'PickupInStore'}">
					<c:set var="doneLoop" value="true"/>
					<c:set var="bopisShipmodeId" value="${curShipmode.shipModeId}"/>
				</c:if>
			</c:if>
		</c:forEach>
	</c:if>
</c:forEach>

<wcf:url var="updateItemPhysicalStore" value="RESTOrderShipInfoUpdate">
	<wcf:param name="authToken" value="${authToken}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="orderId" value="${order.orderId}" />
	<wcf:param name="URL" value="${WCParam.refUrl}" />
	<wcf:param name="fromPage" value="${fromPage}" />

	<c:forEach var="curOrderItem" items="${order.orderItem}" varStatus="counter">
		<wcf:param name="orderItemId_${counter.count}" value="${curOrderItem.orderItemId}"/>
		<wcf:param name="shipModeId_${counter.count}" value="${bopisShipmodeId}"/>
		<wcf:param name="physicalStoreId_${counter.count}" value="${pickUpAtStoreId}"/>
	</c:forEach>
				
</wcf:url>

<% 
	String refUrl = pageContext.getAttribute("updateItemPhysicalStore").toString();
	response.sendRedirect(refUrl); 
%>

<!-- END SaveStoreSelection.jsp -->
