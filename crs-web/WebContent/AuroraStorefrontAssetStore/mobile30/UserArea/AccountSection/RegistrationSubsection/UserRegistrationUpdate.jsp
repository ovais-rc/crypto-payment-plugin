<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
  *****
  * This JSP checks to ensure only 'G' user will be routed to the user registration update page of the mobile store front. 
  *****
--%>

<!-- BEGIN UserRegistrationUpdate.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>

<%@ include file="../../../../Common/EnvironmentSetup.jspf"%>

<c:choose>
	<c:when test="${userType == 'G'}">
		<c:set var="incfile" value="${env_jspStoreDir}${storeNameDir}UserArea/AccountSection/LogonSubsection/logon.jsp"/>
	</c:when>
	<c:otherwise>
		<c:set var="incfile" value="${env_jspStoreDir}${storeNameDir}UserArea/AccountSection/RegistrationSubsection/UserRegistrationUpdateForm.jsp"/>
	</c:otherwise>
</c:choose>

<%out.flush();%>
<c:import url="${incfile}"/>
<%out.flush();%>

<!-- END UserRegistrationUpdate.jsp -->
