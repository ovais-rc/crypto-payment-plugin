<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP file renders an individual catalog entry the intelligent offer
  * e-Marketing Spot. 
  * This JSP requires the following parameters:
  *   partNumber - the part number of the catalog entry to display. The
  *                catalog entry ID is looked up based on the partnumber,
  *                and the JSP snippet CatalogEntryThumbnailDisplay.jsp
  *                is used to display the catalog entry
  *   catalogEntryIdentifier - the catalog entry identifier of the catalog entry to display
  *                and the JSP snippet CatalogEntryThumbnailDisplay.jsp
  *                is used to display the catalog entry
  *   count - The number of the catalog entry within the scrollable pane.
  *   zoneId - The ID of the Intelligent Offer zone. Any whitespace in the zone
  *            name should be removed.
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
	*	<c:import url="${env_jspStoreDir}Widgets/ESpot/IBMProductRecommendations/IBMProductRecommendations_SKU_UI.jsp">
	*		<c:param name="partNumber" value="${currentPartnumber}"/>
	*		<c:param name="count" value="${status.count}"/>
	*	</c:import>
  *****
--%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:set var="partNumber" value="${fn:toUpperCase(param.partNumber)}"/>
<c:set var="catalogEntryIdentifier" value="${param.catEntryIdentifier}"/>

<%-- Pick the expression builder based on the pageView and partNumber availability --%>
<c:choose>
	<c:when test="${!empty partNumber}">
		<c:choose>
			<c:when test="${param.pageView eq 'list'}">
				<c:set var="expressionBuilder" value="getCatalogEntryViewAllByPartnumber"/>
			</c:when>
			<c:otherwise>
				<c:set var="expressionBuilder" value="getCatalogEntryViewSummaryByPartnumber"/>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${param.pageView eq 'list'}">
				<c:set var="expressionBuilder" value="getCatalogEntryViewAllByID"/>
			</c:when>
			<c:otherwise>
				<c:set var="expressionBuilder" value="getCatalogEntryViewSummaryByID"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<c:if test="${!empty catalogEntriesMap }">
	<c:choose>
		<c:when test="${!empty catalogEntryIdentifier}">
			<c:set var="catalogEntryDetails" value="${catalogEntriesMap[catalogEntryIdentifier]}" scope="request"/>
		</c:when>
		<c:otherwise>
			<c:set var="catalogEntryDetails" value="${catalogEntriesMap[partNumber]}" scope="request"/>
		</c:otherwise>
	</c:choose>
</c:if>
<c:if test="${!empty catalogEntryDetails}">
			<c:set var="uniqueId" value="IntelligentOfferDisplayPartnumber_div_item_${param.count}_${param.zoneId}"/>

			<c:url value="ClickInfo" var="ClickInfoURL">
				<c:param name="evtype" value="CpgnClick" />
				<c:param name="mpe_id" value="${param.mpe_id}" />
				<c:param name="intv_id" value="${param.intv_id}" />
				<c:param name="storeId" value="${storeId}" />
				<c:param name="catalogId" value="${param.catalogId}" />
				<c:param name="langId" value="${langId}" />
				<c:if test="${not empty param.experimentId}">
					<c:param name="experimentId" value="${param.experimentId}" />
					<c:param name="testElementId" value="${param.testElementId}" />
					<c:param name="controlElement" value="${param.controlElement}" />
				</c:if>
				<c:if test="${not empty param.zoneId}">
					<c:param name="cm_vc" value="${param.zoneId}"/>
				</c:if>
			</c:url>

		  	<%-- Coremetrics tag --%>
		  	<c:url value="" var="cmcrURL" />
			<flow:ifEnabled feature="Analytics">
						<cm:campurl id="cmcrURL" url="${cmcrURL}" 
							name="${catalogEntryDetails.name}" initiative="${param.intv_id}"
							activityName="${param.activityName}" campaignName="${param.campaignName}" marketingSpotName="${param.emsName}" 
							experimentName="${param.experimentName}" testElementName="${param.testElementName}" controlElement="${param.controlElement}"/>
			</flow:ifEnabled>
			<%-- Coremetrics tag --%>	        	
		
			<c:set var="catalogEntryName" value="${catalogEntryDetails.name}"/>
			<c:set var="catalogEntryIdentifier" value="${catalogEntryDetails.uniqueID}"/>
		  <%out.flush();%>
			<c:import url="${env_siteWidgetsDir}Common/CatalogEntry/CatalogEntryDisplay.jsp">
				<c:param name="emsName" value="${param.emsName}" />
				<c:param name="skipAttachments" value="true"/>
				<c:param name="pageView" value="${param.pageView}"/>
				<c:param name="disableProductCompare" value="true" />
				<c:param name="prefix" value="intelligentOffer"/>
				<c:param name="catEntryIdentifier" value="${catalogEntryIdentifier}"/>
				<c:param name="useClickInfoURL" value="true"/>
				<c:param name="clickInfoURL" value="${ClickInfoURL}"/>
				<c:param name="cmcrurl" value="${cmcrURL}"/>		
			</c:import>
		  <%out.flush();%>

</c:if>