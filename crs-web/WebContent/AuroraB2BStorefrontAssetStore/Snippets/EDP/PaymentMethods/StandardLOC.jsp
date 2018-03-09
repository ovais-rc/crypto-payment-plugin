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
<%-- 
  ***
  *    This JSP snippet displays the following information:
  *	     - The protocol data fields for the payment method LineOfCredit.
  *	     - A list of usable billing addresses for this payment method.
  ***
--%>

<!-- BEGIN StandardLOC.jsp -->

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

<c:set var="account" value="${param.account}"/>
<c:set var="piAmount" value="${param.piAmount}"/>
<c:set var="paymentTCId" value="${param.paymentTCId}"/>
<c:set var="buyerOrgDN" value="${param.buyerOrgDN}"/>

<c:if test="${!empty paymentTCId}" >
  <c:catch var="error">
    <wcf:rest var="paymentTCbean" url="store/{storeId}/contract" scope="page">
      <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
      <wcf:param name="q" value="byPaymentTermConditionId"/>
      <wcf:param name="paymentTCId" value="${paymentTCId}"/>
    </wcf:rest>
  </c:catch>
    <c:set var="WCAccountId" value="${paymentTCbean.tradingId}" />
    
   	<c:forEach var="pAttrValue" items="${paymentTCbean.PAttrValues}">
	<%-- Remove the scoped variable --%>
       <c:remove var="attribute"/>
      <c:catch var="error">
        <wcf:rest var="attribute" url="store/{storeId}/cart/@self/pattribute/{attributeId}" scope="page">
          <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
          <wcf:var name="attributeId" value="${pAttrValue.attributeId}" encode="true"/>
        </wcf:rest>
      </c:catch>
   	   <c:if test="${attribute.resultList[0].name eq 'account'}">
            <c:if test="${!empty pAttrValue.PAttrValue}">
              <c:set var="valueFromPaymentTC" value="true" />
   		      <c:set var="account" value="${pAttrValue.PAttrValue}" />
            </c:if>
            <c:if test="${empty pAttrValue.PAttrValue}">
	          <c:set var="account" value="" />
            </c:if>
       </c:if>
    </c:forEach>
</c:if>

<div class="card_info" id="WC_StandardLOC_div_1_<c:out value='${paymentAreaNumber}'/>">
	<span class="col1">
		<%@ include file="PaymentAmount.jspf"%>	
	</span>
			<input type="hidden" name="account" id="account1_<c:out value='${paymentAreaNumber}'/>" value ="<c:out value='${account}' />" />
			<input type="hidden" name="paymentTCId" value="<c:out value='${paymentTCId}'/>" id="paymentTCId"/>
			<input type="hidden" name="BuyerOrgDN" id="BuyerOrgDN" value="<c:out value='${buyerOrgDN}'/>" />
			<input type="hidden" name="WCAccountId" id="WCAccountId" value="<c:out value='${WCAccountId}'/>" />
</div>
<!-- END StandardLOC.jsp -->
