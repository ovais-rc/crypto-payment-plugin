
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<wcf:url var="couponWalletTableView" value="CouponWalletTableView" type="Ajax">
    <wcf:param name="storeId"   value="${WCParam.storeId}"  />
    <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
    <wcf:param name="langId" value="${langId}" />
</wcf:url>
<fmt:message bundle="${storeText}" key="MO_MA_MYCOUPONS" var="contentPageName" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN CouponWalletDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
    <%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><fmt:message bundle="${storeText}" key="MYACCOUNT_MY_COUPONS"/></title>
    <%@ include file="../../../Common/CommonJSToInclude.jspf"%>

    <script type="text/javascript">
        MyAccountServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
    </script>

    <%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
</head>
<body>

<!-- Page Start -->
<div id="page" class="nonRWDPage">
    <!-- Import Header Widget -->
    <div class="header_wrapper_position" id="headerWidget">
        <%out.flush();%>
        <c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
        <%out.flush();%>
    </div>
    <!-- Header Nav End -->

    <!-- Main Content Start -->
    <div id="contentWrapper">
        <div id="content" role="main">
            <div class="row margin-true">
                <div class="col12">
                    <%out.flush();%>
                        <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">
                            <wcpgl:param name="pageGroup" value="Content"/>
                        </wcpgl:widgetImport>
                    <%out.flush();%>
                </div>
            </div>
            <div class="rowContainer" id="container_MyAccountDisplayB2B">
                <div class="row margin-true">
                    <div class="col4 acol12 ccol3">
                        <%out.flush();%>
                            <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
                        <%out.flush();%>
                    </div>
                    <div class="col8 acol12 ccol9 right">
                        <div id="box" class="myAccountMarginRight">
                            <div class="left" id="WC_AccountForm_div_1">
                                <%--
                                ***
                                *   Start: Error handling
                                * Show an appropriate error message when a user enters invalid information into the form.
                                ***
                                --%>

                                <c:if test="${!empty errorMessage}">
                                    <c:out value="${errorMessage}"/><br /><br />
                                </c:if>
                                <%--
                                ***
                                *   End: Error handling
                                ***
                                --%>
                            </div>
                            <div class="my_account" id="WC_NonAjaxCouponWalletDisplay_div_1">
                                <h2 class="myaccount_header bottom_line"><fmt:message bundle="${storeText}" key='MYACCOUNT_MY_COUPONS'/></h2>

                                <span id="CouponDisplay_Widget_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="MYACCOUNT_MY_COUPONS" /></span>
                                <div class="body left" id="WC_NonAjaxCouponWalletDisplay_div_6">
                                    <div class="couponWalletContainer" id="CouponDisplay_Widget" refreshurl="<c:out value='${couponWalletTableView}'/>" wcType="RefreshArea" declareFunction="CommonControllersDeclarationJS.declareAccountCouponRefreshArea" role="region" aria-labelledby="CouponDisplay_Widget_ACCE_Label">
                                        <%out.flush();%>
                                        <c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/CouponWalletTable.jsp">
                                            <c:param name="returnView" value="${couponWalletTableView}" />
                                        </c:import>
                                        <%out.flush();%>
                                    </div>
                                    <br/>
                                    <br clear="all" />
                                </div>
                                <div class="footer" id="WC_NonAjaxCouponWalletDisplay_div_7">
                                    <div class="left_corner" id="WC_NonAjaxCouponWalletDisplay_div_8"></div>
                                    <div class="tile" id="WC_NonAjaxCouponWalletDisplay_div_9"></div>
                                    <div class="right_corner" id="WC_NonAjaxCouponWalletDisplay_div_10"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Main Content End -->

    <!-- Footer Start -->
    <div class="footer_wrapper_position">
        <%out.flush();%>
        <c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
        <%out.flush();%>
    </div>
    <!-- Footer End -->
</div>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END CouponWalletDisplay.jsp -->
