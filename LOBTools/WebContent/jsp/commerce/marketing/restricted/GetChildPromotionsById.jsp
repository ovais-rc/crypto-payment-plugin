<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<wcf:getData
	type="com.ibm.commerce.promotion.facade.datatypes.PromotionType"
	var="promotion" expressionBuilder="getPromotionDetailsById" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${uniqueID}" />
</wcf:getData>
<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${promotion}" scope="request"/>
	<c:choose>
		<c:when test="${promotion.promotionIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="referenceObjectType" value="ChildInheritedPromotion" />
		</c:when>
		<c:otherwise>
			<c:set var="referenceObjectType" value="ChildPromotion" />
		</c:otherwise>
	</c:choose>
	<object objectType="${referenceObjectType}">
		<childPromotionId>${promotion.promotionIdentifier.uniqueID}</childPromotionId>
<jsp:directive.include file="../../promotion/restricted/SerializePromotion.jspf" />
	</object>
