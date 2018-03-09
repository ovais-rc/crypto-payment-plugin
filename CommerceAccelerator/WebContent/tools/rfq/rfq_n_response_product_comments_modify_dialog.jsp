<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ include file="../common/common.jsp" %>
<%
	//*** GET LOCALE FROM COMANDCONTEXT ***//
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale = null;
   	if( aCommandContext!= null ) {
   		locale = aCommandContext.getLocale();
	}
	if (locale == null) {
		locale = new Locale("en","US");
	}
	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript">
var msgMandatoryField = '<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyTCs")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidSize254")) %>';
commentsObj = top.getData("commentsData", 1);
function initData() {
	retrievePanelData();
	parent.setContentFrameLoaded(true);
}
function retrievePanelData() {
   document.rfqProCommentsModifyForm.responsetc.value = commentsObj.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>;
}
var VPDResult;
function validatePanelData() {
	return VPDResult;
}
function savePanelData() {
	VPDResult = validatePanelData0();
	if(!VPDResult) return;
	commentsObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	commentsObj.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %> = document.rfqProCommentsModifyForm.responsetc.value;
	commentsObj.<%= RFQConstants.EC_ATTR_VALUE %> = document.rfqProCommentsModifyForm.responsetc.value;
}
function validatePanelData0() {
	var form=document.rfqProCommentsModifyForm;
	if (isInputStringEmpty(form.responsetc.value) && commentsObj.<%= RFQConstants.EC_ATTR_MANDATORY %> == 1) {
		reprompt(form.responsetc, msgMandatoryField);
		form.responsetc.focus();
		return false;
	}
	if (!isValidUTF8length(form.responsetc.value,254)) {
		reprompt(form.responsetc, msgInvalidSize);
		form.responsetc.focus();
		return false;
	}
	return true;
}
</script>
</head>
<body class="content" >
<h1><%= rfqNLS.get("ProductComm") %></h1>
<%= rfqNLS.get("instruction_PDCommentresponse_modify") %>

<form name="rfqProCommentsModifyForm" action="">
<table border="0" width="100%">
  <tr>
  <td><br /><b><%= rfqNLS.get("name") %>:</b> 
      <i><script type="text/javascript">document.write(ToHTML(commentsObj.<%= RFQConstants.EC_ATTR_NAME %>));</script></i>
  </td>
  </tr>
  <tr>
  <td><b><%= rfqNLS.get("resrequestvalue") %>:</b>
      <i><script type="text/javascript">document.write(ToHTML(commentsObj.<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>));</script></i>
  </td>
  </tr>
  <tr>
    <td>
	<label for="responsetc">
	<br /><b><%= rfqNLS.get("resresponsevalue") %>:</b><br />
	<textarea name="responsetc" id="responsetc" cols="100" rows="5"></textarea>
	</label>
    </td>
  </tr>
</table>
</form>
<script type="text/javascript">
	initData();
</script>
</body>
</html>

