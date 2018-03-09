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

<%-- BEGIN SKUList.jsp --%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/SKUList_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="SKUList_Data.jspf" %>
</c:if>

<c:if test="${param.fromPage != 'catalogEntryListWidget'}">
	<jsp:include page="../com.ibm.commerce.store.widgets.PDP_AddToRequisitionLists/AddToRequisitionLists.jsp" flush="true">
		<jsp:param name="buttonStyle" value="none"/>
		<jsp:param name="addMultipleSKUs" value="true"/>
		<jsp:param name="nestedAddToRequisitionListsWidget" value="true"/>
		<jsp:param name="parentPage" value="${fn:escapeXml(widgetPrefix)}"/>
	</jsp:include>

	<c:if test="${env_inPreview && !env_storePreviewLink}">
		<jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page" />
		<c:set target="${previewWidgetProperties}" property="disableProductCompare" value="${disableProductCompare}" />
		<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
	</c:if>

	<script type="text/javascript">
		dojo.addOnLoad(function() {
			if(typeof SKUListJS != 'undefined'){
				SKUListJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${disableProductCompare}" />');
				SKUListJS.arrangeProductDetailTables();
				SKUListJS.checkOnlineAvailability('${productId}');
				SKUListJS.populateStoreLinks();
				dojo.topic.subscribe('DefiningAttributes_Resolved', SKUListJS.filterSkusByAttribute);
				dojo.topic.subscribe('DefiningAttributes_Changed', SKUListJS.filterSkusByAttribute);
				dojo.subscribe('ProductAddedToCart', SKUListJS.removeAllQuantities);
				dojo.subscribe('SKUsAddedToReqList', SKUListJS.removeAllQuantities);
			}
		});
		
		window.onresize = function() {
			if(typeof SKUListJS != 'undefined'){
				SKUListJS.arrangeProductDetailTables();
			}
		};
	</script>
</c:if>

<%@ include file="ext/SKUList_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="SKUList_UI.jspf" %>
</c:if>

<c:if test="${param.fromPage != 'catalogEntryListWidget'}">
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>

<jsp:useBean id="SKUList_TimeStamp" class="java.util.Date" scope="request"/>

<wcpgl:pageLayoutWidgetCache/>

<%-- END SKUList.jsp --%>