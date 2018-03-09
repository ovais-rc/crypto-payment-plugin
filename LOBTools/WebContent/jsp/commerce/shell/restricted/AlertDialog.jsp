
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% 
	request.setAttribute(
			com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE
			, Boolean.FALSE);
%>

<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.ShellLOB" var="resources" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="alertDialogTitle" bundle="${resources}" /></title>
<style type="text/css">
html { height: 100%; overflow: hidden; }
body { font: 9pt Arial; background-color: #ffffff; margin: 0 0 0 0; padding: 0 0 0 0; word-wrap: break-word; width: expression(this.clientWidth > 100 ? "auto" : "100px"); }
.dialogText { font: 9pt Arial; word-wrap: break-word; }
.dialogButton { color: #375c7a; font-family: Arial; font-size: 9pt; white-space: nowrap; }
</style>
<script type="text/javascript">
<!-- hide script from old browsers
var isIE = document.all ? true : false;
var mouseDown = false;
var buttonStateActive = 0;
var buttonStateHover = 1;
var buttonStateSelected = 2;
var buttonBackgroundLeft = ["${pageContext.request.contextPath}/images/shell/b_active_left.png", "${pageContext.request.contextPath}/images/shell/b_hover_left.png", "${pageContext.request.contextPath}/images/shell/b_pressed_left.png"];
var buttonBackgroundCenter = ["${pageContext.request.contextPath}/images/shell/b_active_center.png", "${pageContext.request.contextPath}/images/shell/b_hover_center.png", "${pageContext.request.contextPath}/images/shell/b_pressed_center.png"];
var buttonBackgroundRight = ["${pageContext.request.contextPath}/images/shell/b_active_right.png", "${pageContext.request.contextPath}/images/shell/b_hover_right.png", "${pageContext.request.contextPath}/images/shell/b_pressed_right.png"];

function getClientWidth () {
	return window.document.documentElement.clientWidth;
}

function getClientHeight () {
	return window.document.documentElement.clientHeight;
}

function getPageWidth () {
	return window.document.body.scrollWidth;
}

function getPageHeight () {
	return window.document.body.scrollHeight;
}

function window_onLoad () {
	if (isIE) {
		var hiddenWidth = getPageWidth() - getClientWidth();
		var hiddenHeight = getPageHeight() - getClientHeight();
		window.dialogWidth = parseInt(window.dialogWidth) + hiddenWidth + "px";
		window.dialogHeight = parseInt(window.dialogHeight) + hiddenHeight + "px";
	}
	else {
		window.sizeToContent();
		document.getElementById("dialogButtonText").focus();
	}
}

function buttonOnMouseOver () {
	setButtonState(mouseDown ? buttonStateSelected : buttonStateHover);
}

function buttonOnMouseOut () {
	setButtonState(buttonStateActive);
}

function buttonOnMouseDown () {
	setButtonState(buttonStateSelected);
}

function buttonOnMouseUp () {
	setButtonState(buttonStateHover);
}

function setButtonState (state) {
	if (isIE) {
		document.all.dialogButtonLeftBorder.background = buttonBackgroundLeft[state];
		document.all.dialogButtonLeftBorder.style.background = "transparent url('" + buttonBackgroundLeft[state] + "') none";
		document.all.dialogButtonLeftBorder.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundLeft[state] + "', sizingMethod='image')";

		document.all.dialogButton.background = buttonBackgroundCenter[state];
		document.all.dialogButton.style.background = "transparent url('" + buttonBackgroundCenter[state] + "') none";
		document.all.dialogButton.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundCenter[state] + "', sizingMethod='scale')";

		document.all.dialogButtonRightBorder.background = buttonBackgroundRight[state];
		document.all.dialogButtonRightBorder.style.background = "transparent url('" + buttonBackgroundRight[state] + "') none";
		document.all.dialogButtonRightBorder.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundRight[state] + "', sizingMethod='image')";
	}
	else {
		document.getElementById("dialogButtonLeftBorder").style.backgroundImage = "url(" + buttonBackgroundLeft[state] + ")";
		document.getElementById("dialogButton").style.backgroundImage = "url(" + buttonBackgroundCenter[state] + ")";
		document.getElementById("dialogButtonRightBorder").style.backgroundImage = "url(" + buttonBackgroundRight[state] + ")";
	}
}

function trapKey (evt) {
	// traps for Enter, ESC and space keys
	if (evt.keyCode == 13 || evt.keyCode == 27 || evt.keyCode == 32) {
		closeWindow();
	}
}

function closeWindow () {
	window.close();
}

document.oncontextmenu = new Function("return false");
//-->
</script>
</head>

<body onload="window_onLoad()" onkeypress="trapKey(event)" onmousedown="javascript:mouseDown=true;" onmouseup="javascript:mouseDown=false;">

<form>
<table border="0" bgColor="#51659d" width="100%" cellpadding="4" cellspacing="0">
	<tr>
		<td>
			<table border="0" bgColor="#5975c6" width="100%" cellpadding="1" cellspacing="0">
				<tr>
					<td>
						<table border="0" bgColor="#ffffff" width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="5" height="10"></td>
							</tr>
							<tr>
								<td width="10"></td>
								<td width="44" height="44" background="${pageContext.request.contextPath}/images/shell/dialog_warning.png" style="background: transparent url('${pageContext.request.contextPath}/images/shell/dialog_warning.png') none; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/dialog_warning.png', sizingMethod='image')" />
								<td width="10"></td>
								<td class="dialogText"><fmt:message key="${param.msgKey}" bundle="${resources}" /></td>
								<td width="10"></td>
							</tr>
							<tr>
								<td colspan="5" height="10"></td>
							</tr>
							<tr>
								<td colspan="5" height="39" align="right" valign="middle" background="${pageContext.request.contextPath}/images/shell/alert_button_area_back.png">
									<table border="0" cellpadding="0" cellspacing="0" height="30">
										<tr>
											<td width="5"></td>
											<td id="dialogButtonLeftBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_left.png" onclick="closeWindow();" onmouseover="buttonOnMouseOver();" onmouseout="buttonOnMouseOut();" onmousedown="buttonOnMouseDown();" onmouseup="buttonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_left.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_left.png', sizingMethod='image')" />
											<td id="dialogButton" class="dialogButton" width="62" height="30" align="center" background="${pageContext.request.contextPath}/images/shell/b_active_center.png" onclick="closeWindow();" onmouseover="buttonOnMouseOver();" onmouseout="buttonOnMouseOut();" onmousedown="buttonOnMouseDown();" onmouseup="buttonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_center.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_center.png', sizingMethod='scale')">
												<table border="0" cellpadding="0" cellspacing="0" width="60" height="13">
													<tr><td id="dialogButtonText" tabindex="1" align="center">
<script>if (isIE) { document.write('<div style="white-space: nowrap;">'); }</script>&nbsp;&nbsp;<fmt:message key="okButton" bundle="${resources}" />&nbsp;&nbsp;<script>if (isIE) { document.write('</div>'); }</script>
													</td></tr>
												</table>
											</td>
											<td id="dialogButtonRightBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_right.png" onclick="closeWindow();" onmouseover="buttonOnMouseOver();" onmouseout="buttonOnMouseOut();" onmousedown="buttonOnMouseDown();" onmouseup="buttonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_right.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_right.png', sizingMethod='image')" />
											<td width="5"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

</body>

</html>
