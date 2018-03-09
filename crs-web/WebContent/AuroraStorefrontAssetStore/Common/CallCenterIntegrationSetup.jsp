<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ include file="EnvironmentSetup.jspf" %>

<flow:ifEnabled feature="SideBySideIntegration">
	<c:if test="${env_shopOnBehalfEnabled_CSR eq 'true' && env_shopOnBehalfSessionEstablished eq 'false'}">
		<c:if test="${WCParam.containsKey('wccMode')}">
			<script>
				$(document).ready(function() {
					callCenterIntegrationJS.setUpCookies("${fn:escapeXml(WCParam.wccMode)}");
				});
			</script>
		</c:if>
		<%@ include file="CSRFProtection.jspf"%>
	</c:if>
	<c:if test="${env_shopOnBehalfSessionEstablished eq 'true'}">
		<wcf:rest var="person" url="store/{storeId}/person/@self">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>
		<script>
		$(document).ready(function() {
				callCenterIntegrationJS.updateWCParamJS("userId", "${CommandContext.forUserId}");
				callCenterIntegrationJS.updateWCParamJS("logonId", "${person.logonId}");
			});
		</script>
	</c:if>
</flow:ifEnabled>
