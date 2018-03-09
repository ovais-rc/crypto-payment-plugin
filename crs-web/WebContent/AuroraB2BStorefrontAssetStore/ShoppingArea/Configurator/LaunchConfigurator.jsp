<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This page launches the sterling configurator by building and automatically submitting a form.
  * This page is also called once the sterling configurator is submitted and an item is add to the
  * shopping cart.  In this scenario, this page simply redirects to either the shopping cart or
  * the shipping page.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ page import="java.io.StringReader"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="org.w3c.dom.Document"%>
<%@ page import="org.w3c.dom.Element"%>
<%@ page import="java.lang.Exception"%>
<%@ page import="org.xml.sax.InputSource"%>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<!-- BEGIN LaunchConfigurator.jsp -->
<c:set var="catEntryId" value="${WCParam.catEntryId}"/>
<c:if test="${empty catEntryId}">
	<c:set var="catEntryId" value="${WCParam.productId}"/>
</c:if>

<c:if test="${!empty catEntryId}">
	<%-- Get the configuration for this particular dynamic kit --%>
	<c:catch var="searchServerException">
		<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${catEntryId}" >
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
	<c:set var="configuratorURL" value="${catalogEntryView.dynamicKitURL}"/>
	<c:if test="${!empty catalogEntryView.dynamicKitDefaultConfiguration}">
		<c:set var="ConfigXML" value="${catalogEntryView.dynamicKitDefaultConfiguration}" scope="request"/>
	</c:if>
</c:if>

<c:if test="${!empty WCParam.orderItemId}">
	<%-- An orderItemId is set if a dynamic kit is in the shopping cart and
	is requested to be reconfigured.  We need to retrieve the order item configuration (oiconifg).
	--%>
	<wcf:rest var="itemConfiguration" url="store/{storeId}/order">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="q" value="findConfigurationByOrderItemId"/>
		<wcf:param name="orderItemId" value="${WCParam.orderItemId}"/>
	</wcf:rest>
	
	<c:if test="${!empty itemConfiguration.Order && !empty itemConfiguration.Order[0].orderItem && !empty itemConfiguration.Order[0].orderItem[0].orderItemConfiguration}">
		<c:set var="ConfigXML" value="${itemConfiguration.Order[0].orderItem[0].orderItemConfiguration}" scope="request"/>		
	</c:if>
</c:if>

<%-- If a request failed for some reason, capture the ConfigXML in the request and pass it back to the configurator --%>
<c:if test="${!empty errorMessage}">
	<c:set var="ConfigXML" value="${WCParam.ConfigXML}" scope="request"/>
</c:if>


<%-- Get the contract ID --%>
<c:set var="contractId" value=""/>
<c:if test="${!empty WCParam.contractId}">
	<c:set var="contractId" value="${WCParam.contractId}"/>
</c:if>
<c:if test="${empty contractId && !empty CommandContext.currentTradingAgreementIdsAsString}">
	<%-- pick the first contract if not specified --%>
	<c:set var="localContractIds" value="${fn:split(CommandContext.currentTradingAgreementIdsAsString, ';')}" />
	<c:set var="contractId" value="${localContractIds[0]}"/>
</c:if>

<%-- Create the final URL redirected to when a configuration is complete (added or updated). --%>
<c:set var="fromURL" value="${WCParam.fromURL}"/>
<c:if test="${empty fromURL}">
	<c:set var="fromURL" value="AjaxOrderItemDisplayView" />
</c:if>

<c:set var="doneButton"><fmt:message bundle="${storeText}" key="PRODUCT_ADD_TO_CART" /></c:set>

<c:choose>
	<c:when test="${!empty WCParam.ReturnURL}">
		<%-- The returnURL is passed back on error.  We want to keep the original value --%>
		<c:set var="returnURL" value="${WCParam.ReturnURL}" />
	</c:when>
	<c:when test="${!empty WCParam.fromPage && WCParam.fromPage == 'requisitionList'}">
		<%-- Case where the shopper is coming from the requisition list page. --%>
		<wcf:url var="returnURL" value="RequisitionListConfigurationUpdate" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="productId" value="${catEntryId}" />
			<wcf:param name="orderItemId" value="${WCParam.orderItemId}" />
			<wcf:param name="contractId" value="${contractId}" />
			<wcf:param name="fromURL" value="${fromURL}" />
			<wcf:param name="URL" value="LaunchConfiguratorRedirectView?ConfigXML*=&ReturnURL*=&configCacheId*=&organizationCode*=&configurationXML*=" />
			<wcf:param name="errorViewName" value="LaunchConfiguratorView" />
			<wcf:param name="submitted" value="true" />
			<flow:ifEnabled feature="SOAWishlist">
				<wcf:param name="giftListId" value="${giftListId}" />
			</flow:ifEnabled>
		</wcf:url>
		<c:set var="doneButton"><fmt:message bundle="${storeText}" key="SHOPCART_UPDATE" /></c:set>
	</c:when>
	<c:when test="${!empty WCParam.orderItemId}">
		<%-- If orderItemId is set, we assume a reconfiguration of a kit. --%>
		<wcf:url var="returnURL" value="RESTOrderUpdateConfigurationInCart" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="productId" value="${catEntryId}" />
			<wcf:param name="orderItemId" value="${WCParam.orderItemId}" />
			<wcf:param name="contractId" value="${contractId}" />
			<wcf:param name="fromURL" value="${fromURL}" />
			<wcf:param name="URL" value="LaunchConfiguratorRedirectView?ConfigXML*=&ReturnURL*=&configCacheId*=&organizationCode*=&configurationXML*=" />
			<wcf:param name="errorViewName" value="LaunchConfiguratorView" />
			<wcf:param name="submitted" value="true" />
			<flow:ifEnabled feature="SOAWishlist">
				<wcf:param name="giftListId" value="${giftListId}" />
			</flow:ifEnabled>
		</wcf:url>
	</c:when>
	<c:otherwise>
		<%-- A new configuration is requested --%>
		<wcf:url var="returnURL" value="RESTOrderAddConfigurationToCart" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catEntryId" value="${catEntryId}" />
			<wcf:param name="quantity" value="${WCParam.quantity}" />
			<wcf:param name="contractId" value="${contractId}" />
			<wcf:param name="errorViewName" value="LaunchConfiguratorView" />
			<wcf:param name="fromURL" value="${fromURL}" />
			<wcf:param name="URL" value="LaunchConfiguratorRedirectView?ConfigXML*=&ReturnURL*=&configCacheId*=&organizationCode*=&configurationXML*=" />
			<wcf:param name="submitted" value="true" />
			<flow:ifEnabled feature="SOAWishlist">
				<wcf:param name="giftListId" value="${giftListId}" />
			</flow:ifEnabled>
		</wcf:url>
	</c:otherwise>
</c:choose>

<%-- Build the URL if the shopper wishes to cancel the configuration --%>
<wcf:url var="cancelURL" value="Product2">
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="productId" value="${catEntryId}"/>
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="errorViewName" value="ProductDisplayErrorView"/>
	<wcf:param name="categoryId" value="${WCParam.categoryId}" />
</wcf:url>


<%-- Get the model name.  We remove the item name from the dynamicKitModelReference --%>
<c:set var="modelName" value=""/>
<c:set var="modelStoreName" value="${param.storeName}"/>
<c:if test="${!empty catalogEntryView}">
	<c:forTokens items="${catalogEntryView.dynamicKitModelReference}" delims="/" var="token" varStatus="status">
		<c:choose>
			<c:when test="${!status.last}">
				<c:choose>
					<c:when test="${status.first}">
						<c:set var="modelStoreName" value="${token}"/>
						<c:set var ="modelName" value="${token}" />
					</c:when>
					<c:otherwise>
						<c:set var="modelName" value="${modelName}/${token}" />
					</c:otherwise>
				</c:choose>
			</c:when>
		</c:choose>
	</c:forTokens>
</c:if>
<c:set var="modelName" value="${modelName}" scope="request"/>
<%
String strConfig = (String)(request.getAttribute("ConfigXML"));
String modelName = (String)(request.getAttribute("modelName"));

if(strConfig != null && !strConfig.isEmpty())
{
  //validate whether the modelName is same as the one in BOM xml.
  StringReader xmlInput = new StringReader(strConfig);
		try {

		  DocumentBuilderFactory bldrFactory = DocumentBuilderFactory.newInstance();

		  DocumentBuilder docBldr = bldrFactory.newDocumentBuilder();

		  Document doc = docBldr.parse(new InputSource(xmlInput));
		  Element root = doc.getDocumentElement();


		  if (root.getNodeName().equals("ConfiguratorBOM")) {
			  if(!modelName.equals(root.getAttribute("ModelName")))
			  {
				 request.setAttribute("ConfigXML", "");
			  }
		  }

		}catch(Exception e){

		}finally{
			xmlInput.close();
		}

}
%>

<%-- Removed title, since new store does not show the title inside iframe, but outside in Configure.jsp --%>

<%-- get the customers cookie activity data --%>
<c:choose>
	<c:when test="${env_inPreview}">
		<c:set var="cookiePrefix" value="WCP_USERACTIVITY_"/>
	</c:when>
	<c:otherwise>
		<c:set var="cookiePrefix" value="WC_USERACTIVITY_"/>
	</c:otherwise>
</c:choose>
<c:forEach items="${pageContext.request.cookies}" var="tmpCookie">
  <c:if test="${fn:contains(tmpCookie.name, cookiePrefix)}">
    <c:set var="userActivity" value="${tmpCookie.value}"/>
  </c:if>
</c:forEach>

<c:set var="ConfigurationDate" value="${catalogEntryView.dynamicKitConfigurationDate}" />
<c:set var="sterlingOrgCode" value="${catalogEntryView.dynamicKitOrgCode}" />

<%-- get the buyer user ID --%>
<c:set var="person" value="${requestScope.person}"/>
<c:if test="${empty person || person==null}">
	<wcf:rest var="person" url="store/{storeId}/person/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
</c:if>
<c:set var="buyerUserId" value="${person.logonId}" />

<%-- Get the CSS to use --%>
<c:set var="css" value="${jspStoreImgDir}css/common1_1.css"/>
<c:set var="css" value="${fn:substringBefore(css,'.css')}_configurator.css"/>
<html>
	<head>
		<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="CONFIGURE"  /></title>
		<script type="text/javascript">
		<%-- A small script to check for error messages and refresh the configurator frame --%>
		function checkForErrorAndLoadForm() {
			<c:if test="${!empty errorMessage}">
				with(window.top) {
					MessageHelper.displayErrorMessage(<wcf:json object="${errorMessage}"/>);
				}
			</c:if>
			processAndSubmitForm(document.getElementById('configure'));
		}
		</script>
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	</head>

	<body onload="checkForErrorAndLoadForm()">
	 <%--
		Debug statements<br/>
		URL: ${catalogEntryView.dynamicKitURL}<br/>
		sfId: ${sdb.identifier}<br/>
		Model: ${modelName}<br/>
		ReturnURL: <c:out value="${returnURL}"/><br/>
		currency: <c:out value="${currencyFormatterDB.currencyCode}"/><br/>
		css: <c:out value="${css}"/><br/>
		storeId: <c:out value="${WCParam.storeId}"/><br/>
		contractId: <c:out value="${contractId}"/><br/>
		ConfigXML: <c:out value="${ConfigXML}" escapeXml="true" /><br/>
		buyerUserId: <c:out value="${buyerUserId}" /><br/>
		WC_USERACTIVITY: <c:out value="${userActivity}" escapeXml="true" /><br/>
			  ConfigurationDate: <c:out value="${ConfigurationDate}" escapeXml="true" /><br/>
	--%>

	<form id="configure" action="${catalogEntryView.dynamicKitURL}?sfId=<c:out value='${sterlingOrgCode}'/>" method="post">
		<input type="hidden" name="sfId" value="<c:out value="${sterlingOrgCode}"/>"/>
		<input type="hidden" name="Model" value="${modelName}"/>
		<input type="hidden" name="organizationCode" value="<c:out value="${sterlingOrgCode}"/>" />
		<input type="hidden" name="doneButton" value="<c:out value="${doneButton}"/>" />
		<input type="hidden" name="ReturnURL" value="<c:out value="${returnURL}"/>" />
		<input type="hidden" name="currency" value="${currencyFormatterDB.currencyCode}" />
		<input type="hidden" name="css" value="${css}" />
		<input type="hidden" name="storeId" value="${WCParam.storeId}" />
		<input type="hidden" name="catalogId" value="${WCParam.catalogId}" />
		<%-- Creates a cancel URL to allow the user to cancel out of the configuration --%>
		<%--<input type="hidden" name="CancelURL" value="${cancelURL}" />--%>
		<input type="hidden" name="contractId" value="${contractId}" />
		<input type="hidden" name="LocaleCode" value="${CommandContext.locale}" />
		<input type="hidden" name="pageTitle" value=" " />
		<input type="hidden" name="displayFooter" value="0" />
		<input type="hidden" name="FiringPhase" value="Initiate" />
		<c:if test="${!empty ConfigXML}">
			<input type="hidden" name="ConfigXML" value="<c:out value="${ConfigXML}"/>" />
		</c:if>
		<input type="hidden" name="buyerUserId" value="<c:out value="${buyerUserId}"/>" />
		<%-- Pass the users activity --%>
		<c:choose>
		<c:when test="${!empty userType && userType ne 'G'}">
			<input type="hidden" name="WC_USERACTIVITY" value="<c:out value="${userActivity}"/>" />
		</c:when>
		<c:otherwise>
			<input type="hidden" name="WC_USERACTIVITY" value="" />
		</c:otherwise>
		</c:choose>
		<input type="hidden" name="ConfigurationDate" value="<c:out value="${ConfigurationDate}"/>" />
	</form>
	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END LaunchConfigurator.jsp -->
