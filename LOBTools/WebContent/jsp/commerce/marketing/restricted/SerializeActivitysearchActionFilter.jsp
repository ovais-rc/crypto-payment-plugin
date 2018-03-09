<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="propertyFilter" value="false" />
<c:set var="attributeFilter" value="false" />
<c:set var="categoryFilter" value="false" />
<c:set var="dataType" value="" />
<c:set var="elementObjectTypePrefix" value="" />

<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
	<c:if test="${elementVariable.name == 'filterName'}">
		<c:set var="filterName" value="${elementVariable.value}" />
	</c:if>
	<c:if test="${elementVariable.name == 'filterValue'}">
		<c:set var="filterValue" value="${elementVariable.value}" />
	</c:if>
	<c:if test="${elementVariable.name == 'elementObjectTypePrefix'}">
		<c:set var="elementObjectTypePrefix" value="${elementVariable.value}" />
	</c:if>	
	<c:if test="${elementVariable.name == 'filterType'}">
		<c:if test="${elementVariable.value == 'catalogEntryProperty'}">
			<c:set var="propertyFilter" value="true" />
		</c:if>
		<c:if test="${elementVariable.value == 'attributeType'}">
			<c:set var="attributeFilter" value="true" />
		</c:if>
		<c:if test="${elementVariable.value == 'facetableAttributeType'}">
			<c:set var="attributeFilter" value="true" />
		</c:if>
	</c:if>
	<c:if test="${elementVariable.name == 'filterDataType'}">
		<c:set var="dataType" value="${elementVariable.value}" />
	</c:if>
</c:forEach>

<c:set var="elementObjectType" value="${filterName}" />
<c:if test="${propertyFilter}">
	<c:set var="elementObjectType" value="catalogEntryPropertySearchFilter" />
</c:if>

<c:if test="${filterName == 'parentCatgroup_id_search'}">
	<c:set var="categoryFilter" value="true" />
	<c:set var="owningCatalog" value="${param.masterCatalogId}"/>
	<c:set var="owningCatalogIdentifier" value="${param.masterCatalogIdentifier}"/>
	<c:set var="catalogStoreId" value="${param.masterCatalogStoreId}"/>
	<c:set var="catGroupId" value="${filterValue}"/>
	<c:set var="filterValues" value="${fn:split(filterValue, '_')}"/>
	<c:if test="${fn:length(filterValues) == 2}">
		<c:set var="owningCatalog" value="${filterValues[0]}"/>
		<c:set var="catGroupId" value="${filterValues[1]}"/>
	</c:if>
	<c:if test="${owningCatalog != param.masterCatalogId}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="salesCatalog"
			expressionBuilder="getCatalogDetailsByID">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="catalogId" value="${owningCatalog}"/>
		</wcf:getData>
		<c:set var="owningCatalogIdentifier" value="${salesCatalog.catalogIdentifier.externalIdentifier.identifier}"/>
		<c:set var="catalogStoreId" value="${salesCatalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
	</c:if>
	<wcf:getData
		type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
		var="catalogGroup" expressionBuilder="getCatalogGroupDetailsByID" varShowVerb="showVerb">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:contextData name="catalogId" data="${owningCatalog}" />
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
		<wcf:param name="catGroupId" value="${catGroupId}" />
	</wcf:getData>
	
	<c:set var="inherited" value=""/>
	<c:set var="dynamic" value=""/>	
	<c:set var="sales" value=""/>	
		
	<c:if test="${param.storeId != catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}">
		<c:set var="inherited" value="Inherited"/>
	</c:if>
	<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
		<c:set var="dynamic" value="Dynamic"/>
	</c:if>	
	<c:if test="${owningCatalog != param.masterCatalogId}">
		<c:set var="sales" value="Sales" />
	</c:if>	
  <c:set var="objectType" value="${inherited}${dynamic}${sales}CatalogGroup"/>	
  <c:set var="elementObjectType" value="Child${inherited}CatalogGroup" />
	<c:if test="${!empty elementObjectTypePrefix}">
			<c:set var="elementObjectType" value="${elementObjectTypePrefix}${elementObjectType}" />
	</c:if>

</c:if>

<c:if test="${attributeFilter}">
	<c:set var="attrValueIDList" value=""/>	
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}" varStatus="counter">
		<c:if test="${elementVariable.name == 'filterValue'}">
			<c:choose>
				<c:when test="${empty attrValueIDList}">
					<c:set var="attrValueIDList" value="${elementVariable.value}"/>
				</c:when>
				<c:otherwise>			
					<c:set var="attrValueIDList" value="${attrValueIDList}${' or @identifier='}${elementVariable.value}"/>							
				</c:otherwise>
			</c:choose>
		</c:if>			
	</c:forEach>
	
	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType"
		var="attribute"
		expressionBuilder="getAttributeDictionaryAttributeAndAllowedValuesByID"
		varShowVerb="showVerb">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="uniqueID" value="${filterName}"/>	
		<wcf:param name="identifier" value="${attrValueIDList}" />			
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	</wcf:getData>	
	
	<c:set var="inheritedAttribute" value="" />
	<c:set var="attributeType" value="AllowedValues" />
	<c:if test="${attribute.attributeIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
		<c:set var="inheritedAttribute" value="Inherited" />				
	</c:if>
	<c:set var="elementObjectType" value="Child${inheritedAttribute}AttributeWithAllowedValues" />
</c:if>


<c:if test="${(attributeFilter && !(empty attribute)) ||  (categoryFilter && !(empty catalogGroup)) || (!attributeFilter && !categoryFilter)}">
	<object objectType="${elementObjectType}">
		<parent>
			<object objectId="${element.parentElementIdentifier.name}"/>
		</parent>
		<c:set var="readonly" value="" />
		<c:if test="${propertyFilter}">
			<c:set var="readonly" value="readonly='true'" />
		</c:if>
		<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
		<elementName>${element.campaignElementIdentifier.name}</elementName>
		<sequence>${element.elementSequence}</sequence>
		<customerCount readonly="true">${element.count}</customerCount>
		<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
			<c:if test="${elementVariable.name != 'filterValue'}">
				<c:choose>
					<c:when test="${elementVariable.name == 'filterName'}">
						<${elementVariable.name} ${readonly}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
					</c:when>
					<c:when test="${elementVariable.name == 'filterOperator'}">
						<c:choose>
							<c:when test="${dataType == 'NUMERIC'}">
								<filterOperatorNumeric><wcf:cdata data="${elementVariable.value}"/></filterOperatorNumeric>
							</c:when>
							<c:when test="${dataType == 'EXACTSTRING'}">
								<filterOperatorExactString><wcf:cdata data="${elementVariable.value}"/></filterOperatorExactString>
							</c:when>
							<c:when test="${dataType == 'ANYSTRING'}">
								<filterOperatorAnyString><wcf:cdata data="${elementVariable.value}"/></filterOperatorAnyString>
							</c:when>
							<c:otherwise>
								<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${elementVariable.name == 'filterValue'}">
				<c:choose>
					<c:when test="${elementObjectType == filterName}">
						<object objectType="filterValue">
							<filterValueId><wcf:cdata data="${elementVariable.value}"/></filterValueId>
							<filterValue><wcf:cdata data="${elementVariable.value}"/></filterValue>
						</object>
					</c:when>				
					<c:otherwise>
						<c:if test="${categoryFilter}">
							<c:if test="${owningCatalog == param.masterCatalogId}">
								<jsp:directive.include file="../../catalog/restricted/serialize/SerializeCatalogGroup.jspf" />
							</c:if>
							<c:if test="${owningCatalog != param.masterCatalogId}">
								<jsp:directive.include file="../../catalog/restricted/serialize/SerializeSalesCatalogGroup.jspf" />
							</c:if>
						</c:if>	
						<c:if test="${propertyFilter}">
							<c:if test="${dataType == 'NUMERIC'}">	
								<filterValue><wcf:cdata data="${elementVariable.value}"/></filterValue>
							</c:if>
							<c:if test="${dataType != 'NUMERIC'}">
								<object objectType="filterValue">
									<filterValueId><wcf:cdata data="${elementVariable.value}"/></filterValueId>
									<filterValue><wcf:cdata data="${elementVariable.value}"/></filterValue>
								</object>
							</c:if>
						</c:if>														
						<c:if test="${attributeFilter}">
							<object objectType="ChildAttributeAllowedValues">
								<attrValId><wcf:cdata data="${elementVariable.value}"/></attrValId>								
							</object>
						</c:if>																		
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
		<c:if test="${attributeFilter}">
			<jsp:directive.include file="../../catalog/restricted/serialize/SerializeAttributeDictionaryAttribute.jspf" />
		</c:if>
		<c:forEach var="userDataField" items="${element.userData.userDataField}">
			<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
		</c:forEach>
	</object>
</c:if>


 