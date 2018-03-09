<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp displays a select box with all applicable shipping addresses.
  ***
--%>
<!-- BEGIN ShippingAddressSelect.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:set var="orderShipInfo" value="${requestScope.orderUsableShipping}"/>
<c:if test="${empty orderShipInfo || orderShipInfo==null}">
	<c:choose>
		<c:when test="${empty param.orderId || param.orderId == null}">
			<wcf:rest var="orderShipInfo" url="store/{storeId}/cart/@self/usable_shipping_info">
				<wcf:var name="storeId" value="${storeId}"/>
				<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
			</wcf:rest>
		</c:when>
		<c:otherwise>
			<wcf:rest var="orderShipInfo" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
				<wcf:var name="storeId" value="${storeId}"/>
				<wcf:param name="orderId" value="${param.orderId}" />
				<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
				<wcf:param name="pageSize" value="${pageSize}"/>
				<wcf:param name="pageNumber" value="${currentPage}"/>
			</wcf:rest>
		</c:otherwise>
	</c:choose>
</c:if>

<c:set var="selectedAddressId" value="${param.addressId}"/>
<c:set var="selectedAddressNickName" value="${param.addressNickName}"/>
<c:set var="hasValidAddresses" value="false"/>
<c:set var="isPersonAddress" value="false"/>
<c:forEach var="tempAddressInfo" items="${orderShipInfo.usableShippingAddress}">
	<c:set var="hasValidAddresses" value="true"/>
	<c:if test="${(selectedAddressId eq tempAddressInfo.addressId) || (selectedAddressNickName eq tempAddressInfo.nickName)}" >
		<c:set var="isPersonAddress" value="true"/>
	</c:if>
</c:forEach>

<c:set var="orderItemId" value="${param.orderItemId}"/>

<c:if test="${empty orderItemId}">
	<c:set var="orderItemId" value="${WCParam.orderItemId}"/>
</c:if>
<%-- Retrive the shipping address from each of the order items in multiple shipping and display them  --%>
<c:set var="orderItemShippingInfo" value=""/>

<c:forEach var="shippingOrderItem" items="${orderShipInfo.orderItem}">
<c:if test="${shippingOrderItem.orderItemId eq orderItemId}">
		<c:set var="orderItemShippingInfo" value="${shippingOrderItem}"/>
	</c:if>
</c:forEach>

<c:if test="${!empty orderItemShippingInfo}">
	<c:set var="orderShipInfo" value="${orderItemShippingInfo}"/>
	<c:forEach var="tempAddressInfo" items="${orderShipInfo.usableShippingAddress}">
		<c:set var="hasValidAddresses" value="true"/>
		<c:if test="${(selectedAddressId eq tempAddressInfo.addressId) || (selectedAddressNickName eq tempAddressInfo.nickName)}" >
			<c:set var="isPersonAddress" value="true"/>
		</c:if>
	</c:forEach>
</c:if>

<wcf:url var="AddressDisplayURL" value="AjaxAddressDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<c:set var="search01" value="'"/>
<c:set var="replaceStr01" value="\\'"/>

<fmt:message bundle="${storeText}" var="profileshipping"  key="QC_DEFAULT_SHIPPING"/>
<fmt:message bundle="${storeText}" var="profilebilling"  key="QC_DEFAULT_BILLING"/>
<div class="shipping_address_MS_shipping_info_page" id="WC_ShippingAddressSelectMultiple_div_<c:out value='${orderItemId}'/>">
<div id="MS_ShippingAddress_Section_<c:out value='${orderItemId}'/>" class="${requestScope.shippingModeVisibility}">
	<p>
		<c:choose>
			<c:when test="${hasValidAddresses}" >
			<label for="MS_ShipmentAddress_<c:out value='${orderItemId}'/>"><span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS"/></span></label>
				<select class="drop_down_shipping form_input" name="MS_ShipmentAddress_<c:out value='${orderItemId}'/>" id="MS_ShipmentAddress_<c:out value='${orderItemId}'/>" onChange="JavaScript:setCurrentId('MS_ShipmentAddress_<c:out value='${orderItemId}'/>'); CheckoutHelperJS.updateAddressIdForThisItem(this.value,'<c:out value='${orderItemId}'/>');CheckoutHelperJS.displayAddressDetailsForMS(this.value,'<c:out value='${orderItemId}'/>','Shipping');CheckoutHelperJS.showHideEditAddressLink(this,'<c:out value='${orderItemId}'/>');TealeafWCJS.rebind(this.id);" onkeydown="CheckoutHelperJS.tabPressed(event);">
					<c:forEach var="contactInfoIdentifier" items="${orderShipInfo.usableShippingAddress}">
						<option value="<c:out value='${contactInfoIdentifier.addressId}'/>"
					<c:if test="${(selectedAddressId eq contactInfoIdentifier.addressId) || (selectedAddressNickName eq contactInfoIdentifier.nickName)}" >
						selected="selected"
						<c:set var="selectedShippingAddressId" value="${contactInfoIdentifier.addressId}"/>
					</c:if>
					><c:choose><c:when test="${contactInfoIdentifier.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
					<c:when test="${contactInfoIdentifier.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
					<c:otherwise><c:out value="${contactInfoIdentifier.nickName}"/></c:otherwise></c:choose></option>
					</c:forEach>
					<%@ include file="MultipleShippingAddressSelectExt.jspf" %>
					<%@ include file="GiftRegistryMultipleShippingAddressSelectExt.jspf" %>
				</select>
			</c:when>
			<c:otherwise>
				<span class="secondary_button button_fit" >
					<span class="button_container">
						<span class="button_bg">
							<span class="button_top">
								<span class="button_bottom">   
									<a href="JavaScript:CheckoutHelperJS.createAddress(-1,'Shipping');" class="tlignore" id="WC_ShippingAddressSelectMultiple_link_1"><fmt:message bundle="${storeText}" key="ADD_ADDRESS"/></a>
								</span>
							</span>	
						</span>
					</span>
				</span>	
			</c:otherwise>
		</c:choose>
	</p>
<c:set var="showEditShippingAddressLink" value="true"/>
<c:set var="person" value="${requestScope.person}"/>
<c:if test="${empty person || person==null}">
	<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
</c:if>

<c:catch>
	<c:set var="activeOrgId" value="${CommandContext.activeOrganizationId}"/>
	<wcf:rest var="organization" url="store/{storeId}/organization/{organizationId}">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="organizationId" value="${activeOrgId}" encode="true"/>
	</wcf:rest>
	<c:set var="organizationAddresses" value="${organization.addressBook}"/>
	<c:set var ="contact" value="${organization.contactInfo}"/>
	<c:if test="${selectedShippingAddressId == contact.addressId}">
		<c:set var="showEditShippingAddressLink" value="false"/>
	</c:if>
	<c:set var = "existingContactOrgAddress" value="${contactOrgAddress}"/>
	<c:set var ="contactOrgAddress" value="${contact.addressId}" scope="request"/>
	<c:forEach items="${organizationAddresses}" var="contact">
		<c:choose>
			<c:when test="${empty contactOrgAddress || contactOrgAddress eq null}">
				<c:set var="contactOrgAddress" value="${contact.addressId}" scope="request"/>
			</c:when>
			<c:otherwise>
				<c:set var="contactOrgAddress" value="${contactOrgAddress},${contact.addressId}" scope="request"/>
			</c:otherwise>
		</c:choose>
		<c:if test="${selectedShippingAddressId == contact.addressId}">
				<c:set var="showEditShippingAddressLink" value="false"/>
		</c:if>
	</c:forEach>
	<c:if test="${empty existingContactOrgAddress}">
		<input type="hidden" id="shippingOrganizationAddressList" value="${contactOrgAddress}" name="shippingOrganizationAddressList"/>
	</c:if>
</c:catch>

	<c:if test="${isPersonAddress}">
		<!-- Area where selected shipping Address details is showed in short..-->
		<div id="MS_shippingAddressDisplayArea_<c:out value='${orderItemId}'/>">
			<c:import url="/${sdb.jspStoreDir}/Snippets/Member/Address/AddressDisplay.jsp">
				<c:param name="addressId" value= "${selectedShippingAddressId}"/>
			</c:import>
			<input type="hidden" value="<c:out value='${selectedShippingAddressId}'/>" id="addressId_<c:out value='${orderItemId}'/>" name="addressId_<c:out value='${orderItemId}'/>"/>
		</div>
	
	
		<!-- Show Edit button only if there are any valid address.. -->
		<c:if test="${selectedAddressId != -1}" >
			<br/>
			<%-- Use the value of personalAddressAllowed to hide/show the create/edit address link. --%>
			<div class="editAddressLink hover_underline" id="editAddressLink_<c:out value='${orderItemId}'/>" style="display:block;">
				<c:if test="${!empty param.personalAddressAllowed && param.personalAddressAllowed}">
				<c:if test="${showEditShippingAddressLink}">
					<a href="JavaScript:CheckoutHelperJS.editAddress('MS_ShipmentAddress_<c:out value='${orderItemId}'/>','<c:out value='${orderItemId}'/>','<c:out value='${fn:replace(profileshipping,search01,replaceStr01)}'/>','<c:out value='${fn:replace(profilebilling,search01,replaceStr01)}'/>');CheckoutHelperJS.setLastAddressLinkIdToFocus('WC_ShippingAddressSelectMultiple_link_2_<c:out value='${orderItemId}'/>');" onfocus="javascript:CheckoutHelperJS.setLastFocus(this.id);" class="tlignore" id="WC_ShippingAddressSelectMultiple_link_2_<c:out value='${orderItemId}'/>">
						<img src="<c:out value='${jspStoreImgDir}'/>images/edit_icon.png" alt="" /> 
						<fmt:message bundle="${storeText}" key="ADDR_EDIT_ADDRESS"/>
					</a>
				 </c:if>
				 </c:if>
			</div>
			
			<wcf:url var="AddressEditView" value="AddressEditView" type="Ajax">
				<wcf:param name="langId" value="${WCParam.langId}" />
				<wcf:param name="storeId" value="${WCParam.storeId}" />
				<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			</wcf:url>
		</c:if>
	</c:if>
	<%-- Use the value of personalAddressAllowed to hide/show the create/edit address link. --%>
<c:if test="${!empty param.personalAddressAllowed && param.personalAddressAllowed}">
	<div class="newShippingAddressButton hover_underline" id="newShippingAddressButton_<c:out value='${orderItemId}'/>">
			<a href="JavaScript:setCurrentId('MS_ShipmentAddress_<c:out value='${orderItemId}'/>'); CheckoutHelperJS.addNewShippingAddressForMS('<c:out value='${orderItemId}'/>');CheckoutHelperJS.displayAddressDetailsForMSHelper('<c:out value='${orderItemId}'/>','Shipping');CheckoutHelperJS.setLastAddressLinkIdToFocus('WC_ShippingAddressSelectMultiple_link_3_<c:out value='${orderItemId}'/>');" class="tlignore" id="WC_ShippingAddressSelectMultiple_link_3_<c:out value='${orderItemId}'/>">
				<img class="nopadding" src="<c:out value='${jspStoreImgDir}${env_vfileColor}'/>table_plus_add.png" alt="" />
				<fmt:message bundle="${storeText}" key="ADDR_CREATE_ADDRESS"/>
			</a>
	</div>
</c:if>
<script type="text/javascript">
			$(document).ready(function() { 
				CheckoutHelperJS.showHideEditAddressLink(document.getElementById("MS_ShipmentAddress_<wcf:out value='${orderItemId}' escapeFormat='js'/>"),'<wcf:out value='${orderItemId}' escapeFormat='js'/>');
			});
</script>
</div>
</div>
<!-- END ShippingAddressSelect.jsp -->
