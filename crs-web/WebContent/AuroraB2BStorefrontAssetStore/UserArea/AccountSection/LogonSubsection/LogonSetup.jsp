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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

	<c:choose>
		<c:when test="${userType eq 'G'}">
			<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/AccountDisplay.jsp"/>
		</c:when>
		<c:otherwise>
			<%--
			  ***
			  * if there is an error, this means that a registered shopper tried to 
			  * logon as another user and logon fails.  In this case, UserArea/AccountSection/AccountDisplay.jsp is displayed.
			  ***
			--%>
			<c:choose>  
				<c:when test="${!empty storeError.key}">
					<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/AccountDisplay.jsp"/>
				</c:when>
				<c:otherwise>
					<c:set var="incfile" value="${env_jspStoreDir}/UserArea/AccountSection/MyAccountDisplay.jsp"/>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
	
	<%out.flush();%>
	<c:import url="${incfile}"/>
	<%out.flush();%>
	