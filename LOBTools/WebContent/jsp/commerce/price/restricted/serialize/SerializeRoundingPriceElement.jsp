<%--
 ===================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright International Business Machines Corporation.
      2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>


<object objectType="roundingPrice">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'definingCurrencyCodes'}">
				<object objectType="prcRoundingRuleCurrencyObject">
					<definingCurrencyCodes>${elementVariable.value}</definingCurrencyCodes>
				</object>
			</c:when>
			<c:when test="${elementVariable.name == 'pattern'}">
				<object objectType="prcRoundingRulePatternObject">
					<pattern>${elementVariable.value}</pattern>
				</object>
			</c:when>
		</c:choose>
	</c:forEach>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
