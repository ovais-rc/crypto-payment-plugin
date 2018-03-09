<%
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2008
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:choose>
	<c:when test="${WCParam.state eq 'forgetpassword'}">
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/PasswordSubsection/PasswordResetForm.jsp"/>
	</c:when>
	<c:otherwise>
		<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/RegistrationSubsection/UserRegistrationSetup.jsp"/>
	</c:otherwise>
</c:choose>
<%out.flush();%>
<c:import url="${incfile}"/>
<%out.flush();%>
