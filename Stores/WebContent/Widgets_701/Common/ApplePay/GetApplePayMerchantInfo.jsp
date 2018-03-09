<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- BEGIN GetApplePayMerchantInfo.jsp --%>
<%@ include file="../EnvironmentSetup.jspf"%>
<% pageContext.setAttribute("lineBreak", "\n"); %> 

<%-- Get merchant configuration information, i.e. supportedNetworks and merchantCapabilities --%>
<wcf:rest var="merchantInfo" url="store/{storeId}/merchant">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="paymentSystem" value="ApplePaySystem" encode="true"/>
	<wcf:param name="paymentConfigGroup" value="default" encode="true"/>
	<wcf:param name="responseFormat" value="json" />
</wcf:rest>
/*
{
	"merchantIdentifier": "<c:out value='${merchantInfo.merchantIdentifier}'/>"
}
*/
<%-- END GetApplePayMerchantInfo.jsp --%>
