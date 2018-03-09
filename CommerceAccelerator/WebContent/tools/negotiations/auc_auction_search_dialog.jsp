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

<%@page language="java" %>
<!-- ========================================================================
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
 ===========================================================================-->
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
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

     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);
%>

<%
//        String emptyString = new String("");

    	String lang =  request.getParameter("lang");
    	//out.println("lang received is: " + lang);
		if (lang == null) {
			lang =  "-1";
		}
		String StoreId =  request.getParameter("StoreId");
		if (StoreId == null) {
			StoreId = "0";
		}

%>

<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>

var ds_auctid          = "<%= auctionNLS.get("AuctionRefNum") %>";
var ds_aucttype        = "<%= auctionNLS.get("AuctionType") %>";
var ds_itemid          = "<%= auctionNLS.get("ItemRefNum") %>";
var searchResultsBCT   = "<%= auctionNLS.get("searchResultsBCT") %>";
var msgInvalidNumber   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidNumber") ) %>";
var msgInvalidSize     = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize") ) %>";


function initializeState()
{
     document.DialogForm.aurefnum.focus();
     parent.setContentFrameLoaded(true);
  
}

function savePanelData() {
 
     parent.put(auctId, document.DialogForm.aurefnum.value);
     parent.put(auctType, document.DialogForm.autype.value); 
     parent.put(auctSKU, document.DialogForm.sku.value );  
   
}  

function validatePanelData() {
    var theLang   = "<%= UIUtil.toJavaScript(lang) %>";  
    //var theLang     = "-1";  //tools right needs this value for validation

    var auct_id     = document.DialogForm.aurefnum.value;
    var sku         = document.DialogForm.sku.value;
    var i           = document.DialogForm.autype.selectedIndex;
    var auctionType = document.DialogForm.autype.options[i].value;


    if (!isInputStringEmpty(auct_id)) {
      if ( isNaN(strToNumber(auct_id, theLang)) ) {
  	reprompt(document.DialogForm.aurefnum, msgInvalidNumber);
  	return false;
      }
    }	

    if (!isInputStringEmpty(sku)){
        if ( !isValidUTF8length(sku, 64) ) {
          reprompt(document.DialogForm.sku, msgInvalidSize );
          return false;
        }
    }


}
</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("SearchDialog") %></h1>


   <FORM Name="DialogForm" id="DialogForm">   
   
	<TABLE id="WC_AuctionSearchDialog_Table_1">
        <TR>
	      <TD id="WC_AuctionSearchDialog_TableCell_1">
                 <%= auctionNLS.get("auctionSearchText") %><BR><BR> 
	      </TD>
        </TR>
        <TR>
	      <TD id="WC_AuctionSearchDialog_TableCell_2">
	         <LABEL for="WC_AuctionSearchDialog_aurefnum_In_DialogForm">
   		 <%= auctionNLS.get("AuctionRefNum") %></LABEL><BR>
		 <INPUT TYPE="text" NAME="aurefnum" SIZE=17 MAXLENGTH="26" VALUE="" id="WC_AuctionSearchDialog_aurefnum_In_DialogForm">
		 
	      </TD>
        </TR>

	<TR>
	      <TD id="WC_AuctionSearchDialog_TableCell_3">
		 <LABEL for="WC_AuctionSearchDialog_sku_In_DialogForm">
		 <%= auctionNLS.get("SKU") %></LABEL><BR>
	         <INPUT TYPE="text" NAME="sku" SIZE=17 VALUE="" id="WC_AuctionSearchDialog_sku_In_DialogForm">
	         
  	      </TD>
	</TR>		
        <TR>
	      <TD id="WC_AuctionSearchDialog_TableCell_4">
   		<LABEL for="WC_AuctionSearchDialog_autype_In_DialogForm">
   		<%= auctionNLS.get("auctionType") %></LABEL><BR>
    		<SELECT NAME="autype" id="WC_AuctionSearchDialog_autype_In_DialogForm">
        	<OPTION VALUE="All" SELECTED><%= auctionNLS.get("all") %> 
        	<OPTION VALUE="O" ><%= auctionNLS.get("opencry") %> 
        	<OPTION VALUE="SB"><%= auctionNLS.get("sealedbid") %>
        	<OPTION VALUE="D"><%= auctionNLS.get("dutch") %> 
    		</SELECT>
    		    
	     </TD>
	</TR>

</TABLE>
</FORM>
</BODY>
</HTML>


