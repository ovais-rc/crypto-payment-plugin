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
  * After the customer has provided the necessary information on the Forget Password page, this email will be sent.
  * This email JSP page informs the customer about the newly reset password. 
  * This JSP page is associated with PasswordNotifyView view in the struts-config file.  
  *****
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf"%>

<%-- set up personalizationMap and common values --%>
<jsp:useBean id="personalizationMap" class="java.util.LinkedHashMap" type="java.util.Map"/>

<c:set target="${personalizationMap}" property="STORE_ID" value="${storeId}" />	
<c:set target="${personalizationMap}" property="CATALOG_ID" value="${catalogId}" />	
<c:set target="${personalizationMap}" property="LANG_ID" value="${langId}" />	
<c:set target="${personalizationMap}" property="STORE_NAME" value="${storeName}" />	
	
<%-- add specific personalization name-value pairs --%>
<c:set target="${personalizationMap}" property="USER_NAME" value="${WCParam.logonId}" />	
<c:set target="${personalizationMap}" property="VALIDATION_CODE" value="${WCParam.logonPassword}" />	

<c:choose>
	<c:when test="${!empty WCParam.resetPasswordFormURL}">
		<c:set target="${personalizationMap}" property="RESET_PASSWORD_URL" value="${WCParam.resetPasswordFormURL}" />	
	</c:when>
	<c:otherwise>
		<c:set target="${personalizationMap}" property="RESET_PASSWORD_URL" value="" />	
	</c:otherwise>
</c:choose>
	
<%-- output the Silverpop Transact XML --%>

<%-- [campaignId] will be replaced with the value set in the Admin Console, or set the specific value here --%>
<CAMPAIGN_ID>[campaignId]</CAMPAIGN_ID>
<%-- if using 'Click to View', then put SAVE_COLUMNS elements here, for example
<SAVE_COLUMNS>
<COLUMN_NAME>USER_NAME</COLUMN_NAME>
<COLUMN_NAME>VALIDATION_CODE</COLUMN_NAME>
<COLUMN_NAME>RESET_PASSWORD_URL</COLUMN_NAME>
<COLUMN_NAME>SUBJECT</COLUMN_NAME>
<COLUMN_NAME>STORE_ID</COLUMN_NAME>
<COLUMN_NAME>CATALOG_ID</COLUMN_NAME>
<COLUMN_NAME>LANG_ID</COLUMN_NAME>
<COLUMN_NAME>STORE_NAME</COLUMN_NAME>
</SAVE_COLUMNS>
--%>
<c:if test="${!empty personalizationMap}">
<RECIPIENT>
<%@ include file="../Common/SilverpopPersonalizationXml.jspf"%>
<%-- Optionally include e-Marketing Spots here --%>
</RECIPIENT>
</c:if>