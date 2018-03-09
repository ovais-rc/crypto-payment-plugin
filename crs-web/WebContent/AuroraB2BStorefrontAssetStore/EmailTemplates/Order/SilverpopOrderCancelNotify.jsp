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
  * When order is being cancel by the user, this email will be sent.
  * This email JSP page informs the customer that the order is cancel.
  * This JSP page is associated with OrderCancelView view in the struts-config file.    
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/JSTLEnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}" var="eHostPath" />
<c:set value="${eHostPath}${jspStoreImgDir}" var="jspStoreImgDir" />
<c:set var="sendEmail" value="true"/>


<wcf:rest var="order" url="store/{storeId}/order/{orderId}" scope="request">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
</wcf:rest>

<%-- Find out if order is using single or multiple shipment --%>
<c:set var="shipmentTypeId" value="1" scope="request"/>
<c:choose>
	<c:when test="${fn:length(order.orderItem) > maxOrderItemsToInspect}">
		<c:set var="shipmentTypeId" value="2" scope="request"/>
	</c:when>
	<c:otherwise>
		<c:remove var="blockMap"/>
		<jsp:useBean id="blockMap" class="java.util.HashMap" scope="request"/>
		<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
			<c:set var="itemId" value="${orderItem.orderItemId}"/>
			<c:set var="addressId" value="${orderItem.addressId}"/>
			<c:set var="shipModeId" value="${orderItem.shipModeId}"/>
			<c:set var="keyVar" value="${addressId}_${shipModeId}"/>
			<c:set var="itemIds" value="${blockMap[keyVar]}"/>
			<c:choose>
				<c:when test="${empty itemIds}">
					<c:set target="${blockMap}" property="${keyVar}" value="${itemId}"/>
				</c:when>
				<c:otherwise>
					<c:set target="${blockMap}" property="${keyVar}" value="${itemIds},${itemId}"/>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:choose>
			<c:when test="${fn:length(blockMap) == 1}">
				<c:set var="shipmentTypeId" value="1" scope="request"/>
			</c:when>
			<c:otherwise>
				<c:set var="shipmentTypeId" value="2" scope="request"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

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
<%-- if using 'Click to View', then put SAVE_COLUMNS elements here, for example
<SAVE_COLUMNS>
<COLUMN_NAME>BODY</COLUMN_NAME>
<COLUMN_NAME>SUBJECT</COLUMN_NAME>
<COLUMN_NAME>STORE_ID</COLUMN_NAME>
<COLUMN_NAME>CATALOG_ID</COLUMN_NAME>
<COLUMN_NAME>LANG_ID</COLUMN_NAME>
<COLUMN_NAME>STORE_NAME</COLUMN_NAME>
<COLUMN_NAME>ORDER_ID</COLUMN_NAME>
</SAVE_COLUMNS>
--%>
<c:if test="${!empty personalizationMap}">
<RECIPIENT>
<%@ include file="../Common/SilverpopPersonalizationXml.jspf"%>
<PERSONALIZATION>
<TAG_NAME>BODY</TAG_NAME>
<VALUE><![CDATA[
</c:if>

<!-- BEGIN OrderCancelNotify.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>
			<fmt:message bundle="${storeText}" key="EMAIL_PAGE_TITLE">
				<fmt:param value="${storeName}"/>
			</fmt:message>
		</title>
	</head>


	<body style="font-family:Arial,Verdana,Helvetica,sans-serif; color:#4D4D4D; background:none repeat scroll 0 0 #EEEEEE; margin:0; padding:0; border:0 none; line-height:1.4em; vertical-align:baseline;">
		<span role="main">
		<table role="presentation" style="width:100%; height:100%; background-color:#ffffff; padding:25px 0 50px;">

			<tr>
				<td style="margin:0; padding:0;">
					<table role="presentation" style="border-collapse:collapse; border-spacing:0; margin:0 auto;">
						<tr>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${jspStoreImgDir}${env_vfileColor}email_template/border_top_left.png" alt="" height="7px" width="7px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${jspStoreImgDir}${env_vfileColor}email_template/border_top_middle.png" alt="" height="7px" width="628px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:bottom" src="${jspStoreImgDir}${env_vfileColor}email_template/border_top_right.png" alt="" height="7px" width="7px" /></td>
						</tr>
						<tr>
							<td style="margin: 0; padding: 0; background-image: url('${jspStoreImgDir}${env_vfileColor}email_template/border_left.png'); background-repeat: repeat-y; width: 7px;"></td>
							<td style="margin:0; padding:0;">
								<table role="presentation" style="border-collapse:collapse; border-spacing:0;">
									<tr>
										<td style="margin:0; padding:0; border-bottom: 1px solid #cccccc; width:628px; height:89px;">
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
										<td style="margin:0; padding:0;">
											<table role="presentation" style="border-collapse:collapse; border-spacing:0; margin:0 auto; width:558px; color:#404040; font-size:12px; margin-top:30px;">
												<tr>
													<td style="margin:0; padding:0;">
														<table role="presentation" style="border-collapse:collapse; border-spacing:0;">
															<tr>
																<td style="margin:0; padding:0;">
																	<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
																	<c:param name="storeId" value="${storeId}" />
																	<c:param name="catalogId" value="${catalogId}" />
																	<c:param name="cacheWithParent" value="false" />
																	<c:param name="isEmail" value="true" />
																	<c:param name="emsName" value="EmailOrderCancel_Content" />
																	<c:param name="substitutionName1" value="[storeName]" />
																	<c:param name="substitutionValue1" value="${storeName}" />
																	<c:param name="substitutionName2" value="[orderNumber]" />
																	<c:param name="substitutionValue2" value="${WCParam.orderId}" />
																	</c:import>
																	<h2 style="margin:0 0 6px; color:#808080; font-size:16px; font-weight:normal;">
																	<fmt:message bundle="${storeText}" key="EMAIL_ORDER_DETAILS"/></h2>
																</td>
															</tr>
														</table>
														<table role="presentation" style="border-collapse:collapse; border-spacing:0; width:100%;">
															<tr>
																<td style="margin:0; padding:0;">
																	<table role="presentation" style="border-collapse:collapse; border-spacing:0; margin-bottom:11px;">
																		<tr>
																			<td style="margin:0; padding:0;"><h3 style="display:inline; font-size:12px; padding-right:10px;"><strong><fmt:message bundle="${storeText}" key="EMAIL_ORDER_NUMBER"/>&#58;&nbsp;</strong></h3>${WCParam.orderId}</td>
																		</tr>
																		<tr>
																			<td style="margin:0; padding:0;"><h3 style="display:inline; font-size:12px; padding-right:10px;"><strong><fmt:message bundle="${storeText}" key="EMAIL_ORDER_DATE"/>&#58;&nbsp;</strong></h3>
																			<c:catch>
																				<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
																			</c:catch>
																			<c:if test="${empty expectedDate}">
																				<c:catch>
																					<fmt:parseDate parseLocale="${dateLocale}" var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
																				</c:catch>
																			</c:if>
																			<fmt:formatDate value="${expectedDate}" dateStyle="long"/>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
														<!-- Include Shipping Information -->
														<%@ include file="OrderShippingInformation.jspf"%>

														<!-- Include Items Information -->
														<c:choose>
															<c:when test="${shipmentTypeId == 1}">
																<%@ include file="OrderItemsInformation_Single.jspf"%>
															</c:when>
															<c:otherwise>
																<%@ include file="OrderItemsInformation_Multiple.jspf"%>
															</c:otherwise>
														</c:choose>

													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td style="margin:0; padding:0; height:50px;"><br/></br></td>
									</tr>
									<tr>
										<td style="margin:0; padding:0; width:628px; height:35px;  ">
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
							<td style="margin: 0; padding: 0; background-image: url('${jspStoreImgDir}${env_vfileColor}email_template/border_right.png'); background-repeat: repeat-y; width: 7px;"></td>
						</tr>
						<tr>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${jspStoreImgDir}${env_vfileColor}email_template/border_bottom_left.png" alt="BottomLeft" height="7px" width="7px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${jspStoreImgDir}${env_vfileColor}email_template/border_bottom_middle.png" alt="BottomMiddle" height="7px" width="628px" /></td>
							<td style="margin:0;padding:0;"><img style="vertical-align:top" src="${jspStoreImgDir}${env_vfileColor}email_template/border_bottom_right.png" alt="BottomRight" height="7px" width="7px" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td style="margin:0; padding:0;">
					<table role="presentation" style="border-collapse:collapse; border-spacing:0; text-align:center; font-size:9px; color:gray; padding:25px 0 0; margin:0 auto; width:628px;">
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

<c:if test="${!empty personalizationMap}">
]]></VALUE></PERSONALIZATION>
</RECIPIENT>
</c:if>