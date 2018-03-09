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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<jsp:useBean id="foundPeople" class="java.util.HashMap" type="java.util.Map" scope="request"/>

<c:if test="${foundPeople[personId] == null}">
	<wcf:getData
	    type="com.ibm.commerce.member.facade.datatypes.PersonType"
	    var="person"
	    expressionBuilder="findByUniqueID"
	    varShowVerb="showVerb" >
	    <wcf:param name="personId" value="${personId}" />
	    <wcf:param name="accessProfile" value="IBM_All" />
	</wcf:getData>
	<c:set target="${foundPeople}" property="${personId}" value="${person}"/>
</c:if>

<c:set var="businessObject" value="${foundPeople[personId]}" />
<jsp:directive.include file="SerializePerson.jspf" />