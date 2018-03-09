<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.

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
<%@  page import="com.ibm.commerce.negotiation.beans.*" %>
<%@  page import="com.ibm.commerce.negotiation.bean.commands.*" %>
<%@  page import="com.ibm.commerce.negotiation.objects.*"  %>
<%@  page import="com.ibm.commerce.negotiation.util.*"  %>
<%@  page import="com.ibm.commerce.negotiation.misc.*"  %>
<%@  page import="com.ibm.commerce.negotiation.operation.*"  %>
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.catalog.beans.*" %>
<%@  page import="com.ibm.commerce.beans.*"  %>
<%@  page import="com.ibm.commerce.command.*"  %>
<%@  page import="com.ibm.commerce.exception.*"  %>
<%@  page import="com.ibm.commerce.price.utils.*"  %>
<%@  page import="com.ibm.commerce.common.objects.*"  %>
<%@  page import="java.sql.*"  %>
<%@  page import="com.ibm.commerce.utils.*" %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
     String   emptyString = "";
     String   zeroPrice = "0";
     String   StoreId = "0";
     Integer  aLang = new Integer("-1");
//     String   lang =  "-1";  
     Locale   aLocale = null;
     String   locale = "en_US";

     String auctid = request.getParameter("auctionId"); 


     //***Get lang id, locale and storeid from CommandContext
      CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
        if( aCommandContext!= null )
        {
            aLang = aCommandContext.getLanguageId();
//            lang = aLang.toString();
            aLocale = aCommandContext.getLocale();
            locale = aLocale.toString();
            StoreId = aCommandContext.getStoreId().toString();
        }
    
      
     //***Get currency        
     StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
     
     CurrencyManager cm = CurrencyManager.getInstance();
//     Integer defaultLanguageId = new Integer(Integer.parseInt(lang));
//     String defaultCurrency = cm.getDefaultCurrency(storeAB, defaultLanguageId);    
     //out.println("<BR>Default Currency is " + defaultCurrency);

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);


%>
<jsp:useBean id="auction" class="com.ibm.commerce.negotiation.beans.AuctionInfoDataBean" >
<jsp:setProperty property="auctionId" name="auction" value="<%= auctid %>" />
<jsp:setProperty property="auctStoreId" name="auction" value="<%= StoreId %>" />
</jsp:useBean>

<jsp:useBean id="autobid" class="com.ibm.commerce.negotiation.beans.AutoBidListBean" >
<jsp:setProperty property="*" name="autobid" />
<jsp:setProperty property="auctionId" name="autobid" value="<%= auctid %>" />
<jsp:setProperty property="autoBidStatus" name="autobid" value="A" />
</jsp:useBean>


<%
    com.ibm.commerce.beans.DataBeanManager.activate(auction, request);
%>
<%
  String  ownerid = auction.getOwnerId();  
  String  austatus= auction.getStatus();
  //out.println("austatus is: " + austatus);
  
  String autype= auction.getAuctionType();
  
  //format quantity
  String  quant_ds = ""; 
  quant_ds = auction.getQuantity();
  if (quant_ds!= null && quant_ds.length() > 0){
	Double dtemp = Double.valueOf(quant_ds);
 	Integer itemp = new Integer(dtemp.intValue());
 	java.text.NumberFormat numberFormatter;
	if (itemp.intValue() > 0 ) {
	 	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
 		quant_ds = numberFormatter.format(itemp);
	}
  }


  String  aucur= auction.getCurrency();
  String  auruletype= auction.getCloseType();

  String  minbid= auction.getReservePrice();
  String  audeposit = auction.getDeposit();
  String  aucurprice= auction.getCurrentPrice();

  String  minbid_ds = "";
  String  minbid_ds2 = "";
  String  audeposit_ds = "";
  String  audeposit_ds2 = "";
  String  aucurprice_ds = "";


    //format prices
    FormattedMonetaryAmount fmt = null;
    BigDecimal   aPrice = null;

    if ( !minbid.equals(emptyString) && minbid != null ) {
       aPrice = new BigDecimal(minbid);
	 if (aPrice.doubleValue() > 0 ) {
	       fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
      	 minbid_ds = fmt.toString();
	       minbid_ds2 = fmt.getFormattedValue();
	}
    }
  
    
    if ( !audeposit.equals(emptyString) && audeposit != null) {
       aPrice = new BigDecimal(audeposit);
	 if (aPrice.doubleValue() > 0 ) {
	       fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
      	 audeposit_ds = fmt.toString();
	       audeposit_ds2 =  fmt.getFormattedValue();
	 }
    }

    if ( !aucurprice.equals(emptyString)  && aucurprice != null) {
       aPrice = new BigDecimal(aucurprice);
       fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
       aucurprice_ds = fmt.getFormattedValue();
    }

  String  pricing = auction.getClosePriceRule(); 
  if (pricing == null) {
	  pricing = "";
  }
  
  String  austdate= auction.getAuctStartDate();
  String  styy = auction.getAuctStartYear(); 
  String  stmm  = auction.getAuctStartMonth(); 
  String  stdd = auction.getAuctStartDay(); 

  String   sthh = "";
  String   stmin = "";
  String   stss = "";
  String   endhh = "";
  String   endmin = "";
  String   endss = "";
//  TimestampHelper tsh = new TimestampHelper(0, 0, 1, 0, 0, 0, 0); 
  Timestamp start_ts = null;
  Timestamp end_ts = null;
  String start_time = "";
  String end_time = "";
  
  if ( auction.getStartTimeInEntityType() != null) {
     start_ts = auction.getStartTimeInEntityType();
     start_time = TimestampHelper.getTimeFromTimestamp(start_ts);
  } else {
    start_time = "";
  }
  String austtime = auction.getAuctStartTime();
  if ( !austtime.equals(emptyString) ) { 
     sthh = auction.getAuctStartHour();
     stmin = auction.getAuctStartMinute();
     stss = auction.getAuctStartSecond();
   	  
     if ( (sthh.substring(0,1)).equals("0") ) {
        sthh = sthh.substring(1);
     }
     if ( (stmin.substring(0,1)).equals("0") ) {
        stmin = stmin.substring(1);
     }
     if ( (stss.substring(0,1)).equals("0") ) {
        stss = stss.substring(1);
     }
  }
  
  String  auenddat= auction.getAuctEndDate();
  String  endyy = auction.getAuctEndYear(); 
  String  endmm  = auction.getAuctEndMonth(); 
  String  enddd = auction.getAuctEndDay(); 

  if ( auction.getEndTimeInEntityType() != null) {
     end_ts = auction.getEndTimeInEntityType();
     end_time = TimestampHelper.getTimeFromTimestamp(end_ts);
  } else {
     end_time = "";
  }
  String  auendtim= auction.getAuctEndTime();
  if ( !auendtim.equals(emptyString) ) { 
     endhh = auction.getAuctEndHour();
     endmin = auction.getAuctEndMinute();
     endss = auction.getAuctEndSecond();
   	  
     if ( (endhh.substring(0,1)).equals("0") ) {
        endhh = endhh.substring(1);
     }
     if ( (endmin.substring(0,1)).equals("0") ) {
        endmin = endmin.substring(1);
     }
     if ( (endss.substring(0,1)).equals("0") ) {
        endss = endss.substring(1);
     }

  }

  String  autimdur= auction.getAuctDurationTime();
  String  audaydur= auction.getDurationDays();
  String  auhourdur = auction.getAuctDurationHour();
  String  aumindur  = auction.getAuctDurationMinute();    

  //Set duration to blanks if close type is 1
  if ( auruletype.equals("1") ) {
     audaydur = "";
     auhourdur = "";
     aumindur = "";
  }    

  String  aurulemacro= auction.getRulePage();
  String  auprdmacro= auction.getItemPage();
  String  aubdrule= auction.getBidRuleId();
  //out.println("<BR>aubdrule is " + aubdrule);
  if ( aubdrule == null ) {
    aubdrule = "";
  }
  Integer id = aLang;
  String  ausdesc = auction.getShortDescription(id);
  String  auldesc = auction.getLongDescription(id);
  String  product_id = auction.getEntryId();
  String  proddesc = "";
  String  prodname = "";
  String  sku = "";

%>
<%     
	String  editable = "true";
	if ( austatus.equals("C")) {
		editable = "false";
	} else {
		if ( austatus.equals("F")) {
			//@DetermineIfAnyOrderBids()
			com.ibm.commerce.beans.DataBeanManager.activate(autobid, request);
			
			AutoBidDataBean[] autobids = autobid.getAutoBids();
			if ( autobids.length > 0 ) {
				//out.println("There are " + autobids.length + " autobids");
				editable = "false";
			} else {
				//out.println("There are " + "no autobids");
				editable = "true"; 
			}
		} else {
			editable = "none";
		}
	}
%> 
<jsp:useBean id="item" class="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" >
<jsp:setProperty property="catalogEntryID" name="item" value="<%= product_id %>" />
</jsp:useBean>

<%     
     try{   
        //Get SKU
      	CatalogEntryAccessBean cb = new CatalogEntryAccessBean(); 
        cb.setInitKey_catalogEntryReferenceNumber(product_id);
        sku = cb.getPartNumber();

        //Get item description
        com.ibm.commerce.beans.DataBeanManager.activate(item, request);
        Integer lid = aLang;
        proddesc = item.getDescription(lid).getShortDescription();
        prodname = item.getDescription(lid).getName();
     }
     catch( Exception e ) {
         ;
	 }    

%>   


<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_datetime.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>
var aDefault = null;
var locale = "<%= locale %>"; 
var lang;
var temp = "";; 
var i = 0;
var aTime;
var ampmIndicator;
var delimiter; 

var msgMandatoryField  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgMandatoryField")) %>";
var msgInvalidNumber   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidNumber")) %>";
var msgInvalidInteger  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgInvalidInteger")) %>";
var msgQuantityCheck   = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgQuantityCheck")) %>";
var msgNegativeNumber  = "<%= UIUtil.toJavaScript( (String)auctionNLS.get("msgNegativeNumber")) %>";


function initializeState()
{
	
   if ( parent.get(auctId, aDefault) != null && "<%= editable %>" != "none") {
     document.ItemForm.quant.value =   parent.get(auctQuantity_ds, aDefault);   
   }  
   
  //Check if there is a validation error 
 
   var errorCode = parent.getErrorParams();
     
   if ( errorCode == "errQuant1" )
       reprompt(document.ItemForm.quant, msgMandatoryField );
   if ( errorCode == "errQuant2" )
       reprompt(document.ItemForm.quant, msgInvalidNumber );
   if ( errorCode == "errQuant3" )
       reprompt(document.ItemForm.quant, msgQuantityCheck );
   if ( errorCode == "errQuant4" )
       reprompt(document.ItemForm.quant, msgInvalidInteger );
   if ( errorCode == "errQuant5" )
       reprompt(document.ItemForm.quant, msgNegativeNumber );

   document.ItemForm.quant.focus();
   parent.setContentFrameLoaded(true);
  
}

function savePanelData() {

  //alert("You have reached savePanelData()");
  
  //if firsttime, put auction info from database in model.  
  //We know we won't find auction type  from model  
  if ( parent.get(auctType, aDefault) == null ) {
     parent.put(auctId, "<%= UIUtil.toJavaScript(auctid) %>");
     parent.put(auctLang, "<%= aLang %>"); 
     parent.put(auctLocale, "<%= locale %>"); 
     parent.put(auctOwnerid, "<%= ownerid %>"); 
     parent.put(auctStoreid, "<%= StoreId %>"); 
     parent.put(auctType, "<%= autype %>"); 
     parent.put(auctRuleType, "<%= auruletype %>");
     if ( "<%= auruletype %>" == "1" || "<%= auruletype %>" == "2" || "<%= auruletype %>" == "3") {
        parent.put(auctOrChecked, "true");
        parent.put(auctAndChecked, "false");
     }   
  else if ( "<%= auruletype %>" == "4" ) {
             parent.put(auctOrChecked, "false");
             parent.put(auctAndChecked, "true");
       }   
  else {
          parent.put(auctOrChecked, "true");
          parent.put(auctAndChecked, "false");
       }
    var and_checked = "false";

     if ( AMPMIndicator == "Yes")
       temp = "1"; 
     else
       temp = "0";    
     parent.put(auctTimeFlag, temp );
     parent.put(auctRuleMacro, "<%= aurulemacro %>");   
     parent.put(auctPrdMacro, "<%= auprdmacro %>");   
     parent.put(auctRuleType, "<%= auruletype %>");   
     parent.put(auctItem,"<%= product_id %>" );  
     parent.put(auctSKU,"<%= sku %>" );  
     parent.put(auctProdDesc, "<%= proddesc %>" );   
     parent.put(auctProdName, "<%= prodname %>" );   

     parent.put(auctBdrule, "<%= aubdrule %>");   
     parent.put(auctCur, "<%= aucur %>");   
     parent.put(auctPricing, "<%= pricing %>");   

     parent.put(auctMinbid, "<%= minbid_ds2 %>");   
     parent.put(auctMinbid_ds, "<%= minbid_ds2 %>");
     parent.put(auctDeposit, "<%= audeposit_ds2 %>");   
     parent.put(auctDeposit_ds, "<%= audeposit_ds2 %>");

     if ( "<%= autype %>" == "D" ) {
       parent.put(auctCurPrice, "<%= aucurprice_ds %>");
       parent.put(auctCurPrice_ds, "<%= aucurprice_ds %>");
     }
     else {
       parent.put(auctCurPrice, "<%= zeroPrice %>");   
       parent.put(auctCurPrice_ds, "<%= zeroPrice %>");
     }

     parent.put(auctDayDur, "<%= audaydur %>");   
     parent.put(auctTimDur, "<%= autimdur %>");   
     parent.put(auctHourDur, "<%= auhourdur %>");   
     parent.put(auctMinDur, "<%= aumindur %>");   
     
     parent.put(auctStDate, "<%= austdate %>");   
     parent.put(auctStTime, "<%= austtime %>");   
     parent.put(auctEndDate, "<%= auenddat %>");   
     parent.put(auctEndTime, "<%= auendtim %>");   

     //Convert date for display purpose
    if ( "<%= austdate %>" == "") {
      parent.put(auctStYear_ds, "");   
      parent.put(auctStMonth_ds, "");   
      parent.put(auctStDay_ds, "");   
    }
     else {
       parent.put(auctStYear_ds, "<%= styy %>");
       parent.put(auctStMonth_ds, "<%= stmm %>");
       parent.put(auctStDay_ds, "<%= stdd %>");

     }
     
     if ( "<%= auenddat %>" == "") {
      parent.put(auctEndYear_ds, "");   
      parent.put(auctEndMonth_ds, "");   
      parent.put(auctEndDay_ds, "");   
     }     
     else {
       parent.put(auctEndYear_ds, "<%= endyy %>");   
       parent.put(auctEndMonth_ds, "<%= endmm %>");   
       parent.put(auctEndDay_ds, "<%= enddd %>");   

     }
      
     //Convert time for display purpose
     if ( AMPMIndicator == "Yes") {   // 12 hour clock format

        temp = getTimeFormat("<%= sthh %>", "<%= stmin %>","<%= stss %>");
        delimiter = " ";
        aTime = temp.substring(0, temp.indexOf(delimiter));
        ampmIndicator = temp.substring(temp.lastIndexOf(delimiter) + 1);
        parent.put(auctStTime_ds, aTime);   
        parent.put(auctStAMPM, ampmIndicator);   

        temp = getTimeFormat("<%= endhh %>", "<%= endmin %>","<%= endss %>");
        delimiter = " ";
        aTime = temp.substring(0, temp.indexOf(delimiter));
        ampmIndicator = temp.substring(temp.lastIndexOf(delimiter) + 1);
        parent.put(auctEndTime_ds, aTime);   
        parent.put(auctEndAMPM, ampmIndicator);  

     }
     else {
        parent.put(auctStTime_ds,  "<%= start_time %>");   
        parent.put(auctEndTime_ds, "<%= end_time %>");   
     } 
     
     parent.put(auctEditable, "<%= editable %>"); 
     parent.put(auctShortDesc, "<%= UIUtil.toJavaScript(ausdesc) %>" );   
     parent.put(auctLongDesc, "<%=  UIUtil.toJavaScript(auldesc) %>" );   

   }  


   parent.put(auctQuantity_ds, document.ItemForm.quant.value);   
   
   
}  
function noenter() {
	return !(window.event && window.event.keyCode == 13); 
}

</SCRIPT>
</HEAD>

<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("AuctItem") %></h1>
 
   <FORM Name="ItemForm" >   
   
	<TABLE>
<%    if ( editable.equals("none") ) {  	
%>
	<TR>
	  <TD>
	    <%= auctionNLS.get("AuctionRefNum") %>:  <I><%= UIUtil.toHTML(auctid) %></I> <BR>
	  </TD>
	</TR>
	<TR>
	  <TD>

<%     if ( autype.equals("O") ) {
%>
          <%= auctionNLS.get("auctionType") %>:  <I><%= auctionNLS.get("opencry") %></I> <BR>
<%      } else if (  autype.equals("SB")  ) {
%>
          <%= auctionNLS.get("auctionType") %>:  <I><%= auctionNLS.get("sealedbid") %></I> <BR>
<%      } else if (  autype.equals("D")  ) {
%>
          <%= auctionNLS.get("auctionType") %>:   <I><%= auctionNLS.get("dutch") %></I><BR>
<%      } else {
%>   
          <%= auctionNLS.get("auctionType") %>:   <I><%= autype %></I><BR>
<%      }
%>
	  </TD>
	</TR>
	<TR>
	   <TD>
	    <%= auctionNLS.get("SKU") %>: <I><%= sku %></I> <BR>
	   </TD>
	</TR>
	<TR>
	   <TD>
	    <%= auctionNLS.get("ItemName") %>: <I><%= prodname %> </I><BR>
	   </TD>
	</TR>
	<TR>
	   <TD>
	    <%= auctionNLS.get("ItemDesc") %>: <I><%= proddesc %> </I><BR>
	   </TD>
	</TR>
	
        <TR> 
	<TD>
	   <%= auctionNLS.get("AuctionQuantity") %>: <I><%= quant_ds %></I> <BR>
	</TD>
	</TR>

<% } else {
%>	
	<TR>
	<TD>
	   <%= auctionNLS.get("AuctionRefNum") %>: <I><%= UIUtil.toHTML(auctid) %></I> <BR>
	</TD>
	</TR>
	<TR>
	<TD>

<%     if ( autype.equals("O") ) {
%>
          <%= auctionNLS.get("auctionType") %>:  <I><%= auctionNLS.get("opencry") %></I> <BR>
<%      } else if (  autype.equals("SB")  ) {
%>
          <%= auctionNLS.get("auctionType") %>:  <I><%= auctionNLS.get("sealedbid") %></I> <BR>
<%      } else if (  autype.equals("D")  ) {
%>
          <%= auctionNLS.get("auctionType") %>:   <I><%= auctionNLS.get("dutch") %></I><BR>
<%      } else {
%>   
          <%= auctionNLS.get("auctionType") %>:   <%= autype %><BR>
<%      }
%>
	</TD>
	</TR>

	<TR>
	  <TD>
	    <%= auctionNLS.get("SKU") %>: <I><%= sku %></I> <BR>
	  </TD>
	</TR>
	<TR>
	  <TD>
	    <%= auctionNLS.get("ItemName") %>: <I><%= prodname %></I> <BR>
	  </TD>
	</TR>
	<TR>
	  <TD>
	    <%= auctionNLS.get("ItemDesc") %>: <I><%= proddesc %></I> <BR>
	  </TD>
	</TR>

        <TR>
		<TD>

		       <LABEL>
			<%= auctionNLS.get("AuctionQuantity") %> <%= auctionNLS.get("mandatory") %><BR>
			<INPUT TYPE="text"
				NAME="quant"
				SIZE=17 
				MAXLENGTH="64"
				onkeypress="return noenter()"
				VALUE=<%= quant_ds %>>
			</LABEL>	
		</TD>
	</TR>
<% }
%>
</TABLE>

</FORM>
</BODY>

</HTML>

