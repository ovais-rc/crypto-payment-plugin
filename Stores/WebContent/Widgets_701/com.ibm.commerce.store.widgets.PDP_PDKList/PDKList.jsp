<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>



<!-- BEGIN PDKList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/PDKList_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="PDKList_Data.jspf" %>
</c:if>

	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<%@ include file="ext/PDKList_UI.jspf" %>

<c:if test = "${param.custom_view ne 'true'}">
	<c:choose>
			<c:when test="${param.pdksOrientation eq 'vertical'}">

				<%@include file="PDKList_Vertical_UI.jspf"%>
			</c:when>
			<c:otherwise>

				<%@include file="PDKList_Horizontal_UI.jspf"%>
			</c:otherwise>
		</c:choose>
</c:if>

	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<wcpgl:pageLayoutWidgetCache/>
<!-- END PDKList.jsp -->