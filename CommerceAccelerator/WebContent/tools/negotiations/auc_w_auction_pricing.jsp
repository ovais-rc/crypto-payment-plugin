<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

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
<%@  include file="../common/common.jsp" %>

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
//  String emptyString = new String("");
  String zeroPrice = "0";

  String autype = request.getParameter("autype");
  //out.println("autype received is: " + autype);
  String locale = request.getParameter("locale");

%>

<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctPricing") %></h1>


<FORM Name="PricingForm">
    <!--<FONT SIZE=+1><B><%= auctionNLS.get("AuctionDetail") %></B></FONT><BR>-->
   
   <TABLE>

  <%  if ( autype.equals("D") )
      { %>
   <TR  >
	<TD>
		<LABEL>
		<%= auctionNLS.get("Currency") %><BR>
		<INPUT TYPE="text"
                	      NAME="aucur"
	                      SIZE=17 
        	              MAXLENGTH="26"
                	      VALUE="USD"   
                	       onFocus="Javascript:document.PricingForm.aucurprice.focus()">   
		</LABEL>
	</TD>
   </TR>
  <%  } else { %>   
   <TR  >
	<TD>
		<LABEL>
		<%= auctionNLS.get("Currency") %><BR>
		<INPUT TYPE="text"
                	      NAME="aucur"
	                      SIZE=17 
        	              MAXLENGTH="26"
                	      VALUE="USD"   
                	       onFocus="Javascript:document.PricingForm.audeposit.focus()">   
		</LABEL>
	</TD>
   </TR>
   <% }  %>

  <%  if ( autype.equals("D") )
      { %>
	<TR >
	   <TD>
		        <LABEL>
			<%= auctionNLS.get("OfferedPrice") %> <%= auctionNLS.get("mandatory") %><BR>
			<INPUT TYPE="text"
                       		NAME="aucurprice"
                       		SIZE=30
                       		MAXLENGTH="64"
                       		VALUE=" "> 
		        </LABEL>
	   </TD>
        </TR>        
  <%  } else { %>   
   <TR>
	<TD>
	        <LABEL>
		<%= auctionNLS.get("Deposit") %><BR>
		<INPUT TYPE="text"
                 NAME="audeposit"
                 SIZE=30 
                 MAXLENGTH="64"
                 VALUE=" ">   
	        </LABEL>
	</TD>
   </TR>
   <TR>
	<TD>
	        <LABEL>
		<%= auctionNLS.get("ReservePrice") %> <BR>   <!-- Also known as minimum bid -->
		<INPUT TYPE="text"
			NAME="minbid"
                       SIZE=30 
                       MAXLENGTH="64"
                       VALUE=" ">   
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
 		<%= auctionNLS.get("NonDiscriminativeDescriptionString") %> 

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
		<%= auctionNLS.get("DiscriminativeDescriptionString") %> 

	</TD>
   </TR>

   <% }  %>
	
   
</TABLE>
<SCRIPT LANGUAGE="JavaScript">
var msgMandatoryField = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField")) %>";
var msgInvalidPrice   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidPrice")) %>";
var msgNegativeNumber = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgNegativeNumber")) %>";
var locale = "<%= UIUtil.toJavaScript(locale) %>"; 

var i = 0;
var aDefault = "";
var temp = "";
var msgNotFloat = "<%= auctionNLS.get("msgNotFloat") %>";
var lang;


function initializeState()
{

  lang   = parent.get(auctLang);
  document.PricingForm.aucur.value = parent.get(auctCur_ds, "USD");  
   
  if ( "<%= UIUtil.toJavaScript(autype) %>" == "D" ) {
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


  parent.setContentFrameLoaded(true);

  
}

function savePanelData() {

  parent.put(auctCur, document.PricingForm.aucur.value);   
  if ("<%= UIUtil.toJavaScript(autype) %>" != "D" ) {   
     
     parent.put(auctMinbid_ds, document.PricingForm.minbid.value); 
     if (!isInputStringEmpty(document.PricingForm.minbid.value)) {
       temp = currencyToNumber(document.PricingForm.minbid.value, document.PricingForm.aucur.value, lang);
       parent.put(auctMinbid, temp);
     }  
     else
       parent.put(auctMinbid, document.PricingForm.minbid.value);
        
     parent.put(auctDeposit_ds, document.PricingForm.audeposit.value);   
     if (!isInputStringEmpty(document.PricingForm.audeposit.value)) {
       temp = currencyToNumber(document.PricingForm.audeposit.value, document.PricingForm.aucur.value, lang);
       parent.put(auctDeposit, temp);   
     }
     else
       parent.put(auctDeposit, document.PricingForm.audeposit.value);   
     
     for (i=0;i< document.PricingForm.PricingSelect.length;i++) {
 	if (document.PricingForm.PricingSelect[i].checked){
             parent.put(auctPricing, document.PricingForm.PricingSelect[i].value);
	     break;
	}
     }

     parent.put(auctCurPrice_ds, "<%= zeroPrice %>");   

  } 
  else {
     parent.put(auctCurPrice_ds, document.PricingForm.aucurprice.value);  
     if (!isInputStringEmpty(document.PricingForm.aucurprice.value)) { 
       temp = currencyToNumber(document.PricingForm.aucurprice.value, document.PricingForm.aucur.value, lang);
       parent.put(auctCurPrice, temp);   
     }
     else
       parent.put(auctCurPrice, document.PricingForm.aucurprice.value);   

  }

  parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData() {
  
    var form     = document.PricingForm;
 
    if ( "<%= UIUtil.toJavaScript(autype) %>" == "D" ){

        if (isInputStringEmpty(form.aucurprice.value)) {
         	reprompt(form.aucurprice, msgMandatoryField);
         	return false;
        }

        if ( isValidCurrency(form.aucurprice.value, form.aucur.value, lang) == false ) {
  	   reprompt(form.aucurprice, msgInvalidPrice);
  	   return false;
	}

        temp = currencyToNumber(form.aucurprice.value, form.aucur.value, lang)
        if ( temp != null) {
            if ( temp < 0 ) {
  	        reprompt(form.aucurprice, msgNegativeNumber);
  	        return false;
            }
        }

        parent.put(auctCurPrice, temp);   
        
    } 
    else {
	if (!isInputStringEmpty(form.minbid.value)) {
           if ( isValidCurrency(form.minbid.value, form.aucur.value, lang) == false ) {
  	     reprompt(form.minbid, msgInvalidPrice);
  	     return false;
  	   }  
           temp = currencyToNumber(form.minbid.value, form.aucur.value, lang)
           if ( temp != null) {
              if ( temp < 0 ) {
  	        reprompt(form.minbid, msgNegativeNumber);
  	        return false;
              }
           }

           parent.put(auctMinbid, temp);   

	}

	
	if (!isInputStringEmpty(form.audeposit.value)) {
           if ( isValidCurrency(form.audeposit.value, form.aucur.value, lang) == false ) {
  	     reprompt(form.audeposit, msgInvalidPrice);
  	     return false;
  	   }  
           
           temp = currencyToNumber(form.audeposit.value, form.aucur.value, lang)
           if ( temp != null) {
              if ( temp < 0 ) {
  	        reprompt(form.audeposit, msgNegativeNumber);
  	        return false;
              }
           }
           
           parent.put(auctDeposit, temp);   
  
        }
    }
}  


</SCRIPT>

</FORM>
</BODY>
</HTML>

