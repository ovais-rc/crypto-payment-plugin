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
//*   WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
 ===========================================================================-->

<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@  page import="com.ibm.commerce.price.utils.*"  %>
<%@  page import="com.ibm.commerce.common.objects.*"  %>
<%@  page import="com.ibm.commerce.price.*"  %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@include file="../common/common.jsp" %>

<%
     String   emptyString = new String("");
     String   StoreId = "0";
     Integer  aLang = null;
     String   lang =  "-1";  
     Locale   aLocale = null;
     String   locale = "en_US";

     CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
     if( aCommandContext!= null )
     {
            aLang = aCommandContext.getLanguageId();
            lang = aLang.toString();
            aLocale = aCommandContext.getLocale();
            locale = aLocale.toString();
            StoreId = aCommandContext.getStoreId().toString();
     }
    
      
     //***Get currency        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    
     FormattedMonetaryAmount fmt = null;
     BigDecimal   aPrice = null;
     
     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

    String autype =  request.getParameter("autype");
    String editable =  request.getParameter("editable");
    String aucur =  request.getParameter("aucur");
    String aucurprice =  request.getParameter("aucurprice_ds");
    String audeposit =  request.getParameter("audeposit_ds");
    String minbid =  request.getParameter("minbid_ds");
    String pricing =  request.getParameter("pricing");

     aPrice = new BigDecimal("0");
     fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
     String c_prefix = fmt.getPrefix();
     String c_postfix = fmt.getSuffix();
     String audeposit_ds =  "";
     String minbid_ds =  "";

     if (minbid != null && !minbid.equals("")) 
	    minbid_ds =  c_prefix + minbid + c_postfix;   
     if (audeposit!= null && !audeposit.equals(""))
    	   audeposit_ds =  c_prefix + audeposit + c_postfix;


    //out.println("autype is " + autype);
    //out.println("editable is " + editable);
    

%>


<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>

	//parent.put(auctMinbid_ds,"<%= UIUtil.toJavaScript(minbid_ds) %>");

	//parent.put(auctDeposit_ds,"<%= UIUtil.toJavaScript(audeposit_ds) %>");

var aDefault = "";
var autype = parent.get(auctType, aDefault);  
var locale = parent.get(auctLocale, aDefault); 
var editable = parent.get(auctEditable); 
 
  //alert (" autype is " + autype );    

var titleCurrency = "<%= auctionNLS.get("Currency") %>";  
    //alert (" titleCurrency is " + titleCurrency );    
var titleOfferedPrice = "<%= auctionNLS.get("OfferedPrice") %>";
var titleMandatory = "<%= auctionNLS.get("mandatory") %>";
var titleDeposit = "<%= auctionNLS.get("DepositRequired") %>";
var titleReservedPrice = "<%= auctionNLS.get("ReservePrice") %>";
var titlePricing = "<%= auctionNLS.get("PricingMechanism") %>"; 


var i = 0;
var temp = "";


var msgMandatoryField  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField")) %>";
var msgInvalidNumber   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidNumber")) %>";
var msgInvalidPrice    = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidPrice")) %>";
var msgNegativeNumber  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgNegativeNumber")) %>";

function initializeState()
{
 
   if ( editable == "true") {
     document.PricingForm.aucur.value = parent.get(auctCur, aDefault);   
     if ( autype == "D" ) {
    	document.PricingForm.aucurprice.value = parent.get(auctCurPrice_ds, aDefault);   
        document.PricingForm.aucurprice.focus();
     }	
     else {
  	document.PricingForm.audeposit.value = parent.get(auctDeposit_ds, aDefault);   
        document.PricingForm.audeposit.focus();
  	document.PricingForm.minbid.value = parent.get(auctMinbid_ds, aDefault);  
  	
    	var pricing = parent.get(auctPricing, "ND");  
  	for (i=0;i<document.PricingForm.PricingSelect.length;i++) {
          if (document.PricingForm.PricingSelect[i].value == pricing){
		document.PricingForm.PricingSelect[i].click();
	     break;
   	  }
	}
 
     }
  }
  else {
     if ( autype == "D" ) { 
    	document.PricingForm.aucurprice.value = parent.get(auctCurPrice_ds, aDefault);   
        document.PricingForm.aucurprice.focus();
     }
  }

  //Check for Validation Error
  var errorCode = parent.getErrorParams();
  
  if ( autype == "D" )  {
     if ( errorCode == "errCurprice1" )
       reprompt(document.PricingForm.aucurprice, msgMandatoryField );
     if ( errorCode == "errCurprice2" )
       reprompt(document.PricingForm.aucurprice, msgInvalidPrice );
     if ( errorCode == "errCurprice3" )
       reprompt(document.PricingForm.aucurprice, msgNegativeNumber );
  }     
  else {
     if ( errorCode == "errMinbid1" )
       reprompt(document.PricingForm.minbid, msgInvalidPrice );
     if ( errorCode == "errMinbid2" )
       reprompt(document.PricingForm.minbid, msgNegativeNumber );
     if ( errorCode == "errMinbid3" )
       reprompt(document.PricingForm.minbid, msgInvalidNumber );

     if ( errorCode == "errDeposit1" )
       reprompt(document.PricingForm.audeposit, msgInvalidPrice );
     if ( errorCode == "errDeposit2" )
       reprompt(document.PricingForm.audeposit, msgNegativeNumber );
     if ( errorCode == "errDeposit3" )
       reprompt(document.PricingForm.audeposit, msgInvalidNumber );
  
  }

  parent.setContentFrameLoaded(true);

}

function savePanelData() {

  //alert("You have reached savePanelData()");

  
  // Save panel data in model 
  if ( editable == "true") {
     if (autype == "D" )    
      parent.put(auctCurPrice_ds, document.PricingForm.aucurprice.value);   
     else {
       parent.put(auctMinbid_ds, document.PricingForm.minbid.value);   
       parent.put(auctDeposit_ds, document.PricingForm.audeposit.value); 
       
       for (i=0;i< document.PricingForm.PricingSelect.length;i++) {
 	if (document.PricingForm.PricingSelect[i].checked){
             parent.put(auctPricing, document.PricingForm.PricingSelect[i].value);
	     break;
	}
       }
     }
  }
  else {
     if (autype == "D" )    
      parent.put(auctCurPrice_ds, document.PricingForm.aucurprice.value);   
  }  

}
function noenter() {
	return !(window.event && window.event.keyCode == 13); 
}

</SCRIPT>

</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctPricing") %></h1>

<FORM Name="PricingForm">
   
   <TABLE>

<%   if ( autype.equals("D") ) {
       if ( editable.equals("true") ) {
%>
          <TR>
	    <TD>
	    <LABEL>
	    <%= auctionNLS.get("Currency") %><BR>
	      <INPUT TYPE="text" NAME="aucur" SIZE="17" MAXLENGTH="26" VALUE=""   
	       onFocus="Javascript:document.PricingForm.aucurprice.focus()">    
	    </LABEL>
	    </TD>
          </TR> 
          <TR>
	    <TD>
   	    <LABEL>
	    <%= auctionNLS.get("OfferedPrice") %> <%= auctionNLS.get("mandatory") %><BR>
	      <INPUT TYPE="text" NAME="aucurprice" SIZE="30" MAXLENGTH="64" VALUE=" "onkeypress="return noenter()" >    
	    </LABEL>
	    </TD>
	  </TR>
<% } else {
%>
	<TR>
        <TD>
	 <%= auctionNLS.get("Currency") %>:  <I><%= UIUtil.toHTML(aucur) %></I> <BR>
	</TD>
	</TR>
          <TR>
            <TD>
   	    <LABEL>
	    <%= auctionNLS.get("OfferedPrice") %> <%= auctionNLS.get("mandatory") %><BR>
	      <INPUT TYPE="text" NAME="aucurprice" SIZE="30" MAXLENGTH="64" VALUE=" " onkeypress="return noenter()">    
   	    </LABEL>
	    </TD>
	  </TR>

<% } }
%>
	
<%   if ( !autype.equals("D") ) {
       if ( editable.equals("true") ) {
%>
        <TR>
          <TD>
	    <LABEL>
	    <%= auctionNLS.get("Currency") %><BR>
	    <INPUT TYPE="text" NAME="aucur" SIZE="17" MAXLENGTH="26" VALUE=""   
	     onFocus="Javascript:document.PricingForm.audeposit.focus()">
	     </LABEL>
	  </TD>
	</TR> 
        <TR>
          <TD>
	    <LABEL>
	    <%= auctionNLS.get("Deposit") %><BR> 
	    <INPUT TYPE="text" NAME="audeposit" SIZE="30"  MAXLENGTH="64" VALUE=" "> 
	    </LABEL>
	  </TD> 
	</TR> 
        <TR>
          <TD>
	    <LABEL>
	    <%= auctionNLS.get("ReservePrice") %><BR> 
	    <INPUT TYPE="text" NAME="minbid" SIZE="30" MAXLENGTH="64" VALUE=" "> 
	    </LABEL>
	  </TD>
	</TR> 
        <TR>
	<TD>
		<BR><%= auctionNLS.get("PricingMechanism") %><BR>
		<Label for="ND">
     		<INPUT TYPE="radio" NAME="PricingSelect" VALUE="ND" id="ND" CHECKED> 
		<%= auctionNLS.get("NonDiscriminative") %>
		</Label>
	</TD>
        </TR>
        <TR>
	<TD>
 		&nbsp;&nbsp;&nbsp;&nbsp;<%= auctionNLS.get("NonDiscriminativeDescriptionString") %> 

	</TD>
        </TR>

        <TR>
	<TD>
		<Label for="D">
	     	<INPUT TYPE="radio" NAME="PricingSelect" VALUE="D" id="D"> <%= auctionNLS.get("Discriminative") %>
		</Label>

	</TD>
        </TR>

        <TR>
	<TD>
		&nbsp;&nbsp;&nbsp;&nbsp;<%= auctionNLS.get("DiscriminativeDescriptionString") %> 

	</TD>
        </TR>

<% } else {
%>
	<TR>
	<TD> 
	       <%= auctionNLS.get("Currency") %>:  <I><%= UIUtil.toHTML(aucur) %></I> <BR>
	</TD>
	</TR>
	<TR>
	<TD> 
	       <%= auctionNLS.get("Deposit") %>:  <I><%= UIUtil.toHTML(audeposit_ds) %></I> <BR>
	</TD>
	</TR>
	<TR>
	<TD> 
	       <%= auctionNLS.get("ReservePrice") %>:  <I><%= UIUtil.toHTML(minbid_ds) %></I> <BR>
	</TD>
	</TR>
	<TR>
<%	if ( pricing.equals("ND") ) {
%>
	  <TD> 
	         <%= auctionNLS.get("PricingMechanism") %>:  <I><%= auctionNLS.get("NonDiscriminative") %></I> <BR>
	  </TD>
	  </TR>
<%      } else {
%>
	  <TD>
	         <%= auctionNLS.get("PricingMechanism") %>:  <I><%= auctionNLS.get("Discriminative") %></I> <BR>
	  </TD>
	  </TR>

<% } } }
%>
  
</TABLE>
</FORM>
</BODY>
</HTML>


