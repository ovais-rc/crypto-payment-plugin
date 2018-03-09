<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>

<wcbase:useBean id="error" classname="com.ibm.commerce.beans.ErrorDataBean" scope="request" />

<c:if test="${empty error.exceptionType}">
	<wcbase:useBean id="order" classname="com.ibm.commerce.order.beans.OrderDataBean">
		<c:set target="${order}" property="orderId" value="${RequestProperties.orderId}" />
	</wcbase:useBean>
	<wcbase:useBean id="buyerOrganization" classname="com.ibm.commerce.user.beans.OrganizationDataBean">
		<c:set target="${buyerOrganization}" property="dataBeanKeyMemberId" value="${order.organizationId}" />
	</wcbase:useBean>
	<wcbase:useBean id="customer" classname="com.ibm.commerce.user.beans.UserDataBean">
		<c:set target="${customer}" property="dataBeanKeyMemberId" value="${order.memberId}" />
	</wcbase:useBean>
	<wcbase:useBean id="promotionCodeList" classname="com.ibm.commerce.marketing.databeans.PromoCodeListDataBean">
		<c:set target="${promotionCodeList}" property="orderId" value="${RequestProperties.orderId}" />
	</wcbase:useBean>
	<c:set var="currency" value="${order.currency}" />
	<c:set var="languageId" value="${CommandContext.languageId}" />
</c:if>

<ord:AcknowledgeOrder
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:wcf="http://www.ibm.com/xmlns/prod/commerce/foundation"
	xmlns:ord="http://www.ibm.com/xmlns/prod/commerce/order"
	releaseID="" versionID="">
	<jsp:include page="../Resources/Components/Common/ApplicationArea.jsp" flush="true" />
	<ord:DataArea>
		<oa:Acknowledge>
			<jsp:include page="../Resources/Components/Common/OriginalApplicationArea.jsp" flush="true" />
			<c:if test="${!empty error.exceptionType}">
				<jsp:include page="../Resources/Components/Common/ResponseCriteria.jsp" flush="true" />
			</c:if>
		</oa:Acknowledge>
		<c:if test="${empty error.exceptionType}">
			<ord:Order>
				<ord:OrderHeader>
					<wcf:OrderIdentifier>
						<wcf:OrderID><c:out value="${order.orderId}" /></wcf:OrderID>
						<c:if test="${!empty RequestProperties.externalOrderId}">
							<wcf:ExternalOrderID><c:out value="${RequestProperties.externalOrderId}" /></wcf:ExternalOrderID>
						</c:if>
					</wcf:OrderIdentifier>
					<ord:OrderReferences>
						<ord:StoreID><c:out value="${order.storeEntityId}" /></ord:StoreID>
						<ord:BuyerOrganizationIdentifier>
							<wcf:UniqueID><c:out value="${order.organizationId}" /></wcf:UniqueID>
							<wcf:DistinguishedName><c:out value="${buyerOrganization.distinguishedName}" /></wcf:DistinguishedName>
						</ord:BuyerOrganizationIdentifier>
						<ord:CustomerIdentifier>
							<wcf:UniqueID><c:out value="${order.memberId}" /></wcf:UniqueID>
							<wcf:DistinguishedName><c:out value="${customer.distinguishedName}" /></wcf:DistinguishedName>
						</ord:CustomerIdentifier>
					</ord:OrderReferences>
					<ord:OrderCharges>
						<ord:TotalProductPrice currency="<c:out value="${currency}" />"><c:out value="${order.totalProductPrice}" /></ord:TotalProductPrice>
						<ord:TotalAdjustment currency="<c:out value="${currency}" />"><c:out value="${order.totalAdjustment}" /></ord:TotalAdjustment>
						<ord:TotalShippingCharge currency="<c:out value="${currency}" />"><c:out value="${order.totalShippingCharge}" /></ord:TotalShippingCharge>
						<ord:TotalSalesTax currency="<c:out value="${currency}" />"><c:out value="${order.totalTax}" /></ord:TotalSalesTax>
						<ord:TotalShippingTax currency="<c:out value="${currency}" />"><c:out value="${order.totalShippingTax}" /></ord:TotalShippingTax>
					</ord:OrderCharges>
					<c:if test="${!empty promotionCodeList.codes}">
						<ord:OrderPaymentInfo>
							<c:forEach var="promotionCode" items="${promotionCodeList.codes}">	
								<ord:PromotionCode><c:out value="${promotionCode.code}" /></ord:PromotionCode>
							</c:forEach>
						</ord:OrderPaymentInfo>
					</c:if>
				</ord:OrderHeader>
				<c:forEach var="orderItem" items="${order.orderItemDataBeans}">
					<c:set var="catalogEntry" value="${orderItem.catalogEntryDataBean}" />
					<c:set var="shipping" value="${catalogEntry.shipping}" />
					<c:catch>
						<c:if test="${!empty shipping}">
							<c:set var="nominalQuantity" value="${shipping.nominalQuantity}" />
							<c:set var="uom" value="${shipping.quantityMeasure}" />
						</c:if>
					</c:catch>
					<c:if test="${empty nominalQuantity}">
						<c:set var="nominalQuantity" value="1.0" />
					</c:if>
					<c:if test="${empty uom}">
						<c:set var="uom" value="C62" />
					</c:if>
					<ord:OrderItem>
						<wcf:OrderItemIdentifier>
							<wcf:OrderItemID><c:out value="${orderItem.orderItemId}" /></wcf:OrderItemID>
							<c:if test="${!empty orderItem.field2}">
								<wcf:ExternalOrderItemID><c:out value="${orderItem.field2}" /></wcf:ExternalOrderItemID>
							</c:if>
						</wcf:OrderItemIdentifier>
						<wcf:ProductIdentifier>
							<wcf:CatalogEntryID><c:out value="${catalogEntry.catalogEntryReferenceNumber}" /></wcf:CatalogEntryID>
							<wcf:SKU><c:out value="${catalogEntry.partNumber}" /></wcf:SKU>
						</wcf:ProductIdentifier>
						<ord:Quantity uom="<c:out value="${uom}" />"><c:out value="${orderItem.quantity * nominalQuantity}" /></ord:Quantity>
						<ord:OrderItemCharges>
							<wcf:UnitPrice>
								<wcf:Price currency="<c:out value="${currency}" />"><c:out value="${orderItem.price}" /></wcf:Price>
								<wcf:Quantity uom="<c:out value="${uom}" />"><c:out value="${nominalQuantity}" /></wcf:Quantity>
							</wcf:UnitPrice>
							<ord:PriceOverride><c:out value="${orderItem.prepareFlags div 2 mod 2 >= 1}" /></ord:PriceOverride>
							<ord:FreeGift><c:out value="${orderItem.prepareFlags div 128 mod 2 >= 1}" /></ord:FreeGift>
							<ord:OrderItemPrice><c:out value="${orderItem.totalProduct}" /></ord:OrderItemPrice>
							<c:forEach var="orderItemAdjustment" items="${orderItem.orderItemAdjustmentDataBeans}">
								<c:set var="orderAdjustment" value="${orderItemAdjustment.orderAdjustmentDataBean}" />
								<c:set var="calculationUsageId" value="${orderAdjustment.calculationUsageId}" />
								<c:choose>
									<c:when test="${calculationUsageId == -1}">
										<c:set var="type" value="Discount" />
									</c:when>
									<c:when test="${calculationUsageId == -5}">
										<c:set var="type" value="Coupon" />
									</c:when>
									<c:when test="${calculationUsageId == -6}">
										<c:set var="type" value="Surcharge" />
									</c:when>
								</c:choose>
								<c:set var="displayLevel" value="${orderAdjustment.displayLevel}" />
								<c:choose>
									<c:when test="${displayLevel == 0}">
										<c:set var="displayLevelName" value="OrderItem" />
									</c:when>
									<c:when test="${displayLevel == 1}">
										<c:set var="displayLevelName" value="Order" />
									</c:when>
								</c:choose>
								<ord:Adjustment>
									<ord:Type><c:out value="${type}" /></ord:Type>
									<ord:Code><c:out value="${orderAdjustment.calculationCodeDataBean.code}" /></ord:Code>
									<ord:Description languageID="<c:out value="${languageId}" />"><c:out value="${orderAdjustment.descriptionString}" /></ord:Description>
									<ord:Amount currency="<c:out value="${currency}" />"><c:out value="${orderItemAdjustment.amount}" /></ord:Amount>
									<ord:DisplayLevel><c:out value="${displayLevelName}" /></ord:DisplayLevel>
								</ord:Adjustment>
							</c:forEach>
							<ord:ShippingCharge currency="<c:out value="${currency}" />"><c:out value="${orderItem.shippingCharge}" /></ord:ShippingCharge>
							<ord:SalesTax currency="<c:out value="${currency}" />"><c:out value="${orderItem.taxAmount}" /></ord:SalesTax>
							<ord:ShippingTax currency="<c:out value="${currency}" />"><c:out value="${orderItem.shippingTaxAmount}" /></ord:ShippingTax>
						</ord:OrderItemCharges>
						<ord:OrderItemShippingInfo>
							<c:set var="shippingAddress" value="${orderItem.addressDataBean}" />
							<wcf:ContactEntry>
								<wcf:Address>
									<wcf:AddressLine><c:out value="${shippingAddress.address1}" /></wcf:AddressLine>
									<wcf:AddressLine><c:out value="${shippingAddress.address2}" /></wcf:AddressLine>
									<wcf:AddressLine><c:out value="${shippingAddress.address3}" /></wcf:AddressLine>
									<wcf:City><c:out value="${shippingAddress.city}" /></wcf:City>
									<wcf:StateOrProvinceName><c:out value="${shippingAddress.state}" /></wcf:StateOrProvinceName>
									<wcf:Country><c:out value="${shippingAddress.country}" /></wcf:Country>
									<wcf:PostalCode><c:out value="${shippingAddress.zipCode}" /></wcf:PostalCode>
								</wcf:Address>
								<wcf:ContactName />
							</wcf:ContactEntry>
							<ord:ShippingModeID><c:out value="${orderItem.shippingModeId}" /></ord:ShippingModeID>
						</ord:OrderItemShippingInfo>
					</ord:OrderItem>
				</c:forEach>
			</ord:Order>
		</c:if>
	</ord:DataArea>
</ord:AcknowledgeOrder>
