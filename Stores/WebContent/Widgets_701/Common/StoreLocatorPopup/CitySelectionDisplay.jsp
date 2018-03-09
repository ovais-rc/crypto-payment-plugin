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
  * This JSP displays the city selections for the province.
  *****
--%>

<!-- BEGIN CitySelectionDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:set var="provinceId" value="-999" />
<c:if test="${!empty WCParam.provinceId}">
  <c:set var="provinceId" value="${WCParam.provinceId}" />
</c:if>
<c:if test="${!empty param.provinceId}">
  <c:set var="provinceId" value="${param.provinceId}" />
</c:if>

<c:catch var="geoNodeException">
	<wcf:rest var="geoNodes" url="store/{storeId}/geonode/byParentGeoNode/{parentGeoId}">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="parentGeoId" value="${provinceId}" encode="true"/>
	</wcf:rest>
</c:catch>

<select name="selectCity" id="selectCity" class="drop_down_country" onchange="javaScript:TealeafWCJS.processDOMEvent(event);storeLocatorJS.changeCitySelection(this.options[this.selectedIndex].value);">

  <c:if test="${empty geoNodeException}">
    <c:set var="resultNum" value="${fn:length(geoNodes.GeoNode)}" />
    <c:if test="${resultNum > 0}">
      <c:forEach var="i" begin="0" end="${resultNum-1}">
        <option value='<c:out value="${geoNodes.GeoNode[i].uniqueID}" />'><c:out value="${geoNodes.GeoNode[i].Description[0].shortDescription}" /></option>
      </c:forEach>
    </c:if>
    <c:if test="${resultNum == 0}">
      <c:if test="${!empty geoNodes.uniqueID}">
        <option value='<c:out value="${geoNodes.uniqueID}" />'><c:out value="${geoNodes.name}" /></option>
      </c:if>
    </c:if>
  </c:if>

</select>
<!-- END CitySelectionDisplay.jsp -->
