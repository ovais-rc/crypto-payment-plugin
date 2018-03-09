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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.ActivityType"
	var="elementActivity"
	expressionBuilder="findCampaignElementsByActivityID">
	<wcf:param name="activityId"
		value="${activity.activityIdentifier.uniqueID}" />
	<wcf:contextData name="storeId" data="${param.storeId}" />
</wcf:getData>
	
<c:forEach var="element" items="${elementActivity.campaignElement}">
	<c:set var="typeOfAction" value="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/>
	
	<c:set var="foundMatch" value="false"/>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${(elementVariable.name == 'collateralIdList') && (elementVariable.value == param.collateralId)}">
			<c:set var="foundMatch" value="true" />
		</c:if>
	</c:forEach>

	<c:if test="${(foundMatch == 'true') && (typeOfAction == 'displayContent' || typeOfAction == 'displayPromotion' || typeOfAction == 'displayTitle') }">
		<reference>
			
			<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]" var="contents" expressionBuilder="findByUniqueIDs">
				<wcf:param name="UniqueID" value="${param.collateralId}" />
				<wcf:contextData name="storeId" data="${param.storeId}"/>
			</wcf:getData>			
		
			<c:forEach var="content" items="${contents}">
				
				<c:set var="referenceObjectType" value="ChildMarketingContent"/>
				<c:if test="${content.marketingContentIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="ChildInheritedMarketingContent" />
				</c:if>				
			
				<object objectType="${referenceObjectType}">
					<childMarketingContentId>${param.collateralId}</childMarketingContentId>
					<parent>
						<object objectType="${typeOfAction}">
							<elementName>${element.campaignElementIdentifier.name}</elementName>
							<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
							<parent>
								<c:set var="curActivity" value="${elementActivity}" scope="request"/>
								<c:set var="searchElementName" value="${element.parentElementIdentifier.name}" scope="request"/>
								<%
								com.ibm.commerce.marketing.facade.datatypes.ActivityType curActivity = (com.ibm.commerce.marketing.facade.datatypes.ActivityType)request.getAttribute("curActivity");
								String name = (String)request.getAttribute("searchElementName");
								java.util.List ancestry = com.ibm.commerce.marketing.internal.client.lobtools.ActivityBuilderUtils.getElementAncestry(curActivity, name);
								request.setAttribute("ancestry", ancestry);
								%>
								<c:forEach var="obj" items="${ancestry}" varStatus="status">
									<c:forTokens var="type" items="${obj}" delims="," begin="0" end="0">
										<object objectType="${type}">
									</c:forTokens>
									<c:forTokens var="name" items="${obj}" delims="," begin="1" end="1">
										<elementName>${name}</elementName>
									</c:forTokens>
								
									<parent>
									<c:if test="${status.last}">
										<c:set var="showVerb" value="${showVerb}" scope="request"/>
										<c:set var="businessObject" value="${activity}" scope="request"/>									
										<jsp:directive.include file="../../marketing/restricted/SerializeActivity.jspf"/>
									</c:if>
								</c:forEach>
								<c:forEach var="obj" items="${ancestry}" varStatus="status">
						  			</parent>
									</object>
								</c:forEach>									
							</parent>
						</object>
					</parent>
				</object>
			</c:forEach>
		</reference>
	</c:if>
</c:forEach>
