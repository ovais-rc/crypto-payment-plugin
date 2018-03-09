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

<%-- BEGIN DefiningAttributes.jsp --%>

<%-- This widget publishes the following events:
	- DefiningAttributes_Changed: When an attribute is selected, but not all other attributes are selected, so there is no SKU resolved yet.
	- DefiningAttributes_Resolved: When an attribute is selected, and all other attributes are selected, so a SKU is resolved.
--%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/DefiningAttributes_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="DefiningAttributes_Data.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<%@ include file="ext/DefiningAttributes_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="DefiningAttributes_UI.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<jsp:useBean id="DefiningAttributes_TimeStamp" class="java.util.Date" scope="request"/>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		if(typeof productDisplayJS != 'undefined'){
			productDisplayJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
		}		
	});
</script>
<wcpgl:pageLayoutWidgetCache/>
<%-- END DefiningAttributes.jsp --%>

