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
						com.ibm.commerce.server.*,
						java.math.*,
						com.ibm.commerce.negotiation.util.*,
						com.ibm.commerce.negotiation.misc.*, com.ibm.commerce.negotiation.operation.*,
						com.ibm.commerce.utils.*"%>

<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>

<%
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

     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));

	//*** GET CURRENCY ***//
     CurrencyManager cm = CurrencyManager.getInstance();
     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);

     FormattedMonetaryAmount fmt = null;
     BigDecimal d= null;

	//*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
	Hashtable neg_properties = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",locale_obj);

	String stylename=null,ownerid=null,auctiontype=null,auctioncurrency=null;
	JSPHelper a_help = new JSPHelper(request);
	stylename = (String)a_help.getParameter("ProfileName"); 
	ownerid   = (String)a_help.getParameter("OwnerId");

%>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale_obj) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT>

var msgMandatoryField 	= '<%= UIUtil.toJavaScript((String)neg_properties.get("msgMandatoryField")) %>';
var msgFieldInvalidSize = '<%= UIUtil.toJavaScript((String)neg_properties.get("msgInvalidSize")) %>';
var ds_stylename 		= '<%= UIUtil.toJavaScript((String)neg_properties.get("StyleName")) %>';

function initializeState(){
	var code = parent.getErrorParams();
	if (code == "profileNameMissing")
		alertDialog(ds_stylename + ":" + msgMandatoryField);
	else 	if (code == "profileNameInvalidSize")
		alertDialog(ds_stylename + ":" + msgFieldInvalidSize);

	// If coming into this notebook for the first time,
	// populate Model with all the required data from the
	// bean. Format the data for display according to Locale.
	if (parent.get("firstvisit","true") != "false") {
		populateModel();
		populateTimeValues();
		formatModelData();
	}
	parent.put("firstvisit","false");

	retrievePanelData();
	parent.setContentFrameLoaded(true);
}


// This function picks up all the data coming from the database and 
// formats them in accordance with the User's Locale. Gets executed the very
// first time ONLY.
function formatModelData(){

	var lang = parent.get("lang","-1");

	tempvalue = parent.get("austtim","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString()))
		parent.put("austtim_ds",tempvalue);

	tempvalue = parent.get("auendtim","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString()))
		parent.put("auendtim_ds",tempvalue);

	tempvalue = parent.get("auhourdur","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString()))
		parent.put("auhourdur_ds",formatInteger(tempvalue,lang));
	else
		parent.put("auhourdur_ds","");
	

	tempvalue = parent.get("aumindur","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString()))
		parent.put("aumindur_ds",formatInteger(tempvalue,lang));
	else
		parent.put("aumindur_ds","");
}

function savePanelData(){
	var form=document.auctionStyleForm;
	parent.put("autype",form.autype.value);
	parent.put("ProfileName",form.ProfileName.value);
	parent.put("ownerid",form.ownerid.value);
}


function retrievePanelData(){
	var form = document.auctionStyleForm;
	form.ProfileName.value = parent.get("ProfileName","");
	form.ownerid.value = parent.get("ownerid","");
	form.autype.value = parent.get("autype","O");
}


function populateTimeValues(){
	var timdur = parent.get("autimdur","");
	if (!isInputStringEmpty(timdur)) {
		  var time1 = timdur.toString();
		  var hh = time1.substring(0,time1.indexOf(":"));
		  var mm = time1.substring(time1.indexOf(":") + 1);
		  parent.put("auhourdur",hh);
		  parent.put("aumindur",mm);
	}
	else {
		parent.put("auhourdur","");
		parent.put("aumindur","");
 	}
	
	var daydur = parent.get("audaydur","");
	if (daydur == "-1")
		parent.put("audaydur","");
}

function noenter() {
	return !(window.event && window.event.keyCode == 13); 
}
</SCRIPT>

<%--
   Get the AuctionStyleDataBean and its associated data. Assign these data to the
   Javascript model Hashtable.
 --%>


<jsp:useBean id="aStyle" class="com.ibm.commerce.negotiation.beans.AuctionStyleDataBean" >
<jsp:setProperty property="*" name="aStyle" />
<jsp:setProperty property="auctStyleOwnerId" name="aStyle" value="<%= ownerid %>"/>
<jsp:setProperty property="auctStyleName" name="aStyle" value="<%= stylename %>" />
</jsp:useBean>

<%
	out.println("<SCRIPT LANGUAGE='Javascript'>"); 
	out.println("function populateModel(){"); 
	if (stylename != null && !stylename.equals("")) { 
		com.ibm.commerce.beans.DataBeanManager.activate(aStyle, request);
		if (aStyle!=null) {
			auctiontype     = aStyle.getAuctionType();
			auctioncurrency = aStyle.getCurrency();

			// Monetary formatting
			String a_deposit = "", a_reserveprice="", a_offeredprice="";
			String fm_deposit = "",fm_reserveprice="", fm_offeredprice="";
			a_deposit      = aStyle.getDeposit();
			a_reserveprice = aStyle.getReservePrice();
			a_offeredprice = aStyle.getOpenPrice();
			if (a_deposit != null && a_deposit.length() > 0) {
					d   = new BigDecimal(a_deposit);
					if (d.doubleValue() > 0) {
	      				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
						fm_deposit = fmt.getFormattedValue();
					}
			}

			if (a_reserveprice != null && a_reserveprice.length() > 0) {
					d   = new BigDecimal(a_reserveprice);
					if (d.doubleValue() > 0) {
	      				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
						fm_reserveprice = fmt.getFormattedValue();
					}
			}

			if (a_offeredprice != null && a_offeredprice.length() > 0) {
					d   = new BigDecimal(a_offeredprice);
					if (d.doubleValue() > 0) {
	      				fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(d, defaultCurrency), storeAB, Integer.valueOf(lang));   
						fm_offeredprice = fmt.getFormattedValue();
					}
			}


			// Integer  formatting
			String a_day = "",a_stday = "",a_endday = "",a_quant = "";
			String fm_day = "",fm_stday = "",fm_endday = "",fm_quant = "";
			a_day  = aStyle.getDurationDays();
			if (a_day!= null && a_day.length() > 0){
				Double d_day = Double.valueOf(a_day);
 				Integer i_day = new Integer(d_day.intValue());
			 	java.text.NumberFormat numberFormatter;
				if (i_day.intValue() > 0 ) {
				 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
 					fm_day = numberFormatter.format(i_day);
				}
			}

			a_stday  = aStyle.getAuctStartDays();
			if (a_stday!= null && a_stday.length() > 0){
				Double d_day = Double.valueOf(a_stday);
 				Integer i_day = new Integer(d_day.intValue());
			 	java.text.NumberFormat numberFormatter;
				if (i_day.intValue() > 0 ) {
				 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
 					fm_stday = numberFormatter.format(i_day);
				}
			}

			a_endday  = aStyle.getAuctEndDays();
			if (a_endday!= null && a_endday.length() > 0){
				Double d_day = Double.valueOf(a_endday);
 				Integer i_day = new Integer(d_day.intValue());
			 	java.text.NumberFormat numberFormatter;
				if (i_day.intValue() > 0 ) {
				 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
 					fm_endday = numberFormatter.format(i_day);
				}
			}

			a_quant  = aStyle.getQuantity();
			if (a_quant!= null && a_quant.length() > 0){
				Double dtemp = Double.valueOf(a_quant);
 				Integer itemp = new Integer(dtemp.intValue());
			 	java.text.NumberFormat numberFormatter;
				if (itemp.intValue() > 0 ) {
				 	numberFormatter = java.text.NumberFormat.getNumberInstance(locale_obj);
 					fm_quant = numberFormatter.format(itemp);
				}
			}

			out.println("parent.put('ProfileName','" + UIUtil.toJavaScript(aStyle.getName()) + "')");
			out.println("parent.put('autype','"     + aStyle.getAuctionType() + "')");         
			out.println("parent.put('ownerid','"    + aStyle.getOwnerId() + "')");
			out.println("parent.put('pricing','"    + aStyle.getClosePriceRule() + "')");                        
			out.println("parent.put('quant','"      + a_quant + "')");         
			out.println("parent.put('audeposit','"  + a_deposit + "')");                        
			out.println("parent.put('minbid','"     + a_reserveprice + "')");                        
			out.println("parent.put('aucurprice','" + a_offeredprice + "')");                        
			out.println("parent.put('austday','"    + a_stday + "')");  
			out.println("parent.put('auendday','"   + a_endday + "')");                                                
			out.println("parent.put('audaydur','"   + a_day + "')");
			out.println("parent.put('quant_ds','"      + fm_quant + "')");         
			out.println("parent.put('audeposit_ds','"  + fm_deposit + "')");                        
			out.println("parent.put('minbid_ds','"     + fm_reserveprice + "')");                        
			out.println("parent.put('aucurprice_ds','" + fm_offeredprice + "')");                        
			out.println("parent.put('austday_ds','"    + fm_stday + "')");  
			out.println("parent.put('auendday_ds','"   + fm_endday + "')");                                                
			out.println("parent.put('audaydur_ds','"   + fm_day + "')");
			out.println("parent.put('aurulemacro','"+ UIUtil.toJavaScript(aStyle.getRulePage()) + "')");                        
			out.println("parent.put('auprdmacro','" + UIUtil.toJavaScript(aStyle.getItemPage()) + "')");                        
			out.println("parent.put('aubdrule','"   + aStyle.getBidRuleId() + "')");                                       
			out.println("parent.put('auruletype','" + aStyle.getCloseType() + "')");
			out.println("parent.put('aucur','" + auctioncurrency + "')");

			if (aStyle.getCloseType().equals("4"))
				out.println("parent.put('ANDOR','AND')");

		
			// Get the hh:mm portion of the timestamp
			String temp_ts = aStyle.getStartTime();
			String new_ts = "";
			if (temp_ts != null && !temp_ts.equals(""))
				new_ts = TimestampHelper.getTimeFromTimestamp(java.sql.Timestamp.valueOf(temp_ts));
			out.println("parent.put('austtim','"    + new_ts + "')");                        

			temp_ts = aStyle.getEndTime();
			new_ts = "";
			if (temp_ts != null && !temp_ts.equals(""))
				new_ts = TimestampHelper.getTimeFromTimestamp(java.sql.Timestamp.valueOf(temp_ts));
			out.println("parent.put('auendtim','"   + new_ts + "')");

			temp_ts = aStyle.getDuration();
			new_ts = "";
			if (temp_ts != null && !temp_ts.equals(""))
				new_ts = TimestampHelper.getTimeFromTimestamp(java.sql.Timestamp.valueOf(temp_ts));
			out.println("parent.put('autimdur','"   + new_ts + "')");

			out.println("parent.put('lang','" + lang + "')");
			out.println("parent.put('defaultCurrency','" + defaultCurrency + "')");
		}
	}
    out.println("}"); 
    out.println("</SCRIPT>"); 
%>

</HEAD>


<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= neg_properties.get("AStyleType") %></h1>


<FORM NAME="auctionStyleForm">
<INPUT TYPE=HIDDEN NAME="ownerid" VALUE="<%= ownerid%>">
<INPUT TYPE=HIDDEN NAME="autype" VALUE="">
 <TABLE ALIGN="LEFT">
	<TR>
	<TD>
		<%= neg_properties.get("StyleName") %>: <I><%= stylename %></I><BR><BR>	
      	<INPUT type="hidden" name="ProfileName" value="">
	</TD>
	</TR>
	<TR>
	<TD>
		<%= neg_properties.get("auctionType") %>: 
<% if (auctiontype!=null && auctiontype.equals(AuctionConstants.EC_AUCTION_OPEN_CRY_TYPE)){ %>
			<I><%= neg_properties.get("opencry") %></I>
<% }else if (auctiontype!=null && auctiontype.equals(AuctionConstants.EC_AUCTION_SEALED_BID_TYPE)){ %>
			<I><%= neg_properties.get("sealedbid") %></I>
<% }else if (auctiontype!=null && auctiontype.equals(AuctionConstants.EC_AUCTION_DUTCH_TYPE)){ %>
			<I><%= neg_properties.get("dutch") %></I>
<% } %>
	</TD>
	</TR>
</TABLE>

</FORM>
</BODY>
</HTML>

