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
//* This tag adds the client side render context support to the current
//* page.
//* The ID passed to the this tag will be used to identify the render
//* context.
//* If this tag has already been called for this request and id,
//* then it will do nothing.
%><%@
	tag body-content="empty" %><%@
	attribute name="id" description="
		Render context ID. If not specified, the render context will be
		declared using &quot;default&quot; as the render context ID." %><%@
	attribute name="local" description="
		This attribute should be set to &quot;true&quot; if the render context
		does not need to be synchronized with the server. If not specified,
		then this attribute is assumed to be &quot;false&quot;." %><%@
	attribute name="url" description="
		URL that is used to update the render context." %><%@
	attribute name="properties" fragment="true" description="
		JavaScript Object that contains the initial render context properties.
		The attribute should only be specified for a local render context." %><%@
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<c:choose><c:when test="${id==null}">
<c:set var="renderContextId" value="default"/>
</c:when><c:otherwise>
<c:set var="renderContextId" value="${id}"/>
</c:otherwise></c:choose>

<jsp:useBean id="declared_render_contexts" class="java.util.HashMap" scope="request"/>
<c:if test="${!declared_render_contexts[renderContextId]}">
<c:set target="${declared_render_contexts}" property="${renderContextId}" value="true"/>
<wcf:defineObjects/>

<script type="text/javascript">
<!-- <![CDATA[
dojo.require("wc.render.*");
wc.render.declareContext(
	"${renderContextId}",
<c:choose><c:when test="${properties != null}">
	<jsp:invoke fragment="properties"/>,
</c:when><c:otherwise>
	<wcf:json object="${renderContextValues}"/>,
</c:otherwise></c:choose>
	"${url}");
//[[>-->
</script>

</c:if>
