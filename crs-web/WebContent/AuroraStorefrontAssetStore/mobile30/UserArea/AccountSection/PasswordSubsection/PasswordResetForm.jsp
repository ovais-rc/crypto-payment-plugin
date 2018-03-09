<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays the Forgot your password form
  *****
--%>

<!-- BEGIN PasswordResetForm.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
    <head>
        <title>
            <fmt:message bundle="${storeText}" key="FYP_TITLE"/>
        </title>
        <meta name="viewport" content="${viewport}" />
        <link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

        <%@ include file="../../../include/CommonAssetsForHeader.jspf" %>
    </head> 
    <body>
        <div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
            <%@ include file="../../../include/HeaderDisplay.jspf" %>
            
            <!-- Start Breadcrumb Bar -->
            <div id="breadcrumb" class="item_wrapper_gradient">
                <a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
                    <div class="arrow_icon"></div>
                </div></a>
                <div class="page_title left"><fmt:message bundle="${storeText}" key="FYP_TITLE"/></div>
                <div class="clear_float"></div>
            </div>
            <!-- End Breadcrumb Bar -->

            <!-- Start Notification Container -->
            <c:if test="${!empty errorMessage}">
                <div id="notification_container" class="item_wrapper notification" style="display:block">
                    <p class="error"><c:out value="${errorMessage}"/></p>
                </div>
            </c:if>
            <!--End Notification Container -->
            
            <div class="item_wrapper item_wrapper_gradient">
                <p>
                    <fmt:message bundle="${storeText}" key="FYP_TEXT1">
                    <wcf:url var="RegisterURL" value="UserRegistrationForm">
                        <wcf:param name="langId" value="${langId}" />
                        <wcf:param name="storeId" value="${WCParam.storeId}" />
                        <wcf:param name="catalogId" value="${WCParam.catalogId}" />
                        <wcf:param name="myAcctMain" value="1" />
                        <wcf:param name="registerNew" value="Y" />
                    </wcf:url>
                
                <c:set var="regURL">
                    <c:out value="${RegisterURL}" />
                </c:set>
                        <fmt:param value="${regURL}" />
                    </fmt:message>
                </p>
            </div>

            <div id="forgot_your_password" class="item_wrapper"> 
                
                    
                <form id="forgot_your_password_form" method="post" action="PersonChangeServicePasswordReset">
                    <input type="hidden" name="challengeAnswer" value="-" />
                    <input type="hidden" name="storeId" value='<c:out value="${WCParam.storeId}" />' />
                    <input type="hidden" name="catalogId" value='<c:out value="${WCParam.catalogId}" />' />
                    <input type="hidden" name="langId" value='<c:out value="${langId}" />' />
                    <input type="hidden" name="state" value="passwdconfirm" />
                    <input type="hidden" name="URL" value="ResetPasswordForm" />
                    <input type="hidden" name="errorViewName" value="ResetPasswordGuestErrorView" />
					<input type="hidden" name="authToken" value="${authToken}" />
                    
                    <fieldset> 
                        <label for="logon_id"><div><fmt:message bundle="${storeText}" key="FYP_LOGON_ID"/></div></label>
                        <input type="text" id="logon_id" name="logonId" class="inputfield input_width_standard" placeholder="<fmt:message bundle="${storeText}" key="LOGON_ID"/>"/> 
                        <div class="item_spacer"></div>

                        <div class="single_button_container">
                            <input type="submit" id="send_password" name="send_password" class="primary_button button_half_more" value="<fmt:message bundle="${storeText}" key="FYP_SEND_PASSWORD"/>" />                      
                        </div>
                        <div class="clear_float"></div>
                    </fieldset> 
                </form> 
            </div> 
                            
            <%@ include file="../../../include/FooterDisplay.jspf" %>                       
        </div>
    <%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END PasswordResetForm.jsp -->
