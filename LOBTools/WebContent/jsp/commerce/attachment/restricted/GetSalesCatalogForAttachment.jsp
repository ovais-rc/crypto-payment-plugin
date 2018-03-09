<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="catalogs"
	expressionBuilder="getCatalogForAttachment"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:param name="attachmentId" value="${param.attachmentId}"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="attachmentId" value = "${param.attachmentId}" />
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty catalogs)}">
	<c:forEach var="catalog" items="${catalogs}">
	    <reference>

	           <c:forEach var="attachmentReference" items="${catalog.attachmentReference}">
	          		<c:choose>
	             		 <c:when test= "${attachmentId == attachmentReference.attachmentIdentifier.uniqueID}">
	                 		<c:set var="attachmentRefId" value="${attachmentReference.attachmentReferenceIdentifier.uniqueID}"/>
	                 		<c:set var="owningStoreId" value="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
	                 		<c:set var="attachmentStoreId" value="${attachmentReference.attachmentIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
	                 		<c:set var="attachmentReferenceObjectType" value="AttachmentReference" />
	                 		<c:if test="${(param.storeId) == owningStoreId && (param.storeId) != attachmentStoreId}">
				  				<c:set var="attachmentReferenceObjectType" value="BusinessObjectToInheritedAttachment" />
				 	 		</c:if>
				 	 		<c:if test="${(param.storeId) != owningStoreId}">
								<c:set var="attachmentReferenceObjectType" value="InheritedBusinessObjectToInheritedAttachment" />
							</c:if>
	              		</c:when>
	          		</c:choose>
	          	</c:forEach>
	          	<object objectType="${attachmentReferenceObjectType}">
			 		<attachmentRefId><wcf:cdata data="${attachmentRefId}"/></attachmentRefId>
			 		 <parent>
			 		     <c:set var="objectType" value="SalesCatalog" />
			 		     <c:if test="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
			 		     	<c:set var="objectType" value="InheritedSalesCatalog" />
			 		     </c:if>
			   			 <jsp:directive.include file="../../catalog/restricted/serialize/SerializeSalesCatalog.jspf"/>
			  		</parent>
				</object>
		</reference>
	</c:forEach>
</c:if>
</objects>
