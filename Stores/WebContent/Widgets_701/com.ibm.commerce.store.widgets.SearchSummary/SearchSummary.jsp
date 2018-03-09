<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SearchSummary.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@include file="/Widgets_701/Common/SearchSetup.jspf"%>

<%@include file="SearchSummary_Data.jspf"%>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
<script>
	dojo.addOnLoad(function(){
		dojo.topic.subscribe("FacetCount_updated", function(data){
			var origSearchCount = data['origSearchCount'];
			var totalSearchCount = data['totalSearchCount'];
			var searchTotalCount = byId('searchTotalCount<c:out value="${widgetSuffix}"/>');
			var suggestedSearchTotalCount = byId('suggestedSearchTotalCount<c:out value="${widgetSuffix}"/>');
			if(searchTotalCount != null) {
				searchTotalCount.innerHTML = '<wcst:message key = "{0}_matches" bundle="${widgetText}"><wcst:param value="' + origSearchCount + '"/></wcst:message>';
			}
			if(suggestedSearchTotalCount != null) {
				suggestedSearchTotalCount.innerHTML = totalSearchCount;
			}
		});
	});
</script>

<%@include file="SearchSummary_UI.jspf"%>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END SearchSummary.jsp -->
