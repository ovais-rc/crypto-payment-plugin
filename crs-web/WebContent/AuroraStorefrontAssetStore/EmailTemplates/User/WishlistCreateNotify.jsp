<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<%-- 
  *****
  * After the customer will create a wish list and specify the target user's email addresses, this email will be sent to them.
  * This email JSP page informs the customer's contacts about the newly created wish list. 
  *****
--%>

	<%@ include file="../../Common/EnvironmentSetup.jspf" %>
	<%@ include file="../../Common/nocache.jspf"%>
	<wcf:url var="emailStoreURL" patternName="HomePageURLWithLang" value="TopCategories">
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="urlLangId" value="${langId}" />
	</wcf:url>


	<c:set var="guestAccessKey" value=""/>
	<c:if test="${!empty WCParam.giftListId}">
		<c:set var="selectedWishListId" value="${WCParam.giftListId}"/>
		<wcf:rest var="wishListResult" url="/store/{storeId}/wishlist/{wishlistId}">
			<wcf:var name="storeId" value="${storeId}" />
			<wcf:var name="wishlistId" value="${selectedWishListId}" />
		</wcf:rest>
		<c:set var="selectedWishList" value="${wishListResult.GiftList[0]}"/>
		<c:set var="guestAccessKey" value="${selectedWishList.guestAccessKey}"/>
		<c:set var="listExternalId" value="${selectedWishList.externalIdentifier}"/>
	</c:if>
	
	<c:url var="sharedWishListViewURL" value="SharedWishListView">
		<c:param name="langId" value="${langId}" />
		<c:param name="storeId" value="${storeId}" />
		<c:param name="catalogId" value="${catalogId}" />
		<c:param name="wishListEMail" value="true"/>  
		<c:param name="externalId" value="${WCParam.giftListId}" />
		<c:param name="guestAccessKey" value="${guestAccessKey}" />
	</c:url>
	<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}${portUsed}" var="hostPath" />
	<c:set var="wishListlink" value="${hostPath}${pageContext.request.contextPath}/servlet/${sharedWishListViewURL}" />
	<c:set value="${jspStoreImgDir}" var="fullJspStoreImgDir" />
	<c:if test="${!(fn:contains(fullJspStoreImgDir, '://'))}">
		<c:set value="${hostPath}${jspStoreImgDir}" var="fullJspStoreImgDir" />
	</c:if>
	
	<c:choose>
		<c:when test="${!empty WCParam.senderEmail && WCParam.senderEmail != 'SOAWishListEmail@SOAWishListEmail.com'}">
			<c:set var="senderEmail" value="${WCParam.senderEmail}" />
		</c:when>
		<c:otherwise>
			<fmt:message bundle="${storeText}" key="EMAIL_WISHLISTMESSAGE_NA" var="senderEmail"/>
		</c:otherwise>
	</c:choose>
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title>
			<fmt:message bundle="${storeText}" key="EMAIL_PAGE_TITLE">
				<fmt:param value="${storeName}"/>
			</fmt:message>
		</title>
		

	</head>

	<body style="font-size: 12px; font-weight: normal; font-family: Arial,Verdana,Helvetica,sans-serif; margin: 0; padding: 0; background: none repeat scroll 0 0 #EEEEEE; line-height: 1.4em; " role="document">
		<span role="main">
		<table style="width: 100%; height: 100%; background-color: #ffffff; padding: 25px 0 50px;" role="presentation">
			
			<tr>
				<td>
					<table style="border-collapse: collapse; border-spacing: 0; margin: 0 auto;" role="presentation">
						<tr>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_top_left.png" alt="" height="7px" width="7px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_top_middle.png" alt="" height="7px" width="628px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_top_right.png" alt="" height="7px" width="7px" /></td>
						</tr>
						<tr>
							<td style="margin: 0; padding: 0; background-image: url('${fullJspStoreImgDir}${env_vfileColor}email_template/border_left.png'); background-repeat: repeat-y; width: 7px;"></td>
							<td style="margin: 0; padding: 0;">
								<table style="border-collapse: collapse; border-spacing: 0;" role="presentation">
									<tr style="">
										<td style="margin: 0; padding: 0; border-bottom: 1px solid #cccccc; width: 628px; height: 89px;">
										<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
										<c:param name="storeId" value="${storeId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="isEmail" value="true" />
										<c:param name="useFullURL" value="true" />
										<c:param name="emsName" value="EmailBanner_Content" /> 
										</c:import>
										</td>

									</tr>
									<tr>
										<td>
											<table style="border-collapse: collapse; border-spacing: 0; margin: 0 auto; width: 558px; color: #404040; font-size: 12px;" role="presentation">
												<tr>
													<td>
														
														<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
														<c:param name="emsName" value="EmailWishlist_Content" /> 
														<c:param name="storeId" value="${storeId}" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="isEmail" value="true" />
														<c:param name="substitutionName1" value="[senderName]" />
														<c:param name="substitutionValue1" value="${WCParam.senderName}" />
														<c:param name="substitutionName2" value="[senderEmail]" />
														<c:param name="substitutionValue2" value="${senderEmail}" />
														<c:param name="substitutionName3" value="[link]" />
														<c:param name="substitutionValue3" value="${wishListlink}" />
														<c:param name="substitutionName4" value="[storeName]" />
														<c:param name="substitutionValue4" value="${storeName}" />
														</c:import>
														
														<c:if test="${!empty WCParam.message && WCParam.message != 'SOAWishListEmail'}">
														<p style="margin: 0; line-height: 14px; color: #404040; font-size: 12px;"><fmt:message bundle="${storeText}" key="EMAIL_SENDER_MESSAGE">
														<fmt:param value="${WCParam.senderName}"/>
														</fmt:message></p>
														<p style="margin: 0; line-height: 14px; color: #404040; font-size: 12px;"><c:out value="${WCParam.message}" /></p>
														</c:if>
													</td>
												</tr>

											</table>
										</td>
									</tr>
									<tr>
										<td style="height: 50px;"></td>
									</tr>
									<tr>
										<td style="margin: 0; padding: 0; width: 628px; height: 35px;">
										<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
										<c:param name="storeId" value="${storeId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="isEmail" value="true" />
										<c:param name="useFullURL" value="true" />
										<c:param name="emsName" value="EmailBottom_Content" />
										</c:import>
										</td>
									</tr>

								</table>
							</td>
							<td style="margin: 0; padding: 0; background-image: url('${fullJspStoreImgDir}${env_vfileColor}email_template/border_right.png'); background-repeat: repeat-y; width: 7px;"></td>
						</tr>
						<tr>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_bottom_left.png" alt="BottomLeft" height="7px" width="7px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_bottom_middle.png" alt="BottomMiddle" height="7px" width="628px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${fullJspStoreImgDir}${env_vfileColor}email_template/border_bottom_right.png" alt="BottomRight" height="7px" width="7px" /></td>
						</tr>

					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table style="border-collapse: collapse; border-spacing: 0; text-align: center; font-size: 9px; color: gray; padding: 25px 0 0; margin: 0 auto; width: 628px;" role="presentation">
						<tr>
							<td>
								
<!-- Include email footer -->
		<%@ include file="../Common/Footer.jspf"%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>  
		</span>
	</body>
</html>