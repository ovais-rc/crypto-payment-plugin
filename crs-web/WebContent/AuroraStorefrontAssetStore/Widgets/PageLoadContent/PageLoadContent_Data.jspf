<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<jsp:useBean id="emsNameMap" class="java.util.HashMap" type="java.util.Map"/>
<jsp:useBean id="controllerUrlMap" class="java.util.HashMap" type="java.util.Map"/>

<c:set var="mainDiscounts" value="false"/>
<c:if test="${not empty param.mainDiscounts}">
	<c:set var="mainDiscounts" value="${param.mainDiscounts}"/>
</c:if>

<%-- Double Content Area Espot --%>
<c:set var="doubleContentAreaESpot" value="false"/>
<c:if test="${not empty param.doubleContentAreaESpot}">
	<c:set var="doubleContentAreaESpot" value="${param.doubleContentAreaESpot}"/>
	
	<%-- configure ems name for double content area espot --%>
	<c:set target="${emsNameMap}" property="doubleContentAreaESpot" value="HeaderESpot"/>
	
	<%-- Double Content Area Espot Url --%>
	<wcf:url var="DoubleContentAreaESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="doubleContentAreaESpot" value="${DoubleContentAreaESpotURL}"/>
</c:if>

<%-- Home Hero Espot --%>
<c:set var="homeHeroESpot" value="false"/>
<c:if test="${not empty param.homeHeroESpot}">
	<c:set var="homeHeroESpot" value="${param.homeHeroESpot}"/>
	
	<%-- configure ems name for home hero espot --%>
	<c:set target="${emsNameMap}" property="homeHeroESpot" value="HomePageMainAd"/>
	
	<%-- Home Hero Espot Url --%>
	<wcf:url var="HomeHeroESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="1" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="homeHeroESpot" value="${HomeHeroESpotURL}"/>
</c:if>

<%-- Scrollable Espot --%>
<c:set var="scrollableESpot" value="false"/>
<c:if test="${not empty param.scrollableESpot}">
	<c:set var="scrollableESpot" value="${param.scrollableESpot}"/>
	
	<%-- configure ems name for scrollable espot --%>
	<c:set target="${emsNameMap}" property="scrollableESpot" value="HomePageFeaturedProducts"/>
	
	<%-- Scrollable Espot Url --%>
	<wcf:url var="ScrollableESpotURL" value="ScrollableESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="pageView" value="miniGrid"/>
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="scrollableESpot" value="${ScrollableESpotURL}"/>
</c:if>

<%-- Home Left Espot --%>
<c:set var="homeLeftESpot" value="false"/>
<c:if test="${not empty param.homeLeftESpot}">
	<c:set var="homeLeftESpot" value="${param.homeLeftESpot}"/>
	
	<%-- configure ems name for home left espot --%>
	<c:set target="${emsNameMap}" property="homeLeftESpot" value="HomePageLeftAds"/>
	
	<%-- Home Left Espot Url --%>
	<wcf:url var="HomeLeftESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="homeLeftESpot" value="${HomeLeftESpotURL}"/>
</c:if>

<%-- Home Right Top Espot --%>
<c:set var="homeRightTopESpot" value="false"/>
<c:if test="${not empty param.homeRightTopESpot}">
	<c:set var="homeRightTopESpot" value="${param.homeRightTopESpot}"/>
	
	<%-- configure ems name for home right top espot --%>
	<c:set target="${emsNameMap}" property="homeRightTopESpot" value="HomePageRightAds1"/>
	
	<%-- Home Right Top Espot Url --%>
	<wcf:url var="HomeRightTopESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="1" />
		<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="homeRightTopESpot" value="${HomeRightTopESpotURL}"/>
</c:if>

<%-- Home Right Bottom Espot --%>
<c:set var="homeRightBottomESpot" value="false"/>
<c:if test="${not empty param.homeRightBottomESpot}">
	<c:set var="homeRightBottomESpot" value="${param.homeRightBottomESpot}"/>
	
	<%-- configure ems name for home right bottom espot --%>
	<c:set target="${emsNameMap}" property="homeRightBottomESpot" value="HomePageRightAds2"/>
	
	<%-- Home Right Bottom Espot Url --%>
	<wcf:url var="HomeRightBottomESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="1" />
		<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="homeRightBottomESpot" value="${HomeRightBottomESpotURL}"/>
</c:if>

<%-- Tall Double Content Area ESpot --%>
<c:set var="tallDoubleContentAreaESpot" value="false"/>
<c:if test="${not empty param.tallDoubleContentAreaESpot}">
	<c:set var="tallDoubleContentAreaESpot" value="${param.tallDoubleContentAreaESpot}"/>
	
	<%-- configure ems name for tall double content area espot --%>
	<c:set target="${emsNameMap}" property="tallDoubleContentAreaESpot" value="DressPageAds"/>
	
	<%-- Tall Double Content Area ESpot Url --%>
	<wcf:url var="TallDoubleContentAreaESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="tallDoubleContentAreaESpot" value="${TallDoubleContentAreaESpotURL}"/>
</c:if>

<%-- Top Category Hero ESpot --%>
<c:set var="topCategoryHeroESpot" value="false"/>
<c:if test="${not empty param.topCategoryHeroESpot}">
	<c:set var="topCategoryHeroESpot" value="${param.topCategoryHeroESpot}"/>
	
	<%-- configure ems name for top category hero espot --%>
	<c:set target="${emsNameMap}" property="topCategoryHeroESpot" value="${param.departmentName}PageMainAd"/>
	
	<%-- Top Category Hero ESpot Url --%>
	<wcf:url var="TopCategoryHeroESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="topCategoryHeroESpot" value="${TopCategoryHeroESpotURL}"/>
</c:if>

<%-- Top Category Tall Double ESpot --%>
<c:set var="topCategoryTallDoubleESpot" value="false"/>
<c:if test="${not empty param.topCategoryTallDoubleESpot}">
	<c:set var="topCategoryTallDoubleESpot" value="${param.topCategoryTallDoubleESpot}"/>
	
	<%-- configure ems name for top category tall double espot --%>
	<c:set target="${emsNameMap}" property="topCategoryTallDoubleESpot" value="${param.departmentName}PageAds"/>
	
	<%-- Top Category Tall Double ESpot Url --%>
	<wcf:url var="TopCategoryTallDoubleESpotURL" value="ContentAreaESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberContentPerRow" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="topCategoryTallDoubleESpot" value="${TopCategoryTallDoubleESpotURL}"/>
</c:if>

<%-- Top Categories Espot --%>
<c:set var="topCategoriesESpot" value="false"/>
<c:if test="${not empty param.topCategoriesESpot}">
	<c:set var="topCategoriesESpot" value="${param.topCategoriesESpot}"/>
	
	<%-- configure ems name for top categories espot --%>
	<c:set target="${emsNameMap}" property="topCategoriesESpot" value="WomencategoryRecommendationsforStores"/>
	
	<%-- Top Categories Espot Url --%>
	<wcf:url var="TopCategoriesESpotURL" value="CategoriesESpotView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="numberCategoriesPerRow" value="4" />
		<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="topCategoriesESpot" value="${TopCategoriesESpotURL}"/>
</c:if>

<%-- Featured Products in Category ESpot --%>
<c:set var="categoryFeaturedProductsESpot" value="false"/>
<c:if test="${not empty param.categoryFeaturedProductsESpot}">
	<c:set var="categoryFeaturedProductsESpot" value="${param.categoryFeaturedProductsESpot}"/>
	
	<%-- configure ems name for Featured Products in Category ESpot --%>
	<c:set target="${emsNameMap}" property="categoryFeaturedProductsESpot" value="DressProductRecommendationpage"/>
	
	<%-- Featured Products in Category ESpot Url --%>
	<wcf:url var="CategoryFeaturedProductsESpotURL" value="ProductRecommendationsCenterView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="pageSize" value="4" />
		<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
		<wcf:param name="pageView" value="miniGrid"/>
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="categoryFeaturedProductsESpot" value="${CategoryFeaturedProductsESpotURL}"/>
</c:if>

<%-- Best Selling Products Espot --%>
<c:set var="bestSellingProductsESpot" value="false"/>
<c:if test="${not empty param.bestSellingProductsESpot}">
	<c:set var="bestSellingProductsESpot" value="${param.bestSellingProductsESpot}"/>
	
	<%-- configure ems name for best selling products espot --%>
	<c:set target="${emsNameMap}" property="bestSellingProductsESpot" value="BestSellingProducts"/>
	
	<%-- Best Selling Products Espot Url --%>
	<wcf:url var="BestSellingProductsESpotURL" value="BestSellerView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="pageView" value="grid"/>
		<wcf:param name="pageSize" value="4"/>
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="bestSellingProductsESpot" value="${BestSellingProductsESpotURL}"/>
</c:if>

<%-- Top Browsed Products Espot --%>
<c:set var="topBrowsedProductsESpot" value="false"/>
<c:if test="${not empty param.topBrowsedProductsESpot}">
	<c:set var="topBrowsedProductsESpot" value="${param.topBrowsedProductsESpot}"/>
	
	<%-- configure ems name for top browsed products espot --%>
	<c:set target="${emsNameMap}" property="topBrowsedProductsESpot" value="TopBrowsedProducts"/>
	
	<%-- Top Browsed Products Espot Url --%>
	<wcf:url var="TopBrowsedProductsESpotURL" value="ProductRankingView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="pageView" value="grid"/>
		<wcf:param name="pageSize" value="4"/>
		<wcf:param name="showFeed" value="true"/>
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="topBrowsedProductsESpot" value="${TopBrowsedProductsESpotURL}"/>
</c:if>

<%-- Side bar product recommendations --%>
<c:set var="sideBarProductRecommendations" value="false"/>
<c:if test="${not empty param.sideBarProductRecommendations}">
	<c:set var="sideBarProductRecommendations" value="${param.sideBarProductRecommendations}"/>
	
	<%-- configure ems name for side bar product recommendations content area espot --%>
	<c:set target="${emsNameMap}" property="sideBarProductRecommendations" value="RightSideBarFeaturedProducts"/>
	
	<%-- Side bar product recommendations Url --%>
	<wcf:url var="SideBarProductRecommendationsURL" value="ProductRecommendationsSidebarView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}" />
		<wcf:param name="catalogId" value="${catalogId}" />
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="currentPage" value="0"/>
		<wcf:param name="pageView" value="sidebar" />
		<wcf:param name="pageSize" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="sideBarProductRecommendations" value="${SideBarProductRecommendationsURL}"/>
</c:if>

<%-- Side bar browsing history --%>
<c:set var="sideBarBrowsingHistory" value="false"/>
<c:if test="${not empty param.sideBarBrowsingHistory}">
	<c:set var="sideBarBrowsingHistory" value="${param.sideBarBrowsingHistory}"/>
	
	<%-- configure ems name for side bar browsing history content area espot --%>
	<c:set target="${emsNameMap}" property="sideBarBrowsingHistory" value="BrowsingHistory"/>
	
	<%-- Side bar browsing history Url --%>
	<wcf:url var="SideBarBrowsingHistoryURL" value="ProductBrowsingHistoryView" type="Ajax">
		<wcf:param name="storeId" value="${storeId}" />
		<wcf:param name="catalogId" value="${catalogId}" />
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="currentPage" value="0"/>
		<wcf:param name="pageView" value="sidebar" />
		<wcf:param name="pageSize" value="2" />
	</wcf:url>
	<c:set target="${controllerUrlMap}" property="sideBarBrowsingHistory" value="${SideBarBrowsingHistoryURL}"/>
</c:if>

