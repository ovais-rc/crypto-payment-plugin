<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AjaxOrderDetail_ItemTableInit.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/OrderDetail/OrderDetail.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		OrderDetailJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
		
		dojo.subscribe("showResultsForPageNumber_orderDetail",OrderDetailJS,"showResultsPage");
		<c:if test="${env_inPreview && !env_storePreviewLink}">
		dojo.subscribe("CMPageRefreshEvent",function(){
			var previewHeader = window.parent.frames[0];
			if(previewHeader.isSpotsShown()) {
				previewHeader.showESpots();previewHeader.showESpots();
				}
			});
		</c:if>
	});
</script>
	
<div id="orderSummaryContainer" class="pageSection">
	<div class="pageSectionTitle">
		<span id="memberGroupExpand">
			<a id="orderSummaryContainer_plusImage_link" onclick="OrderDetailJS.expandCollapseArea()" href="#" tabindex="0"><img id="orderSummaryContainer_plusImage" style="display:inline" alt="<wcst:message key='ORDERDETAIL_SECTION_EXPAND_ACCE' bundle='${widgetText}'/>" src="<c:out value='${jspStoreImgDir}images/'/>icon_plus.png"></a>
			<a id="orderSummaryContainer_minusImage_link" onclick="OrderDetailJS.expandCollapseArea()" href="#" tabindex="-1"><img id="orderSummaryContainer_minusImage" style="display:none" alt="<wcst:message key='ORDERDETAIL_SECTION_COLLAPSE_ACCE' bundle='${widgetText}'/>" src="<c:out value='${jspStoreImgDir}images/'/>icon_minus.png"></a>
		</span>
		<p class="title">
			<a id="orderSummaryExpandLink" onclick="OrderDetailJS.expandCollapseArea()" href="#"><wcst:message key="ORDERDETAIL_SECTION" bundle="${widgetText}"/></a>
		</p>
	</div>
</div>

<!-- END AjaxOrderDetail_ItemTableInit.jsp -->
