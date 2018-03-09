<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN Footer.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<c:if test="${WCParam.omitHeader != 1}">
	<%@ include file="ext/Footer_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="Footer_Data.jspf" %>
	</c:if>

	<%@ include file="ext/Footer_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true' && _worklightHybridApp ne 'true'}">
		<%@ include file="Footer_UI.jspf" %>
	</c:if>
</c:if>
<%@ include file="../../Common/PageExt.jspf" %>

<c:if test = "${_worklightHybridApp eq 'true'}">
    <%@ include file="../../WorklightHybrid/WorklightHybridSetup.jspf" %>
</c:if>

<%--
	Display the Coremetrics tags at the bottom of the store page for debugging purposes.
	The tags are displayed only if the 'debug' attribute is set to true in the config file.
--%>
<flow:ifEnabled feature="Analytics">
	<div id="cm-tag-output">
		<div id="cm-pageview"></div>
		<div id="cm-productview"></div>
		<div id="cm-shopAction"></div>
		<div id="cm-order"></div>
		<div id="cm-registration"></div>
		<div id="cm-element"></div>
		<div id="cm-conversionevent"></div>
	</div>
</flow:ifEnabled>
<!-- END Footer.jsp -->
