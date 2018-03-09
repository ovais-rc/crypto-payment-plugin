<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	varShowVerb="showVerbOnlineStore"
	expressionBuilder="findStoreByUniqueIDWithLanguage">
	<wcf:param name="usage" value="IBM_ViewCatalogTool"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>
<c:set var="defaultCat" value="${onlineStore.defaultCatalog[0]}"/>

<objects>
	<%--
		This is a condition to not display default catalog node for the store of type:<br/>
		<ul>
			<li>CHS (demand hub)
			<li>SCP (supplier hub)
			<LI>SHS (supplier hosted store)
			<LI>RPS (Consumer direct reseller store front asset store)
			<LI>BRP (B2B reseller store front asset store)
			<LI>DPS (Distributor asset store)
			<LI>DPX (Distributor proxy store)
			<LI>SCS (Supplier catalog asset store)
			<LI>SPS (Supplier asset store)
			<LI>HCP (Hosting hub)
			<LI>PBS (Store directory)
			<LI>MPS (Consumer direct hosted store front asset store)
			<LI>BMP (B2B hosted store front asset store)
		</ul>
	--%>
	<c:if test="${
			param.storeType != 'CHS' && 
			param.storeType != 'SCP' && 
			param.storeType != 'SHS' && 
			param.storeType != 'RPS' && 
			param.storeType != 'BRP' && 
			param.storeType != 'DPS' && 
			param.storeType != 'DPX' && 
			param.storeType != 'SCS' && 
			param.storeType != 'HCP' && 
			param.storeType != 'PBS' && 
			param.storeType != 'MPS' && 
			param.storeType != 'BMP'}"  >
		<object objectType="DefaultCatalog">
			<c:set var="showVerb" value="${showVerbOnlineStore}" scope="request"/>
			<c:set var="businessObject" value="${defaultCat}" scope="request"/>
			<jsp:include page="/cmc/SerializeChangeControlMetaData" />
		
			<objectStoreId>${param.storeId}</objectStoreId>
			<defaultcatalogId><c:out value="${param.masterCatalogStoreId}"/></defaultcatalogId>
		</object>
	</c:if>
</objects>
