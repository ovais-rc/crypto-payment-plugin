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
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ include file="../common/common.jsp" %>
<%
	//*** GET LOCALE FROM COMANDCONTEXT ***//
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale = null;
	if( aCommandContext!= null ) {
   	    locale = aCommandContext.getLocale();
	}
	if (locale == null)	{
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
var anTC = new Object();
anTC = top.getData("anTC",1);
var allTC = new Array();
allTC = top.getData("allTC",1);

function retrievePanelData() {
	document.rfqTCForm.responsetc.value = anTC.<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>;
}
function initializeState() {
	parent.setContentFrameLoaded(true);
}
var VPDResult;
function validatePanelData() {
return VPDResult;
}
function validatePanelData0(){
	var form=document.rfqTCForm;
	if (anTC.<%=RFQConstants.EC_ATTR_MANDATORY%> ==1 && isInputStringEmpty(form.responsetc.value)) {
		reprompt(form.responsetc, msgMandatoryField);
		return false;
	}
	if (!isValidUTF8length(form.responsetc.value,254)) {
		reprompt(form.responsetc, msgInvalidSize);
		return false;
	}
	return true;
}
function savePanelData() {
	VPDResult = validatePanelData0();
	if(!VPDResult) return;
	var form = document.rfqTCForm;
	anTC.<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%> = form.responsetc.value;
    for(var i = 0; i < allTC.length; i++) {
    	if (allTC[i].<%=RFQConstants.EC_REQUEST_TC_ID%> == anTC.<%=RFQConstants.EC_REQUEST_TC_ID%>) {
			allTC[i].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%> = anTC.<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>; 
			allTC[i].display = anTC.<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>; 
		}
    }
	top.sendBackData(allTC,"allTC");
}
</script>
</head>

<body class="content">
<h1><%= rfqNLS.get("resTermsandConditions") %></h1>
<%= rfqNLS.get("instruction_TCresponse") %>

<form name="rfqTCForm" action="">
<table border="0" width="100%">
    <tr>
    <td><b><%= rfqNLS.get("requesttc") %></b>
  		  <script type="text/javascript">
//		    document.write(anTC.<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>);
		    document.write(anTC.display_rfq);
		  </script>
    </td>
    </tr>
    <tr>
  	<td>
	    <label for="responsetc">
	    <br /><b><%= rfqNLS.get("responsetc") %></b><br />
      	    <textarea name="responsetc" id="responsetc" cols="120" rows="10" ></textarea>
	    </label>
	</td>
    </tr>
</table>
</form>

<script type="text/javascript">
	retrievePanelData();
	initializeState();
</script>

</body>
</html>
