<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>

<c:set var="reasonCode" value="${error.ECMessage.systemMessageIdentifier}" />
<c:if test="${empty reasonCode}">
	<wcbase:useBean id="storeError" classname="com.ibm.commerce.common.beans.StoreErrorDataBean" />
	<c:set var="reasonCode" value="${storeError.key}" />
</c:if>

<oa:ResponseCriteria>
	<oa:ChangeStatus>
		<oa:Code><c:out value="${error.correlationIdentifier}" /></oa:Code>
		<oa:ReasonCode><c:out value="${reasonCode}" /></oa:ReasonCode>
		<oa:Reason><c:out value="${error.message}" /></oa:Reason>
	</oa:ChangeStatus>
</oa:ResponseCriteria>
