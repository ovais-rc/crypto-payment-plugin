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
<%-- response builder for the GetPaymentEntity BOD --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>

<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String dateTime = sdf.format(new java.util.Date());
%>
<c:set var="credit" value="${RequestProperties.credit}" />
<c:set var="payment" value="${RequestProperties.payment}" />
<c:set var="paymentInstruction" value="${RequestProperties.paymentInstruction}" />
<wc:ShowPaymentEntity releaseID="9.0" versionID="9.1" xmlns:oa="http://www.openapplications.org/oagis/9" xmlns:wc="http://www.ibm.com/xmlns/prod/WebSphereCommerce">
	<oa:ApplicationArea>
		<oa:CreationDateTime><%=dateTime%></oa:CreationDateTime>
		<oa:BODID><%=dateTime%><c:out value="[${CommandContext.user.displayName}]" /></oa:BODID>
	</oa:ApplicationArea>
	<wc:DataArea>
		<oa:Show />
		<wc:PaymentEntity>
			<c:if test="${!empty credit}">
				<c:set var="timeCreated" value="${credit.timeCreated}" />
				<c:set var="timeUpdated" value="${credit.timeUpdated}" />
				<wc:Credit>
					<wc:Id><c:out value="${credit.id}" /></wc:Id>
					<wc:CreditedAmount><c:out value="${credit.creditedAmount}" /></wc:CreditedAmount>
					<wc:CreditingAmount><c:out value="${credit.creditingAmount}" /></wc:CreditingAmount>
					<wc:ExpectedAmount><c:out value="${credit.expectedAmount}" /></wc:ExpectedAmount>
					<wc:ReversingCreditedAmount><c:out value="${credit.reversingCreditedAmount}" /></wc:ReversingCreditedAmount>
					<wc:State><c:out value="${credit.state}" /></wc:State>
					<wc:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></wc:TimeCreated>
					<wc:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></wc:TimeUpdated>
					<wc:PaymentInstruction>
						<wc:Id><c:out value="${credit.paymentInstruction.id}" /></wc:Id>
					</wc:PaymentInstruction>
				</wc:Credit>
			</c:if>
			<c:if test="${!empty payment}">
				<c:set var="timeCreated" value="${payment.timeCreated}" />
				<c:set var="timeExpired" value="${payment.timeExpired}" />
				<c:set var="timeUpdated" value="${payment.timeUpdated}" />
				<wc:Payment>
					<wc:Id><c:out value="${payment.id}" /></wc:Id>
					<wc:AttentionRequired><c:out value="${payment.paymentRequiresAttention}" /></wc:AttentionRequired>
					<wc:ApprovedAmount><c:out value="${payment.approvedAmount}" /></wc:ApprovedAmount>
					<wc:ApprovingAmount><c:out value="${payment.approvingAmount}" /></wc:ApprovingAmount>
					<wc:AvsCommonCode><c:out value="${payment.avsCommonCode}" /></wc:AvsCommonCode>
					<wc:DepositedAmount><c:out value="${payment.depositedAmount}" /></wc:DepositedAmount>
					<wc:DepositingAmount><c:out value="${payment.depositingAmount}" /></wc:DepositingAmount>
					<wc:ExpectedAmount><c:out value="${payment.expectedAmount}" /></wc:ExpectedAmount>
					<wc:Expired><c:out value="${payment.expired}" /></wc:Expired>
					<wc:ReversingApprovedAmount><c:out value="${payment.reversingApprovedAmount}" /></wc:ReversingApprovedAmount>
					<wc:ReversingDepositedAmount><c:out value="${payment.reversingDepositedAmount}" /></wc:ReversingDepositedAmount>
					<wc:State><c:out value="${payment.state}" /></wc:State>
					<wc:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></wc:TimeCreated>
					<wc:TimeExpired><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeExpired")).longValue()))%></wc:TimeExpired>
					<wc:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></wc:TimeUpdated>
					<wc:PaymentInstruction>
						<wc:Id><c:out value="${payment.paymentInstruction.id}" /></wc:Id>
					</wc:PaymentInstruction>
				</wc:Payment>
			</c:if>
			<c:if test="${!empty paymentInstruction}">
				<c:set var="timeCreated" value="${paymentInstruction.timeCreated}" />
				<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}" />
				<wc:PaymentInstruction>
					<wc:Id><c:out value="${paymentInstruction.id}" /></wc:Id>
					<wc:AccountNumber><c:out value="${paymentInstruction.accountNumber}" /></wc:AccountNumber>
					<wc:Amount><c:out value="${paymentInstruction.amount}" /></wc:Amount>
					<wc:ApprovedAmount><c:out value="${paymentInstruction.approvedAmount}" /></wc:ApprovedAmount>
					<wc:ApprovingAmount><c:out value="${paymentInstruction.approvingAmount}" /></wc:ApprovingAmount>
					<wc:CreditedAmount><c:out value="${paymentInstruction.creditedAmount}" /></wc:CreditedAmount>
					<wc:CreditingAmount><c:out value="${paymentInstruction.creditingAmount}" /></wc:CreditingAmount>
					<wc:Currency><c:out value="${paymentInstruction.currency}" /></wc:Currency>
					<wc:DepositedAmount><c:out value="${paymentInstruction.depositedAmount}" /></wc:DepositedAmount>
					<wc:DepositingAmount><c:out value="${paymentInstruction.depositingAmount}" /></wc:DepositingAmount>
					<wc:OrderId><c:out value="${paymentInstruction.orderId}" /></wc:OrderId>
					<wc:PaymentConfigurationId><c:out value="${paymentInstruction.paymentConfigurationId}" /></wc:PaymentConfigurationId>
					<wc:PaymentSystemName><c:out value="${paymentInstruction.paymentSystemName}" /></wc:PaymentSystemName>
					<wc:Retriable><c:out value="${paymentInstruction.paymentInstructionRetriable}" /></wc:Retriable>
					<wc:ReversingApprovedAmount><c:out value="${paymentInstruction.reversingApprovedAmount}" /></wc:ReversingApprovedAmount>
					<wc:ReversingCreditedAmount><c:out value="${paymentInstruction.reversingCreditedAmount}" /></wc:ReversingCreditedAmount>
					<wc:ReversingDepositedAmount><c:out value="${paymentInstruction.reversingDepositedAmount}" /></wc:ReversingDepositedAmount>
					<wc:RmaId><c:out value="${paymentInstruction.rmaId}" /></wc:RmaId>
					<wc:State><c:out value="${paymentInstruction.state}" /></wc:State>
					<wc:StoreId><c:out value="${paymentInstruction.store}" /></wc:StoreId>
					<wc:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></wc:TimeCreated>
					<wc:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></wc:TimeUpdated>
					<wc:ExtendedData>
						<c:forEach var="nameValuePair" items="${paymentInstruction.extendedData}">
							<wc:NameValuePair>
								<wc:Name><c:out value="${nameValuePair.key}" /></wc:Name>
								<wc:Value><c:out value="${nameValuePair.value}" /></wc:Value>
							</wc:NameValuePair>
						</c:forEach>
					</wc:ExtendedData>
				</wc:PaymentInstruction>
				<c:forEach var="credit" items="${paymentInstruction.credits}">
					<c:set var="timeCreated" value="${credit.timeCreated}" />
					<c:set var="timeUpdated" value="${credit.timeUpdated}" />
					<wc:Credit>
						<wc:Id><c:out value="${credit.id}" /></wc:Id>
						<wc:CreditedAmount><c:out value="${credit.creditedAmount}" /></wc:CreditedAmount>
						<wc:CreditingAmount><c:out value="${credit.creditingAmount}" /></wc:CreditingAmount>
						<wc:ExpectedAmount><c:out value="${credit.expectedAmount}" /></wc:ExpectedAmount>
						<wc:ReversingCreditedAmount><c:out value="${credit.reversingCreditedAmount}" /></wc:ReversingCreditedAmount>
						<wc:State><c:out value="${credit.state}" /></wc:State>
						<wc:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></wc:TimeCreated>
						<wc:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></wc:TimeUpdated>
					</wc:Credit>
				</c:forEach>
				<c:forEach var="payment" items="${paymentInstruction.payments}">
					<c:set var="timeCreated" value="${payment.timeCreated}" />
					<c:set var="timeExpired" value="${payment.timeExpired}" />
					<c:set var="timeUpdated" value="${payment.timeUpdated}" />
					<wc:Payment>
						<wc:Id><c:out value="${payment.id}" /></wc:Id>
						<wc:AttentionRequired><c:out value="${payment.paymentRequiresAttention}" /></wc:AttentionRequired>
						<wc:ApprovedAmount><c:out value="${payment.approvedAmount}" /></wc:ApprovedAmount>
						<wc:ApprovingAmount><c:out value="${payment.approvingAmount}" /></wc:ApprovingAmount>
						<wc:AvsCommonCode><c:out value="${payment.avsCommonCode}" /></wc:AvsCommonCode>
						<wc:DepositedAmount><c:out value="${payment.depositedAmount}" /></wc:DepositedAmount>
						<wc:DepositingAmount><c:out value="${payment.depositingAmount}" /></wc:DepositingAmount>
						<wc:ExpectedAmount><c:out value="${payment.expectedAmount}" /></wc:ExpectedAmount>
						<wc:Expired><c:out value="${payment.expired}" /></wc:Expired>
						<wc:ReversingApprovedAmount><c:out value="${payment.reversingApprovedAmount}" /></wc:ReversingApprovedAmount>
						<wc:ReversingDepositedAmount><c:out value="${payment.reversingDepositedAmount}" /></wc:ReversingDepositedAmount>
						<wc:State><c:out value="${payment.state}" /></wc:State>
						<wc:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></wc:TimeCreated>
						<wc:TimeExpired><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeExpired")).longValue()))%></wc:TimeExpired>
						<wc:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></wc:TimeUpdated>
					</wc:Payment>
				</c:forEach>
			</c:if>
		</wc:PaymentEntity>
	</wc:DataArea>
</wc:ShowPaymentEntity>

