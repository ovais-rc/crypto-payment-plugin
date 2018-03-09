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
  * This JSP contains logic to find the store information.
  *****
--%>

<!-- BEGIN StoreInfo.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="storeLocatorPageGroup" value="true" />
<c:set var="storeDetailPage" value="true" />

<c:if test="${WCParam.prevPage == 'storeLoc' || WCParam.prevPage == 'storeDetail'}">
	<c:set var="prodComparePageGroup" value="false" />
	<c:set var="searchPageGroup" value="false" />
	<c:set var="wishlistPageGroup" value="false" />
	<c:set var="shoppingcartPageGroup" value="false" />
</c:if>
<c:if test="${empty WCParam.storeList}">
	<c:choose>
		<c:when test="${param.pgGrp == 'catNav'}">
			<c:set var="categoryNavPageGroup" value="true" scope="request"/>
		</c:when>
		<c:when test="${param.pgGrp == 'search'}">
			<c:set var="searchPageGroup" value="true" scope="request"/>
		</c:when>
		<c:when test="${param.pgGrp == 'wishlist'}">
			<c:set var="wishlistPageGroup" value="true" scope="request"/>
		</c:when>
		<c:when test="${param.pgGrp == 'shoppingcart'}">
			<c:set var="shoppingcartPageGroup" value="true" scope="request"/>
		</c:when>
		<c:when test="${param.pgGrp == 'prodComp'}">
			<c:set var="prodComparePageGroup" value="true" scope="request"/>
		</c:when>	
		<c:otherwise>
			<c:set var="storeLocatorPageGroup" value="true" />
		</c:otherwise>	
	</c:choose>
</c:if>
<c:if test="${!empty WCParam.storeList}">
	<c:set var="storeLocatorPageGroup" value="true" />
</c:if>


<c:set var="storeListIndex" value="" />
<c:if test="${!empty WCParam.storeListIndex}">
	<c:set var="storeListIndex" value="${WCParam.storeListIndex}" />
</c:if>
<c:if test="${!empty param.storeListIndex}">
	<c:set var="storeListIndex" value="${param.storeListIndex}" />
</c:if>

<c:set var="physicalStoreId" value="" />
<c:if test="${!empty WCParam.physicalStoreId}">
	<c:set var="physicalStoreId" value="${WCParam.physicalStoreId}" />
</c:if>
<c:if test="${!empty param.physicalStoreId}">
	<c:set var="physicalStoreId" value="${param.physicalStoreId}" />
</c:if>

<c:set var="storeAvailPage" value="" />
<c:if test="${!empty WCParam.storeAvailPage}">
	<c:set var="storeAvailPage" value="${WCParam.storeAvailPage}" />
</c:if>
<c:if test="${!empty param.storeAvailPage}">
	<c:set var="storeAvailPage" value="${param.storeAvailPage}" />
</c:if>

<c:if test"${!empty cookie.WC_physicalStores.value}">
	<c:set var="wcPhysicalStores" value="${cookie.WC_physicalStores.value}" />
	<c:set var="wcPhysicalStores" value="${fn:replace(wcPhysicalStores, '%2C', ',')}"/>
	<c:set var="physicalStoreArray" value="${fn:split(wcPhysicalStores, ',')}" />
	<c:set var="physicalStoreSize" value="${fn:length(physicalStoreArray)}" />			
</c:if>

<c:choose>
	<c:when test="${empty storeListIndex && empty physicalStoreId}">
		<c:set var="geoNodeId" value="" />
		<c:if test="${!empty WCParam.geoNodeId}">
			<c:set var="geoNodeId" value="${WCParam.geoNodeId}" />
		</c:if>
		<c:if test="${!empty param.geoNodeId}">
			<c:set var="geoNodeId" value="${param.geoNodeId}" />
		</c:if>

		<c:set var="geoCodeLatitude" value="" />
		<c:if test="${!empty WCParam.geoCodeLatitude}">
			<c:set var="geoCodeLatitude" value="${WCParam.geoCodeLatitude}" />
		</c:if>
		<c:if test="${!empty param.geoCodeLatitude}">
			<c:set var="geoCodeLatitude" value="${param.geoCodeLatitude}" />
		</c:if>

		<c:set var="geoCodeLongitude" value="" />
		<c:if test="${!empty WCParam.geoCodeLongitude}">
			<c:set var="geoCodeLongitude" value="${WCParam.geoCodeLongitude}" />
		</c:if>
		<c:if test="${!empty param.geoCodeLongitude}">
			<c:set var="geoCodeLongitude" value="${param.geoCodeLongitude}" />
		</c:if>
		
		<c:set var="page" value="" />
		<c:if test="${!empty WCParam.page}">
			<c:set var="page" value="${WCParam.page}" />
		</c:if>
		<c:if test="${!empty param.page}">
			<c:set var="page" value="${param.page}" />
		</c:if>
		
		<c:choose>
			<c:when test="${!empty page}">
				<c:if test="${page < 1}">
					<c:set var="page" value="1" />
				</c:if>
				<c:if test="${page > 1}">
					<c:if test="${!empty geoNodeId}">
						<c:set var="maxItems" value="1" />
						<c:set var="recordSetStartNumber" value="0" />
						<c:catch var="physicalStoreException">
							<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byGeoNode/{geoId}">
								<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
								<wcf:var name="geoId" value="${geoNodeId}" encode="true"/>
								<wcf:param name="pageNumber" value="${page}" />
								<wcf:param name="pageSize" value="${maxItems}" />
							</wcf:rest>
						</c:catch>
					</c:if>
				</c:if>
			</c:when>
			<c:otherwise>
				<c:set var="page" value="1" />
			</c:otherwise>
		</c:choose>
		
		<c:if test="${!empty geoNodeId}">
			<c:set var="maxItems" value="1" />
			<c:set var="recordSetStartNumber" value="${(page-1)*maxItems}" />
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byGeoNode/{geoId}">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:var name="geoId" value="${geoNodeId}" encode="true"/>
					<wcf:param name="pageNumber" value="${page}" />
					<wcf:param name="pageSize" value="${maxItems}" />
				</wcf:rest>
			</c:catch>
		</c:if>
		<c:if test="${!empty geoCodeLatitude && !empty geoCodeLongitude}">
			<c:set var="maxItems" value="${storeLocatorResultMaxPageSize}" />
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/latitude/{latitude}/longitude/{longitude}">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:var name="latitude" value="${geoCodeLatitude}" encode="true"/>
					<wcf:var name="longitude" value="${geoCodeLongitude}" encode="true"/>
					<wcf:param name="siteLevelStoreSearch" value="false"/>
					<c:if test="${!empty cookie.WC_mStRadius.value}">
						<wcf:param name="radius" value="${cookie.WC_mStRadius.value}" />
					</c:if>                   
					<c:if test="${!empty cookie.WC_mStUom.value}">
						<wcf:param name="radiusUOM" value="${cookie.WC_mStUom.value}" />
					</c:if>                   
					<wcf:param name="maxItems" value="${maxItems}" />
				</wcf:rest>
			</c:catch>
		</c:if>
	</c:when>
	<c:when test="${!empty physicalStoreId}">
		<c:if test"${!empty cookie.WC_physicalStores.value}">
			<c:forEach var="thePhysicalStore" items="${physicalStoreArray}" varStatus="theRow">
				<c:if test="${physicalStoreId == thePhysicalStore}">
					<c:set var="page" value="${theRow.count}" />
				</c:if>
			</c:forEach>
			
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byStoreId/${physicalStoreId}">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				</wcf:rest>
			</c:catch>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:if test"${!empty cookie.WC_physicalStores.value}">
			<c:set var="page" value="${storeListIndex+1}" />
			
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byStoreIds">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<c:forTokens items="${wcPhysicalStores}" delims="," var="phyStoreId">
						<wcf:param name="physicalStoreId" value="${phyStoreId}" />	
					</c:forTokens>
				</wcf:rest>
			</c:catch>
		</c:if>
	</c:otherwise>
</c:choose>


<c:if test="${(!empty geoNodeId || (!empty geoCodeLatitude && !empty geoCodeLongitude) || !empty physicalStoreId || !empty storeListIndex) && empty physicalStoreException}">
	<c:set var="resultStoreNum" value="${fn:length(physicalStores.PhysicalStore)}" />
	<c:choose>
		<c:when test="${resultStoreNum > 0}">
			<c:choose>
				<c:when test="${empty storeListIndex and empty physicalStoreId}">
					<c:choose>
						<c:when test="${!empty geoNodeId}">
							<c:set var="i" value="0" />
						</c:when>
						<c:otherwise>
							<c:set var="i" value="${page-1}" />
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${!empty physicalStoreId}">
					<c:set var="i" value="0" />
				</c:when>
				<c:otherwise>
					<c:set var="i" value="${storeListIndex}" />
				</c:otherwise>
			</c:choose>
			<%@ include file="./StoreHoursIndex.jspf" %>
			
			<c:set var="physicalStoreIdentifier" value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" />
			
			<c:set var="infoType" value="${param.infoType}" />
			<c:if test="${infoType == 'Details'}">
				<%@ include file="./StoreDetailInfo.jspf" %>
			</c:if>
			<c:if test="${infoType == 'Map'}">
				<c:set var="storeMap" value="true" />
				<c:if test="${!empty storeAvailPage}">
					<c:set var="storeLocatorPageGroup" value="false" />
				</c:if>
				<%@ include file="./StoreMapInfo.jspf" %>
			</c:if>

		</c:when>
		<c:otherwise>
			<c:set var="physicalStoreIdentifier" value="" />
		</c:otherwise>
	</c:choose>
</c:if>

<!-- END StoreInfo.jsp -->
