<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<flow:ifEnabled feature="Analytics">
    <%@include file="AnalyticsFacetSearch.jspf" %>
	<cm:pageview pagename="${WCParam.pagename}" category="${WCParam.category}" 
		srchKeyword="${WCParam.searchTerms}" srchResults="${WCParam.searchCount}" 
			returnAsJSON="true" extraparms="${analyticsFacet}" />
</flow:ifEnabled>
