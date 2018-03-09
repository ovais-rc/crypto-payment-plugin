<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp populates the data required by the online store inventory section of the SKU list widget.
  * It creates a JSON object which is returned to the client from the AJAX call.
  ***
--%>
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>
<%@ include file="/Widgets_801/Common/PDP_CatalogEntryData.jspf" %>

<c:if test="${empty storeInventorySystem}">
	<wcf:rest var="storeInventoryConfig" url="store/{storeId}/configuration/{uniqueId}" cached="true">
		<wcf:var name="storeId" value="${param.storeId}"/>
		<wcf:var name="uniqueId" value="com.ibm.commerce.foundation.inventorySystem"/>
	</wcf:rest>
	<c:set var="storeInventorySystem" value="${queryStoreInventoryConfigResult.resultList[0].configurationAttribute[0].primaryValue.value}" scope="request"/>
</c:if>

<%-- Get the online inventory availabilities for all SKUs --%>
<c:if test="${storeInventorySystem != 'No inventory'}">
	<c:choose>
		<c:when test="${type eq 'product'}">
			<c:forEach var="sku" items="${entitledItems}" varStatus="status">
				<c:if test="${sku.buyable eq 'true'}">
					<c:if test="${status.count == 1}">
						<c:set var="productIds" value="${sku.uniqueID}"/>
					</c:if>
					<c:if test="${status.count > 1}">
						<c:set var="productIds" value="${productIds},${sku.uniqueID}"/>
					</c:if>
				</c:if>
			</c:forEach>
		</c:when>
		<c:when test="${type eq 'item' && catalogEntryDetails.buyable}">
			<c:set var="productIds" value="${catalogEntryDetails.uniqueID}"/>
		</c:when>
		<c:otherwise>
		</c:otherwise>
	</c:choose>
	
	<c:catch var="inventoryException">
		<wcf:rest var="inventoryAvailabilities" url="store/{storeId}/inventoryavailability/{productIds}">
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
			<wcf:var name="productIds" value="${productIds}"/>
		</wcf:rest>
	</c:catch>

	<%-- If an exception is thrown, it means the store has no inventory --%>
	<c:choose>
		<c:when test="${empty inventoryException}">
			<c:set var="showInventory" value="true"/>
		</c:when>
		<c:otherwise>
			<c:set var="showInventory" value="false"/>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- Prepares the json object to be returned --%>

{
"onlineInventory": 
	{
	<c:forEach var="itemAvailability" items="${inventoryAvailabilities.InventoryAvailability}" varStatus="status">
		<c:set var="onlineInventoryStatus" value="${itemAvailability.inventoryStatus}" />
		"${itemAvailability.productId}": 
		{
			"status": "<wcst:message key="INV_STATUS_${onlineInventoryStatus}" bundle="${widgetText}"/>",
			"image": "widget_product_info/<wcst:message key="IMG_NAME_${onlineInventoryStatus}" bundle="${widgetText}"/>",
			"altText": "<wcst:message key="IMG_INV_STATUS_${onlineInventoryStatus}" bundle="${widgetText}"/>"
		}
		<c:if test="${status.index < inventoryAvailabilities.InventoryAvailability.size() - 1}">
		,
		</c:if>
	</c:forEach>
	}
}

