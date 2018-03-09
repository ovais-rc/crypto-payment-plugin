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
<%-- response builder for the AcknowledgePaymentFinancialTransaction BOD --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String dateTime = sdf.format(new java.util.Date());
%>
<pay:RespondFinancialTransaction releaseID="9.0" xmlns:oa="http://www.openapplications.org/oagis/9" 
        xmlns:pay="http://www.ibm.com/xmlns/prod/commerce/payment" 
        xmlns:wcf="http://www.ibm.com/xmlns/prod/commerce/foundation" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xsi:schemaLocation="http://www.ibm.com/xmlns/prod/commerce/payment ../xsd/OAGIS/9.0/Overlays/IBM/Commerce/BODs/AcknowledgeFinancialTransaction.xsd http://www.openapplications.org/oagis/9 ../../../../../../Oagis9Dependencies.xsd http://www.ibm.com/xmlns/prod/commerce/foundation ../Resources/Components/CommerceFoundation.xsd ">
	<wcf:ApplicationArea>
		<oa:CreationDateTime><%=dateTime%></oa:CreationDateTime>
		<oa:BODID><%=dateTime%><c:out value="[${CommandContext.user.displayName}]" /></oa:BODID>
	</wcf:ApplicationArea>
	<pay:DataArea>
		<oa:Respond>
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
		</oa:Respond>
		<c:forEach var="financialTransaction1" items="${RequestProperties.financialTransactions}">
			<pay:FinancialTransaction Action='<c:out value="${financialTransaction1.action}"/>'>
			    <c:set var="financialTransaction" value="${financialTransaction1.financialTransaction}" />
			    <c:set var="payment" value="${financialTransaction1.financialTransaction.payment}" />
			    <c:if test="${!empty payment}">
			    	<c:set var="paymentInstruction" value="${payment.paymentInstruction}"/>
			    </c:if>
			    <c:set var="credit" value="${financialTransaction1.financialTransaction.credit}" />
			    <c:if test="${!empty credit}">
			    	<c:set var="paymentInstruction" value="${credit.paymentInstruction}"/>
			    </c:if>
			    <c:set var="timeCreated" value="${financialTransaction1.financialTransaction.timeCreated}" />
					<c:set var="timeUpdated" value="${financialTransaction1.financialTransaction.timeUpdated}" />
					<pay:FinancialTransactionIdentifer>
							<wcf:FinancialTransactionID>
									<c:out value="${financialTransaction.id}"/>
							</wcf:FinancialTransactionID>
					</pay:FinancialTransactionIdentifer>
					<pay:RequestedAmount>
							<c:out value="${financialTransaction.requestedAmount}"/>
					</pay:RequestedAmount>
					<pay:ProcessedAmount>
							<c:out value="${financialTransaction.processedAmount}"/>
					</pay:ProcessedAmount>
					<pay:State>
							<c:set var="oldState" value="${financialTransaction.state}"/>
							<c:if test="${oldState eq 0}">New</c:if>
							<c:if test="${oldState eq 1}">Pending</c:if>
							<c:if test="${oldState eq 2}">Success</c:if>
							<c:if test="${oldState eq 3}">Failed</c:if>
							<c:if test="${oldState eq 4}">Canceled</c:if>
					</pay:State>
					<c:if test="${!empty financialTransaction.referenceNumber}">
							<pay:ReferenceNumber>
									<c:out value="${financialTransaction.referenceNumber}"/>
							</pay:ReferenceNumber>
					</c:if>
					<c:if test="${!empty financialTransaction.responseCode}">
							<pay:ResponseCode>
									<c:out value="${financialTransaction.responseCode}"/>
							</pay:ResponseCode>
					</c:if>
					<c:if test="${!empty financialTransaction.reasonCode}">
							<pay:ReasonCode>
									<c:out value="${financialTransaction.reasonCode}"/>
							</pay:ReasonCode>
					</c:if>
					<c:if test="${!empty financialTransaction.trackingId}">
							<pay:TrackingID>
									<c:out value="${financialTransaction.trackingId}"/>
							</pay:TrackingID>
					</c:if>
					<c:if test="${!empty financialTransaction.extendedData}">
							<c:forEach var="extendedData" items="${financialTransaction.extendedData}">
									<pay:ExtendedData name='<c:out value="${extendedData.key}"/>'>
													<c:out value="${extendedData.value}"/>
									</pay:ExtendedData>
							</c:forEach>
					</c:if>
					<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
					<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
					<c:if test="${!empty payment}">
					    <c:set var="timeCreated" value="${payment.timeCreated}" />
							<c:set var="timeExpired" value="${payment.timeExpired}" />
							<c:set var="timeUpdated" value="${payment.timeUpdated}" />
							<pay:Payment>
									<pay:PaymentIdentifier>
											<wcf:PaymentID>
													<c:out value="${payment.id}"/>
											</wcf:PaymentID>
									</pay:PaymentIdentifier>
									<pay:ExpectedAmount>
											<c:out value="${payment.expectedAmount}"/>
									</pay:ExpectedAmount>
									<pay:ApprovingAmount>
											<c:out value="${payment.approvingAmount}"/>
									</pay:ApprovingAmount>
									<pay:ApprovedAmount>
											<c:out value="${payment.approvedAmount}"/>
									</pay:ApprovedAmount>
									<pay:DepositingAmount>
											<c:out value="${payment.depositingAmount}"/>
									</pay:DepositingAmount>
									<pay:DepositedAmount>
											<c:out value="${payment.depositedAmount}"/>
									</pay:DepositedAmount>
									<pay:ReversingApprovedAmount>
											<c:out value="${payment.reversingApprovedAmount}"/>
									</pay:ReversingApprovedAmount>
									<pay:ReversingDepositedAmount>
											<c:out value="${payment.reversingDepositedAmount}"/>
									</pay:ReversingDepositedAmount>
									<pay:State>
											<c:set var="oldState" value="${payment.state}"/>
											<c:if test="${oldState eq 0}">New</c:if>
											<c:if test="${oldState eq 1}">Approving</c:if>
											<c:if test="${oldState eq 2}">Approved</c:if>
											<c:if test="${oldState eq 3}">Failed</c:if>
											<c:if test="${oldState eq 4}">Canceled</c:if>
											<c:if test="${oldState eq 5}">Expired</c:if>
									</pay:State>
									<pay:AvsCommonCode>
											<c:out value="${payment.avsCommonCode}"/>
									</pay:AvsCommonCode>
									<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
									<c:if test="${!empty timeExpired}">
											<pay:TimeExpired><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeExpired")).longValue()))%></pay:TimeExpired>
									</c:if>
									<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
									<c:if test="${!empty paymentInstruction}">									        
											<c:set var="timeCreated" value="${paymentInstruction.timeCreated}"/>
											<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}"/>
											<pay:PaymentInstruction>
													<pay:PaymentInstructionIdentifier>
															<wcf:PaymentInstructionID>
																	<c:out value="${paymentInstruction.id}"/>
															</wcf:PaymentInstructionID>
													</pay:PaymentInstructionIdentifier>
													<pay:StoreID>
															<c:out value="${paymentInstruction.store}"/>
													</pay:StoreID>
													<c:if test="${!empty paymentInstruction.orderId}">
													    <pay:OrderIdentifier>
																	<wcf:OrderID>
																			<c:out value="${paymentInstruction.orderId}"/>
																	</wcf:OrderID>
														</pay:OrderIdentifier>
													</c:if>
													<c:if test="${!empty paymentInstruction.rmaId}">
															<pay:RMAIdentifier>
																	<wcf:RMAID>
																			<c:out value="${paymentInstruction.rmaId}"/>
																	</wcf:RMAID>
															</pay:RMAIdentifier>
													</c:if>
													<pay:PaymentConfigurationID>
															<c:out value="${paymentInstruction.paymentConfigurationId}"/>
													</pay:PaymentConfigurationID>
													<pay:PaymentSystemName>
															<c:out value="${paymentInstruction.paymentSystemName}"/>
													</pay:PaymentSystemName>
													<pay:PaymentPluginName>
															<c:out value="${paymentInstruction.paymentPluginName}"/>
													</pay:PaymentPluginName>
													<pay:Amount>
															<c:out value="${paymentInstruction.amount}"/>
													</pay:Amount>
													<c:if test="${!empty paymentInstruction.accountNumber}">
															<pay:AccountNumber>
																	<c:out value="${paymentInstruction.accountNumber}"/>
															</pay:AccountNumber>
													</c:if>
													<c:if test="${!empty paymentInstruction.extendedData}">
															<c:forEach var="extendedData" items="${paymentInstruction.extendedData}">
													    		<pay:ExtendedData name='<c:out value="${extendedData.key}"/>'>
																			<c:out value="${extendedData.value}"/>
																	</pay:ExtendedData>
															</c:forEach>
													</c:if>
													<pay:ApprovedAmount><c:out value="${paymentInstruction.approvedAmount}" /></pay:ApprovedAmount>
													<pay:ApprovingAmount><c:out value="${paymentInstruction.approvingAmount}" /></pay:ApprovingAmount>
													<pay:CreditedAmount><c:out value="${paymentInstruction.creditedAmount}" /></pay:CreditedAmount>
													<pay:CreditingAmount><c:out value="${paymentInstruction.creditingAmount}" /></pay:CreditingAmount>
													<pay:DepositedAmount><c:out value="${paymentInstruction.depositedAmount}" /></pay:DepositedAmount>
													<pay:DepositingAmount><c:out value="${paymentInstruction.depositingAmount}" /></pay:DepositingAmount>
													<pay:ReversingApprovedAmount><c:out value="${paymentInstruction.reversingApprovedAmount}" /></pay:ReversingApprovedAmount>
													<pay:ReversingCreditedAmount><c:out value="${paymentInstruction.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
													<pay:ReversingDepositedAmount><c:out value="${paymentInstruction.reversingDepositedAmount}" /></pay:ReversingDepositedAmount>
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
							</pay:Payment>
					</c:if>
					<c:if test="${!empty credit}">
							<c:set var="timeCreated" value="${credit.timeCreated}" />
							<c:set var="timeUpdated" value="${credit.timeUpdated}" />
							<pay:Credit>
									<pay:CreditIdentifier>
											<wcf:CreditID>
													<c:out value="${credit.id}"/>
											</wcf:CreditID>
									</pay:CreditIdentifier>
								  <pay:ExpectedAmount>
								  		<c:out value="${credit.expectedAmount}"/>
								  </pay:ExpectedAmount>
								  <pay:CreditedAmount><c:out value="${credit.creditedAmount}" /></pay:CreditedAmount>
									<pay:CreditingAmount><c:out value="${credit.creditingAmount}" /></pay:CreditingAmount>
									<pay:ReversingCreditedAmount><c:out value="${credit.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
									<pay:State>
											<c:set var="oldState" value="${credit.state}"/>
											<c:if test="${oldState eq 0}">New</c:if>
											<c:if test="${oldState eq 1}">Crediting</c:if>
											<c:if test="${oldState eq 2}">Credited</c:if>
											<c:if test="${oldState eq 3}">Failed</c:if>
											<c:if test="${oldState eq 4}">Canceled</c:if>
									</pay:State>
									<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
									<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
									<c:if test="${!empty paymentInstruction}">
											<c:set var="timeCreated" value="${paymentInstruction.timeCreated}" />
											<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}" />
											<pay:PaymentInstruction>
													<pay:PaymentInstructionIdentifier>
															<wcf:PaymentInstructionID>
																	<c:out value="${paymentInstruction.id}"/>
															</wcf:PaymentInstructionID>
													</pay:PaymentInstructionIdentifier>
													<pay:StoreID>
															<c:out value="${paymentInstruction.store}"/>
													</pay:StoreID>
													<c:if test="${!empty paymentInstruction.orderId}">
															<pay:OrderIdentifier>
																	<wcf:OrderID>
																			<c:out value="${paymentInstruction.orderId}"/>
																	</wcf:OrderID>
															</pay:OrderIdentifier>
													</c:if>
													<c:if test="${!empty paymentInstruction.rmaId}">
															<pay:RMAIdentifier>
																	<wcf:RMAID>
																			<c:out value="${paymentInstruction.rmaId}"/>
																	</wcf:RMAID>
															</pay:RMAIdentifier>
													</c:if>
													<pay:PaymentConfigurationID>
															<c:out value="${paymentInstruction.paymentConfigurationId}"/>
													</pay:PaymentConfigurationID>
													<pay:PaymentSystemName>
															<c:out value="${paymentInstruction.paymentSystemName}"/>
													</pay:PaymentSystemName>
													<pay:PaymentPluginName>
															<c:out value="${paymentInstruction.paymentPluginName}"/>
													</pay:PaymentPluginName>
													<pay:Amount>
															<c:out value="${paymentInstruction.amount}"/>
													</pay:Amount>
													<c:if test="${!empty paymentInstruction.accountNumber}">
															<pay:AccountNumber>
																	<c:out value="${paymentInstruction.accountNumber}"/>
															</pay:AccountNumber>
													</c:if>
													<c:if test="${!empty paymentInstruction.extendedData}">
															<c:forEach var="extendedData" items="${paymentInstruction.extendedData}">
													    		<pay:ExtendedData name='<c:out value="${extendedData.key}"/>'>
																			<c:out value="${extendedData.value}"/>
																	</pay:ExtendedData>
															</c:forEach>
													</c:if>
													<pay:ApprovedAmount><c:out value="${paymentInstruction.approvedAmount}" /></pay:ApprovedAmount>
													<pay:ApprovingAmount><c:out value="${paymentInstruction.approvingAmount}" /></pay:ApprovingAmount>
													<pay:CreditedAmount><c:out value="${paymentInstruction.creditedAmount}" /></pay:CreditedAmount>
													<pay:CreditingAmount><c:out value="${paymentInstruction.creditingAmount}" /></pay:CreditingAmount>
													<pay:DepositedAmount><c:out value="${paymentInstruction.depositedAmount}" /></pay:DepositedAmount>
													<pay:DepositingAmount><c:out value="${paymentInstruction.depositingAmount}" /></pay:DepositingAmount>
													<pay:ReversingApprovedAmount><c:out value="${paymentInstruction.reversingApprovedAmount}" /></pay:ReversingApprovedAmount>
													<pay:ReversingCreditedAmount><c:out value="${paymentInstruction.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
													<pay:ReversingDepositedAmount><c:out value="${paymentInstruction.reversingDepositedAmount}" /></pay:ReversingDepositedAmount>
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
							</pay:Credit>		
					</c:if>
			</pay:FinancialTransaction>
		</c:forEach>
	</pay:DataArea>
</pay:RespondFinancialTransaction>
