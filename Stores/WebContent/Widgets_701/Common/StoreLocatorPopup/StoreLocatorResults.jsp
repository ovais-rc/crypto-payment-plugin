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
  * This JSP displays the store locator results.
  *****
--%>

<!-- BEGIN StoreLocatorResults.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:set var="fromPage" value="StoreLocator" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>
<c:if test="${!empty param.fromPage}">
	<c:set var="fromPage" value="${param.fromPage}" />
</c:if>

<c:set var="cityId" value="-999" />
<c:if test="${!empty WCParam.cityId}">
	<c:set var="cityId" value="${WCParam.cityId}" />
</c:if>
<c:if test="${!empty param.cityId}">
	<c:set var="cityId" value="${param.cityId}" />
</c:if>

<c:set var="geoCodeLatitude" value=""/>
<c:set var="geoCodeLongitude" value=""/>
<c:if test="${!empty param.geoCodeLatitude}">
	<c:set var="geoCodeLatitude" value="${param.geoCodeLatitude}" />
</c:if>
<c:if test="${!empty param.geoCodeLongitude}">
	<c:set var="geoCodeLongitude" value="${param.geoCodeLongitude}" />
</c:if>

<c:set var="errorMsgKey" value=""/>
<c:if test="${!empty WCParam.errorMsgKey}">
	<c:set var="errorMsgKey" value="${fn:escapeXml(WCParam.errorMsgKey)}"/>
</c:if>
<c:if test="${!empty param.errorMsgKey}">
	<c:set var="errorMsgKey" value="${fn:escapeXml(param.errorMsgKey)}"/>
</c:if>

<c:if test="${empty errorMsgKey}">
	<c:choose>
		<c:when test="${empty geoCodeLatitude && empty geoCodeLongitude}">
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="store/{storeId}/storelocator/byGeoNode/{geoId}">
					<wcf:var name="storeId" value="${storeId}" encode="true"/>
					<wcf:var name="geoId" value="${cityId}" encode="true"/>
				</wcf:rest>
			</c:catch>
		</c:when>
		<c:otherwise>
			<c:catch var="physicalStoreException">
				<wcf:rest var="physicalStores" url="store/{storeId}/storelocator/latitude/{latitude}/longitude/{longitude}">
					<wcf:var name="storeId" value="${storeId}" encode="true"/>
					<wcf:var name="latitude" value="${geoCodeLatitude}" encode="true"/>
					<wcf:var name="longitude" value="${geoCodeLongitude}" encode="true"/>
					<wcf:param name="siteLevelStoreSearch" value="false"/>
					<c:if test="${!empty radius}"><wcf:param name="radius" value="${radius}" /></c:if>                   
					<c:if test="${!empty uom}"><wcf:param name="radiusUOM" value="${uom}" /></c:if>                   
					<wcf:param name="maxItems" value="${maxItems}" />
				</wcf:rest>
			</c:catch>
		</c:otherwise>
	</c:choose>
</c:if>

<c:if test="${cityId != -999 || (!empty geoCodeLatitude && !empty geoCodeLongitude) || !empty errorMsgKey}">
	<div class="gift_content">
</c:if>

<c:if test="${!empty physicalStoreException}">
	<c:out value="${physicalStoreException.changeStatus.description.value}" />
</c:if>
<c:if test="${empty physicalStoreException}">
	<c:set var="resultNum" value="${fn:length(physicalStores.PhysicalStore)}" />
	<c:choose>
		<c:when test="${resultNum <= 0 && !empty errorMsgKey}">
			<span class="content_text_title"><wcst:message bundle="${widgetText}" key="STORE_RESULTS"/></span>
			<div class="instruction"><wcst:message bundle="${widgetText}" key="${errorMsgKey}" /></div>
		</c:when>
		<c:when test="${cityId != -999 && resultNum <= 0}">
			<span class="content_text_title"><wcst:message bundle="${widgetText}" key="STORE_RESULTS"/></span>
			<div id="no_store_message" tabindex="-1"><span class="instruction"><wcst:message bundle="${widgetText}" key="NO_STORE_EXIST" /></span></div>
		</c:when>
		<c:when test="${cityId != -999 && resultNum > 0}">
			<span class="content_text_title"><wcst:message bundle="${widgetText}" key="STORE_RESULTS"/></span>
			<div class="instruction"><wcst:message bundle="${widgetText}" key="MAKE_SELECTION" /></div>
		</c:when>
	</c:choose>
			
	<c:if test="${resultNum > 0}">

		<table id="bopis_table" tabindex="-1" summary="<wcst:message bundle="${widgetText}" key='STORE_RESULTS_SUMMARY'/>" cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr class="nested">
				<th class="align_left" id="PhysicalStores_tableCell_result1"><wcst:message bundle="${widgetText}" key="STORE_RESULTS_COLUMN1" /></th>
				<th class="align_left" id="PhysicalStores_tableCell_result2"><wcst:message bundle="${widgetText}" key="STORE_RESULTS_COLUMN2" /></th>
				<th class="align_left" id="PhysicalStores_tableCell_result3"><wcst:message bundle="${widgetText}" key="STORE_RESULTS_COLUMN3" /></th>
				<c:if test="${_worklightHybridApp}"><th class="align_left" id="PhysicalStores_tableCell_result3"><wcst:message bundle="${widgetText}" key="MST_VIEW_MAP" /></th></c:if>
			</tr>
            
			<c:forEach var="i" begin="0" end="${resultNum-1}">
				<c:set var="storeHourIndex" value=-1 />
				<c:set var="attributeNum" value="${fn:length(physicalStores.PhysicalStore[i].Attribute)}" />
				<c:if test="${attributeNum > 0}">
					<c:forEach var="j" begin="0" end="${attributeNum - 1}">
						<c:if test="${physicalStores.PhysicalStore[i].Attribute[j].name == 'StoreHours'}">
							<c:set var="storeHoursIndex" value="${j}" />
							<c:set var="j" value="${attributeNum}" />
						</c:if>
					</c:forEach>
				</c:if>
					
				<tr>
					<td headers="PhysicalStores_tableCell_result1" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
						<p><span class="my_account_content_bold"><c:out value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" /></span></p>
						<p><c:out value="${physicalStores.PhysicalStore[i].addressLine[0]}" /></p>
						<p><c:out value="${physicalStores.PhysicalStore[i].city}" />, <c:out value="${physicalStores.PhysicalStore[i].stateOrProvinceName}" />  <c:out value="${physicalStores.PhysicalStore[i].postalCode}" /></p>
						<p><c:out value="${physicalStores.PhysicalStore[i].telephone1}" /></p>
					</td>
    
					<c:choose>
						<c:when test="${storeHoursIndex > -1}">
							<td headers="PhysicalStores_tableCell_result2" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
								<c:out value="${physicalStores.PhysicalStore[i].Attribute[storeHoursIndex].displayValue}" escapeXml="false"/>
							</td>
						</c:when>
						<c:otherwise>
							<td headers="PhysicalStores_tableCell_result2" <c:choose><c:when test="${i == resultNum - 1}"><c:out value="class=no_bottom_border"/></c:when><c:otherwise><c:out value="class=dotted_bottom_border"/></c:otherwise></c:choose>>
							</td>
						</c:otherwise>
					</c:choose>                 

					<td class="avail <c:choose><c:when test="${i == resultNum - 1}"><c:out value="no_bottom_border"/></c:when><c:otherwise><c:out value="dotted_bottom_border"/></c:otherwise></c:choose>" headers="PhysicalStores_tableCell_result3">
						<c:set var="storeExistInCookie" value="false" />
						<c:set var="cookieVal" value="${cookie.WC_physicalStores.value}" />
						<c:set var="cookieVal" value="${fn:replace(cookieVal, '%2C', ',')}"/>
						<c:forTokens items="${cookieVal}" delims="," var="physicalStoreId">
							<c:if test="${physicalStoreId == physicalStores.PhysicalStore[i].uniqueID}">
								<c:set var="storeExistInCookie" value="true" />
							</c:if>
						</c:forTokens>

						<c:choose>
							<c:when test="${storeExistInCookie == 'true'}">
								<div id="addPhysicalStoreToCookieDisabled<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />" style="display:block;">
								</div>
								<div id="addPhysicalStoreToCookie<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />" style="display:none;">
									<a href="#" role="button" class="button_primary" id="addPhysicalStoreToCookieButton<c:out value='${i}' />" onclick="Javascript:setCurrentId('addPhysicalStoreToCookieDisabled<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />'); if (storeLocatorJS.addPhysicalStore(<c:out value="${physicalStores.PhysicalStore[i].uniqueID}" />, <c:out value="${i}" />)) {storeLocatorJS.refreshStoreList('<c:out value="${fromPage}" />');} return false;" onBlur="JavaScript: this.blur();" onmouseout="JavaScript: this.blur();">
										<div class="left_border"></div>
										<div class="button_text"><wcst:message bundle="${widgetText}" key="ADD_PHYSICAL_STORE" /></div>
										<div class="right_border"></div>
									</a>
								</div>
							</c:when>
							<c:otherwise>
								<div id="addPhysicalStoreToCookieDisabled<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />" style="display:none;">
								</div>
								<div id="addPhysicalStoreToCookie<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />" style="display:block;">
									<a href="#" role="button" class="button_primary" id="addPhysicalStoreToCookieButton<c:out value='${i}' />" onclick="Javascript:setCurrentId('addPhysicalStoreToCookieDisabled<c:out value='${physicalStores.PhysicalStore[i].uniqueID}' />'); if (storeLocatorJS.addPhysicalStore(<c:out value="${physicalStores.PhysicalStore[i].uniqueID}" />, <c:out value="${i}" />)) {storeLocatorJS.refreshStoreList('<c:out value="${fromPage}" />');} return false;" onBlur="JavaScript: this.blur();" onmouseout="JavaScript: this.blur();">
										<div class="left_border"></div>
										<div class="button_text"><wcst:message bundle="${widgetText}" key="ADD_PHYSICAL_STORE" /></div>
										<div class="right_border"></div>
									</a>
								</div>
							</c:otherwise>
						</c:choose>
					</td>
					<c:if test="${_worklightHybridApp}">
					<td class="dotted_bottom_border">
						<div style="display:block;">
							<a class="button_primary" role="button" href="#" onclick="javascript:DisplayMapJS.invokeNativeMap('<c:out value="${geoCodeLatitude}" />','<c:out value="${geoCodeLongitude}" />','<c:out value="${physicalStores.PhysicalStore[i].uniqueID}" />','<c:out value="${physicalStores.PhysicalStore[i].Description[0].displayStoreName}" />','<c:out value="${physicalStores.PhysicalStore[i].latitude}" />','<c:out value="${physicalStores.PhysicalStore[i].longitude}" />','<c:out value="${physicalStores.PhysicalStore[i].city}" />','<c:out value="${physicalStores.PhysicalStore[i].stateOrProvinceName}" />','<c:out value="${physicalStores.PhysicalStore[i].addressLine[0]}" />','<c:out value="${physicalStores.PhysicalStore[i].addressLine[1]}" />','<c:out value="${physicalStores.PhysicalStore[i].addressLine[2]}" />')">
								<div class="left_border"></div>
								<div class="button_text"><wcst:message bundle="${widgetText}" key="MST_VIEW_MAP" /></div>
								<div class="right_border"></div>
							</a>
						</div>
					</td>
					</c:if>
				</tr>
  
			</c:forEach>
		</table>
	</c:if>
</c:if>
<c:if test="${cityId != -999 || (!empty geoCodeLatitude && !empty geoCodeLongitude) || !empty errorMsgKey}">
	</div>
</c:if>

<!-- END StoreLocatorResults.jsp -->
