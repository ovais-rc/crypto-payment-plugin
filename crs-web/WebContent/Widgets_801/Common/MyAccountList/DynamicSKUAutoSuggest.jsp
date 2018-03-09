<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN DynamicSKUAutoSuggest.jsp -->
<%@include file="../../Common/JSTLEnvironmentSetup.jspf" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<c:set var="skuTerm" value="" />
<c:set var="suffix" value="${WCParam.suffix}" />
<c:if test="${!empty WCParam.term}">
	<c:set var="skuTerm" value="${fn:trim(fn:toUpperCase(WCParam.term))}" />
</c:if>
<c:set var="enableAddButton" value="false" />
<c:catch var="searchServerException">
	<wcf:rest var="skuResults" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/sitecontent/productSuggestionsBySearchTerm/*" >		
		<wcf:param name="searchTerm" value="${skuTerm}"/>		
		<wcf:param name="langId" value="${WCParam.langId}"/>		
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="pageNumber" value="1"/>
		<wcf:param name="pageSize" value="4"/>		
		<wcf:param name="profileName" value="IBM_findNavigationSuggestion_PartNumber"/>	
		<wcf:param name="searchType" value="100"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
</c:catch>
<c:if test="${fn:length(skuResults.suggestionView) > 0}">
<div id="skuAddSearch${suffix}" class="skuAddSearch" style="display: block;" role="list" aria-label="<wcst:message key='ACCE_REGION_SKUTYPEAHEAD' bundle='${widgetText}' />" >

	<div role="list" title="Suggested Keywords"></div>
	<c:forEach items="${skuResults.suggestionView[0].entry}" var="resultTerm" varStatus="status">
		<c:set var="resultPartNumber" value="${resultTerm.partNumber}"/>
		<c:set var="resultPartNumberInUpperCase" value="${fn:toUpperCase(resultPartNumber)}"/>	
		<c:set var="resultName" value="${resultTerm.name}"/>
		<c:if test="${resultPartNumberInUpperCase == skuTerm}">
			<c:set var="enableAddButton" value="true" />
		</c:if>
		<div class="skuSearchItem" id="skuAutoSelectOption_${status.index}${suffix}" tabindex="-1" title='<c:out value="${resultPartNumber}"/>' role="listitem" onclick="AutoSKUSuggestJS.selectAutoSuggest(this.title); return false;">
			<p class="skuCode">				
				<c:if test="${fn:indexOf(resultPartNumberInUpperCase,skuTerm)ne-1}">
					<%-- Highlight the search term in the result --%>
					<c:set var="boldSKUTerm">
						<b><c:out value="${skuTerm}" escapeXml="false"/></b>
					</c:set>
					<c:out value="${fn:replace(resultPartNumberInUpperCase,skuTerm,boldSKUTerm)}" escapeXml="false"/>
				</c:if>
				<c:if test="${fn:indexOf(resultPartNumberInUpperCase,skuTerm)eq-1}">
					<c:out value="${resultPartNumber}"/>
				</c:if>				
			</p>
			<p class="skuTitle">			
				<c:out value="${resultName}" escapeXml="false"/>
			</p>
		</div>
	</c:forEach>
</div>

<input type='hidden' id='autoSuggestOriginalTerm${suffix}' value='${skuTerm}'/>
<input type='hidden' id='dynamicAutoSuggestSKUTotalResults${suffix}' value="${fn:length(skuResults.suggestionView[0].entry)}"/>
<input type='hidden' id='enableAddButton${suffix}' value='${enableAddButton}'/>
</c:if>
							
<!-- END DynamicSKUAutoSuggest.jsp -->
