<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:choose>    
	<c:when test="${!empty WCParam.registerNew}">  
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/RegistrationSubsection/UserRegistrationAddForm.jsp"/>
	</c:when>
	<c:when test="${userType == 'G'}">
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/LogonSubsection/LogonSetup.jsp"/>
	</c:when>
	<c:when test="${!empty WCParam.editRegistration}">
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/RegistrationSubsection/UserRegistrationUpdateForm.jsp"/>
	</c:when>
	<c:otherwise>
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/PasswordSubsection/PasswordUpdateForm.jsp"/>
	</c:otherwise>
</c:choose>
<%out.flush();%>
<c:import url="${incfile}"/>
<%out.flush();%>
