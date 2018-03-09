<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP file is used to create a JSON that has the order total amount.
  *****
--%>
<%@	page session="false"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="order" value="${requestScope.orderInCart}"/>
<c:if test="${empty order || order == null}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="1"/>
		<wcf:param name="pageNumber" value="1"/>
		<wcf:param name="profileName" value="IBM_Summary"/>
	</wcf:rest>
</c:if>
{
	"orderTotal": "<c:out value='${order.grandTotal}'/>",
	"operation": "<c:out value="${param.operation}"/>",
	"piFormName": "<c:out value="${param.piFormName}"/>",
	"skipOrderPrepare": "<c:out value="${param.skipOrderPrepare}"/>"
}
