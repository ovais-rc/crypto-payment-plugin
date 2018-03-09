<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogFilterType"
	var="catalogFilter" expressionBuilder="getCatalogFilterDetailsById" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${param.uniqueId}" />
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}" />
	<wcf:param name="accessProfile" value="IBM_CatalogFilter_details" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetTotal="${showVerb.recordSetTotal}"> 
    
  <c:forEach var="catalogGroupConditionGroup" items="${catalogFilter.catalogGroupSelection}">
                                                                       
   <c:set var="uniqueIDs" value="${catalogGroupConditionGroup.catalogGroupSelectionIdentifier.externalIdentifier.catalogGroupIdentifier.uniqueID}"/>
   		<c:choose>
   		<c:when test="${0 != catalogGroupConditionGroup.catalogGroupSelectionIdentifier.externalIdentifier.catalogGroupIdentifier.uniqueID}">
   			    <c:set var="uniqueIDs" value="${catalogGroupConditionGroup.catalogGroupSelectionIdentifier.externalIdentifier.catalogGroupIdentifier.uniqueID}"/>
   			    <jsp:directive.include file="GetCategoriesById.jsp" />
   		</c:when>
   		<c:otherwise>
			    <c:set var="uniqueIDs" value="${param.masterCatalogId}"/>
                <jsp:directive.include file="GetCatalogById.jsp" />
		</c:otherwise>
		</c:choose>
   </c:forEach> 

  <c:forEach var="productSetAssociation" items="${catalogFilter.productSetSelection}">
  		<c:set var="uniqueIDs" value=""/>
		<c:set var="count" value="1" />
      	 <c:forEach var="catalogEntry" items="${productSetAssociation.productSet.catalogEntryIdentifier}">
      	   <c:if test="${!empty uniqueIDs}">
             <c:set var="uniqueIDs" value="${uniqueIDs},${catalogEntry.uniqueID}"/>
      	   </c:if>
      	   <c:if test="${empty uniqueIDs}">
             <c:set var="uniqueIDs" value="${catalogEntry.uniqueID}"/>
           </c:if>
		   <c:if test="${count eq 1000}">
				<jsp:directive.include file="GetProductsById.jsp" />
		  		<c:set var="uniqueIDs" value=""/>
				<c:set var="count" value="0" />
		   </c:if>
		   <c:if test="${count ne 1000}">
				<c:set var="count" value="${count + 1}" />
		   </c:if>
         </c:forEach> 
         <c:if test="${count ge 1 && !empty uniqueIDs}">
			<jsp:directive.include file="GetProductsById.jsp" />
	  </c:if>
   </c:forEach> 

</objects>