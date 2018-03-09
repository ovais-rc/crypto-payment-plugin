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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ page import="com.ibm.commerce.catalog.facade.datatypes.CatalogAttributeType"%>

<%--
	Call the catalog entry GET web service to fetch the current page of attribute dictionary descriptive
	attributes in all languages currently enabled in the CMC tool for the
	catalog entry currently being browsed.
--%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntry"
	expressionBuilder="getCatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValueByIDWithPaging"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catEntryId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
<c:if test="${!empty param.objectVersionId}">
	<wcf:param name="accessProfile" value="IBM_Admin_CatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValue_Paging_Version"/>
</c:if>
</wcf:getData>
<%--
	Include the JSP fragment containing constants used throughout the attribute JSPs.
--%>
<jsp:directive.include file="serialize/SerializeCatalogEntryAttributeConstants.jspf"/>

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty catalogEntry)}">
	<c:forEach var="catentry" items="${catalogEntry}">
		<jsp:directive.include file="serialize/SerializeAttributeSetup.jspf"/>
		
		<c:set var="uniqueIDs" value="" /> 
	  	<c:forEach var="attributeReference" items="${catentry.catalogEntryAttributes.attributes}">
			<c:if test="${!empty attributeReference.usage}">
			    <c:choose>
					<c:when test="${uniqueIDs != ''}">
						<c:set var="uniqueIDs" value="${uniqueIDs}${','}${attributeReference.attributeIdentifier.uniqueID}" />
					</c:when>
					<c:otherwise>
						<c:set var="uniqueIDs" value="${attributeReference.attributeIdentifier.uniqueID}" />
					</c:otherwise>
				</c:choose>
			</c:if>	
		</c:forEach>			
		<c:if test="${uniqueIDs != ''}">
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType[]"
				var="attributeDictionaryAttributes"
				expressionBuilder="getAttributeDictionaryAttributeSummaryByIDs"
				varShowVerb="showVerb">
				<wcf:contextData name="storeId" data="${param.storeId}"/>
				<c:forTokens var="value" items="${uniqueIDs}" delims=",">
					<wcf:param name="UniqueID" value="${value}" />
				</c:forTokens>
				<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			</wcf:getData> 
			
			<c:forEach var="attributeObject" items="${attributeDictionaryAttributes}">
			 	<c:set target="${ATTRIBUTE_VERB_MAP}" property="${attributeObject.attributeIdentifier.uniqueID}" value="${attributeObject}"/>
			</c:forEach>	
		</c:if>	           
					
			<c:forEach var="attribute" items="${catentry.catalogEntryAttributes.attributes}">
				<%
					//------------------------------------------------------------------------------------//
					// Need to keep track of the processed attributes so they do not get processed again
					//------------------------------------------------------------------------------------//
					if(pageContext.getAttribute("attribute")!=null && PROCESSED_ATTRIBUTES!=null)
					{
						// get the catalog entry attribute
						CatalogAttributeType catalogAttribute = (CatalogAttributeType)pageContext.getAttribute("attribute");
						if(catalogAttribute!=null)
						{
							if(catalogAttribute.getAttributeIdentifier()!=null && catalogAttribute.getAttributeIdentifier().getUniqueID()!=null)
							{
								// Get the attribute ID
								String attributeID = catalogAttribute.getAttributeIdentifier().getUniqueID();
								if(attributeID != null)
								{
									attributeID = attributeID.trim();
									// Check if the attribute was processed already
									if(!PROCESSED_ATTRIBUTES.contains(attributeID)) {
										%>
										<jsp:directive.include file="serialize/SerializeCatalogEntryDescriptiveAttributeDictionaryAttributes.jspf"/>
										<%
										// Mark the attribute as processed
										PROCESSED_ATTRIBUTES.add(attributeID);
									}
								}
							}
						}
					}
				%>
			</c:forEach>
			<jsp:directive.include file="serialize/SerializeAttributeCleanup.jspf"/>
		</c:forEach>
	</c:if>
</objects>