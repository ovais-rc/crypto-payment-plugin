<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>  
 
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>  
  
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.StorePageType[]"
	var="catEntryPageLayoutAssociation" expressionBuilder="findPageLayoutAssociationByPageTypeAndObjectId" varShowVerb="showVerb"   
	recordSetStartNumber="${param.recordSetStartNumber}"  
	recordSetReferenceId="${param.recordSetReferenceId}"    
	maxItems="${param.maxItems}">                   
	<wcf:contextData name="storeId" data="${param.storeId}" />      
	<wcf:param name="pageType" value="${param.pageType}" />
	<wcf:param name="objectIdentifier" value="${param.parentId}"/>       
</wcf:getData>     
<objects   
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"  
	recordSetTotal="${showVerb.recordSetTotal}">  
	<c:forEach var="catEntryPage" items="${catEntryPageLayoutAssociation}">        
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${catEntryPage}" scope="request"/>  
		<jsp:directive.include file="serialize/SerializeCatalogEntryPage-PageLayoutAssociation.jspf" />     
	</c:forEach>  
</objects>
