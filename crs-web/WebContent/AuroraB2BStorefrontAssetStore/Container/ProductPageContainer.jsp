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

<!-- BEGIN ProductPageContainer.jsp -->

<%@include file="../Common/EnvironmentSetup.jspf"%>
<%@taglib uri="http://commerce.ibm.com/pagelayout" prefix="wcpgl"%>

<!--Start Page Content-->
<div id="contentWrapper">
	<c:set var="slotNumber" value="7"/>
	<c:set var="foundCurrentSlot7" value="false"/>
	<c:forEach var="childWidget" items="${pageDesign.widget.childWidget}">
		<c:if test="${childWidget.slot.internalSlotId == slotNumber && !foundCurrentSlot7}">
			<c:set var="foundCurrentSlot7" value="true"/>
		</c:if>
	</c:forEach>
	<div class="product_page_content rowContainer <c:if test='${foundCurrentSlot7 == true}'>bundle_package_page</c:if>" id="container_${pageDesign.layoutId}" role="main">		
		<div class="row margin-true">
			<div class="col12 slot1" data-slot-id="1"><wcpgl:widgetImport slotId="1"/></div>
		</div>
		<div class="row">
			<div class="col6 acol12 slot2" data-slot-id="2"><wcpgl:widgetImport slotId="2"/></div>
			<div class="col6 acol12 slot3" data-slot-id="3"><wcpgl:widgetImport slotId="3"/></div>
		</div>
		<div class="row margin-true ${fn:toLowerCase(pageDesign.pageGroup)}_pageDesign_pageGroup">
		<c:choose>
			<c:when test="${foundCurrentSlot7 == true}">
				<div class="col6 acol6 ccol2 slot4" data-slot-id="4"><wcpgl:widgetImport slotId="4"/></div>
				<div id="productSlot56" class="acol12 col12 ccol2">
			</c:when>
			<c:otherwise>
				<div class="col6 acol6 ccol3 slot4" data-slot-id="4"><wcpgl:widgetImport slotId="4"/></div>
				<div id="productSlot56" class="acol12 col12 ccol3">
			</c:otherwise>
		</c:choose>
			<div class="col5 acol6 ccol12 left slot5" data-slot-id="5"><wcpgl:widgetImport slotId="5"/></div>
			<div class="col5 acol12 ccol12 left slot6" data-slot-id="6"><wcpgl:widgetImport slotId="6"/></div>
			</div>		

		<c:choose>
			<c:when test="${foundCurrentSlot7 == true}">
				<div class="col12 acol12 ccol4 left slot7" data-slot-id="7"><wcpgl:widgetImport slotId="7"/></div>
				<div class="col12 acol12 ccol4 left slot8" data-slot-id="8"><wcpgl:widgetImport slotId="8"/></div>
			</c:when>
			<c:otherwise>
				<div class="col12 acol12 ccol6 left slot7" data-slot-id="7"><wcpgl:widgetImport slotId="7"/></div>
				<div class="col12 acol12 ccol6 left slot8" data-slot-id="8"><wcpgl:widgetImport slotId="8"/></div>
			</c:otherwise>
		</c:choose>

		<wcf:useBean var="tabSlotIds" classname="java.util.ArrayList"/>
		<%-- Double loop to get the slots into the array list in proper order. The service does not return the child widgets in any predictable order. --%>
		<c:set var="tabSlotCount" value="0"/>
		<c:forEach var="slotNumber" begin="9" end="11">
			<c:set var="foundCurrentSlot" value="false"/>
			<c:forEach var="childWidget" items="${pageDesign.widget.childWidget}">
				<c:if test="${childWidget.slot.internalSlotId == slotNumber && !foundCurrentSlot}">
					<wcf:set target="${tabSlotIds}" value="${slotNumber}" />
					<c:set var="foundCurrentSlot" value="true"/>
					<c:set var="tabSlotCount" value="${tabSlotCount+1}"/>
				</c:if>
			</c:forEach>
		</c:forEach>
		<c:if test="${!empty tabSlotIds}">
			<c:choose>
				<c:when test="${foundCurrentSlot7 == true}">
					<div class="col12 acol12 ccol4 right tabbedSlots9_10_11">
				</c:when>
				<c:otherwise>
					<div class="col12 acol12 ccol6 right tabbedSlots9_10_11">
				</c:otherwise>
			</c:choose>
			<div class="tabButtonContainer" role="tablist">
				<div class="tab_header tab_header_double">
					<c:forEach var="tabSlotId" items="${tabSlotIds}" varStatus="status">
						<c:set var="tabSlotName" value="Title${tabSlotId}"/>
						<c:forEach var="childWidget" items="${pageDesign.widget.childWidget}">
							<c:if test="${childWidget.slot.internalSlotId == tabSlotName}">
								<c:set var="tabWidgetDefIdentifier" value="${childWidget.widgetDefinitionId}"/>
								<c:set var="tabWidgetIdentifier" value="${childWidget.widgetId}"/>
							</c:if>
						</c:forEach>
							
						<c:choose>
							<c:when test="${status.first}">
								<c:set var="tabClass" value="active_tab focused_tab" />
								<c:set var="tabIndex" value="0" /> 
							</c:when>
							<c:otherwise>
								<c:set var="tabClass" value="inactive_tab" />
								<c:set var="tabIndex" value="-1" />
							</c:otherwise>
						</c:choose>
						<c:set var="tabNumber" value="${status.index+1}" scope="request"/>
						<div id="tab${status.count}" tabindex="${tabIndex}" class="tab_container ${tabClass}" 
								aria-labelledby="contentRecommendationWidget_${tabSlotName}_${tabWidgetDefIdentifier}_${tabWidgetIdentifier}" aria-controls="tab${status.count}Widget"
								onfocus="ProductTabJS.focusTab('tab${status.count}');" onblur="ProductTabJS.blurTab('tab${status.count}');" 
								role="tab" aria-setsize="${tabSlotCount}" aria-posinset="${status.count}" aria-selected="${status.first == true ? 'true' : 'false'}" 	
								onclick="ProductTabJS.selectTab('tab${status.count}');" 
								onkeydown="ProductTabJS.selectTabWithKeyboard('${status.count}','${tabSlotCount}', event);">
								<wcpgl:widgetImport slotId="${tabSlotName}"/>
						</div>
						<c:remove var="tabNumber"/>
					</c:forEach>
				</div>
			</div>

			<c:forEach var="tabSlotId" items="${tabSlotIds}" varStatus="status">
				<c:set var="tabStyle" value=""/>
				<c:if test="${!status.first}">
					<c:set var="tabStyle" value="style='display:none'" />
				</c:if>
				<div role="tabpanel" class="tab left" data-slot-id="${tabSlotId}" id="tab${status.count}Widget" aria-labelledby="tab${status.count}" ${tabStyle}>
					<div class="content">
						<wcpgl:widgetImport slotId="${tabSlotId}"/>
					</div>
				</div>
				<c:remove var="tabStyle"/>
			</c:forEach>
			</div>
		</c:if>
		<div class="clear_float"></div>
		</div>				
	</div>
</div>

<!-- END ProductPageContainer.jsp -->
