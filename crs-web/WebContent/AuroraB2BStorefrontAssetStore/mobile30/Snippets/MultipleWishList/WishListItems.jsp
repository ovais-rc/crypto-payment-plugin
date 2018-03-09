<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN WishListItems.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<wcf:rest var="catentry" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${param.catEntryId}" >	
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="currency" value="${env_currencyCode}"/>
			<wcf:param name="responseFormat" value="json"/>		
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
</wcf:rest>

<div id="wishlist_item_wrapper" class="item_wrapper item_wrapper_gradient">
	<div class="product_image_container">
		<c:choose>
			<c:when test="${!empty catentry.catalogEntryView[0].thumbnail}">
				<img src="<c:out value="${catentry.catalogEntryView[0].thumbnail}"/>" alt="<c:out value="${catentry.catalogEntryView[0].name}" />"/>
			</c:when>
			<c:otherwise>
				<img src="<c:out value="${hostPath}${jspStoreImgDir}" />images/NoImageIcon.jpg" alt="<fmt:message bundle="${storeText}" key="No_Image"/>"/>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="product_info_container">
		<wcf:url var="catEntryDisplayUrl" patternName="ProductURL" value="Product1">
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="productId" value="${param.catEntryId}"/>
		</wcf:url>
		<div><a id="item_display_link_${param.catEntryId}" href="${fn:escapeXml(catEntryDisplayUrl)}">${catentry.catalogEntryView[0].name}</a></div>
		<div class="small_text item_info"><c:out value="${catentry.catalogEntryView[0].partNumber}" /></div>

		<c:set var="type" value="${fn:toLowerCase(catentry.catalogEntryView[0].catalogEntryTypeCode)}" />
		<c:set var="type" value="${fn:replace(type,'bean','')}" />
		<c:set var="catalogEntry" value="${catentry.catalogEntryView[0]}" />
		<c:set var="displayPriceRange" value="false"/>
		<div class="bold item_info"><%@ include file="../ReusableObjects/CatalogEntryPriceDisplay.jspf"%></div>
	</div>

	<div class="multi_button_container">
		<wcf:url var="addToCartURL" value="RESTOrderItemAdd">
			<wcf:param name="URL" value="AjaxOrderItemDisplayView" />
			<wcf:param name="errorViewName" value="m30InterestListDisplay" />
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="productId" value="${param.catEntryId}" />
			<wcf:param name="catEntryId" value="${param.catEntryId}" />
			<wcf:param name="quantity" value="1" />
			<wcf:param name="giftListId" value="${WCParam.giftListId}" />					
			<wcf:param name="externalId" value="${WCParam.externalId}" />
		</wcf:url>
		<a id="<c:out value='add_${param.catEntryId}_to_cart'/>" href="${addToCartURL}" title="<fmt:message bundle="${storeText}" key="ADD_TO_CART"/>">
			<div class="primary_button button_half left">
				<fmt:message bundle="${storeText}" key="ADD_TO_CART"/>
			</div>
		</a>
		<div class="button_spacing left"></div>
	
		<wcf:url var="wishListItemDeleteURL" value="RestWishListRemoveItem">
			<wcf:param name="authToken" value="${authToken}"/>
			<wcf:param name="URL" value="m30InterestListDisplay" />
			<wcf:param name="errorViewName" value="m30InterestListDisplay" />
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="giftListId" value="${WCParam.giftListId}" />
			<wcf:param name="externalId" value="${WCParam.externalId}" />
			<wcf:param name="catEntryId" value="${param.catEntryId}" />
		</wcf:url>	
		<a id="<c:out value='item_${param.catEntryId}_delete'/>" href="${wishListItemDeleteURL}" title="<fmt:message bundle="${storeText}" key="WISHLIST_REMOVE"/>">
			<div class="secondary_button button_half left">
				<fmt:message bundle="${storeText}" key="WISHLIST_REMOVE"/>
			</div>
		</a>								
	</div>
	<div class="clear_float"></div>	
</div>

<!-- END WishListItems.jsp -->
