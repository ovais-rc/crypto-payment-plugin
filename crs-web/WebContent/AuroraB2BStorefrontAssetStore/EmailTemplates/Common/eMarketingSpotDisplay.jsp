<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  ***
  * This eMarketingSpotDisplay.jsp is built as a sample snippet to display an e-Marketing Spot in a
  * store page.
  *
  * This e-Marketing Spot code supports all types of campaign Web activity:
  *	- Products, items and category suggestions
  *	- Ad copy - Awareness Advertisements
  *		  - Discount Advertisements
  *		  - Coupons Advertisements
  *	- Merchandising Association - Cross-sell and Up-Sell
  *
  * If you intend to display only one type of the campaign Web activity in your e-Marketing Spot,
  * sections of the code that will not be used can be removed.
  *
  * Prerequisites:
  * 	These two parameters are required by this code:
  *		- emsName
  *		This file can be reused in different pages of the store by including it and giving
  * 	a unique value for emsName, which should match exactly with an eMarketingSpot name
  * 	that is defined in the WebSphere Commerce Accelerator.
  *		- catalogId
  *		catalogId needs to be passed in as it is required to build the proper URL.
  *
  * How to use this snippet?
  *	This is an example of how this file could be included into a page:
  *		<c:import url="${env_jspStoreDir}EmailTemplates/Common/eMarketingSpotDisplay.jsp">
  *			<c:param name="emsName" value="ShoppingCartPage" />
  *			<c:param name="catalogId" value="${WCParam.catalogId}" />
  *		</c:import>
  *
  * In case special characters are used in the e-Marketing Spot name, and they need to be encoded in order to pass
  * them successfully to this page through request parameter, the following technique may be used before setting
  * the emsName parameter in the import statement:
  * 	request.setAttribute("emsName", java.net.URLEncoder.encode("ShoppingCartPage"));
  * And retrieve it from the request when setting the parameter:
  * 		<c:param name="emsName" value="${requestScope.emsName}"/>
  ***
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<%
	String emsName = request.getParameter("emsName");
	if (emsName != null) {
		request.setAttribute("emsName", emsName);
	}
	
	Object DM_marketingSpotBehavior = request.getAttribute("DM_emsBehavior-" + emsName);
	if (DM_marketingSpotBehavior != null) {
		request.setAttribute("DM_marketingSpotBehavior", DM_marketingSpotBehavior.toString());
	}
%>

<%--
  ***
  * Hostname of the URL that is used to point to the shared image directory. Use this variable to
  * reference images.
  ***
--%>
<c:set var="serverName"  value="<%= request.getServerName() %>"/>
<c:set value="https://${serverName}:port" var="hostPath" />

<%--
  ***
  * Sets the ClickInfo command URL if the optional clickInfoURL parameter is provided. Use the
  * default value of the URL otherwise.
  ***
--%>
<c:set value="ClickInfo" var="clickInfoCommand" />

<%--
  ***
  * Specifies whether AttachmentDisplay.jspf uses fully qualified URL for
  * image tags or relative path..By default it uses relative path..Fully qualified
  * URL is required for email activity functionality..
  ***
--%>
<c:set value="false" var="paramUseFullURL" />
<c:if test="${!empty param.useFullURL}">
	<c:set value="${param.useFullURL}" var="paramUseFullURL" />
</c:if>

<%--
  ***
  * Sets the current catalog ID from the parameter object if provided. Use the default value from
  * the command context otherwise.
  ***
--%>
<c:set value="${WCParam.catalogId}" var="catalogId" />
<c:if test="${!empty param.catalogId}">
	<c:set value="${param.catalogId}" var="catalogId" />
</c:if>

<%--
  ***
  * Create the e-Marketing Spot REST call
  ***
--%>
		<wcf:rest var="eSpotDatasRoot" url="/store/{storeId}/espot/{name}" format="json" >
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
			<wcf:var name="name" value="${emsName}" encode="true"/>
            <%-- the name of the e-Marketing Spot --%>
            <wcf:param name="DM_EmsName" value="${emsName}" />

			<wcf:param name="DM_marketingSpotBehavior" value="${requestScope.DM_marketingSpotBehavior}"/>

			<%-- do not retrieve the catalog group SDO but obtain the catalog group Id only --%>
			<wcf:param name="DM_ReturnCatalogGroupId" value="true" />
			
			<%-- do not retrieve the catalog entry SDO but obtain the catalog entry Id only --%>
		    <wcf:param name="DM_ReturnCatalogEntryId" value="true" />

            <wcf:param name="DM_contextPath" value="${env_contextAndServletPath}" />
            <wcf:param name="DM_imagePath" value="${requestScope.jspStoreImgDir}" />

            <c:if test="${!empty param.numberContentToDisplay}">
                <wcf:param name="DM_DisplayContent"    value="${param.numberContentToDisplay}" />
            </c:if>
                                            
            <%-- url command name --%>
            <wcf:param name="DM_ReqCmd" value="${requestURI}" />
            <%-- url name value pair parameters --%>    
			<c:catch>
				<c:forEach var="aParam" items="${WCParamValues}">
					<c:forEach var="aValue" items="${aParam.value}">
						<c:if test="${aParam.key !='logonPassword' && aParam.key !='logonPasswordVerify' && aParam.key !='URL' && aParam.key !='logonPasswordOld' && aParam.key !='logonPasswordOldVerify' && aParam.key !='account' && aParam.key !='cc_cvc' && aParam.key !='check_routing_number' && aParam.key !='plainString' && aParam.key !='xcred_logonPassword'}">
							<wcf:param name="${aParam.key}" value="${aValue}"/>
						</c:if>
					</c:forEach>
				</c:forEach>
            </c:catch>
                        
			<c:if test="${!empty param.substitutionName1 && !empty param.substitutionValue1}">
				<wcf:param name="DM_SubstitutionName1" value="${param.substitutionName1}" />
				<wcf:param name="DM_SubstitutionValue1" value="${param.substitutionValue1}" />
			</c:if>
			<c:if test="${!empty param.substitutionName2 && !empty param.substitutionValue2}">
				<wcf:param name="DM_SubstitutionName2" value="${param.substitutionName2}" />
				<wcf:param name="DM_SubstitutionValue2" value="${param.substitutionValue2}" />
			</c:if>
			<c:if test="${!empty param.substitutionName3 && !empty param.substitutionValue3}">
				<wcf:param name="DM_SubstitutionName3" value="${param.substitutionName3}" />
				<wcf:param name="DM_SubstitutionValue3" value="${param.substitutionValue3}" />
			</c:if>
			<c:if test="${!empty param.substitutionName4 && !empty param.substitutionValue4}">
				<wcf:param name="DM_SubstitutionName4" value="${param.substitutionName4}" />
				<wcf:param name="DM_SubstitutionValue4" value="${param.substitutionValue4}" />
			</c:if>
			<c:if test="${!empty param.substitutionName5 && !empty param.substitutionValue5}">
				<wcf:param name="DM_SubstitutionName5" value="${param.substitutionName5}" />
				<wcf:param name="DM_SubstitutionValue5" value="${param.substitutionValue5}" />
			</c:if>
            
			<c:if test="${empty param.substitutionName1}">
				<wcf:param name="DM_SubstitutionName1" value="[storeName]" />
				<wcf:param name="DM_SubstitutionValue1" value="${storeName}" />
			</c:if>
			<c:if test="${empty param.substitutionName2}">
				<wcf:param name="DM_SubstitutionName2" value="[fullPathHomeURL]" />
				<wcf:param name="DM_SubstitutionValue2" value="${homePageURL}" />
			</c:if>
			<c:if test="${empty param.substitutionName3}">
				<wcf:param name="DM_SubstitutionName3" value="[langlocale]" />
				<wcf:param name="DM_SubstitutionValue3" value="${locale}" />
			</c:if>
			<c:if test="${empty param.substitutionName4}">
				<wcf:param name="DM_SubstitutionName4" value="[productTotalCount]" />
				<wcf:param name="DM_SubstitutionValue4" value="${searchTabSubText1}" />
			</c:if>
			
			<c:if test="${empty param.substitutionName5}">
				<wcf:param name="DM_SubstitutionName5" value="[contentTotalCount]" />
				<wcf:param name="DM_SubstitutionValue5" value="${searchTabSubText2}" />
			</c:if>

			<wcf:param name="DM_SubstitutionName6" value="[widgetSuffix]" />
			<wcf:param name="DM_SubstitutionValue6" value="${widgetSuffix}" />
							
			<%-- Example of including a value from a specific cookie
			     <wcf:param name="MYCOOKIE" value="${cookie.MYCOOKIE.value}" />
			--%>
			    
			<%-- Example of including all cookies 
			     <c:forEach var="cookieEntry" items="${cookie}">
			         <wcf:param name="${cookieEntry.key}" value="${cookieEntry.value.value}" />                    
			     </c:forEach>
			--%>
 		</wcf:rest>
		<c:if test="${!empty eSpotDatasRoot.MarketingSpotData[0]}" >
			<c:set  var="eSpotDatas" value="${eSpotDatasRoot.MarketingSpotData[0]}"/>
		</c:if>
		<c:set var="emsId" value="${eSpotDatas.marketingSpotIdentifier}"/>

<%--
  ***
  * END: e-Marketing Spot REST call. Resulting object called eSpotDatas.
  ***
--%>


<%--
  ***
  * Display Content
  ***
--%>
<c:set var="currentRowCount" value="0" />

<jsp:useBean id="contentUrlMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentImageMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentDescriptionMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentTextMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentAssetPathMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentFlashMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentTypeMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentFormatMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentClickToEditURLMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentImageAreaInputMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentImageAreaNameMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentImageAreaMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentImageAreaSourceMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="contentTargetAttributeMap" class="java.util.LinkedHashMap" type="java.util.Map"/>

<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}" varStatus="status3">

    <c:if test='${eSpotData.baseMarketingSpotDataType eq "MarketingContent"}'>
         <c:set var="currentRowCount" value="${currentRowCount+1}" />

        <%--
          *
          * Set up the URL to call when the image or text is clicked.
          *
        --%>
		<c:set var="contentClickUrl" value="${param.contentClickUrl}"/>
		<c:if test = "${empty contentClickUrl}">
			<c:url value="${eSpotData.contentUrl}" var="contentClickUrl">
				<c:if test="${!empty param.errorViewName}" >
					<c:param name="errorViewName" value="${param.errorViewName}" />
					<c:if test="${!empty param.orderId}">
						<c:param name="orderId" value="${param.orderId}"/>
					</c:if>
				</c:if>
				<c:if test="${!empty eSpotData.contentUrl && (fn:contains(eSpotData.contentUrl,'OrderItemAdd') || fn:contains(eSpotData.contentUrl,'AddOrderItemWithPromotionCodeOrCoupon'))}" >
					<c:param name="deleteCartCookie" value="true"/>
				</c:if>
			</c:url>
		</c:if>

        <c:url value="${clickInfoCommand}" var="ClickInfoURL">
            <c:param name="evtype" value="CpgnClick" />
            <c:param name="mpe_id" value="${emsId}" />
            <c:param name="intv_id" value="${eSpotData.activityIdentifierID}" />
            <c:param name="storeId" value="${storeId}" />
            <c:param name="catalogId" value="${catalogId}" />
            <c:param name="langId" value="${langId}" />
            
			<c:forEach var="expResult" items="${eSpotData.experimentResult}" begin="0" end="0">
				<c:param name="experimentId" value="${expResult.experimentResultId}" />
				<c:param name="testElementId" value="${expResult.experimentResultTestElementId}" />
				<c:param name="controlElement" value="${expResult.controlElement}" />
			</c:forEach>
			<c:param name="expDataType" value="${eSpotData.baseMarketingSpotDataType}" />
			<c:param name="expDataUniqueID" value="${eSpotData.baseMarketingSpotActivityID}" />
			
			<c:choose>
				<c:when test="${(fn:contains(contentClickUrl, '?'))}">
					<c:param name="URL" value="${contentClickUrl}" />
				</c:when>
				<c:otherwise>
					<c:param name="URL" value="${contentClickUrl}?evtype=&mpe_id=&intv_id=&storeId=&catalogId=&langId=&experimentId=&testElementId=&controlElement=&expDataType=&expDataUniqueID=" />
				</c:otherwise>
			</c:choose>
        </c:url>

        <c:choose>
        
            <c:when test="${eSpotData.contentFormatName == 'File'}">
				<c:set target="${contentFormatMap}" property="${currentRowCount}" value="File" />
                <%--
                  *
                  * For handling language specific assets and descriptions
                  *
                --%>
                <c:set var="foundLanguage" value="false"/>
                
                <%-- Store the index of the asset for the current language in the array --%>
                <c:set var="assetIndex" value="0"/>
                
                <%-- Check if there are any attachment assets --%>
                <c:if test="${fn:length(eSpotData.attachmentAsset) > 0}">
                    <%-- Go through each asset and scan the list of languages specified --%>
                    <%-- Take the first asset found with the current selected language --%>
                    <%-- If no language specific asset is found, use the first asset as the default --%>
                    <c:forEach var="i" begin="0" end="${fn:length(eSpotData.attachmentAsset)-1}">
                        <c:forEach var="language" items="${eSpotData.attachmentAsset[i].attachmentAssetLanguage}">
                            <c:if test="${(language == langId) && (!foundLanguage)}">
                                <c:set var="foundLanguage" value="true"/>
                                <c:set var="assetIndex" value="${i}"/>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </c:if>

                <c:set var="foundLanguage" value="false"/>
                <%-- Store the index of the attachment description for the current language in the array --%>
                <c:set var="descriptionIndex" value="0"/>

                <%-- Check if there are any attachment descriptions --%>
                <c:if test="${fn:length(eSpotData.attachmentDescription) > 0}">
                    <%-- Go through each description and find the description associated with the current language --%>
                    <%-- If no language specific description is found, use the default English description --%>
                    <c:forEach var="i" begin="0" end="${fn:length(eSpotData.attachmentDescription)-1}">
                        <c:forEach var="language" items="${eSpotData.attachmentDescription[i].attachmentLanguage}">
                            <c:if test="${(language == langId) && (!foundLanguage)}">
                                <c:set var="foundLanguage" value="true"/>
                                <c:set var="descriptionIndex" value="${i}"/>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </c:if>
                
                <c:set var="contentMimeType" value="${eSpotData.contentMimeType}"/>
                <c:set var="assetMimeType" value="${eSpotData.attachmentAsset[assetIndex].attachmentAssetMimeType}"/>
                <c:if test="${(empty contentMimeType) && 
                	(fn:endsWith(attachment.attachmentAsset[assetIndex].attachmentAssetPath, '.gif') ||
                	 fn:endsWith(attachment.attachmentAsset[assetIndex].attachmentAssetPath, '.jpg') ||
                	 fn:endsWith(attachment.attachmentAsset[assetIndex].attachmentAssetPath, '.jpeg') ||
                	 fn:endsWith(attachment.attachmentAsset[assetIndex].attachmentAssetPath, '.png')	)}">
                	 <c:set var="contentMimeType" value="image"/>
                </c:if>
                <c:if test="${(empty contentMimeType) && (fn:endsWith(eSpotData.attachmentAsset[assetIndex].attachmentAssetPath, '.swf') )}">
                	<c:set var="contentMimeType" value="application"/>
                	<c:set var="assetMimeType" value="application/x-shockwave-flash"/>
                </c:if>
                
                <c:set var="contentPath" value=""/>
                <c:choose>
                	<c:when test="${(fn:startsWith(eSpotData.attachmentAsset[assetIndex].attachmentAssetPath, 'http://') ||
                		fn:startsWith(eSpotData.attachmentAsset[assetIndex].attachmentAssetPath, 'https://')	)}">
                		<c:set var="contentPath" value="${eSpotData.attachmentAsset[assetIndex].attachmentAssetPath}"/>
                		<wcst:resolveContentURL var="contentPath" url="${contentPath}" mimeTypeVar="resolvedMimeType" mimeSubtypeVar="resolvedMimeSubtype" includeHostName="${prependFullURL}"/>
                		<c:if test="${!empty resolvedMimeType}">
                			<c:set var="contentMimeType" value="${resolvedMimeType}"/>
                			<c:if test="${!empty resolvedMimeSubtype}">
		                		<c:set var="assetMimeType" value="${resolvedMimeType}/${resolvedMimeSubtype}"/>
		                	</c:if>
                		</c:if>
                	</c:when>
					<c:when test="${fn:startsWith(eSpotData.attachmentAsset[assetIndex].attachmentAssetPath, '/store/0/storeAsset')}">
						<c:set var="contentPath" value="${restPrefix}${eSpotData.attachmentAsset[assetIndex].attachmentAssetPath}"/>	
					</c:when>					
                	<c:when test="${empty eSpotData.attachmentAsset[assetIndex].attachmentAssetRootDirectory}">
                		<c:set var="contentPath" value="${hostPath}${storeImgDir}${eSpotData.attachmentAsset[assetIndex].attachmentAssetPath}"/>
                	</c:when>
                	<c:otherwise>
                		<c:set var="contentPath" value="${hostPath}${env_imageContextPath}/${eSpotData.attachmentAsset[assetIndex].attachmentAssetRootDirectory}/${eSpotData.attachmentAsset[assetIndex].attachmentAssetPath}"/>
                	</c:otherwise>
                </c:choose>		
            	
		<c:choose>
	        	<c:when test="${(contentMimeType eq 'image') || (contentMimeType eq 'images')}">
				<c:set target="${contentTypeMap}" property="${currentRowCount}" value="image" />
						   <%--
				                    *
				                    * Display the content image, with optional click information.
				                    *
				                   --%>
								   
								<c:if test="${!empty eSpotData.contentUrl}">
									<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${env_absoluteUrl}${ClickInfoURL}" />
									<c:if test="${fn:contains(ClickInfoURL, '://') || fn:startsWith(ClickInfoURL, '/')}">
										<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${ClickInfoURL}" />
									</c:if>
								</c:if>
									<c:set target="${contentImageMap}" property="${currentRowCount}" value="${contentPath}" />
									<c:set target="${contentDescriptionMap}" property="${currentRowCount}" value="${eSpotData.attachmentDescription[descriptionIndex].attachmentShortDescription}" />
									
									<c:if test="${!empty eSpotData.marketingContentImageMap}" >
									  <c:set target="${contentImageAreaInputMap}" property="${currentRowCount}" value="${eSpotData.contentInputOption}" />
									  <c:set target="${contentImageAreaNameMap}" property="${currentRowCount}" value="${eSpotData.marketingContentImageMap[0].name}" />
									
										<c:choose>
											<c:when test="${!empty eSpotData.marketingContentImageMap[0].area}" >
												<jsp:useBean id="contentImageAreaPerEspotMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
												
												<c:forEach var="imageArea" items="${eSpotData.marketingContentImageMap[0].area}" varStatus="aStatus">
													<c:url value="${clickInfoCommand}" var="ImageMapClickInfoURL">
														<c:param name="evtype" value="CpgnClick" />
														<c:param name="mpe_id" value="${emsId}" />
														<c:param name="intv_id" value="${eSpotData.activityIdentifierID}" />
														<c:param name="storeId" value="${storeId}" />
														<c:param name="catalogId" value="${catalogId}" />
														<c:param name="langId" value="${langId}" />
														
														<c:forEach var="expResult" items="${eSpotData.experimentResult}" begin="0" end="0">
															<c:param name="experimentId" value="${expResult.experimentResultId}" />
															<c:param name="testElementId" value="${expResult.experimentResultTestElementId}" />
															<c:param name="controlElement" value="${expResult.controlElement}" />
														</c:forEach>
														<c:param name="expDataType" value="${eSpotData.baseMarketingSpotDataType}" />
														<c:param name="expDataUniqueID" value="${eSpotData.baseMarketingSpotActivityID}" />

														<c:param name="URL" value="${imageArea.url}" />
													</c:url>
												
													<jsp:useBean id="contentImageAreaMap_current" class="java.util.HashMap" type="java.util.Map"/>
													<c:set target="${contentImageAreaMap_current}" property="shape" value="${imageArea.shape}" />
													<c:set target="${contentImageAreaMap_current}" property="coordinates" value="${imageArea.coordinates}" />
													<c:set target="${contentImageAreaMap_current}" property="url" value="${env_absoluteUrl}${ImageMapClickInfoURL}" />
													<c:if test="${fn:contains(ImageMapClickInfoURL, '://') || fn:startsWith(ImageMapClickInfoURL, '/')}">
														<c:set target="${contentImageAreaMap_current}" property="url" value="${ImageMapClickInfoURL}" />
													</c:if>
													<c:set target="${contentImageAreaMap_current}" property="title" value="${imageArea.title}" />
													<c:set target="${contentImageAreaMap_current}" property="target" value="${imageArea.target}" />
													<c:set target="${contentImageAreaMap_current}" property="altText" value="${imageArea.alternateText}" />
																																				
													<c:set target="${contentImageAreaPerEspotMap}" property="${aStatus.count}" value="${contentImageAreaMap_current}" />
													<c:remove var="contentImageAreaMap_current"/>
												</c:forEach>
												<c:set target="${contentImageAreaMap}" property="${currentRowCount}" value="${contentImageAreaPerEspotMap}" />
											</c:when>
											<c:when test="${!empty eSpotData.marketingContentImageMap[0].source}" >
												<c:set target="${contentImageAreaSourceMap}" property="${currentRowCount}" value="${eSpotData.marketingContentImageMap[0].source}" />
											</c:when>
										</c:choose>
									</c:if>
							
					</c:when>

                    <c:when test="${(contentMimeType eq 'application') ||
                                    (contentMimeType eq 'applications') ||
                                    (contentMimeType eq 'text') ||
                                    (contentMimeType eq 'textyv') ||
                                    (contentMimeType eq 'video') ||
                                    (contentMimeType eq 'audio') ||
                                    (contentMimeType eq 'model')
                                    }">
						<c:set target="${contentTypeMap}" property="${currentRowCount}" value="application" />
                        <%--
                          *
                          * Display the content: flash, audio, or other.
                          *
                        --%>
                        <c:choose>
                            <c:when test="${(assetMimeType eq 'application/x-shockwave-flash')}" >
								<c:set target="${contentFlashMap}" property="${currentRowCount}" value="true" />
								
								<c:set target="${contentDescriptionMap}" property="${currentRowCount}" value="${eSpotData.marketingContentDescription[0].marketingText}" />
								
								<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${contentPath}" />                          
                            </c:when>
							
                            <c:otherwise>
								<c:set target="${contentFlashMap}" property="${currentRowCount}" value="false" />
								
								<c:set target="${contentAssetPathMap}" property="${currentRowCount}" value="${contentPath}" /> 
                <c:set target="${contentImageMap}" property="${currentRowCount}" value="${hostPath}${env_customImageContextPath}/${eSpotData.attachmentAsset[assetIndex].attachmentAssetRootDirectory}/${eSpotData.attachmentImage}"/>
								
								<c:set target="${contentDescriptionMap}" property="${currentRowCount}" value="${eSpotData.attachmentDescription[descriptionIndex].attachmentShortDescription}"/>
								
								
								 <c:if test="${!empty eSpotData.contentUrl}">
									<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${env_absoluteUrl}${ClickInfoURL}" />	
									<c:if test="${fn:contains(ClickInfoURL, '://') || fn:startsWith(ClickInfoURL, '/')}">
										<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${ClickInfoURL}" />	
									</c:if>									
									
									<c:set target="${contentTextMap}" property="${currentRowCount}" value="${eSpotData.marketingContentDescription[0].marketingText}"/>
								</c:if>
                                                              
                            </c:otherwise>
                        </c:choose>


                    </c:when>

                    <c:otherwise>
                        <%--
                          * Content type is File, but no image or known mime type is associated, so display a link to the URL.
                          * Display the content text, with optional click information.
                          *
                        --%>
						<c:choose>														
							<c:when test="${!empty eSpotData.marketingContentImageMap && !empty eSpotData.marketingContentImageMap[0].area}" >																																																																																	
								<c:forEach var="linkContent" items="${eSpotData.marketingContentImageMap[0].area}" varStatus="aStatus">																																		
									<c:if test = "${!empty linkContent.url}">											
										<c:set var="linkClickUrl" value="${linkContent.url}" />
										<c:set target="${contentTargetAttributeMap}" property="${aStatus.count}" value="${linkContent.target}"/>																			
										<c:set target="${contentTextMap}" property="${aStatus.count}" value="${linkContent.title}"/>
										<c:set target="${contentUrlMap}" property="${aStatus.count}" value="${env_absoluteUrl}${linkClickUrl}" />
										<c:if test="${fn:contains(linkClickUrl, '://') || fn:startsWith(linkClickUrl, '/')}">
											<c:set target="${contentUrlMap}" property="${aStatus.count}" value="${linkClickUrl}" />
										</c:if>
									</c:if> 																																
								</c:forEach>																												
							</c:when>
							<c:otherwise>						
								<c:set target="${contentAssetPathMap}" property="${currentRowCount}" value="${contentPath}" />
																				
								<c:if test="${!empty eSpotData.contentUrl}">
									<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${env_absoluteUrl}${ClickInfoURL}" />
									<c:if test="${fn:contains(ClickInfoURL, '://') || fn:startsWith(ClickInfoURL, '/')}">
										<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${ClickInfoURL}" />
									</c:if>
								</c:if>
									
								<c:if test="${!empty eSpotData.marketingContentDescription[0].marketingText}">
									<c:set target="${contentTextMap}" property="${currentRowCount}" value="${eSpotData.marketingContent.marketingContentDescription[0].marketingText}"/>
								</c:if>
							</c:otherwise>
						</c:choose>												
					</c:otherwise>
				</c:choose>
            </c:when>
            <c:when test="${eSpotData.contentFormatName == 'Text'}">
				<c:set target="${contentFormatMap}" property="${currentRowCount}" value="Text" />
                        <%--
                          * No RSS subscription support in emails
                          * Display the content text, with optional click information.
                          *
                        --%>                          
                        <c:if test="${!empty eSpotData.contentUrl}">
							<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${env_absoluteUrl}${ClickInfoURL}" />
							<c:if test="${fn:contains(ClickInfoURL, '://') || fn:startsWith(ClickInfoURL, '/')}">
								<c:set target="${contentUrlMap}" property="${currentRowCount}" value="${ClickInfoURL}" />
							</c:if>
                        </c:if>
						<c:set target="${contentTextMap}" property="${currentRowCount}" value="${eSpotData.marketingContentDescription[0].marketingText}"/>                
            </c:when>
        </c:choose>
    </c:if>
</c:forEach>


<c:set var="uniqueID" value=“${emsId}”/>

<c:if test="${empty uniqueID || uniqueID == null}">
	<c:set var="uniqueID" value="${emsName}"/>
</c:if>

		<c:forEach items="${contentFormatMap}" varStatus="aStatus">
			<c:choose>
				<c:when test="${contentFormatMap[aStatus.current.key] eq 'File'}">
					<c:choose>
						<c:when test="${contentTypeMap[aStatus.current.key] eq 'image'}">							
								<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
									<a id="ContentAreaESpotInfoImgLink_<c:out value='${uniqueID}_${aStatus.count}'/>" 
										href="${contentUrlMap[aStatus.current.key]}" title="${contentDescriptionMap[aStatus.current.key]}">
								</c:if>
										<c:set var="port" value="${portUsed}"/>
										<c:set var="imageURL" value="${contentImageMap[aStatus.current.key]}"/>
										<c:set var="imageURL" value="${fn:replace(imageURL, ':port', port)}"/>
										<img src="${imageURL}" alt="${contentDescriptionMap[aStatus.current.key]}"/>
								<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
									</a>
								</c:if>							
						</c:when>

						<c:otherwise>
							<a href="<c:out value='${contentAssetPathMap[aStatus.current.key]}'/>" target="_new">
								<c:out value="${contentAssetPathMap[aStatus.current.key]}"/>
							</a>
																					
							<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
								<a href="${contentUrlMap[aStatus.current.key]}" ${clickOpenBrowser} >
							</c:if>
							
							<c:if test="${!empty contentTextMap[aStatus.current.key]}">
								<br/>
								<c:out value="${contentTextMap[aStatus.current.key]}" escapeXml="false" />
							</c:if>
							
							<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
							   </a>
							</c:if>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${contentFormatMap[aStatus.current.key] eq 'Text'}">
						<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
							<a id="WC_ContentAreaESpot_links_7_<c:out value='${aStatus.count}'/>" href="${contentUrlMap[aStatus.current.key]}" ${clickOpenBrowser} >
						</c:if>							
						
						<c:out value="${contentTextMap[aStatus.current.key]}" escapeXml="false" />
					
						<c:if test="${!empty contentUrlMap[aStatus.current.key]}">
							</a>
						</c:if>
				</c:when>
			</c:choose>
		</c:forEach>
		

<%--
  ***
  * Display Categories
  ***
--%>
<c:set var="currentRowCount" value="0" />

<jsp:useBean id="categoryImageMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="categoryURLMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="categoryDescriptionMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="categoryIdentifierMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="categoryPartNumberMap" class="java.util.LinkedHashMap" type="java.util.Map"/>
<jsp:useBean id="categoryIdMap" class="java.util.LinkedHashMap" type="java.util.Map"/>

<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}">
	<c:if test='${eSpotData.baseMarketingSpotDataType eq "CatalogGroupId" && !empty eSpotData.baseMarketingSpotActivityID}'>
        <c:choose>
        	<c:when test="${empty categoryIdQueryList}">
        		<c:set var="categoryIdQueryList" value="${eSpotData.baseMarketingSpotActivityID}"/>
        	</c:when>
        	<c:otherwise>
        		<c:set var="categoryIdQueryList" value="${categoryIdQueryList},${eSpotData.baseMarketingSpotActivityID}"/>
        	</c:otherwise>
        </c:choose>
	</c:if>
</c:forEach>
<c:if test='${!empty categoryIdQueryList}'>
	<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${storeId}/categoryview/byIds" >
		<c:forEach var="id" items="${categoryIdQueryList}">
			<wcf:param name="id" value="${id}"/>
		</c:forEach>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="currency" value="${env_currencyCode}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="responseFormat" value="json"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
	<c:set var="eSpotCatalogIdResults" value="${catalogNavigationView.catalogGroupView}"/>

	<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}" varStatus="status2">
	    <c:if test='${eSpotData.baseMarketingSpotDataType eq "CatalogGroupId"}'>
			<c:forEach var="categoryDetails" items="${eSpotCatalogIdResults}">
				<c:if test="${eSpotData.baseMarketingSpotActivityID == categoryDetails.uniqueID}">
					<c:set var="currentRowCount" value="${currentRowCount+1}" />
			        <%--
			           *
			           * Set up the URL to call when clicking on the image.
			           *
			        --%>
	                <wcf:url var="TargetURL" value="Category3" patternName="CanonicalCategoryURL">
	                    <wcf:param name="langId" value="${langId}" />
	                    <wcf:param name="storeId" value="${storeId}" />
	                    <wcf:param name="catalogId" value="${catalogId}" />
	                    <wcf:param name="categoryId" value="${categoryDetails.uniqueID}" />
	                    <wcf:param name="pageView" value="${defaultPageView}" />
	                    <wcf:param name="beginIndex" value="0" />
	                    <wcf:param name="urlLangId" value="${urlLangId}" />
	                </wcf:url>
			
			        <c:url value="${clickInfoCommand}" var="ClickInfoURL">
			            <c:param name="evtype" value="CpgnClick" />
			            <c:param name="mpe_id" value="${eSpotDatas.marketingSpotIdentifier}" />
			            <c:param name="intv_id" value="${eSpotData.activityIdentifierID}" />
			            <c:param name="storeId" value="${storeId}" />
			            
						<c:forEach var="expResult" items="${eSpotData.experimentResult}" begin="0" end="0">
							<c:param name="experimentId" value="${expResult.experimentResultId}" />
							<c:param name="testElementId" value="${expResult.experimentResultTestElementId}" />
							<c:param name="controlElement" value="${expResult.controlElement}" />
						</c:forEach>
						<c:param name="expDataType" value="${eSpotData.baseMarketingSpotDataType}" />
						<c:param name="expDataUniqueID" value="${eSpotData.baseMarketingSpotActivityID}" />
			            
						<c:choose>
							<c:when test="${(fn:contains(TargetURL, '?'))}">
								<c:param name="URL" value="${TargetURL}" />
							</c:when>
							<c:otherwise>
								<c:param name="URL" value="${TargetURL}?evtype=&mpe_id=&intv_id=&storeId=&catalogId=&langId=&experimentId=&testElementId=&controlElement=&expDataType=&expDataUniqueID=" />
							</c:otherwise>
						</c:choose>
			         </c:url>
			
			        <c:set value="${categoryDetails.thumbnail}" var="marketing_catalogGroupThumbNail" />
			        <c:set value="${categoryDetails.fullImage}" var="marketing_catalogGroupFullImage" />
			        <c:set value="${categoryDetails.shortDescription}" var="marketing_catalogGroupShortDescription" />
			        <c:set value="${categoryDetails.name}" var="marketing_CategoryName" />
			        <c:set value="${categoryDetails.identifier}" var="marketing_PartNumber" />
			        
			
			        <c:choose>
			            <c:when test="${!empty marketing_catalogGroupThumbNail}">
			                <c:set value="${marketing_catalogGroupThumbNail}" var="marketing_catalogGroupImage" />
			            </c:when>
			            <c:otherwise>
			                <c:set value="${marketing_catalogGroupFullImage}" var="marketing_catalogGroupImage" />
			            </c:otherwise>
			        </c:choose>
					
					<c:choose>
						<c:when test="${!empty marketing_catalogGroupImage}">
							<c:choose>
								<c:when test="${(fn:startsWith(marketing_catalogGroupImage, 'http://') || fn:startsWith(marketing_catalogGroupImage, 'https://'))}">
									<wcst:resolveContentURL var="resolvedPath" url="${marketing_catalogGroupImage}" includeHostName="${prependFullURL}"/>
									<c:set target="${categoryImageMap}" property="${currentRowCount}" value="${resolvedPath}"/>
								</c:when>
								<c:when test="${fn:contains(marketing_catalogGroupImage, '/store/0/storeAsset')}">
									<c:set target="${categoryImageMap}" property="${currentRowCount}" value="${restPrefix}${marketing_catalogGroupImage}"/>
								</c:when>						
								<c:otherwise>
									<c:set target="${categoryImageMap}" property="${currentRowCount}" value="${hostPath}${marketing_catalogGroupImage}"/>
								</c:otherwise>
							</c:choose>
							<c:set target="${categoryDescriptionMap}" property="${currentRowCount}" value="${marketing_catalogGroupShortDescription}"/>
						</c:when>
						<c:otherwise>
							<c:set target="${categoryImageMap}" property="${currentRowCount}" value="${hostPath}${jspStoreImgDir}images/NoImageIcon_sm.jpg"/>
							<c:set target="${categoryDescriptionMap}" property="${currentRowCount}" value="<wcst:message key='No_Image' bundle='${widgetText}'"/>
						</c:otherwise>
					</c:choose>
					
					<c:set target="${categoryURLMap}" property="${currentRowCount}" value="${env_absoluteUrl}${ClickInfoURL}"/>
					<c:set target="${categoryIdentifierMap}" property="${currentRowCount}" value="${marketing_CategoryName}"/>
					<c:set target="${categoryPartNumberMap}" property="${currentRowCount}" value="${marketing_PartNumber}"/>
					<c:set target="${categoryIdMap}" property="${currentRowCount}" value="${categoryDetails.uniqueID}"/>
				</c:if>
			</c:forEach>
		</c:if>
	</c:forEach>	

	<div><fmt:message bundle="${storeText}" key="EMAIL_RECOMMENDED_CATEGORIES" /></div>
	<div>
	<c:forEach items="${categoryURLMap}" varStatus="aStatus">
		<div style="float:left;padding:5px;" id="category_<c:out value='${fn:replace(categoryPartNumberMap[aStatus.current.key]," ", "--_-")}'/>">
			<div id="CategoryImage_${uniqueID}_${aStatus.count}">
				<c:if test="${!empty categoryURLMap[aStatus.current.key]}">
					<a id="CategoriesESpotImgLink_${uniqueID}_${aStatus.count}" 
						href="${categoryURLMap[aStatus.current.key]}"
						aria-label="${categoryIdentifierMap[aStatus.current.key]}" title="${categoryIdentifierMap[aStatus.current.key]}" >
				</c:if>
				<img src="${categoryImageMap[aStatus.current.key]}" alt=""/>
				<c:if test="${!empty categoryURLMap[aStatus.current.key]}">
					</a>
				</c:if>
			</div>
			<div>
				<a tabindex="-1" aria-hidden="true" class="product_group_name product_info" href="${categoryURLMap[aStatus.current.key]}${cmcrurl_ProductNameLink}"><c:out value="${categoryIdentifierMap[aStatus.current.key]}"/></a>
			</div>
		</div>
	</c:forEach>
	</div>
</c:if>


<%--
  ***
  * Display Catalog Entries
  ***
--%>
<c:set var="currentProductCount" value="0" />
<c:set var="catentryIdList" value=""/>

<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}">
	<c:if test='${eSpotData.baseMarketingSpotDataType eq "CatalogEntryId" && !empty eSpotData.baseMarketingSpotActivityID}'>
        <c:choose>
        	<c:when test="${empty catentryIdQueryList}">
        		<c:set var="catentryIdQueryList" value="${eSpotData.baseMarketingSpotActivityID}"/>
        	</c:when>
        	<c:otherwise>
        		<c:set var="catentryIdQueryList" value="${catentryIdQueryList},${eSpotData.baseMarketingSpotActivityID}"/>
        	</c:otherwise>
        </c:choose>
	</c:if>
</c:forEach>

<c:remove var="eSpotCatalogIdResults"/>
<c:if test='${!empty catentryIdQueryList}'>
	<c:catch var="searchServerException">
		<wcf:rest var="catalogNavigationView1" url="${searchHostNamePath}${searchContextPath}/store/${storeId}/productview/byIds" >
			<c:forEach var="id" items="${catentryIdQueryList}">
				<wcf:param name="id" value="${id}"/>
			</c:forEach>
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="currency" value="${env_currencyCode}" />
			<wcf:param name="responseFormat" value="json" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
			<c:forEach var="contractId" items="${env_activeContractIds}">
				<wcf:param name="contractId" value="${contractId}"/>
			</c:forEach>
		</wcf:rest>
		<c:set var="eSpotCatalogIdResults" value="${catalogNavigationView1.catalogEntryView}"/>
	</c:catch>

	<c:forEach var="id" items="${catentryIdQueryList}">
		<c:forEach var="catEntryDetails" items="${eSpotCatalogIdResults}">
			<c:if test="${id == catEntryDetails.uniqueID}">
				<c:set var="catEntryType" value="${fn:toLowerCase(catEntryDetails.catalogEntryView[0].catalogEntryTypeCode)}" />		
				<c:set var="catEntryType" value="${fn:replace(catEntryType,'bean','')}" />		
				<c:choose>
					<c:when test="${(catEntryType eq 'dynamickit' && showDynamicKit) || !(catEntryType eq 'dynamickit')}">  
						<c:set var="currentProductCount" value="${currentProductCount+1}" />
						<c:choose>
							<c:when test="${empty catentryIdList}">
								<c:set var="catentryIdList" value="${id}"/>
							</c:when>
							<c:otherwise>
								<c:set var="catentryIdList" value="${catentryIdList},${id}"/>
							</c:otherwise>							
						</c:choose> 									      																										        
					</c:when>
				</c:choose>
			</c:if>
		</c:forEach>
	</c:forEach>

<div><fmt:message bundle="${storeText}" key="EMAIL_RECOMMENDED_PRODUCTS" /></div>
<div>
<c:forEach var="catalogIdEntry" items="${eSpotCatalogIdResults}">
		<c:set var="uniqueID" value="${catalogIdEntry.uniqueID}"/>	
		<c:set var="catalogEntryDetails" value="${catalogIdEntry}" scope="request"/> 

		<c:forEach var="eSpotData" items="${eSpotDatas.baseMarketingSpotActivityData}">
			<c:if test="${eSpotData.baseMarketingSpotActivityID == uniqueID}">
				<c:set var="intvId" value="${eSpotData.activityIdentifierID}"/>
				<c:set var="expResults" value="${eSpotData.experimentResult}" />
				<c:set var="expDataType" value="${eSpotData.baseMarketingSpotDataType}" />
				<c:set var="expDataUniqueID" value="${eSpotData.baseMarketingSpotActivityID}" />
			</c:if>
		</c:forEach>

		<%-- eSpots: parents unknown --%>
<c:set var="patternName" value="ProductURL"/>
<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
	<wcf:param name="catalogId" value="${catalogId}"/>
	<wcf:param name="storeId" value="${storeId}"/>
	<wcf:param name="productId" value="${uniqueID}"/>
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="errorViewName" value="ProductDisplayErrorView"/>
	<wcf:param name="urlLangId" value="${urlLangId}" />
</wcf:url>


			<c:url value="${clickInfoCommand}" var="ClickInfoURL">
				<c:param name="evtype" value="CpgnClick" />
				<c:param name="mpe_id" value="${eSpotDatas.marketingSpotIdentifier}" />
				<c:param name="intv_id" value="${intvId}" />
				<c:param name="storeId" value="${storeId}" />
				<c:param name="catalogId" value="${catalogId}" />
				<c:param name="langId" value="${langId}" />
				
				<c:forEach var="expResult" items="${expResults}" begin="0" end="0">
					<c:param name="experimentId" value="${expResult.experimentResultId}" />
					<c:param name="testElementId" value="${expResult.experimentResultTestElementId}" />
					<c:param name="controlElement" value="${expResult.controlElement}" />
				</c:forEach>
				<c:param name="expDataType" value="${expDataType}" />
				<c:param name="expDataUniqueID" value="${expDataUniqueID}" />
				<c:choose>
					<c:when test="${(fn:contains(catEntryDisplayUrl, '?'))}">
						<c:param name="URL" value="${catEntryDisplayUrl}" />
					</c:when>
					<c:otherwise>
						<c:param name="URL" value="${catEntryDisplayUrl}?evtype=&mpe_id=&intv_id=&storeId=&catalogId=&langId=&experimentId=&testElementId=&controlElement=&expDataType=&expDataUniqueID=" />
					</c:otherwise>
				</c:choose>
			</c:url>			
		<c:set var="catEntryDisplayUrl" value="${env_absoluteUrl}${ClickInfoURL}" />

		<c:set var="catalogEntryID" value="${catalogEntryDetails.uniqueID}" />
		<c:set var="productName" value="${catalogEntryDetails.name}"  />
		<c:set var="productShortDescription" value="${catalogEntryDetails.shortDescription}"  />
		<c:set var="attributes" value="${catalogEntryDetails.attributes}"/>
		<c:set var="partNumber" value="${catalogEntryDetails.partNumber}"/>
		
<c:choose>
	<c:when test="${(fn:startsWith(catalogEntryDetails.thumbnail, 'http://') || fn:startsWith(catalogEntryDetails.thumbnail, 'https://'))}">
		<wcst:resolveContentURL var="productThumbNail" url="${catalogEntryDetails.thumbnail}"/>
	</c:when>
	<c:when test="${fn:contains(catalogEntryDetails.thumbnail, '/store/0/storeAsset')}">
		<c:set var="productThumbNail" value="${restPrefix}${catalogEntryDetails.thumbnail}" />		
	</c:when>						
	<c:otherwise>
		<c:set var="productThumbNail" value="${hostPath}${catalogEntryDetails.thumbnail}" />
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${(fn:startsWith(catalogEntryDetails.fullImage, 'http://') || fn:startsWith(catalogEntryDetails.fullImage, 'https://'))}">
		<wcst:resolveContentURL var="productFullImage" url="${catalogEntryDetails.fullImage}"/>
	</c:when>
	<c:when test="${fn:contains(catalogEntryDetails.fullImage, '/store/0/storeAsset')}">
		<c:set var="productFullImage" value="${restPrefix}${catalogEntryDetails.fullImage}" />
	</c:when>						
	<c:otherwise>
		<c:set var="productFullImage" value="${hostPath}${catalogEntryDetails.fullImage}" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${!empty productThumbNail}">
		<c:set var="imgSource" value="${productThumbNail}" />
	</c:when>
	<c:otherwise>
		<c:set var="imgSource" value="${hostPath}${jspStoreImgDir}images/NoImageIcon_sm.jpg" />
	</c:otherwise>
</c:choose>

<c:set var="altImgText">
	<c:out value='${fn:replace(productName, search, replaceStr)} ${formattedPriceString}' escapeXml='false'/>
</c:set>

		<div style="float:left;padding:5px;">
			<div id="CatalogEntryProdImg_${catalogEntryID}">
				<div id="product_<c:out value='${partNumber}'/>">
					<a id="catalogEntry_img${catalogEntryID}"
							href="${fn:escapeXml(catEntryDisplayUrl)}"
							title="${altImgText}" >
						<img alt="" src="${imgSource}"/>
					</a>
				</div>
			</div>
			<div>
				<div>
					<a aria-hidden="true" tabindex="-1" id="WC_CatalogEntryDBThumbnailDisplayJSPF_${catalogEntryID}_link_9b" href="${fn:escapeXml(catEntryDisplayUrl)}${fn:escapeXml(cmcrurl_productNameLink)}"><c:out value="${productName}" escapeXml="${env_escapeXmlFlag}"/></a>
				</div>
			</div>
		</div>
		<c:remove var="catalogEntryDetails" scope="request"/> 
</c:forEach>
</div>

</c:if>
