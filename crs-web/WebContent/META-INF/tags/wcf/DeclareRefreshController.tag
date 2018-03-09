<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2007
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//* This tag declares a refresh area controller. The refresh area
//* controller provides the JavaScript logic that will listen to
//* changes in the render context and the model and refresh the
//* refresh areas registered to the controller. Refresh areas are declared
//* using the wc.widget.RefreshArea widget and specifying the ID
//* of a declared refresh controller for the "controllerId" attribute.
%><%@
	tag body-content="empty" %><%@
	attribute name="id" required="true"	description="
		Refresh controller ID." %><%@
	attribute name="renderContextId" description="
		The render context ID. If the render context ID is not specified, then &quot;default&quot; will
		be assumed." %><%@
	attribute name="url" required="true" description="
		The URL that will be invoked to retrieve the refresh data."%><%@
	attribute name="formId"	description="
		The element ID of the form that is to be submitted to retrieve the refresh data." %><%@
	attribute name="modelChangedScript" fragment="true" description="
		JavaScript that is to be executed when a model change occurs.
		The script may make use of several local variables:
		controller - the refresh controller,
		message - the model changed event message,
		widget - the refresh area widget,
		renderContext - the render context" %><%@
	attribute name="renderContextChangedScript" fragment="true" description="
		JavaScript that is to be executed when a render context change occurs.
		The script may make use of several local variables:
		controller - the refresh controller,
		message - the render context changed event message,
		widget - the refresh area widget,
		renderContext - the render context" %><%@
	attribute name="json" description="
		This attribute should be set to &quot;true&quot; if the
		expected response type from the refresh URL is JSON. If this
		attribute is not specified, then the expected response type
		is HTML." %><%@
	attribute name="refreshScript" fragment="true" description="
		JavaScript that is to be executed to perform the refresh.
		The script may make use of the following local variables:
		controller - the refresh controller,
		widget - the refresh area widget,
		data - the refresh request response data,
		renderContext - the render context.
		If this attribute is not specified, then the default behaviour
		is to call &quot;widget.setInnerHtml(data)&quot;." %><%@
	attribute name="postRefreshScript" fragment="true" description="
		JavaScript that is to be executed after the refresh has completed.
		The script may make use of several local variables:
		controller - the refresh controller,
		widget - the refresh area widget,
		renderContext - the render context." %><%@
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<script type="text/javascript">
<!-- <![CDATA[
dojo.require("wc.render.*");
wc.render.declareRefreshController({
	id: "${id}",
	renderContext: wc.render.getContextById("${renderContextId == null ? "default" : renderContextId}"),
	url: "${url}",
	formId: "${formId}"
<c:if test="${json}">
	,mimetype: "text/json"
</c:if><c:if test="${modelChangedScript != null}">
	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		<jsp:invoke fragment="modelChangedScript"/>
	}
</c:if><c:if test="${renderContextChangedScript != null}">
	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		<jsp:invoke fragment="renderContextChangedScript"/>
	}
</c:if><c:if test="${refreshScript != null}">
	,refreshHandler: function(widget, data) {
		var controller = this;
		var renderContext = this.renderContext;
		<jsp:invoke fragment="refreshScript"/>
	}
</c:if><c:if test="${postRefreshScript != null}">
	,postRefreshHandler: function(widget) {
		var controller = this;
		var renderContext = this.renderContext;
		<jsp:invoke fragment="postRefreshScript"/>
	}
</c:if>
});
//[[>-->
</script>
