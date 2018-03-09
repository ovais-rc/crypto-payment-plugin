<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * 
  ***
--%>

<!-- BEGIN StandardCheck.jsp -->

<!-- Set the taglib -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="paymentAreaNumber" value="${WCParam.currentPaymentArea}"/>
<c:if test="${empty paymentAreaNumber}">
	<c:set var="paymentAreaNumber" value="${param.paymentAreaNumber}" />
</c:if>
<c:set var="paymentTCId" value="${param.paymentTCId}"/>

<c:set var="account" value="${param.account}"/>
<c:set var="check_routing_number" value="${param.check_routing_number}"/>
<c:set var="piAmount" value="${param.piAmount}"/>

<div class="card_info" id="WC_StandardCheck_div_1_<c:out value='${paymentAreaNumber}'/>">

	<input type="hidden" name="paymentTCId" value="<c:out value="${paymentTCId}"/>" id="WC_StandardCheck_inputs_1_<c:out value='${paymentAreaNumber}'/>"/>
	<input type="hidden" id="mandatoryFields_<c:out value='${paymentAreaNumber}'/>" name="mandatoryFields"  value="check_routing_number_<c:out value='${paymentAreaNumber}'/>,CheckAccount_<c:out value='${paymentAreaNumber}'/>,billing_address_id"/>

	<span class="col1">
		<span>
			<span class="required-field">*</span><label for="check_routing_number_<c:out value='${paymentAreaNumber}' />">
			<span><fmt:message bundle="${storeText}" key="EDPPaymentMethods_BANK_ROUTING_NO" /></span></label>
		</span><br />
		<span>
			<input aria-required="true" type="tel" name="check_routing_number" value="<c:out value="${check_routing_number}" />" id="check_routing_number_<c:out value='${paymentAreaNumber}'/>" onchange="JavaScript:CheckoutPayments.updatePaymentObject(<c:out value='${paymentAreaNumber}'/>, 'check_routing_number');"/>
		</span><br />
		<span>
			<span class="required-field">*</span><label for="CheckAccount_<c:out value='${paymentAreaNumber}' />">
			<span><fmt:message bundle="${storeText}" key="EDPPaymentMethods_BANK_ACCOUNT_NO"  /></span></label>
		</span><br />
		<span>
			<input aria-required="true" type="tel" name="account" value ="<c:out value="${account}" />" id="CheckAccount_<c:out value='${paymentAreaNumber}' />" onchange="JavaScript:CheckoutPayments.updatePaymentObject(<c:out value='${paymentAreaNumber}'/>, 'account');"/>
		</span><br />
		<%--
		***************************
		* Start: Show the remaining amount -- the amount not yet allocated to a payment method
		***************************
		--%>
		<%@ include file="PaymentAmount.jspf"%>
	</span>
</div>
<!-- END StandardCheck.jsp -->

