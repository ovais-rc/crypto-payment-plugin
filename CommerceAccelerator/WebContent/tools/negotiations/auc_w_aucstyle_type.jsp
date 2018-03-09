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
			com.ibm.commerce.negotiation.beans.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.common.objects.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
      //*** GET LOCALE FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	Locale   locale_obj = null;
      if( aCommandContext!= null )
		locale_obj  = aCommandContext.getLocale();
	if (locale_obj == null)
		locale_obj = new Locale("en","US");

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties= (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
%>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>

var msgMandatoryField 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgMandatoryField")) %>';
var msgFieldInvalidSize = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';

function initializeState(){
	parent.setContentFrameLoaded(true);
}

function validatePanelData(){  
	 var form=document.auctionStyleForm;
	 if (isInputStringEmpty(form.ProfileName.value)) {
		reprompt(form.ProfileName, msgMandatoryField);
		return false;
	 }
	if(!isValidUTF8length(form.ProfileName.value,38)){
		reprompt(form.ProfileName,msgFieldInvalidSize);
		return false;
	}
	 return true;
}

function savePanelData(){
	var form=document.auctionStyleForm;
	for (i=0;i<form.autype.length;i++) {
		if (form.autype[i].checked){
			parent.put("autype",form.autype[i].value);
			break;
		}
	}
	parent.put("ProfileName",form.ProfileName.value);
	
	parent.addURLParameter("authToken", "${authToken}");
}

function retrievePanelData(){
	var form = document.auctionStyleForm;
	form.ProfileName.value = parent.get("ProfileName","");
	var selectedAuctionType = parent.get("autype","O");
	for (i=0;i<form.autype.length;i++) {
		if (form.autype[i].value == selectedAuctionType){
			form.autype[i].click();
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
<BR><h1><%= neg_properties.get("AStyleType") %></h1>

<FORM NAME="auctionStyleForm">
<TABLE>
	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("StyleName") %> <%= neg_properties.get("required") %><BR>	
      	<INPUT size="30" type="input" name="ProfileName" maxlength="38" onkeypress="return noenter()">
		</Label>
	</TD>
	</TR>
	<TR>
	<TD>
		<%= neg_properties.get("auctionType") %><BR>
		<Label for="O">
      	<INPUT TYPE="radio" NAME="autype" VALUE="O" id="O" CHECKED> <%= neg_properties.get("opencry") %><BR> 		</Label>
		<Label for="SB">
      	<INPUT TYPE="radio" NAME="autype" VALUE="SB" id="SB"> <%= neg_properties.get("sealedbid") %><BR>		
		</Label>
		<Label for="D">
		<INPUT TYPE="radio" NAME="autype" VALUE="D" id="D"> <%= neg_properties.get("dutch") %>
		</Label>
	</TD>
	</TR>
</TABLE>
</FORM>

<SCRIPT LANGUAGE="Javascript">
	retrievePanelData();
</SCRIPT> 

</BODY>
</HTML>
