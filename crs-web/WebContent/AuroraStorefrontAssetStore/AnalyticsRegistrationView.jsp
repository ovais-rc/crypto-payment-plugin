<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<flow:ifEnabled feature="Analytics">
	<c:set var="person" value="${requestScope.person}"/>
	<c:if test="${empty person || person==null}">
		<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>
	</c:if>	
	p=${person} s=${storeId }
	<cm:registration personJSON="${person}" returnAsJSON="true" />
</flow:ifEnabled>

