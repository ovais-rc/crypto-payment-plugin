<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the store map page.
  *****
--%>

<!-- BEGIN StoreMap.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MSTMP_TITLE">
				<fmt:param value="${storeName}" />
			</fmt:message>
		</title>
		
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

		<%@ include file="../include/CommonAssetsForHeader.jspf" %>
	</head>
	
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
		
			<%@ include file="../include/HeaderDisplay.jspf" %>
			
			<% out.flush(); %>
				<c:import url="${env_jspStoreDir}${storeNameDir}Snippets/StoreLocator/StoreInfo.jsp">
					<c:param name="storeId" value="${WCParam.storeId}" />
					<c:param name="infoType" value="Map" />
					<c:param name="storeListIndex" value="${WCParam.storeListIndex}"/>
					<c:param name="geoNodeId" value="${WCParam.geoNodeId}"/>
					<c:param name="geoCodeLatitude" value="${WCParam.geoCodeLatitude}" />
					<c:param name="geoCodeLongitude" value="${WCParam.geoCodeLongitude}" />
					<c:param name="physicalStoreId" value="${WCParam.physicalStoreId}" />
					<c:param name="page" value="${WCParam.page}"/>
					<c:param name="recordSetReferenceId" value="${WCParam.recordSetReferenceId}"/>
					<c:param name="storeAvailPage" value="${WCParam.storeAvailPage}"/>
					<c:param name="prevPage" value="${WCParam.prevPage}" />
				</c:import>
			<% out.flush(); %>
				
			<%@ include file="../include/FooterDisplay.jspf" %>	
		</div>
	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END StoreMap.jsp -->
