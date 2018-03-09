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

<%@page language="java" %>
<!-- ========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//*   WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
     Locale   aLocale = null;
     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
       aLocale = aCommandContext.getLocale();
     }

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);
%>

<HTML>
<HEAD>
</HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<BODY class=content ONLOAD="initializeState();" >
<BR><h1><%= auctionNLS.get("AuctDisplay") %></h1>


<FORM Name="DisplayForm" id="DisplayForm">
    <!--<FONT SIZE=+1><B><%= auctionNLS.get("AuctionDetail") %></B></FONT><BR>-->

   <TABLE id="WC_W_AuctionDisplay_Table_1">
   <TR>
 		<TD id="WC_W_AuctionDisplay_TableCell_1">
			<LABEL id="WC_W_AuctionDisplay_aurulemacro_In_DisplayForm" for="WC_W_AuctionDisplay_aurulemacro_In_DisplayForm">
			<%= auctionNLS.get("RuleTemplate") %> 
			</LABEL> <%= auctionNLS.get("mandatory") %><BR>
			<INPUT TYPE="text"
                         NAME="aurulemacro"
                         SIZE=30 
                         MAXLENGTH=254
				 VALUE="" id="WC_W_AuctionDisplay_aurulemacro_In_DisplayForm">
			
   </TR>
   <TR>
 		<TD id="WC_W_AuctionDisplay_TableCell_2">
			<LABEL id="WC_W_AuctionDisplay_auprdmacro_In_DisplayForm" for="WC_W_AuctionDisplay_auprdmacro_In_DisplayForm">
			<%= auctionNLS.get("ProductTemplate") %>
			</LABEL> <%= auctionNLS.get("mandatory") %><BR>
			<INPUT TYPE="text"
                         NAME="auprdmacro"
                         SIZE=30 
                         MAXLENGTH=254
				 VALUE="" id="WC_W_AuctionDisplay_auprdmacro_In_DisplayForm">
			
		</TD>
   </TR>
   <TR>
	<TD id="WC_W_AuctionDisplay_TableCell_3">
	<LABEL for="WC_W_AuctionDisplay_ausdesc_In_DisplayForm">
	 <%= auctionNLS.get("AuctionShortDesc") %></LABEL><BR> 
	 <TEXTAREA NAME="ausdesc"
		COLS=50
		ROWS=3
		WRAP=VIRTUAL id="WC_W_AuctionDisplay_ausdesc_In_DisplayForm">
	 </TEXTAREA>
	
	</TD> 
   </TR>
   <TR>
	<TD id="WC_W_AuctionDisplay_TableCell_4">
	<LABEL for="WC_W_AuctionDisplay_auldesc_In_DisplayForm">
	 <%= auctionNLS.get("AuctionLongDesc") %>
	 </LABEL><BR> 
	 <TEXTAREA NAME="auldesc"
		COLS=50
		ROWS=6
		WRAP=VIRTUAL id="WC_W_AuctionDisplay_auldesc_In_DisplayForm">
	 </TEXTAREA>
	
	</TD> 
   </TR>

</TABLE>
<SCRIPT LANGUAGE="JavaScript">

var i = 0;
var aDefault = null;
var msgMandatoryField  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField")) %>";
var msgInvalidSize254  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize254")) %>";
var msgInvalidSize2048 = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize2048")) %>";
var msgInvalidSize     = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize")) %>";


function initializeState()
{
  
  // Get panel data from model  
  document.DisplayForm.aurulemacro.value = parent.get(auctRuleMacro, aDefault);   
  document.DisplayForm.auprdmacro.value = parent.get(auctPrdMacro, aDefault);   

  document.DisplayForm.ausdesc.value = "";   
  document.DisplayForm.auldesc.value = "";   

  if ( parent.get(auctShortDesc, aDefault) != null ) {
    document.DisplayForm.ausdesc.value = parent.get(auctShortDesc, aDefault);   
    document.DisplayForm.auldesc.value = parent.get(auctLongDesc, aDefault);   

  }

  document.DisplayForm.aurulemacro.focus();   
    
  parent.setContentFrameLoaded(true);
  
}

function savePanelData() {

  
  // Save panel data in model 
  parent.put(auctRuleMacro, document.DisplayForm.aurulemacro.value);   
  parent.put(auctPrdMacro, document.DisplayForm.auprdmacro.value);   
  parent.put(auctShortDesc, document.DisplayForm.ausdesc.value );   
  parent.put(auctLongDesc, document.DisplayForm.auldesc.value );   

  parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData() {
  
  var form     = document.DisplayForm;

    if (isInputStringEmpty(form.aurulemacro.value)){
        reprompt(document.DisplayForm.aurulemacro, msgMandatoryField );
        return false;
    }
    else {
       if (!isValidUTF8length(form.aurulemacro.value, 254)) {
        reprompt(document.DisplayForm.aurulemacro, msgInvalidSize );
        return false;
       }
    }

    if (isInputStringEmpty(form.auprdmacro.value)) {
        reprompt(document.DisplayForm.auprdmacro, msgMandatoryField);
        return false;
    }
    else {
       if (!isValidUTF8length(form.auprdmacro.value, 254)) {
        reprompt(document.DisplayForm.auprdmacro, msgInvalidSize );
        return false;
       }
    }

    if (!isInputStringEmpty(form.ausdesc.value)){
        if ( !isValidUTF8length(form.ausdesc.value, 254) ) {
          reprompt(document.DisplayForm.ausdesc, msgInvalidSize254 );
          return false;
        }
    }

    if (!isInputStringEmpty(form.auldesc.value)){
       if ( !isValidUTF8length(form.auldesc.value, 2048)  ) {
         reprompt(document.DisplayForm.auldesc, msgInvalidSize2048 );
         return false;
       }    
    }

}  


</SCRIPT>

</FORM>
</BODY>
</HTML>
