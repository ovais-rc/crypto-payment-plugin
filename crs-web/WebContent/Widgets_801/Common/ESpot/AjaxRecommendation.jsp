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

<!-- BEGIN AjaxRecommendation.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>

<%--
    When an eSpot results in a dynamic rule, an Ajax request is created. The Ajax request 
    directs to this JSP that simply includes the corresponding recommendation widget/eSpot JSP.
--%>
<c:set var="returnUrl" value="" />
<c:choose>
    <c:when test="${WCParam.recommendationType == 'content'}">
        <c:set var="returnUrl" value="/Widgets_801/com.ibm.commerce.store.widgets.ContentRecommendation/ContentRecommendation.jsp" />
    </c:when>
    <c:when test="${WCParam.recommendationType == 'catalogEntry'}">
        <c:set var="returnUrl" value="/Widgets_801/com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp" />
    </c:when>
    <c:when test="${WCParam.recommendationType == 'category'}">
        <c:set var="returnUrl" value="/Widgets_801/com.ibm.commerce.store.widgets.CategoryRecommendation/CategoryRecommendation.jsp" />
    </c:when>
    <c:when test="${WCParam.recommendationType == 'espot'}">
        <c:set var="returnUrl" value="/Widgets_801/com.ibm.commerce.store.widgets.EMarketingSpot/EMarketingSpot.jsp" />
    </c:when>
    <c:otherwise>
        <c:out value="Unrecognized widget type - ${WCParam.recommendationType}"/>
    </c:otherwise>
</c:choose>

<%out.flush();%>
<c:import url="${returnUrl}">
    <c:param name="emsName" value="${WCParam.emsName}" /> 
    <c:param name="catalogId" value="${WCParam.catalogId}" />
    <c:param name="storeId" value="${WCParam.storeId}"/>
    <c:param name="categoryId" value="${WCParam.categoryId}" />
    <c:param name="langId" value="${WCParam.langId}"/>
    <c:param name="urlLangId" value="${WCParam.urlLangId}" />
    <c:param name="dontCreateRefreshArea" value="true"/>
</c:import>
<%out.flush();%>

<!-- END AjaxRecommendation.jsp -->
