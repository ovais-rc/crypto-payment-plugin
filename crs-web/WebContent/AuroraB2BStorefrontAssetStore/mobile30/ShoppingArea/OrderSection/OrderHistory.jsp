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
  * This JSP snippet displays the Order history page for a particular user
  *****
--%>

<!-- BEGIN OrderHistory.jsp -->

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
			<wcf:param name="URL" value="m30OrderHistory"/>
		</wcf:url>

		<%out.flush();%>
		<c:import url="${LoginURL}"/>
		<%out.flush();%>
	</c:when>
	<c:otherwise>
		<%-- Required variables for breadcrumb support --%>
		<c:set var="accountPageGroup" value="true" scope="request" />
		<c:set var="orderHistoryPage" value="true" scope="request" />
		
		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<title>
					<fmt:message bundle="${storeText}" key="MO_ORDERS"/>
				</title>
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
						<div class="page_title left"><fmt:message bundle="${storeText}" key="MO_ORDERS"/></div>
						<div class="clear_float"></div>
					</div>
					<!-- End Breadcrumb Bar -->
					
					<!-- Start My Orders List-->
					<div id="orders">
						<% out.flush(); %>
						<c:import url="${env_jspStoreDir}${storeNameDir}Snippets/Order/OrderStatusDisplay.jsp" >
								<c:param name= "showScheduledOrders" value="false"/>
								<c:param name= "showOrdersAwaitingApproval" value="false"/>
								<c:param name= "showPONumber" value="false"/>
								<c:param name="maLandingPage" value="false"/>
								<c:param name="allOrders" value="true"/>
						</c:import>
						<% out.flush();%>			
					</div>
					<!-- End My Orders List-->

					<%@ include file="../../include/FooterDisplay.jspf" %>						
				</div>
			<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
		
	</c:otherwise>
</c:choose>

<!--  END OrderHistory.jsp -->
