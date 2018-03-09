<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays the user registration add page for the mobile store front. 
  *****
--%>

<!-- BEGIN UserRegistrationAddForm.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<%@ include file="./MandatoryUserRegistrationFields.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MUSER_REG"/>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="MUSER_REG"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty errorMessage}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><c:out value="${errorMessage}" /></p>
					</div>
				</c:when>	
				<c:otherwise>
					<c:if test="${!empty storeError.key}">
						<div id="notification_container" class="item_wrapper notification" style="display:block">
							<p class="error"><c:out value="${storeError.key}"/></p>
						</div>
					</c:if>
				</c:otherwise>
			</c:choose>	
			<!--End Notification Container -->
			
			<!-- Begin Register -->
			<div class="item_wrapper item_wrapper_gradient">
				<p><fmt:message bundle="${storeText}" key="MUSREG_CREATE_MSG1"/><span class="required">*</span><fmt:message bundle="${storeText}" key="MUSREG_CREATE_MSG2"/></p>
			</div>

			<div id="register" class="item_wrapper">
				<form id="register_form" method="post" action="UserRegistrationAdd">
					<input type="hidden" name="new" value="Y" id="WC_MUserRegistrationAddForm_FormInput_new" />
					<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />" id="WC_MUserRegistrationAddForm_FormInput_storeId" />
					<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />" id="WC_MUserRegistrationAddForm_FormInput_catalogId" />
					<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_MUserRegistrationAddForm__FormInput_langId" />
					<input type="hidden" name="URL" value="m30MyAccountDisplay" id="WC_MUserRegistrationAddForm_FormInput_URL" />
					<input type="hidden" name="errorViewName" value="UserRegistrationAddForm" id="WC_MUserRegistrationAddForm_FormInput_errorViewName" />              

					<input type="hidden" name="registerType" value="G" id="WC_MUserRegistrationAddForm_FormInput_registerType" />
					<input type="hidden" name="profileType" value="B" id="WC_MUserRegistrationAddForm_FormInput_profileType" />
					<%-- The challenge answer and question are necessary for the forget password feature. Therefore, they are set to "-" here.	--%>
					<input type="hidden" name="challengeQuestion" value="-" id="WC_MUserRegistrationAddForm_FormInput_challengeQuestion" />
					<input type="hidden" name="challengeAnswer" value="-" id="WC_MUserRegistrationAddForm_FormInput_challengeAnswer" />
				
					<input type="hidden" name="addressType" value="SB" id="WC_MUserRegistrationAddForm_FormInput_addressType" />
					<input type="hidden" name="primary" value="true" id="WC_MUserRegistrationAddForm_FormInput_primary" />
					
					<input type="hidden" name="authToken" value="${authToken}" id="WC_MUserRegistrationAddForm_FormInput_authToken"/>
					<input type="hidden" name="isBuyerUser" value="true" id="WC_UserRegistrationAddForm_FormInput_isBuyerUser"/>

					<%@ include file="UserRegistrationAddDefaults.jspf"%>
					
					<%--
					  ***
					  * If an error occurs, the page will refresh and the entry fields will be pre-filled with the previously entered value.
					  * The entry fields below use e.g. paramSource.logonId to get the previously entered value.
					  * In this case, the paramSource is set to WCParam.  
					  ***
					--%>
					<c:set var="paramSource" value="${WCParam}"/>

					<fieldset>
						<div><label for="WC_MUserRegistrationAddForm_FormInput_logonId"><c:if test="${fn:contains(mandatoryFields, 'logonId')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_LOGONID"/></label></div>
						<input type="text" id="WC_MUserRegistrationAddForm_FormInput_logonId" name="logonId" value="<c:out value="${paramSource.logonId}" />" class="inputfield input_width_standard" />	
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationAddForm_FormInput_logonPassword"><c:if test="${fn:contains(mandatoryFields, 'logonPassword')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_PASSWORD1"/> <span class="small_text"><fmt:message bundle="${storeText}" key="MUSREG_PASSWORD2"/></span></label></div>
						<input type="password" id="WC_MUserRegistrationAddForm_FormInput_logonPassword" name="logonPassword" value="<c:out value="${paramSource.logonPassword}" />" class="inputfield input_width_standard" />		
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationAddForm_FormInput_logonPasswordVerify"><c:if test="${fn:contains(mandatoryFields, 'logonPasswordVerify')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_VPASSWORD"/></label></div>
						<input type="password" id="WC_MUserRegistrationAddForm_FormInput_logonPasswordVerify" name="logonPasswordVerify" value="<c:out value="${paramSource.logonPasswordVerify}" />" class="inputfield input_width_standard" />	
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationAddForm_FormInput_firstName"><c:if test="${fn:contains(mandatoryFields, 'firstName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_FNAME"/></label></div>
						<input type="text" id="WC_MUserRegistrationAddForm_FormInput_firstName" name="firstName" value="<c:out value="${paramSource.firstName}" />" class="inputfield input_width_standard" />	
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationAddForm_FormInput_lastName"><c:if test="${fn:contains(mandatoryFields, 'lastName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_LNAME"/></label></div>
						<input type="text" id="WC_MUserRegistrationAddForm_FormInput_lastName" name="lastName" value="<c:out value="${paramSource.lastName}" />" class="inputfield input_width_standard" />	
						<div class="item_spacer"></div>
												
						<div><label for="WC_MUserRegistrationAddForm_FormInput_email1"><c:if test="${fn:contains(mandatoryFields, 'email1')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_EMAIL"/></label></div>
						<input type="email" id="WC_MUserRegistrationAddForm_FormInput_email1" name="email1" value="<c:out value="${paramSource.email1}" />" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div class="single_button_container">
							<input type="submit" id="submit_registration" name="submit_registration" value="<fmt:message bundle="${storeText}" key="MUSREG_SUBMIT"/>" class="primary_button button_half" />
						</div>

					</fieldset>
				</form>
			</div>
			<!-- End Register -->
		
			<%@ include file="../../../include/FooterDisplay.jspf" %>						
			
		</div>
	<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END UserRegistrationAddForm.jsp -->
