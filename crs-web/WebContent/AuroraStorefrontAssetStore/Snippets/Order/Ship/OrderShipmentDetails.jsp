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
<!-- BEGIN OrderShipmentDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<c:if test='${param.email eq "true"}'>
	<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}" var="eHostPath" />
	<c:set value="${eHostPath}${jspStoreImgDir}" var="jspStoreImgDir" />
</c:if>

<c:if test='${param.email != "true"}'>
	<script type="text/javascript">
		$(document).ready(function() {
			ServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
			// On IE7, the specified div requires float:left in order for the CSS containers to show properly.  However, this change messes up the styling on all other
			// browsers.
			if (Utils.get_IE_version() === 7) {
				$('#WC_OrderShipmentDetails_div_16').css('float', 'left');
			}
		});
	</script>
</c:if>
<c:set var="subscriptionId" value="${WCParam.subscriptionId}" />
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<fmt:parseNumber var="pageSize" value="${pageSize}"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<c:choose>
	<c:when test="${WCParam.orderId != null}">
		<wcf:rest var="order" url="store/{storeId}/order/{orderId}" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
			<wcf:param name="accessProfile" value="IBM_Details" />
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="1"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		</wcf:rest>
		<c:set var="objectId" value="${order.orderId}"/>
	</c:when>

	<c:when test="${WCParam.externalOrderId != null}">
		<wcf:rest var="order" url="store/{storeId}/order/{orderId}" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:var name="orderId" value="${WCParam.externalOrderId}" encode="true"/>
			<wcf:param name="accessProfile" value="IBM_External_Details" />
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="1"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		</wcf:rest>
		<c:set var="objectId" value="${order.externalOrderID}"/>
	</c:when>

	<c:when test="${WCParam.quoteId != null}">
		<%/* Currently no local implementation available*/%>
	</c:when>
	<c:when test="${WCParam.externalQuoteId != null}">
		<wcf:rest var="quote" url="store/{storeId}/order" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="q" value="findQuoteByExternalQuoteId"/>
			<wcf:param name="quoteId" value="$PWCParam.externalQuoteId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="1"/>
		</wcf:rest>
		<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
		<c:set var="order" value="${quote.orderTemplate}" scope="request"/>
	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>

<c:if test="${order.orderStatus eq 'M'}">
	<%-- The following code snippet is used for handling the case where punchout payment was used as the payment method. --%>
	<c:set var="wasPunchoutPaymentUsed" value="false"/>
		<c:set var="breakLoop" value="false"/>
		<c:forEach var="paymentInstructionInstance" items="${order.paymentInstruction}" varStatus="paymentInstCount">
			<c:if test="${not breakLoop}">
				<c:if test="${paymentInstructionInstance.payMethodId eq 'SimplePunchout' or paymentInstructionInstance.xpaym_punchoutPayment eq 'true'}">
					<c:set var="wasPunchoutPaymentUsed" value="true"/>
					<c:set var="breakLoop" value="true"/>
				</c:if>
			</c:if>
		</c:forEach>
	<c:if test="${wasPunchoutPaymentUsed}">
		<jsp:useBean id="payInstMap" class="java.util.HashMap"/>
		<c:set var="isPunchoutPaymentPending" value="false"/>
		<c:forEach var="payInst" items="${order.paymentInstruction}">
			<c:set target="${payInstMap}" property="${payInst.piId}" value="${payInst.piStatus}"/>
			<c:if test="${(payInst.payMethodId eq 'SimplePunchout' or payInst.xpaym_punchoutPayment eq 'true') && payInst.piStatus eq 'Pending'}">
				<c:set var="isPunchoutPaymentPending" value="true"/>
			</c:if>
		</c:forEach>
	</c:if>
</c:if>

<c:set var="shipmentTypeId" value="1"/>

<fmt:parseNumber var="numEntries" value="${ShowVerbSummary.recordSetTotal}" integerOnly="true" />
<c:choose>
	<c:when test="${numEntries > maxOrderItemsToInspect}">
		<c:set var="shipmentTypeId" value="2"/>
	</c:when>
	<c:otherwise>
		<jsp:useBean id="blockMap" class="java.util.HashMap" scope="request"/>
		<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
			<c:set var="itemId" value="${orderItem.orderItemId}"/>
			<c:set var="addressId" value="${orderItem.addressId}"/>
			<c:set var="shipModeId" value="${orderItem.shipModeId}"/>
			<c:set var="keyVar" value="${addressId}_${shipModeId}"/>
			<c:set var="itemIds" value="${blockMap[keyVar]}"/>
			<c:choose>
				<c:when test="${empty itemIds}">
					<c:set target="${blockMap}" property="${keyVar}" value="${itemId}"/>
				</c:when>
				<c:otherwise>
					<c:set target="${blockMap}" property="${keyVar}" value="${itemIds},${itemId}"/>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:choose>
			<c:when test="${fn:length(blockMap) == 1}">
				<c:set var="shipmentTypeId" value="1"/>
			</c:when>
			<c:otherwise>
				<c:set var="shipmentTypeId" value="2"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>



<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:choose>
	<c:when test ="${order.grandTotal != null}">
		<c:set var="key1" value="store/${storeId}/currency_format+byCurrency+${order.grandTotalCurrency}+-1+${langId}"/>
		<c:set var="currencyFormatterDB" value="${cachedOnlineStoreMap[key1]}"/>
		<c:if test="${empty currencyFormatterDB}">
			<wcf:rest var="getCurrencyFormatResponse" url="store/{storeId}/currency_format" cached="true">
				<wcf:var name="storeId" value="${storeId}" />
				<wcf:param name="q" value="byCurrency" />
				<wcf:param name="currency" value="${order.grandTotalCurrency}" />
				<wcf:param name="numberUsage" value="-1" />
				<wcf:param name="langId" value="${langId}" />
			</wcf:rest>
			<c:set var="currencyFormatterDB" value="${getCurrencyFormatResponse.resultList[0]}" scope="request" />
			<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${currencyFormatterDB}"/>
		</c:if>

		<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>
		<c:if test="${order.grandTotalCurrency == 'KRW'}">
			<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
		</c:if>
		<c:if test="${order.grandTotalCurrency == 'PLN'}">
			<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
		</c:if>
		<c:if test="${order.grandTotalCurrency == 'ILS' && locale == 'iw_IL'}">
			<c:set property="currencySymbol" value="&#1513;&#1524;&#1495;" target="${currencyFormatterDB}"/>
		</c:if>

		<%-- These variables are used to hold the currency symbol --%>
		<c:choose>
			<c:when test="${locale == 'ar_EG' && order.grandTotalCurrency == 'EGP'}">
				<c:set var="CurrencySymbolToFormat" value=""/>
				<c:set var="CurrencySymbol" value="${currencyFormatterDB.currencySymbol}"/>
			</c:when>
			<c:otherwise>
				<c:set var="CurrencySymbolToFormat" value="${currencyFormatterDB.currencySymbol}"/>
				<c:set var="CurrencySymbol" value=""/>
			</c:otherwise>
		</c:choose>

	</c:when>
</c:choose>
<c:set var="person" value="${requestScope.person}"/>
<c:if test="${empty person || person==null}">
	<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
</c:if>	
<c:set var="personAddresses" value="${person}"/>
<c:set var="numberOfPaymentMethods" value="${fn:length(order.paymentInstruction)}"/>
<div id="box" class="myAccountMarginRight">
	<div class="my_account" id="WC_OrderShipmentDetails_div_1">
		<c:choose>
			<c:when test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
				<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<flow:ifEnabled feature="Subscription">
						<c:catch var="searchServerException">
							<wcf:rest var="catEntry" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${WCParam.subscriptionCatalogEntryId}" >
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="currency" value="${env_currencyCode}" />
								<wcf:param name="responseFormat" value="json" />
								<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
								<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
							</wcf:rest>
							<c:set var="catEntryName" value="${catEntry.catalogEntryView[0].name}" />
						</c:catch>
						<fmt:message bundle="${storeText}" var="openingBrace" key="OPENING_BRACE" />
						<c:choose>
							<c:when test="${fn:contains(catEntryName,openingBrace)}">
								<c:set var="subscriptionName" value="${fn:substringBefore(catEntryName,openingBrace)}"/>
							</c:when>
							<c:otherwise>
								<c:set var="subscriptionName" value="${catEntryName}"/>
							</c:otherwise>
						</c:choose>
					</flow:ifEnabled>
				</c:if>

				<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}" >
					<flow:ifEnabled feature="RecurringOrders">
						<fmt:message bundle="${storeText}" key="X_DETAILS"  var="RecurringOrderDetailBreadcrumbLinkLabel">
							<fmt:param><c:out value="${objectId}"/></fmt:param>
						</fmt:message>
						<script type="text/javascript">
							$(document).ready(function() {
								if(document.getElementById("RecurringOrderBreadcrumb")){
									document.getElementById("MyAccountBreadcrumbLink").style.display="none";
									document.getElementById("RecurringOrderDetailBreadcrumbLink").innerHTML="<c:out value='${RecurringOrderDetailBreadcrumbLinkLabel}' />";
									document.getElementById("RecurringOrderBreadcrumb").style.display="inline";
								}
							});
						</script>
					</flow:ifEnabled>
				</c:if>
				<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<flow:ifEnabled feature="Subscription">
						<script type="text/javascript">
							$(document).ready(function() {
								if(document.getElementById("SubscriptionBreadcrumb")){
									document.getElementById("MyAccountBreadcrumbLink").style.display="none";
									document.getElementById("SubscriptionDetailBreadcrumbLink").innerHTML="<c:out value='${subscriptionName}' />";
									document.getElementById("SubscriptionBreadcrumb").style.display="inline";
								}
							});
						</script>
					</flow:ifEnabled>
				</c:if>

				<!--- Tabs --->
				<div class="tab_container_top" >
					<div id="recurring_order_details_On">
						<div class="tab_clear"></div>
						<div class="tab_active_left"></div>
						<div class="tab_active_middle" id="tab_order_details1">
							<c:choose>
								<c:when test="${WCParam.isQuote eq true}">
									<fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
								</c:when>
								<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
									<c:out value="${subscriptionName}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="X_ORDER_DETAILS" >
										<fmt:param><c:out value="${objectId}"/></fmt:param>
									</fmt:message>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tab_active_inactive"></div>
					</div>
					<div id="recurring_order_details_Off" style="display:none">
						<div class="tab_clear"></div>
						<div class="tab_inactive_left"></div>
						<div class="tab_inactive_middle" id="tab_order_details">
							<a href="javascript:MyAccountDisplay.selectRecurringOrderTab('recurring_order_details');" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<c:out value="${subscriptionName}"/>
									</c:when>
									<c:when test="${WCParam.isQuote eq true}">
										<fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
									</c:when>
									<c:otherwise>
										<fmt:message bundle="${storeText}" key="X_ORDER_DETAILS" >
											<fmt:param><c:out value="${objectId}"/></fmt:param>
										</fmt:message>
									</c:otherwise>
								</c:choose>
							</a>
						</div>
						<div class="tab_inactive_active"></div>
					</div>

					<div id="recurring_order_history_Off">
						<div class="tab_inactive_middle" id="tab_order_history1">
							<a href="javascript:MyAccountDisplay.selectRecurringOrderTab('recurring_order_history');" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_HISTORY" />
									</c:when>
									<c:otherwise>
										<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDER_HISTORY" >
											<fmt:param value="${objectId}" />
										</fmt:message>
									</c:otherwise>
								</c:choose>
							</a>
						</div>
						<div class="tab_inactive_right"></div>
					</div>
					<div id="recurring_order_history_On" style="display:none">
						<div class="tab_active_middle" id="tab_order_history">
							<a href="#" class="tab_link">
								<c:choose>
									<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
										<fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_HISTORY" />
									</c:when>
									<c:otherwise>
										<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDER_HISTORY" >
											<fmt:param value="${objectId}" />
										</fmt:message>
									</c:otherwise>
								</c:choose>
							</a>
						</div>
						<div class="tab_active_right"></div>
					</div>
				</div>

				<div class="tab_container_base">
					<div class="tab_container_left"></div>
					<div class="tab_container_middle"></div>
					<div class="tab_container_right"></div>
				</div>
				<!--- End Tabs --->
			</c:when>
			<c:otherwise>
				<fmt:message bundle="${storeText}" key="X_DETAILS"  var="OrderHistoryDetailBreadcrumbLinkLabel">
					<fmt:param><c:out value="${objectId}"/></fmt:param>
				</fmt:message>
				<script type="text/javascript">
					$(document).ready(function() {
						if(document.getElementById("OrderHistoryBreadcrumb")){
							document.getElementById("MyAccountBreadcrumbLink").style.display="none";
							document.getElementById("OrderHistoryDetailBreadcrumbLink").innerHTML="<c:out value='${OrderHistoryDetailBreadcrumbLinkLabel}' />";
							document.getElementById("OrderHistoryBreadcrumb").style.display="inline";
						}
					});
				</script>
				<h2 class="myaccount_header">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_ORDERDETAILS" />
						</c:otherwise>
					</c:choose>
				</h2>
			</c:otherwise>
		</c:choose>

		<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
			<div id="mainTabContainer" class="mainTabContainer_body" data-widget-type="tabs" doLayout="false">
				<div id="recurring_order_details" selected="true">
		</c:if>

		<div class="body" id="WC_OrderShipmentDetails_div_6">
			<div class="order_details_my_account" id="WC_OrderShipmentDetails_div_7">
				<c:if test="${order.orderStatus eq 'W'}">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_QUOTE_PENDING_APPROVAL_MESSAGE" /></span></p>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_PENDING_APPROVAL_MESSAGE" /></span></p>
						</c:otherwise>
					</c:choose>
				</c:if>

				<p>
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_QUOTE_NUMBER" /></span>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${order.orderStatus eq 'I' && order.orderTypeCode ne 'REC'}">
									<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER" /></span>
								</c:when>
								<c:when test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}">
									<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="ORD_SCHEDULED_ORDER_NUMBER" /></span>
								</c:when>
								<c:when test="${order.orderStatus eq 'M' && isPunchoutPaymentPending eq true}">
									<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="PUNCHOUT_PAYMENT_PAY_INSTRUCTION_MSG" /></span>
								</c:when>
								<c:otherwise>
									<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER" /></span>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
					<c:if test="${isPunchoutPaymentPending ne true}">
						<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${objectId}"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							</c:otherwise>
						</c:choose>
					</c:if>
				</p>
				<c:if test="${!(order.orderStatus eq 'I' || order.orderStatus eq 'W') && (WCParam.currentSelection ne 'RecurringOrderDetailSlct') && (WCParam.currentSelection ne 'SubscriptionDetailSlct')}">
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_QUOTE_DATE" /></span>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_DATE" /></span>
						</c:otherwise>
					</c:choose>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
							<c:when test="${!empty expectedDate}">
								<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></p>
							</c:otherwise>
					</c:choose>

				</c:if>
				<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}" >
					<c:choose>
						<c:when test="${WCParam.isQuote eq true}">
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_QUOTE_DATE" /></span>
						</c:when>
						<c:otherwise>
							<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_DATE" /></span>
						</c:otherwise>
					</c:choose>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expectedDate}">
							<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>
				</c:if>
				<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
					<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_DATE" /></span>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expectedDate}">
							<fmt:formatDate value="${expectedDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>
					<wcf:rest var="subscription" url="/store/{storeId}/subscription">
						<wcf:var name="storeId" value="${storeId}" />
						<wcf:param name="q" value="bySubscriptionIds"/>
						<wcf:param name="profileName" value="IBM_Store_Details"/>
						<wcf:param name="subscriptionId" value="${subscriptionId}"/>
					</wcf:rest>

					<p><span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_EXPIRY_DATE" /></span>
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="expiryDate" value="${subscription.resultList[0].subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/> 
					</c:catch>
					<c:if test="${empty expiryDate}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="expiryDate" value="${subscription.resultList[0].subscriptionInfo.fulfillmentSchedule.endInfo.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<c:choose>
						<c:when test="${!empty expiryDate}">
							<fmt:formatDate value="${expiryDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></p>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></p>
						</c:otherwise>
					</c:choose>

				</c:if>
				<br/>
			</div>

			<div  id="WC_UserRegistrationUpdateForm_div_42" class="button_footer_line button_footer_line_csr">
				<c:if test="${WCParam.isQuote ne true}">
					<flow:ifEnabled feature="AllowReOrder">
						<c:choose>
							<c:when test="${!empty order.externalOrderID}">
								<c:set var="objectId" value="${order.externalOrderID}"/>
							</c:when>
							<c:otherwise>
								<c:set var="objectId" value="${order.orderId}"/>
							</c:otherwise>
						</c:choose>
						<wcf:url value="AjaxRESTOrderCopy" var="OrderCopyUrl" type="Ajax">
							<wcf:param name="fromOrderId_1" value="${objectId}"/>
							<wcf:param name="toOrderId" value=".**."/>
							<wcf:param name="copyOrderItemId_1" value="*"/>
							<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
							<wcf:param name="storeId" value="${WCParam.storeId}"/>
							<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
							<wcf:param name="langId" value="${WCParam.langId}"/>
							<wcf:param name="inventoryValidation" value="true"/>
						</wcf:url>
					</flow:ifEnabled>	
					<a onclick="javascript:MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>'); return false;" class="button_primary" href="#" id="ReorderCSR">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message key="MO_REORDER" bundle="${storeText}"/></div>												
						<div class="right_border"></div>
					</a>
				</c:if>
				<c:if test = "${fn:contains(validOrderStatusForCancel,order.orderStatus) && env_shopOnBehalfSessionEstablished eq 'true'}">
					<%-- Order status allows cancelation. CSR is accessing store on-behalf of shopper. Display cancel button --%>
					<wcf:url var="cancelRedirectURL" value="TrackOrderStatus">
						<wcf:param name="storeId"   value="${WCParam.storeId}"  />
						<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="orderStatusStyle" value="strong"/>
						<flow:ifEnabled feature="contractSelection">
							<wcf:param name="showOrderHeader" value="false"/>
						</flow:ifEnabled>
						<flow:ifDisabled feature="contractSelection">
							<wcf:param name="showOrderHeader" value="true"/>
						</flow:ifDisabled>			
					</wcf:url>
					<c:if test="${guestOrderDetails eq 'true'}">
						<c:set var="cancelRedirectURL" value="${env_TopCategoriesDisplayURL}"/>
					</c:if>
					<a onclick="javascript:onBehalfUtilitiesJS.cancelOrder('${order.orderId}', '${cancelRedirectURL}', 'true'); return false;" class="button_primary button_left_padding" href="#" id="CancelOrderCSR">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message key="CANCEL_ORDER_CSR" bundle="${storeText}"/></div>												
						<div class="right_border"></div>
					</a>
				</c:if>
			</div>
			<br clear="all"/>

			

			<div class="myaccount_header" id="WC_OrderShipmentDetails_div_8">
				<div class="left_corner_straight" id="WC_OrderShipmentDetails_div_9"></div>
				<div class="headingtext" id="WC_OrderShipmentDetails_div_10"><span class="header"><fmt:message bundle="${storeText}" key="MO_SHIPPINGINFO" /></span></div>
				<div class="right_corner_straight" id="WC_OrderShipmentDetails_div_11"></div>
			</div>
			<div class="myaccount_content margin_below" id="WC_OrderShipmentDetails_div_16">
				<div id="shipping">
					<c:choose>
						<c:when test="${shipmentTypeId == 1}">
							<div class="shipping_address" id="WC_OrderShipmentDetails_div_17">
								<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_SHIPPINGADDRESS" /></p>

								<c:set var="contact" value="${order.orderItem[0]}" />

								<c:if test="${!empty contact.nickName}">
									<p>
										<c:choose>
											<c:when test="${contact.nickName eq  profileShippingNickname}">
												<fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING" />
											</c:when>
											<c:when test="${contact.nickName eq  profileBillingNickname}">
												<fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING" />
											</c:when>
											<c:otherwise>
												<c:out value="${contact.nickName}"/>
											</c:otherwise>
										</c:choose>
									</p>
								</c:if>

								<!-- Display shipping address of the order -->
								<%@ include file="../../ReusableObjects/AddressDisplay.jspf"%>
							</div>

							<div class="shipping_method" id="WC_OrderShipmentDetails_div_18">
								<p>
									<flow:ifEnabled feature="ShipAsComplete">
										<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE" />: </span>
										<c:choose>
											<c:when test='${order.shipAsComplete}'>
												<span class="text"><fmt:message bundle="${storeText}" key="YES" /></span>
											</c:when>
											<c:otherwise>
												<span class="text"><fmt:message bundle="${storeText}" key="NO" /></span>
											</c:otherwise>
										</c:choose>
									</flow:ifEnabled>
								</p>
								<br />

								<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_SHIPPINGMETHOD" /></p>
								<p>
								<c:choose>
									<c:when test="${!empty order.orderItem[0].shipModeDescription}">
										<c:out value="${order.orderItem[0].shipModeDescription}"/>
									</c:when>
									<c:otherwise>
										<c:out value="${order.orderItem[0].shipModeCode}"/>
									</c:otherwise>
								</c:choose>
								</p>
								<br />
								<c:if test="${orderPage == 'confirmation'}">
									<flow:ifEnabled feature="FutureOrders">
										<c:if test="${!isOrderScheduled}">
											<c:set var="requestedShipDate" value="${order.orderItem[0].requestedShipDate}"/>

											<c:if test='${!empty requestedShipDate}'>
												<c:catch>
													<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
												</c:catch>
												<c:if test="${empty expectedShipDate}">
													<c:catch>
														<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
													</c:catch>
												</c:if>

												<%-- Format the timezone retrieved from cookie since it is in decimal representation --%>
												<%-- Convert the decimals back to the correct timezone format such as :30 and :45 --%>
												<%-- Only .75 and .5 are converted as currently these are the only timezones with decimals --%>
												<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
												<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
												<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>
												<fmt:formatDate value="${expectedShipDate}" type="date" dateStyle="long" var="formattedDate" timeZone="${formattedTimeZone}"/>
												<c:if test="${!empty formattedDate}">
													<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_COLON"/></p>
													<p class="text"><c:out value="${formattedDate}"/></p>
													<br />
												</c:if>
											</c:if>
										</c:if>
									</flow:ifEnabled>
								</c:if>
								<br clear="all"/>

								<flow:ifEnabled feature="ShippingChargeType">
									<wcf:rest var="shipCharges" url="store/{storeId}/cart/{orderId}/usable_ship_charges_by_ship_mode">
										<wcf:var name="storeId" value="${storeId}" />
										<wcf:var name="orderId" value="${order.orderId}" />
									</wcf:rest>
									<c:set var="shipCharges" value="${shipCharges.resultList[0]}" />
									
									<c:if test="${not empty shipCharges.shipChargesByShipMode}">
										<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_shipModeData"  varStatus="counter1">
											<c:if test="${shipCharges_shipModeData.shipModeDesc == order.orderItem[0].shipModeDescription}">
												<c:forEach items="${shipCharges_shipModeData.shippingChargeTypes}" var="shipCharges_data"  varStatus="counter2">
													<c:if test="${shipCharges_data.selected}">
														<p>
															<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="ShippingChargeType_colon" /></span>
															<span class="text"><fmt:message bundle="${storeText}" key="${shipCharges_data.policyName}" /></span>
														</p>
														<c:if test="${shipCharges_data.carrAccntNumber != null && shipCharges_data.carrAccntNumber != ''}">
															<p>
																<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="ShippingChargeAcctNum_colon" /></span>
																<span class="text"><c:out value="${shipCharges_data.carrAccntNumber}"/></span>
															</p>
														</c:if>
													</c:if>
												</c:forEach>
											</c:if>
										</c:forEach>
									</c:if>
								</flow:ifEnabled>

								<flow:ifEnabled feature="ShippingInstructions">
									<c:if test="${!empty order.orderItem[0].shipInstruction}">
										<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS"  />: </p>
										<p class="text"><c:out value="${order.orderItem[0].shipInstruction}"/></p>
										<br />
									</c:if>
								</flow:ifEnabled>
							</div>
							
							<%-- Display Single shipment confirmation page --%>
							<c:if test='${param.email != "true"}'>

								<wcf:url var="currentOrderItemDetailPaging" value="OrderItemPageView" type="Ajax">
									<wcf:param name="storeId" value="${WCParam.storeId}"  />
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${WCParam.langId}" />
									<wcf:param name="orderPage" value="confirmation" />
									<wcf:param name="orderId" value="${WCParam.orderId}" />
								</wcf:url>
								
								<span id="OrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
								<div wcType="RefreshArea" id="OrderConfirmPagingDisplay" refreshurl="${currentOrderItemDetailPaging}" declareFunction="CommonControllersDeclarationJS.declareOrderItemPaginationDisplayRefreshArea('OrderConfirmPagingDisplay')"
								ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="OrderConfirmPagingDisplay_ACCE_Label"
								refreshurl="<c:out value='${currentOrderItemDetailPaging}'/>">
							</c:if>
							<c:choose>
								<c:when test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
									<%out.flush();%>
										<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">
											<c:param name="catalogId" value="${WCParam.catalogId}" />
											<c:param name="langId" value="${WCParam.langId}" />
											<c:param name="storeId" value="${storeId}"/>
											<c:param name="orderPage" value="confirmation" />
											<c:param name="isFromOrderDetailsPage" value="true" />
										</c:import>
									<%out.flush();%>
								</c:when>
								<c:otherwise>
									<%out.flush();%>
										<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">
											<c:param name="catalogId" value="${WCParam.catalogId}" />
											<c:param name="langId" value="${WCParam.langId}" />
											<c:param name="storeId" value="${storeId}"/>
											<c:param name="orderPage" value="confirmation" />
											<c:param name="isFromOrderDetailsPage" value="true" />
											<c:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
										</c:import>
									<%out.flush();%>
								</c:otherwise>
							</c:choose>
							<c:if test='${param.email != "true"}'>
								</div>
							</c:if>
						</c:when>
						<c:otherwise>
							<div class="shipping_method" id="WC_OrderShipmentDetails_div_35">
								<p>
									<flow:ifEnabled feature="ShipAsComplete">
										<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE" />: </span>
										<c:if test='${order.shipAsComplete}'>
											<span class="text"><fmt:message bundle="${storeText}" key="YES" /></span>
										</c:if>
										<c:if test='${!order.shipAsComplete}'>
											<span class="text"><fmt:message bundle="${storeText}" key="NO" /></span>
										</c:if>
									</flow:ifEnabled>
								</p>
							</div>

							<%-- Display Multiple shipment confirmation page --%>
							<c:if test='${param.email != "true"}'>
							<span id="MSOrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
							<!-- This refreshArea is only used when file "storefront/mobile30/ShoppingArea/OrderSection/OrderDetails.jsp" or "storefront/UserArea/ServiceSection/TrackOrderStatusSubsection/GuestOrderDetailDisplay.jsp" is being included. -->
							<div dojoType="wc.widget.RefreshArea" widgetId="MSOrderConfirmPagingDisplay" id="MSOrderDetailPagingDisplay"
								controllerId="MSOrderItemPaginationDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="MSOrderConfirmPagingDisplay_ACCE_Label">
							</c:if>
							<c:choose>
								<c:when test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
									<%out.flush();%>
									<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp">
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${storeId}"/>
										<c:param name="orderPage" value="confirmation" />
										<c:param name="isFromOrderDetailsPage" value="true" />
									</c:import>
									<%out.flush();%>
								</c:when>
								<c:otherwise>
									<%out.flush();%>
									<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/MSOrderItemDetailSummary.jsp">
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${storeId}"/>
										<c:param name="orderPage" value="confirmation" />
										<c:param name="isFromOrderDetailsPage" value="true" />
										<c:param name="subscriptionOrderItemId" value="${WCParam.orderItemId}" />
									</c:import>
									<%out.flush();%>
								</c:otherwise>
							</c:choose>
							<c:if test='${param.email != "true"}'>
								</div>
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:if test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
						<div id="total_breakdown">
							<table id="order_total" cellpadding="0" cellspacing="0" border="0" role="presentation">

								<%-- ORDER SUBTOTAL--%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_1"><fmt:message bundle="${storeText}" key="MO_ORDERSUBTOTAL" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_2">
										<c:choose>
											<c:when test="${!empty order.totalProductPrice}">
												<fmt:formatNumber value="${order.totalProductPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<%-- DISCOUNT ADJUSTMENTS --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_11"><fmt:message bundle="${storeText}" key="MO_DISCOUNTADJ" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_12">
										<c:choose>
											<c:when test="${!empty order.totalAdjustment}">
												<fmt:formatNumber value="${order.totalAdjustment}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<%-- TAX --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message bundle="${storeText}" key="MO_TAX" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_6">
										<c:choose>
											<c:when test="${!empty order.totalSalesTax}">
												<fmt:formatNumber value="${order.totalSalesTax}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<%-- SHIPPING CHARGE --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_7"><fmt:message bundle="${storeText}" key="MO_SHIPPING" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_8">
										<c:choose>
											<c:when test="${!empty order.totalShippingCharge}">
												<fmt:formatNumber value="${order.totalShippingCharge}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<%-- SHIPPING TAX --%>
								<tr>
									<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_14"><fmt:message bundle="${storeText}" key="MO_SHIPPING_TAX" /></td>
									<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_15">
										<c:choose>
											<c:when test="${!empty order.totalShippingTax}">
												<fmt:formatNumber value="${order.totalShippingTax}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<%-- ORDER TOTAL --%>
								<tr>
									<td class="total_details order_total" id="WC_SingleShipmentOrderTotalsSummary_td_9"><fmt:message bundle="${storeText}" key="MO_ORDERTOTAL" /></td>
									<td class="total_figures breadcrumb_current" id="WC_SingleShipmentOrderTotalsSummary_td_10">
										<c:choose>
											<c:when test="${order.grandTotal != null}">
													<c:choose>
													<c:when test="${!empty order.grandTotal}">
														<fmt:formatNumber value="${order.grandTotal}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
													</c:when>
													<c:otherwise>
														<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</table>
						</div>
					</c:if>
					<br clear="all" />
				</div>
			</div>

			<c:if test="${WCParam.currentSelection ne 'SubscriptionDetailSlct'}">
				<c:set var="scheduledOrderEnabled" value="false"/>
				<c:set var="recurringOrderEnabled" value="false"/>
				<flow:ifEnabled feature="ScheduleOrder">
					<c:set var="scheduledOrderEnabled" value="true"/>
				</flow:ifEnabled>
				<flow:ifEnabled feature="RecurringOrders">
					<c:set var="recurringOrderEnabled" value="true"/>
				</flow:ifEnabled>
				<c:choose>
					<c:when test="${scheduledOrderEnabled == 'true'}">
						<c:if test="${WCParam.isQuote != true}">
							<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ScheduleOrderDisplayExt.jsp">
									<c:param value="false" name="isShippingBillingPage"/>
									<c:param value="${order.orderId}" name="orderId"/>
								</c:import>
							<%out.flush();%>
						</c:if>
					</c:when>
					<c:when test="${recurringOrderEnabled == 'true'}">
						<c:if test="${WCParam.isQuote != true}">
							<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/RecurringOrderCheckoutDisplay.jsp">
									<c:param value="false" name="isShippingBillingPage"/>
									<c:param value="${order.orderId}" name="orderId"/>
									<c:param name="subscriptionId" value="${subscriptionId}"/>
								</c:import>
							<%out.flush();%>
						</c:if>
					</c:when>
					<c:otherwise>

					</c:otherwise>
				 </c:choose>
			</c:if>
			<br/>
			<c:if test="${order.orderTypeCode ne 'SUB'}">
				<div class="myaccount_header" id="WC_OrderShipmentDetails_div_21">
					<div class="left_corner_straight" id="WC_OrderShipmentDetails_div_22"></div>
					<div class="headingtext" id="WC_OrderShipmentDetails_div_23"><span class="header"><fmt:message bundle="${storeText}" key="MO_BILLINGINFO" /></span></div>
					<div class="right_corner_straight" id="WC_OrderShipmentDetails_div_24"></div>
				</div>
				<c:set var="paymentInstruction" value="${order}"/>
				<%@ include file="../../../ShoppingArea/CheckoutSection/CheckoutPaymentAndBillingAddressSummary.jspf" %>
				<%@ include file="../../../ShoppingArea/CheckoutSection/OrderAdditionalDetailSummaryExt.jspf" %>
			</c:if>
			<br/>
			<div class="button_footer_line" id="WC_OrderShipmentDetails_div_29">

				<div id="WC_OrderShipmentDetails_div_31_1" class="button_primary">
					<a href="#" role="button" class="button_primary" id="WC_OrderDetailDisplay_Print_Link" onclick="JavaScript: print();">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message bundle="${storeText}" key="PRINT" /></div>
						<div class="right_border"></div>
					</a>
				</div>

				<div class="button_right_side_message" id="WC_OrderShipmentDetails_div_32_1">
					<fmt:message bundle="${storeText}" key="PRINT_RECOMMEND" />
				</div>
			</div>
			<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
				</div>
				</div>
			</c:if>

	<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct'}">
		<div id="recurring_order_history" style="display:none">
			<div class="body" id="WC_OrderShipmentDetails_div_26">
				<div id="WC_OrderShipmentDetails_div_27">
					<span id="RecurringOrderChildOrdersDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_History_List"/></span>
					<div wcType="RefreshArea" id="RecurringOrderChildOrdersDisplay" refreshurl="${RecurringOrderChildOrdersTableDetailsDisplay}" declareFunction="CommonControllersDeclarationJS.declareRecurOrderChildOrdersRefreshArea()" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_History_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="RecurringOrderChildOrdersDisplay_ACCE_Label">
						<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderChildOrdersTableDetailsDisplay.jsp">
								<c:param name="${objectIdParam}" value="${objectId}"/>
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
							</c:import>
						<%out.flush();%>
					</div>
				</div>
			</div>
			<div class="footer">
				<div class="left_corner"></div>
				<div class="tile"></div>
				<div class="right_corner"></div>
			</div>
		</div>
	</c:if>
	<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
		<div id="recurring_order_history" style="display:none">
			<div class="body" id="WC_OrderShipmentDetails_div_26a">
				<div id="WC_OrderShipmentDetails_div_27a" >
					<span id="SubscriptionChildOrdersDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Subscription_History_List"/></span>
					<div wcType="RefreshArea" id="SubscriptionChildOrdersDisplay" refreshurl="${SubscriptionChildOrdersTableDetailsDisplayURL}" declareFunction="CommonControllersDeclarationJS.declareSubscriptionChildOrdersRefreshArea()" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Subscription_History_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="SubscriptionChildOrdersDisplay_ACCE_Label">
						<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/SubscriptionChildOrdersTableDetailsDisplay.jsp">
								<c:param name="orderItemId" value="${WCParam.orderItemId}"/>
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
							</c:import>
						<%out.flush();%>
					</div>
				</div>
			</div>
			<div class="footer">
				<div class="left_corner"></div>
				<div class="tile"></div>
				<div class="right_corner"></div>
			</div>
		</div>
	</c:if>

<!-- Content End -->
</div>
</div>
</div>
<!-- END OrderShipmentDetails.jsp -->
