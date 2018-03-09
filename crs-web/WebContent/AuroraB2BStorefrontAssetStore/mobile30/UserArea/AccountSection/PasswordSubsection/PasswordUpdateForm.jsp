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
  * This JSP will display the PasswordUpdate form for the mobile store with the following fields:
  *  - Current password
  *  - New password
  *  - New Verify password
  * If the user password has expired, this page will be displayed after the user logs on to the mobile store.
  *****
--%>

<%-- Start - JSP File Name:  PasswordUpdateForm.jsp --%>

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
            <fmt:message bundle="${storeText}" key="MCHANGE_PASSWORD_TITLE">
                <fmt:param value="${storeName}" />
            </fmt:message>
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
                <div class="page_title left"><fmt:message bundle="${storeText}" key="MCHANGE_PASSWORD_TITLE"/></div>
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
                <p><fmt:message bundle="${storeText}" key="MEXP_PASSWORD_TEXT" /></p>
            </div>
            
            <div id="password_update_information_form" class="item_wrapper">
                <form id="password_update_form" method="post" action="PersonChangeServicePasswordReset">
                    <input type="hidden" name="storeId" value='<c:out value="${WCParam.storeId}" />' id="WC_MPasswordUpdateForm_FormInput_storeId"/>
                    <input type="hidden" name="catalogId" value='<c:out value="${WCParam.catalogId}" />' id="WC_MPasswordUpdateForm_FormInput_catalogId"/>
                    <input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_MPasswordUpdateForm_FormInput_langId"/>
                    <input type="hidden" name="logonId" value='<c:out value="${WCParam.logonId}" />' id="WC_MPasswordUpdateForm_FormInput_logonId"/>
                    <input type="hidden" name="reLogonURL" value="ChangePassword" id="WC_MPasswordUpdateForm_FormInput_reLogonURL"/>
                    <input type="hidden" name="Relogon" value="Update" id="WC_MPasswordUpdateForm_FormInput_Relogon"/>
                    <input type="hidden" name="errorViewName" value="ChangePassword" />
                
                    <input type="hidden" name="fromOrderId" value="*" id="WC_MPasswordUpdateForm_FormInput_fromOrderId"/>
                    <input type="hidden" name="toOrderId" value="." id="WC_MPasswordUpdateForm_FormInput_toOrderId"/>
                    <input type="hidden" name="deleteIfEmpty" value="*" id="WC_MPasswordUpdateForm_FormInput_deleteIfEmpty" />
                    <input type="hidden" name="continue" value="1" id="WC_MPasswordUpdateForm_FormInput_continue" />
                    <input type="hidden" name="createIfEmpty" value="1" id="WC_MPasswordUpdateForm_FormInput_createIfEmpty" />
                    <%-- the parameter 'calculationUsageId' and 'updatePrices' are used by the OrderCalculate command --%>
                    <input type="hidden" name="calculationUsageId" value="-1" id="WC_MPasswordUpdateForm_FormInput_calculationUsageId" />
                    <input type="hidden" name="updatePrices" value="1" id="WC_MPasswordUpdateForm_FormInput_updatePrices"/>
                    <input type="hidden" name="URL" value="m30MyAccountDisplay" id="WC_MPasswordUpdateForm_FormInput_URL"/>
                    <input type="hidden" name="myAcctMain" value="1" id="WC_MPasswordUpdateForm_FormInput_myAcctMain"/>
					<input type="hidden" name="authToken" value="${authToken}"  id="WC_MPasswordUpdateForm_FormInput_authToken"/>
                
                    <fieldset>
                        <div><label for="WC_MPasswordUpdateForm_FormInput_logonPasswordOld"><fmt:message bundle="${storeText}" key="MCURRENT_PASSWORD"/></label></div>
                        <input type="password" id="WC_MPasswordUpdateForm_FormInput_logonPasswordOld" name="logonPasswordOld" class="inputfield input_width_standard" value=""/>        
                        <div class="item_spacer"></div>
                        
                        <div><label for="WC_MPasswordUpdateForm_FormInput_logonPassword"><fmt:message bundle="${storeText}" key="MUSREG_PASSWORD1"/></label></div>
                        <input type="password" id="WC_MPasswordUpdateForm_FormInput_logonPassword" name="logonPassword" class="inputfield input_width_standard" value=""/>      
                        <div class="item_spacer"></div>
                        
                        <div><label for="WC_MPasswordUpdateForm_FormInput_logonPasswordVerify"><fmt:message bundle="${storeText}" key="MUSREG_VPASSWORD"/></label></div>
                        <input type="password" id="WC_MPasswordUpdateForm_FormInput_logonPasswordVerify" name="logonPasswordVerify" class="inputfield input_width_standard" value=""/>      
                        <div class="item_spacer_10px"></div>

                        <div class="single_button_container">
                            <input type="submit" id="password_update_form_submit" name="password_update_form_submit" value="<fmt:message bundle="${storeText}" key="MUSREGU_UPDATE"/>" class="primary_button button_half" />
                        </div>
                        <div class="item_spacer_5px"></div>
                    </fieldset>
                </form>
            </div>
            
            <%@ include file="../../../include/FooterDisplay.jspf" %>                       
        </div>
    <%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END PasswordUpdateForm.jsp -->
