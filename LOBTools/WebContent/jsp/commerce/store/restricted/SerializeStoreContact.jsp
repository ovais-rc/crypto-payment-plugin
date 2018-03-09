<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with 
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object objectType="${objectType}">
	<languageId><wcf:cdata data="${info.language}"/></languageId>
	<contactInfoId><wcf:cdata data="${info.contactInfoIdentifier.uniqueID}"/></contactInfoId>
	<personTitle><wcf:cdata data="${info.contactName.personTitle}"/></personTitle>
	<businessTitle><wcf:cdata data="${info.contactName.businessTitle}"/></businessTitle>
	<firstName><wcf:cdata data="${info.contactName.firstName}"/></firstName>
	<middleName><wcf:cdata data="${info.contactName.middleName}"/></middleName>
	<lastName><wcf:cdata data="${info.contactName.lastName}"/></lastName>
	<c:set var="count" value="0"/>	
	<c:forEach var="addressLine" items="${info.address.addressLine}">
		<addressLine.${count}><wcf:cdata data="${addressLine}"/></addressLine.${count}>
		<c:set var="count" value="${count + 1}"/>	
	</c:forEach>
	<city><wcf:cdata data="${info.address.city}"/></city>
	<stateOrProvinceName><wcf:cdata data="${info.address.stateOrProvinceName}"/></stateOrProvinceName>
	<country><wcf:cdata data="${info.address.country}"/></country>
	<postalCode><wcf:cdata data="${info.address.postalCode}"/></postalCode>
	<telephone1><wcf:cdata data="${info.telephone1.value}"/></telephone1>
	<telephone2><wcf:cdata data="${info.telephone2.value}"/></telephone2>
	<email1><wcf:cdata data="${info.emailAddress1.value}"/></email1>
	<email2><wcf:cdata data="${info.emailAddress2.value}"/></email2>
	<fax1><wcf:cdata data="${info.fax1.value}"/></fax1>
	<fax2><wcf:cdata data="${info.fax2.value}"/></fax2>
	<mobile><wcf:cdata data="${info.mobilePhone1.value}"/></mobile>
	<organizationName><wcf:cdata data="${info.organizationName}"/></organizationName>
	<organizationUnitName><wcf:cdata data="${info.organizationUnitName}"/></organizationUnitName>
	<geographicalShippingCode><wcf:cdata data="${info.geographicalShippingCode}"/></geographicalShippingCode>
	<geographicalTaxCode><wcf:cdata data="${info.geographicalTaxCode}"/></geographicalTaxCode>
	<c:forEach var="userDataField" items="${info.userData}">
		<x${objectType}_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x${objectType}_${userDataField.typedKey}>
	</c:forEach>
</object>