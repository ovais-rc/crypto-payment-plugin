
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.

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
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.FoundationLOB" var="resources" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="rightToLeftInputDialogTitle" bundle="${resources}" /></title>
<style type="text/css">
html { height: 100%; overflow: hidden; }
body { font: 9pt Arial; background-color: #ffffff; margin: 0 0 0 0; padding: 0 0 0 0; word-wrap: break-word; width: expression(this.clientWidth > 100 ? "auto" : "100px"); }
.dialogText { font: 9pt Arial; word-wrap: break-word; }
.dialogButton { color: #375c7a; font-family: Arial; font-size: 9pt; white-space: nowrap; }
.dialogInput { font: 9pt Arial; border-width: 1px; width: 450px; height: 82px; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/shell/ManagementCenter.js"></script>
<script type="text/javascript">
<!-- hide script from old browsers
var isIE = document.all ? true : false;
var mouseDown = false;
var okButtonStateActive = 0;
var okButtonStateHover = 1;
var okButtonStateSelected = 2;
var cancelButtonStateActive = 0;
var cancelButtonStateHover = 1;
var cancelButtonStateSelected = 2;
var buttonBackgroundLeft = ["${pageContext.request.contextPath}/images/shell/b_active_left.png", "${pageContext.request.contextPath}/images/shell/b_hover_left.png", "${pageContext.request.contextPath}/images/shell/b_pressed_left.png"];
var buttonBackgroundCenter = ["${pageContext.request.contextPath}/images/shell/b_active_center.png", "${pageContext.request.contextPath}/images/shell/b_hover_center.png", "${pageContext.request.contextPath}/images/shell/b_pressed_center.png"];
var buttonBackgroundRight = ["${pageContext.request.contextPath}/images/shell/b_active_right.png", "${pageContext.request.contextPath}/images/shell/b_hover_right.png", "${pageContext.request.contextPath}/images/shell/b_pressed_right.png"];
var currentFocus = "";

function okButtonOnMouseOver () {
	setOkButtonState(mouseDown ? okButtonStateSelected : okButtonStateHover);
}

function okButtonOnMouseOut () {
	setOkButtonState(okButtonStateActive);
}

function okButtonOnMouseDown () {
	setOkButtonState(okButtonStateSelected);
}

function okButtonOnMouseUp () {
	setOkButtonState(okButtonStateHover);
}

function setOkButtonState (state) {
	if (isIE) {
		document.getElementById("okButtonLeftBorder").background = buttonBackgroundLeft[state];
		document.getElementById("okButtonLeftBorder").style.background = "transparent url('" + buttonBackgroundLeft[state] + "') none";
		document.getElementById("okButtonLeftBorder").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundLeft[state] + "', sizingMethod='image')";

		document.getElementById("okButton").background = buttonBackgroundCenter[state];
		document.getElementById("okButton").style.background = "transparent url('" + buttonBackgroundCenter[state] + "') none";
		document.getElementById("okButton").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundCenter[state] + "', sizingMethod='scale')";

		document.getElementById("okButtonRightBorder").background = buttonBackgroundRight[state];
		document.getElementById("okButtonRightBorder").style.background = "transparent url('" + buttonBackgroundRight[state] + "') none";
		document.getElementById("okButtonRightBorder").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundRight[state] + "', sizingMethod='image')";
	}
	else {
		document.getElementById("okButtonLeftBorder").style.backgroundImage = "url(" + buttonBackgroundLeft[state] + ")";
		document.getElementById("okButton").style.backgroundImage = "url(" + buttonBackgroundCenter[state] + ")";
		document.getElementById("okButtonRightBorder").style.backgroundImage = "url(" + buttonBackgroundRight[state] + ")";
	}
}

function cancelButtonOnMouseOver () {
	setCancelButtonState(mouseDown ? cancelButtonStateSelected : cancelButtonStateHover);
}

function cancelButtonOnMouseOut () {
	setCancelButtonState(cancelButtonStateActive);
}

function cancelButtonOnMouseDown () {
	setCancelButtonState(cancelButtonStateSelected);
}

function cancelButtonOnMouseUp () {
	setCancelButtonState(cancelButtonStateHover);
}

function setCancelButtonState (state) {
	if (isIE) {
		document.getElementById("cancelButtonLeftBorder").background = buttonBackgroundLeft[state];
		document.getElementById("cancelButtonLeftBorder").style.background = "transparent url('" + buttonBackgroundLeft[state] + "') none";
		document.getElementById("cancelButtonLeftBorder").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundLeft[state] + "', sizingMethod='image')";

		document.getElementById("cancelButton").background = buttonBackgroundCenter[state];
		document.getElementById("cancelButton").style.background = "transparent url('" + buttonBackgroundCenter[state] + "') none";
		document.getElementById("cancelButton").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundCenter[state] + "', sizingMethod='scale')";

		document.getElementById("cancelButtonRightBorder").background = buttonBackgroundRight[state];
		document.getElementById("cancelButtonRightBorder").style.background = "transparent url('" + buttonBackgroundRight[state] + "') none";
		document.getElementById("cancelButtonRightBorder").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='" + buttonBackgroundRight[state] + "', sizingMethod='image')";
	}
	else {
		document.getElementById("cancelButtonLeftBorder").style.backgroundImage = "url(" + buttonBackgroundLeft[state] + ")";
		document.getElementById("cancelButton").style.backgroundImage = "url(" + buttonBackgroundCenter[state] + ")";
		document.getElementById("cancelButtonRightBorder").style.backgroundImage = "url(" + buttonBackgroundRight[state] + ")";
	}
}

function trapKey (evt) {
	var keyCode = evt.charCode ? evt.charCode : evt.keyCode;
	if (keyCode == 27) {
		closeWindow();
	}
	else if (keyCode == 13 || keyCode == 32) {
		if (currentFocus == "ok") {
			sendBackValue();
		}
		else if (currentFocus == "cancel") {
			closeWindow();
		}
	}
}

function sendBackValue () {
	window.returnValue = trim(document.getElementById("inputTextField").value);
	closeWindow();
}

function closeWindow () {
	window.close();
}

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

function getTextDirection (text) {
	var fdc = /[A-Za-z\u05d0-\u065f\u066a-\u06ef\u06fa-\u07ff\ufb1d-\ufdff\ufe70-\ufefc]/.exec(text);
	return fdc ? ( fdc[0] <= 'z' ? "ltr" : "rtl" ) : document.dir;	
}

function handleKeyUp () {
	var field = document.getElementById("inputTextField");
	if (field.isContextual) {
		if (field.dir !== field.oldDir) {
			field.isContextual = false;
		}
		else {
			field.dir = getTextDirection(field.value);
			field.oldDir = field.dir;
		}
	}
}

function window_onLoad () {
	// initialize the label and value for the input text field
	document.getElementById("inputTextPrompt").innerHTML = window.dialogArguments.inputTextPrompt;
	var field = document.getElementById("inputTextField");
	var value = "";
	if (window.dialogArguments.inputTextValue != null && window.dialogArguments.inputTextValue != "null") {
		field.value = window.dialogArguments.inputTextValue;
		value = field.value;
	}	
	field.dir = getTextDirection(value);
	field.oldDir = field.dir;
	field.isContextual = true;
	if (field.addEventListener) {
		field.addEventListener("keyup", handleKeyUp, false);
	}
	else {
		field.attachEvent("onkeyup", handleKeyUp);
	}

	// set default focus to the input text field
	document.getElementById("inputTextField").focus();

	// resize the window to fit the content in this dialog
	if (isIE) {
		var hiddenWidth = getPageWidth() - getClientWidth();
		var hiddenHeight = getPageHeight() - getClientHeight();
		window.dialogWidth = parseInt(window.dialogWidth) + hiddenWidth + "px";
		window.dialogHeight = parseInt(window.dialogHeight) + hiddenHeight + "px";
	}
	else {
		window.sizeToContent();
	}
}

document.oncontextmenu = new Function("return false");
//-->
</script>
</head>

<body onload="window_onLoad()" onkeypress="trapKey(event)" onmousedown="javascript:mouseDown=true;" onmouseup="javascript:mouseDown=false;">

<table border="0" bgColor="#51659d" width="100%" cellpadding="4" cellspacing="0">
	<tr>
		<td>
			<table border="0" bgColor="#5975c6" width="100%" cellpadding="1" cellspacing="0">
				<tr>
					<td>
						<table border="0" bgColor="#ffffff" width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<table border="0" cellpadding="0" cellspacing="10">
										<tr>
											<td id="inputTextPrompt" class="dialogText"><label for="inputTextField"></label></td>
										</tr>
										<tr>
											<td><textarea id="inputTextField" class="dialogInput" tabindex="1" onfocus="currentFocus = '';"></textarea></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="39" align="right" valign="middle" background="${pageContext.request.contextPath}/images/shell/alert_button_area_back.png">
									<table border="0" cellpadding="0" cellspacing="0" height="30">
										<tr>
											<td width="5"></td>
											<td id="okButtonLeftBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_left.png" onclick="sendBackValue();" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_left.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_left.png', sizingMethod='image')" />
											<td id="okButton" class="dialogButton" width="62" height="30" align="center" background="${pageContext.request.contextPath}/images/shell/b_active_center.png" onclick="sendBackValue();" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_center.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_center.png', sizingMethod='scale')">
												<table border="0" cellpadding="0" cellspacing="0" width="60" height="13">
													<tr><td id="okButtonText" tabindex="2" align="center" onfocus="currentFocus='ok';">
<script>if (isIE) { document.write('<div style="white-space: nowrap;">'); }</script>&nbsp;&nbsp;<fmt:message key="simpleDialogOK" bundle="${resources}" />&nbsp;&nbsp;<script>if (isIE) { document.write('</div>'); }</script>
													</td></tr>
												</table>
											</td>
											<td id="okButtonRightBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_right.png" onclick="sendBackValue();" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_right.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_right.png', sizingMethod='image')" />
											<td width="5"></td>
											<td id="cancelButtonLeftBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_left.png" onclick="closeWindow();" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_left.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_left.png', sizingMethod='image')" />
											<td id="cancelButton" class="dialogButton" width="62" height="30" align="center" background="${pageContext.request.contextPath}/images/shell/b_active_center.png" onclick="closeWindow();" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_center.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_center.png', sizingMethod='scale')">
												<table border="0" cellpadding="0" cellspacing="0" width="60" height="13">
													<tr><td id="cancelButtonText" tabindex="3" align="center" onfocus="currentFocus='cancel';">
<script>if (isIE) { document.write('<div style="white-space: nowrap;">'); }</script>&nbsp;&nbsp;<fmt:message key="simpleDialogCancel" bundle="${resources}" />&nbsp;&nbsp;<script>if (isIE) { document.write('</div>'); }</script>
													</td></tr>
												</table>
											</td>
											<td id="cancelButtonRightBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_right.png" onclick="closeWindow();" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_right.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_right.png', sizingMethod='image')" />
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

</body>

</html>
