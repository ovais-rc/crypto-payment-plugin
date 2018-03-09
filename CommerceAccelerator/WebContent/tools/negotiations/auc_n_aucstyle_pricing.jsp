<!-- ========================================================================
 Licensed Materials - Property of IBM

 WebSphere Commerce

 (c) Copyright IBM Corp. 2000, 2002

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%@page language="java" import=	"com.ibm.commerce.tools.test.*,
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
	String selectedAuctionType = (String)request.getParameter("autype");
	
      //*** GET LANGID AND STOREID FROM COMANDCONTEXT ***//
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
 	String   StoreId = "0";
	String   lang =  "-1";  
	Locale   locale_obj = null;
      if( aCommandContext!= null ){
            lang = aCommandContext.getLanguageId().toString();
            locale_obj = aCommandContext.getLocale();
            StoreId = aCommandContext.getStoreId().toString();
      }
	if (locale_obj == null)
		locale_obj = new Locale("en","US");

     //*** GET OWNER ***//        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     String   ownerid =  storeAB.getMemberId();

	//*** GET CURRENCY ***//     
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>

// The following values will be accessed from the External Javascript function
// validateAllPanels()
var msgInvalidInteger 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidInteger")) %>';
var msgInvalidNumber 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidNumber")) %>';
var msgNonNegative 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgNegativeNumber")) %>';
var msgInvalidPrice     = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidPrice")) %>';
 
var ds_deposit		= '<%= UIUtil.toJavaScript((String)neg_properties.get("Deposit")) %>';
var ds_minbid		= '<%= UIUtil.toJavaScript((String)neg_properties.get("ReservePrice")) %>';
var ds_pricing		= '<%= UIUtil.toJavaScript((String)neg_properties.get("PricingMechanism")) %>';
var ds_aucurprice		= '<%= UIUtil.toJavaScript((String)neg_properties.get("OfferedPrice")) %>';
var ds_quant		= '<%= UIUtil.toJavaScript((String)neg_properties.get("AuctionQuantity")) %>';
var currency            = parent.get("aucur","");

function initializeState()
{
   var code = parent.getErrorParams();

   if (code == "quantityError")
        alertDialog(ds_quant + " : " + msgInvalidInteger);
   else if (code == "quantityNegative")
        alertDialog(ds_quant + " : " + msgNonNegative);
   else if (code == "depositError")
        alertDialog(ds_deposit + " : " + msgInvalidPrice);
   else if (code == "depositNegative")
        alertDialog(ds_deposit + " : " + msgNonNegative);
   else if (code == "minbidError")
        alertDialog(ds_minbid + " : " + msgInvalidPrice);
   else if (code == "minbidNegative")
        alertDialog(ds_minbid + " : " + msgNonNegative);
   else if (code == "curpriceError")
        alertDialog(ds_aucurprice + " : " + msgInvalidPrice);
   else if (code == "curpriceNegative")
        alertDialog(ds_aucurprice + " : " + msgNonNegative);

   parent.setContentFrameLoaded(true);
}

function savePanelData(){
	var form = document.PricingForm;
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
		<%= neg_properties.get("Currency") %>: <I> 
			<SCRIPT LANGUAGE="Javascript">
				document.write(currency);
			</SCRIPT>
		</I><BR><BR>
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
		<%= neg_properties.get("Currency") %>: <I> 		
			<SCRIPT LANGUAGE="Javascript">
				document.write(currency);
			</SCRIPT>
			</I>
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


