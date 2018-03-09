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

<%-- BEGIN MiniShopCartDisplayRefresh.jsp --%>

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>
<c:set var="miniCartContent" value="false"/>
<c:if test="${!empty param.miniCartContent}">
    <c:set var="miniCartContent" value="${param.miniCartContent}"/>
</c:if>
<c:set var="enableToLoad" value="true"/>
<c:if test="${!empty param.enableToLoad}">
    <c:set var="enableToLoad" value="${param.enableToLoad}"/>
</c:if>

<c:set var="ariaMessage">
    <fmt:message bundle="${storeText}" key="ACCE_Status_Shopping_Cart_Content_Updated"/>
</c:set>

<c:set var="miniCartAttributes" value="wcType='RefreshArea' refreshurl='' declareFunction='declareMiniShoppingCartRefreshArea()' widgetId='MiniShoppingCart' ariaMessage='${ariaMessage}' ariaLiveId='${ariaMessageNode}' role='region'"/>

<c:if test="${env_useExternalCart}">
    <c:set var="miniCartAttributes" value=""/>
</c:if>

<c:set var="cookieOrderIdKey" value="WC_CartOrderId_${storeId}"/>
<span id="MiniShoppingCart_Label" class="spanacce" aria-hidden="true"><fmt:message bundle="${storeText}" key="ACCE_Region_Shopping_Cart_Content"/></span>
<div id="MiniShoppingCart" ${miniCartAttributes}  aria-labelledby="MiniShoppingCart_Label">
    <%out.flush();%>
        <c:import url = "${env_jspStoreDir}Widgets/MiniShopCartDisplay/MiniShopCartDisplay.jsp" />
    <%out.flush();%>
</div>
<c:if test="${!env_useExternalCart}">
<div id ="MiniShopCartContents" wcType="RefreshArea" refreshurl="" declareFunction="declareMiniShopCartContentsRefreshArea()" widgetId="MiniShopCartContents" aria-labelledby="MiniShoppingCart_Label">
</div>

<script type="text/javascript">
  $(document).ready(function() {
        var passwordForm = document.getElementById("WC_PasswordUpdateForm_div_1");
        var miniCartContent = "<c:out value='${miniCartContent}'/>";
        var enableToLoad = "<c:out value='${enableToLoad}'/>";
        if (miniCartContent == "true" || miniCartContent == true || passwordForm != null){
            $('#MiniShoppingCart').refreshWidget("updateUrl", getAbsoluteURL()+'MiniShopCartDisplayView?storeId=<c:out value="${storeId}"/>&catalogId=<c:out value="${catalogId}"/>&langId=<c:out value="${langId}"/>&miniCartContent=true');
            $('#MiniShopCartContents').refreshWidget("updateUrl", getAbsoluteURL()+'MiniShopCartDisplayView?storeId=<c:out value="${storeId}"/>&catalogId=<c:out value="${catalogId}"/>&langId=<c:out value="${langId}"/>&page_view=dropdown&miniCartContent=true');
        }else{
            $('#MiniShoppingCart').refreshWidget("updateUrl", getAbsoluteURL()+'MiniShopCartDisplayView?storeId=<c:out value="${storeId}"/>&catalogId=<c:out value="${catalogId}"/>&langId=<c:out value="${langId}"/>');
            $('#MiniShopCartContents').refreshWidget("updateUrl", getAbsoluteURL()+'MiniShopCartDisplayView?storeId=<c:out value="${storeId}"/>&catalogId=<c:out value="${catalogId}"/>&langId=<c:out value="${langId}"/>&page_view=dropdown');
        }

        <%-- WC_USERACTIVITY cookies is now set as HttpOnly cookie. So cannot access this cookie in javascript. We will have the extra call to MiniShopCartView on every page for generic user. --%>
        if($('#MiniShoppingCart') != null && !multiSessionEnabled && (enableToLoad == "true" || enableToLoad == true) && passwordForm == null){
            loadMiniCart("<c:out value='${CommandContext.currency}'/>","<c:out value='${langId}'/>");
        }
    });
</script>
</c:if>
<%-- END MiniShopCartDisplayRefresh.jsp --%>