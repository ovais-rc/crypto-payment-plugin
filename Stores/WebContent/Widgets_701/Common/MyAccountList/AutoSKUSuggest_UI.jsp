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

<%--
*****
Required parameters:
	suffix:
	autoSKUSuggestInputField:
	autoSuggestBySKULabel:

*****
--%>
 
<!-- BEGIN AutoSKUSuggest_UI.jsp -->	

<c:set var="suffix" value="${param.suffix}"/>
<c:set var="autoSKUSuggestInputField" value="${param.autoSKUSuggestInputField}"/>
<c:set var="autoSuggestBySKULabel" value="${param.autoSuggestBySKULabel}"/>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}/Widgets_701/Common/MyAccountList/javascript/AutoSKUSuggest.js"></script>
<script type="text/javascript">
	//Declare context and refresh controller which are used in autoSuggestBySKU to display the result(SKUs).
	autoSKUSuggest_controller_initProperties.id = "autoSuggestBySKU_Controller${suffix}";
	wc.render.declareRefreshController(autoSKUSuggest_controller_initProperties);
</script>
	
<c:url var="SearchAutoSuggestSKUServletURL" value="SearchComponentSKUAutoSuggestView">		
	<c:param name="langId" value="${WCParam.langId}"/>
	<c:param name="storeId" value="${WCParam.storeId}"/>
	<c:param name="catalogId" value="${WCParam.catalogId}"/>
</c:url>

<script type="text/javascript">		
	AutoSKUSuggestJS.init("${autoSKUSuggestInputField}");	
	AutoSKUSuggestJS.setAutoSuggestURL("${SearchAutoSuggestSKUServletURL}");
	AutoSKUSuggestJS.suffix = "${suffix}";		
	AutoSKUSuggestJS.setAddButton("${autoSKUSuggestAddButton}", "${autoSKUSuggestAddButtonText}", "${autoSKUSuggestAddButtonDisableCss}", "${autoSKUSuggestAddButtonTextDisableCss}");	
</script>

<div dojoType="wc.widget.RefreshArea" widgetId="autoSuggestBySKU_Widget${suffix}" controllerId="autoSuggestBySKU_Controller${suffix}" id="autoSuggestBySKU_Result_div${suffix}" aria-label='<c:out value="${autoSuggestBySKULabel}" />' class="autoSuggestBySKU_QuickOrder" style="display: none;">
</div>

<!-- END AutoSKUSuggest_UI.jsp -->	
