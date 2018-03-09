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

<!-- BEGIN OrderDetail_ItemTable.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/OrderDetail_Data.jspf" %>

<c:choose>
	<c:when test="${shipmentTypeId == 1}">
		<wcf:url var="OrderDetailItemTableView" value="SSOrderDetailItemTableView" type="Ajax">
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
			<c:choose>
				<c:when test="${WCParam.orderId != null}">
					<wcf:param name="orderId" value="${WCParam.orderId}" />
				</c:when>
				<c:when test="${WCParam.externalOrderId != null}">
					<wcf:param name="externalOrderId" value="${WCParam.externalOrderId}" />
				</c:when>
				<c:when test="${WCParam.quoteId != null}">
					<wcf:param name="quoteId" value="${WCParam.quoteId}" />
				</c:when>
				<c:when test="${WCParam.externalQuoteId != null}">
					<wcf:param name="externalQuoteId" value="${WCParam.externalQuoteId}" />
				</c:when>		
				<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
					<wcf:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
				</c:when>
			</c:choose>
		</wcf:url>
	</c:when>
	<c:otherwise>
		<wcf:url var="OrderDetailItemTableView" value="MSOrderDetailItemTableView" type="Ajax">
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
			<c:choose>
				<c:when test="${WCParam.orderId != null}">
					<wcf:param name="orderId" value="${WCParam.orderId}" />
				</c:when>
				<c:when test="${WCParam.externalOrderId != null}">
					<wcf:param name="externalOrderId" value="${WCParam.externalOrderId}" />
				</c:when>
				<c:when test="${WCParam.quoteId != null}">
					<wcf:param name="quoteId" value="${WCParam.quoteId}" />
				</c:when>
				<c:when test="${WCParam.externalQuoteId != null}">
					<wcf:param name="externalQuoteId" value="${WCParam.externalQuoteId}" />
				</c:when>		
				<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
					<wcf:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
				</c:when>
			</c:choose>
		</wcf:url>
	</c:otherwise>
</c:choose>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/OrderDetail/OrderDetailContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/OrderDetail/OrderDetailControllersDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		wc.render.getRefreshControllerById('OrderDetailItemTable_Controller').url = "<c:out value='${OrderDetailItemTableView}'/>";
	});
</script>
	
<div id="OrderDetailItems_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="ORDERDETAIL_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div dojoType="wc.widget.RefreshArea" id="OrderDetailItemTable_Widget" controllerId="OrderDetailItemTable_Controller" aria-labelledby="OrderDetailItems_table_summary">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_ItemTable/AjaxOrderDetail_ItemTableInit.jsp" />
	<%out.flush();%>
</div>
	
<!-- END OrderDetail_ItemTable.jsp -->
