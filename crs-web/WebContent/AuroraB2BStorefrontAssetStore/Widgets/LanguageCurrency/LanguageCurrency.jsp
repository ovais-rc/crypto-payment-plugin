<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN LanguageCurrency.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/LanguageCurrency_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="LanguageCurrency_Data.jspf" %>
</c:if>

<%@ include file="ext/LanguageCurrency_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
		<%-- If store supports only one language and one currency, then do not show the popup with options to select lang/currency --%>
		<c:when test = "${fn:length(supportedCurrencies) == 1 && fn:length(supportedLanguages) == 1}">
			<%@ include file="LanguageCurrency_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="LanguageCurrency_Popup_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>
<jsp:useBean id="LanguageCurrency_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END LanguageCurrency.jsp -->