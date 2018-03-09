<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SavedOrderInfo.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<wcf:url var="SavedOrderInfoView" value="SavedOrderInfoView" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderControllersDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderServicesDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		wc.render.getRefreshControllerById('SavedOrderInfo_Controller').url = "<c:out value='${SavedOrderInfoView}'/>";
	});
</script>

<span class="spanacce" id="savedOrderInfo_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_SAVEDORDERINFO" bundle="${widgetText}" /></span>
<div dojoType="wc.widget.RefreshArea" id="SavedOrderInfo_Widget" controllerId="SavedOrderInfo_Controller" role="region" aria-labelledby="savedOrderInfo_widget_ACCE_Label" ariaMessage="<wcst:message key="ACCE_STATUS_SAVEDORDERINFO_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderInfo/AjaxSavedOrderInfo.jsp" />
	<%out.flush();%>
</div>

<!-- END SavedOrderInfo.jsp -->

