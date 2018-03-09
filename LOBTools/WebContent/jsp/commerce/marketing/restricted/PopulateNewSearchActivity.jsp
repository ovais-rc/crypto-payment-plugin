<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<object>
	<c:if test="${!empty(param.searchKeyword)}">
		<c:if test="${empty(param.path)}">
			<object objectType="path">
				<elemTemplateName>path</elemTemplateName>
				<elementName>0</elementName>
				<sequence>0.0</sequence>
				<customerCount readonly="true"></customerCount>
			</object>
		</c:if>
		<c:if test="${empty(param.viewSearchEMarketingSpot)}">
			<object objectType="viewSearchEMarketingSpot">
				<parent>
					<c:if test="${empty(param.path)}">
						<object objectId="0"/>
					</c:if>
					<c:if test="${!empty(param.path)}">
						<object objectPath="path"/>
					</c:if>
				</parent>
				<elemTemplateName>viewSearchEMarketingSpot</elemTemplateName>
				<elementName>1</elementName>
				<sequence>1000.0</sequence>
				<customerCount readonly="true"></customerCount>
				<searchOperator>=</searchOperator>
				<object objectType="searchKeyword">
					<searchKeyword><wcf:cdata data="${param.searchKeyword}"/></searchKeyword>
				</object>
			</object>
		</c:if>
		<c:if test="${!empty(param.viewSearchEMarketingSpot)}">
			<object objectPath="path/viewSearchEMarketingSpot">
				<searchOperator>=</searchOperator>
				<object objectType="searchKeyword">
					<searchKeyword><wcf:cdata data="${param.searchKeyword}"/></searchKeyword>
				</object>
			</object>
		</c:if>
	</c:if>
</object>
