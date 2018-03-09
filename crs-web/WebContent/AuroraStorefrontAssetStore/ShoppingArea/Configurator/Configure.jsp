<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This page embeds the Sterling Configurator in an Iframe using the view LaunchConfiguratorView.
  *****
--%>
<!DOCTYPE html>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf"%>

<c:set var="pageCategory" value="Configurator" scope="request"/>

<!-- BEGIN Configure.jsp -->

<%-- Get the configuration for this particular dynamic kit --%>
<c:catch var="searchServerException">
	<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${WCParam.catEntryId}" >	
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="currency" value="${env_currencyCode}"/>
		<wcf:param name="responseFormat" value="json"/>		
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
</c:catch>
<c:set var="catalogEntryView" value="${catalogNavigationView.catalogEntryView[0]}" scope="request"/>
<c:set var="showConfigure" value="${catalogEntryView.buyable}"/>
<c:set var="isPreConfigured" value="catalogEntryView.dynamicKitDefaultConfigurationComplete"/>
<c:set var="priceValueIndex" value="1"/>
<c:set var="quantity" value="${WCParam.quantity}"/>
<c:if test="${empty quantity}">
	<c:set var="quantity" value="1"/>
</c:if>
<c:if test="${isPreConfigured == '1'}">
	<c:set var="isPreConfigured" value="true"/>				
</c:if>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="CONFIGURE" /></title>
		
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
        <script>
			function resizeFrame(frameObj) {
				<%-- only enable this line if the parent scheme (host+port) are the same as the iframe scheme --%>
				/*
				var theHeight=frameObj.contentWindow.document.body.scrollHeight+50;	
				document.getElementById('configDiv').style.height=theHeight + "px";
				*/
			}
        </script>
       </head>

	<body>
        <c:set var="hasBreadCrumbTrail" value="true" scope="request"/>

        <%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
		<div id="page">
			<!-- Start Header -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- End Header -->
			
			<!--Start Page Content-->
			<div class="content_wrapper_position">
				<div class="content_wrapper">
					<!--For border customization -->
					<div class="content_top">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>
					<!-- Main Content Area -->
					<div class="content_left_shadow">
						<div class="content_right_shadow">				
							<div class="main_content">
								<!-- Start Main Content -->
								<!-- Configurator Content -->
								<div class="container_configurator_full_width container_margin_5px">
									
									<div class="configurator_page_content">
										<div class="comment right"><fmt:message bundle="${storeText}" key="DK_PRICING_ADJUSTMENT" /></div>
										<div class="clear_float"></div>
										<div class="content_box">
											<div class="box_header">
												<c:if test="${!empty catalogEntryView.name}">
													<fmt:message bundle="${storeText}" key="CONFIGURE_YOUR" > 
														<fmt:param><c:out value="${catalogEntryView.name}"/></fmt:param>
													</fmt:message>
												</c:if>
											</div>
											
											<div class="product_add right">
												<c:if test="${!empty catalogEntryView.price && isPreConfigured}">
													<p>
														<fmt:message bundle="${storeText}" key="DK_PRICE_AS_CONFIGURED" />
														<span class="price">
														<fmt:formatNumber value="${catalogEntryView.price[priceValueIndex].value.value}" type="currency" 
															currencyCode="${catalogEntryView.price[priceValueIndex].value['currency']}" />
														</span>
													</p>
												</c:if>
											
												<div class="clear_float"></div>
											</div>
											<div class="clear_float"></div>
											
											<c:choose>
												<c:when test="${!showConfigure}">
													<div id="configErrorDiv">
														<fmt:message bundle="${storeText}" key="KIT_NOT_BUYABLE" /><br/><br/>
														<c:set var="buttonLink">
															<a href="JavaScript:window.history.back();return false;"><fmt:message bundle="${storeText}" key="GOBACK" /></a>
														</c:set>
														<%@ include file="../../Snippets/ReusableObjects/StoreButton.jspf" %>
													</div>
												</c:when>
												<c:when test="${empty catalogEntryView.dynamicKitModelReference}">
													<div id="configErrorDiv">
														<fmt:message bundle="${storeText}" key="MISSING_MODEL_REFERENCE" /><br/><br/>
														<c:set var="buttonLink">
															<a href="JavaScript:window.history.back();return false;"><fmt:message bundle="${storeText}" key="GOBACK" /></a>
														</c:set>
														<%@ include file="../../Snippets/ReusableObjects/StoreButton.jspf" %>
													</div>
												</c:when>
												<c:when test="${empty catalogEntryView.dynamicKitURL}">
													<div id="configErrorDiv">
														<fmt:message bundle="${storeText}" key="MISSING_MODEL_URL" /><br/><br/>
														<c:set var="buttonLink">
															<a href="JavaScript:window.history.back();return false;"><fmt:message bundle="${storeText}" key="GOBACK" /></a>
														</c:set>
														<%@ include file="../../Snippets/ReusableObjects/StoreButton.jspf" %>
													</div>
												</c:when>
												<c:otherwise>
													<c:url var="launchConfiguratorURL" value="LaunchConfiguratorView">
														<c:param name="catEntryId" value="${WCParam.catEntryId}" />
														<c:param name="orderItemId" value="${WCParam.orderItemId}" />
														<c:param name="fromURL" value="${WCParam.fromURL}" />
														<c:param name="langId" value="${langId}" />
														<c:param name="storeId" value="${storeId}" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="quantity" value="${quantity}" />
														<c:param name="fromPage" value="${WCParam.fromPage}" />
														<c:param name="contractId" value="${WCParam.contractId}" />
													</c:url>
													<div id="configDiv">
														<c:if test="${!empty catalogEntryView.name}">
															<fmt:message bundle="${storeText}" var="pageTitle" key="CONFIGURE_YOUR" > 
																<fmt:param><c:out value="${catalogEntryView.name}"/></fmt:param>
															</fmt:message>
														</c:if>
														<iframe id="configuratorFrame" src="<c:out value="${launchConfiguratorURL}"/>" onload="resizeFrame(this)" style="height:100%" frameborder="0" border="0" title="<c:out value="${pageTitle}"/>">
														</iframe>
													</div>
												</c:otherwise>
											</c:choose>
											
										</div>
									</div>
									
								</div>
								<!-- End Configurator Content -->
							
								<!-- End Main Content -->
							</div>
						</div>				
					</div>
					<!--For border customization -->
					<div class="content_bottom">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>
				</div>
			</div>
			<!--End Page Content-->
			
			<!--Start Footer Content-->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!--End Footer Content-->
			
       <%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END Configure.jsp -->
      

