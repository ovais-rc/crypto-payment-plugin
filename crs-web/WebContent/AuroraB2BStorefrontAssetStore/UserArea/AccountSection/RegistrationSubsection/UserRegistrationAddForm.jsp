
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="pageCategory" value="MyAccount" scope="request"/>

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
<!-- BEGIN UserRegistrationAddForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
    <%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><fmt:message bundle="${storeText}" key="REGISTER_TITLE"/></title>

    <%@ include file="../../../Common/CommonJSToInclude.jspf"%>

    <script type="text/javascript">
        $(document).ready(function() {
            ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');

            MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", Utils.getLocalizationMessage('PWDREENTER_DO_NOT_MATCH'));
            MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", Utils.getLocalizationMessage('WISHLIST_INVALIDEMAILFORMAT'));
//             MessageHelper.setMessage("REQUIRED_FIELD_ENTER", Utils.getLocalizationMessage('REQUIRED_FIELD_ENTER'));
            MessageHelper.setMessage("ERROR_INVALIDPHONE", Utils.getLocalizationMessage('ERROR_INVALIDPHONE'));
            MessageHelper.setMessage("ERROR_LastNameEmpty", Utils.getLocalizationMessage('ERROR_LastNameEmpty'));
            MessageHelper.setMessage("ERROR_AddressEmpty", Utils.getLocalizationMessage('ERROR_AddressEmpty'));
            MessageHelper.setMessage("ERROR_CityEmpty", Utils.getLocalizationMessage('ERROR_CityEmpty'));
            MessageHelper.setMessage("ERROR_StateEmpty", Utils.getLocalizationMessage('ERROR_StateEmpty'));
            MessageHelper.setMessage("ERROR_CountryEmpty", Utils.getLocalizationMessage('ERROR_CountryEmpty'));
            MessageHelper.setMessage("ERROR_ZipCodeEmpty", Utils.getLocalizationMessage('ERROR_ZipCodeEmpty'));
            MessageHelper.setMessage("ERROR_EmailEmpty", Utils.getLocalizationMessage('ERROR_EmailEmpty'));
            MessageHelper.setMessage("ERROR_LogonIdEmpty", Utils.getLocalizationMessage('ERROR_LogonIdEmpty'));
            MessageHelper.setMessage("ERROR_PasswordEmpty", Utils.getLocalizationMessage('ERROR_PasswordEmpty'));
            MessageHelper.setMessage("ERROR_VerifyPasswordEmpty", Utils.getLocalizationMessage('ERROR_VerifyPasswordEmpty'));
//             MessageHelper.setMessage("ERROR_MESSAGE_TYPE", Utils.getLocalizationMessage('ERROR_MESSAGE_TYPE'));
            MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", Utils.getLocalizationMessage('ERROR_INVALIDEMAILFORMAT'));
            MessageHelper.setMessage("ERROR_FirstNameEmpty", Utils.getLocalizationMessage('ERROR_FirstNameEmpty'));
            MessageHelper.setMessage("ERROR_FirstNameTooLong", Utils.getLocalizationMessage('ERROR_FirstNameTooLong'));
            MessageHelper.setMessage("ERROR_LastNameTooLong", Utils.getLocalizationMessage('ERROR_LastNameTooLong'));
            MessageHelper.setMessage("ERROR_AddressTooLong", Utils.getLocalizationMessage('ERROR_AddressTooLong'));
            MessageHelper.setMessage("ERROR_CityTooLong", Utils.getLocalizationMessage('ERROR_CityTooLong'));
            MessageHelper.setMessage("ERROR_StateTooLong", Utils.getLocalizationMessage('ERROR_StateTooLong'));
            MessageHelper.setMessage("ERROR_CountryTooLong", Utils.getLocalizationMessage('ERROR_CountryTooLong'));
            MessageHelper.setMessage("ERROR_ZipCodeTooLong", Utils.getLocalizationMessage('ERROR_ZipCodeTooLong'));
            MessageHelper.setMessage("ERROR_EmailTooLong", Utils.getLocalizationMessage('ERROR_EmailTooLong'));
            MessageHelper.setMessage("ERROR_PhoneTooLong", Utils.getLocalizationMessage('ERROR_PhoneTooLong'));
            MessageHelper.setMessage("ERROR_SpecifyYear", Utils.getLocalizationMessage('ERROR_SpecifyYear'));
            MessageHelper.setMessage("ERROR_SpecifyMonth", Utils.getLocalizationMessage('ERROR_SpecifyMonth'));
            MessageHelper.setMessage("ERROR_SpecifyDate", Utils.getLocalizationMessage('ERROR_SpecifyDate'));
            MessageHelper.setMessage("ERROR_InvalidDate1", Utils.getLocalizationMessage('ERROR_InvalidDate1'));
            MessageHelper.setMessage("ERROR_InvalidDate2", Utils.getLocalizationMessage('ERROR_InvalidDate2'));
//             MessageHelper.setMessage("ERROR_MOBILE_PHONE_EMPTY", Utils.getLocalizationMessage('ERROR_MOBILE_PHONE_EMPTY'));
            MessageHelper.setMessage("AGE_WARNING_ALERT", Utils.getLocalizationMessage('AGE_WARNING_ALERT'));
            MessageHelper.setMessage("ERROR_OrgNameEmpty", Utils.getLocalizationMessage('ERROR_OrgNameEmpty'));
            MessageHelper.setMessage("ERROR_DefaultOrgRegistration", Utils.getLocalizationMessage('ERROR_DefaultOrgRegistration'));
        });

    </script>
    <script type="text/javascript">
        function popupWindow(URL) {
            window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
        }
    </script>

    <%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

</head>


<wcf:url var="MyAccountURL" value="AjaxLogonForm" type="Ajax">
    <wcf:param name="langId" value="${langId}" />
    <wcf:param name="storeId" value="${WCParam.storeId}" />
    <wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<c:set var="actionURL" value="UserRegistrationAdd" scope="request" />

<body>

<!-- Page Start -->
<div id="page">

    <%--
      ***
      * If an error occurs, the page will refresh and the entry fields will be pre-filled with the previously entered value.
      * The entry fields below use e.g. paramSource.logonId to get the previously entered value.
      * In this case, the paramSource is set to WCParam.
      ***
    --%>
    <c:set var="paramSource" value="${WCParam}"/>

    <c:set var="person" value="${requestScope.person}"/>
    <c:if test="${empty person || person==null}">
        <wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
            <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
        </wcf:rest>
    </c:if>
    <!-- Main Content Start -->

    <!-- Import Header Widget -->
    <div class="header_wrapper_position" id="headerWidget">
        <%out.flush();%>
        <c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
        <%out.flush();%>
    </div>
    <!-- Header Nav End -->

    <!-- Content Start -->
    <div class="content_wrapper_position" role="main">
        <div class="content_wrapper">
            <div class="content_left_shadow">
                <div class="content_right_shadow">
                    <div class="main_content">
                        <div class="container_full_width">
                            <%out.flush();%>
                            <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url = "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RegistrationForm/RegistrationForm.jsp" />
                            <%out.flush();%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Content End -->

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

<!-- END UserRegistrationAddForm.jsp -->
