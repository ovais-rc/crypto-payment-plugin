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
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ include file="../common/common.jsp" %>
<%
	//*** GET LOCALE FROM COMANDCONTEXT ***//
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale locale = null;
	if( aCommandContext!= null ) {
	    locale = aCommandContext.getLocale();
	}
	if (locale == null) {
	    locale = new Locale("en","US");
	}
	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">
var msgMandatoryField = '<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyTCs")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidSize254")) %>';
var commentObj;
commentObj = top.getData("<%= RFQConstants.EC_TC_RFQ_LEVEL_COMMENT %>",1);
function initData() {
	document.rfqTCForm.responsetc.value = commentObj.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>;
	parent.setContentFrameLoaded(true);
}
var VPDResult;
function validatePanelData() {
	return VPDResult;
}
function savePanelData() {
	VPDResult = validatePanelData0();
	if(!VPDResult) return;
	commentObj.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %> = document.rfqTCForm.responsetc.value;
	commentObj.res_display = document.rfqTCForm.responsetc.value;
	commentObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
}
function validatePanelData0() {
	var form=document.rfqTCForm;
	if (isInputStringEmpty(form.responsetc.value) && commentObj.<%= RFQConstants.EC_ATTR_MANDATORY %> == 1) {
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
<h1><%= rfqNLS.get("changetermsandconditions") %></h1>
<%= rfqNLS.get("instruction_TCresponse_modify") %>

<form name="rfqTCForm" action="">
<table border="0" width="100%">
   <tr>
  <td width="30%" align="left"><b><%= rfqNLS.get("requesttc_") %></b></td>
  <td width="70%" align="left"><i>
  	<script type="text/javascript">
  	document.writeln(commentObj.req_display);
  	</script>
  </i>	
  </td>
  </tr>
</table>
<table border="0" width="100%">
  <tr>
  	<td> 
	    <label for="responsetc">
	    <br /><b><%= rfqNLS.get("responsetc_") %></b><br />
	    <textarea name="responsetc" id="responsetc" cols="120" rows="10" ></textarea>
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

