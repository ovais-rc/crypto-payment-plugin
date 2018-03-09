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
<%-- 
  ***
  * This jsp populates the data required by the physical store inventory section of the product display page.
  * It creates a JSON object which is returned to the client from the AJAX call.
  ***
--%>
<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:set var="cookieVal" value="${cookie.WC_physicalStores.value}" />
<c:set var="cookieVal" value="${fn:replace(cookieVal, '%2C', ',')}"/>

<%-- Fetches the inventory list for a particular item in online store and physical store using store ids--%>
<c:if test="${empty storeInventorySystem}">
	<wcf:rest var="queryStoreInventoryConfigResult" url="store/{storeId}/configuration/{uniqueId}" cached="true">
		<wcf:var name="storeId" value="${storeId}"/>
		<wcf:var name="uniqueId" value="com.ibm.commerce.foundation.inventorySystem"/>
		<wcf:param name="langId" value="${langId}" />
	</wcf:rest>
	<c:set var="storeInventorySystem" value="${queryStoreInventoryConfigResult.resultList[0].configurationAttribute[0].primaryValue.value}" scope="request"/>
</c:if>

<c:if test="${storeInventorySystem != 'No inventory'}">
	<c:catch>
		<wcf:rest var="itemInventoryList" url="store/{storeId}/inventoryavailability/{productIds}">
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
			<wcf:var name="productIds" value="${param.itemId}" encode="true"/>
			<wcf:param name="onlineStoreId" value="${storeId}"/>
			<wcf:param name="physicalStoreId" value="${cookieVal}"/>
		</wcf:rest>
	</c:catch>
</c:if>

<c:set var="physicalStores" value=""/>
<c:set var="storeCounter" value="0"/>
<c:set var="onlineInventoryStatus" value="NA"/>
<%-- Iterates through the inventory list to get the online inventory status and physical store inventory status --%>
<c:forEach var="itemInventory" items="${itemInventoryList.InventoryAvailability}" varStatus="counter">
	<c:choose>
		<%-- Selects the online inventory status when online store name is not empty --%>
		<c:when test="${!empty itemInventory.onlineStoreName}">
			<c:if test="${!empty itemInventory.inventoryStatus}">
			    <c:set var="onlineInventoryStatus" value="${itemInventory.inventoryStatus}"/>
			</c:if>
		</c:when>
		<%-- Process the physical store inventory availability information when physical store name is not empty --%>
		<c:when test="${!empty itemInventory.physicalStoreName}">
			<c:set var="storeCounter" value="${storeCounter+1}"/>
			
			<c:choose>
				<c:when test="${! empty(itemInventory.availabilityDateTime)}">
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="date" value="${itemInventory.availabilityDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT" dateStyle="long"/>
					</c:catch>
					<c:if test="${empty date}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="date" value="${itemInventory.availabilityDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT" dateStyle="long"/>
						</c:catch>
					</c:if>
					<fmt:formatDate var="availableDate" value="${date}"/>
				</c:when>
				<c:otherwise>
					<c:set var="availableDate" value=""/>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${empty itemInventory.inventoryStatus}">
					<c:set var="inventoryStatus" value="NA"/>
					<wcst:message key="INV_STATUS_NA" var="inventoryStatusText" bundle="${widgetText}"/>
					<wcst:message key="IMG_NAME_NA" var="imageName" bundle="${widgetText}"/>
					<wcst:message key="IMG_INV_STATUS_NA" var="altText" bundle="${widgetText}"/>
					
				</c:when>
				<c:otherwise>
					<c:set var="inventoryStatus" value="${itemInventory.inventoryStatus}"/>
					<wcst:message key="INV_STATUS_${itemInventory.inventoryStatus}" var="inventoryStatusText" bundle="${widgetText}"/>
					<wcst:message key="IMG_NAME_${itemInventory.inventoryStatus}" var="imageName" bundle="${widgetText}"/>
					<wcst:message key="IMG_INV_STATUS_${itemInventory.inventoryStatus}" var="altText" bundle="${widgetText}"/>
				</c:otherwise>
			</c:choose>
			<c:if test="${!empty physicalStores}">
				<c:set var="physicalStores" value="${physicalStores},"/>
			</c:if>
			<c:set var="physicalStores" value="${physicalStores}{
				id: '${itemInventory.physicalStoreId}',
				name: '${fn:escapeXml(itemInventory.physicalStoreName)}',
				status: '${inventoryStatus}',
				statusText: '${fn:escapeXml(inventoryStatusText)}',
				image: 'widget_product_info/${imageName}',
				altText: '${fn:escapeXml(altText)}',
				availableDate: '${availableDate}',
				availableQuantity: '${itemInventory.availableQuantity}'}"/>
		</c:when>
	</c:choose>
</c:forEach>

<%-- Pick 'Select Store' message if no physical store currently picked. Pick 'Change Store' if some physical store is picked already.  --%>
<c:choose>
	<c:when test="${storeCounter eq 0}">
		<wcst:message key="INV_STATUS_CHECK_IN_STORES" var="invStatusCheckStores" bundle="${widgetText}"/>
	</c:when>
	<c:otherwise>
		<wcst:message key="INV_STATUS_CHECK_OTHER_STORES" var="invStatusCheckStores" bundle="${widgetText}"/>
	</c:otherwise>
</c:choose>

<%-- Prepares the json object to be returned --%>
/*
{
"onlineInventory": {
	status: "<wcst:message key="INV_STATUS_${onlineInventoryStatus}" bundle="${widgetText}"/>",
	image: "widget_product_info/<wcst:message key="IMG_NAME_${onlineInventoryStatus}" bundle="${widgetText}"/>",
	altText: "<wcst:message key="IMG_INV_STATUS_${onlineInventoryStatus}" bundle="${widgetText}"/>"},
"inStoreInventory": {
	stores: [${physicalStores}],
	checkStoreText: "${invStatusCheckStores}"
	}
}
*/
