<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * params: productId, storeId, catalogId, usage, excludeUsageStr 
  ***
--%>

<!-- BEGIN AttachmentList.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<c:set var="uniqueID" value="${WCParam.productId}"/>
<c:if test="${empty uniqueID}">
	<c:set var="uniqueID" value="${param.productId}"/>
</c:if>
<c:choose>
	<%-- Display SKU context-sensitive data when product ID is a SKU --%>
	<c:when test="${displaySKUContextData eq 'true'}">
	</c:when>
	<c:otherwise>
		<c:if test="${!empty parentCatEntryId}" >
			<c:set var="uniqueID" value="${parentCatEntryId}" />		
		</c:if>
	</c:otherwise>
</c:choose>
<c:if test="${!empty uniqueID}">
	<c:set var="excludeUsageStr" value="${WCParam.excludeUsageStr}"/>
	<c:if test="${empty excludeUsageStr}">
		<c:set var="excludeUsageStr" value="${param.excludeUsageStr}"/>
	</c:if>
	<c:set var="usage" value="${WCParam.usage}"/>
	<c:if test="${empty usage}">
		<c:set var="usage" value="${param.usage}"/>
	</c:if>
	<c:set var="beginIndex" value="0"/>
	<c:if test="${!empty param.beginIndex}">
		<c:set var="beginIndex" value="${param.beginIndex}"/>
	</c:if>
	
	<c:catch var="searchServerException">
		<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${uniqueID}" >	
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="currency" value="${env_currencyCode}"/>
			<wcf:param name="responseFormat" value="json"/>		
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="attachmentFilter" value="exclusion:${excludeUsageStr}"/>
			<c:forEach var="contractId" items="${env_activeContractIds}">
				<wcf:param name="contractId" value="${contractId}"/>
			</c:forEach>
		</wcf:rest>
		<c:set var="catEntry" value="${catalogNavigationView.catalogEntryView[0]}" />
	</c:catch>
	
	<c:set var="totalCount" value="${WCParam.displayAttachmentCount}"/>
	<c:if test="${empty totalCount}">
			<c:set var="totalCount" value="${param.displayAttachmentCount}"/>
	</c:if>
	<c:set var="endIndex" value = "${pageSize + beginIndex}"/>
	<c:if test="${endIndex > totalCount}">
		<c:set var="endIndex" value = "${totalCount}"/>
	</c:if>

	<fmt:parseNumber var="total" value="${totalCount}" parseLocale="en_US"/> <%-- Get a float value from totalCount which is a string --%>
	<c:set  var="totalPages"  value = "${total / pageSize * 1.0}"/>
	<%-- Get a float value from totalPages which is a string --%>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="false" parseLocale="en_US"/> 

	<%-- do a ceil if totalPages contains fraction digits --%>
	<c:set var="totalPages" value = "${totalPages + (1 - (totalPages % 1)) % 1}"/>

	<c:set var="currentPage" value = "${( beginIndex + 1) / pageSize}" />
	<%-- Get a float value from currentPage which is a string --%>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

	<%-- do a ceil if currentPage contains fraction digits --%>
	<c:set var="currentPage" value = "${currentPage + (1 - (currentPage % 1)) % 1}"/>

	<%-- Get a float value from currentPage which is a string --%>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

	<%-- Get number of items to be displayed in this page --%>
	<c:if test="${totalCount>0}">
	<fmt:parseNumber var="numOfItemsInPage" value="${endIndex - beginIndex}" integerOnly="false" parseLocale="en_US"/>
	<div class="header_bar">
		<div class="title"><wcst:message key="PT_PRODUCT_ATTACHMENT" bundle="${widgetText}"/> 
			<span class="num_products">&#40;&nbsp;
				<c:set var="beginCounter" value="${beginIndex + 1}"/>
				<c:if test="${totalCount == 0}">
					<c:set var="beginCounter" value = "0"/>
				</c:if>
				<wcst:message key="PAGINATION_{0}_TO_{1}_OF_{2}" bundle="${widgetText}">
					<wcst:param value="${beginCounter}"/>
					<wcst:param value="${endIndex}"/>
					<wcst:param value="${totalCount}"/>
				</wcst:message>
				&nbsp;&#41;
			</span>
		</div>

		<%-- Set variables used by pagination controls --%>
		<c:set var="otherViews" value="false"/> <%-- display list and grid view icons --%>
		<c:set var="eventName" value="AttachmentPagination_Context"/>
		<c:if test="${totalCount>1}">
			<div class="paging_controls">
				<c:set var="linkPrefix" value="categoryResults"/>
				<%@include file="../Common/PaginationControls.jspf" %>
			</div>
		</c:if>
	</div>
	</c:if>
	<jsp:useBean id="attachmentGrp" class="java.util.TreeMap" type="java.util.TreeMap"/>
	<c:set var="displayAttachmentCount" value="0"/>
	<c:forEach items="${catEntry.attachments}" var="attachment">
		<c:set var="displayAttachment" value="true" />
		<%-- if usage is specified, only display attachment of the specified usage. --%>
		<c:choose>
			<%-- Do not display attachments with empty usage type --%>
			<c:when test="${empty attachment.usage}">
				<c:set var="displayAttachment" value="false" />
			</c:when>
			<c:when test="${!empty usage}">
				<c:if test="${param.usage ne attachment.usage}">
					<c:set var="displayAttachment" value="false" />
				</c:if>
			</c:when>
			<c:when test="${!empty excludeUsageStr}">
				<%-- checks the usage type of this attachment and see if should exclude this attachment from display --%>
				<c:forTokens items="${excludeUsageStr}" delims="," var="usageType">
					<c:if test="${fn:startsWith(attachment.usage, usageType)}">
						<c:set var="displayAttachment" value="false" />
					</c:if>
				</c:forTokens>
			</c:when>
		</c:choose>
			
		<c:if test="${displayAttachment}">
			<c:set var="mimeType" value="${attachment.mimeType}" />
			<c:set var="mimePart" value="" />
			<c:set var="displayAttachmentCount" value="${displayAttachmentCount + 1}"/>
			<c:set var="numOfAttachmentsPerPage" value="${endIndex - beginIndex}"/>
			
			<c:if test="${displayAttachmentCount > beginIndex && displayAttachmentCount <= endIndex}">			
			<c:forTokens items="${mimeType}" delims="/" var="mimePartFromType" end="0">
				<c:set var="mimePart" value="${mimePartFromType}" />
			</c:forTokens>
			<c:choose>
				<c:when test="${(fn:startsWith(attachment.attachmentAssetPath, 'http://') || fn:startsWith(attachment.attachmentAssetPath, 'https://'))}">
					<c:if test="${env_WCMUsed}">
						<wcst:resolveContentURL var="resolvedPath" url="${attachment.attachmentAssetPath}" mimeTypeVar="resolvedMimeType" mimeSubtypeVar="resolvedMimeSubtype"/>
						<c:set var="assetPath" value="${resolvedPath}"/>
						<c:if test="${!empty resolvedMimeType}">
							<c:set var="mimeType" value="${resolvedMimeType}"/>
							<c:set var="mimePart" value="${resolvedMimeType}"/>
							<c:if test="${!empty resolvedMimeSubtype}">
								<c:set var="mimeType" value="${resolvedMimeType}/${resolvedMimeSubtype}"/>
							</c:if>
						</c:if>
					</c:if>
					<c:if test="${!env_WCMUsed}">
						<c:set var="assetPath" value="${attachment.attachmentAssetPath}"/>			
					</c:if>
				</c:when>
				<c:when test="${mimePart eq 'uri' || empty mimePart}">
					<c:set var="assetPath" value="${attachment.attachmentAssetPath}"/>
				</c:when>
				<c:when test="${fn:startsWith(attachment.attachmentAssetPath, '/store/0/storeAsset')}">
					<c:set var="assetPath" value="${storeContextPath}${attachment.attachmentAssetPath}"/>
				</c:when>
				<c:when test="${fn:startsWith(attachment.attachmentAssetPath, '[extContentURI]') && env_inPreview}">
					<c:set var="assetPathTemp" value="${fn:substringAfter(attachment.attachmentAssetPath, '/StoreImageServlet')}"/>
					<c:set var="assetPath" value="${staticAssetContextRoot}/StoreImageServlet${assetPathTemp}"/>
				</c:when>
				<c:when test="${fn:startsWith(attachment.attachmentAssetPath, '[extContentURI]')}">
					<c:set var="assetPath" value="${fn:replace(attachment.attachmentAssetPath, '[extContentURI]', '')}"/>
				</c:when>
				<c:otherwise>
					<c:set var="assetPath" value="${staticAssetContextRoot}/${attachment.attachmentAssetPath}"/>
				</c:otherwise>
			</c:choose>

			<c:set var="url_parts" value="${fn:split(assetPath, '/')}" />
			<c:set var="fileType_parts" value="${fn:split(url_parts[fn:length(url_parts)-1], '.')}" />
			<c:set var="fileType" value="${fn:toLowerCase(fileType_parts[fn:length(fileType_parts)-1])}" />
			
			<c:set var="attachmentType" value="default"/>
			<c:if test="${not empty fileType}">	
				<c:if test="${fileType eq 'txt'|| fileType eq 'text'|| fileType eq 'csv'|| fileType eq 'vsd'|| fileType eq 'msg'}">
					<c:set var="attachmentType" value="text"/>
				</c:if>
				<c:if test="${fileType eq 'html' || fileType eq 'htm' || mimeType eq 'text/html'}">
					<c:set var="attachmentType" value="html"/>
				</c:if>
				<c:if test="${fileType eq 'gif'|| fileType eq 'jpeg'|| fileType eq 'jpg'|| fileType eq 'jpe'|| fileType eq 'png'|| fileType eq 'ps'}">
					<c:set var="attachmentType" value="image"/>
				</c:if>
				<c:if test="${fileType eq 'pdf' || mimeType eq 'application/pdf'}">
					<c:set var="attachmentType" value="pdf"/>
				</c:if>
				<c:if test="${fileType eq 'postscript'|| fileType eq 'msword'|| fileType eq 'doc'|| fileType eq 'docx'|| fileType eq 'rtf'|| fileType eq 'odt'}">
					<c:set var="attachmentType" value="doc"/>
				</c:if>
				<c:if test="${fileType eq 'vnd.ms-powerpoint'|| fileType eq 'ppt'|| fileType eq 'pptx'|| fileType eq 'odp'}">
					<c:set var="attachmentType" value="presentation"/>
				</c:if>
				<c:if test="${fileType eq 'vnd.ms-excel'|| fileType eq 'xls'|| fileType eq 'xlsx'|| fileType eq 'ods'}">
					<c:set var="attachmentType" value="spreadsheet"/>
				</c:if>
				<c:if test="${fileType eq 'wav'|| fileType eq 'ra'|| fileType eq 'x-pn-realaudio-plugin'}">
					<c:set var="attachmentType" value="audio"/>
				</c:if>
				<c:if test="${fileType eq 'mpg'|| fileType eq 'mp4'|| fileType eq 'mov'|| fileType eq 'avi'|| fileType eq 'qt'|| fileType eq 'rpm'|| fileType eq 'swf'|| fileType eq 'movie' || mimeType eq 'video/mpeg' ||mimeType eq 'video/quicktime'|| mimeType eq 'video/x-msvideo'|| mimeType eq 'application/x-shockwave-flash'}">
					<c:set var="attachmentType" value="video"/>
				</c:if>
				<c:if test="${fileType eq 'x-gzip'|| fileType eq 'zip'|| fileType eq 'rar'|| fileType eq 'tar'|| fileType eq 'gtar'|| fileType eq 'x-tar'|| fileType eq 'jar'|| fileType eq 'class'}">
					<c:set var="attachmentType" value="archive"/>
				</c:if>
			</c:if>
			<c:if test="${empty fileType}">
				<c:set var="attachmentType" value="webpage"/>
			</c:if>
			<c:set var="attchImage" value="${jspStoreImgDir}${env_vfileColor}${attachmentType}_icon.png" />
			<c:set var="attchName" value="${attachment.name}" />
			<c:set var="attchShortDesc" value="${attachment.shortdesc}" />
			<c:set var="attchLongDesc" value="${attachment.longdesc}" />
			<c:forEach var="metaData" items="${attachment.metaData}">
				<c:if test="${metaData.typedKey == 'size'}">
					<c:set var="size" value="${metaData.typedValue}" />
					<c:if test="${size<1048576}">
						<fmt:formatNumber var="formated_size" value="${size/1024}" pattern="0.00KB"/>
					</c:if>
					<c:if test="${size>=1048576&&size<1073741824}">
						<fmt:formatNumber var="formated_size" value="${size/1048576}" pattern="0.00MB"/>
					</c:if>
					<c:if test="${size>=1073741824}">
						<fmt:formatNumber var="formated_size" value="${size/1073741824}" pattern="0.00GB"/>
					</c:if>
				</c:if>
			</c:forEach>
			<c:choose>
				<c:when test="${empty attachmentGrp[attachment.usage]}">
					<wcf:useBean var="attachmentsList" classname="java.util.ArrayList"/>
					<c:set target="${attachmentGrp}" property="${attachment.usage}" value="${attachmentsList}"/>
				</c:when>
				<c:otherwise>
					<c:set var="attachmentsList" value="${attachmentGrp[attachment.usage]}"/>
				</c:otherwise>
			</c:choose>
			<jsp:useBean id="attachmentDetails" class="java.util.HashMap" type="java.util.Map"/>
			<c:set target="${attachmentDetails}" property="name" value="${attchName}"/>
			<c:set target="${attachmentDetails}" property="assetPath" value="${assetPath}"/>
			<c:set target="${attachmentDetails}" property="shortDesc" value="${attchShortDesc}"/>
			<c:set target="${attachmentDetails}" property="longDesc" value="${attchLongDesc}"/>
			<c:set target="${attachmentDetails}" property="image" value="${attchImage}"/>
			<c:set target="${attachmentDetails}" property="mimeType" value="${mimeType}"/>
			<c:set target="${attachmentDetails}" property="mimePart" value="${mimePart}"/>
			<c:set target="${attachmentDetails}" property="size" value="${formated_size}"/>
			
			<wcf:set target="${attachmentsList}" value="${attachmentDetails}"/>
			<c:remove var="attachmentDetails"/>
			<c:remove var="attachmentsList"/>
			</c:if>
		</c:if>
	</c:forEach>
	<c:if test="${not empty attachmentGrp}">
		<c:forEach var="attachmentsList" items="${attachmentGrp}">
			<wcst:message key='PT_PRODUCT_ATTACHMENT_USAGE_USERMANUAL' bundle='${widgetText}' var="userManualText"/>
			<c:set var="attachmentTypeName">${(attachmentsList.key=="USERMANUAL")?userManualText:fn:toLowerCase(attachmentsList.key)}</c:set>
			<div class="header">
				<c:if test="${attachmentsList.key=='USERMANUAL'}">
					<c:out value="${attachmentTypeName}"/>
				</c:if>
			</div>
			<div class="attachment">
				<c:forEach var="attachmentDetails" items="${attachmentsList.value}" varStatus="status">
					<div class="attachment">
						<c:set var="mimePart" value="${attachmentDetails['mimePart']}" />
						<c:set var="attachmentNameToDisplay">${(empty attachmentDetails['name'])?attachmentDetails['shortDesc']:attachmentDetails['name']}</c:set>
						<c:set var="attachmentNameToDisplay">${(empty attachmentNameToDisplay)?attachmentTypeName:attachmentNameToDisplay}</c:set>
						<c:choose>
							<c:when test="${(mimePart eq 'image') || (mimePart eq 'images')|| (mimePart eq 'application') || (mimePart eq 'applications') || ( mimePart eq 'text') 							
											||(mimePart eq 'textyv' ) || (mimePart eq 'video') || (mimePart eq 'audio')	
											|| (mimePart eq 'model')}"> 
										<div class="icon">
											<a href="${attachmentDetails['assetPath']}" target="_new" aria-describedby="acce_attachment_${fn:toLowerCase(attachmentsList.key)}_${status.count}" aria-label="<c:out value="${attachmentNameToDisplay}"/>" id="WC_TechnicalSpecification_Image_2_${status.count}">
												<img src="${attachmentDetails['image']}" alt="${attachmentNameToDisplay}" title="${attachmentNameToDisplay}"/>
												<c:set var="acceAttachmentType" value="${fn:replace(attachmentDetails['mimeType'],'application/','')}" />
												<span id="acce_attachment_${fn:toLowerCase(attachmentsList.key)}_${status.count}" class="spanacce"><c:out value="${acceAttachmentType}" /></span>
											</a>
										</div>
										<div class="description">
											<a href="${attachmentDetails['assetPath']}" tabIndex="-1" aria-hidden="true" target="_blank" id="WC_TechnicalSpecification_Links_1_${status.count}">
												<c:out value="${attachmentNameToDisplay}"/>
											</a>
											<div class="clear_float"></div>
											<c:if test="${not empty attachmentDetails['size']}">
												<span class="size">(${attachmentDetails['size']})</span>
											</c:if>
										</div>
							</c:when>			
							<c:when test="${(mimePart eq 'uri')}">
								<a href="${attachmentDetails['assetPath']}" target="_blank" id="WC_TechnicalSpecification_Links_3_${status.count}"> 
									<c:out value="${attachmentNameToDisplay}" />
								</a>
							</c:when>
							<c:otherwise>
								<c:set var="http" value=""/>
								<c:if test="${fn:indexOf(attachmentDetails['assetPath'],'://') == -1 }">
									<c:set var="http" value="http://"/>
								</c:if>
								<div class="icon">
									<a href="${http}${attachmentDetails['assetPath']}" target="_new" id="WC_TechnicalSpecification_Image_2_${status.count}">
										<img src="${attachmentDetails['image']}" alt="${attachmentNameToDisplay}" title="${attachmentNameToDisplay}"/>
									</a>
								</div>
								<div class="description">
									<a href="${http}${attachmentDetails['assetPath']}" target="_new" id="WC_TechnicalSpecification_Links_2_${status.count}"> 
										<c:out value="${(empty attachmentNameToDisplay)?attachmentDetails['assetPath']:attachmentNameToDisplay}"/>
									</a>
									<div class="clear_float"></div>
								</div>
							</c:otherwise>					
						</c:choose>
					</div>
				
				</c:forEach>
			</div>
		</c:forEach>
	</c:if>
</c:if>
<!-- END AttachmentList.jsp -->
