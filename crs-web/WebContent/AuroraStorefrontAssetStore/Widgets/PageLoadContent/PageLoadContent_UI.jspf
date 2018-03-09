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
<script>
	dojo.addOnLoad(function() {
	
		<%-- Main Discounts --%>
		<c:if test="${mainDiscounts and not empty param.productId}">
			wc.render.updateContext('DiscountDetailsContext', {productId:'${param.productId}', pageView:'main'});
		</c:if>
		
		<%-- Double Content Area Espot --%>
		<c:if test="${doubleContentAreaESpot}">
			CommonControllersDeclarationJS.setControllerURL('DoubleContentAreaESpot_Controller','${controllerUrlMap["doubleContentAreaESpot"]}');
			wc.render.updateContext('DoubleContentAreaESpot_Context', {'emsName': '${emsNameMap["doubleContentAreaESpot"]}'});
		</c:if>

		<%-- Home Hero Espot --%>
		<c:if test="${homeHeroESpot}">
			CommonControllersDeclarationJS.setControllerURL('HomeHeroESpot_Controller','${controllerUrlMap["homeHeroESpot"]}');
			wc.render.updateContext('HomeHeroESpot_Context', {'emsName': '${emsNameMap["homeHeroESpot"]}'});
		</c:if>
		
		<%-- Scrollable Espot --%>
		<c:if test="${scrollableESpot}">
			CommonControllersDeclarationJS.setControllerURL('ScrollableESpot_Controller','${controllerUrlMap["scrollableESpot"]}');
			wc.render.updateContext('ScrollableESpot_Context', {'emsName': '${emsNameMap["scrollableESpot"]}'});
		</c:if>
		
		<%-- Home Left Espot --%>
		<c:if test="${homeLeftESpot}">
			CommonControllersDeclarationJS.setControllerURL('HomeLeftESpot_Controller','${controllerUrlMap["homeLeftESpot"]}');
			wc.render.updateContext('HomeLeftESpot_Context', {'emsName': '${emsNameMap["homeLeftESpot"]}'});
		</c:if>
		
		<%-- Home Right Top Espot --%>
		<c:if test="${homeRightTopESpot}">
			CommonControllersDeclarationJS.setControllerURL('HomeRightTopESpot_Controller','${controllerUrlMap["homeRightTopESpot"]}');
			wc.render.updateContext('HomeRightTopESpot_Context', {'emsName': '${emsNameMap["homeRightTopESpot"]}'});
		</c:if>
		
		<%-- Home Right Bottom Espot --%>
		<c:if test="${homeRightBottomESpot}">
			CommonControllersDeclarationJS.setControllerURL('HomeRightBottomESpot_Controller','${controllerUrlMap["homeRightBottomESpot"]}');
			wc.render.updateContext('HomeRightBottomESpot_Context', {'emsName': '${emsNameMap["homeRightBottomESpot"]}'});
		</c:if>
		
		<%-- Tall Double Content Area ESpot --%>
		<c:if test="${tallDoubleContentAreaESpot}">
			CommonControllersDeclarationJS.setControllerURL('TallDoubleContentAreaESpot_Controller','${controllerUrlMap["tallDoubleContentAreaESpot"]}');
			wc.render.updateContext('TallDoubleContentAreaESpot_Context', {'emsName': '${emsNameMap["tallDoubleContentAreaESpot"]}'});
		</c:if>
		
		<%-- Top Category Hero ESpot --%>
		<c:if test="${topCategoryHeroESpot}">
			CommonControllersDeclarationJS.setControllerURL('TopCategoryHeroESpot_Controller','${controllerUrlMap["topCategoryHeroESpot"]}');
			wc.render.updateContext('TopCategoryHeroESpot_Context', {'emsName': '${emsNameMap["topCategoryHeroESpot"]}'});
		</c:if>
		
		<%-- Top Category Tall Double ESpot --%>
		<c:if test="${topCategoryTallDoubleESpot}">
			CommonControllersDeclarationJS.setControllerURL('TopCategoryTallDoubleESpot_Controller','${controllerUrlMap["topCategoryTallDoubleESpot"]}');
			wc.render.updateContext('TopCategoryTallDoubleESpot_Context', {'emsName': '${emsNameMap["topCategoryTallDoubleESpot"]}'});
		</c:if>
		
		<%-- Top Categories Espot --%>
		<c:if test="${topCategoriesESpot}">
			CommonControllersDeclarationJS.setControllerURL('TopCategoriesESpot_Controller','${controllerUrlMap["topCategoriesESpot"]}');
			wc.render.updateContext('TopCategoriesESpot_Context', {'emsName': '${emsNameMap["topCategoriesESpot"]}'});
		</c:if>
		
		<%-- Featured Products in Category Espot --%>
		<c:if test="${categoryFeaturedProductsESpot}">
			CommonControllersDeclarationJS.setControllerURL('CategoryFeaturedProductsESpot_Controller','${controllerUrlMap["categoryFeaturedProductsESpot"]}');
			wc.render.updateContext('CategoryFeaturedProductsESpot_Context', {'emsName': '${emsNameMap["categoryFeaturedProductsESpot"]}'});
		</c:if>
		
		<%-- Best Selling Products Espot --%>
		<c:if test="${bestSellingProductsESpot}">
			CommonControllersDeclarationJS.setControllerURL('BestSeller_Controller','${controllerUrlMap["bestSellingProductsESpot"]}');
			wc.render.updateContext('BestSeller_Context', {'emsName': '${emsNameMap["bestSellingProductsESpot"]}'});
		</c:if>
		
		<%-- Top Browsed Products Espot --%>
		<c:if test="${topBrowsedProductsESpot}">
			CommonControllersDeclarationJS.setControllerURL('ProductRanking_Controller','${controllerUrlMap["topBrowsedProductsESpot"]}');
			wc.render.updateContext('ProductRanking_Context', {'emsName': '${emsNameMap["topBrowsedProductsESpot"]}'});
		</c:if>
		
		<%-- Side Bar Product Recommendations --%>
		<c:if test="${sideBarProductRecommendations}">
			CommonControllersDeclarationJS.setControllerURL('ProductRecommendations_Controller','${controllerUrlMap["sideBarProductRecommendations"]}');
			wc.render.updateContext('ProductRecommendations_Context', {'emsName': '${emsNameMap["sideBarProductRecommendations"]}'});
		</c:if>
		
		<%-- Side Bar Product Recommendations --%>
		<c:if test="${sideBarBrowsingHistory}">
			CommonControllersDeclarationJS.setControllerURL('ProductBrowsingHistory_Controller','${controllerUrlMap["sideBarBrowsingHistory"]}');
			wc.render.updateContext('ProductBrowsingHistory_Context', {'emsName': '${emsNameMap["sideBarBrowsingHistory"]}'});
		</c:if>
		
	});
</script>
