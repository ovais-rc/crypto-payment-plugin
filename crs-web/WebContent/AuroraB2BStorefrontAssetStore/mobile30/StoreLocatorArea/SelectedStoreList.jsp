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
  * This JSP displays the selected store list page.
  *****
--%>

<!-- BEGIN SelectedStoreList.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="storeLocatorPageGroup" value="true" />
<c:set var="selectedStoreListPage" value="true" />

<c:set var="fromPage" value="" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:set var="wcPhysicalStores" value="${cookie.WC_physicalStores.value}" />
<c:if test="${!empty wcPhysicalStores}">
	<c:set var="wcPhysicalStores" value="${fn:replace(wcPhysicalStores, '%2C', ',')}" scope="page" />
	<c:catch var="physicalStoreException">
		<wcf:rest var="physicalStores" url="/store/{storeId}/storelocator/byStoreIds">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<c:forTokens items="${wcPhysicalStores}" delims="," var="phyStoreId">
				<wcf:param name="physicalStoreId" value="${phyStoreId}" />
			</c:forTokens>
		</wcf:rest>
	</c:catch>

	<c:if test="${fromPage == 'ShoppingCart'}">
		<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
		</wcf:rest>

		<c:set var="orderId" value="${order.orderId}" />

	<c:if test="${!empty orderId}">

		<c:set var="wcPhysicalStores" value="${cookie.WC_physicalStores.value}" />
		<c:set var="wcPhysicalStoresCopy" value="${fn:replace(wcPhysicalStores, '%2C', ',')}"/>

		<c:catch var="inventoryException">
			<wcf:rest var="overallInventoryAvailablityList" url="store/{storeId}/inventoryavailability/byOrderId/{orderId}">
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				<wcf:var name="orderId" value="${orderId}" encode="true"/>
				<wcf:param name="physicalStoreId" value="${wcPhysicalStoresCopy}"/>
			</wcf:rest>
		</c:catch>
		<c:forEach var="physicalStoreIds" items="${overallInventoryAvailablityList.overallInventoryAvailability}">
			<c:set var="resultPhysicalStoreIds" value="${resultPhysicalStoreIds}${physicalStoreIds.physicalStoreId},"/>
		</c:forEach>
		<c:forEach var="physicalStoreInvStatus" items="${overallInventoryAvailablityList.overallInventoryAvailability}">
			<c:set var="resultPhysicalStoreInvStatus" value="${resultPhysicalStoreInvStatus}${physicalStoreInvStatus.overallInventoryStatus},"/>
		</c:forEach>

	</c:if>

		<c:set var="resultPhyStoreInvStatusArray" value="${fn:split(resultPhysicalStoreInvStatus, ',')}" />
		<c:set var="pickUpStoreId" value="${cookie.WC_pickUpStore.value}" />
	</c:if>
</c:if>

<wcf:url var="mStoreLocatorURL" value="m30StoreLocatorView">
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
	<wcf:param name="fromPage" value="${fromPage}" />
	<c:if test="${fromPage == 'ShoppingCart'}">
		<wcf:param name="orderId" value="${WCParam.orderId}" />
	</c:if>
</wcf:url>

<c:if test="${(fromPage == 'ShoppingCart') && (empty wcPhysicalStores || !empty physicalStoreException)}">
	<c:redirect url="${mStoreLocatorURL}"/>
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

<c:if test="${fromPage == 'ShoppingCart'}">
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
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MSTLST_TITLE">
				<fmt:param value="${storeName}" />
			</fmt:message>
		</title>

		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

		<%-- APPLEPAY BEGIN --%>
		<flow:ifEnabled feature="ApplePay">
			<link rel="apple-touch-icon" size="120x120" href="images/touch-icon-120x120.png">
			<link rel="apple-touch-icon" size="152x152" href="images/touch-icon-152x152.png">
			<link rel="apple-touch-icon" size="180x180" href="images/touch-icon-180x180.png">

			<script type="text/javascript" src="${jsIBMWidgetsAssetsPrefix}Common/javascript/ApplePay.js"></script>
		</flow:ifEnabled>
		<%-- APPLEPAY END --%>

		<%@ include file="../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left">
					<c:choose>
						<c:when test="${fromPage == 'ShoppingCart'}">
							<fmt:message bundle="${storeText}" key="MSTLST_CHECKOUT_HEADING"/>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MSTLST_HEADING"/>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<c:if test="${fromPage == 'ShoppingCart'}">
				<!-- Start Step Container -->
				<div id="step_container" class="item_wrapper" style="display:block">
					<div class="small_text left">
						<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
							<fmt:param value="2"/>
							<fmt:param value="${totalCheckoutSteps}"/>
						</fmt:message>
					</div>
					<div class="clear_float"></div>
				</div>
				<!--End Step Container -->
			</c:if>

			<!-- Start Notification Container -->
			<c:if test="${WCParam.errorView=='true'}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><fmt:message bundle="${storeText}" key="MSTLST_PICK_STORE_ERROR"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<div id="store_list">
				<c:if test="${(!empty wcPhysicalStores) && (empty physicalStoreException)}">
					<c:if test="${fromPage == 'ShoppingCart'}">
						<div id="overview_select_store" class="item_wrapper">
							<p><fmt:message bundle="${storeText}" key="MSTLST_PICK_STORE"/></p>
						</div>
					</c:if>

					<c:set var="resultStoreNum" value="${fn:length(physicalStores.PhysicalStore)}" />
					<c:forEach var="i" begin="0" end="${resultStoreNum-1}" varStatus="status">
						<div  class="item_wrapper item_wrapper_gradient">
							<c:set var="storeListIndex" value="${i}" />

							<c:url var="mStoreDetailURL" value="m30StoreDetailView">
								<c:param name="storeListIndex" value="${storeListIndex}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="productId" value="${WCParam.productId}" />

								<c:if test="${!empty WCParam.storeList}">
									<c:param name="storeList" value="${WCParam.storeList}" />
								</c:if>
								<c:if test="${!empty WCParam.fromPage}">
									<c:param name="fromPage" value="${WCParam.fromPage}" />
								</c:if>
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
							</c:url>
							<c:set var="phoneWithNoSpace" value="${fn:trim(physicalStores.PhysicalStore[i].telephone1)}" />
							<c:set var="physicalStoreId" value="${physicalStores.PhysicalStore[i].uniqueID}" />
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
								<c:param name="fromPage" value="${fromPage}" />
								<c:if test="${fromPage == 'ShoppingCart'}">
									<c:param name="orderId" value="${orderId}" />
								</c:if>
								<c:param name="refUrl" value="m30SelectedStoreListView" />
							</c:url>
							<c:choose>
								<c:when test="${fromPage == 'ShoppingCart'}">
									<form name="storeSelectionForm" id="your_store_list_cont_checkout_button" method="post" action="m30SaveStoreSelection">
										<c:set var="invStatus" value="NA" />
										<c:if test="${!empty wcPhysicalStores}">
											<c:set var="storeUniqueId" value="${physicalStores.PhysicalStore[i].uniqueID}" />
											<c:set var="k" value="0" />
											<c:forTokens items="${resultPhysicalStoreIds}" delims="," var="resultPhyStoreId">
												<c:if test="${resultPhyStoreId == storeUniqueId}">
													<c:set var="invStatus" value="${resultPhyStoreInvStatusArray[k]}" />
												</c:if>
												<c:set var="k" value="${k+1}" />
											</c:forTokens>
										</c:if>
										<fmt:message bundle="${storeText}" var="invMessage" key="INV_STATUS_${invStatus}"/>
										<fmt:message bundle="${storeText}" var="availLiClassId" key="status_${invStatus}"/>

										<ul class="store_locator numbered left">
											<li class="bold"><label for="store_list_choice_<c:out value="${i}" />"><c:out value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" /></label></li>
											<li class="padded"><p class="<c:out value="${availLiClassId}" />"><img src="${jspStoreImgDir}mobile30/images/${invStatus}.gif" width="12" height="12" alt="${invMessage}" /> <c:out value="${invMessage}" /></p></li>
										</ul>
										<div class="clear_float"></div>

										<div class="multi_button_container">
											<c:choose>
												<c:when test="${invStatus=='Available' || invStatus=='Backorderable'}">
													<%-- APPLEPAY BEGIN --%>
													<flow:ifEnabled feature="ApplePay">
														<a class="apple-pay-button left full-width" id="applePayButtonDiv_<c:out value="${i}" />" wairole="button" role="button" aria-label="<fmt:message bundle="${storeText}" key='APPLE_PAY_BUTTON'/>" onclick="javascript: mobileBOPISFlow('<c:out value="${bopisShipmodeId}" />', '<c:out value="${physicalStores.PhysicalStore[i].uniqueID}" />');" href="javascript:void(0);"></a>
													</flow:ifEnabled>
													<%-- APPLEPAY END --%>
												</c:when>
												<c:otherwise>
												</c:otherwise>
											</c:choose>
											<a id="<c:out value='store_${status.count}_remove'/>" href="${fn:escapeXml(mRemoveFromStoreList)}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key='MSTLST_REMOVE_STORE'/></div></a>
											<div class="button_spacing left"></div>

											<input type="hidden" id="storeId_sc" name="storeId" value="<c:out value="${WCParam.storeId}" escapeXml="true"/>" />
											<input type="hidden" id="langId_sc" name="langId" value="<c:out value="${WCParam.langId}" escapeXml="true"/>" />
											<input type="hidden" id="catalogId_sc" name="catalogId" value="<c:out value="${WCParam.catalogId}" escapeXml="true"/>" />
											<input type="hidden" id="fromPage_sc" name="fromPage" value="<c:out value="${fromPage}" escapeXml="true"/>" />
											<input type="hidden" id="refUrl_sc" name="refUrl" value="m30OrderBillingAddressSelection" />
											<c:choose>
												<c:when test="${invStatus=='Available' || invStatus=='Backorderable'}">
													<input type="hidden" id="store_list_choice_<c:out value="${i}" />" name="pickUpAtStoreId" value="<c:out value="${physicalStores.PhysicalStore[i].uniqueID}" />" />
													<input type="submit" id="select_store_<c:out value="${i}" />" name="select_store" value="<fmt:message bundle="${storeText}" key="MSTLST_SELECT"/>" class="primary_button button_half left" />
												</c:when>
												<c:otherwise>
												</c:otherwise>
											</c:choose>
										</div>
										<div class="clear_float"></div>
									</form>
								</c:when>
								<c:otherwise>
									<ul class="store_locator numbered left">
										<li class="bold"><c:out value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" /></li>
										<div class="item_spacer_5px"></div>
										<li><c:out value="${physicalStores.PhysicalStore[i].addressLine[0]}" /><br />
										<c:out value="${physicalStores.PhysicalStore[i].city}" />, <c:out value="${physicalStores.PhysicalStore[i].stateOrProvinceName}" /></li>
										<div class="item_spacer"></div>
										<c:set var="phoneWithCallingFormat" value="${fn:replace(phoneWithNoSpace, '.', '-')}" />
										<li><a id="store_${status.count}_phone_number" href="tel:+1-${phoneWithCallingFormat}"><c:out value="${phoneWithNoSpace}" /></a></li>
									</ul>
									<div class="clear_float"></div>
									<div class="multi_button_container">
										<a id="<c:out value='store_${status.count}_details'/>" href="${fn:escapeXml(mStoreDetailURL)}"><div class="secondary_button button_full left"><fmt:message bundle="${storeText}" key='MSTLST_VIEW_DETAILS'/></div></a>
										<%@ include file="../Snippets/StoreLocator/ViewMap.jspf" %>
										<div class="button_spacing left"></div>
										<a id="<c:out value='store_${status.count}_remove'/>" href="${fn:escapeXml(mRemoveFromStoreList)}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key='MSTLST_REMOVE_STORE'/></div></a>
										<div class="clear_float"></div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</c:forEach>
				</c:if>

				<div id="store_locator_container" class="item_wrapper">
					<div class="single_button_container">
						<p><fmt:message bundle="${storeText}" key="MSTLST_STLOC_ADD"/></p>
						<a id="store_locator" href="${fn:escapeXml(mStoreLocatorURL)}"><div class="secondary_button button_full"><fmt:message bundle="${storeText}" key='MSTLST_STLOC'/></div></a>
					</div>
					<div class="clear_float"></div>
				</div>

				<c:choose>
					<c:when test="${fromPage == 'ShoppingCart'}">
						<form name="errorForm" method="get" action="m30SelectedStoreListView">
							<input type="hidden" name="orderId" value="<c:out value="${WCParam.orderId}" escapeXml="true"/>" />
							<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" escapeXml="true"/>" />
							<input type="hidden" name="langId" value="<c:out value="${WCParam.langId}" escapeXml="true"/>" />
							<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" escapeXml="true"/>" />
							<input type="hidden" name="fromPage" value="<c:out value="${WCParam.fromPage}" escapeXml="true"/>" />
							<input type="hidden" name="errorView" value="true" />
						</form>
					</c:when>
					<c:otherwise>
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
								<form id="your_store_list_cont_shopping_button" name="your_store_list_cont_shopping_button" method="post" action="ProductDisplay">
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
									<div class="item_wrapper_button">
										<div class="single_button_container">
											<input type="submit" id="continue_shopping" name="continue_shopping" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLST_CONT_SHOPPING'/>" />
										</div>
										<div class="clear_float"></div>
									</div>
								</form>
							</c:when>
							<c:otherwise>
									<div class="item_wrapper_button">
										<div class="single_button_container">
											<input type="submit" id="continue_shopping" name="continue_shopping" class="primary_button button_full" value="<fmt:message bundle="${storeText}" key='MSTLST_CONT_SHOPPING'/>"  onclick="javascript:setPageLocation('${fn:escapeXml(env_TopCategoriesDisplayURL)}')" />
										</div>
										<div class="clear_float"></div>
									</div>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</div>

			<%@ include file="../include/FooterDisplay.jspf" %>

		</div>
	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END SelectedStoreList.jsp -->
