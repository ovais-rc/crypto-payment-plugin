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

<!-- BEGIN Discounts.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/Discounts_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="Discounts_Data.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<%@ include file="ext/Discounts_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="Discounts_UI.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<jsp:useBean id="Discounts_TimeStamp" class="java.util.Date" scope="request"/>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		if(typeof productDisplayJS != 'undefined'){
			productDisplayJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
			<c:if test="${displaySKUContextData ne 'true'}">
				dojo.topic.subscribe('DefiningAttributes_Resolved', productDisplayJS.updateProductDiscount);
			</c:if>
		}		
	});
</script>
<!-- END Discounts.jsp -->