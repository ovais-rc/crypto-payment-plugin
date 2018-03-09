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

<span class="spanacce" id="orgNameForAcce">
	<fmt:message bundle="${storeText}" key="ORG_CREATE_ORG_NAME"/><c:out value='${orgEntityDetails.displayName}'/>
</span>
<div id="PageHeader_CreateEditOrganization" style="margin-bottom:0px;" tabindex="0" aria-labelledby="orgNameForAcce">
	<h1 style="padding: 0px 0px;"><c:out value='${orgEntityDetails.displayName}'/></h1>
</div>

<div class="row">
	<div class="col12">
		<%out.flush();%>
			<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationSummary/OrganizationSummary.jsp">
				<wcpgl:param name="orgSummaryType" value="edit"/>
				<wcpgl:param name="orgSummaryBasicEdit" value="true"/>
				<wcpgl:param name="orgSummaryAddressEdit" value="true"/>
				<wcpgl:param name="orgSummaryContactInfoEdit" value="true"/>
				<wcpgl:param name="orgEntityId" value="${orgEntityId}"/>
			</wcpgl:widgetImport>
		<%out.flush();%>

		<c:if test = "${(env_shopOnBehalfSessionEstablished eq 'false' && env_shopOnBehalfEnabled_CSR eq 'false')}">
			<%-- This is a normal buyerAdmin session or buyerAdmin on-behalf-session for another buyerAdmin. Not a CSR session --%>
			<%out.flush();%>
				<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationMemberApprovalGroups/OrganizationMemberApprovalGroups.jsp"/>
			<%out.flush();%>

			<%out.flush();%>
				<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationRoles/OrganizationRoles.jsp"/>
			<%out.flush();%>
		</c:if>
	</div>
</div>
<input type="hidden" id="authToken" value="${authToken}"/>
<div id="overlay" class="nodisplay"></div>
