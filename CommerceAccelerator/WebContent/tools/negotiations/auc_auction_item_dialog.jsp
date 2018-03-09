
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
     CommandContext aCommandContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);    
     if( aCommandContext!= null )
     {
       aLocale = aCommandContext.getLocale();
     }
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

 // for the invalid char message
	Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS",aLocale);
%>

<%
//		String emptyString = new String("");

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
<link rel=stylesheet href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
var msgSelectOne = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgSelectOne")) %>";
var msgInvalidSize     = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidSize") ) %>";

var msgInvalidChar = "<%= UIUtil.toJavaScript( (String)userNLS.get("invalidChars") ) %>";

function initializeState()
{
     document.SearchForm.sku.focus();
     parent.setContentFrameLoaded(true);
  
}

function savePanelData() {
}  


function validate() {
    //Do we have a find all or do I validate to have at least one find criteria    
    if (    isInputStringEmpty(document.SearchForm.sku.value)    
         && isInputStringEmpty(document.SearchForm.name.value)
         && isInputStringEmpty(document.SearchForm.shortdesc.value) ) {
       //reprompt(document.SearchForm.sku, msgSelectOne); 
       //return false;
	 return true;
    }	

    if (!isInputStringEmpty(document.SearchForm.sku.value)){
        if ( !isValidUTF8length(document.SearchForm.sku.value, 64) ) {
          reprompt(document.SearchForm.sku, msgInvalidSize );
          return false;
        }
    }
    if (!isInputStringEmpty(document.SearchForm.name.value)){
        if ( !isValidUTF8length(document.SearchForm.name.value, 64) ) {
          reprompt(document.SearchForm.name, msgInvalidSize );
          return false;
        }
    }
    if (!isInputStringEmpty(document.SearchForm.shortdesc.value)){
        if ( !isValidUTF8length(document.SearchForm.shortdesc.value, 254) ) {
          reprompt(document.SearchForm.shortdesc, msgInvalidSize );
          return false;
        }
    }

    return true;
    
}

function findAction() {
    if (validate()) {
	doSearch();
    }
}


function cancelAction() {
	top.goBack();
}

function doSearch()
{
var url = "/webapp/wcs/tools/servlet/NewDynamicListView";

  var urlPara = new Object();
  urlPara.ActionXMLFile='negotiations.auctionItemListSC';
  urlPara.cmd='AuctionItemList';
  urlPara.listsize='15';
  urlPara.startindex='0';
  urlPara.refnum='0';
  urlPara.orderby='PARTNUMBER';
  urlPara.selected='SELECTED';
  urlPara.sku=document.SearchForm.sku.value;
  urlPara.name=document.SearchForm.name.value;
  urlPara.shortdesc=document.SearchForm.shortdesc.value;

 	top.setContent("<%= UIUtil.toJavaScript((String)auctionNLS.get("ItemList")) %>",url,false,urlPara)  
}

</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("ItemDialog") %></h1>

   <FORM Name="SearchForm" >   
   
	<TABLE> 
        <TR>
	      <TD>
                 <%= auctionNLS.get("itemSearchText") %><BR><BR> 
	      </TD>
        </TR>

        <TR>
	      <TD>
	         <LABEL>
   		 <%= auctionNLS.get("SKU") %><BR>
		 <INPUT TYPE="text" NAME="sku" SIZE=38 MAXLENGTH=38 VALUE="">
		 </LABEL>
	      </TD>
        </TR>
	<TR>
	      <TD>
		 <LABEL>
		 <%= auctionNLS.get("name") %><BR>
	         <INPUT TYPE="text" NAME="name" SIZE=38  VALUE="">
	         </LABEL>
  	      </TD>
	</TR>		
	<TR>
	      <TD>
		 <LABEL>
		 <%= auctionNLS.get("shortDescription") %><BR>
	         <INPUT TYPE="text" NAME="shortdesc" SIZE=38 VALUE="">
	         </LABEL>
  	      </TD>
	</TR>		

</TABLE>
</FORM>
</BODY>
</HTML>

