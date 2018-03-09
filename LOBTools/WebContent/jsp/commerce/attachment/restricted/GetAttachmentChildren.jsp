<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type = "com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
     var="attachments"
     expressionBuilder="getAttachmentById">
     <wcf:contextData name="storeId" data="${param.storeId}" />
     <wcf:param name="attachmentId" value="${param.attachmentId}"/>
     <wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<objects>
<c:if test="${!(empty attachments)}">
	<c:forEach var="attachment" items="${attachments}">
		<jsp:directive.include file="serialize/SerializeAttachmentDescription.jspf"/>
	
        <c:if test="${!(empty attachment.attachmentAsset)}">
        	<c:forEach var="attachmentAsset" items="${attachment.attachmentAsset}">   
             
             <object objectType="AttachmentAssetWithURLType">
	                            <assetId><wcf:cdata data="${attachmentAsset.attachmentAssetIdentifier.uniqueID}"/></assetId>
	                            
	                            <c:choose>
									<c:when test="${!( empty attachmentAsset.mimeType)}">
										<path><wcf:cdata data="/${attachmentAsset.rootDirectory}/${attachmentAsset.attachmentAssetPath}"/></path>
										<fileName><wcf:cdata data="FileType"/></fileName>
								    </c:when>
								    <c:otherwise>
	      								<path><wcf:cdata data="${attachmentAsset.attachmentAssetPath}"/></path>
	 								</c:otherwise>
	 							</c:choose>
								
									<c:choose>
										 <c:when test= "${!( empty attachmentAsset.language)}">
								 	 		<c:set var="languageIds" value="" />
								     		<c:forEach var="languageId" items = "${attachmentAsset.language}" varStatus="varStatus">
								     			<c:choose>
													<c:when test="${!(varStatus.first)}">
								    	      			<c:set var="languageIds" value="${languageIds},${languageId}" />
								    	  		 	</c:when>
								    	     		<c:otherwise>
	      											 	<c:set var ="languageIds" value="${languageId}" />
	 												</c:otherwise>
	 											</c:choose>
								   			</c:forEach>
								   			<assetLanguageIds>${languageIds}</assetLanguageIds>
								   		</c:when>
								   </c:choose>
						  </object>		
	      </c:forEach>
	   </c:if>
    </c:forEach>
</c:if>
</objects>

