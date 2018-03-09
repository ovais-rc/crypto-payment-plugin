<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="Common/EnvironmentSetup.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<flow:ifEnabled feature="Analytics">
	<wcf:rest var="orderJSONForAn" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
	
	<%@include file="AnalyticsFacetSearch.jspf" %>
    
	<cm:cart orderJSON="${orderJSONForAn}" extraparms="null, ${analyticsFacet}" returnAsJSON="true" />
    
</flow:ifEnabled>
