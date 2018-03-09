<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>
<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<fmt:message var="addtionalBCT" bundle="${storeText}" key="MA_MYADDRESS_BOOK" scope="request"/>
<wcf:url var="additionalBCT_URL" value="AddressBookForm" scope="request">
    <wcf:param name="storeId" value="${WCParam.storeId}" />
    <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
    <wcf:param name="langId" value="${langId}" />
</wcf:url>

<fmt:message bundle="${storeText}" key="MA_CREATE_ADDRESS" var="contentPageName" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN AccountAddressForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
    <%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><fmt:message bundle="${storeText}" key="ADDRESSBOOKCREATE_TITLE"/></title>

    <%@ include file="../../../Common/CommonJSToInclude.jspf"%>
    <%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

    <script type="text/javascript">
        //messages used by AddressBookForm.js
        $(document).ready( function() {
            <fmt:message bundle="${storeText}" key="ERROR_RecipientTooLong" var="ERROR_RecipientTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_MiddleNameTooLong" var="ERROR_MiddleNameTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_AddressTooLong" var="ERROR_AddressTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_CityTooLong" var="ERROR_CityTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_StateTooLong" var="ERROR_StateTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_CountryTooLong" var="ERROR_CountryTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong"/>
            <fmt:message bundle="${storeText}" key="ERROR_RecipientEmpty" var="ERROR_RecipientEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_FirstNameEmpty" var="ERROR_FirstNameEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_LastNameEmpty" var="ERROR_LastNameEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_MiddleNameEmpty" var="ERROR_MiddleNameEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_AddressEmpty" var="ERROR_AddressEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_CityEmpty" var="ERROR_CityEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_StateEmpty" var="ERROR_StateEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_CountryEmpty" var="ERROR_CountryEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_ZipCodeEmpty" var="ERROR_ZipCodeEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_PhonenumberEmpty" var="ERROR_PhonenumberEmpty"/>
            <fmt:message bundle="${storeText}" key="ERROR_EmailEmpty" var="ERROR_EmailEmpty"/>
            <fmt:message bundle="${storeText}" key="PWDREENTER_DO_NOT_MATCH" var="PWDREENTER_DO_NOT_MATCH"/>
            <fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
            <fmt:message bundle="${storeText}" key="AB_UPDATE_SUCCESS" var="AB_UPDATE_SUCCESS"/>
            <fmt:message bundle="${storeText}" key="AB_DELETE_SUCCESS" var="AB_DELETE_SUCCESS"/>
            <fmt:message bundle="${storeText}" key="AB_ADDNEW_SUCCESS" var="AB_ADDNEW_SUCCESS"/>
            <fmt:message bundle="${storeText}" key="WISHLIST_INVALIDEMAILFORMAT" var="WISHLIST_INVALIDEMAILFORMAT"/>
            <fmt:message bundle="${storeText}" key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE"/>
            <fmt:message bundle="${storeText}" key="AB_SELECT_ADDRTYPE" var="AB_SELECT_ADDRTYPE"/>
            <fmt:message bundle="${storeText}" key="ERROR_DEFAULTADDRESS" var="ERROR_DEFAULTADDRESS"/>
            <fmt:message bundle="${storeText}" key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>

            MessageHelper.setMessage("ERROR_RecipientTooLong", <wcf:json object="${ERROR_RecipientTooLong}"/>);
            MessageHelper.setMessage("ERROR_FirstNameTooLong", <wcf:json object="${ERROR_FirstNameTooLong}"/>);
            MessageHelper.setMessage("ERROR_LastNameTooLong", <wcf:json object="${ERROR_LastNameTooLong}"/>);
            MessageHelper.setMessage("ERROR_MiddleNameTooLong", <wcf:json object="${ERROR_MiddleNameTooLong}"/>);
            MessageHelper.setMessage("ERROR_AddressTooLong", <wcf:json object="${ERROR_AddressTooLong}"/>);
            MessageHelper.setMessage("ERROR_CityTooLong", <wcf:json object="${ERROR_CityTooLong}"/>);
            MessageHelper.setMessage("ERROR_StateTooLong", <wcf:json object="${ERROR_StateTooLong}"/>);
            MessageHelper.setMessage("ERROR_CountryTooLong", <wcf:json object="${ERROR_CountryTooLong}"/>);
            MessageHelper.setMessage("ERROR_ZipCodeTooLong", <wcf:json object="${ERROR_ZipCodeTooLong}"/>);
            MessageHelper.setMessage("ERROR_PhoneTooLong", <wcf:json object="${ERROR_PhoneTooLong}"/>);
            MessageHelper.setMessage("ERROR_RecipientEmpty", <wcf:json object="${ERROR_RecipientEmpty}"/>);
            /*Although for English, firstname is not mandatory. But it is mandatory for other languages.*/
            MessageHelper.setMessage("ERROR_FirstNameEmpty", <wcf:json object="${ERROR_FirstNameEmpty}"/>);
            MessageHelper.setMessage("ERROR_LastNameEmpty", <wcf:json object="${ERROR_LastNameEmpty}"/>);
            MessageHelper.setMessage("ERROR_MiddleNameEmpty", <wcf:json object="${ERROR_MiddleNameEmpty}"/>);
            MessageHelper.setMessage("ERROR_AddressEmpty", <wcf:json object="${ERROR_AddressEmpty}"/>);
            MessageHelper.setMessage("ERROR_CityEmpty", <wcf:json object="${ERROR_CityEmpty}"/>);
            MessageHelper.setMessage("ERROR_StateEmpty", <wcf:json object="${ERROR_StateEmpty}"/>);
            MessageHelper.setMessage("ERROR_CountryEmpty", <wcf:json object="${ERROR_CountryEmpty}"/>);
            MessageHelper.setMessage("ERROR_ZipCodeEmpty", <wcf:json object="${ERROR_ZipCodeEmpty}"/>);
            MessageHelper.setMessage("ERROR_PhonenumberEmpty", <wcf:json object="${ERROR_PhonenumberEmpty}"/>);
            MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
            MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", <wcf:json object="${PWDREENTER_DO_NOT_MATCH}"/>);
            MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
            MessageHelper.setMessage("AB_UPDATE_SUCCESS", <wcf:json object="${AB_UPDATE_SUCCESS}"/>);
            MessageHelper.setMessage("AB_DELETE_SUCCESS", <wcf:json object="${AB_DELETE_SUCCESS}"/>);
            MessageHelper.setMessage("AB_ADDNEW_SUCCESS", <wcf:json object="${AB_ADDNEW_SUCCESS}"/>);
            MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", <wcf:json object="${WISHLIST_INVALIDEMAILFORMAT}"/>);
            MessageHelper.setMessage("ERROR_INVALIDPHONE", <wcf:json object="${ERROR_INVALIDPHONE}"/>);
            MessageHelper.setMessage("AB_SELECT_ADDRTYPE", <wcf:json object="${AB_SELECT_ADDRTYPE}"/>);
            MessageHelper.setMessage("ERROR_DEFAULTADDRESS", <wcf:json object="${ERROR_DEFAULTADDRESS}"/>);
            MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);

            AddressBookFormJS.setCommonParameters("<c:out value='${langId}'/>", "<c:out value='${WCParam.storeId}'/>","<c:out value='${WCParam.catalogId}'/>");
        });

    </script>
</head>
<body>

<div id="page">
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
                            <wcpgl:param name="doNotCacheForMyAccount" value="true"/>
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
                        <!-- Main Content Start -->
                        <div><h1><fmt:message bundle="${storeText}" key="ADDRESSBOOKCREATE_TITLE" /></h1></div>

                        <%out.flush();%>
                            <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.AddressBookList/AddressBookList.jsp">
                                <wcpgl:param name="storeId" value="${WCParam.storeId}"/>
                                <wcpgl:param name="catalogId" value="${WCParam.catalogId}"/>
                                <wcpgl:param name="langId" value="${langId}"/>
                                <wcpgl:param name="type" value="add"/>
                                <wcpgl:param name="pageName" value="AccountForm"/>
                            </wcpgl:widgetImport>
                        <%out.flush();%>
                        <!-- Main Content End -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="overlay" class="nodisplay"></div>
    <!-- Main Content End -->

    <!-- Footer Start -->
    <div class="footer_wrapper_position">
        <%out.flush();%>
            <c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
        <%out.flush();%>
    </div>
    <!-- Footer End -->

</div><!-- end class="page" -->

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END AccountAddressForm.jsp -->
