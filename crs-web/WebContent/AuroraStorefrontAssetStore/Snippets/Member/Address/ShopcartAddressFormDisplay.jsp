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
<!-- BEGIN ShopcartAddressFormDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>


<c:set var="addressId" value="${WCParam.addressId}"/>
<c:if test="${empty WCParam.addressId}" >
	<c:set var="addressId" value="${param.addressId}"/>
</c:if>

<c:set var="addressType" value="${WCParam.addressType}"/>
<c:if test="${empty WCParam.addressType}" >
	<c:set var="addressType" value="${param.addressType}"/>
</c:if>


<!-- Assume its add address -->
<c:set var="serviceId" value="AjaxAddAddressForPerson"/>

<c:if test="${!empty addressId && addressId != -1}">
	<!-- for this selected addressId get all the details -->
	<c:set var="person" value="${requestScope.person}"/>
	<c:if test="${empty person || person==null}">
		<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>
	</c:if>
	<c:set var="personAddresses" value="${person}"/>
	<c:set var="selectedContact" value=""/>

	<c:set var="shownAddress" value="false"/>
	<c:set var="contact" value="${person}"/>
	<c:if test="${contact.addressId eq addressId}" >	
		<c:set var="selectedContact" value="${contact}"/>
		<c:set var="shownAddress" value="true"/>
	</c:if>
	<c:if test="${!shownAddress}" >
		<c:forEach items="${personAddresses.contact}" var="contact">
			<c:if test="${contact.addressId eq addressId}" >
				<c:set var="selectedContact" value="${contact}"/>
				<c:set var="shownAddress" value="true"/>
			</c:if>
		</c:forEach>
	</c:if>

	<c:set var="serviceId" value="AjaxUpdateAddressForPerson"/>
	<c:set var="countryDisplayName" value="${selectedContact.country}"/>
	<c:set var="stateDisplayName" value="${selectedContact.state}"/>

</c:if>

<c:set var="formName" value="shopcartAddressForm"/>

<form id='<c:out value="${formName}"/>' name='<c:out value="${formName}"/>'>
	<input type="hidden" name="storeId" value="<c:out value="${storeId}" />" id="WC_ShopcartAddressFormDisplay_inputs_1"/>
	<input type="hidden" name="catalogId" value="<c:out value="${catalogId}" />" id="WC_ShopcartAddressFormDisplay_inputs_2"/>
	<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_ShopcartAddressFormDisplay_inputs_3"/>
	<input type="hidden" name="authToken" value="${authToken}" id="WC_ShopcartAddressFormDisplay_inputs_authToken" />
	<c:if test="${addressType == 'Billing' || addressType == 'B'}">
		<c:set var="serviceId" value="UpdateBillingAddressInCheckout"/>
	</c:if>
	<c:if test="${empty addressId || addressId == -1}">
		<!-- we need to pass addressType only when we are creating..otherwise its not needed -->
		<input type="hidden" name="addressType" value="<c:out value="${addressType}" />" id="WC_ShopcartAddressFormDisplay_inputs_4"/>
		<input type="hidden" name="originalAddressType" value="<c:out value="${addressType}" />" id="WC_ShopcartAddressFormDisplay_inputs_6"/>
		<c:if test="${addressType == 'Billing' || addressType == 'B'}">
			<c:set var="serviceId" value="AddBillingAddressInCheckOut"/>
		</c:if>
	</c:if>
	<input type="hidden" name="originalServiceId" value="${serviceId}" id="WC_ShopcartAddressFormDisplay_inputs_orginalServiceId"/>
	<div id="box_1">
		<div class="contentgrad_header" id="WC_ShopcartAddressFormDisplay_div_1">
			 <div class="left_corner" id="WC_ShopcartAddressFormDisplay_div_2"></div>
			 <div class="left" id="WC_ShopcartAddressFormDisplay_div_3"></div>
			 <div class="right_corner" id="WC_ShopcartAddressFormDisplay_div_4"></div>
		</div>
		<div class="body" id="WC_ShopcartAddressFormDisplay_div_5">
			<div id="centered_single_column_form">
				<c:choose>
					<c:when test="${!empty addressId && addressId != -1}">
						<h1><fmt:message bundle="${storeText}" key="ADDR_EDIT_ADDRESS_TITLE"/></h1><br />
					</c:when>
					<c:otherwise>
						<h1><fmt:message bundle="${storeText}" key="ADDR_CREATE_ADDRESS_TITLE"/></h1><br />
					</c:otherwise>
				</c:choose>
				<div id="WC_ShopcartAddressFormDisplay_div_6">
					<span class="required-field"> *</span>
					<fmt:message bundle="${storeText}" key="REQUIRED_FIELDS"/>
				</div>
				<br />
				<c:choose>
					<c:when test="${!empty addressId && addressId != -1}">
						<div class="label_spacer" id="WC_ShopcartAddressFormDisplay_div_7">
						<fmt:message bundle="${storeText}" key="AB_RECIPIENT"/>
							<span>
								<c:out value="${selectedContact.nickName}"/>
							</span>
							<input type="hidden" name="addressId" value="<c:out value="${addressId}" />" id="WC_ShopcartAddressFormDisplay_inputs_5"/>
							<!-- This will be input field in case of create address...-->
							<input type="hidden" id="nickName" name="nickName" value='<c:out value="${selectedContact.nickName}"/>'/>
						</div>
						<br />
					</c:when>
					<c:otherwise>
						<div class="label_spacer" id="WC_ShopcartAddressFormDisplay_div_8">
						<span class="spanacce">
						 <label for="nickName">
						 <fmt:message bundle="${storeText}" key="AB_RECIPIENT"/>
						 </label>
						 </span>
							<span class="required-field"> *</span>
							<fmt:message bundle="${storeText}" key="AB_RECIPIENT"/>
						</div>
						<div id="WC_ShopcartAddressFormDisplay_div_9">
							<input id="nickName" aria-required="true" name="nickName" type="text" class="form_input" size="35" value="" />
						</div>
					</c:otherwise>
				</c:choose>
				
				<%-- 
						1. The hidden field "AddressForm_FieldsOrderByLocale" is to set all the mandatory fields AND the order of the fields
						that are displayed in each locale-dependent address form, so that AddressHelper.js knows
						which fields to validate and in which order it should validate them.
						2. Mandatory fields use UPPER CASE, non-mandatory fields use lower case.
				--%>
				<c:choose>
					<c:when test="${locale eq 'fr_FR' || locale eq 'de_DE' || locale eq 'es_ES' || locale eq 'it_IT' || locale eq 'ro_RO'}">
						<%@ include file="ShoppingCartAddressEntryForm_DE_ES_FR_IT_RO.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'zh_CN'}">
						<%@ include file="ShoppingCartAddressEntryForm_CN.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ADDRESS,ZIP,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'zh_TW'}">
						<%@ include file="ShoppingCartAddressEntryForm_TW.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ZIP,ADDRESS,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'ar_EG'}">
						<%@ include file="ShoppingCartAddressEntryForm_AR.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,COUNTRY/REGION,CITY,STATE/PROVINCE,ADDRESS,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'ru_RU'}">
						<%@ include file="ShoppingCartAddressEntryForm_RU.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,middle_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'pl_PL'}">
						<%@ include file="ShoppingCartAddressEntryForm_PL.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,STATE/PROVINCE,COUNTRY/REGION,phone1,EMAIL1"/>
					</c:when>
					<c:when test="${locale eq 'ja_JP' || locale eq 'ko_KR'}">
						<%@ include file="ShoppingCartAddressEntryForm_JP_KR.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,FIRST_NAME,COUNTRY/REGION,ZIP,STATE/PROVINCE,CITY,ADDRESS,phone1,EMAIL1"/>
					</c:when>
					<c:otherwise>
						<%@ include file="ShoppingCartAddressEntryForm.jspf"%>
						<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
					</c:otherwise>
				</c:choose>
				<br />
				<c:if test="${empty addressId || addressId == -1}">
					<%-- This option is only available when adding a new address --%>
					<span class="checkbox">
						<input type="checkbox" class="checkbox" name="addToBothShippingBilling" id="addToBothShippingBilling" onclick="JavaScript:AddressHelper.setAddressTypeInCreatingNewAddressDuringCheckout(this, <c:out value='${formName}'/>);" />
						<span class="text"><label for="addToBothShippingBilling"><fmt:message bundle="${storeText}" key="AB_SBADDR"/></label></span>
					</span>
				</c:if>
			</div>
			<br clear="all" />
		</div>
		<div id="centered_single_column_form_footer">
			<a role="button" class="button_primary tlignore" id="WC_ShopcartAddressFormDisplay_links_1" tabindex="0" href="JavaScript:AddressHelper.saveShopCartAddress('<c:out value='${serviceId}'/>', '<c:out value='${formName}'/>', '<c:out value='${addressType}'/>');">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="SUBMIT"/></div>
				<div class="right_border"></div>
			</a>
			<div class="sixpixels"></div>
			<a href="#" role="button" class="button_secondary button_left_padding" id="WC_ShopcartAddressFormDisplay_links_2" tabindex="0" onclick="JavaScript:CheckoutHelperJS.cancelEditAddress()">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="CANCEL"/></div>
				<div class="right_border"></div>
			</a>
		</div>
	</div>
</form>
<!-- END ShopcartAddressFormDisplay.jsp -->
