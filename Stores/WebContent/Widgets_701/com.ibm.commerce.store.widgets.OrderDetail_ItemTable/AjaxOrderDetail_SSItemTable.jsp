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

<!-- BEGIN AjaxOrderDetail_SSItemTable.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>
	
<div id="orderSummaryContainer" class="pageSection">
	<div class="pageSectionTitle">
		<span id="memberGroupExpand">
			<a id="orderSummaryContainer_plusImage_link" onclick="OrderDetailJS.expandCollapseArea()" href="#" tabindex="-1"><img id="orderSummaryContainer_plusImage" style="display:none" alt="<wcst:message key='ORDERDETAIL_SECTION_EXPAND_ACCE' bundle='${widgetText}'/>" src="<c:out value='${jspStoreImgDir}images/'/>icon_plus.png"></a>
			<a id="orderSummaryContainer_minusImage_link" onclick="OrderDetailJS.expandCollapseArea()" href="#" tabindex="0"><img id="orderSummaryContainer_minusImage" style="display:inline" alt="<wcst:message key='ORDERDETAIL_SECTION_COLLAPSE_ACCE' bundle='${widgetText}'/>" src="<c:out value='${jspStoreImgDir}images/'/>icon_minus.png"></a>
		</span>
		<p class="title">
			<a id="orderSummaryExpandLink" onclick="OrderDetailJS.expandCollapseArea()" href="#"><wcst:message key="ORDERDETAIL_SECTION" bundle="${widgetText}"/></a>
		</p>
	
		<%@ include file="ext/OrderDetail_ItemTable_Data.jspf" %>
		<c:if test = "${param.custom_data ne 'true'}">
			<%@ include file="OrderDetail_ItemTable_SSData.jspf" %>
		</c:if>
		
		<%@ include file="ext/OrderDetail_ItemTable_UI.jspf" %>
		<c:if test = "${param.custom_view ne 'true'}">
			<%@ include file="OrderDetail_ItemTable_UI.jspf" %>
		</c:if>
	</div>
</div>

<!-- END AjaxOrderDetail_SSItemTable.jsp -->
