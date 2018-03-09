<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP determines whether the login page or the account page should be shown to the user
  * for the mobile store front.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:choose>
	<c:when test="${userType eq 'G'}">
		<c:set var="incfile" value="${env_jspStoreDir}${storeNameDir}/UserArea/AccountSection/LogonSubsection/LogonForm.jsp"/>
	</c:when>
	<c:otherwise>
		<%--
		  ***
		  * If remember me is set, the user should be prompted with with the logon form rather than my account page.
		  * Otherwise, if a registered user then the my account page should be displayed.
		  ***
		--%>
		<wcbase:isRemembered>
			<c:set var="incfile" value="${env_jspStoreDir}${storeNameDir}/UserArea/AccountSection/LogonSubsection/LogonForm.jsp"/>
		</wcbase:isRemembered>
		<wcbase:isNotRemembered>
			<c:set var="incfile" value="${env_jspStoreDir}${storeNameDir}/UserArea/AccountSection/MyAccountDisplay.jsp"/>
		</wcbase:isNotRemembered>
	</c:otherwise>
</c:choose>

<%out.flush();%>
<c:import url="${incfile}"/>
<%out.flush();%>
	