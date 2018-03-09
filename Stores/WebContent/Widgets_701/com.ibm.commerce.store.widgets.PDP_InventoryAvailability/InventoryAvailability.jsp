<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN InventoryAvailability.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:if test="${!param.fromComponents}">
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>

<flow:ifEnabled feature="InventoryAvailability">

	<%@ include file="ext/InventoryAvailability_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="InventoryAvailability_Data.jspf" %>
	</c:if>

	<%@ include file="ext/InventoryAvailability_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="InventoryAvailability_UI.jspf" %>
	</c:if>

</flow:ifEnabled>

<c:if test="${!param.fromComponents}">
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>

<jsp:useBean id="InventoryAvailability_TimeStamp" class="java.util.Date" scope="request"/>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		if(typeof productDisplayJS != 'undefined'){
			productDisplayJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
		}
	});
</script>
<!-- END InventoryAvailability.jsp -->