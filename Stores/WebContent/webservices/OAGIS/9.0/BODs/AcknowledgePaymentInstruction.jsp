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
<%-- response builder for the AcknowledgePaymentInstruction BOD --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>

<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String dateTime = sdf.format(new java.util.Date());
%>

<pay:AcknowledgePaymentInstruction releaseID="9.0" xmlns:oa="http://www.openapplications.org/oagis/9" 
        xmlns:pay="http://www.ibm.com/xmlns/prod/commerce/payment" 
        xmlns:wcf="http://www.ibm.com/xmlns/prod/commerce/foundation" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xsi:schemaLocation="http://www.ibm.com/xmlns/prod/commerce/payment ../xsd/OAGIS/9.0/Overlays/IBM/Commerce/BODs/AcknowledgeFinancialTransaction.xsd http://www.openapplications.org/oagis/9 ../../../../../../Oagis9Dependencies.xsd http://www.ibm.com/xmlns/prod/commerce/foundation ../Resources/Components/CommerceFoundation.xsd ">
	<wcf:ApplicationArea>
		<oa:CreationDateTime><%=dateTime%></oa:CreationDateTime>
		<oa:BODID><%=dateTime%><c:out value="[${CommandContext.user.displayName}]" /></oa:BODID>
	</wcf:ApplicationArea>
	<pay:DataArea>
		<oa:Acknowledge>
			<oa:ResponseCriteria>
				<oa:ChangeStatus>
					<c:if test="${!empty error.exceptionType}">
					    <oa:Code><c:out value="${error.correlationIdentifier}" /></oa:Code>
					    <oa:ReasonCode><c:out value="${error.errorCode}" /></oa:ReasonCode>
					    <c:set var="reason" value="${error.systemMessage}" />
                        <c:if test="${empty reason}">
	                      <c:set var="reason" value="${error.message}" />
                        </c:if>
						<oa:Reason><c:out value="${reason}"/></oa:Reason>
					</c:if>
				</oa:ChangeStatus>
			</oa:ResponseCriteria>
		</oa:Acknowledge>
		<c:forEach var="paymentInstruction1" items="${RequestProperties.paymentInstructions}">
		<c:set var="paymentInstruction" value="${paymentInstruction1.paymentInstruction}" />
		<c:set var="paymentMethodName" value="${paymentInstruction1.paymentMethodName}" />
			<c:if test="${!empty paymentInstruction}">
				<c:set var="timeCreated" value="${paymentInstruction.timeCreated}" />
				<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}" />
	    	<pay:PaymentInstruction>
	    	        <c:set var="currency" value="${paymentInstruction.currency}"/>
					<pay:PaymentInstructionIdentifier>
						<wcf:PaymentInstructionID><c:out value="${paymentInstruction.id}"/></wcf:PaymentInstructionID>
					</pay:PaymentInstructionIdentifier>
                    <pay:StoreID><c:out value="${paymentInstruction.store}"/></pay:StoreID>
					<c:if test="${!empty paymentInstruction.orderId}">
						<pay:OrderIdentifier>
							<wcf:OrderID><c:out value="${paymentInstruction.orderId}"/></wcf:OrderID>
						</pay:OrderIdentifier>
					</c:if>
					<c:if test="${!empty paymentInstruction.rmaId}">
						<pay:RMAIdentifier>
							<wcf:RMAID><c:out value="${paymentInstruction.rmaId}"/></wcf:RMAID>
						</pay:RMAIdentifier>
					</c:if>
					<pay:PaymentConfigurationID><c:out value="${paymentInstruction.paymentConfigurationId}"/></pay:PaymentConfigurationID>
					<pay:PaymentMethodName><c:out value="${paymentMethodName}"/></pay:PaymentMethodName>
					<pay:PaymentSystemName><c:out value="${paymentInstruction.paymentSystemName}"/></pay:PaymentSystemName>
					<pay:PaymentPluginName><c:out value="${paymentInstruction.paymentPluginName}"/></pay:PaymentPluginName>
					<pay:Amount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.amount}"/></pay:Amount>
					<pay:AccountNumber><c:out value="${paymentInstruction.accountNumber}"/></pay:AccountNumber>
					<c:if test="${!empty paymentInstruction.extendedData}">
						<c:forEach var="extendedData" items="${paymentInstruction.extendedData}">
							<pay:ExtendedData name='<c:out value="${extendedData.key}"/>'>
								<c:out value="${extendedData.value}"/>
							</pay:ExtendedData>
						</c:forEach>
					</c:if>
                    <pay:ApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvedAmount}" /></pay:ApprovedAmount>
                    <pay:ApprovingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvingAmount}" /></pay:ApprovingAmount>
                    <pay:CreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditedAmount}" /></pay:CreditedAmount>
                    <pay:CreditingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditingAmount}" /></pay:CreditingAmount>
                    <pay:DepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositedAmount}" /></pay:DepositedAmount>
                    <pay:DepositingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositingAmount}" /></pay:DepositingAmount>
                    <pay:ReversingApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingApprovedAmount}" /></pay:ReversingApprovedAmount>
                    <pay:ReversingCreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
                    <pay:ReversingDepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingDepositedAmount}" /></pay:ReversingDepositedAmount>
                    <pay:State>
						<c:set var="oldState" value="${paymentInstruction.state}"/>
						<c:if test="${oldState eq 0}">New</c:if>
						<c:if test="${oldState eq 1}">Valid</c:if>
						<c:if test="${oldState eq 2}">Invalid</c:if>
						<c:if test="${oldState eq 3}">Closed</c:if>
					</pay:State>
                    <pay:Retriable><c:out value="${paymentInstruction.paymentInstructionRetriable}" /></pay:Retriable>
					<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
					<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
				</pay:PaymentInstruction>
			</c:if>	  
		</c:forEach>
	</pay:DataArea>
</pay:AcknowledgePaymentInstruction>
