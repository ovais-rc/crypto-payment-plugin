<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>

<c:set var="addtionalBCT" scope="request"><fmt:message bundle="${storeText}" key="CUSTOMER_SERVICE"/></c:set>
<wcf:url var="additionalBCT_URL" value="CustomerServiceLandingPageView" scope="request">
    <wcf:param name="langId" value="${param.langId}" />
    <wcf:param name="storeId" value="${param.storeId}" />
    <wcf:param name="catalogId" value="${param.catalogId}" />
</wcf:url>
<fmt:message bundle="${storeText}" key="FIND_CUSTOMERS_CSR" var="contentPageName" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<flow:ifEnabled feature="on-behalf-of-csr">
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
    xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
    <head>
        <%@ include file="../Common/CommonCSSToInclude.jspf"%>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>${contentPageName}</title>

        <!-- Include script files -->
        <%@ include file="../Common/CommonJSToInclude.jspf"%>
    </head>

    <body>
        <!-- Page Start -->
        <div id="page">
            <%@ include file="../Common/CommonJSPFToInclude.jspf"%>
            <div id="wrapper" class="ucp_active">
                <div class="highlight">
                    <!-- Header Widget -->
                    <div id="headerWrapper">
                        <%out.flush();%> <c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" /> <%out.flush();%>
                    </div>
                </div>
            </div>
            <!-- Main Content Start -->
            <div id="contentWrapper">
                <div id="content" role="main">
                    <div class="rowContainer" id="container_orgUserList_detail">
                        <div class="row margin-true">
                            <!-- breadcrumb -->
                            <%out.flush();%>
                                <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">
                                    <wcpgl:param name="pageGroup" value="Content" />
                                </wcpgl:widgetImport>
                            <%out.flush();%>
                            <div class="col12"></div>
                        </div>

                        <div class="row margin-true">
                            <!-- Left Nav -->
                            <div class="col4 acol12 ccol3">
                                <%out.flush();%>
                                    <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.CustomerServiceNavigation/CustomerServiceNavigation.jsp"/>
                                <%out.flush();%>
                            </div>

                            <!-- Content area -->
                            <div class="col8 acol12 ccol9 right">
                                <div id="RegisteredCustomersPageHeading" tabindex="0">
                                    <h1 style="padding: 0px 0px;"><fmt:message key="FIND_CUSTOMERS_CSR" bundle="${storeText}"/></h1>
                                    <span id="errorMessage_section" style="display:none"></span>
                                </div>
                                <div id="RegisteredCustomersSearch_table" class="listTable findOrderlistTable" role="grid" aria-labelledby="registeredCustomerSearchResults_table_summary" tabindex="0">
                                    <%-- This is the hidden table summary used for Accessibility TODO --%>
                                    <div id="registeredCustomerSearchResults_table_summary" class="nodisplay" aria-hidden="true">
                                        <fmt:message key="REGISTERED_CUSTOMER_SEARCH_RESULTS_TABLE_SUMMARY" bundle="${storeText}"/>
                                    </div>
                                    <div class="row">
                                        <div class="col12">
                                            <%out.flush();%>
                                            <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.RegisteredCustomers/RegisteredCustomersSearch.jsp"/>
                                            <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.RegisteredCustomers/RegisteredCustomersList.jsp"/>
                                            <%out.flush();%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Footer Widget -->
                    <div class="highlight">
                        <div id="footerWrapper">
                            <%out.flush();%> <c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/> <%out.flush();%>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Main Content End -->

            <flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
            <%@ include file="../Common/JSPFExtToInclude.jspf"%>
        </div>
    </body>
</html>
</flow:ifEnabled>
