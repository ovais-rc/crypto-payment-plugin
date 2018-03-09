<?xml version="1.0" encoding="UTF-8"?>

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
 
<wcf:getData
      type="com.ibm.commerce.infrastructure.facade.datatypes.FolderType"
      var="folder"
      expressionBuilder="getFolderItemsByFolderId"
      varShowVerb="showVerb"
      recordSetStartNumber="${param.recordSetStartNumber}"
      recordSetReferenceId="${param.recordSetReferenceId}"
      maxItems="${param.maxItems}">
      <wcf:contextData name="storeId" data="${param.storeId}"/>
      <wcf:param name="uniqueID" value="${param.folderId}"/>     
</wcf:getData>
 
<objects
      recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
      recordSetReferenceId="${showVerb.recordSetReferenceId}"
      recordSetStartNumber="${showVerb.recordSetStartNumber}"
      recordSetCount="${showVerb.recordSetCount}"
      recordSetTotal="${showVerb.recordSetTotal}">
     
      <c:set var="idList" value=""/>
      <c:set var="objectClass" value=""/>
     
      <c:forEach items="${folder.folderItem}" var="folderItem" varStatus="counter">
            <c:choose>
                  <c:when test="${counter.index == 0}">
                        <c:set var="objectClass" value="${folderItem.folderItemType}"/>
                        <c:set var="idList" value="${folderItem.referenceID}"/>
                  </c:when>
                  <c:otherwise>
                        <c:choose>
                              <c:when test="${folderItem.folderItemType == objectClass}">
                                    <c:set var="idList" value="${idList}${','}${folderItem.referenceID}"/>                           
                              </c:when>
                              <c:otherwise>                            
                                    <jsp:directive.include file="serialize/SerializePageComposerFolderItemReferences.jspf" />                               
                                    <c:set var="objectClass" value="${folderItem.folderItemType}"/>
                                    <c:set var="idList" value="${folderItem.referenceID}"/>
                              </c:otherwise>
                        </c:choose>
                  </c:otherwise>
            </c:choose>
            <c:if test="${counter.last}">
                  <jsp:directive.include file="serialize/SerializePageComposerFolderItemReferences.jspf" />
            </c:if>
      </c:forEach>
     
</objects>
