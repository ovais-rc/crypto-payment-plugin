<!DOCTYPE html>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<fmt:setLocale value="${CommandContext.locale}"/>
<fmt:setBundle basename="com.ibm.commerce.stores.preview.properties.StorePreviewer"/>

<c:choose>
	<c:when test="${CommandContext.locale eq 'iw_IL'}">
		<c:set var="shortLocale" value="he" />
	</c:when>
	<c:otherwise>
		<c:set var="shortLocale"
			value="${fn:substring(CommandContext.locale,0,2)}" />
	</c:otherwise>
</c:choose>

<wcst:alias name="ConfigProperties" var="ConfigProperties" />
<wcst:mapper source="ConfigProperties" method="getValue" var="configValueMap" />
<wcst:alias name="StoreModuleName" var="storeModuleName" />
<c:if test="${empty  env_webAlias}">
	<c:set var="env_webAlias" value="${configWebModuleMap[storeModuleName].webAlias}"/>
</c:if>

<html lang="${shortLocale}">
	<head>
		<title><fmt:message key="enterPasswordDialogTitle"/></title>
		<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;">
		<c:choose>
			<c:when test="${CommandContext.locale == 'iw_IL' || CommandContext.locale == 'ar_EG'}">
				<link rel="stylesheet" type="text/css" href="${staticIBMAssetAliasRoot}/tools/preview/css/store_preview_bidi.css"></link>
			</c:when>
			<c:otherwise>
				<link rel="stylesheet" type="text/css" href="${staticIBMAssetAliasRoot}/tools/preview/css/store_preview.css"></link>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			// Below is from MDS
			function buttonHover(ele, ele2) {
				var srcElement = document.getElementById(ele);
				var srcElement2 = document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 -21px';
				srcElement2.style.backgroundPosition = '-7px 0';
			}
			function buttonHoverOff(ele, ele2) {
				var srcElement = document.getElementById(ele);
				var srcElement2 = document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 0';
				srcElement2.style.backgroundPosition = '0 0';
			}
			function buttonActive(ele, ele2) {
				var srcElement = document.getElementById(ele);
				var srcElement2 = document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 -42px';
				srcElement2.style.backgroundPosition = '-14px 0';
			}
			function buttonActiveOff(ele, ele2) {
				var srcElement = document.getElementById(ele);
				var srcElement2 = document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 0';
				srcElement2.style.backgroundPosition = '0 0';
			}
		</script>
		
	</head>
	<body>
		<div role="main">
			<div id="enterPasswordDialog" class="store_preview_dialog_window" role="dialog" aria-labelledby="enterPasswordDialogTitle">
				<div class="sp_header_top">
					<div id="enterPasswordDialogTitle" class="sp_header"><fmt:message key="enterPasswordDialogTitle"/></div>
					<div class="sp_whitespace_background">
						<div class="sp_content_container">
							<c:if test="${param.password != null}">
								<div class="sp_errorMessageContainer" role="alert" aria-labelledby="errorMessage">
									<img src='<c:out value='${staticIBMAssetAliasRoot}'/>/images/preview/error.png'/>
									<span id="errorMessage" class="sp_red"><fmt:message key="enterPasswordDialogPasswordIncorrectMessage"/></span><br/>
								</div>
							</c:if>
							<form id="passwordForm" class="password" action="" method="post">
								<label for="password"><fmt:message key="enterPasswordDialogPrompt"/></label><br/>
								<input id="password" name="password" type="password"></input>
							</form>
						</div>
						<div class="sp_optionsContainer"> 
							<div class="sp_rightContainer">								
								<a id="submitButton" class="sp_light_button" href="#" onclick="document.getElementById('passwordForm').submit()" role="button" aria-labelledby="submitButtonLabel"
									onmouseup="buttonActiveOff('submitButtonLabel','submitButtonLabelRight')"
									onmousedown="buttonActive('submitButtonLabel','submitButtonLabelRight')"
									onmouseout="buttonHoverOff('submitButtonLabel','submitButtonLabelRight')"
									onmouseover="buttonHover('submitButtonLabel','submitButtonLabelRight')">								
									<div id="submitButtonLabel" style='background-position: 0px 0px;' class="sp_button_text"><fmt:message key="enterPasswordDialogSubmitButtonLabel"/></div>
									<div id="submitButtonLabelRight" style='background-position: 0px 0px;' class="sp_button_right"></div>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
