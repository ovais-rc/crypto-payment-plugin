<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

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

<% 
	request.setAttribute(
			com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE
			, Boolean.FALSE);
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">
<head>
<base target="_self" />
<script type="text/javascript">
<!-- hide script from old browsers

function window_onLoad() {
	var newContent = "<html><head><base target=\"_self\" /></head><body>" + window.dialogArguments.content + "</body></html>";
	document.open();
	document.write(newContent);
	document.close();
	document.forms[0].submit();
}

//-->
</script>
</head>

<body onload="window_onLoad()">
</body>

</html>
