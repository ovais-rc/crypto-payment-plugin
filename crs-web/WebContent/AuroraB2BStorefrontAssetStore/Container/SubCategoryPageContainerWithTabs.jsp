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

    <!-- BEGIN SubCategoryPageContainerWithTabs.jsp -->

    <%@include file="../Common/EnvironmentSetup.jspf"%>
    <%@taglib uri="http://commerce.ibm.com/pagelayout" prefix="wcpgl"%>

            <div class="subCat_page_tab_content rowContainer" id="container_${pageDesign.layoutId}">
                <div class="row margin-true">
                    <div class="col12" data-slot-id="1">
                        <wcpgl:widgetImport slotId="1" />
                    </div>
                </div>
                <div class="row">
                    <div class="col6 acol12" data-slot-id="2">
                        <wcpgl:widgetImport slotId="2" />
                    </div>
                    <div class="col6 acol12" data-slot-id="3">
                        <wcpgl:widgetImport slotId="3" />
                    </div>
                </div>
                <div class="row margin-true">
                    <div class="col4 acol12 ccol3" data-slot-id="4">
                        <wcpgl:widgetImport slotId="4" />
                    </div>
                    <div class="col8 acol12 ccol9 right" data-slot-id="5">
                        <wcpgl:widgetImport slotId="5" />
                    </div>
                    <div class="col8 acol12 ccol9 right">

                        <wcf:useBean var="tabSlotIds" classname="java.util.ArrayList" />
                        <%-- Double loop to get the slots into the array list in proper order. The service does not return the child widgets in any predictable order. --%>
						<c:set var="tabSlotCount" value="0" />
						<c:forEach var="slotNumber" begin="6" end="7">
							<c:set var="foundCurrentSlot" value="false" />
							<c:forEach var="childWidget" items="${pageDesign.widget.childWidget}">
								<c:if test="${childWidget.slot.internalSlotId == slotNumber && !foundCurrentSlot}">
									<wcf:set target="${tabSlotIds}" value="${slotNumber}" />
									<c:set var="foundCurrentSlot" value="true" />
									<c:set var="tabSlotCount" value="${tabSlotCount+1}" />
								</c:if>
							</c:forEach>
						</c:forEach>

						<%-- Find the index of the selected tab --%>
						<c:set var="selectedTabIndex" value="${0}" />
						<c:forEach var="tabSlotId" items="${tabSlotIds}" varStatus="status">
							<c:if test="${(empty WCParam.tabSlotId && status.first) || (!empty WCParam.tabSlotId && WCParam.tabSlotId == tabSlotId)}">
								<c:set var="selectedTabIndex" value="${status.index}" />
							</c:if>
						</c:forEach>
						<div class="tabButtonContainer" role="tablist">
							<div class="tab_header tab_header_double">
								<c:forEach var="tabSlotId" items="${tabSlotIds}" varStatus="status">
									<c:set var="tabSlotName" value="Title${tabSlotId}" />
									<c:forEach var="childWidget" items="${pageDesign.widget.childWidget}">
										<c:if test="${childWidget.slot.internalSlotId == tabSlotName}">
											<c:set var="tabWidgetDefIdentifier" value="${childWidget.widgetDefinitionId}" />
											<c:set var="tabWidgetIdentifier" value="${childWidget.widgetId}" />
										</c:if>
									</c:forEach>
									<c:choose>
										<c:when test="${selectedTabIndex == status.index}">
											<c:set var="tabClass" value="tab_container active_tab" />
											<c:set var="tabIndex" value="0" />
										</c:when>
										<c:otherwise>
											<c:set var="tabClass" value="tab_container inactive_tab" />
											<c:set var="tabIndex" value="-1" />
										</c:otherwise>
									</c:choose>
									<c:set var="tabNumber" value="${status.index+1}" scope="request" />
									<div id="tab${status.count}" tabindex="${tabIndex}" class="tab_container ${tabClass}" aria-labelledby="contentRecommendationWidget_${tabSlotName}_${tabWidgetDefIdentifier}_${tabWidgetIdentifier}" aria-controls="tab${status.count}Widget" onfocus="ProductTabJS.focusTab('tab${status.count}');"
										onblur="ProductTabJS.blurTab('tab${status.count}');" role="tab" aria-setsize="${tabSlotCount}" aria-posinset="${status.count}" aria-selected="${status.first == true ? 'true' : 'false'}" onclick="ProductTabJS.selectTab('tab${status.count}');"
										onkeydown="ProductTabJS.selectTabWithKeyboard('${status.count}','${tabSlotCount}', event);">
										<wcpgl:widgetImport slotId="${tabSlotName}" />
									</div>
									<c:remove var="tabNumber" />
								</c:forEach>
							</div>
						</div>

						<c:forEach var="tabSlotId" items="${tabSlotIds}" varStatus="status">
							<c:set var="tabStyle" value="" />
							<c:if test="${selectedTabIndex != status.index}">
								<c:set var="tabStyle" value="style='display:none'" />
							</c:if>
							<div role="tabpanel" class="tab left" data-slot-id="${tabSlotId}" id="tab${status.count}Widget" aria-labelledby="tab${status.count}" ${tabStyle}>
								<div class="content">
									<wcpgl:widgetImport slotId="${tabSlotId}" />
								</div>
							</div>
							<c:remove var="tabStyle" />
						</c:forEach>

                    </div>
                    <div class="col8 acol12 ccol9 right" data-slot-id="8">
                        <wcpgl:widgetImport slotId="8" />
                    </div>
                </div>
            </div>

            <!-- END SubCategoryPageContainerWithTabs.jsp -->