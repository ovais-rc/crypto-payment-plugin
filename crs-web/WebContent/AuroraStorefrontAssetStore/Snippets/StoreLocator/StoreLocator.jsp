<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays the store locator content.
  * 
	* Parameters
	*
	* -fromUrl (optional)
	* If provided, clicking the Continue Shopping button will redirect back to the url specified
	*
	* -fromPage (optional)
	* It can be one of these options: "ProductDetails", "StoreLocator", or "ShoppingCart". If coming from the product details
	* page this page shows a short summary of the product at the top of the page. If coming from the shopping cart page then
	* the page will show the inventory information in the physical store list section. Otherwise, fromPage defaults to "StoreLocator"
	* and it will just show a default store locator page with search results and physical store list management.
	* 
	* -productId (optional)
	* The product id for the product that the shopper is checking inventory for.
	* 
	* -type (optional)
	* The type of product that the shopper is checking inventory for. This type parameter maybe "item", "product", "package" or "bundle".
  *****
--%>

<!-- BEGIN StoreLocator.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="fromPage" value="StoreLocator" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${fn:escapeXml(WCParam.fromPage)}" />
</c:if>
<c:if test="${!empty param.fromPage}">
	<c:set var="fromPage" value="${fn:escapeXml(param.fromPage)}" />
</c:if>

<c:if test="${!empty WCParam.fromUrl}">
	<c:set var="fromUrl" value="${WCParam.fromUrl}" />
</c:if>
<c:if test="${!empty param.fromUrl}">
	<c:set var="fromUrl" value="${param.fromUrl}" />
</c:if>

<wcf:url var="AjaxProvinceSelectionDisplayURL" value="AjaxProvinceSelectionDisplayView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="AjaxCitySelectionDisplayURL" value="AjaxCitySelectionDisplayView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="langId" value="${langId}" />						
</wcf:url>
<wcf:url var="AjaxStoreLocatorResultsURL" value="AjaxStoreLocatorResultsView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="orderId" value="${param.orderId}" />
	<wcf:param name="langId" value="${langId}" />						
</wcf:url>
<wcf:url var="AjaxSelectedStoreListURL" value="AjaxSelectedStoreListView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="orderId" value="${param.orderId}" />
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="fromPage" value="${fromPage}" />
</wcf:url>

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

<c:catch var="topGeoNodeException">
	<wcf:rest var="topGeoNodes" url="store/{storeId}/geonode/byTopGeoNode">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="siteLevelSearch" value="false"/>
	</wcf:rest>
</c:catch>

<script type="text/javascript">
	StoreLocatorControllersDeclarationJSStore.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','<c:out value="${WCParam.orderId}"/>','<c:out value="${WCParam.fromPage}"/>');
	StoreLocatorContextsJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','<c:out value="${WCParam.orderId}"/>','<c:out value="${WCParam.fromPage}"/>');
	
	<fmt:message bundle="${storeText}" key='MISSING_CITY' var="MISSING_CITY"/>
	<fmt:message bundle="${storeText}" key='EXCEED_PHYSICAL_STORE_SIZE' var="EXCEED_PHYSICAL_STORE_SIZE"/>
	
	MessageHelper.setMessage("MISSING_CITY", <wcf:json object="${MISSING_CITY}"/>);
	MessageHelper.setMessage("EXCEED_PHYSICAL_STORE_SIZE", <wcf:json object="${EXCEED_PHYSICAL_STORE_SIZE}"/>);

	$(document).ready(storeLocatorJSStore.initProvinceSelections);
</script>


<c:choose>
	<c:when test="${fromPage == 'ProductDetails'}">
		<c:set var="productId" value="" />
		<c:set var="catalogEntry" value="" />
		<c:if test="${!empty WCParam.productId}">
			<c:set var="productId" value="${WCParam.productId}" />
		</c:if>
		<c:if test="${!empty param.productId}">
			<c:set var="productId" value="${param.productId}" />
		</c:if>
		
		<c:if test="${!empty productId}">
			<c:catch var="searchServerException">
				<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${productId}" >	
					<wcf:param name="langId" value="${langId}"/>
					<wcf:param name="currency" value="${env_currencyCode}"/>
					<wcf:param name="responseFormat" value="json"/>		
					<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					<c:forEach var="contractId" items="${env_activeContractIds}">
						<wcf:param name="contractId" value="${contractId}"/>
					</c:forEach>
				</wcf:rest>
			</c:catch>
			<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
				<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}"/>
				<c:set var="typeCode" value="${catalogEntry.catalogEntryTypeCode}" />
			</c:if>
		</c:if>

		<div id="check_product_availability_container" class="contentgrad_header">
			<div id="WC_StoreLocator_div_1" class="left_corner"></div>
			<div id="WC_StoreLocator_div_2" class="left"><span class="contentgrad_text"><fmt:message bundle="${storeText}" key="STORELOCATOR_TITLE2" /></span></div>
			<div id="WC_StoreLocator_div_3" class="right_corner"></div>
		</div>
	</c:when>
</c:choose>
		
<div id="gift_registry_box">

<c:if test="${fromPage == 'ProductDetails'}">
	<c:if test="${!empty catalogEntry}">
		<div id="check_product_availability">
			<c:choose>
				<c:when test="${(fn:startsWith(catalogEntry.thumbnail, 'http://') || fn:startsWith(catalogEntry.thumbnail, 'https://'))}">
					<wcst:resolveContentURL var="thumbNail" url="${catalogEntry.thumbnail}"/>
				</c:when>
				<c:when test="${fn:startsWith(catalogEntry.thumbnail, '/store/0/storeAsset')}">
					<c:set var="thumbNail" value="${storeContextPath}${catalogEntry.thumbnail}" />
				</c:when>
				<c:otherwise>
					<c:set var="thumbNail" value="${catalogEntry.thumbnail}" />
				</c:otherwise>
			</c:choose>
			<img src="${thumbNail}" alt="${catalogEntry.shortDescription}"/>
			<c:if test="${typeCode == 'ItemBean'}">
				<div id="WC_StoreLocator_div_7" class="product_options">
					<h1><a id="WC_StoreLocator_links_1" href='<c:out value="${ProductDisplayURL}"/>'><c:out value="${catalogEntry.name}" escapeXml="false" /></a></h1>
			</c:if>
			<c:if test="${typeCode == 'ProductBean'}">
				<div id="WC_StoreLocator_div_8" class="product_options">
					<h1><a id="WC_StoreLocator_links_2" href='<c:out value="${ProductDisplayURL}"/>'><c:out value="${catalogEntry.name}" escapeXml="false" /></a></h1>
			</c:if>
			<c:if test="${typeCode == 'PackageBean' || typeCode == 'DynamicKitBean'}">
				<div id="WC_StoreLocator_div_9" class="product_options">
					<h1><a id="WC_StoreLocator_links_3" href='<c:out value="${ProductDisplayURL}"/>'><c:out value="${catalogEntry.name}" escapeXml="false" /></a></h1>
			</c:if>
			<c:if test="${typeCode == 'BundleBean'}">
				<div id="WC_StoreLocator_div_10" class="product_options">
					<h1><a id="WC_StoreLocator_links_4" href='<c:out value="${ProductDisplayURL}"/>'><span class="bopis_link"><c:out value="${catalogEntry.name}" escapeXml="false" /></a></h1>
			</c:if>
			<div id="WC_StoreLocator_div_11" class="font3"><fmt:message bundle="${storeText}" key="PRICE_LABEL" /><%@ include file="../ReusableObjects/CatalogEntryPriceDisplay.jspf" %></div>
			</div>
		</div>
    	<br clear="all" />
	</c:if>
</c:if>

<c:choose>
	<c:when test="${fromPage != 'ShoppingCart'}">	
		<div class="store_locator_title"><span aria-level="1" role="heading"><fmt:message bundle="${storeText}" key="STORELOCATOR_TITLE1"/></span></div>
		<div class="gift_header"><span aria-level="2" role="heading"><fmt:message bundle="${storeText}" key="STORE_LIST_TITLE"/></span>
			<div id="hideStoreListHeader" class="checkout_show_icon" style="display:block">
				<div id="WC_StoreLocator_div_14" class="hide"><a role="button" class="tlignore" id="WC_StoreLocator_links_5" href="Javascript:storeLocatorJSStore.hideStoreList();"><fmt:message bundle="${storeText}" key="STORE_LIST_HIDE" /> <img src="<c:out value='${jspStoreImgDir}images/'/>collapse_icon.gif" border="0" alt=""/></a></div>
			</div>
			<div id="showStoreListHeader" class="checkout_show_icon" style="display:none">
				<div id="WC_StoreLocator_div_18" class="hide"><a role="button" class="tlignore" id="WC_StoreLocator_links_6" href="Javascript:storeLocatorJSStore.showStoreList();"><fmt:message bundle="${storeText}" key="STORE_LIST_SHOW" /> <img src="<c:out value='${jspStoreImgDir}images/'/>expand_icon.gif" border="0" alt=""/></a></div>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div class="gift_header"><span aria-level="1" role="heading"><fmt:message bundle="${storeText}" key="STORE_LIST_TITLE"/></span>
			<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
			<div id="hideStoreListHeader" class="checkout_show_icon checkout_top_location" style="display:block">
				<div id="WC_StoreLocator_div_14" class="hide"><a role="button" class="tlignore" id="WC_StoreLocator_links_5" href="Javascript:storeLocatorJSStore.hideStoreList();"><fmt:message bundle="${storeText}" key="STORE_LIST_HIDE" /> <img src="<c:out value='${jspStoreImgDir}images/'/>collapse_icon.gif" border="0" alt=""/></a></div>
			</div>
			<div id="showStoreListHeader" class="checkout_show_icon checkout_top_location" style="display:none">
				<div id="WC_StoreLocator_div_18" class="hide"><a role="button" class="tlignore" id="WC_StoreLocator_links_6" href="Javascript:storeLocatorJSStore.showStoreList();"><fmt:message bundle="${storeText}" key="STORE_LIST_SHOW" /> <img src="<c:out value='${jspStoreImgDir}images/'/>expand_icon.gif" border="0" alt=""/></a></div>
			</div>
		</div>
	</c:otherwise>
</c:choose>

<!-- your store list -->
<span id="selectedStoreList_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Your_Store_List"/></span>
<div wcType="RefreshArea" id="selectedStoreList" refreshurl="<c:out value='${AjaxSelectedStoreListURL}'/>" declareFunction="StoreLocatorControllersDeclarationJSStore.selectedStoreListRefreshController()" style="display:block;" ariaMessage="<fmt:message bundle='${storeText}' key='ACCE_Status_Your_Store_List_Updated'/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="selectedStoreList_ACCE_Label">
	<% out.flush(); %>
	<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/SelectedStoreList.jsp">
		<c:param name="storeId" value="${param.storeId}" />
		<c:param name="catalogId" value="${param.catalogId}" />
		<c:param name="langId" value="${langId}" />
	</c:import>	
	<% out.flush(); %>
</div>

<!-- your store list -->

<!-- store locator -->
<c:choose>
	<c:when test="${fromPage != 'ShoppingCart'}">	
		<h2 class="gift_header"><fmt:message bundle="${storeText}" key="STORELOCATOR_TITLE1"/></h2>
	</c:when>
	<c:otherwise>
		<h1 class="gift_header"><fmt:message bundle="${storeText}" key="STORELOCATOR_TITLE1"/></h1>
	</c:otherwise>
</c:choose>

<div class="gift_content">
	<a href="#" role="button" class="button_primary" id="findNearest" onclick="javascript:GeolocationJS.launch();">
		<div class="left_border"></div>
		<div class="button_text"><fmt:message bundle="${storeText}" key="MSTLOC_FIND_NEAREST" /></div>
		<div class="right_border"></div>
	</a>
</div>
<div class="gift_content">
	<span class="instruction"><fmt:message bundle="${storeText}" key="SELECT_ENTER_OPTIONS"/></span>
	
	<div id="location">
		<c:set var="formName" value="searchByGeoNodeForm" />
		<form id='<c:out value="${formName}" />' name='<c:out value="${formName}" />'>

			<div id="WC_StoreLocator_div_29" class="location_select">
				<div id="WC_StoreLocator_div_30" class="location_select_label"><label for="selectCountry"><fmt:message bundle="${storeText}" key="SELECT_COUNTRY" /></label></div>
				<div id="WC_StoreLocator_div_31" class="location_select_form">
					<select name="selectCountry" id="selectCountry" title="<fmt:message bundle="${storeText}" key='ACCE_COUNTRY_CHANGE'/>" class="drop_down_country" onchange="JavaScript:storeLocatorJSStore.changeCountrySelection(this.options[this.selectedIndex].value);">
						<c:if test="${empty topGeoNodeException}">
							<c:set var="resultNum" value="${fn:length(topGeoNodes.GeoNode)}" />
							<c:if test="${resultNum > 0}">
								<c:forEach var="i" begin="0" end="${resultNum-1}">
									<option value='<c:out value="${topGeoNodes.GeoNode[i].uniqueID}" />'><c:out value="${topGeoNodes.GeoNode[i].Description[0].shortDescription}" /></option>
								</c:forEach>
							</c:if>
							<c:if test="${resultNum == 0 && !empty topGeoNodes.uniqueID}">
						    	<option value='<c:out value="${topGeoNodes.uniqueID}" />'><c:out value="${topGeoNodes.Description[0].shortDescription}" /></option>
						    </c:if>
						</c:if>
					</select>
				</div>
			</div>
			<div id="WC_StoreLocator_div_32" class="location_select">
				<div id="WC_StoreLocator_div_33" class="location_select_label"><label for="selectState"><fmt:message bundle="${storeText}" key="SELECT_STATEPROVINCE" /></label></div>
				<div id="WC_StoreLocator_div_34" class="location_select_form">
					<div wcType="RefreshArea" id="provinceSelections" refreshurl="<c:out value="${AjaxProvinceSelectionDisplayURL}"/>" declareFunction="StoreLocatorControllersDeclarationJSStore.provinceSelectionsRefreshArea()">
						<% out.flush(); %>
						<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/ProvinceSelectionDisplay.jsp">
							<c:param name="storeId" value="${param.storeId}" />
							<c:param name="catalogId" value="${param.catalogId}" />
							<c:param name="langId" value="${langId}" />
						</c:import>	
						<% out.flush(); %>
					</div>						
				</div>
			</div>
			<div id="WC_StoreLocator_div_35" class="location_select">
				<div id="WC_StoreLocator_div_36" class="location_select_label"><label for="selectCity"><fmt:message bundle="${storeText}" key="SELECT_CITY" /></label></div>
				<div id="WC_StoreLocator_div_37" class="location_select_form">
					<div wcType="RefreshArea" id="citySelections" refreshurl="<c:out value="${AjaxCitySelectionDisplayURL}"/>" declareFunction="StoreLocatorControllersDeclarationJSStore.citySelectionsRefreshController()">
						<% out.flush(); %>
						<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/CitySelectionDisplay.jsp">
							<c:param name="storeId" value="${param.storeId}" />
							<c:param name="catalogId" value="${param.catalogId}" />
							<c:param name="langId" value="${langId}" />
						</c:import>	
						<% out.flush(); %>
					</div>

				</div>
			</div>
			<div id="WC_StoreLocator_div_38" class="location_select">
				<div id="WC_StoreLocator_div_39" class="location_select_button">
					<a href="#" role="button" class="button_primary" id="cityGo" onclick="Javascript:setCurrentId('cityGo'); storeLocatorJSStore.refreshResultsFromCity(document.${formName}, '<c:out value='${fromPage}'/>');">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message bundle="${storeText}" key="GO_BUTTON_LABEL" /></div>
						<div class="right_border"></div>
					</a>
				</div>
			</div>
			<%@ include file="StoreLocator_body_ext.jspf"%>
		</form>
		<br clear="all"/>
	</div>
</div>

<span id="storeLocatorResults_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Store_Result_List"/></span>
<div wcType="RefreshArea" id="storeLocatorResults" refreshurl="<c:out value='${AjaxStoreLocatorResultsURL}'/>" ariaMessage="<fmt:message bundle='${storeText}' key='ACCE_Status_Store_Result_List_Updated'/>" ariaLiveId="${ariaMessageNode}" declareFunction="StoreLocatorControllersDeclarationJSStore.storeLocatorResultsRefreshController" role="region" aria-labelledby="storeLocatorResults_ACCE_Label">
	<% out.flush(); %>
	<c:import url="/${sdb.jspStoreDir}/Snippets/StoreLocator/StoreLocatorResults.jsp">
		<c:param name="storeId" value="${param.storeId}" />
		<c:param name="catalogId" value="${param.catalogId}" />
		<c:param name="langId" value="${langId}" />
	</c:import>	
	<% out.flush(); %>
</div>
	
<c:choose>
	<c:when test="${!empty fromUrl}">
		<div class="button_footer_line no_float">
			<a href="#" role="button" class="button_primary" id="continueShoppingStoreLocator" onclick="javascript:setPageLocation('<c:out value="${fromUrl}"/>')">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="CONTINUE_SHOPPING" /></div>
				<div class="right_border"></div>
			</a>
		</div>
	</c:when>
	<c:when test="${fromPage == 'ProductDetails' or fromPage == 'InventoryStatus'}">
		<div class="button_footer_line no_float">
			<a href="#" role="button" class="button_primary" id="continueShoppingStoreLocator" onclick="javascript:setPageLocation('<c:out value="${ProductDisplayURL}"/>')">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="CONTINUE_SHOPPING" /></div>
				<div class="right_border"></div>
			</a>
		</div>
	</c:when>
	<c:when test="${fromPage == 'StoreLocator'}">
		<div class="button_footer_line no_float">
			<a href="#" role="button" class="button_primary" id="continueShoppingStoreLocator" onclick="javascript:setPageLocation('<c:out value="${env_TopCategoriesDisplayURL}"/>')">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="CONTINUE_SHOPPING" /></div>
				<div class="right_border"></div>
			</a>
		</div>
	</c:when>
</c:choose>

<!-- END StoreLocator.jsp -->
