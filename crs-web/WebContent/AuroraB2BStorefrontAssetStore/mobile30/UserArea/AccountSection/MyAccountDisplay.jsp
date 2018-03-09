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
  * This JSP displays the users account page. 
  *****
--%>

<!-- BEGIN MyAccountDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:choose>
	<%--	Test to see if user is logged in. If not, redirect to the login page. 
			After logging in, we will be redirected back to this page.
	 --%>
	<c:when test="${userType == 'G'}">
		<wcf:url var="LoginURL" value="m30LogonForm" type="Ajax">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="URL" value="m30MyAccountDisplay"/>
		</wcf:url>

		<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<c:choose>
					<c:when test="${_iPhoneHybridApp == true}">
						<title><fmt:message bundle="${storeText}" key="MYACCOUNT_TITLE"/> - <c:out value="${storeName}"/></title>
						<meta name="description" content="<c:out value="${category.description.longDescription}"/>"/>
						<meta name="keywords" content="<c:out value="${category.description.keyWord}"/>"/>
						<meta name="viewport" content="${viewport}" />
						<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>
					</c:when>
					<c:otherwise>
						<meta http-equiv="Refresh" content="0;URL=${LoginURL}"/>
					</c:otherwise>
				</c:choose>
			</head>
			<body>
				<c:if test="${_iPhoneHybridApp == true}">
					<div id="breadcrumb" class="item_wrapper_gradient">
						<div class="page_title left"><fmt:message bundle="${storeText}" key="MYACCOUNT_TITLE"/></div>
						<div class="clear_float"></div>
					</div>
					<div class="item_wrapper_button">
						<div class="single_button_container left">
							<a id="logon_link" href="${fn:escapeXml(LoginURL)}" title="<fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_IN" />">
								<div class="primary_button button_half"><fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_IN" /></div>
							</a>
							<div class="clear_float"></div>
						</div>
					</div>
				</c:if>
				<script type="text/javascript">
				setDeleteCartCookie();
				</script>
			<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:when>
	<c:otherwise>

		<%-- Required variables for breadcrumb support --%>
		<c:set var="accountPageGroup" value="true" scope="request" />
		<c:set var="accountDisplayPage" value="true" scope="request" />
		
		<wcf:url var="OrderHistoryURL" value="m30OrderHistory">
		  <wcf:param name="langId" value="${langId}" />
		  <wcf:param name="storeId" value="${WCParam.storeId}" />
		  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<wcf:url var="PerInfoDispURL" value="m30UserRegistrationUpdate">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<wcf:url var="AddressBookURL" value="m30OrderBillingAddressSelection">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="fromPage" value="MyAccount" />
		</wcf:url>
		<flow:ifEnabled feature="SOAWishlist">
		<wcf:url var="WishListDispURL" value="m30InterestListsView">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="listId" value="." />  			
			<wcf:param name="URL" value="m30InterestListsView" />  			
		</wcf:url>
		</flow:ifEnabled>
		<wcf:url var="SubscriptionDispURL" value="m30MySubscriptionDisplay">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>

		<wcf:url var="CouponsDispURL" value="m30CouponsDisplay">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
		
		<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<title><fmt:message bundle="${storeText}" key="MYACCOUNT_TITLE"/> - <c:out value="${storeName}"/></title>
				<meta name="description" content="<c:out value="${category.description.longDescription}"/>"/>
				<meta name="keyword" content="<c:out value="${category.description.keyWord}"/>"/>
				<meta name="viewport" content="${viewport}" />
				<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

                <%@ include file="../../include/CommonAssetsForHeader.jspf" %>
			</head>	
			
			<body>
				<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->	
					<%@ include file="../../include/HeaderDisplay.jspf" %>
					
					<!-- Start Breadcrumb Bar -->
					<div id="breadcrumb" class="item_wrapper_gradient">
						<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
							<div class="arrow_icon"></div>
						</div></a>
						<div class="page_title left"><fmt:message bundle="${storeText}" key="MYACCOUNT_TITLE"/></div>
						<div class="clear_float"></div>
					</div>
					<!-- End Breadcrumb Bar -->

					<!-- Start My Account -->
					<div id="department_categories" class="item_wrapper">
						<div id="order_history_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${OrderHistoryURL}'">
							<h4><fmt:message bundle="${storeText}" key="MO_MA_MYORDERS"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
						<div id="personal_info_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${PerInfoDispURL}'">
							<h4><fmt:message bundle="${storeText}" key="MA_MYPERSONAL_INFORMATION"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
						<div id="address_book_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${AddressBookURL}'">
							<h4><fmt:message bundle="${storeText}" key="MA_MYADDRESS_BOOK"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
						<flow:ifEnabled feature="SOAWishlist">
						<div id="wish_list_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${WishListDispURL}'">
							<h4><fmt:message bundle="${storeText}" key="MA_MYWISHLIST"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
						</flow:ifEnabled>
						<div id="subscription_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${SubscriptionDispURL}'">
							<h4><fmt:message bundle="${storeText}" key="MA_MYSUBSCRIPTIONS"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
						<div id="coupon_link" class="sub_wrapper item_wrapper_gradient" onclick="location.href='${CouponsDispURL}'">
							<h4><fmt:message bundle="${storeText}" key="MO_MA_MYCOUPONS"/></h4>
							<div class="forward_arrow_icon"></div>
						</div>
					</div>
					<!-- End My Account -->
		
					<c:if test="${_iPhoneHybridApp == true}">
						<!-- Home Page link: MobileIndexURL -->
						<wcf:url var="MobileIndexURL" patternName="HomePageURLWithLang" value="TopCategoriesDisplayView">
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						</wcf:url>

						<wcf:url var="logOffURL" value="Logoff">
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="langId" value="${WCParam.langId}" />
							<wcf:param name="URL" value="${fn:escapeXml(MobileIndexURL)}" />
						</wcf:url>	

						<div class="item_wrapper_button">
							<div class="single_button_container left">
								<a id="logoff_link" href="${fn:escapeXml(logOffURL)}" title="<fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_OUT" />">
									<div class="primary_button button_half"><fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_OUT" /></div>
								</a>
								<div class="clear_float"></div>
							</div>
						</div>
					</c:if>
				
					<%@ include file="../../include/FooterDisplay.jspf" %>						
				</div>
				<script type="text/javascript">
				setDeleteCartCookie();
				</script>
			<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:otherwise>
</c:choose>

<!-- END MyAccountDisplay.jsp -->
