<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

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
  * This JSP displays the store locator search result page.
  *****
--%>

<!-- BEGIN StoreLocatorResults.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../include/parameters.jspf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="storeLocatorPageGroup" value="true" />
<c:set var="storeLocatorResultPage" value="true" />

<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<c:if test="${!empty WCParam.zipOrCity}">
	<c:set var="zipOrCity" value="${WCParam.zipOrCity}" />
</c:if>

<c:if test="${!empty WCParam.whichSearch}">
	<c:set var="whichSearch" value="${WCParam.whichSearch}"/>
</c:if>

<c:set var="geoNodeId" value="" />
<c:if test="${!empty WCParam.geoNodeId}">
	<c:set var="geoNodeId" value="${WCParam.geoNodeId}" />
</c:if>

<c:set var="geoNodeShortDesc" value="" />
<c:if test="${!empty WCParam.geoNodeShortDesc}">
	<c:set var="geoNodeShortDesc" value="${WCParam.geoNodeShortDesc}" />
</c:if>

<c:set var="multipleCity" value="" />
<c:if test="${!empty WCParam.multipleCity}">
	<c:set var="multipleCity" value="${WCParam.multipleCity}" />
</c:if>
<c:if test="${multipleCity}">
	<c:catch var="geoNodeException">
		<wcf:rest var="geoNodes" url="/store/{storeId}/geonode">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="q" value="byGeoNodeTypeAndName"/>
			<wcf:param name="type" value="CITY"/>
			<wcf:param name="name" value="${zipOrCity}"/>
			<wcf:param name="siteLevelSearch" value="false"/>
		</wcf:rest>
	</c:catch>

	<c:set var="resultNum" value="${fn:length(geoNodes.GeoNode)}" />
</c:if>

<c:set var="geoCodeLatitude" value="" />
<c:if test="${!empty WCParam.geoCodeLatitude}">
	<c:set var="geoCodeLatitude" value="${WCParam.geoCodeLatitude}" />
</c:if>

<c:set var="geoCodeLongitude" value="" />
<c:if test="${!empty WCParam.geoCodeLongitude}">
	<c:set var="geoCodeLongitude" value="${WCParam.geoCodeLongitude}" />
</c:if>

<c:set var="radius" value="" />
<c:if test="${!empty WCParam.radius}">
	<c:set var="radius" value="${WCParam.radius}" />
</c:if>
<c:if test="${!empty radius}">
<%
	String radiusVal = (String)pageContext.getAttribute("radius");
	Cookie cookie = new Cookie ("WC_mStRadius", radiusVal);
	cookie.setMaxAge(-1);
	cookie.setPath("/");
	response.addCookie(cookie);
%>
</c:if>

<c:set var="uom" value="" />
<c:if test="${!empty WCParam.uom}">
	<c:set var="uom" value="${WCParam.uom}" />
</c:if>
<c:if test="${!empty uom}">
<%
	String uomVal = (String)pageContext.getAttribute("uom");
	Cookie cookie = new Cookie ("WC_mStUom", uomVal);
	cookie.setMaxAge(-1);
	cookie.setPath("/");
	response.addCookie(cookie);
%>
</c:if>

<c:choose>
	<%-- If categoryId is empty --%>
	<c:when test="${empty param.categoryId}">
		<c:set var="patternName" value="ProductURL"/>
	</c:when>
	<%-- If only categoryId is present and top_category, parent_category_rn either empty or same as categoryId --%>
	<c:when test="${(empty param.top_category or (param.categoryId eq param.top_category)) and (empty param.parent_category_rn or (param.categoryId eq param.parent_category_rn))}">
		<c:set var="patternName" value="ProductURLWithCategory"/>
	</c:when>
	<%-- If categoryId, top_category and parent_category_rn are present and different --%>
	<c:when test="${(not empty param.top_category) and (not empty param.parent_category_rn) and (param.categoryId ne param.parent_category_rn) and (param.categoryId ne param.top_category) and (param.parent_category_rn ne param.top_category)}">
		<c:set var="patternName" value="ProductURLWithParentAndTopCategory"/>
	</c:when>
	<%-- here, categoryId will be present and either top_category or parent_category_rn will be different from categoryId --%>
	<c:otherwise>
		<c:set var="patternName" value="ProductURLWithParentCategory"/>
	</c:otherwise>
</c:choose>
<wcf:url var="ProductDisplayURL" patternName="${patternName}" value="Product2">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="productId" value="${param.productId}"/>
	<wcf:param name="categoryId" value="${param.categoryId}"/>
	<wcf:param name="parent_category_rn" value="${param.parent_category_rn}"/>
	<wcf:param name="top_category" value="${param.top_category}" />
	<wcf:param name="urlLangId" value="${urlLangId}" />
</wcf:url>

<c:set var="maxItems" value="${storeLocatorResultMaxPageSize}" />
<c:choose>
	<c:when test="${!empty geoNodeId}">
		<c:set var="page" value="${empty WCParam.page ? 1 : WCParam.page}" />
		<c:set var="recordSetStartNumber" value="${(page-1)*maxItems}" />
		<c:catch var="physicalStoreException">
			<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byGeoNode/{geoId}">
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				<wcf:var name="geoId" value="${geoNodeId}" encode="true"/>
				<wcf:param name="pageNumber" value="${page}"/>
				<wcf:param name="pageSize" value="${maxItems}"/>
			</wcf:rest>
		</c:catch>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${!empty geoCodeLatitude && !empty geoCodeLongitude}">
				<c:catch var="physicalStoreException">
					<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/latitude/{latitude}/longitude/{longitude}">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:var name="latitude" value="${geoCodeLatitude}" encode="true"/>
						<wcf:var name="longitude" value="${geoCodeLongitude}" encode="true"/>
						<wcf:param name="siteLevelStoreSearch" value="false"/>
						<c:if test="${!empty radius}"><wcf:param name="radius" value="${radius}" /></c:if>
						<c:if test="${!empty uom}"><wcf:param name="radiusUOM" value="${uom}" /></c:if>
						<wcf:param name="maxItems" value="${maxItems}" />
					</wcf:rest>
				</c:catch>
			</c:when>
			<c:otherwise>
				<!-- temp code starts - message!! -->
				<c:set var="resultEmpty" value="true" scope="request" />
				<!-- temp code ends - message!! -->
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>


<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<c:choose>
			<c:when test="${!multipleCity}">
				<c:choose>
					<c:when test="${!empty geoCodeLatitude && !empty geoCodeLongitude}">
						<title>
							<fmt:message bundle="${storeText}" key="MSTLOCRES_TITLE">
								<fmt:param value="${storeName}"/>
							</fmt:message>
						</title>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${!empty geoNodeId}">
								<title>
									<fmt:message bundle="${storeText}" key="MSTLOCRES_TITLE_SINGLE_CITY">
										<fmt:param value="${storeName}"/>
									</fmt:message>
								</title>
							</c:when>
							<c:otherwise>
								<title>
									<fmt:message bundle="${storeText}" key="MSTLOCRES_TITLE_NO_CITY">
										<fmt:param value="${storeName}"/>
									</fmt:message>
								</title>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<title>
					<fmt:message bundle="${storeText}" key="MSTLOCRES_TITLE">
						<fmt:param value="${storeName}" />
					</fmt:message>
				</title>
			</c:otherwise>
		</c:choose>

		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

		<%@ include file="../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body onbeforeunload='reset_locatorDropdown()'>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="MSTORE_LOCATOR_RESULTS"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:if test="${!empty WCParam.errorMsgKey}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><fmt:message bundle="${storeText}" key="${fn:escapeXml(WCParam.errorMsgKey)}" /></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<!-- Start Store Locator Results -->
			<div id="store_locator_results">
				<c:if test="${multipleCity}">
					<form id="store_locator_result_form" method="post" action="">
					<div id="multi_results" class="item_wrapper">
						<label for="select_city"><p><fmt:message bundle="${storeText}" key="MSTLOCRES_MULTI_CITY_MESSAGE" /> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span>.</p>
						<div class="item_spacer_10px"></div>
						<p><fmt:message bundle="${storeText}" key="MSTLOCRES_MULTI_CITY_SELECT" /></p></label>
						<select id="select_city" name="select_city" class="inputfield input_width_standard" onchange="window.location.href=this.form.select_city.options[this.form.select_city.selectedIndex].value;">
							<option value="" disabled selected hidden><fmt:message bundle="${storeText}" key="MO_STORE_LOCATION" /></option>
							<c:forEach var="i" begin="0" end="${resultNum-1}">
								<c:url var="mStoreLocatorResultURL" value="m30StoreLocatorResultView">
									<c:param name="storeId" value="${WCParam.storeId}" />
									<c:param name="langId" value="${WCParam.langId}" />
									<c:param name="catalogId" value="${WCParam.catalogId}" />
									<c:param name="productId" value="${WCParam.productId}" />

									<c:if test="${!empty WCParam.pgGrp}">
										<c:param name="pgGrp" value="${WCParam.pgGrp}" />
										<c:choose>
											<c:when test="${WCParam.pgGrp == 'catNav'}">
												<c:param name="categoryId" value="${WCParam.categoryId}" />
												<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
												<c:param name="top_category" value="${WCParam.top_category}" />
												<c:param name="sequence" value="${WCParam.sequence}" />
											</c:when>
											<c:when test="${WCParam.pgGrp == 'search'}">
												<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
												<c:param name="pageSize" value="${WCParam.pageSize}" />
												<c:param name="searchTerm" value="${WCParam.searchTerm}" />
												<c:param name="beginIndex" value="${WCParam.beginIndex}" />
												<c:param name="sType" value="${WCParam.sType}" />
											</c:when>
										</c:choose>
									</c:if>

									<c:param name="geoNodeId" value="${geoNodes.GeoNode[i].uniqueID}" />
									<c:param name="geoNodeShortDesc" value="${geoNodes.GeoNode[i].Description[0].shortDescription}" />
									<c:param name="fromPage" value="${fromPage}" />
									<c:param name="zipOrCity" value="${zipOrCity}" />
									<c:if test="${!empty whichSearch}">
										<c:param name="whichSearch" value="zipOrCity"/>
									</c:if>
									<c:if test="${fromPage == 'ShoppingCart'}">
										<c:param name="orderId" value="${WCParam.orderId}" />
									</c:if>
								</c:url>
								<option value="<c:out value='${mStoreLocatorResultURL}' />"><c:out value="${geoNodes.GeoNode[i].Description[0].shortDescription}" /></option>
							</c:forEach>
						</select>
					</div>
					</form>
				</c:if>

				<c:if test="${!multipleCity && (!empty geoNodeId || (!empty geoCodeLatitude && !empty geoCodeLongitude)) && empty physicalStoreException}">
					<c:set var="resultStoreNum" value="${fn:length(physicalStores.PhysicalStore)}" />
					<fmt:parseNumber var="numEntries" value="${physicalStores.recordSetTotal}" integerOnly="true" />
					<c:choose>
						<c:when test="${resultStoreNum > 0}">
							<c:set var="resultEmpty" value="false" scope="request" />

							<div id="search_results_text" class="item_wrapper">
								<p>
								<c:choose>
									<c:when test="${!empty geoNodeId}">
										<fmt:message bundle="${storeText}" key="MSTLOCRES_M_STORE">
											<fmt:param value="${recordSetStartNumber + 1}" />
											<fmt:param value="${recordSetStartNumber + resultStoreNum}" />
											<fmt:param value="${numEntries}" />
										</fmt:message> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span><c:if test="${!empty geoNodeShortDesc}">-<c:out value="${geoNodeShortDesc}" /></c:if>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${whichSearch == 'zipOrCity'}">
												<fmt:message bundle="${storeText}" key="MSTLOCRES_CLOSEST_STORE">
													<fmt:param value="${resultStoreNum}" />
												</fmt:message> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MSTLOCRES_GPS_CLOSEST_STORE">
													<fmt:param value="${resultStoreNum}" />
												</fmt:message>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
								</p>
								<c:if test="${fromPage == 'ShoppingCart'}">
									<p><fmt:message bundle="${storeText}" key="MSTLOCRES_ADD_CHECK_PROD_AVAIL" /></p>
								</c:if>
							</div>

							<c:forEach var="i" begin="0" end="${resultStoreNum-1}" varStatus="status">
								<%@ include file="../Snippets/StoreLocator/StoreHoursIndex.jspf" %>

								<div class="item_wrapper item_wrapper_gradient">
									<ul class="store_locator numbered left">
										<c:choose>
											<c:when test="${!empty geoNodeId}">
												<c:set var="detailInfoPage" value="${((page-1)*maxItems)+i+1}" />
											</c:when>
											<c:otherwise>
												<c:set var="detailInfoPage" value="${i+1}" />
											</c:otherwise>
										</c:choose>
										<li class="bold"><c:out value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" /></li>
										<div class="item_spacer_5px"></div>

										<li><c:out value="${physicalStores.PhysicalStore[i].addressLine[0]}" /><br />
										<c:out value="${physicalStores.PhysicalStore[i].city}" />, <c:out value="${physicalStores.PhysicalStore[i].stateOrProvinceName}" /><br />
										<c:out value="${physicalStores.PhysicalStore[i].postalCode}" /></li>
										<div class="item_spacer"></div>
										<c:if test="${storeHoursIndex > -1}">
											<li><c:out value="${physicalStores.PhysicalStore[i].Attribute[storeHoursIndex].displayValue}" escapeXml="false" /></li>
											<div class="item_spacer"></div>
										</c:if>
										<c:set var="phoneWithNoSpace" value="${fn:trim(physicalStores.PhysicalStore[i].telephone1)}" />
										<c:set var="phoneWithCallingFormat" value="${fn:replace(phoneWithNoSpace, '.', '-')}" />
										<li>
											<a id="store_phone_number" href="tel:+1-${phoneWithCallingFormat}"><c:out value="${phoneWithNoSpace}" /></a>
										</li>
									</ul>
									<div class="clear_float"></div>

									<div class="multi_button_container">
										<c:if test="${fromPage != 'ShoppingCart'}">
											<c:set var="prevPage" value="storeLoc" />

											<c:url var="mStoreDetailURL" value="m30StoreDetailView">
												<c:param name="storeId" value="${WCParam.storeId}" />
												<c:param name="langId" value="${WCParam.langId}" />
												<c:param name="catalogId" value="${WCParam.catalogId}" />
												<c:param name="productId" value="${WCParam.productId}" />
												<c:param name="prevPage" value="${prevPage}" />

												<c:if test="${!empty WCParam.pgGrp}">
													<c:param name="pgGrp" value="${WCParam.pgGrp}" />
													<c:choose>
														<c:when test="${WCParam.pgGrp == 'catNav'}">
															<c:param name="categoryId" value="${WCParam.categoryId}" />
															<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
															<c:param name="top_category" value="${WCParam.top_category}" />
															<c:param name="sequence" value="${WCParam.sequence}" />
														</c:when>
														<c:when test="${WCParam.pgGrp == 'search'}">
															<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
															<c:param name="pageSize" value="${WCParam.pageSize}" />
															<c:param name="searchTerm" value="${WCParam.searchTerm}" />
															<c:param name="beginIndex" value="${WCParam.beginIndex}" />
															<c:param name="sType" value="${WCParam.sType}" />
														</c:when>
													</c:choose>
												</c:if>
												<c:param name="geoNodeId" value="${geoNodeId}" />
												<c:param name="geoCodeLatitude" value="${geoCodeLatitude}" />
												<c:param name="geoCodeLongitude" value="${geoCodeLongitude}" />
												<c:param name="page" value="${detailInfoPage}" />
											</c:url>
											<a id="<c:out value='store_${status.count}_details'/>" href="${fn:escapeXml(mStoreDetailURL)}"><div class="secondary_button button_full left"><fmt:message bundle="${storeText}" key='MSTLOCRES_VIEW_DETAILS'/></div></a>
										</c:if>

										<%@ include file="../Snippets/StoreLocator/ViewMap.jspf" %>
										<div class="button_spacing left"></div>

										<c:set var="physicalStoreId" value="${physicalStores.PhysicalStore[i].uniqueID}" />
										<c:choose>
											<c:when test="${fn:contains(cookie.WC_physicalStores.value, physicalStoreId)}">
												<c:url var="mRemoveFromStoreList" value="m30RemoveFromStoreList">
													<c:param name="storeId" value="${WCParam.storeId}" />
													<c:param name="langId" value="${WCParam.langId}" />
													<c:param name="catalogId" value="${WCParam.catalogId}" />
													<c:param name="productId" value="${WCParam.productId}" />

													<c:if test="${!empty WCParam.pgGrp}">
														<c:param name="pgGrp" value="${WCParam.pgGrp}" />
														<c:choose>
															<c:when test="${WCParam.pgGrp == 'catNav'}">
																<c:param name="categoryId" value="${WCParam.categoryId}" />
																<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
																<c:param name="top_category" value="${WCParam.top_category}" />
																<c:param name="sequence" value="${WCParam.sequence}" />
															</c:when>
															<c:when test="${WCParam.pgGrp == 'search'}">
																<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
																<c:param name="pageSize" value="${WCParam.pageSize}" />
																<c:param name="searchTerm" value="${WCParam.searchTerm}" />
																<c:param name="beginIndex" value="${WCParam.beginIndex}" />
																<c:param name="sType" value="${WCParam.sType}" />
															</c:when>
														</c:choose>
													</c:if>

													<c:param name="physicalStoreId" value="${physicalStoreId}" />
													<c:param name="refUrl" value="m30StoreLocatorResultView" />
													<c:param name="geoNodeId" value="${geoNodeId}" />
													<c:param name="geoNodeShortDesc" value="${geoNodeShortDesc}" />
													<c:param name="geoCodeLatitude" value="${geoCodeLatitude}" />
													<c:param name="geoCodeLongitude" value="${geoCodeLongitude}" />
													<c:param name="zipOrCity" value="${zipOrCity}" />
													<c:param name="fromPage" value="${fromPage}" />
													<c:if test="${fromPage == 'ShoppingCart'}">
														<c:param name="orderId" value="${WCParam.orderId}" />
													</c:if>
													<c:param name="page" value="${page}" />
												</c:url>
												<a id="<c:out value='store_${status.count}_remove'/>" href="${fn:escapeXml(mRemoveFromStoreList)}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key='MSTLOCRES_REMOVE_STORE'/></div></a>
											</c:when>
											<c:otherwise>
												<c:url var="mAddToStoreList" value="m30AddToStoreList">
													<c:param name="storeId" value="${WCParam.storeId}" />
													<c:param name="langId" value="${WCParam.langId}" />
													<c:param name="catalogId" value="${WCParam.catalogId}" />
													<c:param name="productId" value="${WCParam.productId}" />

													<c:if test="${!empty WCParam.pgGrp}">
														<c:param name="pgGrp" value="${WCParam.pgGrp}" />
														<c:choose>
															<c:when test="${WCParam.pgGrp == 'catNav'}">
																<c:param name="categoryId" value="${WCParam.categoryId}" />
																<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
																<c:param name="top_category" value="${WCParam.top_category}" />
																<c:param name="sequence" value="${WCParam.sequence}" />
															</c:when>
															<c:when test="${WCParam.pgGrp == 'search'}">
																<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
																<c:param name="pageSize" value="${WCParam.pageSize}" />
																<c:param name="searchTerm" value="${WCParam.searchTerm}" />
																<c:param name="beginIndex" value="${WCParam.beginIndex}" />
																<c:param name="sType" value="${WCParam.sType}" />
															</c:when>
														</c:choose>
													</c:if>

													<c:param name="physicalStoreId" value="${physicalStoreId}" />
													<c:param name="refUrl" value="m30StoreLocatorResultView" />
													<c:param name="geoNodeId" value="${geoNodeId}" />
													<c:param name="geoNodeShortDesc" value="${geoNodeShortDesc}" />
													<c:param name="geoCodeLatitude" value="${geoCodeLatitude}" />
													<c:param name="geoCodeLongitude" value="${geoCodeLongitude}" />
													<c:param name="zipOrCity" value="${zipOrCity}" />
													<c:param name="fromPage" value="${fromPage}" />
													<c:if test="${fromPage == 'ShoppingCart'}">
														<c:param name="orderId" value="${WCParam.orderId}" />
													</c:if>
													<c:param name="page" value="${page}" />
												</c:url>
												<a id="<c:out value='store_${status.count}_add'/>" href="${fn:escapeXml(mAddToStoreList)}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key='MSTLOCRES_ADD_STORE'/></div></a>
											</c:otherwise>
										</c:choose>
										<div class="clear_float"></div>
									</div>
								</div>

							</c:forEach>

							<c:if test="${!empty geoNodeId}">
								<c:set var="remainOnLastPage" value="${(numEntries mod maxItems)>0 ? 1 : 0}" />
								<c:set var="totalPage" value="${((numEntries-(numEntries mod maxItems))/maxItems) + remainOnLastPage}" />

								<c:if test="${totalPage > 1}">
									<!-- Start Page Container -->
									<div id="page_container" class="item_wrapper" style="display:block">
										<div class="small_text left">
											<fmt:message bundle="${storeText}" key="MSTLOCRES_PAGE_NUMBER">
												<fmt:param value="${page}" />
												<fmt:param value="${totalPage}" />
											</fmt:message>
										</div>
										<div class="clear_float"></div>
									</div>
									<!-- End Page Container -->

									<div id="paging_control" class="item_wrapper">
										<c:if test="${page > 1}">
											<c:url var="mStoreLocatorResultURL" value="m30StoreLocatorResultView">
												<c:param name="storeId" value="${WCParam.storeId}" />
												<c:param name="langId" value="${WCParam.langId}" />
												<c:param name="catalogId" value="${WCParam.catalogId}" />
												<c:param name="productId" value="${WCParam.productId}" />

												<c:if test="${!empty WCParam.pgGrp}">
													<c:param name="pgGrp" value="${WCParam.pgGrp}" />
													<c:choose>
														<c:when test="${WCParam.pgGrp == 'catNav'}">
															<c:param name="categoryId" value="${WCParam.categoryId}" />
															<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
															<c:param name="top_category" value="${WCParam.top_category}" />
															<c:param name="sequence" value="${WCParam.sequence}" />
														</c:when>
														<c:when test="${WCParam.pgGrp == 'search'}">
															<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
															<c:param name="pageSize" value="${WCParam.pageSize}" />
															<c:param name="searchTerm" value="${WCParam.searchTerm}" />
															<c:param name="beginIndex" value="${WCParam.beginIndex}" />
															<c:param name="sType" value="${WCParam.sType}" />
														</c:when>
													</c:choose>
												</c:if>

												<c:param name="geoNodeId" value="${geoNodeId}" />
												<c:param name="geoNodeShortDesc" value="${geoNodeShortDesc}" />
												<c:param name="zipOrCity" value="${zipOrCity}" />
												<c:if test="${!empty whichSearch}">
													<c:param name="whichSearch" value="zipOrCity"/>
												</c:if>
												<c:param name="fromPage" value="${fromPage}" />
												<c:if test="${fromPage == 'ShoppingCart'}">
													<c:param name="orderId" value="${WCParam.orderId}" />
												</c:if>
												<c:param name="page" value="${page - 1}" />
											</c:url>
											<a id="mPrevStores" href="${fn:escapeXml(mStoreLocatorResultURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
												<div class="back_arrow_icon"></div>
												<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
											</a>
											<c:if test="${page+1 > totalPage}">
												<div class="clear_float"></div>
											</c:if>
										</c:if>
										<c:if test="${page < totalPage}">
											<c:url var="mStoreLocatorResultURL" value="m30StoreLocatorResultView">
												<c:param name="storeId" value="${WCParam.storeId}" />
												<c:param name="langId" value="${WCParam.langId}" />
												<c:param name="catalogId" value="${WCParam.catalogId}" />
												<c:param name="productId" value="${WCParam.productId}" />

												<c:if test="${!empty WCParam.pgGrp}">
													<c:param name="pgGrp" value="${WCParam.pgGrp}" />
													<c:choose>
														<c:when test="${WCParam.pgGrp == 'catNav'}">
															<c:param name="categoryId" value="${WCParam.categoryId}" />
															<c:param name="parent_category_rn" value="${WCParam.parent_category_rn}" />
															<c:param name="top_category" value="${WCParam.top_category}" />
															<c:param name="sequence" value="${WCParam.sequence}" />
														</c:when>
														<c:when test="${WCParam.pgGrp == 'search'}">
															<c:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
															<c:param name="pageSize" value="${WCParam.pageSize}" />
															<c:param name="searchTerm" value="${WCParam.searchTerm}" />
															<c:param name="beginIndex" value="${WCParam.beginIndex}" />
															<c:param name="sType" value="${WCParam.sType}" />
														</c:when>
													</c:choose>
												</c:if>

												<c:param name="geoNodeId" value="${geoNodeId}" />
												<c:param name="geoNodeShortDesc" value="${geoNodeShortDesc}" />
												<c:param name="zipOrCity" value="${zipOrCity}" />
												<c:if test="${!empty whichSearch}">
													<c:param name="whichSearch" value="zipOrCity"/>
												</c:if>
												<c:param name="fromPage" value="${fromPage}" />
												<c:if test="${fromPage == 'ShoppingCart'}">
													<c:param name="orderId" value="${WCParam.orderId}" />
												</c:if>
												<c:param name="page" value="${page + 1}" />
											</c:url>
											<a id="mNextStores" href="${fn:escapeXml(mStoreLocatorResultURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
												<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
												<div class="forward_arrow_icon"></div>
											</a>
											<c:if test="${page-1 < 1}">
												<div class="clear_float"></div>
											</c:if>
										</c:if>
									</div>
								</c:if>
							</c:if>
						</c:when>
						<c:otherwise>
							<c:set var="resultEmpty" value="true" scope="request" />
							<div id="search_results_text" class="item_wrapper">
								<c:choose>
									<c:when test="${whichSearch == 'zipOrCity'}">
										<c:choose>
											<c:when test="${!empty geoNodeId}">
												<p><fmt:message bundle="${storeText}" key="MSTLOCRES_NO_STORE"/> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span><c:if test="${!empty geoNodeShortDesc}">-<c:out value="${geoNodeShortDesc}" /></c:if></p>
											</c:when>
											<c:otherwise>
												<p><fmt:message bundle="${storeText}" key="MSTLOCRES_NO_STORE"/> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span></p>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<p>
											<fmt:message bundle="${storeText}" key="MSTLOCRES_GPS_CLOSEST_STORE">
												<fmt:param value="0" />
											</fmt:message>
										</p>
									</c:otherwise>
								</c:choose>
							</div>
						</c:otherwise>
					</c:choose>
				</c:if>
				<c:if test="${!multipleCity && empty geoNodeId && empty geoCodeLatitude && empty geoCodeLongitude}">
					<c:set var="resultEmpty" value="true" scope="request" />
					<div id="search_results_text" class="item_wrapper">
						<p><fmt:message bundle="${storeText}" key="MSTLOCRES_NO_STORE"/> <span class="bold">&#34;<c:out value="${zipOrCity}" />&#34;</span></p>
					</div>
				</c:if>

				<c:if test="${fromPage != 'ProductDetails' && fromPage != 'ShoppingCart'}">
					<c:if test="${!empty cookie.WC_physicalStores.value}">
						<c:url var="mSelectedStoreListURL" value="m30SelectedStoreListView">
							<c:param name="storeId" value="${WCParam.storeId}" />
							<c:param name="langId" value="${WCParam.langId}" />
							<c:param name="catalogId" value="${WCParam.catalogId}" />
							<c:param name="productId" value="${WCParam.productId}" />
							<c:param name="fromPage" value="${fromPage}" />
						</c:url>

						<div id="store_list_container" class="item_wrapper">
							<div class="single_button_container">
								<p><fmt:message bundle="${storeText}" key="MSTLOCRES_STLST_MANAGE"/></p>
								<a id="store_locator_list" href="${fn:escapeXml(mSelectedStoreListURL)}"><div class="secondary_button button_full"><fmt:message bundle="${storeText}" key='MSTLOCRES_STLST'/></div></a>
								<div class="clear_float"></div>
							</div>
						</div>
					</c:if>
				</c:if>

				<c:choose>
					<c:when test="${fromPage == 'InventoryStatus'}">
						<div id="continue_results" class="item_wrapper_button">
							<div class="single_button_container">
								<input type="submit" id="continue_shopping" name="continue_shopping" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLOCRES_CONT_SHOPPING'/>" onclick="javascript:setPageLocation('${fn:escapeXml(ProductDisplayURL)}')" />
							</div>
							<div class="clear_float"></div>
						</div>
					</c:when>
					<c:when test="${fromPage == 'ProductDetails'}">
						<form id="store_result_button" method="post" action="ProductDisplay">
							<input type="hidden" id="storeId_pd" name="storeId" value="<c:out value="${WCParam.storeId}" escapeXml="true"/>" />
							<input type="hidden" id="langId_pd" name="langId" value="<c:out value="${WCParam.langId}" escapeXml="true"/>" />
							<input type="hidden" id="catalogId_pd" name="catalogId" value="<c:out value="${WCParam.catalogId}" escapeXml="true"/>" />
							<input type="hidden" id="productId_pd" name="productId" value="<c:out value="${WCParam.productId}" escapeXml="true"/>" />

							<c:if test="${!empty WCParam.pgGrp}">
								<input type="hidden" id="pgGrp_pd" name="pgGrp" value="<c:out value="${WCParam.pgGrp}" escapeXml="true"/>" />
								<c:choose>
									<c:when test="${WCParam.pgGrp == 'catNav'}">
										<input type="hidden" id="categoryId_pd" name="categoryId" value="<c:out value="${WCParam.categoryId}" escapeXml="true"/>" />
										<input type="hidden" id="parent_category_rn_pd" name="parent_category_rn" value="<c:out value="${WCParam.parent_category_rn}" escapeXml="true"/>" />
										<input type="hidden" id="top_category_pd" name="top_category" value="<c:out value="${WCParam.top_category}" escapeXml="true"/>" />
										<input type="hidden" id="sequence_pd" name="sequence" value="<c:out value="${WCParam.sequence}" escapeXml="true"/>" />
									</c:when>
									<c:when test="${WCParam.pgGrp == 'search'}">
										<input type="hidden" id="resultCatEntryType_pd" name="resultCatEntryType" value="<c:out value="${WCParam.resultCatEntryType}" escapeXml="true"/>" />
										<input type="hidden" id="pageSize_pd" name="pageSize" value="<c:out value="${WCParam.pageSize}" escapeXml="true"/>" />
										<input type="hidden" id="searchTerm_pd" name="searchTerm" value="<c:out value="${WCParam.searchTerm}" escapeXml="true"/>" />
										<input type="hidden" id="sType_pd" name="sType" value="<c:out value="${WCParam.sType}" escapeXml="true"/>" />
										<input type="hidden" id="beginIndex_pd" name="beginIndex" value="<c:out value="${WCParam.beginIndex}" escapeXml="true"/>" />
									</c:when>
								</c:choose>
							</c:if>

							<div id="continue_results" class="item_wrapper_button">
								<div class="single_button_container">
									<input type="submit" id="continue_shopping" name="continue_shopping" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLOCRES_CONT_SHOPPING'/>" />
								</div>
								<div class="clear_float"></div>
							</div>
						</form>
					</c:when>
					<c:when test="${fromPage == 'ShoppingCart'}">
						<form id="store_result_button" method="post" action="m30SelectedStoreListView">
							<input type="hidden" id="storeId_sc" name="storeId" value="<c:out value="${WCParam.storeId}" escapeXml="true"/>" />
							<input type="hidden" id="langId_sc" name="langId" value="<c:out value="${WCParam.langId}" escapeXml="true"/>" />
							<input type="hidden" id="catalogId_sc" name="catalogId" value="<c:out value="${WCParam.catalogId}" escapeXml="true"/>" />
							<input type="hidden" id="fromPage_sc" name="fromPage" value="<c:out value="${fromPage}" escapeXml="true"/>" />
							<input type="hidden" id="orderId_sc" name="orderId" value="<c:out value="${WCParam.orderId}" escapeXml="true"/>" />

							<div id="continue_results" class="item_wrapper_button">
								<div class="single_button_container">
									<input type="submit" id="continue_checkout" name="continue_checkout" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLOCRES_CONT_CHECKOUT'/>" />
								</div>
								<div class="clear_float"></div>
							</div>
						</form>
					</c:when>
					<c:otherwise>
						<div id="continue_results" class="item_wrapper_button">
							<div class="single_button_container">
								<input type="submit" id="continue_shopping" name="continue_shopping" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLOCRES_CONT_SHOPPING'/>" onclick="javascript:setPageLocation('${fn:escapeXml(env_TopCategoriesDisplayURL)}')" />
							</div>
							<div class="clear_float"></div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- End Store Locator Results -->

			<%@ include file="../include/FooterDisplay.jspf" %>
		</div>

		<script type="text/javascript">
        //<![CDATA[

        function reset_locatorDropdown() {
		    if(document.getElementById('select_city')) {
		    	document.getElementById('select_city').selectedIndex = 0;
		    }
		    return true;
		}
		        
        //]]> 
        </script>

	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END StoreLocatorResults.jsp -->
