
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

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

<c:set var="pageCategory" value="MyAccount" scope="request"/>

<!DOCTYPE HTML>

<!-- BEGIN WishListDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="WISHLIST_TITLE"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript">
		$( document ).ready(function() {  
			categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
			ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
			
			<fmt:message bundle="${storeText}" key="WISHLIST_MISSINGNAME" var="WISHLIST_MISSINGNAME"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_MISSINGEMAIL" var="WISHLIST_MISSINGEMAIL"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_INVALIDEMAILFORMAT" var="WISHLIST_INVALIDEMAILFORMAT"/>
			<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_EMPTY" var="WISHLIST_EMPTY"/>
			<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
			<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM" />
			<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_ADDED" var="WISHLIST_ADDED"/>
			<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR"/>
			<%-- Missing message --%>
			<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
			<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">                                     
				<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US" /></fmt:param>
			</fmt:message>
			<fmt:message bundle="${storeText}" key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU"/>
			MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
			MessageHelper.setMessage("WISHLIST_MISSINGNAME", <wcf:json object="${WISHLIST_MISSINGNAME}"/>);
			MessageHelper.setMessage("WISHLIST_MISSINGEMAIL", <wcf:json object="${WISHLIST_MISSINGEMAIL}"/>);
			MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", <wcf:json object="${WISHLIST_INVALIDEMAILFORMAT}"/>);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
			MessageHelper.setMessage("WISHLIST_EMPTY", <wcf:json object="${WISHLIST_EMPTY}"/>);
			MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
			MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
			MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
			MessageHelper.setMessage("WISHLIST_ADDED", <wcf:json object="${WISHLIST_ADDED}"/>);
			MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
			MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
			MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);
		});
	</script>
	<wcf:url var="WishListResultDisplayViewURL" value="WishListResultDisplayViewV2">
		<wcf:param name="langId" value="${langId}" />						
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	</wcf:url>
	
	<fmt:message bundle="${storeText}" key="WISHLISTS_TITLE" var="contentPageName" scope="request"/>
</head>
                 
<body>

	<%@ include file="../../../Common/MultipleWishListSetup.jspf" %>
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page" class="nonRWDPage">

	<c:set var="myAccountPage" value="true" scope="request"/>
	<c:set var="wishListPage" value="true" />
	<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

    <!-- Main Content Start -->
	
	<c:set var="myAccountPage" value="true" scope="request"/>
	<c:set var="wishListPage" value="true"/>
	<c:set var="url" value="WishListDisplayView"/>	
	
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
							<%@ include file="../../../Snippets/MultipleWishList/GetDefaultWishList.jspf" %>
							<div wcType="RefreshArea" id="WishlistSelect_Widget" refreshurl="" declareFunction="ShoppingListControllersJS.declareWishlistSelectWidgetRefreshController()">
								<% out.flush(); %>								
								 <wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.WishListActions/WishListActions.jsp">
									<wcpgl:param name="storeId" value="${WCParam.storeId}" />
									<wcpgl:param name="catalogId" value="${catalogId}" />
									<wcpgl:param name="langId" value="${langId}"/>							
								</wcpgl:widgetImport>
								<% out.flush(); %>
							</div>
							
							<div class="my_account_wishlist" id="WC_WishListDisplay_div_18">
								<span id="WishlistDisplay_Widget_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Wish_List"/></span>
								<div wcType="RefreshArea" id="WishlistDisplay_Widget" refreshurl="" declareFunction="ShoppingListControllersJS.declareWishlistDisplayWidgetRefreshController()" ariaMessage="<fmt:message bundle='${storeText}' key='ACCE_Status_Wish_List_Updated'/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="WishlistDisplay_Widget_ACCE_Label">
									
									<% out.flush(); %>
									<wcpgl:widgetImport url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.WishListDetail/WishListDetail.jsp">
										<wcpgl:param name="storeId" value="${WCParam.storeId}" />
										<wcpgl:param name="catalogId" value="${catalogId}" />
										<wcpgl:param name="langId" value="${langId}" />
										<%-- get default list ID from get data once service is available, now just pass in 1st wish list ID found --%>
										<wcpgl:param name="listId" value="${defaultWishList.giftListIdentifier.uniqueID}"/>
									</wcpgl:widgetImport>
									<% out.flush(); %>
					
								</div>	
											
								<p class="space"></p>
				
								<fmt:message bundle="${storeText}" var="titleString" key="WISHLIST_ESPOT_TITLE" scope="request"/>	
									<% out.flush(); %>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
										<wcpgl:param name="emsName" value="WishListCenter_CatEntries" />
										<wcpgl:param name="errorViewName" value="AjaxOrderItemDisplayView" />
										<wcpgl:param name="widgetOrientation" value="horizontal"/>
										<wcpgl:param name="espotTitle" value="${titleString}"/>
									</wcpgl:widgetImport>
									<% out.flush(); %>
							
								</div>
								<!-- Content End -->
								<!-- Right Nav Start -->
								<div id="right_nav">
									<% out.flush(); %>								
										<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.WishListEmail/WishListEmail.jsp">
											<wcpgl:param name="storeId" value="${WCParam.storeId}" />
											<wcpgl:param name="catalogId" value="${catalogId}" />
											<wcpgl:param name="langId" value="${langId}"/>		
											<wcpgl:param name="errorViewName" value="WishListDisplayView" />			
											<wcpgl:param name="bHasWishList" value="true" />							
										</wcpgl:widgetImport>
									<% out.flush(); %>
								</div>
								<!-- Right Nav End -->
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
</div>
<flow:ifEnabled feature="Analytics">
	<cm:pageview/>
</flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END WishListDisplay.jsp -->
