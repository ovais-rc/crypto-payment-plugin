<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN GlobalLoginOrganizationAndContract.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/ErrorMessageSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:choose>
	<c:when test = "${env_b2bStore == 'true'}">
		<c:choose>
			<c:when test="${env_shopOnBehalfEnabled_CSR eq 'true' && env_shopOnBehalfSessionEstablished eq 'true'}">
				<%-- Refer to scenario B5 below --%>
				<%@ include file="CSR/GlobalLogin_CSR_Data.jspf" %>
			</c:when>
			<c:otherwise>
				<%-- Scenario B2 to B4 --%>
				<%@ include file="GlobalLoginOrganizationAndContract_Data.jspf" %>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<%-- Refer to scenario A1, A2, A3 --%>
		<%@ include file="CSR/GlobalLogin_CSR_Data.jspf" %>
	</c:otherwise>
</c:choose>

<%-- Separate out to B2C and B2B Store sceanrios to simplify the logic --%>
<%--
	Possible Scenarios:
	A1) B2C Shopper
	A2) CSR 
	A3) CSR on behalf of Shopper

	B1) B2B buyer
	B2) B2B Admin
	B3) B2B Admin on-behalf on buyer
	B4) CSR
	B5) CSR on-behalf of buyer
--%>

<c:choose>
	<c:when test="${env_b2bStore != 'true'}">
		<c:choose>
		  <c:when test="${env_shopOnBehalfEnabled_CSR eq 'true'}">
			<%-- Handles A2 and A3 --%>
			<%@ include file="CSR/GlobalLoginShopOnBehalfEnabled_CSR_UI.jspf" %>
		  </c:when>
		  <c:otherwise>
			<%-- Handles A1 --%>
			<%@ include file="GlobalLoginShopOnBehalfDisabled_UI.jspf" %>
		  </c:otherwise>
		</c:choose>	
	</c:when>
	<c:otherwise>
		<c:choose>
		  <c:when test="${env_shopOnBehalfSessionEstablished eq 'true' && env_shopOnBehalfEnabled_CSR eq 'true'}">
			<%-- Handles B5 --%>
			<%@ include file="CSR/GlobalLoginShopOnBehalfEnabled_CSR_UI.jspf" %>
		  </c:when>
		  <c:when test="${env_shopOnBehalfEnabled eq 'true'}">
			<%-- Handles B1 and B2 --%>
			<%@ include file="GlobalLoginShopOnBehalfEnabled_UI.jspf" %>
		  </c:when>
		  <c:otherwise>
			<%-- Handles B4 --%>
			<%@ include file="GlobalLoginShopOnBehalfDisabled_UI.jspf" %>
		  </c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<!-- END GlobalLoginOrganizationAndContract.jsp -->