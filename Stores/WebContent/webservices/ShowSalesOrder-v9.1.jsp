<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>
<%-- response builder for the PreprocessSalesOrder BOD --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String dateTime = sdf.format(new java.util.Date());
%>
<wcbase:useBean id="order" classname="com.ibm.commerce.order.beans.OrderDataBean">
	<c:set target="${order}" property="orderId" value="${RequestProperties.orderId}" />
</wcbase:useBean>
<oa:ShowSalesOrder releaseID="9.0" versionID="9.1" xmlns:oa="http://www.openapplications.org/oagis/9">
	<oa:ApplicationArea>
		<oa:CreationDateTime><%=dateTime%></oa:CreationDateTime>
		<oa:BODID><%=dateTime%><c:out value="[${CommandContext.user.displayName}]" /></oa:BODID>
	</oa:ApplicationArea>
	<oa:DataArea>
		<oa:Show />
		<oa:SalesOrder>
			<oa:SalesOrderHeader>
				<oa:DocumentID>
					<oa:ID><c:out value="${order.orderId}" /></oa:ID>
				</oa:DocumentID>
				<oa:CustomerParty>
					<oa:PartyIDs>
						<oa:ID><c:out value="${order.memberId}" /></oa:ID>
					</oa:PartyIDs>
				</oa:CustomerParty>
				<oa:TotalAmount currencyID="<c:out value="${order.currency}" />"><c:out value="${order.grandTotal.amount}" /></oa:TotalAmount>
				<oa:PaymentTerm>
					<c:forEach var="orderAdjustment" items="${order.orderAdjustmentDataBeans}">
						<c:if test="${adjustment.amount < 0.0}">
							<oa:Discount type="<c:out value="${orderAdjustment.calculationUsageId}" />">
								<oa:ID><c:out value="${orderAdjustment.calculationCodeId}" /></oa:ID>
								<oa:Description><c:out value="${orderAdjustment.descriptionString}" /></oa:Description>
								<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${0.0 - orderAdjustment.amount}" /></oa:Amount>
							</oa:Discount>
						</c:if>
					</c:forEach>
				</oa:PaymentTerm>
				<c:forEach var="orderAdjustment" items="${order.orderAdjustmentDataBeans}">
					<c:if test="${orderAdjustment.amount > 0.0}">
						<oa:DistributedCharge type="<c:out value="${orderAdjustment.calculationUsageId}" />">
								<oa:ID><c:out value="${orderAdjustment.calculationCodeId}" /></oa:ID>
								<oa:Description><c:out value="${orderAdjustment.descriptionString}" /></oa:Description>
								<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderAdjustment.amount}" /></oa:Amount>
						</oa:DistributedCharge>
					</c:if>
				</c:forEach>
				<oa:DistributedCharge type="-2">
					<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${order.totalShippingCharge}" /></oa:Amount>
				</oa:DistributedCharge>
				<c:forEach var="orderTax" items="${order.taxes.categorizedAmountsAndNames}">
					<oa:DistributedTax>
						<oa:ID><c:out value="${orderTax.key}" /></oa:ID>
						<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderTax.value}" /></oa:Amount>
					</oa:DistributedTax>
				</c:forEach>
				<oa:SalesOrganizationIDs>
					<oa:ID><c:out value="${order.storeEntityId}" /></oa:ID>
				</oa:SalesOrganizationIDs>
			</oa:SalesOrderHeader>
			<c:forEach var="orderItem" items="${order.orderItemDataBeans}">
				<c:set var="catalogEntry" value="${orderItem.catalogEntryDataBean}" />
				<oa:SalesOrderLine>
					<oa:LineNumber><c:out value="${orderItem.orderItemId}" /></oa:LineNumber>
					<oa:Item>
						<oa:ItemID>
							<oa:ID><c:out value="${catalogEntry.catalogEntryReferenceNumber}" /></oa:ID>
						</oa:ItemID>
						<oa:SupplierItemID>
							<oa:ID><c:out value="${catalogEntry.partNumber}" /></oa:ID>
						</oa:SupplierItemID>
						<oa:Specification>
							<oa:Property>
								<oa:NameValue name="contractId"><c:out value="${orderItem.contractId}" /></oa:NameValue>
							</oa:Property>
							<oa:Property>
								<oa:NameValue name="offerId"><c:out value="${orderItem.offerId}" /></oa:NameValue>
							</oa:Property>
						</oa:Specification>
					</oa:Item>
					<c:set var="shipping" value="${catalogEntry.shipping}" />
					<% try { %>
					<c:if test="${!empty shipping}">
						<c:set var="nominalQuantity" value="${shipping.nominalQuantity}" />
						<c:set var="unitCode" value="${shipping.quantityMeasure}" />
					</c:if>
					<% } catch(Exception e) {} %>
					<c:if test="${empty nominalQuantity}">
						<c:set var="nominalQuantity" value="1.0" />
					</c:if>
					<c:if test="${empty unitCode}">
						<c:set var="unitCode" value="C62" />
					</c:if>
					<oa:Quantity unitCode="<c:out value="${unitCode}" />"><c:out value="${orderItem.quantity * nominalQuantity}" /></oa:Quantity>
					<oa:UnitPrice>
						<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderItem.price}" /></oa:Amount>
						<oa:PerQuantity unitCode="<c:out value="${unitCode}" />"><c:out value="${nominalQuantity}" /></oa:PerQuantity>
					</oa:UnitPrice>
					<oa:TotalAmount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderItem.totalProduct + orderItem.totalAdjustment + orderItem.shippingCharge + orderItem.taxAmount + orderItem.shippingTaxAmount}" /></oa:TotalAmount>
					<c:set var="address" value="${orderItem.addressDataBean}" />
					<oa:ShipToParty>
						<oa:Location>
							<oa:Address>
								<oa:LineOne><c:out value="${address.address1}" /></oa:LineOne>
								<oa:LineTwo><c:out value="${address.address2}" /></oa:LineTwo>
								<oa:LineThree><c:out value="${address.address3}" /></oa:LineThree>
								<oa:CityName><c:out value="${address.city}" /></oa:CityName>
								<oa:CountrySubDivisionCode name="state"><c:out value="${address.state}" /></oa:CountrySubDivisionCode>
								<oa:CountryCode><c:out value="${address.country}" /></oa:CountryCode>
								<oa:PostalCode><c:out value="${address.zipCode}" /></oa:PostalCode>
							</oa:Address>
						</oa:Location>
					</oa:ShipToParty>
					<oa:TransportationTerm><oa:FreightTermCode><c:out value="${orderItem.shippingModeId}" /></oa:FreightTermCode></oa:TransportationTerm>
					<oa:PaymentTerm>
						<c:forEach var="orderItemAdjustment" items="${orderItem.orderItemAdjustmentDataBeans}">
							<c:if test="${orderItemAdjustment.amount < 0.0}">
								<c:set var="orderAdjustment" value="${orderItemAdjustment.orderAdjustmentDataBean}" />
								<oa:Discount type="<c:out value="${orderAdjustment.calculationUsageId}" />">
									<oa:ID><c:out value="${orderAdjustment.calculationCodeId}" /></oa:ID>
									<oa:Description><c:out value="${orderAdjustment.descriptionString}" /></oa:Description>
									<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${0.0 - orderItemAdjustment.amount}" /></oa:Amount>
								</oa:Discount>
							</c:if>
						</c:forEach>
					</oa:PaymentTerm>
					<c:forEach var="orderItemAdjustment" items="${orderItem.orderItemAdjustmentDataBeans}">
						<c:if test="${orderItemAdjustment.amount > 0.0}">
							<c:set var="orderAdjustment" value="${orderItemAdjustment.orderAdjustmentDataBean}" />
							<oa:DistributedCharge type="<c:out value="${orderAdjustment.calculationUsageId}" />">
								<oa:ID><c:out value="${orderAdjustment.calculationCodeId}" /></oa:ID>
								<oa:Description><c:out value="${orderAdjustment.descriptionString}" /></oa:Description>
								<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderItemAdjustment.amount}" /></oa:Amount>
							</oa:DistributedCharge>
						</c:if>
					</c:forEach>
					<oa:DistributedCharge type="-2">
						<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderItem.shippingCharge}" /></oa:Amount>
					</oa:DistributedCharge>
					<c:forEach var="orderItemTax" items="${orderItem.categoryTaxAmounts}">
						<oa:DistributedTax>
							<oa:ID><c:out value="${orderItemTax.taxCategoryId}" /></oa:ID>
							<oa:Amount currencyID="<c:out value="${order.currency}" />"><c:out value="${orderItemTax.taxAmount}" /></oa:Amount>
						</oa:DistributedTax>
					</c:forEach>
					<oa:DistributionCenterCode><c:out value="${orderItem.fulfillmentCenterId}" /></oa:DistributionCenterCode>
				</oa:SalesOrderLine>
			</c:forEach>
		</oa:SalesOrder>
	</oa:DataArea>
</oa:ShowSalesOrder>

