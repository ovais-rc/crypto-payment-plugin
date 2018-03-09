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
  * After the customer will create a wish list and specify the target user's email addresses, this email will be sent to them.
  * This email JSP page informs the customer's contacts about the newly created wish list. 
  * This JSP page is associated with GiftRegistryAnnouncementMessageView view in the struts-config file.    
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
	
	<c:set var="guestAccessKey" value=""/>
	<c:if test="${!empty WCParam.giftListId}">
		<c:set var="selectedWishListId" value="${WCParam.giftListId}"/>
		<wcf:rest var="wishListResult" url="/store/{storeId}/wishlist/{wishlistId}">
			<wcf:var name="storeId" value="${storeId}" />
			<wcf:var name="wishlistId" value="${selectedWishListId}" />
		</wcf:rest>
		<c:set var="selectedWishList" value="${wishListResult.GiftList[0]}"/>
		<c:set var="guestAccessKey" value="${selectedWishList.guestAccessKey}"/>
	</c:if>
	
	<c:url var="sharedWishListViewURL" value="SharedWishListView">
		<c:param name="langId" value="${langId}" />
		<c:param name="storeId" value="${storeId}" />
		<c:param name="catalogId" value="${catalogId}" />
		<c:param name="wishListEMail" value="true"/>  
		<c:param name="externalId" value="${WCParam.giftListId}" />
		<c:param name="guestAccessKey" value="${guestAccessKey}" />
	</c:url>
	<c:set value="${pageContext.request.serverName}${portUsed}" var="hostPath" />
	<c:set var="wishListlink" value="${hostPath}${pageContext.request.contextPath}/servlet/${sharedWishListViewURL}" />
	
	<c:choose>
		<c:when test="${!empty WCParam.senderEmail && WCParam.senderEmail != 'SOAWishListEmail@SOAWishListEmail.com'}">
			<c:set var="senderEmail" value="${WCParam.senderEmail}" />
		</c:when>
		<c:otherwise>
			<fmt:message bundle="${storeText}" key="EMAIL_WISHLISTMESSAGE_NA" var="senderEmail"/>
		</c:otherwise>
	</c:choose>

	<%-- add specific personalization name-value pairs --%>
	<c:set target="${personalizationMap}" property="WISHLIST_LINK" value="${wishListlink}" />	
  <c:set target="${personalizationMap}" property="SENDER_NAME" value="${WCParam.senderName}" />	
  <c:set target="${personalizationMap}" property="SENDER_EMAIL" value="${senderEmail}" />	

	<c:choose>
		<c:when test="${!empty WCParam.message && WCParam.message != 'SOAWishListEmail'}">
			<c:set target="${personalizationMap}" property="SENDER_MESSAGE" value="${WCParam.message}" />	
		</c:when>
		<c:otherwise>
			<c:set target="${personalizationMap}" property="SENDER_MESSAGE" value="" />	
		</c:otherwise>
	</c:choose>
	
<%-- output the Silverpop Transact XML --%>

<%-- [campaignId] will be replaced with the value set in the Admin Console, or set the specific value here --%>
<CAMPAIGN_ID>[campaignId]</CAMPAIGN_ID>
<%-- if using 'Click to View', then put SAVE_COLUMNS elements here, for example
<SAVE_COLUMNS>
<COLUMN_NAME>WISHLIST_LINK</COLUMN_NAME>
<COLUMN_NAME>SENDER_NAME</COLUMN_NAME>
<COLUMN_NAME>SENDER_EMAIL</COLUMN_NAME>
<COLUMN_NAME>SENDER_MESSAGE</COLUMN_NAME>
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

<%-- Include an e-Marketing Spot --%>
<PERSONALIZATION>
<TAG_NAME>EmailWishlistNotification_Content</TAG_NAME>
<VALUE><![CDATA[
<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
<c:param name="emsName" value="EmailWishlistNotification_Content" /> 
<c:param name="storeId" value="${storeId}" />
<c:param name="catalogId" value="${catalogId}" />
<c:param name="isEmail" value="true" />
<c:param name="useFullURL" value="true" />	
</c:import>
]]></VALUE></PERSONALIZATION>

</RECIPIENT>
</c:if>