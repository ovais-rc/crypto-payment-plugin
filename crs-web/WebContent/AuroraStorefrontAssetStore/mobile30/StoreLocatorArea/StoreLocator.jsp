<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the store locator page.
  *****
--%>

<!-- BEGIN StoreLocator.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../include/parameters.jspf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<c:set var="storeLocatorPageGroup" value="true" />
<c:set var="storeLocatorPage" value="true" />

<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MSTLOC_TITLE">
				<fmt:param value="${storeName}" />
			</fmt:message>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

        <%@ include file="../include/CommonAssetsForHeader.jspf" %>
	</head>
	
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="MSTORE_LOCATOR"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->
			
			<!-- Start Notification Container -->
			<c:if test="${!empty WCParam.errorMsgKey}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><fmt:message bundle="${storeText}" key="${WCParam.errorMsgKey}"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<!-- Start Store Locator-->
			<div id="store_locator" class="item_wrapper">
				<%@ include file="../Snippets/StoreLocator/GPSSupport.jspf" %>

				<div class="clear_float"></div>
				<div class="item_spacer_10px"></div>
				
				<form id="store_locator_form" method="post" action="m30StoreLocatorSearchView">
					<input type="hidden" id="storeId" name="storeId" value="<c:out value="${WCParam.storeId}" escapeXml="true"/>" />
					<input type="hidden" id="langId" name="langId" value="<c:out value="${WCParam.langId}" escapeXml="true"/>" />
					<input type="hidden" id="catalogId" name="catalogId" value="<c:out value="${WCParam.catalogId}" escapeXml="true"/>" />
					<input type="hidden" id="productId" name="productId" value="<c:out value="${WCParam.productId}" escapeXml="true"/>" />

					<c:if test="${!empty WCParam.pgGrp}">
						<input type="hidden" id="pgGrp" name="pgGrp" value="${WCParam.pgGrp}" />
						<c:choose>
							<c:when test="${WCParam.pgGrp == 'catNav'}">
								<input type="hidden" id="categoryId" name="categoryId" value="<c:out value="${WCParam.categoryId}" escapeXml="true"/>" />
								<input type="hidden" id="parent_category_rn" name="parent_category_rn" value="<c:out value="${WCParam.parent_category_rn}" escapeXml="true"/>" />
								<input type="hidden" id="top_category" name="top_category" value="<c:out value="${WCParam.top_category}" escapeXml="true"/>" />
								<input type="hidden" id="sequence" name="sequence" value="<c:out value="${WCParam.sequence}" escapeXml="true"/>" />
							</c:when>
							<c:when test="${WCParam.pgGrp == 'search'}">
								<input type="hidden" id="resultCatEntryType" name="resultCatEntryType" value="<c:out value="${WCParam.resultCatEntryType}" escapeXml="true"/>" />
								<input type="hidden" id="pageSize" name="pageSize" value="<c:out value="${WCParam.pageSize}" escapeXml="true"/>" />
								<input type="hidden" id="searchTerm" name="searchTerm" value="<c:out value="${WCParam.searchTerm}" escapeXml="true"/>" />
								<input type="hidden" id="sType" name="sType" value="<c:out value="${WCParam.sType}" escapeXml="true"/>" />
								<input type="hidden" id="beginIndex" name="beginIndex" value="<c:out value="${WCParam.beginIndex}" escapeXml="true"/>" />
							</c:when>
						</c:choose>
					</c:if>																

					<input type="hidden" id="fromPage" name="fromPage" value="<c:out value="${fromPage}" escapeXml="true"/>" />
					<input type="hidden" id="errorMsgKey" name="errorMsgKey" value="" />

					<div><label for="zip_or_city"><fmt:message bundle="${storeText}" key="MSTLOC_ENTER_ZIP_CITY"/></label></div>
					<input type="text" id="zip_or_city" name="zipOrCity" class="inputfield input_width_full" value="<c:if test='${!empty cookie.WC_mStSearch.value}'><c:out value='${cookie.WC_mStSearch.value}'/></c:if>" placeholder="<fmt:message bundle="${storeText}" key="MSTLOC_ENTER_ZIP_CITY"/>" />
					<div class="item_spacer"></div>
					
					<c:choose>
						<c:when test="${fromPage == 'ShoppingCart'}">
							<div class="single_button_container left">
								<input type="submit" id="locate_store" name="locate_store" class="primary_button button_half" onclick="javascript:checkField(this.form);" value="<fmt:message bundle="${storeText}" key='MSTLOC_CONT_CHECKOUT'/>" />
							</div>
						</c:when>
						<c:otherwise>
							<div class="single_button_container">
								<input type="submit" id="locate_store" name="locate_store" class="primary_button button_full" onclick="javascript:checkField(this.form);" value="<fmt:message bundle="${storeText}" key='MSTLOC_GO'/>" />
							</div>	
						</c:otherwise>
					</c:choose>					
					<div class="clear_float"></div>
				</form>
			</div>
			<!-- End Store Locator-->
					
			<%@ include file="../include/FooterDisplay.jspf" %>						
			
		</div>
		
        <script type="text/javascript">
        //<![CDATA[

        function checkField(form) {
            if (form.zipOrCity.value == null || form.zipOrCity.value.length == 0) {
                form.errorMsgKey.value = "MSTLOC_ERR_EMPTY_ZIPCITY";
                form.action = "m30StoreLocatorView";
            } else {
                updateStoreLocatorSearchValue(form.zipOrCity.value);
            }
            form.submit();
        }

        function getCookie(c) {
            var cookies = document.cookie.split(";");
            for (var i = 0; i < cookies.length; i++) {
                var index = cookies[i].indexOf("=");
                var name = cookies[i].substr(0,index);
                name = name.replace(/^\s+|\s+$/g,"");
                if (name == c) {
                    return decodeURIComponent(cookies[i].substr(index + 1));
                }
            }
        }

        function setStoreLocatorCookieValue(cookieName, cookieValue) {
            var tempValue = cookieValue;
        	var expiry = new Date();
        	expiry.setTime(expiry.getTime() + 10000);
            if (cookieValue != null && tempValue != "undefined" && tempValue != "") {
                var currValue = getCookie(cookieName);
                if (currValue != tempValue) {
                    document.cookie = cookieName + "=;" + (new Date()).toUTCString() + "; path=/";
                    document.cookie = cookieName + "=" + cookieValue + ";" + expiry.toUTCString() + "; path=/";
                }
            }
        }

        function updateStoreLocatorSearchValue(searchValue) {
            var cookieName = "WC_mStSearch";
            setStoreLocatorCookieValue(cookieName, searchValue);
        }
        
        //]]> 
        </script>

	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END StoreLocator.jsp -->
