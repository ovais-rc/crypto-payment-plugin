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

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${!empty param.searchText && param.searchText != ''}">
		<c:set var="searchText" value="${param.searchText}" />
	</c:when>
	<c:otherwise>
		<c:set var="searchText" value="*" />
	</c:otherwise>
</c:choose>
<wcf:getData
	type="com.ibm.commerce.pagelayout.facade.datatypes.PageType[]"
	var="contentpages" expressionBuilder="searchContentPagesByName"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="searchText" value="${searchText}" />
</wcf:getData>
<c:set var="showVerb2" value="${showVerb}" scope="request"/>
<objects 
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}" 
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:forEach var="contentpage" items="${contentpages}">       
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />   
        <c:set var="pageOwningStoreId" value="${contentpage.pageIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
 		 <c:if test="${param.storeId != pageOwningStoreId}">
			<%-- esite case--%>
			<c:set var="inherited" value="Inherited" />
		</c:if> 
		<jsp:directive.include file="serialize/SerializeContentPage.jspf" />
	</c:forEach>  
</objects>


