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

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%-- 
	This fragment requires the following vars to be set
		activeWidget, activeWidgetShowVerb, businessObject
		
	When there is no esite default display text override returned by the server response and the parent object (an inherited Layout) 
	is locked in a different workspace, the CMC will always mark the default display text as read only.  This will
	prevent the business user on the e-site to provide override for default display text.  Whenever a property of a layout
	or widget is updated in CMC, the CMC always sent a request to update the default display text override.  This causes
	the default display text override to be locked in the workspace even though the business user does not update the default
	display text override field in CMC.  To fix both issues, we use foundESiteTextList to keep a list of default display text 
	found in the current store.  After going through all
	default display text returned by the server response, it will try to check the foundESiteTextList to find out whether
	there is any default display text missing for the local store and all current data languages in CMC.  If there is
	any missing default display text found, it will initialize a WidgetDisplayText object and mark the object as modifiable.
--%>


<jsp:useBean id="foundESiteTextList" class="java.util.HashMap" type="java.util.Map" scope="page" />

<c:forEach var="extData" items="${activeWidget.extendedData}">
	<c:if test="${extData.dataType == 'IBM_DisplayText'}">
		<c:set var="inherited" value="" />
		<c:set var="owningStoreId" value="${extData.storeIdentifier.uniqueID}" />
		<c:if test="${param.storeId != owningStoreId}">
			<c:set var="inherited" value="Inherited" />
		</c:if>
		<c:forEach var="attributes" items="${extData.attributes}">
			<object objectType="${inherited}WidgetDisplayText">
			
				<c:set var="showVerb" value="${activeWidgetShowVerb}" scope="request" /> 
		 		<c:set var="businessObject" value="${extData}" scope="request" />
		 		<jsp:include page="/cmc/SerializeChangeControlMetaData" /> 
		 		
		 		<languageId>${attributes.language}</languageId>
				<objectStoreId>${owningStoreId}</objectStoreId> 
				<c:forEach	var="attribute" items="${attributes.attribute}">
					<xExtData_${attribute.typedKey}>
						<wcf:cdata data="${attribute.typedValue}" />
					</xExtData_${attribute.typedKey}>
				</c:forEach> 
			</object>

			<c:if test="${param.storeId == owningStoreId}">
				<c:set target="${foundESiteTextList}" property="${attributes.language}" value="${attributes.language}" />
			</c:if>

		</c:forEach>
	</c:if>
</c:forEach>

<c:forEach var="language" items="${param.dataLanguageIds}">
	 <c:if test="${empty foundESiteTextList[language]}">
		<object	objectType="WidgetDisplayText">
			<changeControlModifiable>true</changeControlModifiable>		
			<objectStoreId><wcf:cdata data="${param.storeId}"/></objectStoreId>			
			<languageId><wcf:cdata data="${language}"/></languageId>
			<xExtData_displayText></xExtData_displayText>
			
		</object>
	 </c:if>
	 
</c:forEach>


<c:remove var="foundESiteTextList" scope="page" />

