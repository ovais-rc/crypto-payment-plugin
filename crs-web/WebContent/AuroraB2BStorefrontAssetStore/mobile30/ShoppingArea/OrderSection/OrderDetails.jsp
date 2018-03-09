<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP snippet displays the Order details page for a particular order
  *****
--%>

<!-- BEGIN OrderDetails.jsp -->


<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<%-- Required variables for breadcrumb support --%>
<c:set var="accountPageGroup" value="true" scope="request" />
<c:set var="orderDetailsPage" value="true" scope="request" />

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
    <head>
        <title>
            <fmt:message bundle="${storeText}" key="MO_ORDERDETAILS"/>
        </title>
        <meta name="viewport" content="${viewport}" />
        <link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

        <%@ include file="../../include/CommonAssetsForHeader.jspf" %>
    </head> 
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->	

			<%@ include file="../../include/HeaderDisplay.jspf" %>
			
			<% out.flush(); %>
			<c:import url="${env_jspStoreDir}${storeNameDir}Snippets/Order/OrderDetailDisplay.jsp" >
					<c:param name="orderId" value="${WCParam.orderId}"/>
			</c:import>
			<% out.flush();%>			
							
			<%@ include file="../../include/FooterDisplay.jspf" %>						
		</div>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderDetails.jsp -->
