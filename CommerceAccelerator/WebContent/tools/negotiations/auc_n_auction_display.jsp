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
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
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
<% 
  String emptyString = new String("");
  String editable =  request.getParameter("editable");

%>
<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
var i = 0;
var aDefault = null;

var editable = parent.get(auctEditable);
var sdesc = parent.get(auctShortDesc, "");   
var ldesc = parent.get(auctLongDesc, "");   
var msgMandatoryField   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField")) %>";
var msgInvalidSize254   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize254")) %>";
var msgInvalidSize2048  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize2048")) %>";
var msgInvalidSize      = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize")) %>";


function initializeState()
{
  //alert("I have reached initializeState()");


  // Get panel data from model  
  if ( editable == "true" ) {
     document.DisplayForm.aurulemacro.value = parent.get(auctRuleMacro, aDefault);   
     document.DisplayForm.aurulemacro.focus();
     document.DisplayForm.auprdmacro.value = parent.get(auctPrdMacro, aDefault);   
     document.DisplayForm.ausdesc.value = parent.get(auctShortDesc, "");   
     document.DisplayForm.auldesc.value = parent.get(auctLongDesc, "");   
  }

  //Check if there is a validation error 
  
  var errorCode = parent.getErrorParams();
  
  if ( errorCode == "errRule" )
       reprompt(document.DisplayForm.aurulemacro, msgMandatoryField );
  if ( errorCode == "errRule1" )
       reprompt(document.DisplayForm.aurulemacro, msgInvalidSize );
  if ( errorCode == "errProd" )
       reprompt(document.DisplayForm.auprdmacro, msgMandatoryField);
  if ( errorCode == "errProd1" )
       reprompt(document.DisplayForm.auprdmacro, msgInvalidSize);

  if ( errorCode == "errShortDesc" )
       reprompt(document.DisplayForm.ausdesc, msgInvalidSize254);
  if ( errorCode == "errLongDesc" )
       reprompt(document.DisplayForm.auldesc, msgInvalidSize2048);

 
  parent.setContentFrameLoaded(true);
  
}

function savePanelData() {

  //alert("You have reached savePanelData()");

  // Save panel data in model 
  if ( editable == "true" ) {
     parent.put(auctRuleMacro, document.DisplayForm.aurulemacro.value);   
     parent.put(auctPrdMacro, document.DisplayForm.auprdmacro.value);   
     parent.put(auctShortDesc, document.DisplayForm.ausdesc.value );   
     parent.put(auctLongDesc, document.DisplayForm.auldesc.value );   

  }
}


</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();" >
<BR><h1><%= auctionNLS.get("AuctDisplay") %></h1>

<FORM Name="DisplayForm" id="DisplayForm">

   <TABLE id="WC_N_AuctionDisplay_Table_1">
<%    if ( editable.equals("true") ) {  	
%>
   <TR>
 	<TD id="WC_N_AuctionDisplay_TableCell_1">
 	<LABEL for="WC_N_AuctionDisplay_aurulemacro_In_DisplayForm">
	  <%= auctionNLS.get("RuleTemplate") %> 
	 </LABEL><%= auctionNLS.get("mandatory") %><BR>
	  <INPUT TYPE="text" NAME="aurulemacro" SIZE=30 MAXLENGTH=254 VALUE="" id="WC_N_AuctionDisplay_aurulemacro_In_DisplayForm">   
	 
	</TD>
   </TR>
   <TR>
 	<TD id="WC_N_AuctionDisplay_TableCell_2">
	  <LABEL for="WC_N_AuctionDisplay_auprdmacro_In_DisplayForm">
	  <%= auctionNLS.get("ProductTemplate") %> 
	  </LABEL><%= auctionNLS.get("mandatory") %><BR>
	  <INPUT TYPE="text" NAME="auprdmacro" SIZE=30 MAXLENGTH=254 VALUE="" id="WC_N_AuctionDisplay_auprdmacro_In_DisplayForm">
	  
	</TD>
   </TR>
   <TR>
 	<TD id="WC_N_AuctionDisplay_TableCell_3">
	 <LABEL for="WC_N_AuctionDisplay_ausdesc_In_DisplayForm">
	 <%= auctionNLS.get("AuctionShortDesc") %> 
	 </LABEL><BR>
	 <TEXTAREA NAME="ausdesc" COLS=50 ROWS=3 WRAP=VIRTUAL id="WC_N_AuctionDisplay_ausdesc_In_DisplayForm">
	 </TEXTAREA>
	 
	</TD> 
   </TR>
   <TR>
 	<TD id="WC_N_AuctionDisplay_TableCell_4">
	 <LABEL for="WC_N_AuctionDisplay_auldesc_In_DisplayForm">
	 <%= auctionNLS.get("AuctionLongDesc") %> 
	 </LABEL><BR>
	 <TEXTAREA NAME="auldesc" COLS=50 ROWS=6 WRAP=VIRTUAL id="WC_N_AuctionDisplay_auldesc_In_DisplayForm">
	 </TEXTAREA>
	 
	</TD> 
   </TR>

<% } else {
%>	
        <SCRIPT>
        var ruletemplate_title = "<%= auctionNLS.get("RuleTemplate") %>";
        var prdtemplate_title =  "<%= auctionNLS.get("ProductTemplate") %>";
        document.writeln('<TR>');
        document.writeln('<TD id="WC_N_AuctionDisplay_TableCell_5">');
        document.writeln( ruletemplate_title + ': <I>' + parent.get(auctRuleMacro, "") + '</I><BR>');
   	  document.writeln('</TD>');
   	  document.writeln('</TR> ');
        document.writeln('<TR>');
        document.writeln('<TD id="WC_N_AuctionDisplay_TableCell_6">');
        document.writeln( prdtemplate_title + ': <I>' + parent.get(auctPrdMacro, "") + '</I><BR>');
   	  document.writeln('</TD>');
   	  document.writeln('</TR> ');
          
        var  aDesc_title = "<%= auctionNLS.get("AuctionShortDesc") %>"; 
        document.writeln('<TR>');
        document.writeln('<TD id="WC_N_AuctionDisplay_TableCell_7">');
        document.writeln( aDesc_title + ': <I>' + parent.get(auctShortDesc, "") + '</I><BR>');
   	  document.writeln('</TD>');
   	  document.writeln('</TR> ');
   	  aDesc_title = "<%= auctionNLS.get("AuctionLongDesc") %>"; 
   	  document.writeln('<TR>');
   	  document.writeln('<TD id="WC_N_AuctionDisplay_TableCell_8">');
   	  document.writeln(aDesc_title + ': <I>' + parent.get(auctLongDesc, "") + '</I><BR>');
   	  document.writeln('</TD>');
   	  document.writeln('</TR> ');
	</SCRIPT>

<% }
%>

</TABLE>

</FORM>
</BODY>
</HTML>
