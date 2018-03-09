

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AdvancedSearchDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="searchTypeAll" value="2"/>
<c:set var="searchTypeExact" value="1"/>
<c:set var="searchTypeAny" value="0"/>
<c:set var="needVfileStylesheet" value="true" scope="request"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../Common/CommonCSSToInclude.jspf" %>
		<%@ include file="../../Common/CommonJSToInclude.jspf" %>
				
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message bundle="${storeText}" key="TITLE_ADVANCED_SEARCH"/></title>
		<meta name="description" content="<fmt:message bundle="${storeText}" key="TITLE_ADVANCED_SEARCH"/>"/>
		<meta name="keywords" content="<fmt:message bundle="${storeText}" key="TITLE_ADVANCED_SEARCH"/>"/>
	</head>

	<body>

	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
	<%@ include file="Search_Data.jspf" %>


	<div id="page">
		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<!-- Header Nav End -->

			<!--Start Page Content -->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">					
								<div class="container_full_width">	
									<!-- Content Start -->
									<div id="box">
										<div class="sign_in_registration" id="WC_AdvancedSearchForm_div_1">
											<div class="title" id="WC_AdvancedSearchForm_div_2">
												<h1>
													<fmt:message bundle="${storeText}" key="TITLE_ADVANCED_SEARCH"/>
												</h1>
											</div>
											<form name="AdvancedSearchForm" action="SearchDisplay" method="get" id="AdvancedSearchForm">
												<input type="hidden" name="advancedSearch" value= "1"/>
												<input type="hidden" name="searchSource" value="A" id="searchSource"/>
												<input type="hidden" name="storeId" value= "${storeId}"/>
												<input type="hidden" name="catalogId" value= "${catalogId}"/>
												<div class="form" id="WC_AdvancedSearchForm_div_3">
													<div class="myaccount_header" id="WC_AdvancedSearchForm_div_4">
														<h2 class="registration_header"><fmt:message bundle="${storeText}" key="ADVANCED_SEARCH_MESSAGE"/></h2>
													</div>
													<div class="content" id="WC_AdvancedSearchForm_div_5">
														<div class="align" id="WC_AdvancedSearchForm_div_6">
															<div class="form_2column" id="WC_AdvancedSearchForm_div_7">
																<div class="column" id="WC_AdvancedSearchForm_div_8">
																	<div class="column_label" id="WC_AdvancedSearchForm_div_9">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_searchTerm">
																				<fmt:message bundle="${storeText}" key="SEARCH_FOR"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="SEARCH_FOR"/>
																	</div>
																	<input type="text" size="26" maxlength="254" aria-required="true" name="searchTerm" id="WC_AdvancedSearchForm_FormInput_searchTerm"  value="<c:out value="${WCParam.searchTerm}"/>"/>
																	<label for="WC_AdvancedSearchForm_FormInput_searchType" class="nodisplay"><fmt:message bundle="${storeText}" key="SEARCH_FOR_OPTIONS" /></label>
																	<select name="searchType" id="WC_AdvancedSearchForm_FormInput_searchType">
																		<option value="${searchTypeAny}" <c:if test="${!empty WCParam.searchType && WCParam.searchType==searchTypeAny}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="ANY_WORDS" />
																		</option>																		
																		<option value="${searchTypeAll}" <c:if test="${!empty WCParam.searchType && WCParam.searchType==searchTypeAll}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="ALL_WORDS" />
																		</option>
																		
																		<option value="${searchTypeExact}" <c:if test="${!empty WCParam.searchType && WCParam.searchType==searchTypeExact}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="EXACT_PHRASE" />
																		</option>
																	</select>
																</div>

						                                        <div class="column" id="WC_AdvancedSearchForm_div_10">
						                                             <div class="column_label" id="WC_AdvancedSearchForm_div_11">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_filterTerm">
																				<fmt:message bundle="${storeText}" key="EXCLUDE_WORDS"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="EXCLUDE_WORDS"/>
																	</div>
																	<input size="46" maxlength="50" aria-required="false" name="filterTerm" id="WC_AdvancedSearchForm_FormInput_filterTerm" value="<c:out value="${WCParam.filterTerm}"/>" />
																	<input type="hidden" name="filterType" id="WC_AdvancedSearchForm_FormInput_filterType" value="${searchTypeAny}" />
																</div>
																<div class="column" id="WC_AdvancedSearchForm_div_12">
																	<div class="column_label" id="WC_AdvancedSearchForm_div_13">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_categoryId">
																				<fmt:message bundle="${storeText}" key="SEARCH_IN1"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="SEARCH_IN1"/>
																	</div>
																	<select name="categoryId" id="WC_AdvancedSearchForm_FormInput_categoryId">
																		<option value=""><fmt:message bundle="${storeText}" key="SEARCH_ALL_DEPARTMENTS" /></option>
																		<c:forEach var="topCategory" items="${searchDropdownCategoryList}" varStatus="status">
																			<option value=${topCategory[1]} <c:if test="${WCParam.categoryId == topCategory[1]}">selected="selected"</c:if>><c:out value="${topCategory[0]}"/></option>
																		</c:forEach>
																	</select>
																</div>

																<div class="column" id="WC_AdvancedSearchForm_div_19">
																	<div class="column_label" id="WC_AdvancedSearchForm_div_20">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_manufacturer">
																				<fmt:message bundle="${storeText}" key="SEARCH_BRANDS"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="SEARCH_BRANDS"/>
						                                             </div>
						                                             <input type="text" size="46" maxlength="50" aria-required="false" name="manufacturer" id="WC_AdvancedSearchForm_FormInput_manufacturer" value="<c:out value="${WCParam.manufacturer}"/>" />
						                                        </div>
																<div class="column" id="WC_AdvancedSearchForm_div_21">
																	<div class="column_label" id="WC_AdvancedSearchForm_div_22">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_searchTermScope">
																				<fmt:message bundle="${storeText}" key="SEARCH_FOR_WORD_IN"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="SEARCH_FOR_WORD_IN"/>
																	</div>
																	<select size="1" name="searchTermScope" id="WC_AdvancedSearchForm_FormInput_searchTermScope">
																		<option value="0"></option>
																		<option value="1" <c:if test="${!empty WCParam.searchTermScope && WCParam.searchTermScope=='1'}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="PRODUCT_NAME_DESC" />
																		</option>
																		<option value="2" <c:if test="${!empty WCParam.searchTermScope && WCParam.searchTermScope=='2'}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="PRODUCT_NAME_ONLY" />
																		</option>
																		<option value="3" <c:if test="${!empty WCParam.searchTermScope && WCParam.searchTermScope=='3'}">selected="selected"</c:if>>
																			<fmt:message bundle="${storeText}" key="PRODUCT_ATTACHMENT_ONLY" />
																		</option>
																	</select>
																</div>

																<c:set var="globalpricemode" value="${cookie.priceMode.value}" scope="request"/>
																<c:if test="${globalpricemode == null}">
																	<c:set var="term" value="" />
																	<c:catch var="searchServerException">
																		<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/bySearchTerm/${term}" >
																			<wcf:param name="langId" value="${langId}"/>
																			<wcf:param name="currency" value="${env_currencyCode}"/>
																			<wcf:param name="responseFormat" value="json"/>     
																			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																			<c:forEach var="contractId" items="${env_activeContractIds}">
																				<wcf:param name="contractId" value="${contractId}"/>
																			</c:forEach>
																		</wcf:rest>
																	</c:catch>

																	<c:set var="globalpricemode" value="${catalogNavigationView.metaData.price}" scope="request"/>
																	<%
																		Cookie priceModeCookie = new Cookie("priceMode", (String) request.getAttribute("globalpricemode"));
																		priceModeCookie.setPath("/");
																		response.addCookie(priceModeCookie);
																	%>
																</c:if>

																<c:choose>
																	<c:when test="${globalpricemode != 0}">
																		<div class="column" id="WC_AdvancedSearchForm_div_23">
																			<div class="column_label" id="WC_AdvancedSearchForm_div_24">
																				<span class="spanacce">
																					<label>
																						<fmt:message bundle="${storeText}" key="SEARCH_PRICE_RANGE"/>
																					</label>
																				</span>
																				<fmt:message bundle="${storeText}" key="SEARCH_PRICE_RANGE"/>
																			</div>
																			<div class="priceRangeContainer">
																				<div class="range">
																					<span class="<c:choose><c:when test="${locale == 'pl_PL' || isBiDiLocale}">right</c:when><c:otherwise>label</c:otherwise></c:choose>"><c:out value="${env_CurrencySymbolToFormat}" escapeXml="false"/></span><span class="inputbox"><input type="text" size="18" maxlength="50" aria-required="false" title='<fmt:message bundle="${storeText}" key="SEARCH_PRICE_RANGE"/> <fmt:message bundle="${storeText}" key="LN_SEARCH_FACET_LOWER_BOUND"/>' name="minPrice" id="WC_AdvancedSearchForm_FormInput_minPrice" value="<c:out value="${WCParam.minPrice}"/>"/></span>
																				</div>
																				<div>-</div>
																				<div class="range">
																					<span class="<c:choose><c:when test="${locale == 'pl_PL' || isBiDiLocale}">right</c:when><c:otherwise>label</c:otherwise></c:choose>"><c:out value="${env_CurrencySymbolToFormat}" escapeXml="false"/></span><span class="inputbox"><input type="text" size="19" maxlength="50" aria-required="false" title='<fmt:message bundle="${storeText}" key="SEARCH_PRICE_RANGE"/> <fmt:message bundle="${storeText}" key="LN_SEARCH_FACET_UPPER_BOUND"/>' name="maxPrice" id="WC_AdvancedSearchForm_FormInput_maxPrice" value="<c:out value="${WCParam.maxPrice}"/>"/></span>
																				</div>
																			</div>
																		</div>
																		<div class="clear_float"></div>
																	</c:when>
																	<c:otherwise>
																		<input type="hidden" name="minPrice" id="WC_AdvancedSearchForm_FormInput_minPrice" value=""/>
																		<input type="hidden" name="maxPrice" id="WC_AdvancedSearchForm_FormInput_maxPrice" value=""/>
																	</c:otherwise>
																</c:choose>

																<div class="column" id="WC_AdvancedSearchForm_div_25">
																	<div class="column_label" id="WC_AdvancedSearchForm_div_26">
																		<span class="spanacce">
																			<label for="WC_AdvancedSearchForm_FormInput_pageSize">
																				<fmt:message bundle="${storeText}" key="RESULTS_PER_PAGE"/>
																			</label>
																		</span>
																		<fmt:message bundle="${storeText}" key="RESULTS_PER_PAGE"/>
																	</div>
																	<select name="pageSize" id="WC_AdvancedSearchForm_FormInput_pageSize">
																		<option value="12" <c:if test="${!empty WCParam.pageSize && WCParam.pageSize=='12'}">selected="selected"</c:if>>12</option>
																		<option value="20" <c:if test="${!empty WCParam.pageSize && WCParam.pageSize=='20'}">selected="selected"</c:if>>20</option>
																		<option value="40" <c:if test="${!empty WCParam.pageSize && WCParam.pageSize=='40'}">selected="selected"</c:if>>40</option>
																	</select>
																</div>
															</div>
															<div class="clear_float"></div>
														</div>
													<div class="button_footer_line no_float" id="WC_AdvancedSearchForm_div_40">
														<a href="#" role="button" class="button_primary" id="WC_AdvancedSearchForm_links_1" tabindex="0" onclick="SearchJS.validateForm(byId('AdvancedSearchForm'));">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message bundle="${storeText}" key="SEARCH_CATALOG"/></div>												
															<div class="right_border"></div>
														</a>
													</div>

													</div>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Content End -->
		<!-- Footer Start -->
		<div class="footer_wrapper_position">
			<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
			<%out.flush();%>
		</div>
		<!-- Footer End -->
	</div>

	<script type="text/javascript">
		$( document ).ready(function() {
			<fmt:message bundle="${storeText}" key="EDPPaymentMethods_AMOUNT_NAN" var="EDPPaymentMethods_AMOUNT_NAN" />
			<fmt:message bundle="${storeText}" key="ERROR_EMPTY_SEARCH_FIELDS" var="ERROR_EMPTY_SEARCH_FIELDS" />
			<fmt:message bundle="${storeText}" key="ERROR_PRICE_RANGE" var="ERROR_PRICE_RANGE" />

			MessageHelper.setMessage("EDPPaymentMethods_AMOUNT_NAN", <wcf:json object="${EDPPaymentMethods_AMOUNT_NAN}"/>);
			MessageHelper.setMessage("ERROR_EMPTY_SEARCH_FIELDS", <wcf:json object="${ERROR_EMPTY_SEARCH_FIELDS}"/>);
			MessageHelper.setMessage("ERROR_PRICE_RANGE", <wcf:json object="${ERROR_PRICE_RANGE}"/>);
		});
	</script>

	<flow:ifEnabled feature="Analytics">
		<%@include file="../../AnalyticsFacetSearch.jspf" %>
		<cm:pageview pagename="${WCParam.pagename}" category="${WCParam.category}" 
		srchKeyword="${WCParam.searchTerms}" srchResults="${WCParam.searchCount}" 
			returnAsJSON="true" extraparms="${analyticsFacet}" />
	</flow:ifEnabled>
	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END AdvancedSearchDisplay.jsp -->
