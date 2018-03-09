<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * DiscountDetailsDisplay.jsp displays the details of a discount code
  * - for item level discounts, display short and long description of the discount and the associated items and a clickable short
  *   description that links to the Item Display page
  * - for product level discounts, display short and long description of the discount and the associated products and a clickable
  *   name that links to the Product Display page
  * - for category level discounts, display the short and long description of the discount
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<wcf:rest var="calculationCodeList" url="/store/{storeId}/associated_promotion">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="profileName" value="IBM_catalogEntryDetailed"/>
	<wcf:param name="q" value="byName"/>
	<wcf:param name="qCalculationUsageId" value="-1"/>
	<wcf:param name="qCode" value="${WCParam.code}"/>
	<wcf:param name="qIncludePromotionCode" value="true"/>
</wcf:rest>
<c:set var="pageCategory" value="Browse" scope="request"/>

<!-- BEGIN DiscountDetailsDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
	<title>
		<fmt:message bundle="${storeText}" key="DISCOUNT_DETAILS_TITLE">
			<fmt:param value="${storeName}"/>
		</fmt:message>
	</title>
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
</head>

<body>

<!-- Page Start -->
<div id="page">

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_static_full_width container_margin_5px">
							<div class="static_page_content">
								<div class="page_header">
									<fmt:message bundle="${storeText}" key="DISCOUNT_DETAILS_TITLE"/>
								</div>
								<div class="content_box">


									<%-- calculationCodes is used to show the discount information of the product --%>
									<c:set var="calculationCodes" value="${calculationCodeList.resultList}" scope="request"/>

									<%--
										***
										* Start check for valid discount.
										* - if true, then display the discount description and long description and the products associated with the discount.
										* - if false, then display error message stating that there is no valid discount.
										***
									--%>
									<c:choose>
										<c:when test="${ !empty calculationCodes }"  >
											<div id="WC_DiscountDetailsDisplay_div_1" class="header">
												<%-- Show the description of the discount --%>
												<c:out value="${calculationCodes[0].descriptionString}" />
											</div>
											<div id="WC_DiscountDetailsDisplay_div_2" class="info_section">
												<%-- Show the long description of the discount --%>
												<span>
													<c:out value="${calculationCodes[0].longDescriptionString}" escapeXml="false" />
												</span>
											</div>

											<tr>
												<td valign="top" id="WC_DiscountDetailsDisplay_TableCell_9">
													<br />
													<table cellpadding="0" cellspacing="0" border="0" id="WC_DiscountDetailsDisplay_Table_3" class="info_section">
														<tbody>
															<tr>
																<%--
																	***
																	* Begin check for discounted products.  For each product, get the parent product and then display the product short description and link to product display page.
																	***
																--%>
																<td valign="top" id="WC_DiscountDetailsDisplay_TableCell_10">
																	<table cellpadding="0" cellspacing="0" border="0" id="WC_DiscountDetailsDisplay_Table_4" role="presentation">
																		<%-- Display the discounted category --%>

																		<c:if test="${!empty WCParam.categoryId}">
																			<tr>
																				<c:catch var="searchServerException">
																					<wcf:rest var="category" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/categoryview/byId/${WCParam.categoryId}" >
																						<wcf:param name="langId" value="${langId}"/>
																						<wcf:param name="currency" value="${env_currencyCode}"/>
																						<wcf:param name="responseFormat" value="json"/>
																						<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																						<c:forEach var="contractId" items="${env_activeContractIds}">
																							<wcf:param name="contractId" value="${contractId}"/>
																						</c:forEach>
																					</wcf:rest>
																				</c:catch>
																				<c:if test="${(!empty category.catalogGroupView[0].fullImage) || (!empty category.catalogGroupView[0].shortDescription)}">
																					<td valign="top" class="categoryspace" width="165" id="WC_CachedCategoriesDisplay_TableCell_3">
																						<%-- Show category image and short description if available --%>
																						<c:if test="${!empty category.catalogGroupView[0].fullImage}">
																							<%-- URL that links to the category display page --%>
																							<wcf:url var="categoryDisplayUrl" patternName="CanonicalCategoryURL" value="Category6">
																								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
																								<wcf:param name="categoryId" value="${WCParam.categoryId}" />
																								<wcf:param name="storeId" value="${WCParam.storeId}" />
																								<wcf:param name="langId" value="${langId}" />
																								<wcf:param name="urlLangId" value="${urlLangId}" />
																							</wcf:url>
																							<div align="center" id="WC_DiscountDetailsDisplay_div_3">
																								<a href="<c:out value="${categoryDisplayUrl}"/>" id="WC_DiscountDetailsDisplay_Link_Cat_1">
																									<img src="<c:out value="${category.objectPath}${category.catalogGroupView[0].fullImage}"/>" alt="<c:out value="${category.catalogGroupView[0].name}"/>" border="0" />
																								</a>
																							</div>
																						</c:if>
																					</td>
																				</c:if>
																			</tr>
																			<c:if test="${!empty category.catalogGroupView[0].shortDescription}">
																				<tr>
																					<td id="WC_DiscountDetailsDisplay_td_1">
																						<span class="text"><c:out value="${category.catalogGroupView[0].shortDescription}" /></span>
																					</td>
																				</tr>
																			</c:if>
																		</c:if>

																		<c:if test="${ !empty calculationCodes[0].attachedCatalogEntries }"  >
																		<tr>
																		<%-- Set the number of items to show on each row --%>
																			<c:catch var="searchServerException">
																				<wcf:rest var="promotionCatalogEntry" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
																					<c:forEach var="discountEntry" items="${calculationCodes[0].attachedCatalogEntries}">
																						<wcf:param name="id" value="${discountEntry.catalogEntryId}" />
																					</c:forEach>
																					<wcf:param name="langId" value="${langId}" />
																					<wcf:param name="currency" value="${env_currencyCode}" />
																					<wcf:param name="responseFormat" value="json" />
																					<wcf:param name="catalogId" value="${WCParam.catalogId}" />
																					<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
																					<c:forEach var="contractId" items="${env_activeContractIds}">
																						<wcf:param name="contractId" value="${contractId}"/>
																					</c:forEach>
																				</wcf:rest>
																			</c:catch>

																			<jsp:useBean id="promotionCatalogEntryMap" class="java.util.HashMap" type="java.util.Map"/>
																			<c:forEach var="discountEntry" items="${promotionCatalogEntry.catalogEntryView}">
																				<c:set target="${promotionCatalogEntryMap}" property="${discountEntry.uniqueID}" value="${discountEntry}" />
																			</c:forEach>
																			<c:set var="maxInRow" value="4"/>
																			<c:forEach var="catalogEntry" items="${calculationCodes[0].attachedCatalogEntries}" varStatus="counter">
																				<c:set var="discountCatalogEntryDB" value="${catalogEntry}"/>

																				<%-- Display the associated products with the discount code --%>
																				<td class="discountProduct" valign="top" align="center" id="WC_DiscountDetailsDisplay_TableCell_11_<c:out value="${counter.count}"/>">

																					<%-- Will only execute the following code if the catalog entry is not a dynamic kit --%>
																					<c:if test="${!discountCatalogEntryDB.isDynamicKit}" >
																						<c:set var="discountCatalogEntryView" value="${promotionCatalogEntryMap[discountCatalogEntryDB.catalogEntryId]}"/>
																						<c:if test="${!empty discountCatalogEntryView.thumbnail}">
																							<c:choose>
																								<c:when test="${(fn:startsWith(discountCatalogEntryView.thumbnail, 'http://') || fn:startsWith(discountCatalogEntryView.thumbnail, 'https://'))}">
																									<wcst:resolveContentURL var="thumbNail" url="${discountCatalogEntryView.thumbnail}"/>
																								</c:when>
																								<c:when test="${fn:startsWith(discountCatalogEntryView.thumbnail, '/store/0/storeAsset')}">
																									<c:set var="thumbNail" value="${restPrefix}${discountCatalogEntryView.thumbnail}" />
																								</c:when>
																								<c:otherwise>
																									<c:set var="thumbNail" value="${discountCatalogEntryView.thumbnail}" />
																								</c:otherwise>
																							</c:choose>
																						</c:if>
																						<span class="productName">
																							<%-- URL that links to the Product Display Page --%>
																							<wcf:url var="ProductDisplayURL" patternName="ProductURL" value="Product1">
																								<wcf:param name="langId" value="${langId}" />
																								<wcf:param name="storeId" value="${WCParam.storeId}" />
																								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
																								<wcf:param name="productId" value="${discountCatalogEntryView.uniqueID}" />
																								<wcf:param name="urlLangId" value="${urlLangId}" />
																							</wcf:url>
																							<a href="<c:out value="${ProductDisplayURL}"/>" id="WC_DiscountDetailsDisplay_Link_1_<c:out value="${counter.count}"/>">
																								<c:choose>
																									<c:when test="${!empty thumbNail}">
																										<img src="${thumbNail}" alt="<c:out value="${discountCatalogEntryView.shortDescription}" />" border="0"/>
																									</c:when>
																									<c:otherwise>
																										<img src="<c:out value="${jspStoreImgDir}"/>images/NoImageIcon_sm.jpg" alt="<fmt:message bundle="${storeText}" key="No_Image"/>" border="0"/>
																									</c:otherwise>
																								</c:choose>
																								<br /><c:out value="${discountCatalogEntryView.name}" escapeXml="false"  /><br /><br />
																							</a>
																						</span>
																						 <%--
																						  ***
																						  *	Start: discountCatalogEntryDB.productDataBean Price
																						  * The 1st choose block below determines the way to show the discountCatalogEntryDB.productDataBean contract price: a) no price available, b) the minimum price, c) the price range.
																						  * The 2nd choose block determines whether to show the list price.
																						  * List price is only displayed if it is greater than the discountCatalogEntryDB.productDataBean price and if the discountCatalogEntryDB.productDataBean does not have price range (i.e. min price == max price)
																						  ***
																						--%>
																						<c:choose>
																							<c:when test="${catalogEntry.isProduct}">
																							 	<c:set var="type" value="product"/>
																								<c:catch var="searchServerException">
																									<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${catalogEntry.productDataBean.productId}" >
																										<wcf:param name="langId" value="${langId}"/>
																										<wcf:param name="currency" value="${env_currencyCode}"/>
																										<wcf:param name="responseFormat" value="json"/>
																										<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																										<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
																										<c:forEach var="contractId" items="${env_activeContractIds}">
																											<wcf:param name="contractId" value="${contractId}"/>
																										</c:forEach>
																									</wcf:rest>
																								</c:catch>
																								<c:set var="catalogEntryTemp" value="${catalogEntry}" />
																								<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}" />
																								<%@ include file="../../Snippets/ReusableObjects/CatalogEntryPriceDisplay.jspf"%>
																								<c:set var="catalogEntry" value="${catalogEntryTemp}" />
																							</c:when>
																							<c:otherwise>
																								<c:set var="discountItemDB" value="${catalogEntry}"/>
																								<c:set var="catalogEntryIdForPriceRule" value="${catalogEntry.catalogEntryId}"/>
																								<%@ include file="../../Snippets/ReusableObjects/GetCatalogEntryDisplayPrice.jspf"%>
																								<c:choose>
																									<c:when test="${(empty displayPriceAmount)&&(empty discountItemDB.calculatedContractPrice)}" >
																										<c:set var="productDataBeanPriceString"><fmt:message bundle="${storeText}" key="NO_PRICE_AVAILABLE" /></c:set>
																									</c:when>
																									<c:when test="${ listPriced && (!empty displayPriceAmount) && (!empty discountItemDB.calculatedContractPrice) && (discountItemDB.calculatedContractPrice.amount < displayPriceAmount)}" >
																										<c:set var="productDataBeanPriceString" value="${discountItemDB.calculatedContractPrice}" />
																										<!-- The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
																										These descriptions are necessary for meeting Accessibility requirements -->
																										<a href="#" id="WC_CacheddiscountCatalogEntryDB.productDataBeanOnlyDisplay_Link_2"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message bundle="${storeText}" key="RegularPriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="listPrice"><fmt:formatNumber value="${displayPriceAmount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></span>
																										<br />
																										<a href="#" id="WC_CachedProductOnlyDisplay_Link_3_<c:out value='${counter.count}'/>"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message bundle="${storeText}" key="SalePriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="redPrice"><fmt:formatNumber value="${productDataBeanPriceString.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></span>
																									</c:when>
																							 		<c:otherwise>
																									<%--	The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
																										These descriptions are necessary for meeting Accessibility requirements --%>
																										<a href="#" id="WC_CacheddiscountCatalogEntryDB.productDataBeanOnlyDisplay_Link_4"><img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt='<fmt:message bundle="${storeText}" key="PriceIs" />' width="1" height="1" border="0"/></a>
																										<span class="price">
																											<fmt:formatNumber value="${discountItemDB.calculatedContractPrice.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/>
																											<c:out value="${CurrencySymbol}"/>
																										</span>
																									</c:otherwise>
																								</c:choose>
																							</c:otherwise>
																						</c:choose>
																					</c:if>

																				</td>
																				<%--
																					***
																					* Draw another row if number of items/products displayed on this row is greater than
																					* the number specified by MaxInRow
																					***
																				--%>
																				<c:if test="${(counter.count) % maxInRow==0 }">
																					</tr>
																					<tr>
																				</c:if>
																			</c:forEach>
																		</tr>
																		</c:if>

																		<tr>
																			<td colspan="<c:out value="${maxInRow}"/>" id="WC_DiscountDetailsDisplay_TableCell_12">
																				<br />
																				<span class="discount">
																					<fmt:message bundle="${storeText}" key="DETAILED_DISCOUNT_DISCLAIMER"/>
																				</span>
																			</td>
																		</tr>
																	</table>
																</td>
																<%--
																	***
																	* End check for discounted products.
																	***
																--%>

															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr>
												<td id="WC_DiscountDetailsDisplay_TableCell_13">
													<fmt:message bundle="${storeText}" key="DISCOUNTDETAILS_ERROR"/>
												</td>
											</tr>
										</c:otherwise>
									</c:choose>
									<%--
										***
										* End check for valid discount
										***
									--%>
								</div>
									<br /><br />
									<a href="#" class="button_primary" id="discountDetailsPageBack" tabindex="0" onclick="javascript:history.back(1);return false;">
													<div class="left_border"></div>
													<div class="button_text"><fmt:message bundle="${storeText}" key="BACK" /></div>
													<div class="right_border"></div>
												</a>
							</div>
							<!-- Content End -->
						</div>
						<!-- Main Content End -->
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->

</div>
<!-- Page End -->

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END DiscountDetailsDisplay.jsp -->