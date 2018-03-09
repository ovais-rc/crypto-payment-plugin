<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<%-- 
  *****
  * After the customer has provided the necessary information on the Change Password page, this email will be sent.
  * This email JSP page informs the customer about the new password. 
  * This JSP page is associated with ?? view in the struts-config file.  
  *****
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf"%>

<!-- BEGIN PasswordChangeNotify.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="EMAIL_PAGE_TITLE">
				<fmt:param value="${storeName}"/>
			</fmt:message>
		</title>
	</head>
	      
	<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" role="document">
	<span role="main">
	<table border="0" cellpadding="0" width="630" align="center" role="presentation">
	
	<tr><td align="center">
		<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
			<c:param name="storeId" value="${storeId}" />
			<c:param name="catalogId" value="${catalogId}" />
			<c:param name="isEmail" value="true" />
			<c:param name="useFullURL" value="true" />
			<c:param name="emsName" value="EmailBanner_Content" /> 
		</c:import>
	</td></tr>
	<tr><td align="left">	
		<!-- Border Line -->		
		<p style="height: 1px;background-color: #cccccc;"></p>
		
		<!-- Email Content -->
		<p style="clear: both;"></p>
		<span style="font-family: Arial, Helvetica, sans-serif;font-size: 16px;color: #808080;margin-top: 15px;"><fmt:message bundle="${storeText}" key="EMAIL_PASSWORD_HEADER"/></span>
		
		<p style="clear: both;"></p>
		<span style="font-family: Arial, Helvetica, sans-serif;font-size: 12px;color: #404040;margin-top: 25px;">
			<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
				<c:param name="storeId" value="${storeId}" />
				<c:param name="catalogId" value="${catalogId}" />
				<c:param name="isEmail" value="true" />
				<c:param name="emsName" value="PasswordChangeNotifyCenter_Content" /> 
				<c:param name="substitutionName1" value="[userName]" />
				<c:param name="substitutionValue1" value="${WCParam.logonId}" />
				<c:param name="substitutionName2" value="[password]" />
				<c:param name="substitutionValue2" value="${WCParam.logonPassword}" />
				<c:param name="substitutionName3" value="[storeName]" />
				<c:param name="substitutionValue3" value="${storeName}" />
			</c:import>
		</span>
	</td></tr>
	<tr><td align="center">	
		<p style="clear: both;"></p>
		<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
			<c:param name="storeId" value="${storeId}" />
			<c:param name="catalogId" value="${catalogId}" />
			<c:param name="isEmail" value="true" />
			<c:param name="useFullURL" value="true" />
			<c:param name="emsName" value="EmailBottom_Content" /> 
		</c:import>
		
		<p style="clear: both;"></p>
	</td></tr>
	<tr><td align="center">	
		<!-- Include email footer -->
		<%@ include file="../Common/Footer.jspf"%>
	</td></tr>
	</table>	
	</span>
	</body>
</html>
<!-- END PasswordChangeNotify.jsp -->
