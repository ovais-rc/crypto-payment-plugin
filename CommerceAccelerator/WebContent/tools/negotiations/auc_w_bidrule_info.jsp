<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import=	"com.ibm.commerce.tools.test.*,
			com.ibm.commerce.tools.util.*,
 			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.negotiation.beans.*" %>

<%@include file="../common/common.jsp" %>
<HTML>
<HEAD>


<%
      //*** GET LOCALE FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale = null;
      if( aCommandContext!= null )
            locale = aCommandContext.getLocale();
	if (locale == null)
		locale = new Locale("en","US");

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale);
%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
var msgMandatoryField = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgMandatoryField")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';

function initializeState(){
	parent.setContentFrameLoaded(true);
}

function validatePanelData(){  
	var form=document.bidrulewizardForm;

	if (isInputStringEmpty(form.rulename.value)) {
		reprompt(form.rulename, msgMandatoryField);
		return false;
	}

	if (!isValidUTF8length(form.rulename.value,30)) {
		reprompt(form.rulename, msgInvalidSize);
		return false;
	}

	if (!isValidUTF8length(form.ruledesc.value,254)) {
		reprompt(form.ruledesc, msgInvalidSize);
		return false;
	}
	return true;
}


function savePanelData(){
	var form=document.bidrulewizardForm;
	for (i=0;i<form.ruletype.length;i++) {
		if (form.ruletype[i].checked){
			parent.put("ruletype",form.ruletype[i].value);
			break;
		}
	}
	parent.put("rulename",form.rulename.value);
	parent.put("ruledesc",form.ruledesc.value);
	
	parent.addURLParameter("authToken", "${authToken}");
}


function retrievePanelData(){
	var form = document.bidrulewizardForm;
	form.rulename.value = parent.get("rulename","");
	form.ruledesc.value = parent.get("ruledesc","");

	var selectedAuctionType = parent.get("ruletype","O");
	for (i=0;i<form.ruletype.length;i++) {
		if (form.ruletype[i].value == selectedAuctionType){
			form.ruletype[i].click();
			break;
		}
  	}
}

function noenter() {
	return !(window.event && window.event.keyCode == 13); 
}
</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();">

<BR><h1><%= neg_properties.get("BRuleGeneral") %></h1>

<FORM NAME="bidrulewizardForm" id="bidrulewizardForm">
<TABLE id="WC_W_BidruleInfo_Table_1">
	<TR>
	<TD id="WC_W_BidruleInfo_TableCell_1">
		<Label for="WC_W_BidruleInfo_rulename_In_bidrulewizardForm">
		<%= neg_properties.get("name") %></Label><%= neg_properties.get("required") %><BR>	
      	<INPUT size="30" type="input" name="rulename" maxlength="30" onkeypress="return noenter()" id="WC_W_BidruleInfo_rulename_In_bidrulewizardForm">
		
	</TD>
	</TR>
	<TR>
	<TD id="WC_W_BidruleInfo_TableCell_2">
		<Label for="WC_W_BidruleInfo_ruledesc_In_bidrulewizardForm">
		<%= neg_properties.get("description") %></Label> <BR>
	 	<TEXTAREA NAME="ruledesc" COLS=50 ROWS=3 WRAP=VIRTUAL id="WC_W_BidruleInfo_ruledesc_In_bidrulewizardForm">
		</TEXTAREA>
		
	</TD>
	</TR>
	<TR>
	<TD id="WC_W_BidruleInfo_TableCell_3">
		<%= neg_properties.get("type") %> <BR>
		
      	<INPUT TYPE="radio" NAME="ruletype" VALUE="O" id="WC_W_BidruleInfo_O_In_bidrulewizardForm" CHECKED> <Label for="WC_W_BidruleInfo_O_In_bidrulewizardForm"> <%= neg_properties.get("opencry") %></Label> <BR>
		
      	<INPUT TYPE="radio" NAME="ruletype" VALUE="SB" id="WC_W_BidruleInfo_SB_In_bidrulewizardForm"> <Label for="WC_W_BidruleInfo_SB_In_bidrulewizardForm"><%= neg_properties.get("sealedbid") %> </Label>
	</TD>
	</TR>
</TABLE>

</FORM>
<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 
</BODY>
</HTML>


