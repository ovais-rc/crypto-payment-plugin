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
<%-- response builder for the AcknowledgeFinancialTransaction BOD --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<wcbase:useBean id="error"
	classname="com.ibm.commerce.beans.ErrorDataBean" scope="request" />
<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
String dateTime = sdf.format(new java.util.Date());
%>
<pay:AcknowledgeFinancialTransaction
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns:oa="http://www.openapplications.org/oagis/9"
		xmlns:wcf="http://www.ibm.com/xmlns/prod/commerce/foundation" 
		xmlns:pay="http://www.ibm.com/xmlns/prod/commerce/payment" 
		releaseID="" versionID="">
	<jsp:include page="../Resources/Components/Common/ApplicationArea.jsp" flush="true" />
	<pay:DataArea>
		<oa:Acknowledge>
			<jsp:include page="../Resources/Components/Common/OriginalApplicationArea.jsp" flush="true" />
			<c:if test="${!empty error.exceptionType}">
				<%
				java.util.Set set = new java.util.HashSet();
				Throwable e = error.getException();
				if(e != null) {
					while(true) {
						set.add(e);
						Throwable cause = null;
						if(e instanceof com.ibm.commerce.edp.api.BaseException) {
							cause = ((com.ibm.commerce.edp.api.BaseException)e).getPreviousException();
						}
						else {
							cause = e.getCause();
						}
						if(cause == null || set.contains(cause)) {
							break;
						}
						else {
							e = cause;
						}
					}
					if(e instanceof com.ibm.commerce.edp.api.BaseException) {
						com.ibm.commerce.edp.api.BaseException be = (com.ibm.commerce.edp.api.BaseException)e;
						pageContext.setAttribute("reasonCode", be.getMessageKey());
						pageContext.setAttribute("reason", be.getLocalizedMessage());
					}
				}
				%>
				<c:if test="${empty reasonCode}">
					<c:set var="reasonCode" value="${error.ECMessage.systemMessageIdentifier}" />
				</c:if>
				<c:if test="${empty reasonCode}">
					<wcbase:useBean id="storeError" classname="com.ibm.commerce.common.beans.StoreErrorDataBean" />
					<c:set var="reasonCode" value="${storeError.key}" />
				</c:if>
				<c:if test="${empty reason}">
					<c:set var="reason" value="${error.message}" />
				</c:if>
				<oa:ResponseCriteria>
					<oa:ChangeStatus>
						<oa:Code><c:out value="${error.correlationIdentifier}" /></oa:Code>
						<oa:ReasonCode><c:out value="${reasonCode}" /></oa:ReasonCode>
						<oa:Reason><c:out value="${reason}" /></oa:Reason>
					</oa:ChangeStatus>
				</oa:ResponseCriteria>
			</c:if>
		</oa:Acknowledge>
		<c:forEach var="financialTransaction1" items="${RequestProperties.financialTransactions}">
		  <c:set var="paymentMethodName" value="${financialTransaction1.paymentMethodName}" />
			<pay:FinancialTransaction type="<c:out value='${financialTransaction1.action}'/>">
			    <c:set var="financialTransaction" value="${financialTransaction1.financialTransaction}" />
			    <c:set var="payment" value="${financialTransaction1.financialTransaction.payment}" />
			    <c:if test="${!empty payment}">
			    	<c:set var="paymentInstruction" value="${payment.paymentInstruction}"/>
			    </c:if>
			    <c:set var="credit" value="${financialTransaction1.financialTransaction.credit}" />
			    <c:if test="${!empty credit}">
			    	<c:set var="paymentInstruction" value="${credit.paymentInstruction}"/>
			    </c:if>
			    <c:set var="currency" value="${paymentInstruction.currency}"/>
			    <c:set var="timeCreated" value="${financialTransaction1.financialTransaction.timeCreated}" />
					<c:set var="timeUpdated" value="${financialTransaction1.financialTransaction.timeUpdated}" />
					<wcf:FinancialTransactionIdentifier><wcf:FinancialTransactionID><c:out value="${financialTransaction.id}"/></wcf:FinancialTransactionID></wcf:FinancialTransactionIdentifier>
					<pay:RequestedAmount currency="<c:out value='${currency}'/>"><c:out value="${financialTransaction.requestedAmount}"/></pay:RequestedAmount>
					<pay:ProcessedAmount currency="<c:out value='${currency}'/>"><c:out value="${financialTransaction.processedAmount}"/></pay:ProcessedAmount>
					<c:set var="oldState" value="${financialTransaction.state}"/>
					<c:choose>
						<c:when test="${oldState eq 0}">
							<c:set var="state" value="New" />
						</c:when>
						<c:when test="${oldState eq 1}">
							<c:set var="state" value="Pending" />
						</c:when>
						<c:when test="${oldState eq 2}">
							<c:set var="state" value="Success" />
						</c:when>
						<c:when test="${oldState eq 3}">
							<c:set var="state" value="Failed" />
						</c:when>
						<c:when test="${oldState eq 4}">
							<c:set var="state" value="Canceled" />
						</c:when>
						<c:otherwise>
							<c:set var="state" value="" />
						</c:otherwise>
					</c:choose>
					<pay:State><c:out value="${state}" /></pay:State>
          <pay:ReferenceNumber><c:out value="${financialTransaction.referenceNumber}"/></pay:ReferenceNumber>
          <pay:ResponseCode><c:out value="${financialTransaction.responseCode}"/></pay:ResponseCode>
          <pay:ReasonCode><c:out value="${financialTransaction.reasonCode}"/></pay:ReasonCode>
		  <pay:ReasonMessage />
          <pay:TrackingID><c:out value="${financialTransaction.trackingId}"/></pay:TrackingID>

					<c:if test="${!empty financialTransaction.extendedData}">
							<c:forEach var="extendedData" items="${financialTransaction.extendedData}">
									<wcf:ExtendedData name='<c:out value="${extendedData.key}"/>'><c:out value="${extendedData.value}"/></wcf:ExtendedData>
							</c:forEach>
					</c:if>
					<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
					<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
					<c:if test="${!empty payment}">
					    <c:set var="timeCreated" value="${payment.timeCreated}" />
							<c:set var="timeExpired" value="${payment.timeExpired}" />
							<c:set var="timeUpdated" value="${payment.timeUpdated}" />
							<pay:Payment>
									<wcf:PaymentIdentifier><wcf:PaymentID><c:out value="${payment.id}"/></wcf:PaymentID></wcf:PaymentIdentifier>
									<pay:ExpectedAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.expectedAmount}"/></pay:ExpectedAmount>
									<pay:ApprovingAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.approvingAmount}"/></pay:ApprovingAmount>
									<pay:ApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.approvedAmount}"/></pay:ApprovedAmount>
									<pay:DepositingAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.depositingAmount}"/></pay:DepositingAmount>
									<pay:DepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.depositedAmount}"/></pay:DepositedAmount>
									<pay:ReversingApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.reversingApprovedAmount}"/></pay:ReversingApprovedAmount>
									<pay:ReversingDepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${payment.reversingDepositedAmount}"/></pay:ReversingDepositedAmount>
									<c:set var="oldState" value="${payment.state}"/>
									<c:choose>
										<c:when test="${oldState eq 0}">
											<c:set var="state" value="New" />
										</c:when>
										<c:when test="${oldState eq 1}">
											<c:set var="state" value="Approving" />
										</c:when>
										<c:when test="${oldState eq 2}">
											<c:set var="state" value="Approved" />
										</c:when>
										<c:when test="${oldState eq 3}">
											<c:set var="state" value="Failed" />
										</c:when>
										<c:when test="${oldState eq 4}">
											<c:set var="state" value="Canceled" />
										</c:when>
										<c:when test="${oldState eq 5}">
											<c:set var="state" value="Expired" />
										</c:when>
										<c:otherwise>
											<c:set var="state" value="" />
										</c:otherwise>
									</c:choose>
									<pay:State><c:out value="${state}" /></pay:State>
									<pay:AvsCommonCode><c:out value="${payment.avsCommonCode}"/></pay:AvsCommonCode>
									<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
									<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
									<c:if test="${!empty timeExpired}">
											<pay:TimeExpired><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeExpired")).longValue()))%></pay:TimeExpired>
									</c:if>
									<c:if test="${!empty paymentInstruction}">									        
											<c:set var="timeCreated" value="${paymentInstruction.timeCreated}"/>
											<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}"/>
											<pay:PaymentInstruction>
													<wcf:PaymentInstructionIdentifier><wcf:PaymentInstructionID><c:out value="${paymentInstruction.id}"/></wcf:PaymentInstructionID></wcf:PaymentInstructionIdentifier>
													<pay:StoreID><c:out value="${paymentInstruction.store}"/></pay:StoreID>
													<c:if test="${!empty paymentInstruction.orderId}">
													    <wcf:OrderIdentifier><wcf:OrderID><c:out value="${paymentInstruction.orderId}"/></wcf:OrderID></wcf:OrderIdentifier>
													</c:if>
													<c:if test="${!empty paymentInstruction.rmaId}">
															<wcf:RMAIdentifier><wcf:RMAID><c:out value="${paymentInstruction.rmaId}"/></wcf:RMAID></wcf:RMAIdentifier>
													</c:if>
													<pay:PaymentConfigurationID><c:out value="${paymentInstruction.paymentConfigurationId}"/></pay:PaymentConfigurationID>
													<pay:PaymentMethodName><c:out value="${paymentMethodName}"/></pay:PaymentMethodName>
													<pay:PaymentSystemName><c:out value="${paymentInstruction.paymentSystemName}"/></pay:PaymentSystemName>
													<pay:PaymentPluginName><c:out value="${paymentInstruction.paymentPluginName}"/></pay:PaymentPluginName>
													<pay:Amount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.amount}"/></pay:Amount>
													<c:if test="${!empty paymentInstruction.accountNumber}">
															<pay:AccountNumber><c:out value="${paymentInstruction.accountNumber}"/></pay:AccountNumber>
													</c:if>
													<c:if test="${!empty paymentInstruction.extendedData}">
															<c:forEach var="extendedData" items="${paymentInstruction.extendedData}">
													    		<wcf:ExtendedData name='<c:out value="${extendedData.key}"/>'><c:out value="${extendedData.value}"/></wcf:ExtendedData>
															</c:forEach>
													</c:if>
													<pay:ApprovingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvingAmount}" /></pay:ApprovingAmount>
													<pay:ApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvedAmount}" /></pay:ApprovedAmount>
													<pay:DepositingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositingAmount}" /></pay:DepositingAmount>
													<pay:DepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositedAmount}" /></pay:DepositedAmount>
													<pay:CreditingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditingAmount}" /></pay:CreditingAmount>
													<pay:CreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditedAmount}" /></pay:CreditedAmount>
													<pay:ReversingApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingApprovedAmount}" /></pay:ReversingApprovedAmount>
													<pay:ReversingDepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingDepositedAmount}" /></pay:ReversingDepositedAmount>
													<pay:ReversingCreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
													<c:set var="oldState" value="${paymentInstruction.state}"/>
													<c:choose>
														<c:when test="${oldState eq 0}">
															<c:set var="state" value="New" />
														</c:when>
														<c:when test="${oldState eq 1}">
															<c:set var="state" value="Valid" />
														</c:when>
														<c:when test="${oldState eq 2}">
															<c:set var="state" value="Invalid" />
														</c:when>
														<c:when test="${oldState eq 3}">
															<c:set var="state" value="Closed" />
														</c:when>
														<c:otherwise>
															<c:set var="state" value="" />
														</c:otherwise>
													</c:choose>
													<pay:State><c:out value="${state}" /></pay:State>
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
									<wcf:CreditIdentifier><wcf:CreditID><c:out value="${credit.id}"/></wcf:CreditID></wcf:CreditIdentifier>
								  <pay:ExpectedAmount currency="<c:out value='${currency}'/>"><c:out value="${credit.expectedAmount}"/></pay:ExpectedAmount>
									<pay:CreditingAmount currency="<c:out value='${currency}'/>"><c:out value="${credit.creditingAmount}" /></pay:CreditingAmount>
								  <pay:CreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${credit.creditedAmount}" /></pay:CreditedAmount>
									<pay:ReversingCreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${credit.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
									<c:set var="oldState" value="${credit.state}"/>
									<c:choose>
										<c:when test="${oldState eq 0}">
											<c:set var="state" value="New" />
										</c:when>
										<c:when test="${oldState eq 1}">
											<c:set var="state" value="Crediting" />
										</c:when>
										<c:when test="${oldState eq 2}">
											<c:set var="state" value="Credited" />
										</c:when>
										<c:when test="${oldState eq 3}">
											<c:set var="state" value="Failed" />
										</c:when>
										<c:when test="${oldState eq 4}">
											<c:set var="state" value="Canceled" />
										</c:when>
										<c:otherwise>
											<c:set var="state" value="" />
										</c:otherwise>
									</c:choose>
									<pay:State><c:out value="${state}" /></pay:State>
									<pay:TimeCreated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeCreated")).longValue()))%></pay:TimeCreated>
									<pay:TimeUpdated><%=sdf.format(new java.util.Date(((Long)pageContext.getAttribute("timeUpdated")).longValue()))%></pay:TimeUpdated>
									<c:if test="${!empty paymentInstruction}">
											<c:set var="timeCreated" value="${paymentInstruction.timeCreated}" />
											<c:set var="timeUpdated" value="${paymentInstruction.timeUpdated}" />
											<pay:PaymentInstruction>
													<wcf:PaymentInstructionIdentifier><wcf:PaymentInstructionID><c:out value="${paymentInstruction.id}"/></wcf:PaymentInstructionID></wcf:PaymentInstructionIdentifier>
													<pay:StoreID><c:out value="${paymentInstruction.store}"/></pay:StoreID>
													<c:if test="${!empty paymentInstruction.orderId}">
															<wcf:OrderIdentifier><wcf:OrderID><c:out value="${paymentInstruction.orderId}"/></wcf:OrderID></wcf:OrderIdentifier>
													</c:if>
													<c:if test="${!empty paymentInstruction.rmaId}">
															<wcf:RMAIdentifier><wcf:RMAID><c:out value="${paymentInstruction.rmaId}"/></wcf:RMAID></wcf:RMAIdentifier>
													</c:if>
													<pay:PaymentConfigurationID><c:out value="${paymentInstruction.paymentConfigurationId}"/></pay:PaymentConfigurationID>
													<pay:PaymentMethodName><c:out value="${paymentMethodName}"/></pay:PaymentMethodName>
													<pay:PaymentSystemName><c:out value="${paymentInstruction.paymentSystemName}"/></pay:PaymentSystemName>
													<pay:PaymentPluginName><c:out value="${paymentInstruction.paymentPluginName}"/></pay:PaymentPluginName>
													<pay:Amount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.amount}"/></pay:Amount>
													<c:if test="${!empty paymentInstruction.accountNumber}">
															<pay:AccountNumber><c:out value="${paymentInstruction.accountNumber}"/></pay:AccountNumber>
													</c:if>
													<c:if test="${!empty paymentInstruction.extendedData}">
															<c:forEach var="extendedData" items="${paymentInstruction.extendedData}">
													    		<wcf:ExtendedData name='<c:out value="${extendedData.key}"/>'><c:out value="${extendedData.value}"/></wcf:ExtendedData>
															</c:forEach>
													</c:if>
													<pay:ApprovingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvingAmount}" /></pay:ApprovingAmount>
													<pay:ApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.approvedAmount}" /></pay:ApprovedAmount>
													<pay:DepositingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositingAmount}" /></pay:DepositingAmount>
													<pay:DepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.depositedAmount}" /></pay:DepositedAmount>
													<pay:CreditingAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditingAmount}" /></pay:CreditingAmount>
													<pay:CreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.creditedAmount}" /></pay:CreditedAmount>
													<pay:ReversingApprovedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingApprovedAmount}" /></pay:ReversingApprovedAmount>
													<pay:ReversingDepositedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingDepositedAmount}" /></pay:ReversingDepositedAmount>
													<pay:ReversingCreditedAmount currency="<c:out value='${currency}'/>"><c:out value="${paymentInstruction.reversingCreditedAmount}" /></pay:ReversingCreditedAmount>
													<c:set var="oldState" value="${paymentInstruction.state}"/>
													<c:choose>
														<c:when test="${oldState eq 0}">
															<c:set var="state" value="New" />
														</c:when>
														<c:when test="${oldState eq 1}">
															<c:set var="state" value="Valid" />
														</c:when>
														<c:when test="${oldState eq 2}">
															<c:set var="state" value="Invalid" />
														</c:when>
														<c:when test="${oldState eq 3}">
															<c:set var="state" value="Closed" />
														</c:when>
														<c:otherwise>
															<c:set var="state" value="" />
														</c:otherwise>
													</c:choose>
													<pay:State><c:out value="${state}" /></pay:State>
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
</pay:AcknowledgeFinancialTransaction>
