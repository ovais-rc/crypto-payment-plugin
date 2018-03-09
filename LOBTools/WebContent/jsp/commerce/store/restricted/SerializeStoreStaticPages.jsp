<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="stoBundleName" value="com.ibm.commerce.store.client.lobtools.properties.StoreLOB"/>

<c:set var="assetStoreId" value=""/>
<jsp:useBean id="foundESiteURLList" class="java.util.HashMap" type="java.util.Map"/>
<jsp:useBean id="foundAssetStoreURLList" class="java.util.HashMap" type="java.util.Map"/>		
<jsp:useBean id="usageList" class="java.util.HashMap" type="java.util.Map"/>
<jsp:useBean id="pageNameList" class="java.util.HashMap" type="java.util.Map"/>
		
<c:forEach var="staticPageSEO" items="${staticPagesSEO[0].SEOContentURLs}">
	<c:set var="pageName" value="${staticPageSEO.usage}"/>
	<c:set var="pageNameKey" value="staticPage_${pageName}_name"/>
	<c:set var="nullPageNameValue" value="???${pageNameKey}???"/>

	<c:if test="${empty assetStoreId}">
		<c:forEach var="staticPageSEO2" items="${staticPagesSEO[0].SEOContentURLs}">
			<c:if test="${staticPageSEO2.parentStoreIdentifier.uniqueID != param.storeId }">
				<c:set var="assetStoreId" value="${staticPageSEO2.parentStoreIdentifier.uniqueID}"/>
			</c:if>					
		</c:forEach>
	</c:if>
	
	<fmt:setLocale value="${param.locale}"/>
	<fmt:setBundle basename="${stoBundleName}" var="stoResourceBundle"/>		
	<fmt:message bundle="${stoResourceBundle}" key="${pageNameKey}" var="template_name"/>
		
	<c:if test="${template_name != nullPageNameValue}">
		<c:set var="pageName" value="${template_name}"/>
	</c:if>
	
	<c:set var="inherited" value=""/>
	<c:if test="${staticPageSEO.parentStoreIdentifier.uniqueID != param.storeId }">
		<c:set var="inherited" value="Inherited"/>
	</c:if>
	
	<c:set target="${usageList}" property="${staticPageSEO.usage}" value="${staticPageSEO.usage}"/>
	<c:set target="${pageNameList}" property="${staticPageSEO.usage}" value="${pageName}"/>

	<c:forEach var="staticPageURLKeyword" items="${staticPageSEO.URLKeyword}">
		<c:if test="${staticPageURLKeyword.language != null}">
			<object objectType="StoreStaticPages">
				<staticPageName><wcf:cdata data="${pageName}"/></staticPageName>
				<staticPageUsage><wcf:cdata data="${staticPageSEO.usage}"/></staticPageUsage>
				<c:choose>
					<c:when test="${!empty assetStoreId }">
						<objectStoreId><wcf:cdata data="${assetStoreId}"/></objectStoreId>	
					</c:when>
					<c:otherwise>
						<objectStoreId><wcf:cdata data="${staticPageSEO.parentStoreIdentifier.uniqueID}"/></objectStoreId>
					</c:otherwise>
				</c:choose>
				<object objectType="${inherited}StoreStaticPageDetails"> 
					<c:choose>
						<c:when test="${inherited == 'Inherited'}">
							<c:set target="${foundAssetStoreURLList}" property="${staticPageSEO.usage}_${staticPageURLKeyword.language}" value="${staticPageURLKeyword.language}"/>
						</c:when>
						<c:otherwise>
							<c:set target="${foundESiteURLList}" property="${staticPageSEO.usage}_${staticPageURLKeyword.language}" value="${staticPageURLKeyword.language}"/>
						</c:otherwise>
					</c:choose>
					<staticPageId><wcf:cdata data="${staticPageSEO.URLKeywordID}"/></staticPageId>
					<objectStoreId><wcf:cdata data="${staticPageSEO.parentStoreIdentifier.uniqueID}"/></objectStoreId>
					<languageId><wcf:cdata data="${staticPageURLKeyword.language}"/></languageId>
					<c:if test="${staticPageURLKeyword.keyword != null && staticPageURLKeyword.keyword != ''}">
						<staticPageUrlkeyword><wcf:cdata data="${staticPageURLKeyword.keyword}"/></staticPageUrlkeyword>
					</c:if>
					<c:if test="${staticPageURLKeyword.URLPrefix != null && staticPageURLKeyword.URLPrefix != ''}">
						<staticPagePrefixUrl><wcf:cdata data="${staticPageURLKeyword.URLPrefix}"/></staticPagePrefixUrl>
					</c:if>
				</object>
			</object>
		</c:if>
	</c:forEach>	
	
</c:forEach>

<c:forEach var="language" items="${param.dataLanguageIds}">
	<c:forEach var="usage" items="${usageList}">
		<c:set var="usageVal" value="${usage.value}"/>
		<c:set var="usage_lang" value="${usageVal}_${language}"/>
		<c:if test="${empty foundESiteURLList[usage_lang]}">
			<object objectType="StoreStaticPages">
				<staticPageName><wcf:cdata data="${pageNameList[usageVal]}"/></staticPageName>
				<staticPageUsage><wcf:cdata data="${usage.value}"/></staticPageUsage>
				<c:choose>
					<c:when test="${!empty assetStoreId }">
						<objectStoreId><wcf:cdata data="${assetStoreId}"/></objectStoreId>	
					</c:when>
					<c:otherwise>
						<objectStoreId><wcf:cdata data="${param.storeId}"/></objectStoreId>
					</c:otherwise>
				</c:choose>
				<object objectType="StoreStaticPageDetails">
					<objectStoreId><wcf:cdata data="${param.storeId}"/></objectStoreId>
				    <languageId><wcf:cdata data="${language}"/></languageId>
				 </object>
			</object>
		</c:if>
		<c:if test="${!empty foundAssetStoreURLList}">
			<c:if test="${empty foundAssetStoreURLList[usage_lang]}">
				<object objectType="StoreStaticPages">
					<staticPageName><wcf:cdata data="${pageNameList[usageVal]}"/></staticPageName>
					<staticPageUsage><wcf:cdata data="${usage.value}"/></staticPageUsage>
					<objectStoreId><wcf:cdata data="${assetStoreId}"/></objectStoreId>
					<object objectType="InheritedStoreStaticPageDetails">
						<objectStoreId><wcf:cdata data="${assetStoreId}"/></objectStoreId>
					    <languageId><wcf:cdata data="${language}"/></languageId>
					</object>
				</object>
			</c:if>
		</c:if>
	</c:forEach>
</c:forEach>