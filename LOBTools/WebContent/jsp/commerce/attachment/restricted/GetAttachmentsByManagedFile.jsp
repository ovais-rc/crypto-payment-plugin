<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
	var="attachments"  
	expressionBuilder="getAttachmentByAttachmentAssetPath"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	
	 <c:set var="path" value="" />
       <c:set var="emptyString" value="" />
       <c:forTokens var="token"  delims="/" begin = "1" items="${param.fullPath}" >
        <c:choose>
           <c:when test = "${path == emptyString}">
                  <c:set var ="path" value="${token}" />
           </c:when>
           <c:otherwise>
              <c:set var ="path" value="${path}/${token}" />
           </c:otherwise>
         </c:choose>
       </c:forTokens>
	
	<wcf:param name="path" value="${path}"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="storeId" value="${param.objectStoreId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>

<c:set var="assetPathWithRootDirectory" value="${param.fullPath}"/>
<c:set var="assetPath" value="${path}"/>
<c:set var="recordSetCompleteIndicator" value="false"/>
		<c:if test="${showVerb.recordSetStartNumber+showVerb.recordSetCount==showVerb.recordSetTotal}">
		    <c:set var="recordSetCompleteIndicator" value="true"/>
		</c:if>		
<objects recordSetCompleteIndicator="${recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty attachments)}">
<c:forEach var="attachment" items="${attachments}">
 <reference>
 
   <c:forEach var="attachmentAsset" items="${attachment.attachmentAsset}">
   		<c:if test="${attachmentAsset.attachmentAssetPath == assetPath}" >
   			<c:set var="assetId" value ="${attachmentAsset.attachmentAssetIdentifier.uniqueID}" />
   		    <c:set var="attachmentAssetObjectType" value="AttachmentAssetWithFileType" /> 
			<c:set var="owningStoreId" value="${attachmentAsset.storeIdentifier.uniqueID}" />
			<c:if test="${(param.storeId) != owningStoreId}">
				<c:set var="attachmentAssetObjectType" value="InheritedAttachmentAssetWithFileType" /> 
			</c:if> 
   		</c:if>
   </c:forEach>
 
        <object objectType="${attachmentAssetObjectType}">
        	
            <assetId><wcf:cdata data="${assetId}"/></assetId>
         	<path><wcf:cdata data="${assetPathWithRootDirectory}"/></path>
         	<parent>
			 		<jsp:directive.include file="serialize/SerializeAttachment.jspf"/>
       		 </parent>
         </object>
   </reference>     
</c:forEach>
</c:if>
</objects>
