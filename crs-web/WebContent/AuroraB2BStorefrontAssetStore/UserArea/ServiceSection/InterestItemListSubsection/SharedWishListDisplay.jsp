<%--
  *****
  * This page shows a wishlist that has been shared to you by another user
  *
  * -A list of order items that a user has added to their wish list
  * 	- For each interest item:
  * 		- Checkbox to select the item (used to select products that user wants to add to their shopcart)
  *			- Clickable item name (links to display page for order item)
  * 		- Attribute values for each interest item
  *			- Item price 
  * - 'Add Selected items to shopping cart' button (adds item to Shopping Cart)
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

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
<!-- BEGIN SharedWishListDisplay.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<title><fmt:message bundle="${storeText}" key="WISHLIST_TITLE"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>

	<script type="text/javascript">
		categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
	</script>

	<script type="text/javascript">
		ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
		<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM" />
		<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR"/>
		/* Missing Message */
		<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
		<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">                                     
			<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US"/></fmt:param>
		</fmt:message>
		
		MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
	</script>
	<script type="text/javascript">
		function refreshContentURL(contentURL){
			/* Handles multiple clicks */
			if(!submitRequest()){
				return;
			}   	
			cursor_wait();
            $("#SharedWishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
			wcRenderContext.updateRenderContext("SharedWishlistDisplay_Context");
		}
	</script>
</head>

<body>
	<c:set var="wishListPage" value="true"/>   
	<c:set var="sharedWishList" value="true" scope="request"/>
	<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
	<c:set var="useHomeRightSidebar" value="true" scope="request"/>
	<c:set var="pageCategory" value="MyAccount" scope="request"/>
	
	<div id="page" class="nonRWDPage">
			
		<%@ include file="../../../Common/MultipleWishListSetup.jspf" %>
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
		<!-- Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<div class="content_wrapper_position" role="main">
			<div class="content_wrapper">
				<div class="content_left_shadow">
					<div class="content_right_shadow">
						<div class="main_content">
							<div class="container_content_rightsidebar">
								<h1 class="shared_wishlist_title"><fmt:message bundle="${storeText}" key="MA_SHARED_WL"/></h1>													
								<div class="left_column"> 				

									<div id="box" class="my_account_shared_wishlist">
									<!-- Start - JSP File Name: SharedWishListDisplay.jsp -->
										<c:set var="sharedWishList" value="true" scope="request" />	
										<span id="WishlistDisplay_Widget_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Wish_List"/></span>
										<div wcType="RefreshArea" id="SharedWishlistDisplay_Widget" refreshurl="" declareFunction="ShoppingListControllersJS.declareSharedWishlistDisplayRefreshController()" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Wish_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="WishlistDisplay_Widget_ACCE_Label">
											<% out.flush(); %>		
											<c:set var="wishListEMail" value="false"/>
											<c:if test="${WCParam.wishListEMail == 'true'}">
												<c:set var="wishListEMail" value="true"/>
											</c:if>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.WishListDetail/WishListDetail.jsp">
												<wcpgl:param name="storeId" value="${WCParam.storeId}" />
												<wcpgl:param name="catalogId" value="${catalogId}" />
												<wcpgl:param name="langId" value="${langId}" />
												<wcpgl:param name="externalId" value="${WCParam.externalId}" />
												<wcpgl:param name="wishListEMail" value="${wishListEMail}"/>
											</wcpgl:widgetImport>		
											<% out.flush(); %>
										</div>				
															
										<!-- Content End -->
									</div>
								</div>
								<div class="right_column">
									<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
										<wcpgl:param name="emsName" value="ShoppingCartRight_CatEntries"/>
										<wcpgl:param name="widgetOrientation" value="vertical"/>
										<wcpgl:param name="pageSize" value="2"/>
									</wcpgl:widgetImport>
									<%out.flush();%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Footer Widget -->
		<div class="footer_wrapper_position">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
			<%out.flush();%>
		</div>  

	</div>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END SharedWishListDisplay.jsp -->
