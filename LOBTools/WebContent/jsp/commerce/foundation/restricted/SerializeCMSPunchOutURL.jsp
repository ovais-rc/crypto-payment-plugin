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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:choose>
<c:when test="${param.test}">
<%--
Bypass the punch-out window if this is a test of the punch-out mechanism.
--%>
<object>
	<punchOutURL><wcf:cdata data="${param.cmcPath}/cmc/Set${punchOutType}PunchOutReturnValue?storeId=${param.storeId}&objecType=${param.objectType}&propertyName=${param.propertyName}"/></punchOutURL>
<c:forEach items="${param}" var="par">
	<c:if test="${fn:startsWith(par.key, 'callbackParameter.')}">
		<c:set var="callbackParameterName"><c:out value="${fn:substring(par.key,fn:length('callbackParameter.'),fn:length(par.key))}"/></c:set>
		<${callbackParameterName}><wcf:cdata data="${par.value}"/></${callbackParameterName}>
	</c:if>
</c:forEach>
</object>
</c:when>
<c:otherwise>
<%--
	==========================================================================
	Call the get service for online store to retrieve the
	flag used to determine if cms punch-out is enabled or not.
	==========================================================================
--%>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	varShowVerb="showVerb"
	expressionBuilder="findByUniqueID">
	<wcf:param name="usage" value="${usage}"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Details"/>
</wcf:getData>

<c:set var="cmsHost" value=""/>
<c:set var="cmsPath" value=""/>
<c:set var="cmsSelectPath" value=""/>
<c:set var="cmsEditPath" value=""/>
<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
	<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
		<c:if test="${userDataField.typedKey == 'wc.cmsPunchOut.cmsHost'}">
			<c:set var="cmsHost" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'wc.cmsPunchOut.cmsPath'}">
			<c:set var="cmsPath" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'wc.cmsPunchOut.cmsSelectPath'}">
			<c:set var="cmsSelectPath" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'wc.cmsPunchOut.cmsEditPath'}">
			<c:set var="cmsEditPath" value="${userDataField.typedValue}" />
		</c:if>
	</c:forEach>
</c:if>

<c:if test="${empty cmsSelectPath}">
	<c:set var="cmsSelectPath" value="${cmsPath}"/>
</c:if>
<c:if test="${empty cmsEditPath}">
	<c:set var="cmsEditPath" value="${cmsPath}"/>
</c:if>
<c:choose>
	<c:when test="${param.punchOutType == 'edit'}">
		<c:set var="cmsPath" value="${cmsEditPath}"/>
	</c:when>
	<c:when test="${param.punchOutType == 'select'}">
		<c:set var="cmsPath" value="${cmsSelectPath}"/>
	</c:when>
</c:choose>

<c:set var="content" value=""/>
<c:if test="${fn:startsWith(param.content, 'http://[cmsHost]')}">
	<c:set var="content" value="${fn:substring(param.content,fn:length('http://[cmsHost]'),fn:length(param.content))}"/>
</c:if>
<object>
	<punchOutURL><wcf:cdata data="${cmsHost}${cmsPath}"/></punchOutURL>
	<locale><wcf:cdata data="${param.locale}"/></locale>
	<link><wcf:cdata data="${content}"/></link>
	<store><wcf:cdata data="${onlineStore.onlineStoreIdentifier.externalIdentifier.nameIdentifier}"/></store>
	<url><wcf:cdata data="${param.cmcPath}/cmc/Set${punchOutType}PunchOutReturnValue?storeId=${param.storeId}&objecType=${param.objectType}&propertyName=${param.propertyName}"/></url>
</object>
</c:otherwise>
</c:choose>