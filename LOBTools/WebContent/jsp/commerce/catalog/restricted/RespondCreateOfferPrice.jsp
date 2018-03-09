<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object>
	<objectStoreId>${param.storeId}</objectStoreId>
	<offerPriceId><wcf:cdata data="${offerPriceList[0].priceListIdentifier.uniqueID}_${offerPriceList[0].priceEntry[0].qualifier}"/></offerPriceId>
	<priceListId>${offerPriceList[0].priceListIdentifier.uniqueID}</priceListId>
	<qualifier>${offerPriceList[0].priceEntry[0].qualifier}</qualifier>
</object>