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
		<c:if test="${(elementVariable.name == 'segmentIdList') && (elementVariable.value == param.segmentId)}">
			<c:set var="foundMatch" value="true" />
		</c:if>
	</c:forEach>

	<c:if test="${foundMatch == 'true'}">
		<reference>
	
			<wcf:getData type="com.ibm.commerce.member.facade.datatypes.MemberGroupType[]" var="memberGroups" expressionBuilder="findByUniqueIDs">
				<wcf:contextData name="storeId" data="${param.storeId}" />
				<wcf:param name="accessProfile" value="IBM_Summary" />
				<wcf:param name="UniqueID" value="${param.segmentId}" />
			</wcf:getData>					
		
			<c:forEach var="group" items="${memberGroups}">
				
				<c:set var="referenceObjectType" value="ChildCustomerSegment"/>
				<c:if test="${group.memberGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="ChildInheritedCustomerSegment" />
				</c:if>				
			
				<object objectType="${referenceObjectType}">
					<childCustomerSegmentId>${group.memberGroupIdentifier.uniqueID}</childCustomerSegmentId>
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
										<jsp:directive.include file="SerializeActivity.jspf"/>
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
