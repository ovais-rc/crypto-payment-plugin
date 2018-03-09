<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

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

<% 
	request.setAttribute(
			com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE
			, Boolean.FALSE);
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<c:set var="cancel" value="true"/>
<c:set var="returnValue" value=""/>
<c:set var="multiLanguage" value="false"/>

<jsp:useBean id="localeToContentURLMap" class="java.util.HashMap" type="java.util.Map"/>

<c:forEach items="${param}" var="p">
	<c:if test="${fn:startsWith(p.key, 'link.')}">
		<c:set var="multiLanguage" value="true"/>
		<c:set var="contentLocale">${fn:substring(p.key,fn:length('link.'),fn:length(p.key))}</c:set>
		<c:set target="${localeToContentURLMap}" property="${contentLocale}">${p.value}</c:set>
	</c:if>
</c:forEach>

<c:if test="${multiLanguage}">
	<jsp:useBean id="languageIdToContentURLMap" class="java.util.HashMap" type="java.util.Map"/>
	
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType[]"
			var="configurations"
			expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.supportedLanguages"/>
	</wcf:getData>
	<c:forEach var="config" items="${configurations}">
		<c:if test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.supportedLanguages'}">
			<c:forEach var="attribute" items="${config.configurationAttribute}">
				<c:set var="languageId" value=""/>
				<c:set var="localeName" value=""/>
				<c:set var="language" value=""/>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<c:if test="${additionalValue.name == 'languageId'}">
						<c:set var="languageId" value="${additionalValue.value}"/>
					</c:if>
					<c:if test="${additionalValue.name == 'localeName'}">
						<c:set var="localeName" value="${additionalValue.value}"/>
					</c:if>
					<c:if test="${additionalValue.name == 'language'}">
						<c:set var="language" value="${additionalValue.value}"/>
					</c:if>
				</c:forEach>
				<c:if test="${!empty languageId}">
					<c:if test="${!empty localeToContentURLMap[language]}">
						<c:set target="${languageIdToContentURLMap}" property="${languageId}" value="${localeToContentURLMap[language]}"/>
					</c:if>
					<c:if test="${!empty localeToContentURLMap[localeName]}">
						<c:set target="${languageIdToContentURLMap}" property="${languageId}" value="${localeToContentURLMap[localeName]}"/>
					</c:if>
				</c:if>
			</c:forEach>
		</c:if>
	</c:forEach>
	<c:if test="${empty languageIdProperty}">
		<c:set var="languageIdProperty" value="languageId"/>
	</c:if>
	<c:if test="${empty languageObjectAttributes}">
		<c:set var="languageObjectAttributes" value=""/>
	</c:if>
	<c:set var="cancel" value="false"/>
	<c:set var="returnValue"><?xml version="1.0" encoding="UTF-8"?><parent></c:set>
	<c:forEach var="lang" items="${languageIdToContentURLMap}">
		<c:set var="returnValue">${returnValue}<object objectType="${languageObjectType}" ${languageObjectAttributes}></c:set>
		<c:set var="returnValue">${returnValue}<${languageIdProperty}>${lang.key}</${languageIdProperty}></c:set>
		<c:set var="returnValue">${returnValue}<${punchOutPropertyName} dirty="true"><![CDATA[http://[cmsHost]${lang.value}]]></${punchOutPropertyName}></c:set>
		<c:set var="returnValue">${returnValue}</object></c:set>
	</c:forEach>
	<c:set var="returnValue">${returnValue}</parent></c:set>
</c:if>

<c:if test="${!multiLanguage && !(empty param.link)}">
	<c:set var="cancel" value="false"/>
	<c:set var="returnValue"><?xml version="1.0" encoding="UTF-8"?><object></c:set>
	<c:set var="returnValue">${returnValue}<${punchOutPropertyName} dirty="true"><![CDATA[http://[cmsHost]${param.link}]]></${punchOutPropertyName}></c:set>
	<c:set var="returnValue">${returnValue}</object></c:set>
</c:if>

<c:if test="${!cancel}">
	<c:set var="returnValue">${fn:replace(returnValue, "\"", "\\\"")}</c:set>
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<base target="_self" />
<title></title>
<script type="text/javascript">
<!-- hide script from old browsers
function window_onLoad () {
<c:if test="${!cancel}">
	window.returnValue = "${returnValue}";
</c:if>
	window.close();
}
//-->
</script>
</head>

<body onload="window_onLoad()">

</body>

</html>
