<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN FacebookLike.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="FacebookLike_Data.jspf" %>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
<flow:ifEnabled feature="FacebookIntegration">
	<c:if test="${!empty productId}">
		<%-- Only show if on a product page --%>
		<%@ include file="FacebookLike_UI.jspf" %>
	</c:if>
</flow:ifEnabled>
	
<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<jsp:useBean id="FacebookLike_TimeStamp" class="java.util.Date" scope="request"/>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		if(typeof productDisplayJS != 'undefined'){
			productDisplayJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
		}		
	});
</script>
<!-- END FacebookLike.jsp -->