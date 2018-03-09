<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SiteContentList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:remove var="includedSearchContentJSPF"/>
<c:if test="${empty totalContentCount}">
	<%@include file="/Widgets_701/Common/SearchContentSetup.jspf" %>
</c:if>

	<c:set var="endIndex" value = "${pageSize + WCParam.beginIndex}"/>
	<c:if test="${totalContentCount < endIndex}">
		<c:set var="endIndex" value = "${totalContentCount}"/>
	</c:if>


<!--	<%-- totalContentCount is set in SearchContentSetup.jspf file.. --%>
	<fmt:parseNumber var="total" value="${totalContentCount}" parseLocale="en_US"/> <%-- Get a float value from totalContentCount which is a string --%>
	<c:set  var="totalPages"  value = "${total / pageSize * 1.0}"/>
	<%-- Get a float value from totalPages which is a string --%>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="false" parseLocale="en_US"/> 

	<%-- do a ceil if totalPages contains fraction digits --%>
	<c:set var="totalPages" value = "${totalPages + (1 - (totalPages % 1)) % 1}"/>

	<c:set var="currentPage" value = "${( WCParam.beginIndex + 1) / pageSize}" />
	<%-- Get a float value from currentPage which is a string --%>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

	<%-- do a ceil if currentPage contains fraction digits --%>
	<c:set var="currentPage" value = "${currentPage + (1 - (currentPage % 1)) % 1}"/>

	<%-- Get a float value from currentPage which is a string --%>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

	<%-- If we are using grid mode, then we need to know the total number of rows to display --%>
	<c:set var="totalRows"  value="${total / env_resultsPerRow}"/>
	${totalRows}
	<c:set var="totalRddows" value = "${totalRoddws + (1 - (totalRddows % 1)) % 1}" />	-->

	<wcf:url var="SiteContentListViewURL" value="SiteContentListView" type="Ajax">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="sType" value="SimpleSearch"/>						
			<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
			<wcf:param name="searchType" value="${WCParam.searchType}"/>	
			<wcf:param name="metaData" value="${metaData}"/>	
			<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
			<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
			<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
			<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
			<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
			<wcf:param name="filterType" value="${WCParam.filterType}" />
			<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
			<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
			<c:if test="${env_inPreview && !env_storePreviewLink}">
				<wcf:param name="pgl_widgetName" value="${param.pgl_widgetName}" />
				<wcf:param name="pgl_widgetId" value="${param.pgl_widgetId}" />
				<wcf:param name="pgl_widgetSlotId" value="${param.pgl_widgetSlotId}"/>
				<wcf:param name="pgl_widgetSeqeunce" value="${param.pgl_widgetSeqeunce}"/>
				<wcf:param name="pgl_widgetDefName" value="${param.pgl_widgetDefName}"/>
			</c:if>
	</wcf:url>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>	
	
<c:if test="${totalContentCount > 0}">

	<script type="text/javascript">
					<!-- Initializes the undo stack. This must be called from a <script>  block that lives inside the <body> tag to prevent bugs on IE. -->
					dojo.require("dojo.back");
					dojo.back.init();
					dojo.addOnLoad(function(){																	
						SearchBasedNavigationDisplayJS.initContentUrl('${SiteContentListViewURL}');
						SearchBasedNavigationDisplayJS.updateContextProperties('searchBasedNavigation_context',{'searchTerm':'<wcf:out value="${searchTerm}" escapeFormat="js"/>'});					
					});
	</script>


	<%@include file="SiteContentList_UI.jspf"%>

</c:if>	
<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END SiteContentList.jsp -->
