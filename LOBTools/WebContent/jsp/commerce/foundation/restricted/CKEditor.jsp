
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<fmt:setLocale value="${param.locale}"/>
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.FoundationLOB" var="resources" />
<!DOCTYPE html>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="${fn:substring(param.locale, 0, 2)}" xml:lang="${fn:substring(param.locale, 0, 2)}">

<head>
<title><fmt:message key="CKEditorTitle" bundle="${resources}" /></title>
<style type="text/css">

.dialogText { font: 9pt Arial; word-wrap: break-word; }
.dialogButton { color: #375c7a; font-family: Arial; font-size: 9pt; white-space: nowrap; }

</style>
<script>
	var contentLocale = window.dialogArguments.contentLocale;
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/ckeditor/ckeditor.js"></script>

<script type="text/javascript">
	var tags = window.dialogArguments.CKEditorSubstitutionTags == null ? {} : window.dialogArguments.CKEditorSubstitutionTags;
	var editorLocale = window.dialogArguments.editorLocale;
	var css = "";
	var cssLocales = ""
	if (window.dialogArguments.storeCSSURL != null) {
		css = window.dialogArguments.storeUriPrefix + window.dialogArguments.storeCSSURL;
		if (window.dialogArguments.storeCSSLocales != null) {
			cssLocales = window.dialogArguments.storeCSSLocales;
			if (cssLocales.indexOf(contentLocale) >= 0) {
				css = css.replace("$locale$", contentLocale);
			} else {
				css = css.replace("$locale$", "");
			}
		}
	}

	window.onload = function() {
		CKEDITOR.stylesSet.add('IBM_CMC_style', []);
		// Workaround from CKEditor to fix IE cursor problem when mouse pointer is clicked on white space
		CKEDITOR.on( 'instanceCreated', function( ev ) {
			var editor = ev.editor;
			
			editor.on( 'contentDom', function() {
				var doc = editor.document,
					outerDoc = CKEDITOR.document,
					editable = editor.editable(),
					body = doc.getBody(),
					html = doc.getDocumentElement();

				var isInline = editable.isInline();

				// The following selection related fixes applies to only framed editable.
				if ( CKEDITOR.env.ie && !isInline ) {
					
					// When content doc is in standards mode, IE doesn't focus the editor when
					// clicking at the region below body (on html element) content, we emulate
					// the normal behavior on old IEs. (#1659, #7932)
					if ( doc.$.compatMode != 'BackCompat' ) {
						if ( CKEDITOR.env.ie ) {
							function moveRangeToPoint( range, x, y ) {
								// Error prune in IE7. (#9034, #9110)
								try { range.moveToPoint( x, y ); } catch ( e ) {}
							}

							html.on( 'mousedown', function( evt ) {
								evt = evt.data;

								// Expand the text range along with mouse move.
								function onHover( evt ) {
									evt = evt.data.$;
									if ( textRng ) {
										// Read the current cursor.
										var rngEnd = body.$.createTextRange();

										moveRangeToPoint( rngEnd, evt.x, evt.y );

										// Handle drag directions.
										textRng.setEndPoint(
											startRng.compareEndPoints( 'StartToStart', rngEnd ) < 0 ?
											'EndToEnd' : 'StartToStart', rngEnd );

										// Update selection with new range.
										textRng.select();
									}
								}

								function removeListeners() {
									outerDoc.removeListener( 'mouseup', onSelectEnd );
									html.removeListener( 'mouseup', onSelectEnd );
								}

								function onSelectEnd() {

									html.removeListener( 'mousemove', onHover );
									removeListeners();

									// Make it in effect on mouse up. (#9022)
									textRng.select();
								}


								// We're sure that the click happens at the region
								// below body, but not on scrollbar.
								if ( evt.getTarget().is( 'html' ) &&
										 evt.$.y < html.$.clientHeight &&
										 evt.$.x < html.$.clientWidth ) {
									// Start to build the text range.
									var textRng = body.$.createTextRange();
									moveRangeToPoint( textRng, evt.$.x, evt.$.y );

									// Records the dragging start of the above text range.
									var startRng = textRng.duplicate();

									html.on( 'mousemove', onHover );
									outerDoc.on( 'mouseup', onSelectEnd );
									html.on( 'mouseup', onSelectEnd );
								}
							});
						}

					}
				}

			});
		});
		var editor = CKEDITOR.replace( 'inputTextField',
		{
			language : editorLocale,
			width: 798,
			height : 555,
			toolbar: 'IBM_CMC_Toolbar',
			contentsCss: [css ,'/lobtools/css/ckeditor/custom.css'],
			fillEmptyBlocks : false,
			toolbar_IBM_CMC_Toolbar: 
				[
					{ name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
					{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
					{ name: 'editing', items : [ 'Find','-','SelectAll','-','IbmSpellChecker','Scayt' ] },
					'/',
					{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
					{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
					'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
					{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
					{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','SpecialChar'] },
					'/',
					{ name: 'styles', items : [ 'Format','Font','FontSize' ] },
					{ name: 'colors', items : [ 'TextColor','BGColor' ] },
					{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] }
				],
			stylesSet: 'IBM_CMC_style',
			on :
			{
				instanceReady: function(evt)
				{
					// Output paragraphs as <p>Text</p>.
					this.dataProcessor.writer.setRules( 'p',
						{
							indent : false,
							breakBeforeOpen : false,
							breakAfterOpen : false,
							breakBeforeClose : false,
							breakAfterClose : false
						});
					var text = window.dialogArguments.inputTextValue;
					if (window.dialogArguments.inputTextValue == "null" || window.dialogArguments.inputTextValue == null){
						CKEDITOR.instances.inputTextField.setData("");
					} else {
						CKEDITOR.instances.inputTextField.setData(preProcess(text));
					}
					resizeWindows();
				}
			}
		});
	};

</script>

<script type="text/javascript">
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
var setEditorHeightTimeoutId;

function preProcess(data) {
	for (var key in tags) {
		if (data.indexOf(key) != -1) {
			var re = new RegExp(key.replace("[", "\\[").replace("]", "\\]"), "g");
			data = data.replace(re, tags[key]);
		}
	}
	return data;
}

function postProcess(data) {
	for (var key in tags) {
		if (data.indexOf(tags[key]) != -1) {
			var re = new RegExp(tags[key], "g");
			data = data.replace(re, key);
		}
	}
	return data;
}

function setEditorHeight() {

	var height = window.innerHeight || document.documentElement.clientHeight;
	var width = window.innerWidth || document.documentElement.clientWidth;
	if (isIE) {
		CKEDITOR.instances.inputTextField.resize(width-2, height - 41);
	} else {
		CKEDITOR.instances.inputTextField.resize(width-2, height - 41);
	}
}

function okButtonOnMouseOver() {
	setOkButtonState(mouseDown ? okButtonStateSelected : okButtonStateHover);
}

function okButtonOnMouseOut() {
	setOkButtonState(okButtonStateActive);
}

function okButtonOnMouseDown() {
	setOkButtonState(okButtonStateSelected);
}

function okButtonOnMouseUp() {
	setOkButtonState(okButtonStateHover);
}

function setOkButtonState(state) {
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
	} else {
		document.getElementById("okButtonLeftBorder").style.backgroundImage = "url(" + buttonBackgroundLeft[state] + ")";
		document.getElementById("okButton").style.backgroundImage = "url(" + buttonBackgroundCenter[state] + ")";
		document.getElementById("okButtonRightBorder").style.backgroundImage = "url(" + buttonBackgroundRight[state] + ")";
	}
}

function cancelButtonOnMouseOver() {
	setCancelButtonState(mouseDown ? cancelButtonStateSelected : cancelButtonStateHover);
}

function cancelButtonOnMouseOut() {
	setCancelButtonState(cancelButtonStateActive);
}

function cancelButtonOnMouseDown() {
	setCancelButtonState(cancelButtonStateSelected);
}

function cancelButtonOnMouseUp() {
	setCancelButtonState(cancelButtonStateHover);
}

function setCancelButtonState(state) {
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

function trapKey(evt) {
	var keyCode = evt.charCode ? evt.charCode : evt.keyCode;
}

function closeWindow() {
	window.close();
}

function sendBackValue() {
	var text = CKEDITOR.instances.inputTextField.getData();
	window.returnValue = postProcess(text);
	closeWindow();
}

function resizeWindows() {
	clearTimeout(setEditorHeightTimeoutId);
	setEditorHeightTimeoutId = setTimeout(setEditorHeight, 10);
}

</script>
</head>
<body onkeypress="trapKey(event)" onmousedown="javascript:mouseDown=true;" onmouseup="javascript:mouseDown=false;" onresize="resizeWindows();" style="margin:0;padding:0;" role="main">

	<table border="0" bgColor="#51659d" cellpadding="0" cellspacing="0" style="height: 100%; width:100%" role="presentation">
		<tr>
			<td>
				<table border="0" bgColor="#5975c6" width="100%" cellpadding="1" cellspacing="0" role="presentation">
					<tr>
						<td>
							<table border="0" bgColor="#ffffff" cellpadding="0" cellspacing="0" style="width:auto;" role="presentation">
								<tr>
									<td>
										<table border="0" cellpadding="0" cellspacing="0" role="presentation">
											<tr>
												<td>
													<textarea id="inputTextField" name="inputTextField"></textarea>
												</td>	
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td height="39" align="right" valign="middle" background="${pageContext.request.contextPath}/images/shell/alert_button_area_back.png">
										<table border="0" cellpadding="0" cellspacing="0" height="30" role="presentation">
											<tr>
												<td width="5"></td>
												<td id="okButtonLeftBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_left.png" onclick="sendBackValue();" onkeydown="if (event.keyCode == 13) {sendBackValue();}" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_left.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_left.png', sizingMethod='image')" />
												<td role="button" aria-labelledby="okButtonText" id="okButton" class="dialogButton" width="62" height="30" align="center" background="${pageContext.request.contextPath}/images/shell/b_active_center.png" onclick="sendBackValue();" onkeydown="if (event.keyCode == 13) {sendBackValue();}" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_center.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_center.png', sizingMethod='scale')">
													<table border="0" cellpadding="0" cellspacing="0" width="60" height="13" role="presentation">
														<tr><td id="okButtonText" tabindex="0" align="center">
															<script>if (isIE) { document.write('<div style="white-space: nowrap;">'); }</script>
															<fmt:message key="simpleDialogOK" bundle="${resources}" />
															<script>if (isIE) { document.write('</div>'); }</script>
														</td></tr>
													</table>
												</td>
												<td id="okButtonRightBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_right.png" onclick="sendBackValue();" onkeydown="if (event.keyCode == 13) {sendBackValue();}" onmouseover="okButtonOnMouseOver();" onmouseout="okButtonOnMouseOut();" onmousedown="okButtonOnMouseDown();" onmouseup="okButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_right.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_right.png', sizingMethod='image')" />
												<td width="5"></td>
												<td id="cancelButtonLeftBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_left.png" onclick="closeWindow();" onkeydown="if (event.keyCode == 13) {closeWindow();}" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_left.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_left.png', sizingMethod='image')" />
												<td role="button" aria-labelledby="cancelButtonText" id="cancelButton" class="dialogButton" width="62" height="30" align="center" background="${pageContext.request.contextPath}/images/shell/b_active_center.png" onclick="closeWindow();" onkeydown="if (event.keyCode == 13) {closeWindow();}" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_center.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_center.png', sizingMethod='scale')">
													<table border="0" cellpadding="0" cellspacing="0" width="60" height="13" role="presentation">
														<tr><td id="cancelButtonText" tabindex="0" align="center">
															<script>if (isIE) { document.write('<div style="white-space: nowrap;">'); }</script>
															<fmt:message key="simpleDialogCancel" bundle="${resources}" />
															<script>if (isIE) { document.write('</div>'); }</script>
														</td></tr>
													</table>
												</td>
												<td id="cancelButtonRightBorder" width="6" height="30" background="${pageContext.request.contextPath}/images/shell/b_active_right.png" onclick="closeWindow();" onkeydown="if (event.keyCode == 13) {closeWindow();}" onmouseover="cancelButtonOnMouseOver();" onmouseout="cancelButtonOnMouseOut();" onmousedown="cancelButtonOnMouseDown();" onmouseup="cancelButtonOnMouseUp();" style="cursor: pointer; background: transparent url('${pageContext.request.contextPath}/images/shell/b_active_right.png') none; filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/b_active_right.png', sizingMethod='image')" />
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

