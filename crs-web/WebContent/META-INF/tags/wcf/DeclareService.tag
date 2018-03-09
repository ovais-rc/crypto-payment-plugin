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
//* This tag adds client side support for invoking a service request.
//* The ID will be used to register the specified service so it can be
//* invoked with the wc.service.invoke(serviceId, parameters) function.
//* The parameters parameter is an object map that will be passed as
//* parameters to the service URL.
%><%@
	tag body-content="empty"%><%@
	attribute name="id" required="true"
	description="Service ID."%><%@
	attribute name="actionId" required="true" description="
		The action identifier used to uniquely identify the action
		performed by this service."%><%@
	attribute name="url" required="true" description="
		The URL that will process this service."%><%@
	attribute name="formId"	description="
		The element ID of the form that is to be submitted to this service." %><%@
	attribute name="validateParametersScript" fragment="true" description="
		JavaScript that is used to validate the parameters that are being passed
		to this request. The script may make use of the local variable
		&quot;parameters&quot; which is the Object map of parameters that
		were passed to the service. The script must also update a local
		variable called &quot;valid&quot; to &quot;false&quot; to indicate
		that the request should be terminated. If this attribute is not specified
		then the parameters are always considered to be valid." %><%@
	attribute name="validateFormScript" fragment="true"	description="
		JavaScript that is used to validate the form that is specified by
		the &quot;formId&quot;. The script may make use of the local variable
		&quot;formNode&quot; which is the form node extracted from the document.
		The script must also update a local variable called &quot;valid&quot;
		to &quot;false&quot; to indicate that the request should be terminated.
		If this attribute is not specified, then the form is always considered
		to be valid." %><%@
	attribute name="successTestScript" fragment="true" description="
		JavaScript that is used to examine the service response object to determine
		if the request was successful or not. The script may make use of the local
		variable &quot;serviceResponse&quot; which is the service response object.
		The script must also update a local variable called &quot;success&quot; to
		&quot;false&quot; to indicate that the request was not successful. This result will
		determine if the success handler or the failure handler will be invoked.
		If this attribute is not specified, then the service response Object will
		be tested to see if there is a property called &quot;errorCode&quot;. If the
		&quot;errorCode&quot; property exists, then the service request will be treated
		as a failed request." %><%@
	attribute name="successHandlerScript" fragment="true" description="
		JavaScript that is to be executed after the successful invocation of the service request.
		The script may make use of the local variable &quot;serviceResponse&quot; which is an Object
		that contains the service response map." %><%@
	attribute name="failureHandlerScript" fragment="true" description="
		JavaScript that is to be executed after a failed invocation of the service request.
		The script may make use of the local variable &quot;serviceResponse&quot; which is an Object
		that contains the service response map."%><%@
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<script type="text/javascript">
<!-- <![CDATA[
dojo.require("wc.service.*");
wc.service.declare({
	id: "${id}",
	actionId: "${actionId}",
	url: "${url}",
	formId: "${formId}"
<c:if test="${validateParametersScript != null}">
	,validateParameters: function (parameters) {
		var valid = true;
		<jsp:invoke fragment="validateParametersScript"/>
		return valid;
	}
</c:if><c:if test="${validateFormScript != null}">
	,validateForm: function (parameters) {
		var valid = true;
		<jsp:invoke fragment="validateFormScript"/>
		return valid;
	}
</c:if><c:if test="${successTestScript != null}">
	,successTest: function(serviceResponse) {
		boolean success = true;
		<jsp:invoke fragment="successTestScript"/>
		return success;
	}
</c:if><c:if test="${successHandlerScript != null}">
	,successHandler: function(serviceResponse) {
		<jsp:invoke fragment="successHandlerScript"/>
	}
</c:if><c:if test="${failureHandlerScript != null}">
	,failureHandler: function(serviceResponse) {
		<jsp:invoke fragment="failureHandlerScript"/>
	}
</c:if>
});
//[[>-->
</script>

