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
  * This JSP displays the province selections for the country.
  *****
--%>

<!-- BEGIN ProvinceSelectionDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:set var="countryId" value="-999" />
<c:if test="${!empty WCParam.countryId}">
  <c:set var="countryId" value="${WCParam.countryId}" />
</c:if>
<c:if test="${!empty param.countryId}">
  <c:set var="countryId" value="${param.countryId}" />
</c:if>

<c:catch var="geoNodeException">
	<wcf:rest var="geoNodes" url="store/{storeId}/geonode/byParentGeoNode/{parentGeoId}">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="parentGeoId" value="${countryId}" encode="true"/>
	</wcf:rest>
</c:catch>


<select name="selectState" id="selectState" title="<wcst:message bundle="${widgetText}" key='ACCE_PROVINCE_CHANGE'/>" class="drop_down_country" onchange="JavaScript:TealeafWCJS.processDOMEvent(event);storeLocatorJS.changeProvinceSelection(this.options[this.selectedIndex].value);">

  <c:if test="${empty geoNodeException}">
    <c:set var="resultNum" value="${fn:length(geoNodes.GeoNode)}" />
    <c:if test="${resultNum > 0}">
      <c:forEach var="i" begin="0" end="${resultNum-1}">
        <option value='<c:out value="${geoNodes.GeoNode[i].uniqueID}" />'><c:out value="${geoNodes.GeoNode[i].Description[0].shortDescription}" /></option>
      </c:forEach>
    </c:if>
    <c:if test="${resultNum == 0 && !empty geoNodes.uniqueID}">
      <option value='<c:out value="${geoNodes.uniqueID}" />'><c:out value="${geoNodes.Description[0].shortDescription}" /></option>
    </c:if>
  </c:if>

</select>
<!-- END ProvinceSelectionDisplay.jsp -->
