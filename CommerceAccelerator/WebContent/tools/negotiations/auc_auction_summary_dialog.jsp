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
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.catalog.beans.*" %>
<%@  page import="com.ibm.commerce.beans.*"  %>
<%@  page import="com.ibm.commerce.command.*"  %>
<%@  page import="com.ibm.commerce.price.utils.*"  %>
<%@  page import="com.ibm.commerce.common.objects.*"  %>
<%@  page import="com.ibm.commerce.price.*"  %>
<%@  page import="java.util.*"  %>
<%@  page import="java.text.*"  %>
<%@  page import="java.math.*"  %>
<%@  page import="com.ibm.commerce.tools.test.*" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%
     String   emptyString = new String("");
     String   zeroPrice = "0";
     String   StoreId = "0";
     Integer  aLang = null;
     String   lang =  "1";  
     Locale   aLocale = null;
     String   locale = "en_US";
     FormattedMonetaryAmount fmt = null;
     BigDecimal   aPrice = null;

     //***Get lang id, locale and storeid from CommandContext
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
     //out.println("<BR>Default Currency is " + defaultCurrency);


     String auctid = request.getParameter("auctionId"); 
    //out.println("<BR>auctionId received is: " + auctid );

     // obtain the resource bundle for display
     Hashtable auctionNLS = (Hashtable)ResourceDirectory.lookup("negotiations.negotiationsNLS",aLocale);

%>
<jsp:useBean id="auction" class="com.ibm.commerce.negotiation.beans.AuctionInfoDataBean" >
<jsp:setProperty property="auctionId" name="auction" value="<%= auctid %>" />
<jsp:setProperty property="auctStoreId" name="auction" value="<%= StoreId %>" />
</jsp:useBean>


<%
    com.ibm.commerce.beans.DataBeanManager.activate(auction, request);
%>
<%
  String  ownerid = auction.getOwnerId();  
  String  austatus= auction.getStatus();
  String  autype= auction.getAuctionType();
  
  String  quant_ds = auction.getQuantity();
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

  //format prices
  String  minbid= auction.getReservePrice();
  String  formatted_minbid = "";
  if ( !minbid.equals(emptyString) ) {
     aPrice = new BigDecimal(minbid);
     fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
     formatted_minbid = fmt.toString();
  }
  
  String  aucurprice= auction.getCurrentPrice();
  String  formatted_aucurprice = "";
  if ( !aucurprice.equals(emptyString) ) {
     aPrice = new BigDecimal(aucurprice);
     fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
     formatted_aucurprice = fmt.toString();
  }

    
  String  audeposit = auction.getDeposit();
  String  formatted_audeposit = "";
  if ( !audeposit.equals(emptyString) ) {
     aPrice = new BigDecimal(audeposit);
     fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(aPrice, aucur), storeAB, aLang); 
     formatted_audeposit = fmt.toString();
  }

  String  pricing = auction.getClosePriceRule(); 
  
  DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT, aLocale);
  DateFormat df2= DateFormat.getTimeInstance(DateFormat.SHORT, aLocale);

  String  austdate= df.format(auction.getStartTimeInEntityType());
  String  austtime = auction.getAuctStartTime();

  String  auenddat = "";
  String  auendtim = ""; 

  if (auction.getEndTimeInEntityType() != null ) {
    auenddat= df.format(auction.getEndTimeInEntityType());
    auendtim= auction.getAuctEndTime();
  }

//actual end date
  String acenddat = "";
  String acendtim = "";

//get the actual end time

  if (auction.getRealEndTimeInEntityType() != null ) {
	acenddat= df.format(auction.getRealEndTimeInEntityType());
	acendtim= auction.getAuctRealEndTime();
   } 


  String  autimdur= auction.getAuctDurationTime();
  String  audaydur= auction.getDurationDays();
  String  hours = auction.getAuctDurationHour();
  int     auhourdur;
  int     aumindur;
  if ( !hours.equals(emptyString) ) 
     auhourdur = Integer.parseInt(hours);
  else
     auhourdur = 0;  
  String  minutes  = auction.getAuctDurationMinute();    
  if ( !minutes.equals(emptyString) ) 
     aumindur = Integer.parseInt(minutes);
  else
     aumindur = 0;


  String  aurulemacro= auction.getRulePage();
  String  auprdmacro= auction.getItemPage();
  String  aubdrule= auction.getBidRuleId();
  String  rulename = "";

  Integer id = Integer.valueOf(lang);
  String  ausdesc = auction.getShortDescription(id);
  if (ausdesc == null)
    ausdesc = ""; 
  String  auldesc = auction.getLongDescription(id);
  if (auldesc == null)
    auldesc = ""; 
  String  product_id = auction.getEntryId();
  String  proddesc = "";
  String  prodname = "";
  String  sku = "";

  String  austAMPM = "AM";
  String  auendAMPM = "PM";
%>

<jsp:useBean id="OCBidRule" class="com.ibm.commerce.negotiation.beans.OpenCryBidControlRuleDataBean" >
<jsp:setProperty property="*" name="OCBidRule" />
<jsp:setProperty property="id" name="OCBidRule" value="<%= aubdrule %>" />
</jsp:useBean>

<jsp:useBean id="SBBidRule" class="com.ibm.commerce.negotiation.beans.SealedBidControlRuleDataBean" >
<jsp:setProperty property="*" name="SBBidRule" />
<jsp:setProperty property="id" name="SBBidRule" value="<%= aubdrule %>" />
</jsp:useBean>

<%        //Get control rule name
    if ( autype.equals("O") && !aubdrule.equals(emptyString) ) {    
        com.ibm.commerce.beans.DataBeanManager.activate(OCBidRule, request);
        rulename = OCBidRule.getRuleName();
    } else  if ( autype.equals("SB") && !aubdrule.equals(emptyString) ) {
        com.ibm.commerce.beans.DataBeanManager.activate(SBBidRule, request);
        rulename = SBBidRule.getRuleName();

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
        Integer lid = new Integer(Integer.parseInt(lang));
        proddesc = item.getDescription(lid).getShortDescription();
        if (proddesc == null)
          proddesc = "";
        prodname = item.getDescription(lid).getName();
        if ( prodname == null)
           prodname = "";
      }
     catch( Exception e ) {  }    
      
%>   


<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>">


<SCRIPT SRC="/wcs/javascript/tools/negotiations/auc_common.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<SCRIPT>

function initializeState()
{
   
   
   parent.setContentFrameLoaded(true);
  
}

function savePanelData() {

   return true;     
   
}  

</SCRIPT>
</HEAD>
<BODY class=content ONLOAD="initializeState();">
<BR><h1><%= auctionNLS.get("SummaryDialog") %></h1>


   <FORM Name="SummaryForm" >   
   
	<TABLE> 

	<TR>
	  <TD >
	    <%= auctionNLS.get("AuctionRefNum") %>: <I><%= UIUtil.toHTML(auctid) %></I> <BR>
	  </TD>
	</TR>
	<TR>
<%      if ( autype.equals("D") ) {
%>	  
	  <TD>
	    <%= auctionNLS.get("auctionType") %>: <I><%= auctionNLS.get("dutch") %></I> <BR>
	  </TD>
<%      } else if ( autype.equals("O") ) {
%>
	  <TD>
	    <%= auctionNLS.get("auctionType") %>: <I><%= auctionNLS.get("opencry") %></I> <BR>
	  </TD>
<%      } else if ( autype.equals("SB") ) {
%>
	  <TD>
	    <%= auctionNLS.get("auctionType") %>: <I><%= auctionNLS.get("sealedbid") %></I> <BR>
	  </TD>
<%      }
%>
        </TR>


        <TR>
<%      if ( austatus.equals("C") ) {
%>	  
	  <TD>
	    <%= auctionNLS.get("AuctionStatus") %>: <I><%= auctionNLS.get("currentStatus") %></I> <BR>
	  </TD>
<%      } else if ( austatus.equals("F") ) {
%>
	  <TD>
	    <%= auctionNLS.get("AuctionStatus") %>: <I><%= auctionNLS.get("futureStatus") %></I> <BR>
	  </TD>
<%      } else if ( austatus.equals("R") ) {
%>
	  <TD>
	    <%= auctionNLS.get("AuctionStatus") %>: <I><%= auctionNLS.get("retractedStatus") %></I> <BR>
	  </TD>
<%      } else if ( austatus.equals("BC") ) {
%>
	  <TD>
	    <%= auctionNLS.get("AuctionStatus") %>: <I><%= auctionNLS.get("biddingClosedStatus") %></I> <BR>
	  </TD>
<%      } else if ( austatus.equals("SC") ) {
%>
	  <TD>
	    <%= auctionNLS.get("AuctionStatus") %>: <I><%= auctionNLS.get("settlementClosedStatus") %></I> <BR>
	  </TD>
<%      }
%>
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

	<TR    >
	  <TD>
	    <%= auctionNLS.get("auctionViewRule") %>:  <I><%= aurulemacro %></I> <BR>
	  </TD>
	</TR>
	<TR    >
	  <TD> 
	    <%= auctionNLS.get("auctionViewProd") %>: <I><%= auprdmacro %></I> <BR>
	  </TD>
	</TR>
	
<%   if ( autype.equals("D") ) { 
%>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("OfferedPrice") %>: <I><%= formatted_aucurprice %></I> <BR>
	  </TD>
	</TR>

<%   } else {
        if ( !aubdrule.equals(emptyString) ) {  
%>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("bidControlRuleName") %>: <I><%= rulename %></I> <BR>
	  </TD>
	</TR>

<%      } else {
%>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("bidControlRuleName") %>: <I><%= auctionNLS.get("none") %></I>  <BR>
	  </TD>
	</TR>
<%     }
    }
%> 
	<TR    >
	  <TD>
	    <%= auctionNLS.get("Currency") %>:  <I><%= aucur %></I> <BR>
	  </TD>
	</TR>

<%   if ( autype.equals("D") ) { 
%>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("AuctionQuantity") %>: <I><%= quant_ds %></I> <BR>
	  </TD>
	</TR>

<%   } else {
%>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("AuctionQuantity") %>: <I><%= quant_ds %></I> <BR>
	  </TD>
	</TR>
	<TR    >
	  <TD>
	    <%= auctionNLS.get("ReservePrice") %>:  <I><%= formatted_minbid %></I> <BR>
	  </TD>
	</TR>
	
	<TR    >
	  <TD>
	    <%= auctionNLS.get("Deposit") %>:  <I><%= formatted_audeposit %></I> <BR>
	  </TD>
	</TR>
<%   }
%>

  <TR>
	 <TD>
	   <%= auctionNLS.get("AuctionStartDate") %> <I><%= austdate %>&nbsp;<%= austtime %>&nbsp;</I>
	  <BR>
       </TD>
  </TR>
  <TR >
	<TD >
	    <%= auctionNLS.get("AuctionEndDate") %>  <I><%= auenddat %>&nbsp;<%= auendtim %>&nbsp;</I>
	  <BR>
	</TD>
  </TR>
<TR>
<TD>
<%= auctionNLS.get("AuctionRealEndDate") %>  <I><%= acenddat %>&nbsp;<%= acendtim %>&nbsp;</I>
<BR>
</TD>

</TR>

<%   if ( !autype.equals("D") ) {
%>
        <TR    >
        <TD  ALIGN=center > 
<%     if ( auruletype.equals("4") ) {
%>
	  <%= auctionNLS.get("And") %><BR>
<%     }  else if ( auruletype.equals("3") || auruletype.equals("2")) { 
%> 
	  <%= auctionNLS.get("Or") %><BR>
<%     }
%>	 
	</TD>
      </TR>
<%     if ( !auruletype.equals("1") ) {
%>
        <TR    >
	<TD  >
	 <%= auctionNLS.get("StyleDurationPrefix") %>&nbsp;
	   <%= audaydur %>&nbsp;
	 <%= auctionNLS.get("days") %>&nbsp;
	   <%= auhourdur %>&nbsp;
	 <%= auctionNLS.get("hours") %>&nbsp; 
	   <%= aumindur %>&nbsp;
	 <%= auctionNLS.get("minutes") %>&nbsp; 
	 <%= auctionNLS.get("StyleDurationSuffix") %>
        </TD>
        </TR>
<% } }
%> 

	<TR>
	  <TD>
	    <%= auctionNLS.get("AuctionShortDesc") %>:  <I><%=UIUtil.toHTML(ausdesc)%></I> <BR>
	  </TD>
	</TR>
	

</TABLE>

</FORM>
</BODY>

</HTML>
