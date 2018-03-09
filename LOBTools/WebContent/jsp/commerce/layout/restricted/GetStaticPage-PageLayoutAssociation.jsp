<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>  

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>  
  
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.StorePageType[]"
	var="staticpages" expressionBuilder="findPageLayoutAssociationByPageType" varShowVerb="showVerb"   
	recordSetStartNumber="${param.recordSetStartNumber}"  
	recordSetReferenceId="${param.recordSetReferenceId}"    
	maxItems="${param.maxItems}">               
	<wcf:contextData name="storeId" data="${param.storeId}" />   
	<wcf:param name="pageType" value="${param.pageType}" />        
</wcf:getData>     
<objects   
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"  
	recordSetTotal="${showVerb.recordSetTotal}">  
	<c:forEach var="staticpage" items="${staticpages}">        
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${staticpage}" scope="request"/>  
		<jsp:directive.include file="serialize/SerializeStaticPage-PageLayoutAssociation.jspf" />     
	</c:forEach>  
</objects>
