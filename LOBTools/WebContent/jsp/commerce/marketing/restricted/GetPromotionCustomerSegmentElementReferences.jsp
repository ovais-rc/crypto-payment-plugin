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
	type="com.ibm.commerce.promotion.facade.datatypes.PromotionType"
	var="promotionElements" expressionBuilder="getPromotionElementsById">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${promotion.promotionIdentifier.uniqueID}" />
</wcf:getData>

<c:set var="targetingCondition" value=""/>
<c:set var="identifierMemberGroup" value=""/>
		
<c:forEach var="element" items="${promotionElements.element}">
		
		<c:if test="${element.elementSubType == 'Identifier_MemberGroup' || element.elementSubType == 'Identifier_InheritedMemberGroup'}">
			<c:set var="identifierMemberGroup" value="${element}"/>
		</c:if>
		<c:if test="${element.elementSubType == 'TargetingCondition'}">
			<c:set var="targetingCondition" value="${element}"/>
		</c:if>
		
</c:forEach>
		
<c:if test="${!empty targetingCondition && !empty identifierMemberGroup}">				
<reference>
<object objectType="${identifierMemberGroup.elementSubType}">
	<elementName>${identifierMemberGroup.elementName}</elementName>
	<elementType>${identifierMemberGroup.elementType}</elementType>
	<elementSequence>${identifierMemberGroup.elementSequence}</elementSequence>	
	<parent>
		<object objectType="${targetingCondition.elementSubType}">
			<elementName>${targetingCondition.elementName}</elementName>
			<elementType>${targetingCondition.elementType}</elementType>
			<elementSequence>${targetingCondition.elementSequence}</elementSequence>			
			<parent>
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<c:set var="businessObject" value="${promotion}" scope="request"/>
				<jsp:directive.include file="../../promotion/restricted/SerializePromotion.jspf" />
			</parent>
		</object>
	</parent>
</object>
</reference>
</c:if>