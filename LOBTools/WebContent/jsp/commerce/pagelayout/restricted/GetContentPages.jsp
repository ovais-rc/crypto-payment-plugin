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

<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.PageType[]"
	var="contentpages"
	expressionBuilder="getAllPages"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
</wcf:getData>

<c:set var="showVerb2" value="${showVerb}" scope="request"/>
<c:set var="storeId" value="${param.storeId}" />
<c:set var="pageGroup" value="${param.pageGroup}"/>
<objects 
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}" 
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:forEach var="contentpage" items="${contentpages}">       
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />   
        <c:set var="pageOwningStoreId" value="${contentpage.pageIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
 		 <c:if test="${param.storeId != pageOwningStoreId}">
			<c:set var="inherited" value="Inherited" />
		</c:if> 
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${contentpage}" scope="request"/>
		<jsp:directive.include file="serialize/SerializeContentPage.jspf" />
	</c:forEach>  
</objects>

