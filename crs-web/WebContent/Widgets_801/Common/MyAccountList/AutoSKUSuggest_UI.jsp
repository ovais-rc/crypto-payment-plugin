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
        <%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>
        
        <c:if test="${!empty param.suffix}">
            <c:set var="suffix" value="${param.suffix}" />
        </c:if>
        <c:if test="${!empty param.autoSKUSuggestInputField}">
            <c:set var="autoSKUSuggestInputField" value="${param.autoSKUSuggestInputField}" />
        </c:if>
        <c:if test="${!empty param.autoSuggestBySKULabel}">
            <c:set var="autoSuggestBySKULabel" value="${param.autoSuggestBySKULabel}" />
        </c:if>

        <c:url var="SearchAutoSuggestSKUServletURL" value="SearchComponentSKUAutoSuggestViewV2">
            <c:param name="langId" value="${WCParam.langId}" />
            <c:param name="storeId" value="${WCParam.storeId}" />
            <c:param name="catalogId" value="${WCParam.catalogId}" />
        </c:url>

        <script type="text/javascript">
            AutoSKUSuggestJS.init("${autoSKUSuggestInputField}");
            AutoSKUSuggestJS.setAutoSuggestURL("${SearchAutoSuggestSKUServletURL}");
            AutoSKUSuggestJS.suffix = "${suffix}";
            AutoSKUSuggestJS.setAddButton("${autoSKUSuggestAddButton}", "${autoSKUSuggestAddButtonText}", "${autoSKUSuggestAddButtonDisableCss}", "${autoSKUSuggestAddButtonTextDisableCss}");

        </script>

        <div wcType="RefreshArea" id="autoSuggestBySKU_Result_div${suffix}" declareFunction="AutoSKUSuggestJS.autoSKUSuggest_controller_initProperties(${suffix})" aria-label='<c:out value="${autoSuggestBySKULabel}" />' class="autoSuggestBySKU_QuickOrder" style="display: none;">
        </div>

        <!-- END AutoSKUSuggest_UI.jsp -->
