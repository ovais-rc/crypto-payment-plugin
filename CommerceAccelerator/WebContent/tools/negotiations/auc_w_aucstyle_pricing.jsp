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
			com.ibm.commerce.common.objects.*,
			com.ibm.commerce.price.utils.*,
			com.ibm.commerce.negotiation.misc.*,
			com.ibm.commerce.negotiation.operation.*,
			com.ibm.commerce.negotiation.util.*" %>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
      //*** GET LANGID,LOCALE AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId 	= "0";
	String   lang	=  "1";  
	Locale   locale_obj = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
		locale_obj = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale_obj == null)
		locale_obj = new Locale("en","US");

	StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));

	//*** GET CURRENCY ***//	     
	CurrencyManager cm = CurrencyManager.getInstance();
	Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
	String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    


	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties= (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
	String selectedAuctionType = (String)request.getParameter("autype");
%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>

var msgInvalidInteger 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidInteger")) %>';
var msgInvalidNumber 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidNumber")) %>';
var msgInvalidCurrency 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidPrice")) %>';
var msgNegativeNumber 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgNegativeNumber")) %>'

function initializeState()
{
	parent.setContentFrameLoaded(true);
}

//******************************************
// This function should do the following
// for every form element:
// i) Validate the input
// ii)Remove all the locale specific formatting 
//    before saving it in Model.
// ******************************************
function validatePanelData() 
{
	var form = document.PricingForm;
	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") 
	{		
		if (!isInputStringEmpty(form.quant.value) ) {
			if(!isValidInteger(form.quant.value, "<%= lang %>")){
				reprompt(form.quant, msgInvalidInteger);
		     		return false;  
			}
			var p_quant = form.quant.value;
		      if (p_quant.charAt(0) == '-'){
				reprompt(form.quant, msgNegativeNumber);
		     		return false;  
			}
			var p_quant = strToNumber(form.quant.value, "<%= lang %>")
			parent.put("quant",p_quant);
		}else
			parent.put("quant","");

		if (!isInputStringEmpty(form.audeposit.value) ) {
	    		var deposit = form.audeposit.value;
	     		if (!isValidCurrency(deposit,"<%= defaultCurrency %>","<%= lang %>")){
				reprompt(form.audeposit, msgInvalidCurrency);
				return false;  
			}
			if (deposit.charAt(0) == "-"){
			     reprompt(form.audeposit, msgNegativeNumber)
			     return false  
			}
			var p_deposit = currencyToNumber(form.audeposit.value, "<%= defaultCurrency %>", "<%= lang %>");
			parent.put("audeposit",p_deposit);
		} else
			parent.put("audeposit","");

		if (!isInputStringEmpty(form.minbid.value) ) {
			var minbid = form.minbid.value;
			if (!isValidCurrency(minbid,"<%= defaultCurrency %>","<%= lang %>")){
				reprompt(form.minbid, msgInvalidCurrency)
				return false  
			}
			if (minbid.charAt(0) == "-"){
				reprompt(form.minbid, msgNegativeNumber)
				return false  
			}
			var p_minbid = currencyToNumber(form.minbid.value, "<%= defaultCurrency %>", "<%= lang %>");
			parent.put("minbid",p_minbid);
		}else
			parent.put("minbid","");
	}
	else {
		// Dutch Type

		if (!isInputStringEmpty(form.quant.value) ) {

			if(!isValidInteger(form.quant.value, "<%= lang %>")){
				reprompt(form.quant, msgInvalidInteger);
		     		return false;  
			}
			var p_quant   = form.quant.value;
		      if (p_quant.charAt(0) == '-'){
				reprompt(form.quant, msgNegativeNumber);
		     		return false;  
			}
			var p_quant = strToNumber(form.quant.value, "<%= lang %>")
			parent.put("quant",p_quant);
		}else
			parent.put("quant","");
		
		if (!isInputStringEmpty(form.aucurprice.value) ) {
			var aucurprice = form.aucurprice.value;
			if (!isValidCurrency(aucurprice,"<%= defaultCurrency %>","<%= lang %>")){
				reprompt(form.aucurprice, msgInvalidCurrency)
				return false  
			}
			if (aucurprice.toString().charAt(0) == "-"){
				reprompt(form.aucurprice, msgNegativeNumber)
				return false  
			}
			var p_curprice = currencyToNumber(form.aucurprice.value, "<%= defaultCurrency %>", "<%= lang %>");
			parent.put("aucurprice",p_curprice);
		}else
			parent.put("aucurprice","");
	}
}

function savePanelData()
{
	var form = document.PricingForm;
	parent.put("aucur","<%= defaultCurrency %>");
	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") 
	{		
		for (i=0;i<form.pricing.length;i++) {
			if (form.pricing[i].checked){
				parent.put("pricing",form.pricing[i].value);
				break;
			}
		}
		parent.put("quant_ds",form.quant.value);
		parent.put("minbid_ds",form.minbid.value);
		parent.put("audeposit_ds",form.audeposit.value);
		parent.put("aucurprice","");
	}
	else { // Dutch Type
		parent.put("audeposit_ds","");
		parent.put("minbid_ds","");
		parent.put("pricing","");
		parent.put("aucurprice_ds",form.aucurprice.value);
		parent.put("quant_ds",form.quant.value);
	}
	
	parent.addURLParameter("authToken", "${authToken}");
}

function retrievePanelData()
{
	var form = document.PricingForm;
	if (parent.get("autype") != "<%= AuctionConstants.EC_AUCTION_DUTCH_TYPE %>") 
	{
		var pricing = parent.get("pricing","ND");
		for (i=0;i<form.pricing.length;i++) {
			if (form.pricing[i].value == pricing){
				form.pricing[i].click();
				break;
			}
		}
		form.audeposit.value = parent.get("audeposit_ds","");
		form.quant.value     = parent.get("quant_ds","");
		form.minbid.value    = parent.get("minbid_ds","");
	}
	else { // Dutch Type
		form.aucurprice.value = parent.get("aucurprice_ds","");
		form.quant.value   = parent.get("quant_ds","");
	}
}

</SCRIPT>
</HEAD>



<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= neg_properties.get("AStylePricing") %></h1>


<FORM NAME="PricingForm">
 <TABLE ALIGN="LEFT">
<% 	if (!selectedAuctionType.equals(AuctionConstants.EC_AUCTION_DUTCH_TYPE)) {
%>

	<TR>
	<TD>
		<%= neg_properties.get("Currency") %>: <%= defaultCurrency %>
		<BR>	
	</TD>
	</TR>


	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("AuctionQuantity") %><BR>	
      	<INPUT size="17" type="input" name="quant" maxlength="64">
		</Label>
	</TD>
	</TR>

	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("Deposit") %><BR>	
      	<INPUT size="30" type="input" name="audeposit" maxlength="64">
		</Label>
	</TD>
	</TR>

	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("ReservePrice") %><BR>	
      	<INPUT size="30" type="input" name="minbid" maxlength="64">
		</Label>
	</TD>
	</TR>

	<TR>
	<TD>
		<%= neg_properties.get("PricingMechanism") %><BR>
		<Label for="ND">
     		<INPUT TYPE="radio" NAME="pricing" VALUE="ND" id="ND" CHECKED> 
		<%= neg_properties.get("NonDiscriminative") %>
		</Label>
	</TD>
	</TR>
	<TR>
	<TD>
		
		<%= neg_properties.get("NonDiscriminativeDescriptionString") %> 

	</TD>
	</TR>

	<TR>
	<TD>
		<Label for="D">
	     	<INPUT TYPE="radio" NAME="pricing" VALUE="D" id="D"> <%= neg_properties.get("Discriminative") %>
		</Label>

	</TD>
	</TR>

	<TR>
	<TD>
		<%= neg_properties.get("DiscriminativeDescriptionString") %> 

	</TD>
	</TR>
<% } else {
%>
	<TR>
	<TD>
		<%= neg_properties.get("Currency") %>: <%= defaultCurrency %>
		<BR><BR>	
	</TD>
	</TR>

	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("AuctionQuantity") %><BR>	
      	<INPUT size="30" type="input" name="quant" maxlength="64">
		</Label>
	</TD>
	</TR>

	<TR>
	<TD>
		<Label>
		<%= neg_properties.get("OfferedPrice") %><BR>	
      	<INPUT size="30" type="input" name="aucurprice" maxlength="64">
		</Label>
	</TD>
	</TR>
<%}%>
 </TABLE>
</FORM>


<SCRIPT LANGUAGE="Javascript">
retrievePanelData();
</SCRIPT>
</BODY>
</HTML>


