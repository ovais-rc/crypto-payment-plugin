<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  ***
  * This jsp populates the data required by the physical store details section of the product display page.
  * It creates a JSON object which is returned to the client from the AJAX call.
  ***
--%>

<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:catch var="physicalStoreException">
	<wcf:rest var="physicalStore" url="store/{storeId}/storelocator/byStoreId/{uniqueId}">
		<wcf:var name="storeId" value="${storeId}" encode="trure"/>
		<wcf:var name="uniqueId" value="${param.physicalStoreId}" encode="trure"/>
	</wcf:rest>
</c:catch>

<c:set var="hours" value=""/>
<c:forEach var="attribute" items="${physicalStore.PhysicalStore[0].Attribute}">
	<c:if test="${attribute.name eq 'StoreHours'}">
		<c:set var="hours" value="${fn:escapeXml(attribute.displayValue)}"/>
	</c:if>
</c:forEach>
<%-- Prepares the json object to be returned --%>
<c:set var="address" value="{
	name: '${fn:escapeXml(physicalStore.PhysicalStore[0].storeName)}',
	addressLine: '${fn:escapeXml(physicalStore.PhysicalStore[0].addressLine[0])}',
	city: '${fn:escapeXml(physicalStore.PhysicalStore[0].city)}',
	stateOrProvinceName: '${fn:escapeXml(physicalStore.PhysicalStore[0].stateOrProvinceName)}',
	postalCode: '${fn:escapeXml(physicalStore.PhysicalStore[0].postalCode)}',
	country: '${fn:escapeXml(physicalStore.PhysicalStore[0].country)}',
	telephone: '${fn:escapeXml(physicalStore.PhysicalStore[0].telephone1)}'}"/>
/*
{
address: ${address},
hours: '${hours}'
}
*/
