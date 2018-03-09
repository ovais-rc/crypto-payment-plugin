<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!doctype HTML>

<%@ include file= "../../../Common/JSTLEnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<c:choose>
	<c:when test = "${empty WCParam.searchTerm && empty WCParam.manufacturer && !WCParam.containsKey('facet_1') && empty WCParam.metaData && empty WCParam.searchSource && WCParam.advancedSearch != '1'}">
		<%-- We are here due to some smart facet navigation and not because of search.. Display categoryNavigation page with filtered out products.. --%>
		<% out.flush(); %>
		<c:import url = "../CategorySubsection/CategoryNavigationDisplay.jsp"/>
		<% out.flush(); %>
	</c:when>
	<c:otherwise>
		<%-- We landed here through some search term. Show results for this search term.. --%>
		<%-- Do not import this page because
			1. SearchResultsDisplay page is not cached
			2. If Search result count == 1, it will redirect to product page directly, in which case we end up with some exceptions
		--%>
		<%@ include file="SearchResultsDisplay.jsp"%>
	</c:otherwise>
</c:choose>