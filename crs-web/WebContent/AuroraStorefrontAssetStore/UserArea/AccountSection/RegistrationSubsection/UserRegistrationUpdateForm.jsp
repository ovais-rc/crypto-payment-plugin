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
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<fmt:message bundle="${storeText}" key="MA_PERSONAL_INFO" var="contentPageName" scope="request"/>
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
<!-- BEGIN UserRegistrationUpdateForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="MA_PERSONAL_INFO"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">  
		$(document).ready(function() { 
			//messages used by AddressBookForm.js
			<fmt:message bundle="${storeText}" key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_MiddleNameTooLong" var="ERROR_MiddleNameTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_AddressTooLong" var="ERROR_AddressTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_CityTooLong" var="ERROR_CityTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_StateTooLong" var="ERROR_StateTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_CountryTooLong" var="ERROR_CountryTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong"/>
			<fmt:message bundle="${storeText}" key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong"/>
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
			<fmt:message bundle="${storeText}" key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE"/>
			<fmt:message bundle="${storeText}" key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
			<fmt:message bundle="${storeText}" key="PWDREENTER_DO_NOT_MATCH" var="PWDREENTER_DO_NOT_MATCH"/>
			<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
			<fmt:message bundle="${storeText}" key="ERROR_SpecifyYear" var="ERROR_SpecifyYear"/>
			<fmt:message bundle="${storeText}" key="ERROR_SpecifyMonth" var="ERROR_SpecifyMonth"/>
			<fmt:message bundle="${storeText}" key="ERROR_SpecifyDate" var="ERROR_SpecifyDate"/>
			<fmt:message bundle="${storeText}" key="ERROR_InvalidDate1" var="ERROR_InvalidDate1"/>
			<fmt:message bundle="${storeText}" key="ERROR_InvalidDate2" var="ERROR_InvalidDate2"/>
		
			MessageHelper.setMessage("ERROR_FirstNameTooLong", <wcf:json object="${ERROR_FirstNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_LastNameTooLong", <wcf:json object="${ERROR_LastNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_MiddleNameTooLong", <wcf:json object="${ERROR_MiddleNameTooLong}"/>);
			MessageHelper.setMessage("ERROR_AddressTooLong", <wcf:json object="${ERROR_AddressTooLong}"/>);
			MessageHelper.setMessage("ERROR_CityTooLong", <wcf:json object="${ERROR_CityTooLong}"/>);
			MessageHelper.setMessage("ERROR_StateTooLong", <wcf:json object="${ERROR_StateTooLong}"/>);
			MessageHelper.setMessage("ERROR_CountryTooLong", <wcf:json object="${ERROR_CountryTooLong}"/>);
			MessageHelper.setMessage("ERROR_ZipCodeTooLong", <wcf:json object="${ERROR_ZipCodeTooLong}"/>);
			MessageHelper.setMessage("ERROR_PhoneTooLong", <wcf:json object="${ERROR_PhoneTooLong}"/>);
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
			MessageHelper.setMessage("ERROR_INVALIDPHONE", <wcf:json object="${ERROR_INVALIDPHONE}"/>);
			MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
		
			MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", <wcf:json object="${PWDREENTER_DO_NOT_MATCH}"/>);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
			
			MessageHelper.setMessage("ERROR_SpecifyYear", <wcf:json object="${ERROR_SpecifyYear}"/>);
			MessageHelper.setMessage("ERROR_SpecifyMonth", <wcf:json object="${ERROR_SpecifyMonth}"/>);
			MessageHelper.setMessage("ERROR_SpecifyDate", <wcf:json object="${ERROR_SpecifyDate}"/>);
			MessageHelper.setMessage("ERROR_InvalidDate1", <wcf:json object="${ERROR_InvalidDate1}"/>);
			MessageHelper.setMessage("ERROR_InvalidDate2", <wcf:json object="${ERROR_InvalidDate2}"/>);			
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

	<div id="UserRegistrationErrorMessage">
		<c:if test="${!empty errorMessage}">
			<fmt:message bundle="${storeText}" var ="msgType" key="ERROR_MESSAGE_TYPE"/>
			<c:set var = "errorMessage" value ="${msgType}${fn:escapeXml(errorMessage)}"/>
			<script type="text/javascript">
				$(document).ready(function() { 
					$('#MessageArea').css("display","block");
					$('#ErrorMessageText').html() ="${errorMessage}";
					$('#MessageArea').focus();
					setTimeout("$('#ErrorMessageText').focus()",2000);
				});
			</script>
		</c:if>
	</div>
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
						<%out.flush();%>
							<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.PersonalInformation/PersonalInformation.jsp"/>
						<%out.flush();%>
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
<!-- END UserRegistrationUpdateForm.jsp -->
