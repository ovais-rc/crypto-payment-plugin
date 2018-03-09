<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="com.ibm.commerce.tools.shipping.ShippingConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="ShippingCommon.jsp" %>

<%
		
%>

<html>

<head>
<%= fHeader %>
<style type='text/css'>
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACKING_PANEL_TITLE) %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/CalcCode.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData () {
	with (document.trackingForm) {
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		if (parent.get) {
	
			var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
			if (o != null) {
			
				loadValue(trackInquiryTypeInput, o.<%= ShippingConstants.ELEMENT_TRACK_INCQUIRY_TYPE %>);
				loadValue(trackNameInput, o.<%= ShippingConstants.ELEMENT_TRACK_NAME %>);
				loadValue(trackSocksHostInput, o.<%= ShippingConstants.ELEMENT_TRACK_SOCKS_HOST %>);
				loadValue(trackSocksPortInput, o.<%= ShippingConstants.ELEMENT_TRACK_SOCKS_PORT %>);
				loadValue(trackURLInput, o.<%= ShippingConstants.ELEMENT_TRACK_URL %>);
				loadValue(trackIconInput, o.<%= ShippingConstants.ELEMENT_TRACK_ICON %>);
				
			}


			if (parent.get("trackInquiryTypeTooLong", false)) {
				parent.remove("trackInquiryTypeTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_INCQUIRY_TYPE_TOO_LONG)) %>");
				trackInquiryTypeInput.select();
				trackInquiryTypeInput.focus();
				return;
			}

			if (parent.get("trackNameTooLong", false)) {
				parent.remove("trackNameTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_NAME_TOO_LONG)) %>");
				trackNameInput.select();
				trackNameInput.focus();
				return;
			}
			
				if (parent.get("trackSocksHostTooLong", false)) {
				parent.remove("trackSocksHostTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_SOCKS_HOST_TOO_LONG)) %>");
				trackSocksHostInput.select();
				trackSocksHostInput.focus();
				return;
			}

			if (parent.get("trackSocksPortNotInteger", false)) {
				parent.remove("trackSocksPortNotInteger");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_SOCKS_PORT_NOT_INTEGER)) %>");
				trackSocksPortInput.select();
				trackSocksPortInput.focus();
				return;
			}
			
			if (parent.get("trackURLTooLong", false)) {
				parent.remove("trackURLTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_URL_TOO_LONG)) %>");
				trackURLInput.select();
				trackURLInput.focus();
				return;
			}
			
			if (parent.get("trackIconTooLong", false)) {
				parent.remove("trackIconTooLong");
				alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_ICON_TOO_LONG)) %>");
				trackURLInput.select();
				trackURLInput.focus();
				return;
			}

		
		}
		trackNameInput.focus();
	}
}

function validatePanelData () {
	with (document.trackingForm) {
		if (!isValidUTF8length(trackInquiryTypeInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_INCQUIRY_TYPE %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_INCQUIRY_TYPE_TOO_LONG)) %>");
			codeInput.select();
			codeInput.focus();
			return false;
		}
		if (!isValidUTF8length(trackNameInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_NAME %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_NAME_TOO_LONG)) %>");
			trackNameInput.select();
			trackNameInput.focus();
			return false;
		}
		if (!isValidUTF8length(trackSocksHostInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_SOCKS_HOST %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_SOCKS_HOST_TOO_LONG)) %>");
			trackSocksHostInput.select();
			trackSocksHostInput.focus();
			return false;
		}
		if ((trackSocksPortInput.value != "") && !isValidPositiveInteger(trackSocksPortInput.value)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_SOCKS_PORT_NOT_INTEGER)) %>");
			trackSocksPortInput.select();
			trackSocksPortInput.focus();
			return false;
		}
		if (!isValidUTF8length(trackURLInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_URL %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_URL_TOO_LONG)) %>");
			trackURLInput.select();
			trackURLInput.focus();
			return false;
		}
		
		if (!isValidUTF8length(trackIconInput.value, <%= ShippingConstants.DB_COLUMN_LENGTH_SHIPMODE_TRACK_ICON %>)) {
			alertDialog("<%= UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_TRACK_ICON_TOO_LONG)) %>");
			trackIconInput.select();
			trackIconInput.focus();
			return false;
		}

	}
	return true;
}

function savePanelData () {
	with (document.trackingForm) {
		if (parent.get) {
			var o = parent.get("<%= ShippingConstants.ELEMENT_SHIPMODE_BEAN %>", null);
			if (o != null) {
				o.<%= ShippingConstants.ELEMENT_TRACK_INCQUIRY_TYPE %> = trackInquiryTypeInput.value;
				o.<%= ShippingConstants.ELEMENT_TRACK_NAME %> = trackNameInput.value;
				o.<%= ShippingConstants.ELEMENT_TRACK_SOCKS_HOST %> = trackSocksHostInput.value;
				o.<%= ShippingConstants.ELEMENT_TRACK_SOCKS_PORT %> = trackSocksPortInput.value;
				o.<%= ShippingConstants.ELEMENT_TRACK_URL %> = trackURLInput.value;
				o.<%= ShippingConstants.ELEMENT_TRACK_ICON %> = trackIconInput.value;
			}
		}
	}
}
//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="loadPanelData()" class="content">

<h1><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACKING_PANEL_PROMPT) %></h1>

<form name="trackingForm">

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_NAME_PROMPT) %><br>
<LABEL><input name="trackNameInput" type="TEXT" size="30" maxlength="64"></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_INCQUIRY_TYPE_PROMPT) %><br>
<LABEL><input name="trackInquiryTypeInput" type="TEXT" size="30" maxlength="64"></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_SOCKS_HOST_PROMPT) %><br>
<LABEL><input name="trackSocksHostInput" type="TEXT" size="30" maxlength="64"></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_SOCKS_PORT_PROMPT) %><br>
<LABEL><input name="trackSocksPortInput" type="TEXT" size="30" maxlength="64"></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_URL_PROMPT) %><br>
<LABEL><input name="trackURLInput" type="TEXT" size="30" maxlength="64"></LABEL>

<p><%= shippingRB.get(ShippingConstants.MSG_SHIPMODE_TRACK_ICON_PROMPT) %><br>
<LABEL><input name="trackIconInput" type="TEXT" size="30" maxlength="64"></LABEL>
	
</form>

</body>

</html>