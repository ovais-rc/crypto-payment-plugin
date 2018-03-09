<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.content.facade.datatypes.TaskGroupType[]"
	var="taskGroups" expressionBuilder="getTaskGroupHistoryByTaskGroupID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:param name="taskGroupId" value="${param.taskGroupId}" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}"> 
  <c:if test="${!(empty taskGroups)}">
    <c:forEach var="taskGroup" items="${taskGroups}">
 	   <c:forEach var="taskGroupHistory" items="${taskGroup.taskGroupChangeHistories.taskGroupChangeHistory}">
 	   <object objectType="TaskGroupHistory" readonly="true"> 
	          <c:set var="showVerb" value="${showVerb}" scope="request" /> 
		      <taskGroupHistoryId>${taskGroupHistory.historyUniqueId}</taskGroupHistoryId>
              <modifiedTime>${taskGroupHistory.changedTime}</modifiedTime> 
              <c:set var="type" value="${taskGroupHistory.changeHistoryExternalIdentifier.primaryObjectType}"/> 
              <c:set var="objectType" value="UnknownObject"/>
              <c:choose>
               <c:when test="${type == 'Catalog' || type == 'InheritedCatalog' || type == 'Product' ||   type == 'InheritedProduct' ||
                type == 'Kit' || type == 'InheritedKit'||  type == 'PredefinedDKit' ||  type == 'InheritedPredefinedDKit' ||  type == 'ProductSKU' || type == 'InheritedProductSKU' ||  
                type == 'Bundle' ||  type == 'InheritedBundle' ||  type == 'CatalogGroupSKU' ||  type == 'InheritedCatalogGroupSKU' ||  type == 'CatalogGroup' ||  
                type == 'InheritedCatalogGroup' ||  type == 'SalesCatalogGroup' ||  type == 'InheritedSalesCatalogGroup' ||  type == 'SalesCatalog' ||  type == 'InheritedSalesCatalog' || 
                type == 'DynamicSalesCatalogGroup' ||  type == 'InheritedDynamicSalesCatalogGroup' || 
                type == 'Promotion' ||  type == 'InheritedPromotion' ||  type == 'Attachment' ||  type == 'InheritedAttachment' ||  type == 'ManagedFile' ||  
                type == 'InheritedManagedFile' ||  type == 'InstallmentRule' ||  type == 'InheritedInstallmentRule' ||  type == 'SearchTermAssociations' ||  type == 'InheritedSearchTermAssociations' ||  
                type == 'PriceList' ||  type == 'InheritedPriceList' ||  type == 'RefInheritedPriceList' ||  type == 'Campaign' ||  type == 'InheritedCampaign' ||  
                type == 'EMarketingSpot' ||  type == 'CustomerSegment' ||  type == 'EmailTemplate' ||  type == 'InheritedEmailTemplate' ||
                type == 'WebActivity' ||  type == 'WebActivityTemplate' ||  type == 'DialogActivity' ||  type == 'DialogActivityTemplate' ||  type == 'EmailActivity' ||
                type == 'InheritedEMarketingSpot' ||  type == 'MarketingContent' ||  type == 'InheritedMarketingContent' ||  type == 'SearchActivity' ||  type == 'InheritedSearchActivity' ||  
                type == 'SearchActivityTemplate' ||  type == 'InheritedSearchActivityTemplate' ||  type == 'AttributeDictionaryAttributeWithAllowedValues' ||  
                type == 'InheritedAttributeDictionaryAttributeWithAllowedValues' ||  type == 'AttributeDictionaryAttributeWithAssignedValues' ||  type == 'InheritedAttributeDictionaryAttributeWithAssignedValues' || type == 'DefaultCatalog' || 
                type == 'TopCatalogGroupPage' ||  type == 'InheritedTopCatalogGroupPage' || type == 'CatalogGroupPage' ||  type == 'InheritedCatalogGroupPage' || type == 'CatalogGroupSKUPage' ||  type == 'InheritedCatalogGroupSKUPage' ||  type == 'ProductPage' ||  type == 'InheritedProductPage' ||  type == 'ProductSKUPage' ||  type == 'InheritedProductSKUPage' ||  
                type == 'BundlePage' ||  type == 'InheritedBundlePage' ||  type == 'KitPage' ||  type == 'InheritedKitPage' ||  type == 'DynamicKitPage' ||  type == 'InheritedDynamicKitPage' ||  type == 'PredDynaKitPage' ||  type == 'InheritedPredDynaKitPage' ||
                type == 'TopSalesCatalogGroupPage' ||  type == 'InheritedTopSalesCatalogGroupPage' || type == 'SalesCatalogGroupPage' ||  type == 'InheritedSalesCatalogGroupPage' || type == 'HomePage' ||  type == 'InheritedHomePage' ||  type == 'HelpPage' ||  type == 'InheritedHelpPage' ||  
                type == 'ContactUsPage' ||  type == 'InheritedContactUsPage' ||  type == 'ReturnPolicyPage' ||  type == 'InheritedReturnPolicyPage' ||  type == 'PrivacyPolicyPage' ||  type == 'InheritedPrivacyPolicyPage' ||  
                type == 'CorporateInfoPage' ||  type == 'InheritedCorporateInfoPage' ||  type == 'CorporateContactUsPage' ||  type == 'InheritedCorporateContactUsPage' ||  type == 'SiteMapPage' ||  type == 'InheritedSiteMapPage' ||
               	type == 'PageLayout' || type == 'InheritedPageLayout' || type == 'ContentPage' || type == 'InheritedContentPage'}">
                   <c:set var="objectType" value="${taskGroupHistory.changeHistoryExternalIdentifier.primaryObjectType}"/>
               </c:when>
              </c:choose>
	          <objectType><wcf:cdata data="${objectType}" /></objectType>
	          <objectUniqueId><wcf:cdata data="${taskGroupHistory.changeHistoryExternalIdentifier.primaryObjectUniqueId}" /></objectUniqueId>			  
	          <task><wcf:cdata data="${taskGroupHistory.taskDescriptionType.name}" /></task>
	          <objectStoreId><wcf:cdata data="${taskGroupHistory.changeHistoryExternalIdentifier.storeIdentifier.uniqueID}" /></objectStoreId>
	          <objectCode><wcf:cdata data="${taskGroupHistory.objectCode}" /></objectCode>
	          <action><wcf:cdata data="${taskGroupHistory.action}" /></action> 
	          <modifiedBy><wcf:cdata data="${taskGroupHistory.changedBy.logonID}" /></modifiedBy>
	          <c:forEach var="extendedData" items="${taskGroupHistory.changeHistoryExtendedDataList.changeHistoryExtendedData}">
		           <xd_${extendedData.extendedAttributeName}><wcf:cdata data="${extendedData.extendedAttributeValue}"/></xd_${extendedData.extendedAttributeName}>
	          </c:forEach>
	          <c:forEach var="userDataField" items="${taskGroupHistory.userData.userDataField}">
		           <x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	          </c:forEach>
	   </object>
	   </c:forEach> 
	</c:forEach>
  </c:if>
</objects>