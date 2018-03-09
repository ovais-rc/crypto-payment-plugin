<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>  
 
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>  
  
<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType[]"
	var="pagelayouts" expressionBuilder="getLayoutsByPage" varShowVerb="showVerb"   
	recordSetStartNumber="${param.recordSetStartNumber}"  
	recordSetReferenceId="${param.recordSetReferenceId}"    
	maxItems="${param.maxItems}">               
	<wcf:contextData name="storeId" data="${param.storeId}" />    
	<wcf:param name="pageGroup" value="${param.pageGroup}" />
	<wcf:param name="pageId" value="${param.pageId}"/> 
	<wcf:param name="accessProfile" value="IBM_Admin_Details" />     
</wcf:getData>     
<c:set var="showVerb1" value="${showVerb}" scope="request"/>   
<objects   
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"  
	recordSetTotal="${showVerb.recordSetTotal}"> 
	<c:if test="${! (empty pagelayouts) }">
		<c:forEach var="pagelayout" items="${pagelayouts}">
			<%-- Check if the layout is marked as deleted --%>
			<c:if test="${! (empty pagelayout.state) && (pagelayout.state ne 'MarkForDelete') }" >
			    <c:set var="template" value="${pagelayout}" />
				<jsp:directive.include file="serialize/SerializePageReferences.jspf" /> 
			</c:if>
		</c:forEach> 
	</c:if> 
</objects>
