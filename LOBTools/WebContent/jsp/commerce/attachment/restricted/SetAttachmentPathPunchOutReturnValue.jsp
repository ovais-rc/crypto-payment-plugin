<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="languageObjectType" value="AttachmentAssetWithURLType" scope="request"/>
<c:set var="languageObjectAttributes" scope="request">new="true"</c:set>
<c:set var="languageIdProperty" value="assetLanguageIds" scope="request"/>
<c:set var="punchOutPropertyName" value="path" scope="request"/>
<jsp:include page="/cmc/SetCMSPunchOutReturnValue"/>
