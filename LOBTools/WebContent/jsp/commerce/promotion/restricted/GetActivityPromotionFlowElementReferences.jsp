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
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${element}" scope="request"/>
	<c:set var="typeOfAction" value="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/>
	
	<c:set var="foundMatch" value="false"/>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${(elementVariable.name == 'promotionId') && (elementVariable.value == param.promotionId)}">
			<c:set var="foundMatch" value="true" />
		</c:if>
	</c:forEach>

	<c:if test="${(foundMatch == 'true') && (typeOfAction == 'displayPromotion' || typeOfAction == 'issueCoupon')}">
		<reference>
			<wcf:getData type="com.ibm.commerce.promotion.facade.datatypes.PromotionType" var="promotion" expressionBuilder="getPromotionDetailsById">
				<wcf:contextData name="storeId" data="${param.storeId}" />
				<wcf:param name="uniqueID" value="${param.promotionId}" />
			</wcf:getData>
		
			<c:set var="referenceObjectType" value="ChildPromotion"/>
			<c:if test="${promotion.promotionIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="referenceObjectType" value="ChildInheritedPromotion" />
			</c:if>				
			
			<object objectType="${referenceObjectType}">
				<childPromotionId>${param.promotionId}</childPromotionId>
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
		</reference>
	</c:if>
</c:forEach>
