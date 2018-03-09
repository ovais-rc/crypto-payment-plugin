<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP file renders the dynamic recommendations from Coremetrics Intelligent
  * Offer. The callback function io_rec_zp in wczpf.js will update the context
  * WC_IntelligentOfferESpot_context_ID_<<zoneId>>. This will call the URL
  * IntelligentOfferResultsViewV2 to update the refresh area on the page.
  * The IntelligentOfferResultsViewV2 URL is associated with this JSP page. 
  * This JSP requires the following parameters to be included on the URL:
  *   partNumbers - a comma separated list of catalog entry partnumbers 
  *                 that have been returned as recommendations from Intelligent
  *                 Offer
  *   zoneId - The ID of the Intelligent Offer zone. Any whitespace in the zone
  *            name should be removed.
  *   espotTitle - The title to display above the catalog entry recommendations.
  *                This is set up in the Intelligent Offer tool.
  *   langId - the current language ID
  *   storeId - the current store ID
  *   catalogId - the current catalog ID
  *   emsName - the name of the e-Marketing in which the recommendations are displayed
  *   mpe_id - the ID of the e-Marketing in which the recommendations are displayed. 
  *            This is used for the ClickInfo url.
  *   intv_id - the ID of the web activity which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.
  *   experimentId - the ID of the experiment which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.
  *   testElementId - the ID of the test element which specified that Intelligent Offer
  *             recommendations should be displayed. This is used for the ClickInfo url.   
  *   activityName - the name of the activity which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   campaignName - the name of the campaign to which the activity belongs.
  *             This is used for Analytics reporting.
  *   experimentName - the name of the experiment which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   testElementName - the name of the test element which provided the recommendation. 
  *            This is used for Analytics reporting.
  *   controlElement - is the test element which provided the recommendation a control element. 
  *            This is used for Analytics reporting.   
  * 
  * How to use this snippet?
  * This snippet is not intended to be directly included on a store page. It
  * is associated with a refresh area that will display when recommendations
  * are returned from Intelligent Offer.
  *****
--%>

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<c:set var="currentProductCount" value="0" />
<c:set var="emsName" value="${param.emsName}"/>

<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\"','')}"/>

<c:set var="eMarketingFeedURL" value="${param.feedURL }"/>

<c:set var="widgetSuffix" value="${param.widgetSuffix }"/>

<c:set var="partNumbers" value=""/>
<c:set var="showDefaultContent" value="false"/>
<c:if test="${empty param.partNumbers}">
	<c:set var="showDefaultContent" value="true"/>
</c:if>
<c:if test="${empty param.partNumbers || (env_inPreview && !env_storePreviewLink)}" >
	
	<c:if test="${IBMProductRecommendationDatasMap != null }" >
		<c:set var="eSpotDatas" value="${IBMProductRecommendationDatasMap[emsName] }"/>
	</c:if>
	<c:if test="${empty eSpotDatas && !empty emsName}" >
	<%-- Call the REST service to get the data to display in the e-Marketing Spot --%>
	<wcf:rest var="eSpotDatasRoot" url="/store/{storeId}/espot/{name}" format="json" >
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:var name="name" value="${emsName}" encode="true"/>
		<wcf:param name="DM_EmsName" value="${emsName}" />
		<wcf:param name="DM_marketingSpotBehavior" value="${requestScope.DM_marketingSpotBehavior}"/>
		<%-- do not retrieve the catalog entry SDO but obtain the catalog entry Id only --%>
		<wcf:param name="DM_ReturnCatalogEntryId" value="true" />
		<wcf:param name="DM_ReturnDefaultContentOnly" value="${showDefaultContent}"/>
		<c:if test="${!empty param.productId}">
			<c:set var="productId" value="${param.productId}"/>
		</c:if>
           <c:if test="${!empty productId}">
			<wcf:param name="productId" value="${productId}" />
		</c:if>          					
	</wcf:rest>
	<c:if test="${!empty eSpotDatasRoot.MarketingSpotData[0]}" >
		<c:set  var="eSpotDatas" value="${eSpotDatasRoot.MarketingSpotData[0]}"/>
	</c:if>
	</c:if>
</c:if>
<c:choose>
	<c:when test="${empty param.partNumbers}">
		<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}">
			<c:if test='${(eSpotData.baseMarketingSpotDataType eq "CatalogEntryId") and (!empty eSpotData.baseMarketingSpotActivityID) and (eSpotData.baseMarketingSpotActivityID ne param.mainProductId)}'>
				<c:set var="currentProductCount" value="${currentProductCount+1}" />
				<c:choose>
					<c:when test="${empty catentryIdList}">
						<c:set var="catentryIdList" value="${eSpotData.baseMarketingSpotActivityID}"/>
					</c:when>
					<c:otherwise>
						<c:set var="catentryIdList" value="${catentryIdList},${eSpotData.baseMarketingSpotActivityID}"/>
					</c:otherwise>							
				</c:choose> 	
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<c:forTokens items="${param.partNumbers}" delims="," var="currentPartnumber" varStatus="status">
			<%-- Same product should not be displayed --%>
			<c:if test="${currentPartnumber ne param.mainPartNumber}">
				<c:set var="currentProductCount" value="${currentProductCount+1}" />
				<c:choose>
					<c:when test="${empty partNumbers}" >
						<c:set var="partNumbers" value="${currentPartnumber}" />
					</c:when>
					<c:otherwise>
						<c:set var="partNumbers" value="${partNumbers},${currentPartnumber}" />
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forTokens>
	</c:otherwise>
</c:choose>

<c:set var="espotTitle" value="${param.espotTitle}"/>
<c:if test="${empty espotTitle}">
	<wcst:message key="ES_RECOMMENDATIONS" var="espotTitle" bundle="${widgetText}"/>
</c:if>
<%@ include file="../Common/ESpot/ESpotTitle_Data.jspf"%>


<c:set var="numEntries" value="${currentProductCount}"/>

<c:set var="pageSize" value="${param.pageSize}" />

<c:set var="currentPage" value="${param.currentPage}" />
<c:if test="${empty currentPage}">
	<c:set var="currentPage" value="0" />
</c:if>

<c:if test="${currentPage < 0}">
	<c:set var="currentPage" value="0"/>
</c:if>
<c:if test="${currentPage >= (totalPages)}">
	<c:set var="currentPage" value="${totalPages-1}"/>
</c:if>

<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)+1}"/>
<c:if test="${numEntries%pageSize == 0}">
	<fmt:formatNumber var="totalPages" value="${numEntries/pageSize}"/>
	<c:if test="${totalPages == 0 && numEntries!=0}">
		<fmt:formatNumber var="totalPages" value="1"/>
	</c:if>
</c:if>
<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>

<!-- get catalogEntry -->
<c:remove var="catalogEntriesMap" />
<jsp:useBean id="catalogEntriesMap" class="java.util.HashMap" type="java.util.Map" scope="request"/>
<c:choose>
	<c:when test="${!empty partNumbers}">
		<c:catch var="searchServerException">
			<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byPartNumbers">
				<c:forTokens items="${partNumbers}" delims="," var="currentPartnumber">
					<wcf:param name="partNumber" value="${currentPartnumber}"/>
				</c:forTokens>
				<wcf:param name="langId" value="${langId}"/>
				<wcf:param name="currency" value="${env_currencyCode}"/>
				<wcf:param name="responseFormat" value="json"/>		
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<c:forEach var="contractId" items="${env_activeContractIds}">
					<wcf:param name="contractId" value="${contractId}"/>
				</c:forEach>
			</wcf:rest>
			<c:forEach items="${catalogNavigationView.catalogEntryView}" var="currentCatalogEntry" >
				<c:set var="upperCasePartNumber" value="${fn:toUpperCase(currentCatalogEntry.partNumber)}" />
				<c:if test="${empty catalogEntriesMap[upperCasePartNumber]}">
					<c:set target="${catalogEntriesMap}" property="${upperCasePartNumber}" value="${currentCatalogEntry}"/>
				</c:if>
			</c:forEach>
		</c:catch>
	</c:when>
	<c:otherwise>
		<c:if test="${not empty catentryIdList}">
			<c:catch var="searchServerException">
				<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds">
					<c:forTokens items="${catentryIdList}" delims="," var="catEntryId">
						<wcf:param name="id" value="${catEntryId}"/>
					</c:forTokens>
					<wcf:param name="langId" value="${langId}"/>
					<wcf:param name="currency" value="${env_currencyCode}"/>
					<wcf:param name="responseFormat" value="json"/>		
					<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					<c:forEach var="contractId" items="${env_activeContractIds}">
						<wcf:param name="contractId" value="${contractId}"/>
					</c:forEach>
				</wcf:rest>
				<c:forEach items="${catalogNavigationView.catalogEntryView}" var="currentCatalogEntry" >
					<c:set target="${catalogEntriesMap}" property="${currentCatalogEntry.uniqueID}" value="${currentCatalogEntry}"/>
				</c:forEach>
			</c:catch>
		</c:if>
	</c:otherwise>
</c:choose>


<c:choose>
	<c:when test="${param.pageView eq 'list'}">
		<c:set var="viewMode" value="list_mode"/>
	</c:when>
	<c:otherwise>
		<c:set var="viewMode" value="grid_mode"/>
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${param.displayPreference == '1' }" >
		<c:set var="background" value="false"/>
		<c:set var="border" value="false"/>
	</c:when>
	<c:when test="${param.displayPreference == '3' }" >
		<c:set var="background" value="true"/>
		<c:set var="border" value="true"/>
	</c:when>
	<c:otherwise>
		<c:set var="background" value="true"/>
		<c:set var="border" value="false"/>
	</c:otherwise>
</c:choose>

<c:set var="columnCountByWidth" value="${!empty param.columnCountByWidth ? param.columnCountByWidth : '{\"0\":1,\"201\":2,\"601\":3,\"801\":4}'}"/>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<c:if test="${empty catentryIdList && empty partNumbers }">
		<c:set var="eSpotHasNoSupportedDataToDisplay" value="true"/>
	</c:if>
  <jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page" />
	<c:set target="${previewWidgetProperties}" property="widgetOrientation" value="${param.widgetOrientation}" />	
	<c:if test="${param.widgetOrientation eq 'vertical'}" >
		<c:set target="${previewWidgetProperties}" property="pageSize" value="${param.pageSize}" />
	</c:if>
	<c:if test="${param.widgetOrientation eq 'horizontal' }">
			<c:set var="preference"><wcst:message key="displayPreference_${param.displayPreference}" bundle="${widgetText}" /></c:set>
			<c:set target="${previewWidgetProperties}" property="displayPreference" value="${preference}" />
	</c:if>
	<c:set target="${previewWidgetProperties}" property="showFeed" value="${param.showFeed}" />	
	
	<wcf:eMarketingSpotCache marketingSpotDataJSON="${eSpotDatas}" catalogEntryDependencyName="productId" />
	 
	<c:set var="widgetManagedByMarketing" value="true" />
	<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>
<c:choose>
	<c:when test="${param.widgetOrientation eq 'vertical'}">
		<%@include file="IBMProductRecommendation_Vertical_UI.jspf"%>
	</c:when>
	<c:otherwise>
		<%@include file="IBMProductRecommendation_Horizontal_UI.jspf"%>
	</c:otherwise>
</c:choose>

<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_End.jspf" %>
		
