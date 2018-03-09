<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>



<!-- BEGIN CatalogEntryRecommendation.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		shoppingActionsJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
		shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
	});
	//Declare refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos	
	wc.render.declareRefreshController({
		id: "prodRecommendationRefresh_controller_<c:out value="${param.emsName}" />",
		renderContext: wc.render.getContextById("searchBasedNavigation_context"),
		url: "",
		formId: ""
	
		,renderContextChangedHandler: function(message, widget) {
			var controller = this;
			var renderContext = this.renderContext;
			var resultType = renderContext.properties["resultType"];
			if(resultType == "products" || resultType == "both"){
				widget.refresh(renderContext.properties);
				console.log("espot refreshing");
			}
		}
			
		/**
		 * Clears the progress bar after a successful refresh.
		 *
		 * @param {Object} widget The refresh area widget.
		 */
		,postRefreshHandler: function(widget) {
			var controller = this;
			var renderContext = this.renderContext;
			cursor_clear();
			
			var refreshUrl = controller.url;
			var emsName = "";
			var indexOfEMSName = refreshUrl.indexOf("emsName=", 0);
			if(indexOfEMSName >= 0){
				emsName = refreshUrl.substring(indexOfEMSName+8);
				if (emsName.indexOf("&") >= 0) {
					emsName = emsName.substring(0, emsName.indexOf("&"));
					emsName = "script_" + emsName;
				}
			}
				
			if (emsName != "") {
				if (dojo.byId(emsName) != null) {
					var espot = dojo.query('.genericESpot',dojo.byId(emsName).parentNode)[0];
					if (espot != null) {
						dojo.addClass(espot,'emptyESpot');
					}
				}
			}
			dojo.publish("CMPageRefreshEvent");
		}
	});
</script>

<%@ include file="ext/CatalogEntryRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="CatalogEntryRecommendation_Data.jspf" %>
</c:if>

<c:if test="${env_inPreview && !env_storePreviewLink && (empty ignorePreview)}">
	<c:if test="${empty catentryIdList}">
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
	<c:set var="widgetManagedByMarketing" value="true" />
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>

<%@ include file="ext/CatalogEntryRecommendation_UI.jspf" %>

<c:if test = "${param.custom_view ne 'true'}">
	<c:if test = "${param.showFeed eq 'true'}">
		<c:url var="eMarketingFeedURL" value="${restURLScheme}://${restServerName}:${restURLPort}${restURI}/stores/${storeId}/MarketingSpotData/${emsName}">
			<c:param name="responseFormat" value="atom" />
			<c:param name="langId" value="${langId}" />
			<c:param name="currency" value="${env_currencyCode}"/>
		</c:url>
		<%-- 
			Set this key ${emsName} to true in this map, will tell EMarketingSpot.jsp to 
			set showFeed to false for the other widgets in the same espot. We only need to
			show one feed icon and url for one EMarketingSpot.
		--%>
		<c:if test="${eSpotRssFeedEnabled != null }" >
			<c:set target="${eSpotRssFeedEnabled }" property="${emsName}" value="true" />
		</c:if>
	</c:if>
	
	<c:if test="${eSpotDatas.behavior == 2}">			
		<wcf:url var="CatEntryRecommendationRefreshViewURL" value="CatalogEntryRecommendationView" type="Ajax">
			<wcf:param name="emsName" value="${param.emsName}" />
			<wcf:param name="pageSize" value="${pageSize}" />
			<wcf:param name="commandName" value="SearchDisplay" />
			<wcf:param name="pageView" value="${param.pageView}" />
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="categoryId" value="${WCParam.categoryId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
			<wcf:param name="dontCreateRefreshArea" value="true" />
			<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
			<c:if test="${env_inPreview && !env_storePreviewLink && (empty ignorePreview)}">
				<wcf:param name="pgl_widgetName" value="${param.pgl_widgetName}" />
				<wcf:param name="pgl_widgetId" value="${param.pgl_widgetId}" />
				<wcf:param name="pgl_widgetSlotId" value="${param.pgl_widgetSlotId}"/>
				<wcf:param name="pgl_widgetSeqeunce" value="${param.pgl_widgetSeqeunce}"/>
				<wcf:param name="pgl_widgetDefName" value="${param.pgl_widgetDefName}"/>
			</c:if>
		</wcf:url>
		<script type="text/javascript">
			dojo.addOnLoad(function(){
				if (wc.render.getRefreshControllerById("prodRecommendationRefresh_controller_<c:out value="${param.emsName}"/>") != null) {
					wc.render.getRefreshControllerById("prodRecommendationRefresh_controller_<c:out value="${param.emsName}"/>").url = '${CatEntryRecommendationRefreshViewURL}';
				}
			});
		</script>
		<c:if test="${empty WCParam.dontCreateRefreshArea}">
			<div dojoType="wc.widget.RefreshArea" id="SearchProductRecommendationESpot_Widget_<c:out value="${param.emsName}"/>" controllerId="prodRecommendationRefresh_controller_<c:out value="${param.emsName}"/>">
		</c:if>
	</c:if>
	
	<c:if test="${!empty catentryIdList}">
		<c:choose>
			<c:when test="${param.widgetOrientation eq 'vertical'}">
				<%@include file="CatalogEntryRecommendation_Vertical_UI.jspf"%>
			</c:when>
			<c:otherwise>
				<%@include file="CatalogEntryRecommendation_Horizontal_UI.jspf"%>
			</c:otherwise>
		</c:choose>
		<%-- 
			 A ESpot widget can have Content, CatlogEntry, and Category recommendations, the ${eSpotTitleIncluded} 
			 is used to make sure that the ESpost title only display once.
		--%>
		<c:if test="${ eSpotTitleIncluded == null}" >
			<jsp:useBean id="eSpotTitleIncluded" class="java.util.LinkedHashMap" scope="request" />
		</c:if>
		<c:if test="${empty eSpotTitleIncluded[emsName] }" >
			<c:set target="${eSpotTitleIncluded }" property="${emsName}" value="true" />
		</c:if>
	</c:if>
	<c:if test="${eSpotDatas.behavior == 2 && empty WCParam.dontCreateRefreshArea}">
		</div>
	</c:if>
</c:if>
<c:if test="${ empty ignorePreview }">	
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>
<wcpgl:pageLayoutWidgetCache/>
<!-- END CatalogEntryRecommendation.jsp -->
