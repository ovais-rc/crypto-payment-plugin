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

<%-- 
  *****
  * After a new user or buyer organization registers, and an order requiring approval is placed by a buyer this email will be sent to the approver. 
  * This email JSP page informs the approver about user or buyer organization registration and order approvals.
  * This JSP page is associated with ApproversNotifyView view in the struts-config file.   
  *****
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf"%>

<wcst:alias name="JSPHelper" var="jHelper">
	<wcf:param name="parameterSource" value="javax.servlet.jsp.jspRequest"/>
</wcst:alias>
<wcst:mapper source="jHelper" method="getParameter" var="getParameter"/>

<c:set var="flowId" value="${getParameter['flowId']}" scope="request"/>
<wcf:rest var="flow" url="store/{storeId}/flow/{flowId}" scope="request">
	<wcf:var name="storeId" value="${storeId}"/>
	<wcf:var name="flowId" value="${flowId}"/>
</wcf:rest>

<c:set var="approvalIdentifier" value="${flow.identifier}" scope="request"/>
<c:if test="${approvalIdentifier eq 'OrderProcess'}">
	<c:set var="orderId" value="${getParameter['orderId']}" scope="request"/>
</c:if>

<c:if test="${approvalIdentifier eq 'ResellerOrgEntityRegistrationAdd'}">
	<c:set var="orgName" value="${getParameter['org_orgEntityName']}" scope="request"/>
	<c:set var="logonId" value="${getParameter['usr_logonId']}" scope="request"/>
	<c:set var="firstName" value="${getParameter['firstName']}" scope="request"/>
</c:if>

<c:if test="${approvalIdentifier eq 'UserRegistrationAdd'}">
	<c:set var="orgName" value="${getParameter['ancestorOrgs']}" scope="request"/>
	<c:set var="logonId" value="${getParameter['logonId']}" scope="request"/>
	<c:set var="firstName" value="${getParameter['firstName']}" scope="request"/>
</c:if>

<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}${portUsed}" var="hostPath" />
<c:set value="${jspStoreImgDir}" var="fullJspStoreImgDir" />
<c:if test="${!(fn:contains(fullJspStoreImgDir, '://'))}">
	<c:set value="${hostPath}${jspStoreImgDir}" var="fullJspStoreImgDir" />
</c:if>

<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}${portUsed}" var="hostPath" />
<c:set value="${jspStoreImgDir}" var="fullJspStoreImgDir" />
<c:if test="${!(fn:contains(fullJspStoreImgDir, '://'))}">
	<c:set value="${hostPath}${jspStoreImgDir}" var="fullJspStoreImgDir" />
</c:if>

<%-- set up personalizationMap and common values --%>
<jsp:useBean id="personalizationMap" class="java.util.LinkedHashMap" type="java.util.Map"/>

<c:set target="${personalizationMap}" property="STORE_ID" value="${storeId}" />	
<c:set target="${personalizationMap}" property="CATALOG_ID" value="${catalogId}" />	
<c:set target="${personalizationMap}" property="LANG_ID" value="${langId}" />	
<c:set target="${personalizationMap}" property="STORE_NAME" value="${storeName}" />	
	
<%-- add specific personalization name-value pairs --%>	
<c:set target="${personalizationMap}" property="ORDER_ID" value="${WCParam.orderId}" />
	
<%-- output the Silverpop Transact XML --%>			

<%-- [campaignId] will be replaced with the value set in the Admin Console, or set the specific value here --%>
<CAMPAIGN_ID>[campaignId]</CAMPAIGN_ID>
<%-- if using 'Click to View', then put SAVE_COLUMNS elements here --%>
<c:if test="${!empty personalizationMap}">
<RECIPIENT>
<%@ include file="../Common/SilverpopPersonalizationXml.jspf"%>
<PERSONALIZATION>
<TAG_NAME>BODY</TAG_NAME>
<VALUE><![CDATA[
</c:if>

<!-- BEGIN ApproverNotify.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="EMAIL_PAGE_TITLE_1">
				<fmt:param value="${storeName}"/>
			</fmt:message>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>

	<body text="#333333" style="background-color:#fff">
		<p>&nbsp;</p>
		<table border="0" align="center" cellpadding="6" cellspacing="6">
			<tbody>
				<tr>
				  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size: 11px; color:#666">
					<p style="margin-bottom:0px;">	
						<fmt:message bundle="${storeText}" key="EMAIL_DISCLAIMER_1_MESSAGE">
							<fmt:param value="${storeName}"/>
						</fmt:message>
					</p>
					<p style="margin-top:0px;">
						<fmt:message bundle="${storeText}" key="EMAIL_DISCLAIMER_2_MESSAGE">
							<fmt:param value="${storeName}"/>
						</fmt:message>
					</p>
					</td>
				</tr>
			</tbody>
		</table>
		<table border="0" align="center" cellpadding="0" cellspacing="0" style="background-color:#fff; width:100%; max-width:690px; ">
			<tr>
				<td height="10" align="center" valign="top">
					<img src="${fullJspStoreImgDir}${env_vfileColor}email_template/top_border.jpg" height="10" border="0" alt="top border" style="display:block; width:100%">
				</td>
			</tr>
			<tr>
				<td align="center" valign="top" style="min-height:300px; border-color:#ccc; border-width:0px 1px 0px 1px; border-style:solid">
					 <table border="0" align="center" cellpadding="0" cellspacing="0" >
						<tr>
							<td height="96" align="left" valign="top">
						      <!-- Insert logo and optional social media links in this table row -->
						      <a href="#"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/Aurora_logo.jpg" width="219" height="96" alt="Aurora logo" border="0" style="display:block"/></a>
						    </td>
						</tr>
						<tr>
							<td align="center" valign="top" style="min-height:300px; padding: 0px 20px 0px 20px;">
									<table border="0" cellspacing="5" cellpadding="5" style="width: 100%;">
										<tbody>
											<c:choose>
												 <c:when test="${approvalIdentifier eq 'UserRegistrationAdd'}">
													<tr>
													<td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:21px; color:#333333">
														<fmt:message bundle="${storeText}" key="EMAIL_DEAR_ADMINISTRATOR"/>
													</td>
													</tr>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'OrderProcess'}">
													<tr>
													<td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:21px; color:#333333">
														<fmt:message bundle="${storeText}" key="EMAIL_DEAR_APPROVER"/>
													</td>
													</tr>
												 </c:when>
												 <c:otherwise>
													<!-- empty sub-heading -->
												 </c:otherwise>
											</c:choose>
										<tr>
										  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:14px; color:#333333">
										  <!-- START Message body 
										   TO DO: Need to account for this type: || approvalIdentifier eq 'ResellerUserRegistrationAdd'
										  -->
											<c:choose>
												 <c:when test="${approvalIdentifier eq 'ResellerOrgEntityRegistrationAdd'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_BUYERREG_MESSAGE">
														<fmt:param value="${orgName}"/>
													</fmt:message>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'UserRegistrationAdd'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_USERREG_MESSAGE">
														<fmt:param value="${logonId}"/>
														<fmt:param value="${orgName}"/>
														<fmt:param value="${storeName}"/>
													</fmt:message>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'OrderProcess'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_ALT_ORDER_MESSAGE">
														<fmt:param value="${orderId}"/>
														<fmt:param value="${storeName}"/>
													</fmt:message>
												 </c:when>
												 <c:otherwise>
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_GENERIC_MESSAGE"/>
												 </c:otherwise>
											</c:choose>
										   <!-- END Message body -->
										  </td>
										</tr>
									  </tbody>
									</table>
							</td>
						</tr>
						<tr>
							<td height="168" valign="top" align="center">
								<!-- Featured items table -->
								<table height="168" border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td style="padding-left: 20px; padding-right: 20px; padding-bottom: 10px;">
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_01.jpg" width="213" height="168" alt="Feature 1" border="0" style="display:block"></a>
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_02.jpg" width="210" height="168" alt="Feature 2" border="0" style="display:block"></a>
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_03.jpg" width="213" height="168" alt="Feature 3" border="0" style="display:block"></a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="30" valign="top">
					<!-- Footer -->
					<img src="${fullJspStoreImgDir}${env_vfileColor}email_template/footer.jpg" height="30" alt="Footer" border="0" style="display:block; width:100%"/>
				</td>
			</tr>		
		</table>  
		<table border="0" align="center" cellpadding="6" cellspacing="6">
		  <tbody>
			<tr>
			  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size: 11px; color:#666">
				<!-- Legal info. -->
				<fmt:message bundle="${storeText}" key="EMAIL_LEGAL_INFO_MESSAGE">
					<fmt:param value="${storeName}"/>
				</fmt:message>
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- Please leave spacers at bottom -->
		<p>&nbsp;</p>
		<p>&nbsp;</p>
	</body>
</html>

<c:if test="${!empty personalizationMap}">
]]></VALUE></PERSONALIZATION>
</RECIPIENT>
</c:if>