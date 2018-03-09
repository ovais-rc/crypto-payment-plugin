<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- BEGIN NamePartNumberAndPrice.jsp --%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/NamePartNumberAndPrice_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="NamePartNumberAndPrice_Data.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<%@ include file="ext/NamePartNumberAndPrice_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<c:when test = "${(type eq 'bundle') or (type eq 'package')}">
			<%@ include file="NamePartNumberAndPriceBundle_UI.jspf" %>
		</c:when>
		<c:when test = "${type eq 'dynamickit' or type eq 'preddynakit'}">
			<%@ include file="NamePartNumberAndPriceDynamicKit_UI.jspf" %>		
		</c:when>
		<c:otherwise>
			<%@ include file="NamePartNumberAndPrice_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<jsp:useBean id="NamePartNumberAndPrice_TimeStamp" class="java.util.Date" scope="request"/>

<script type="text/javascript">
	dojo.addOnLoad(function() { 
		if(typeof productDisplayJS != 'undefined'){
			productDisplayJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
			<c:if test="${env_displayListPriceInProductPage == 'true' && displaySKUContextData ne 'true'}">
				dojo.topic.subscribe('DefiningAttributes_Resolved', productDisplayJS.displayPrice);		
			</c:if>
			dojo.topic.subscribe('DefiningAttributes_Resolved', productDisplayJS.updateProductName);	
			dojo.topic.subscribe('DefiningAttributes_Resolved', productDisplayJS.updateProductPartNumber);					
		}		
	});
</script>
<wcpgl:pageLayoutWidgetCache/>
<%-- END NamePartNumberAndPrice.jsp --%>
