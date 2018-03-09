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

<!-- BEGIN GlobalLogin.jsp -->

<%@ include file= "/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file= "/Widgets_701/Common/ErrorMessageSetup.jspf" %>

<%@ include file="ext/GlobalLogin_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="GlobalLogin_Data.jspf" %>
</c:if>

<c:if test="${empty includedGlobalLoginJS}">
<c:set var="includedGlobalLoginJS" value="includedGlobalLoginJS" scope="request"/>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.GlobalLogin/javascript/GlobalLoginControllers.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.GlobalLogin/javascript/GlobalLogin.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.GlobalLogin/javascript/GlobalLoginShopOnBehalf.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.GlobalLogin/javascript/GlobalLoginActions.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.GlobalLogin/javascript/GlobalLoginServicesDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		GlobalLoginJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');																		
		GlobalLoginJS.initGlobalLoginUrl('GlobalLogin_controller', getAbsoluteURL() + '<c:out value="${GlobalLoginDisplayURL}"/>');		
		GlobalLoginJS.initGlobalLoginUrl('GlobalLogin_SignIn_controller', getAbsoluteURL() + '<c:out value="${GlobalLoginSignInDisplayURL}"/>');
		GlobalLoginShopOnBehalfJS.setBuyerSearchURL('${GlobalLoginShopOnBehalf_buyerSearchURL}');
		GlobalLoginShopOnBehalfJS.setControllerURL('${GlobalLoginShopOnBehalfURL}');
	});			
</script>
</c:if>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		GlobalLoginJS.registerWidget('<c:out value="${widgetId}"/>');
		GlobalLoginShopOnBehalfJS.registerShopOnBehalfPanel('${shopOnBehalfPanelId}', '${shopForSelfPanelId}');
	});
</script>
		
<%@ include file="ext/GlobalLoginSignIn_UI.jspf" %>
<c:if test = "${userLogonState == '0'}">
	<%@ include file="GlobalLoginSignIn_UI.jspf" %>
</c:if>	

<%@ include file="ext/GlobalLoginSignOut_UI.jspf" %>
<c:if test = "${userLogonState == '1'}">
	<%@ include file="GlobalLoginSignOut_UI.jspf" %>
</c:if>	

<!-- END GlobalLogin.jsp -->
