<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the store's static URLs for use by the crawler.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>

<?xml version="1.0" encoding="UTF-8"?>
<urlset>
<c:if test="${empty catalogId}">
	<wcf:rest var="queryStoreInfoDetailsResult" url="store/{storeId}/online_store" cached="true">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
	</wcf:rest>
	<c:set var="catalogId" value="${sdb.masterCatalog.catalogId}"/>
	<c:set var="onlineStore" value="${queryStoreInfoDetailsResult.resultList[0]}"/>
	<c:if test="${!empty onlineStore.defaultCatalog.catalogIdentifier}">
		<c:set var="catalogId" value="${onlineStore.defaultCatalog.catalogIdentifier}"/>
	</c:if>
</c:if>
<wcf:rest var="getPageResponse" url="store/{storeId}/page">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:param name="q" value="byUrlConfigurable"/>
	<wcf:param name="urlConfigurable" value="true"/>
</wcf:rest>
<c:set var="pages" value="${getPageResponse.resultList}"/>

<c:forEach var="page" items="${pages}">
	<%--
  	***
  	* begin of page
    ***
    --%>
		<wcf:url var="pageContentOnlyURL" patternName="StaticPagesContentOnlyPattern" value="GenericStaticContentPageLayoutView">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="pageId" value="${page.pageId}" />
			<wcf:param name="omitHeader" value="1" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<wcf:url var="pageViewURL" patternName="StaticPagesPattern" value="GenericStaticContentPageLayoutView">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="pageId" value="${page.pageId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<url crawlurl="${pageContentOnlyURL}" indexurl="${pageViewURL}"> 
		</url>
	<%--
  	***
 	* End of page
  	***
 	--%>
</c:forEach>	
</urlset>
