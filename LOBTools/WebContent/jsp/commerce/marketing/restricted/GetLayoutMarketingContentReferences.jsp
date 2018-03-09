<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

	<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]" var="contents" expressionBuilder="findByUniqueIDs">
		<wcf:param name="UniqueID" value="${param.collateralId}" />
		<wcf:contextData name="storeId" data="${param.storeId}"/>
	</wcf:getData>			
		
	<%-- get any layouts associated with the e-Marketing Spot --%>		
	<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType[]"
		var="pagelayouts" expressionBuilder="findLayoutsByEMarketingSpotID" varShowVerb="showVerb">
		<wcf:param name="eMarketingSpotId" value="${spot.marketingSpotIdentifier.uniqueID}" />
		<wcf:contextData name="storeId" data="${param.storeId}" />
	</wcf:getData>
		
	<c:forEach var="content" items="${contents}">
		<c:forEach var="layout" items="${pagelayouts}">
		
			<%-- get the widgets in the layout - based on jsp\commerce\pagelayout\restricted\GetChildLayoutWidgets.jsp and SerializeLayoutWidget.jspf --%>
			<wcf:getData
				type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType"
				var="pagelayout" expressionBuilder="getLayoutsByUniqueID"
				varShowVerb="showVerb0">
				<wcf:contextData name="storeId" data="${param.storeId}" />
				<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
				<wcf:param name="layoutId" value="${layout.layoutIdentifier.uniqueID}"/>
				<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			</wcf:getData>

			<c:if test="${!(empty pagelayout.widget)}">
				<c:forEach var="widget" items="${pagelayout.widget}">
					<c:if test="${!(widget.parentWidget == null || empty widget.parentWidget) && (widget.childSlot == null || empty widget.childSlot ) }">
						<c:set var="emsId" value="" />
						<c:forEach var="property" items="${widget.widgetProperty}">
							<c:if test="${property.name == 'emsId'}">
								<c:set var="emsId" value="${property.value}"/>
							</c:if>
						</c:forEach>
						<%-- found the widget associated with the e-Marketing Spot --%>
						<c:if test="${!empty emsId && emsId == spot.marketingSpotIdentifier.uniqueID}">

							<reference>		
								<c:set var="inheritedChildObject" value=""/>
								<c:set var="inherited" value=""/>
								<c:if test="${defaultContent.storeIdentifier.uniqueID != param.storeId}">
									<c:set var="inherited" value="Inherited"/>
								</c:if>
								<c:if test="${content.marketingContentIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
									<c:set var="inheritedChildObject" value="Inherited"/>
								</c:if>
			
								<%-- serialize the default content reference --%>
								<object objectType="${inheritedChildObject}DefaultEMarketingSpot${inherited}MarketingContentReference">				
									<uniqueId>${defaultContent.uniqueID}</uniqueId>
									<objectStoreId>${defaultContent.storeIdentifier.uniqueID}</objectStoreId>
									<contentId>${defaultContent.contentUniqueID}</contentId>
									<contentType><wcf:cdata data="${defaultContent.format}"/></contentType>
									<sequence><fmt:formatNumber type="number" value="${defaultContent.displaySequence}" maxFractionDigits="0" pattern="#0" /></sequence>
									<parent>
						
										<%-- serialize the widget associated with the e-Marketing Spot --%>
										<c:set var="widgetObjectType" value="${widget.widgetDefinitionIdentifier.externalIdentifier.identifier}" />
										<c:set var="widgetDefinitionId" value="${widget.widgetDefinitionIdentifier.uniqueID}" />

										<c:if test="${widgetDefinitionId != null }">
											<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.WidgetDefinitionType"
												var="widgetDefinition"
												expressionBuilder="findByUniqueIDs">
												<wcf:contextData name="storeId" data="${param.storeId}" />
												<wcf:param name="UniqueID" value="${widgetDefinitionId}" />
											</wcf:getData>
											<c:if test="${!(empty widgetDefinition)}">
	 											<c:set var="widgetObjectType" value="${widgetDefinition.widgetObjectName}"/>
											</c:if>
										</c:if>		

										<object objectType="${widgetObjectType}" >
											<widgetId><wcf:cdata data="${widget.widgetIdentifier.uniqueID}"/></widgetId>
											<widgetDefId><wcf:cdata data="${widget.widgetDefinitionIdentifier.uniqueID}"/></widgetDefId>
											<widgetName><wcf:cdata data="${widget.widgetIdentifier.name}"/></widgetName>
											<slotIdentifier><wcf:cdata data="${widget.slot.internalSlotId}"/></slotIdentifier>
											<sequence><wcf:cdata data="${widget.widgetSequence}"/></sequence>
											<parentWidgetId><wcf:cdata data="${widget.parentWidget.uniqueID}"/></parentWidgetId>
											<%-- widget properties --%>
											<c:forEach var="property" items="${widget.widgetProperty}">
												<xWidgetProp_${property.name}><wcf:cdata data="${property.value}"/></xWidgetProp_${property.name}>
											</c:forEach>
											
											<parent>

												<%-- serialize the layout --%>
												<c:set var="showVerb1" value="${showVerb0}" scope="request"/>

												<%-- Default case: assume everything is one store --%>
												<c:set var="inherited" value="" />   
	        									<c:set var="layoutOwningStoreId" value="${pagelayout.layoutIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			 									<c:if test="${param.storeId != layoutOwningStoreId}">
													<%-- esite case--%>
													<c:set var="inherited" value="Inherited" />
												</c:if> 
												<jsp:directive.include file="../../pagelayout/restricted/serialize/SerializePageLayout.jspf" />

											</parent>
																						
										</object>
									</parent>
								</object>
							</reference>
			
						</c:if>
					</c:if>
				</c:forEach>
			</c:if>

		</c:forEach>
	</c:forEach>