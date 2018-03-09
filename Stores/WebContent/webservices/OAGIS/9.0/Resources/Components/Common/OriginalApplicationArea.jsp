<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:if test="${!empty RequestProperties['ApplicationArea/BODID']}">
	<oa:OriginalApplicationArea>
		<oa:CreationDateTime><c:out value="${RequestProperties['ApplicationArea/CreationDateTime']}"/></oa:CreationDateTime>
		<oa:BODID><c:out value="${RequestProperties['ApplicationArea/BODID']}"/></oa:BODID>
	</oa:OriginalApplicationArea>
</c:if>