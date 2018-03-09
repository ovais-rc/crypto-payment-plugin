<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN Discounts.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/Discounts_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="Discounts_Data.jspf" %>
</c:if>


<%@ include file="ext/Discounts_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<c:when test="${param.pageView eq 'main'}">
			<%@ include file="DiscountsExclusive_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="Discounts_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>

<jsp:useBean id="Discounts_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END Discounts.jsp -->