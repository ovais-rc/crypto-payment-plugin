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


<HTML>
<HEAD>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
var msgFieldInvalidSize = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';

function initializeState(){
   parent.setContentFrameLoaded(true);
}

function savePanelData(){
	var form=document.auctionStyleForm;
	parent.put("aurulemacro",form.aurulemacro.value);
	parent.put("auprdmacro",form.auprdmacro.value);
	
	parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData(){  
	var form=document.auctionStyleForm;
	if(!isValidUTF8length(form.aurulemacro.value,254)){
		reprompt(form.aurulemacro,msgFieldInvalidSize);
		return false;
	}
	if(!isValidUTF8length(form.auprdmacro.value,254)){
		reprompt(form.auprdmacro,msgFieldInvalidSize);
		return false;
	}
	return true;
}

function retrievePanelData(){
	var form = document.auctionStyleForm;
	form.aurulemacro.value = parent.get("aurulemacro","");
	form.auprdmacro.value  = parent.get("auprdmacro","");
}

</SCRIPT>
</HEAD>



<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= neg_properties.get("AStyleDisplay") %></h1>


<FORM NAME="auctionStyleForm">
 <TABLE ALIGN="LEFT">
	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("RuleTemplate") %><BR>	
      	<INPUT size="30" type="input" name="aurulemacro" maxlength="254">
		</Label>
	</TD>
	</TR>

	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("ProductTemplate") %><BR>	
      	<INPUT size="30" type="input" name="auprdmacro" maxlength="254">
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


