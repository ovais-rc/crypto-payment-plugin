<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CatalogEntryDisplay.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%-- If param catEntryIdentifier is passed, then give preference to it, else it should be set in request scope somewhere else --%>
<c:if test = "${!empty param.catEntryIdentifier}">
	<c:set var="catEntryIdentifier" value="${param.catEntryIdentifier}"/>
</c:if>
<c:if test = "${!empty param.catEntryPartNumber}">
	<c:set var="partNumber" value="${param.catEntryPartNumber}"/>
</c:if>
<c:set var="cmcrurl" value="${param.cmcrurl}"/>

<%-- Declare map of ad ribbons for a particular catalog entry --%>
<jsp:useBean id="adRibbonMap" class="java.util.LinkedHashMap" type="java.util.Map" scope="page" />

<%@ include file="ext/CatalogEntryDisplay_Data.jspf" %>

<c:if test = "${param.custom_data ne 'true'}">
	<c:choose>
		<c:when test = "${param.pageView == 'list' or param.pageView == 'miniList'}">
			<c:set var="productId" value="${catEntryIdentifier}"/> <%-- ProductDescription_Data expects us to pass productId --%>
			<%@ include file="/Widgets_701/Common/ProductDescription/ProductDescription_Data.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="CatalogEntryDisplay_Data.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>
<div class="product">
<c:if test="${env_inPreview && !env_storePreviewLink}">
	<div class="caption" style="display:none"></div>
	<div class="ESpotInfo">
		<c:url var="clickToEditURL" value="/cmc/EditBusinessObject" context="/">
			<c:param name="toolId" value="catalogManagement"/>
			<c:param name="storeId" value="${storeId}"/>
			<c:param name="storeSelection" value="assetStore"/>
			<c:param name="languageId" value="${langId}"/>
			<c:param name="searchType" value="FindAllCatalogEntries"/>
			<c:param name="searchOption.searchText" value="${partNumber}"/>
			<c:param name="searchOption.searchUniqueId" value="${catalogEntryID}"/>
		</c:url>
		<a id="CatalogEntryDisplay_${param.pageView}_click2edit_Product_${catalogEntryID}" class="click2edit_button"  href="javascript:void(0)" onclick="parent.callManagementCenter('<wcf:out escapeFormat="js" value="${clickToEditURL}"/>');" ><wcst:message key='Click2Edit_product' bundle="${previewText}"/></a>
	</div>
</c:if>

<%@ include file="ext/CatalogEntryDisplay_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<c:when test="${param.pageView == 'list'}">
			<%@ include file="CatalogEntryDisplay_ListView_UI.jspf" %>
		</c:when>
		<c:when test="${param.pageView == 'miniList'}">
			<%@ include file="CatalogEntryDisplay_MiniListView_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="CatalogEntryDisplay_GridView_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>
</div>

<c:remove var="emptyPriceString"/>
<c:remove var="priceString"/>
<c:remove var="indexedPrice"/>
<c:remove var="listPrice"/>
<c:remove var="calculatedPrice"/>
<c:remove var="strikedPriceString"/>
<c:remove var="minimumPriceString"/>
<c:remove var="maximumPriceString"/>
<c:remove var="isDKPreConfigured"/>		
<c:remove var="isDKConfigurable"/>

<jsp:useBean id="CatalogEntry_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END CatalogEntryDisplay.jsp -->
