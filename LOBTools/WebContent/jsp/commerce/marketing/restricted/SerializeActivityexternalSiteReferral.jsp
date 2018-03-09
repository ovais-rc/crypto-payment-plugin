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

<c:set var="hasReferralURLValue" value="false"/>
<c:set var="hasURLName" value="false"/>

<object objectType="externalSiteReferral">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:choose>
			<c:when test="${elementVariable.name == 'urlValueList'}">
				<object objectType="urlValue">
					<urlValue><wcf:cdata data="${elementVariable.value}"/></urlValue>
				</object>
			</c:when>
			<c:otherwise>
				<c:if test="${elementVariable.name == 'referralURLValue'}">
					<c:set var="hasReferralURLValue" value="true"/>
				</c:if>
				<c:if test="${elementVariable.name == 'urlName'}">
					<c:set var="hasURLName" value="true"/>
				</c:if>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:if test="${hasReferralURLValue == 'false'}">
		<referralURLValue/>
	</c:if>
	<c:if test="${hasURLName == 'false'}">
		<urlName/>
	</c:if>

	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
