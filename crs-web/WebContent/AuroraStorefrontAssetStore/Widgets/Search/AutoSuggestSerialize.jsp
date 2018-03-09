<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AutoSuggestSerialize.jsp -->

<%@include file="../../Common/JSTLEnvironmentSetup.jspf" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ page trimDirectiveWhitespaces="true" %>

<fmt:message bundle="${storeText}" var="suggestedKeyWords" key="SUGGESTED_KEYWORDS" />
<fmt:message bundle="${storeText}" var="suggestedProducts" key="SUGGESTED_PRODUCTS" />
<%
		String PARAM_TERM = "term";
		String PARAM_SHOWHEADER = "showHeader";
		String term = request.getParameter(PARAM_TERM);
		pageContext.setAttribute("showHeader", request.getParameter(PARAM_SHOWHEADER));
		pageContext.setAttribute("term", term);
		String lowerCaseTerm = term.toLowerCase();
		pageContext.setAttribute("lowerCaseSearchTerm", lowerCaseTerm);

%>

<c:if test="${fn:length(term) > 1}">
	<c:set var="keywordViewIndex" value="0"/>
	<c:set var="productViewIndex" value="0"/>
	<flow:ifEnabled feature="KeywordSuggestions">
	<c:catch var="searchServerException">
		<wcf:rest var="terms" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/sitecontent/keywordSuggestionsByTerm/*" >
			<%-- Default sort for CatEntListWidget --%>
			<c:choose>
				<c:when test="${!empty WCParam.langId}">
					<wcf:param name="langId" value="${WCParam.langId}"/>
				</c:when>
				<c:otherwise>
					<wcf:param name="langId" value="${langId}"/>
				</c:otherwise>
			</c:choose>
			<wcf:param name="searchTerm" value="${term}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<c:forEach var="contractId" items="${env_activeContractIds}">
				<wcf:param name="contractId" value="${contractId}"/>
			</c:forEach>
		</wcf:rest>
	</c:catch>
	<c:if test="${fn:length(terms.suggestionView) > 0 and fn:length(terms.suggestionView[0].entry) > 0}">
		<%-- Start showing the results --%>
		<c:set var="keywordViewIndex" value="${fn:length(terms.suggestionView[0].entry)}"/>
		<div id='suggestedKeywordResults'>
			<c:if test="${showHeader}">
				<div id='suggestedKeywordsHeader'>
					<ul class="autoSuggestDivNestedList">
						<li class="heading">
							<span id="suggest_keywords_ACCE_Label"><c:out value="${suggestedKeyWords}"/></span>
						</li>
					</ul>
				</div>
			</c:if>
			<div class='list_section'>
				<div title="${suggestedKeyWords}" role='list' aria-labelledby="suggest_keywords_ACCE_Label"></div>
				<c:forEach items="${terms.suggestionView[0].entry}" var="resultTerm" varStatus="status">
					<c:set var="result" value="${resultTerm.term}"/>
					<c:set var="resultInLowerCase" value="${fn:toLowerCase(result)}"/>
					<ul class="autoSuggestDivNestedList">
						<li id='suggestionItem_${status.index}' role='listitem' tabindex='-1'>
							<a role='listitem' href='#' onmouseout="this.className=''"
							onmouseover='SearchJS.enableAutoSelect("${status.index}");' onclick='SearchJS.selectAutoSuggest(this.title); return false;' title='<c:out value="${result}"/>'
							id='autoSelectOption_${status.index}'>
								<%-- Highlight the search term in the result --%>
								<c:out value="${fn:substringBefore(result,lowerCaseSearchTerm)}"/><span class='highlight'><c:out value="${WCParam.term}"/></span><c:out value="${fn:substringAfter(result,lowerCaseSearchTerm)}"/>
							</a>
						</li>
					</ul>
				</c:forEach>
			</div>
		</div>
	</c:if>
	</flow:ifEnabled>
	
	<flow:ifEnabled feature="ProductSuggestions">
	<c:catch var="searchServerException">
		<wcf:rest var="suggestProductsTerms" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/sitecontent/productSuggestionsBySearchTerm/*" >
			<%-- Default sort for CatEntListWidget --%>
			<c:choose>
				<c:when test="${!empty WCParam.langId}">
					<wcf:param name="langId" value="${WCParam.langId}"/>
				</c:when>
				<c:otherwise>
					<wcf:param name="langId" value="${langId}"/>
				</c:otherwise>
			</c:choose>
			<wcf:param name="searchTerm" value="${term}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="pageNumber" value="1"/>
			<wcf:param name="pageSize" value="4"/>
			<c:forEach var="contractId" items="${env_activeContractIds}">
				<wcf:param name="contractId" value="${contractId}"/>
			</c:forEach>
		</wcf:rest>
	</c:catch>
	<c:if test="${fn:length(suggestProductsTerms.suggestionView) > 0 and fn:length(suggestProductsTerms.suggestionView[0].entry) > 0}">
		<%-- Start showing the results --%>

		<c:set var="productViewIndex" value="${fn:length(suggestProductsTerms.suggestionView[0].entry)}"/>
		<div id='suggestedProductsResults'>
			<c:if test="${showHeader}">
				<div id='suggestedProductsHeader'>
					<ul class="autoSuggestDivNestedList">
						<li class="heading">
							<span id="suggest_products_ACCE_Label"><c:out value="${suggestedProducts}"/></span>
						</li>
					</ul>
				</div>
			</c:if>
			<div class='list_section'>
				<div title="${suggestedProducts}" role='list' aria-labelledby="suggest_products_ACCE_Label"></div>
				<c:forEach items="${suggestProductsTerms.suggestionView[0].entry}" var="resultTerm" varStatus="status">
					<c:set var="result" value="${resultTerm.name}"/>		
					<c:set var="resultThumbnail" value="${resultTerm.thumbnail}"/>				
					<c:set var="resultPartNumber" value="${resultTerm.partNumber}"/>
					<c:set var="resultInLowerCase" value="${fn:toLowerCase(result)}"/>
					<c:set var="resultIndex" value="${status.index + keywordViewIndex}"/>
					<wcf:url var="productDisplayUrl" patternName="ProductURL" value="Product2">
						<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
						<wcf:param name="storeId" value="${WCParam.storeId}"/>
						<wcf:param name="productId" value="${resultTerm.uniqueID}"/>
						<wcf:param name="langId" value="${WCParam.langId}"/>
						<wcf:param name="urlLangId" value="${WCParam.langId}" />
					</wcf:url>	
					
					<ul class="autoSuggestDivNestedList">
						<li id='suggestionItem_${resultIndex}' role='listitem' tabindex='-1'>
							<a role='listitem' href='<c:out value="${productDisplayUrl}"/>' onmouseout="this.className=''"
							onmouseover='SearchJS.enableAutoSelect("${resultIndex}");' title='<c:out value="${result}"/>'
							id='autoSelectOption_${resultIndex}'>
								<div class="as_thumbnail">
									<c:choose>
										<c:when test="${empty resultThumbnail}">
											<c:set var="productThumbnailUrl" value="${hostPath}${jspStoreImgDir}images/NoImageIcon_sm.jpg"/>
										</c:when>
										<c:when test="${(fn:startsWith(resultThumbnail, 'http://') || fn:startsWith(resultThumbnail, 'https://'))}">
											<wcst:resolveContentURL var="productThumbnailUrl" url="${resultThumbnail}"/>
										</c:when>
										<c:when test="${fn:startsWith(resultThumbnail, '/store/0/storeAsset')}">
											<c:set var="productThumbnailUrl" value="${storeContextPath}${resultThumbnail}" />
										</c:when>
										<c:otherwise>
											<c:set var="productThumbnailUrl" value="${jsServerPath}${resultThumbnail}" />
										</c:otherwise>
									</c:choose>
									<img alt='<c:out value="${result}"/>' src="${productThumbnailUrl}">
								</div>
								<c:if test="${fn:indexOf(resultInLowerCase,lowerCaseSearchTerm)ne-1}">
									<%-- Highlight the search term in the result --%>
									<c:out value="${fn:substringBefore(resultInLowerCase,lowerCaseSearchTerm)}"/><span class='highlight'><c:out value="${WCParam.term}"/></span><c:out value="${fn:substringAfter(resultInLowerCase,lowerCaseSearchTerm)}"/>
								</c:if>
								<c:if test="${fn:indexOf(resultInLowerCase,lowerCaseSearchTerm)eq-1}">
									<c:out value="${result}"/>
								</c:if>
								<br>
								<span class="partNumber"><c:out value="${resultPartNumber}"/></span>
							</a>
						</li>
					</ul>
				</c:forEach>
			</div>	
		</div>
	</c:if>
	</flow:ifEnabled>
	<input type='hidden' id='autoSuggestOriginalTerm' value='<c:out value="${WCParam.term}"/>'/>
	<input type='hidden' id='dynamicAutoSuggestTotalResults' value="${keywordViewIndex + productViewIndex}"/>
</c:if>
<!-- END AutoSuggestSerialize.jsp -->
